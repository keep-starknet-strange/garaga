from math import gcd

from hydra.definitions import CURVES, CurveID
from hydra.hints.tower_backup import E12

# Bls

x = CURVES[CurveID.BLS12_381.value].x
k = 12
r = x**4 - x**2 + 1
q = ((x - 1) ** 2) // 3 * r + x
h = (q**k - 1) // r

lam = -x + q
m = lam // r

p = 5044125407647214251
h3 = h // (27 * p)
assert h % (27 * p) == 0
assert m == 3 * p**2

assert gcd(3, h3) == 1
assert gcd(p**2, h3) == 1
assert gcd(3, h3) == 1
assert gcd(p, h3) == 1
assert gcd(p, 27 * h3) == 1
assert gcd(27, p * h3) == 1

ONE = E12.one(curve_id=1)

assert (q**3 - 1) % 27 == 0


def is_pth_residue(x: E12) -> bool:
    return x ** (h3 * 27) == ONE


def get_pth_root_inverse(x: E12) -> E12:
    if is_pth_residue(x):
        return ONE

    v = 27 * h3
    wj = x**v

    v_inv = pow(v, -1, p)
    s = (-1 * v_inv) % p

    return wj**s


def get_order_of_3rd_primitive_root(x: E12) -> int:
    # correct way is do do r * p * h3 but outputs of equal Tate pairings are always of the form c^r thus there is no rth root contribution
    y = x ** (p * h3)

    if y == ONE:
        return 0

    y3 = y**3
    if y3 == ONE:
        return 1

    y9 = y3**3
    if y9 == ONE:
        return 2

    y27 = y9**3
    if y27 == ONE:
        return 3

    else:
        raise ValueError("")


def get_any_27th_root_inverse(x: E12) -> E12:
    pw = get_order_of_3rd_primitive_root(x)

    if pw == 0:
        return ONE

    _ord = 3**pw

    v = p * h3
    wj = x**v

    v_inv = pow(v, -1, _ord)
    s = (-1 * v_inv) % _ord

    return wj**s


def h3_ord_element_lambda_root(x: E12) -> E12:
    # after applying shifts we know that element is order just h3

    e = pow(lam, -1, h3)
    return x**e


# assumes it's already of the form x^r
def get_root_and_scaling_factor_bls(x: E12) -> tuple[E12, E12]:
    assert x**h == ONE  # assert that x = f^r for some f
    wp_shift = get_pth_root_inverse(x)
    w27_shift = get_any_27th_root_inverse(x)

    w_full = wp_shift * w27_shift
    x_shifted = x * w_full
    root = h3_ord_element_lambda_root(x_shifted)

    return (root, w_full)


if __name__ == "__main__":
    import random

    from hydra.hints.multi_miller_witness import get_miller_loop_output

    random.seed(0)
    for i in range(5):
        f = get_miller_loop_output(curve_id=CurveID.BLS12_381, will_be_one=True)
        root, w_full = get_root_and_scaling_factor_bls(f)
        assert f * w_full == root**lam
        print(f"{i} Will be one check ok")

        f = get_miller_loop_output(curve_id=CurveID.BLS12_381, will_be_one=False)

        try:
            root, w_full = get_root_and_scaling_factor_bls(f)
            assert f * w_full == root**lam
        except (ValueError, AssertionError):
            print(f"{i} No nth root -- Ok")
        else:
            raise ValueError("Non-one case should not pass")
