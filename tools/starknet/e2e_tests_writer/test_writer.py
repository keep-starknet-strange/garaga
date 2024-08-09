import concurrent.futures
import random
import subprocess

from hydra.definitions import CURVES, CurveID, G1Point
from hydra.precompiled_circuits.multi_pairing_check import get_pairing_check_input
from tools.make.utils import create_directory
from tools.starknet.e2e_tests_writer.mpcheck import MPCheckCalldataBuilder
from tools.starknet.e2e_tests_writer.msm import MSMCalldataBuilder


def generate_pairing_test(curve_id, n_pairs, n_fixed_g2, include_m, seed):
    random.seed(seed)
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
    return builder.to_cairo_1_test()


def generate_msm_test(curve_id, n_points, seed):
    random.seed(seed)
    builder = MSMCalldataBuilder(
        curve_id=curve_id,
        points=[G1Point.gen_random_point(curve_id) for _ in range(n_points)],
        scalars=[random.randint(0, CURVES[curve_id.value].n) for _ in range(n_points)],
    )
    return builder.to_cairo_1_test()


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
    create_directory("src/cairo/src/tests")
    with open("src/cairo/src/tests/pairing_tests.cairo", "w") as f:
        f.write(pairing_test_header)
        with concurrent.futures.ProcessPoolExecutor() as executor:
            futures = [
                executor.submit(
                    generate_pairing_test,
                    curve_id,
                    n_pairs,
                    n_fixed_g2,
                    include_m,
                    0,
                )
                for curve_id in pairing_curve_ids
                for n_pairs, n_fixed_g2, include_m in params
            ]
            results = [future.result() for future in futures]
            for result in results:
                f.write(result)
                f.write("\n")
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
        with concurrent.futures.ProcessPoolExecutor() as executor:
            futures = [
                executor.submit(generate_msm_test, curve_id, n_points, 0)
                for curve_id in msm_curve_ids
                for n_points in msm_sizes
            ]
            results = [future.result() for future in futures]
            for result in results:
                f.write(result)
                f.write("\n")
        f.write("}")

    subprocess.run(["scarb", "fmt"], check=True, cwd="src/cairo/src/tests")


if __name__ == "__main__":
    import time

    start = time.time()
    write_all_tests()
    end = time.time()
    print(f"Time taken: {end - start} seconds")
