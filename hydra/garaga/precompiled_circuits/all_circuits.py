from enum import Enum

from garaga.definitions import CurveID
from garaga.precompiled_circuits.compilable_circuits.base import (
    cairo1_tests_header,
    compilation_mode_to_file_header,
    compile_circuit,
    format_cairo_files_in_parallel,
)
from garaga.precompiled_circuits.compilable_circuits.cairo1_mpcheck_circuits import (
    EvalE12D,
    FixedG2MPCheckBit0,
    FixedG2MPCheckBit00,
    FixedG2MPCheckBit1,
    FixedG2MPCheckFinalizeBN,
    FixedG2MPCheckInitBit,
    FP12MulAssertOne,
    MPCheckFinalizeBLS,
    MPCheckPrepareLambdaRootEvaluations,
    MPCheckPreparePairs,
)
from garaga.precompiled_circuits.compilable_circuits.common_cairo_fustat_circuits import (
    AccumulateEvalPointChallengeSignedCircuit,
    AccumulateFunctionChallengeDuplCircuit,
    AddECPointCircuit,
    DoubleECPointCircuit,
    DummyCircuit,
    EvalFunctionChallengeDuplCircuit,
    FinalizeFunctionChallengeDuplCircuit,
    InitFunctionChallengeDuplCircuit,
    IsOnCurveG1Circuit,
    IsOnCurveG1G2Circuit,
    IsOnCurveG2Circuit,
    RHSFinalizeAccCircuit,
    SlopeInterceptSamePointCircuit,
)


class CircuitID(Enum):
    DUMMY = int.from_bytes(b"dummy", "big")
    FP12_MUL = int.from_bytes(b"fp12_mul", "big")
    FP12_SUB = int.from_bytes(b"fp12_sub", "big")
    FINAL_EXP_PART_1 = int.from_bytes(b"final_exp_part_1", "big")
    FINAL_EXP_PART_2 = int.from_bytes(b"final_exp_part_2", "big")
    MULTI_MILLER_LOOP = int.from_bytes(b"multi_miller_loop", "big")
    MULTI_PAIRING_CHECK = int.from_bytes(b"multi_pairing_check", "big")
    IS_ON_CURVE_G1_G2 = int.from_bytes(b"is_on_curve_g1_g2", "big")
    IS_ON_CURVE_G1 = int.from_bytes(b"is_on_curve_g1", "big")
    IS_ON_CURVE_G2 = int.from_bytes(b"is_on_curve_g2", "big")
    DERIVE_POINT_FROM_X = int.from_bytes(b"derive_point_from_x", "big")
    SLOPE_INTERCEPT_SAME_POINT = int.from_bytes(b"slope_intercept_same_point", "big")
    ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED = int.from_bytes(
        b"acc_eval_point_challenge", "big"
    )
    RHS_FINALIZE_ACC = int.from_bytes(b"rhs_finalize_acc", "big")
    EVAL_FUNCTION_CHALLENGE_DUPL = int.from_bytes(
        b"eval_function_challenge_dupl", "big"
    )
    INIT_FUNCTION_CHALLENGE_DUPL = int.from_bytes(
        b"init_function_challenge_dupl", "big"
    )
    ACC_FUNCTION_CHALLENGE_DUPL = int.from_bytes(b"acc_function_challenge_dupl", "big")
    FINALIZE_FUNCTION_CHALLENGE_DUPL = int.from_bytes(
        b"finalize_function_challenge_dupl", "big"
    )
    ADD_EC_POINT = int.from_bytes(b"add_ec_point", "big")
    DOUBLE_EC_POINT = int.from_bytes(b"double_ec_point", "big")
    MP_CHECK_BIT0_LOOP = int.from_bytes(b"mp_check_bit0_loop", "big")
    MP_CHECK_BIT00_LOOP = int.from_bytes(b"mp_check_bit00_loop", "big")
    MP_CHECK_BIT1_LOOP = int.from_bytes(b"mp_check_bit1_loop", "big")
    MP_CHECK_PREPARE_PAIRS = int.from_bytes(b"mp_check_prepare_pairs", "big")
    MP_CHECK_PREPARE_LAMBDA_ROOT = int.from_bytes(
        b"mp_check_prepare_lambda_root", "big"
    )
    MP_CHECK_INIT_BIT = int.from_bytes(b"mp_check_init_bit", "big")
    MP_CHECK_FINALIZE_BN = int.from_bytes(b"mp_check_finalize_bn", "big")
    MP_CHECK_FINALIZE_BLS = int.from_bytes(b"mp_check_finalize_bls", "big")
    FP12_MUL_ASSERT_ONE = int.from_bytes(b"fp12_mul_assert_one", "big")
    EVAL_E12D = int.from_bytes(b"eval_e12d", "big")


ALL_CAIRO_CIRCUITS = {
    CircuitID.DUMMY: {"class": DummyCircuit, "params": None, "filename": "dummy"},
    CircuitID.IS_ON_CURVE_G1_G2: {
        "class": IsOnCurveG1G2Circuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.IS_ON_CURVE_G1: {
        "class": IsOnCurveG1Circuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.IS_ON_CURVE_G2: {
        "class": IsOnCurveG2Circuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.SLOPE_INTERCEPT_SAME_POINT: {
        "class": SlopeInterceptSamePointCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED: {
        "class": AccumulateEvalPointChallengeSignedCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.RHS_FINALIZE_ACC: {
        "class": RHSFinalizeAccCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.EVAL_FUNCTION_CHALLENGE_DUPL: {
        "class": EvalFunctionChallengeDuplCircuit,
        "params": [{"n_points": k} for k in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]],
        "filename": "ec",
    },
    CircuitID.INIT_FUNCTION_CHALLENGE_DUPL: {
        "class": InitFunctionChallengeDuplCircuit,
        "params": [{"n_points": k} for k in [11]],
        "filename": "ec",
    },
    CircuitID.ACC_FUNCTION_CHALLENGE_DUPL: {
        "class": AccumulateFunctionChallengeDuplCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.FINALIZE_FUNCTION_CHALLENGE_DUPL: {
        "class": FinalizeFunctionChallengeDuplCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.ADD_EC_POINT: {
        "class": AddECPointCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.DOUBLE_EC_POINT: {
        "class": DoubleECPointCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.MP_CHECK_BIT0_LOOP: {
        "class": FixedG2MPCheckBit0,
        "params": [
            {"n_pairs": 2, "n_fixed_g2": 2},  # BLS SIG / KZG Verif
            {"n_pairs": 3, "n_fixed_g2": 2},  # Groth16
        ],
        "filename": "multi_pairing_check",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
    CircuitID.MP_CHECK_BIT00_LOOP: {
        "class": FixedG2MPCheckBit00,
        "params": [
            {"n_pairs": 2, "n_fixed_g2": 2},  # BLS SIG / KZG Verif
            {"n_pairs": 3, "n_fixed_g2": 2},  # Groth16
        ],
        "filename": "multi_pairing_check",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
    CircuitID.MP_CHECK_BIT1_LOOP: {
        "class": FixedG2MPCheckBit1,
        "params": [
            {"n_pairs": 2, "n_fixed_g2": 2},  # BLS SIG / KZG Verif
            {"n_pairs": 3, "n_fixed_g2": 2},  # Groth16
        ],
        "filename": "multi_pairing_check",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
    CircuitID.MP_CHECK_PREPARE_PAIRS: {
        "class": MPCheckPreparePairs,
        "params": [{"n_pairs": k} for k in [1, 2, 3]],
        "filename": "multi_pairing_check",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
    CircuitID.MP_CHECK_PREPARE_LAMBDA_ROOT: {
        "class": MPCheckPrepareLambdaRootEvaluations,
        "params": None,
        "filename": "multi_pairing_check",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
    CircuitID.MP_CHECK_INIT_BIT: {
        "class": FixedG2MPCheckInitBit,
        "params": [
            {"n_pairs": 2, "n_fixed_g2": 2},  # BLS SIG / KZG Verif
            {"n_pairs": 3, "n_fixed_g2": 2},  # Groth16
        ],
        "filename": "multi_pairing_check",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
    CircuitID.MP_CHECK_FINALIZE_BN: {
        "class": FixedG2MPCheckFinalizeBN,
        "params": [
            {"n_pairs": 2, "n_fixed_g2": 2},  # BLS SIG / KZG Verif
            {"n_pairs": 3, "n_fixed_g2": 2},  # Groth16
        ],
        "filename": "multi_pairing_check",
        "curve_ids": [CurveID.BN254],
    },
    CircuitID.MP_CHECK_FINALIZE_BLS: {
        "class": MPCheckFinalizeBLS,
        "params": [{"n_pairs": k} for k in [2, 3]],
        "filename": "multi_pairing_check",
        "curve_ids": [CurveID.BLS12_381],
    },
    CircuitID.FP12_MUL_ASSERT_ONE: {
        "class": FP12MulAssertOne,
        "params": None,
        "filename": "extf_mul",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
    CircuitID.EVAL_E12D: {
        "class": EvalE12D,
        "params": None,
        "filename": "extf_mul",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
}


def main(
    PRECOMPILED_CIRCUITS_DIR: str,
    CIRCUITS_TO_COMPILE: dict[CircuitID, dict],
    compilation_mode: int = 1,
):
    """Compiles and writes all circuits to .cairo files"""

    # Ensure the 'codes' dict keys match the filenames used for file creation.
    # Using sets to remove potential duplicates
    filenames_used = set([v["filename"] for v in CIRCUITS_TO_COMPILE.values()])
    codes = {filename: set() for filename in filenames_used}
    cairo1_tests_functions = {filename: set() for filename in filenames_used}
    cairo1_full_function_names = {filename: set() for filename in filenames_used}

    files = {
        f: open(f"{PRECOMPILED_CIRCUITS_DIR}{f}.cairo", "w") for f in filenames_used
    }

    # Write the header to each file
    HEADER = compilation_mode_to_file_header(compilation_mode)

    for file in files.values():
        file.write(HEADER)

    # Instantiate and compile circuits for each curve

    for circuit_id, circuit_info in CIRCUITS_TO_COMPILE.items():
        for curve_id in circuit_info.get(
            "curve_ids", [CurveID.BN254, CurveID.BLS12_381]
        ):
            filename_key = circuit_info["filename"]
            compiled_circuits, full_function_names = compile_circuit(
                curve_id,
                circuit_info["class"],
                circuit_info["params"],
                compilation_mode,
                cairo1_tests_functions,
                filename_key,
            )
            codes[filename_key].update(compiled_circuits)
            if compilation_mode == 1:

                cairo1_full_function_names[filename_key].update(full_function_names)

    # Write selector functions and compiled circuit codes to their respective files
    print("Writing circuits and selectors to .cairo files...")
    for filename in filenames_used:
        if filename in files:
            # Write the compiled circuit codes
            for compiled_circuit in sorted(codes[filename]):
                files[filename].write(compiled_circuit + "\n")

            if compilation_mode == 1:
                files[filename].write(cairo1_tests_header() + "\n")
                fns_to_import = sorted(cairo1_full_function_names[filename])
                if "" in fns_to_import:
                    fns_to_import.remove("")
                files[filename].write(f"use super::{{{','.join(fns_to_import)}}};\n")
                for cairo1_test in sorted(cairo1_tests_functions[filename]):
                    files[filename].write(cairo1_test + "\n")
                files[filename].write("}\n")

        else:
            print(f"Warning: No file associated with filename '{filename}'")

    # Close all files
    for file in files.values():
        file.close()

    format_cairo_files_in_parallel(
        filenames_used, compilation_mode, PRECOMPILED_CIRCUITS_DIR
    )
    return None


if __name__ == "__main__":
    import random

    random.seed(0)
    print("Compiling Cairo 1 circuits...")
    main(
        PRECOMPILED_CIRCUITS_DIR="src/src/circuits/",
        CIRCUITS_TO_COMPILE=ALL_CAIRO_CIRCUITS,
        compilation_mode=1,
    )
