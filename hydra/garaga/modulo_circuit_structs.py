from __future__ import annotations

from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Generic, TypeVar

from garaga.algebra import FunctionFelt, ModuloCircuitElement, PyFelt
from garaga.definitions import STARK, G1Point, G2Point, get_base_field
from garaga.hints import io
from garaga.hints.io import (
    int_array_to_u384_array,
    int_to_u2XX,
    int_to_u256,
    int_to_u384,
)

T = TypeVar("T", bound="Cairo1SerializableStruct")

from enum import Enum


class CairoOption(Enum):
    SOME = 0
    NONE = 1
    VOID = 2  # Special case to serialize nothing at all.


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

    @property
    def bits(self) -> int:
        return self.elmts[0].p.bit_length()

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

    def serialize_to_calldata(self) -> list[int]:
        cd = [len(self)]
        for elmt in self.elmts:
            cd.extend(elmt.serialize_to_calldata())
        return cd


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
        code = f"let mut {self.name} = {self.name};\n"
        code += f"for val in {self.name} {{\n"

        self.elmts[0].name = "*val"
        code += self.elmts[0].dump_to_circuit_input()
        code += "};\n"
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

    def _serialize_to_calldata(
        self, option: CairoOption = None, as_pure_felt252_array: bool = False
    ) -> list[int]:
        cd = []
        if option:
            if option == CairoOption.SOME:
                cd.append(0)
            elif option == CairoOption.NONE:
                cd.append(1)
                return cd
            elif option == CairoOption.VOID:
                return cd
            else:
                raise ValueError(f"Invalid option: {option}")

        cd.append(len(self.elmts))
        for elmt in self.elmts:
            cd.extend(elmt._serialize_to_calldata())

        if as_pure_felt252_array:
            cd[0] = len(cd) - 1
        return cd


# class u288(Cairo1SerializableStruct):
#     def serialize(self, raw: bool = False) -> str:
#         assert len(self.elmts) == 1
#         raw_struct = f"{int_to_u288(self.elmts[0].value)}"
#         if raw:
#             return raw_struct
#         else:
#             return f"let {self.name}:{self.struct_name} = {raw_struct};\n"

#     def _serialize_to_calldata(self) -> list[int]:
#         assert len(self.elmts) == 1
#         return io.bigint_split_array(self.elmts, n_limbs=3, prepend_length=False)

#     def extract_from_circuit_output(
#         self, offset_to_reference_map: dict[int, str]
#     ) -> str:
#         assert len(self.elmts) == 1
#         return f"let {self.name}:{self.struct_name} = outputs.get_output({offset_to_reference_map[self.elmts[0].offset]});"

#     def dump_to_circuit_input(self) -> str:
#         return f"circuit_inputs = circuit_inputs.next_u288({self.name});\n"

#     def __len__(self) -> int:
#         if self.elmts is not None:
#             assert len(self.elmts) == 1
#             return 1
#         else:
#             return 1


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


class GenericT(Cairo1SerializableStruct):
    # <T> => u384 or u288

    @property
    def struct_name(self) -> str:
        return "T"

    def serialize(self, raw: bool = False) -> str:
        if self.bits <= 288:
            curve_id = 0
        else:
            curve_id = 1
        assert len(self.elmts) == 1
        raw_struct = f"{int_to_u2XX(self.elmts[0].value, curve_id)}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        assert len(self.elmts) == 1
        if self.bits <= 288:
            return io.bigint_split_array(self.elmts, prepend_length=False)
        else:
            return io.bigint_split_array(self.elmts, n_limbs=3, prepend_length=False)

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        raise NotImplementedError

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


class u256Span(Cairo1SerializableStruct):
    @property
    def struct_name(self) -> str:
        return "Span<u256>"

    def serialize(self, raw: bool = False) -> str:
        raw_struct = f"{io.int_array_to_u256_array(self.elmts)}.span()"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.struct_name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        return io.bigint_split_array(
            self.elmts, n_limbs=2, base=2**128, prepend_length=True
        )

    def dump_to_circuit_input(self) -> str:
        code = f"""
    for val in {self.name} {{
        circuit_inputs = circuit_inputs.next_u256(*val);
    }};"""
        return code

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        raise NotImplementedError

    def __len__(self) -> int:
        if self.elmts is not None:
            return len(self.elmts)
        else:
            return None


class u128(Cairo1SerializableStruct):
    def serialize(self, raw: bool = False) -> str:
        assert len(self.elmts) == 1
        assert 0 <= self.elmts[0].value < 2**128
        raw_struct = f"{hex(self.elmts[0].value)}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.struct_name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        assert len(self.elmts) == 1
        assert 0 <= self.elmts[0].value < 2**128
        return [self.elmts[0].value]

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        raise NotImplementedError

    def dump_to_circuit_input(self) -> str:
        return f"circuit_inputs = circuit_inputs.next_u128({self.name});\n"

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 1
            return 1
        else:
            return 1


class u128Span(Cairo1SerializableStruct):
    @property
    def struct_name(self) -> str:
        return "Span<u128>"

    def serialize(self, raw: bool = False) -> str:
        raw_struct = f"{io.int_array_to_u128_array(self.elmts)}.span()"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.struct_name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        return io.bigint_split_array(
            self.elmts, n_limbs=1, base=2**128, prepend_length=True
        )

    def dump_to_circuit_input(self) -> str:
        code = f"""
    for val in {self.name} {{
        circuit_inputs = circuit_inputs.next_u128(*val);
    }};"""
        return code

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        raise NotImplementedError

    def __len__(self) -> int:
        if self.elmts is not None:
            return len(self.elmts)
        else:
            return None


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
        code = ""
        # Need to unpack the tuple  :
        code = f"let ({','.join([self.members_names[i] for i in range(len(self.elmts))])}) = {self.name};\n"
        # Now call dump_to_circuit_input for each member
        # Names must correspond to the members names
        for i, elmt in enumerate(self.elmts):
            assert (
                elmt.name == self.members_names[i]
            ), f"Tuple member {i} has name {elmt.name} instead of {self.members_names[i]}"
            code += elmt.dump_to_circuit_input()
        return code

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
        code = f"let {self.name}_384:u384 = {self.name}.into();\n"
        code += f"circuit_inputs = circuit_inputs.next_2({self.name}_384);\n"
        return code

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 1
            return 1
        else:
            return 1


class u384Array(Cairo1SerializableStruct):
    def serialize(self, raw: bool = False) -> str:
        if len(self.elmts) == 0:
            raw_struct = "array![]"
        else:
            bits = self.bits
            if self.name == "g_rhs_sqrt":
                # Temp fix before we change the MSMHint and G1Points to depend on the curve id
                # Todo : remove this
                curve_id = 1
            else:
                curve_id = 0 if bits <= 288 else 1

            raw_struct = f"{io.int_array_to_u2XX_array(self.elmts, curve_id=curve_id)}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.struct_name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        if len(self.elmts) == 0:
            return [0]
        bits = self.bits
        if bits <= 288 and self.name != "g_rhs_sqrt":
            return io.bigint_split_array(self.elmts, n_limbs=3, prepend_length=True)
        else:
            return io.bigint_split_array(self.elmts, n_limbs=4, prepend_length=True)

    @property
    def struct_name(self) -> str:
        bits = self.bits
        if bits <= 288:
            return "Array<u288>"
        elif bits <= 384:
            return "Array<u384>"
        else:
            raise ValueError(f"Unsupported bit length for u384Array: {bits}")

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        return f"let {self.name} = array![{','.join([f'outputs.get_output({offset_to_reference_map[elmt.offset]})' for elmt in self.elmts])}];"

    def dump_to_circuit_input(self) -> str:
        next_fn = "next_2"
        code = f"""
    for val in {self.name}.span() {{
        circuit_inputs = circuit_inputs.{next_fn}(*val);
    }};"""
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
        name: str, f: FunctionFelt, msm_size: int, batched: bool = False
    ) -> "FunctionFeltCircuit":
        _a_num, _a_den, _b_num, _b_den = io.padd_function_felt(
            f, msm_size, py_felt=True, batched=batched
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
        bits = self.elmts[0].bits
        if bits <= 288:
            for elmt in self.elmts:
                cd.extend(
                    io.bigint_split_array(elmt.elmts, n_limbs=3, prepend_length=True)
                )
        else:
            for elmt in self.elmts:
                cd.extend(
                    io.bigint_split_array(elmt.elmts, n_limbs=4, prepend_length=True)
                )
        return cd

    def serialize_input_signature(self) -> str:
        return f"{self.name}:FunctionFelt<T>"

    def serialize(self, raw: bool = False) -> str:
        raw_struct = f"FunctionFelt {{ {','.join([f'{self.members_names[i]}: {self.elmts[i].serialize(raw=True)}' for i in range(4)])} }}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.struct_name} = {raw_struct};\n"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"""
            for val in {self.name}.{mem_name} {{
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
        return f"let {self.name}:{self.struct_name} = array![{','.join([f'outputs.get_output({offset_to_reference_map[elmt.offset]})' for elmt in self.elmts])}].span();"

    def dump_to_circuit_input(self) -> str:
        code = f"""let mut {self.name} = {self.name};
    for val in {self.name} {{
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

    def serialize_input_signature(self) -> str:
        bits = self.bits
        if bits <= 288:
            return f"{self.name}:G2Line<u288>"
        else:
            return f"{self.name}:G2Line<u384>"

    def serialize(self, raw: bool = False) -> str:
        assert len(self.elmts) == 4
        bits = self.bits
        if bits <= 288:
            curve_id = 0
        else:
            curve_id = 1

        raw_struct = f"{self.struct_name} {{r0a0: {int_to_u2XX(self.elmts[0].value, curve_id=curve_id)}, r0a1: {int_to_u2XX(self.elmts[1].value, curve_id=curve_id)}, r1a0: {int_to_u2XX(self.elmts[2].value, curve_id=curve_id)}, r1a1: {int_to_u2XX(self.elmts[3].value, curve_id=curve_id)}}}"
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
        next_fn = "next_2"
        for mem_name in self.members_names:
            code += (
                f"circuit_inputs = circuit_inputs.{next_fn}({self.name}.{mem_name});\n"
            )
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

    @property
    def struct_name(self) -> str:
        p = self.elmts[0].p
        if p.bit_length() <= 288:
            return "E12D<u288>"
        else:
            return "E12D<u384>"

    def serialize(self, raw: bool = False, is_option: bool = False) -> str:
        if self.elmts is None:
            raw_struct = "Option::None"
            if raw:
                return raw_struct
            else:
                return f"let {self.name}:Option<{self.__class__.__name__}> = {raw_struct};\n"
        else:
            assert len(self.elmts) == 12
            bits: int = self.elmts[0].p.bit_length()
            if bits <= 288:
                curve_id = 0
            else:
                curve_id = 1

            raw_struct = (
                f"{self.__class__.__name__}{{"
                + f"{','.join([f'w{i}: {int_to_u2XX(self.elmts[i].value, curve_id=curve_id)}' for i in range(len(self))])}}}"
            )
            if is_option:
                raw_struct = f"Option::Some({raw_struct})"
            if raw:
                return raw_struct
            else:
                return f"let {self.name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        bits: int = self.bits
        if bits <= 288:
            return io.bigint_split_array(self.elmts, n_limbs=3, prepend_length=False)
        elif bits <= 384:
            return io.bigint_split_array(self.elmts, n_limbs=4, prepend_length=False)
        else:
            raise ValueError(f"Unsupported bit length for E12D: {bits}")

    def dump_to_circuit_input(self) -> str:
        bits: int = self.elmts[0].p.bit_length()
        code = ""
        next_fn = "next_2"
        for i in range(len(self)):
            code += f"circuit_inputs = circuit_inputs.{next_fn}({self.name}.w{i});\n"
        return code

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 12
            return 12
        else:
            return 12


class E12T(Cairo1SerializableStruct):
    def __init__(self, name: str, elmts: list[ModuloCircuitElement]):
        super().__init__(name, elmts)
        self.members_names = (
            "c0b0a0",
            "c0b0a1",
            "c0b1a0",
            "c0b1a1",
            "c0b2a0",
            "c0b2a1",
            "c1b0a0",
            "c1b0a1",
            "c1b1a0",
            "c1b1a1",
            "c1b2a0",
            "c1b2a1",
        )

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 12
        code = (
            f"let {self.name}:{self.__class__.__name__} = {self.__class__.__name__}{{\n"
        )
        for i, elmt in enumerate(self.elmts):
            code += f"{self.members_names[i]}:outputs.get_output({offset_to_reference_map[elmt.offset]}),\n"
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

            raw_struct = (
                f"{self.__class__.__name__}{{"
                + f"{','.join([f'{self.members_names[i]}: {int_to_u384(self.elmts[i].value)}' for i in range(len(self))])}}}"
            )
            if is_option:
                raw_struct = f"Option::Some({raw_struct})"
            if raw:
                return raw_struct
            else:
                return f"let {self.name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        return io.bigint_split_array(self.elmts, n_limbs=4, prepend_length=False)

    def dump_to_circuit_input(self) -> str:
        code = ""
        for i in range(len(self)):
            code += f"circuit_inputs = circuit_inputs.next_2({self.name}.{self.members_names[i]});\n"
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

    @property
    def struct_name(self) -> str:
        p = self.elmts[0].p
        if p.bit_length() <= 288:
            return "E12DMulQuotient<u288>"
        else:
            return "E12DMulQuotient<u384>"

    def serialize(self, raw: bool = False, is_option: bool = False) -> str:
        if self.elmts is None:
            raw_struct = "Option::None"
            if raw:
                return raw_struct
            else:
                return f"let {self.name}:Option<{self.__class__.__name__}> = {raw_struct};\n"
        else:
            assert len(self.elmts) == 11
            bits: int = self.elmts[0].p.bit_length()
            if bits <= 288:
                curve_id = 0
            else:
                curve_id = 1

            raw_struct = (
                f"{self.__class__.__name__}{{"
                + f"{','.join([f'w{i}: {int_to_u2XX(self.elmts[i].value, curve_id=curve_id)}' for i in range(len(self))])}}}"
            )
            if is_option:
                raw_struct = f"Option::Some({raw_struct})"
            if raw:
                return raw_struct
            else:
                return f"let {self.name} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        bits: int = self.bits
        if bits <= 288:
            return io.bigint_split_array(self.elmts, n_limbs=3, prepend_length=False)
        elif bits <= 384:
            return io.bigint_split_array(self.elmts, n_limbs=4, prepend_length=False)
        else:
            raise ValueError(f"Unsupported bit length for E12D: {bits}")

    def dump_to_circuit_input(self) -> str:
        code = ""
        next_fn = "next_2"
        for i in range(len(self)):
            code += f"circuit_inputs = circuit_inputs.{next_fn}({self.name}.w{i});\n"
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

    def serialize_input_signature(self) -> str:
        bits = self.bits
        if bits <= 288:
            return f"{self.name}:MillerLoopResultScalingFactor<u288>"
        else:
            return f"{self.name}:MillerLoopResultScalingFactor<u384>"

    def dump_to_circuit_input(self) -> str:
        code = ""
        next_fn = "next_2"
        for mem_name in self.members_names:
            code += (
                f"circuit_inputs = circuit_inputs.{next_fn}({self.name}.{mem_name});\n"
            )
        return code

    def serialize(self, raw: bool = False) -> str:
        assert len(self.elmts) == 6
        bits = self.bits
        if bits <= 288:
            curve_id = 0
        else:
            curve_id = 1
        raw_struct = f"{self.__class__.__name__}{{{','.join([f'{self.members_names[i]}: {int_to_u2XX(self.elmts[i].value, curve_id=curve_id)}' for i in range(len(self))])}}}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.__class__.__name__} = {raw_struct};\n"

    def _serialize_to_calldata(self) -> list[int]:
        bits = self.bits
        if bits <= 288:
            return io.bigint_split_array(self.elmts, n_limbs=3, prepend_length=False)
        else:
            return io.bigint_split_array(self.elmts, n_limbs=4, prepend_length=False)

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
