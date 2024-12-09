import os
import subprocess
from pathlib import Path

from garaga.definitions import CurveID
from garaga.modulo_circuit_structs import G2Line, StructArray
from garaga.precompiled_circuits.compilable_circuits.common_cairo_fustat_circuits import (
    EvalFunctionChallengeDuplCircuit,
)
from garaga.precompiled_circuits.compilable_circuits.ultra_honk import (
    PrepareScalarsCircuit,
    SumCheckCircuit,
)
from garaga.precompiled_circuits.honk import G2_POINT_KZG_1, G2_POINT_KZG_2, HonkVk
from garaga.precompiled_circuits.multi_miller_loop import precompute_lines
from garaga.starknet.cli.utils import create_directory
from garaga.starknet.groth16_contract_generator.generator import get_scarb_toml_file


def precompute_lines_honk() -> StructArray:

    # Precompute lines for fixed G2 points
    lines = precompute_lines([G2_POINT_KZG_1, G2_POINT_KZG_2])
    precomputed_lines = StructArray(
        name="lines",
        elmts=[
            G2Line(name=f"line{i}", elmts=lines[i : i + 4])
            for i in range(0, len(lines), 4)
        ],
    )

    return precomputed_lines


def gen_honk_circuits_code(vk: HonkVk) -> str:
    """
    Generate the code for the sumcheck circuit.
    """
    header = """
use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, circuit_add, circuit_sub, circuit_mul, circuit_inverse,
    EvalCircuitTrait, CircuitOutputsTrait, CircuitModulus, AddInputResultTrait, CircuitInputs,
};
use garaga::core::circuit::AddInputResultTrait2;
use garaga::ec_ops::FunctionFelt;
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{
    get_b, G1Point, u288, get_GRUMPKIN_modulus, get_BN254_modulus};
use core::option::Option;\n
"""
    code = header
    sumcheck_circuit = SumCheckCircuit(vk)
    sumcheck_function_name = f"{CurveID.GRUMPKIN.name}_{sumcheck_circuit.name.upper()}"
    sumcheck_code, sumcheck_function_name = sumcheck_circuit.circuit.compile_circuit(
        function_name=sumcheck_function_name, pub=True
    )

    prepare_scalars_circuit = PrepareScalarsCircuit(vk)
    scalar_indexes = prepare_scalars_circuit.scalar_indexes
    msm_len = prepare_scalars_circuit.msm_len
    prepare_scalars_function_name = (
        f"{CurveID.GRUMPKIN.name}_{prepare_scalars_circuit.name.upper()}"
    )

    prepare_scalars_code, prepare_scalars_function_name = (
        prepare_scalars_circuit.circuit.compile_circuit(
            function_name=prepare_scalars_function_name, pub=True
        )
    )
    code += sumcheck_code + prepare_scalars_code

    lhs_ecip_circuit = EvalFunctionChallengeDuplCircuit(
        CurveID.BN254.value,
        n_points=msm_len,
        batched=True,
        generic_circuit=False,
        compilation_mode=1,
    )
    lhs_ecip_function_name = f"{CurveID.BN254.name}_{lhs_ecip_circuit.name.upper()}"
    lhs_ecip_code, lhs_ecip_function_name = lhs_ecip_circuit.circuit.compile_circuit(
        function_name=lhs_ecip_function_name, pub=True
    )
    code += lhs_ecip_code
    return (
        code,
        sumcheck_function_name,
        prepare_scalars_function_name,
        scalar_indexes,
        lhs_ecip_function_name,
        msm_len,
    )


def gen_msm_code(vk: HonkVk) -> str:
    code = """

    """
    return code


def gen_honk_verifier(
    vk: str | Path | HonkVk | bytes,
    output_folder_path: str,
    output_folder_name: str,
    cli_mode: bool = False,
) -> str:
    if isinstance(vk, (Path, str)):
        vk = HonkVk.from_bytes(open(vk, "rb").read())
    elif isinstance(vk, bytes):
        vk = HonkVk.from_bytes(vk)
    else:
        assert isinstance(
            vk, HonkVk
        ), f"Invalid type for vk: {type(vk)}. Should be str, Path, HonkVk or bytes."

    curve_id = CurveID.GRUMPKIN

    output_folder_path = os.path.join(output_folder_path, output_folder_name)

    precomputed_lines = precompute_lines_honk()

    constants_code = f"""
    use garaga::definitions::{{G1Point, G2Point, G2Line, u384, u288}};
    use garaga::utils::noir::HonkVk;

    {vk.serialize_to_cairo()}\n
    pub const precomputed_lines: [G2Line; {len(precomputed_lines)//4}] = {precomputed_lines.serialize(raw=True, const=True)};
    """

    (
        circuits_code,
        sumcheck_function_name,
        prepare_scalars_function_name,
        scalar_indexes,
        lhs_ecip_function_name,
        msm_len,
    ) = gen_honk_circuits_code(vk)

    scalars_tuple = ",\n            ".join(f"scalar_{idx}" for idx in scalar_indexes)
    scalars_tuple_into = ",\n            ".join(
        f"scalar_{idx}.try_into().unwrap()" for idx in scalar_indexes
    )

    contract_code = f"""
use super::honk_verifier_constants::{{vk, precomputed_lines}};
use super::honk_verifier_circuits::{{{sumcheck_function_name}, {prepare_scalars_function_name}, {lhs_ecip_function_name}}};

#[starknet::interface]
trait IUltraKeccakHonkVerifier<TContractState> {{
    fn verify_ultra_keccak_honk_proof(
        self: @TContractState,
        full_proof_with_hints: Span<felt252>,
    ) -> Option<Span<u256>>;
}}

#[starknet::contract]
mod UltraKeccakHonkVerifier {{
    use garaga::definitions::{{G1Point, G1G2Pair, BN254_G1_GENERATOR, get_a, get_modulus, u384}};
    use garaga::pairing_check::{{multi_pairing_check_bn254_2P_2F, MPCheckHintBN254}};
    use garaga::ec_ops::{{G1PointTrait, ec_safe_add, FunctionFelt,FunctionFeltTrait, DerivePointFromXHint, MSMHintBatched, compute_rhs_ecip, derive_ec_point_from_X, SlopeInterceptOutput}};
    use garaga::ec_ops_g2::{{G2PointTrait}};
    use garaga::basic_field_ops::{{add_mod_p, mul_mod_p}};
    use garaga::circuits::ec;
    use garaga::utils::neg_3;
    use super::{{vk, precomputed_lines, {sumcheck_function_name}, {prepare_scalars_function_name}, {lhs_ecip_function_name}}};
    use garaga::utils::noir::{{HonkProof, remove_unused_variables_sumcheck_evaluations, G2_POINT_KZG_1, G2_POINT_KZG_2}};
    use garaga::utils::noir::keccak_transcript::{{HonkTranscriptTrait, Point256IntoCircuitPoint}};
    use garaga::core::circuit::U64IntoU384;
    use core::num::traits::Zero;
    use core::poseidon::hades_permutation;

    #[storage]
    struct Storage {{}}

    #[derive(Drop, Serde)]
    struct FullProof {{
        proof: HonkProof,
        msm_hint_batched: MSMHintBatched,
        derive_point_from_x_hint: DerivePointFromXHint,
        kzg_hint:MPCheckHintBN254,
    }}

    #[abi(embed_v0)]
    impl IUltraKeccakHonkVerifier of super::IUltraKeccakHonkVerifier<ContractState> {{
        fn verify_ultra_keccak_honk_proof(
            self: @ContractState,
            full_proof_with_hints: Span<felt252>,
        ) -> Option<Span<u256>> {{
            // DO NOT EDIT THIS FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING.
            // This function returns an Option for the public inputs if the proof is valid.
            // If the proof is invalid, the execution will either fail or return None.
            // Read the documentation to learn how to generate the full_proof_with_hints array given a proof and a verifying key.
            let mut full_proof_with_hints = full_proof_with_hints;
            let full_proof = Serde::<FullProof>::deserialize(ref full_proof_with_hints).expect('deserialization failed');
            // let mpcheck_hint = fph.mpcheck_hint;
            // let msm_hint = fph.msm_hint;


            let (transcript, base_rlc) = HonkTranscriptTrait::from_proof(full_proof.proof);
            let log_n = vk.log_circuit_size;
            let (sum_check_rlc, honk_check) = {sumcheck_function_name}(
                p_public_inputs: full_proof.proof.public_inputs,
                p_public_inputs_offset: full_proof.proof.public_inputs_offset.into(),
                {', '.join([f'sumcheck_univariate_{i}: (*full_proof.proof.sumcheck_univariates.at({i}))' for i in range(vk.log_circuit_size)])},
                sumcheck_evaluations: remove_unused_variables_sumcheck_evaluations(
                    full_proof.proof.sumcheck_evaluations
                ),
                tp_sum_check_u_challenges: transcript.sum_check_u_challenges.span().slice(0, log_n),
                tp_gate_challenges: transcript.gate_challenges.span().slice(0, log_n),
                tp_eta_1: transcript.eta.into(),
                tp_eta_2: transcript.eta_two.into(),
                tp_eta_3: transcript.eta_three.into(),
                tp_beta: transcript.beta.into(),
                tp_gamma: transcript.gamma.into(),
                tp_base_rlc: base_rlc.into(),
                tp_alphas: transcript.alphas.span(),
            );

        let (
            {scalars_tuple},
            _
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

            // Starts with 1 * shplonk_q, not included in msm.

            let mut _points: Array<G1Point> = array![vk.qm,
                                                    vk.qc,
                                                    vk.ql,
                                                    vk.qr,
                                                    vk.qo,
                                                    vk.q4,
                                                    vk.qArith,
                                                    vk.qDeltaRange,
                                                    vk.qElliptic,
                                                    vk.qAux,
                                                    vk.qLookup,
                                                    vk.qPoseidon2External,
                                                    vk.qPoseidon2Internal,
                                                    vk.s1,
                                                    vk.s2,
                                                    vk.s3,
                                                    vk.s4,
                                                    vk.id1,
                                                    vk.id2,
                                                    vk.id3,
                                                    vk.id4,
                                                    vk.t1,
                                                    vk.t2,
                                                    vk.t3,
                                                    vk.t4,
                                                    vk.lagrange_first,
                                                    vk.lagrange_last,
                                                    full_proof.proof.w1.into(),
                                                    full_proof.proof.w2.into(),
                                                    full_proof.proof.w3.into(),
                                                    full_proof.proof.w4.into(),
                                                    full_proof.proof.z_perm.into(),
                                                    full_proof.proof.lookup_inverses.into(),
                                                    full_proof.proof.lookup_read_counts.into(),
                                                    full_proof.proof.lookup_read_tags.into(),
                                                    full_proof.proof.z_perm.into(),
                                                    ];

            let n_gem_comms = vk.log_circuit_size-1;
            for i in 0_u32..n_gem_comms {{
                _points.append((*full_proof.proof.gemini_fold_comms.at(i)).into());
            }};
            _points.append(BN254_G1_GENERATOR);
            _points.append(full_proof.proof.kzg_quotient.into());

            let points = _points.span();

            let scalars: Span<u256> = array![{scalars_tuple_into}, transcript.shplonk_z.into()].span();

            full_proof.msm_hint_batched.SumDlogDivBatched.validate_degrees_batched({msm_len});

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

            let (s0, _, _) = full_proof.msm_hint_batched.SumDlogDivBatched.update_hash_state(s0, s1, s2);

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

            let (zk_ecip_batched_lhs) = {lhs_ecip_function_name}(A0:random_point, A2:G1Point{{x:mb.x_A2, y:mb.y_A2}}, coeff0:mb.coeff0, coeff2:mb.coeff2, SumDlogDivBatched:full_proof.msm_hint_batched.SumDlogDivBatched);

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

            let mod_bn = get_modulus(0);
            let c0: u384 = base_rlc_coeff.into();
            let c1: u384 = mul_mod_p(c0, c0, mod_bn);
            let c2 = mul_mod_p(c1, c0, mod_bn);

            let zk_ecip_batched_rhs = add_mod_p(
                add_mod_p(mul_mod_p(rhs_low, c0, mod_bn), mul_mod_p(rhs_high, c1, mod_bn), mod_bn),
                mul_mod_p(rhs_high_shifted, c2, mod_bn),
                mod_bn
            );

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

            if sum_check_rlc.is_zero() && honk_check.is_zero() && ecip_check && kzg_check {{
                return Option::Some(full_proof.proof.public_inputs);
            }} else {{
                return Option::None;
            }}
        }}
    }}
}}


    """

    create_directory(output_folder_path)
    src_dir = os.path.join(output_folder_path, "src")
    create_directory(src_dir)

    with open(os.path.join(output_folder_path, ".tools-versions"), "w") as f:
        f.write("scarb 2.9.1\n")

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
    return constants_code


if __name__ == "__main__":

    VK_PATH = (
        "hydra/garaga/starknet/honk_contract_generator/examples/vk_ultra_keccak.bin"
    )

    CONTRACTS_FOLDER = "src/contracts/"  # Do not change this

    FOLDER_NAME = (
        "noir_ultra_keccak_honk_example"  # '_curve_id' is appended in the end.
    )

    gen_honk_verifier(VK_PATH, CONTRACTS_FOLDER, FOLDER_NAME)
