from hydra.precompiled_circuits import multi_miller_loop, final_exp
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
    N_LIMBS,
)
from hydra.hints import neg_3
from random import seed, randint
from enum import Enum
from tools.gnark_cli import GnarkCLI
import subprocess
from concurrent.futures import ProcessPoolExecutor


seed(42)


class CircuitID(Enum):
    DUMMY = int.from_bytes(b"dummy", "big")
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
    IS_ON_CURVE_G1 = int.from_bytes(b"is_on_curve_g1", "big")
    DERIVE_POINT_FROM_X = int.from_bytes(b"derive_point_from_x", "big")
    SLOPE_INTERCEPT_SAME_POINT = int.from_bytes(b"slope_intercept_same_point", "big")
    ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED = int.from_bytes(
        b"acc_eval_point_challenge", "big"
    )
    RHS_FINALIZE_ACC = int.from_bytes(b"rhs_finalize_acc", "big")
    EVAL_FUNCTION_CHALLENGE_DUPL = int.from_bytes(
        b"eval_function_challenge_dupl", "big"
    )
    ADD_EC_POINT = int.from_bytes(b"add_ec_point", "big")
    DOUBLE_EC_POINT = int.from_bytes(b"double_ec_point", "big")


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
        if auto_run:
            self.circuit: ModuloCircuit = self._run_circuit_inner(self.build_input())

    @abstractmethod
    def build_input(self) -> list[PyFelt]:
        pass

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
    ):
        super().__init__(name, input_len, curve_id, auto_run)
        self.init_hash = init_hash


class DummyCircuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True) -> None:
        super().__init__(
            name="dummy",
            input_len=N_LIMBS * 2,
            curve_id=curve_id,
            auto_run=auto_run,
        )

    def build_input(self) -> list[PyFelt]:
        return [self.field(44), self.field(4)]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(self.name, self.curve_id, generic_circuit=True)
        x, y = circuit.write_elements(input, WriteOps.INPUT)
        r = circuit.sub(x, y)  # 40
        z = circuit.div(x, y)  # 4
        c = circuit.add(r, z)  # 44
        d = circuit.sub(r, z)  # 36
        e = circuit.mul(r, z)  # 120
        f = circuit.div(r, z)  # 8
        circuit.extend_output([r, z, c, d, e, f])
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit


class IsOnCurveG1G2Circuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True):
        super().__init__(
            name="is_on_curve_g1_g2",
            input_len=N_LIMBS * (2 + 4),
            curve_id=curve_id,
            auto_run=auto_run,
        )

    def build_input(self) -> list[PyFelt]:
        cli = GnarkCLI(CurveID(self.curve_id))
        order = CURVES[self.curve_id].n
        input = []
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


class IsOnCurveG1Circuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True):
        super().__init__(
            name="is_on_curve_g1",
            input_len=N_LIMBS * (2 + 1),
            curve_id=curve_id,
            auto_run=auto_run,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        random_point = G1Point.gen_random_point(CurveID(self.curve_id))
        input.append(self.field(random_point.x))
        input.append(self.field(random_point.y))
        input.append(self.field(CURVES[self.curve_id].a))
        input.append(self.field(CURVES[self.curve_id].b))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = BasicEC(self.name, self.curve_id)
        px, py, a, b = circuit.write_elements(input[0:4], WriteOps.INPUT)
        lhs, rhs = circuit._is_on_curve_G1_weirstrass(px, py, a, b)
        zero_check = circuit.sub(lhs, rhs)
        circuit.extend_output([zero_check])
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit


class DerivePointFromXCircuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True) -> None:
        super().__init__(
            name="derive_point_from_x",
            input_len=N_LIMBS * 3,  # X + b + G
            curve_id=curve_id,
            auto_run=auto_run,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.append(self.field(randint(0, STARK - 1)))
        input.append(self.field(CURVES[self.curve_id].a))
        input.append(self.field(CURVES[self.curve_id].b))  # y^2 = x^3 + b
        input.append(self.field(CURVES[self.curve_id].fp_generator))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = DerivePointFromX(self.name, self.curve_id)
        x, a, b, g = circuit.write_elements(input[0:4], WriteOps.INPUT)
        rhs, grhs, should_be_rhs, should_be_grhs, y_try = circuit._derive_point_from_x(
            x, a, b, g
        )
        circuit.extend_output([rhs, grhs, should_be_rhs, should_be_grhs, y_try])
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit


class SlopeInterceptSamePointCircuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True) -> None:
        super().__init__(
            name="slope_intercept_same_point",
            input_len=N_LIMBS * 3,  # P(Px, Py), A in y^2 = x^3 + Ax + B
            curve_id=curve_id,
            auto_run=auto_run,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        random_point = G1Point.gen_random_point(CurveID(self.curve_id))
        input.append(self.field(random_point.x))
        input.append(self.field(random_point.y))
        input.append(self.field(CURVES[self.curve_id].a))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ECIPCircuits(self.name, self.curve_id)
        px, py, a = circuit.write_elements(input[0:3], WriteOps.INPUT)
        m_A0, b_A0, xA0, yA0, xA2, yA2, coeff0, coeff2 = (
            circuit._slope_intercept_same_point((px, py), a)
        )
        circuit.extend_output([m_A0, b_A0, xA0, yA0, xA2, yA2, coeff0, coeff2])
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit


class AccumulateEvalPointChallengeSignedCircuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True) -> None:
        super().__init__(
            name="acc_eval_point_challenge",
            input_len=N_LIMBS * 8,  # Eval_Accumulator + (m,b) + xA + (Px, Py) + ep + en
            curve_id=curve_id,
            auto_run=auto_run,
        )

    def build_input(self) -> list[PyFelt]:
        circuit = SlopeInterceptSamePointCircuit(self.curve_id, auto_run=False)
        xA, _yA, _A = circuit.build_input()
        m_A0, b_A0, xA0, yA0, xA2, yA2, coeff0, coeff2 = circuit._run_circuit_inner(
            [xA, _yA, _A]
        ).output
        input = []
        random_point = G1Point.gen_random_point(CurveID(self.curve_id))
        scalar = randint(0, 2**127)
        ep, en = neg_3.positive_negative_multiplicities(neg_3.neg_3_base_le(scalar))
        input.append(self.field(randint(0, CURVES[self.curve_id].p - 1)))
        input.append(self.field(m_A0.value))
        input.append(self.field(b_A0.value))
        input.append(self.field(xA.value))
        input.append(self.field(random_point.x))
        input.append(self.field(random_point.y))
        input.append(self.field(abs(ep)))
        input.append(self.field(abs(en)))
        input.append(self.field(1 if ep >= 0 else -1))
        input.append(self.field(1 if en >= 0 else -1))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ECIPCircuits(self.name, self.curve_id)
        acc, m, b, xA, px, py, ep, en, sp, sn = circuit.write_elements(
            input[0:10], WriteOps.INPUT
        )
        res_acc = circuit._accumulate_eval_point_challenge_signed_same_point(
            acc, (m, b), xA, (px, py), ep, en, sp, sn
        )
        circuit.extend_output([res_acc])
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit


class RHSFinalizeAccCircuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True) -> None:
        super().__init__(
            name="rhs_finalize_acc",
            input_len=N_LIMBS * 6,  # Eval_Accumulator + (m,b) + xA + (Qx, Qy)
            curve_id=curve_id,
            auto_run=auto_run,
        )

    def build_input(self) -> list[PyFelt]:
        circuit = SlopeInterceptSamePointCircuit(self.curve_id, auto_run=False)
        xA, _yA, _A = circuit.build_input()
        m_A0, b_A0, xA0, yA0, xA2, yA2, coeff0, coeff2 = circuit._run_circuit_inner(
            [xA, _yA, _A]
        ).output
        input = []
        Q = G1Point.gen_random_point(CurveID(self.curve_id))
        input.append(self.field(randint(0, CURVES[self.curve_id].p - 1)))
        input.append(self.field(m_A0.value))
        input.append(self.field(b_A0.value))
        input.append(self.field(xA.value))
        input.append(self.field(Q.x))
        input.append(self.field(Q.y))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ECIPCircuits(self.name, self.curve_id)
        acc, m, b, xA, Qx, Qy = circuit.write_elements(input[0:6], WriteOps.INPUT)
        res_acc = circuit._RHS_finalize_acc(acc, (m, b), xA, (Qx, Qy))
        circuit.extend_output([res_acc])
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit


class EvalFunctionChallengeDuplCircuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, n_points: int = 1, auto_run: bool = True) -> None:
        self.n_points = n_points
        super().__init__(
            name=f"eval_function_challenge_dupl",
            input_len=N_LIMBS
            * (
                (2 + 2 + 2)  # 2 EC challenge points (x,y) + 2 coefficients
                + (  # F=a(x) + y b(x).
                    (1 + n_points)  # Number of coefficients in a's numerator
                    + (1 + n_points + 1)  # Number of coefficients in a's denominator
                    + (1 + n_points + 1)  # Number of coefficients in b's numerator
                    + (1 + n_points + 4)  # Number of coefficients in b's denominator
                )
            ),
            curve_id=curve_id,
            auto_run=auto_run,
        )

    @staticmethod
    def _n_coeffs_from_n_points(n_points: int) -> tuple[int, int, int, int]:
        return (1 + n_points, 1 + n_points + 1, 1 + n_points + 1, 1 + n_points + 4)

    @staticmethod
    def _n_points_from_n_coeffs(n_coeffs: int) -> int:
        # n_coeffs = 10 + 4n_points => 4n_points = n_coeffs - 10
        assert n_coeffs >= 10
        assert (n_coeffs - 10) % 4 == 0
        return (n_coeffs - 10) // 4

    def build_input(self) -> list[PyFelt]:
        input = []
        circuit = SlopeInterceptSamePointCircuit(self.curve_id, auto_run=False)
        xA, _yA, _A = circuit.build_input()
        m_A0, b_A0, xA0, yA0, xA2, yA2, coeff0, coeff2 = circuit._run_circuit_inner(
            [xA, _yA, _A]
        ).output
        input.extend([xA0.felt, _yA.felt, xA2.felt, yA2.felt, coeff0.felt, coeff2.felt])
        n_coeffs = self._n_coeffs_from_n_points(self.n_points)
        for _ in range(sum(n_coeffs)):
            input.append(self.field(randint(0, CURVES[self.curve_id].p - 1)))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ECIPCircuits(self.name, self.curve_id)
        xA0, yA0, xA2, yA2, coeff0, coeff2 = circuit.write_elements(
            input[0:6], WriteOps.INPUT
        )
        all_coeffs = circuit.write_elements(input[6:], WriteOps.INPUT)

        def split_list(input_list, lengths):
            start_idx, result = 0, []
            for length in lengths:
                result.append(input_list[start_idx : start_idx + length])
                start_idx += length
            return result

        n_points = self._n_points_from_n_coeffs(len(all_coeffs))
        log_div_a_num, log_div_a_den, log_div_b_num, log_div_b_den = split_list(
            all_coeffs, self._n_coeffs_from_n_points(n_points)
        )

        res = circuit._eval_function_challenge_dupl(
            (xA0, yA0),
            (xA2, yA2),
            coeff0,
            coeff2,
            log_div_a_num,
            log_div_a_den,
            log_div_b_num,
            log_div_b_den,
        )
        circuit.extend_output([res])
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        return circuit


class AddECPointCircuit(BaseModuloCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
    ):
        super().__init__(
            name="add_ec_point",
            input_len=N_LIMBS * 4,  # xP, yP, xQ, yQ
            curve_id=curve_id,
            auto_run=auto_run,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        P = G1Point.gen_random_point(CurveID(self.curve_id))
        Q = G1Point.gen_random_point(CurveID(self.curve_id))
        input.append(self.field(P.x))
        input.append(self.field(P.y))
        input.append(self.field(Q.x))
        input.append(self.field(Q.y))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = BasicEC(self.name, self.curve_id)
        xP, yP, xQ, yQ = circuit.write_elements(input[0:4], WriteOps.INPUT)
        xR, yR = circuit.add_points((xP, yP), (xQ, yQ))
        circuit.extend_output([xR, yR])
        circuit.values_segment = circuit.values_segment.non_interactive_transform()
        # circuit.print_value_segment()
        return circuit


class DoubleECPointCircuit(BaseModuloCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
    ):
        super().__init__(
            name="double_ec_point",
            input_len=N_LIMBS * 3,  # xP, yP, A
            curve_id=curve_id,
            auto_run=auto_run,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        P = G1Point.gen_random_point(CurveID(self.curve_id))
        input.append(self.field(P.x))
        input.append(self.field(P.y))
        input.append(self.field(CURVES[self.curve_id].a))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = BasicEC(self.name, self.curve_id)
        xP, yP, A = circuit.write_elements(input[0:3], WriteOps.INPUT)
        xR, yR = circuit.double_point((xP, yP), A)
        circuit.extend_output([xR, yR])
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


# All the circuits that are going to be compiled.
ALL_EXTF_CIRCUITS = {
    CircuitID.DUMMY: {"class": DummyCircuit, "params": None},
    CircuitID.IS_ON_CURVE_G1_G2: {"class": IsOnCurveG1G2Circuit, "params": None},
    CircuitID.IS_ON_CURVE_G1: {"class": IsOnCurveG1Circuit, "params": None},
    CircuitID.DERIVE_POINT_FROM_X: {"class": DerivePointFromXCircuit, "params": None},
    CircuitID.SLOPE_INTERCEPT_SAME_POINT: {
        "class": SlopeInterceptSamePointCircuit,
        "params": None,
    },
    CircuitID.ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED: {
        "class": AccumulateEvalPointChallengeSignedCircuit,
        "params": None,
    },
    CircuitID.RHS_FINALIZE_ACC: {"class": RHSFinalizeAccCircuit, "params": None},
    CircuitID.EVAL_FUNCTION_CHALLENGE_DUPL: {
        "class": EvalFunctionChallengeDuplCircuit,
        "params": [{"n_points": k} for k in range(1, 4)],
    },
    CircuitID.FP12_MUL: {"class": FP12MulCircuit, "params": None},
    CircuitID.FINAL_EXP_PART_1: {"class": FinalExpPart1Circuit, "params": None},
    CircuitID.FINAL_EXP_PART_2: {"class": FinalExpPart2Circuit, "params": None},
    CircuitID.COMPUTE_DOUBLE_PAIR_LINES: {
        "class": ComputeDoublePairLinesCircuit,
        "params": None,
    },
    CircuitID.ACCUMULATE_SINGLE_PAIR_LINES: {
        "class": AccumulateSinglePairLinesCircuit,
        "params": None,
    },
    CircuitID.MILLER_LOOP_N1: {"class": MillerLoopN1, "params": None},
    CircuitID.MILLER_LOOP_N2: {"class": MillerLoopN2, "params": None},
    CircuitID.MILLER_LOOP_N3: {"class": MillerLoopN3, "params": None},
    CircuitID.ADD_EC_POINT: {"class": AddECPointCircuit, "params": None},
    CircuitID.DOUBLE_EC_POINT: {"class": DoubleECPointCircuit, "params": None},
}


def main():
    import re

    def to_snake_case(s: str) -> str:
        return re.sub(r"(?<=[a-z])(?=[A-Z])|[^a-zA-Z0-9]", "_", s).lower()

    PRECOMPILED_CIRCUITS_DIR = "src/fustat/precompiled_circuits/"

    """Compiles and writes all circuits to .cairo files"""
    filenames = ["final_exp", "multi_miller_loop", "extf_mul", "ec", "dummy"]
    circuit_name_to_filename = {
        CircuitID.DUMMY: "dummy",
        CircuitID.IS_ON_CURVE_G1_G2: "ec",
        CircuitID.IS_ON_CURVE_G1: "ec",
        CircuitID.DERIVE_POINT_FROM_X: "ec",
        CircuitID.SLOPE_INTERCEPT_SAME_POINT: "ec",
        CircuitID.ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED: "ec",
        CircuitID.RHS_FINALIZE_ACC: "ec",
        CircuitID.EVAL_FUNCTION_CHALLENGE_DUPL: "ec",
        CircuitID.ADD_EC_POINT: "ec",
        CircuitID.DOUBLE_EC_POINT: "ec",
        CircuitID.FP12_MUL: "extf_mul",
        CircuitID.FINAL_EXP_PART_1: "final_exp",
        CircuitID.FINAL_EXP_PART_2: "final_exp",
        CircuitID.COMPUTE_DOUBLE_PAIR_LINES: "multi_miller_loop",
        CircuitID.ACCUMULATE_SINGLE_PAIR_LINES: "multi_miller_loop",
        CircuitID.MILLER_LOOP_N1: "multi_miller_loop",
        CircuitID.MILLER_LOOP_N2: "multi_miller_loop",
        CircuitID.MILLER_LOOP_N3: "multi_miller_loop",
    }
    # Ensure the 'codes' dict keys match the filenames used for file creation.
    # Using sets to remove pot
    codes = {filename: set() for filename in filenames}
    selector_functions = {filename: set() for filename in filenames}

    files = {f: open(f"{PRECOMPILED_CIRCUITS_DIR}{f}.cairo", "w") for f in filenames}

    # Write the header to each file
    header = """
from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from modulo_circuit import ExtensionFieldModuloCircuit, ModuloCircuit, get_void_modulo_circuit, get_void_extension_field_modulo_circuit
from definitions import bn, bls
"""
    for file in files.values():
        file.write(header)

    def compile_circuit(
        curve_id: CurveID,
        circuit_class: BaseModuloCircuit,
        circuit_id: CircuitID,
        params: list[dict],
    ) -> tuple[list[str], str]:
        print(
            f"Compiling {curve_id.name}:{circuit_class.__name__} {f'with params {params}' if params else ''}..."
        )
        param_name = list(params[0].keys())[0] if params else None

        circuits: list[BaseModuloCircuit] = []
        compiled_circuits: list[str] = []

        if params is None:
            circuit_instance = circuit_class(curve_id.value)
            circuits.append(circuit_instance)
        else:
            for param in params:
                circuit_instance = circuit_class(curve_id.value, **param)
                circuits.append(circuit_instance)

        selector_function = build_selector_function(circuit_id, circuits[0], params)

        for i, circuit_instance in enumerate(circuits):
            function_name = (
                f"{circuit_id.name}"
                if circuit_instance.circuit.generic_circuit
                else f"{curve_id.name}_{circuit_id.name}"
            )
            function_name += f"_{params[i][param_name]}" if params else ""

            compiled_circuit = circuit_instance.circuit.compile_circuit(
                function_name=function_name
            )

            compiled_circuits.append(compiled_circuit)

        return compiled_circuits, selector_function

    def build_selector_function(
        circuit_id: CircuitID, circuit_instance: BaseModuloCircuit, params: list[dict]
    ) -> str:
        struct_name = circuit_instance.circuit.class_name

        if circuit_instance.circuit.generic_circuit and params is None:
            selector_function = ""
        elif circuit_instance.circuit.generic_circuit and params is not None:
            param_name = list(params[0].keys())[0]
            selector_function = f"""
            func get_{circuit_id.name}_circuit(curve_id:felt, {param_name}:felt) -> (circuit:{struct_name}*){{
            tempvar offset = 2 * ({list(params[0].keys())[0]} - 1) + 1;
            jmp rel offset;
            """
            for param in params:
                selector_function += f"""
                jmp circuit_{param[param_name]};
                """

            for param in params:
                selector_function += f"""
                circuit_{param[param_name]}:
                let curve_id = [fp - 4];
                return get_{circuit_id.name}_{param[param_name]}_circuit(curve_id);
                """
            selector_function += "\n}\n"

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

        # selector_functions[filename_key].add(selector_function)

        return selector_function

    # Instantiate and compile circuits for each curve
    for curve_id in [CurveID.BN254, CurveID.BLS12_381]:
        for circuit_id, circuit_info in ALL_EXTF_CIRCUITS.items():
            filename_key = circuit_name_to_filename[circuit_id]
            compiled_circuits, selector_function = compile_circuit(
                curve_id,
                circuit_info["class"],
                circuit_id,
                circuit_info["params"],
            )
            codes[filename_key].update(compiled_circuits)
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
                files[filename].write(compiled_circuit + "\n")
        else:
            print(f"Warning: No file associated with filename '{filename}'")

    # Close all files
    for file in files.values():
        file.close()

    def format_cairo_files_in_parallel(filenames):
        print(f"Formatting .cairo files in parallel...")
        cairo_files = [f"{PRECOMPILED_CIRCUITS_DIR}{f}.cairo" for f in filenames]
        with ProcessPoolExecutor() as executor:
            futures = [
                executor.submit(
                    subprocess.run, ["cairo-format", file, "-i"], check=True
                )
                for file in cairo_files
            ]
            for future in futures:
                future.result()  # Wait for all formatting tasks to complete
        print(f"Done!")

    format_cairo_files_in_parallel(filenames)
    return None


if __name__ == "__main__":
    main()
