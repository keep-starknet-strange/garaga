from src.algebra import PyFelt, ModuloCircuitElement, BaseField
from src.definitions import STARK, CURVES, N_LIMBS
from dataclasses import dataclass
from enum import Enum, auto


class WriteOps(Enum):
    """
    Enum for the source of a write operation in the value segment.
    -LIMBS: The value was written by coping N_LIMBS from the allocation pointer to the value segment.
    -COMMIT: The value was written as a result of a hint value from the prover.
    -FELT: The value was written by coping N_LIMBS from the allocation pointer,
           as a result of a non-deterministic felt252 to UInt384 decomposition.
           The value segment is increased by 1 due to an extra range check needed.
    -BUILTIN: The value was written by the modulo builtin as result of a ADD or MUL instruction.
    """

    LIMBS = auto()
    COMMIT = auto()
    FELT = auto()
    BUILTIN = auto()


class ModBuiltinOps(Enum):
    """
    Enum for the modulo builtin operations.
    """

    ADD = "+"
    MUL = "*"


@dataclass(slots=True, frozen=True)
class ModuloCircuitInstruction:
    operation: ModBuiltinOps
    left_offset: int
    right_offset: int
    result_offset: int


@dataclass(slots=True, frozen=True)
class ValueSegmentItem:
    emulated_felt: PyFelt
    write_source: WriteOps
    instruction: None | ModuloCircuitInstruction

    @property
    def value(self) -> int:
        return self.emulated_felt.value

    @property
    def p(self):
        return self.emulated_felt.p

    @property
    def felt(self):
        return self.emulated_felt


@dataclass(slots=True, init=False)
class ValueSegment:
    segment: dict[int, ValueSegmentItem]
    offset: int
    debug: bool
    stacks: dict[WriteOps, dict[int, ValueSegmentItem]]

    def __init__(self, debug: bool = True):
        self.segment: dict[int, ValueSegmentItem] = dict()
        self.offset = 0
        self.debug = debug
        self.stacks = {key: dict() for key in WriteOps}

    def __len__(self) -> int:
        return len(self.segment)

    def __getitem__(self, key: int) -> ValueSegmentItem:
        return self.segment[key]

    def get_add_mul_offsets(self):
        add_offsets = [
            (
                item.instruction.left_offset,
                item.instruction.right_offset,
                result_offset,
            )
            for result_offset, item in self.stacks[WriteOps.BUILTIN].items()
            if item.instruction.operation == ModBuiltinOps.ADD
        ]
        mul_offsets = [
            (
                item.instruction.left_offset,
                item.instruction.right_offset,
                result_offset,
            )
            for result_offset, item in self.stacks[WriteOps.BUILTIN].items()
            if item.instruction.operation == ModBuiltinOps.MUL
        ]
        return add_offsets, mul_offsets

    def write(self, item: ValueSegmentItem) -> int:
        offset = self.offset
        self.segment[offset] = item
        self.stacks[item.write_source][self.offset] = item
        self.offset += N_LIMBS
        if item.write_source == WriteOps.FELT:
            self.offset += 1
        return offset

    def fiat_shamir(self) -> "ValueSegment":
        """
        Rebuild a new ValueSegment by re-ordering the current one in this order:
        LIMBS (inputs)
        COMMITS
        FELT
        BUILTIN
        Order matters!
        """
        res = ValueSegment()
        offset_map = {}
        for stacks_key in [
            WriteOps.LIMBS,
            WriteOps.COMMIT,
            WriteOps.FELT,
            WriteOps.BUILTIN,
        ]:
            print(stacks_key, len(self.stacks[stacks_key]))
            for old_offset, item in self.stacks[stacks_key].items():
                new_offset = res.write(
                    ValueSegmentItem(
                        item.emulated_felt,
                        item.write_source,
                        ModuloCircuitInstruction(
                            item.instruction.operation,
                            offset_map[item.instruction.left_offset],
                            offset_map[item.instruction.right_offset],
                            res.offset,
                        ),
                    )
                    if stacks_key == WriteOps.BUILTIN
                    else item
                )

                offset_map[old_offset] = new_offset
        return res

    def print(self):
        # ANSI escape codes for some colors
        RED = "\033[31m"  # Red text
        GREEN = "\033[32m"  # Green text
        BLUE = "\033[34m"  # Blue text
        ORANGE = "\033[33m"  # Orange text
        RESET = "\033[0m"  # Reset to default color

        # print(f"{RED}This will be red!{RESET}")
        # print(f"{GREEN}This will be green!{RESET}")

        for i, (offset, val) in enumerate(self.segment.items()):
            row = ""
            row += f"{BLUE}{'['+str(i)+']':^7}{RESET}|{ORANGE}{'['+str(offset)+']':^7}{RESET}|"
            if val.write_source in [WriteOps.BUILTIN, WriteOps.BUILTIN]:
                row += f"{str(val.instruction.left_offset)+str(val.instruction.operation.value)+str(val.instruction.right_offset):^9}|"
            else:
                row += f"{'_':^9}|"
            row += f"{val.write_source.name:^8}|"
            row += f"\t{RED}{hex(val.emulated_felt.value)}{RESET}"

            print(row)


class ModuloCircuit:
    """
    Represents a modulo circuit capable of performing arithmetic operations on base field elements,
    storing constants, and caching powers of base field elements.

    Attributes:
        circuit_name (str): The name of the circuit.
        last_offset (int): The last used offset in the circuit's memory.
        N_LIMBS (int): The number of limbs used in the circuit.
        values_segment (dict[int, BaseFieldElement]): A dictionary mapping offsets to base field elements.
        add_offsets (list[tuple]): A list of tuples representing the offsets involved in addition operations.
        mul_offsets (list[tuple]): A list of tuples representing the offsets involved in multiplication operations.
        constants (dict[str, ModuloElement]): A dictionary mapping constant names to their ModuloElement representations.
    """

    def __init__(self, name: str, curve_id: int) -> None:
        self.circuit_name = name
        self.curve_id = curve_id
        self.field = BaseField(CURVES[curve_id].p)
        self.values_offset = 0
        self.number_of_values = 0
        self.N_LIMBS = 4

        self.values_segment: ValueSegment = ValueSegment()
        self.constants: dict[str, ModuloCircuitElement] = dict()
        self.z_powers: list[ModuloCircuitElement] = []
        # self.add_offsets: list[ModuloCircuitInstruction] = []
        # self.mul_offsets: list[ModuloCircuitInstruction] = []

    def write_element(
        self,
        elmt: PyFelt,
        write_source: WriteOps = WriteOps.LIMBS,
        instruction: ModuloCircuitInstruction | None = None,
    ) -> ModuloCircuitElement:
        assert type(elmt) == PyFelt, f"Expected PyFelt, got {type(elmt)}"
        self.values_segment.write(
            ValueSegmentItem(
                elmt,
                write_source,
                instruction,
            )
        )
        res = ModuloCircuitElement(elmt, self.values_offset)
        self.values_offset += self.N_LIMBS
        self.number_of_values += 1
        return res

    def write_elements(
        self,
        elmts: list[PyFelt],
        operation: WriteOps = WriteOps.LIMBS,
    ) -> list[ModuloCircuitElement]:
        assert operation not in [
            WriteOps.BUILTIN,
            WriteOps.BUILTIN,
        ], f"Builtin {operation} not supported in this context. Use add and mul directly."
        return [self.write_element(elmt, operation, None) for elmt in elmts]

    def write_cairo_native_felt(self, value: int):
        assert 0 <= value < STARK
        res = self.write_element(self.field(value), WriteOps.FELT)
        self.values_offset += 1
        return res

    def write_sparse_elements(self, elmts: list[PyFelt]) -> list[ModuloCircuitElement]:
        sparsity = [1 if elmt != self.field.zero() else 0 for elmt in elmts]
        return [
            self.write_element(elmt, "sparse_write")
            for elmt, not_sparse in zip(elmts, sparsity)
            if not_sparse
        ], sparsity

    def add_constant(self, name: str, value: PyFelt) -> None:
        if name in self.constants:
            raise ValueError(f"Constant '{name}' already exists.")
        self.constants[name] = self.write_element(value, WriteOps.LIMBS)

    def get_constant(self, name: str) -> ModuloCircuitElement:
        if name not in self.constants:
            raise ValueError(f"Constant '{name}' does not exist.")
        return self.constants[name]

    def add(
        self, a: ModuloCircuitElement, b: ModuloCircuitElement
    ) -> ModuloCircuitElement:
        assert (
            type(a) == type(b) == ModuloCircuitElement
        ), f"Expected ModuloElement, got {type(a)}, {a} and {type(b)}, {b}"

        instruction = ModuloCircuitInstruction(
            ModBuiltinOps.ADD, a.offset, b.offset, self.values_offset
        )
        # self.add_offsets.append(instruction)
        return self.write_element(
            a.emulated_felt + b.emulated_felt, WriteOps.BUILTIN, instruction
        )

    def mul(
        self,
        a: ModuloCircuitElement,
        b: ModuloCircuitElement,
    ) -> ModuloCircuitElement:

        instruction = ModuloCircuitInstruction(
            ModBuiltinOps.MUL, a.offset, b.offset, self.values_offset
        )
        # self.mul_offsets.append(instruction)
        return self.write_element(
            a.emulated_felt * b.emulated_felt, WriteOps.BUILTIN, instruction
        )

    def compile_offsets(self) -> str:
        add_offsets, mul_offsets = self.values_segment.get_add_mul_offsets()
        add_offsets_lookup = f"{self.circuit_name}_add_offsets:\n"
        mul_offsets_lookup = f"{self.circuit_name}_mul_offsets:\n"
        for left, right, result in add_offsets:
            add_offsets_lookup += (
                f"\t dw {left}; // {self.values_segment[left].value}\n"
                + f"\t dw {right}; // {self.values_segment[right].value}\n"
                + f"\t dw {result}; // {self.values_segment[result].value}\n\n"
            )
        for left, right, result in mul_offsets:
            mul_offsets_lookup += (
                f"\t dw {left}; // {self.values_segment[left].value}\n"
                + f"\t dw {right}; // {self.values_segment[right].value}\n"
                + f"\t dw {result}; // {self.values_segment[result].value}\n\n"
            )
        return add_offsets_lookup + mul_offsets_lookup

    def sub(self, a: ModuloCircuitElement, b: ModuloCircuitElement):
        raise NotImplementedError

    def inv(self, a: ModuloCircuitElement):
        raise NotImplementedError

    def div(self, a: ModuloCircuitElement, b: ModuloCircuitElement):
        raise NotImplementedError

    def _check_sanity(self):
        for a_offset, b_offset, result_offset in self.add_offsets:
            a_value = self.values_segment[a_offset]
            b_value = self.values_segment[b_offset]
            result_value = self.values_segment[result_offset]
            assert result_value == a_value + b_value
        for a_offset, b_offset, result_offset in self.mul_offsets:
            a_value = self.values_segment[a_offset]
            b_value = self.values_segment[b_offset]
            result_value = self.values_segment[result_offset]
            assert result_value == a_value * b_value
        return True

    def print_value_segment(self):
        self.values_segment.print()


if __name__ == "__main__":
    from src.algebra import BaseField

    field = BaseField(256)
    circuit = ModuloCircuit("test_circuit")
    a = circuit.write_commitment(field(1))
    b = circuit.write_commitment(field(2))
    c = circuit.add(a, b)
    d = circuit.mul(c, b)
    x = circuit.write_commitment(field(42))
    y = circuit.write_commitment(field(13))
    z = circuit.add(x, y)

    print(c)

    print(d)

    print(circuit.values_segment)
    print(circuit.add_offsets)
    print(circuit.mul_offsets)

    assert circuit._check_sanity()

    print(circuit.compile_offsets())
