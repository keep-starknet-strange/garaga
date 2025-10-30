import random

import pytest

from garaga.curves import CURVES, CurveID
from garaga.points import G2Point

# List of curve IDs to test
curve_ids = [CurveID.BN254, CurveID.BLS12_381]


def get_g2_generator_point(curve_id):
    return G2Point(CURVES[curve_id.value].G2x, CURVES[curve_id.value].G2y, curve_id)


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_equality(curve_id):
    p1 = get_g2_generator_point(curve_id)
    p2 = get_g2_generator_point(curve_id)
    p3 = p1.add(p2)
    assert p1 == p2
    assert p1 != p3


@pytest.mark.parametrize("curve_id", curve_ids)
def test_ng2(curve_id):
    p = get_g2_generator_point(curve_id)
    nG = G2Point.get_nG(curve_id, 1)

    assert nG == p


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_infinity(curve_id):
    inf = G2Point.infinity(curve_id)
    assert inf.is_infinity()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_on_curve(curve_id):
    p = get_g2_generator_point(curve_id)
    assert p.is_on_curve()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_not_on_curve(curve_id):
    with pytest.raises(ValueError):
        _ = G2Point((1, 2), (3, 4), curve_id)


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_scalar_mul(curve_id):
    p = get_g2_generator_point(curve_id)
    result = p.scalar_mul(2)
    assert result.is_on_curve()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_addition(curve_id):
    p1 = get_g2_generator_point(curve_id)
    p2 = get_g2_generator_point(curve_id)
    result = p1.add(p2)
    assert result.is_on_curve()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_negation(curve_id):
    p = get_g2_generator_point(curve_id)
    neg_p = -p
    assert neg_p.is_on_curve()
    assert p.add(neg_p).is_infinity()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_msm(curve_id):
    p1 = get_g2_generator_point(curve_id)
    p2 = get_g2_generator_point(curve_id)
    points = [p1, p2]
    scalars = [2, 3]
    result = G2Point.msm(points, scalars)
    assert result.is_on_curve()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_gen_random_point(curve_id):
    p = G2Point.gen_random_point(curve_id)
    assert p.is_on_curve()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_scalar_mul_zero(curve_id):
    p = get_g2_generator_point(curve_id)
    result = p.scalar_mul(0)
    assert result.is_infinity()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_scalar_mul_one(curve_id):
    p = get_g2_generator_point(curve_id)
    result = p.scalar_mul(1)
    assert result == p


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_scalar_mul_negative(curve_id):
    p = get_g2_generator_point(curve_id)
    result = p.scalar_mul(-1)
    assert result == -p


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_scalar_mul_large(curve_id):
    p = get_g2_generator_point(curve_id)
    large_scalar = 10**18
    result = p.scalar_mul(large_scalar)
    assert result.is_on_curve()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_scalar_mul_invalid(curve_id):
    p = get_g2_generator_point(curve_id)
    with pytest.raises(TypeError):
        p.scalar_mul("invalid_scalar")


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_scalar_mul_order(curve_id):
    p = get_g2_generator_point(curve_id)
    result = p.scalar_mul(CURVES[curve_id.value].n)
    assert result.is_infinity()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_scalar_mul_larger_than_order(curve_id):
    p = get_g2_generator_point(curve_id)
    result = p.scalar_mul(CURVES[curve_id.value].n + 1)
    assert result == p


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g2point_scalar_mul_larger_than_order_random_points(curve_id):
    # Generate 10 random points on the curve
    random_points = [G2Point.gen_random_point(curve_id) for _ in range(10)]

    # Shuffle the points
    random.shuffle(random_points)

    for p in random_points:
        result = p.scalar_mul(CURVES[curve_id.value].n + 1)
        assert result == p


@pytest.mark.parametrize("curve_id", curve_ids)
def test_is_in_subgroup(curve_id):
    for _ in range(10):
        p = G2Point.gen_random_point(curve_id)
        assert p.is_in_prime_order_subgroup()
        assert p.is_in_prime_order_subgroup_generic()

        if CURVES[curve_id.value].h != 1:
            p = G2Point.gen_random_point_not_in_subgroup(curve_id)
            assert not p.is_in_prime_order_subgroup()
            assert not p.is_in_prime_order_subgroup_generic()
