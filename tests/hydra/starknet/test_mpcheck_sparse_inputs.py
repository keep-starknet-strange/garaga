import pytest
from garaga.curves import CurveID
from garaga.points import G1G2Pair, G1Point, G2Point
from garaga.starknet.tests_and_calldata_generators.mpcheck import MPCheckCalldataBuilder


@pytest.mark.parametrize("curve_id", [CurveID.BN254, CurveID.BLS12_381])
@pytest.mark.parametrize("n_fixed_g2", [0, 1, 2])
def test_generator_cancellation_sparse_frobenius_calldata(curve_id, n_fixed_g2):
    p = G1Point.get_nG(curve_id, 1)
    q = G2Point.get_nG(curve_id, 1)
    builder = MPCheckCalldataBuilder(
        curve_id, [G1G2Pair(p, q), G1G2Pair(-p, q)], n_fixed_g2, None
    )
    assert builder.serialize_to_calldata(
        use_rust=True
    ) == builder.serialize_to_calldata(use_rust=False)
