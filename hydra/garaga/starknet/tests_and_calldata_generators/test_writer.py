import concurrent.futures
import random
import subprocess

import garaga.modulo_circuit_structs as structs
from garaga.definitions import (
    CURVES,
    CurveID,
    G1G2Pair,
    G1Point,
    G2Point,
    get_base_field,
)
from garaga.precompiled_circuits.multi_pairing_check import get_pairing_check_input
from garaga.starknet.cli.utils import create_directory
from garaga.starknet.tests_and_calldata_generators.mpcheck import MPCheckCalldataBuilder
from garaga.starknet.tests_and_calldata_generators.msm import MSMCalldataBuilder

TESTS_DIR = "src/src/tests"


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
        points=[G1Point.gen_random_point(curve_id) for _ in range(n_points - 1)]
        + [G1Point.infinity(curve_id)],
        scalars=[0]
        + [random.randint(0, CURVES[curve_id.value].n) for _ in range(n_points - 1)],
    )
    return builder.to_cairo_1_test()


def generate_msm_test_edge_cases(curve_id, n_points, seed):
    random.seed(seed)
    builder = MSMCalldataBuilder(
        curve_id=curve_id,
        points=[G1Point.gen_random_point(curve_id) for _ in range(n_points - 1)]
        + [G1Point.infinity(curve_id)],
        scalars=[0]
        + [random.randint(0, CURVES[curve_id.value].n) for _ in range(n_points - 1)],
    )
    return builder.to_cairo_1_test(
        test_name=f"test_msm_{curve_id.name}_{n_points}P_edge_case"
    )


def generate_tower_pairing_test(curve_id, n_pairs, seed):
    random.seed(seed)
    pairs: list[G1G2Pair]
    if n_pairs == 1:
        pairs = [
            G1G2Pair(
                p=G1Point.get_nG(curve_id, 1),
                q=G2Point.get_nG(curve_id, 1),
            )
        ]
    else:
        pairs, _ = get_pairing_check_input(
            curve_id=curve_id, n_pairs=n_pairs, return_pairs=True
        )

    res = G1G2Pair.pair(pairs, curve_id)
    res = res.felt_coeffs
    e12t = structs.E12T(name="expected_result", elmts=res)
    i_s = list(range(n_pairs))
    code = f"""
#[test]
fn test_tower_pairing_{curve_id.name}_{n_pairs}P() {{
    let mut res:E12T = E12TOne::one();
"""
    for i, pair in enumerate(pairs):
        code += f"""
    {structs.G1PointCircuit.from_G1Point(f"p{i}", pair.p).serialize()}
    p{i}.assert_on_curve({curve_id.value});
    {structs.G2PointCircuit.from_G2Point(f"q{i}", pair.q).serialize()}
    q{i}.assert_on_curve({curve_id.value});
    let (tmp{i}) = miller_loop_{pair.p.curve_id.name.lower()}_tower(p{i}, q{i});
    let (res) = run_{pair.p.curve_id.name.upper()}_E12T_MUL_circuit(tmp{i}, res);"""
    code += f"""
    let final = final_exp_{curve_id.name.lower()}_tower(res);
    assert_eq!(final, {e12t.serialize(raw=True)});
}}
"""
    return code


def generate_tower_final_exp_test(curve_id, seed):
    from garaga.hints.tower_backup import E12

    random.seed(seed)
    field = get_base_field(curve_id)
    elmts = [field.random() for _ in range(12)]
    e12 = E12(elmts, curve_id.value)
    e12t = structs.E12T(name="input", elmts=elmts)
    cofactor = CURVES[curve_id.value].final_exp_cofactor
    h = cofactor * (CURVES[curve_id.value].p ** 12 - 1) // CURVES[curve_id.value].n
    expected = structs.E12T(name="expected", elmts=(e12**h).felt_coeffs)
    code = f"""
#[test]
fn test_tower_final_exp_{curve_id.name}() {{
    {e12t.serialize()}
    let res = final_exp_{curve_id.name.lower()}_tower(input);
    assert_eq!(res, {expected.serialize(raw=True)});
}}
"""
    return code


def generate_expt_half_test(curve_id, seed):
    from garaga.hints.tower_backup import E12

    random.seed(seed)
    field = get_base_field(curve_id)
    elmts = [field.random() for _ in range(12)]

    e12 = E12(elmts, curve_id.value)
    # Simulate easy part :
    p = CURVES[curve_id.value].p
    e12 = e12 ** ((p**6 - 1) * (p**2 + 1))
    e12t = structs.E12T(name="input", elmts=e12.felt_coeffs)

    h = 7566188111470821376

    expected_tower = e12**h
    assert expected_tower.conjugate() == expected_tower.__inv__()
    expected = structs.E12T(
        name="expected", elmts=expected_tower.conjugate().felt_coeffs
    )
    code = f"""
#[test]
fn test_expt_half_{curve_id.name}() {{
    {e12t.serialize()}
    let (res) = expt_half_{curve_id.name.lower()}_tower(input);
    assert_eq!(res, {expected.serialize(raw=True)});
}}
"""
    return code


def write_all_tests():
    create_directory(TESTS_DIR)
    random.seed(0)
    pairing_curve_ids = [CurveID.BN254, CurveID.BLS12_381]

    tower_pairing_test_header = """
#[cfg(test)]
mod tower_pairing_tests {
    use garaga::single_pairing_tower::{
        E12TOne, u384,G1Point, G2Point, E12T, miller_loop_bls12_381_tower, miller_loop_bn254_tower, final_exp_bls12_381_tower, final_exp_bn254_tower, expt_half_bls12_381_tower
    };
    use garaga::ec_ops::{G1PointImpl};
    use garaga::ec_ops_g2::{G2PointImpl};
    use garaga::circuits::tower_circuits::{run_BN254_E12T_MUL_circuit, run_BLS12_381_E12T_MUL_circuit};
"""

    with open(f"{TESTS_DIR}/tower_pairing_tests.cairo", "w") as f:
        f.write(tower_pairing_test_header)
        with concurrent.futures.ProcessPoolExecutor() as executor:
            pairing_futures = [
                executor.submit(generate_tower_pairing_test, curve_id, n_pairs, 0)
                for curve_id in pairing_curve_ids
                for n_pairs in [1, 2, 3]
            ]
            final_exp_futures = [
                executor.submit(generate_tower_final_exp_test, curve_id, 0)
                for curve_id in pairing_curve_ids
            ]
            expt_half_futures = [
                executor.submit(generate_expt_half_test, curve_id, 0)
                for curve_id in [CurveID.BLS12_381]
            ]
            all_futures = pairing_futures + final_exp_futures + expt_half_futures
            results = [future.result() for future in all_futures]

            for result in results:
                f.write(result)
                f.write("\n")
        f.write("}")
    subprocess.run(["scarb", "fmt"], check=True, cwd=f"{TESTS_DIR}")
    params = [(2, 2, False), (3, 2, True)]

    pairing_test_header = """
    #[cfg(test)]
    mod pairing_tests {
        use garaga::pairing_check::{
            G1G2Pair, G1Point, G2Point, G2Line, E12D, MillerLoopResultScalingFactor,
            multi_pairing_check_bn254_2P_2F,
            multi_pairing_check_bls12_381_2P_2F,
            u384,
            MPCheckHintBN254,
            MPCheckHintBLS12_381,
            u288,
        };
        use garaga::groth16::{
            E12DMulQuotient,
            multi_pairing_check_bn254_3P_2F_with_extra_miller_loop_result,
            multi_pairing_check_bls12_381_3P_2F_with_extra_miller_loop_result,
        };
    """
    with open(f"{TESTS_DIR}/pairing_tests.cairo", "w") as f:
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
    subprocess.run(["scarb", "fmt"], check=True, cwd=f"{TESTS_DIR}")

    msm_curve_ids = [
        CurveID.BN254,
        CurveID.BLS12_381,
        CurveID.SECP256R1,
        CurveID.SECP256K1,
        CurveID.ED25519,
        CurveID.GRUMPKIN,
    ]

    msm_sizes = [1, 2, 3, 4, 10, 11, 12]

    msm_test_header = """
#[cfg(test)]
mod msm_tests {
    use garaga::ec_ops::{G1Point, FunctionFelt, u384, msm_g1, MSMHint, DerivePointFromXHint};

"""
    with open(f"{TESTS_DIR}/msm_tests.cairo", "w") as f:
        f.write(msm_test_header)
        with concurrent.futures.ProcessPoolExecutor() as executor:
            futures = [
                executor.submit(generate_msm_test, curve_id, n_points, 0)
                for curve_id in msm_curve_ids
                for n_points in msm_sizes
            ]
            futures.extend(
                [
                    executor.submit(generate_msm_test_edge_cases, curve_id, n_points, 0)
                    for curve_id in msm_curve_ids
                    for n_points in [1, 2, 3]
                ]
            )
            results = [future.result() for future in futures]
            for result in results:
                f.write(result)
                f.write("\n")
        f.write("}")

    subprocess.run(["scarb", "fmt"], check=True, cwd=f"{TESTS_DIR}")


if __name__ == "__main__":
    import time

    start = time.time()
    write_all_tests()
    end = time.time()
    print(f"Time taken: {end - start} seconds")
