import random

import pytest

from garaga.definitions import CURVES, CurveID, G1Point
from garaga.hints.fake_glv import half_gcd_eisenstein_hint, scalar_mul_glv_and_fake_glv


@pytest.mark.parametrize(
    "curve_id", [CurveID.BN254, CurveID.SECP256K1, CurveID.BLS12_381]
)
def test_half_gcd_eisenstein_hint(curve_id):

    curve = CURVES[curve_id.value]
    eigen_value = curve.eigen_value
    order = curve.n

    max_bit_length = curve.n.bit_length() // 4 + 9
    print(f"max_bit_length: {max_bit_length}")
    for _ in range(10000):
        scalar = random.randint(1, order)
        u1, u2, v1, v2 = half_gcd_eisenstein_hint(order, scalar, eigen_value)
        # assert (scalar * (v1 + eigen_value * v2) + u1 + eigen_value * u2) % order == 0

        assert abs(u1).bit_length() <= max_bit_length
        assert abs(u2).bit_length() <= max_bit_length
        assert abs(v1).bit_length() <= max_bit_length
        assert abs(v2).bit_length() <= max_bit_length


@pytest.mark.parametrize(
    "curve_id", [CurveID.SECP256K1, CurveID.BLS12_381, CurveID.BN254]
)
def test_glv_fake_glv(curve_id):
    curve = CURVES[curve_id.value]
    random_point = G1Point.get_nG(curve_id, 1)
    # for _ in range(100):
    #     scalar = random.randint(1, curve.n)
    #     _ = scalar_mul_glv_and_fake_glv(random_point, scalar)
    scalar = curve.n - 2
    _ = scalar_mul_glv_and_fake_glv(random_point, scalar)

    # for _ in range(100):
    #     _ = scalar_mul_glv_and_fake_glv(random_point, scalar)
    #     scalar -= 1


def test_glv_fake_glv_bls12_381_2():
    curve = CURVES[CurveID.BLS12_381.value]
    n_failed = 0
    n_passed = 0
    for _ in range(10):
        try:
            point = G1Point.gen_random_point_not_in_subgroup(CurveID.BLS12_381)
            scalar = random.randint(1, 2**63)
            expected_point = point.scalar_mul(scalar)
            print(f"expected_point: {expected_point}")
            _ = scalar_mul_glv_and_fake_glv(point, scalar)
            n_passed += 1
        except AssertionError as e:
            print(f"Assertion error for scalar = {e}")
            n_failed += 1
    print(f"n_failed: {n_failed}, n_passed: {n_passed}")

    # _ = scalar_mul_glv_and_fake_glv(point, scalar)
    assert not point.is_in_prime_order_subgroup()
    print(f"point nisg: {point}")


def test_glv_fake_glv_bls12_381_3():
    curve = CURVES[CurveID.BLS12_381.value]
    n_failed = 0
    n_passed = 0
    for _ in range(100):
        try:
            point = G1Point.gen_random_point(CurveID.BLS12_381)
            scalar = random.randint(1, curve.n)
            _ = scalar_mul_glv_and_fake_glv(point, scalar)
            n_passed += 1
        except AssertionError as e:
            print(f"Assertion error for scalar = {scalar}")
            n_failed += 1
    print(f"n_failed: {n_failed}, n_passed: {n_passed}")

    # _ = scalar_mul_glv_and_fake_glv(point, scalar)
