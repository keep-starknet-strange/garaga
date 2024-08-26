import re
import subprocess
from abc import ABC, abstractmethod
from concurrent.futures import ProcessPoolExecutor

from garaga.definitions import CurveID, get_base_field
from garaga.hints.io import int_array_to_u384_array
from garaga.modulo_circuit import ModuloCircuit, ModuloCircuitElement, PyFelt
from garaga.modulo_circuit_structs import Cairo1SerializableStruct


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
        compilation_mode: int = 0,
    ) -> None:
        self.name = name
        self.cairo_name = int.from_bytes(name.encode("utf-8"), "big")
        self.curve_id = curve_id
        self.field = get_base_field(curve_id)
        self.input_len = input_len
        self.init_hash = None
        self.generic_over_curve = False
        self.compilation_mode = compilation_mode
        if auto_run:
            self.input = self.build_input()
            self.circuit: ModuloCircuit = self._run_circuit_inner(self.input.copy())

    @abstractmethod
    def build_input(self) -> list[PyFelt]:
        pass

    @property
    def full_input_cairo1(self) -> list[PyFelt] | list[Cairo1SerializableStruct]:
        if self.circuit is None:
            raise ValueError("Circuit not run yet")
        if self.circuit.input_structs:
            return self.circuit.input_structs
        else:
            res = self.input + self.circuit.witnesses
        return res

    @abstractmethod
    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        pass

    def run_circuit(self, input: list[int]) -> ModuloCircuit:
        # print(
        #     f"Running circuit for {self.name} with CurveID {CurveID(self.curve_id).name}..."
        # )
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
        compilation_mode: int = 0,
    ):
        super().__init__(name, input_len, curve_id, auto_run, compilation_mode)
        self.init_hash = init_hash


def compilation_mode_to_file_header(mode: int) -> str:
    if mode == 0:
        return """
from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from modulo_circuit import ExtensionFieldModuloCircuit, ModuloCircuit, get_void_modulo_circuit, get_void_extension_field_modulo_circuit
from definitions import bn, bls
"""
    elif mode == 1:
        return """
use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition,
    CircuitData, CircuitInputAccumulator
};
use garaga::core::circuit::AddInputResultTrait2;
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{get_a, get_b, get_p, get_g, get_min_one, G1Point, G2Point, E12D, E12DMulQuotient, G1G2Pair, BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor, G2Line};
use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};
use core::option::Option;\n
"""


def cairo1_tests_header() -> str:
    return """
#[cfg(test)]
mod tests {
    use core::traits::TryInto;

    use core::circuit::{
        RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
        circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384,
        CircuitOutputsTrait, CircuitModulus, AddInputResultTrait, CircuitInputs
    };
    use garaga::definitions::{G1Point, G2Point, E12D, E12DMulQuotient, G1G2Pair, BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor, G2Line};
    use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};
"""


def to_snake_case(s: str) -> str:
    return re.sub(r"(?<=[a-z])(?=[A-Z])|[^a-zA-Z0-9]", "_", s).lower()


def compile_circuit(
    curve_id: CurveID,
    circuit_class: BaseModuloCircuit,
    params: list[dict],
    compilation_mode: int,
    cairo1_tests_functions: dict[str, set[str]],
    filename_key: str,
) -> tuple[list[str], str]:
    # print(
    #     f"Compiling {curve_id.name}:{circuit_class.__name__} {f'with params {params}' if params else ''}..."
    # )

    circuits: list[BaseModuloCircuit] = []
    compiled_circuits: list[str] = []
    full_function_names: list[str] = []

    if params is None:
        circuit_instance = circuit_class(
            curve_id=curve_id.value, compilation_mode=compilation_mode
        )
        circuits.append(circuit_instance)
    else:
        for param in params:
            circuit_instance = circuit_class(
                curve_id=curve_id.value, compilation_mode=compilation_mode, **param
            )
            circuits.append(circuit_instance)

    for i, circuit_instance in enumerate(circuits):
        function_name = (
            f"{circuit_instance.name.upper()}"
            if circuit_instance.circuit.generic_circuit
            else f"{curve_id.name}_{circuit_instance.name.upper()}"
        )
        compiled_circuit, full_function_name = circuit_instance.circuit.compile_circuit(
            function_name=function_name
        )

        compiled_circuits.append(compiled_circuit)

        if compilation_mode == 1:
            circuit_input = circuit_instance.full_input_cairo1
            if sum(
                [len(x.elmts) for x in circuit_instance.circuit.output_structs]
            ) == len(circuit_instance.circuit.output):
                circuit_output = circuit_instance.circuit.output_structs
            else:
                circuit_output = circuit_instance.circuit.output
            full_function_names.append(full_function_name)
            cairo1_tests_functions[filename_key].add(
                write_cairo1_test(
                    full_function_name,
                    circuit_input,
                    circuit_output,
                    curve_id.value,
                )
            )

    return compiled_circuits, full_function_names


def write_cairo1_test(function_name: str, input: list, output: list, curve_id: int):
    return ""
    if function_name == "":
        # print(f"passing test")
        return ""
    include_curve_id = CurveID.find_value_in_string(function_name) == None
    if all(isinstance(i, Cairo1SerializableStruct) for i in input):
        input_code = "\n".join([i.serialize() for i in input])
        input_params = ",".join([f"{i.name}" for i in input])
    elif all(isinstance(i, PyFelt) for i in input):
        input_code = f"let input = {int_array_to_u384_array(input)};"
        input_params = "input"
    else:
        raise ValueError(
            f"Invalid input type for Cairo1 test : {[type(i) for i in input]}"
        )
    if all(isinstance(i, Cairo1SerializableStruct) for i in output):
        output_code = f"let ({', '.join([i.name+'_result' for i in output])}) = {function_name}({input_params}{', ' + str(curve_id) if include_curve_id else ''});"
        output_code += "\n".join([i.serialize() for i in output])
        for struct in output:
            output_code += f"assert_eq!({struct.name}_result, {struct.name});"
    elif all(isinstance(i, ModuloCircuitElement) for i in output):
        output_code = f"let got = {function_name}({input_params}{', ' + str(curve_id) if include_curve_id else ''});"
        output_code += f"let exp = {int_array_to_u384_array(output)};"
        output_code += "assert_eq!(got.len(), exp.len());"
        output_code += "assert_eq!(got, exp);"
    else:
        raise ValueError(
            f"Invalid output type for Cairo1 test : {[type(i) for i in output]}"
        )
    code = f"""
    #[test]
    fn test_{function_name}_{CurveID(curve_id).name}() {{
        {input_code}
        {output_code}
    }}
    """

    return code


def format_cairo_files_in_parallel(
    filenames, compilation_mode, precompiled_circuits_dir
):
    if compilation_mode == 0:
        print("Formatting .cairo zero files in parallel...")
        cairo_files = [f"{precompiled_circuits_dir}{f}.cairo" for f in filenames]
        with ProcessPoolExecutor() as executor:
            futures = [
                executor.submit(
                    subprocess.run, ["cairo-format", file, "-i"], check=True
                )
                for file in cairo_files
            ]
            for future in futures:
                future.result()  # Wait for all formatting tasks to complete
        print("Done!")
    elif compilation_mode == 1:
        subprocess.run(["scarb", "fmt"], check=True, cwd=precompiled_circuits_dir)
