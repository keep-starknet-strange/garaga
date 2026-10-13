import random
from fractions import Fraction

import pytest
from garaga.curves import CURVES, CurveID
from garaga.hints.lattice import _round_nearest, rational_reconstruct_extension
from garaga.points import G1Point

GLV_CURVES = [CurveID.BN254, CurveID.BLS12_381, CurveID.SECP256K1]


@pytest.mark.parametrize("curve_id", GLV_CURVES)
def test_reconstruction_invariants_at_scalar_boundaries(curve_id):
    curve = CURVES[curve_id.value]
    rng = random.Random(42)
    scalars = [0, 1, 2, curve.n - 2, curve.n - 1, curve.eigen_value]
    scalars += [rng.randrange(curve.n) for _ in range(32)]
    scalars += [
        min(curve.n - 1, (1 << bits) + offset)
        for bits in range(1, 257, 8)
        for offset in (-1, 0, 1)
    ]
    for scalar in scalars:
        values = rational_reconstruct_extension(curve.n, scalar, curve.eigen_value)
        u1, u2, v1, v2 = values
        denominator = (v1 + curve.eigen_value * v2) % curve.n
        assert denominator != 0
        assert (u1 + curve.eigen_value * u2 + scalar * denominator) % curve.n == 0
        assert all(abs(value).bit_length() <= 65 for value in values)


def test_zero_scalar_has_a_nonzero_denominator():
    assert rational_reconstruct_extension(13, 0, 3) == (0, 0, 1, 0)


def test_rounding_ties_match_rust():
    for numerator, expected in [(1, 1), (-1, -1), (3, 2), (-3, -2)]:
        assert _round_nearest(Fraction(numerator, 2)) == expected


@pytest.mark.parametrize("modulus", [0, 1, -13])
def test_invalid_modulus_is_rejected(modulus):
    with pytest.raises(ValueError, match="modulus"):
        rational_reconstruct_extension(modulus, 2, 3)


@pytest.mark.parametrize("curve_id", GLV_CURVES)
def test_python_rust_hint_serialization_matches_at_scalar_boundaries(curve_id):
    from garaga.starknet.tests_and_calldata_generators.msm import MSMCalldataBuilder

    curve = CURVES[curve_id.value]
    rng = random.Random(42)
    scalars = [0, 1, 2, curve.n - 2, curve.n - 1]
    scalars += [rng.randrange(curve.n) for _ in range(8)]
    builder = MSMCalldataBuilder(
        curve_id=curve_id,
        points=[G1Point.get_nG(curve_id, 1)] * len(scalars),
        scalars=scalars,
    )
    assert builder.serialize_to_calldata(
        use_rust=False
    ) == builder.serialize_to_calldata(use_rust=True)
