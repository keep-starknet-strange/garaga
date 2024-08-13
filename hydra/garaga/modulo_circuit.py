from dataclasses import dataclass, field
from enum import Enum, auto
from typing import List, Union

from garaga.algebra import BaseField, ModuloCircuitElement, PyFelt
from garaga.definitions import BASE, CURVES, N_LIMBS, STARK, CurveID, get_sparsity
from garaga.hints.extf_mul import nondeterministic_extension_field_div
from garaga.hints.io import bigint_split
from garaga.modulo_circuit_structs import Cairo1SerializableStruct

BATCH_SIZE = 1


class WriteOps(Enum):
    """
    Enum for the source of a write operation in the value segment.
    -CONSTANT | INPUT: The value was written by coping N_LIMBS from the allocation pointer to the value segment.
    -COMMIT: The value was written as a result of a hint value from the prover, and needs to be hashed.
    -WITNESS: Same as COMMIT, but do not need to be hashed.
    -FELT: The value was written by coping N_LIMBS from the allocation pointer,
           as a result of a non-deterministic felt252 to UInt384 decomposition.
           In CairoZero, the value segment is increased by 1 due to an extra range check needed.
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
    comment: str | None


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
    assert_eq_instructions: list[ModuloCircuitInstruction]
    offset: int
    n_limbs: int
    debug: bool
    name: str
    output: list[ModuloCircuitElement]
    segment_stacks: dict[WriteOps, dict[int, ValueSegmentItem]]
    output_structs: list[Cairo1SerializableStruct] | None

    def __init__(self, name: str, debug: bool = False, compilation_mode: int = 0):
        self.segment: dict[int, ValueSegmentItem] = dict()
        self.assert_eq_instructions: list[ModuloCircuitInstruction] = []
        self.output: list[ModuloCircuitElement] = []
        self.offset = 0
        self.n_limbs = N_LIMBS
        self.debug = debug
        self.name = name
        self.segment_stacks = {key: dict() for key in WriteOps}
        self.output_structs = None if compilation_mode == 0 else []

    def __len__(self) -> int:
        return len(self.segment)

    def __getitem__(self, key: int) -> ValueSegmentItem:
        return self.segment[key]

    @property
    def input(self) -> list[ModuloCircuitElement]:
        combined_items = [
            (offset, item)
            for stack in [
                WriteOps.INPUT,
                WriteOps.COMMIT,
                WriteOps.WITNESS,
                WriteOps.FELT,
            ]
            for offset, item in self.segment_stacks[stack].items()
        ]
        combined_items.sort(key=lambda x: x[0])  # Sort by offset

        return [
            ModuloCircuitElement(item.emulated_felt, offset)
            for offset, item in combined_items
        ]

    def write_to_segment(self, item: ValueSegmentItem) -> int:
        offset = self.offset
        self.segment[offset] = item
        self.segment_stacks[item.write_source][offset] = item
        self.offset += N_LIMBS
        if item.write_source == WriteOps.FELT:
            self.offset += 1
        return offset

    def non_interactive_transform(self) -> "ValueSegment":
        """
        Rebuild a new ValueSegment by re-ordering the current one in this order:
        CONSTANT
        INPUT
        COMMIT
        WITNESS
        FELT
        BUILTIN
        Order matters!
        """
        res = ValueSegment(self.name)
        offset_map = {}
        for stacks_key in [
            WriteOps.CONSTANT,
            WriteOps.INPUT,
            WriteOps.COMMIT,
            WriteOps.WITNESS,
            WriteOps.FELT,
            WriteOps.BUILTIN,
        ]:
            if self.debug:
                print(stacks_key, len(self.segment_stacks[stacks_key]))
            for old_offset, item in self.segment_stacks[stacks_key].items():
                # print(offset_map)
                if item.instruction is None:
                    new_offset = res.write_to_segment(item)
                else:
                    # print(item.instruction)
                    new_offset = res.write_to_segment(
                        ValueSegmentItem(
                            item.emulated_felt,
                            item.write_source,
                            ModuloCircuitInstruction(
                                operation=item.instruction.operation,
                                left_offset=offset_map.get(
                                    item.instruction.left_offset, res.offset
                                ),
                                right_offset=offset_map.get(
                                    item.instruction.right_offset, res.offset
                                ),
                                result_offset=offset_map.get(
                                    item.instruction.result_offset, res.offset
                                ),
                                comment=item.instruction.comment,
                            ),
                        )
                    )

                offset_map[old_offset] = new_offset
        # Those are builtins instructions that did not create any new value.
        for assert_eq_instruction in self.assert_eq_instructions:
            res.assert_eq_instructions.append(
                ModuloCircuitInstruction(
                    operation=assert_eq_instruction.operation,
                    left_offset=offset_map[assert_eq_instruction.left_offset],
                    right_offset=offset_map[assert_eq_instruction.right_offset],
                    result_offset=offset_map[assert_eq_instruction.result_offset],
                    comment=assert_eq_instruction.comment,
                )
            )
        new_output = []
        new_output_structs = None if self.output_structs is None else []
        for elmt in self.output:
            new_output.append(ModuloCircuitElement(elmt.felt, offset_map[elmt.offset]))

        if self.output_structs is not None:
            for struct in self.output_structs:
                new_output_structs.append(
                    struct.__class__(
                        struct.name,
                        [
                            ModuloCircuitElement(elt.felt, offset_map[elt.offset])
                            for elt in struct.elmts
                        ],
                    )
                )

        res.output = new_output
        res.output_structs = new_output_structs
        return res

    def get_dw_lookups(self) -> dict:
        dw_arrays = {
            "constants_ptr": [],
            "add_offsets_ptr": [],
            "mul_offsets_ptr": [],
            "output_offsets_ptr": [],
            "poseidon_indexes_ptr": [],
        }
        for _, item in self.segment_stacks[WriteOps.CONSTANT].items():
            dw_arrays["constants_ptr"].append(
                bigint_split(item.value, self.n_limbs, BASE)
            )
        for write_op in [WriteOps.BUILTIN, WriteOps.WITNESS]:
            for result_offset, item in self.segment_stacks[write_op].items():
                if not item.instruction:
                    continue
                # print(item.instruction)
                dw_arrays[
                    item.instruction.operation.name.lower() + "_offsets_ptr"
                ].append(
                    (
                        item.instruction.left_offset,
                        item.instruction.right_offset,
                        item.instruction.result_offset,
                        item.instruction.comment,
                    )
                )
        for assert_eq_instruction in self.assert_eq_instructions:
            dw_arrays[
                assert_eq_instruction.operation.name.lower() + "_offsets_ptr"
            ].append(
                (
                    assert_eq_instruction.left_offset,
                    assert_eq_instruction.right_offset,
                    assert_eq_instruction.result_offset,
                    assert_eq_instruction.comment,
                )
            )
        for output_elmt in self.output:
            dw_arrays["output_offsets_ptr"].append(output_elmt.offset)

        # print("dw_arrays[add_offsets_ptr]", dw_arrays["add_offsets_ptr"])
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
            if val.instruction:
                row += f"{str(val.instruction.left_offset)+str(val.instruction.operation.value)+str(val.instruction.right_offset)+'='+str(val.instruction.result_offset):^9}|"
            else:
                row += f"{'_':^9}|"
            row += f"{val.write_source.name:^8}|"
            import numpy as np

            row += f"\t{RED}{np.base_repr(val.emulated_felt.value, base=36)}{RESET} {val.instruction.comment if val.instruction else ''}"

            print(row)

    def summarize(self):
        all_instructions = {
            item.instruction for item in self.segment.values() if item.instruction
        }
        all_assert_eq_instructions = set(self.assert_eq_instructions)

        all_instructions_except_assert_eq = (
            all_instructions - all_assert_eq_instructions
        )
        add_count: int = 0
        mul_count: int = 0
        for instruction in all_instructions_except_assert_eq:
            if instruction.operation.name == "ADD":
                add_count += 1
            elif instruction.operation.name == "MUL":
                mul_count += 1
        return add_count, mul_count, len(all_assert_eq_instructions)


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

    def __init__(
        self,
        name: str,
        curve_id: int,
        generic_circuit: bool = False,
        compilation_mode: int = 0,
    ) -> None:
        assert (
            len(name) <= 31
        ), f"Name '{name}' is too long to fit in a felt252, size is: {len(name)}"
        self.name = name
        self.class_name = "ModuloCircuit"
        self.curve_id = curve_id
        self.field = BaseField(CURVES[curve_id].p)
        self.N_LIMBS = 4
        self.values_segment: ValueSegment = ValueSegment(
            name=name, compilation_mode=compilation_mode
        )
        self.constants: dict[int, ModuloCircuitElement] = dict()
        self.generic_circuit = generic_circuit
        self.compilation_mode = compilation_mode
        self.exact_output_refs_needed = None
        self.input_structs: list[Cairo1SerializableStruct] = []

    @property
    def values_offset(self) -> int:
        return self.values_segment.offset

    @property
    def output(self) -> list[ModuloCircuitElement]:
        return self.values_segment.output

    @property
    def input(self) -> list[ModuloCircuitElement]:
        return self.values_segment.input

    @property
    def output_structs(self) -> list[Cairo1SerializableStruct]:
        return self.values_segment.output_structs

    @property
    def continuous_output(self) -> bool:
        return all(
            self.output[i + 1].offset - self.output[i].offset == N_LIMBS
            for i in range(len(self.output) - 1)
        )

    @property
    def witnesses(self) -> list[PyFelt]:
        return [
            self.values_segment.segment_stacks[WriteOps.WITNESS][offset].felt
            for offset in sorted(self.values_segment.segment_stacks[WriteOps.WITNESS])
        ]

    def is_empty_circuit(self) -> bool:
        return len(self.values_segment.segment_stacks[WriteOps.BUILTIN]) == 0

    def write_element(
        self,
        elmt: PyFelt,
        write_source: WriteOps = WriteOps.INPUT,
        instruction: ModuloCircuitInstruction | None = None,
    ) -> ModuloCircuitElement:
        assert isinstance(elmt, PyFelt), f"Expected PyFelt, got {type(elmt)}"
        value_offset = self.values_segment.write_to_segment(
            ValueSegmentItem(
                elmt,
                write_source,
                instruction,
            )
        )
        res = ModuloCircuitElement(elmt, value_offset)
        return res

    def write_struct(
        self,
        struct: Cairo1SerializableStruct,
        write_source: WriteOps = WriteOps.INPUT,
    ) -> Union[
        ModuloCircuitElement,
        List[ModuloCircuitElement],
        List[List[Union[ModuloCircuitElement, List[ModuloCircuitElement]]]],
    ]:
        all_pyfelt = all(type(elmt) == PyFelt for elmt in struct.elmts)
        all_cairo1serializablestruct = all(
            isinstance(elmt, Cairo1SerializableStruct) for elmt in struct.elmts
        )
        assert (
            all_pyfelt or all_cairo1serializablestruct
        ), f"Expected list of PyFelt or Cairo1SerializableStruct, got {[type(elmt) for elmt in struct.elmts]}"

        if all_pyfelt:
            self.input_structs.append(struct)
            if len(struct) == 1:
                return self.write_element(struct.elmts[0], write_source)
            else:
                return self.write_elements(struct.elmts, write_source)
        elif all_cairo1serializablestruct:
            result = [self.write_struct(elmt, write_source) for elmt in struct.elmts]
            # Ensure only the larger struct is appended
            self.input_structs = [
                s for s in self.input_structs if s not in struct.elmts
            ]
            self.input_structs.append(struct)
            return result

    def write_elements(
        self, elmts: list[PyFelt], operation: WriteOps, sparsity: list[int] = None
    ) -> list[ModuloCircuitElement]:
        if sparsity is not None:
            assert len(sparsity) == len(
                elmts
            ), f"Expected sparsity of length {len(elmts)}, got {len(sparsity)}"
            vals = [
                (
                    self.write_element(elmt, operation)
                    if sparsity[i] != 0
                    else self.set_or_get_constant(0)
                )
                for i, elmt in enumerate(elmts)
            ]
        else:
            vals = [self.write_element(elmt, operation, None) for elmt in elmts]
        return vals

    def write_cairo_native_felt(self, native_felt: PyFelt):
        assert type(native_felt) == PyFelt, f"Expected PyFelt, got {type(native_felt)}"
        assert 0 <= native_felt.value < STARK
        res = self.write_element(elmt=native_felt, write_source=WriteOps.FELT)
        return res

    def write_sparse_constant_elements(
        self, elmts: list[PyFelt]
    ) -> (list[ModuloCircuitElement], list[int]):
        sparsity = get_sparsity(elmts)
        elements = []
        for elmt, s in zip(elmts, sparsity):
            match s:
                case 0:
                    # Mocked 0 element. Be careful to pass sparsity when evaluating.
                    elements.append(ModuloCircuitElement(self.field.zero(), -1))
                case 2:
                    # Mocked 1 element. Be careful to pass sparsity when evaluating.
                    elements.append(ModuloCircuitElement(self.field.one(), -1))
                case _:
                    elements.append(self.set_or_get_constant(elmt.value))
        return elements, sparsity

    def set_or_get_constant(self, val: PyFelt | int) -> ModuloCircuitElement:
        if type(val) == int:
            val = self.field(val)
        if val.value in self.constants:
            # print((f"/!\ Constant '{hex(val.value)}' already exists."))
            return self.constants[val.value]
        self.constants[val.value] = self.write_element(val, WriteOps.CONSTANT)
        return self.constants[val.value]

    def add(
        self,
        a: ModuloCircuitElement,
        b: ModuloCircuitElement,
        comment: str | None = None,
    ) -> ModuloCircuitElement:
        if a is None and type(b) == ModuloCircuitElement:
            return b
        elif b is None and type(a) == ModuloCircuitElement:
            return a
        else:
            assert (
                type(a) == type(b) == ModuloCircuitElement
            ), f"Expected ModuloElement, got {type(a)}, {a} and {type(b)}, {b}"

            instruction = ModuloCircuitInstruction(
                ModBuiltinOps.ADD, a.offset, b.offset, self.values_offset, comment
            )
            return self.write_element(
                a.emulated_felt + b.emulated_felt, WriteOps.BUILTIN, instruction
            )

    def double(self, a: ModuloCircuitElement) -> ModuloCircuitElement:
        return self.add(a, a)

    def mul(
        self,
        a: ModuloCircuitElement,
        b: ModuloCircuitElement,
        comment: str | None = None,
    ) -> ModuloCircuitElement:
        if a is None and type(b) == ModuloCircuitElement:
            return self.set_or_get_constant(0)
        elif b is None and type(a) == ModuloCircuitElement:
            return self.set_or_get_constant(0)
        assert (
            type(a) == type(b) == ModuloCircuitElement
        ), f"Expected ModuloElement, got {type(a)}, {a} and {type(b)}, {b}"
        instruction = ModuloCircuitInstruction(
            ModBuiltinOps.MUL, a.offset, b.offset, self.values_offset, comment
        )
        return self.write_element(
            a.emulated_felt * b.emulated_felt, WriteOps.BUILTIN, instruction
        )

    def square(
        self, a: ModuloCircuitElement, comment: str | None = None
    ) -> ModuloCircuitElement:
        return self.mul(a, a, comment)

    def neg(
        self, a: ModuloCircuitElement, comment: str | None = None
    ) -> ModuloCircuitElement:
        assert (
            type(a) == ModuloCircuitElement
        ), f"Expected ModuloElement, got {type(a)}, {a}"
        res = self.sub(self.set_or_get_constant(self.field.zero()), a, comment)
        return res

    def sub(
        self,
        a: ModuloCircuitElement,
        b: ModuloCircuitElement,
        comment: str | None = None,
    ):
        assert (
            type(a) == type(b) == ModuloCircuitElement
        ), f"Expected ModuloElement, got {type(a)}, {a} and {type(b)}, {b}"
        instruction = ModuloCircuitInstruction(
            ModBuiltinOps.ADD, b.offset, self.values_offset, a.offset, comment
        )
        return self.write_element(a.felt - b.felt, WriteOps.BUILTIN, instruction)

    def inv(
        self,
        a: ModuloCircuitElement,
        comment: str | None = None,
    ):
        assert (
            type(a) == ModuloCircuitElement
        ), f"Expected ModuloElement, got {type(a)}, {a}"
        if self.compilation_mode == 0:
            one = self.set_or_get_constant(
                1
            )  # Write one before accessing its offset so self.values_offset is correctly updated.

            instruction = ModuloCircuitInstruction(
                ModBuiltinOps.MUL,
                a.offset,
                self.values_offset,
                one.offset,
                comment,
            )
        elif self.compilation_mode == 1:
            instruction = ModuloCircuitInstruction(
                ModBuiltinOps.MUL,
                a.offset,
                None,
                None,
                comment,
            )

        return self.write_element(a.felt.__inv__(), WriteOps.BUILTIN, instruction)

    def div(
        self,
        a: ModuloCircuitElement,
        b: ModuloCircuitElement,
        comment: str | None = None,
    ):
        assert (
            type(a) == type(b) == ModuloCircuitElement
        ), f"Expected ModuloElement, got {type(a)}, {a} and {type(b)}, {b}"
        if self.compilation_mode == 0:
            instruction = ModuloCircuitInstruction(
                ModBuiltinOps.MUL, b.offset, self.values_offset, a.offset, comment
            )
            return self.write_element(
                a.felt * b.felt.__inv__(), WriteOps.BUILTIN, instruction
            )
        else:
            return self.mul(a, self.inv(b))

    def fp2_mul(self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]):
        # Assumes the irreducible poly is X^2 + 1.
        assert len(X) == len(Y) == 2 and all(
            type(x) == type(y) == ModuloCircuitElement for x, y in zip(X, Y)
        )
        # xy = (x0 + i*x1) * (y0 + i*y1) = (x0*y0 - x1*y1) + i * (x0*y1 + x1*y0)
        return [
            self.sub(
                self.mul(X[0], Y[0], comment="Fp2 mul start"),
                self.mul(X[1], Y[1]),
                comment="Fp2 mul real part end",
            ),
            self.add(
                self.mul(X[0], Y[1]),
                self.mul(X[1], Y[0]),
                comment="Fp2 mul imag part end",
            ),
        ]

    def fp2_square(self, X: list[ModuloCircuitElement]):
        # Assumes the irreducible poly is X^2 + 1.
        # x² = (x0 + i x1)² = (x0² - x1²) + 2 * i * x0 * x1 = (x0+x1)(x0-x1) + i * 2 * x0 * x1.
        # (x0+x1)*(x0-x1) is cheaper than x0² - x1². (2 ADD + 1 MUL) vs (1 ADD + 2 MUL) (16 vs 20 steps)
        assert len(X) == 2 and all(type(x) == ModuloCircuitElement for x in X)
        return [
            self.mul(self.add(X[0], X[1]), self.sub(X[0], X[1])),
            self.double(self.mul(X[0], X[1])),
        ]

    def fp2_div(self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]):
        assert len(X) == len(Y) == 2 and all(
            type(x) == type(y) == ModuloCircuitElement for x, y in zip(X, Y)
        )
        if self.compilation_mode == 0:
            x_over_y = nondeterministic_extension_field_div(X, Y, self.curve_id, 2)
            x_over_y = self.write_elements(x_over_y, WriteOps.WITNESS)
            # x_over_y = d0 + i * d1
            # y = y0 + i * y1
            # x = x_over_y*y = d0*y0 - d1*y1 + i * (d0*y1 + d1*y0)
            self.sub_and_assert(
                a=self.mul(x_over_y[0], Y[0]), b=self.mul(x_over_y[1], Y[1]), c=X[0]
            )
            self.add_and_assert(
                a=self.mul(x_over_y[0], Y[1]), b=self.mul(x_over_y[1], Y[0]), c=X[1]
            )
            return x_over_y
        elif self.compilation_mode == 1:
            # Todo : consider passing as calldata if possible.
            t0 = self.mul(Y[0], Y[0], comment="Fp2 Div x/y start : Fp2 Inv y start")
            t1 = self.mul(Y[1], Y[1])
            t0 = self.add(t0, t1)
            t1 = self.inv(t0)
            inv0 = self.mul(Y[0], t1, comment="Fp2 Inv y real part end")
            inv1 = self.neg(self.mul(Y[1], t1), comment="Fp2 Inv y imag part end")
            return self.fp2_mul(X, [inv0, inv1])

    def sub_and_assert(
        self,
        a: ModuloCircuitElement,
        b: ModuloCircuitElement,
        c: ModuloCircuitElement,
        comment: str | None = None,
    ):
        """
        Subtracts b from a and asserts that the result is equal to c.
        In practice, it checks that c + b = a [mod p].
        All three values are expected to be already in the value segment, no new value is created.
        Costs 2 Steps.
        """
        instruction = ModuloCircuitInstruction(
            ModBuiltinOps.ADD, c.offset, b.offset, a.offset, comment
        )
        self.values_segment.assert_eq_instructions.append(instruction)
        return c

    def add_and_assert(
        self,
        a: ModuloCircuitElement,
        b: ModuloCircuitElement,
        c: ModuloCircuitElement,
        comment: str | None = None,
    ):
        """
        Adds a and b and asserts that the result is equal to c.
        In practice, it only checks that a + b = c [mod p].
        All three values are expected to be already in the value segment, no new value is created.
        Costs 2 Steps.
        """
        instruction = ModuloCircuitInstruction(
            ModBuiltinOps.ADD, a.offset, b.offset, c.offset, comment
        )
        self.values_segment.assert_eq_instructions.append(instruction)
        return c

    def eval_poly(
        self,
        poly: list[ModuloCircuitElement],
        X_powers: list[ModuloCircuitElement],
        poly_name: str = None,
        var_name: str = "x",
    ):
        """
        Evaluates a polynomial at precomputed powers of X.
        Assumes that the polynomial is in the form a0 + a1*x + a2*x^2 + ... + an*x^n, indexed with the constant coefficient first.
        Assumes that X_powers is a list of powers of X, such that X_powers[i] = X^(i+1).
        """
        if poly_name is None:
            poly_name = "UnnamedPoly"
        assert len(poly) - 1 <= len(
            X_powers
        ), f"Expected at least {len(poly) - 1} powers of X to evaluate P, got {len(X_powers)}"

        acc = poly[0]
        for i in range(1, len(poly)):
            acc = self.add(
                acc,
                self.mul(
                    poly[i],
                    X_powers[i - 1],
                    comment=f"Eval {poly_name} step coeff_{i} * {var_name}^{i}",
                ),
                comment=f"Eval {poly_name} step + (coeff_{i} * {var_name}^{i})",
            )
        return acc

    def extend_output(self, elmts: list[ModuloCircuitElement]):
        assert isinstance(elmts, (list, tuple))
        assert all(isinstance(x, ModuloCircuitElement) for x in elmts)
        self.output.extend(elmts)
        return

    def extend_struct_output(self, struct: Cairo1SerializableStruct):
        assert isinstance(struct, Cairo1SerializableStruct)
        if self.compilation_mode == 0:
            self.extend_output(struct.elmts)
        else:
            self.values_segment.output_structs.append(struct)
            self.extend_output(struct.elmts)
        return

    def print_value_segment(self):
        self.values_segment.print()

    def compile_circuit(self, function_name: str = None):
        if self.is_empty_circuit():
            return "", ""
        self.values_segment = self.values_segment.non_interactive_transform()
        if self.compilation_mode == 0:
            return self.compile_circuit_cairo_zero(function_name), None
        elif self.compilation_mode == 1:
            return self.compile_circuit_cairo_1(function_name)

    def compile_circuit_cairo_zero(
        self,
        function_name: str = None,
        returns: dict[str] = {
            "felt*": [
                "constants_ptr",
                "add_offsets_ptr",
                "mul_offsets_ptr",
                "output_offsets_ptr",
            ],
            "felt": [
                "constants_ptr_len",
                "input_len",
                "witnesses_len",
                "output_len",
                "continuous_output",
                "add_mod_n",
                "mul_mod_n",
                "n_assert_eq",
                "name",
                "curve_id",
            ],
        },
    ) -> str:
        dw_arrays = self.values_segment.get_dw_lookups()
        name = function_name or self.values_segment.name
        function_name = f"get_{name}_circuit"
        if self.generic_circuit:
            code = (
                f"func {function_name}(curve_id:felt)->(circuit:{self.class_name}*)"
                + "{"
                + "\n"
            )
        else:
            code = f"func {function_name}()->(circuit:{self.class_name}*)" + "{" + "\n"

        code += "alloc_locals;\n"
        code += "let (__fp__, _) = get_fp_and_pc();\n"

        for dw_array_name in returns["felt*"]:
            code += f"let ({dw_array_name}:felt*) = get_label_location({dw_array_name}_loc);\n"

        code += f"let constants_ptr_len = {len(dw_arrays['constants_ptr'])};\n"
        code += f"let input_len = {len(self.values_segment.segment_stacks[WriteOps.INPUT])*N_LIMBS};\n"
        code += f"let witnesses_len = {len(self.values_segment.segment_stacks[WriteOps.WITNESS])*N_LIMBS};\n"
        code += f"let output_len = {len(self.output)*N_LIMBS};\n"
        continuous_output = self.continuous_output
        code += f"let continuous_output = {1 if continuous_output else 0};\n"
        code += f"let add_mod_n = {len(dw_arrays['add_offsets_ptr'])};\n"
        code += f"let mul_mod_n = {len(dw_arrays['mul_offsets_ptr'])};\n"
        code += (
            f"let n_assert_eq = {len(self.values_segment.assert_eq_instructions)};\n"
        )
        code += f"let name = '{self.name}';\n"
        code += (
            f"let curve_id = {'curve_id' if self.generic_circuit else self.curve_id};\n"
        )

        code += f"local circuit:{self.class_name} = {self.class_name}({', '.join(returns['felt*'])}, {', '.join(returns['felt'])});\n"
        code += f"return (&circuit,);\n"

        for dw_array_name in returns["felt*"]:
            dw_values = dw_arrays[dw_array_name]
            code += f"\t {dw_array_name}_loc:\n"
            if dw_array_name == "constants_ptr":
                for bigint in dw_values:
                    for limb in bigint:
                        code += f"\t dw {limb};\n"
                code += "\n"

            elif dw_array_name in ["add_offsets_ptr", "mul_offsets_ptr"]:
                num_instructions = len(dw_values)
                instructions_needed = (
                    BATCH_SIZE - (num_instructions % BATCH_SIZE)
                ) % BATCH_SIZE  # Must be a multiple of 8 (currently)
                for left, right, result, comment in dw_values:
                    code += (
                        f"\t dw {left}; // {comment}\n"
                        + f"\t dw {right};\n"
                        + f"\t dw {result};\n"
                    )
                if instructions_needed > 0:
                    first_triplet = dw_values[0]
                    for _ in range(instructions_needed):
                        code += (
                            f"\t dw {first_triplet[0]};\n"
                            + f"\t dw {first_triplet[1]};\n"
                            + f"\t dw {first_triplet[2]};\n"
                        )
                code += "\n"
            elif dw_array_name in ["output_offsets_ptr"]:
                if continuous_output:
                    code += f"\t dw {dw_values[0]};\n"
                else:
                    for val in dw_values:
                        code += f"\t dw {val};\n"

        code += "\n"
        code += "}\n"
        return code

    def write_cairo1_input_stack(
        self,
        write_ops: WriteOps,
        code: str,
        offset_to_reference_map: dict[int, str],
        start_index: int,
    ) -> tuple:
        len_stack = len(self.values_segment.segment_stacks[write_ops])
        if len_stack > 0:
            code += f"\n // {write_ops.name} stack\n"
            offsets = list(self.values_segment.segment_stacks[write_ops].keys())
            i = 0
            while i < len_stack:
                if write_ops == WriteOps.CONSTANT:
                    val = self.values_segment.segment[offsets[i]].value
                    if 0 < -val % self.field.p <= 100:
                        comment = f"// -{hex(-val%self.field.p)} % p"
                    else:
                        comment = f"// {hex(val)}"
                    code += f"\t let in{start_index+i} = CE::<CI<{start_index+i}>> {{}}; {comment}\n"
                    offset_to_reference_map[offsets[i]] = f"in{start_index+i}"
                    i += 1
                else:
                    if i + 2 < len_stack:
                        code += f"\t let (in{start_index+i}, in{start_index+i+1}, in{start_index+i+2}) = (CE::<CI<{start_index+i}>> {{}}, CE::<CI<{start_index+i+1}>> {{}}, CE::<CI<{start_index+i+2}>> {{}});\n"
                        offset_to_reference_map[offsets[i]] = f"in{start_index+i}"
                        offset_to_reference_map[offsets[i + 1]] = f"in{start_index+i+1}"
                        offset_to_reference_map[offsets[i + 2]] = f"in{start_index+i+2}"
                        i += 3
                    elif i + 1 < len_stack:
                        code += f"\t let (in{start_index+i}, in{start_index+i+1}) = (CE::<CI<{start_index+i}>> {{}}, CE::<CI<{start_index+i+1}>> {{}});\n"
                        offset_to_reference_map[offsets[i]] = f"in{start_index+i}"
                        offset_to_reference_map[offsets[i + 1]] = f"in{start_index+i+1}"
                        i += 2
                    else:
                        code += f"\t let in{start_index+i} = CE::<CI<{start_index+i}>> {{}};\n"
                        offset_to_reference_map[offsets[i]] = f"in{start_index+i}"
                        i += 1
            return (
                code,
                offset_to_reference_map,
                start_index + len_stack,
            )
        else:
            return code, offset_to_reference_map, start_index

    def fill_cairo_1_constants(self) -> str:
        constants_ints = [
            self.values_segment.segment[offset].value
            for offset in self.values_segment.segment_stacks[WriteOps.CONSTANT].keys()
        ]
        if len(constants_ints) < 8:
            constants_split = [bigint_split(x, N_LIMBS, BASE) for x in constants_ints]
            constants_filled = "\n".join(
                f"circuit_inputs = circuit_inputs.next_2([{','.join(hex(x) for x in constants_split[i])}]); // in{i}"
                for i in range(len(constants_ints))
            )
            return constants_filled, None
        else:
            import garaga.hints.io as io

            const_name = (
                self.name.upper()
                + "_"
                + CurveID(self.curve_id).name.upper()
                + "_CONSTANTS"
            )
            constants_filled = f"""
            circuit_inputs = circuit_inputs.next_span({const_name}.span()); // in{0} - in{len(constants_ints)-1}
            """

            const_array = f"const {const_name}: [u384; {len(constants_ints)}] = {io.int_array_to_u384_array(constants_ints, const=True)};"
        return constants_filled, const_array

    def write_cairo1_circuit(self, offset_to_reference_map: dict[int, str]) -> str:
        code = ""
        for i, (offset, vs_item) in enumerate(
            self.values_segment.segment_stacks[WriteOps.BUILTIN].items()
        ):
            op = vs_item.instruction.operation
            left_offset = vs_item.instruction.left_offset
            right_offset = vs_item.instruction.right_offset
            result_offset = vs_item.instruction.result_offset
            comment = vs_item.instruction.comment or ""

            # print(i, op, left_offset, right_offset, result_offset)
            match op:
                case ModBuiltinOps.ADD:
                    if right_offset > result_offset:
                        # Case sub
                        code += f"let t{i} = circuit_sub({offset_to_reference_map[result_offset]}, {offset_to_reference_map[left_offset]}); {'// '+comment if comment else ''}\n"
                        offset_to_reference_map[offset] = f"t{i}"
                        assert offset == right_offset
                    else:
                        code += f"let t{i} = circuit_add({offset_to_reference_map[left_offset]}, {offset_to_reference_map[right_offset]}); {'// '+comment if comment else ''}\n"
                        offset_to_reference_map[offset] = f"t{i}"
                        assert offset == result_offset

                case ModBuiltinOps.MUL:
                    if right_offset == result_offset == offset:
                        # Case inv
                        # print(f"\t INV {left_offset} {right_offset} {result_offset}")
                        code += f"let t{i} = circuit_inverse({offset_to_reference_map[left_offset]}); {'// '+comment if comment else ''}\n"
                        offset_to_reference_map[offset] = f"t{i}"
                    else:
                        # print(f"MUL {left_offset} {right_offset} {result_offset}")
                        code += f"let t{i} = circuit_mul({offset_to_reference_map[left_offset]}, {offset_to_reference_map[right_offset]}); {'// '+comment if comment else ''}\n"
                        offset_to_reference_map[offset] = f"t{i}"
                        assert offset == result_offset
        return code

    def compile_circuit_cairo_1(
        self,
        function_name: str = None,
    ) -> str:
        name = function_name or self.values_segment.name
        function_name = f"run_{name}_circuit"
        curve_index = CurveID.find_value_in_string(name)
        return_is_struct = False
        input_is_struct = False
        if self.output_structs:
            if sum([len(x.elmts) for x in self.output_structs]) == len(self.output):
                return_is_struct = True
                signature_output = (
                    f"({','.join([x.struct_name for x in self.output_structs])}"
                )

                signature_output += ",)" if len(self.output_structs) == 1 else ")"
            else:
                raise ValueError(
                    f"Output structs must have the same number of elements as the output: {len(self.output_structs)=} != {len(self.output)=}"
                )
        else:
            signature_output = f"Array<u384>"

        if self.input_structs:
            if sum([len(x) for x in self.input_structs]) == len(self.input):
                input_is_struct = True
                signature_input = f"{','.join([x.serialize_input_signature() for x in self.input_structs])}"
            else:
                raise ValueError(
                    f"Input structs must have the same number of elements as the input: {sum([len(x) for x in self.input_structs])=} != {len(self.input)=}"
                )
        else:
            signature_input = f"mut input: Array<u384>"

        if self.generic_circuit:
            code = f"fn {function_name}({signature_input}, curve_index:usize)->{signature_output} {{\n"
        else:
            code = f"fn {function_name}({signature_input})->{signature_output} {{\n"

        code, offset_to_reference_map, start_index = self.write_cairo1_input_stack(
            WriteOps.CONSTANT, code, {}, 0
        )
        (
            code,
            offset_to_reference_map,
            commit_start_index,
        ) = self.write_cairo1_input_stack(
            WriteOps.INPUT, code, offset_to_reference_map, start_index
        )
        code, offset_to_reference_map, commit_end_index = self.write_cairo1_input_stack(
            WriteOps.COMMIT, code, offset_to_reference_map, commit_start_index
        )
        code, offset_to_reference_map, start_index = self.write_cairo1_input_stack(
            WriteOps.WITNESS, code, offset_to_reference_map, commit_end_index
        )
        code, offset_to_reference_map, start_index = self.write_cairo1_input_stack(
            WriteOps.FELT, code, offset_to_reference_map, start_index
        )

        code += self.write_cairo1_circuit(offset_to_reference_map)

        outputs_refs = []
        for out in self.output:
            if self.values_segment[out.offset].write_source == WriteOps.BUILTIN:
                outputs_refs.append(offset_to_reference_map[out.offset])
            else:
                continue
        if self.exact_output_refs_needed:
            outputs_refs_needed = [
                offset_to_reference_map[out.offset]
                for out in self.exact_output_refs_needed
            ]
        else:
            outputs_refs_needed = outputs_refs

        if curve_index is not None:
            code += f"""
    let modulus = TryInto::<_, CircuitModulus>::try_into([{','.join([hex(limb) for limb in bigint_split(self.field.p, N_LIMBS, BASE)])}])
        .unwrap(); // {CurveID(self.curve_id).name} prime field modulus
        """
        else:
            code += f"""
    let modulus = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([modulus.limb0, modulus.limb1, modulus.limb2, modulus.limb3])
        .unwrap();
        """

        code += f"""
    let mut circuit_inputs = ({','.join(outputs_refs_needed)},).new_inputs();
    // Prefill constants:
    """

        tmp, const_array = self.fill_cairo_1_constants()
        code += tmp
        code += """
        // Fill inputs:
        """

        acc_len = len(self.values_segment.segment_stacks[WriteOps.CONSTANT])
        if input_is_struct:
            for struct in self.input_structs:
                struct_code = struct.dump_to_circuit_input()
                struct_code_lines = [
                    line for line in struct_code.split("\n") if line.strip()
                ]
                if "while let" not in struct_code:
                    struct_code_with_counter = "\n".join(
                        f"{line} // in{i+acc_len}"
                        for i, line in enumerate(struct_code_lines)
                    )
                else:
                    struct_code_with_counter = (
                        struct_code + f" // in{acc_len} - in{acc_len+len(struct)-1}"
                    )
                acc_len += len(struct)
                code += struct_code_with_counter + "\n"
        else:
            code += f"""
    let mut input = input;
    while let Option::Some(val) = input.pop_front() {{
        circuit_inputs = circuit_inputs.next(val);
    }};
    """
        code += f"""
        let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
"""
        if return_is_struct:
            code += "\n".join(
                [
                    struct.extract_from_circuit_output(offset_to_reference_map)
                    for struct in self.output_structs
                ]
            )
            code += (
                f"return ({','.join([struct.name for struct in self.output_structs])}"
            )
            code += ",);\n}" if len(self.output_structs) == 1 else ");\n}"
        else:
            code += f"let res=array![{','.join([f'outputs.get_output({ref})' for ref in outputs_refs])}];\n"
            code += "return res;\n"
            code += "}\n"

        if const_array:
            code += "\n"
            code += const_array
        return code, function_name

    def summarize(self):
        add_count, mul_count, assert_eq_count = self.values_segment.summarize()
        summary = {
            "circuit": self.name,
            "MULMOD": mul_count,
            "ADDMOD": add_count,
            "ASSERT_EQ": assert_eq_count,
            "POSEIDON": 0,
            "RLC": 0,
        }

        return summary


if __name__ == "__main__":
    from garaga.algebra import BaseField

    field = BaseField(256)
    circuit = ModuloCircuit("test_circuit", 0)
    a = circuit.write_element(field(1))
    b = circuit.write_element(field(2))
    c = circuit.add(a, b)
    d = circuit.mul(c, b)

    print(c)

    print(d)

    circuit = ModuloCircuit("test_empty_circuit", curve_id=0, compilation_mode=1)
    print(circuit.compile_circuit())
