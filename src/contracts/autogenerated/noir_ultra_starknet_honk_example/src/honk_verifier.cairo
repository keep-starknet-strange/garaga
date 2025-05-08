use super::honk_verifier_circuits::{
    is_on_curve_bn254, run_GRUMPKIN_HONK_PREP_MSM_SCALARS_SIZE_12_circuit,
    run_GRUMPKIN_HONK_SUMCHECK_SIZE_12_PUB_17_circuit,
};
use super::honk_verifier_constants::{VK_HASH, precomputed_lines, vk};

#[starknet::interface]
pub trait IUltraStarknetHonkVerifier<TContractState> {
    fn verify_ultra_starknet_honk_proof(
        self: @TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<Span<u256>>;
}

#[starknet::contract]
mod UltraStarknetHonkVerifier {
    use core::num::traits::Zero;
    use core::poseidon::hades_permutation;
    use garaga::circuits::ec;
    use garaga::core::circuit::{U32IntoU384, U64IntoU384, u288IntoCircuitInputValue};
    use garaga::definitions::{
        BN254_G1_GENERATOR, G1G2Pair, G1Point, get_BN254_modulus, get_GRUMPKIN_modulus,
        get_eigenvalue, get_min_one_order, get_nG_glv_fake_glv, get_third_root_of_unity, u288, u384,
    };
    use garaga::ec_ops::{G1PointTrait, GlvFakeGlvHint, _ec_safe_add, _scalar_mul_glv_and_fake_glv};
    use garaga::pairing_check::{MPCheckHintBN254, multi_pairing_check_bn254_2P_2F};
    use garaga::utils::noir::honk_transcript::{
        BATCHED_RELATION_PARTIAL_LENGTH, HonkTranscriptTrait, Point256IntoCircuitPoint,
        StarknetHasherState,
    };
    use garaga::utils::noir::{G2_POINT_KZG_1, G2_POINT_KZG_2, HonkProof};
    use super::{
        VK_HASH, is_on_curve_bn254, precomputed_lines,
        run_GRUMPKIN_HONK_PREP_MSM_SCALARS_SIZE_12_circuit,
        run_GRUMPKIN_HONK_SUMCHECK_SIZE_12_PUB_17_circuit, vk,
    };

    #[storage]
    struct Storage {}

    #[derive(Drop, Serde)]
    struct FullProof {
        proof: HonkProof,
        msm_hint: Span<felt252>,
        kzg_hint: MPCheckHintBN254,
    }

    #[abi(embed_v0)]
    impl IUltraStarknetHonkVerifier of super::IUltraStarknetHonkVerifier<ContractState> {
        fn verify_ultra_starknet_honk_proof(
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

            let (transcript, transcript_state, base_rlc) = HonkTranscriptTrait::from_proof::<
                StarknetHasherState,
            >(vk.circuit_size, vk.public_inputs_size, vk.public_inputs_offset, full_proof.proof);
            let log_n = vk.log_circuit_size;
            let (sum_check_rlc, honk_check) = run_GRUMPKIN_HONK_SUMCHECK_SIZE_12_PUB_17_circuit(
                p_public_inputs: full_proof.proof.public_inputs,
                p_pairing_point_object: full_proof.proof.pairing_point_object,
                p_public_inputs_offset: vk.public_inputs_offset.into(),
                sumcheck_univariates_flat: full_proof
                    .proof
                    .sumcheck_univariates
                    .slice(0, log_n * BATCHED_RELATION_PARTIAL_LENGTH),
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
                scalar_41,
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
                scalar_68,
            ) =
                run_GRUMPKIN_HONK_PREP_MSM_SCALARS_SIZE_12_circuit(
                p_sumcheck_evaluations: full_proof.proof.sumcheck_evaluations,
                p_gemini_a_evaluations: full_proof.proof.gemini_a_evaluations,
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
                full_proof.proof.w1.into(), // Proof point 1,
                full_proof.proof.w2.into(), // Proof point 2,
                full_proof.proof.w3.into(), // Proof point 3,
                full_proof.proof.w4.into(), // Proof point 4,
                full_proof.proof.z_perm.into(), // Proof point 5,
                full_proof.proof.lookup_inverses.into(), // Proof point 6,
                full_proof.proof.lookup_read_counts.into(), // Proof point 7,
                full_proof.proof.lookup_read_tags.into() // Proof point 8
            ];

            for gem_comm in full_proof.proof.gemini_fold_comms {
                _points.append((*gem_comm).into());
            } // log_n -1 = 11 points || Proof points 9-19
            _points.append(full_proof.proof.kzg_quotient.into()); // Proof point 20
            _points.append(BN254_G1_GENERATOR);

            let mut points = _points.span();

            let mut scalars: Span<u384> = array![
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
                scalar_41,
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
                transcript.shplonk_z.into(),
                scalar_68,
            ]
                .span();

            // Check input points are on curve.
            // Skip the first 27 points as they are from VK and keep the last 20 proof points
            for point in points.slice(27, 20) {
                assert(is_on_curve_bn254(*point, mod_bn), 'proof point not on curve');
            }

            // Assert shplonk_q is on curve
            let shplonk_q_pt: G1Point = full_proof.proof.shplonk_q.into();
            assert(is_on_curve_bn254(shplonk_q_pt, mod_bn), 'shplonk_q not on curve');

            let mut msm_hint = full_proof.msm_hint;
            assert(msm_hint.len() == 48 * 12, 'wrong glv&fakeglv hint size');
            let eigen = get_eigenvalue(0);
            let third_root_of_unity = get_third_root_of_unity(0);
            let min_one = get_min_one_order(0);
            let nG = get_nG_glv_fake_glv(0);

            let mut P_1 = shplonk_q_pt;

            while msm_hint.len() != 0 {
                let pt = *points.pop_front().unwrap();
                let scalar = *scalars.pop_front().unwrap();
                // Note : Scalars are below curve order by construction (circuit outputs mod n and
                // transcript output (u128))
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
            }

            let P_2: G1Point = full_proof.proof.kzg_quotient.into();

            // Perform the KZG pairing check.
            let kzg_check = multi_pairing_check_bn254_2P_2F(
                G1G2Pair { p: P_1, q: G2_POINT_KZG_1 },
                G1G2Pair { p: P_2.negate(0), q: G2_POINT_KZG_2 },
                precomputed_lines.span(),
                full_proof.kzg_hint,
            );

            if sum_check_rlc.is_zero() && honk_check.is_zero() && kzg_check {
                return Option::Some(full_proof.proof.public_inputs);
            } else {
                return Option::None;
            }
        }
    }
}

