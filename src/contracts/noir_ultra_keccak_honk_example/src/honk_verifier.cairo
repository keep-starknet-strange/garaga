use super::honk_verifier_constants::{vk, precomputed_lines};
use super::honk_verifier_circuits::{
    run_GRUMPKIN_HONK_SUMCHECK_SIZE_5_PUB_1_circuit,
    run_GRUMPKIN_HONK_PREPARE_MSM_SCALARS_SIZE_5_circuit
};

#[starknet::interface]
trait IUltraKeccakHonkVerifier<TContractState> {
    fn verify_ultra_keccak_honk(
        self: @TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<Span<u256>>;
}

#[starknet::contract]
mod UltraKeccakHonkVerifier {
    use starknet::SyscallResultTrait;
    use garaga::definitions::{G1Point, G1G2Pair};
    use garaga::pairing_check::{multi_pairing_check_bn254_2P_2F};
    use garaga::ec_ops::{G1PointTrait, ec_safe_add};
    use garaga::ec_ops_g2::{G2PointTrait};
    use super::{
        vk, precomputed_lines, run_GRUMPKIN_HONK_SUMCHECK_SIZE_5_PUB_1_circuit,
        run_GRUMPKIN_HONK_PREPARE_MSM_SCALARS_SIZE_5_circuit
    };
    use garaga::utils::noir::{HonkProof, remove_unused_variables_sumcheck_evaluations};
    use garaga::utils::noir::keccak_transcript::HonkTranscriptTrait;
    use garaga::core::circuit::U64IntoU384;
    use core::num::traits::Zero;

    const ECIP_OPS_CLASS_HASH: felt252 =
        0x3dfa22aa8817c4abe631894416d0292466a4e972898aa9990bee3960c7630ed;
    use starknet::ContractAddress;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl IUltraKeccakHonkVerifier of super::IUltraKeccakHonkVerifier<ContractState> {
        fn verify_ultra_keccak_honk(
            self: @ContractState, full_proof_with_hints: Span<felt252>,
        ) -> Option<Span<u256>> {
            // DO NOT EDIT THIS FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING.
            // This function returns an Option for the public inputs if the proof is valid.
            // If the proof is invalid, the execution will either fail or return None.
            // Read the documentation to learn how to generate the full_proof_with_hints array given
            // a proof and a verifying key.
            let mut full_proof_with_hints = full_proof_with_hints;
            let proof = Serde::<HonkProof>::deserialize(ref full_proof_with_hints)
                .expect('deserialization failed');
            // let mpcheck_hint = fph.mpcheck_hint;
            // let msm_hint = fph.msm_hint;

            // Perform the pairing check.
            // let check = multi_pairing_check_bn254_2P_2F(
            //    G1G2Pair { p: vk_x, q: vk.gamma_g2 },
            //    G1G2Pair { p: groth16_proof.c, q: vk.delta_g2 },
            //    precomputed_lines.span(),
            //    mpcheck_hint,
            //);

            let (transcript, base_rlc) = HonkTranscriptTrait::from_proof(proof);
            let log_n = vk.log_circuit_size;
            let (check_rlc, check) = run_GRUMPKIN_HONK_SUMCHECK_SIZE_5_PUB_1_circuit(
                p_public_inputs: proof.public_inputs,
                p_public_inputs_offset: proof.public_inputs_offset.into(),
                sumcheck_univariate_0: (*proof.sumcheck_univariates.at(0)),
                sumcheck_univariate_1: (*proof.sumcheck_univariates.at(1)),
                sumcheck_univariate_2: (*proof.sumcheck_univariates.at(2)),
                sumcheck_univariate_3: (*proof.sumcheck_univariates.at(3)),
                sumcheck_univariate_4: (*proof.sumcheck_univariates.at(4)),
                sumcheck_evaluations: remove_unused_variables_sumcheck_evaluations(
                    proof.sumcheck_evaluations
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
                scalar_1,
                scalar_2,
                scalar_3,
                scalar_4,
                scalar_5,
                scalar_6,
                scalar_7,
                scalar_8,
                scalar_9,
                scalar_10,
                scalar_11,
                scalar_12,
                scalar_13,
                scalar_14,
                scalar_15,
                scalar_16,
                scalar_17,
                scalar_18,
                scalar_19,
                scalar_20,
                scalar_21,
                scalar_22,
                scalar_23,
                scalar_24,
                scalar_25,
                scalar_26,
                scalar_27,
                scalar_28,
                scalar_29,
                scalar_30,
                scalar_31,
                scalar_32,
                scalar_33,
                scalar_34,
                scalar_35,
                scalar_36,
                scalar_37,
                scalar_38,
                scalar_39,
                scalar_40,
                scalar_41,
                scalar_42,
                scalar_43,
                scalar_44,
                scalar_45,
                scalar_46,
                scalar_47,
                scalar_48,
                scalar_72,
                _
            ) =
                run_GRUMPKIN_HONK_PREPARE_MSM_SCALARS_SIZE_5_circuit(
                p_sumcheck_evaluations: proof.sumcheck_evaluations,
                p_gemini_a_evaluations: proof.gemini_a_evaluations,
                tp_gemini_r: transcript.gemini_r.into(),
                tp_rho: transcript.rho.into(),
                tp_shplonk_z: transcript.shplonk_z.into(),
                tp_shplonk_nu: transcript.shplonk_nu.into(),
                tp_sum_check_u_challenges: transcript.sum_check_u_challenges.span().slice(0, log_n),
            );

            if check.is_zero() && check_rlc.is_zero() {
                return Option::Some(proof.public_inputs);
            } else {
                return Option::None;
            }
        }
    }
}
