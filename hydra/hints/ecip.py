from __future__ import annotations
from hydra.algebra import Polynomial, PyFelt, RationalFunction, FunctionFelt
from hydra.definitions import (
    CURVES,
    CurveID,
    G1Point,
    get_base_field,
    EcInfinity,
    STARK,
)
from dataclasses import dataclass
import copy
import functools
from starkware.python.math_utils import is_quad_residue, sqrt as sqrt_mod_p
from hydra.poseidon_transcript import hades_permutation
from hydra.hints.io import int_to_u384, int_array_to_u384_array

def derive_ec_point_from_X(
    x: PyFelt | int, curve_id: CurveID
) -> tuple[PyFelt, list[PyFelt]]:
    field = get_base_field(curve_id.value)
    if isinstance(x, int):
        x = field(x)
    rhs = x**3 + field(CURVES[curve_id.value].a) * x + field(CURVES[curve_id.value].b)
    g = field(CURVES[curve_id.value].fp_generator)

    g_rhs_roots = []
    attempt = 0
    while not is_quad_residue(rhs.value, field.p):
        g_rhs = rhs * g
        g_rhs_roots.append(sqrt_mod_p(g_rhs.value, field.p))
        _x, _, _ = hades_permutation(x.value, attempt, 2)
        x = field(_x)
        rhs = (
            x**3 + field(CURVES[curve_id.value].a) * x + field(CURVES[curve_id.value].b)
        )
        attempt += 1

    y = sqrt_mod_p(rhs.value, field.p)
    assert field(y) ** 2 == rhs
    return x, y, g_rhs_roots

def zk_ecip_hint(
    Bs: list[G1Point], dss: list[list[int]]
) -> tuple[G1Point, FunctionFelt]:
    """
    Inputs:
    - Bs: list of points on the curve
    - dss: list of digits of the points in Bs (obtained from scalars using hints.neg3.construct_digit_vectors)
    Returns:
    - Q: MSM of Bs by scalars contained in dss matrix
    - sum_dlog: sum of the logarithmic derivatives of the functions in Ds

    Use this to verify equation 3 in https://eprint.iacr.org/2022/596.pdf
    Partial Ref : https://gist.github.com/Liam-Eagen/666d0771f4968adccd6087465b8c5bd4
    Full algo verifying it available in tests/benchmarks.py::test_msm_n_points
    """
    Q, Ds = ecip_functions(Bs, dss)
    dlogs = [dlog(D) for D in Ds]
    sum_dlog = dlogs[0]
    for i in range(1, len(dlogs)):
        sum_dlog = sum_dlog + (-3) ** i * dlogs[i]
    return Q, sum_dlog

def slope_intercept(P: G1Point, Q: G1Point) -> tuple[PyFelt, PyFelt]:
    field = get_base_field(P.curve_id.value)
    if P == Q:
        px, py = field(P.x), field(P.y)
        m = (3 * px**2 + CURVES[P.curve_id.value].a) / (2 * py)
        b = py - m * px
        return (m, b)
    else:
        px, py = field(P.x), field(P.y)
        qx, qy = field(Q.x), field(Q.y)
        m = (py - qy) / (px - qx)
        b = qy - m * qx
        return (m, b)


def line(P: G1Point, Q: G1Point) -> FF:
    """
    Returns line function passing through points, works for all points and returns 1 for O + O = O
    """
    field = get_base_field(P.curve_id.value)
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
        m = (3 * Px**2 + CURVES[P.curve_id.value].a) / (2 * Py)
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
    Represents a polynomial over F_p[x]
    Example : F(x, y) = c0(x) + c1(x) * y + c2(x) * y^2 + ...
    """

    coeffs: list[Polynomial]
    y2: Polynomial
    p: int
    curve_id: CurveID

    def __init__(self, coeffs: list[Polynomial], curve_id: CurveID):
        self.coeffs = coeffs
        self.p = coeffs[0][0].p
        self.field = get_base_field(curve_id.value)
        self.curve_id = curve_id
        a = self.field(CURVES[curve_id.value].a)
        b = self.field(CURVES[curve_id.value].b)
        # y² = x³ + ax + b
        self.y2 = Polynomial([b, a, self.field.zero(), self.field.one()])

    def degree(self) -> int:
        return len(self.coeffs) - 1

    def __getitem__(self, i: int) -> Polynomial:
        try:
            return self.coeffs[i]
        except IndexError:
            return Polynomial.zero(self.p)

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

        zero = Polynomial.zero(self.p)

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
                self.coeffs.append(Polynomial.zero(self.p))
            return self
        y2 = self.y2
        deg_0_coeff = copy.deepcopy(self.coeffs[0])
        deg_1_coeff = copy.deepcopy(self.coeffs[1])
        for i, poly in enumerate(self.coeffs):
            if i == 0 or i == 1:
                continue
            if i % 2 == 0:
                deg_0_coeff = deg_0_coeff + poly * y2
            else:
                deg_1_coeff = deg_1_coeff + poly * y2
                y2 = y2 * y2
        return FF([deg_0_coeff, deg_1_coeff], self.curve_id)

    def to_poly(self) -> Polynomial:
        assert len(self.coeffs) == 1
        return self.coeffs[0]

    def div_by_poly(self, poly: Polynomial) -> "FF":
        return FF([c // poly for c in self.coeffs], self.curve_id)

    def normalize(self) -> "FF":
        """
        Normalize the polynomial by dividing all coefficients by the first one
        """
        coeff = self.coeffs[0][0]
        return FF([c * coeff.__inv__() for c in self.coeffs], self.curve_id)

def construct_function(Ps: list[G1Point]) -> FF:
    """
    Returns a function exactly interpolating the points Ps
    """
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
            num = (aNum * bNum * line(A, B)).reduce()
            den = (line(A, -A) * line(B, -B)).to_poly()
            D = num.div_by_poly(den)
            xs2.append((A.add(B), D))

        if x0 is not None:
            xs2.append(x0)

        xs = xs2

    assert xs[0][0].is_infinity()

    return D.normalize()

def row_function(ds: list[int], Ps: list[G1Point], Q: G1Point) -> tuple[FF, G1Point]:
    digits_points = [
        P if d == 1 else -P if d == -1 else G1Point(0, 0, P.curve_id)
        for d, P in zip(ds, Ps)
    ]
    sum_digits_points = functools.reduce(lambda x, y: x.add(y), digits_points)
    Q2 = Q.scalar_mul(-3).add(sum_digits_points)
    Q_neg = -Q
    div_ = [Q_neg, Q_neg, Q_neg, -Q2] + digits_points
    div = [P for P in div_ if not P.is_infinity()]

    D = construct_function(div)
    return (D, Q2)

def ecip_functions(Bs: list[G1Point], dss: list[list[int]]) -> tuple[G1Point, list[FF]]:
    dss.reverse()

    Q = G1Point(0, 0, Bs[0].curve_id)
    Ds = []
    for ds in dss:
        D, Q = row_function(ds, Bs, Q)
        Ds.append(D)

    Ds.reverse()
    return (Q, Ds)

def dlog(d: FF) -> FunctionFelt:
    """
    Compute the logarithmic derivative of a Function
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
    field = get_base_field(d.curve_id.value)

    d: FF = d.reduce()
    assert len(d.coeffs) == 2, f"D has {len(d.coeffs)} coeffs: {d.coeffs}"
    Dx = FF([d[0].differentiate(), d[1].differentiate()], d.curve_id)
    Dy: Polynomial = d[1]  # B(x)

    TWO_Y: FF = FF([Polynomial.zero(field.p), Polynomial([field(2)])], d.curve_id)
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
            Polynomial.zero(field.p),
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
        coeff_str = p.print_as_sage_poly(var_name=f"x")

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


if __name__ == "__main__":
    import random

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

    codes = "\n".join(
        [
            build_cairo1_tests_derive_ec_point_from_X(x, curve_id, idx)
            for idx, x in enumerate([random.randint(0, STARK - 1) for _ in range(2)])
            for curve_id in CurveID
        ]
    )

    print(codes)
