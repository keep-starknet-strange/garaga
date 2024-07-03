from sympy.core.numbers import igcdex as xgcd
import sympy
from hydra.hints.tower_backup import E12
from hydra.definitions import CURVES, get_base_field, get_irreducible_poly, CurveID
from hydra.algebra import Polynomial
from sympy.ntheory.modular import solve_congruence
from math import lcm, gcd
import math


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
assert gcd(p ^ 2, h3) == 1
assert gcd(3, h3) == 1
assert gcd(p, h3) == 1
assert gcd(p, 27 * h3) == 1
assert gcd(27, p * h3) == 1

ONE = E12.one(curve_id=1)

assert (q**3 - 1) % 27 == 0


class NoNthRoot(Exception):
    pass


def find_nth_root(elmt: E12, n: int) -> E12:
    """
    ref : https://github.com/sagemath/sage/blob/31e216689afea5bc4e0daaee0122c546f42d1da5/src/sage/rings/finite_rings/element_base.pyx#L53
    """
    q = elmt.order
    gcdd = gcd(n, q - 1)
    if elmt == E12.one(elmt.curve_id):
        if gcdd == 1:
            return elmt
        else:
            root = zeta_e12(elmt.curve_id, n)
            return root
    if gcdd == q - 1:
        raise NoNthRoot("No nth root")

    alpha, _, gcdd = xgcd(n, q - 1)
    if gcdd == 1:
        return elmt**alpha

    n = gcdd
    q1overN = (q - 1) // n

    if elmt**q1overN != E12.one(elmt.curve_id):
        raise NoNthRoot("No nth root")

    elmt = elmt**alpha
    F = sympy.factorint(n)
    for r, v in F.items():
        k, h = val_unit(q - 1, r)
        hinv = pow(-h, -1, r**v)
        z = h * hinv
        x = (1 + z) // (r**v)
        if k == v:
            elmt = elmt**x

        else:
            # We need an element of order r^k (g^h in Johnston's article)
            # self^x differs from the actual nth root by an element of
            # order dividing r^(k-v)
            gh = zeta_e12(elmt.curve_id, r**k)
            t = discrete_log_e12(a=elmt**h, base=gh ** (r**v), order=r ** (k - v))
            elmt = elmt**x * gh ** (-hinv * t)

    return elmt


def discrete_log_e12(a: E12, base: E12, order: int) -> int:
    """
    Returns an integer `n` such that `b^n = a`,
    assuming that ``ord`` is a multiple of the order of the base `b`.
    ref : https://github.com/sagemath/sagelib/blob/fd0c7c46e6a2da4b84df582e0da0333ce5cf79d9/sage/groups/generic.py#L655
    """
    if order == 1 and a != base:
        raise ValueError
    f = sympy.factorint(order)
    l = [0] * len(f)
    for i, (pi, ri) in enumerate(f.items()):
        for j in range(ri):
            c = bsgs_e12(
                base ** (order // pi),
                ((a * (base ** l[i]).__inv__()) ** (order // (pi ** (j + 1)))),
                (0, pi),
            )
            l[i] += c * (pi**j)

    return crt_list(l, [pi**ri for pi, ri in f.items()])


def crt_list(v: list[int], moduli: list[int]) -> int:
    """
    Given a list `v` of elements and a list of corresponding `moduli`,
    find a single element that reduces to each element of `v` modulo
    the corresponding moduli.
    ref : https://github.com/sagemath/sagelib/blob/fd0c7c46e6a2da4b84df582e0da0333ce5cf79d9/sage/rings/arith.py#L2818
    """
    if not isinstance(v, list) or not isinstance(moduli, list):
        raise ValueError("Arguments to CRT_list should be lists")
    if len(v) != len(moduli):
        raise ValueError("Arguments to CRT_list should be lists of the same length")
    if len(v) == 0:
        return 0
    if len(v) == 1:
        return v[0] % moduli[0]

    try:
        result = solve_congruence(*list(zip(v, moduli)))
        if result is None:
            raise ValueError("No solution exists")
        x, m = result
        return x % m
    except ValueError as e:
        raise ValueError(f"No solution to crt problem: {str(e)}")


def bsgs_e12(a: E12, b: E12, bounds: tuple[int, int]) -> int:
    """
    discrete baby-step giant-step function for E12 elements

    Solves a^n=b with lb <= n <= ub,
    raising an error if no such n exists.
    ref : https://github.com/sagemath/sagelib/blob/fd0c7c46e6a2da4b84df582e0da0333ce5cf79d9/sage/groups/generic.py#L357
    """
    identity = E12.one(a.curve_id)
    zero = E12.zero(a.curve_id)
    lb, ub = bounds
    if lb < 0 or ub < lb:
        raise ValueError
    if a == zero and not b == zero:
        raise ValueError
    ran = 1 + ub - lb
    c = b.__inv__() * a**lb
    m = math.isqrt(ran) + 1
    table = dict()

    d = c
    for i0 in range(m):
        i = lb + i0
        if d == identity:
            return i
        table[d] = i
        d = d * a

    c = c * d.__inv__()
    d = identity

    for i in range(m):
        j = table.get(d)
        if j is not None:
            return i * m + j
        d = c * d

    raise ValueError


def val_unit(n: int, p: int) -> tuple[int, int]:
    """
    Return a pair: the p-adic valuation of `n`, and the p-adic unit of `n`.

    We do not require that p be prime, but it must be at least 2.

    :param n: The integer to compute the p-adic valuation and unit for.
    :param p: The base for the p-adic valuation.
    :return: A tuple (v, u) where v is the p-adic valuation and u is the p-adic unit.
    """
    if p < 2:
        raise ValueError(
            "You can only compute the valuation with respect to an integer larger than 1."
        )
    if n == 0:
        return (float("inf"), 1)

    v = 0
    while n % p == 0:
        n //= p
        v += 1

    u = n
    return (v, u)


def zeta_e12(curve_id: int, n: int) -> E12:
    """
    Return an element of multiplicative order n in E12 field of a given curve.
    If there is no such element, raise ValueError.
    ref : https://github.com/sagemath/sage/blob/31e216689afea5bc4e0daaee0122c546f42d1da5/src/sage/rings/finite_rings/finite_field_base.pyx#L677
    """
    group_order = CURVES[curve_id].p ** 12 - 1
    co_order = group_order // n
    if co_order * n != group_order:
        raise NoNthRoot("No nth root")
    return element_of_factored_order(curve_id, sympy.factorint(n))


def element_of_factored_order(curve_id: int, factors: dict[int, int]):
    """
    Return an element of ``self`` of order ``n`` where ``n`` is
    given in factored form.

    INPUT:

    - factors -- the factorization of the required order. The order
      must be a divisor of ``self.order() - 1`` but this is not
      checked.
    ref : https://github.com/sagemath/sage/blob/31e216689afea5bc4e0daaee0122c546f42d1da5/src/sage/rings/finite_rings/finite_field_base.pyx#L790
    """
    n = 1
    primes = []
    for p, e in factors.items():
        primes.append(p)
        n *= p**e

    field = get_base_field(curve_id)
    N = field.p**12 - 1
    c = N // n

    g = E12.from_poly(
        Polynomial(
            [
                field(0),
                field(1),
                field(0),
                field(0),
                field(0),
                field(0),
                field(0),
                field(0),
                field(0),
                field(0),
                field(0),
                field(0),
            ]
        ),
        curve_id,
    )

    for x in range(field.p):
        # Only try (g+(constant))^c.
        x = field(x)
        g_coeffs = g.felt_coeffs
        g_plus_x_coeffs = [g_coeffs[0] + x] + g_coeffs[1:]
        g_plus_x = E12(g_plus_x_coeffs, curve_id)
        a = g_plus_x**c
        if all(a ** (n // p) != E12.one(curve_id) for p in primes):
            return a
    raise Exception("No element of order {n} found in E12")


def has_27th_root_contribution(x):
    # checks if x has a 27th root of unity contribution
    try:
        find_nth_root(x, 3)
        # print(f"No 27th root contribution")
        return False
    except NoNthRoot:
        # print(f"27th root contribution")
        return True
    else:
        raise NotImplementedError


def has_pth_root_contribution(x):
    # checks if x has a pth root of unity contribution
    try:
        c = find_nth_root(x, p)
        # print(f"No pth root contribution : {c.print_as_sage_poly()}")
        return False
    except NoNthRoot as e:
        # print(f"{e}")
        # print(f"pth root contribution")
        return True
    else:
        raise NotImplementedError


def clear_pth_root(x: E12):
    check = has_pth_root_contribution(x)
    # print(f"check : {check}")
    if not check:
        # print(f"No pth root contribution")
        return ONE
    v = 27 * h3
    wj = x**v
    v_inv = pow(v, -1, p)
    s = (-1 * v_inv) % p
    return wj**s


def clear_27th_root_factor(x):
    if not has_27th_root_contribution(x):
        return ONE
    v = p * h3
    wj = x**v
    v_inv = pow(v, -1, 27)
    s = (-1 * v_inv) % 27
    return wj**s


def get_root_and_scaling_factor_bls(f: E12) -> tuple[E12, E12]:
    wp_shift = clear_pth_root(f)
    w27_shift = clear_27th_root_factor(f)
    w_full = wp_shift * w27_shift
    f_shifted = f * w_full
    root = find_nth_root(f_shifted, lam)
    return root, w_full


if __name__ == "__main__":
    variable = "z"
    from hydra.hints.multi_miller_witness import get_miller_loop_output

    w27 = find_nth_root(elmt=ONE, n=27)
    wp = find_nth_root(elmt=ONE, n=p)
    assert wp**p == ONE
    assert w27**27 == ONE
    assert w27**9 != ONE

    import random

    random.seed(0)
    for i in range(5):
        f = get_miller_loop_output(curve_id=CurveID.BLS12_381, will_be_one=True)
        wp_shift = clear_pth_root(f)
        w27_shift = clear_27th_root_factor(f)
        w_full = wp_shift * w27_shift
        non_zero_indexes = [
            index for index, value in enumerate(w_full.value_coeffs) if value != 0
        ]
        # print(f"w_full non zero coeffs indexes (Fq12 Tower) : {non_zero_indexes}")
        f_shifted = f * w_full
        root = find_nth_root(f_shifted, lam)
        assert f_shifted == root**lam
        print(f"{i} Will be one check ok")

        f = get_miller_loop_output(curve_id=CurveID.BLS12_381, will_be_one=False)
        wp_shift = clear_pth_root(f)
        w27_shift = clear_27th_root_factor(f)
        f_shifted = f * wp_shift * w27_shift

        try:
            root = find_nth_root(f_shifted, lam)
            assert f_shifted == root**lam
        except NoNthRoot:
            print(f"{i} No nth root -- Ok")
        else:
            raise ValueError("Non-one case should not pass")
