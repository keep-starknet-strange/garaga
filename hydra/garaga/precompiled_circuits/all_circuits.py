from enum import Enum
from pathlib import Path

from garaga.definitions import CurveID
from garaga.precompiled_circuits.compilable_circuits.apply_isogeny import (
    ApplyIsogenyCircuit,
)
from garaga.precompiled_circuits.compilable_circuits.base import (
    cairo1_tests_header,
    compilation_mode_to_file_header,
    compile_circuit,
    create_cairo1_test,
    format_cairo_files_in_parallel,
)
from garaga.precompiled_circuits.compilable_circuits.cairo1_mpcheck_circuits import (
    EvalE12D,
    FixedG2MPCheckBit0,
    FixedG2MPCheckBit00,
    FixedG2MPCheckBit1,
    FixedG2MPCheckBit01,
    FixedG2MPCheckBit10,
    FixedG2MPCheckFinalizeBN,
    FixedG2MPCheckInitBit,
    FP12MulAssertOne,
    MPCheckFinalizeBLS,
    MPCheckPrepareLambdaRootEvaluations,
    MPCheckPreparePairs,
)
from garaga.precompiled_circuits.compilable_circuits.cairo1_tower_pairing import (
    E12TCyclotomicSquareCircuit,
    E12TCyclotomicSquareCompressedCircuit,
    E12TDecompressKarabinaPtIICircuit,
    E12TDecompressKarabinaPtINZCircuit,
    E12TDecompressKarabinaPtIZCircuit,
    E12TFrobeniusCircuit,
    E12TFrobeniusCubeCircuit,
    E12TFrobeniusSquareCircuit,
    E12TInverseCircuit,
    E12TMulCircuit,
    FP6NegCircuit,
    TowerMillerBit0,
    TowerMillerBit1,
    TowerMillerFinalizeBN,
    TowerMillerInitBit,
)
from garaga.precompiled_circuits.compilable_circuits.common_cairo_fustat_circuits import (
    AddECPointCircuit,
    AddECPointsG2Circuit,
    ClearCofactorBLS12_381Circuit,
    DoubleECPointCircuit,
    DoubleECPointG2AEq0Circuit,
    DummyCircuit,
    IsOnCurveG1Circuit,
    IsOnCurveG1G2Circuit,
    IsOnCurveG2Circuit,
    PrepareFakeGLVPtsCircuit,
    PrepareGLVFakeGLVPtsCircuit,
    QuadrupleAndAdd9Circuit,
)
from garaga.starknet.cli.utils import create_directory

STARKNET_DIR = Path(__file__).parent.parent / "starknet"


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
    CLEAR_COFACTOR_BLS12_381 = int.from_bytes(b"clear_cofactor_bls12_381", "big")
    ADD_EC_POINT = int.from_bytes(b"add_ec_point", "big")
    DOUBLE_EC_POINT = int.from_bytes(b"double_ec_point", "big")
    PREPARE_GLV_FAKE_GLV_PTS = int.from_bytes(b"prepare_glv_fake_glv_pts", "big")
    PREPARE_FAKE_GLV_PTS = int.from_bytes(b"prepare_fake_glv_pts", "big")
    QUADRUPLE_AND_ADD_9 = int.from_bytes(b"quadruple_and_add_9", "big")
    MP_CHECK_BIT0_LOOP = int.from_bytes(b"mp_check_bit0_loop", "big")
    MP_CHECK_BIT00_LOOP = int.from_bytes(b"mp_check_bit00_loop", "big")
    MP_CHECK_BIT1_LOOP = int.from_bytes(b"mp_check_bit1_loop", "big")
    MP_CHECK_BIT01_LOOP = int.from_bytes(b"mp_check_bit01_loop", "big")
    MP_CHECK_BIT10_LOOP = int.from_bytes(b"mp_check_bit10_loop", "big")
    MP_CHECK_PREPARE_PAIRS = int.from_bytes(b"mp_check_prepare_pairs", "big")
    MP_CHECK_PREPARE_LAMBDA_ROOT = int.from_bytes(
        b"mp_check_prepare_lambda_root", "big"
    )
    MP_CHECK_INIT_BIT = int.from_bytes(b"mp_check_init_bit", "big")
    MP_CHECK_FINALIZE_BN = int.from_bytes(b"mp_check_finalize_bn", "big")
    MP_CHECK_FINALIZE_BLS = int.from_bytes(b"mp_check_finalize_bls", "big")
    FP12_MUL_ASSERT_ONE = int.from_bytes(b"fp12_mul_assert_one", "big")
    EVAL_E12D = int.from_bytes(b"eval_e12d", "big")
    APPLY_ISOGENY = int.from_bytes(b"apply_isogeny", "big")
    HONK_SUMCHECK_CIRCUIT = int.from_bytes(b"honk_sumcheck_circuit", "big")
    HONK_PREPARE_SCALARS_CIRCUIT = int.from_bytes(
        b"honk_prepare_scalars_circuit", "big"
    )
    TOWER_MILLER_BIT0 = int.from_bytes(b"tower_miller_bit0", "big")
    TOWER_MILLER_BIT1 = int.from_bytes(b"tower_miller_bit1", "big")
    TOWER_MILLER_INIT_BIT = int.from_bytes(b"tower_miller_init_bit", "big")
    TOWER_MILLER_FINALIZE_BN = int.from_bytes(b"tower_miller_finalize_bn", "big")
    E12T_MUL = int.from_bytes(b"e12t_mul", "big")
    E12T_CYCLOTOMIC_SQUARE = int.from_bytes(b"e12t_cyclotomic_square", "big")
    E12T_FROBENIUS_SQUARE = int.from_bytes(b"e12t_frobenius_square", "big")
    FP6_NEG = int.from_bytes(b"fp6_neg", "big")
    E12T_INVERSE = int.from_bytes(b"e12t_inverse", "big")
    E12T_FROBENIUS = int.from_bytes(b"e12t_frobenius", "big")
    E12T_FROBENIUS_CUBE = int.from_bytes(b"e12t_frobenius_cube", "big")
    E12T_CYCLOTOMIC_SQUARE_COMPRESSED = int.from_bytes(
        b"e12t_cyclotomic_square_compressed", "big"
    )
    E12T_DECOMPRESS_KARABINA_PT_INZ = int.from_bytes(
        b"e12t_decompress_karabina_pt_inz", "big"
    )
    E12T_DECOMPRESS_KARABINA_PT_IZ = int.from_bytes(
        b"e12t_decompress_karabina_pt_iz", "big"
    )
    E12T_DECOMPRESS_KARABINA_PT_II = int.from_bytes(
        b"e12t_decompress_karabina_pt_ii", "big"
    )
    ADD_EC_POINT_G2 = int.from_bytes(b"add_ec_point_g2", "big")
    DOUBLE_EC_POINT_G2 = int.from_bytes(b"double_ec_point_g2", "big")
    FULL_ECIP_BATCHED = int.from_bytes(b"full_ecip__batched", "big")


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
    CircuitID.CLEAR_COFACTOR_BLS12_381: {
        "class": ClearCofactorBLS12_381Circuit,
        "params": None,
        "filename": "ec",
        "curve_ids": [CurveID.BLS12_381],
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
    CircuitID.PREPARE_GLV_FAKE_GLV_PTS: {
        "class": PrepareGLVFakeGLVPtsCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.PREPARE_FAKE_GLV_PTS: {
        "class": PrepareFakeGLVPtsCircuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.QUADRUPLE_AND_ADD_9: {
        "class": QuadrupleAndAdd9Circuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.ADD_EC_POINT_G2: {
        "class": AddECPointsG2Circuit,
        "params": None,
        "filename": "ec",
    },
    CircuitID.DOUBLE_EC_POINT_G2: {
        "class": DoubleECPointG2AEq0Circuit,
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
        "curve_ids": [CurveID.BLS12_381],
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
        "curve_ids": [CurveID.BLS12_381],
    },
    CircuitID.MP_CHECK_BIT01_LOOP: {
        "class": FixedG2MPCheckBit01,
        "params": [
            {"n_pairs": 2, "n_fixed_g2": 2},  # BLS SIG / KZG Verif
            {"n_pairs": 3, "n_fixed_g2": 2},  # Groth16
        ],
        "filename": "multi_pairing_check",
        "curve_ids": [CurveID.BN254],
    },
    CircuitID.MP_CHECK_BIT10_LOOP: {
        "class": FixedG2MPCheckBit10,
        "params": [
            {"n_pairs": 2, "n_fixed_g2": 2},  # BLS SIG / KZG Verif
            {"n_pairs": 3, "n_fixed_g2": 2},  # Groth16
        ],
        "filename": "multi_pairing_check",
        "curve_ids": [CurveID.BN254],
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
    CircuitID.APPLY_ISOGENY: {
        "class": ApplyIsogenyCircuit,
        "params": None,
        "filename": "isogeny",
        "curve_ids": [CurveID.BLS12_381],
    },
    CircuitID.TOWER_MILLER_BIT0: {
        "class": TowerMillerBit0,
        "params": [{"n_pairs": k} for k in [1]],
        "filename": "tower_circuits",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
    CircuitID.TOWER_MILLER_BIT1: {
        "class": TowerMillerBit1,
        "params": [{"n_pairs": k} for k in [1]],
        "filename": "tower_circuits",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
    CircuitID.TOWER_MILLER_INIT_BIT: {
        "class": TowerMillerInitBit,
        "params": [{"n_pairs": k} for k in [1]],
        "filename": "tower_circuits",
        "curve_ids": [CurveID.BLS12_381],
    },
    CircuitID.TOWER_MILLER_FINALIZE_BN: {
        "class": TowerMillerFinalizeBN,
        "params": None,
        "filename": "tower_circuits",
        "curve_ids": [CurveID.BN254],
    },
    CircuitID.E12T_MUL: {
        "class": E12TMulCircuit,
        "params": None,
        "filename": "tower_circuits",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
    CircuitID.E12T_CYCLOTOMIC_SQUARE: {
        "class": E12TCyclotomicSquareCircuit,
        "params": None,
        "filename": "tower_circuits",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
    CircuitID.E12T_FROBENIUS_SQUARE: {
        "class": E12TFrobeniusSquareCircuit,
        "params": None,
        "filename": "tower_circuits",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
    CircuitID.FP6_NEG: {
        "class": FP6NegCircuit,
        "params": None,
        "filename": "tower_circuits",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
    CircuitID.E12T_INVERSE: {
        "class": E12TInverseCircuit,
        "params": None,
        "filename": "tower_circuits",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
    CircuitID.E12T_FROBENIUS: {
        "class": E12TFrobeniusCircuit,
        "params": None,
        "filename": "tower_circuits",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
    CircuitID.E12T_FROBENIUS_CUBE: {
        "class": E12TFrobeniusCubeCircuit,
        "params": None,
        "filename": "tower_circuits",
        "curve_ids": [CurveID.BN254, CurveID.BLS12_381],
    },
    CircuitID.E12T_CYCLOTOMIC_SQUARE_COMPRESSED: {
        "class": E12TCyclotomicSquareCompressedCircuit,
        "params": None,
        "filename": "tower_circuits",
        "curve_ids": [CurveID.BLS12_381],
    },
    CircuitID.E12T_DECOMPRESS_KARABINA_PT_INZ: {
        "class": E12TDecompressKarabinaPtINZCircuit,
        "params": None,
        "filename": "tower_circuits",
        "curve_ids": [CurveID.BLS12_381],
    },
    CircuitID.E12T_DECOMPRESS_KARABINA_PT_IZ: {
        "class": E12TDecompressKarabinaPtIZCircuit,
        "params": None,
        "filename": "tower_circuits",
        "curve_ids": [CurveID.BLS12_381],
    },
    CircuitID.E12T_DECOMPRESS_KARABINA_PT_II: {
        "class": E12TDecompressKarabinaPtIICircuit,
        "params": None,
        "filename": "tower_circuits",
        "curve_ids": [CurveID.BLS12_381],
    },
    # CircuitID.HONK_SUMCHECK_CIRCUIT: {
    #     "class": SumCheckCircuit,
    #     "params": [
    #         {
    #             "vk": HonkVk.from_bytes(
    #                 open(
    #                     f"{STARKNET_DIR}/honk_contract_generator/examples/vk_ultra_keccak.bin",
    #                     "rb",
    #                 ).read()
    #             )
    #         }
    #     ],
    #     "filename": "honk_circuits",
    #     "curve_ids": [CurveID.GRUMPKIN],
    # },
    # CircuitID.HONK_PREPARE_SCALARS_CIRCUIT: {
    #     "class": PrepareScalarsCircuit,
    #     "params": [
    #         {
    #             "vk": HonkVk.from_bytes(
    #                 open(
    #                     f"{STARKNET_DIR}/honk_contract_generator/examples/vk_ultra_keccak.bin",
    #                     "rb",
    #                 ).read()
    #             )
    #         }
    #     ],
    #     "filename": "honk_circuits",
    #     "curve_ids": [CurveID.GRUMPKIN],
    # },
    # CircuitID.FULL_ECIP_BATCHED: {
    #     "class": FullECIPCircuitBatched,
    #     "params": [{"n_points": k} for k in [1]],
    #     "filename": "ec_batched",
    #     "curve_ids": [CurveID.BN254],
    # },
}


def initialize_compilation(
    PRECOMPILED_CIRCUITS_DIR: str, CIRCUITS_TO_COMPILE: dict
) -> tuple[
    set[str],
    dict[str, set[str]],
    dict[str, set[str]],
    dict[str, set[str]],
    dict[str, open],
]:
    """
    Initialize the compilation process by creating the necessary directories and files.
    Returns :
        - filenames_used: set of all filenames that will be used
        - codes: dict of sets of strings, where each set contains the compiled circuits for a given filename
        - cairo1_tests_functions: dict of sets of strings, where each set contains the cairo1 tests for a given filename
        - cairo1_full_function_names: dict of sets of strings, where each set contains the full function names for a given filename
        - files: dict of open files, where each file is for a given filename
    """
    create_directory(PRECOMPILED_CIRCUITS_DIR)
    filenames_used = set([v["filename"] for v in CIRCUITS_TO_COMPILE.values()])
    codes = {filename: set() for filename in filenames_used}
    cairo1_tests_functions = {filename: set() for filename in filenames_used}
    cairo1_full_function_names = {filename: set() for filename in filenames_used}
    files = {
        f: open(f"{PRECOMPILED_CIRCUITS_DIR}{f}.cairo", "w") for f in filenames_used
    }
    return (
        filenames_used,
        codes,
        cairo1_tests_functions,
        cairo1_full_function_names,
        files,
    )


def write_headers(
    files: dict[str, open],
    compilation_mode: int,
    output_sizes_exceeding_limit: dict[str, set[int]],
    file_curve_ids: dict[str, set[CurveID]],
) -> None:
    """
    Write the header to the files. Add a specific header if max output length exceeds the limit.
    """

    for filename, curve_ids in file_curve_ids.items():
        HEADER = compilation_mode_to_file_header(compilation_mode, curve_ids)
        files[filename].write(HEADER)

    TEMPLATE = """
impl CircuitDefinition{num_outputs}<
    {elements}
> of core::circuit::CircuitDefinition<
    (
        {ce_elements}
    )
> {{
    type CircuitType =
        core::circuit::Circuit<
            ({elements_tuple},)
        >;
}}
impl MyDrp_{num_outputs}<
    {elements}
> of Drop<
    (
        {ce_elements}
    )
>;
"""

    for filename, file in files.items():

        # Then write the template for each unique output size exceeding the limit
        for num_outputs in sorted(output_sizes_exceeding_limit[filename]):
            elements = ", ".join(f"E{i}" for i in range(num_outputs))
            ce_elements = ", ".join(f"CE<E{i}>" for i in range(num_outputs))
            elements_tuple = ", ".join(f"E{i}" for i in range(num_outputs))
            file.write(
                TEMPLATE.format(
                    num_outputs=num_outputs,
                    elements=elements,
                    ce_elements=ce_elements,
                    elements_tuple=elements_tuple,
                )
            )


def compile_circuits(
    CIRCUITS_TO_COMPILE: dict,
    compilation_mode: int,
    codes: dict[str, set[str]],
    cairo1_full_function_names: dict[str, set[str]],
    cairo1_tests_functions: dict[str, set[str]],
    output_sizes_exceeding_limit: dict[str, set[int]],
    limit: int,
) -> None:
    """
    Compile the circuits and write them to the files.
    """
    for circuit_id, circuit_info in CIRCUITS_TO_COMPILE.items():
        for curve_id in circuit_info.get(
            "curve_ids", [CurveID.BN254, CurveID.BLS12_381]
        ):
            filename_key = circuit_info["filename"]
            compiled_circuits, full_function_names, circuit_instances = compile_circuit(
                curve_id,
                circuit_info["class"],
                circuit_info["params"],
                compilation_mode,
            )
            codes[filename_key].update(compiled_circuits)
            for circuit_instance in circuit_instances:
                output_length = len(circuit_instance.circuit.output)
                if (
                    output_length > limit
                    and circuit_instance.circuit.exact_output_refs_needed is None
                ):
                    output_sizes_exceeding_limit[filename_key].add(output_length)

            if compilation_mode == 1:
                cairo1_full_function_names[filename_key].update(full_function_names)
                generate_cairo1_tests(
                    circuit_instances,
                    full_function_names,
                    curve_id,
                    cairo1_tests_functions,
                    filename_key,
                )


def generate_cairo1_tests(
    circuit_instances,
    full_function_names,
    curve_id,
    cairo1_tests_functions,
    filename_key,
):
    for circuit_instance, full_function_name in zip(
        circuit_instances, full_function_names
    ):
        circuit_input = circuit_instance.full_input_cairo1
        circuit_output = (
            circuit_instance.circuit.output_structs
            if sum([len(x.elmts) for x in circuit_instance.circuit.output_structs])
            == len(circuit_instance.circuit.output)
            else circuit_instance.circuit.output
        )
        cairo1_tests_functions[filename_key].add(
            create_cairo1_test(
                full_function_name,
                circuit_input,
                circuit_output,
                curve_id.value,
            )
        )


def write_compiled_circuits(
    files: dict[str, open],
    codes: dict[str, set[str]],
    cairo1_full_function_names: dict[str, set[str]],
    cairo1_tests_functions: dict[str, set[str]],
    compilation_mode: int,
) -> None:
    """
    Write the compiled circuits and the cairo1 tests to the files.
    """
    print("Writing circuits and selectors to .cairo files...")
    for filename, file in files.items():
        for compiled_circuit in sorted(codes[filename]):
            file.write(compiled_circuit + "\n")

        # if compilation_mode == 1:
        #     write_cairo1_tests(
        #         file, filename, cairo1_full_function_names, cairo1_tests_functions
        #     )


def write_cairo1_tests(
    file: open,
    filename: str,
    cairo1_full_function_names: dict[str, set[str]],
    cairo1_tests_functions: dict[str, set[str]],
) -> None:
    file.write(cairo1_tests_header() + "\n")
    fns_to_import = sorted(cairo1_full_function_names[filename])
    if "" in fns_to_import:
        fns_to_import.remove("")
    file.write(f"use super::{{{','.join(fns_to_import)}}};\n")
    for cairo1_test in sorted(cairo1_tests_functions[filename]):
        file.write(cairo1_test + "\n")
    file.write("}\n")


def main(
    PRECOMPILED_CIRCUITS_DIR: str,
    CIRCUITS_TO_COMPILE: dict[CircuitID, dict],
    compilation_mode: int = 1,
):
    """Compiles and writes all circuits to .cairo files"""
    filenames_used, codes, cairo1_tests_functions, cairo1_full_function_names, files = (
        initialize_compilation(PRECOMPILED_CIRCUITS_DIR, CIRCUITS_TO_COMPILE)
    )
    file_curve_ids = {filename: set() for filename in filenames_used}

    # Populate file_curve_ids with curve IDs
    for circuit_info in CIRCUITS_TO_COMPILE.values():
        filename = circuit_info["filename"]
        curve_ids = circuit_info.get("curve_ids", [CurveID.BN254, CurveID.BLS12_381])
        file_curve_ids[filename].update(curve_ids)

    output_sizes_exceeding_limit = {filename: set() for filename in filenames_used}
    limit = 16
    compile_circuits(
        CIRCUITS_TO_COMPILE,
        compilation_mode,
        codes,
        cairo1_full_function_names,
        cairo1_tests_functions,
        output_sizes_exceeding_limit,
        limit,
    )
    write_headers(files, compilation_mode, output_sizes_exceeding_limit, file_curve_ids)
    write_compiled_circuits(
        files,
        codes,
        cairo1_full_function_names,
        cairo1_tests_functions,
        compilation_mode,
    )

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
