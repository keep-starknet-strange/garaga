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


# Independent Jacobian arithmetic checks the affine fallback and native backend.
def _jacobian_double(point, a, modulus):
    x, y, z = point
    y_squared = y * y % modulus
    s = 4 * x * y_squared % modulus
    m = (3 * x * x + a * pow(z, 4, modulus)) % modulus
    rx = (m * m - 2 * s) % modulus
    ry = (m * (s - rx) - 8 * y_squared * y_squared) % modulus
    return rx, ry, 2 * y * z % modulus


def _jacobian_add(left, right, a, modulus):
    x1, y1, z1 = left
    x2, y2, z2 = right
    if z1 == 0:
        return right
    if z2 == 0:
        return left
    u1, u2 = x1 * z2 * z2 % modulus, x2 * z1 * z1 % modulus
    s1, s2 = y1 * pow(z2, 3, modulus) % modulus, y2 * pow(z1, 3, modulus) % modulus
    if u1 == u2:
        return _jacobian_double(left, a, modulus) if s1 == s2 else (0, 1, 0)
    h, r = (u2 - u1) % modulus, (s2 - s1) % modulus
    h_squared = h * h % modulus
    h_cubed = h_squared * h % modulus
    rx = (r * r - h_cubed - 2 * u1 * h_squared) % modulus
    ry = (r * (u1 * h_squared - rx) - s1 * h_cubed) % modulus
    return rx, ry, z1 * z2 * h % modulus


def _jacobian_to_affine(point, modulus):
    x, y, z = point
    if z == 0:
        return 0, 0
    inverse = pow(z, -1, modulus)
    return x * inverse**2 % modulus, y * inverse**3 % modulus


def _reference_scalar_mul(point, scalar):
    curve = CURVES[point.curve_id.value]
    a = curve.swu_params.A if point.iso_point else curve.a
    base = (point.x % curve.p, point.y % curve.p, 1)
    if scalar < 0:
        base = (base[0], -base[1] % curve.p, 1)
    result = (0, 1, 0)
    for bit in bin(abs(scalar))[2:]:
        result = _jacobian_double(result, a, curve.p)
        if bit == "1":
            result = _jacobian_add(result, base, a, curve.p)
    return _jacobian_to_affine(result, curve.p)


def _reference_add(left, right):
    curve = CURVES[left.curve_id.value]
    a = curve.swu_params.A if left.iso_point else curve.a
    result = _jacobian_add((left.x, left.y, 1), (right.x, right.y, 1), a, curve.p)
    return _jacobian_to_affine(result, curve.p)


@pytest.mark.parametrize("curve_id", curve_ids)
@pytest.mark.parametrize("negative", [False, True])
def test_scalar_mul_huge_integer_matches_independent_math(curve_id, negative):
    curve = CURVES[curve_id.value]
    point = G1Point(curve.Gx, curve.Gy, curve_id)
    scalar = (1 << 1024) + curve.n + 17
    if negative:
        scalar = -scalar
    result = point.scalar_mul(scalar)
    assert (result.x, result.y) == _reference_scalar_mul(point, scalar)


@pytest.fixture(
    params=["bls_torsion", "bls_coset", "ed_order2", "ed_order4", "ed_coset", "iso"]
)
def generic_point(request):
    if request.param.startswith("bls"):
        curve = CURVES[CurveID.BLS12_381.value]
        point = G1Point(0, 2, CurveID.BLS12_381)
        if request.param == "bls_coset":
            generator = G1Point(curve.Gx, curve.Gy, CurveID.BLS12_381)
            point = G1Point(*_reference_add(generator, point), CurveID.BLS12_381)
        return point
    if request.param == "iso":
        from garaga.curves import get_base_field
        from garaga.signature import map_to_curve

        return map_to_curve(get_base_field(CurveID.BLS12_381)(7), CurveID.BLS12_381)
    curve = CURVES[CurveID.ED25519.value]
    if request.param == "ed_order2":
        x = (curve.a_twisted + curve.d_twisted) * pow(6, -1, curve.p) % curve.p
        return G1Point(x, 0, CurveID.ED25519)
    sqrt_minus_one = pow(2, (curve.p - 1) // 4, curve.p)
    point = G1Point(*curve.to_weierstrass(sqrt_minus_one, 0), CurveID.ED25519)
    if request.param == "ed_coset":
        generator = G1Point(curve.Gx, curve.Gy, CurveID.ED25519)
        point = G1Point(*_reference_add(generator, point), CurveID.ED25519)
    return point


@pytest.mark.parametrize(
    "scalar_kind", ["zero", "one", "order", "past_order", "negative", "huge"]
)
def test_generic_scalar_mul_does_not_reduce_to_subgroup_order(
    generic_point, scalar_kind
):
    order = CURVES[generic_point.curve_id.value].n
    scalar = {
        "zero": 0,
        "one": 1,
        "order": order,
        "past_order": order + 1,
        "negative": -order - 1,
        "huge": -(1 << 1024) - order - 17,
    }[scalar_kind]
    result = generic_point.scalar_mul(scalar)
    assert (result.x, result.y) == _reference_scalar_mul(generic_point, scalar)
    assert result.iso_point == generic_point.iso_point


def test_bls_order3_point_is_not_in_subgroup():
    point = G1Point(0, 2, CurveID.BLS12_381)
    assert point.scalar_mul(CURVES[CurveID.BLS12_381.value].n) == point
    assert not point.is_in_prime_order_subgroup_generic()
    assert not point.is_in_prime_order_subgroup()


def test_ed25519_addition_with_order4_torsion_cosets():
    curve = CURVES[CurveID.ED25519.value]
    generator = G1Point(curve.Gx, curve.Gy, CurveID.ED25519)
    torsion = G1Point(
        *curve.to_weierstrass(pow(2, (curve.p - 1) // 4, curve.p), 0), CurveID.ED25519
    )
    left = G1Point(*_reference_add(generator, torsion), CurveID.ED25519)
    right = G1Point(*_reference_add(generator, -torsion), CurveID.ED25519)
    result = left.add(right)
    assert (result.x, result.y) == _reference_scalar_mul(generator, 2)
    assert not result.is_infinity()


@pytest.mark.parametrize("curve_id", curve_ids)
@pytest.mark.parametrize("multiple", [-1, 1, 1 << 512])
def test_noncanonical_coordinates_preserve_point_arithmetic(curve_id, multiple):
    curve = CURVES[curve_id.value]
    generator = G1Point(curve.Gx, curve.Gy, curve_id)
    point = G1Point(
        curve.Gx + multiple * curve.p, curve.Gy + multiple * curve.p, curve_id
    )
    summed = generator.add(point)
    assert (summed.x, summed.y) == _reference_scalar_mul(generator, 2)
    for scalar in (1, -1, curve.n + 1):
        result = point.scalar_mul(scalar)
        assert (result.x, result.y) == _reference_scalar_mul(generator, scalar)


@pytest.mark.parametrize("generic_point", ["iso"], indirect=True)
def test_isogenous_identity_operations_preserve_metadata(generic_point):
    zero = generic_point.scalar_mul(0)
    assert zero.is_infinity() and zero.iso_point
    assert zero.scalar_mul(123).iso_point
    assert zero.add(generic_point) == generic_point
    assert generic_point.add(-generic_point).iso_point
    assert G1Point.infinity(generic_point.curve_id).add(generic_point) == generic_point


def test_nonidentity_addition_rejects_different_curve_equations(generic_point):
    curve = CURVES[CurveID.SECP256K1.value]
    other = G1Point(curve.Gx, curve.Gy, CurveID.SECP256K1)
    with pytest.raises(ValueError, match="same curve"):
        generic_point.add(other)
    if generic_point.iso_point:
        curve = CURVES[generic_point.curve_id.value]
        ordinary = G1Point(curve.Gx, curve.Gy, generic_point.curve_id)
        with pytest.raises(ValueError, match="same curve"):
            generic_point.add(ordinary)
