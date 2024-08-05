from hydra.definitions import CURVES, CurveID, G1Point
from hydra.precompiled_circuits.multi_pairing_check import get_pairing_check_input
from tools.starknet.e2e_tests_writer.msm import MSMCalldataBuilder
from tools.starknet.e2e_tests_writer.mpcheck import MPCheckCalldataBuilder

import random
import subprocess


def write_all_tests():
    random.seed(0)
    pairing_curve_ids = [CurveID.BN254, CurveID.BLS12_381]
    params = [(2, 2, False), (3, 2, True)]

    pairing_test_header = """
    #[cfg(test)]
    mod pairing_tests {
        use garaga::pairing_check::{
            G1G2Pair, G1Point, G2Point, G2Line, E12D, MillerLoopResultScalingFactor,
            multi_pairing_check_bn254_2P_2F,
            multi_pairing_check_bls12_381_2P_2F,
            u384,
            E12DMulQuotient,
            MPCheckHintBN254,
            MPCheckHintBLS12_381
        };
        use garaga::groth16::{
            multi_pairing_check_bn254_3P_2F_with_extra_miller_loop_result,
            multi_pairing_check_bls12_381_3P_2F_with_extra_miller_loop_result,
        };
    """
    with open("src/cairo/src/tests/pairing_tests.cairo", "w") as f:
        f.write(pairing_test_header)
        for curve_id in pairing_curve_ids:
            for n_pairs, n_fixed_g2, include_m in params:
                print(
                    f"\n Generating pairing test for curve_id: {curve_id}, n_pairs: {n_pairs}, include_m: {include_m}"
                )
                pairs, public_pair = get_pairing_check_input(
                    curve_id=curve_id,
                    n_pairs=n_pairs,
                    include_m=include_m,
                    return_pairs=True,
                )
                builder = MPCheckCalldataBuilder(
                    curve_id=curve_id,
                    pairs=pairs,
                    n_fixed_g2=n_fixed_g2,
                    public_pair=public_pair,
                )
                f.write(builder.to_cairo_1_test())
                f.write("\n")  # Add some spacing between tests
        f.write("}")
    subprocess.run(["scarb", "fmt"], check=True, cwd="src/cairo/src/tests/")

    msm_curve_ids = [
        CurveID.BN254,
        CurveID.BLS12_381,
        CurveID.SECP256R1,
        CurveID.SECP256K1,
        CurveID.ED25519,
    ]

    msm_sizes = [1, 2, 3, 4, 5, 6, 7, 8]

    msm_test_header = """
#[cfg(test)]
mod msm_tests {
    use garaga::ec_ops::{G1Point, FunctionFelt, u384, msm_g1, MSMHint, DerivePointFromXHint};

"""
    with open("src/cairo/src/tests/msm_tests.cairo", "w") as f:
        f.write(msm_test_header)
        for curve_id in msm_curve_ids:
            for n_points in msm_sizes:
                print(
                    f"\nGenerating msm test for curve_id: {curve_id}, n_points: {n_points}"
                )
                builder = MSMCalldataBuilder(
                    curve_id=curve_id,
                    points=[
                        G1Point.gen_random_point(curve_id) for _ in range(n_points)
                    ],
                    scalars=[
                        random.randint(0, CURVES[curve_id.value].n)
                        for _ in range(n_points)
                    ],
                )
                f.write(builder.to_cairo_1_test())
                f.write("\n")
        f.write("}")

    subprocess.run(["scarb", "fmt"], check=True, cwd="src/cairo/src/tests")


if __name__ == "__main__":
    write_all_tests()
