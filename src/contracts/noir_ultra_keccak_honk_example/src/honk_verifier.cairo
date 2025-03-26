use super::honk_verifier_circuits::{
    run_BN254_EVAL_FN_CHALLENGE_SING_41P_RLC_circuit,
    run_GRUMPKIN_HONK_PREP_MSM_SCALARS_SIZE_5_circuit,
    run_GRUMPKIN_HONK_SUMCHECK_SIZE_5_PUB_1_circuit,
};
use super::honk_verifier_constants::{precomputed_lines, vk};

#[starknet::interface]
trait IUltraKeccakHonkVerifier<TContractState> {
    fn verify_ultra_keccak_honk_proof(
        self: @TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<Span<u256>>;
}

#[starknet::contract]
mod UltraKeccakHonkVerifier {
    use core::num::traits::Zero;
    use core::poseidon::hades_permutation;
    use garaga::basic_field_ops::{batch_3_mod_p, sub_mod_p};
    use garaga::circuits::ec;
    use garaga::core::circuit::{U32IntoU384, U64IntoU384, into_u256_unchecked};
    use garaga::definitions::{BN254_G1_GENERATOR, G1G2Pair, G1Point, get_a, get_modulus};
    use garaga::ec_ops::{
        DerivePointFromXHint, FunctionFeltTrait, G1PointTrait, MSMHint, SlopeInterceptOutput,
        compute_rhs_ecip, derive_ec_point_from_X, ec_safe_add,
    };
    use garaga::pairing_check::{MPCheckHintBN254, multi_pairing_check_bn254_2P_2F};
    use garaga::utils::neg_3;
    use garaga::utils::noir::honk_transcript::{
        BATCHED_RELATION_PARTIAL_LENGTH, HonkTranscriptTrait, KeccakHasherState,
        Point256IntoCircuitPoint,
    };
    use garaga::utils::noir::{G2_POINT_KZG_1, G2_POINT_KZG_2, HonkProof};
    use super::{
        precomputed_lines, run_BN254_EVAL_FN_CHALLENGE_SING_41P_RLC_circuit,
        run_GRUMPKIN_HONK_PREP_MSM_SCALARS_SIZE_5_circuit,
        run_GRUMPKIN_HONK_SUMCHECK_SIZE_5_PUB_1_circuit, vk,
    };

    #[storage]
    struct Storage {}

    #[derive(Drop, Serde)]
    struct FullProof {
        proof: HonkProof,
        msm_hint_batched: MSMHint,
        derive_point_from_x_hint: DerivePointFromXHint,
        kzg_hint: MPCheckHintBN254,
    }

    #[abi(embed_v0)]
    impl IUltraKeccakHonkVerifier of super::IUltraKeccakHonkVerifier<ContractState> {
        fn verify_ultra_keccak_honk_proof(
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

            let (transcript, base_rlc) = HonkTranscriptTrait::from_proof::<
                KeccakHasherState,
            >(vk.circuit_size, vk.public_inputs_size, vk.public_inputs_offset, full_proof.proof);
            let log_n = vk.log_circuit_size;
            let (sum_check_rlc, honk_check) = run_GRUMPKIN_HONK_SUMCHECK_SIZE_5_PUB_1_circuit(
                p_public_inputs: full_proof.proof.public_inputs,
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
                scalar_68,
            ) =
                run_GRUMPKIN_HONK_PREP_MSM_SCALARS_SIZE_5_circuit(
                p_sumcheck_evaluations: full_proof.proof.sumcheck_evaluations,
                p_gemini_a_evaluations: full_proof.proof.gemini_a_evaluations,
                tp_gemini_r: transcript.gemini_r.into(),
                tp_rho: transcript.rho.into(),
                tp_shplonk_z: transcript.shplonk_z.into(),
                tp_shplonk_nu: transcript.shplonk_nu.into(),
                tp_sum_check_u_challenges: transcript.sum_check_u_challenges.span().slice(0, log_n),
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
                full_proof.proof.w1.into(),
                full_proof.proof.w2.into(),
                full_proof.proof.w3.into(),
                full_proof.proof.w4.into(),
                full_proof.proof.z_perm.into(),
                full_proof.proof.lookup_inverses.into(),
                full_proof.proof.lookup_read_counts.into(),
                full_proof.proof.lookup_read_tags.into(),
            ];

            for gem_comm in full_proof.proof.gemini_fold_comms {
                _points.append((*gem_comm).into());
            }
            _points.append(BN254_G1_GENERATOR);
            _points.append(full_proof.proof.kzg_quotient.into());

            let points = _points.span();

            let scalars: Span<u256> = array![
                into_u256_unchecked(scalar_1),
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
                into_u256_unchecked(scalar_29),
                into_u256_unchecked(scalar_30),
                into_u256_unchecked(scalar_31),
                into_u256_unchecked(scalar_32),
                into_u256_unchecked(scalar_33),
                into_u256_unchecked(scalar_34),
                into_u256_unchecked(scalar_35),
                into_u256_unchecked(scalar_41),
                into_u256_unchecked(scalar_42),
                into_u256_unchecked(scalar_43),
                into_u256_unchecked(scalar_44),
                into_u256_unchecked(scalar_68),
                transcript.shplonk_z.into(),
            ]
                .span();

            full_proof.msm_hint_batched.RLCSumDlogDiv.validate_degrees_batched(41);
            // HASHING: GET ECIP BASE RLC COEFF.
            // TODO : RE-USE transcript to avoid re-hashing G1 POINTS.
            let (s0, s1, s2): (felt252, felt252, felt252) = hades_permutation(
                'MSM_G1', 0, 1,
            ); // Init Sponge state
            let (s0, s1, s2) = hades_permutation(
                s0 + 0.into(), s1 + 41.into(), s2,
            ); // Include curve_index and msm size

            let mut s0 = s0;
            let mut s1 = s1;
            let mut s2 = s2;

            // Check input points are on curve and hash them at the same time.

            for point in points {
                if !point.is_infinity() {
                    point.assert_on_curve(0);
                }
                let (_s0, _s1, _s2) = point.update_hash_state(s0, s1, s2);
                s0 = _s0;
                s1 = _s1;
                s2 = _s2;
            }

            if !full_proof.msm_hint_batched.Q_low.is_infinity() {
                full_proof.msm_hint_batched.Q_low.assert_on_curve(0);
            }
            if !full_proof.msm_hint_batched.Q_high.is_infinity() {
                full_proof.msm_hint_batched.Q_high.assert_on_curve(0);
            }
            if !full_proof.msm_hint_batched.Q_high_shifted.is_infinity() {
                full_proof.msm_hint_batched.Q_high_shifted.assert_on_curve(0);
            }

            // Hash result points
            let (s0, s1, s2) = full_proof.msm_hint_batched.Q_low.update_hash_state(s0, s1, s2);
            let (s0, s1, s2) = full_proof.msm_hint_batched.Q_high.update_hash_state(s0, s1, s2);
            let (s0, s1, s2) = full_proof
                .msm_hint_batched
                .Q_high_shifted
                .update_hash_state(s0, s1, s2);

            // Hash scalars :
            let mut s0 = s0;
            let mut s1 = s1;
            let mut s2 = s2;
            for scalar in scalars {
                let (_s0, _s1, _s2) = core::poseidon::hades_permutation(
                    s0 + (*scalar.low).into(), s1 + (*scalar.high).into(), s2,
                );
                s0 = _s0;
                s1 = _s1;
                s2 = _s2;
            }

            let base_rlc_coeff = s1;

            let (s0, _, _) = full_proof
                .msm_hint_batched
                .RLCSumDlogDiv
                .update_hash_state(s0, s1, s2);

            let random_point: G1Point = derive_ec_point_from_X(
                s0,
                full_proof.derive_point_from_x_hint.y_last_attempt,
                full_proof.derive_point_from_x_hint.g_rhs_sqrt,
                0,
            );

            // Get slope, intercept and other constant from random point
            let (mb): (SlopeInterceptOutput,) = ec::run_SLOPE_INTERCEPT_SAME_POINT_circuit(
                random_point, get_a(0), 0,
            );

            // Get positive and negative multiplicities of low and high part of scalars
            let (epns_low, epns_high) = neg_3::u256_array_to_low_high_epns(scalars, Option::None);

            // Hardcoded epns for 2**128
            let epns_shifted: Array<(felt252, felt252, felt252, felt252)> = array![
                (
                    5279154705627724249993186093248666011,
                    345561521626566187713367793525016877467,
                    -1,
                    -1,
                ),
            ];

            let (lhs_fA0) = run_BN254_EVAL_FN_CHALLENGE_SING_41P_RLC_circuit(
                A: random_point,
                coeff: mb.coeff0,
                SumDlogDivBatched: full_proof.msm_hint_batched.RLCSumDlogDiv,
            );
            let (lhs_fA2) = run_BN254_EVAL_FN_CHALLENGE_SING_41P_RLC_circuit(
                A: G1Point { x: mb.x_A2, y: mb.y_A2 },
                coeff: mb.coeff2,
                SumDlogDivBatched: full_proof.msm_hint_batched.RLCSumDlogDiv,
            );
            let mod_bn = get_modulus(0);

            let zk_ecip_batched_lhs = sub_mod_p(lhs_fA0, lhs_fA2, mod_bn);

            let rhs_low = compute_rhs_ecip(
                points,
                mb.m_A0,
                mb.b_A0,
                random_point.x,
                epns_low,
                full_proof.msm_hint_batched.Q_low,
                0,
            );
            let rhs_high = compute_rhs_ecip(
                points,
                mb.m_A0,
                mb.b_A0,
                random_point.x,
                epns_high,
                full_proof.msm_hint_batched.Q_high,
                0,
            );
            let rhs_high_shifted = compute_rhs_ecip(
                array![full_proof.msm_hint_batched.Q_high].span(),
                mb.m_A0,
                mb.b_A0,
                random_point.x,
                epns_shifted,
                full_proof.msm_hint_batched.Q_high_shifted,
                0,
            );

            let zk_ecip_batched_rhs = batch_3_mod_p(
                rhs_low, rhs_high, rhs_high_shifted, base_rlc_coeff.into(), mod_bn,
            );

            let ecip_check = zk_ecip_batched_lhs == zk_ecip_batched_rhs;

            let P_1 = ec_safe_add(
                full_proof.msm_hint_batched.Q_low, full_proof.msm_hint_batched.Q_high_shifted, 0,
            );
            let P_1 = ec_safe_add(P_1, full_proof.proof.shplonk_q.into(), 0);
            let P_2: G1Point = full_proof.proof.kzg_quotient.into();

            // Perform the KZG pairing check.
            let kzg_check = multi_pairing_check_bn254_2P_2F(
                G1G2Pair { p: P_1, q: G2_POINT_KZG_1 },
                G1G2Pair { p: P_2.negate(0), q: G2_POINT_KZG_2 },
                precomputed_lines.span(),
                full_proof.kzg_hint,
            );

            if sum_check_rlc.is_zero() && honk_check.is_zero() && ecip_check && kzg_check {
                return Option::Some(full_proof.proof.public_inputs);
            } else {
                return Option::None;
            }
        }
    }
}

