from dataclasses import dataclass
from abc import ABC, abstractmethod

from hydra.hints.io import int_to_u384, int_array_to_u384_array
from hydra.algebra import ModuloCircuitElement, PyFelt


@dataclass(slots=True)
class Cairo1SerializableStruct(ABC):
    name: str
    elmts: list[ModuloCircuitElement | PyFelt]

    def __post_init__(self):
        assert type(self.elmts) == list
        assert type(self.name) == str
        assert all(
            isinstance(elmt, (ModuloCircuitElement, PyFelt)) for elmt in self.elmts
        )

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


class u384(Cairo1SerializableStruct):
    def serialize(self, raw: bool = False) -> str:
        assert len(self.elmts) == 1
        raw_struct = f"{int_to_u384(self.elmts[0].value)}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.struct_name} = {raw_struct};\n"

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 1
        return f"let {self.name}:{self.struct_name} = outputs.get_output({offset_to_reference_map[self.elmts[0].offset]});\n"

    def dump_to_circuit_input(self) -> str:
        return f"circuit_inputs = circuit_inputs.next({self.name});\n"

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

    @property
    def struct_name(self) -> str:
        return "Array<u384>"

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 1
        return f"let {self.name}:{self.struct_name} = array![{','.join([f'outputs.get_output({offset_to_reference_map[elmt.offset]})' for elmt in self.elmts])}];\n"

    def dump_to_circuit_input(self) -> str:
        code = f"""
    let mut {self.name} = {self.name};
    while let Option::Some(val) = {self.name}.pop_front() {{
        circuit_inputs = circuit_inputs.next(val);
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
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{yInv: {int_to_u384(self.elmts[0].value)}, xNegOverY: {int_to_u384(self.elmts[1].value)}}};\n"

    def serialize_input_signature(self):
        return f"{self.name}:{self.struct_name}"

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 2
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{ {','.join([f'{self.members_names[i]}: outputs.get_output({offset_to_reference_map[self.elmts[i].offset]})' for i in range(2)])} }};\n"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"circuit_inputs = circuit_inputs.next({self.name}.{mem_name});\n"
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

    def serialize_input_signature(self):
        return f"{self.name}:{self.struct_name}"

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 4
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{ {','.join([f'{self.members_names[i]}: outputs.get_output({offset_to_reference_map[self.elmts[i].offset]})' for i in range(4)])} }};\n"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"circuit_inputs = circuit_inputs.next({self.name}.{mem_name});\n"
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

    @property
    def struct_name(self) -> str:
        return "G1Point"

    def serialize(self) -> str:
        assert len(self.elmts) == 2
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{x: {int_to_u384(self.elmts[0].value)}, y: {int_to_u384(self.elmts[1].value)}}};\n"

    def serialize_input_signature(self):
        return f"{self.name}:{self.struct_name}"

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 2
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{ {','.join([f'{self.members_names[i]}: outputs.get_output({offset_to_reference_map[self.elmts[i].offset]})' for i in range(2)])} }};\n"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"circuit_inputs = circuit_inputs.next({self.name}.{mem_name});\n"
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

    @property
    def struct_name(self) -> str:
        return "G2Point"

    def serialize(self) -> str:
        assert len(self.elmts) == 4
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{x0: {int_to_u384(self.elmts[0].value)}, x1: {int_to_u384(self.elmts[1].value)}, y0: {int_to_u384(self.elmts[2].value)}, y1: {int_to_u384(self.elmts[3].value)}}};\n"

    def serialize_input_signature(self):
        return f"{self.name}:{self.struct_name}"

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 4
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{ {','.join([f'{self.members_names[i]}: outputs.get_output({offset_to_reference_map[self.elmts[i].offset]})' for i in range(4)])} }};\n"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"circuit_inputs = circuit_inputs.next({self.name}.{mem_name});\n"
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

    def serialize_input_signature(self):
        return f"{self.name}:{self.struct_name}"

    def extract_from_circuit_output(
        self, offset_to_reference_map: dict[int, str]
    ) -> str:
        assert len(self.elmts) == 6
        return f"let {self.name}:{self.struct_name} = {self.struct_name} {{ {','.join([f'{self.members_names[i]}: outputs.get_output({offset_to_reference_map[self.elmts[i].offset]})' for i in range(6)])} }};\n"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"circuit_inputs = circuit_inputs.next({self.name}.{mem_name});\n"
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

    def serialize(self, raw: bool = False) -> str:
        assert len(self.elmts) == 12
        raw_struct = f"{self.__class__.__name__}{{{','.join([f'w{i}: {int_to_u384(self.elmts[i].value)}' for i in range(len(self))])}}}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.__class__.__name__} = {raw_struct};\n"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for i in range(len(self)):
            code += f"circuit_inputs = circuit_inputs.next({self.name}.w{i});\n"
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

    def serialize(self, raw: bool = False) -> str:
        assert len(self.elmts) == 11
        raw_struct = f"{self.__class__.__name__}{{{','.join([f'w{i}: {int_to_u384(self.elmts[i].value)}' for i in range(len(self))])}}}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.__class__.__name__} = {raw_struct};\n"

    def dump_to_circuit_input(self) -> str:
        code = ""
        for i in range(len(self)):
            code += f"circuit_inputs = circuit_inputs.next({self.name}.w{i});\n"
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
        raise NotImplementedError

    def dump_to_circuit_input(self) -> str:
        code = ""
        for mem_name in self.members_names:
            code += f"circuit_inputs = circuit_inputs.next({self.name}.{mem_name});\n"
        return code

    def serialize(self, raw: bool = False) -> str:
        assert len(self.elmts) == 6
        raw_struct = f"{self.__class__.__name__}{{{','.join([f'{self.members_names[i]}: {int_to_u384(self.elmts[i].value)}' for i in range(len(self))])}}}"
        if raw:
            return raw_struct
        else:
            return f"let {self.name}:{self.__class__.__name__} = {raw_struct};\n"

    def __len__(self) -> int:
        if self.elmts is not None:
            assert len(self.elmts) == 6
            return 6
        else:
            return 6
