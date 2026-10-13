import pytest
from garaga import garaga_rs
from garaga.curves import CURVES, CurveID
from garaga.hints.fake_glv import get_ed25519_cofactor_hint, scalar_mul_fake_glv
from garaga.points import G1Point
from garaga.starknet.tests_and_calldata_generators.msm import MSMCalldataBuilder


def ed25519_points():
    curve = CURVES[CurveID.ED25519.value]
    order_two_x = (curve.a_twisted + curve.d_twisted) * pow(6, -1, curve.p) % curve.p
    order_two = G1Point(order_two_x, 0, CurveID.ED25519)
    order_four = G1Point(
        *curve.to_weierstrass(pow(2, (curve.p - 1) // 4, curve.p), 0), CurveID.ED25519
    )
    generator = G1Point.get_nG(CurveID.ED25519, 1)
    return [order_two, order_four, generator.add(order_four), generator]


@pytest.mark.parametrize("point", ed25519_points())
@pytest.mark.parametrize("scalar", [0, 1, 2, 7, 8, CURVES[4].n - 1])
def test_ed25519_full_curve_hint_parity(point, scalar):
    result = point.scalar_mul(scalar)
    preimage = get_ed25519_cofactor_hint(point, scalar)
    assert preimage.scalar_mul(8) == result.add(-point.scalar_mul(scalar % 8))
    assert scalar_mul_fake_glv(point, scalar) == result
    builder = MSMCalldataBuilder(CurveID.ED25519, [point], [scalar])
    python_hint = builder.serialize_to_calldata(include_points_and_scalars=False)
    rust_hint = builder.serialize_to_calldata(
        include_points_and_scalars=False, use_rust=True
    )
    assert python_hint == rust_hint
    assert len(python_hint) == 18


@pytest.mark.parametrize("use_rust", [False, True])
def test_bls12_381_calldata_rejects_non_subgroup(use_rust):
    # (0,2) has order three on y²=x³+4, not the prime subgroup order.
    point = G1Point(0, 2, CurveID.BLS12_381)
    builder = MSMCalldataBuilder(CurveID.BLS12_381, [point], [2])
    with pytest.raises(ValueError, match="prime-order subgroup"):
        builder.serialize_to_calldata(use_rust=use_rust)


def test_msm_builder_rejects_unreduced_scalar():
    with pytest.raises(AssertionError, match="less than"):
        MSMCalldataBuilder(
            CurveID.BN254, [G1Point.get_nG(CurveID.BN254, 1)], [CURVES[0].n]
        )


@pytest.mark.parametrize("curve_id", list(CurveID))
def test_msm_calldata_rejects_coordinate_alias(curve_id):
    generator = G1Point.get_nG(curve_id, 1)
    alias = G1Point(generator.x, generator.y + CURVES[curve_id.value].p, curve_id)
    with pytest.raises(ValueError, match="canonical"):
        MSMCalldataBuilder(curve_id, [alias], [2])
    with pytest.raises(ValueError, match="canonical"):
        garaga_rs.msm_calldata_builder(
            [alias.x, alias.y], [2], curve_id.value, True, False
        )
