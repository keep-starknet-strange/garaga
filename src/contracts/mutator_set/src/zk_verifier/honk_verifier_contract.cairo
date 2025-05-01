use super::honk_verifier_circuits::{
    is_on_curve_bn254, run_GRUMPKIN_ZKHONK_PREP_MSM_SCALARS_SIZE_17_circuit,
    run_GRUMPKIN_ZK_HONK_EVALS_CONS_DONE_SIZE_17_circuit,
    run_GRUMPKIN_ZK_HONK_EVALS_CONS_INIT_SIZE_17_circuit,
    run_GRUMPKIN_ZK_HONK_EVALS_CONS_LOOP_SIZE_17_circuit,
    run_GRUMPKIN_ZK_HONK_SUMCHECK_SIZE_17_PUB_19_circuit,
};
use super::honk_verifier_constants::{VK_HASH, precomputed_lines, vk};

#[starknet::interface]
pub trait IUltraKeccakZKHonkVerifier<TContractState> {
    fn verify_ultra_keccak_zk_honk_proof(
        self: @TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<Span<u256>>;
}

#[starknet::contract]
mod UltraKeccakZKHonkVerifier {
    use core::num::traits::Zero;
    use core::poseidon::hades_permutation;
    use garaga::basic_field_ops::{batch_3_mod_p, sub_mod_p};
    use garaga::circuits::ec;
    use garaga::core::circuit::{
        U32IntoU384, U64IntoU384, into_u256_unchecked, u256_to_u384, u288IntoCircuitInputValue,
    };
    use garaga::definitions::{
        BN254_G1_GENERATOR, G1G2Pair, G1Point, get_BN254_modulus, get_GRUMPKIN_modulus, u288,
    };
    use garaga::ec_ops::{G1PointTrait, ec_safe_add, msm_g1};
    use garaga::pairing_check::{MPCheckHintBN254, multi_pairing_check_bn254_2P_2F};
    use garaga::utils::neg_3;
    use garaga::utils::noir::honk_transcript::{KeccakHasherState, Point256IntoCircuitPoint};
    use garaga::utils::noir::zk_honk_transcript::{
        ZKHonkTranscriptTrait, ZK_BATCHED_RELATION_PARTIAL_LENGTH,
    };
    use garaga::utils::noir::{G2_POINT_KZG_1, G2_POINT_KZG_2, ZKHonkProof};
    use super::{
        VK_HASH, is_on_curve_bn254, precomputed_lines,
        run_GRUMPKIN_ZKHONK_PREP_MSM_SCALARS_SIZE_17_circuit,
        run_GRUMPKIN_ZK_HONK_EVALS_CONS_DONE_SIZE_17_circuit,
        run_GRUMPKIN_ZK_HONK_EVALS_CONS_INIT_SIZE_17_circuit,
        run_GRUMPKIN_ZK_HONK_EVALS_CONS_LOOP_SIZE_17_circuit,
        run_GRUMPKIN_ZK_HONK_SUMCHECK_SIZE_17_PUB_19_circuit, vk,
    };

    #[storage]
    struct Storage {}

    #[derive(Drop, Serde)]
    struct FullProof {
        proof: ZKHonkProof,
        msm_hint: Span<felt252>,
        kzg_hint: MPCheckHintBN254,
    }

    #[abi(embed_v0)]
    impl IUltraKeccakZKHonkVerifier of super::IUltraKeccakZKHonkVerifier<ContractState> {
        fn verify_ultra_keccak_zk_honk_proof(
            self: @ContractState, full_proof_with_hints: Span<felt252>,
        ) -> Option<Span<u256>> {
            // DO NOT EDIT THIS FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING.
            // This function returns an Option for the public inputs if the proof is valid.
            // If the proof is invalid, the execution will either fail or return None.
            // Read the documentation to learn how to generate the full_proof_with_hints array given
            // a proof and a verifying key.
            let mut full_proof_with_hints = full_proof_with_hints;
            let full_proof = Serde::<FullProof>::deserialize(ref full_proof_with_hints)
                .expect('deserialization failed');
            let mod_bn = get_BN254_modulus();
            let mod_grumpkin = get_GRUMPKIN_modulus();

            let (transcript, transcript_state, base_rlc) = ZKHonkTranscriptTrait::from_proof::<
                KeccakHasherState,
            >(vk.circuit_size, vk.public_inputs_size, vk.public_inputs_offset, full_proof.proof);
            let log_n = vk.log_circuit_size;
            let (sum_check_rlc, honk_check) = run_GRUMPKIN_ZK_HONK_SUMCHECK_SIZE_17_PUB_19_circuit(
                p_public_inputs: full_proof.proof.public_inputs,
                p_pairing_point_object: full_proof.proof.pairing_point_object,
                p_public_inputs_offset: vk.public_inputs_offset.into(),
                libra_sum: u256_to_u384(full_proof.proof.libra_sum),
                sumcheck_univariates_flat: full_proof
                    .proof
                    .sumcheck_univariates
                    .slice(0, log_n * ZK_BATCHED_RELATION_PARTIAL_LENGTH),
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
                modulus: mod_grumpkin,
            );

            const CONST_PROOF_SIZE_LOG_N: usize = 28;
            let (mut challenge_poly_eval, mut root_power_times_tp_gemini_r) =
                run_GRUMPKIN_ZK_HONK_EVALS_CONS_INIT_SIZE_17_circuit(
                tp_gemini_r: transcript.gemini_r.into(), modulus: mod_grumpkin,
            );
            for i in 0..CONST_PROOF_SIZE_LOG_N {
                let (new_challenge_poly_eval, new_root_power_times_tp_gemini_r) =
                    run_GRUMPKIN_ZK_HONK_EVALS_CONS_LOOP_SIZE_17_circuit(
                    challenge_poly_eval: challenge_poly_eval,
                    root_power_times_tp_gemini_r: root_power_times_tp_gemini_r,
                    tp_sumcheck_u_challenge: (*transcript.sum_check_u_challenges.at(i)).into(),
                    modulus: mod_grumpkin,
                );
                challenge_poly_eval = new_challenge_poly_eval;
                root_power_times_tp_gemini_r = new_root_power_times_tp_gemini_r;
            }
            let (vanishing_check, diff_check) =
                run_GRUMPKIN_ZK_HONK_EVALS_CONS_DONE_SIZE_17_circuit(
                p_libra_evaluation: u256_to_u384(full_proof.proof.libra_evaluation),
                p_libra_poly_evals: full_proof.proof.libra_poly_evals,
                tp_gemini_r: transcript.gemini_r.into(),
                challenge_poly_eval: challenge_poly_eval,
                root_power_times_tp_gemini_r: root_power_times_tp_gemini_r,
                modulus: mod_grumpkin,
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
                scalar_42,
                scalar_43,
                scalar_44,
                scalar_45,
                scalar_46,
                scalar_47,
                scalar_48,
                scalar_49,
                scalar_50,
                scalar_51,
                scalar_52,
                scalar_53,
                scalar_54,
                scalar_55,
                scalar_56,
                scalar_57,
                scalar_69,
                scalar_70,
                scalar_71,
                scalar_72,
            ) =
                run_GRUMPKIN_ZKHONK_PREP_MSM_SCALARS_SIZE_17_circuit(
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

            // Starts with 1 * shplonk_q, not included in msm
            let mut _points: Array<G1Point> = array![
                vk.qm,
                vk.qc,
                vk.ql,
                vk.qr,
                vk.qo,
                vk.q4,
                vk.qLookup,
                vk.qArith,
                vk.qDeltaRange,
                vk.qElliptic,
                vk.qAux,
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
                full_proof.proof.gemini_masking_poly.into(), // Proof point 1,
                full_proof.proof.w1.into(), // Proof point 2,
                full_proof.proof.w2.into(), // Proof point 3,
                full_proof.proof.w3.into(), // Proof point 4,
                full_proof.proof.w4.into(), // Proof point 5,
                full_proof.proof.z_perm.into(), // Proof point 6,
                full_proof.proof.lookup_inverses.into(), // Proof point 7,
                full_proof.proof.lookup_read_counts.into(), // Proof point 8,
                full_proof.proof.lookup_read_tags.into() // Proof point 9
            ];

            for gem_comm in full_proof.proof.gemini_fold_comms {
                _points.append((*gem_comm).into());
            } // log_n -1 = 16 points || Proof points 10-25
            for lib_comm in full_proof.proof.libra_commitments {
                _points.append((*lib_comm).into());
            } // 3 points || Proof points 26-28
            _points.append(full_proof.proof.kzg_quotient.into()); // Proof point 29
            _points.append(BN254_G1_GENERATOR);

            let points = _points.span();
            let scalars: Span<u256> = array![
                into_u256_unchecked(scalar_2),
                into_u256_unchecked(scalar_3),
                into_u256_unchecked(scalar_4),
                into_u256_unchecked(scalar_5),
                into_u256_unchecked(scalar_6),
                into_u256_unchecked(scalar_7),
                into_u256_unchecked(scalar_8),
                into_u256_unchecked(scalar_9),
                into_u256_unchecked(scalar_10),
                into_u256_unchecked(scalar_11),
                into_u256_unchecked(scalar_12),
                into_u256_unchecked(scalar_13),
                into_u256_unchecked(scalar_14),
                into_u256_unchecked(scalar_15),
                into_u256_unchecked(scalar_16),
                into_u256_unchecked(scalar_17),
                into_u256_unchecked(scalar_18),
                into_u256_unchecked(scalar_19),
                into_u256_unchecked(scalar_20),
                into_u256_unchecked(scalar_21),
                into_u256_unchecked(scalar_22),
                into_u256_unchecked(scalar_23),
                into_u256_unchecked(scalar_24),
                into_u256_unchecked(scalar_25),
                into_u256_unchecked(scalar_26),
                into_u256_unchecked(scalar_27),
                into_u256_unchecked(scalar_28),
                into_u256_unchecked(scalar_1),
                into_u256_unchecked(scalar_29),
                into_u256_unchecked(scalar_30),
                into_u256_unchecked(scalar_31),
                into_u256_unchecked(scalar_32),
                into_u256_unchecked(scalar_33),
                into_u256_unchecked(scalar_34),
                into_u256_unchecked(scalar_35),
                into_u256_unchecked(scalar_36),
                into_u256_unchecked(scalar_42),
                into_u256_unchecked(scalar_43),
                into_u256_unchecked(scalar_44),
                into_u256_unchecked(scalar_45),
                into_u256_unchecked(scalar_46),
                into_u256_unchecked(scalar_47),
                into_u256_unchecked(scalar_48),
                into_u256_unchecked(scalar_49),
                into_u256_unchecked(scalar_50),
                into_u256_unchecked(scalar_51),
                into_u256_unchecked(scalar_52),
                into_u256_unchecked(scalar_53),
                into_u256_unchecked(scalar_54),
                into_u256_unchecked(scalar_55),
                into_u256_unchecked(scalar_56),
                into_u256_unchecked(scalar_57),
                into_u256_unchecked(scalar_69),
                into_u256_unchecked(scalar_70),
                into_u256_unchecked(scalar_71),
                transcript.shplonk_z.into(),
                into_u256_unchecked(scalar_72),
            ]
                .span();

            // Check input points are on curve.
            // Skip the first 27 points as they are from VK and keep the last 29 proof points
            for point in points.slice(27, 29) {
                assert(is_on_curve_bn254(*point, mod_bn), 'proof point not on curve');
            }

            // Assert shplonk_q is on curve
            let shplonk_q_pt: G1Point = full_proof.proof.shplonk_q.into();
            assert(is_on_curve_bn254(shplonk_q_pt, mod_bn), 'shplonk_q not on curve');

            let P_1 = msm_g1(points, scalars, 0, full_proof.msm_hint);
            let P_1 = ec_safe_add(P_1, shplonk_q_pt, 0);
            let P_2: G1Point = full_proof.proof.kzg_quotient.into();

            // Perform the KZG pairing check.
            let kzg_check = multi_pairing_check_bn254_2P_2F(
                G1G2Pair { p: P_1, q: G2_POINT_KZG_1 },
                G1G2Pair { p: P_2.negate(0), q: G2_POINT_KZG_2 },
                precomputed_lines.span(),
                full_proof.kzg_hint,
            );

            if sum_check_rlc.is_zero()
                && honk_check.is_zero()
                && !vanishing_check.is_zero()
                && diff_check.is_zero()
                && kzg_check {
                return Option::Some(full_proof.proof.public_inputs);
            } else {
                return Option::None;
            }
        }
    }
}

