import argparse
import os
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

    points_code, (n_vk_points, n_proof_points) = _get_msm_points_array_code(
        log_n=vk.log_circuit_size
    )

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

    contract_code = f"""{contract_header}
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
                tp_eta_2: transcript.eta_two.into(),
                tp_eta_3: transcript.eta_three.into(),
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
            assert(msm_hint.len() == {msm_len} * 12, 'wrong glv&fakeglv hint size');
            let eigen = get_eigenvalue(0);
            let third_root_of_unity = get_third_root_of_unity(0);
            let min_one = get_min_one_order(0);
            let nG = get_nG_glv_fake_glv(0);

            let mut P_1 = shplonk_q_pt;
            while msm_hint.len() != 0 {{
                let pt = *points.pop_front().unwrap();
                let scalar = *scalars.pop_front().unwrap();
                // Note : Scalars are below curve order by construction (circuit outputs mod n and transcript output (u128))
                let glv_fake_glv_hint: GlvFakeGlvHint = Serde::deserialize(ref msm_hint).unwrap();
                let temp = _scalar_mul_glv_and_fake_glv(
                    pt,
                    scalar,
                    mod_grumpkin,
                    mod_bn,
                    glv_fake_glv_hint,
                    eigen,
                    third_root_of_unity,
                    min_one,
                    nG,
                    0,
                );
                P_1 = _ec_safe_add(P_1, temp, mod_bn, 0);
            }}

            let P_2:G1Point = full_proof.proof.kzg_quotient.into();

            // Perform the KZG pairing check.
            let kzg_check = multi_pairing_check_bn254_2P_2F(
               G1G2Pair {{ p: P_1, q: G2_POINT_KZG_1 }},
               G1G2Pair {{ p: P_2.negate(0), q: G2_POINT_KZG_2 }},
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
    EvalCircuitTrait, CircuitOutputsTrait, CircuitInputs, CircuitModulus,
};
use garaga::core::circuit::{AddInputResultTrait2, u288IntoCircuitInputValue};
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
    use garaga::definitions::{{G1Point, G1G2Pair, BN254, get_BN254_modulus, get_GRUMPKIN_modulus, u384, get_eigenvalue, get_third_root_of_unity, get_min_one_order, get_nG_glv_fake_glv}};
    use garaga::pairing_check::{{multi_pairing_check_bn254_2P_2F, MPCheckHintBN254}};
    use garaga::ec_ops::{{G1PointTrait, _ec_safe_add, _scalar_mul_glv_and_fake_glv, GlvFakeGlvHint}};
    use super::{{vk, precomputed_lines, {imports_str}}};
    use garaga::apps::noir::{{ZKHonkProof, G2_POINT_KZG_1, G2_POINT_KZG_2}};
    use garaga::apps::noir::zk_honk_transcript::{{Point256IntoCircuitPoint, KeccakHasherState, ZKHonkTranscriptTrait, ZK_BATCHED_RELATION_PARTIAL_LENGTH}};
    use garaga::core::circuit::{{U32IntoU384, u288IntoCircuitInputValue, U64IntoU384, u256_to_u384}};
    use core::num::traits::Zero;

    #[storage]
    struct Storage {{}}

    #[derive(Drop, Serde)]
    struct FullProof {{
        proof: ZKHonkProof,
        msm_hint: Span<felt252>,
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
pub const precomputed_lines: [G2Line; {len(precomputed_lines)//4}] = {precomputed_lines.serialize(raw=True, const=True)};
"""


def _get_msm_points_array_code(log_n: int) -> tuple[str, tuple[int, int]]:
    vk_points = [
        "vk.qm",
        "vk.qc",
        "vk.ql",
        "vk.qr",
        "vk.qo",
        "vk.q4",
        "vk.qLookup",
        "vk.qArith",
        "vk.qDeltaRange",
        "vk.qElliptic",
        "vk.qMemory",
        "vk.qNnf",
        "vk.qPoseidon2External",
        "vk.qPoseidon2Internal",
        "vk.s1",
        "vk.s2",
        "vk.s3",
        "vk.s4",
        "vk.id1",
        "vk.id2",
        "vk.id3",
        "vk.id4",
        "vk.t1",
        "vk.t2",
        "vk.t3",
        "vk.t4",
        "vk.lagrange_first",
        "vk.lagrange_last",
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
    )


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
        FOLDER_NAME = "noir_ultra_keccak_zk_honk_example"

        gen_honk_verifier(
            VK_PATH,
            CONTRACTS_FOLDER,
            FOLDER_NAME,
        )

        # Generate calldata
        output_folder_path = os.path.join(CONTRACTS_FOLDER, FOLDER_NAME)
        proof_file = os.path.join(EXAMPLES_FOLDER, "proof_ultra_keccak_zk.bin")
        public_inputs_file = os.path.join(
            EXAMPLES_FOLDER, "public_inputs_ultra_keccak.bin"
        )

        if os.path.exists(proof_file) and os.path.exists(public_inputs_file):
            try:
                write_test_calldata_file_generic(
                    output_folder_path,
                    ProofSystem.UltraKeccakZKHonk,
                    VK_PATH,
                    proof_file,
                    public_inputs_file,
                )
                print(f"Generated calldata for {FOLDER_NAME}")
            except Exception as e:
                print(f"Error generating calldata for {FOLDER_NAME}: {e}")
                raise e
        else:
            print(f"Warning: Proof or public inputs file not found for {FOLDER_NAME}")

    if args.max_log_n:
        # NOTE : each additional public input increase bytecode by ~ 21 felts.
        #       each additional circuit size increase bytecode by ~ 372 felts.
        vk = HonkVk.from_bytes(open(VK_PATH, "rb").read())
        vk.log_circuit_size = MAX_LOG_N
        vk.public_inputs_size = 4 + PAIRING_POINT_OBJECT_LENGTH

        gen_honk_verifier(
            vk,
            CONTRACTS_FOLDER,
            "ultra_keccak_zk_honk_max_log_n",
        )
