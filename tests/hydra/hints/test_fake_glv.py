import random

import pytest

from garaga.curves import CURVES, CurveID
from garaga.hints.fake_glv import (
    half_gcd_eisenstein_hint,
    scalar_mul_fake_glv,
    scalar_mul_glv_and_fake_glv,
)
from garaga.points import G1Point

GLV_FAKE_GLV_CURVES = [
    CurveID(k) for k, v in CURVES.items() if v.is_endomorphism_available()
]
FAKE_GLV_CURVES = [
    CurveID(k) for k, v in CURVES.items() if not v.is_endomorphism_available()
]


@pytest.mark.parametrize("curve_id", GLV_FAKE_GLV_CURVES)
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


@pytest.mark.parametrize("curve_id", GLV_FAKE_GLV_CURVES)
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
    assert not point.is_in_prime_order_subgroup_generic()
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


@pytest.mark.parametrize("curve_id", FAKE_GLV_CURVES)
def test_scalar_mul_fake_glv(curve_id):
    curve = CURVES[curve_id.value]
    G = G1Point.get_nG(curve_id, 1)
    infinity_point = G1Point.infinity(curve_id)
    n = curve.n

    test_cases = [
        # Point, Scalar, Description
        (G, 0, "Generator * 0"),
        (G, 1, "Generator * 1"),
        (G, 2, "Generator * 2"),
        (G, n - 1, "Generator * (n-1)"),
        (G, n, "Generator * n"),
        (infinity_point, 5, "Infinity * 5"),
        (infinity_point, 0, "Infinity * 0"),
    ]

    # Add a random point case
    random_point = G1Point.gen_random_point(curve_id)
    test_cases.extend(
        [
            (random_point, 0, "Random * 0"),
            (random_point, 1, "Random * 1"),
            (random_point, n, "Random * n"),
        ]
    )

    print(f"\nTesting Curve: {curve_id.name}")
    for point, scalar, desc in test_cases:
        print(f"  Case: {desc} (P={point}, s={scalar})")
        expected = point.scalar_mul(scalar)
        actual = scalar_mul_fake_glv(point, scalar)
        assert actual == expected, f"Mismatch for {desc}"

    # Test more random points and scalars
    num_random_tests = 10
    print(f"  Running {num_random_tests} random tests...")
    for i in range(num_random_tests):
        point = G1Point.gen_random_point(curve_id)
        scalar = random.randint(1, n)
        # print(f"    Random Test {i+1}: P={point}, s={scalar}") # Optional: verbose logging
        expected = point.scalar_mul(scalar)
        actual = scalar_mul_fake_glv(point, scalar)
        assert (
            actual == expected
        ), f"Mismatch for random test {i+1} (P={point}, s={scalar})"
    print(f"  {num_random_tests} random tests passed.")

    # Test random scalars for each bit length up to n.bit_length()
    print(f"  Running tests for scalar bit lengths 1 to {n.bit_length()}...")
    for k in range(1, n.bit_length() + 1, 4):
        # Generate a scalar with exactly k bits
        if k == 1:
            scalar = 1  # Only possible 1-bit scalar > 0
        else:
            lower_bound = 1 << (k - 1)
            upper_bound = (1 << k) - 1
            scalar = random.randint(lower_bound, upper_bound)

        # Ensure scalar is less than n (important for high bit lengths)
        scalar = scalar % n
        if scalar == 0:  # Avoid scalar 0 if it happens by modulo
            scalar = 1  # Or continue; let's test with 1 in this rare case

        point_to_test = G  # Use generator for consistency
        # print(f"    Bit Length {k}: s={scalar}") # Optional: verbose logging

        expected = point_to_test.scalar_mul(scalar)
        actual = scalar_mul_fake_glv(point_to_test, scalar)
        assert actual == expected, f"Mismatch for scalar bit length {k} (s={scalar})"
    print(f"  Scalar bit length tests passed.")
