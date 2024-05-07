from src.precompiled_circuits import multi_miller_loop, final_exp
from src.precompiled_circuits.ec import IsOnCurveCircuit, DerivePointFromX
from src.extension_field_modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuit,
    ModuloCircuitElement,
    PyFelt,
    WriteOps,
)
from src.definitions import (
    CurveID,
    CURVES,
    BN254_ID,
    BLS12_381_ID,
    get_base_field,
    CurveID,
    STARK,
)
from random import seed, randint
from enum import Enum
from tools.gnark_cli import GnarkCLI
import subprocess
from concurrent.futures import ProcessPoolExecutor


seed(42)


class CircuitID(Enum):
    FP12_MUL = int.from_bytes(b"fp12_mul", "big")
    FP12_SUB = int.from_bytes(b"fp12_sub", "big")
    FINAL_EXP_PART_1 = int.from_bytes(b"final_exp_part_1", "big")
    FINAL_EXP_PART_2 = int.from_bytes(b"final_exp_part_2", "big")
    COMPUTE_DOUBLE_PAIR_LINES = int.from_bytes(b"compute_double_pair_lines", "big")
    ACCUMULATE_SINGLE_PAIR_LINES = int.from_bytes(
        b"accumulate_single_pair_lines", "big"
    )
    MILLER_LOOP_N1 = int.from_bytes(b"miller_loop_n1", "big")
    MILLER_LOOP_N2 = int.from_bytes(b"miller_loop_n2", "big")
    MILLER_LOOP_N3 = int.from_bytes(b"miller_loop_n3", "big")
    IS_ON_CURVE_G1_G2 = int.from_bytes(b"is_on_curve_g1_g2", "big")
    DERIVE_POINT_FROM_X = int.from_bytes(b"derive_point_from_x", "big")


from abc import ABC, abstractmethod


class BaseModuloCircuit(ABC):
    """
    Base class for all modulo circuits.
    Parameters:
    - name: str, the name of the circuit
    - input_len: int, the number of input elements (/!\ of total felt252 values)
    - curve_id: int, the id of the curve
    - auto_run: bool, whether to run the circuit automatically at initialization.
    """

    def __init__(
        self,
        name: str,
        input_len: int,
        curve_id: int,
        auto_run: bool = True,
    ) -> None:
        self.name = name
        self.cairo_name = int.from_bytes(name.encode("utf-8"), "big")
        self.curve_id = curve_id
        self.field = get_base_field(curve_id)
        self.input_len = input_len
        self.init_hash = None
        self.generic_circuit = False
        if auto_run:
            self.circuit: ModuloCircuit = self._run_circuit_inner(self.build_input())

    @abstractmethod
    def build_input(self) -> list[PyFelt]:
        pass

    @abstractmethod
    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        pass

    def run_circuit(self, input: list[int]) -> ModuloCircuit:
        print(
            f"Running circuit for {self.name} with CurveID {CurveID(self.curve_id).name}..."
        )
        circuit_input = [self.field(x) for x in input]
        return self._run_circuit_inner(circuit_input)


class BaseEXTFCircuit(BaseModuloCircuit):
    def __init__(
        self,
        name: str,
        input_len: int,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
    ):
        super().__init__(name, input_len, curve_id, auto_run)
        self.init_hash = init_hash


class IsOnCurveG1G2Circuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True):
        super().__init__("is_on_curve_g1_g2", 24, curve_id, auto_run)

    def build_input(self, n1: int = None, n2: int = None) -> list[PyFelt]:
        cli = GnarkCLI(CurveID(self.curve_id))
        order = CURVES[self.curve_id].n
        input = []
        if n1 is None or n2 is None:
            n1, n2 = randint(1, order), randint(1, order)
        input.extend([self.field(x) for x in cli.nG1nG2_operation(n1, n2, raw=True)])
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = IsOnCurveCircuit(self.name, self.curve_id)
        p = circuit.write_elements(input[0:2], WriteOps.INPUT)
        q = circuit.write_elements(input[2:6], WriteOps.INPUT)
        lhs, rhs = circuit._is_on_curve_G1(*p)
        lhs2, rhs2 = circuit._is_on_curve_G2(*q)
        zero_check = circuit.sub(lhs, rhs)
        zero_check_2 = [circuit.sub(lhs2[0], rhs2[0]), circuit.sub(lhs2[1], rhs2[1])]

        circuit.extend_output([zero_check])
        circuit.extend_output(zero_check_2)
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit


class DerivePointFromXCircuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True) -> None:
        super().__init__(
            name="derive_point_from_x",
            input_len=4 * 3,  # X + b + G
            curve_id=curve_id,
            auto_run=auto_run,
        )
        self.generic_circuit = True

    def build_input(self) -> list[PyFelt]:
        input = []
        input.append(self.field(randint(0, STARK - 1)))
        input.append(self.field(CURVES[self.curve_id].b))  # y^2 = x^3 + b
        input.append(self.field(CURVES[self.curve_id].fp_generator))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = DerivePointFromX(self.name, self.curve_id)
        x, b, g = circuit.write_elements(input[0:3], WriteOps.INPUT)
        rhs, grhs, should_be_rhs, should_be_grhs, y_try = circuit._derive_point_from_x(
            x, b, g
        )
        circuit.extend_output([rhs, grhs, should_be_rhs, should_be_grhs, y_try])
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit


class FP12MulCircuit(BaseEXTFCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, init_hash: int = None):
        super().__init__("fp12_mul", 24, curve_id, auto_run, init_hash)

    def build_input(self) -> list[PyFelt]:
        return [self.field(randint(0, self.field.p - 1)) for _ in range(self.input_len)]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ExtensionFieldModuloCircuit:
        circuit = ExtensionFieldModuloCircuit(
            self.name, self.curve_id, extension_degree=12, init_hash=self.init_hash
        )
        X = circuit.write_elements(input[0:12], WriteOps.INPUT)
        Y = circuit.write_elements(input[12:24], WriteOps.INPUT)
        xy = circuit.extf_mul(X, Y, 12)
        circuit.extend_output(xy)
        circuit.finalize_circuit()
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit


class FinalExpPart1Circuit(BaseEXTFCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, init_hash: int = None):
        super().__init__("final_exp_part_1", 12, curve_id, auto_run)

    def build_input(self) -> list[PyFelt]:
        return [self.field(randint(0, self.field.p - 1)) for _ in range(self.input_len)]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ExtensionFieldModuloCircuit:
        circuit: final_exp.FinalExpTorusCircuit = final_exp.GaragaFinalExp[
            CurveID(self.curve_id)
        ](name="final_exp_part_1", init_hash=self.init_hash)
        t0, t1, _sum = circuit.final_exp_part1(input[0:6], input[6:12])
        # for t0_val in t0:
        #     print(f"Final exp Part1 t0 {hex(t0_val.value)}")
        # for t1_val in t1:
        #     print(f"Final exp Part1 t1 {hex(t1_val.value)}")
        # for _sum_val in _sum:
        #     print(f"Final exp Part1 _sum {hex(_sum_val.value)}")
        # Note : output is handled inside final_exp_part1.
        circuit.finalize_circuit()
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit


class FinalExpPart2Circuit(BaseEXTFCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, init_hash: int = None):
        super().__init__("final_exp_part_2", 12, curve_id, auto_run, init_hash)

    def build_input(self) -> list[PyFelt]:
        return [self.field(randint(0, self.field.p - 1)) for _ in range(self.input_len)]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ExtensionFieldModuloCircuit:
        circuit: final_exp.FinalExpTorusCircuit = final_exp.GaragaFinalExp[
            CurveID(self.curve_id)
        ](name="final_exp_part_2", hash_input=False, init_hash=self.init_hash)
        res = circuit.final_exp_finalize(input[0:6], input[6:12])
        circuit.extend_output(res)

        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit


class ComputeDoublePairLinesCircuit(BaseEXTFCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True):
        super().__init__("compute_double_pair_lines", 2 * 6, curve_id, auto_run)

    def build_input(self) -> list[PyFelt]:
        cli = GnarkCLI(CurveID(self.curve_id))
        order = CURVES[self.curve_id].n
        res = []
        for _ in range(2):
            n1, n2 = randint(1, order), randint(1, order)
            gnark_output = cli.nG1nG2_operation(n1, n2, raw=True)
            res.extend([self.field(x) for x in gnark_output])
        return res

    def _run_circuit_inner(self, input: list[PyFelt]) -> ExtensionFieldModuloCircuit:
        circuit = multi_miller_loop.MultiMillerLoopCircuit(
            self.name,
            self.curve_id,
            n_pairs=2,
        )
        circuit.write_p_and_q(input)
        lines = circuit.compute_double_pair_lines(0, 1)
        line_functions_sparsities = circuit.output_lines_sparsities
        assert len(lines) == len(line_functions_sparsities)
        for line, sparsity in zip(lines, line_functions_sparsities):
            if sparsity:
                line = [line[i] for i in range(12) if sparsity[i] == 1]
            else:
                line = line
                assert len(line) == 12
            circuit.extend_output(line)
        assert len(circuit.output) == sum(
            sum(sparsity) if sparsity else 12 for sparsity in line_functions_sparsities
        )
        circuit.finalize_circuit()
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        assert len(circuit.output) == sum(
            sum(sparsity) if sparsity else 12 for sparsity in line_functions_sparsities
        )
        return circuit


class AccumulateSinglePairLinesCircuit(BaseEXTFCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, init_hash: int = None):
        super().__init__(
            "accumulate_single_pair_lines",
            None,
            curve_id,
            auto_run,
            init_hash=init_hash,
        )

    def build_input(self) -> list[PyFelt]:
        cli = GnarkCLI(CurveID(self.curve_id))
        order = CURVES[self.curve_id].n
        input = []
        n1, n2 = randint(1, order), randint(1, order)
        double_line_circuit = ComputeDoublePairLinesCircuit(self.curve_id).circuit
        input.extend([x.felt for x in double_line_circuit.output])
        input.extend([self.field(x) for x in cli.nG1nG2_operation(n1, n2, raw=True)])
        self.input_spartisities = double_line_circuit.output_lines_sparsities
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ExtensionFieldModuloCircuit:
        circuit = multi_miller_loop.MultiMillerLoopCircuit(
            self.name,
            self.curve_id,
            n_pairs=1,
            hash_input=False,
            init_hash=self.init_hash,
        )
        lines = []
        self.build_input()

        exp_len = (
            sum(
                sum(sparsity) if sparsity else 12
                for sparsity in self.input_spartisities
            )
            + 6
        )
        assert len(input) == exp_len, f"Expected {exp_len} elements, got {len(input)}."
        offset = 0
        for sparsity in self.input_spartisities:
            X = []
            if sparsity:
                for k in range(12):
                    if sparsity[k] == 0:
                        X.append(circuit.get_constant(0))
                    elif sparsity[k] == 1:
                        X.append(input[offset])
                        offset += 1
                    else:
                        raise ValueError(f"Sparsity value {sparsity[k]} is not valid.")
            else:
                X = input[offset : offset + 12]
                offset += 12

            if sparsity:
                zero_values = [X[i].value for i in range(12) if sparsity[i] == 0]
                assert all(
                    value == 0 for value in zero_values
                ), "Some elements expected to be zero based on sparsity are not zero."

            lines.append(
                circuit.write_elements(
                    elmts=X,
                    operation=WriteOps.INPUT,
                    sparsity=sparsity,
                )
            )

        circuit.write_p_and_q(input[-6:])
        lines = circuit.accumulate_single_pair_lines(lines, 0)
        for line in lines:
            circuit.extend_output(line)
        circuit.finalize_circuit()
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit


class MillerLoopN1(BaseEXTFCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True):
        super().__init__("miller_loop_n1", 2 * 6, curve_id, auto_run)

    def build_input(self) -> list[PyFelt]:
        cli = GnarkCLI(CurveID(self.curve_id))
        order = CURVES[self.curve_id].n
        n1, n2 = randint(1, order), randint(1, order)
        return [self.field(x) for x in cli.nG1nG2_operation(n1, n2, raw=True)]

    def _run_circuit_inner(self, input: list[PyFelt]):
        circuit = multi_miller_loop.MultiMillerLoopCircuit(
            self.name,
            self.curve_id,
            n_pairs=1,
            hash_input=True,
        )
        circuit.write_p_and_q(input)
        m = circuit.miller_loop(1, None)
        circuit.extend_output(m)
        circuit.finalize_circuit()
        circuit.values_segment = circuit.values_segment.non_interactive_transform()

        return circuit


class MillerLoopN2(BaseEXTFCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, init_hash: int = None):
        super().__init__("miller_loop_n2", 2 * 6, curve_id, auto_run, init_hash)

    def build_input(self) -> list[PyFelt]:
        double_line_circuit = ComputeDoublePairLinesCircuit(self.curve_id).circuit
        input = [x.felt for x in double_line_circuit.output]
        self.input_spartisities = double_line_circuit.output_lines_sparsities
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        circuit = multi_miller_loop.MultiMillerLoopCircuit(
            self.name,
            self.curve_id,
            n_pairs=2,
            hash_input=False,
            init_hash=self.init_hash,
        )
        lines = []
        self.build_input()
        offset = 0
        for sparsity in self.input_spartisities:
            X = []
            if sparsity:
                for k in range(12):
                    if sparsity[k] == 0:
                        X.append(circuit.get_constant(0))
                    elif sparsity[k] == 1:
                        X.append(input[offset])
                        offset += 1
                    else:
                        raise ValueError(f"Sparsity value {sparsity[k]} is not valid.")
            else:
                X = input[offset : offset + 12]
                offset += 12
            lines.append(
                circuit.write_elements(
                    elmts=X,
                    operation=WriteOps.INPUT,
                    sparsity=sparsity,
                )
            )
        m = circuit.miller_loop(2, lines)
        circuit.extend_output(m)
        circuit.finalize_circuit()
        circuit.values_segment = circuit.values_segment.non_interactive_transform()

        return circuit


class MillerLoopN3(BaseEXTFCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, init_hash: int = None):
        super().__init__("miller_loop_n3", 2 * 6, curve_id, auto_run, init_hash)

    def build_input(self) -> list[PyFelt]:
        acc_line_circuit = AccumulateSinglePairLinesCircuit(self.curve_id).circuit
        input = [x.felt for x in acc_line_circuit.output]
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        circuit = multi_miller_loop.MultiMillerLoopCircuit(
            self.name,
            self.curve_id,
            n_pairs=3,
            hash_input=False,
            init_hash=self.init_hash,
        )
        assert len(input) % 12 == 0
        lines = []
        for i in range(len(input) // 12):
            lines.append(
                circuit.write_elements(
                    elmts=input[12 * i : 12 * i + 12],
                    operation=WriteOps.INPUT,
                )
            )
        m = circuit.miller_loop(3, lines)
        circuit.extend_output(m)
        circuit.finalize_circuit()
        circuit.values_segment = circuit.values_segment.non_interactive_transform()

        return circuit


ALL_EXTF_CIRCUITS = {
    CircuitID.IS_ON_CURVE_G1_G2: IsOnCurveG1G2Circuit,
    CircuitID.DERIVE_POINT_FROM_X: DerivePointFromXCircuit,
    CircuitID.FP12_MUL: FP12MulCircuit,
    CircuitID.FINAL_EXP_PART_1: FinalExpPart1Circuit,
    CircuitID.FINAL_EXP_PART_2: FinalExpPart2Circuit,
    CircuitID.COMPUTE_DOUBLE_PAIR_LINES: ComputeDoublePairLinesCircuit,
    CircuitID.ACCUMULATE_SINGLE_PAIR_LINES: AccumulateSinglePairLinesCircuit,
    CircuitID.MILLER_LOOP_N1: MillerLoopN1,
    CircuitID.MILLER_LOOP_N2: MillerLoopN2,
    CircuitID.MILLER_LOOP_N3: MillerLoopN3,
}


def main():
    import re

    def to_snake_case(s: str) -> str:
        return re.sub(r"(?<=[a-z])(?=[A-Z])|[^a-zA-Z0-9]", "_", s).lower()

    """Compiles and writes all circuits to .cairo files"""
    filenames = ["final_exp", "multi_miller_loop", "extf_mul", "ec"]
    circuit_name_to_filename = {
        CircuitID.IS_ON_CURVE_G1_G2: "ec",
        CircuitID.DERIVE_POINT_FROM_X: "ec",
        CircuitID.FP12_MUL: "extf_mul",
        CircuitID.FINAL_EXP_PART_1: "final_exp",
        CircuitID.FINAL_EXP_PART_2: "final_exp",
        CircuitID.COMPUTE_DOUBLE_PAIR_LINES: "multi_miller_loop",
        CircuitID.ACCUMULATE_SINGLE_PAIR_LINES: "multi_miller_loop",
        CircuitID.MILLER_LOOP_N1: "multi_miller_loop",
        CircuitID.MILLER_LOOP_N2: "multi_miller_loop",
        CircuitID.MILLER_LOOP_N3: "multi_miller_loop",
    }
    # Ensure the 'codes' dict keys match the filenames used for file creation
    codes = {filename: [] for filename in filenames}
    selector_functions = {filename: set() for filename in filenames}

    files = {f: open(f"src/precompiled_circuits/{f}.cairo", "w") for f in filenames}

    # Write the header to each file
    header = """
from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from src.modulo_circuit import ExtensionFieldModuloCircuit, ModuloCircuit, get_void_modulo_circuit, get_void_extension_field_modulo_circuit
from src.definitions import bn, bls
"""
    for file in files.values():
        file.write(header)

    # Instantiate and compile circuits for each curve
    for i, curve_id in enumerate([CurveID.BN254, CurveID.BLS12_381]):
        for circuit_id, circuit_class in ALL_EXTF_CIRCUITS.items():
            circuit_instance: BaseModuloCircuit = circuit_class(curve_id.value)
            print(f"Compiling {curve_id.name}:{circuit_instance.name} ...")

            if circuit_instance.generic_circuit == True and i == 0:
                compiled_circuit = circuit_instance.circuit.compile_circuit(
                    function_name=f"{circuit_id.name}"
                )
            elif circuit_instance.generic_circuit == False:
                compiled_circuit = circuit_instance.circuit.compile_circuit(
                    function_name=f"{curve_id.name}_{circuit_id.name}"
                )
            else:
                compiled_circuit = {"function_name": "", "code": ""}

            filename_key = circuit_name_to_filename[circuit_id]
            codes[filename_key].append(compiled_circuit)
            struct_name = circuit_instance.circuit.class_name
            # Add the selector function for this circuit if it doesn't already exist in the list
            if circuit_id not in selector_functions[filename_key]:
                if circuit_instance.generic_circuit == True:
                    selector_function = ""
                else:
                    selector_function = f"""
        func get_{circuit_id.name}_circuit(curve_id:felt) -> (circuit:{struct_name}*){{
            if (curve_id == bn.CURVE_ID) {{
                return get_BN254_{circuit_id.name}_circuit();
            }}
            if (curve_id == bls.CURVE_ID) {{
                return get_BLS12_381_{circuit_id.name}_circuit();
            }}
            return get_void_{to_snake_case(struct_name)}();
        }}
        """

            selector_functions[filename_key].add(selector_function)

    # Write selector functions and compiled circuit codes to their respective files
    print(f"Writing circuits and selectors to .cairo files...")
    for filename in filenames:
        if filename in files:
            # Write the selector functions for this file
            for selector_function in selector_functions[filename]:
                files[filename].write(selector_function)
            # Write the compiled circuit codes
            for compiled_circuit in codes[filename]:
                files[filename].write(compiled_circuit["code"] + "\n")
        else:
            print(f"Warning: No file associated with filename '{filename}'")

    # Close all files
    for file in files.values():
        file.close()

    print(f"Formatting .cairo files in parallel...")
    cairo_files = [f"src/precompiled_circuits/{f}.cairo" for f in filenames]
    with ProcessPoolExecutor() as executor:
        futures = [
            executor.submit(subprocess.run, ["cairo-format", file, "-i"], check=True)
            for file in cairo_files
        ]
        for future in futures:
            future.result()  # Wait for all formatting tasks to complete
    print(f"Done!")
    return None


if __name__ == "__main__":
    main()
