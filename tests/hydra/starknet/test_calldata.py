import random

import pytest

from garaga.definitions import CURVES, CurveID, G1Point
from garaga.precompiled_circuits.multi_pairing_check import get_pairing_check_input
from garaga.starknet.tests_and_calldata_generators.mpcheck import MPCheckCalldataBuilder
from garaga.starknet.tests_and_calldata_generators.msm import MSMCalldataBuilder

# Define the curves to be tested
curves = list(CurveID)


@pytest.mark.parametrize("curve_id", [CurveID.BN254, CurveID.BLS12_381])
@pytest.mark.parametrize("mpc_size", [2, 3])
@pytest.mark.parametrize("n_fixed_g2", [2])
@pytest.mark.parametrize("include_m", [True, False])
def test_mpc_calldata_builder(
    curve_id,
    mpc_size,
    n_fixed_g2,
    include_m,
):
    pairs, public_pair = get_pairing_check_input(
        curve_id=curve_id,
        n_pairs=mpc_size,
        include_m=include_m,
        return_pairs=True,
    )

    mpc = MPCheckCalldataBuilder(
        curve_id=curve_id,
        pairs=pairs,
        n_fixed_g2=n_fixed_g2,
        public_pair=public_pair,
    )

    calldata1 = mpc.serialize_to_calldata(use_rust=False)

    calldata2 = mpc.serialize_to_calldata(use_rust=True)

    assert calldata1 == calldata2


@pytest.mark.parametrize("curve_id", curves)
@pytest.mark.parametrize("msm_size", [1, 2])
@pytest.mark.parametrize("include_digits_decomposition", [True, False])
@pytest.mark.parametrize("include_points_and_scalars", [True, False])
@pytest.mark.parametrize("serialize_as_pure_felt252_array", [True, False])
@pytest.mark.parametrize("risc0_mode", [True, False])
def test_msm_calldata_builder(
    curve_id,
    msm_size,
    include_digits_decomposition,
    include_points_and_scalars,
    serialize_as_pure_felt252_array,
    risc0_mode,
):
    curve = CURVES[curve_id.value]
    order = curve.n

    scalar_limit = min(order, 2**128) if risc0_mode else order

    points = [G1Point.gen_random_point(curve_id) for _ in range(msm_size)]
    scalars = [random.randint(0, scalar_limit - 1) for _ in range(msm_size)]

    msm = MSMCalldataBuilder(
        points=points,
        scalars=scalars,
        curve_id=curve_id,
        risc0_mode=risc0_mode,
    )

    calldata1 = msm.serialize_to_calldata(
        include_digits_decomposition=include_digits_decomposition,
        include_points_and_scalars=include_points_and_scalars,
        serialize_as_pure_felt252_array=serialize_as_pure_felt252_array,
        use_rust=False,
    )

    calldata2 = msm.serialize_to_calldata(
        include_digits_decomposition=include_digits_decomposition,
        include_points_and_scalars=include_points_and_scalars,
        serialize_as_pure_felt252_array=serialize_as_pure_felt252_array,
        use_rust=True,
    )

    assert calldata1 == calldata2


if __name__ == "__main__":
    pytest.main()
