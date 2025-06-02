from random import randint

import garaga.modulo_circuit_structs as structs
from garaga.definitions import CURVES, CurveID, G1Point, G2Point
from garaga.hints import neg_3
from garaga.hints.ecip import (
    n_coeffs_from_n_points,
    n_points_from_n_coeffs,
    slope_intercept,
)
from garaga.modulo_circuit import WriteOps
from garaga.modulo_circuit_structs import G1PointCircuit, G2PointCircuit, u384
from garaga.precompiled_circuits.cofactor_clearing import G1CofactorClearing
from garaga.precompiled_circuits.compilable_circuits.base import (
    BaseModuloCircuit,
    ModuloCircuit,
    PyFelt,
)
from garaga.precompiled_circuits.ec import (
    BasicEC,
    BasicECG2,
    ECIPCircuits,
    FakeGLVCircuits,
    IsOnCurveCircuit,
)


class DummyCircuit(BaseModuloCircuit):
    def __init__(
        self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0
    ) -> None:
        super().__init__(
            name="dummy",
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
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        curve_id = CurveID(self.curve_id)
        order = CURVES[self.curve_id].n
        input = []
        n1, n2 = randint(1, order), randint(1, order)
        p1, p2 = G1Point.get_nG(curve_id, n1), G2Point.get_nG(curve_id, n2)
        pair = [p1.x, p1.y, p2.x[0], p2.x[1], p2.y[0], p2.y[1]]
        input.extend([self.field(x) for x in pair])
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
        circuit = BasicECG2(
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


class AddECPointsG2Circuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0):
        super().__init__(
            name="add_ec_points_g2",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        P = G2Point.gen_random_point(CurveID(self.curve_id))
        Q = G2Point.gen_random_point(CurveID(self.curve_id))
        input.append(self.field(P.x[0]))
        input.append(self.field(P.x[1]))
        input.append(self.field(P.y[0]))
        input.append(self.field(P.y[1]))
        input.append(self.field(Q.x[0]))
        input.append(self.field(Q.x[1]))
        input.append(self.field(Q.y[0]))
        input.append(self.field(Q.y[1]))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = BasicECG2(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        px0, px1, py0, py1 = circuit.write_struct(
            G2PointCircuit("p", input[0:4]), WriteOps.INPUT
        )
        qx0, qx1, qy0, qy1 = circuit.write_struct(
            G2PointCircuit("q", input[4:8]), WriteOps.INPUT
        )

        (nx0, nx1), (ny0, ny1) = circuit.add_points(
            ((px0, px1), (py0, py1)), ((qx0, qx1), (qy0, qy1))
        )
        circuit.extend_struct_output(G2PointCircuit("result", [nx0, nx1, ny0, ny1]))

        return circuit


class DoubleECPointG2AEq0Circuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0):
        super().__init__(
            name="double_ec_point_g2_a_eq_0",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        P = G2Point.gen_random_point(CurveID(self.curve_id))
        input.append(self.field(P.x[0]))
        input.append(self.field(P.x[1]))
        input.append(self.field(P.y[0]))
        input.append(self.field(P.y[1]))

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = BasicECG2(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        px0, px1, py0, py1 = circuit.write_struct(
            G2PointCircuit("p", input[0:4]), WriteOps.INPUT
        )

        (nx0, nx1), (ny0, ny1) = circuit.double_point_a_eq_0(((px0, px1), (py0, py1)))
        circuit.extend_struct_output(G2PointCircuit("result", [nx0, nx1, ny0, ny1]))

        return circuit


class SlopeInterceptSamePointCircuit(BaseModuloCircuit):
    def __init__(
        self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0
    ) -> None:
        super().__init__(
            name="slope_intercept_same_point",
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
            name="acc_eval_point_challenge_signed",
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


class EvalFunctionChallengeSingleCircuit(BaseModuloCircuit):
    def __init__(
        self,
        curve_id: int,
        n_points: int = 1,
        auto_run: bool = True,
        compilation_mode: int = 0,
        batched: bool = False,
        generic_circuit: bool = True,
    ) -> None:
        self.n_points = n_points
        self.batched = batched
        self.generic_circuit = generic_circuit
        super().__init__(
            name=f"eval_fn_challenge_sing_{n_points}P" + ("_rlc" if batched else ""),
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        circuit = SlopeInterceptSamePointCircuit(self.curve_id, auto_run=False)
        xA, _yA, _A = circuit.build_input()
        m_A0, b_A0, xA0, yA0, xA2, yA2, coeff0, coeff2 = circuit._run_circuit_inner(
            [xA, _yA, _A]
        ).output
        input.extend([xA0.felt, _yA.felt, coeff0.felt])
        n_coeffs = n_coeffs_from_n_points(self.n_points, self.batched)
        for _ in range(sum(n_coeffs)):
            input.append(self.field(randint(0, CURVES[self.curve_id].p - 1)))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ECIPCircuits(
            self.name,
            self.curve_id,
            compilation_mode=self.compilation_mode,
            generic_circuit=self.generic_circuit,
        )

        xA0, yA0 = circuit.write_struct(
            G1PointCircuit("A", [input[0], input[1]]), WriteOps.INPUT
        )
        coeff0 = circuit.write_struct(u384("coeff", [input[2]]), WriteOps.INPUT)

        all_coeffs = input[3:]

        def split_list(input_list, lengths):
            start_idx, result = 0, []
            for length in lengths:
                result.append(input_list[start_idx : start_idx + length])
                start_idx += length
            return result

        n_points = n_points_from_n_coeffs(len(all_coeffs), self.batched)
        _log_div_a_num, _log_div_a_den, _log_div_b_num, _log_div_b_den = split_list(
            all_coeffs, n_coeffs_from_n_points(n_points, self.batched)
        )
        log_div_a_num, log_div_a_den, log_div_b_num, log_div_b_den = (
            circuit.write_struct(
                structs.FunctionFeltCircuit(
                    name="SumDlogDiv" + ("Batched" if self.batched else ""),
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

        res = circuit._eval_function_challenge_single(
            (xA0, yA0),
            coeff0,
            log_div_a_num,
            log_div_a_den,
            log_div_b_num,
            log_div_b_den,
        )
        circuit.extend_struct_output(u384("res", [res]))

        return circuit


class EvalFunctionChallengeDuplCircuit(BaseModuloCircuit):
    def __init__(
        self,
        curve_id: int,
        n_points: int = 1,
        auto_run: bool = True,
        compilation_mode: int = 0,
        batched: bool = False,
        generic_circuit: bool = True,
    ) -> None:
        self.n_points = n_points
        self.batched = batched
        self.generic_circuit = generic_circuit
        super().__init__(
            name=f"eval_fn_challenge_dupl_{n_points}P" + ("_rlc" if batched else ""),
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        circuit = SlopeInterceptSamePointCircuit(self.curve_id, auto_run=False)
        xA, _yA, _A = circuit.build_input()
        m_A0, b_A0, xA0, yA0, xA2, yA2, coeff0, coeff2 = circuit._run_circuit_inner(
            [xA, _yA, _A]
        ).output
        input.extend([xA0.felt, _yA.felt, xA2.felt, yA2.felt, coeff0.felt, coeff2.felt])
        n_coeffs = n_coeffs_from_n_points(self.n_points, self.batched)
        for _ in range(sum(n_coeffs)):
            input.append(self.field(randint(0, CURVES[self.curve_id].p - 1)))
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ECIPCircuits(
            self.name,
            self.curve_id,
            compilation_mode=self.compilation_mode,
            generic_circuit=self.generic_circuit,
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

        n_points = n_points_from_n_coeffs(len(all_coeffs), self.batched)
        _log_div_a_num, _log_div_a_den, _log_div_b_num, _log_div_b_den = split_list(
            all_coeffs, n_coeffs_from_n_points(n_points, self.batched)
        )
        log_div_a_num, log_div_a_den, log_div_b_num, log_div_b_den = (
            circuit.write_struct(
                structs.FunctionFeltCircuit(
                    name="SumDlogDiv" + ("Batched" if self.batched else ""),
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
        batched: bool = False,
        compilation_mode: int = 0,
    ) -> None:
        self.n_points = n_points
        self.batched = batched
        super().__init__(
            name=f"init_fn_challenge_dupl_{n_points}P" + ("_rlc" if batched else ""),
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random(), self.field.random()])  # xA0, xA2
        n_coeffs = n_coeffs_from_n_points(self.n_points, self.batched)
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

        n_points = n_points_from_n_coeffs(len(all_coeffs), self.batched)
        _log_div_a_num, _log_div_a_den, _log_div_b_num, _log_div_b_den = split_list(
            all_coeffs, n_coeffs_from_n_points(n_points, self.batched)
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
            structs.GenericT("next_a_num_coeff", [input[12]]), WriteOps.INPUT
        )
        next_a_den_coeff = circuit.write_struct(
            structs.GenericT("next_a_den_coeff", [input[13]]), WriteOps.INPUT
        )
        next_b_num_coeff = circuit.write_struct(
            structs.GenericT("next_b_num_coeff", [input[14]]), WriteOps.INPUT
        )
        next_b_den_coeff = circuit.write_struct(
            structs.GenericT("next_b_den_coeff", [input[15]]), WriteOps.INPUT
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
            name="finalize_fn_challenge_dupl",
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
        circuit.generic_modulus = True
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
        circuit.generic_modulus = True
        xP, yP = circuit.write_struct(G1PointCircuit("p", input[0:2]), WriteOps.INPUT)
        A = circuit.write_struct(u384("A_weirstrass", [input[2]]))
        xR, yR = circuit.double_point((xP, yP), A)
        circuit.extend_struct_output(G1PointCircuit("r", [xR, yR]))

        return circuit


class PrepareGLVFakeGLVPtsCircuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0):
        super().__init__(
            name="prepare_glv_fake_glv_pts",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.append(self.field.random())  # Px
        input.append(self.field.random())  # P0y
        input.append(self.field.random())  # P1y
        input.append(self.field.random())  # Qx
        input.append(self.field.random())  # Q0y
        input.append(self.field.random())  # Phi_P0y
        input.append(self.field.random())  # Phi_P1y
        input.append(self.field.random())  # Phi_Q0y
        input.append(self.field.random())  # Gen_x
        input.append(self.field.random())  # Gen_y
        input.append(self.field.random())  # third_root

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = FakeGLVCircuits(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        circuit.generic_modulus = True
        Px = circuit.write_struct(u384("Px", [input[0]]), WriteOps.INPUT)
        P0y = circuit.write_struct(u384("P0y", [input[1]]), WriteOps.INPUT)
        P1y = circuit.write_struct(u384("P1y", [input[2]]), WriteOps.INPUT)
        Qx = circuit.write_struct(u384("Qx", [input[3]]), WriteOps.INPUT)
        Q0y = circuit.write_struct(u384("Q0y", [input[4]]), WriteOps.INPUT)
        Phi_P0y = circuit.write_struct(u384("Phi_P0y", [input[5]]), WriteOps.INPUT)
        Phi_P1y = circuit.write_struct(u384("Phi_P1y", [input[6]]), WriteOps.INPUT)
        Phi_Q0y = circuit.write_struct(u384("Phi_Q0y", [input[7]]), WriteOps.INPUT)
        Gen = circuit.write_struct(
            G1PointCircuit("Gen", [input[8], input[9]]), WriteOps.INPUT
        )
        third_root = circuit.write_struct(
            u384("third_root", [input[10]]), WriteOps.INPUT
        )

        (
            B1,
            B2,
            B3,
            B4,
            B5,
            B6,
            B7,
            B8,
            B9y,
            B10y,
            B11y,
            B12y,
            B13y,
            B14y,
            B15y,
            B16y,
            Phi_P0x,
            Phi_Q0x,
            Acc,
        ) = circuit.prepare_points_glv_fake_glv(
            Px, P0y, P1y, Qx, Q0y, Phi_P0y, Phi_P1y, Phi_Q0y, Gen, third_root
        )
        # circuit.exact_output_refs_needed = [B2[0], B3[0], B4[0], B5[0], B6[0], B7[0], B8[0], B10y, B11y, B12y, B13y, B14y, B15y, B16y, Acc[0], Acc[1]]
        circuit.extend_struct_output(G1PointCircuit("B1", [B1[0], B1[1]]))
        circuit.extend_struct_output(G1PointCircuit("B2", [B2[0], B2[1]]))
        circuit.extend_struct_output(G1PointCircuit("B3", [B3[0], B3[1]]))
        circuit.extend_struct_output(G1PointCircuit("B4", [B4[0], B4[1]]))
        circuit.extend_struct_output(G1PointCircuit("B5", [B5[0], B5[1]]))
        circuit.extend_struct_output(G1PointCircuit("B6", [B6[0], B6[1]]))
        circuit.extend_struct_output(G1PointCircuit("B7", [B7[0], B7[1]]))
        circuit.extend_struct_output(G1PointCircuit("B8", [B8[0], B8[1]]))
        circuit.extend_struct_output(u384("B9y", [B9y]))
        circuit.extend_struct_output(u384("B10y", [B10y]))
        circuit.extend_struct_output(u384("B11y", [B11y]))
        circuit.extend_struct_output(u384("B12y", [B12y]))
        circuit.extend_struct_output(u384("B13y", [B13y]))
        circuit.extend_struct_output(u384("B14y", [B14y]))
        circuit.extend_struct_output(u384("B15y", [B15y]))
        circuit.extend_struct_output(u384("B16y", [B16y]))
        circuit.extend_struct_output(u384("Phi_P0x", [Phi_P0x]))
        circuit.extend_struct_output(u384("Phi_Q0x", [Phi_Q0x]))
        circuit.extend_struct_output(G1PointCircuit("Acc", [Acc[0], Acc[1]]))
        return circuit


class PrepareFakeGLVPtsCircuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0):
        super().__init__(
            name="prepare_fake_glv_pts",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.append(self.field.random())  # Px
        input.append(self.field.random())  # Py
        input.append(self.field.random())  # Qx
        input.append(self.field.random())  # Qy
        input.append(self.field.random())  # s2_sign
        input.append(self.field.random())  # A_weirstrass

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = FakeGLVCircuits(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        circuit.generic_modulus = True
        P = circuit.write_struct(
            G1PointCircuit("P", [input[0], input[1]]), WriteOps.INPUT
        )
        Q = circuit.write_struct(
            G1PointCircuit("Q", [input[2], input[3]]), WriteOps.INPUT
        )
        s2_sign = circuit.write_struct(u384("s2_sign", [input[4]]), WriteOps.INPUT)
        A_weirstrass = circuit.write_struct(
            u384("A_weirstrass", [input[5]]), WriteOps.INPUT
        )

        (
            T1,
            T2,
            T3,
            T4,
            T5y,
            T6y,
            T7y,
            T8y,
            T9,
            T10,
            T11,
            T12,
            T13y,
            T14y,
            T15y,
            T16y,
            R2,
            R0y,
        ) = circuit.prepare_points_fake_glv(P, Q, s2_sign, A_weirstrass)
        # circuit.exact_output_refs_needed = [B2[0], B3[0], B4[0], B5[0], B6[0], B7[0], B8[0], B10y, B11y, B12y, B13y, B14y, B15y, B16y, Acc[0], Acc[1]]
        circuit.extend_struct_output(G1PointCircuit("T1", [T1[0], T1[1]]))
        circuit.extend_struct_output(G1PointCircuit("T2", [T2[0], T2[1]]))
        circuit.extend_struct_output(G1PointCircuit("T3", [T3[0], T3[1]]))
        circuit.extend_struct_output(G1PointCircuit("T4", [T4[0], T4[1]]))
        circuit.extend_struct_output(u384("T5y", [T5y]))
        circuit.extend_struct_output(u384("T6y", [T6y]))
        circuit.extend_struct_output(u384("T7y", [T7y]))
        circuit.extend_struct_output(u384("T8y", [T8y]))
        circuit.extend_struct_output(G1PointCircuit("T9", [T9[0], T9[1]]))
        circuit.extend_struct_output(G1PointCircuit("T10", [T10[0], T10[1]]))
        circuit.extend_struct_output(G1PointCircuit("T11", [T11[0], T11[1]]))
        circuit.extend_struct_output(G1PointCircuit("T12", [T12[0], T12[1]]))
        circuit.extend_struct_output(u384("T13y", [T13y]))
        circuit.extend_struct_output(u384("T14y", [T14y]))
        circuit.extend_struct_output(u384("T15y", [T15y]))
        circuit.extend_struct_output(u384("T16y", [T16y]))
        circuit.extend_struct_output(G1PointCircuit("R2", [R2[0], R2[1]]))
        circuit.extend_struct_output(u384("R0y", [R0y]))
        return circuit


class QuadrupleAndAdd9Circuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0):
        super().__init__(
            name="quadruple_and_add_9",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.append(self.field.random())  # Px
        input.append(self.field.random())  # Py
        for _ in range(9):
            input.append(self.field.random())  # Qx
            input.append(self.field.random())  # Qy
        input.append(self.field.random())  # A_weirstrass

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = BasicEC(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        circuit.generic_modulus = True
        P = circuit.write_struct(
            G1PointCircuit("P", [input[0], input[1]]), WriteOps.INPUT
        )
        Qs = []
        for i in range(2, len(input) - 1, 2):
            Qs.append(
                circuit.write_struct(
                    G1PointCircuit(f"Q_{i//2}", [input[i], input[i + 1]]),
                    WriteOps.INPUT,
                )
            )

        A_weirstrass = circuit.write_struct(
            u384("A_weirstrass", [input[len(input) - 1]]), WriteOps.INPUT
        )

        Rx, Ry = circuit.n_quadruple_and_add(P, Qs, A_weirstrass)
        circuit.extend_struct_output(G1PointCircuit("R", [Rx, Ry]))
        return circuit


class ClearCofactorBLS12_381Circuit(BaseModuloCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, compilation_mode: int = 0):
        super().__init__(
            name="clear_cofactor_bls12_381",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.append(self.field.random())  # Px
        input.append(self.field.random())  # Py
        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = G1CofactorClearing(
            self.name, self.curve_id, compilation_mode=self.compilation_mode
        )
        circuit.generic_modulus = True
        P = circuit.write_struct(
            G1PointCircuit("P", [input[0], input[1]]), WriteOps.INPUT
        )

        res = circuit.clear_cofactor(P)
        circuit.extend_struct_output(G1PointCircuit("res", [res[0], res[1]]))
        return circuit
