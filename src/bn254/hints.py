from gmpy2 import mpz
import gmpy2
from gmpy2 import f_divmod, f_div, f_mod, f_divmod_2exp
from typing import List

p = mpz(21888242871839275222246405745257275088696311157297823662689037894645226208583)
base_bits = mpz(86)
base = mpz(2**86)
degree = mpz(2)
p_limbs = [
    mpz(60193888514187762220203335),
    mpz(27625954992973055882053025),
    mpz(3656382694611191768777988),
]


def reduce_hint(val_limbs: List[int]) -> (List[int], List[int]):
    val_limbs = [mpz(x) for x in val_limbs]
    val = sum([x * base**i for i, x in enumerate(val_limbs)])
    q, r = f_divmod(val, p)
    q_limbs = split_mpz(q)
    r_limbs = split_mpz(r)

    q_P_plus_r_limbs = poly_mul_plus_c(q_limbs, p_limbs, r_limbs)
    diff_limbs = poly_sub(q_P_plus_r_limbs, val_limbs)
    _, carries = reduce_zero_poly(diff_limbs)
    carries = abs_poly(carries)
    flags = [1 if diff_limbs[i] >= 0 else 0 for i in range(len(diff_limbs) - 1)]
    return (
        [int(x) for x in q_limbs],
        [int(x) for x in r_limbs],
        flags,
        [int(x) for x in carries],
    )


def reduce3_hint(val_limbs: List[int]) -> (List[int], List[int]):
    val_limbs = [mpz(x) for x in val_limbs]
    val = sum([x * base**i for i, x in enumerate(val_limbs)])
    q, r = f_divmod(val, p)
    r_limbs = split_mpz(r)

    q_P_plus_r_limbs = [q * P + r_limbs[i] for i, P in enumerate(p_limbs)]
    diff_limbs = poly_sub(q_P_plus_r_limbs, val_limbs)
    _, carries = reduce_zero_poly(diff_limbs)
    carries = abs_poly(carries)
    flags = [1 if diff_limbs[i] >= 0 else 0 for i in range(len(diff_limbs) - 1)]
    return (
        int(q),
        [int(x) for x in r_limbs],
        flags,
        [int(x) for x in carries],
    )


def split(x) -> List[int]:
    coeffs = []
    for n in range(degree, 0, -1):
        q, r = f_divmod_2exp(x, n * base_bits)  # divmod(x, gmpy2.pow(base, n))
        coeffs.append(q)
        x = r
    coeffs.append(x)
    return [int(x) for x in coeffs[::-1]]


def split_mpz(x: mpz) -> List[mpz]:
    coeffs = []
    for n in range(degree, 0, -1):
        q, r = f_divmod_2exp(x, n * base_bits)  # divmod(x, gmpy2.pow(base, n))
        coeffs.append(q)
        x = r
    coeffs.append(x)
    return coeffs[::-1]


def poly_mul(a: list, b: list) -> list:
    n = len(a)
    assert n == len(b)
    result = [mpz(0)] * (2 * n - 1)
    for i in range(n):
        for j in range(n):
            result[i + j] += a[i] * b[j]
    return result


def poly_mul_plus_c(a: list, b: list, c: list) -> list:
    n = len(a)
    assert n == len(b) == len(c)
    result = [mpz(0)] * (2 * n - 1)
    for i in range(n):
        for j in range(n):
            result[i + j] += a[i] * b[j]
    for i in range(n):
        result[i] += c[i]
    return result


def poly_sub(a: list, b: list) -> list:
    n = len(a)
    assert n == len(b)
    result = []
    for i in range(n):
        result.append(a[i] - b[i])
    return result


def abs_poly(x: list):
    n = len(x)
    result = []
    for i in range(n):
        result.append(abs(x[i]))
    return result


def reduce_zero_poly(x: list):
    x = x.copy()
    carries = []
    for i in range(0, len(x) - 1):
        carries.append(x[i] // base)  # f_div(x[i], base)
        x[i] = x[i] % base  # f_mod(x[i], base)  #
        assert x[i] == mpz(0), f"reduce_zero_poly failed: {x[i]}"
        x[i + 1] += carries[i]
    assert x[-1] == 0
    return x, carries


def mul_e2(x: (mpz, mpz), y: (mpz, mpz)):
    a = (x[0] + x[1]) * (y[0] + y[1]) % p
    b, c = x[0] * y[0] % p, x[1] * y[1] % p
    return (b - c) % p, (a - b - c) % p


def square_e2(x: (mpz, mpz)):
    return mul_e2(x, x)


def double_e2(x: (mpz, mpz)):
    return 2 * x[0] % p, 2 * x[1] % p


def sub_e2(x: (mpz, mpz), y: (mpz, mpz)):
    return (x[0] - y[0]) % p, (x[1] - y[1]) % p


def neg_e2(x: (mpz, mpz)):
    return -x[0] % p, -x[1] % p


def mul_by_non_residue_e2(x: (mpz, mpz)):
    return mul_e2(x, (mpz(9), mpz(1)))


def add_e2(x: (mpz, mpz), y: (mpz, mpz)):
    return (x[0] + y[0]) % p, (x[1] + y[1]) % p


def inv_e2(a: (mpz, mpz)):
    t0, t1 = (a[0] * a[0] % p, a[1] * a[1] % p)
    t0 = (t0 + t1) % p
    t1 = pow(t0, -1, p)
    return a[0] * t1 % p, -(a[1] * t1) % p


def add_e6(
    x: ((mpz, mpz), (mpz, mpz), (mpz, mpz)), y: ((mpz, mpz), (mpz, mpz), (mpz, mpz))
):
    return (add_e2(x[0], y[0]), add_e2(x[1], y[1]), add_e2(x[2], y[2]))


def inv_e6(x: ((mpz, mpz), (mpz, mpz), (mpz, mpz))):
    t0, t1, t2 = square_e2(x[0]), square_e2(x[1]), square_e2(x[2])
    t3, t4, t5 = mul_e2(x[0], x[1]), mul_e2(x[0], x[2]), mul_e2(x[1], x[2])
    c0 = add_e2(neg_e2(mul_by_non_residue_e2(t5)), t0)
    c1 = sub_e2(mul_by_non_residue_e2(t2), t3)
    c2 = sub_e2(t1, t4)
    t6 = mul_e2(x[0], c0)
    d1 = mul_e2(x[2], c1)
    d2 = mul_e2(x[1], c2)
    d1 = mul_by_non_residue_e2(add_e2(d1, d2))
    t6 = add_e2(t6, d1)
    t6 = inv_e2(t6)
    return mul_e2(c0, t6), mul_e2(c1, t6), mul_e2(c2, t6)


def mul_e6(
    x: ((mpz, mpz), (mpz, mpz), (mpz, mpz)), y: ((mpz, mpz), (mpz, mpz), (mpz, mpz))
):
    # assert (
    #     len(x) == 3
    #     and len(y) == 3
    #     and len(x[0]) == 2
    #     and len(x[1]) == 2
    #     and len(x[2]) == 2
    #     and len(y[0]) == 2
    #     and len(y[1]) == 2
    #     and len(y[2]) == 2
    # )
    t0, t1, t2 = mul_e2(x[0], y[0]), mul_e2(x[1], y[1]), mul_e2(x[2], y[2])
    c0 = add_e2(x[1], x[2])
    tmp = add_e2(y[1], y[2])
    c0 = mul_e2(c0, tmp)
    c0 = sub_e2(c0, t1)
    c0 = sub_e2(c0, t2)
    c0 = mul_by_non_residue_e2(c0)
    c0 = add_e2(c0, t0)
    c1 = add_e2(x[0], x[1])
    tmp = add_e2(y[0], y[1])
    c1 = mul_e2(c1, tmp)
    c1 = sub_e2(c1, t0)
    c1 = sub_e2(c1, t1)
    tmp = mul_by_non_residue_e2(t2)
    c1 = add_e2(c1, tmp)
    tmp = add_e2(x[0], x[2])
    c2 = add_e2(y[0], y[2])
    c2 = mul_e2(c2, tmp)
    c2 = sub_e2(c2, t0)
    c2 = sub_e2(c2, t2)
    c2 = add_e2(c2, t1)
    return c0, c1, c2


def div_e6(
    x: ((int, int), (int, int), (int, int)),
    y: ((int, int), (int, int), (int, int)),
):
    x_mpz = ((mpz(x[0]), mpz(x[1])), (mpz(x[2]), mpz(x[3])), (mpz(x[4]), mpz(x[5])))
    y_mpz = ((mpz(y[0]), mpz(y[1])), (mpz(y[2]), mpz(y[3])), (mpz(y[4]), mpz(y[5])))

    return mul_e6(x_mpz, inv_e6(y_mpz))


def square_torus_e6(x: ((int, int), (int, int), (int, int))):
    x_mpz = ((mpz(x[0]), mpz(x[1])), (mpz(x[2]), mpz(x[3])), (mpz(x[4]), mpz(x[5])))

    true_v = ((mpz(0), mpz(0)), (mpz(1), mpz(0)), (mpz(0), mpz(0)))
    one_over_2_e6 = (
        (
            mpz(
                10944121435919637611123202872628637544348155578648911831344518947322613104292
            ),
            mpz(0),
        ),
        (mpz(0), mpz(0)),
        (mpz(0), mpz(0)),
    )
    z = mul_e6(add_e6(x_mpz, mul_e6(true_v, inv_e6(x_mpz))), one_over_2_e6)
    return z
