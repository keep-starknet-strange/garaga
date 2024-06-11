import random
import subprocess
import re

p = 21888242871839275222246405745257275088696311157297823662689037894645226208583
STARK = 3618502788666131213697322783095070105623107215331596699973092056135872020481


def mul_e2(x: (int, int), y: (int, int)):
    a = (x[0] + x[1]) * (y[0] + y[1]) % p
    b, c = x[0] * y[0] % p, x[1] * y[1] % p
    return (b - c) % p, (a - b - c) % p


def exp_e2(x: (int, int), p: int):
    """
    Compute x**p in F_p^2 using square-and-multiply algorithm.


    Args:
    x: Element of F_p^2, represented as a tuple of integers.
    p: The exponent, a non-negative integer.


    Returns:
    x**p in F_p^2, represented similarly as x.
    """
    # Ensure x is in F_p^2 and p is a non-negative integer.
    assert len(x) == 2 and isinstance(p, int) and p >= 0

    # Handle the easy cases.
    if p == 0:
        # x**0 = 1, where 1 is the multiplicative identity in F_p^2.
        return (1, 0)
    elif p == 1:
        # x**1 = x.
        return x

    # Start the computation.
    result = (1, 0)  # Initialize result as the multiplicative identity in F_p^2.
    temp = x  # Initialize temp as x.

    # Loop through each bit of the exponent p.
    for bit in reversed(bin(p)[2:]):  # [2:] to strip the "0b" prefix.
        if bit == "1":
            result = mul_e2(result, temp)
        temp = mul_e2(temp, temp)

    return result


def square_e2(x: (int, int)):
    return mul_e2(x, x)


def double_e2(x: (int, int)):
    return 2 * x[0] % p, 2 * x[1] % p


def sub_e2(x: (int, int), y: (int, int)):
    return (x[0] - y[0]) % p, (x[1] - y[1]) % p


def neg_e2(x: (int, int)):
    return -x[0] % p, -x[1] % p


def mul_by_non_residue_e2(x: (int, int)):
    return mul_e2(x, (9, 1))


def add_e2(x: (int, int), y: (int, int)):
    return (x[0] + y[0]) % p, (x[1] + y[1]) % p


def inv_e2(a: (int, int)):
    t0, t1 = (a[0] * a[0] % p, a[1] * a[1] % p)
    t0 = (t0 + t1) % p
    t1 = pow(t0, -1, p)
    return a[0] * t1 % p, -(a[1] * t1) % p


# E6 Tower:
def mul_by_non_residue_e6(x: ((int, int), (int, int), (int, int))):
    return mul_by_non_residue_e2(x[2]), x[0], x[1]


def sub_e6(
    x: ((int, int), (int, int), (int, int)), y: ((int, int), (int, int), (int, int))
):
    return (sub_e2(x[0], y[0]), sub_e2(x[1], y[1]), sub_e2(x[2], y[2]))


def add_e6(
    x: ((int, int), (int, int), (int, int)), y: ((int, int), (int, int), (int, int))
):
    return (add_e2(x[0], y[0]), add_e2(x[1], y[1]), add_e2(x[2], y[2]))


def neg_e6(x: ((int, int), (int, int), (int, int))):
    return neg_e2(x[0]), neg_e2(x[1]), neg_e2(x[2])


def inv_e6(x: ((int, int), (int, int), (int, int))):
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
    x: ((int, int), (int, int), (int, int)), y: ((int, int), (int, int), (int, int))
):
    assert (
        len(x) == 3
        and len(y) == 3
        and len(x[0]) == 2
        and len(x[1]) == 2
        and len(x[2]) == 2
        and len(y[0]) == 2
        and len(y[1]) == 2
        and len(y[2]) == 2
    )
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


def square_torus_e6(x: ((int, int), (int, int), (int, int))):
    v = ((0, 0), (1, 0), (0, 0))
    one_over_2_e6 = (
        (
            10944121435919637611123202872628637544348155578648911831344518947322613104292,
            0,
        ),
        (0, 0),
        (0, 0),
    )
    inv_x = inv_e6(x)
    v_inv_x = mul_e6(v, inv_x)
    x_v_inv_x = add_e6(x, v_inv_x)
    z = mul_e6(x_v_inv_x, one_over_2_e6)
    print(f"inv_x = {inv_x}")
    print(f"v_inv_x = {v_inv_x}")
    print(f"x_v_inv_x = {x_v_inv_x}")
    print(f"z = {z}")
    return z


def v_from_square_e6(
    # SQ = 1/2(x+ v/x) <=> v = x (2SQ - x)
    sq: ((int, int), (int, int), (int, int)),
    x,
) -> ((int, int), (int, int), (int, int)):
    two_e6 = ((2, 0), (0, 0), (0, 0))
    two_sq = mul_e6(two_e6, sq)
    two_sq_min_x = sub_e6(two_sq, x)

    print(f"two_sq = {two_sq}")
    print(f"two_sq_min_x = {two_sq_min_x}")
    return mul_e6(x, two_sq_min_x)


def div_e6(
    x: ((int, int), (int, int), (int, int)), y: ((int, int), (int, int), (int, int))
):
    return mul_e6(x, inv_e6(y))


def square_e6(x: ((int, int), (int, int), (int, int))):
    return mul_e6(x, x)


def exp_e6(x: ((int, int), (int, int), (int, int)), p: int):
    """
    Compute x**p in F_p^6 using square-and-multiply algorithm.

    Args:
    x: Element of F_p^6, represented as a tuple of three pairs of integers.
    p: The exponent, a non-negative integer.

    Returns:
    x**p in F_p^6, represented similarly as x.
    """
    # Ensure x is in F_p^6 and p is a non-negative integer.
    assert (
        len(x) == 3
        and len(x[0]) == 2
        and len(x[1]) == 2
        and len(x[2]) == 2
        and isinstance(p, int)
        and p >= 0
    )

    # Handle the easy cases.
    if p == 0:
        # x**0 = 1, where 1 is the multiplicative identity in F_p^6.
        return ((1, 0), (0, 0), (0, 0))
    elif p == 1:
        # x**1 = x.
        return x

    # Start the computation.
    result = (
        (1, 0),
        (0, 0),
        (0, 0),
    )  # Initialize result as the multiplicative identity in F_p^6.
    temp = x  # Initialize temp as x.

    # Loop through each bit of the exponent p.
    for bit in reversed(bin(p)[2:]):  # [2:] to strip the "0b" prefix.
        if bit == "1":
            result = mul_e6(result, temp)
        temp = square_e6(temp)

    return result


def inv_e12(
    c0: ((int, int), (int, int), (int, int)), c1: ((int, int), (int, int), (int, int))
):
    t0, t1 = square_e6(c0), square_e6(c1)
    tmp = mul_by_non_residue_e6(t1)
    t0 = sub_e6(t0, tmp)
    t1 = inv_e6(t0)
    c0 = mul_e6(c0, t1)
    c1 = mul_e6(c1, t1)
    c1 = neg_e6(c1)
    return [
        c0[0][0],
        c0[0][1],
        c0[1][0],
        c0[1][1],
        c0[2][0],
        c0[2][1],
        c1[0][0],
        c1[0][1],
        c1[1][0],
        c1[1][1],
        c1[2][0],
        c1[2][1],
    ]


def mul_e12(
    x: (((int, int), (int, int), (int, int)), ((int, int), (int, int), (int, int))),
    y: (((int, int), (int, int), (int, int)), ((int, int), (int, int), (int, int))),
):
    a = add_e6(x[0], x[1])
    b = add_e6(y[0], y[1])
    a = mul_e6(a, b)
    b = mul_e6(x[0], y[0])
    c = mul_e6(x[1], y[1])
    z1 = sub_e6(a, b)
    z1 = sub_e6(z1, c)
    c = mul_by_non_residue_e6(c)
    z0 = add_e6(c, b)
    return (z0, z1)


def flatten(t):
    result = []
    for item in t:
        if isinstance(item, tuple):
            result.extend(flatten(item))
        else:
            result.append(item)
    return result


def pack_e12(l: list):
    assert len(l) == 12
    return (
        ((l[0], l[1]), (l[2], l[3]), (l[4], l[5])),
        ((l[6], l[7]), (l[8], l[9]), (l[10], l[11])),
    )


def pack_e6(l: list):
    assert len(l) == 6
    return (
        (l[0], l[1]),
        (l[2], l[3]),
        (l[4], l[5]),
    )


def parse_fp_elements(input_string: str):
    pattern = re.compile(r"\[([^\[\]]+)\]")
    substrings = pattern.findall(input_string)
    sublists = [substring.split(" ") for substring in substrings]
    sublists = [[int(x) for x in sublist] for sublist in sublists]
    fp_elements = [
        x[0] + x[1] * 2**64 + x[2] * 2**128 + x[3] * 2**192 for x in sublists
    ]
    return fp_elements


def square_e12_gnark(
    x: (((int, int), (int, int), (int, int)), ((int, int), (int, int), (int, int)))
):
    inputs = flatten(x)
    inputs += inputs
    cmd = ["./tools/gnark/main", "e12", "square"] + [str(x) for x in inputs]
    out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode("utf-8")
    fp_elements = parse_fp_elements(out)
    assert len(fp_elements) == 12
    return fp_elements


def inv_e12_gnark(
    x: (((int, int), (int, int), (int, int)), ((int, int), (int, int), (int, int)))
):
    inputs = flatten(x)
    inputs += inputs
    cmd = ["./tools/gnark/main", "e12", "inv"] + [str(x) for x in inputs]
    out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode("utf-8")
    fp_elements = parse_fp_elements(out)
    assert len(fp_elements) == 12
    return fp_elements


def square_e12_gnark2(
    x: (((int, int), (int, int), (int, int)), ((int, int), (int, int), (int, int)))
):
    inputs = flatten(x)
    inputs += inputs
    cmd = ["./tools/gnark/main", "e12", "mul"] + [str(x) for x in inputs]
    out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode("utf-8")
    fp_elements = parse_fp_elements(out)
    assert len(fp_elements) == 12
    return fp_elements


def mul_e12_gnark(
    x: (((int, int), (int, int), (int, int)), ((int, int), (int, int), (int, int))),
    y: (((int, int), (int, int), (int, int)), ((int, int), (int, int), (int, int))),
):
    inputs = flatten(x) + flatten(y)
    cmd = ["./tools/gnark/main", "e12", "mul"] + [str(x) for x in inputs]
    out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode("utf-8")
    # print(out)
    fp_elements = parse_fp_elements(out)
    assert len(fp_elements) == 12
    return fp_elements


def test_square():
    x = pack_e12([random.randint(0, p - 1) for _ in range(12)])
    y = square_e12_gnark(x)
    yy = square_e12_gnark2(x)
    assert y == yy
    z = flatten(square_e12(x))
    zz = flatten(mul_e12(x, x))
    assert z == zz
    assert y == z, f"{y} != {z}"


def test_inv():
    x = pack_e12([random.randint(0, p - 1) for _ in range(12)])
    y = inv_e12(x[0], x[1])
    yy = inv_e12_gnark(x)
    assert y == yy


def test_mul():
    x = pack_e12([random.randint(0, p - 1) for _ in range(12)])
    y = pack_e12([random.randint(0, p - 1) for _ in range(12)])
    z = flatten(mul_e12(x, y))
    zz = mul_e12_gnark(x, y)
    assert z == zz


def gnark_to_w(x: list):
    res = 12 * [0]
    # C0.B0.A0 0
    res[0] += x[0]
    # C0.B0.A1 1
    res[6] += x[1]
    res[0] += -9 * x[1]
    # C0.B1.A0 2
    res[2] += x[2]
    # C0.B1.A1 3
    res[8] += x[3]
    res[2] += -9 * x[3]
    # C0.B2.A0 4
    res[4] = x[4]
    # C0.B2.A1 5
    res[10] += x[5]
    res[4] += -9 * x[5]
    # C1.B0.A0 6
    res[1] += x[6]
    # C1.B0.A1 7
    res[7] += x[7]
    res[1] += -9 * x[7]
    # C1.B1.A0 8
    res[3] += x[8]
    # C1.B1.A1 9
    res[9] += x[9]
    res[3] += -9 * x[9]
    # C1.B2.A0 10
    res[5] += x[10]
    # C1.B2.A1 11
    res[11] += x[11]
    res[5] += -9 * x[11]
    res = [x % p for x in res]
    return res


def w_to_gnark(x: list):
    x = x + (12 - len(x)) * [0]
    res = 12 * [0]
    # w^0
    res[0] += x[0]
    # w^1
    res[6] += x[1]
    # w^2
    res[2] += x[2]
    # w^3
    res[8] += x[3]
    # w^4
    res[4] += x[4]
    # w^5
    res[10] += x[5]
    # w^6
    res[1] += x[6]
    res[0] += 9 * x[6]
    # w^7
    res[7] += x[7]
    res[6] += 9 * x[7]
    # w^8
    res[3] += x[8]
    res[2] += 9 * x[8]
    # w^9
    res[9] += x[9]
    res[8] += 9 * x[9]
    # w^10
    res[5] += x[10]
    res[4] += 9 * x[10]
    # w^11
    res[11] += x[11]
    res[10] += 9 * x[11]

    res = [x % p for x in res]
    return res


def gnark_to_v(x: list, reduce=True):
    res = 6 * [0]

    res[0] += x[0]
    res[3] += x[1]
    res[0] += -9 * x[1]

    res[1] += x[2]
    res[4] += x[3]
    res[1] += -9 * x[3]

    res[2] += x[4]
    res[5] += x[5]
    res[2] += -9 * x[5]
    if reduce:
        res = [x % p for x in res]
    return res


def v_to_gnark(x: list):
    res = 6 * [0]

    # v^0
    res[0] += x[0]
    # v^1
    res[2] += x[1]
    # v^2
    res[4] += x[2]
    # v^3
    res[1] += x[3]
    res[0] += 9 * x[3]
    # v^4
    res[3] += x[4]
    res[2] += 9 * x[4]
    # v^5
    res[5] += x[5]
    res[4] += 9 * x[5]

    res = [x % p for x in res]
    return res


def test_v():
    x = [random.randint(0, p - 1) for _ in range(6)]
    assert x == v_to_gnark(gnark_to_v(x))


def test_neg_e6():
    x = [random.randint(0, p - 1) for _ in range(6)]
    x_gnark = pack_e6(v_to_gnark(x))
    x_gnark_neg = neg_e6(x_gnark)

    x_neg = [-e % p for e in x]

    assert x_neg == gnark_to_v(flatten(x_gnark_neg))


def test_frobenius_torus_square():
    x = [random.randint(0, p - 1) for _ in range(6)]
    x_gnark = pack_e6(v_to_gnark(x))
    v = [0, 1, 0, 0, 0, 0]
    v_gnark = pack_e6(v_to_gnark(v))
    print(v_gnark)
    x_gnark_fr2 = exp_e6(x_gnark, p**2)
    tmp = inv_e6(exp_e6(v_gnark, (p**2 - 1) // 2))
    x_gnark_fr2 = mul_e6(x_gnark_fr2, tmp)

    x_gnark_fr2_gnark = flatten(x_gnark)
    x_gnark_fr2_gnark = [
        x_gnark_fr2_gnark[0]
        * 2203960485148121921418603742825762020974279258880205651967
        % p,
        x_gnark_fr2_gnark[1]
        * 2203960485148121921418603742825762020974279258880205651967
        % p,
        x_gnark_fr2_gnark[2]
        * 21888242871839275220042445260109153167277707414472061641714758635765020556617
        % p,
        x_gnark_fr2_gnark[3]
        * 21888242871839275220042445260109153167277707414472061641714758635765020556617
        % p,
        x_gnark_fr2_gnark[4]
        * 21888242871839275222246405745257275088696311157297823662689037894645226208582
        % p,
        x_gnark_fr2_gnark[5]
        * 21888242871839275222246405745257275088696311157297823662689037894645226208582
        % p,
    ]

    assert flatten(x_gnark_fr2) == x_gnark_fr2_gnark, f"Yo"

    x_fr2 = [
        x[0] * 2203960485148121921418603742825762020974279258880205651967 % p,
        x[1]
        * 21888242871839275220042445260109153167277707414472061641714758635765020556617
        % p,
        x[2]
        * 21888242871839275222246405745257275088696311157297823662689037894645226208582
        % p,
        x[3] * 2203960485148121921418603742825762020974279258880205651967 % p,
        x[4]
        * 21888242871839275220042445260109153167277707414472061641714758635765020556617
        % p,
        x[5]
        * 21888242871839275222246405745257275088696311157297823662689037894645226208582
        % p,
    ]
    assert x_fr2 == gnark_to_v(
        flatten(x_gnark_fr2)
    ), f" {x_fr2} != {flatten(x_gnark_fr2)}"


if __name__ == "__main__":
    # test_inv()
    # test_mul()
    # test_square()
    # test_v()
    # test_frobenius_torus_square()
    x = [random.randint(0, p - 1) for _ in range(12)]
    assert x == w_to_gnark(gnark_to_w(x))
    assert x == gnark_to_w(w_to_gnark(x))

    from hydra.algebra import Polynomial
    from hydra.algebra import PyFelt, BaseField

    field = BaseField(p)

    x = [random.randint(0, p - 1) for _ in range(12)]
    x = [1, 1] + [1] * 10
    x_gnark = w_to_gnark(x)
    assert x == gnark_to_w(x_gnark)

    xx = [field(x) for x in x]
    x_poly = Polynomial(xx)

    assert x == x_poly.get_coeffs()
    y_poly = x_poly * x_poly
    print(f"Ypoly: {y_poly.get_coeffs()}")

    # // Extension fields tower:
    # //
    # //	𝔽p²[u] = 𝔽p/u²+1
    # //	𝔽p⁶[v] = 𝔽p²/v³-9-u
    # //	𝔽p¹²[w] = 𝔽p⁶/w²-v
    # Irreducible polys :
    # Fp12/Fp : w^12 - 18w^6 + 82 = 0
    # Fp6/Fp : v^6 - 18v^3 + 82 = 0
    coeffs = [
        PyFelt(82, field),
        field.zero(),
        field.zero(),
        field.zero(),
        field.zero(),
        field.zero(),
        PyFelt(-18 % p, field),
        field.zero(),
        field.zero(),
        field.zero(),
        field.zero(),
        field.zero(),
        field.one(),
    ]

    unreducible_poly = Polynomial(coeffs)
    # unreducible_poly2 = Polynomial(reversed(coeffs))

    y_poly1r = y_poly % unreducible_poly
    y_poly1q = y_poly // unreducible_poly
    assert y_poly1q * unreducible_poly + y_poly1r == y_poly
    # y_poly2r = y_poly % unreducible_poly2

    res1 = w_to_gnark(y_poly1r.get_coeffs())
    # res2 = w_to_gnark(y_poly2r.get_coeffs())

    expected = flatten(square_e12_gnark(pack_e12(x_gnark)))
    print(f"\nres1: {res1}")
    # print(f"res2: {res2}")
    print(f"expected: {expected}")

    assert expected == flatten(square_e12(pack_e12(x_gnark)))
    assert res1 == expected, f"{res1} != {expected}"
    # assert res2 == expected

    w = [0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0]
    w_2 = v = flatten(square_e12(pack_e12(w)))
    w_3 = flatten(mul_e12(pack_e12(w_2), pack_e12(w)))
    w_4 = flatten(square_e12(pack_e12(w_2)))
    w_5 = flatten(mul_e12(pack_e12(w_4), pack_e12(w)))

    w_6 = flatten(square_e12(pack_e12(w_3)))
    w_7 = flatten(mul_e12(pack_e12(w_6), pack_e12(w)))
    w_8 = flatten(square_e12(pack_e12(w_4)))
    w_9 = flatten(mul_e12(pack_e12(w_8), pack_e12(w)))
    w_10 = flatten(square_e12(pack_e12(w_5)))
    w_11 = flatten(mul_e12(pack_e12(w_10), pack_e12(w)))
    w_12 = flatten(square_e12(pack_e12(w_6)))

    w_pows = [w, w_2, w_3, w_4, w_5, w_6, w_7, w_8, w_9, w_10, w_11, w_12]
    for i in range(1, 13):
        print(f"w^{i}: {w_pows[i-1]}")
