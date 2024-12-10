use super::honk_verifier_constants::{vk, precomputed_lines};
use super::honk_verifier_circuits::{
    run_GRUMPKIN_HONK_SUMCHECK_SIZE_5_PUB_1_circuit,
    run_GRUMPKIN_HONK_PREPARE_MSM_SCALARS_SIZE_5_circuit,
    run_BN254_EVAL_FN_CHALLENGE_DUPL_42P_RLC_circuit,
};

#[starknet::interface]
trait IUltraKeccakHonkVerifier<TContractState> {
    fn verify_ultra_keccak_honk_proof(
        self: @TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<Span<u256>>;
}

#[starknet::contract]
mod UltraKeccakHonkVerifier {
    use garaga::definitions::{G1Point, G1G2Pair, BN254_G1_GENERATOR, get_a, get_modulus, u384};
    use garaga::pairing_check::{multi_pairing_check_bn254_2P_2F, MPCheckHintBN254};
    use garaga::ec_ops::{
        G1PointTrait, ec_safe_add, FunctionFelt, FunctionFeltTrait, DerivePointFromXHint,
        MSMHintBatched, compute_rhs_ecip, derive_ec_point_from_X, SlopeInterceptOutput,
    };
    use garaga::ec_ops_g2::{G2PointTrait};
    use garaga::basic_field_ops::{add_mod_p, mul_mod_p};
    use garaga::circuits::ec;
    use garaga::utils::neg_3;
    use super::{
        vk, precomputed_lines, run_GRUMPKIN_HONK_SUMCHECK_SIZE_5_PUB_1_circuit,
        run_GRUMPKIN_HONK_PREPARE_MSM_SCALARS_SIZE_5_circuit,
        run_BN254_EVAL_FN_CHALLENGE_DUPL_42P_RLC_circuit,
    };
    use garaga::utils::noir::{
        HonkProof, remove_unused_variables_sumcheck_evaluations, G2_POINT_KZG_1, G2_POINT_KZG_2,
    };
    use garaga::utils::noir::keccak_transcript::{HonkTranscriptTrait, Point256IntoCircuitPoint};
    use garaga::core::circuit::U64IntoU384;
    use core::num::traits::Zero;
    use core::poseidon::hades_permutation;

    #[storage]
    struct Storage {}

    #[derive(Drop, Serde)]
    struct FullProof {
        proof: HonkProof,
        msm_hint_batched: MSMHintBatched,
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
            // let mpcheck_hint = fph.mpcheck_hint;
            // let msm_hint = fph.msm_hint;

            let (transcript, base_rlc) = HonkTranscriptTrait::from_proof(full_proof.proof);
            let log_n = vk.log_circuit_size;
            let (sum_check_rlc, honk_check) = run_GRUMPKIN_HONK_SUMCHECK_SIZE_5_PUB_1_circuit(
                p_public_inputs: full_proof.proof.public_inputs,
                p_public_inputs_offset: full_proof.proof.public_inputs_offset.into(),
                sumcheck_univariate_0: (*full_proof.proof.sumcheck_univariates.at(0)),
                sumcheck_univariate_1: (*full_proof.proof.sumcheck_univariates.at(1)),
                sumcheck_univariate_2: (*full_proof.proof.sumcheck_univariates.at(2)),
                sumcheck_univariate_3: (*full_proof.proof.sumcheck_univariates.at(3)),
                sumcheck_univariate_4: (*full_proof.proof.sumcheck_univariates.at(4)),
                sumcheck_evaluations: remove_unused_variables_sumcheck_evaluations(
                    full_proof.proof.sumcheck_evaluations,
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
                scalar_44,
                scalar_45,
                scalar_46,
                scalar_47,
                scalar_48,
                scalar_72,
                _,
            ) =
                run_GRUMPKIN_HONK_PREPARE_MSM_SCALARS_SIZE_5_circuit(
                p_sumcheck_evaluations: full_proof.proof.sumcheck_evaluations,
                p_gemini_a_evaluations: full_proof.proof.gemini_a_evaluations,
                tp_gemini_r: transcript.gemini_r.into(),
                tp_rho: transcript.rho.into(),
                tp_shplonk_z: transcript.shplonk_z.into(),
                tp_shplonk_nu: transcript.shplonk_nu.into(),
                tp_sum_check_u_challenges: transcript.sum_check_u_challenges.span().slice(0, log_n),
            );

            // Starts with 1 * shplonk_q, not included in msm.

            let mut _points: Array<G1Point> = array![
                vk.qm,
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

            let n_gem_comms = vk.log_circuit_size - 1;
            for i in 0_u32..n_gem_comms {
                _points.append((*full_proof.proof.gemini_fold_comms.at(i)).into());
            };
            _points.append(BN254_G1_GENERATOR);
            _points.append(full_proof.proof.kzg_quotient.into());

            let points = _points.span();

            let scalars: Span<u256> = array![
                scalar_1.try_into().unwrap(),
                scalar_2.try_into().unwrap(),
                scalar_3.try_into().unwrap(),
                scalar_4.try_into().unwrap(),
                scalar_5.try_into().unwrap(),
                scalar_6.try_into().unwrap(),
                scalar_7.try_into().unwrap(),
                scalar_8.try_into().unwrap(),
                scalar_9.try_into().unwrap(),
                scalar_10.try_into().unwrap(),
                scalar_11.try_into().unwrap(),
                scalar_12.try_into().unwrap(),
                scalar_13.try_into().unwrap(),
                scalar_14.try_into().unwrap(),
                scalar_15.try_into().unwrap(),
                scalar_16.try_into().unwrap(),
                scalar_17.try_into().unwrap(),
                scalar_18.try_into().unwrap(),
                scalar_19.try_into().unwrap(),
                scalar_20.try_into().unwrap(),
                scalar_21.try_into().unwrap(),
                scalar_22.try_into().unwrap(),
                scalar_23.try_into().unwrap(),
                scalar_24.try_into().unwrap(),
                scalar_25.try_into().unwrap(),
                scalar_26.try_into().unwrap(),
                scalar_27.try_into().unwrap(),
                scalar_28.try_into().unwrap(),
                scalar_29.try_into().unwrap(),
                scalar_30.try_into().unwrap(),
                scalar_31.try_into().unwrap(),
                scalar_32.try_into().unwrap(),
                scalar_33.try_into().unwrap(),
                scalar_34.try_into().unwrap(),
                scalar_35.try_into().unwrap(),
                scalar_44.try_into().unwrap(),
                scalar_45.try_into().unwrap(),
                scalar_46.try_into().unwrap(),
                scalar_47.try_into().unwrap(),
                scalar_48.try_into().unwrap(),
                scalar_72.try_into().unwrap(),
                transcript.shplonk_z.into(),
            ]
                .span();

            full_proof.msm_hint_batched.SumDlogDivBatched.validate_degrees_batched(42);

            // HASHING: GET ECIP BASE RLC COEFF.
            // TODO : RE-USE transcript to avoid re-hashing G1 POINTS.
            let (s0, s1, s2): (felt252, felt252, felt252) = hades_permutation(
                'MSM_G1', 0, 1,
            ); // Init Sponge state
            let (s0, s1, s2) = hades_permutation(
                s0 + 0.into(), s1 + 42.into(), s2,
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
            };

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
            };

            let base_rlc_coeff = s1;

            let (s0, _, _) = full_proof
                .msm_hint_batched
                .SumDlogDivBatched
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

            let (zk_ecip_batched_lhs) = run_BN254_EVAL_FN_CHALLENGE_DUPL_42P_RLC_circuit(
                A0: random_point,
                A2: G1Point { x: mb.x_A2, y: mb.y_A2 },
                coeff0: mb.coeff0,
                coeff2: mb.coeff2,
                SumDlogDivBatched: full_proof.msm_hint_batched.SumDlogDivBatched,
            );

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

            let mod_bn = get_modulus(0);
            let c0: u384 = base_rlc_coeff.into();
            let c1: u384 = mul_mod_p(c0, c0, mod_bn);
            let c2 = mul_mod_p(c1, c0, mod_bn);

            let zk_ecip_batched_rhs = add_mod_p(
                add_mod_p(mul_mod_p(rhs_low, c0, mod_bn), mul_mod_p(rhs_high, c1, mod_bn), mod_bn),
                mul_mod_p(rhs_high_shifted, c2, mod_bn),
                mod_bn,
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

