from src.algebra import Polynomial, BaseField, PyFelt, ModuloCircuitElement
from dataclasses import dataclass
from enum import Enum

N_LIMBS = 4
BASE = 2**96
STARK = 0x800000000000011000000000000000000000000000000000000000000000001
BN254_ID = int.from_bytes(b"bn254", "big")
BLS12_381_ID = int.from_bytes(b"bls12_381", "big")


class CurveID(Enum):
    BN254 = int.from_bytes(b"bn254", "big")
    BLS12_381 = int.from_bytes(b"bls12_381", "big")


@dataclass(slots=True, frozen=True)
class Curve:
    id: int
    p: int
    n: int  # order
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


def NAF(x):
    if x == 0:
        return []
    z = 0 if x % 2 == 0 else 2 - (x % 4)
    return NAF((x - z) // 2) + [z]


CURVES = {
    BN254_ID: Curve(
        id=BN254_ID,
        p=0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47,
        n=0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593F0000001,
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
    ),
    BLS12_381_ID: Curve(
        id=BLS12_381_ID,
        p=0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAB,
        n=0x73EDA753299D7D483339D80809A1D80553BDA402FFFE5BFEFFFFFFFF00000001,
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
    ),
}


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


@dataclass(frozen=True)
class G1Point:
    """
    Represents a point on G1, the group of rational points on an elliptic curve over the base field.
    """

    x: int
    y: int
    curve_id: CurveID

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
