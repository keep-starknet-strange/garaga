import random

import pytest

from garaga import ed25519 as ed
from garaga.precompiled_circuits.compilable_circuits.ed25519 import (
    Ed25519Circuit,
    pow_252_3,
)
from tools.divide_and_pair.vectors import (
    ELL,
    IDENTITY,
    multiply,
    vectors,
    weierstrass,
)


@pytest.mark.parametrize("scalar,coset,point", vectors())
def test_all_torsion_cosets(scalar, coset, point):
    expected = multiply(point, ELL) == IDENTITY
    assert expected == (coset == 0)
    assert ed.is_in_prime_order_subgroup(*point) == expected
    assert ed.is_small_order(*point) == (scalar == 0)
    model = weierstrass(point)
    assert model.is_in_prime_order_subgroup_generic() == expected
    assert model.is_in_prime_order_subgroup() == expected


def test_reject_off_curve():
    assert not ed.is_in_prime_order_subgroup(1, 1)
    point = weierstrass(vectors()[8][2])
    point.y += 1
    assert not point.is_in_prime_order_subgroup()


def evaluate(operation, *values):
    instance = Ed25519Circuit(operation=operation, auto_run=False)
    return [value.value for value in instance.run_circuit(list(values)).output]


def test_addition_chain():
    class Exponents:
        def mul(self, x, y):
            return x + y

    assert pow_252_3(Exponents(), 1) == 2**252 - 3


@pytest.mark.parametrize("scalar,coset,point", vectors())
def test_cairo_circuit_path_matches_python(scalar, coset, point):
    x, y = point
    if not weierstrass(point).y == 0:
        assert evaluate(
            "from_weierstrass", weierstrass(point).x, weierstrass(point).y
        ) == [x, y]
    assert evaluate("low_order", x, y) == [(x * x + y * y) % ed.P]
    if ed.is_small_order(x, y):
        return

    def sqrt(value):
        root, same, opposite = evaluate("sqrt", value % ed.P)
        if same == 0:
            return root
        if opposite == 0:
            return root * ed.I % ed.P
        return None

    u, w, e = evaluate("prepare", x, y)
    wp = sqrt(4 * u)
    if wp is None:
        assert coset != 0
        return
    (up,) = evaluate("halve_up", u, w, e, wp)
    root = sqrt(up)
    if root is None:
        root = sqrt(2 * up)
        assert root is not None
        e, wp, w = evaluate("halve_nqr", e, wp, root)
        sign = ed.P - 1
    else:
        w, sign = root, 1
    (symbol,) = evaluate("finish", e, wp, w, sign)
    assert (symbol == 1) == ed.is_in_prime_order_subgroup(x, y)


def test_square_roots_and_nonresidues():
    rng = random.Random(749)
    for value in [0, 1, 2, ed.P - 1] + [rng.randrange(ed.P) for _ in range(20)]:
        root = ed.sqrt(value)
        assert (root is not None) == (
            value == 0 or pow(value, (ed.P - 1) // 2, ed.P) == 1
        )
        if root is not None:
            assert root * root % ed.P == value
        is_square, paired_root = ed.sqrt_or_twice(value)
        assert is_square == (root is not None)
        assert paired_root * paired_root % ed.P == (
            value if is_square else 2 * value % ed.P
        )
        candidate, same, opposite, imaginary, neg_imaginary = evaluate(
            "sqrt_or_twice", value
        )
        if same == 0:
            result = (True, candidate)
        elif opposite == 0:
            result = (True, candidate * ed.I % ed.P)
        elif imaginary == 0:
            result = (False, candidate * ed.SQRT_TWO_I * ed.I % ed.P)
        else:
            assert neg_imaginary == 0
            result = (False, candidate * ed.SQRT_TWO_I % ed.P)
        assert result == (is_square, paired_root)
