from hydra.definitions import CURVES, CurveID, G1Point
from hydra.precompiled_circuits.multi_pairing_check import get_pairing_check_input
from tools.starknet.e2e_tests_writer.groth16 import groth16_calldata
from tools.starknet.e2e_tests_writer.msm import msm_calldata
from tools.starknet.e2e_tests_writer.pairing_check import pairing_check_calldata

if __name__ == "__main__":
    import random
    import subprocess

    random.seed(0)
    pairing_curve_ids = [CurveID.BN254, CurveID.BLS12_381]
    params = [2]

    pairing_test_header = """
    #[cfg(test)]
    mod pairing_tests {
        use garaga::pairing::{
            G1G2Pair, G1Point, G2Point, E12D, MillerLoopResultScalingFactor,
            multi_pairing_check_bn254_2_pairs, multi_pairing_check_bls12_381_2_pairs, u384,
            E12DMulQuotient
        };
    """
    with open("src/cairo/src/tests/pairing_tests.cairo", "w") as f:
        f.write(pairing_test_header)
        for curve_id in pairing_curve_ids:
            for n_pairs in params:
                print(
                    f"\n Generating pairing test for curve_id: {curve_id}, n_pairs: {n_pairs}"
                )
                pairs, _ = get_pairing_check_input(curve_id, n_pairs, return_pairs=True)
                input = pairing_check_calldata(pairs)
                f.write(
                    input.to_cairo1_test(
                        test_name=f"{curve_id.name}_mpcheck_{n_pairs}P"
                    )
                )
                f.write("\n")  # Add some spacing between tests
        f.write("}")
    subprocess.run(["scarb", "fmt"], check=True, cwd="src/cairo/src/tests/")

    groth16_test_header = """
    #[cfg(test)]
    mod groth16_tests {
        use garaga::groth16::{
            G1G2Pair, G1Point, G2Point, E12D, MillerLoopResultScalingFactor,
            multi_pairing_check_groth16_bn254,
            multi_pairing_check_groth16_bls12_381, u384,
            E12DMulQuotient, G2Line
        };
    """
    with open("src/cairo/src/tests/groth16_tests.cairo", "w") as f:
        f.write(groth16_test_header)
        for curve_id in pairing_curve_ids:
            print(f"\n Generating groth16 test for curve_id: {curve_id}")
            pairs, extra_pair = get_pairing_check_input(
                curve_id, n_pairs=3, include_m=True, return_pairs=True
            )
            input = groth16_calldata(pairs, extra_pair)
            f.write(input.to_cairo1_test())
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
    use garaga::ec_ops::{G1Point, FunctionFelt, u384, msm_g1};

"""
    with open("src/cairo/src/tests/msm_tests.cairo", "w") as f:
        f.write(msm_test_header)
        for curve_id in msm_curve_ids:
            for n_points in msm_sizes:
                print(
                    f"\nGenerating msm test for curve_id: {curve_id}, n_points: {n_points}"
                )
                input = msm_calldata(
                    points=[G1Point.gen_random_point(curve_id)] * n_points,
                    scalars=[
                        random.randint(0, CURVES[curve_id.value].n - 1)
                        for _ in range(n_points)
                    ],
                )
                f.write(
                    input.to_cairo1_test(
                        test_name=f"test_msm_{curve_id.name}_{n_points}_points"
                    )
                )
                f.write("\n")
        f.write("}")

    subprocess.run(["scarb", "fmt"], check=True, cwd="src/cairo/src/tests")
