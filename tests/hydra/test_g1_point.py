import pytest

from garaga.curves import CURVES, CurveID, TwistedEdwardsCurve, is_generator
from garaga.points import G1Point

# List of curve IDs to test
curve_ids = list(CurveID)


@pytest.mark.parametrize("curve_id", [CurveID.ED25519])
def test_weierstrass_to_twistededwards_and_back(curve_id):
    curve: TwistedEdwardsCurve = CURVES[curve_id.value]

    # Define a point in Weierstrass form
    x_weierstrass = curve.Gx
    y_weierstrass = curve.Gy

    x_twisted, y_twisted = curve.to_twistededwards(x_weierstrass, y_weierstrass)
    x_weierstrass_back, y_weierstrass_back = curve.to_weierstrass(x_twisted, y_twisted)
    assert x_weierstrass == x_weierstrass_back
    assert y_weierstrass == y_weierstrass_back


@pytest.mark.parametrize("curve_id", curve_ids)
def test_fp_generator(curve_id):
    if curve_id == CurveID.BLS12_381:
        pytest.skip(
            "Skipping test for curve BLS12_381, it's a bit too slow to factorize p-1, but already tested. Uncomment to convince yourself."
        )
    g = CURVES[curve_id.value].fp_generator
    p = CURVES[curve_id.value].p
    assert is_generator(g, p)


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_equality(curve_id):
    p1 = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    p2 = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    p3 = p1.add(p2)
    assert p1 == p2
    assert p1 != p3


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_infinity(curve_id):
    inf = G1Point.infinity(curve_id)
    assert inf.is_infinity()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_on_curve(curve_id):
    p = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    assert p.is_on_curve()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_not_on_curve(curve_id):
    p = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    p.y = 3  # Modify y to make it not on the curve
    assert not p.is_on_curve()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_scalar_mul(curve_id):
    p = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    result = p.scalar_mul(2)
    assert result.is_on_curve()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_addition(curve_id):
    p1 = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    p2 = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    result = p1.add(p2)
    assert result.is_on_curve()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_addition_with_negative_point(curve_id):
    p1 = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    p2 = -p1
    result = p1.add(p2)
    assert result.is_infinity()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_negation(curve_id):
    p = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    neg_p = -p
    assert neg_p.is_on_curve()
    assert p.add(neg_p).is_infinity()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_msm(curve_id):
    p1 = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    p2 = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    points = [p1, p2]
    scalars = [2, 3]
    result = G1Point.msm(points, scalars)
    assert result.is_on_curve()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_gen_random_point(curve_id):
    p = G1Point.gen_random_point(curve_id)
    assert p.is_on_curve()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_gen_random_point_not_in_subgroup(curve_id):
    if CURVES[curve_id.value].h == 1:
        pytest.skip(f"Skipping test for curve {curve_id} because the cofactor is 1")
    p = G1Point.gen_random_point_not_in_subgroup(curve_id, force_gen=True)
    assert p.is_on_curve()
    assert not p.is_in_prime_order_subgroup_generic()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_to_cairo_1(curve_id):
    p = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    cairo_repr = p.to_cairo_1()
    assert isinstance(cairo_repr, str)


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_doubling(curve_id):
    p = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    doubled = p.add(p)
    assert doubled.is_on_curve()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_addition_vs_doubling(curve_id):
    p = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    doubled = p.add(p)
    scalar_mul_2 = p.scalar_mul(2)
    assert doubled == scalar_mul_2


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_msm_vs_scalar_mul(curve_id):
    p = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    scalar = 3
    msm_result = G1Point.msm([p], [scalar])
    scalar_mul_result = p.scalar_mul(scalar)
    assert msm_result == scalar_mul_result


# Edge case tests for scalar multiplication
@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_scalar_mul_zero(curve_id):
    p = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    result = p.scalar_mul(0)
    assert result.is_infinity()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_scalar_mul_one(curve_id):
    p = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    result = p.scalar_mul(1)
    assert result == p


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_scalar_mul_negative(curve_id):
    p = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    result = p.scalar_mul(-1)
    assert result == -p


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_scalar_mul_large(curve_id):
    p = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    large_scalar = 10**18
    result = p.scalar_mul(large_scalar)
    assert result.is_on_curve()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_scalar_mul_invalid(curve_id):
    p = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    with pytest.raises(TypeError):
        p.scalar_mul("invalid_scalar")


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_scalar_mul_order(curve_id):
    p = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
    result = p.scalar_mul(CURVES[curve_id.value].n)
    assert result.is_infinity()


@pytest.mark.parametrize("curve_id", curve_ids)
def test_g1point_scalar_mul_larger_than_order(curve_id):
    # Generate 10 random points on the curve
    random_points = [G1Point.gen_random_point(curve_id) for _ in range(10)]

    for p in random_points:
        result = p.scalar_mul(CURVES[curve_id.value].n + 1)
        assert result == p


@pytest.mark.parametrize("curve_id", curve_ids)
def test_is_in_subgroup(curve_id):
    for _ in range(10):
        p = G1Point.gen_random_point(curve_id)
        assert p.is_in_prime_order_subgroup()
        assert p.is_in_prime_order_subgroup_generic()

        if CURVES[curve_id.value].h != 1:
            p = G1Point.gen_random_point_not_in_subgroup(curve_id)
            assert not p.is_in_prime_order_subgroup()
            assert not p.is_in_prime_order_subgroup_generic()
