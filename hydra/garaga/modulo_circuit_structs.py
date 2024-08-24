from __future__ import annotations

from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Generic, TypeVar

from garaga.algebra import FunctionFelt, ModuloCircuitElement, PyFelt
from garaga.definitions import STARK, G1Point, G2Point, get_base_field
from garaga.hints import io
from garaga.hints.io import int_array_to_u384_array, int_to_u256, int_to_u384

T = TypeVar("T", bound="Cairo1SerializableStruct")

from enum import Enum


class CairoOption(Enum):
    SOME = 0
    NONE = 1


@dataclass(slots=True)
class Cairo1SerializableStruct(ABC):
    name: str
    elmts: list[ModuloCircuitElement | PyFelt | "Cairo1SerializableStruct"]

    def __post_init__(self):
        assert type(self.name) == str
        if isinstance(self.elmts, (list, tuple)):
            if len(self.elmts) > 0:
                if isinstance(self.elmts[0], Cairo1SerializableStruct):
                    assert all(
                        isinstance(elmt, self.elmts[0].__class__) for elmt in self.elmts
                    ), f"All elements of {self.name} must be of the same type"

                else:
                    assert all(
                        isinstance(elmt, (ModuloCircuitElement, PyFelt))
                        for elmt in self.elmts
                    ), f"All elements of {self.name} must be of type ModuloCircuitElement or PyFelt, got {type(self.elmts[0])}"
        else:
            assert self.elmts is None, f"Elmts must be a list or None, got {self.elmts}"

    @property
    def struct_name(self) -> str:
        return self.__class__.__name__

    def serialize_input_signature(self) -> str:
        return f"{self.name}:{self.struct_name}"

    @abstractmethod
    def serialize(self, raw: bool = False) -> str:
        pass

    @abstractmethod
    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        pass

    @abstractmethod
    def dump_to_circuit_input(self) -> str:
        pass

    @abstractmethod
    def __len__(self) -> int:
        pass

    def _serialize_to_calldata(self) -> list[int]:
        pass

    def serialize_to_calldata(self, *args, **kwargs) -> list[int]:
        data = self._serialize_to_calldata(*args, **kwargs)
        # print(
        #     f"\nSerializing {self.name} {self.struct_name} to calldata: {data} {len(data)}"
        # )
        return data


class StructArray(Cairo1SerializableStruct, Generic[T]):
    elmts: list[T]

    @property
    def struct_name(self) -> str:
        return "Array<" + self.elmts[0].struct_name + ">"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for struct in self.elmts:
            code += struct.dump_to_circuit_input()
        return code

    def __len__(self) -> int:
        return sum(len(struct) for struct in self.elmts)

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        raise NotImplementedError

    def serialize(self, raw: bool = False, const: bool = False) -> str:
        if const:
            raw_struct = "["
        else:
            raw_struct = "array!["

        for struct in self.elmts:
            raw_struct += struct.serialize(raw=True) + ","
        raw_struct += "]\n"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.struct_name} = {raw_struct};\n"


class Struct(Cairo1SerializableStruct):
    elmts: list[Cairo1SerializableStruct]

    def __init__(
        self, struct_name: str, name: str, elmts: list[Cairo1SerializableStruct]
    ):
        super().__init__(name, elmts)
        self._struct_name = struct_name

    @property
    def struct_name(self) -> str:
        return self._struct_name

    def __post_init__(self):
        assert all(isinstance(elmt, Cairo1SerializableStruct) for elmt in self.elmts)

    def dump_to_circuit_input(self) -> str:
        return NotImplementedError

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        raise NotImplementedError

    def serialize(self, raw: bool = False) -> str:
        if raw:
            code = f"{self.struct_name} {{"
        else:
            code = f"let {self.name} = {self.struct_name} {{"
        for struct in self.elmts:
            code += f"{struct.name}: {struct.serialize(raw=True)},"
        if raw:
            code += "}"
        else:
            code += "};"
        return code

    def __len__(self) -> int:
        return sum(len(elmt) for elmt in self.elmts)

    def _serialize_to_calldata(self) -> list[int]:
        cd = []
        for elmt in self.elmts:
            cd.extend(elmt.serialize_to_calldata())
        return cd


class StructSpan(Cairo1SerializableStruct, Generic[T]):
    elmts: list[T]

    @property
    def struct_name(self) -> str:
        return "Span<" + self.elmts[0].struct_name + ">"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for struct in self.elmts:
            code += struct.dump_to_circuit_input()
        return code

    def __len__(self) -> int:
        return sum(len(struct) for struct in self.elmts)

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        raise NotImplementedError

    def serialize(self, raw: bool = False, is_option: bool = False) -> str:
        if self.elmts is None:
            raw_struct = "Option::None"
            if raw:
                return raw_struct
            else:
                return f"let {self.name} = {raw_struct};\n"
        else:
            raw_struct = "array!["
            for struct in self.elmts:
                raw_struct += struct.serialize(raw=True) + ","
            raw_struct += "].span()"
            if is_option:
                raw_struct = f"Option::Some({raw_struct})"
            if raw:
                return raw_struct
            else:
                return f"let {self.name} = {raw_struct};\n"

    def _serialize_to_calldata(self, option: CairoOption = None) -> list[int]:
        cd = []
        if option:
            if option == CairoOption.SOME:
                cd.append(0)
            elif option == CairoOption.NONE:
                cd.append(1)
                return cd
            else:
                raise ValueError(f"Invalid option: {option}")

        cd.append(len(self.elmts))
        for elmt in self.elmts:
            cd.extend(elmt._serialize_to_calldata())
        return cd


class u384(Cairo1SerializableStruct):
    def serialize(self, raw: bool = False) -> str:
        assert len(self.elmts) == 1
        raw_struct = f"{int_to_u384(self.elmts[0].value)}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.struct_name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        assert len(self.elmts) == 1
        return io.bigint_split_array(self.elmts, prepend_length=False)

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 1
        return f"let {self.name}:{self.struct_name} = outputs.get_output({offset_to_reference_map[self.elmts[0].offset]});"

    def dump_to_circuit_input(self) -> str:
        return f"circuit_inputs = circuit_inputs.next_2({self.name});\n"

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 1
            return 1
        else:
            return 1


class u256(Cairo1SerializableStruct):
    def serialize(self, raw: bool = False) -> str:
        assert len(self.elmts) == 1
        raw_struct = f"{int_to_u256(self.elmts[0].value)}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.struct_name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        assert len(self.elmts) == 1
        return list(io.split_128(self.elmts[0].value))

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        raise NotImplementedError

    def dump_to_circuit_input(self) -> str:
        raise NotImplementedError

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 1
            return 1
        else:
            return 1


class Tuple(Cairo1SerializableStruct):
    elmts: list[Cairo1SerializableStruct]

    def __init__(self, name: str, elmts: list[Cairo1SerializableStruct]):
        super().__init__(name, elmts)
        self.members_names = [member.name for member in elmts]

    @property
    def struct_name(self) -> str:
        return f"({','.join([elmt.struct_name for elmt in self.elmts])})"

    def serialize(self, raw: bool = False) -> str:
        assert len(self.elmts) > 0
        raw_struct = f"({','.join([elmt.serialize(raw=True) for elmt in self.elmts])})"
        if raw:
            return raw_struct
        else:
            return f"let ({','.join([elmt.name for elmt in self.elmts])}):{self.struct_name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        cd = []
        for elmt in self.elmts:
            cd.extend(elmt._serialize_to_calldata())
        return cd

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        raise NotImplementedError

    def dump_to_circuit_input(self) -> str:
        raise NotImplementedError

    def __len__(self) -> int:
        return sum(len(elmt) for elmt in self.elmts)


class felt252(Cairo1SerializableStruct):
    def serialize(self, raw: bool = False) -> str:
        assert len(self.elmts) == 1
        raw_struct = f"{hex(self.elmts[0].value)}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.struct_name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        assert len(self.elmts) == 1
        return [self.elmts[0].value % STARK]

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        raise NotImplementedError

    def dump_to_circuit_input(self) -> str:
        raise NotImplementedError

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 1
            return 1
        else:
            return 1


class u384Array(Cairo1SerializableStruct):
    def serialize(self, raw: bool = False) -> str:
        raw_struct = f"{int_array_to_u384_array(self.elmts)}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.struct_name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        return io.bigint_split_array(self.elmts, prepend_length=True)

    @property
    def struct_name(self) -> str:
        return "Array<u384>"

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 1
        return f"let {self.name}:{self.struct_name} = array![{','.join([f'outputs.get_output({offset_to_reference_map[elmt.offset]})' for elmt in self.elmts])}];"

    def dump_to_circuit_input(self) -> str:
        code = f"""
    let mut {self.name} = {self.name};
    while let Option::Some(val) = {self.name}.pop_front() {{
        circuit_inputs = circuit_inputs.next_2(val);
    }};
    """
        return code

    def __len__(self) -> int:
        if self.elmts is not None:
            return len(self.elmts)
        else:
            return None


class FunctionFeltCircuit(Cairo1SerializableStruct):
    def __init__(self, name: str, elmts: list[u384Span]):
        super().__init__(name, elmts)
        self.members_names = ("a_num", "a_den", "b_num", "b_den")

    @property
    def a_num(self) -> list[ModuloCircuitElement | PyFelt]:
        return self.elmts[0].elmts

    @property
    def a_den(self) -> list[ModuloCircuitElement | PyFelt]:
        return self.elmts[1].elmts

    @property
    def b_num(self) -> list[ModuloCircuitElement | PyFelt]:
        return self.elmts[2].elmts

    @property
    def b_den(self) -> list[ModuloCircuitElement | PyFelt]:
        return self.elmts[3].elmts

    @property
    def struct_name(self) -> str:
        return "FunctionFelt"

    @staticmethod
    def from_FunctionFelt(
        name: str, f: FunctionFelt, msm_size: int
    ) -> "FunctionFeltCircuit":
        _a_num, _a_den, _b_num, _b_den = io.padd_function_felt(
            f, msm_size, py_felt=True
        )
        return FunctionFeltCircuit(
            name=name,
            elmts=[
                u384Span("a_num", _a_num),
                u384Span("a_den", _a_den),
                u384Span("b_num", _b_num),
                u384Span("b_den", _b_den),
            ],
        )

    def _serialize_to_calldata(self) -> list[int]:
        cd = []
        assert len(self.elmts) == 4
        for elmt in self.elmts:
            cd.extend(elmt._serialize_to_calldata())
        return cd

    def serialize(self, raw: bool = False) -> str:
        raw_struct = f"{self.struct_name} {{ {','.join([f'{self.members_names[i]}: {self.elmts[i].serialize(raw=True)}' for i in range(4)])} }}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.struct_name} = {raw_struct};\n"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"""let mut {self.name}_{mem_name} = {self.name}.{mem_name};
            while let Option::Some(val) = {self.name}_{mem_name}.pop_front() {{
                circuit_inputs = circuit_inputs.next_2(*val);
            }};
            """
        return code

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{ {','.join([f'{self.members_names[i]}: {self.elmts[i].extract_from_circuit_output(offset_to_reference_map)}' for i in range(4)])} }};"

    def __len__(self) -> int:
        return sum(len(elmt) for elmt in self.elmts)


class u384Span(Cairo1SerializableStruct):
    def serialize(self, raw: bool = False) -> str:
        raw_struct = f"{int_array_to_u384_array(self.elmts)}.span()"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.struct_name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        return io.bigint_split_array(self.elmts, prepend_length=True)

    @property
    def struct_name(self) -> str:
        return "Span<u384>"

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 1
        return f"let {self.name}:{self.struct_name} = array![{','.join([f'outputs.get_output({offset_to_reference_map[elmt.offset]})' for elmt in self.elmts])}].span();"

    def dump_to_circuit_input(self) -> str:
        code = f"""let mut {self.name} = {self.name};
    while let Option::Some(val) = {self.name}.pop_front() {{
        circuit_inputs = circuit_inputs.next_2(*val);
    }};
    """
        return code

    def __len__(self) -> int:
        if self.elmts is not None:
            return len(self.elmts)
        else:
            return None


class BLSProcessedPair(Cairo1SerializableStruct):
    def __init__(self, name: str, elmts: list[ModuloCircuitElement]):
        super().__init__(name, elmts)
        self.members_names = ("yInv", "xNegOverY")

    @property
    def struct_name(self) -> str:
        return "BLSProcessedPair"

    def serialize(self) -> str:
        assert len(self.elmts) == 2
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{yInv: {int_to_u384(self.elmts[0].value)}, xNegOverY: {int_to_u384(self.elmts[1].value)}}};"

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 2
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{ {','.join([f'{self.members_names[i]}: outputs.get_output({offset_to_reference_map[self.elmts[i].offset]})' for i in range(2)])} }};"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"circuit_inputs = circuit_inputs.next_2({self.name}.{mem_name});\n"
        return code

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 2
            return 2
        else:
            return 2


class BNProcessedPair(Cairo1SerializableStruct):
    def __init__(self, name: str, elmts: list[ModuloCircuitElement]):
        super().__init__(name, elmts)
        self.members_names = ("yInv", "xNegOverY", "QyNeg0", "QyNeg1")

    @property
    def struct_name(self) -> str:
        return "BNProcessedPair"

    def serialize(self) -> str:
        assert len(self.elmts) == 4
        members = ", ".join(
            [
                f"{name}: {int_to_u384(self.elmts[i].value)}"
                for i, name in enumerate(self.members_names)
            ]
        )
        return (
            f"let {self.name}:{self.struct_name} = {self.struct_name} {{{members}}};\n"
        )

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 4
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{ {','.join([f'{self.members_names[i]}: outputs.get_output({offset_to_reference_map[self.elmts[i].offset]})' for i in range(4)])} }};"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"circuit_inputs = circuit_inputs.next_2({self.name}.{mem_name});\n"
        return code

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 4
            return 4
        else:
            return 4


class G1PointCircuit(Cairo1SerializableStruct):
    def __init__(self, name: str, elmts: list[ModuloCircuitElement]):
        super().__init__(name, elmts)
        self.members_names = ("x", "y")

    @staticmethod
    def from_G1Point(name: str, point: G1Point) -> "G1PointCircuit":
        field = get_base_field(point.curve_id)
        return G1PointCircuit(name=name, elmts=[field(point.x), field(point.y)])

    @property
    def struct_name(self) -> str:
        return "G1Point"

    def serialize(self, raw: bool = False) -> str:
        assert len(self.elmts) == 2
        raw_struct = f"{self.struct_name} {{x: {int_to_u384(self.elmts[0].value)}, y: {int_to_u384(self.elmts[1].value)}}}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.struct_name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        return io.bigint_split_array(self.elmts, prepend_length=False)

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 2
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{ {','.join([f'{self.members_names[i]}: outputs.get_output({offset_to_reference_map[self.elmts[i].offset]})' for i in range(2)])} }};"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"circuit_inputs = circuit_inputs.next_2({self.name}.{mem_name});\n"
        return code

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 2
            return 2
        else:
            return 2


class G2PointCircuit(Cairo1SerializableStruct):
    def __init__(self, name: str, elmts: list[ModuloCircuitElement]):
        super().__init__(name, elmts)
        self.members_names = ("x0", "x1", "y0", "y1")

    @staticmethod
    def from_G2Point(name: str, point: G2Point) -> "G2PointCircuit":
        field = get_base_field(point.curve_id)
        return G2PointCircuit(
            name=name,
            elmts=[
                field(point.x[0]),
                field(point.x[1]),
                field(point.y[0]),
                field(point.y[1]),
            ],
        )

    @property
    def struct_name(self) -> str:
        return "G2Point"

    def serialize(self, raw: bool = False) -> str:
        assert len(self.elmts) == 4
        raw_struct = f"{self.struct_name} {{x0: {int_to_u384(self.elmts[0].value)}, x1: {int_to_u384(self.elmts[1].value)}, y0: {int_to_u384(self.elmts[2].value)}, y1: {int_to_u384(self.elmts[3].value)}}}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.struct_name} = {raw_struct};\n"

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 4
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{ {','.join([f'{self.members_names[i]}: outputs.get_output({offset_to_reference_map[self.elmts[i].offset]})' for i in range(4)])} }};"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"circuit_inputs = circuit_inputs.next_2({self.name}.{mem_name});\n"
        return code

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 4
            return 4
        else:
            return 4


class G2Line(Cairo1SerializableStruct):
    def __init__(self, name: str, elmts: list[ModuloCircuitElement]):
        super().__init__(name, elmts)
        self.members_names = ("r0a0", "r0a1", "r1a0", "r1a1")

    def serialize(self, raw: bool = False) -> str:
        assert len(self.elmts) == 4
        raw_struct = f"{self.struct_name} {{r0a0: {int_to_u384(self.elmts[0].value)}, r0a1: {int_to_u384(self.elmts[1].value)}, r1a0: {int_to_u384(self.elmts[2].value)}, r1a1: {int_to_u384(self.elmts[3].value)}}}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.struct_name} = {raw_struct};\n"

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 4
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{ {','.join([f'{self.members_names[i]}: outputs.get_output({offset_to_reference_map[self.elmts[i].offset]})' for i in range(4)])} }};"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"circuit_inputs = circuit_inputs.next_2({self.name}.{mem_name});\n"
        return code

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 4
            return 4
        else:
            return 4


class FunctionFeltEvaluations(Cairo1SerializableStruct):
    def __init__(self, name: str, elmts: list[ModuloCircuitElement]):
        super().__init__(name, elmts)
        self.members_names = ("a_num", "a_den", "b_num", "b_den")

    def serialize(self) -> str:
        assert len(self.elmts) == 4
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{a_num: {int_to_u384(self.elmts[0].value)}, a_den: {int_to_u384(self.elmts[1].value)}, b_num: {int_to_u384(self.elmts[2].value)}, b_den: {int_to_u384(self.elmts[3].value)}}};\n"

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 4
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{ {','.join([f'{self.members_names[i]}: outputs.get_output({offset_to_reference_map[self.elmts[i].offset]})' for i in range(4)])} }};"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"circuit_inputs = circuit_inputs.next_2({self.name}.{mem_name});\n"
        return code

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 4
            return 4
        else:
            return 4


class G1G2PairCircuit(Cairo1SerializableStruct):
    def __init__(self, name: str, elmts: list[ModuloCircuitElement]):
        super().__init__(name, elmts)
        self.members_names = ("p.x", "p.y", "q.x0", "q.x1", "q.y0", "q.y1")

    @property
    def struct_name(self) -> str:
        return "G1G2Pair"

    def serialize(self) -> str:
        return (
            f"let {self.name}:{self.struct_name} = {self.struct_name} {{"
            f"p: G1Point{{ x:{int_to_u384(self.elmts[0].value)}, y: {int_to_u384(self.elmts[1].value)}}}, "
            f"q: G2Point{{ x0:{int_to_u384(self.elmts[2].value)}, x1: {int_to_u384(self.elmts[3].value)}, y0: {int_to_u384(self.elmts[4].value)}, y1: {int_to_u384(self.elmts[5].value)}}}}};\n"
        )

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 6
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{ {','.join([f'{self.members_names[i]}: outputs.get_output({offset_to_reference_map[self.elmts[i].offset]})' for i in range(6)])} }};"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"circuit_inputs = circuit_inputs.next_2({self.name}.{mem_name});\n"
        return code

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 6
            return 6
        else:
            return 6


class E12D(Cairo1SerializableStruct):
    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 12
        code = (
            f"let {self.name}:{self.__class__.__name__} = {self.__class__.__name__}{{\n"
        )
        for i, elmt in enumerate(self.elmts):
            code += (
                f"w{i}:outputs.get_output({offset_to_reference_map[elmt.offset]}),\n"
            )
        code += "};"
        return code

    def serialize(self, raw: bool = False, is_option: bool = False) -> str:
        if self.elmts is None:
            raw_struct = "Option::None"
            if raw:
                return raw_struct
            else:
                return f"let {self.name}:Option<{self.__class__.__name__}> = {raw_struct};\n"
        else:
            assert len(self.elmts) == 12
            raw_struct = f"{self.__class__.__name__}{{{','.join([f'w{i}: {int_to_u384(self.elmts[i].value)}' for i in range(len(self))])}}}"
            if is_option:
                raw_struct = f"Option::Some({raw_struct})"
            if raw:
                return raw_struct
            else:
                return f"let {self.name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        return io.bigint_split_array(self.elmts, prepend_length=False)

    def dump_to_circuit_input(self) -> str:
        code = ""
        for i in range(len(self)):
            code += f"circuit_inputs = circuit_inputs.next_2({self.name}.w{i});\n"
        return code

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 12
            return 12
        else:
            return 12


class E12DMulQuotient(Cairo1SerializableStruct):
    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 11
        code = (
            f"let {self.name}:{self.__class__.__name__} = {self.__class__.__name__}{{\n"
        )
        for i, elmt in enumerate(self.elmts):
            code += (
                f"w{i}:outputs.get_output({offset_to_reference_map[elmt.offset]}),\n"
            )
        code += "};"
        return code

    def serialize(self, raw: bool = False, is_option: bool = False) -> str:
        if self.elmts is None:
            raw_struct = "Option::None"
            if raw:
                return raw_struct
            else:
                return f"let {self.name}:Option<{self.__class__.__name__}> = {raw_struct};\n"
        else:
            assert len(self.elmts) == 11, f"Expected 11 elements, got {len(self.elmts)}"
            raw_struct = f"{self.__class__.__name__}{{{','.join([f'w{i}: {int_to_u384(self.elmts[i].value)}' for i in range(len(self))])}}}"
            if is_option:
                raw_struct = f"Option::Some({raw_struct})"
            if raw:
                return raw_struct
            else:
                return f"let {self.name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        return io.bigint_split_array(self.elmts, prepend_length=False)

    def dump_to_circuit_input(self) -> str:
        code = ""
        for i in range(len(self)):
            code += f"circuit_inputs = circuit_inputs.next_2({self.name}.w{i});\n"
        return code

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 11
            return 11
        else:
            return 11


class MillerLoopResultScalingFactor(Cairo1SerializableStruct):
    def __init__(self, name: str, elmts: list[ModuloCircuitElement]):
        super().__init__(name, elmts)
        self.members_names = ("w0", "w2", "w4", "w6", "w8", "w10")

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        raise NotImplementedError("Never used in practice")

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"circuit_inputs = circuit_inputs.next_2({self.name}.{mem_name});\n"
        return code

    def serialize(self, raw: bool = False) -> str:
        assert len(self.elmts) == 6
        raw_struct = f"{self.__class__.__name__}{{{','.join([f'{self.members_names[i]}: {int_to_u384(self.elmts[i].value)}' for i in range(len(self))])}}}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.__class__.__name__} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        return io.bigint_split_array(self.elmts, prepend_length=False)

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 6
            return 6
        else:
            return 6


class SlopeInterceptOutput(Cairo1SerializableStruct):
    def __init__(self, name: str, elmts: list[ModuloCircuitElement]):
        super().__init__(name, elmts)
        self.members_names = ("m_A0", "b_A0", "x_A2", "y_A2", "coeff0", "coeff2")

    def serialize(self, raw: bool = False) -> str:
        assert len(self.elmts) == 6
        raw_struct = f"{self.__class__.__name__}{{{','.join([f'{self.members_names[i]}: {int_to_u384(self.elmts[i].value)}' for i in range(len(self))])}}}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.__class__.__name__} = {raw_struct};\n"

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 6
        code = (
            f"let {self.name}:{self.__class__.__name__} = {self.__class__.__name__}{{\n"
        )
        for mem_name, elmt in zip(self.members_names, self.elmts):
            code += f"{mem_name}: outputs.get_output({offset_to_reference_map[elmt.offset]}),\n"
        code += "};"
        return code

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"circuit_inputs = circuit_inputs.next_2({self.name}.{mem_name});\n"
        return code

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 6
            return 6
        else:
            return 6
