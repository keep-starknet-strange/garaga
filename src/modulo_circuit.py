from src.algebra import PyFelt, ModuloCircuitElement, BaseField
from src.hints.io import bigint_split
from src.definitions import STARK, CURVES, N_LIMBS, BASE
from dataclasses import dataclass
from enum import Enum, auto


class WriteOps(Enum):
    """
    Enum for the source of a write operation in the value segment.
    -CONSTANT | INPUT: The value was written by coping N_LIMBS from the allocation pointer to the value segment.
    -COMMIT: The value was written as a result of a hint value from the prover, and needs to be hashed.
    -WITNESS: Same as COMMIT, but do not need to be hashed.
    -FELT: The value was written by coping N_LIMBS from the allocation pointer,
           as a result of a non-deterministic felt252 to UInt384 decomposition.
           The value segment is increased by 1 due to an extra range check needed.
    -BUILTIN: The value was written by the modulo builtin as result of a ADD or MUL instruction.
    """

    CONSTANT = auto()
    INPUT = auto()
    COMMIT = auto()
    WITNESS = auto()
    FELT = auto()
    BUILTIN = auto()


class ModBuiltinOps(Enum):
    """
    Enum for the modulo builtin operations.
    """

    ADD = "+"
    MUL = "*"


class CairoVMOps(Enum):
    ASSERT_EQ = "=="


@dataclass(slots=True, frozen=True)
class ModuloCircuitInstruction:
    operation: ModBuiltinOps
    left_offset: int
    right_offset: int
    result_offset: int


@dataclass(slots=True, frozen=True)
class AssertEqInstruction:
    segment_left_offset: int
    segment_right_offset: int


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
    assert_eq_instructions: list[AssertEqInstruction]
    offset: int
    n_limbs: int
    debug: bool
    name: str
    segment_stacks: dict[WriteOps, dict[int, ValueSegmentItem]]

    def __init__(self, name: str, debug: bool = True):
        self.segment: dict[int, ValueSegmentItem] = dict()
        self.assert_eq_instructions: list[AssertEqInstruction] = []
        self.offset = 0
        self.n_limbs = N_LIMBS
        self.debug = debug
        self.name = name
        self.segment_stacks = {key: dict() for key in WriteOps}

    def __len__(self) -> int:
        return len(self.segment)

    def __getitem__(self, key: int) -> ValueSegmentItem:
        return self.segment[key]

    def write_to_segment(self, item: ValueSegmentItem) -> int:
        offset = self.offset
        self.segment[offset] = item
        self.segment_stacks[item.write_source][offset] = item
        self.offset += N_LIMBS
        if item.write_source == WriteOps.FELT:
            self.offset += 1
        return offset

    def assert_eq(
        self,
        left_offset: int,
        right_offset: int,
    ):
        self.assert_eq_instructions.append(
            AssertEqInstruction(left_offset, right_offset)
        )

    def non_interactive_transform(self) -> "ValueSegment":
        """
        Rebuild a new ValueSegment by re-ordering the current one in this order:
        CONSTANT
        INPUT
        COMMIT
        FELT
        BUILTIN
        Order matters!
        """
        res = ValueSegment(
            self.name
            if self.name.endswith("_non_interactive")
            else self.name + "_non_interactive"
        )
        offset_map = {}
        for stacks_key in [
            WriteOps.CONSTANT,
            WriteOps.INPUT,
            WriteOps.WITNESS,
            WriteOps.COMMIT,
            WriteOps.FELT,
            WriteOps.BUILTIN,
        ]:
            if self.debug:
                print(stacks_key, len(self.segment_stacks[stacks_key]))
            for old_offset, item in self.segment_stacks[stacks_key].items():
                new_offset = res.write_to_segment(
                    item
                    if stacks_key is not WriteOps.BUILTIN
                    else ValueSegmentItem(
                        item.emulated_felt,
                        item.write_source,
                        ModuloCircuitInstruction(
                            operation=item.instruction.operation,
                            left_offset=offset_map[item.instruction.left_offset],
                            right_offset=offset_map[item.instruction.right_offset],
                            result_offset=res.offset,
                        ),
                    )
                )

                offset_map[old_offset] = new_offset
        for assert_eq_instruction in self.assert_eq_instructions:
            res.assert_eq_instructions.append(
                AssertEqInstruction(
                    offset_map[assert_eq_instruction.segment_left_offset],
                    offset_map[assert_eq_instruction.segment_right_offset],
                )
            )
        return res

    def get_dw_lookups(self) -> dict:
        dw_arrays = {
            "constants_ptr": [],
            "add_offsets_ptr": [],
            "mul_offsets_ptr": [],
            "left_assert_eq_offsets_ptr": [],
            "right_assert_eq_offsets_ptr": [],
            "poseidon_indexes_ptr": [],
        }
        for _, item in self.segment_stacks[WriteOps.CONSTANT].items():
            dw_arrays["constants_ptr"].append(
                bigint_split(item.value, self.n_limbs, BASE)
            )
        for result_offset, item in self.segment_stacks[WriteOps.BUILTIN].items():
            dw_arrays[item.instruction.operation.name.lower() + "_offsets_ptr"].append(
                (
                    item.instruction.left_offset,
                    item.instruction.right_offset,
                    result_offset,
                )
            )
        for assert_eq_instruction in self.assert_eq_instructions:
            dw_arrays["left_assert_eq_offsets_ptr"].append(
                assert_eq_instruction.segment_left_offset
            )
            dw_arrays["right_assert_eq_offsets_ptr"].append(
                assert_eq_instruction.segment_right_offset
            )

        return dw_arrays

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
            if val.write_source in [WriteOps.BUILTIN]:
                row += f"{str(val.instruction.left_offset)+str(val.instruction.operation.value)+str(val.instruction.right_offset):^9}|"
            else:
                row += f"{'_':^9}|"
            row += f"{val.write_source.name:^8}|"
            row += f"\t{RED}{hex(val.emulated_felt.value)}{RESET}"

            print(row)

    def summarize(self):
        add_count = sum(
            1
            for item in self.segment_stacks[WriteOps.BUILTIN].values()
            if item.instruction.operation.name == "ADD"
        )
        mul_count = sum(
            1
            for item in self.segment_stacks[WriteOps.BUILTIN].values()
            if item.instruction.operation.name == "MUL"
        )
        assert add_count + mul_count == len(self.segment_stacks[WriteOps.BUILTIN])
        # print(f"Total FpMul : {mul_count} Total FpAdd : {add_count}")
        return add_count, mul_count


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
        self.name = name
        self.curve_id = curve_id
        self.field = BaseField(CURVES[curve_id].p)
        self.N_LIMBS = 4
        self.values_segment: ValueSegment = ValueSegment(name)
        self.constants: dict[int, ModuloCircuitElement] = dict()

        self.add_constant(self.field.zero())
        self.add_constant(self.field.one())
        self.add_constant(self.field(-1))

    @property
    def values_offset(self):
        return self.values_segment.offset

    def write_element(
        self,
        elmt: PyFelt,
        write_source: WriteOps = WriteOps.INPUT,
        instruction: ModuloCircuitInstruction | None = None,
    ) -> ModuloCircuitElement:
        assert type(elmt) == PyFelt, f"Expected PyFelt, got {type(elmt)}"
        value_offset = self.values_segment.write_to_segment(
            ValueSegmentItem(
                elmt,
                write_source,
                instruction,
            )
        )
        res = ModuloCircuitElement(elmt, value_offset)
        return res

    def write_elements(
        self,
        elmts: list[PyFelt],
        operation: WriteOps = WriteOps.INPUT,
    ) -> list[ModuloCircuitElement]:
        assert operation not in [
            WriteOps.BUILTIN,
            WriteOps.BUILTIN,
        ], f"Builtin {operation} not supported in this context. Use add and mul directly."
        return [self.write_element(elmt, operation, None) for elmt in elmts]

    def write_cairo_native_felt(self, native_felt: PyFelt):
        assert 0 <= native_felt.value < STARK
        res = self.write_element(elmt=native_felt, write_source=WriteOps.FELT)
        return res

    def write_sparse_elements(
        self, elmts: list[PyFelt], operation: WriteOps
    ) -> (list[ModuloCircuitElement], list[int]):
        sparsity = [1 if elmt != self.field.zero() else 0 for elmt in elmts]
        elements = []
        for elmt, not_sparse in zip(elmts, sparsity):
            if not_sparse:
                if elmt.value not in self.constants:
                    elements.append(self.write_element(elmt, operation))
                else:
                    elements.append(self.get_constant(elmt.value))
        return elements, sparsity

    def add_constant(self, val: PyFelt) -> None:
        if val.value in self.constants:
            # print((f"/!\ Constant '{hex(val.value)}' already exists."))
            return self.constants[val.value]
        self.constants[val.value] = self.write_element(val, WriteOps.CONSTANT)
        return self.constants[val.value]

    def get_constant(self, val: int) -> ModuloCircuitElement:
        val = val % self.field.p
        if (val) not in self.constants:
            raise ValueError(
                f"Constant '{val}' does not exist. Available constants : {list(self.constants.keys())}"
            )
        return self.constants[val]

    def assert_eq(self, a: ModuloCircuitElement, b: ModuloCircuitElement):
        assert a.value == b.value, f"Expected {a.value} to be equal to {b.value}"
        self.values_segment.assert_eq(a.offset, b.offset)

    def assert_eq_zero(self, a: ModuloCircuitElement):
        zero = self.constants["ZERO"]
        for i in range(N_LIMBS):
            self.values_segment.assert_eq(a.offset + i, zero.offset)

    def assert_eq_one(self, a: ModuloCircuitElement):
        one, zero = self.constants["ONE"], self.constants["ZERO"]
        self.values_segment.assert_eq(a.offset, one.offset)
        for i in range(1, N_LIMBS):
            self.values_segment.assert_eq(a.offset + i, zero.offset)

    def add(
        self, a: ModuloCircuitElement, b: ModuloCircuitElement
    ) -> ModuloCircuitElement:
        if a is None:
            return b
        elif b is None:
            return a
        else:
            assert (
                type(a) == type(b) == ModuloCircuitElement
            ), f"Expected ModuloElement, got {type(a)}, {a} and {type(b)}, {b}"

            instruction = ModuloCircuitInstruction(
                ModBuiltinOps.ADD, a.offset, b.offset, self.values_offset
            )
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
        return self.write_element(
            a.emulated_felt * b.emulated_felt, WriteOps.BUILTIN, instruction
        )

    def neg(self, a: ModuloCircuitElement) -> ModuloCircuitElement:
        res = self.sub(self.get_constant(0), a)
        return res

    def sub(self, a: ModuloCircuitElement, b: ModuloCircuitElement):
        instruction = ModuloCircuitInstruction(
            ModBuiltinOps.ADD, b.offset, self.values_offset, a.offset
        )
        return self.write_element(a.felt - b.felt, WriteOps.WITNESS, instruction)

    def inv(self, a: ModuloCircuitElement):
        raise NotImplementedError

    def div(self, a: ModuloCircuitElement, b: ModuloCircuitElement):
        return self.mul(a, self.inv(b))

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
