import re
import subprocess
from abc import ABC, abstractmethod
from concurrent.futures import ProcessPoolExecutor
from typing import Type

from garaga.definitions import CurveID, get_base_field
from garaga.hints.io import int_array_to_u384_array
from garaga.modulo_circuit import ModuloCircuit, ModuloCircuitElement, PyFelt
from garaga.modulo_circuit_structs import Cairo1SerializableStruct


def get_circuit_definition_impl_template(num_outputs: int):
    TEMPLATE = """\n
    impl CircuitDefinition{num_outputs}<
        {elements}
    > of core::circuit::CircuitDefinition<
        (
            {ce_elements}
        )
    > {{
        type CircuitType =
            core::circuit::Circuit<
                ({elements_tuple},)
            >;
    }}
    impl MyDrp_{num_outputs}<
        {elements}
    > of Drop<
        (
            {ce_elements}
        )
    >;
    """
    elements = ", ".join(f"E{i}" for i in range(num_outputs))
    ce_elements = ", ".join(f"CE<E{i}>" for i in range(num_outputs))
    elements_tuple = ", ".join(f"E{i}" for i in range(num_outputs))
    return TEMPLATE.format(
        num_outputs=num_outputs,
        elements=elements,
        ce_elements=ce_elements,
        elements_tuple=elements_tuple,
    )


class BaseModuloCircuit(ABC):
    """
    Base class for all modulo circuits that will be compiled to Cairo code.
    Parameters:
    - name: str, the name of the circuit
    - curve_id: int, the id of the curve
    - auto_run: bool, whether to run the circuit automatically at initialization.
                When compiling, this flag is set to true so the ModuloCircuit class inside the
                 ".circuit" member of this class holds the necessary metadata
                about the operations that will be compiled.
                For CairoZero, this flag will be set to False in the Python hint, so that
                BaseModuloCircuit.run_circuit() can be called on a segment parsed from the
                CairoZero VM.
    - compilation mode: 0 (CairoZero) or 1 (Cairo)
    """

    def __init__(
        self,
        name: str,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ) -> None:
        self.name = name
        self.curve_id = curve_id
        self.field = get_base_field(curve_id)
        self.init_hash = None
        self.generic_over_curve = False
        self.compilation_mode = compilation_mode
        if auto_run:
            self.input = self.build_input()
            self.circuit: ModuloCircuit = self._run_circuit_inner(self.input.copy())

    @abstractmethod
    def build_input(self) -> list[PyFelt]:
        """
        This method is used to create the necessary inputs that will be written to the ModuloCircuit.
        It works in pair with the _run_circuit_inner function, where the _run_circuit_inner will use the output of
        the build_input function to "deserialize" the list of elements and write them to the ModuloCircuit class.
        """

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
        """
        This method is responsible for
        - deserializing the input list of elements,
        - creating a ModuloCircuit class (or class that derives from ModuloCircuit)
        - "writing" the inputs to the ModuloCircuit class to obtain ModuloCircuitElements
        - using the methods add, sub, mul, inv (or higher level methods) of the ModuloCircuit class
            to define the list of operations on the given inputs
        - Returning the ModuloCircuit class in a state where the circuit has been run, and therefore holding
            the metadata so that its instructions can be compiled to Cairo code.

        """

    def run_circuit(self, input: list[int]) -> ModuloCircuit:
        """
        A simple wrapper around _run_circuit_inner that converts the input as a list of ints to a list of PyFelt.
        Used in CairoZero hint.
        """
        # print(
        #     f"Running circuit for {self.name} with CurveID {CurveID(self.curve_id).name}..."
        # )
        circuit_input = [self.field(x) for x in input]
        return self._run_circuit_inner(circuit_input)


class BaseEXTFCircuit(BaseModuloCircuit):
    """
    A extension of the BaseModuloCircuit class that holds an init_hash, used for CairoZero.
    Not relevant for Cairo1 circuits.
    """

    def __init__(
        self,
        name: str,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(name, curve_id, auto_run, compilation_mode)
        self.init_hash = init_hash


def compilation_mode_to_file_header(mode: int, curve_ids: set[CurveID]) -> str:
    if mode == 0:
        return """
from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from modulo_circuit import ExtensionFieldModuloCircuit, ModuloCircuit, get_void_modulo_circuit, get_void_extension_field_modulo_circuit
from definitions import bn, bls
"""
    elif mode == 1:
        moduluses = [
            f"get_{curve_id.name}_modulus"
            for curve_id in sorted(curve_ids, key=lambda x: x.name)
        ]
        return f"""
use core::circuit::{{
    RangeCheck96, AddMod, MulMod, u384, u96, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition,
    CircuitData, CircuitInputAccumulator
}};
use garaga::core::circuit::{{AddInputResultTrait2, u288IntoCircuitInputValue, IntoCircuitInputValue}};
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{{get_a, get_b, get_modulus, get_g, get_min_one, G1Point, G2Point, E12D, u288, E12DMulQuotient, G1G2Pair, BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor, G2Line, E12T, {', '.join(moduluses)}}};
use core::option::Option;
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

"""


def to_snake_case(s: str) -> str:
    return re.sub(r"(?<=[a-z])(?=[A-Z])|[^a-zA-Z0-9]", "_", s).lower()


def create_circuit_instances(
    circuit_class: Type[BaseModuloCircuit],
    curve_id: CurveID,
    params: list[dict],
    compilation_mode: int,
) -> list[BaseModuloCircuit]:
    """
    Create a list of circuit instances from a given circuit class, curve id, params and compilation mode.
    """
    circuits = []
    if params is None:
        circuit_instance = circuit_class(
            curve_id=curve_id.value, compilation_mode=compilation_mode, auto_run=True
        )
        circuits.append(circuit_instance)
    else:
        for param in params:
            circuit_instance = circuit_class(
                curve_id=curve_id.value,
                compilation_mode=compilation_mode,
                auto_run=True,
                **param,
            )
            circuits.append(circuit_instance)
    return circuits


def compile_single_circuit(
    circuit_instance: BaseModuloCircuit,
) -> tuple[ModuloCircuit, str]:
    """
    Compile a single circuit instance to Cairo code.
    Returns the compiled circuit and the full function name.
    """
    curve_id = CurveID(circuit_instance.curve_id)
    function_name = (
        f"{circuit_instance.name.upper()}"
        if circuit_instance.circuit.generic_circuit
        else f"{curve_id.name}_{circuit_instance.name.upper()}"
    )
    compiled_circuit, full_function_name = circuit_instance.circuit.compile_circuit(
        function_name=function_name
    )
    return compiled_circuit, full_function_name


def compile_circuit(
    curve_id: CurveID,
    circuit_class: BaseModuloCircuit,
    params: list[dict],
    compilation_mode: int,
) -> tuple[list[str], list[str], list[BaseModuloCircuit]]:
    """
    Compile a list of circuit instances to Cairo code.
    Returns :
    - compiled_circuits: list of compiled circuits as strings
    - full_function_names: list of full function names as strings
    - circuit_instances: list of circuit instances that have been compiled
    """
    circuits = create_circuit_instances(
        circuit_class, curve_id, params, compilation_mode
    )
    compiled_circuits = []
    full_function_names = []

    for circuit_instance in circuits:
        compiled_circuit, full_function_name = compile_single_circuit(circuit_instance)
        compiled_circuits.append(compiled_circuit)
        full_function_names.append(full_function_name)

    return compiled_circuits, full_function_names, circuits


def create_cairo1_test(function_name: str, input: list, output: list, curve_id: int):
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
        subprocess.run(["scarb", "fmt", f"{precompiled_circuits_dir}"], check=True)
