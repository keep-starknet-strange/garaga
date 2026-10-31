"""Independent complete Edwards arithmetic for subgroup regression vectors."""

from functools import cache

from garaga.algebra import PyFelt
from garaga.curves import CURVES, CurveID
from garaga.points import G1Point

CURVE = CURVES[4]
P, D, ELL = CURVE.p, CURVE.d_twisted, CURVE.n
IDENTITY = (0, 1)


def add(left, right):
    x, y = left
    u, v = right
    product = D * x * y * u * v % P
    return (
        (x * v + y * u) * pow(1 + product, -1, P) % P,
        (y * v + x * u) * pow(1 - product, -1, P) % P,
    )


def multiply(point, scalar):
    result = IDENTITY
    while scalar:
        if scalar & 1:
            result = add(result, point)
        point = add(point, point)
        scalar >>= 1
    return result


@cache
def torsion_generator():
    for y in range(2, 100):
        x_sq = (y * y - 1) * pow(D * y * y + 1, -1, P) % P
        try:
            x = PyFelt(x_sq, P).sqrt().value
        except ValueError:
            continue
        torsion = multiply((x, y), ELL)
        if multiply(torsion, 4) != IDENTITY:
            assert multiply(torsion, 8) == IDENTITY
            return torsion
    raise AssertionError("No rational order-eight generator found")


def weierstrass(point):
    x, y = point
    if point == IDENTITY:
        return G1Point.infinity(CurveID.ED25519)
    if x == 0:
        return G1Point((-1 + D) * pow(6, -1, P) % P, 0, CurveID.ED25519)
    return G1Point(*CURVE.to_weierstrass(x, y), CurveID.ED25519)


@cache
def vectors():
    base = CURVE.to_twistededwards(CURVE.Gx, CURVE.Gy)
    torsion = torsion_generator()
    result = []
    for scalar in [0, 1, 2, 17, ELL - 1, (1 << 200) + 3]:
        prime = multiply(base, scalar)
        for coset in range(8):
            point = add(prime, multiply(torsion, coset))
            result.append((scalar, coset, point))
    return result
