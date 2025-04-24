import random

import pytest

from garaga.definitions import CURVES, CurveID
from garaga.hints.fake_glv import half_gcd_eisenstein_hint


@pytest.mark.parametrize(
    "curve_id", [CurveID.BN254, CurveID.SECP256K1, CurveID.BLS12_381]
)
def test_half_gcd_eisenstein_hint(curve_id):

    curve = CURVES[curve_id.value]
    eigen_value = curve.eigen_value
    order = curve.n

    max_bit_length = curve.n.bit_length() // 4 + 9
    print(f"max_bit_length: {max_bit_length}")
    for _ in range(100000):
        scalar = random.randint(1, order)
        u1, u2, v1, v2 = half_gcd_eisenstein_hint(order, scalar, eigen_value)
        # assert (scalar * (v1 + eigen_value * v2) + u1 + eigen_value * u2) % order == 0

        assert abs(u1).bit_length() <= max_bit_length
        assert abs(u2).bit_length() <= max_bit_length
        assert abs(v1).bit_length() <= max_bit_length
        assert abs(v2).bit_length() <= max_bit_length
