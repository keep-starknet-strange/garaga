import sympy

from garaga.definitions import CURVES
from garaga.modulo_circuit import ModuloCircuit, ModuloCircuitElement, PyFelt, WriteOps
from garaga.precompiled_circuits.fp2 import Fp2Circuits


def is_quad_residue(n, p):
    """
    Returns True if n is a quadratic residue mod p.
    """
    return sympy.ntheory.residue_ntheory.is_quad_residue(n, p)


def sqrt_mod_p(n, p):
    """
    Finds the minimum non-negative integer m such that (m*m) % p == n.
    """
    return min(sympy.ntheory.residue_ntheory.sqrt_mod(n, p, all_roots=True))


class IsOnCurveCircuit(Fp2Circuits):
    def __init__(self, name: str, curve_id: int, compilation_mode: int = 0):
        super().__init__(
            name=name,
            curve_id=curve_id,
            compilation_mode=compilation_mode,
            generic_circuit=True,
        )
        self.curve = CURVES[curve_id]

    def set_consts(
        self,
        a: PyFelt | ModuloCircuitElement,
        b: PyFelt | ModuloCircuitElement,
        b20: PyFelt | ModuloCircuitElement,
        b21: PyFelt | ModuloCircuitElement,
    ):
        self.a = self.write_element(a) if isinstance(a, PyFelt) else a
        self.b = self.write_element(b) if isinstance(b, PyFelt) else b
        self.b20 = self.write_element(b20) if isinstance(b20, PyFelt) else b20
        self.b21 = self.write_element(b21) if isinstance(b21, PyFelt) else b21

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


class DecompressG1Point(ModuloCircuit):
    """
    A class to decompress a G1 point on an elliptic curve given the x-coordinate.

    This class is a specialized ModuloCircuit that uses the curve parameters to compute the y-coordinate
    from a given x-coordinate, ensuring that the point lies on the curve. The y-coordinate is determined
    using the s_bit, which is extracted from the compressed G1 point. The s_bit indicates which of the two
    possible y-coordinates (positive or negative) should be selected.
    """

    def __init__(self, name: str, curve_id: int, compilation_mode: int = 0):
        super().__init__(
            name=name,
            curve_id=curve_id,
            generic_circuit=True,
            compilation_mode=compilation_mode,
        )
        self.curve = CURVES[curve_id]

    def derive_y_from_x(
        self,
        b: ModuloCircuitElement,
        x: ModuloCircuitElement,
    ) -> ModuloCircuitElement:
        """
        Derive the two possible y-coordinates from the given x-coordinate on the elliptic curve.
        Ensures that the point lies on the curve.
        Assumes that the curve equation is y^2 = x^3 + b.

        :param x: The x-coordinate as a ModuloCircuitElement.
        :param b: The curve parameter b as a ModuloCircuitElement.
        :return: The two possible y-coordinates as a ModuloCircuitElement.
                    No assumption on the order of the two y-coordinates.
        :raises AssertionError: If the x-coordinate does not lie on the curve.
        """

        assert (
            CURVES[self.curve_id].a == 0
        ), "This circuit is only supported for curves with a = 0"
        assert (
            self.compilation_mode == 0
        ), "This circuit is only supported for CairoZero"

        # y^2 = x^3 + b
        x3 = self.mul(x, self.mul(x, x))
        rhs = self.add(x3, b)

        y = self.fp_sqrt(rhs)
        neg_y = self.neg(y)

        return (y, neg_y)


class ECIPCircuits(ModuloCircuit):
    def __init__(
        self,
        name: str,
        curve_id: int,
        compilation_mode: int = 0,
        generic_circuit: bool = True,
    ):
        super().__init__(
            name=name,
            curve_id=curve_id,
            generic_circuit=generic_circuit,
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
        assert isinstance(ep, ModuloCircuitElement) and isinstance(
            en, ModuloCircuitElement
        )
        assert isinstance(sign_ep, ModuloCircuitElement) and isinstance(
            sign_en, ModuloCircuitElement
        )
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

    def _eval_function_challenge_single(
        self,
        A: tuple[ModuloCircuitElement, ModuloCircuitElement],
        coeff: ModuloCircuitElement,
        log_div_a_num: list[ModuloCircuitElement],
        log_div_a_den: list[ModuloCircuitElement],
        log_div_b_num: list[ModuloCircuitElement],
        log_div_b_den: list[ModuloCircuitElement],
        var_name: str = "xA",
    ) -> ModuloCircuitElement:
        xA, yA = A
        F_A = self.add(
            self.div(
                self.eval_horner(
                    log_div_a_num, xA, poly_name="sumdlogdiv_a_num", var_name=var_name
                ),
                self.eval_horner(
                    log_div_a_den, xA, poly_name="sumdlogdiv_a_den", var_name=var_name
                ),
            ),
            self.mul(
                yA,
                self.div(
                    self.eval_horner(
                        log_div_b_num,
                        xA,
                        poly_name="sumdlogdiv_b_num",
                        var_name=var_name,
                    ),
                    self.eval_horner(
                        log_div_b_den,
                        xA,
                        poly_name="sumdlogdiv_b_den",
                        var_name=var_name,
                    ),
                ),
            ),
        )
        return self.mul(coeff, F_A)

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

        F_A0 = self._eval_function_challenge_single(
            A0,
            coeff0,
            log_div_a_num,
            log_div_a_den,
            log_div_b_num,
            log_div_b_den,
            var_name="xA0",
        )
        F_A2 = self._eval_function_challenge_single(
            A2,
            coeff2,
            log_div_a_num,
            log_div_a_den,
            log_div_b_num,
            log_div_b_den,
            var_name="xA2",
        )

        # return coeff0*F(A0) - coeff2*F(A2)

        res = self.sub(F_A0, F_A2)

        return res

    def _init_function_challenge_dupl(
        self,
        xA0: ModuloCircuitElement,
        xA2: ModuloCircuitElement,
        log_div_a_num: list[ModuloCircuitElement],
        log_div_a_den: list[ModuloCircuitElement],
        log_div_b_num: list[ModuloCircuitElement],
        log_div_b_den: list[ModuloCircuitElement],
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:

        # F = a(x) + y*b(x), a and b being rational functions.
        # computes F(A0) and F(A2)

        # Precompute powers of xA0 and xA2 for evaluating the polynomials.
        xA0_powers = [xA0]
        xA2_powers = [xA2]
        for i in range(len(log_div_b_den) - 2):
            xA0_powers.append(self.mul(xA0_powers[-1], xA0, comment=f"xA0^{i+2}"))
            xA2_powers.append(self.mul(xA2_powers[-1], xA2, comment=f"xA2^{i+2}"))

        A_NUM_A0 = self.eval_poly(
            log_div_a_num, xA0_powers, poly_name="sumdlogdiv_a_num", var_name="xA0"
        )
        A_DEN_A0 = self.eval_poly(
            log_div_a_den, xA0_powers, poly_name="sumdlogdiv_a_den", var_name="xA0"
        )
        B_NUM_A0 = self.eval_poly(
            log_div_b_num, xA0_powers, poly_name="sumdlogdiv_b_num", var_name="xA0"
        )
        B_DEN_A0 = self.eval_poly(
            log_div_b_den, xA0_powers, poly_name="sumdlogdiv_b_den", var_name="xA0"
        )

        A_NUM_A2 = self.eval_poly(
            log_div_a_num, xA2_powers, poly_name="sumdlogdiv_a_num", var_name="xA2"
        )
        A_DEN_A2 = self.eval_poly(
            log_div_a_den, xA2_powers, poly_name="sumdlogdiv_a_den", var_name="xA2"
        )
        B_NUM_A2 = self.eval_poly(
            log_div_b_num, xA2_powers, poly_name="sumdlogdiv_b_num", var_name="xA2"
        )
        B_DEN_A2 = self.eval_poly(
            log_div_b_den, xA2_powers, poly_name="sumdlogdiv_b_den", var_name="xA2"
        )

        # return F(A0) and F(A2), and the last power of xA0 and xA2 used in a_den (also equal to b_num)

        a_den_degree = len(log_div_a_den) - 1
        assert a_den_degree == len(log_div_b_num) - 1

        return (
            A_NUM_A0,
            A_DEN_A0,
            B_NUM_A0,
            B_DEN_A0,
            A_NUM_A2,
            A_DEN_A2,
            B_NUM_A2,
            B_DEN_A2,
            xA0_powers[a_den_degree - 1],
            xA2_powers[a_den_degree - 1],
        )

    def _accumulate_function_challenge_dupl(
        self,
        a_num_acc_A0: ModuloCircuitElement,
        a_den_acc_A0: ModuloCircuitElement,
        b_num_acc_A0: ModuloCircuitElement,
        b_den_acc_A0: ModuloCircuitElement,
        a_num_acc_A2: ModuloCircuitElement,
        a_den_acc_A2: ModuloCircuitElement,
        b_num_acc_A2: ModuloCircuitElement,
        b_den_acc_A2: ModuloCircuitElement,
        xA0: ModuloCircuitElement,
        xA2: ModuloCircuitElement,
        xA0_power: ModuloCircuitElement,
        xA2_power: ModuloCircuitElement,
        next_a_num_coeff: ModuloCircuitElement,
        next_a_den_coeff: ModuloCircuitElement,
        next_b_num_coeff: ModuloCircuitElement,
        next_b_den_coeff: ModuloCircuitElement,
    ):
        # Update accumulators for A0
        new_a_num_acc_A0 = self.add(a_num_acc_A0, self.mul(next_a_num_coeff, xA0_power))
        next_xA0_power = self.mul(xA0_power, xA0)
        new_a_den_acc_A0 = self.add(
            a_den_acc_A0, self.mul(next_a_den_coeff, next_xA0_power)
        )
        new_b_num_acc_A0 = self.add(
            b_num_acc_A0, self.mul(next_b_num_coeff, next_xA0_power)
        )
        next_b_den_A0_power = self.mul(next_xA0_power, xA0)
        for _ in range(2):
            next_b_den_A0_power = self.mul(next_b_den_A0_power, xA0)
        new_b_den_acc_A0 = self.add(
            b_den_acc_A0, self.mul(next_b_den_coeff, next_b_den_A0_power)
        )

        # Update accumulators for A2
        new_a_num_acc_A2 = self.add(a_num_acc_A2, self.mul(next_a_num_coeff, xA2_power))
        next_xA2_power = self.mul(xA2_power, xA2)
        new_a_den_acc_A2 = self.add(
            a_den_acc_A2, self.mul(next_a_den_coeff, next_xA2_power)
        )
        new_b_num_acc_A2 = self.add(
            b_num_acc_A2, self.mul(next_b_num_coeff, next_xA2_power)
        )
        next_b_den_A2_power = next_xA2_power
        for _ in range(3):
            next_b_den_A2_power = self.mul(next_b_den_A2_power, xA2)
        new_b_den_acc_A2 = self.add(
            b_den_acc_A2, self.mul(next_b_den_coeff, next_b_den_A2_power)
        )

        return (
            new_a_num_acc_A0,
            new_a_den_acc_A0,
            new_b_num_acc_A0,
            new_b_den_acc_A0,
            new_a_num_acc_A2,
            new_a_den_acc_A2,
            new_b_num_acc_A2,
            new_b_den_acc_A2,
            next_xA0_power,
            next_xA2_power,
        )

    def _finalize_function_challenge_dupl(
        self,
        a_num_acc_A0: ModuloCircuitElement,
        a_den_acc_A0: ModuloCircuitElement,
        b_num_acc_A0: ModuloCircuitElement,
        b_den_acc_A0: ModuloCircuitElement,
        a_num_acc_A2: ModuloCircuitElement,
        a_den_acc_A2: ModuloCircuitElement,
        b_num_acc_A2: ModuloCircuitElement,
        b_den_acc_A2: ModuloCircuitElement,
        yA0: ModuloCircuitElement,
        yA2: ModuloCircuitElement,
        coeff_A0: ModuloCircuitElement,
        coeff_A2: ModuloCircuitElement,
    ):
        F_A0 = self.add(
            self.div(a_num_acc_A0, a_den_acc_A0),
            self.mul(yA0, self.div(b_num_acc_A0, b_den_acc_A0)),
            comment="a(x0) + y0 b(x0)",
        )
        F_A2 = self.add(
            self.div(a_num_acc_A2, a_den_acc_A2),
            self.mul(yA2, self.div(b_num_acc_A2, b_den_acc_A2)),
            comment="a(x2) + y2 b(x2)",
        )

        # return coeff0*F(A0) - coeff2*F(A2)
        res = self.sub(self.mul(coeff_A0, F_A0), self.mul(coeff_A2, F_A2))
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
        ny = self.sub(self.mul(slope, self.sub(xP, nx)), yP)
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

    def negate_point(
        self, P: tuple[ModuloCircuitElement, ModuloCircuitElement]
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        """Negate a point in G1."""
        x, y = P
        return (x, self.neg(y))

    def add_points(
        self,
        P: tuple[ModuloCircuitElement, ModuloCircuitElement],
        Q: tuple[ModuloCircuitElement, ModuloCircuitElement],
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        """Add two points in G1."""
        xP, yP = P
        xQ, yQ = Q
        slope = self._compute_adding_slope(P, Q)
        slope_sqr = self.mul(slope, slope)
        nx = self.sub(self.sub(slope_sqr, xP), xQ)
        ny = self.sub(self.mul(slope, self.sub(xP, nx)), yP)
        return (nx, ny)

    def double_point_a_eq_0(
        self,
        P: tuple[ModuloCircuitElement, ModuloCircuitElement],
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        """Double a point in G1 when curve parameter a=0."""
        xP, yP = P
        three = self.set_or_get_constant(self.field(3))
        slope = self.div(
            self.mul(three, self.mul(xP, xP)), self.add(yP, yP)  # 3x^2  # 2y
        )
        slope_sqr = self.mul(slope, slope)
        nx = self.sub(self.sub(slope_sqr, xP), xP)
        ny = self.sub(self.mul(slope, self.sub(xP, nx)), yP)
        return (nx, ny)

    def double_n_times(
        self, P: tuple[ModuloCircuitElement, ModuloCircuitElement], n: int
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        """Double a point n times in G1."""
        Q = P
        for _ in range(n):
            Q = self.double_point_a_eq_0(Q)
        return Q


class BasicECG2(Fp2Circuits):
    def __init__(self, name: str, curve_id: int, compilation_mode: int = 0):
        super().__init__(
            name=name,
            curve_id=curve_id,
            generic_circuit=True,
            compilation_mode=compilation_mode,
        )
        self.curve = CURVES[curve_id]

    def _is_on_curve_G2_weirstrass(
        self,
        x0: ModuloCircuitElement,
        x1: ModuloCircuitElement,
        y0: ModuloCircuitElement,
        y1: ModuloCircuitElement,
        a: ModuloCircuitElement,
        b0: ModuloCircuitElement,
        b1: ModuloCircuitElement,
    ):
        # y^2 = x^3 + ax + b [Fp2]

        y2 = self.fp2_square([y0, y1])
        x2 = self.fp2_square([x0, x1])
        x3 = self.fp2_mul([x0, x1], x2)

        ax = [self.mul(a, x0), self.mul(a, x1)]
        ax_b = [self.add(ax[0], b0), self.add(ax[1], b1)]

        x3_ax_b = [self.add(x3[0], ax_b[0]), self.add(x3[1], ax_b[1])]

        return y2, x3_ax_b

    def _compute_adding_slope(
        self,
        P: tuple[
            tuple[ModuloCircuitElement, ModuloCircuitElement],
            tuple[ModuloCircuitElement, ModuloCircuitElement],
        ],
        Q: tuple[
            tuple[ModuloCircuitElement, ModuloCircuitElement],
            tuple[ModuloCircuitElement, ModuloCircuitElement],
        ],
    ):
        xP, yP = P
        xQ, yQ = Q
        slope = self.fp2_div(self.vector_sub(yP, yQ), self.vector_sub(xP, xQ))
        return slope

    def _compute_doubling_slope_a_eq_0(
        self,
        P: tuple[ModuloCircuitElement, ModuloCircuitElement],
    ):

        xP, yP = P
        # Compute doubling slope m = (3x^2 + A) / 2y
        three = self.set_or_get_constant(self.field(3))

        m_num = self.vector_scale(self.fp2_square(xP), three)
        m_den = self.vector_add(yP, yP)
        m = self.fp2_div(m_num, m_den)
        return m

    def add_points(
        self,
        P: tuple[ModuloCircuitElement, ModuloCircuitElement],
        Q: tuple[ModuloCircuitElement, ModuloCircuitElement],
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        xP, yP = P
        xQ, yQ = Q
        slope = self._compute_adding_slope(P, Q)
        slope_sqr = self.fp2_square(slope)
        nx = self.vector_sub(self.vector_sub(slope_sqr, xP), xQ)
        ny = self.vector_sub(self.fp2_mul(slope, self.vector_sub(xP, nx)), yP)
        return (nx, ny)

    def double_point_a_eq_0(
        self,
        P: tuple[ModuloCircuitElement, ModuloCircuitElement],
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        xP, yP = P
        slope = self._compute_doubling_slope_a_eq_0(P)
        slope_sqr = self.fp2_square(slope)
        nx = self.vector_sub(self.vector_sub(slope_sqr, xP), xP)
        ny = self.vector_sub(self.fp2_mul(slope, self.vector_sub(xP, nx)), yP)
        return (nx, ny)

    def double_n_times(self, P, n):
        Q = P
        for _ in range(n):
            Q = self.double_point_a_eq_0(Q)
        return Q

    def negate_point(
        self, P: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]
    ) -> tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]:
        x, y = P
        return (x, self.vector_neg(y))
