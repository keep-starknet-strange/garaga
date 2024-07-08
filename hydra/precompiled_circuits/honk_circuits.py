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
        return [
            self.field(44),
            self.field(4),
            self.field(34),
            self.field(12),
        ]  #  beta: PyFelt, gamma: PyFelt, domainSize: int, offset: int

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(self.name, self.curve_id, generic_circuit=True)
        beta, gamma, domainSize, offset = circuit.write_elements(input, WriteOps.INPUT)
        # Calculate numeratorAcc and denumenatorAcc based on these formulas:
        # numeratorAcc = gamma + (beta * Fr(domainSize + offset))
        # denominatorAcc = gamma - (beta * Fr(offset + 1))
        numeratorAcc = circuit.add(
            gamma, circuit.mul(beta, circuit.add(domainSize, offset))
        )
        _one: ModuloCircuitElement = circuit.write_element(
            self.field(1), WriteOps.CONSTANT
        )
        denominatorAcc = circuit.sub(
            gamma, circuit.mul(beta, circuit.add(offset, _one))
        )
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
        return [
            self.field(44),
            self.field(4),
            self.field(34),
            self.field(12),
            self.field(34),
            self.field(12),
        ]  # beta, publicInput, numerator, numeratorAcc, denominator, denominatorAcc

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(self.name, self.curve_id, generic_circuit=True)
        beta, pubInput, numerator, denominator, numeratorAcc, denominatorAcc = (
            circuit.write_elements(input, WriteOps.INPUT)
        )
        # Calculate numeratorAcc and denumenatorAcc based on these formulas:
        # pubInput = Fr(publicInput)
        # numerator = numerator * (numeratorAcc + pubInput)
        # denominator = denominator * (denominatorAcc + pubInput)
        # numeratorAcc = numeratorAcc + beta
        # denominatorAcc = denominatorAcc - beta
        # beta = beta
        numerator_out = circuit.mul(circuit.add(numeratorAcc), numerator)
        denominator_out = circuit.mul(
            denominator, circuit.add(denominatorAcc, pubInput)
        )
        numeratorAcc_out = circuit.add(numeratorAcc, beta)
        denominatorAcc_out = circuit.sub(denominatorAcc, beta)

        circuit.extend_output(
            [numerator_out, denominator_out, numeratorAcc_out, denominatorAcc_out]
        )
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit


class VerifySumCheckInnerLoop(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True) -> None:
        super().__init__(
            name="HonkVerifierComputePublicInputDeltaLoop",
            input_len=6,
            curve_id=curve_id,
            auto_run=auto_run,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.append(self.field.random())  # RoundUnivariate1

    def computeNextTargetSum(
        self,
        roundUnivariates: list[ModuloCircuitElement],
        roundChallenge: ModuloCircuitElement,
        circuit: ModuloCircuit,
    ):
        assert len(roundUnivariates) == 7
        BARYCENTRIC_LAGRANGE_DENOMINATORS: list[ModuloCircuitElement] = circuit.write_elements(
                [
                    self.field(
                        0x00000000000000000000000000000000000000000000000000000000000002D0
                    ),
                    self.field(
                        0x00000000000000000000000000000000000000000000000000000000000002D0
                    ),
                    self.field(
                        0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFFF89
                    ),
                    self.field(
                        0x0000000000000000000000000000000000000000000000000000000000000030
                    ),
                    self.field(
                        0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFFFDD
                    ),
                    self.field(
                        0x0000000000000000000000000000000000000000000000000000000000000030
                    ),
                    self.field(
                        0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFFF89
                    ),
                    self.field(
                        0x00000000000000000000000000000000000000000000000000000000000002D0
                    ),
                ],
                WriteOps.CONSTANT,
            )
        BARYCENTRIC_DOMAIN: list[ModuloCircuitElement] = circuit.write_elements([
            self.field(0x00),
            self.field(0x01),
            self.field(0x02),
            self.field(0x03), 
            self.field(0x04),
            self.field(0x05),
            self.field(0x06),
        ])

        _numerator_value: ModuloCircuitElement = circuit.set_or_get_constant(1)

        for i in range(7):
            _numerator_value = circuit.mul(circuit.sub(roundChallenge,  circuit.set_or_get_constant(i)))

        denominatorInverses = [circuit.set_or_get_constant(0)] * 7

        for i in range(7):
            inv = BARYCENTRIC_LAGRANGE_DENOMINATORS[i]
            inv = circuit.mul(inv, circuit.sub(roundChallenge, BARYCENTRIC_DOMAIN[i]))
            inv = circuit.inv(inv)
            denominatorInverses[i] = inv

        targetSum: ModuloCircuitElement = circuit.set_or_get_constant(0)

        for i in range(7):
            term = roundUnivariates[i]
            term = circuit.mul(term, denominatorInverses[i])
            targetSum = circuit.add(targetSum, term)

        targetSum = circuit.mul(targetSum, _numerator_value)
        return targetSum

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(self.name, self.curve_id, generic_circuit=True)
        round1, round2, roundTarget, roundChallenge = circuit.write_elements(
            input, WriteOps.INPUT
        )

        roundUnivariates = [round1, round2]

        totalSum = circuit.add(round1, round2)

        to_check_eq_zero = circuit.sub(totalSum, roundTarget)
        circuit.extend_output([to_check_eq_zero])

        roundTarget = self.computeNextTargetSum(roundUnivariates, roundChallenge, circuit)

        # powPartialEvaluation = partiallyEvaluatePOW(
        #     tp, powPartialEvaluation, roundChallenge, rnd
        # )

        circuit.extend_output(
            [numerator_out, denominator_out, numeratorAcc_out, denominatorAcc_out]
        )
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit
