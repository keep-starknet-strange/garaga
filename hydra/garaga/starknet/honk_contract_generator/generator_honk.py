import argparse
import hashlib
import json
import os
import subprocess
from pathlib import Path

from garaga.curves import CurveID, ProofSystem
from garaga.modulo_circuit_structs import G2Line, StructArray
from garaga.precompiled_circuits.compilable_circuits.base import (
    get_circuit_definition_impl_template,
)
from garaga.precompiled_circuits.compilable_circuits.ultra_honk import (
    ZKEvalsConsistencyDoneCircuit,
    ZKEvalsConsistencyInitCircuit,
    ZKEvalsConsistencyLoopCircuit,
    ZKPrepareScalarsCircuit,
    ZKSumCheckCircuit,
)
from garaga.precompiled_circuits.multi_miller_loop import precompute_lines
from garaga.precompiled_circuits.zk_honk import (
    G2_POINT_KZG_1,
    G2_POINT_KZG_2,
    MAX_LOG_N,
    PAIRING_POINT_OBJECT_LENGTH,
    G1Point,
    HonkVk,
)
from garaga.starknet.groth16_contract_generator.generator import (
    write_test_calldata_file_generic,
    write_verifier_files,
)


def gen_honk_verifier(
    vk: str | Path | HonkVk | bytes,
    output_folder_path: str,
    output_folder_name: str,
    cli_mode: bool = False,
    include_test_sample: bool = True,
    extra_test_code: str = "",
) -> bool:
    """
    Generate the honk verifier files and write them to the output folder.
    """
    output_folder_path_full = os.path.join(output_folder_path, output_folder_name)

    (
        constants_code,
        circuits_code,
        contract_code,
        contract_name,
        verification_function_name,
    ) = gen_honk_verifier_files(vk)
    _write_and_format_project_files(
        output_folder_path_full,
        output_folder_name,
        cli_mode,
        constants_code,
        circuits_code,
        contract_code,
        contract_name,
        verification_function_name,
        include_test_sample,
        extra_test_code,
    )
    return True


def gen_honk_verifier_files(
    vk: str | Path | HonkVk | bytes,
) -> tuple[str, str, str, str, str]:
    """
    Returns in this order:
    - constants_code
    - circuits_code
    - contract_code
    - contract_name
    - verification_function_name
    """
    # Parse vk
    if isinstance(vk, (Path, str)):
        vk = HonkVk.from_bytes(open(vk, "rb").read())
    elif isinstance(vk, bytes):
        vk = HonkVk.from_bytes(vk)
    else:
        assert isinstance(
            vk, HonkVk
        ), f"Invalid type for vk: {type(vk)}. Should be str, Path, HonkVk or bytes."

    constants_code = _gen_constants_code(vk)

    (
        circuits_code,
        sumcheck_function_name,
        prepare_scalars_function_name,
        consistency_function_names,
        scalar_indexes,
        msm_len,
        is_on_curve_function_name,
    ) = _gen_circuits_code(vk)

    points_code, (n_vk_points, n_proof_points) = _get_msm_points_array_code(vk)

    scalars_tuple = ",\n            ".join(f"scalar_{idx}" for idx in scalar_indexes)
    scalars_tuple_into = [f"scalar_{idx}" for idx in scalar_indexes]

    scalars_tuple_into.append("transcript.shplonk_z.into()")
    # Swap position of last two elements of scalars_tuple_into (KZG quotient & BN254 G1 generator) :
    scalars_tuple_into = scalars_tuple_into[:-2] + scalars_tuple_into[-2:][::-1]
    # Move first scalar after the first vk points [a, b, c, d, e] -> [b,c,d,a,e] if [b,c,d] are vk points:
    scalars_tuple_into = (
        scalars_tuple_into[1 : n_vk_points + 1]
        + scalars_tuple_into[:1]
        + scalars_tuple_into[n_vk_points + 1 :]
    )

    scalars_tuple_into = ",\n            ".join(scalars_tuple_into)

    # Generate contract header
    contract_name = "UltraKeccakZKHonkVerifier"
    verification_function_name = "verify_ultra_keccak_zk_honk_proof"
    contract_header = _gen_contract_header(
        function_names=[
            sumcheck_function_name,
            prepare_scalars_function_name,
            consistency_function_names[0],
            consistency_function_names[1],
            consistency_function_names[2],
            is_on_curve_function_name,
        ],
    )

    zero_checks = ""
    if vk.zero_commitment_indexes():
        zero_indexes = ", ".join(f"{i}_usize" for i in vk.zero_commitment_indexes())
        zero_checks = f"""
            // Zero VK commitments bind these polynomial evaluations to zero.
            for index in array![{zero_indexes}].span() {{
                if *full_proof.proof.sumcheck_evaluations.at(*index) != 0 {{
                    return Result::Err('Invalid zero selector eval');
                }};
            }};
        """

    contract_code = f"""{contract_header}
            {zero_checks}
            let (transcript, _, base_rlc) = ZKHonkTranscriptTrait::from_proof::<KeccakHasherState>(full_proof.proof, vk.vk_hash, vk.log_circuit_size);
            let log_n = vk.log_circuit_size;
            let (sum_check_rlc, honk_check) = {sumcheck_function_name}(
                p_public_inputs: full_proof.proof.public_inputs,
                p_pairing_point_object: full_proof.proof.pairing_point_object,
                libra_sum: u256_to_u384(full_proof.proof.libra_sum),
                sumcheck_univariates_flat: full_proof.proof.sumcheck_univariates.slice(0, log_n * ZK_BATCHED_RELATION_PARTIAL_LENGTH),
                sumcheck_evaluations: full_proof.proof.sumcheck_evaluations,
                libra_evaluation: u256_to_u384(full_proof.proof.libra_evaluation),
                tp_sum_check_u_challenges: transcript.sum_check_u_challenges.span(),
                tp_gate_challenge: transcript.gate_challenge,
                tp_eta_1: transcript.eta.into(),
                tp_rom_logup_gamma: transcript.rom_logup_gamma.into(),
                tp_beta: transcript.beta.into(),
                tp_gamma: transcript.gamma.into(),
                tp_base_rlc: base_rlc.into(),
                tp_alpha: transcript.alpha,
                tp_libra_challenge: transcript.libra_challenge.into(),
                modulus: mod_grumpkin,
            );

            let (mut challenge_poly_eval, mut root_power_times_tp_gemini_r) = {consistency_function_names[0]}(
                tp_gemini_r: transcript.gemini_r.into(),
                modulus: mod_grumpkin,
            );
            for i in 0..vk.log_circuit_size {{
                let (new_challenge_poly_eval, new_root_power_times_tp_gemini_r) = {consistency_function_names[1]}(
                    challenge_poly_eval: challenge_poly_eval,
                    root_power_times_tp_gemini_r: root_power_times_tp_gemini_r,
                    tp_sumcheck_u_challenge: (*transcript.sum_check_u_challenges.at(i)).into(),
                    modulus: mod_grumpkin,
                );
                challenge_poly_eval = new_challenge_poly_eval;
                root_power_times_tp_gemini_r = new_root_power_times_tp_gemini_r;
            }};
            let (vanishing_check, diff_check) = {consistency_function_names[2]}(
                p_libra_evaluation: u256_to_u384(full_proof.proof.libra_evaluation),
                p_libra_poly_evals: full_proof.proof.libra_poly_evals,
                tp_gemini_r: transcript.gemini_r.into(),
                challenge_poly_eval: challenge_poly_eval,
                root_power_times_tp_gemini_r: root_power_times_tp_gemini_r,
                modulus: mod_grumpkin,
            );

        let (
            {scalars_tuple},
        ) =
            {prepare_scalars_function_name}(
            p_sumcheck_evaluations: full_proof.proof.sumcheck_evaluations,
            p_gemini_masking_eval: u256_to_u384(full_proof.proof.gemini_masking_eval),
            p_gemini_a_evaluations: full_proof.proof.gemini_a_evaluations,
            p_libra_poly_evals: full_proof.proof.libra_poly_evals,
            tp_gemini_r: transcript.gemini_r.into(),
            tp_rho: transcript.rho.into(),
            tp_shplonk_z: transcript.shplonk_z.into(),
            tp_shplonk_nu: transcript.shplonk_nu.into(),
            tp_sum_check_u_challenges: transcript.sum_check_u_challenges.span().slice(0, log_n),
            modulus: mod_grumpkin,
        );

            {points_code}
            let mut scalars: Span<u384> = array![{scalars_tuple_into}].span();

            {_get_msm_kzg_template(msm_len, n_vk_points, n_proof_points, is_on_curve_function_name)}
            if sum_check_rlc.is_zero() && honk_check.is_zero() && !vanishing_check.is_zero() && diff_check.is_zero() && kzg_check.is_ok() {{
                return Result::Ok(full_proof.proof.public_inputs);
            }} else {{
                return Result::Err('Proof verification failed');
            }}
        }}
    }}
}}


    """
    return (
        constants_code,
        circuits_code,
        contract_code,
        contract_name,
        verification_function_name,
    )


def _get_msm_kzg_template(
    msm_size: int,
    n_vk_points: int,
    n_proof_points: int,
    is_on_curve_function_name: str,
):
    TEMPLATE = """\n
            // Check input points are on curve.
            // Skip the first {n_vk_points} points as they are from VK and keep the last {n_proof_points} proof points
            for point in points.slice({n_vk_points}, {n_proof_points}) {{
                assert({is_on_curve_function_name}(*point, mod_bn), 'proof point not on curve');
            }};

            // Assert shplonk_q is on curve
            let shplonk_q_pt:G1Point = full_proof.proof.shplonk_q.into();
            assert({is_on_curve_function_name}(shplonk_q_pt, mod_bn), 'shplonk_q not on curve');

            let mut msm_hint = full_proof.msm_hint;
            assert(msm_hint.len() == {msm_len} * 8, 'wrong glv&fakeglv hint size');

            let mut P_1 = shplonk_q_pt;
            while msm_hint.len() != 0 {{
                let pt = *points.pop_front().unwrap();
                let scalar = *scalars.pop_front().unwrap();
                // Circuit outputs and transcript challenges are reduced modulo the scalar field.
                let glv_fake_glv_hint: HonkScalarMulHint = Serde::deserialize(ref msm_hint).unwrap();
                // Zero precomputed polynomials have identity commitments in Barretenberg 6.
                if pt.is_infinity() {{
                    continue;
                }};
                let temp = honk_scalar_mul(pt, scalar, glv_fake_glv_hint);
                P_1 = _ec_safe_add(P_1, temp, mod_bn, 0);
            }}

            let P_2:G1Point = full_proof.proof.kzg_quotient.into();
            let (pairing_lhs, pairing_rhs) = aggregate_pairing_accumulator(
                full_proof.proof.pairing_point_object, P_1, P_2.negate(0), full_proof.recursion_hint,
            );

            // Perform the KZG pairing check.
            let kzg_check = multi_pairing_check_bn254_2P_2F(
               G1G2Pair {{ p: pairing_lhs, q: G2_POINT_KZG_1 }},
               G1G2Pair {{ p: pairing_rhs, q: G2_POINT_KZG_2 }},
               precomputed_lines.span(),
               full_proof.kzg_hint,
            );

        """.format(
        debug="{:?}",
        msm_len=msm_size,
        n_vk_points=n_vk_points,
        n_proof_points=n_proof_points,
        is_on_curve_function_name=is_on_curve_function_name,
    )
    return TEMPLATE


def _get_circuit_code_header():
    header = """
use core::circuit::{
    u384, circuit_add, circuit_sub, circuit_mul, circuit_inverse,
    CircuitInputs, CircuitModulus,
};
use garaga::core::circuit::{AddInputResultTrait2, CircuitOutputsTrait, EvalCircuitTrait, u288IntoCircuitInputValue};
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{G1Point};\n
"""
    return header


def _gen_circuits_code(vk: HonkVk) -> tuple[str, str, str, list[str], str, int, str]:
    """
    Generate the code for the sumcheck circuit and related circuits.

    Args:
        vk: The verifying key

    Returns:
        Tuple containing:
        - The generated code
        - Sumcheck function name
        - Prepare scalars function name
        - List of consistency function names
        - Scalar indexes
        - MSM length
        - Is on curve function name
    """
    code = _get_circuit_code_header()
    curve_id = CurveID.GRUMPKIN

    # Generate sumcheck circuit
    sumcheck_circuit = ZKSumCheckCircuit(vk)
    sumcheck_function_name = f"{curve_id.name}_{sumcheck_circuit.name.upper()}"
    sumcheck_code, sumcheck_function_name = sumcheck_circuit.circuit.compile_circuit(
        function_name=sumcheck_function_name, pub=True, generic_modulus=True
    )

    # Generate prepare scalars circuit
    prepare_scalars_circuit = ZKPrepareScalarsCircuit(vk)
    scalar_indexes = prepare_scalars_circuit.scalar_indexes
    msm_len = prepare_scalars_circuit.msm_len
    prepare_scalars_function_name = (
        f"{curve_id.name}_{prepare_scalars_circuit.name.upper()}"
    )
    prepare_scalars_code, prepare_scalars_function_name = (
        prepare_scalars_circuit.circuit.compile_circuit(
            function_name=prepare_scalars_function_name, pub=True, generic_modulus=True
        )
    )

    # Generate consistency circuits
    consistency_circuits = []
    for circuit_class in [
        ZKEvalsConsistencyInitCircuit,
        ZKEvalsConsistencyLoopCircuit,
        ZKEvalsConsistencyDoneCircuit,
    ]:
        circuit = circuit_class(vk)
        function_name = f"{curve_id.name}_{circuit.name.upper()}"
        circuit_code, function_name = circuit.circuit.compile_circuit(
            function_name=function_name, pub=True, generic_modulus=True
        )
        consistency_circuits.append((circuit_code, function_name))

    # Combine all circuit code
    code += sumcheck_code + prepare_scalars_code
    code += "".join(circuit_code for circuit_code, _ in consistency_circuits)
    code += get_circuit_definition_impl_template(len(scalar_indexes))

    is_on_curve_code = """
#[inline(never)]
pub fn is_on_curve_excluding_infinity_bn254(p: G1Point, modulus: CircuitModulus) -> bool {
    // INPUT stack
    // y^2 = x^3 + 3
    let (in0, in1) = (CE::<CI<0>> {}, CE::<CI<1>> {});
    let y2 = circuit_mul(in1, in1);
    let x2 = circuit_mul(in0, in0);
    let x3 = circuit_mul(in0, x2);
    let y2_minus_x3 = circuit_sub(y2, x3);

    let mut circuit_inputs = (y2_minus_x3,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x); // in0
    circuit_inputs = circuit_inputs.next_2(p.y); // in1

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let zero_check: u384 = outputs.get_output(y2_minus_x3);
    return zero_check == u384{limb0: 3, limb1: 0, limb2: 0, limb3: 0};
}
    """
    code += is_on_curve_code
    is_on_curve_function_name = "is_on_curve_excluding_infinity_bn254"

    return (
        code,
        sumcheck_function_name,
        prepare_scalars_function_name,
        [func_name for _, func_name in consistency_circuits],
        scalar_indexes,
        msm_len,
        is_on_curve_function_name,
    )


def _gen_contract_header(function_names: list[str]) -> str:
    """Generate the contract header and imports."""
    imports_str = ", ".join(function_names)
    header = f"""
use super::honk_verifier_constants::{{vk, precomputed_lines}};
use super::honk_verifier_circuits::{{{imports_str}}};

#[starknet::interface]
pub trait IUltraKeccakZKHonkVerifier<TContractState> {{
    fn verify_ultra_keccak_zk_honk_proof(
        self: @TContractState,
        full_proof_with_hints: Span<felt252>,
    ) -> Result<Span<u256>, felt252>;
}}

#[starknet::contract]
mod UltraKeccakZKHonkVerifier {{
    use garaga::definitions::{{G1Point, G1G2Pair, BN254, get_BN254_modulus, get_GRUMPKIN_modulus, u384}};
    use garaga::pairing_check::{{multi_pairing_check_bn254_2P_2F, MPCheckHintBN254}};
    use garaga::ec_ops::{{G1PointTrait, _ec_safe_add}};
    use super::{{vk, precomputed_lines, {imports_str}}};
    use garaga::apps::noir::{{ZKHonkProof, G2_POINT_KZG_1, G2_POINT_KZG_2, validate_zk_honk_proof, aggregate_pairing_accumulator, honk_scalar_mul, HonkScalarMulHint}};
    use garaga::apps::noir::zk_honk_transcript::{{Point256IntoCircuitPoint, KeccakHasherState, ZKHonkTranscriptTrait, ZK_BATCHED_RELATION_PARTIAL_LENGTH}};
    use garaga::core::circuit::{{U32IntoU384, u288IntoCircuitInputValue, U64IntoU384, u256_to_u384}};
    use core::num::traits::Zero;

    #[storage]
    struct Storage {{}}

    #[derive(Drop, Serde)]
    struct FullProof {{
        proof: ZKHonkProof,
        msm_hint: Span<felt252>,
        recursion_hint: Span<felt252>,
        kzg_hint:MPCheckHintBN254,
    }}

    #[abi(embed_v0)]
    impl IUltraKeccakZKHonkVerifier of super::IUltraKeccakZKHonkVerifier<ContractState> {{
        fn verify_ultra_keccak_zk_honk_proof(
            self: @ContractState,
            full_proof_with_hints: Span<felt252>,
        ) -> Result<Span<u256>, felt252> {{
            // DO NOT EDIT THIS FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING.
            // This function returns Result::Ok(public_inputs) if the proof is valid.
            // If the proof is invalid, it returns Result::Err(error).
            // Read the documentation to learn how to generate the full_proof_with_hints array given a proof and a verifying key.
            let mut full_proof_with_hints = full_proof_with_hints;
            let full_proof = Serde::<FullProof>::deserialize(ref full_proof_with_hints).expect('deserialization failed');
            if !full_proof_with_hints.is_empty() || !validate_zk_honk_proof(full_proof.proof, vk.log_circuit_size, vk.public_inputs_size) {{
                return Result::Err('Invalid Honk proof encoding');
            }};
            let mod_bn = get_BN254_modulus();
            let mod_grumpkin = get_GRUMPKIN_modulus();

"""
    return header


def _gen_constants_code(vk: HonkVk) -> str:
    """Generate the constants code for the contract."""
    lines = precompute_lines([G2_POINT_KZG_1, G2_POINT_KZG_2])
    precomputed_lines = StructArray(
        name="lines",
        elmts=[
            G2Line(name=f"line{i}", elmts=lines[i : i + 4])
            for i in range(0, len(lines), 4)
        ],
    )
    return f"""
use garaga::definitions::{{G1Point, G2Line, u384, u288}};
use garaga::apps::noir::HonkVk;

{vk.to_cairo()}\n
pub const precomputed_lines: [G2Line<u288>; {len(precomputed_lines)//4}] = {precomputed_lines.serialize(raw=True, const=True)};
"""


def _get_msm_points_array_code(vk: HonkVk) -> tuple[str, tuple[int, int]]:
    log_n = vk.log_circuit_size
    vk_points = [
        f"vk.{name}"
        for name in HonkVk.commitment_names()
        if not getattr(vk, name).is_infinity()
    ]

    next_proof_point_counter = 1
    proof_points = [
        f"full_proof.proof.gemini_masking_poly.into(), // Proof point {next_proof_point_counter}"
    ]
    next_proof_point_counter += 1

    proof_points += [
        f"full_proof.proof.w1.into(), // Proof point {next_proof_point_counter}",
        f"full_proof.proof.w2.into(), // Proof point {next_proof_point_counter+1}",
        f"full_proof.proof.w3.into(), // Proof point {next_proof_point_counter+2}",
        f"full_proof.proof.w4.into(), // Proof point {next_proof_point_counter+3}",
        f"full_proof.proof.z_perm.into(), // Proof point {next_proof_point_counter+4}",
        f"full_proof.proof.lookup_inverses.into(), // Proof point {next_proof_point_counter+5}",
        f"full_proof.proof.lookup_read_counts.into(), // Proof point {next_proof_point_counter+6}",
        f"full_proof.proof.lookup_read_tags.into(), // Proof point {next_proof_point_counter+7}",
    ]
    next_proof_point_counter += 8

    # Combine all points
    all_points = vk_points + proof_points

    points_str = ",\n".join(all_points)
    code = "// Starts with 1 * shplonk_q, not included in msm\n"
    code += f"""            let mut _points: Array<G1Point> = array![{points_str}\n];

            for gem_comm in full_proof.proof.gemini_fold_comms {{
                _points.append((*gem_comm).into());
            }}; // log_n -1 = {log_n-1} points || Proof points {next_proof_point_counter}-{next_proof_point_counter+(log_n-1) - 1}"""
    next_proof_point_counter += log_n - 1
    # Add ZK-specific commitments
    code += f"""
            for lib_comm in full_proof.proof.libra_commitments {{
                _points.append((*lib_comm).into());
            }};// 3 points || Proof points {next_proof_point_counter}-{next_proof_point_counter+3-1}"""
    next_proof_point_counter += 3
    # Add common final points
    code += f"""
            _points.append(full_proof.proof.kzg_quotient.into()); // Proof point {next_proof_point_counter}
            _points.append(BN254.G);

            let mut points = _points.span();"""

    proof_point_counter = next_proof_point_counter

    n_vk_points = len(vk_points)

    return code, (n_vk_points, proof_point_counter)


def _write_and_format_project_files(
    output_folder_path: str,
    output_folder_name: str,
    cli_mode: bool,
    constants_code: str,
    circuits_code: str,
    contract_code: str,
    contract_name: str,
    verification_function_name: str,
    include_test_sample: bool = True,
    extra_test_code: str = "",
):
    # Use the reusable function to write all files
    write_verifier_files(
        output_folder_path,
        output_folder_name,
        constants_code,
        contract_code,
        contract_name,
        verification_function_name,
        ProofSystem.UltraKeccakZKHonk,
        cli_mode,
        circuits_code=circuits_code,
        modules=["honk_verifier", "honk_verifier_constants", "honk_verifier_circuits"],
        constants_filename="honk_verifier_constants.cairo",
        contract_filename="honk_verifier.cairo",
        circuits_filename="honk_verifier_circuits.cairo",
        include_test_sample=include_test_sample,
        extra_test_code=extra_test_code,
    )
    # This threshold reduces both gas and bytecode compared with the generic setting.
    manifest = Path(output_folder_path, "Scarb.toml")
    manifest.write_text(
        manifest.read_text().replace("inlining-strategy = 2", "inlining-strategy = 50")
    )


def write_noir_test_fixtures(vk: HonkVk, proof, directory="src/src/apps/noir"):
    """Regenerate Cairo fixtures and transcript vectors from the committed proof bundle."""
    from pathlib import Path

    from garaga.precompiled_circuits.zk_honk import ZKHonkTranscript

    transcript = ZKHonkTranscript.from_proof(vk, proof)
    vk_value = vk.to_cairo().split(" = ", 1)[1].removesuffix(";")
    proof_value = proof.to_cairo().removesuffix(";")
    expected = transcript.to_cairo()
    code = f"""// Generated by make rewrite from the Barretenberg proof bundle.
use super::{{HonkVk, ZKHonkProof, G1Point256}};
use super::zk_honk_transcript::ZKHonkTranscript;
use garaga::definitions::{{G1Point, u384}};

pub fn get_vk() -> HonkVk {{ {vk_value} }}
pub fn get_zk_proof_keccak() -> ZKHonkProof {{ {proof_value} }}
pub fn get_expected_transcript() -> ZKHonkTranscript {{ {expected} }}
"""
    path = Path(directory, "test_fixtures.cairo")
    path.write_text(code)
    subprocess.run(["scarb", "fmt", str(path)], check=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate HONK verifier contracts")
    parser.add_argument(
        "--max-log-n",
        action="store_true",
        help="Generate contracts with maximum log N size",
    )
    args = parser.parse_args()

    VK_PATH = (
        "hydra/garaga/starknet/honk_contract_generator/examples/vk_ultra_keccak.bin"
    )

    CONTRACTS_FOLDER = "src/contracts/autogenerated/"  # Do not change this
    EXAMPLES_FOLDER = "hydra/garaga/starknet/honk_contract_generator/examples"

    if not args.max_log_n:
        import json

        from garaga.precompiled_circuits.zk_honk import ZKHonkProof

        manifest = json.loads(Path(EXAMPLES_FOLDER, "noir_artifacts.json").read_text())
        vectors = []
        for case, metadata in manifest["cases"].items():
            files = {
                name: Path(EXAMPLES_FOLDER, value["path"])
                for name, value in metadata["files"].items()
            }
            folder = (
                "noir_ultra_keccak_zk_honk_example"
                if case == "hello"
                else f"noir_ultra_keccak_zk_honk_{case}"
            )
            from garaga.starknet.honk_contract_generator.test_templates import (
                release_tests,
            )

            public_bytes = files["public_inputs"].read_bytes()
            public_inputs = [
                int.from_bytes(public_bytes[i : i + 32], "big")
                for i in range(0, len(public_bytes), 32)
            ]
            gen_honk_verifier(
                files["vk"],
                CONTRACTS_FOLDER,
                folder,
                extra_test_code=release_tests(
                    public_inputs,
                    HonkVk.from_bytes(
                        files["vk"].read_bytes()
                    ).zero_commitment_indexes(),
                ),
            )
            fixture_vk = HonkVk.from_bytes(files["vk"].read_bytes())
            fixture_proof = ZKHonkProof.from_bytes(
                files["proof"].read_bytes(),
                files["public_inputs"].read_bytes(),
                fixture_vk,
            )
            if case == "hello":
                write_noir_test_fixtures(fixture_vk, fixture_proof)
            write_test_calldata_file_generic(
                os.path.join(CONTRACTS_FOLDER, folder),
                ProofSystem.UltraKeccakZKHonk,
                files["vk"],
                files["proof"],
                files["public_inputs"],
            )
            words = (
                Path(CONTRACTS_FOLDER, folder, "tests/proof_calldata.txt")
                .read_text()
                .split()
            )
            calldata = [len(words), *[int(word, 0) for word in words]]
            vectors.append(
                {
                    "case": case,
                    "files": {
                        name: path.read_bytes().hex()
                        for name, path in files.items()
                        if name != "vk_hash"
                    },
                    "length": len(calldata),
                    "sha256": hashlib.sha256(
                        "\n".join(map(str, calldata)).encode()
                    ).hexdigest(),
                }
            )
            print(f"Generated verifier and calldata for {case}")
        Path(EXAMPLES_FOLDER, "noir_calldata_test_vectors.json").write_text(
            json.dumps(vectors, indent=2) + "\n"
        )

    if args.max_log_n:
        # Synthetic capacity case: exercise every relation family at the maximum log size.
        # This key measures bytecode size; it has no corresponding proof.
        vk = HonkVk.from_bytes(open(VK_PATH, "rb").read())
        vk.log_circuit_size = MAX_LOG_N
        vk.public_inputs_size = 4 + PAIRING_POINT_OBJECT_LENGTH
        for index, name in enumerate(HonkVk.commitment_names(), start=1):
            setattr(vk, name, G1Point.get_nG(CurveID.BN254, index))

        gen_honk_verifier(
            vk,
            CONTRACTS_FOLDER,
            "ultra_keccak_zk_honk_max_log_n",
        )
