import pytest
from hydra.definitions import CURVES, CurveID, G1Point, G2Point, PairingCurve
from hydra.hints.ecip import verify_ecip
import random

# Define the curves to be tested
curves = list(CurveID)


@pytest.mark.parametrize("curve_id", curves)
@pytest.mark.parametrize("msm_size", range(1, 6))
def test_verify_ecip(curve_id, msm_size):
    curve = CURVES[curve_id.value]
    order = curve.n

    # Test for G1 points
    Bs_G1 = [G1Point.gen_random_point(curve_id) for _ in range(msm_size)]
    scalars = [random.randint(1, order - 1) for _ in range(msm_size)]
    assert verify_ecip(Bs_G1, scalars)

    # Test for G2 points if the curve supports pairing
    if isinstance(CURVES[curve_id.value], PairingCurve):
        Bs_G2 = [G2Point.gen_random_point(curve_id) for _ in range(msm_size)]
        assert verify_ecip(Bs_G2, scalars)


if __name__ == "__main__":
    pytest.main()
