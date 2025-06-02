from dataclasses import dataclass, field
from enum import Enum, auto
from typing import List, Union

from garaga.algebra import BaseField, ModuloCircuitElement, PyFelt
from garaga.definitions import BASE, CURVES, N_LIMBS, STARK, CurveID, get_sparsity
from garaga.hints.io import bigint_split
from garaga.modulo_circuit_structs import (
    Cairo1SerializableStruct,
    GenericT,
    u128,
    u256,
    u384,
)

BATCH_SIZE = 1  # Batch Size, only used in cairo 0 mode.


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
        """
        Returns the DW arrays for the compiled circuit.
        Only relevant in Cairo 0 mode.
        """
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
        generic_modulus: bool = False,
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
        self.generic_modulus = (
            generic_modulus  # Generic modulus has precedence over generic_circuit
        )
        self.compilation_mode = compilation_mode
        self.exact_output_refs_needed = None
        self.input_structs: list[Cairo1SerializableStruct] = []
        self.do_not_inline = False

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
        # Only useful in cairo 0 mode.
        return all(
            self.output[i + 1].offset - self.output[i].offset == N_LIMBS
            for i in range(len(self.output) - 1)
        )

    @property
    def witnesses(self) -> list[PyFelt]:
        # Only useful in cairo 0 mode.
        return [
            self.values_segment.segment_stacks[WriteOps.WITNESS][offset].felt
            for offset in sorted(self.values_segment.segment_stacks[WriteOps.WITNESS])
        ]

    def is_empty_circuit(self) -> bool:
        return len(self.values_segment.segment_stacks[WriteOps.BUILTIN]) == 0

    def write_element(
        self,
        elmt: PyFelt | int,
        write_source: WriteOps = WriteOps.INPUT,
        instruction: ModuloCircuitInstruction | None = None,
    ) -> ModuloCircuitElement:
        """
        Register an emulated field element to the circuit given its value and the write source.
        Returns a ModuloCircuitElement representing the written element with its offset as identifier.
        """
        assert isinstance(elmt, PyFelt) or isinstance(
            elmt, int
        ), f"Expected PyFelt or int, got {type(elmt)}"
        if isinstance(elmt, int):
            elmt = self.field(elmt)
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
            if len(struct) == 1 and isinstance(struct, (u384, u256, u128, GenericT)):
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
        self,
        elmts: list[PyFelt],
        operation: WriteOps = WriteOps.INPUT,
        sparsity: list[int] = None,
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
        assert (
            self.compilation_mode == 0
        ), "write_cairo_native_felt is not supported in cairo 1 mode"
        assert isinstance(
            native_felt, PyFelt
        ), f"Expected PyFelt, got {type(native_felt)}"
        assert 0 <= native_felt.value < STARK
        res = self.write_element(elmt=native_felt, write_source=WriteOps.FELT)
        return res

    def write_sparse_constant_elements(
        self, elmts: list[PyFelt]
    ) -> tuple[list[ModuloCircuitElement], list[int]]:
        sparsity = get_sparsity(elmts)
        elements = []
        for elmt, s in zip(elmts, sparsity):
            match s:
                case 0:
                    # Mocked 0 element not written to the circuit. Be careful to pass sparsity when evaluating.
                    elements.append(ModuloCircuitElement(self.field.zero(), -1))
                case 2:
                    # Mocked 1 element not written to the circuit. Be careful to pass sparsity when evaluating.
                    elements.append(ModuloCircuitElement(self.field.one(), -1))
                case _:
                    elements.append(self.set_or_get_constant(elmt.value))
        return elements, sparsity

    def set_or_get_constant(self, val: PyFelt | int) -> ModuloCircuitElement:
        if isinstance(val, int):
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
        if a is None and isinstance(b, ModuloCircuitElement):
            return b
        elif b is None and isinstance(a, ModuloCircuitElement):
            return a
        else:
            assert isinstance(a, ModuloCircuitElement) and isinstance(
                b, ModuloCircuitElement
            ), f"Expected ModuloElement, got {type(a)}, {a} and {type(b)}, {b}"

            instruction = ModuloCircuitInstruction(
                ModBuiltinOps.ADD, a.offset, b.offset, self.values_offset, comment
            )
            return self.write_element(
                a.emulated_felt + b.emulated_felt, WriteOps.BUILTIN, instruction
            )

    def sum(self, args: list[ModuloCircuitElement], comment: str | None = None):
        if not args:
            raise ValueError("The 'args' list cannot be empty.")
        assert all(isinstance(elmt, ModuloCircuitElement) for elmt in args)
        result = args[0]
        for elmt in args[1:]:
            result = self.add(result, elmt, comment)
        return result

    def product(self, args: list[ModuloCircuitElement], comment: str | None = None):
        if not args:
            raise ValueError("The 'args' list cannot be empty.")
        assert all(isinstance(elmt, ModuloCircuitElement) for elmt in args)
        result = args[0]
        for elmt in args[1:]:
            result = self.mul(result, elmt, comment)
        return result

    def double(self, a: ModuloCircuitElement) -> ModuloCircuitElement:
        return self.add(a, a)

    def mul(
        self,
        a: ModuloCircuitElement,
        b: ModuloCircuitElement,
        comment: str | None = None,
    ) -> ModuloCircuitElement:
        if a is None and isinstance(b, ModuloCircuitElement):
            return self.set_or_get_constant(0)
        elif b is None and isinstance(a, ModuloCircuitElement):
            return self.set_or_get_constant(0)
        assert isinstance(a, ModuloCircuitElement) and isinstance(
            b, ModuloCircuitElement
        ), f"Expected ModuloElement, got lhs {type(a)}, {a} and rhs {type(b)}, {b}"
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
        assert isinstance(a, ModuloCircuitElement) and isinstance(
            b, ModuloCircuitElement
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
        assert isinstance(
            a, ModuloCircuitElement
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
        assert isinstance(a, ModuloCircuitElement) and isinstance(
            b, ModuloCircuitElement
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

    def fp_sqrt(self, element: ModuloCircuitElement) -> ModuloCircuitElement:
        """
        Computes "a" square root of a field element.
        /!\ Warning : This circuit is non deterministic /!\
        /!\ Two square roots exist for any non-zero element, and no constraint is enforced to select any of them /!\
        Raises ValueError if the element is not a quadratic residue.
        """
        assert self.compilation_mode == 0, "fp_sqrt is not supported in cairo 1 mode"

        root = element.felt.sqrt(min_root=False)

        # Write the root as a witness and verify it
        root = self.write_element(root, WriteOps.WITNESS)
        self.mul_and_assert(root, root, element, comment="Fp sqrt")
        return root

    def fp_is_non_zero(self, a: ModuloCircuitElement) -> ModuloCircuitElement:
        """
        Returns 1 if a != 0, 0 if a == 0.
        Enforces soundness by forcing `flag` to be a true indicator of whether 'a' is non-zero.

        Main Constraints:
        1) flag * (1 - flag) = 0
           - Ensures that `flag` ∈ {0,1}, i.e., it's a binary indicator.
        2) Prover supplies a_inv as a “would-be” inverse of `a`.
           - If a != 0, a_inv should be the genuine inverse, i.e. a * a_inv = 1.
           - If a == 0, a_inv is irrelevant and effectively ignored.
        3) flag*(a * a_inv) + (1 - flag)*(a + 1) == 1
           - If a == 0 → the only way is flag=0, so:
                 0 * (0 * a_inv) + 1 * (0 + 1) = 1
             which is satisfied.
           - If a != 0 → the only way is flag=1, so:
                 1 * (a * a_inv) + 0 * (a + 1) = 1
             forcing a_inv to be a true inverse of a.

        Consequently:
          • When a == 0, the circuit forces flag=0 and ignores a_inv.
          • When a != 0, the circuit forces flag=1 and requires a_inv to be the correct inverse.

        Overall, this design prevents cheating (e.g. claiming a != 0 when it's actually 0, or supplying a bogus inverse) because the single equation in step (3) couples a, a_inv, and flag in a way that only the correct assignments can satisfy all constraints.
        """

        assert (
            self.compilation_mode == 0
        ), "`fp_is_non_zero_flag` is only supported in cairo 0 mode."

        # Step 1: Prover declares a boolean-labeled witness: 1 if a != 0, else 0
        is_non_zero_python_bool = int(a.value != 0)
        flag = self.write_element(is_non_zero_python_bool, WriteOps.WITNESS)

        # Step 2: Force the flag to be a single bit: flag * (1 - flag) == 0

        one_minus_flag = self.sub(self.set_or_get_constant(1), flag)
        self.mul_and_assert(
            flag,
            one_minus_flag,
            self.set_or_get_constant(0),
            comment="flag ∈ {0,1}",
        )

        # Step 3: The prover supplies a_inv as a witness.
        #          If flag=1 (a != 0), a_inv must be the real inverse: a*a_inv = 1.
        #          If flag=0 (a == 0), a_inv is irrelevant.
        a_inv_val = 0
        if is_non_zero_python_bool:
            a_inv_val = a.felt.__inv__().value
        a_inv = self.write_element(a_inv_val, WriteOps.WITNESS)

        # Step 4: Combine them with the core check:
        #         flag*(a*a_inv) + (1 - flag)*(a+1) == 1
        #         => forces correct assignments for (flag, a_inv)
        flag_eq_0_branch = self.add(a, self.set_or_get_constant(1))
        flag_eq_1_branch = self.mul(a, a_inv)

        self.add_and_assert(
            self.mul(flag, flag_eq_1_branch),
            self.mul(one_minus_flag, flag_eq_0_branch),
            self.set_or_get_constant(1),
        )

        # Return the final flag: 1 if a != 0, 0 if a == 0
        return flag

    def vector_sub(
        self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]
    ) -> list[ModuloCircuitElement]:
        return [
            self.sub(x, y, comment=f"Fp{len(X)} sub coeff {i}/{len(X)-1}")
            for i, (x, y) in enumerate(zip(X, Y))
        ]

    def vector_scale(
        self, X: list[ModuloCircuitElement], c: ModuloCircuitElement
    ) -> list[ModuloCircuitElement]:
        """
        Multiplies a polynomial with coefficients `X` by a scalar `c`.
        Input : I(x) = i0 + i1*x + i2*x^2 + ... + in-1*x^n-1
        Output : O(x) = ci0 + ci1*x + ci2*x^2 + ... + cin-1*x^n-1.
        This is done in the circuit.
        """
        assert isinstance(c, ModuloCircuitElement), "c must be a ModuloCircuitElement"
        return [
            self.mul(x_i, c, comment=f"Fp{len(X)} scalar mul coeff {i}/{len(X)-1}")
            for i, x_i in enumerate(X)
        ]

    def vector_add(
        self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]
    ) -> list[ModuloCircuitElement]:
        """
        Adds two polynomials with coefficients `X` and `Y`.
        Returns R = [x0 + y0, x1 + y1, x2 + y2, ... + xn-1 + yn-1] mod p
        """
        assert len(X) == len(Y), f"len(X)={len(X)} != len(Y)={len(Y)}"
        return [
            self.add(x_i, y_i, comment=f"Fp{len(X)} add coeff {i}/{len(X)-1}")
            for i, (x_i, y_i) in enumerate(zip(X, Y))
        ]

    def vector_neg(self, X: list[ModuloCircuitElement]) -> list[ModuloCircuitElement]:
        """
        Negates a polynomial with coefficients `X`.
        Returns R = [-x0, -x1, -x2, ... -xn-1] mod p
        """
        return [
            self.neg(x_i, comment=f"Fp{len(X)} neg coeff {i}/{len(X)-1}")
            for i, x_i in enumerate(X)
        ]

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
        assert (
            self.compilation_mode == 0
        ), "sub_and_assert is not supported in cairo 1 mode"
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
        assert (
            self.compilation_mode == 0
        ), "add_and_assert is not supported in cairo 1 mode"
        instruction = ModuloCircuitInstruction(
            ModBuiltinOps.ADD, a.offset, b.offset, c.offset, comment
        )
        self.values_segment.assert_eq_instructions.append(instruction)
        return c

    def mul_and_assert(
        self,
        a: ModuloCircuitElement,
        b: ModuloCircuitElement,
        c: ModuloCircuitElement,
        comment: str | None = None,
    ):
        assert (
            self.compilation_mode == 0
        ), "mul_and_assert is not supported in cairo 1 mode"

        instruction = ModuloCircuitInstruction(
            ModBuiltinOps.MUL, a.offset, b.offset, c.offset, comment
        )
        self.values_segment.assert_eq_instructions.append(instruction)
        return c

    def eval_horner(
        self,
        poly: list[ModuloCircuitElement],
        z: ModuloCircuitElement,
        poly_name: str = None,
        var_name: str = "z",
    ):
        """
        Evaluates a polynomial at point z using Horner's method.
        Assumes that the polynomial is in the form a0 + a1*z + a2*z^2 + ... + an*z^n, indexed with the constant coefficient first.
        """
        if poly_name is None:
            poly_name = "UnnamedPoly"

        # Regular Horner evaluation
        acc = poly[-1]  # Start with the highest degree coefficient
        for i in range(len(poly) - 2, -1, -1):
            acc = self.add(
                poly[i],
                self.mul(
                    acc,
                    z,
                    comment=f"Eval {poly_name} Horner step: multiply by {var_name}",
                ),
                comment=f"Eval {poly_name} Horner step: add coefficient_{i}",
            )

        return acc

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
        """
        Adds elements to the output of the circuit.
        """
        assert isinstance(elmts, (list, tuple))
        assert all(isinstance(x, ModuloCircuitElement) for x in elmts)
        self.output.extend(elmts)
        return

    def extend_struct_output(self, struct: Cairo1SerializableStruct):
        """
        Adds elements to the output of the circuit in struct form.
        """
        assert isinstance(struct, Cairo1SerializableStruct)
        if self.compilation_mode == 0:
            self.extend_output(struct.elmts)
        else:
            self.values_segment.output_structs.append(struct)
            self.extend_output(struct.elmts)
        return

    def print_value_segment(self):
        self.values_segment.print()

    def compile_circuit(
        self,
        function_name: str = None,
        pub: bool = True,
        inline: bool = True,
        generic_modulus: bool = False,
    ):
        if self.is_empty_circuit():
            return "", ""
        self.values_segment = self.values_segment.non_interactive_transform()
        if self.compilation_mode == 0:
            return self.compile_circuit_cairo_zero(function_name), None
        elif self.compilation_mode == 1:
            return self.compile_circuit_cairo_1(
                function_name, pub, inline, generic_modulus
            )

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
        code += "return (&circuit,);\n"

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
        """
        Defines the inputs for the compiled Cairo 1 circuit.
        """
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

    def fill_cairo_1_constants(self) -> tuple[str, str]:
        """
        Return the part of the code that fills the constants to the circuit, and the constants array
        if there are more than 8 constants. In that case, .next_span() is used to save bytecode and
        the constants are stored in a const array.
        """
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
        """
        Defines the arithmetic instructions for the compiled Cairo 1 circuit.
        """
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
        pub: bool = False,
        inline: bool = True,
        generic_modulus: bool = False,
    ) -> tuple[str, str]:
        """
        Defines the Cairo 1 function code for the compiled circuit.
        """
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
            signature_output = "Array<u384>"

        if self.input_structs:
            if sum([len(x) for x in self.input_structs]) == len(self.input):
                input_is_struct = True
                signature_input = f"{','.join([x.serialize_input_signature() for x in self.input_structs])}"
            else:
                raise ValueError(
                    f"Input structs must have the same number of elements as the input: {sum([len(x) for x in self.input_structs])=} != {len(self.input)=}"
                )
        else:
            signature_input = "mut input: Array<u384>"
        if "<T>" in signature_input or ":T," in signature_input:
            generic_input = "<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>"
        else:
            generic_input = ""
        if pub:
            prefix = "pub "
        else:
            prefix = ""
        if inline:
            if generic_input == "":
                attribute = "#[inline(always)]"
            else:
                attribute = "#[inline]"
        else:
            attribute = ""
        generic_modulus = generic_modulus or self.generic_modulus
        if generic_modulus:
            code = f"{attribute}\n{prefix}fn {function_name}{generic_input}({signature_input}, modulus:CircuitModulus)->{signature_output} {{\n"
        elif self.generic_circuit:
            code = f"{attribute}\n{prefix}fn {function_name}{generic_input}({signature_input}, curve_index:usize)->{signature_output} {{\n"
        else:
            code = f"{attribute}\n{prefix}fn {function_name}{generic_input}({signature_input})->{signature_output} {{\n"

        # Define the input for the circuit.
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

        if generic_modulus:
            code += "\nlet modulus = modulus;\n"
        elif curve_index is not None:
            code += f"""
    let modulus = get_{CurveID(self.curve_id).name}_modulus(); // {CurveID(self.curve_id).name} prime field modulus
        """
        else:
            code += """
    let modulus = get_modulus(curve_index);
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
                if "while let" not in struct_code and "for val in" not in struct_code:
                    struct_code_with_counter = "\n".join(
                        f"{line} // in{i+acc_len}"
                        for i, line in enumerate(struct_code_lines)
                    )
                else:
                    struct_code_with_counter = (
                        struct_code + f" // in{acc_len} - in{acc_len+len(struct)-1}\n"
                    )
                acc_len += len(struct)
                code += struct_code_with_counter + "\n"
        else:
            code += """
    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };
    """
        code += """
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
            # Add the constants outside of the function if they are more than 8.
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
