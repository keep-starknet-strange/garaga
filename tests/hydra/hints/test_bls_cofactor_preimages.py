import pytest
from garaga.curves import CURVES, CurveID
from garaga.hints.fake_glv import get_bls12_381_cofactor_hint
from garaga.points import G1Point


@pytest.mark.parametrize("scalar", [0, 1, 2, CURVES[CurveID.BLS12_381.value].n - 1])
def test_bls12_381_preimage_relation_and_record(scalar):
    from garaga.starknet.tests_and_calldata_generators.msm import MSMCalldataBuilder

    point = G1Point.get_nG(CurveID.BLS12_381, 7)
    result = point.scalar_mul(scalar)
    for target in [point, result]:
        preimage = get_bls12_381_cofactor_hint(target)
        assert preimage.is_infinity() or preimage.is_on_curve()
        assert preimage.scalar_mul(0xD201000000010001) == target

    builder = MSMCalldataBuilder(CurveID.BLS12_381, [point], [scalar])
    python_hint = builder.serialize_to_calldata(include_points_and_scalars=False)
    assert len(python_hint) == 28
    assert python_hint == builder.serialize_to_calldata(
        include_points_and_scalars=False, use_rust=True
    )


def test_bls12_381_preimage_infinity():
    point = G1Point.infinity(CurveID.BLS12_381)
    assert get_bls12_381_cofactor_hint(point).is_infinity()


@pytest.mark.parametrize("mixed", [False, True])
def test_bls12_381_preimage_rejects_torsion(mixed):
    point = G1Point(0, 2, CurveID.BLS12_381)
    if mixed:
        point = point.add(G1Point.get_nG(CurveID.BLS12_381, 1))
    with pytest.raises(ValueError, match="prime-order subgroup"):
        get_bls12_381_cofactor_hint(point)


def test_bls12_381_preimage_rejects_wrong_curve():
    with pytest.raises(ValueError, match="only for BLS12-381"):
        get_bls12_381_cofactor_hint(G1Point.get_nG(CurveID.BN254, 1))
