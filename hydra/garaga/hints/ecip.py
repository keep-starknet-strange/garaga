from __future__ import annotations

import functools
from dataclasses import dataclass

from garaga import garaga_rs
from garaga.algebra import Fp2, FunctionFelt, Polynomial, PyFelt, RationalFunction, T
from garaga.definitions import CURVES, CurveID, G1Point, G2Point, get_base_field
from garaga.hints.neg_3 import (
    construct_digit_vectors,
    neg_3_base_le,
    positive_negative_multiplicities,
)
from garaga.poseidon_transcript import hades_permutation


def get_field_type_from_ec_point(P: G1Point | G2Point) -> type[T]:
    """
    Maps an elliptic curve point to the type of the field it belongs to.
    G1Point -> PyFelt
    G2Point -> Fp2
    """
    if isinstance(P, G1Point):
        return PyFelt
    elif isinstance(P, G2Point):
        return Fp2
    else:
        raise ValueError(f"Invalid point type {type(P)}")


def get_ec_group_class_from_ec_point(P: G1Point | G2Point) -> type[G1Point | G2Point]:
    """
    Maps an elliptic curve point to the class of the elliptic curve group it belongs to.
    G1Point -> G1Point
    G2Point -> G2Point
    """
    if isinstance(P, G1Point):
        return G1Point
    elif isinstance(P, G2Point):
        return G2Point
    else:
        raise ValueError(f"Invalid point type {type(P)}")


def derive_ec_point_from_X(
    x: PyFelt | int | Fp2, curve_id: CurveID
) -> tuple[PyFelt, PyFelt, list[PyFelt]] | tuple[Fp2, Fp2, list[Fp2]]:
    """
    From a "random" x coordinate (in practice obtained via the Cairo Poseidon252 hash), finds via a
    "try-and-increment" algorithm a point on the curve for a given curveID.
    Works for curves over base field ("PyFelt") or degree 2 extension field ("Fp2")
    Returns :
    - x (PyFelt or Fp2) - x coordinate of the obtained point after the try-and-increment
    - y (PyFelt or Fp2) - y coordinate of the obtained point after the try-and-increment
    - g_rhs_roots (list of PyFelt of Fp2). A list of square roots over the given field.

    At each attempt, if rhs(x) = x^3 + ax + b is not a quad residue (ie: the point is not on the curve),
    x is updated by hashing it with the attempt : new_x = poseidon(x, attempt)

    Since in a finite field, if z is not a quad residue, g*z is a quad residue (alternatively), at each attempt,
    the square root of g*x is stored in the g*rhs_roots array.

    This is used to verify the existence of the square roots in Cairo.
    See the derive_ec_point_from_X cairo function in ec_ops.cairo.
    """
    field = get_base_field(curve_id.value)
    if isinstance(x, int):
        x = field(x)

    def rhs_compute(x: PyFelt | Fp2) -> PyFelt | Fp2:
        """
        Compute the right hand side of the Weirstrass equation.
        rhs(x) = x^3 + ax + b
        """
        if isinstance(x, Fp2):
            return (
                x**3
                + x * field(CURVES[curve_id.value].a)
                + Fp2(
                    field(CURVES[curve_id.value].b20), field(CURVES[curve_id.value].b21)
                )
            )
        else:
            return (
                x**3
                + field(CURVES[curve_id.value].a) * x
                + field(CURVES[curve_id.value].b)
            )

    if isinstance(x, Fp2):
        g = Fp2(
            field(CURVES[curve_id.value].nr_a0),
            field(CURVES[curve_id.value].nr_a1),
        )
    else:
        g = field(CURVES[curve_id.value].fp_generator)

    rhs = rhs_compute(x)
    g_rhs_roots = []
    attempt = 0
    while not rhs.is_quad_residue():
        g_rhs = rhs * g
        g_rhs_roots.append(g_rhs.sqrt())
        if isinstance(x, Fp2):
            _s0, _, _ = hades_permutation(x.a0.value, x.a1.value, 2)
            _x0, _x1, _ = hades_permutation(_s0, attempt, 2)
            x = Fp2(field(_x0), field(_x1))
        else:
            _x, _, _ = hades_permutation(x.value, attempt, 2)
            x = field(_x)

        rhs = rhs_compute(x)
        attempt += 1

    y = rhs.sqrt()
    assert y**2 == rhs
    return x, y, g_rhs_roots


def zk_ecip_hint(
    Bs: list[G1Point] | list[G2Point], scalars: list[int], use_rust: bool = True
) -> tuple[G1Point | G2Point, FunctionFelt[T]]:
    """
    Inputs:
    - Bs: list of points on the curve
    - scalars: list of scalars
    Returns:
    - Q: MSM of Bs by scalars contained in dss matrix
    - sum_dlog: sum of the logarithmic derivatives of the functions in Ds

    Use this to verify equation 3 in https://eprint.iacr.org/2022/596.pdf
    Partial Ref : https://gist.github.com/Liam-Eagen/666d0771f4968adccd6087465b8c5bd4
    Full algo verifying it in the function verify_ecip below.
    """
    assert len(Bs) == len(scalars)

    ec_group_class = get_ec_group_class_from_ec_point(Bs[0])
    if ec_group_class == G1Point and use_rust:
        pts = []
        c_id = Bs[0].curve_id
        for pt in Bs:
            pts.extend([pt.x, pt.y])
        field_type = get_field_type_from_ec_point(Bs[0])
        field = get_base_field(c_id.value, field_type)

        q, a_num, a_den, b_num, b_den = garaga_rs.zk_ecip_hint(
            pts, list(scalars), c_id.value
        )

        a_num = [field(f) for f in a_num] if len(a_num) > 0 else [field.zero()]
        a_den = [field(f) for f in a_den] if len(a_den) > 0 else [field.one()]
        b_num = [field(f) for f in b_num] if len(b_num) > 0 else [field.zero()]
        b_den = [field(f) for f in b_den] if len(b_den) > 0 else [field.one()]

        Q = G1Point(q[0], q[1], c_id)
        sum_dlog = FunctionFelt(
            RationalFunction(Polynomial(a_num), Polynomial(a_den)),
            RationalFunction(Polynomial(b_num), Polynomial(b_den)),
        )
    else:
        dss = construct_digit_vectors(scalars)
        Q, Ds = ecip_functions(Bs, dss)
        dlogs = [dlog(D) for D in Ds]
        sum_dlog = dlogs[0]
        field = get_base_field(Q.curve_id.value, PyFelt)
        for i in range(1, len(dlogs)):
            sum_dlog = sum_dlog + (-3) ** i * dlogs[i]
    return Q, sum_dlog


def verify_ecip(
    Bs: list[G1Point] | list[G2Point],
    scalars: list[int],
    Q: G1Point | G2Point = None,
    sum_dlog: FunctionFelt[T] = None,
    A0: G1Point | G2Point = None,
    use_rust: bool = True,
) -> bool:
    """
    Verifies the zk-ecip hint.
    If Q, sum_dlog are not provided from a previous computation of the zk_ecip_hint, it will compute them.
    If the random point A0 is not provided for verifying the hint, a random one will be sampled.
    """
    # Prover :
    if Q is None or sum_dlog is None:
        Q, sum_dlog = zk_ecip_hint(Bs, scalars, use_rust)
    else:
        Q = Q
        sum_dlog = sum_dlog
    # Verifier :
    assert sum_dlog.validate_degrees(len(Bs))
    epns = [
        positive_negative_multiplicities(neg_3_base_le(scalar)) for scalar in scalars
    ]

    c_id = Q.curve_id.value
    ec_group_class = get_ec_group_class_from_ec_point(Q)
    field_type = get_field_type_from_ec_point(Q)

    field = get_base_field(Q.curve_id.value, field_type)

    # Verifier must derive a random point A0.
    # In non-interactive context, hash public inputs (Bs, scalars) and prover info (Q, sum_dlog) then map the resulting field element to a point.
    if A0 is None:
        A0 = ec_group_class.gen_random_point(Q.curve_id)
    else:
        A0 = A0

    A2 = A0.scalar_mul(-2)

    xA0 = field(A0.x)
    yA0 = field(A0.y)

    xA2 = field(A2.x)
    yA2 = field(A2.y)

    mA0, bA0 = slope_intercept(A0, A0)
    mA0A2, _ = slope_intercept(A2, A0)

    coeff2 = (2 * yA2 * (xA0 - xA2)) / (
        3 * xA2**2 + field(CURVES[c_id].a) - 2 * mA0A2 * yA2
    )
    coeff0 = coeff2 + 2 * mA0A2

    basis_sum = field.zero()
    for i, (P, (ep, en)) in enumerate(zip(Bs, epns)):
        if P.is_infinity():
            # print("skipping infinity")
            continue
        if ep - en == 0:
            # print("skipping 0")
            continue
        basis_sum += eval_point_challenge_signed(P, xA0, mA0, bA0, ep, en)
        # print(f"rhs_acc {i}: {basis_sum.value}")

    if Q.is_infinity():
        RHS = basis_sum
    else:
        RHS = eval_point_challenge(-Q, xA0, mA0, bA0, 1) + basis_sum

    LHS = coeff0 * sum_dlog.evaluate(xA0, yA0) - coeff2 * sum_dlog.evaluate(xA2, yA2)

    # Verifier must check that LHS = RHS.
    assert LHS == RHS, f"LHS: {LHS}, RHS: {RHS}"

    #########
    assert Q == ec_group_class.msm(
        Bs, scalars
    )  # Sanity check. Not part of the verification.
    ##########
    return True


def slope_intercept(
    P: G1Point | G2Point, Q: G1Point | G2Point
) -> tuple[PyFelt, PyFelt] | tuple[Fp2, Fp2]:
    """
    Returns the slope and intercept of the line passing through points P and Q.
    y = mx + b
    """
    field = get_base_field(P.curve_id.value, get_field_type_from_ec_point(P))
    if P == Q:
        px, py = field(P.x), field(P.y)
        m = (3 * px**2 + field(CURVES[P.curve_id.value].a)) / (2 * py)
        b = py - m * px
        return (m, b)
    else:
        px, py = field(P.x), field(P.y)
        qx, qy = field(Q.x), field(Q.y)
        m = (py - qy) / (px - qx)
        b = qy - m * qx
        return (m, b)


def eval_point_challenge(
    P: G1Point | G2Point, xA0, mA0, bA0, multiplicity: int
) -> PyFelt | Fp2:
    field_type = get_field_type_from_ec_point(P)
    field = get_base_field(P.curve_id.value, field_type)

    xP, yP = field(P.x), field(P.y)
    num = xA0 - xP
    den = yP - mA0 * xP - bA0
    res = multiplicity * num / den
    assert isinstance(res, field_type), f"Expected {field_type}, got {type(res)}"
    return res


def eval_point_challenge_signed(
    P: G1Point | G2Point, xA0, mA0, bA0, ep: int, en: int
) -> PyFelt | Fp2:
    return eval_point_challenge(P, xA0, mA0, bA0, ep) + eval_point_challenge(
        -P, xA0, mA0, bA0, en
    )


def line(P: G1Point | G2Point, Q: G1Point | G2Point) -> FF[T]:
    """
    Returns line function passing through points, works for all points and returns 1 for O + O = O
    """
    assert (
        P.curve_id == Q.curve_id
    ), f"Points must be on the same curve, got {P.curve_id} and {Q.curve_id}"
    assert isinstance(
        P, type(Q)
    ), f"Points must be in the same group, got {type(P)} and {type(Q)}"

    if isinstance(P, G1Point):
        field_type = PyFelt
    elif isinstance(P, G2Point):
        field_type = Fp2
    else:
        raise ValueError(f"Invalid point type {type(P)}")

    field = get_base_field(P.curve_id.value, field_type)

    if P.is_infinity():
        if Q.is_infinity():
            return FF([Polynomial([field.one()])], P.curve_id)
        else:
            Qx = field(Q.x)
            return FF([Polynomial([-Qx, field.one()])], P.curve_id)
    if Q.is_infinity():
        Px = field(P.x)
        return FF([Polynomial([-Px, field.one()])], P.curve_id)

    Px, Py = field(P.x), field(P.y)

    if P == Q:
        m = (3 * Px**2 + field(CURVES[P.curve_id.value].a)) / (2 * Py)
        b = Py - m * Px
        # -m*x + y -b
        return FF([Polynomial([-b, -m]), Polynomial([field.one()])], P.curve_id)

    if P == -Q:
        return FF([Polynomial([-Px, field.one()])], P.curve_id)

    Qx, Qy = field(Q.x), field(Q.y)

    m = (Py - Qy) / (Px - Qx)
    b = Qy - m * Qx
    return FF([Polynomial([-b, -m]), Polynomial([field.one()])], P.curve_id)


@dataclass
class FF:
    """
    Represents a polynomial over F_p[x] or F_p^2[x]
    Example : F(x, y) = c0(x) + c1(x) * y + c2(x) * y^2 + ...
    where c0, c1, c2, ... are polynomials over F_p[x] or F_p^2[x]
    Used to represent a subset of the Function Field where coefficients are polynomials instead of rational functions.
    """

    coeffs: list[Polynomial[T]]
    y2: Polynomial[T]  # = x^3 + ax + b, where a, b are the curve parameters
    p: int
    curve_id: CurveID
    type: type[T]  # PyFelt or Fp2

    def __init__(self, coeffs: list[Polynomial[T]], curve_id: CurveID):
        self.coeffs = coeffs
        self.p = coeffs[0][0].p
        self.field = get_base_field(curve_id.value, type(coeffs[0][0]))
        self.curve_id = curve_id
        self.type = type(coeffs[0][0])
        a = self.field(CURVES[curve_id.value].a)
        if self.type == PyFelt:
            b = self.field(CURVES[curve_id.value].b)
        else:
            b = self.field((CURVES[curve_id.value].b20, CURVES[curve_id.value].b21))

        # y² = x³ + ax + b
        self.y2 = Polynomial([b, a, self.field.zero(), self.field.one()])

    def degree(self) -> int:
        return len(self.coeffs) - 1

    def __getitem__(self, i: int) -> Polynomial:
        try:
            return self.coeffs[i]
        except IndexError:
            return Polynomial.zero(self.p, self.type)

    def __add__(self, other: FF) -> FF:
        if not isinstance(other, FF):
            raise TypeError(f"Cannot add FF and {type(other)}")

        ns, no = len(self.coeffs), len(other.coeffs)
        if ns >= no:
            coeffs = self.coeffs[:]
            for i in range(no):
                coeffs[i] = coeffs[i] + other.coeffs[i]
        else:
            coeffs = other.coeffs[:]
            for i in range(ns):
                coeffs[i] = coeffs[i] + self.coeffs[i]

        return FF(coeffs, self.curve_id)

    def __mul__(self, other: "FF" | Polynomial | PyFelt) -> "FF":
        if isinstance(other, (PyFelt, Polynomial)):
            return FF([c * other for c in self.coeffs], self.curve_id)
        elif not isinstance(other, FF):
            raise TypeError(
                f"Cannot multiply polynomial by type {type(other)}, must be PyFelt, Polynomial, or FF"
            )

        if self.coeffs == [] or other.coeffs == []:
            return FF([Polynomial([self.field.zero()])], self.curve_id)

        zero = Polynomial.zero(self.p, self.type)

        buf = [zero] * (len(self.coeffs) + len(other.coeffs) - 1)
        for i in range(len(self.coeffs)):
            if self.coeffs[i].is_zero():
                continue  # optimization for sparse polynomials
            for j in range(len(other.coeffs)):
                buf[i + j] = buf[i + j] + self.coeffs[i] * other.coeffs[j]
        res = FF(buf, self.curve_id)
        return res

    def neg_y(self) -> "FF":
        """Keeps all the coefficients the same but negate the degree 1 coeff"""
        if len(self.coeffs) < 2:
            return self
        coeffs = self.coeffs[:]
        coeffs[1] = -coeffs[1]
        return FF(coeffs, self.curve_id)

    def reduce(self) -> "FF":
        """
        Reduces the polynomial modulo y² = x³ + ax + b
        Replaces y² with x³ + ax + b and reduces the degree of the polynomial
        Always returns a polynomial of at most degree 1.
        Enforce it has 2 coefficients (padding with zero polynomials if needed)
        """
        if len(self.coeffs) <= 2:
            while len(self.coeffs) < 2:
                self.coeffs.append(Polynomial.zero(self.p, self.type))
            return self
        y2 = self.y2
        deg_0_coeff = self.coeffs[0]
        deg_1_coeff = self.coeffs[1]
        for i, poly in enumerate(self.coeffs):
            if i == 0 or i == 1:
                continue
            if i % 2 == 0:
                deg_0_coeff = deg_0_coeff + poly * y2
            else:
                deg_1_coeff = deg_1_coeff + poly * y2
                y2 = y2 * y2
        return FF([deg_0_coeff, deg_1_coeff], self.curve_id)

    def to_poly(self) -> Polynomial[T]:
        """
        "Downcasts" the FF to a Polynomial iff the FF is of degree 1.
        """
        assert len(self.coeffs) == 1
        return self.coeffs[0]

    def div_by_poly(self, poly: Polynomial[T]) -> "FF":
        return FF([c // poly for c in self.coeffs], self.curve_id)

    def normalize(self) -> "FF":
        """
        Normalize the polynomial by dividing all coefficients by the first one
        """
        coeff = self.coeffs[0][0]
        return FF([c * coeff.__inv__() for c in self.coeffs], self.curve_id)


class EmptyListOfPoints(Exception):
    pass


def construct_function(Ps: list[G1Point] | list[G2Point]) -> FF:
    """
    Returns a function field element (class FF) exactly interpolating the points Ps.
    """
    if len(Ps) == 0:
        raise EmptyListOfPoints(
            "Cannot construct a function from an empty list of points"
        )
    xs = [(P, line(P, -P)) for P in Ps]

    while len(xs) != 1:
        xs2 = []

        if len(xs) & 1:
            x0 = xs[0]
            xs = xs[1:]
        else:
            x0 = None

        for n in range(0, len(xs) // 2):
            (A, aNum) = xs[2 * n]
            (B, bNum) = xs[2 * n + 1]
            aNum_bNum = aNum * bNum
            line_AB = line(A, B)
            product = aNum_bNum * line_AB
            num = product.reduce()
            den = (line(A, -A) * line(B, -B)).to_poly()
            D = num.div_by_poly(den)
            xs2.append((A.add(B), D))

        if x0 is not None:
            xs2.append(x0)

        xs = xs2

    assert xs[0][0].is_infinity()

    return xs[-1][1].normalize()


def row_function(
    ds: list[int], Ps: list[G1Point] | list[G2Point], Q: G1Point | G2Point
) -> tuple[FF, G1Point | G2Point]:
    ec_group_class = G1Point if isinstance(Q, G1Point) else G2Point
    infinity = ec_group_class.infinity(Q.curve_id)

    digits_points = [
        P if d == 1 else -P if d == -1 else infinity for d, P in zip(ds, Ps)
    ]
    sum_digits_points = functools.reduce(lambda x, y: x.add(y), digits_points)
    Q2 = Q.scalar_mul(-3).add(sum_digits_points)
    Q_neg = -Q
    div_ = [Q_neg, Q_neg, Q_neg, -Q2] + digits_points
    div = [P for P in div_ if not P.is_infinity()]
    try:
        D = construct_function(div)
    except EmptyListOfPoints:
        field_type = get_field_type_from_ec_point(div_[0])
        # Returning 1 so that dLog(D) = 0 and doesn't contribute to the sum.
        D = FF(
            [Polynomial.one(get_base_field(Q.curve_id, field_type).p, field_type)],
            Q.curve_id,
        )

    return (D, Q2)


def ecip_functions(
    Bs: list[G1Point] | list[G2Point], dss: list[list[int]]
) -> tuple[G1Point | G2Point, list[FF]]:
    dss.reverse()
    ec_group_class = G1Point if isinstance(Bs[0], G1Point) else G2Point
    Q = ec_group_class.infinity(Bs[0].curve_id)
    Ds = []
    for i, ds in enumerate(dss):
        D, Q = row_function(ds, Bs, Q)
        Ds.append(D)

    Ds.reverse()
    return (Q, Ds)


def dlog(d: FF) -> FunctionFelt:
    """
    Compute the logarithmic derivative of a FunctionFieldElement (class FF),
    Returns a FunctionFelt such that F = a(x) + b(x) * y with a, b RationalFunctions

    Ref https://gist.github.com/Liam-Eagen/666d0771f4968adccd6087465b8c5bd4 (cell #12)

    Example values:
    D: (3*x + 11)*y + x^2 + x + 1
    Dx: 3*y + 2*x + 1
    Dy: 3*x + 11
    Dz_tmp: (9*x^3 + 33*x^2)/(2*y)
    Dz: (6*y^2 + (4*x + 2)*y + 9*x^3 + 33*x^2)/(2*y)
    U=2*y*Dz: 6*y^2 + (4*x + 2)*y + 9*x^3 + 33*x^2
    V=2*y*D: (6*x + 22)*y^2 + (2*x^2 + 2*x + 2)*y

    """
    field = d.field

    d: FF = d.reduce()
    assert len(d.coeffs) == 2, f"D has {len(d.coeffs)} coeffs: {d.coeffs}"

    Dx = FF([d[0].differentiate(), d[1].differentiate()], d.curve_id)
    Dy: Polynomial = d[1]  # B(x)

    TWO_Y: FF = FF(
        [Polynomial.zero(field.p, d.type), Polynomial([field(2)])], d.curve_id
    )
    U: FF = Dx * TWO_Y + FF(
        [
            Dy
            * Polynomial(
                [
                    field(CURVES[d.curve_id.value].a),
                    field.zero(),
                    field(3),
                ]  # 3x^2 + A
            ),
            Polynomial.zero(field.p, d.type),
        ],
        d.curve_id,
    )

    V: FF = TWO_Y * d

    # print(f"U: {print_ff(U)}")
    # print(f"V: {print_ff(V)}")

    Num: FF = (U * V.neg_y()).reduce()
    Den_FF: FF = (V * V.neg_y()).reduce()

    # print(f"Num: {print_ff(Num)}")
    # print(f"Den: {print_ff(Den_FF)}")

    assert Den_FF[
        1
    ].is_zero(), f"Den[1] is not zero: {Den_FF[1].print_as_sage_poly('x')}"

    Den: Polynomial = Den_FF[0]

    _, _, gcd_0 = Polynomial.xgcd(Num[0], Den)
    # print(f"GCD_0: {gcd_0.print_as_sage_poly('x')}")
    _, _, gcd_1 = Polynomial.xgcd(Num[1], Den)
    # print(f"GCD_1: {gcd_1.print_as_sage_poly('x')}")

    # Simplify the numerator and denominator by dividing by the gcd

    a_num = Num[0] // gcd_0
    a_den = Den // gcd_0
    b_num = Num[1] // gcd_1
    b_den = Den // gcd_1

    # Normalize to obtain exactly Sage's coeffs.
    res = FunctionFelt(
        a=RationalFunction(
            a_num * Den.leading_coefficient().__inv__(),
            a_den * a_den.leading_coefficient().__inv__(),
        ),
        b=RationalFunction(
            b_num * Den.leading_coefficient().__inv__(),
            b_den * b_den.leading_coefficient().__inv__(),
        ),
    )
    # print(f"res: {res.print_as_sage_poly()}\n")
    return res


def print_ff(ff: FF):
    string = ""
    coeffs = ff.coeffs
    for i, p in enumerate(coeffs[::-1]):
        coeff_str = p.print_as_sage_poly(var_name="x", as_hex=True)

        if i == len(coeffs) - 1:
            if coeff_str == "":
                string = string[:-2]
            else:
                string += f"{coeff_str}"
        elif i == len(coeffs) - 2:
            string += f"({coeff_str})*y + "
        else:
            string += f"({coeff_str})*y^{len(coeffs) - i - 1} + "
    # print(string)
    return string


def n_points_from_n_coeffs(n_coeffs: int, batched: bool) -> int:
    if batched:
        extra = 4 * 2
    else:
        extra = 0

    # n_coeffs = 10 + 4n_points => 4n_points = n_coeffs - 10
    assert n_coeffs >= 10 + extra
    assert (n_coeffs - 10 - extra) % 4 == 0
    return (n_coeffs - 10 - extra) // 4


def n_coeffs_from_n_points(n_points: int, batched: bool) -> tuple[int, int, int, int]:
    if batched:
        extra = 2
    else:
        extra = 0

    return (
        1 + n_points + extra,
        1 + n_points + 1 + extra,
        1 + n_points + 1 + extra,
        1 + n_points + 4 + extra,
    )


if __name__ == "__main__":
    import random

    from garaga.definitions import STARK
    from garaga.hints.io import int_array_to_u384_array, int_to_u384

    random.seed(0)

    def build_cairo1_tests_derive_ec_point_from_X(x: int, curve_id: CurveID, idx: int):
        x_f, y, roots = derive_ec_point_from_X(x, curve_id)

        code = f"""
        #[test]
            fn derive_ec_point_from_X_{CurveID(curve_id).name}_{idx}() {{
                let x: felt252 = {x%STARK};
                let y: u384 = {int_to_u384(y)};
                let grhs_roots:Array<u384> = {int_array_to_u384_array(roots)};
                let result = derive_ec_point_from_X(x, y, grhs_roots, {curve_id.value});
                assert!(result.x == {int_to_u384(x_f)});
                assert!(result.y == y);
            }}
            """
        return code

    # codes = "\n".join(
    #     [
    #         build_cairo1_tests_derive_ec_point_from_X(x, curve_id, idx)
    #         for idx, x in enumerate([random.randint(0, STARK - 1) for _ in range(2)])
    #         for curve_id in CurveID
    #     ]
    # )

    # print(codes)

    # average_n_roots = 0
    # max_n_roots = 0
    # n = 10000
    # for i in range(n):
    #     x, y, roots = derive_ec_point_from_X(
    #         Fp2.random(CURVES[0].p, max_value=STARK), CurveID(0)
    #     )
    #     # print(f"x: {x}, y: {y}, roots: {roots}")
    #     max_n_roots = max(max_n_roots, len(roots))
    #     average_n_roots += len(roots)
    # print(f"Average number of roots: {average_n_roots / n}")
    # print(f"Max number of roots: {max_n_roots}")

    # verify_ecip([G1Point.gen_random_point(CurveID.SECP256K1)], scalars=[-1])

    import time

    order = CURVES[CurveID.BN254.value].n
    n = 50
    Bs = [G1Point.gen_random_point(CurveID.BN254) for _ in range(n)]
    ss = [random.randint(1, order) for _ in range(n)]

    t0 = time.time()
    ZZ = zk_ecip_hint(Bs, ss, use_rust=False)
    time_taken_py = time.time() - t0
    print(f"Time taken py : {time_taken_py}")

    t0 = time.time()
    ZZ_rs = zk_ecip_hint(Bs, ss, use_rust=True)
    time_taken_rs = time.time() - t0
    print(f"Time taken rs : {time_taken_rs}")

    print(f"Ratio: {time_taken_py / time_taken_rs}")

    assert ZZ == ZZ_rs
