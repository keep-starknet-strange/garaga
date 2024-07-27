import subprocess
from concurrent.futures import ProcessPoolExecutor
from enum import Enum
from random import randint, seed

import hydra.modulo_circuit_structs as structs
from hydra.definitions import (
    BLS12_381_ID,
    BN254_ID,
    CURVES,
    N_LIMBS,
    STARK,
    CurveID,
    G1Point,
    G2Point,
    get_base_field,
    get_irreducible_poly,
)
from hydra.extension_field_modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuit,
    ModuloCircuitElement,
    PyFelt,
    WriteOps,
)
from hydra.hints import neg_3
from hydra.hints.ecip import slope_intercept
from hydra.hints.io import int_array_to_u384_array, int_to_u384
from hydra.modulo_circuit_structs import (
    E12D,
    BLSProcessedPair,
    BNProcessedPair,
    Cairo1SerializableStruct,
    G1PointCircuit,
    G2PointCircuit,
    MillerLoopResultScalingFactor,
    u384,
)
from hydra.precompiled_circuits import final_exp, multi_miller_loop, multi_pairing_check
from hydra.precompiled_circuits.ec import (
    BasicEC,
    DerivePointFromX,
    ECIPCircuits,
    IsOnCurveCircuit,
)
from tools.gnark_cli import GnarkCLI

seed(0)


class CircuitID(Enum):
    DUMMY = int.from_bytes(b"dummy", "big")
    FP12_MUL = int.from_bytes(b"fp12_mul", "big")
    FP12_SUB = int.from_bytes(b"fp12_sub", "big")
    FINAL_EXP_PART_1 = int.from_bytes(b"final_exp_part_1", "big")
    FINAL_EXP_PART_2 = int.from_bytes(b"final_exp_part_2", "big")
    MULTI_MILLER_LOOP = int.from_bytes(b"multi_miller_loop", "big")
    MULTI_PAIRING_CHECK = int.from_bytes(b"multi_pairing_check", "big")
    IS_ON_CURVE_G1_G2 = int.from_bytes(b"is_on_curve_g1_g2", "big")
    IS_ON_CURVE_G1 = int.from_bytes(b"is_on_curve_g1", "big")
    IS_ON_CURVE_G2 = int.from_bytes(b"is_on_curve_g2", "big")
    DERIVE_POINT_FROM_X = int.from_bytes(b"derive_point_from_x", "big")
    SLOPE_INTERCEPT_SAME_POINT = int.from_bytes(b"slope_intercept_same_point", "big")
    ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED = int.from_bytes(
        b"acc_eval_point_challenge", "big"
    )
    RHS_FINALIZE_ACC = int.from_bytes(b"rhs_finalize_acc", "big")
    EVAL_FUNCTION_CHALLENGE_DUPL = int.from_bytes(
        b"eval_function_challenge_dupl", "big"
    )
    INIT_FUNCTION_CHALLENGE_DUPL = int.from_bytes(
        b"init_function_challenge_dupl", "big"
    )
    ACC_FUNCTION_CHALLENGE_DUPL = int.from_bytes(b"acc_function_challenge_dupl", "big")
    FINALIZE_FUNCTION_CHALLENGE_DUPL = int.from_bytes(
        b"finalize_function_challenge_dupl", "big"
    )
    ADD_EC_POINT = int.from_bytes(b"add_ec_point", "big")
    DOUBLE_EC_POINT = int.from_bytes(b"double_ec_point", "big")
    MP_CHECK_BIT0_LOOP = int.from_bytes(b"mp_check_bit0_loop", "big")
    MP_CHECK_BIT00_LOOP = int.from_bytes(b"mp_check_bit00_loop", "big")
    MP_CHECK_BIT1_LOOP = int.from_bytes(b"mp_check_bit1_loop", "big")
    MP_CHECK_PREPARE_PAIRS = int.from_bytes(b"mp_check_prepare_pairs", "big")
    MP_CHECK_PREPARE_LAMBDA_ROOT = int.from_bytes(
        b"mp_check_prepare_lambda_root", "big"
    )
    MP_CHECK_INIT_BIT = int.from_bytes(b"mp_check_init_bit", "big")
    MP_CHECK_FINALIZE_BN = int.from_bytes(b"mp_check_finalize_bn", "big")
    MP_CHECK_FINALIZE_BLS = int.from_bytes(b"mp_check_finalize_bls", "big")
    FP12_MUL_ASSERT_ONE = int.from_bytes(b"fp12_mul_assert_one", "big")


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


class DummyCircuit(BaseModuloCircuit):
    def __init__(
        self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0
    ) -> None:
        super().__init__(
            name="dummy",
            input_len=N_LIMBS * 2,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        return [self.field(44), self.field(4)]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(
            self.name,
            self.curve_id,
            generic_circuit=True,
            compilation_mode=self.compilation_mode,
        )
        x, y = circuit.write_elements(input, WriteOps.INPUT)
        r = circuit.sub(x, y)  # 40
        z = circuit.div(x, y)  # 4
        c = circuit.add(r, z)  # 44
        d = circuit.sub(r, z)  # 36
        e = circuit.mul(r, z)  # 120
        f = circuit.div(r, z)  # 8
        circuit.extend_output([r, z, c, d, e, f])

        return circuit


class IsOnCurveG1G2Circuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0):
        super().__init__(
            name="is_on_curve_g1_g2",
            input_len=N_LIMBS * (2 + 4),
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        cli = GnarkCLI(CurveID(self.curve_id))
        order = CURVES[self.curve_id].n
        input = []
        n1, n2 = randint(1, order), randint(1, order)
        input.extend([self.field(x) for x in cli.nG1nG2_operation(n1, n2, raw=True)])
        input.append(self.field(CURVES[self.curve_id].a))
        input.append(self.field(CURVES[self.curve_id].b))
        input.append(self.field(CURVES[self.curve_id].b20))
        input.append(self.field(CURVES[self.curve_id].b21))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit: IsOnCurveCircuit = IsOnCurveCircuit(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        assert len(input) == 6 + 4, f"got {input} of len {len(input)}"
        p = circuit.write_struct(G1PointCircuit("p", input[0:2]), WriteOps.INPUT)
        q = circuit.write_struct(G2PointCircuit("q", input[2:6]), WriteOps.INPUT)
        a = circuit.write_struct(u384("a", [input[6]]), WriteOps.INPUT)
        b = circuit.write_struct(u384("b", [input[7]]), WriteOps.INPUT)
        b20 = circuit.write_struct(u384("b20", [input[8]]), WriteOps.INPUT)
        b21 = circuit.write_struct(u384("b21", [input[9]]), WriteOps.INPUT)

        circuit.set_consts(a, b, b20, b21)
        lhs, rhs = circuit._is_on_curve_G1(*p)
        lhs2, rhs2 = circuit._is_on_curve_G2(*q)
        zero_check = circuit.sub(lhs, rhs)
        zero_check_2 = [circuit.sub(lhs2[0], rhs2[0]), circuit.sub(lhs2[1], rhs2[1])]

        circuit.extend_struct_output(u384("zero_check_0", [zero_check]))
        circuit.extend_struct_output(u384("zero_check_1", [zero_check_2[0]]))
        circuit.extend_struct_output(u384("zero_check_2", [zero_check_2[1]]))

        return circuit


class IsOnCurveG1Circuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0):
        super().__init__(
            name="is_on_curve_g1",
            input_len=N_LIMBS * (2 + 1),
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
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
        circuit = BasicEC(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        px, py = circuit.write_struct(G1PointCircuit("p", input[0:2]), WriteOps.INPUT)
        a = circuit.write_struct(u384("a", [input[2]]), WriteOps.INPUT)
        b = circuit.write_struct(u384("b", [input[3]]), WriteOps.INPUT)

        lhs, rhs = circuit._is_on_curve_G1_weirstrass(px, py, a, b)
        zero_check = circuit.sub(lhs, rhs)
        circuit.extend_struct_output(u384("zero_check", [zero_check]))

        return circuit


class IsOnCurveG2Circuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0):
        super().__init__(
            name="is_on_curve_g2",
            input_len=N_LIMBS * (2 + 1),
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        random_point = G2Point.gen_random_point(CurveID(self.curve_id))
        input.append(self.field(random_point.x[0]))
        input.append(self.field(random_point.x[1]))
        input.append(self.field(random_point.y[0]))
        input.append(self.field(random_point.y[1]))
        input.append(self.field(CURVES[self.curve_id].a))
        input.append(self.field(CURVES[self.curve_id].b20))
        input.append(self.field(CURVES[self.curve_id].b21))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = BasicEC(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        x0, x1, y0, y1 = circuit.write_struct(
            G2PointCircuit("p", input[0:4]), WriteOps.INPUT
        )
        a = circuit.write_struct(u384("a", [input[4]]), WriteOps.INPUT)
        b20 = circuit.write_struct(u384("b20", [input[5]]), WriteOps.INPUT)
        b21 = circuit.write_struct(u384("b21", [input[6]]), WriteOps.INPUT)

        lhs, rhs = circuit._is_on_curve_G2_weirstrass(x0, x1, y0, y1, a, b20, b21)
        zero_check = [circuit.sub(lhs[0], rhs[0]), circuit.sub(lhs[1], rhs[1])]
        circuit.extend_struct_output(u384("zero_check_0", [zero_check[0]]))
        circuit.extend_struct_output(u384("zero_check_1", [zero_check[1]]))

        return circuit


class DerivePointFromXCircuit(BaseModuloCircuit):
    def __init__(
        self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0
    ) -> None:
        super().__init__(
            name="derive_point_from_x",
            input_len=N_LIMBS * 3,  # X + b + G
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.append(self.field(randint(0, STARK - 1)))
        input.append(self.field(CURVES[self.curve_id].a))
        input.append(self.field(CURVES[self.curve_id].b))  # y^2 = x^3 + b
        input.append(self.field(CURVES[self.curve_id].fp_generator))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = DerivePointFromX(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        x, a, b, g = circuit.write_elements(input[0:4], WriteOps.INPUT)
        rhs, grhs, should_be_rhs, should_be_grhs, y_try = circuit._derive_point_from_x(
            x, a, b, g
        )
        circuit.extend_output([rhs, grhs, should_be_rhs, should_be_grhs, y_try])

        return circuit


class SlopeInterceptSamePointCircuit(BaseModuloCircuit):
    def __init__(
        self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0
    ) -> None:
        super().__init__(
            name="slope_intercept_same_point",
            input_len=N_LIMBS * 3,  # P(Px, Py), A in y^2 = x^3 + Ax + B
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        random_point = G1Point.gen_random_point(CurveID(self.curve_id))
        input.append(self.field(random_point.x))
        input.append(self.field(random_point.y))
        input.append(self.field(CURVES[self.curve_id].a))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ECIPCircuits(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        px, py = circuit.write_struct(G1PointCircuit("p", input[0:2]), WriteOps.INPUT)
        a = circuit.write_struct(u384("a", [input[2]]), WriteOps.INPUT)
        m_A0, b_A0, xA0, yA0, xA2, yA2, coeff0, coeff2 = (
            circuit._slope_intercept_same_point((px, py), a)
        )
        if self.compilation_mode == 0:
            # In Cairo0, xA0 and yA0 are copied from the input
            circuit.extend_output([m_A0, b_A0, xA0, yA0, xA2, yA2, coeff0, coeff2])
        else:
            # In Cairo1, xA0 and yA0 are not copied from the input
            circuit.extend_struct_output(
                structs.SlopeInterceptOutput(
                    "mb", [m_A0, b_A0, xA2, yA2, coeff0, coeff2]
                )
            )

        return circuit


class AccumulateEvalPointChallengeSignedCircuit(BaseModuloCircuit):
    def __init__(
        self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0
    ) -> None:
        super().__init__(
            name="acc_eval_point_challenge",
            input_len=N_LIMBS * 8,  # Eval_Accumulator + (m,b) + xA + (Px, Py) + ep + en
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        A0 = G1Point.gen_random_point(CurveID(self.curve_id))
        m_A0, b_A0 = slope_intercept(A0, A0)
        input = []
        random_point = G1Point.gen_random_point(CurveID(self.curve_id))
        scalar = randint(0, 2**127)
        ep, en = neg_3.positive_negative_multiplicities(neg_3.neg_3_base_le(scalar))
        input.append(self.field(randint(0, CURVES[self.curve_id].p - 1)))
        input.append(self.field(m_A0.value))
        input.append(self.field(b_A0.value))
        input.append(self.field(A0.x))
        input.append(self.field(random_point.x))
        input.append(self.field(random_point.y))
        input.append(self.field(abs(ep)))
        input.append(self.field(abs(en)))
        input.append(self.field(1 if ep >= 0 else -1))
        input.append(self.field(1 if en >= 0 else -1))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ECIPCircuits(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        # acc, m, b, xA, px, py, ep, en, sp, sn = circuit.write_elements(
        #     input[0:10], WriteOps.INPUT
        # )
        acc, m, b, xA = (
            circuit.write_struct(u384("acc", [input[0]]), WriteOps.INPUT),
            circuit.write_struct(u384("m", [input[1]]), WriteOps.INPUT),
            circuit.write_struct(u384("b", [input[2]]), WriteOps.INPUT),
            circuit.write_struct(u384("xA", [input[3]]), WriteOps.INPUT),
        )
        px, py = circuit.write_struct(G1PointCircuit("p", input[4:6]), WriteOps.INPUT)
        ep = circuit.write_struct(u384("ep", [input[6]]), WriteOps.INPUT)
        en = circuit.write_struct(u384("en", [input[7]]), WriteOps.INPUT)
        sp = circuit.write_struct(u384("sp", [input[8]]), WriteOps.INPUT)
        sn = circuit.write_struct(u384("sn", [input[9]]), WriteOps.INPUT)

        res_acc = circuit._accumulate_eval_point_challenge_signed_same_point(
            acc, (m, b), xA, (px, py), ep, en, sp, sn
        )
        circuit.extend_struct_output(u384("res_acc", [res_acc]))

        return circuit


class RHSFinalizeAccCircuit(BaseModuloCircuit):
    def __init__(
        self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0
    ) -> None:
        super().__init__(
            name="rhs_finalize_acc",
            input_len=N_LIMBS * 6,  # Eval_Accumulator + (m,b) + xA + (Qx, Qy)
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        A0 = G1Point.gen_random_point(CurveID(self.curve_id))
        m_A0, b_A0 = slope_intercept(A0, A0)
        input = []
        Q = G1Point.gen_random_point(CurveID(self.curve_id))
        input.append(self.field(randint(0, CURVES[self.curve_id].p - 1)))
        input.append(self.field(m_A0.value))
        input.append(self.field(b_A0.value))
        input.append(self.field(A0.x))
        input.append(self.field(Q.x))
        input.append(self.field(Q.y))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ECIPCircuits(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        # acc, m, b, xA, Qx, Qy = circuit.write_elements(input[0:6], WriteOps.INPUT)
        acc, m, b, xA = (
            circuit.write_struct(u384("acc", [input[0]]), WriteOps.INPUT),
            circuit.write_struct(u384("m", [input[1]]), WriteOps.INPUT),
            circuit.write_struct(u384("b", [input[2]]), WriteOps.INPUT),
            circuit.write_struct(u384("xA", [input[3]]), WriteOps.INPUT),
        )
        Qx, Qy = circuit.write_struct(
            G1PointCircuit("Q_result", input[4:6]), WriteOps.INPUT
        )
        res_acc = circuit._RHS_finalize_acc(acc, (m, b), xA, (Qx, Qy))
        circuit.extend_struct_output(u384("rhs", [res_acc]))

        return circuit


class EvalFunctionChallengeDuplCircuit(BaseModuloCircuit):
    def __init__(
        self,
        curve_id: int,
        n_points: int = 1,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ) -> None:
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
            compilation_mode=compilation_mode,
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
        circuit = ECIPCircuits(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )

        xA0, yA0 = circuit.write_struct(
            G1PointCircuit("A0", [input[0], input[1]]), WriteOps.INPUT
        )
        xA2, yA2 = circuit.write_struct(
            G1PointCircuit("A2", [input[2], input[3]]), WriteOps.INPUT
        )
        coeff0 = circuit.write_struct(u384("coeff0", [input[4]]), WriteOps.INPUT)
        coeff2 = circuit.write_struct(u384("coeff2", [input[5]]), WriteOps.INPUT)

        all_coeffs = input[6:]

        def split_list(input_list, lengths):
            start_idx, result = 0, []
            for length in lengths:
                result.append(input_list[start_idx : start_idx + length])
                start_idx += length
            return result

        n_points = self._n_points_from_n_coeffs(len(all_coeffs))
        _log_div_a_num, _log_div_a_den, _log_div_b_num, _log_div_b_den = split_list(
            all_coeffs, self._n_coeffs_from_n_points(n_points)
        )
        log_div_a_num, log_div_a_den, log_div_b_num, log_div_b_den = (
            circuit.write_struct(
                structs.FunctionFeltCircuit(
                    name="SumDlogDiv",
                    elmts=[
                        structs.u384Span("log_div_a_num", _log_div_a_num),
                        structs.u384Span("log_div_a_den", _log_div_a_den),
                        structs.u384Span("log_div_b_num", _log_div_b_num),
                        structs.u384Span("log_div_b_den", _log_div_b_den),
                    ],
                ),
                WriteOps.INPUT,
            )
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
        circuit.extend_struct_output(u384("res", [res]))

        return circuit


class InitFunctionChallengeDuplCircuit(BaseModuloCircuit):
    def __init__(
        self,
        curve_id: int,
        n_points: int = 1,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ) -> None:
        self.n_points = n_points
        super().__init__(
            name=f"init_function_challenge_dupl",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
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
        input.extend([self.field.random(), self.field.random()])  # xA0, xA2
        n_coeffs = self._n_coeffs_from_n_points(self.n_points)
        for _ in range(sum(n_coeffs)):
            input.append(self.field(randint(0, CURVES[self.curve_id].p - 1)))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ECIPCircuits(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        xA0 = circuit.write_struct(u384("xA0", [input[0]]), WriteOps.INPUT)
        xA2 = circuit.write_struct(u384("xA2", [input[1]]), WriteOps.INPUT)

        all_coeffs = input[2:]

        def split_list(input_list, lengths):
            start_idx, result = 0, []
            for length in lengths:
                result.append(input_list[start_idx : start_idx + length])
                start_idx += length
            return result

        n_points = self._n_points_from_n_coeffs(len(all_coeffs))
        _log_div_a_num, _log_div_a_den, _log_div_b_num, _log_div_b_den = split_list(
            all_coeffs, self._n_coeffs_from_n_points(n_points)
        )

        log_div_a_num, log_div_a_den, log_div_b_num, log_div_b_den = (
            circuit.write_struct(
                structs.FunctionFeltCircuit(
                    name="SumDlogDiv",
                    elmts=[
                        structs.u384Span("log_div_a_num", _log_div_a_num),
                        structs.u384Span("log_div_a_den", _log_div_a_den),
                        structs.u384Span("log_div_b_num", _log_div_b_num),
                        structs.u384Span("log_div_b_den", _log_div_b_den),
                    ],
                ),
                WriteOps.INPUT,
            )
        )

        res = circuit._init_function_challenge_dupl(
            xA0, xA2, log_div_a_num, log_div_a_den, log_div_b_num, log_div_b_den
        )
        circuit.extend_struct_output(
            structs.FunctionFeltEvaluations("A0_evals", res[0:4])
        )
        circuit.extend_struct_output(
            structs.FunctionFeltEvaluations("A2_evals", res[4:8])
        )
        circuit.extend_struct_output(u384("xA0_power", [res[8]]))
        circuit.extend_struct_output(u384("xA2_power", [res[9]]))
        return circuit


class AccumulateFunctionChallengeDuplCircuit(BaseModuloCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ):
        super().__init__(
            name="acc_function_challenge_dupl",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend(
            [self.field.random() for _ in range(8)]
        )  # a_num, a_den, b_num, b_den accumulation evals * 2
        input.extend([self.field.random(), self.field.random()])  # xA0, xA2
        input.extend(
            [self.field.random(), self.field.random()]
        )  # xA0_power, xA2_power, corresponding the max degree of a_den or b_num of the previous accumulator
        input.extend(
            [self.field.random() for _ in range(4)]
        )  # next coefficients of a_num, a_den, b_num, b_den
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ECIPCircuits(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )

        f_a0_accs = circuit.write_struct(
            structs.FunctionFeltEvaluations("f_a0_accs", input[0:4]), WriteOps.INPUT
        )
        f_a1_accs = circuit.write_struct(
            structs.FunctionFeltEvaluations("f_a1_accs", input[4:8]), WriteOps.INPUT
        )
        xA0 = circuit.write_struct(u384("xA0", [input[8]]), WriteOps.INPUT)
        xA2 = circuit.write_struct(u384("xA2", [input[9]]), WriteOps.INPUT)
        xA0_power = circuit.write_struct(u384("xA0_power", [input[10]]), WriteOps.INPUT)
        xA2_power = circuit.write_struct(u384("xA2_power", [input[11]]), WriteOps.INPUT)
        next_a_num_coeff = circuit.write_struct(
            u384("next_a_num_coeff", [input[12]]), WriteOps.INPUT
        )
        next_a_den_coeff = circuit.write_struct(
            u384("next_a_den_coeff", [input[13]]), WriteOps.INPUT
        )
        next_b_num_coeff = circuit.write_struct(
            u384("next_b_num_coeff", [input[14]]), WriteOps.INPUT
        )
        next_b_den_coeff = circuit.write_struct(
            u384("next_b_den_coeff", [input[15]]), WriteOps.INPUT
        )

        res = circuit._accumulate_function_challenge_dupl(
            *f_a0_accs,
            *f_a1_accs,
            xA0,
            xA2,
            xA0_power,
            xA2_power,
            next_a_num_coeff,
            next_a_den_coeff,
            next_b_num_coeff,
            next_b_den_coeff,
        )

        circuit.extend_struct_output(
            structs.FunctionFeltEvaluations("next_f_a0_accs", res[0:4])
        )
        circuit.extend_struct_output(
            structs.FunctionFeltEvaluations("next_f_a1_accs", res[4:8])
        )
        circuit.extend_struct_output(u384("next_xA0_power", [res[8]]))
        circuit.extend_struct_output(u384("next_xA2_power", [res[9]]))
        return circuit


class FinalizeFunctionChallengeDuplCircuit(BaseModuloCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ):
        super().__init__(
            name="final_function_challenge_dupl",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(8)])  # f_a0_accs, f_a1_accs
        input.extend([self.field.random() for _ in range(2)])  # yA0, yA2
        input.extend([self.field.random() for _ in range(2)])  # coeff_A0, coeff_A2
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ECIPCircuits(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        f_a0_accs = circuit.write_struct(
            structs.FunctionFeltEvaluations("f_a0_accs", input[0:4]), WriteOps.INPUT
        )
        f_a1_accs = circuit.write_struct(
            structs.FunctionFeltEvaluations("f_a1_accs", input[4:8]), WriteOps.INPUT
        )
        yA0 = circuit.write_struct(u384("yA0", [input[8]]), WriteOps.INPUT)
        yA2 = circuit.write_struct(u384("yA2", [input[9]]), WriteOps.INPUT)
        coeff_A0 = circuit.write_struct(u384("coeff_A0", [input[10]]), WriteOps.INPUT)
        coeff_A2 = circuit.write_struct(u384("coeff_A2", [input[11]]), WriteOps.INPUT)

        res = circuit._finalize_function_challenge_dupl(
            *f_a0_accs, *f_a1_accs, yA0, yA2, coeff_A0, coeff_A2
        )

        circuit.extend_struct_output(u384("res", [res]))
        return circuit


class AddECPointCircuit(BaseModuloCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ):
        super().__init__(
            name="add_ec_point",
            input_len=N_LIMBS * 4,  # xP, yP, xQ, yQ
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
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
        circuit = BasicEC(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        xP, yP = circuit.write_struct(G1PointCircuit("p", input[0:2]), WriteOps.INPUT)
        xQ, yQ = circuit.write_struct(G1PointCircuit("q", input[2:4]), WriteOps.INPUT)
        xR, yR = circuit.add_points((xP, yP), (xQ, yQ))
        circuit.extend_struct_output(G1PointCircuit("r", [xR, yR]))

        return circuit


class DoubleECPointCircuit(BaseModuloCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ):
        super().__init__(
            name="double_ec_point",
            input_len=N_LIMBS * 3,  # xP, yP, A
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        P = G1Point.gen_random_point(CurveID(self.curve_id))
        input.append(self.field(P.x))
        input.append(self.field(P.y))
        input.append(self.field(CURVES[self.curve_id].a))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = BasicEC(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        xP, yP = circuit.write_struct(G1PointCircuit("p", input[0:2]), WriteOps.INPUT)
        A = circuit.write_struct(u384("A_weirstrass", [input[2]]))
        xR, yR = circuit.double_point((xP, yP), A)
        circuit.extend_struct_output(G1PointCircuit("r", [xR, yR]))

        return circuit


class FP12MulCircuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "fp12_mul", 24, curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        return [self.field(randint(0, self.field.p - 1)) for _ in range(self.input_len)]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ExtensionFieldModuloCircuit:
        circuit = ExtensionFieldModuloCircuit(
            self.name,
            self.curve_id,
            extension_degree=12,
            init_hash=self.init_hash,
            compilation_mode=self.compilation_mode,
        )
        X = circuit.write_elements(input[0:12], WriteOps.INPUT)
        Y = circuit.write_elements(input[12:24], WriteOps.INPUT)
        xy = circuit.extf_mul([X, Y], 12)
        circuit.extend_output(xy)
        circuit.finalize_circuit()

        return circuit


class FinalExpPart1Circuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "final_exp_part_1", 12, curve_id, auto_run, init_hash, compilation_mode
        )

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

        return circuit


class FinalExpPart2Circuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "final_exp_part_2", 12, curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        return [self.field(randint(0, self.field.p - 1)) for _ in range(self.input_len)]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ExtensionFieldModuloCircuit:
        circuit: final_exp.FinalExpTorusCircuit = final_exp.GaragaFinalExp[
            CurveID(self.curve_id)
        ](name="final_exp_part_2", hash_input=False, init_hash=self.init_hash)
        res = circuit.final_exp_finalize(input[0:6], input[6:12])
        circuit.extend_output(res)

        return circuit


class MultiMillerLoop(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int = 0,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ):
        self.n_pairs = n_pairs
        super().__init__(
            f"multi_miller_loop", 6 * n_pairs, curve_id, auto_run, compilation_mode
        )
        self.generic_over_curve = True

    def build_input(self) -> list[PyFelt]:
        cli = GnarkCLI(CurveID(self.curve_id))
        order = CURVES[self.curve_id].n
        input = []
        for _ in range(self.n_pairs):
            n1, n2 = randint(1, order), randint(1, order)
            input.extend(
                [self.field(x) for x in cli.nG1nG2_operation(n1, n2, raw=True)]
            )
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        assert (
            len(input) % 6 == 0
        ), f"Input length must be a multiple of 6, got {len(input)}"
        n_pairs = len(input) // 6
        circuit = multi_miller_loop.MultiMillerLoopCircuit(
            self.name,
            self.curve_id,
            n_pairs=n_pairs,
            hash_input=True,
        )
        circuit.write_p_and_q(input)

        m = circuit.miller_loop(n_pairs)

        circuit.extend_output(m)
        circuit.finalize_circuit()

        return circuit


class MultiPairingCheck(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int = 0,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ):
        self.n_pairs = n_pairs
        super().__init__(
            f"multi_miller_loop", 6 * n_pairs, curve_id, auto_run, compilation_mode
        )
        self.generic_over_curve = True

    def build_input(self) -> list[PyFelt]:

        input, _ = multi_pairing_check.get_pairing_check_input(
            CurveID(self.curve_id), self.n_pairs
        )
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        assert (
            len(input) % 6 == 0
        ), f"Input length must be a multiple of 6, got {len(input)}"
        n_pairs = len(input) // 6
        assert n_pairs >= 2, f"n_pairs must be >= 2, got {n_pairs}"
        circuit = multi_pairing_check.MultiPairingCheckCircuit(
            self.name,
            self.curve_id,
            n_pairs=n_pairs,
            hash_input=True,
        )
        circuit.write_p_and_q(input)

        m, _, _, _, _ = circuit.multi_pairing_check(n_pairs)

        circuit.extend_output(m)
        circuit.finalize_circuit()

        return circuit


class MPCheckBit0Loop(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int = 0,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        self.n_pairs = n_pairs
        super().__init__(
            name=f"mpcheck_bit0",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )
        self.generic_over_curve = True

    def build_input(self) -> list[PyFelt]:
        """
        - (PyInv, PxNegOverY, Qx0, Qx1, Qy0, Qy1) * (n_pairs)
        - LHS = sum(ci*prod(Pi,j))(z) (1 u384)
        - sum (ci_-1*Ri_-1) (12 u384)
        - f:E12 (12 u384)
        - z (1 u384)
        - ci (1 u384)
        """
        input = []
        for _ in range(self.n_pairs):
            p = G1Point.gen_random_point(CurveID(self.curve_id))
            current_q = G2Point.gen_random_point(CurveID(self.curve_id))
            yInv = self.field(p.y).__inv__()
            xNegOverY = -self.field(p.x) * yInv
            input.extend(
                [
                    yInv,
                    xNegOverY,
                    self.field(current_q.x[0]),
                    self.field(current_q.x[1]),
                    self.field(current_q.y[0]),
                    self.field(current_q.y[1]),
                ]
            )

        input.append(
            self.field.random()
        )  # LHS accumulation = Sum(ci*(prod(Pi,j)-Ri)(z))
        input.append(self.field.random())  # R(i-1)(z) = f(i-1)(z) for miller loop.
        input.extend([self.field.random() for _ in range(12)])  # Ri = new_f
        input.append(self.field.random())  # ci_minus_one
        input.append(self.field(randint(0, STARK - 1)))  # z
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        n_pairs = self.n_pairs
        assert n_pairs >= 2, f"n_pairs must be >= 2, got {n_pairs}"
        circuit: multi_pairing_check.MultiPairingCheckCircuit = (
            multi_pairing_check.MultiPairingCheckCircuit(
                self.name,
                self.curve_id,
                n_pairs=n_pairs,
                hash_input=False,
                compilation_mode=self.compilation_mode,
            )
        )
        # Parse (yInv, xNegOverY, Qx0, Qx1, Qy0, Qy1) * n_pairs
        current_points = []
        for i in range(n_pairs):
            circuit.yInv.append(
                circuit.write_struct(u384(name=f"yInv_{i}", elmts=[input.pop(0)]))
            )
            circuit.xNegOverY.append(
                circuit.write_struct(u384(name=f"xNegOverY_{i}", elmts=[input.pop(0)]))
            )
            current_pt = circuit.write_struct(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[input.pop(0), input.pop(0), input.pop(0), input.pop(0)],
                )
            )
            current_points.append(
                (
                    [
                        current_pt[0],
                        current_pt[1],
                    ],
                    [
                        current_pt[2],
                        current_pt[3],
                    ],
                )
            )

        lhs_i = circuit.write_struct(u384(name="lhs_i", elmts=[input.pop(0)]))
        f_i_of_z: ModuloCircuitElement = circuit.write_struct(
            u384(name="f_i_of_z", elmts=[input.pop(0)])
        )

        # f_i_plus_one is R as the result E12 for this bit.
        f_i_plus_one: list[ModuloCircuitElement] = circuit.write_struct(
            E12D(name="f_i_plus_one", elmts=[input.pop(0) for _ in range(12)])
        )
        ci = circuit.write_struct(u384(name="ci", elmts=[input.pop(0)]))
        assert len(input) == 1, f"Input should be empty now"

        circuit.create_powers_of_Z(
            circuit.write_struct(u384(name="z", elmts=[input.pop(0)])), max_degree=11
        )
        ci_plus_one = circuit.mul(ci, ci, f"Compute c_i = (c_(i-1))^2")

        assert len(input) == 0, f"Input should be empty now"
        assert len(current_points) == n_pairs

        sum_i_prod_k_P = circuit.mul(
            f_i_of_z, f_i_of_z, f"Square f evaluation in Z, the result of previous bit."
        )
        new_points = []
        for k in range(n_pairs):
            T, l1 = circuit.double_step(current_points[k], k)
            sum_i_prod_k_P = circuit.mul(
                sum_i_prod_k_P,
                circuit.eval_poly_in_precomputed_Z(l1, circuit.line_sparsity),
                f"Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_{k}(z)",
            )

            new_points.append(T)

        f_i_plus_one_of_z = circuit.eval_poly_in_precomputed_Z(f_i_plus_one)
        new_lhs = circuit.mul(
            ci_plus_one,
            circuit.sub(sum_i_prod_k_P, f_i_plus_one_of_z, f"(Π(i,k) (Pk(z))) - Ri(z)"),
            f"ci * ((Π(i,k) (Pk(z)) - Ri(z))",
        )
        lhs_i_plus_one = circuit.add(
            lhs_i, new_lhs, f"LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))"
        )
        for i, point in enumerate(new_points):
            # circuit.extend_output(point[0])
            # circuit.extend_output(point[1])
            circuit.extend_struct_output(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[point[0][0], point[0][1], point[1][0], point[1][1]],
                )
            )
        circuit.extend_struct_output(
            u384(name="f_i_plus_one_of_z", elmts=[f_i_plus_one_of_z])
        )
        circuit.extend_struct_output(
            u384(name="lhs_i_plus_one", elmts=[lhs_i_plus_one])
        )
        circuit.extend_struct_output(u384(name="ci_plus_one", elmts=[ci_plus_one]))

        return circuit


class MPCheckBit00Loop(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int = 0,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        self.n_pairs = n_pairs
        super().__init__(
            name=f"mpcheck_bit00",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )
        self.generic_over_curve = True

    def build_input(self) -> list[PyFelt]:
        input = []
        for _ in range(self.n_pairs):
            p = G1Point.gen_random_point(CurveID(self.curve_id))
            current_q = G2Point.gen_random_point(CurveID(self.curve_id))
            yInv = self.field(p.y).__inv__()
            xNegOverY = -self.field(p.x) * yInv
            input.extend(
                [
                    yInv,
                    xNegOverY,
                    self.field(current_q.x[0]),
                    self.field(current_q.x[1]),
                    self.field(current_q.y[0]),
                    self.field(current_q.y[1]),
                ]
            )

        input.append(
            self.field.random()
        )  # LHS accumulation = Sum(ci*(prod(Pi,j)-Ri)(z))
        input.append(self.field.random())  # R(i-1)(z) = f(i-1)(z) for miller loop.
        input.extend([self.field.random() for _ in range(12)])  # Ri = new_f
        input.append(self.field.random())  # ci_minus_one
        input.append(self.field(randint(0, STARK - 1)))  # z
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        n_pairs = self.n_pairs
        assert n_pairs >= 2, f"n_pairs must be >= 2, got {n_pairs}"
        circuit: multi_pairing_check.MultiPairingCheckCircuit = (
            multi_pairing_check.MultiPairingCheckCircuit(
                self.name,
                self.curve_id,
                n_pairs=n_pairs,
                hash_input=False,
                compilation_mode=self.compilation_mode,
            )
        )
        # Parse (yInv, xNegOverY, Qx0, Qx1, Qy0, Qy1) * n_pairs
        current_points = []
        for i in range(n_pairs):
            circuit.yInv.append(
                circuit.write_struct(u384(name=f"yInv_{i}", elmts=[input.pop(0)]))
            )
            circuit.xNegOverY.append(
                circuit.write_struct(u384(name=f"xNegOverY_{i}", elmts=[input.pop(0)]))
            )
            current_pt = circuit.write_struct(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[input.pop(0), input.pop(0), input.pop(0), input.pop(0)],
                )
            )
            current_points.append(
                (
                    [
                        current_pt[0],
                        current_pt[1],
                    ],
                    [
                        current_pt[2],
                        current_pt[3],
                    ],
                )
            )

        lhs_i = circuit.write_struct(u384(name="lhs_i", elmts=[input.pop(0)]))
        f_i_of_z: ModuloCircuitElement = circuit.write_struct(
            u384(name="f_i_of_z", elmts=[input.pop(0)])
        )

        # f_i_plus_one is R as the result E12 for this bit.
        f_i_plus_one: list[ModuloCircuitElement] = circuit.write_struct(
            E12D(name="f_i_plus_one", elmts=[input.pop(0) for _ in range(12)])
        )
        ci = circuit.write_struct(u384(name="ci", elmts=[input.pop(0)]))
        assert len(input) == 1, f"Input should be empty now"

        circuit.create_powers_of_Z(
            circuit.write_struct(u384(name="z", elmts=[input.pop(0)])), max_degree=11
        )
        ci_plus_one = circuit.mul(ci, ci, f"Compute c_i = (c_(i-1))^2")

        assert len(input) == 0, f"Input should be empty now"
        assert len(current_points) == n_pairs

        sum_i_prod_k_P = circuit.mul(
            f_i_of_z, f_i_of_z, f"Square f evaluation in Z, the result of previous bit."
        )
        new_points = []
        for k in range(n_pairs):
            T, l1 = circuit.double_step(current_points[k], k)
            sum_i_prod_k_P = circuit.mul(
                sum_i_prod_k_P,
                circuit.eval_poly_in_precomputed_Z(
                    l1, circuit.line_sparsity, f"line_{k}"
                ),
                f"Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_{k}(z)",
            )

            new_points.append(T)

        sum_i_prod_k_P = circuit.mul(
            sum_i_prod_k_P,
            sum_i_prod_k_P,
            "Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2",
        )

        new_new_points = []
        for k in range(n_pairs):
            T, l1 = circuit.double_step(new_points[k], k)
            sum_i_prod_k_P = circuit.mul(
                sum_i_prod_k_P,
                circuit.eval_poly_in_precomputed_Z(
                    l1, circuit.line_sparsity, f"line_{k}"
                ),
                f"Mul (f^4 * (Π(i,k) (line_i,k(z)))^2) * line_i+1_{k}(z)",
            )

            new_new_points.append(T)

        f_i_plus_one_of_z = circuit.eval_poly_in_precomputed_Z(
            f_i_plus_one, poly_name="R"
        )
        new_lhs = circuit.mul(
            ci_plus_one,
            circuit.sub(sum_i_prod_k_P, f_i_plus_one_of_z, f"(Π(i,k) (Pk(z))) - Ri(z)"),
            f"ci * ((Π(i,k) (Pk(z)) - Ri(z))",
        )
        lhs_i_plus_one = circuit.add(
            lhs_i, new_lhs, f"LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))"
        )
        for i, point in enumerate(new_new_points):
            # circuit.extend_output(point[0])
            # circuit.extend_output(point[1])
            circuit.extend_struct_output(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[point[0][0], point[0][1], point[1][0], point[1][1]],
                )
            )
        circuit.extend_struct_output(
            u384(name="f_i_plus_one_of_z", elmts=[f_i_plus_one_of_z])
        )
        circuit.extend_struct_output(
            u384(name="lhs_i_plus_one", elmts=[lhs_i_plus_one])
        )
        circuit.extend_struct_output(u384(name="ci_plus_one", elmts=[ci_plus_one]))

        return circuit


class MPCheckBit1Loop(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int = 0,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        self.n_pairs = n_pairs
        super().__init__(
            name="mpcheck_bit1",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )
        self.generic_over_curve = True

    def build_input(self) -> list[PyFelt]:
        """
        - (PyInv, PxNegOverY, Qx0, Qx1, Qy0, Qy1) * (n_pairs)
        - LHS = sum(ci*prod(Pi,j))(z) (1 u384)
        - sum (ci_-1*Ri_-1) (12 u384)
        - f:E12 (12 u384)
        - z (1 u384)
        - ci (1 u384)
        """
        input = []
        for _ in range(self.n_pairs):
            p = G1Point.gen_random_point(CurveID(self.curve_id))
            current_q = G2Point.gen_random_point(CurveID(self.curve_id))
            q_or_q_neg = G2Point.gen_random_point(CurveID(self.curve_id))
            yInv = self.field(p.y).__inv__()
            xNegOverY = -self.field(p.x) * yInv
            input.extend(
                [
                    yInv,
                    xNegOverY,
                    self.field(current_q.x[0]),
                    self.field(current_q.x[1]),
                    self.field(current_q.y[0]),
                    self.field(current_q.y[1]),
                    self.field(q_or_q_neg.x[0]),
                    self.field(q_or_q_neg.x[1]),
                    self.field(q_or_q_neg.y[0]),
                    self.field(q_or_q_neg.y[1]),
                ]
            )

        input.append(
            self.field.random()
        )  # LHS accumulation = Sum(ci*(prod(Pi,j)-Ri)(z))
        input.append(self.field.random())  # R(i-1)(z) = f(i-1)(z) for miller loop.
        input.extend([self.field.random() for _ in range(12)])  # Ri = new_f
        input.append(self.field.random())  # c_or_cinv_of_z
        input.append(self.field(randint(0, STARK - 1)))  # z
        input.append(self.field.random())  # ci
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        n_pairs = self.n_pairs
        assert n_pairs >= 2, f"n_pairs must be >= 2, got {n_pairs}"
        circuit: multi_pairing_check.MultiPairingCheckCircuit = (
            multi_pairing_check.MultiPairingCheckCircuit(
                self.name,
                self.curve_id,
                n_pairs=n_pairs,
                hash_input=False,
                compilation_mode=self.compilation_mode,
            )
        )
        current_points = []
        q_or_q_neg_points = []
        for i in range(n_pairs):
            circuit.yInv.append(
                circuit.write_struct(u384(name=f"yInv_{i}", elmts=[input.pop(0)]))
            )
            circuit.xNegOverY.append(
                circuit.write_struct(u384(name=f"xNegOverY_{i}", elmts=[input.pop(0)]))
            )
            curr_pt = circuit.write_struct(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[input.pop(0), input.pop(0), input.pop(0), input.pop(0)],
                )
            )
            current_points.append(
                (
                    [
                        curr_pt[0],
                        curr_pt[1],
                    ],
                    [
                        curr_pt[2],
                        curr_pt[3],
                    ],
                )
            )
            q_or_q_neg_pt = circuit.write_struct(
                G2PointCircuit(
                    name=f"Q_or_Qneg_{i}",
                    elmts=[input.pop(0), input.pop(0), input.pop(0), input.pop(0)],
                )
            )
            q_or_q_neg_points.append(
                (
                    [
                        q_or_q_neg_pt[0],
                        q_or_q_neg_pt[1],
                    ],
                    [
                        q_or_q_neg_pt[2],
                        q_or_q_neg_pt[3],
                    ],
                )
            )

        lhs_i = circuit.write_struct(u384(name="lhs_i", elmts=[input.pop(0)]))
        f_i_of_z: ModuloCircuitElement = circuit.write_struct(
            u384(name="f_i_of_z", elmts=[input.pop(0)])
        )

        f_i_plus_one: list[ModuloCircuitElement] = circuit.write_struct(
            E12D(name="f_i_plus_one", elmts=[input.pop(0) for _ in range(12)])
        )
        c_or_cinv_of_z: ModuloCircuitElement = circuit.write_struct(
            u384(name="c_or_cinv_of_z", elmts=[input.pop(0)])
        )
        circuit.create_powers_of_Z(
            circuit.write_struct(u384(name="z", elmts=[input.pop(0)])), max_degree=11
        )
        assert len(input) == 1, f"Input should be empty now"

        ci = circuit.write_struct(u384(name="ci", elmts=[input.pop(0)]))
        ci_plus_one = circuit.mul(ci, ci)

        assert len(input) == 0, f"Input should be empty now"
        assert len(current_points) == n_pairs

        sum_i_prod_k_P_of_z = circuit.mul(
            f_i_of_z, f_i_of_z
        )  # Square f evaluation in Z, the result of previous bit.
        new_points = []

        for k in range(n_pairs):
            T, l1, l2 = circuit.double_and_add_step(
                current_points[k], q_or_q_neg_points[k], k
            )
            sum_i_prod_k_P_of_z = circuit.mul(
                sum_i_prod_k_P_of_z,
                circuit.eval_poly_in_precomputed_Z(
                    l1, circuit.line_sparsity, f"line_{k}p_1"
                ),
            )
            sum_i_prod_k_P_of_z = circuit.mul(
                sum_i_prod_k_P_of_z,
                circuit.eval_poly_in_precomputed_Z(
                    l2, circuit.line_sparsity, f"line_{k}p_2"
                ),
            )
            new_points.append(T)

        sum_i_prod_k_P_of_z = circuit.mul(sum_i_prod_k_P_of_z, c_or_cinv_of_z)

        f_i_plus_one_of_z = circuit.eval_poly_in_precomputed_Z(
            f_i_plus_one, poly_name="R"
        )
        new_lhs = circuit.mul(
            ci_plus_one,
            circuit.sub(sum_i_prod_k_P_of_z, f_i_plus_one_of_z),
            comment=f"ci * ((Π(i,k) (Pk(z)) - Ri(z))",
        )
        lhs_i_plus_one = circuit.add(lhs_i, new_lhs)

        for i, point in enumerate(new_points):
            circuit.extend_struct_output(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[point[0][0], point[0][1], point[1][0], point[1][1]],
                )
            )

        circuit.extend_struct_output(
            u384(name="f_i_plus_one_of_z", elmts=[f_i_plus_one_of_z])
        )
        circuit.extend_struct_output(
            u384(name="lhs_i_plus_one", elmts=[lhs_i_plus_one])
        )
        circuit.extend_struct_output(u384(name="ci_plus_one", elmts=[ci_plus_one]))

        return circuit


class MPCheckPreparePairs(BaseEXTFCircuit):
    """
    This circuit is used to prepare points for the multi-pairing check.
    For BN curve, it will compute yInv and xNegOverY for each point + negate the y of the G2 point.
    For BLS curve, it will only compute yInv and xNegOverY for each point.
    """

    def __init__(
        self,
        curve_id: int,
        n_pairs: int = 0,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        self.n_pairs = n_pairs
        super().__init__(
            name="mpcheck_prepare_points",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )
        self.generic_over_curve = True

    def build_input(self) -> list[PyFelt]:
        """
        - ((Px, Py) + (Qy0, Qy1) if BN curve) * (n_pairs)
        """
        input = []
        for _ in range(self.n_pairs):
            p = G1Point.gen_random_point(CurveID(self.curve_id))
            q = G2Point.gen_random_point(CurveID(self.curve_id))
            input.extend(
                [
                    self.field(p.x),
                    self.field(p.y),
                ]
            )
            if self.curve_id == BN254_ID:
                input.extend(
                    [
                        self.field(q.y[0]),
                        self.field(q.y[1]),
                    ]
                )
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        n_pairs = self.n_pairs
        circuit: ModuloCircuit = ModuloCircuit(
            self.name,
            self.curve_id,
            compilation_mode=self.compilation_mode,
        )
        for i in range(n_pairs):
            x, y = circuit.write_struct(
                G1PointCircuit(name=f"p_{i}", elmts=[input.pop(0), input.pop(0)])
            )
            yInv = circuit.inv(y)
            xNegOverY = circuit.neg(circuit.mul(x, yInv))

            if self.curve_id == BN254_ID:
                Qy0 = circuit.write_struct(u384(name=f"Qy0_{i}", elmts=[input.pop(0)]))
                Qy1 = circuit.write_struct(u384(name=f"Qy1_{i}", elmts=[input.pop(0)]))
                Qyneg0 = circuit.neg(Qy0)
                Qyneg1 = circuit.neg(Qy1)
                circuit.extend_struct_output(
                    BNProcessedPair(
                        name=f"p_{i}", elmts=[yInv, xNegOverY, Qyneg0, Qyneg1]
                    )
                )
            else:
                circuit.extend_struct_output(
                    BLSProcessedPair(name=f"p_{i}", elmts=[yInv, xNegOverY])
                )

        return circuit


class MPCheckPrepareLambdaRootEvaluations(BaseEXTFCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, compilation_mode: int = 1):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        super().__init__(
            name="mpcheck_lambda_root_eval",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(12)])  # lambda_root
        input.append(self.field.random())  # z
        input.extend([self.field.random() for _ in range(6)])  # w - scaling factor
        if self.curve_id == BN254_ID:
            input.extend([self.field.random() for _ in range(12)])  # c_inv
            input.append(self.field.random())  # c_0
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        circuit = multi_pairing_check.MultiPairingCheckCircuit(
            name=self.name,
            curve_id=self.curve_id,
            n_pairs=2,  # Unused
            hash_input=False,
            compilation_mode=self.compilation_mode,
        )
        c_or_c_inv = circuit.write_struct(
            E12D(
                name=(
                    f"lambda_root_inverse"
                    if self.curve_id == BLS12_381_ID
                    else "lambda_root"
                ),
                elmts=[input.pop(0) for _ in range(12)],
            )
        )
        z = circuit.write_struct(u384(name="z", elmts=[input.pop(0)]))
        circuit.create_powers_of_Z(z, max_degree=11)

        if self.curve_id == BLS12_381_ID:
            # Conjugate c_inverse for BLS.
            c_or_c_inv = circuit.conjugate_e12d(c_or_c_inv)

        c_or_c_inv_of_z = circuit.eval_poly_in_precomputed_Z(
            c_or_c_inv, poly_name=f"C_inv" if self.curve_id == BLS12_381_ID else "C"
        )
        circuit.extend_struct_output(
            u384(
                name="c_inv_of_z" if self.curve_id == BLS12_381_ID else "c_of_z",
                elmts=[c_or_c_inv_of_z],
            )
        )

        scaling_factor_sparsity = [
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
        ]  # E6 subfield within E12 : to_direct(E6.random + w * E6.zero)

        scaling_factor_compressed = circuit.write_struct(
            MillerLoopResultScalingFactor(
                name="scaling_factor", elmts=[input.pop(0) for _ in range(6)]
            )
        )
        scaling_factor = [
            scaling_factor_compressed[0],
            None,
            scaling_factor_compressed[1],
            None,
            scaling_factor_compressed[2],
            None,
            scaling_factor_compressed[3],
            None,
            scaling_factor_compressed[4],
            None,
            scaling_factor_compressed[5],
            None,
        ]

        scaling_factor_of_z = circuit.eval_poly_in_precomputed_Z(
            scaling_factor, sparsity=scaling_factor_sparsity, poly_name="W"
        )

        circuit.extend_struct_output(
            u384("scaling_factor_of_z", elmts=[scaling_factor_of_z])
        )

        if self.curve_id == BLS12_381_ID:
            c_inv = c_or_c_inv
            # Compute needed frobenius:
            c_inv_frob_1 = circuit.frobenius(c_inv, 1)
            c_inv_frob_1_of_z = circuit.eval_poly_in_precomputed_Z(
                c_inv_frob_1, poly_name="C_inv_frob_1"
            )
            circuit.extend_struct_output(
                u384("c_inv_frob_1_of_z", elmts=[c_inv_frob_1_of_z])
            )
        elif self.curve_id == BN254_ID:
            c = c_or_c_inv
            c_of_z = c_or_c_inv_of_z
            c_inv = circuit.write_struct(
                E12D(name="c_inv", elmts=[input.pop(0) for _ in range(12)])
            )
            c_0 = circuit.write_struct(u384(name="c_0", elmts=[input.pop(0)]))
            c_inv_of_z = circuit.eval_poly_in_precomputed_Z(c_inv, poly_name=f"C_inv")
            circuit.extend_struct_output(u384(name="c_inv_of_z", elmts=[c_inv_of_z]))
            lhs = circuit.sub(
                circuit.mul(c_of_z, c_inv_of_z),
                circuit.set_or_get_constant(1),
                comment="c_of_z * c_inv_of_z - 1",
            )
            lhs = circuit.mul(lhs, c_0, comment="c_0 * (c_of_z * c_inv_of_z - 1)")
            circuit.extend_struct_output(u384("lhs", elmts=[lhs]))

            # Compute needed frobenius:
            c_inv_frob_1 = circuit.frobenius(c_inv, 1)
            c_frob_2 = circuit.frobenius(c, 2)
            c_inv_frob_3 = circuit.frobenius(c_inv, 3)

            c_inv_frob_1_of_z = circuit.eval_poly_in_precomputed_Z(
                c_inv_frob_1, poly_name="C_inv_frob_1"
            )
            c_frob_2_of_z = circuit.eval_poly_in_precomputed_Z(
                c_frob_2, poly_name="C_frob_2"
            )
            c_inv_frob_3_of_z = circuit.eval_poly_in_precomputed_Z(
                c_inv_frob_3, poly_name="C_inv_frob_3"
            )

            circuit.extend_struct_output(
                u384("c_inv_frob_1_of_z", elmts=[c_inv_frob_1_of_z])
            )
            circuit.extend_struct_output(u384("c_frob_2_of_z", elmts=[c_frob_2_of_z]))
            circuit.extend_struct_output(
                u384("c_inv_frob_3_of_z", elmts=[c_inv_frob_3_of_z])
            )

        return circuit


class MPCheckInitBit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        assert 2 <= n_pairs <= 3, f"n_pairs must be between 2 and 3, got {n_pairs}"
        self.n_pairs = n_pairs
        super().__init__(
            name="mpcheck_init_bit",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        for _ in range(self.n_pairs):
            p = G1Point.gen_random_point(CurveID(self.curve_id))
            current_q = G2Point.gen_random_point(CurveID(self.curve_id))
            yInv = self.field(p.y).__inv__()
            xNegOverY = -self.field(p.x) * yInv
            input.extend(
                [
                    yInv,
                    xNegOverY,
                    self.field(current_q.x[0]),
                    self.field(current_q.x[1]),
                    self.field(current_q.y[0]),
                    self.field(current_q.y[1]),
                ]
            )

        input.extend([self.field.random() for _ in range(12)])  # Ri = new_f
        input.append(self.field.random())  # c0
        input.append(self.field.random())  # z
        input.append(
            self.field.random()
        )  # c_inv_of_z (BN) or conjugate(c_inv)_of_z (BLS)

        if self.curve_id == BN254_ID:
            input.append(self.field.random())  # previous_lhs
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        n_pairs = self.n_pairs
        circuit: multi_pairing_check.MultiPairingCheckCircuit = (
            multi_pairing_check.MultiPairingCheckCircuit(
                self.name,
                self.curve_id,
                n_pairs=n_pairs,
                hash_input=False,
                compilation_mode=self.compilation_mode,
            )
        )
        current_points = []
        for i in range(n_pairs):
            circuit.yInv.append(
                circuit.write_struct(u384(name=f"yInv_{i}", elmts=[input.pop(0)]))
            )
            circuit.xNegOverY.append(
                circuit.write_struct(u384(name=f"xNegOverY_{i}", elmts=[input.pop(0)]))
            )
            curr_pt = circuit.write_struct(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[input.pop(0), input.pop(0), input.pop(0), input.pop(0)],
                )
            )
            current_points.append(
                (
                    [
                        curr_pt[0],
                        curr_pt[1],
                    ],
                    [
                        curr_pt[2],
                        curr_pt[3],
                    ],
                )
            )

        R_i = circuit.write_struct(E12D("R_i", elmts=[input.pop(0) for _ in range(12)]))
        c0 = circuit.write_struct(u384("c0", elmts=[input.pop(0)]))
        z = circuit.write_struct(u384("z", elmts=[input.pop(0)]))
        c_inv_of_z = circuit.write_struct(u384("c_inv_of_z", elmts=[input.pop(0)]))
        circuit.create_powers_of_Z(z, max_degree=11)

        f_i_plus_one_of_z = circuit.eval_poly_in_precomputed_Z(R_i, poly_name="R")
        sum_i_prod_k_P_of_z = circuit.mul(
            c_inv_of_z, c_inv_of_z
        )  # # At initialisation, f=1/c so f^2 = 1/c^2
        new_points = []
        if self.curve_id == BN254_ID:
            c_i = circuit.mul(
                c0, c0
            )  # Second relation for BN at init bit, need to update c_i.
            for k in range(n_pairs):
                T, l1 = circuit.double_step(current_points[k], k)
                sum_i_prod_k_P_of_z = circuit.mul(
                    sum_i_prod_k_P_of_z,
                    circuit.eval_poly_in_precomputed_Z(
                        l1, circuit.line_sparsity, f"line_{k}p_1"
                    ),
                )
                new_points.append(T)
        elif self.curve_id == BLS12_381_ID:
            c_i = c0  # first relation for BLS at init bit, no need to update c_i.
            # bit +1:  multiply f^2 by 1/c
            sum_i_prod_k_P_of_z = circuit.mul(c_inv_of_z, sum_i_prod_k_P_of_z)
            for k in range(n_pairs):
                T, l1, l2 = circuit.triple_step(current_points[k], k)
                sum_i_prod_k_P_of_z = circuit.mul(
                    sum_i_prod_k_P_of_z,
                    circuit.eval_poly_in_precomputed_Z(
                        l1, circuit.line_sparsity, f"line_{k}p_1"
                    ),
                )
                sum_i_prod_k_P_of_z = circuit.mul(
                    sum_i_prod_k_P_of_z,
                    circuit.eval_poly_in_precomputed_Z(
                        l2, circuit.line_sparsity, f"line_{k}p_2"
                    ),
                )
                new_points.append(T)

        new_lhs = circuit.mul(
            c_i,
            circuit.sub(sum_i_prod_k_P_of_z, f_i_plus_one_of_z),
            comment=f"ci * ((Π(i,k) (Pk(z)) - Ri(z))",
        )

        if self.curve_id == BLS12_381_ID:
            new_lhs = new_lhs
        elif self.curve_id == BN254_ID:
            previous_lhs = circuit.write_struct(
                u384("previous_lhs", elmts=[input.pop(0)])
            )
            new_lhs = circuit.add(new_lhs, previous_lhs)

        # OUTPUT
        for i, point in enumerate(new_points):
            circuit.extend_struct_output(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[point[0][0], point[0][1], point[1][0], point[1][1]],
                )
            )
        circuit.extend_struct_output(u384("new_lhs", elmts=[new_lhs]))
        if self.curve_id == BN254_ID:
            circuit.extend_struct_output(u384("c_i", elmts=[c_i]))
        circuit.extend_struct_output(
            u384("f_i_plus_one_of_z", elmts=[f_i_plus_one_of_z])
        )
        return circuit


class MPCheckFinalizeBN(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        assert 2 <= n_pairs <= 3, f"n_pairs must be between 2 and 3, got {n_pairs}"
        self.n_pairs = n_pairs
        self.max_q_degree = multi_pairing_check.get_max_Q_degree(curve_id, self.n_pairs)

        super().__init__(
            name="mpcheck_finalize_bn",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        if self.curve_id == BLS12_381_ID:
            return []
        input = []
        for _ in range(self.n_pairs):
            original_p = G1Point.gen_random_point(CurveID(self.curve_id))
            original_q = G2Point.gen_random_point(CurveID(self.curve_id))
            yInv = self.field(original_p.y).__inv__()
            xNegOverY = -self.field(original_p.x) * yInv
            current_q = G2Point.gen_random_point(CurveID(self.curve_id))

            input.extend(
                [
                    self.field(original_q.x[0]),
                    self.field(original_q.x[1]),
                    self.field(original_q.y[0]),
                    self.field(original_q.y[1]),
                    yInv,
                    xNegOverY,
                    self.field(current_q.x[0]),
                    self.field(current_q.x[1]),
                    self.field(current_q.y[0]),
                    self.field(current_q.y[1]),
                ]
            )

        input.extend([self.field.random() for _ in range(12)])  # Ri = new_f
        input.extend([self.field.random() for _ in range(12)])  # Ri = new_f

        input.append(self.field.random())  # c_i-1
        input.append(self.field.random())  # z
        input.append(self.field.random())  # w_of_z
        input.append(self.field.random())  # c_inv_frob_1_of_z
        input.append(self.field.random())  # c_frob_2_of_z
        input.append(self.field.random())  # c_inv_frob_3_of_z
        input.append(self.field.random())  # previous_lhs
        input.append(self.field.random())  # R_n_minus_3_of_z

        input.extend([self.field.random() for _ in range(self.max_q_degree + 1)])
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        n_pairs = self.n_pairs
        circuit: multi_pairing_check.MultiPairingCheckCircuit = (
            multi_pairing_check.MultiPairingCheckCircuit(
                self.name,
                self.curve_id,
                n_pairs=n_pairs,
                hash_input=False,
                compilation_mode=self.compilation_mode,
            )
        )
        if self.curve_id == BLS12_381_ID:
            return circuit

        current_points = []
        for k in range(n_pairs):
            original_Q = circuit.write_struct(
                G2PointCircuit(
                    name=f"original_Q{k}",
                    elmts=[input.pop(0), input.pop(0), input.pop(0), input.pop(0)],
                )
            )
            circuit.Q.append(
                ([original_Q[0], original_Q[1]], [original_Q[2], original_Q[3]])
            )
            yInv_k = circuit.write_struct(u384(f"yInv_{k}", elmts=[input.pop(0)]))
            xNegOverY_k = circuit.write_struct(
                u384(f"xNegOverY_{k}", elmts=[input.pop(0)])
            )
            circuit.yInv.append(yInv_k)
            circuit.xNegOverY.append(xNegOverY_k)
            curr_pt = circuit.write_struct(
                G2PointCircuit(
                    name=f"Q{k}",
                    elmts=[input.pop(0), input.pop(0), input.pop(0), input.pop(0)],
                )
            )
            current_points.append(
                (
                    [
                        curr_pt[0],
                        curr_pt[1],
                    ],
                    [
                        curr_pt[2],
                        curr_pt[3],
                    ],
                )
            )

        R_n_minus_2 = circuit.write_struct(
            E12D("R_n_minus_2", elmts=[input.pop(0) for _ in range(12)])
        )
        R_n_minus_1 = circuit.write_struct(
            E12D("R_n_minus_1", elmts=[input.pop(0) for _ in range(12)])
        )
        c_n_minus_3 = circuit.write_struct(u384("c_n_minus_3", elmts=[input.pop(0)]))
        w_of_z = circuit.write_struct(u384("w_of_z", elmts=[input.pop(0)]))
        z = circuit.write_struct(u384("z", elmts=[input.pop(0)]))
        c_inv_frob_1_of_z = circuit.write_struct(
            u384("c_inv_frob_1_of_z", elmts=[input.pop(0)])
        )
        c_frob_2_of_z = circuit.write_struct(
            u384("c_frob_2_of_z", elmts=[input.pop(0)])
        )
        c_inv_frob_3_of_z = circuit.write_struct(
            u384("c_inv_frob_3_of_z", elmts=[input.pop(0)])
        )
        previous_lhs = circuit.write_struct(u384("previous_lhs", elmts=[input.pop(0)]))
        R_n_minus_3_of_z = circuit.write_struct(
            u384("R_n_minus_3_of_z", elmts=[input.pop(0)])
        )
        Q = circuit.write_struct(
            structs.u384Array(
                "Q", elmts=[input.pop(0) for _ in range(self.max_q_degree + 1)]
            )
        )

        circuit.create_powers_of_Z(z, max_degree=self.max_q_degree)

        c_n_minus_2 = circuit.mul(c_n_minus_3, c_n_minus_3)
        c_n_minus_1 = circuit.mul(c_n_minus_2, c_n_minus_2)

        R_n_minus_2_of_z = circuit.eval_poly_in_precomputed_Z(
            R_n_minus_2, poly_name="R_n_minus_2"
        )
        R_n_minus_1_of_z = circuit.eval_poly_in_precomputed_Z(
            R_n_minus_1, poly_name="R_n_minus_1"
        )

        # Relation n-2 : f * lines
        prod_k_P_of_z_n_minus_2 = R_n_minus_3_of_z  # Init
        lines = circuit.bn254_finalize_step(current_points)
        for l in lines:
            prod_k_P_of_z_n_minus_2 = circuit.mul(
                prod_k_P_of_z_n_minus_2,
                circuit.eval_poly_in_precomputed_Z(
                    l, circuit.line_sparsity, f"line_{k}"
                ),
            )

        lhs_n_minus_2 = circuit.mul(
            c_n_minus_2,
            circuit.sub(prod_k_P_of_z_n_minus_2, R_n_minus_2_of_z),
            comment=f"c_n_minus_2 * ((Π(n-2,k) (Pk(z)) - R_n_minus_2(z))",
        )

        # Relation n-1 (last one) : f * w * c_inv_frob_1 * c_frob_2 * c_inv_frob_3
        prod_k_P_of_z_n_minus_1 = circuit.mul(R_n_minus_2_of_z, c_inv_frob_1_of_z)
        prod_k_P_of_z_n_minus_1 = circuit.mul(prod_k_P_of_z_n_minus_1, c_frob_2_of_z)
        prod_k_P_of_z_n_minus_1 = circuit.mul(
            prod_k_P_of_z_n_minus_1, c_inv_frob_3_of_z
        )
        prod_k_P_of_z_n_minus_1 = circuit.mul(prod_k_P_of_z_n_minus_1, w_of_z)

        lhs_n_minus_1 = circuit.mul(
            c_n_minus_1,
            circuit.sub(prod_k_P_of_z_n_minus_1, R_n_minus_1_of_z),
            comment=f"c_n_minus_1 * ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))",
        )

        _final_lhs = circuit.add(previous_lhs, lhs_n_minus_2)
        final_lhs = circuit.add(_final_lhs, lhs_n_minus_1)

        Q_of_z = circuit.eval_poly_in_precomputed_Z(Q, poly_name="big_Q")
        P_irr, P_irr_sparsity = circuit.write_sparse_constant_elements(
            get_irreducible_poly(self.curve_id, 12).get_coeffs(),
        )
        P_of_z = circuit.eval_poly_in_precomputed_Z(
            P_irr, P_irr_sparsity, poly_name="P_irr"
        )
        check = circuit.sub(final_lhs, circuit.mul(Q_of_z, P_of_z))

        circuit.extend_struct_output(u384("final_check", elmts=[check]))
        return circuit


class MPCheckFinalizeBLS(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int,
        # include_m: bool,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        assert 2 <= n_pairs <= 3, f"n_pairs must be between 2 and 3, got {n_pairs}"
        self.n_pairs = n_pairs
        self.max_q_degree = multi_pairing_check.get_max_Q_degree(curve_id, self.n_pairs)

        super().__init__(
            name="mpcheck_finalize_bls",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        if self.curve_id == BN254_ID:
            return []
        input = []

        input.extend([self.field.random() for _ in range(12)])  # R_n_minus_1

        input.append(self.field.random())  # c_i-1
        input.append(self.field.random())  # z
        input.append(self.field.random())  # w_of_z
        input.append(self.field.random())  # c_inv_frob_1_of_z
        input.append(self.field.random())  # previous_lhs
        input.append(self.field.random())  # R_n_minus_2_of_z

        input.extend([self.field.random() for _ in range(self.max_q_degree + 1)])
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        n_pairs = self.n_pairs
        circuit: multi_pairing_check.MultiPairingCheckCircuit = (
            multi_pairing_check.MultiPairingCheckCircuit(
                self.name,
                self.curve_id,
                n_pairs=n_pairs,
                hash_input=False,
                compilation_mode=self.compilation_mode,
            )
        )
        if self.curve_id == BN254_ID:
            return circuit

        R_n_minus_1 = circuit.write_struct(
            E12D("R_n_minus_1", elmts=[input.pop(0) for _ in range(12)])
        )
        c_n_minus_2 = circuit.write_struct(u384("c_n_minus_2", elmts=[input.pop(0)]))
        w_of_z = circuit.write_struct(u384("w_of_z", elmts=[input.pop(0)]))
        z = circuit.write_struct(u384("z", elmts=[input.pop(0)]))
        c_inv_frob_1_of_z = circuit.write_struct(
            u384("c_inv_frob_1_of_z", elmts=[input.pop(0)])
        )
        previous_lhs = circuit.write_struct(u384("previous_lhs", elmts=[input.pop(0)]))
        R_n_minus_2_of_z = circuit.write_struct(
            u384("R_n_minus_2_of_z", elmts=[input.pop(0)])
        )
        Q = circuit.write_struct(
            structs.u384Array(
                "Q", elmts=[input.pop(0) for _ in range(self.max_q_degree + 1)]
            )
        )

        circuit.create_powers_of_Z(z, max_degree=self.max_q_degree)

        c_n_minus_1 = circuit.mul(c_n_minus_2, c_n_minus_2)

        R_n_minus_1_of_z = circuit.eval_poly_in_precomputed_Z(
            R_n_minus_1, poly_name="R_n_minus_1"
        )

        # Relation n-1 (last one) : f * w * c_inv_frob_1
        prod_k_P_of_z_n_minus_1 = circuit.mul(R_n_minus_2_of_z, c_inv_frob_1_of_z)
        prod_k_P_of_z_n_minus_1 = circuit.mul(prod_k_P_of_z_n_minus_1, w_of_z)

        lhs_n_minus_1 = circuit.mul(
            c_n_minus_1,
            circuit.sub(prod_k_P_of_z_n_minus_1, R_n_minus_1_of_z),
            comment=f"c_n_minus_1 * ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))",
        )

        final_lhs = circuit.add(
            previous_lhs, lhs_n_minus_1, comment="previous_lhs + lhs_n_minus_1"
        )
        P_irr, P_irr_sparsity = circuit.write_sparse_constant_elements(
            get_irreducible_poly(self.curve_id, 12).get_coeffs(),
        )
        P_of_z = circuit.eval_poly_in_precomputed_Z(
            P_irr, P_irr_sparsity, poly_name="P_irr"
        )

        Q_of_z = circuit.eval_poly_in_precomputed_Z(Q, poly_name="big_Q")

        check = circuit.sub(
            final_lhs,
            circuit.mul(Q_of_z, P_of_z, comment="Q(z) * P(z)"),
            comment="final_lhs - Q(z) * P(z)",
        )

        circuit.extend_struct_output(u384("final_check", elmts=[check]))
        return circuit


class FP12MulAssertOne(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "fp12_mul_assert_one", None, curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(12)])  # X
        input.extend([self.field.random() for _ in range(12)])  # Y
        input.extend([self.field.random() for _ in range(11)])  # Q
        # R is known to be 1.
        input.append(self.field.random())  # z

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ExtensionFieldModuloCircuit:
        circuit = ExtensionFieldModuloCircuit(
            self.name,
            self.curve_id,
            extension_degree=12,
            init_hash=self.init_hash,
            compilation_mode=self.compilation_mode,
        )
        X = circuit.write_struct(E12D("X", elmts=[input.pop(0) for _ in range(12)]))
        Y = circuit.write_struct(E12D("Y", elmts=[input.pop(0) for _ in range(12)]))
        Q = circuit.write_struct(
            structs.E12DMulQuotient("Q", elmts=[input.pop(0) for _ in range(11)])
        )
        assert len(input) == 1
        z = circuit.write_struct(u384("z", elmts=[input.pop(0)]))
        assert len(input) == 0
        circuit.create_powers_of_Z(z, max_degree=12)
        P_irr, P_irr_sparsity = circuit.write_sparse_constant_elements(
            get_irreducible_poly(self.curve_id, 12).get_coeffs(),
        )
        P_of_z = circuit.eval_poly_in_precomputed_Z(
            P_irr, P_irr_sparsity, poly_name="P_irr"
        )
        Q_of_z = circuit.eval_poly_in_precomputed_Z(Q, poly_name="Q")
        R_of_z = circuit.set_or_get_constant(1)

        X_of_z = circuit.eval_poly_in_precomputed_Z(X, poly_name="X")
        Y_of_z = circuit.eval_poly_in_precomputed_Z(Y, poly_name="Y")
        check = circuit.sub(
            circuit.mul(X_of_z, Y_of_z, comment="X(z) * Y(z)"),
            circuit.mul(Q_of_z, P_of_z, comment="Q(z) * P(z)"),
            comment="(X(z) * Y(z)) - (Q(z) * P(z))",
        )
        check = circuit.sub(check, R_of_z, comment="(X(z) * Y(z) - Q(z) * P(z)) - 1")
        circuit.extend_struct_output(u384("check", elmts=[check]))

        return circuit


# All the circuits that are going to be compiled to Cairo Zero.
ALL_FUSTAT_CIRCUITS = {
    CircuitID.DUMMY: {"class": DummyCircuit, "params": None, "filename": "dummy"},
    CircuitID.IS_ON_CURVE_G1_G2: {
        "class": IsOnCurveG1G2Circuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.IS_ON_CURVE_G1: {
        "class": IsOnCurveG1Circuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.DERIVE_POINT_FROM_X: {
        "class": DerivePointFromXCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.SLOPE_INTERCEPT_SAME_POINT: {
        "class": SlopeInterceptSamePointCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED: {
        "class": AccumulateEvalPointChallengeSignedCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.RHS_FINALIZE_ACC: {
        "class": RHSFinalizeAccCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.EVAL_FUNCTION_CHALLENGE_DUPL: {
        "class": EvalFunctionChallengeDuplCircuit,
        "params": [{"n_points": k} for k in [1, 2, 3, 4]],
        "filename": "ec",
    },
    CircuitID.INIT_FUNCTION_CHALLENGE_DUPL: {
        "class": InitFunctionChallengeDuplCircuit,
        "params": [{"n_points": k} for k in [5]],
        "filename": "ec",
    },
    CircuitID.ACC_FUNCTION_CHALLENGE_DUPL: {
        "class": AccumulateFunctionChallengeDuplCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.FINALIZE_FUNCTION_CHALLENGE_DUPL: {
        "class": FinalizeFunctionChallengeDuplCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.FP12_MUL: {
        "class": FP12MulCircuit,
        "params": None,
        "filename": "extf_mul",
    },
    # CircuitID.FINAL_EXP_PART_1: {
    #     "class": FinalExpPart1Circuit,
    #     "params": None,
    #     "filename": "final_exp",
    # },
    # CircuitID.FINAL_EXP_PART_2: {
    #     "class": FinalExpPart2Circuit,
    #     "params": None,
    #     "filename": "final_exp",
    # },
    # CircuitID.MULTI_MILLER_LOOP: {
    #     "class": MultiMillerLoop,
    #     "params": [{"n_pairs": k} for k in [1, 2, 3]],
    #     "filename": "multi_miller_loop",
    # },
    CircuitID.MULTI_PAIRING_CHECK: {
        "class": MultiPairingCheck,
        "params": [{"n_pairs": k} for k in [2, 3]],
        "filename": "multi_pairing_check",
    },
    CircuitID.ADD_EC_POINT: {
        "class": AddECPointCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.DOUBLE_EC_POINT: {
        "class": DoubleECPointCircuit,
        "params": None,
        "filename": "ec",
    },
}


def compilation_mode_to_file_header(mode: int) -> str:
    if mode == 0:
        return f"""
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
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{get_a, get_b, get_p, get_g, get_min_one, G1Point, G2Point, E12D, E12DMulQuotient, G1G2Pair, BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor};
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
    use garaga::definitions::{G1Point, G2Point, E12D, E12DMulQuotient, G1G2Pair, BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor};
    use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};
"""


def main(
    PRECOMPILED_CIRCUITS_DIR: str = "src/fustat/precompiled_circuits/",
    CIRCUITS_TO_COMPILE: dict = ALL_FUSTAT_CIRCUITS,
    compilation_mode: int = 0,
):
    import re

    def to_snake_case(s: str) -> str:
        return re.sub(r"(?<=[a-z])(?=[A-Z])|[^a-zA-Z0-9]", "_", s).lower()

    """Compiles and writes all circuits to .cairo files"""

    # Ensure the 'codes' dict keys match the filenames used for file creation.
    # Using sets to remove potential duplicates
    filenames_used = set([v["filename"] for v in CIRCUITS_TO_COMPILE.values()])
    codes = {filename: set() for filename in filenames_used}
    selector_functions = {filename: set() for filename in filenames_used}
    cairo1_tests_functions = {filename: set() for filename in filenames_used}
    cairo1_full_function_names = {filename: set() for filename in filenames_used}

    files = {
        f: open(f"{PRECOMPILED_CIRCUITS_DIR}{f}.cairo", "w") for f in filenames_used
    }

    # Write the header to each file
    HEADER = compilation_mode_to_file_header(compilation_mode)

    for file in files.values():
        file.write(HEADER)

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
        selector_function = build_selector_function(circuit_id, circuits[0], params)

        for i, circuit_instance in enumerate(circuits):
            function_name = (
                f"{circuit_id.name}"
                if circuit_instance.circuit.generic_circuit
                else f"{curve_id.name}_{circuit_id.name}"
            )
            function_name += f"_{params[i][param_name]}" if params else ""
            compiled_circuit, full_function_name = (
                circuit_instance.circuit.compile_circuit(function_name=function_name)
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

        return compiled_circuits, selector_function, full_function_names

    def write_cairo1_test(function_name: str, input: list, output: list, curve_id: int):
        if function_name == "":
            print(f"passing test")
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
            output_code += f"assert_eq!(got.len(), exp.len());"
            output_code += f"assert_eq!(got, exp);"
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

    def build_selector_function(
        circuit_id: CircuitID, circuit_instance: BaseModuloCircuit, params: list[dict]
    ) -> str:
        if compilation_mode == 1:
            return []

        struct_name = circuit_instance.circuit.class_name
        selectors = []
        if circuit_instance.circuit.generic_circuit and params is None:
            selectors.append("")
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
            selectors.append(selector_function)
        else:
            if circuit_instance.generic_over_curve and params is not None:
                curve_name = CurveID(circuit_instance.curve_id).name
                param_name = list(params[0].keys())[0]
                selector_function_curve = f"""
            func get_{circuit_id.name}_circuit(curve_id:felt, {param_name}:felt) -> (circuit:{struct_name}*){{
                if (curve_id == bn.CURVE_ID) {{
                    return get_BN254_{circuit_id.name}_circuit({param_name});
                }}
                if (curve_id == bls.CURVE_ID) {{
                    return get_BLS12_381_{circuit_id.name}_circuit({param_name});
                }}
                return get_void_{to_snake_case(struct_name)}();
                }}\n
            """
                selectors.append(selector_function_curve)

                param_name = list(params[0].keys())[0]
                selector_function_param = f"""
                func get_{curve_name}_{circuit_id.name}_circuit({param_name}:felt) -> (circuit:{struct_name}*){{
            tempvar offset = 2 * ({list(params[0].keys())[0]} - 1) + 1;
                jmp rel offset;
                """
                for param in params:
                    selector_function_param += f"""
                jmp circuit_{param[param_name]};
                """

                for param in params:
                    selector_function_param += f"""
                    circuit_{param[param_name]}:
                    return get_{curve_name}_{circuit_id.name}_{param[param_name]}_circuit();
                    """
                selector_function_param += "\n}\n"
                selectors.append(selector_function_param)
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
                selectors.append(selector_function)

        return selectors

    # Instantiate and compile circuits for each curve
    for curve_id in [CurveID.BN254, CurveID.BLS12_381]:
        for circuit_id, circuit_info in CIRCUITS_TO_COMPILE.items():
            filename_key = circuit_info["filename"]
            compiled_circuits, selectors, full_function_names = compile_circuit(
                curve_id,
                circuit_info["class"],
                circuit_id,
                circuit_info["params"],
            )
            codes[filename_key].update(compiled_circuits)
            selector_functions[filename_key].update(selectors)
            if compilation_mode == 1:

                cairo1_full_function_names[filename_key].update(full_function_names)

    # Write selector functions and compiled circuit codes to their respective files
    print(f"Writing circuits and selectors to .cairo files...")
    for filename in filenames_used:
        if filename in files:
            # Write the selector functions for this file
            for selector_function in sorted(selector_functions[filename]):
                files[filename].write(selector_function)
            # Write the compiled circuit codes
            for compiled_circuit in sorted(codes[filename]):
                files[filename].write(compiled_circuit + "\n")

            if compilation_mode == 1:
                files[filename].write(cairo1_tests_header() + "\n")
                fns_to_import = sorted(cairo1_full_function_names[filename])
                if "" in fns_to_import:
                    fns_to_import.remove("")
                files[filename].write(f"use super::{{{','.join(fns_to_import)}}};\n")
                for cairo1_test in sorted(cairo1_tests_functions[filename]):
                    files[filename].write(cairo1_test + "\n")
                files[filename].write("}\n")

        else:
            print(f"Warning: No file associated with filename '{filename}'")

    # Close all files
    for file in files.values():
        file.close()

    def format_cairo_files_in_parallel(filenames, compilation_mode):
        if compilation_mode == 0:
            print(f"Formatting .cairo zero files in parallel...")
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
        elif compilation_mode == 1:
            subprocess.run(["scarb", "fmt"], check=True, cwd=PRECOMPILED_CIRCUITS_DIR)

    format_cairo_files_in_parallel(filenames_used, compilation_mode)
    return None


# All the circuits that are going to be compiled to Cairo 1, that are not curve specific.
ALL_CAIRO_GENERIC_CIRCUITS = {
    CircuitID.DUMMY: {"class": DummyCircuit, "params": None, "filename": "dummy"},
    CircuitID.IS_ON_CURVE_G1_G2: {
        "class": IsOnCurveG1G2Circuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.IS_ON_CURVE_G1: {
        "class": IsOnCurveG1Circuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.IS_ON_CURVE_G2: {
        "class": IsOnCurveG2Circuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.SLOPE_INTERCEPT_SAME_POINT: {
        "class": SlopeInterceptSamePointCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED: {
        "class": AccumulateEvalPointChallengeSignedCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.RHS_FINALIZE_ACC: {
        "class": RHSFinalizeAccCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.EVAL_FUNCTION_CHALLENGE_DUPL: {
        "class": EvalFunctionChallengeDuplCircuit,
        "params": [{"n_points": k} for k in [1, 2, 3, 4]],
        "filename": "ec",
    },
    CircuitID.INIT_FUNCTION_CHALLENGE_DUPL: {
        "class": InitFunctionChallengeDuplCircuit,
        "params": [{"n_points": k} for k in [5]],
        "filename": "ec",
    },
    CircuitID.ACC_FUNCTION_CHALLENGE_DUPL: {
        "class": AccumulateFunctionChallengeDuplCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.FINALIZE_FUNCTION_CHALLENGE_DUPL: {
        "class": FinalizeFunctionChallengeDuplCircuit,
        "params": None,
        "filename": "ec",
    },
    # CircuitID.FP12_MUL: {
    #     "class": FP12MulCircuit,
    #     "params": None,
    #     "filename": "extf_mul",
    # },
    CircuitID.ADD_EC_POINT: {
        "class": AddECPointCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.DOUBLE_EC_POINT: {
        "class": DoubleECPointCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.MP_CHECK_BIT0_LOOP: {
        "class": MPCheckBit0Loop,
        "params": [{"n_pairs": k} for k in [2, 3]],
        "filename": "multi_pairing_check",
    },
    CircuitID.MP_CHECK_BIT00_LOOP: {
        "class": MPCheckBit00Loop,
        "params": [{"n_pairs": k} for k in [2, 3]],
        "filename": "multi_pairing_check",
    },
    CircuitID.MP_CHECK_BIT1_LOOP: {
        "class": MPCheckBit1Loop,
        "params": [{"n_pairs": k} for k in [2, 3]],
        "filename": "multi_pairing_check",
    },
    CircuitID.MP_CHECK_PREPARE_PAIRS: {
        "class": MPCheckPreparePairs,
        "params": [{"n_pairs": k} for k in [2, 3]],
        "filename": "multi_pairing_check",
    },
    CircuitID.MP_CHECK_PREPARE_LAMBDA_ROOT: {
        "class": MPCheckPrepareLambdaRootEvaluations,
        "params": None,
        "filename": "multi_pairing_check",
    },
    CircuitID.MP_CHECK_INIT_BIT: {
        "class": MPCheckInitBit,
        "params": [{"n_pairs": k} for k in [2, 3]],
        "filename": "multi_pairing_check",
    },
    CircuitID.MP_CHECK_FINALIZE_BN: {
        "class": MPCheckFinalizeBN,
        "params": [{"n_pairs": k} for k in [2, 3]],
        "filename": "multi_pairing_check",
    },
    CircuitID.MP_CHECK_FINALIZE_BLS: {
        "class": MPCheckFinalizeBLS,
        "params": [{"n_pairs": k} for k in [2, 3]],
        "filename": "multi_pairing_check",
    },
    CircuitID.FP12_MUL_ASSERT_ONE: {
        "class": FP12MulAssertOne,
        "params": None,
        "filename": "extf_mul",
    },
}


if __name__ == "__main__":
    import random

    random.seed(0)
    print(f"Compiling Cairo 1 circuits...")
    main(
        PRECOMPILED_CIRCUITS_DIR="src/cairo/src/circuits/",
        CIRCUITS_TO_COMPILE=ALL_CAIRO_GENERIC_CIRCUITS,
        compilation_mode=1,
    )
    print(f"Compiling Fustat circuits...")
    main(
        PRECOMPILED_CIRCUITS_DIR="src/fustat/precompiled_circuits/",
        CIRCUITS_TO_COMPILE=ALL_FUSTAT_CIRCUITS,
        compilation_mode=0,
    )
