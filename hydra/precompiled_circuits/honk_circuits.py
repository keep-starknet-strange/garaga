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


BATCHED_RELATION_PARTIAL_LENGTH: int = 7


class ComputePublicInputDeltaInit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True) -> None:
        super().__init__(
            name="ComputePublicInputDeltaInit",
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


class ComputePublicInputDeltaLoop(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True) -> None:
        super().__init__(
            name="ComputePublicInputDeltaLoop",
            input_len=6,
            curve_id=curve_id,
            auto_run=auto_run,
        )

    def build_input(self) -> list[PyFelt]:
        return [
            self.field.random(),
            self.field.random(),
            self.field.random(),
            self.field.random(),
            self.field.random(),
            self.field.random(),
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
            name="ComputePublicInputDeltaLoop",
            input_len=6,
            curve_id=curve_id,
            auto_run=auto_run,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.append(self.field.random())  # RoundUnivariate1
        input.append(self.field.random())  # RoundUnivariate2
        input.append(self.field.random())  # RoundUnivariate3
        input.append(self.field.random())  # RoundUnivariate4
        input.append(self.field.random())  # RoundUnivariate5
        input.append(self.field.random())  # RoundUnivariate6
        input.append(self.field.random())  # RoundUnivariate7
        input.append(self.field.random())  # roundTarget
        input.append(self.field.random())  # roundChallenge
        input.append(self.field.random())  # powPartialEvaluation
        input.append(self.field.random())  # transcript_gate_challange_based_on_round



    def computeNextTargetSum(
        self,
        roundUnivariates: list[ModuloCircuitElement],
        roundChallenge: ModuloCircuitElement,
        circuit: ModuloCircuit,
    ):
        assert len(roundUnivariates) == 7
        BARYCENTRIC_LAGRANGE_DENOMINATORS: list[ModuloCircuitElement] = circuit.write_elements(
                [
                    self.field(0x00000000000000000000000000000000000000000000000000000000000002D0),
                    self.field(0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFFF89),
                    self.field(0x0000000000000000000000000000000000000000000000000000000000000030),
                    self.field(0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFFFDD),
                    self.field(0x0000000000000000000000000000000000000000000000000000000000000030),
                    self.field(0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFFF89),
                    self.field(0x00000000000000000000000000000000000000000000000000000000000002D0),
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
        ],
        WriteOps.CONSTANT)

        _numerator_value: ModuloCircuitElement = circuit.set_or_get_constant(1)

        for i in range(7):
            _numerator_value = circuit.mul(_numerator_value, circuit.sub(roundChallenge,  circuit.set_or_get_constant(i)))

        denominatorInverses = [circuit.set_or_get_constant(0)] * 7

        for i in range(BATCHED_RELATION_PARTIAL_LENGTH):
            inv = BARYCENTRIC_LAGRANGE_DENOMINATORS[i]
            inv = circuit.mul(inv, circuit.sub(roundChallenge, BARYCENTRIC_DOMAIN[i]))
            inv = circuit.inv(inv)
            denominatorInverses[i] = inv

        targetSum: ModuloCircuitElement = circuit.set_or_get_constant(0)


        for i in range(BATCHED_RELATION_PARTIAL_LENGTH):
            term = roundUnivariates[i]
            term = circuit.mul(term, denominatorInverses[i])
            targetSum = circuit.add(targetSum, term)

        targetSum = circuit.mul(targetSum, _numerator_value)
        return targetSum


    def partiallyEvaluatePOW(self, circuit:ModuloCircuit, transcript_gate_challange_based_on_round: ModuloCircuitElement, currentEvaluation: ModuloCircuitElement, roundChallenge:ModuloCircuitElement):
        _one: ModuloCircuitElement = circuit.set_or_get_constant(1)
        univariateEval = circuit.add(_one, circuit.mul(roundChallenge,circuit.sub(transcript_gate_challange_based_on_round, _one)))
        newEvaluation = circuit.mul(currentEvaluation, univariateEval)
        return newEvaluation

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(self.name, self.curve_id, generic_circuit=True)
        round1, round2, round3, round4, round5, round6, round7, roundTarget, roundChallenge, powPartialEvaluation, transcript_gate_challange_based_on_round = circuit.write_elements(
            input, WriteOps.INPUT
        )

        roundUnivariates = [round1, round2, round3, round4, round5, round6, round7]

        totalSum = circuit.add(round1, round2)

        to_check_eq_zero = circuit.sub(totalSum, roundTarget)
        circuit.extend_output([to_check_eq_zero])

        roundTarget = self.computeNextTargetSum(roundUnivariates, roundChallenge, circuit)


        powPartialEvaluation = self.partiallyEvaluatePOW(circuit, 
            transcript_gate_challange_based_on_round, powPartialEvaluation, roundChallenge
        ) 

        circuit.extend_output(
            [roundTarget, powPartialEvaluation]
        )
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit


if __name__ == "__main__":
    test = VerifySumCheckInnerLoop(5, False)

    
    roundTarget =test.field(4674566760196214864477970568678594518285056981310251169557458483128259681819)
    roundChallenge = test.field(14389039282624594806383826137646176951319156258352336162155641900017493193090)
    powPartialEvaluation = test.field(13807840717995081925544344617184045656651374224431885663637405530299637667927)
    transcript_gate_challange_based_on_round = test.field(8572886669550635644399645747687511441268264713714244990986020890149373313094)

    input:list[PyFelt] = [
                        test.field(11295649249236926091646558188405281013525669726332467635057881792565548862945),
                        test.field(15267160382798563995077818125530588593307751655393817878197780877138519314491),
                        test.field(15615731433773233787543880334368251950864770786314763897224533361222647544551),
                        test.field(17035808081901983392269425822593278850028670536994624988142588365146403906106),
                        test.field(2399155236915039816957294604529667007597108743264633268412658297429756392745),
                        test.field(21480223225338570876165211989402366595450666207346438152667072792336994019931),
                        test.field(19954405046031682686581549519158063451413851323237758661592008958190125618189),
                        roundTarget,
                        roundChallenge,
                        powPartialEvaluation,
                        transcript_gate_challange_based_on_round
                    ]
    circuit=test._run_circuit_inner(input)

    # This test case is manually pulled from honk.py for the purpose of testing verifySumCheckInnerLoop function. Round is 2
    # It should return:
    # powPartialEvaluation:PyFelt(5728125568134075363604924656756599688906507627035319267637922763832879612798, 0x3064...0001)
    # roundTarget:PyFelt(17633049829173004252018223139456783441198347581212739073179685284518526515842, 0x3064...0001)

    print(circuit.output)
