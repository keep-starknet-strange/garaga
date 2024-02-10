from src.algebra import Polynomial
from src.algebra import BaseField, PyFelt, ModuloCircuitElement
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
    irreducible_polys: dict[int, list[int]]
    nr_a0: int
    nr_a1: int


CURVES = {
    BN254_ID: Curve(
        id=BN254_ID,
        p=0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47,
        irreducible_polys={
            6: [82, 0, 0, -18, 0, 0, 1],
            12: [82, 0, 0, 0, 0, 0, -18, 0, 0, 0, 0, 0, 1],
        },
        nr_a0=9,
        nr_a1=1,
    ),
    BLS12_381_ID: Curve(
        id=BLS12_381_ID,
        p=0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAB,
        irreducible_polys={
            6: [2, 0, 0, -2, 0, 0, 1],
            12: [2, 0, 0, 0, 0, 0, -2, 0, 0, 0, 0, 0, 1],
        },
        nr_a0=1,
        nr_a1=1,
    ),
}


def get_base_field(curve_id: int) -> BaseField:
    return BaseField(CURVES[curve_id].p)


def get_irreducible_poly(curve_id: int, extension_degree: int) -> Polynomial:
    field = BaseField(CURVES[curve_id].p)
    return Polynomial(
        coefficients=[
            field(x) for x in CURVES[curve_id].irreducible_polys[extension_degree]
        ],
        raw_init=True,
    )


# v^6 - 18v^3 + 82
# w^12 - 18w^6 + 82
# v^6 - 2v^3 + 2
# w^12 - 2w^6 + 2


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


if __name__ == "__main__":
    from tools.extension_trick import v_to_gnark, gnark_to_v, w_to_gnark, gnark_to_w
    from random import randint

    x12i = [randint(0, CURVES[BN254_ID].p) for _ in range(12)]
    x12f = [PyFelt(x, CURVES[BN254_ID].p) for x in x12i]

    # DT = direct_to_tower(x12, BN254_ID, 12)
    # assert w_to_gnark

    TD1 = tower_to_direct(x12f, BN254_ID, 12)
    TD2 = gnark_to_w(x12i)
    assert TD1 == TD2

    TD1 = tower_to_direct(x12f[:6], BN254_ID, 6)
    TD2 = gnark_to_v(x12i)

    print(f"TD1: {TD1}")
    print(f"TD2: {TD2}")
    print(TD1 == TD2)
    print([x == y for x, y in zip(TD1, TD2)])
