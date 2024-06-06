from src.algebra import Polynomial, BaseField, PyFelt, ModuloCircuitElement
from starkware.python.math_utils import ec_safe_mult, EcInfinity, ec_safe_add
from dataclasses import dataclass
from enum import Enum
from src.hints.io import bigint_split
import random
import functools

N_LIMBS = 4
BASE = 2**96
STARK = 0x800000000000011000000000000000000000000000000000000000000000001
BN254_ID = int.from_bytes(b"bn254", "big")
BLS12_381_ID = int.from_bytes(b"bls12_381", "big")
SECP256K1_ID = int.from_bytes(b"secp256k1", "big")
SECP256R1_ID = int.from_bytes(b"secp256r1", "big")
X25519_ID = int.from_bytes(b"x25519", "big")


class CurveID(Enum):
    BN254 = int.from_bytes(b"bn254", "big")
    BLS12_381 = int.from_bytes(b"bls12_381", "big")
    SECP256K1 = int.from_bytes(b"secp256k1", "big")
    SECP256R1 = int.from_bytes(b"secp256r1", "big")
    X25519 = int.from_bytes(b"x25519", "big")


@dataclass(slots=True, frozen=True)
class Curve:
    cairo_zero_namespace_name: str
    id: int
    p: int
    n: int  # order
    x: int | None  # curve x paramter
    h: int  # cofactor
    irreducible_polys: dict[int, list[int]]
    nr_a0: int  # E2 non residue
    nr_a1: int
    a: int  # y^2 = x^3 + ax + b
    b: int
    b20: int
    b21: int  # E2: b is (b20, b21)
    loop_counter: list[int]
    line_function_sparsity: list[
        int
    ]  # # 0: ==0, 1: !=0, 2: ==1.. L(x) = Σ(sparsity[i] * coeff[i] * x^i )
    final_exp_cofactor: int
    fp_generator: int  # A generator of the field of the curve. To verify it, use is_generator function.
    Gx: int  # x-coordinate of the generator point
    Gy: int  # y-coordinate of the generator point

    def to_cairo_zero(self) -> str:
        code = f"namespace {self.cairo_zero_namespace_name} {{\n"
        code += f"const CURVE_ID = {self.id};\n"
        p = bigint_split(self.p, N_LIMBS, BASE)
        n = bigint_split(self.n, N_LIMBS, BASE)
        a = bigint_split(self.a, N_LIMBS, BASE)
        b = bigint_split(self.b, N_LIMBS, BASE)
        g = bigint_split(self.fp_generator, N_LIMBS, BASE)
        min_one = bigint_split(-1 % self.p, N_LIMBS, BASE)
        for i, l in enumerate(p):
            code += f"const P{i} = {hex(l)};\n"
        for i, l in enumerate(n):
            code += f"const N{i} = {hex(l)};\n"
        for i, l in enumerate(a):
            code += f"const A{i} = {hex(l)};\n"
        for i, l in enumerate(b):
            code += f"const B{i} = {hex(l)};\n"
        for i, l in enumerate(g):
            code += f"const G{i} = {hex(l)};\n"
        for i, l in enumerate(min_one):
            code += f"const MIN_ONE_D{i} = {hex(l)};\n"
        code += "}\n"
        return code


def NAF(x):
    if x == 0:
        return []
    z = 0 if x % 2 == 0 else 2 - (x % 4)
    return NAF((x - z) // 2) + [z]


GNARK_CLI_SUPPORTED_CURVES = {BN254_ID, BLS12_381_ID}

CURVES: dict[int, Curve] = {
    BN254_ID: Curve(
        cairo_zero_namespace_name="bn",
        id=BN254_ID,
        p=0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47,
        n=0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593F0000001,
        x=0x44e992b44a6909f1,
        h=1,
        irreducible_polys={
            6: [82, 0, 0, -18, 0, 0, 1],
            12: [82, 0, 0, 0, 0, 0, -18, 0, 0, 0, 0, 0, 1],
        },
        nr_a0=9,
        nr_a1=1,
        a=0,
        b=3,
        b20=0x2B149D40CEB8AAAE81BE18991BE06AC3B5B4C5E559DBEFA33267E6DC24A138E5,
        b21=0x9713B03AF0FED4CD2CAFADEED8FDF4A74FA084E52D1852E4A2BD0685C315D2,
        loop_counter=NAF(29793968203157093288)[::-1],
        line_function_sparsity=[
            2,
            1,
            0,
            1,
            0,
            0,
            0,
            1,
            0,
            1,
            0,
            0,
        ],
        final_exp_cofactor=1469306990098747947464455738335385361638823152381947992820,  # cofactor = 2 * x0 * (6 * x0**2 + 3 * x0 + 1)
        fp_generator=3,
        Gx=0x2523648240000001BA344D80000000086121000000000013A700000000000012,
        Gy=0x0000000000000000000000000000000000000000000000000000000000000001,
    ),
    BLS12_381_ID: Curve(
        cairo_zero_namespace_name="bls",
        id=BLS12_381_ID,
        p=0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAB,
        n=0x73EDA753299D7D483339D80809A1D80553BDA402FFFE5BFEFFFFFFFF00000001,
        x=-0xd201000000010000,
        h=0x396C8C005555E1568C00AAAB0000AAAB,
        irreducible_polys={
            6: [2, 0, 0, -2, 0, 0, 1],
            12: [2, 0, 0, 0, 0, 0, -2, 0, 0, 0, 0, 0, 1],
        },
        nr_a0=1,
        nr_a1=1,
        a=0,
        b=4,
        b20=4,
        b21=4,
        loop_counter=[int(x) for x in bin(15132376222941642752)[2:][::-1]],
        line_function_sparsity=[
            1,
            0,
            1,
            2,
            0,
            0,
            1,
            0,
            1,
            0,
            0,
            0,
        ],
        final_exp_cofactor=3,
        fp_generator=3,
        Gx=0x17F1D3A73197D7942695638C4FA9AC0FC3688C4F9774B905A14E3A3F171BAC586C55E83FF97A1AEFFB3AF00ADB22C6BB,
        Gy=0x08B3F481E3AAA0F1A09E30ED741D8AE4FCF5E095D5D00AF600DB18CB2C04B3EDD03CC744A2888AE40CAA232946C5E7E1,
    ),
    SECP256K1_ID: Curve(
        cairo_zero_namespace_name="secp256k1",
        id=SECP256K1_ID,
        p=0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F,
        n=0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141,
        x=None,
        h=1,
        irreducible_polys={},
        nr_a0=None,
        nr_a1=None,
        a=0,
        b=7,
        b20=None,
        b21=None,
        loop_counter=None,
        line_function_sparsity=None,
        final_exp_cofactor=None,
        fp_generator=3,
        Gx=0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798,
        Gy=0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8,
    ),
    SECP256R1_ID: Curve(
        cairo_zero_namespace_name="secp256r1",
        id=SECP256R1_ID,
        p=0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF,
        n=0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551,
        x=None,
        h=1,
        irreducible_polys={},
        nr_a0=None,
        nr_a1=None,
        a=0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFC,
        b=0x5AC635D8AA3A93E7B3EBBD55769886BC651D06B0CC53B0F63BCE3C3E27D2604B,
        b20=None,
        b21=None,
        loop_counter=None,
        line_function_sparsity=None,
        final_exp_cofactor=None,
        fp_generator=6,
        Gx=0x6B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C296,
        Gy=0x4FE342E2FE1A7F9B8EE7EB4A7C0F9E162BCE33576B315ECECBB6406837BF51F5,
    ),
    X25519_ID: Curve(
        cairo_zero_namespace_name="x25519",
        id=X25519_ID,
        p=0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFED,
        n=0x1000000000000000000000000000000014DEF9DEA2F79CD65812631A5CF5D3ED,
        x=None,
        h=8,
        irreducible_polys={},
        nr_a0=None,
        nr_a1=None,
        a=0x2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA984914A144,  # See https://neuromancer.sk/std/other/Curve25519 for weirstrass form conversion utilities
        b=0x7B425ED097B425ED097B425ED097B425ED097B425ED097B4260B5E9C7710C864,
        b20=None,
        b21=None,
        loop_counter=None,
        line_function_sparsity=None,
        final_exp_cofactor=None,
        fp_generator=6,
        Gx=0,
        Gy=0,
    ),
}


# Convert Montgomery affine point eq (B*y^2 = x^3+A*x^2+x) to Weierstrass affine point (y^2 = x^3 + ax + b) form
def to_weierstrass(A: int, B: int, x: int, y: int, p: int) -> tuple[int, int]:
    return ((x * pow(B, -1, p) + A * pow(3 * B, -1, p)) % p, (y * pow(B, -1, p)) % p)


# Convert from Weierstrass affine point to Montgomery form affine point
def to_montgomery(A: int, B: int, u: int, v: int, p: int) -> tuple[int, int]:
    return (B * (u - A * pow(3 * B, -1, p)) % p, B * v % p)


def is_generator(g: int, p: int) -> bool:
    import sympy

    if sympy.isprime(p) == False:
        raise ValueError("p must be a prime number.")
    p_minus_1 = p - 1
    factors = sympy.factorint(p_minus_1)  # Get prime factors and their exponents
    for q in factors.keys():
        # Check if g^((p-1)/q) % p == 1
        if pow(g, p_minus_1 // q, p) == 1:
            return False
    return True


def get_base_field(curve_id: int) -> BaseField:
    return BaseField(CURVES[curve_id].p)


def get_irreducible_poly(curve_id: int, extension_degree: int) -> Polynomial:
    field = get_base_field(curve_id)
    return Polynomial(
        coefficients=[
            field(x) for x in CURVES[curve_id].irreducible_polys[extension_degree]
        ],
        raw_init=True,
    )


@dataclass(slots=True)
class G1Point:
    """
    Represents a point on G1, the group of rational points on an elliptic curve over the base field.
    """

    x: int
    y: int
    curve_id: CurveID

    def __eq__(self, other: "G1Point") -> bool:
        return (
            self.x == other.x
            and self.y == other.y
            and self.curve_id.value == other.curve_id.value
        )

    def __post_init__(self):
        if not self.is_on_curve():
            raise ValueError(f"Point {self} is not on the curve")

    def is_on_curve(self) -> bool:
        """
        Check if the point is on the curve using the curve equation y^2 = x^3 + ax + b.
        """
        a = CURVES[self.curve_id.value].a
        b = CURVES[self.curve_id.value].b
        p = CURVES[self.curve_id.value].p
        lhs = self.y**2 % p
        rhs = (self.x**3 + a * self.x + b) % p
        return lhs == rhs

    @staticmethod
    def gen_random_point(curve_id: CurveID) -> "G1Point":
        """
        Generates a random point on a given curve.
        """
        scalar = random.randint(1, CURVES[curve_id.value].n - 1)
        if curve_id.value in GNARK_CLI_SUPPORTED_CURVES:
            from tools.gnark_cli import GnarkCLI

            cli = GnarkCLI(curve_id)
            ng1ng2 = cli.nG1nG2_operation(scalar, 1, raw=True)
            return G1Point(ng1ng2[0], ng1ng2[1], curve_id)
        else:
            return G1Point.get_nG(curve_id, scalar)

    @staticmethod
    def get_nG(curve_id: CurveID, n: int) -> "G1Point":
        """
        Returns the scalar multiplication of the generator point on a given curve by the scalar n.
        """
        assert (
            n < CURVES[curve_id.value].n
        ), f"n must be less than the order of the curve"

        if curve_id.value in GNARK_CLI_SUPPORTED_CURVES:
            from tools.gnark_cli import GnarkCLI

            cli = GnarkCLI(curve_id)
            ng1ng2 = cli.nG1nG2_operation(n, 1, raw=True)
            return G1Point(ng1ng2[0], ng1ng2[1], curve_id)
        else:
            gen = G1Point(
                CURVES[curve_id.value].Gx,
                CURVES[curve_id.value].Gy,
                curve_id,
            )
            return gen.scalar_mul(n)

    @staticmethod
    def msm(points: list["G1Point"], scalars: list[int]) -> "G1Point":
        muls = [P.scalar_mul(s) for P, s in zip(points, scalars)]
        scalar_mul = functools.reduce(lambda acc, p: acc.add(p), muls)
        return scalar_mul

    def scalar_mul(self, scalar: int) -> "G1Point":
        res = ec_safe_mult(
            scalar,
            (self.x, self.y),
            CURVES[self.curve_id.value].a,
            CURVES[self.curve_id.value].p,
        )
        if res == EcInfinity:
            return res
        return G1Point(res[0], res[1], self.curve_id)

    def add(self, other: "G1Point") -> "G1Point":
        if self.curve_id != other.curve_id:
            raise ValueError("Points are not on the same curve")
        res = ec_safe_add(
            (self.x, self.y),
            (other.x, other.y),
            CURVES[self.curve_id.value].a,
            CURVES[self.curve_id.value].p,
        )
        if res == EcInfinity:
            return res
        return G1Point(res[0], res[1], self.curve_id)


@dataclass(frozen=True)
class G2Point:
    """
    Represents a point on G2, the group of rational points on an elliptic curve over an extension field.
    """

    x: tuple[int, int]
    y: tuple[int, int]
    curve_id: CurveID

    def __post_init__(self):
        if not self.is_on_curve():
            raise ValueError("Point is not on the curve")

    def is_on_curve(self) -> bool:
        """
        Check if the point is on the curve using the curve equation y^2 = x^3 + ax + b in the extension field.
        """
        from src.hints.tower_backup import E2

        a = CURVES[self.curve_id.value].a

        p = CURVES[self.curve_id.value].p
        b = E2(CURVES[self.curve_id.value].b20, CURVES[self.curve_id.value].b21, p)
        y = E2(*self.y, p)
        x = E2(*self.x, p)
        return y**2 == x**3 + a * x + b


# v^6 - 18v^3 + 82
# w^12 - 18w^6 + 82
# v^6 - 2v^3 + 2
# w^12 - 2w^6 + 2


def get_sparsity(X: list[PyFelt | ModuloCircuitElement]) -> list[int]:
    """
    Determines the sparsity of polynomial coefficients.

    This function evaluates a list of polynomial coefficients (`X`) and categorizes each based on its value:
    - 2: The coefficient is 1, indicating a direct representation of a polynomial power.
    - 1: The coefficient is non-zero but not 1, indicating a contributing non-zero coefficient.
    - 0: The coefficient is 0, indicating no contribution to the polynomial.

    Parameters:
    - X (list[PyFelt | ModuloCircuitElement]): Coefficients to evaluate.

    Returns:
    - list[int]: Sparsity categories for each coefficient in `X`.
    """
    return [2 if x.value == 1 else 1 if x.value != 0 else 0 for x in X]


def tower_to_direct(
    X: list[PyFelt], curve_id: int, extension_degree: int
) -> list[PyFelt]:
    """
    Convert Tower to Direct extension field representation:
    T(u,v) = t0+t1u + (t2+t3u)v + (t4+t5u)v^2
    D(v) = d0+d1v+d2v^2+d3v^3+d4v^4+d5v^5

    Only tested with BN254 and BLS12_381 6th and 12th towers defined in this file.
    They were computed by hand then abstracted away with no guarantee of genericity under different tower constructions.
    """
    assert len(X) == extension_degree and type(X[0]) == PyFelt
    if extension_degree == 2:
        return X
    if extension_degree == 6:
        return TD6(X, curve_id)
    elif extension_degree == 12:
        return TD12(X, curve_id)
    else:
        raise ValueError(f"Unsupported extension degree {extension_degree}")


def direct_to_tower(
    X: list[PyFelt | ModuloCircuitElement], curve_id: int, extension_degree: int
) -> list[PyFelt]:
    """
    Convert Direct to Tower extension field representation:
    Input : D(v) = d0+d1v+d2v^2+d3v^3+d4v^4+d5v^5
    Output: T(u,v) = t0+t1u + (t2+t3u)v + (t4+t5u)v^2

    Only tested with BN254 and BLS12_381 6th and 12th towers defined in this file.
    They were computed by hand then abstracted away with no guarantee of genericity under different tower constructions.
    """
    assert len(X) == extension_degree and isinstance(
        X[0], (PyFelt, ModuloCircuitElement)
    ), f"{type(X[0])}"
    X = [x.felt for x in X]
    if extension_degree == 2:
        return X
    if extension_degree == 6:
        return DT6(X, curve_id)
    elif extension_degree == 12:
        return DT12(X, curve_id)
    else:
        raise ValueError(f"Unsupported extension degree {extension_degree}")


def TD6(X: list[PyFelt], curve_id: int) -> list[PyFelt]:
    nr_a0 = CURVES[curve_id].nr_a0
    return [
        X[0] - nr_a0 * X[1],
        X[2] - nr_a0 * X[3],
        X[4] - nr_a0 * X[5],
        X[1],
        X[3],
        X[5],
    ]


def DT6(X: list[PyFelt], curve_id: int) -> list[PyFelt]:
    nr_a0 = CURVES[curve_id].nr_a0
    return [
        X[0] + nr_a0 * X[3],
        X[3],
        X[1] + nr_a0 * X[4],
        X[4],
        X[2] + nr_a0 * X[5],
        X[5],
    ]


def TD12(X: list[PyFelt], curve_id: int) -> list[PyFelt]:
    nr_a0 = CURVES[curve_id].nr_a0
    return [
        X[0] - nr_a0 * X[1],
        X[6] - nr_a0 * X[7],
        X[2] - nr_a0 * X[3],
        X[8] - nr_a0 * X[9],
        X[4] - nr_a0 * X[5],
        X[10] - nr_a0 * X[11],
        X[1],
        X[7],
        X[3],
        X[9],
        X[5],
        X[11],
    ]


def DT12(X: list[PyFelt], curve_id: int) -> list[PyFelt]:
    X += (12 - len(X)) * [0]
    nr_a0 = CURVES[curve_id].nr_a0
    return [
        X[0] + nr_a0 * X[6],
        X[6],
        X[2] + nr_a0 * X[8],
        X[8],
        X[4] + nr_a0 * X[10],
        X[10],
        X[1] + nr_a0 * X[7],
        X[7],
        X[3] + nr_a0 * X[9],
        X[9],
        X[5] + nr_a0 * X[11],
        X[11],
    ]


def get_p_powers_of_V(curve_id: int, extension_degree: int, k: int) -> list[Polynomial]:
    """
    Computes V^(i*p^k) for i in range(extension_degree), where V is the polynomial V(X) = X.

    Args:
        curve_id (int): Identifier for the curve.
        extension_degree (int): Degree of the field extension.
        k (int): Exponent in p^k, must be 1, 2, or 3.

    Returns:
        list[Polynomial]: List of polynomials representing V^(i*p^k) for i in range(extension_degree).
    """
    assert k in [1, 2, 3], f"Supported k values are 1, 2, 3. Received: {k}"

    field = BaseField(CURVES[curve_id].p)
    irr = get_irreducible_poly(curve_id, extension_degree)

    V = Polynomial(
        [field.zero() if i != 1 else field.one() for i in range(extension_degree)]
    )

    V_pow = [V.pow(i * field.p**k, irr) for i in range(extension_degree)]

    return V_pow


def get_V_torus_powers(curve_id: int, extension_degree: int, k: int) -> Polynomial:
    """
    Computes 1/V^((p^k - 1) // 2) where V is the polynomial V(X) = X.
    This is used to compute the Frobenius automorphism in the Torus.

    Args:
        curve_id (int): Identifier for the curve.
        extension_degree (int): Degree of the field extension.
        k (int): Exponent in p^k, must be 1, 2, or 3.

    Returns:
        list[Polynomial]: List of polynomials representing V^(i*p^k) for i in range(extension_degree).
    """
    assert k in [1, 2, 3], f"Supported k values are 1, 2, 3. Received: {k}"

    field = BaseField(CURVES[curve_id].p)
    irr = get_irreducible_poly(curve_id, extension_degree)

    V = Polynomial(
        [field.zero() if i != 1 else field.one() for i in range(extension_degree)]
    )

    V_pow = V.pow((field.p**k - 1) // 2, irr)
    inverse, _, _ = Polynomial.xgcd(V_pow, irr)
    return inverse


def frobenius(
    F: list[PyFelt], V_pow: list[Polynomial], p: int, frob_power: int, irr: Polynomial
) -> Polynomial:
    """
    Applies the Frobenius automorphism to a polynomial in a direct extension field.

    Args:
        F (list[PyFelt]): Coefficients of the polynomial.
        V_pow (list[Polynomial]): Precomputed powers of V.
        p (int): Prime number of the base field.
        frob_power (int): Power of the Frobenius automorphism.
        irr (Polynomial): Irreducible polynomial for the field extension.

    Returns:
        Polynomial: Result of applying Frobenius automorphism.
    """
    assert len(F) == len(V_pow), "Mismatch in lengths of F and V_pow."
    acc = Polynomial([PyFelt(0, p)])
    for i, f in enumerate(F):
        acc += f * V_pow[i]
    assert acc == (
        Polynomial(F).pow(p**frob_power, irr)
    ), "Mismatch in expected result."
    return acc


def generate_frobenius_maps(
    curve_id, extension_degree: int, frob_power: int
) -> tuple[list[str], list[list[tuple[int, int]]]]:
    """
    Generates symbolic expressions for Frobenius map coefficients and a list of tuples with constants.

    Args:
        curve_id (CurveID): Identifier for the curve.
        extension_degree (int): Degree of the field extension.
        frob_power (int): Power of the Frobenius automorphism.

    Returns:
        tuple[list[str], list[list[tuple[int, int]]]]: Symbolic expressions for each coefficient and a list of tuples with constants.
    """
    curve_id = curve_id if type(curve_id) == int else curve_id.value
    V_pow = get_p_powers_of_V(curve_id, extension_degree, frob_power)

    k_expressions = ["" for _ in range(extension_degree)]
    constants_list = [[] for _ in range(extension_degree)]
    for i in range(extension_degree):
        for f_index, poly in enumerate(V_pow):
            if poly[i] != 0:
                hex_value = f"0x{poly[i]:x}"
                compact_hex = (
                    f"{hex_value[:6]}...{hex_value[-4:]}"
                    if len(hex_value) > 10
                    else hex_value
                )
                k_expressions[i] += f" + {compact_hex} * f_{f_index}"
                constants_list[i].append((f_index, poly[i]))
    return k_expressions, constants_list


def precompute_lineline_sparsity(curve_id: int):
    field = get_base_field(curve_id)
    line_sparsity = CURVES[curve_id].line_function_sparsity
    line = Polynomial([field(x) for x in line_sparsity])
    ll = line * line % get_irreducible_poly(curve_id, 12)
    ll_sparsity = get_sparsity(ll.coefficients)
    return ll_sparsity[0:12]


if __name__ == "__main__":
    from tools.extension_trick import v_to_gnark, gnark_to_v, w_to_gnark, gnark_to_w
    from random import randint

    g1 = G1Point.gen_random_point(CurveID.BLS12_381)
    g2 = G1Point.gen_random_point(CurveID.BN254)
    g3 = G1Point.gen_random_point(CurveID.SECP256K1)
    g4 = G1Point.gen_random_point(CurveID.SECP256R1)

    field = get_base_field(BN254_ID)
    x12i = [randint(0, CURVES[BN254_ID].p) for _ in range(12)]
    x12f = [PyFelt(x, CURVES[BN254_ID].p) for x in x12i]

    # DT = direct_to_tower(x12, BN254_ID, 12)
    # assert w_to_gnark

    TD1 = tower_to_direct(x12f, BN254_ID, 12)
    TD2 = gnark_to_w(x12i)
    assert TD1 == TD2

    TD1 = tower_to_direct(x12f[:6], BN254_ID, 6)
    TD2 = gnark_to_v(x12i)

    print(TD1 == TD2)
    print([x == y for x, y in zip(TD1, TD2)])

    XD = [11, 22, 33, 44, 55, 66, 77, 88, 99, 100, 111, 122]
    XD = [field(x) for x in XD]
    XT = direct_to_tower(XD, BN254_ID, 12)
    XT0, XT1 = XT[0:6], XT[6:]
    XD0 = tower_to_direct(XT0, BN254_ID, 6)
    XD1 = tower_to_direct(XT1, BN254_ID, 6)

    print(f"XD = {[x.value for x in XD]}")
    print(f"XT = {[x.value for x in XT]}")
    print(f"XT0 = {[x.value for x in XT0]}")
    print(f"XT1 = {[x.value for x in XT1]}")
    print(f"XD0 = {[x.value for x in XD0]}")
    print(f"XD1 = {[x.value for x in XD1]}")

    # Frobenius maps
    def test_frobenius_maps():
        constants_lists = {}
        for extension_degree in [6, 12]:
            for curve_id in [CurveID.BN254, CurveID.BLS12_381]:
                if curve_id.name not in constants_lists:
                    constants_lists[curve_id.name] = {}
                if extension_degree not in constants_lists[curve_id.name]:
                    constants_lists[curve_id.name][extension_degree] = {}
                p = CURVES[curve_id.value].p
                for frob_power in [1, 2, 3]:
                    print(
                        f"\nFrobenius^{frob_power} for {curve_id.name} Fp{extension_degree}"
                    )
                    irr = get_irreducible_poly(curve_id.value, extension_degree)

                    V_pow = get_p_powers_of_V(
                        curve_id.value, extension_degree, frob_power
                    )
                    print(
                        f"Torus Inv: {get_V_torus_powers(curve_id.value, extension_degree, frob_power).get_value_coeffs()}"
                    )
                    F = [PyFelt(randint(0, p - 1), p) for _ in range(extension_degree)]
                    acc = frobenius(F, V_pow, p, frob_power, irr)

                    k_expressions, constants_list = generate_frobenius_maps(
                        curve_id, extension_degree, frob_power
                    )
                    print(
                        f"f = f0 + f1v + ... + f{extension_degree-1}v^{extension_degree-1}"
                    )
                    print(
                        f"Frob(f) = f^p = f0 + f1v^(p^{frob_power}) + f2v^(2p^{frob_power}) + ... + f{extension_degree-1}*v^(({extension_degree-1})p^{frob_power})"
                    )
                    print(
                        f"Frob(f) = k0 + k1v + ... + k{extension_degree-1}v^{extension_degree-1}"
                    )
                    for i, expr in enumerate(k_expressions):
                        print(f"k_{i} = {expr}")
                        print(f"Constants: {constants_list[i]}")
                    constants_lists[curve_id.name][extension_degree][
                        frob_power
                    ] = constants_list
        return constants_lists

    # frobs = test_frobenius_maps()

    print(precompute_lineline_sparsity(CurveID.BN254.value))
    print(precompute_lineline_sparsity(CurveID.BLS12_381.value))

    # p = G1Point.gen_random_point(CurveID.BN254)
    # print(p)
    # from src.hints.io import bigint_split

    # print(bigint_split(p.x, 4, 2**96))
    # print(bigint_split(p.y, 4, 2**96))

    from tests.benchmarks import test_msm_n_points

    test_msm_n_points(CurveID.BLS12_381, 1)
