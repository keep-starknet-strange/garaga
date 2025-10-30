import random

import pytest

from garaga.curves import CURVES, CurveID, PairingCurve
from garaga.hints.ecip import verify_ecip, zk_ecip_hint
from garaga.points import G1Point, G2Point

# Define the curves to be tested
curves = list(CurveID)


@pytest.mark.parametrize("curve_id", curves)
@pytest.mark.parametrize("msm_size", range(1, 3))
def test_verify_ecip(curve_id, msm_size):
    curve = CURVES[curve_id.value]
    order = curve.n

    # Test for G1 points
    Bs_G1 = [G1Point.get_nG(curve_id, 1) for _ in range(msm_size)]
    scalars = [random.randint(1, order - 1) for _ in range(msm_size)]

    Q, sum_dlog = zk_ecip_hint(Bs_G1, scalars, use_rust=False)

    Q_rust, sum_dlog_rust = zk_ecip_hint(Bs_G1, scalars, use_rust=True)

    assert Q == Q_rust, f"Q: {Q}, \nQ_rust: {Q_rust}"
    assert (
        sum_dlog == sum_dlog_rust
    ), f"sum_dlog: {sum_dlog}, \nsum_dlog_rust: {sum_dlog_rust}"

    assert verify_ecip(Bs_G1, scalars, Q=Q_rust, sum_dlog=sum_dlog_rust)
    # Test for G2 points if the curve supports pairing
    if isinstance(CURVES[curve_id.value], PairingCurve):
        Bs_G2 = [G2Point.gen_random_point(curve_id) for _ in range(msm_size)]
        assert verify_ecip(Bs_G2, scalars)


@pytest.mark.parametrize("curve_id", curves)
@pytest.mark.parametrize("msm_size", range(0, 3))
def test_verify_ecip_edge_cases(curve_id, msm_size):
    curve = CURVES[curve_id.value]
    order = curve.n

    # Test for G1 points
    Bs_G1 = [G1Point.gen_random_point(curve_id) for _ in range(msm_size)] + [
        G1Point.infinity(curve_id)
    ]

    scalars = [0] + [random.randint(1, order - 1) for _ in range(msm_size)]
    assert verify_ecip(Bs_G1, scalars)

    # Test for G2 points if the curve supports pairing
    if isinstance(CURVES[curve_id.value], PairingCurve):
        Bs_G2 = [G2Point.gen_random_point(curve_id) for _ in range(msm_size)] + [
            G2Point.infinity(curve_id)
        ]
        assert verify_ecip(Bs_G2, scalars)


if __name__ == "__main__":
    pytest.main()
