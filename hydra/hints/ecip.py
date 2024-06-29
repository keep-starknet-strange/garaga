from __future__ import annotations
from hydra.algebra import Polynomial, PyFelt, RationalFunction, FunctionFelt
from hydra.definitions import CURVES, CurveID, G1Point, get_base_field, EcInfinity
from dataclasses import dataclass
import copy
import functools


def zk_ecip_hint(
    Bs: list[G1Point], dss: list[list[int]]
) -> tuple[G1Point, FunctionFelt]:
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
        coeff = self.coeffs[0][0]
        return FF([c * coeff.__inv__() for c in self.coeffs], self.curve_id)


def construct_function(Ps: list[G1Point]) -> FF:
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
    Example:
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

    # return Num.reduce() / Den
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

    A = G1Point(
        500532348158005792427012276099857990374801464615176306658756800226897275038,
        1364632244480165430435421736927069801466965097654443703239719684851695312731,
        CurveID.BN254,
    )
    B = G1Point(
        11681035366227306109645958315589959231515078945319038988255000450251808706454,
        4952223946796427996651774589529529963923140782933368260063392168718625716292,
        CurveID.BN254,
    )
    field = get_base_field(CurveID.BN254.value)
    Bs = [A, B]
    # aNum = line(A, -A)
    # bNum = line(B, -B)
    # lab = line(A, B)

    # print_ff(aNum)
    # print_ff(bNum)
    # print_ff(lab)

    # print(f"\n")
    # num = aNum * bNum * lab
    # print_ff(num)
    # print_ff(num.reduce())

    # num = num.reduce()

    # print(f"\n")
    # den = line(A, -A) * line(B, -B)
    # print_ff(den)

    # den = den.to_poly()

    # D = num.div_by_poly(den)
    # print_ff(D)
    # print_ff(D.reduce())

    # print_ff(D.reduce().normalize())

    dss = [[1, 1], [1, 1], [1, 1]]

    Q, Ds = ecip_functions(Bs, dss)
    print(f"Q: {Q}")
    for d in Ds:
        print(f"\nD: {print_ff(d)}")

    dl = [dlog(d) for d in Ds]
    for d in dl:
        d: FunctionFelt
        # print(f"\ndl: {d.print_as_sage_poly()}")
        print(
            f"eval : {d.evaluate(field(0x2523648240000001BA344D80000000086121000000000013A700000000000012), field(0x0000000000000000000000000000000000000000000000000000000000000001))}"
        )
    # field = get_base_field(CurveID.BN254.value)
    # # d0: (3*x + 11)*y + x^2 + x + 1
    # d0 = FF(
    #     [Polynomial([field(1), field(1), field(1)]), Polynomial([field(11), field(3)])],
    #     CurveID.BN254,
    # )

    # dlog(d0)

    sum_dlog = dl[0]
    for i in range(1, len(dl)):
        sum_dlog = sum_dlog + (-3) ** i * dl[i]
    print(f"sum_dlog: {sum_dlog.print_as_sage_poly()}")
    print(
        f"eval: {sum_dlog.evaluate(field(0x2523648240000001BA344D80000000086121000000000013A700000000000012), field(0x0000000000000000000000000000000000000000000000000000000000000001))}"
    )
