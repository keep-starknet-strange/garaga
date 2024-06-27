from hydra.modulo_circuit import WriteOps
from hydra.extension_field_modulo_circuit import (
    ModuloCircuit,
    ModuloCircuitElement,
    PyFelt,
    Polynomial,
)
from hydra.definitions import (
    CURVES,
    STARK,
    CurveID,
    BN254_ID,
    BLS12_381_ID,
    Curve,
)

import random
from enum import Enum

from starkware.python.math_utils import is_quad_residue, sqrt as sqrt_mod_p


class IsOnCurveCircuit(ModuloCircuit):
    def __init__(self, name: str, curve_id: int, compilation_mode: int = 0):
        super().__init__(
            name=name,
            curve_id=curve_id,
            compilation_mode=compilation_mode,
            generic_circuit=True,
        )
        self.curve = CURVES[curve_id]

    def set_consts(self, a: PyFelt, b: PyFelt, b20: PyFelt, b21: PyFelt):
        self.a = self.write_element(a)
        self.b = self.write_element(b)
        self.b20 = self.write_element(b20)
        self.b21 = self.write_element(b21)

    def _is_on_curve_G1(
        self, x: ModuloCircuitElement, y: ModuloCircuitElement
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        # y^2 = x^3 + ax + b
        a = self.a
        b = self.b

        y2 = self.mul(y, y)
        x3 = self.mul(x, self.mul(x, x))

        if a.value != 0:
            ax = self.mul(a, x)
            x3_ax_b = self.add(x3, self.add(ax, b))
        else:
            x3_ax_b = self.add(x3, b)

        return y2, x3_ax_b

    def _is_on_curve_G2(
        self,
        x0: ModuloCircuitElement,
        x1: ModuloCircuitElement,
        y0: ModuloCircuitElement,
        y1: ModuloCircuitElement,
    ):
        # y^2 = x^3 + ax + b [Fp2]
        a = self.a
        b0 = self.b20
        b1 = self.b21

        y2 = self.fp2_square([y0, y1])
        x2 = self.fp2_square([x0, x1])
        x3 = self.fp2_mul([x0, x1], x2)

        ax = [self.mul(a, x0), self.mul(a, x1)]
        ax_b = [self.add(ax[0], b0), self.add(ax[1], b1)]

        x3_ax_b = [self.add(x3[0], ax_b[0]), self.add(x3[1], ax_b[1])]

        return y2, x3_ax_b


class DerivePointFromX(ModuloCircuit):
    def __init__(self, name: str, curve_id: int, compilation_mode: int = 0):
        super().__init__(
            name=name,
            curve_id=curve_id,
            generic_circuit=True,
            compilation_mode=compilation_mode,
        )
        self.curve = CURVES[curve_id]

    def _derive_point_from_x(
        self,
        x: ModuloCircuitElement,
        a: ModuloCircuitElement,
        b: ModuloCircuitElement,
        g: ModuloCircuitElement,
    ) -> list[ModuloCircuitElement]:
        # y^2 = x^3 + ax + b
        # Assumes a == 0.
        x3 = self.mul(x, self.mul(x, x))
        rhs = self.add(x3, self.add(self.mul(a, x), b))

        grhs = self.mul(g, rhs)

        # WRITE g*rhs and rhs "square roots" to circuit.
        # If rhs is a square, write zero to gx and the square root of rhs to x3_ax_b_sqrt.
        # Otherwise, write the square root of gx to gx_sqrt and zero to x3_ax_b_sqrt.
        ## %{
        if is_quad_residue(rhs.value, self.field.p):
            rhs_sqrt = self.write_element(
                self.field(sqrt_mod_p(rhs.value, self.field.p)),
                WriteOps.WITNESS,
            )
            grhs_sqrt = self.write_element(self.field.zero(), WriteOps.WITNESS)

        else:
            assert is_quad_residue(grhs.value, self.field.p)  # Sanity check.
            rhs_sqrt = self.write_element(self.field.zero(), WriteOps.WITNESS)

            grhs_sqrt = self.write_element(
                self.field(sqrt_mod_p(grhs.value, self.field.p)),
                WriteOps.WITNESS,
            )

        ## %}
        should_be_rhs = self.mul(rhs_sqrt, rhs_sqrt)

        should_be_grhs = self.mul(grhs_sqrt, grhs_sqrt)

        return (rhs, grhs, should_be_rhs, should_be_grhs, rhs_sqrt)


class ECIPCircuits(ModuloCircuit):
    def __init__(self, name: str, curve_id: int, compilation_mode: int = 0):
        super().__init__(
            name=name,
            curve_id=curve_id,
            generic_circuit=True,
            compilation_mode=compilation_mode,
        )
        self.curve = CURVES[curve_id]

    def _slope_intercept_same_point(
        self,
        P: tuple[ModuloCircuitElement, ModuloCircuitElement],
        A_weirstrass: ModuloCircuitElement,
    ):
        # Compute doubling slope m = (3x^2 + A) / 2y

        xA0, yA0 = P
        three = self.set_or_get_constant(self.field(3))

        mA0_num = self.add(
            self.mul(three, self.mul(xA0, xA0)),
            A_weirstrass,
        )
        mA0_den = self.add(yA0, yA0)
        m_A0 = self.div(mA0_num, mA0_den)

        # Compute intercept b = y - x*m
        b_A0 = self.sub(yA0, self.mul(xA0, m_A0))

        # Compute A2 = -(2*P)
        xA2 = self.sub(self.mul(m_A0, m_A0), self.add(xA0, xA0))
        yA2 = self.sub(self.mul(m_A0, self.sub(xA0, xA2)), yA0)
        yA2 = self.neg(yA2)

        # Compute slope for A2
        # mA2_num = self.add(
        #     self.mul(three, self.mul(xA2, xA2)),
        #     A_weirstrass,
        # )
        # mA2_den = self.add(yA2, yA2)
        # m_A2 = self.div(mA2_num, mA2_den)

        # Compute slope between A0 and A2
        mA0A2_num = self.sub(yA2, yA0)
        mA0A2_den = self.sub(xA2, xA0)
        m_A0A2 = self.div(mA0A2_num, mA0A2_den)

        #   coeff2 = (2 * yA2) * (xA0 - xA2) / (3 * xA2^2 + A - 2 * m * yA2)
        m_yA2 = self.mul(m_A0A2, yA2)

        coeff2 = self.div(
            self.mul(self.add(yA2, yA2), self.sub(xA0, xA2)),
            self.add(
                self.mul(three, self.mul(xA2, xA2)),
                self.sub(A_weirstrass, self.add(m_yA2, m_yA2)),
            ),
        )
        #     coeff0 = (coeff2 + 2 * m)

        coeff0 = self.add(coeff2, self.add(m_A0A2, m_A0A2))

        # Return slope intercept of A0 (for RHS) and coeff0/2 for LHS
        return (
            m_A0,
            b_A0,
            xA0,
            yA0,
            xA2,
            yA2,
            coeff0,
            coeff2,
        )

    def _accumulate_eval_point_challenge_signed_same_point(
        self,
        eval_accumulator: ModuloCircuitElement,
        slope_intercept: tuple[ModuloCircuitElement, ModuloCircuitElement],
        xA: ModuloCircuitElement,
        P: tuple[ModuloCircuitElement, ModuloCircuitElement],
        ep: ModuloCircuitElement,
        en: ModuloCircuitElement,
        sign_ep: ModuloCircuitElement,
        sign_en: ModuloCircuitElement,
    ) -> ModuloCircuitElement:
        m, b = slope_intercept
        xP, yP = P
        num = self.sub(xA, xP)

        # den_tmp = m*xP + b
        den_tmp = self.add(self.mul(m, xP), b)

        # den_pos = yP - (m*xP + b) = yP - m*xP - b
        den_pos = self.sub(yP, den_tmp)

        # den_neg = -yP - m*xP -b
        den_neg = self.sub(self.neg(yP), den_tmp)

        eval_pos = self.mul(self.mul(sign_ep, ep), self.div(num, den_pos))
        eval_neg = self.mul(self.mul(sign_en, en), self.div(num, den_neg))

        eval_signed = self.add(eval_pos, eval_neg)
        res = self.add(eval_accumulator, eval_signed)
        return res

    def _RHS_finalize_acc(
        self,
        eval_accumulator: ModuloCircuitElement,
        slope_intercept: tuple[ModuloCircuitElement, ModuloCircuitElement],
        xA: ModuloCircuitElement,
        Q: tuple[ModuloCircuitElement, ModuloCircuitElement],
    ):
        m, b = slope_intercept
        xQ, yQ = Q
        num = self.sub(xA, xQ)

        # den_tmp = m*xQ + b
        den_tmp = self.add(self.mul(m, xQ), b)

        # den_neg = -yQ - m*xQ -b

        den_neg = self.sub(self.neg(yQ), den_tmp)

        eval_neg = self.div(num, den_neg)

        res = self.add(eval_accumulator, eval_neg)
        return res

    def _eval_function_challenge_dupl(
        self,
        A0: tuple[ModuloCircuitElement, ModuloCircuitElement],
        A2: tuple[ModuloCircuitElement, ModuloCircuitElement],
        coeff0: ModuloCircuitElement,
        coeff2: ModuloCircuitElement,
        log_div_a_num: list[ModuloCircuitElement],
        log_div_a_den: list[ModuloCircuitElement],
        log_div_b_num: list[ModuloCircuitElement],
        log_div_b_den: list[ModuloCircuitElement],
    ) -> ModuloCircuitElement:

        # F = a(x) + y*b(x), a and b being rational functions.
        # computes coeff0*F(A0) - coeff2*F(A2)

        xA0, yA0 = A0
        xA2, yA2 = A2

        # Precompute powers of xA0 and xA2 for evaluating the polynomials.
        xA0_powers = [xA0]
        xA2_powers = [xA2]
        for _ in range(len(log_div_b_den) - 2):
            xA0_powers.append(self.mul(xA0_powers[-1], xA0))
            xA2_powers.append(self.mul(xA2_powers[-1], xA2))

        F_A0 = self.add(
            self.div(
                self.eval_poly(log_div_a_num, xA0_powers),
                self.eval_poly(log_div_a_den, xA0_powers),
            ),
            self.mul(
                yA0,
                self.div(
                    self.eval_poly(log_div_b_num, xA0_powers),
                    self.eval_poly(log_div_b_den, xA0_powers),
                ),
            ),
        )

        F_A2 = self.add(
            self.div(
                self.eval_poly(log_div_a_num, xA2_powers),
                self.eval_poly(log_div_a_den, xA2_powers),
            ),
            self.mul(
                yA2,
                self.div(
                    self.eval_poly(log_div_b_num, xA2_powers),
                    self.eval_poly(log_div_b_den, xA2_powers),
                ),
            ),
        )

        # return coeff0*F(A0) - coeff2*F(A2)

        res = self.sub(self.mul(coeff0, F_A0), self.mul(coeff2, F_A2))

        return res


class BasicEC(ModuloCircuit):
    def __init__(self, name: str, curve_id: int, compilation_mode: int = 0):
        super().__init__(
            name=name,
            curve_id=curve_id,
            generic_circuit=True,
            compilation_mode=compilation_mode,
        )
        self.curve = CURVES[curve_id]

    def _compute_adding_slope(
        self,
        P: tuple[ModuloCircuitElement, ModuloCircuitElement],
        Q: tuple[ModuloCircuitElement, ModuloCircuitElement],
    ):
        xP, yP = P
        xQ, yQ = Q
        slope = self.div(self.sub(yP, yQ), self.sub(xP, xQ))
        return slope

    def _compute_doubling_slope(
        self,
        P: tuple[ModuloCircuitElement, ModuloCircuitElement],
        A: ModuloCircuitElement,
    ):

        xP, yP = P
        # Compute doubling slope m = (3x^2 + A) / 2y
        three = self.set_or_get_constant(self.field(3))

        m_num = self.add(
            self.mul(three, self.mul(xP, xP)),
            A,
        )
        m_den = self.add(yP, yP)
        m = self.div(m_num, m_den)
        return m

    def add_points(
        self,
        P: tuple[ModuloCircuitElement, ModuloCircuitElement],
        Q: tuple[ModuloCircuitElement, ModuloCircuitElement],
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        xP, yP = P
        xQ, yQ = Q
        slope = self._compute_adding_slope(P, Q)
        slope_sqr = self.mul(slope, slope)
        nx = self.sub(self.sub(slope_sqr, xP), xQ)
        ny = self.sub(self.mul(slope, self.sub(xP, nx)), yP)
        return (nx, ny)

    def double_point(
        self,
        P: tuple[ModuloCircuitElement, ModuloCircuitElement],
        A: ModuloCircuitElement,
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        xP, yP = P
        slope = self._compute_doubling_slope(P, A)
        slope_sqr = self.mul(slope, slope)
        nx = self.sub(self.sub(slope_sqr, xP), xP)
        ny = self.sub(yP, self.mul(slope, self.sub(xP, nx)))
        return (nx, ny)

    def scalar_mul_2_pow_k(
        self,
        P: tuple[ModuloCircuitElement, ModuloCircuitElement],
        A: ModuloCircuitElement,
        k: int,
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        for _ in range(k):
            P = self.double_point(P, A)
        return P

    def _is_on_curve_G1_weirstrass(
        self,
        x: ModuloCircuitElement,
        y: ModuloCircuitElement,
        A: ModuloCircuitElement,
        b: ModuloCircuitElement,
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        # y^2 = x^3 + ax + b
        y2 = self.mul(y, y)
        x3 = self.mul(x, self.mul(x, x))
        ax = self.mul(A, x)
        x3_ax_b = self.add(x3, self.add(ax, b))
        return y2, x3_ax_b
