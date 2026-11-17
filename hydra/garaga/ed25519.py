"""Ed25519 subgroup tests from Divide-and-Pair (ePrint 2026/749).

The field has p = 5 mod 8. One rational halving therefore precedes the
quartic Tate test. Small-order rejection is a separate signature policy.
"""

from garaga.curves import CURVES, CurveID

CURVE = CURVES[CurveID.ED25519.value]
P = CURVE.p
D = CURVE.d_twisted
I = pow(2, (P - 1) // 4, P)
A = 2 * (-1 + D) % P
B = (-1 - D) ** 2 % P
A_PRIME = -2 * A % P
B_PRIME = (A * A - 4 * B) % P


def sqrt(value: int) -> int | None:
    """Return one square root, or None for a nonresidue."""
    value %= P
    root = pow(value, (P + 3) // 8, P)
    if root * root % P != value:
        root = root * I % P
    return root if root * root % P == value else None


SQRT_2_B_PRIME = sqrt(2 * B_PRIME)
assert SQRT_2_B_PRIME is not None
SQRT_TWO_I = sqrt(2 * I)
assert SQRT_TWO_I is not None


def sqrt_or_twice(value: int) -> tuple[bool, int]:
    """Return sqrt(value) or sqrt(2*value), with one fixed exponentiation."""
    value %= P
    root = pow(value, (P + 3) // 8, P)
    square = root * root % P
    if square == value:
        return True, root
    if square == -value % P:
        return True, root * I % P
    if square == I * value % P:
        return False, root * SQRT_TWO_I * I % P
    assert square == -I * value % P
    return False, root * SQRT_TWO_I % P


def is_on_curve(x: int, y: int) -> bool:
    return (y * y - x * x - 1 - D * x * x * y * y) % P == 0


def is_small_order(x: int, y: int) -> bool:
    """Test [8]P = O for an on-curve point in Edwards coordinates."""
    return x * y * (x * x + y * y) % P == 0


def is_in_prime_order_subgroup(x: int, y: int) -> bool:
    """Test [ell]P = O with one halving and a quartic residue symbol.

    Inputs are Edwards coordinates. The identity is accepted. Every other
    small-order point and every nonzero torsion coset is rejected.
    """
    x, y = x % P, y % P
    if not is_on_curve(x, y):
        return False
    if is_small_order(x, y):
        return x == 0 and y == 1

    e = x * (1 - y) % P
    u = (-1 - D) * (1 + y) * x * e % P
    w = 2 * (1 - y) % P

    # Invert the degree-two isogenies without field inversions.
    wp = sqrt(4 * u)
    if wp is None:
        return False
    up = (4 * u - A_PRIME * e * e - 2 * wp * w) * pow(2, -1, P) % P
    is_square, root = sqrt_or_twice(up)
    negative = False
    if is_square:
        w = root
    else:
        wp = wp * root % P
        w = SQRT_2_B_PRIME * e * e % P
        e = e * root % P
        negative = True

    u = (w * w - A * e * e - w * wp) * pow(2, -1, P) % P
    # The final sign of w matters in the quartic Miller value.
    if negative:
        w = -w % P
    f = u * (w + 2 * I * e) ** 2 % P
    return f != 0 and pow(f, (P - 1) // 4, P) == 1
