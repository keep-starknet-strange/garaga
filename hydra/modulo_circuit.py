from hydra.algebra import PyFelt, ModuloCircuitElement, BaseField
from hydra.hints.io import bigint_split
from hydra.hints.extf_mul import nondeterministic_extension_field_div
from hydra.definitions import STARK, CURVES, N_LIMBS, BASE
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

    def __init__(self, name: str, debug: bool = False):
        self.segment: dict[int, ValueSegmentItem] = dict()
        self.assert_eq_instructions: list[ModuloCircuitInstruction] = []
        self.output: list[ModuloCircuitElement] = []
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
                )
            )
        new_output = []
        for elmt in self.output:
            new_output.append(ModuloCircuitElement(elmt.felt, offset_map[elmt.offset]))
        res.output = new_output
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
            row += f"\t{RED}{val.emulated_felt.value}{RESET}"

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

    def __init__(self, name: str, curve_id: int, generic_circuit: bool = False) -> None:
        assert len(name) <= 31, f"Name '{name}' is too long to fit in a felt252."
        self.name = name
        self.class_name = "ModuloCircuit"
        self.curve_id = curve_id
        self.field = BaseField(CURVES[curve_id].p)
        self.N_LIMBS = 4
        self.values_segment: ValueSegment = ValueSegment(name)
        self.constants: dict[int, ModuloCircuitElement] = dict()
        self.generic_circuit = generic_circuit

        self.set_or_get_constant(self.field.zero())
        self.set_or_get_constant(self.field.one())
        # self.set_or_get_constant(self.field(-1))

    @property
    def values_offset(self) -> int:
        return self.values_segment.offset

    @property
    def output(self) -> list[ModuloCircuitElement]:
        return self.values_segment.output

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
        self, elmts: list[PyFelt], operation: WriteOps, sparsity: list[int] = None
    ) -> list[ModuloCircuitElement]:
        if sparsity is not None:
            vals = [
                (
                    self.write_element(elmt, operation)
                    if sparsity[i] != 0
                    else self.get_constant(0)
                )
                for i, elmt in enumerate(elmts)
            ]
        else:
            vals = [self.write_element(elmt, operation, None) for elmt in elmts]
        return vals

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

    def set_or_get_constant(self, val: PyFelt) -> None:
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

    def add(
        self,
        a: ModuloCircuitElement,
        b: ModuloCircuitElement,
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

    def double(self, a: ModuloCircuitElement) -> ModuloCircuitElement:
        return self.add(a, a)

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
        return self.write_element(a.felt - b.felt, WriteOps.BUILTIN, instruction)

    def inv(self, a: ModuloCircuitElement):
        instruction = ModuloCircuitInstruction(
            ModBuiltinOps.MUL, a.offset, self.values_offset, self.get_constant(1).offset
        )
        return self.write_element(a.felt.__inv__(), WriteOps.BUILTIN, instruction)

    def div(self, a: ModuloCircuitElement, b: ModuloCircuitElement):
        instruction = ModuloCircuitInstruction(
            ModBuiltinOps.MUL, b.offset, self.values_offset, a.offset
        )
        return self.write_element(
            a.felt * b.felt.__inv__(), WriteOps.BUILTIN, instruction
        )

    def fp2_mul(self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]):
        assert len(X) == len(Y) == 2
        # xy = (x0 + i*x1) * (y0 + i*y1) = (x0*y0 - x1*y1) + i * (x0*y1 + x1*y0)
        return [
            self.sub(self.mul(X[0], Y[0]), self.mul(X[1], Y[1])),
            self.add(self.mul(X[0], Y[1]), self.mul(X[1], Y[0])),
        ]

    def fp2_square(self, X: list[ModuloCircuitElement]):
        # x² = (x0 + i x1)² = (x0² - x1²) + 2 * i * x0 * x1 = (x0+x1)(x0-x1) + i * 2 * x0 * x1.
        # (x0+x1)*(x0-x1) is cheaper than x0² - x1². (2 ADD + 1 MUL) vs (1 ADD + 2 MUL) (16 vs 20 steps)
        return [
            self.mul(self.add(X[0], X[1]), self.sub(X[0], X[1])),
            self.double(self.mul(X[0], X[1])),
        ]

    def fp2_div(self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]):
        assert len(X) == len(Y) == 2
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

    def sub_and_assert(
        self, a: ModuloCircuitElement, b: ModuloCircuitElement, c: ModuloCircuitElement
    ):
        """
        Subtracts b from a and asserts that the result is equal to c.
        In practice, it checks that c + b = a [mod p].
        All three values are expected to be already in the value segment, no new value is created.
        Costs 2 Steps.
        """
        instruction = ModuloCircuitInstruction(
            ModBuiltinOps.ADD, c.offset, b.offset, a.offset
        )
        self.values_segment.assert_eq_instructions.append(instruction)
        return c

    def add_and_assert(
        self, a: ModuloCircuitElement, b: ModuloCircuitElement, c: ModuloCircuitElement
    ):
        """
        Adds a and b and asserts that the result is equal to c.
        In practice, it only checks that a + b = c [mod p].
        All three values are expected to be already in the value segment, no new value is created.
        Costs 2 Steps.
        """
        instruction = ModuloCircuitInstruction(
            ModBuiltinOps.ADD, a.offset, b.offset, c.offset
        )
        self.values_segment.assert_eq_instructions.append(instruction)
        return c

    def eval_poly(
        self, poly: list[ModuloCircuitElement], X_powers: list[ModuloCircuitElement]
    ):
        """
        Evaluates a polynomial at precomputed powers of X.
        Assumes that the polynomial is in the form a0 + a1*x + a2*x^2 + ... + an*x^n, indexed with the constant coefficient first.
        Assumes that X_powers is a list of powers of X, such that X_powers[i] = X^(i+1).
        """
        assert len(poly) - 1 <= len(
            X_powers
        ), f"Expected at least {len(poly) - 1} powers of X to evaluate P, got {len(X_powers)}"

        acc = poly[0]
        for i in range(1, len(poly)):
            acc = self.add(acc, self.mul(poly[i], X_powers[i - 1]))
        return acc

    def extend_output(self, elmts: list[ModuloCircuitElement]):
        self.output.extend(elmts)
        return

    def print_value_segment(self):
        self.values_segment.print()

    def compile_circuit(
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
                    8 - (num_instructions % 8)
                ) % 8  # Must be a multiple of 8 (currently)
                for left, right, result in dw_values:
                    code += (
                        f"\t dw {left};\n" + f"\t dw {right};\n" + f"\t dw {result};\n"
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
    from hydra.algebra import BaseField

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
