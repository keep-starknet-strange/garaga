from hydra.precompiled_circuits import multi_miller_loop, final_exp, multi_pairing_check
from hydra.precompiled_circuits.ec import (
    IsOnCurveCircuit,
    DerivePointFromX,
    ECIPCircuits,
    BasicEC,
)
from hydra.extension_field_modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuit,
    ModuloCircuitElement,
    PyFelt,
    WriteOps,
    EuclideanPolyAccumulator,
)
from hydra.definitions import (
    CurveID,
    CURVES,
    BN254_ID,
    BLS12_381_ID,
    get_base_field,
    CurveID,
    STARK,
    G1Point,
    G2Point,
    N_LIMBS,
)
from hydra.hints import neg_3
from hydra.hints.io import int_array_to_u384_array
from hydra.precompiled_circuits.all_circuits import BaseModuloCircuit
from random import seed, randint
from enum import Enum
from tools.gnark_cli import GnarkCLI
import subprocess
from concurrent.futures import ProcessPoolExecutor


seed(42)

class HonkVerifierComputePublicInputDeltaInit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True) -> None:
        super().__init__(
            name="HonkVerifierComputePublicInputDeltaInit",
            input_len=4,
            curve_id=curve_id,
            auto_run=auto_run,
        )

    def build_input(self) -> list[PyFelt]:
        return [self.field(44), self.field(4), self.field(34), self.field(12)] #  beta: PyFelt, gamma: PyFelt, domainSize: int, offset: int

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(self.name, self.curve_id, generic_circuit=True)
        beta, gamma, domainSize, offset = circuit.write_elements(input, WriteOps.INPUT)
        # Calculate numeratorAcc and denumenatorAcc based on these formulas:
        # numeratorAcc = gamma + (beta * Fr(domainSize + offset))
        # denominatorAcc = gamma - (beta * Fr(offset + 1))
        numeratorAcc = circuit.add(gamma, circuit.mul(beta, circuit.add(domainSize, offset)))
        _one:ModuloCircuitElement = circuit.write_element(self.field(1), WriteOps.CONSTANT)
        denominatorAcc = circuit.sub(gamma, circuit.mul(beta, circuit.add(offset, _one)))
        circuit.extend_output([numeratorAcc, denominatorAcc])
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit

class HonkVerifierComputePublicInputDeltaLoop(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True) -> None:
        super().__init__(
            name="HonkVerifierComputePublicInputDeltaLoop",
            input_len=6,
            curve_id=curve_id,
            auto_run=auto_run,
        )

    def build_input(self) -> list[PyFelt]:
        return [self.field(44), self.field(4), self.field(34), self.field(12), self.field(34), self.field(12)] # beta, publicInput, numerator, numeratorAcc, denominator, denominatorAcc

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(self.name, self.curve_id, generic_circuit=True)
        beta, pubInput, numerator, denominator, numeratorAcc, denominatorAcc = circuit.write_elements(input, WriteOps.INPUT)
        # Calculate numeratorAcc and denumenatorAcc based on these formulas:
        # pubInput = Fr(publicInput)
        # numerator = numerator * (numeratorAcc + pubInput)
        # denominator = denominator * (denominatorAcc + pubInput)
        # numeratorAcc = numeratorAcc + beta
        # denominatorAcc = denominatorAcc - beta
        # beta = beta
        numerator_out = circuit.mul(circuit.add(numeratorAcc), numerator)
        denominator_out = circuit.mul(denominator, circuit.add(denominatorAcc, pubInput))
        numeratorAcc_out = circuit.add(numeratorAcc, beta)
        denominatorAcc_out = circuit.sub(denominatorAcc, beta)

        circuit.extend_output([numerator_out, denominator_out, numeratorAcc_out, denominatorAcc_out])
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit
