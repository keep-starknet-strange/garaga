import os
import subprocess
from pathlib import Path

from garaga.definitions import CurveID, ProofSystem
from garaga.modulo_circuit_structs import G2Line, StructArray
from garaga.precompiled_circuits.compilable_circuits.base import (
    get_circuit_definition_impl_template,
)
from garaga.precompiled_circuits.compilable_circuits.common_cairo_fustat_circuits import (
    EvalFunctionChallengeSingleCircuit,
)
from garaga.precompiled_circuits.compilable_circuits.ultra_honk import (
    PrepareScalarsCircuit,
    SumCheckCircuit,
    ZKEvalsConsistencyDoneCircuit,
    ZKEvalsConsistencyInitCircuit,
    ZKEvalsConsistencyLoopCircuit,
    ZKPrepareScalarsCircuit,
    ZKSumCheckCircuit,
)
from garaga.precompiled_circuits.honk import (
    CONST_PROOF_SIZE_LOG_N,
    G2_POINT_KZG_1,
    G2_POINT_KZG_2,
    HonkVk,
)
from garaga.precompiled_circuits.multi_miller_loop import precompute_lines
from garaga.starknet.cli.utils import create_directory
from garaga.starknet.groth16_contract_generator.generator import (
    CAIRO_VERSION,
    get_scarb_toml_file,
)


def gen_honk_verifier(
    vk: str | Path | HonkVk | bytes,
    output_folder_path: str,
    output_folder_name: str,
    system: ProofSystem = ProofSystem.UltraKeccakZKHonk,
    cli_mode: bool = False,
) -> str:
    match system:
        case ProofSystem.UltraKeccakHonk | ProofSystem.UltraStarknetHonk:
            return _gen_honk_verifier(
                vk, output_folder_path, output_folder_name, system, cli_mode
            )
        case ProofSystem.UltraKeccakZKHonk | ProofSystem.UltraStarknetZKHonk:
            return _gen_zk_honk_verifier(
                vk, output_folder_path, output_folder_name, system, cli_mode
            )
        case _:
            raise ValueError(f"Proof system {system} not compatible")


def get_msm_kzg_template(msm_size: int, lhs_ecip_function_name: str):
    TEMPLATE = """\n
            full_proof.msm_hint_batched.RLCSumDlogDiv.validate_degrees_batched({msm_len});
            // HASHING: GET ECIP BASE RLC COEFF.
            // TODO : RE-USE transcript to avoid re-hashing G1 POINTS.
            let (s0, s1, s2): (felt252, felt252, felt252) = hades_permutation(
                'MSM_G1', 0, 1
            ); // Init Sponge state
            let (s0, s1, s2) = hades_permutation(
                s0 + 0.into(), s1 + {msm_len}.into(), s2
            ); // Include curve_index and msm size

            let mut s0 = s0;
            let mut s1 = s1;
            let mut s2 = s2;

            // Check input points are on curve and hash them at the same time.

            for point in points {{
                if !point.is_infinity() {{
                    point.assert_on_curve(0);
                }}
                let (_s0, _s1, _s2) = point.update_hash_state(s0, s1, s2);
                s0 = _s0;
                s1 = _s1;
                s2 = _s2;
            }};

            if !full_proof.msm_hint_batched.Q_low.is_infinity() {{
                full_proof.msm_hint_batched.Q_low.assert_on_curve(0);
            }}
            if !full_proof.msm_hint_batched.Q_high.is_infinity() {{
                full_proof.msm_hint_batched.Q_high.assert_on_curve(0);
            }}
            if !full_proof.msm_hint_batched.Q_high_shifted.is_infinity() {{
                full_proof.msm_hint_batched.Q_high_shifted.assert_on_curve(0);
            }}

            // Hash result points
            let (s0, s1, s2) = full_proof.msm_hint_batched.Q_low.update_hash_state(s0, s1, s2);
            let (s0, s1, s2) = full_proof.msm_hint_batched.Q_high.update_hash_state(s0, s1, s2);
            let (s0, s1, s2) = full_proof.msm_hint_batched.Q_high_shifted.update_hash_state(s0, s1, s2);

            // Hash scalars :
            let mut s0 = s0;
            let mut s1 = s1;
            let mut s2 = s2;
            for scalar in scalars {{
                let (_s0, _s1, _s2) = core::poseidon::hades_permutation(
                    s0 + (*scalar.low).into(), s1 + (*scalar.high).into(), s2
                );
                s0 = _s0;
                s1 = _s1;
                s2 = _s2;
            }};

            let base_rlc_coeff = s1;

            let (s0, _, _) = full_proof.msm_hint_batched.RLCSumDlogDiv.update_hash_state(s0, s1, s2);

            let random_point: G1Point = derive_ec_point_from_X(
                s0,
                full_proof.derive_point_from_x_hint.y_last_attempt,
                full_proof.derive_point_from_x_hint.g_rhs_sqrt,
                0
            );

            // Get slope, intercept and other constant from random point
            let (mb): (SlopeInterceptOutput,) = ec::run_SLOPE_INTERCEPT_SAME_POINT_circuit(
                random_point, get_a(0), 0
            );

            // Get positive and negative multiplicities of low and high part of scalars
            let (epns_low, epns_high) = neg_3::u256_array_to_low_high_epns(
                scalars, Option::None
            );

            // Hardcoded epns for 2**128
            let epns_shifted: Array<(felt252, felt252, felt252, felt252)> = array![
                (5279154705627724249993186093248666011, 345561521626566187713367793525016877467, -1, -1)
            ];

            let (lhs_fA0) = {lhs_ecip_function_name}(A:random_point, coeff:mb.coeff0, SumDlogDivBatched:full_proof.msm_hint_batched.RLCSumDlogDiv);
            let (lhs_fA2) = {lhs_ecip_function_name}(A:G1Point{{x:mb.x_A2, y:mb.y_A2}}, coeff:mb.coeff2, SumDlogDivBatched:full_proof.msm_hint_batched.RLCSumDlogDiv);
            let mod_bn = get_modulus(0);

            let zk_ecip_batched_lhs = sub_mod_p(lhs_fA0, lhs_fA2, mod_bn);

            let rhs_low = compute_rhs_ecip(
                points, mb.m_A0, mb.b_A0, random_point.x, epns_low, full_proof.msm_hint_batched.Q_low, 0
            );
            let rhs_high = compute_rhs_ecip(
                points, mb.m_A0, mb.b_A0, random_point.x, epns_high, full_proof.msm_hint_batched.Q_high, 0
            );
            let rhs_high_shifted = compute_rhs_ecip(
                array![full_proof.msm_hint_batched.Q_high].span(),
                mb.m_A0,
                mb.b_A0,
                random_point.x,
                epns_shifted,
                full_proof.msm_hint_batched.Q_high_shifted,
                0
            );

            let zk_ecip_batched_rhs = batch_3_mod_p(rhs_low, rhs_high, rhs_high_shifted, base_rlc_coeff.into(), mod_bn);

            let ecip_check = zk_ecip_batched_lhs == zk_ecip_batched_rhs;

            let P_1 = ec_safe_add(full_proof.msm_hint_batched.Q_low, full_proof.msm_hint_batched.Q_high_shifted, 0);
            let P_1 = ec_safe_add(P_1, full_proof.proof.shplonk_q.into(), 0);
            let P_2:G1Point = full_proof.proof.kzg_quotient.into();

            // Perform the KZG pairing check.
            let kzg_check = multi_pairing_check_bn254_2P_2F(
               G1G2Pair {{ p: P_1, q: G2_POINT_KZG_1 }},
               G1G2Pair {{ p: P_2.negate(0), q: G2_POINT_KZG_2 }},
               precomputed_lines.span(),
               full_proof.kzg_hint,
            );

        """.format(
        lhs_ecip_function_name=lhs_ecip_function_name, msm_len=msm_size
    )
    return TEMPLATE


def setup_vk_flavor(system: ProofSystem, vk: str | Path | HonkVk | bytes):
    match system:
        case ProofSystem.UltraKeccakHonk | ProofSystem.UltraKeccakZKHonk:
            flavor = "Keccak"
        case ProofSystem.UltraStarknetHonk | ProofSystem.UltraStarknetZKHonk:
            flavor = "Starknet"
        case _:
            raise ValueError(f"Proof system {system} not compatible")
    if isinstance(vk, (Path, str)):
        vk = HonkVk.from_bytes(open(vk, "rb").read())
    elif isinstance(vk, bytes):
        vk = HonkVk.from_bytes(vk)
    else:
        assert isinstance(
            vk, HonkVk
        ), f"Invalid type for vk: {type(vk)}. Should be str, Path, HonkVk or bytes."
    return vk, flavor


def _get_circuit_code_header():
    header = """
use core::circuit::{
    u384, circuit_add, circuit_sub, circuit_mul, circuit_inverse,
    EvalCircuitTrait, CircuitOutputsTrait, CircuitInputs,
};
use garaga::core::circuit::AddInputResultTrait2;
use garaga::ec_ops::FunctionFelt;
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{G1Point, get_GRUMPKIN_modulus, get_BN254_modulus};\n
"""
    return header


def _gen_circuits_code(
    vk: HonkVk, is_zk: bool
) -> tuple[str, str, str, list[str], str, int, list[str]]:
    """
    Generate the code for the sumcheck circuit and related circuits.

    Args:
        vk: The verifying key
        is_zk: Whether to generate ZK-specific circuits

    Returns:
        Tuple containing:
        - The generated code
        - Sumcheck function name
        - Prepare scalars function name
        - List of consistency function names (empty for non-ZK)
        - Scalar indexes
        - LHS ECIP function name
        - MSM length
    """
    code = _get_circuit_code_header()
    curve_id = CurveID.GRUMPKIN

    # Generate sumcheck circuit
    sumcheck_circuit = ZKSumCheckCircuit(vk) if is_zk else SumCheckCircuit(vk)
    sumcheck_function_name = f"{curve_id.name}_{sumcheck_circuit.name.upper()}"
    sumcheck_code, sumcheck_function_name = sumcheck_circuit.circuit.compile_circuit(
        function_name=sumcheck_function_name, pub=True
    )

    # Generate prepare scalars circuit
    prepare_scalars_circuit = (
        ZKPrepareScalarsCircuit(vk) if is_zk else PrepareScalarsCircuit(vk)
    )
    scalar_indexes = prepare_scalars_circuit.scalar_indexes
    msm_len = prepare_scalars_circuit.msm_len
    prepare_scalars_function_name = (
        f"{curve_id.name}_{prepare_scalars_circuit.name.upper()}"
    )
    prepare_scalars_code, prepare_scalars_function_name = (
        prepare_scalars_circuit.circuit.compile_circuit(
            function_name=prepare_scalars_function_name, pub=True
        )
    )

    # Generate consistency circuits for ZK
    consistency_circuits = []
    if is_zk:
        for circuit_class in [
            ZKEvalsConsistencyInitCircuit,
            ZKEvalsConsistencyLoopCircuit,
            ZKEvalsConsistencyDoneCircuit,
        ]:
            circuit = circuit_class(vk)
            function_name = f"{curve_id.name}_{circuit.name.upper()}"
            circuit_code, function_name = circuit.circuit.compile_circuit(
                function_name=function_name, pub=True
            )
            consistency_circuits.append((circuit_code, function_name))

    # Generate LHS ECIP circuit
    lhs_ecip_circuit = EvalFunctionChallengeSingleCircuit(
        CurveID.BN254.value,
        n_points=msm_len,
        batched=True,
        generic_circuit=False,
        compilation_mode=1,
    )
    lhs_ecip_function_name = f"{CurveID.BN254.name}_{lhs_ecip_circuit.name.upper()}"
    lhs_ecip_code, lhs_ecip_function_name = lhs_ecip_circuit.circuit.compile_circuit(
        function_name=lhs_ecip_function_name, pub=True, inline=False
    )

    # Combine all circuit code
    code += sumcheck_code + prepare_scalars_code
    if is_zk:
        code += "".join(circuit_code for circuit_code, _ in consistency_circuits)
    code += lhs_ecip_code
    code += get_circuit_definition_impl_template(len(scalar_indexes))

    return (
        code,
        sumcheck_function_name,
        prepare_scalars_function_name,
        [func_name for _, func_name in consistency_circuits] if is_zk else [],
        scalar_indexes,
        lhs_ecip_function_name,
        msm_len,
    )


def _gen_contract_header(flavor: str, is_zk: bool, function_names: list[str]) -> str:
    """Generate the contract header and imports based on flavor and ZK status."""
    contract_name = f"Ultra{flavor}{'ZK' if is_zk else ''}HonkVerifier"
    trait_name = f"I{contract_name}"
    endpoint_name = f"verify_ultra_{flavor.lower()}{'_zk' if is_zk else ''}_honk_proof"
    imports_str = ", ".join(function_names)
    proof_struct_name = f"{('ZK' if is_zk else '') + 'HonkProof'}"
    header = f"""
use super::honk_verifier_constants::{{vk, precomputed_lines}};
use super::honk_verifier_circuits::{{{imports_str}}};

#[starknet::interface]
trait {trait_name}<TContractState> {{
    fn {endpoint_name}(
        self: @TContractState,
        full_proof_with_hints: Span<felt252>,
    ) -> Option<Span<u256>>;
}}

#[starknet::contract]
mod {contract_name} {{
    use garaga::definitions::{{G1Point, G1G2Pair, BN254_G1_GENERATOR, get_a, get_modulus}};
    use garaga::pairing_check::{{multi_pairing_check_bn254_2P_2F, MPCheckHintBN254}};
    use garaga::ec_ops::{{G1PointTrait, ec_safe_add,FunctionFeltTrait, DerivePointFromXHint, MSMHint, compute_rhs_ecip, derive_ec_point_from_X, SlopeInterceptOutput}};
    use garaga::basic_field_ops::{{batch_3_mod_p, sub_mod_p}};
    use garaga::circuits::ec;
    use garaga::utils::neg_3;
    use super::{{vk, precomputed_lines, {imports_str}}};
    use garaga::utils::noir::{{{proof_struct_name}, G2_POINT_KZG_1, G2_POINT_KZG_2}};
    use garaga::utils::noir::honk_transcript::{{Point256IntoCircuitPoint, {flavor}HasherState}};
    use garaga::utils::noir::{'zk_' if is_zk else ''}honk_transcript::{{{('ZK' if is_zk else '') + 'HonkTranscriptTrait'}, {'ZK_' if is_zk else ''}BATCHED_RELATION_PARTIAL_LENGTH}};
    use garaga::core::circuit::{{U32IntoU384, U64IntoU384, {'u256_to_u384, ' if is_zk else ''}into_u256_unchecked}};
    use core::num::traits::Zero;
    use core::poseidon::hades_permutation;

    #[storage]
    struct Storage {{}}

    #[derive(Drop, Serde)]
    struct FullProof {{
        proof: {proof_struct_name},
        msm_hint_batched: MSMHint,
        derive_point_from_x_hint: DerivePointFromXHint,
        kzg_hint:MPCheckHintBN254,
    }}

    #[abi(embed_v0)]
    impl {trait_name} of super::{trait_name}<ContractState> {{
        fn {endpoint_name}(
            self: @ContractState,
            full_proof_with_hints: Span<felt252>,
        ) -> Option<Span<u256>> {{
            // DO NOT EDIT THIS FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING.
            // This function returns an Option for the public inputs if the proof is valid.
            // If the proof is invalid, the execution will either fail or return None.
            // Read the documentation to learn how to generate the full_proof_with_hints array given a proof and a verifying key.
            let mut full_proof_with_hints = full_proof_with_hints;
            let full_proof = Serde::<FullProof>::deserialize(ref full_proof_with_hints).expect('deserialization failed');
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
use garaga::utils::noir::HonkVk;

{vk.serialize_to_cairo()}\n
pub const precomputed_lines: [G2Line; {len(precomputed_lines)//4}] = {precomputed_lines.serialize(raw=True, const=True)};
"""


def _get_msm_points_array_code(zk: bool) -> str:
    # Common points that are shared between ZK and non-ZK versions
    common_points = [
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
        "vk.qAux",
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
        "full_proof.proof.w1.into()",
        "full_proof.proof.w2.into()",
        "full_proof.proof.w3.into()",
        "full_proof.proof.w4.into()",
        "full_proof.proof.z_perm.into()",
        "full_proof.proof.lookup_inverses.into()",
        "full_proof.proof.lookup_read_counts.into()",
        "full_proof.proof.lookup_read_tags.into()",
    ]

    # ZK-specific points that are added at the beginning
    zk_points = ["full_proof.proof.gemini_masking_poly.into()"] if zk else []

    # Combine all points
    all_points = zk_points + common_points
    points_str = ",\n".join(all_points)
    code = "// Starts with 1 * shplonk_q, not included in msm\n"
    code += f"""            let mut _points: Array<G1Point> = array![{points_str}];

            for gem_comm in full_proof.proof.gemini_fold_comms {{
                _points.append((*gem_comm).into());
            }};"""
    # Add ZK-specific commitments
    if zk:
        code += """
            for lib_comm in full_proof.proof.libra_commitments {
                _points.append((*lib_comm).into());
            };"""

    # Add common final points
    code += """
            _points.append(BN254_G1_GENERATOR);
            _points.append(full_proof.proof.kzg_quotient.into());

            let points = _points.span();"""

    return code


def _gen_honk_verifier(
    vk: str | Path | HonkVk | bytes,
    output_folder_path: str,
    output_folder_name: str,
    system: ProofSystem = ProofSystem.UltraKeccakHonk,
    cli_mode: bool = False,
) -> str:
    vk, flavor = setup_vk_flavor(system, vk)

    curve_id = CurveID.GRUMPKIN

    output_folder_path = os.path.join(output_folder_path, output_folder_name)

    constants_code = _gen_constants_code(vk)

    (
        circuits_code,
        sumcheck_function_name,
        prepare_scalars_function_name,
        consistency_function_names,
        scalar_indexes,
        lhs_ecip_function_name,
        msm_len,
    ) = _gen_circuits_code(vk, False)

    scalars_tuple = ",\n            ".join(f"scalar_{idx}" for idx in scalar_indexes)
    scalars_tuple_into = ",\n            ".join(
        f"into_u256_unchecked(scalar_{idx})" for idx in scalar_indexes
    )

    # Generate contract header
    contract_header = _gen_contract_header(
        flavor=flavor,
        is_zk=False,
        function_names=[
            sumcheck_function_name,
            prepare_scalars_function_name,
            lhs_ecip_function_name,
        ],
    )

    contract_code = f"""{contract_header}
            let (transcript, base_rlc) = HonkTranscriptTrait::from_proof::<{flavor}HasherState>(vk.circuit_size, vk.public_inputs_size, vk.public_inputs_offset, full_proof.proof);
            let log_n = vk.log_circuit_size;
            let (sum_check_rlc, honk_check) = {sumcheck_function_name}(
                p_public_inputs: full_proof.proof.public_inputs,
                p_public_inputs_offset: vk.public_inputs_offset.into(),
                sumcheck_univariates_flat: full_proof.proof.sumcheck_univariates.slice(0, log_n * BATCHED_RELATION_PARTIAL_LENGTH),
                sumcheck_evaluations: full_proof.proof.sumcheck_evaluations,
                tp_sum_check_u_challenges: transcript.sum_check_u_challenges.span().slice(0, log_n),
                tp_gate_challenges: transcript.gate_challenges.span().slice(0, log_n),
                tp_eta_1: transcript.eta,
                tp_eta_2: transcript.eta_two,
                tp_eta_3: transcript.eta_three,
                tp_beta: transcript.beta,
                tp_gamma: transcript.gamma,
                tp_base_rlc: base_rlc.into(),
                tp_alphas: transcript.alphas.span(),
            );

        let (
            {scalars_tuple},
        ) =
            {prepare_scalars_function_name}(
            p_sumcheck_evaluations: full_proof.proof.sumcheck_evaluations,
            p_gemini_a_evaluations: full_proof.proof.gemini_a_evaluations,
            tp_gemini_r: transcript.gemini_r.into(),
            tp_rho: transcript.rho.into(),
            tp_shplonk_z: transcript.shplonk_z.into(),
            tp_shplonk_nu: transcript.shplonk_nu.into(),
            tp_sum_check_u_challenges: transcript.sum_check_u_challenges.span().slice(0, log_n),
        );

            {_get_msm_points_array_code(zk=False)}

            let scalars: Span<u256> = array![{scalars_tuple_into}, transcript.shplonk_z.into()].span();

            {get_msm_kzg_template(msm_len, lhs_ecip_function_name)}

            if sum_check_rlc.is_zero() && honk_check.is_zero() && ecip_check && kzg_check {{
                return Option::Some(full_proof.proof.public_inputs);
            }} else {{
                return Option::None;
            }}
        }}
    }}
}}


    """

    _write_and_format_project_files(
        output_folder_path,
        output_folder_name,
        cli_mode,
        constants_code,
        circuits_code,
        contract_code,
    )

    return constants_code


def _gen_zk_honk_verifier(
    vk: str | Path | HonkVk | bytes,
    output_folder_path: str,
    output_folder_name: str,
    system: ProofSystem = ProofSystem.UltraKeccakZKHonk,
    cli_mode: bool = False,
) -> str:
    vk, flavor = setup_vk_flavor(system, vk)

    curve_id = CurveID.GRUMPKIN

    output_folder_path = os.path.join(output_folder_path, output_folder_name)

    constants_code = _gen_constants_code(vk)

    (
        circuits_code,
        sumcheck_function_name,
        prepare_scalars_function_name,
        consistency_function_names,
        scalar_indexes,
        lhs_ecip_function_name,
        msm_len,
    ) = _gen_circuits_code(vk, True)

    scalars_tuple = ",\n            ".join(f"scalar_{idx}" for idx in scalar_indexes)
    scalars_tuple_into = ",\n            ".join(
        f"into_u256_unchecked(scalar_{idx})" for idx in scalar_indexes
    )

    # Generate contract header
    contract_header = _gen_contract_header(
        flavor=flavor,
        is_zk=True,
        function_names=[
            sumcheck_function_name,
            prepare_scalars_function_name,
            consistency_function_names[0],
            consistency_function_names[1],
            consistency_function_names[2],
            lhs_ecip_function_name,
        ],
    )

    contract_code = f"""{contract_header}
            let (transcript, base_rlc) = ZKHonkTranscriptTrait::from_proof::<{flavor}HasherState>(vk.circuit_size, vk.public_inputs_size, vk.public_inputs_offset, full_proof.proof);
            let log_n = vk.log_circuit_size;
            let (sum_check_rlc, honk_check) = {sumcheck_function_name}(
                p_public_inputs: full_proof.proof.public_inputs,
                p_public_inputs_offset: vk.public_inputs_offset.into(),
                libra_sum: u256_to_u384(full_proof.proof.libra_sum),
                sumcheck_univariates_flat: full_proof.proof.sumcheck_univariates.slice(0, log_n * ZK_BATCHED_RELATION_PARTIAL_LENGTH),
                sumcheck_evaluations: full_proof.proof.sumcheck_evaluations,
                libra_evaluation: u256_to_u384(full_proof.proof.libra_evaluation),
                tp_sum_check_u_challenges: transcript.sum_check_u_challenges.span().slice(0, log_n),
                tp_gate_challenges: transcript.gate_challenges.span().slice(0, log_n),
                tp_eta_1: transcript.eta.into(),
                tp_eta_2: transcript.eta_two.into(),
                tp_eta_3: transcript.eta_three.into(),
                tp_beta: transcript.beta.into(),
                tp_gamma: transcript.gamma.into(),
                tp_base_rlc: base_rlc.into(),
                tp_alphas: transcript.alphas.span(),
                tp_libra_challenge: transcript.libra_challenge.into(),
            );

            const CONST_PROOF_SIZE_LOG_N: usize = {CONST_PROOF_SIZE_LOG_N};
            let (mut challenge_poly_eval, mut root_power_times_tp_gemini_r) = {consistency_function_names[0]}(
                tp_gemini_r: transcript.gemini_r.into(),
            );
            for i in 0..CONST_PROOF_SIZE_LOG_N {{
                let (new_challenge_poly_eval, new_root_power_times_tp_gemini_r) = {consistency_function_names[1]}(
                    challenge_poly_eval: challenge_poly_eval,
                    root_power_times_tp_gemini_r: root_power_times_tp_gemini_r,
                    tp_sumcheck_u_challenge: (*transcript.sum_check_u_challenges.at(i)).into(),
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
        );

            {_get_msm_points_array_code(zk=True)}
            let scalars: Span<u256> = array![{scalars_tuple_into}, transcript.shplonk_z.into()].span();

            {get_msm_kzg_template(msm_len, lhs_ecip_function_name)}
            if sum_check_rlc.is_zero() && honk_check.is_zero() && !vanishing_check.is_zero() && diff_check.is_zero() && ecip_check && kzg_check {{
                return Option::Some(full_proof.proof.public_inputs);
            }} else {{
                return Option::None;
            }}
        }}
    }}
}}


    """
    _write_and_format_project_files(
        output_folder_path,
        output_folder_name,
        cli_mode,
        constants_code,
        circuits_code,
        contract_code,
    )

    return True


def _write_and_format_project_files(
    output_folder_path: str,
    output_folder_name: str,
    cli_mode: bool,
    constants_code: str,
    circuits_code: str,
    contract_code: str,
):
    create_directory(output_folder_path)
    src_dir = os.path.join(output_folder_path, "src")
    create_directory(src_dir)

    with open(os.path.join(output_folder_path, ".tool-versions"), "w") as f:
        f.write(f"scarb {CAIRO_VERSION}\n")

    with open(os.path.join(src_dir, "honk_verifier_constants.cairo"), "w") as f:
        f.write(constants_code)

    with open(os.path.join(src_dir, "honk_verifier_circuits.cairo"), "w") as f:
        f.write(circuits_code)

    with open(os.path.join(src_dir, "honk_verifier.cairo"), "w") as f:
        f.write(contract_code)

    with open(os.path.join(output_folder_path, "Scarb.toml"), "w") as f:
        f.write(get_scarb_toml_file(output_folder_name, cli_mode))

    with open(os.path.join(src_dir, "lib.cairo"), "w") as f:
        f.write(
            """
mod honk_verifier;
mod honk_verifier_constants;
mod honk_verifier_circuits;
"""
        )
    subprocess.run(["scarb", "fmt"], check=True, cwd=output_folder_path)


if __name__ == "__main__":

    for system in [
        ProofSystem.UltraKeccakHonk,
        ProofSystem.UltraStarknetHonk,
        ProofSystem.UltraKeccakZKHonk,
        ProofSystem.UltraStarknetZKHonk,
    ]:
        match system:
            case ProofSystem.UltraKeccakHonk:
                flavor = "keccak"
            case ProofSystem.UltraStarknetHonk:
                flavor = "starknet"
            case ProofSystem.UltraKeccakZKHonk:
                flavor = "keccak_zk"
            case ProofSystem.UltraStarknetZKHonk:
                flavor = "starknet_zk"
            case _:
                raise ValueError(f"Proof system {system} not compatible")

        VK_PATH = (
            "hydra/garaga/starknet/honk_contract_generator/examples/vk_ultra_keccak.bin"
        )
        VK_LARGE_PATH = (
            "hydra/garaga/starknet/honk_contract_generator/examples/vk_large.bin"
        )
        CONTRACTS_FOLDER = "src/contracts/"  # Do not change this

        FOLDER_NAME = (
            f"noir_ultra_{flavor}_honk_example"  # '_curve_id' is appended in the end.
        )

        gen_honk_verifier(VK_PATH, CONTRACTS_FOLDER, FOLDER_NAME, system=system)
        # gen_honk_verifier(VK_LARGE_PATH, CONTRACTS_FOLDER, FOLDER_NAME + "_large", system=system)
