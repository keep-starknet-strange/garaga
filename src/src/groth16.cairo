/// This file contains utilities to verify a pairing check of the form :
/// e(P1, Qf1) * e(P2, Qf2) * e(P3, Q3) * e(Pf4, Qf4) == 1, where
/// - Qf1 and Qf2 are fixed known G2 points.
/// - Pf4 and Qf4 is a fixed pair of G1 and G2 points.
/// The result of e(Pf4, Qf4) is precomputed and provided to the circuit as a the miller loop result
/// precomputed_miller_loop_result = MillerLoop(Pf4, Qf4) ∈ Gt/Fp12.
///
/// MultiPairing chekcs circuit in the "3P_2F" mode is used for triple pairs and double fixed G2
/// points
///
/// Qf1 and Qf2 are represented by their pre-computed line functions for the specifc miller loop
/// implementation.
///
/// Two functions are provided for BN254 and BLS12-381 respectively.
/// To generate the lines functions and the precomputed miller loop result, refer to garaga's
/// documentation.
///
/// Moreover, the file contains the full groth16 verification function for BN254 and BLS12-381.
use garaga::definitions::{
    G1Point, G2Point, G1G2Pair, bn_bits, bls_bits, MillerLoopResultScalingFactor, E12D,
    BNProcessedPair, BLSProcessedPair, get_modulus, E12DMulQuotient, G2Line, u288,
};
use garaga::circuits::multi_pairing_check::{
    run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit,
    run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit,
    run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3P_circuit, run_BN254_MP_CHECK_PREPARE_PAIRS_3P_circuit,
    run_BN254_MP_CHECK_PREPARE_PAIRS_1P_circuit,
};
use garaga::circuits::multi_pairing_check as mpc;
use core::circuit::u384;
use garaga::circuits::extf_mul::{
    run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit, run_BN254_FP12_MUL_ASSERT_ONE_circuit,
    run_BN254_EVAL_E12D_circuit, run_BLS12_381_EVAL_E12D_circuit,
};
use core::option::Option;
use garaga::utils;
use core::array::{SpanTrait};
use core::poseidon::hades_permutation;
use core::num::traits::{One};


use garaga::basic_field_ops::{neg_mod_p, compute_yInvXnegOverY_BN254};
use garaga::ec_ops::{msm_g1, MSMHint, DerivePointFromXHint, G1PointTrait};
use garaga::ec_ops_g2::G2PointTrait;
use garaga::pairing_check::{MPCheckHintBN254, MPCheckHintBLS12_381};
use garaga::utils::{u384_assert_zero, usize_assert_eq};
use garaga::utils::hashing;


// Groth16 proof structure, genric for both BN254 and BLS12-381.
#[derive(Drop, Serde)]
pub struct Groth16Proof {
    pub a: G1Point,
    pub b: G2Point,
    pub c: G1Point,
    pub public_inputs: Span<u256>,
}

// Only used for Risc0 where public inputs are derived with an extra step.
#[derive(Drop, Serde)]
pub struct Groth16ProofRaw {
    pub a: G1Point,
    pub b: G2Point,
    pub c: G1Point,
}
// Groth16 verifying key structure, consisting of the two fixed G2 points and the precomputed
// miller loop result miller_loop(alpha, beta)
// Does not include gamma and delta lines inside, although it should be part of the key.
// Does not include IC either as its size is not fixed and we want to write it as constant in smart
// contracts.
#[derive(Drop)]
pub struct Groth16VerifyingKey<T> {
    pub alpha_beta_miller_loop_result: E12D<T>,
    pub gamma_g2: G2Point,
    pub delta_g2: G2Point,
}


// Verify a groth16 proof for BN254.
// Parameters:
// - proof: the proof to verify
// - verification_key: the verifying key
// - lines: the lines of the gamma and delta points. Must correspond to the ones of gamma and
// delta.
// - ic: the points in the VK corresponding to the public inputs. The length must correspond to the
// number of public inputs in the proof.
// - public_inputs_digits_decompositions: the digits decompositions of the public inputs in base
// (-3) for each of the low and high part of the u256.
//      - If provided, or partially provided (as hint), each provided decomposition is verified in
//      Cairo.
//      - If None, or partially provided, the missing decompositions are computed in pure Cairo.
// - public_inputs_msm_hint: the MSM hint of the public inputs
// - mpcheck_hint: the MPCheck hint of the proof
fn verify_groth16_bn254(
    proof: Groth16Proof,
    verification_key: Groth16VerifyingKey<u288>,
    mut lines: Span<G2Line<u288>>,
    ic: Span<G1Point>,
    public_inputs_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
    public_inputs_msm_hint: MSMHint,
    public_inputs_msm_derive_point_from_x_hint: DerivePointFromXHint,
    mpcheck_hint: MPCheckHintBN254,
    small_Q: E12DMulQuotient<u288>,
) -> bool {
    let vk_x: G1Point = msm_g1(
        public_inputs_digits_decompositions,
        public_inputs_msm_hint,
        public_inputs_msm_derive_point_from_x_hint,
        ic.slice(1, ic.len() - 1),
        proof.public_inputs,
        0,
    );

    proof.a.assert_on_curve(0);
    proof.b.assert_on_curve(0);
    proof.c.assert_on_curve(0);

    return multi_pairing_check_bn254_3P_2F_with_extra_miller_loop_result(
        G1G2Pair { p: vk_x, q: verification_key.gamma_g2 },
        G1G2Pair { p: proof.c, q: verification_key.delta_g2 },
        G1G2Pair { p: proof.a, q: proof.b },
        verification_key.alpha_beta_miller_loop_result,
        lines,
        mpcheck_hint,
        small_Q,
    );
}

// Verify a groth16 proof for BN254.
// Parameters:
// - proof: the proof to verify
// - verification_key: the verifying key
// - lines: the lines of the gamma and delta points. Must correspond to the ones of gamma and
// delta.
// - ic: the points in the VK corresponding to the public inputs. The length must correspond to the
// number of public inputs in the proof.
// - public_inputs_digits_decompositions: the digits decompositions of the public inputs in base
// (-3) for each of the low and high part of the u256.
//      - If provided, or partially provided (as hint), each provided decomposition is verified in
//      Cairo.
//      - If None, or partially provided, the missing decompositions are computed in pure Cairo.
// - public_inputs_msm_hint: the MSM hint of the public inputs
// - mpcheck_hint: the MPCheck hint of the proof
fn verify_groth16_bls12_381(
    proof: Groth16Proof,
    verification_key: Groth16VerifyingKey<u384>,
    mut lines: Span<G2Line<u384>>,
    ic: Span<G1Point>,
    public_inputs_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
    public_inputs_msm_hint: MSMHint,
    public_inputs_msm_derive_point_from_x_hint: DerivePointFromXHint,
    mpcheck_hint: MPCheckHintBLS12_381,
    small_Q: E12DMulQuotient<u384>,
) -> bool {
    let vk_x: G1Point = msm_g1(
        public_inputs_digits_decompositions,
        public_inputs_msm_hint,
        public_inputs_msm_derive_point_from_x_hint,
        ic.slice(1, ic.len() - 1),
        proof.public_inputs,
        1,
    );

    proof.a.assert_on_curve(1);
    proof.b.assert_on_curve(1);
    proof.c.assert_on_curve(1);

    return multi_pairing_check_bls12_381_3P_2F_with_extra_miller_loop_result(
        G1G2Pair { p: vk_x, q: verification_key.gamma_g2 },
        G1G2Pair { p: proof.c, q: verification_key.delta_g2 },
        G1G2Pair { p: proof.a, q: proof.b },
        verification_key.alpha_beta_miller_loop_result,
        lines,
        mpcheck_hint,
        small_Q,
    );
}


// This function verifies that
// miller(P0, Q0) * miller(P1, Q1) * miller(P2, Q2) * precomputed_miller_loop_result *
// hint.MillerLoopResultScalingFactor == hint.lambda_root ^ λ (1)
// <=> e(P0, Q0) * e(P1, Q1) * e(P2, Q2) * final_exp(precomputed_miller_loop_result) == 1 (2)
// It is based on the paper "On Proving Pairings" by Andrija Novakovic and Liam Eagen:
// https://eprint.iacr.org/2024/640 to eliminate the cost of the final exponentiation.

// Where :
// - Q1 and Q2 are known G2 points, represented by their precomputed lines functions.
// - λ = 6x + 2 + q - q^2 + q^3 with x the seed of the bn curve, and q the prime modulus of
// the base field.
// - MillerLoopResultScalingFactor is a factor lying in the Fq6 subfield such that it makes
// miller(P0, Q0) * miller(P1, Q1) * miller(P2, Q2) * precomputed_miller_loop_result a lambda
// residue.
// To compute efficiently lambda_root^λ in (1) and take advantage of the squarings in the miller
// function that is iterating over the bits of x, we initialize the miller loop result to
// (1/hint.lambda_root), obtaining as an intermediate result in M = (f/hint.lambda_root^x),
// where f = miller(P0, Q0) * miller(P1, Q1) * miller(P2, Q2) * precomputed_miller_loop_result.
//
// Finally, we verify that M * hint.MillerLoopResultScalingFactor * (1/hint.lambda_root)^q == 1,
// using the Frobenius endomorphism for cheap exponentiation by q.

// On top of this, all extension fields multiplications are verified and batched using
// randomized extension field arithmetic.
// For each bit of the miller loop (0, 1, -1, or 00), we compute the next miller loop intermediate,
// depending on the bit case:
//
// - 0: f₍ᵢ₊₁₎ = fᵢ² * Πⱼ (Lᵢⱼ),
// - (+1): f₍ᵢ₊₁₎ = fᵢ² * Πⱼ (Lᵢⱼ) * (1/lambda_root)
// - (-1): f₍ᵢ₊₁₎ = fᵢ² * Πⱼ (Lᵢⱼ) * (lambda_root)
// - 00: f₍ᵢ₊₂₎ = (fᵢ² * Πⱼ (Lᵢⱼ) )² * Πⱼ (L₍ᵢ₊₁₎ⱼ)
//
// where Lᵢⱼ is the j-th line of the i-th bit of the miller loop, evaluated at point Pⱼ.
// Since we have 3 pairs, for bit "0", we have 3 lines, and for bit "1", we have 6 lines.
// Instead of performing full extension field multiplications, we ask the caller to provide as hint
// all the fᵢ as Fq12 elements inside hint.Ris.
// We then hash (s₀, c₀, _) = Poseidon(Pair₀, Pair₁, Pair₂,
// hint.MillerLoopResultScalingFactor, hint.Ris)
// And we use the definition cᵢ₊₁ = cᵢ² to derive a random coefficient for all relations.
// We also ask the prover to provide a quotient polynomial big_Q such that
// Σᵢ cᵢ * (fᵢ₋₁)² * Πⱼ (Lᵢⱼ) = big_Q * P_irr + Σᵢ cᵢ * fᵢ , where P_irr
// is the irreducible polynomial of the extension field.
// From this, we derive a random point z = Poseidon(s0, hint.big_Q)
// And finally verify that
// Σᵢ cᵢ * (fᵢ₋₁(z))² * Πⱼ (Lᵢⱼ(z)) = big_Q(z) * P_irr(z) + Σᵢ cᵢ * fᵢ(z),
// reusing fᵢ(z) evaluations in the next step.
#[inline]
fn multi_pairing_check_bn254_3P_2F_with_extra_miller_loop_result(
    pair0: G1G2Pair,
    pair1: G1G2Pair,
    pair2: G1G2Pair,
    precomputed_miller_loop_result: E12D<u288>,
    mut lines: Span<G2Line<u288>>,
    mpcheck_hint: MPCheckHintBN254,
    small_Q: E12DMulQuotient<u288>,
) -> bool {
    usize_assert_eq(mpcheck_hint.big_Q.len(), 190);
    usize_assert_eq(mpcheck_hint.Ris.len(), 35);

    let (yInv_0, xNegOverY_0) = compute_yInvXnegOverY_BN254(pair0.p.x, pair0.p.y);
    let (yInv_1, xNegOverY_1) = compute_yInvXnegOverY_BN254(pair1.p.x, pair1.p.y);
    let (processed_pair2) = run_BN254_MP_CHECK_PREPARE_PAIRS_1P_circuit(
        pair2.p, pair2.q.y0, pair2.q.y1,
    );

    // Init sponge state == hades_permutation(int.from_bytes(b'MPCHECK_BN254_3P_2F', "big"), 0, 1)
    let (s0, s1, s2) = (
        0x716fcd6880324d6d3638aeb033dfab41310a98ce7aa8f44159a67f4a8a4fbc8,
        0x68dc029639a62ca19056e890fb846e0b9c89926a0ba1371b79201a6563a0df6,
        0x45cdbfd4efe739304e9ec6744f6bdb99016ab57885cbe7e4c59108d2a649b,
    );
    // Hash Inputs
    let (s0, s1, s2) = hashing::hash_G1G2Pair(pair0, s0, s1, s2);
    let (s0, s1, s2) = hashing::hash_G1G2Pair(pair1, s0, s1, s2);
    let (s0, s1, s2) = hashing::hash_G1G2Pair(pair2, s0, s1, s2);
    let (s0, s1, s2) = hashing::hash_E12D_u288(mpcheck_hint.lambda_root, s0, s1, s2);
    let (s0, s1, s2) = hashing::hash_E12D_u288(mpcheck_hint.lambda_root_inverse, s0, s1, s2);
    let (s0, s1, s2) = hashing::hash_MillerLoopResultScalingFactor_u288(mpcheck_hint.w, s0, s1, s2);
    // Hash Ris to obtain base random coefficient c0
    let (s0, s1, s2) = hashing::hash_E12D_u288_transcript(mpcheck_hint.Ris, s0, s1, s2);

    let mut c_i: u384 = s1.into();

    // Hash Q = (Σ_i c_i*Q_i) to obtain random evaluation point z
    let (z_felt252, _, _) = hashing::hash_u288_transcript(mpcheck_hint.big_Q.span(), s0, s1, s2);

    let z: u384 = z_felt252.into();
    // Precompute lambda root evaluated in Z:
    let (
        c_of_z, w_of_z, c_inv_of_z, LHS, c_inv_frob_1_of_z, c_frob_2_of_z, c_inv_frob_3_of_z,
    ): (u384, u384, u384, u384, u384, u384, u384) =
        run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
        mpcheck_hint.lambda_root, z, mpcheck_hint.w, mpcheck_hint.lambda_root_inverse, c_i,
    );

    // init bit for bn254 is 0:
    let mut Ris = mpcheck_hint.Ris;
    let (R_0_of_Z) = run_BN254_EVAL_E12D_circuit(*Ris.pop_front().unwrap(), z);
    let (_Q2, _lhs, _c_i) = mpc::run_BN254_MP_CHECK_INIT_BIT_3P_2F_circuit(
        yInv_0,
        xNegOverY_0,
        *lines.pop_front().unwrap(),
        yInv_1,
        xNegOverY_1,
        *lines.pop_front().unwrap(),
        processed_pair2.yInv,
        processed_pair2.xNegOverY,
        pair2.q,
        R_0_of_Z,
        c_i,
        z,
        c_inv_of_z,
        LHS,
    );

    let mut Q2 = _Q2;
    let mut LHS = _lhs;
    let mut f_i_of_z = R_0_of_Z;
    c_i = _c_i;

    // rest of miller loop
    let mut bits = bn_bits.span();
    while let Option::Some(bit) = bits.pop_front() {
        let (R_i_of_z) = run_BN254_EVAL_E12D_circuit(*Ris.pop_front().unwrap(), z);
        let (_Q2, _LHS, _c_i): (G2Point, u384, u384) = match *bit {
            0 => {
                let [l0, l1, l2, l3] = (*lines.multi_pop_front::<4>().unwrap()).unbox();
                mpc::run_BN254_MP_CHECK_BIT00_3P_2F_circuit(
                    yInv_0,
                    xNegOverY_0,
                    l0,
                    l1,
                    yInv_1,
                    xNegOverY_1,
                    l2,
                    l3,
                    processed_pair2.yInv,
                    processed_pair2.xNegOverY,
                    Q2,
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    z,
                    c_i,
                )
            },
            1 |
            2 => {
                // 1 -> 10
                // 2 -> -10
                let [l0, l1, l2, l3, l4, l5] = (*lines.multi_pop_front::<6>().unwrap()).unbox();
                let (Q_or_Q_neg, c_or_c_inv_of_z) = match (*bit - 1) {
                    0 => (pair2.q, c_inv_of_z),
                    _ => (
                        G2Point {
                            x0: pair2.q.x0,
                            x1: pair2.q.x1,
                            y0: processed_pair2.QyNeg0,
                            y1: processed_pair2.QyNeg1,
                        },
                        c_of_z,
                    ),
                };
                mpc::run_BN254_MP_CHECK_BIT10_3P_2F_circuit(
                    yInv_0,
                    xNegOverY_0,
                    l0,
                    l1,
                    l2,
                    yInv_1,
                    xNegOverY_1,
                    l3,
                    l4,
                    l5,
                    processed_pair2.yInv,
                    processed_pair2.xNegOverY,
                    Q2,
                    Q_or_Q_neg,
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    c_or_c_inv_of_z,
                    z,
                    c_i,
                )
            },
            _ => {
                // 3 -> 01, 4 -> 0-1
                let [l0, l1, l2, l3, l4, l5] = (*lines.multi_pop_front::<6>().unwrap()).unbox();
                let (Q_or_Q_neg, c_or_c_inv_of_z) = match (*bit - 3) {
                    0 => (pair2.q, c_inv_of_z),
                    _ => (
                        G2Point {
                            x0: pair2.q.x0,
                            x1: pair2.q.x1,
                            y0: processed_pair2.QyNeg0,
                            y1: processed_pair2.QyNeg1,
                        },
                        c_of_z,
                    ),
                };
                mpc::run_BN254_MP_CHECK_BIT01_3P_2F_circuit(
                    yInv_0,
                    xNegOverY_0,
                    l0,
                    l1,
                    l2,
                    yInv_1,
                    xNegOverY_1,
                    l3,
                    l4,
                    l5,
                    processed_pair2.yInv,
                    processed_pair2.xNegOverY,
                    Q2,
                    Q_or_Q_neg,
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    c_or_c_inv_of_z,
                    z,
                    c_i,
                )
            },
        };
        Q2 = _Q2;
        LHS = _LHS;
        f_i_of_z = R_i_of_z;
        c_i = _c_i;
    };
    let R_n_minus_2 = Ris.pop_front().unwrap();
    let R_last = Ris.pop_front().unwrap();

    let [l0, l1, l2, l3] = (*lines.multi_pop_front::<4>().unwrap()).unbox();
    let (check) = mpc::run_BN254_MP_CHECK_FINALIZE_BN_3P_2F_circuit(
        yInv_0,
        xNegOverY_0,
        l0,
        l1,
        yInv_1,
        xNegOverY_1,
        l2,
        l3,
        pair2.q,
        processed_pair2.yInv,
        processed_pair2.xNegOverY,
        Q2,
        *R_n_minus_2,
        *R_last,
        c_i,
        w_of_z,
        z,
        c_inv_frob_1_of_z,
        c_frob_2_of_z,
        c_inv_frob_3_of_z,
        LHS,
        f_i_of_z,
        mpcheck_hint.big_Q,
    );

    // Checks that LHS = Q(z) * P_irr(z)
    u384_assert_zero(check);

    // Use precomputed miller loop result & check f * M = 1
    let (s0, s1, s2) = hashing::hash_E12D_u288(precomputed_miller_loop_result, s0, s1, s2);
    let (z, _, _) = hashing::hash_E12DMulQuotient_u288(small_Q, s0, s1, s2);
    let (check) = run_BN254_FP12_MUL_ASSERT_ONE_circuit(
        *R_last, precomputed_miller_loop_result, small_Q, z.into(),
    );
    u384_assert_zero(check);
    return true;
}


// This function verifies that
// miller(P0, Q0) * miller(P1, Q1) * miller(P2, Q2) * precomputed_miller_loop_result *
// hint.MillerLoopResultScalingFactor == hint.lambda_root ^ λ (1)
// <=> e(P0, Q0) * e(P1, Q1) * e(P2, Q2) * final_exp(precomputed_miller_loop_result) == 1 (2)
// It is based on the paper "On Proving Pairings" by Andrija Novakovic and Liam Eagen:
// https://eprint.iacr.org/2024/640 to eliminate the cost of the final exponentiation.

// Where :
// - Q1 and Q2 are known G2 points, represented by their precomputed lines functions.
// - λ = -x + q, with x the seed of the bls curve, and q the prime modulus of the base field.
// - MillerLoopResultScalingFactor is a factor lying in the Fq6 subfield such that it makes
// miller(P0, Q0) * miller(P1, Q1) * miller(P2, Q2) * precomputed_miller_loop_result a lambda
// residue.
// To compute efficiently lambda_root^λ in (1) and take advantage of the squarings in the miller
// function that is iterating over the bits of x, we initialize the miller loop result to
// (1/hint.lambda_root), obtaining as an intermediate result in M = (f/hint.lambda_root^x),
// where f = miller(P0, Q0) * miller(P1, Q1) * miller(P2, Q2) * precomputed_miller_loop_result.
//
// Finally, we verify that M * hint.MillerLoopResultScalingFactor * (1/hint.lambda_root)^q == 1,
// using the Frobenius endomorphism for cheap exponentiation by q.

// On top of this, all extension fields multiplications are verified and batched using
// randomized extension field arithmetic.
// For each bit of the miller loop (0, 1, or 00), we compute the next miller loop intermediate,
// depending on the bit case:
//
// - 0: f₍ᵢ₊₁₎ = fᵢ² * Πⱼ (Lᵢⱼ),
// - 1: f₍ᵢ₊₁₎ = fᵢ² * Πⱼ (Lᵢⱼ) * (1/lambda_root)
// - 00: f₍ᵢ₊₂₎ = (fᵢ² * Πⱼ (Lᵢⱼ) )² * Πⱼ (L₍ᵢ₊₁₎ⱼ)
//
// where Lᵢⱼ is the j-th line of the i-th bit of the miller loop.
// Since we have 3 pairs, for bit "0", we have 3 lines, and for bit "1", we have 6 lines.
// Instead of performing full extension field multiplications, we ask the caller to provide as hint
// all the fᵢ as Fq12 elements inside hint.Ris.
// We then hash (s₀, c₀, _) = Poseidon(Pair₀, Pair₁, Pair₂,
// hint.MillerLoopResultScalingFactor, hint.Ris)
// And we use the definition cᵢ₊₁ = cᵢ² to derive a random coefficient for all relations.

// We also ask the prover to provide a quotient polynomial big_Q such that
// Σᵢ cᵢ * (fᵢ₋₁)² * Πⱼ (Lᵢⱼ) = big_Q * P_irr + Σᵢ cᵢ * fᵢ , where P_irr
// is the irreducible polynomial of the extension field.
// From this, we derive a random point z = Poseidon(s0, hint.big_Q)
// And finally verify that
// Σᵢ cᵢ * (fᵢ₋₁(z))² * Πⱼ (Lᵢⱼ(z)) = big_Q(z) * P_irr(z) + Σᵢ cᵢ * fᵢ(z),
// reusing fᵢ(z) evaluations in the next step.
#[inline]
fn multi_pairing_check_bls12_381_3P_2F_with_extra_miller_loop_result(
    pair0: G1G2Pair,
    pair1: G1G2Pair,
    pair2: G1G2Pair,
    precomputed_miller_loop_result: E12D<u384>,
    mut lines: Span<G2Line<u384>>,
    hint: MPCheckHintBLS12_381,
    small_Q: E12DMulQuotient<u384>,
) -> bool {
    assert!(
        hint.big_Q.len() == 105,
        "Wrong Q degree for BLS12-381 3-Pairs Paring check, should be of degree 104 (105 coefficients)",
    );
    assert!(hint.Ris.len() == 36, "Wrong Number of Ris for BLS12-381 3-Pairs Paring check");

    let (
        processed_pair0, processed_pair1, processed_pair2,
    ): (BLSProcessedPair, BLSProcessedPair, BLSProcessedPair) =
        run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3P_circuit(
        pair0.p, pair1.p, pair2.p,
    );

    // Init sponge state :
    let (s0, s1, s2) = hades_permutation('MPCHECK_BLS12_381_3P_2F', 0, 1);
    // Hash Inputs.

    let (s0, s1, s2) = hashing::hash_G1G2Pair(pair0, s0, s1, s2);
    let (s0, s1, s2) = hashing::hash_G1G2Pair(pair1, s0, s1, s2);
    let (s0, s1, s2) = hashing::hash_G1G2Pair(pair2, s0, s1, s2);
    let (s0, s1, s2) = hashing::hash_E12D_u384(hint.lambda_root_inverse, s0, s1, s2);
    let (s0, s1, s2) = hashing::hash_MillerLoopResultScalingFactor_u384(hint.w, s0, s1, s2);
    // Hash Ris to obtain base random coefficient c0
    let (s0, s1, s2) = hashing::hash_E12D_u384_transcript(hint.Ris, s0, s1, s2);
    let mut c_i: u384 = s1.into();

    // Hash Q = (Σ_i c_i*Q_i) to obtain random evaluation point z
    let (z_felt252, s1, s2) = hashing::hash_u384_transcript(hint.big_Q.span(), s0, s1, s2);
    let z: u384 = z_felt252.into();
    // Precompute lambda root evaluated in Z:
    let (conjugate_c_inv_of_z, w_of_z, c_inv_of_z_frob_1): (u384, u384, u384) =
        run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
        hint.lambda_root_inverse, z, hint.w,
    );

    // init bit for bls is 1:
    let mut Ris = hint.Ris;
    let (R_0_of_Z) = run_BLS12_381_EVAL_E12D_circuit(*Ris.pop_front().unwrap(), z);
    let [l0, l1, l2, l3] = (*lines.multi_pop_front::<4>().unwrap()).unbox();
    let (_Q2, _lhs) = mpc::run_BLS12_381_MP_CHECK_INIT_BIT_3P_2F_circuit(
        processed_pair0.yInv,
        processed_pair0.xNegOverY,
        l0,
        l1,
        processed_pair1.yInv,
        processed_pair1.xNegOverY,
        l2,
        l3,
        processed_pair2.yInv,
        processed_pair2.xNegOverY,
        pair2.q,
        R_0_of_Z,
        c_i,
        z,
        conjugate_c_inv_of_z,
    );

    let mut Q2 = _Q2;
    let mut LHS = _lhs;
    let mut f_i_of_z = R_0_of_Z;
    // Σ_i (Π_k (c_i*P_k(z)))  = (Σ_i c_i*Q_i(z)) * P(z) + Σ_i c_i * R_i(z)
    // <=> Σ_i (Π_k (c_i*P_k(z))) - Σ_i c_i * R_i(z) = (Σ_i c_i*Q_i(z)) * P(z)
    // => LHS = Σ_i (Π_k (c_i*P_k(z))) - Σ_i c_i * R_i(z)

    // rest of miller loop
    let mut bits = bls_bits.span();

    while let Option::Some(bit) = bits.pop_front() {
        let (R_i_of_z) = run_BLS12_381_EVAL_E12D_circuit(*Ris.pop_front().unwrap(), z);
        let (_Q2, _LHS, _c_i): (G2Point, u384, u384) = match *bit {
            0 => {
                let [l0, l1] = (*lines.multi_pop_front::<2>().unwrap()).unbox();
                mpc::run_BLS12_381_MP_CHECK_BIT0_3P_2F_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    l0,
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    l1,
                    processed_pair2.yInv,
                    processed_pair2.xNegOverY,
                    Q2,
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    z,
                    c_i,
                )
            },
            1 => {
                let [l0, l1, l2, l3] = (*lines.multi_pop_front::<4>().unwrap()).unbox();
                mpc::run_BLS12_381_MP_CHECK_BIT1_3P_2F_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    l0,
                    l1,
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    l2,
                    l3,
                    processed_pair2.yInv,
                    processed_pair2.xNegOverY,
                    Q2,
                    pair2.q,
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    conjugate_c_inv_of_z,
                    z,
                    c_i,
                )
            },
            _ => {
                let [l0, l1, l2, l3] = (*lines.multi_pop_front::<4>().unwrap()).unbox();
                mpc::run_BLS12_381_MP_CHECK_BIT00_3P_2F_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    l0,
                    l1,
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    l2,
                    l3,
                    processed_pair2.yInv,
                    processed_pair2.xNegOverY,
                    Q2,
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    z,
                    c_i,
                )
            },
        };
        Q2 = _Q2;
        LHS = _LHS;
        f_i_of_z = R_i_of_z;
        c_i = _c_i;
    };

    let R_last = Ris.pop_front().unwrap();

    // Checks that LHS = Q(z) * P_irr(z)
    let (check) = mpc::run_BLS12_381_MP_CHECK_FINALIZE_BLS_3P_circuit(
        *R_last, c_i, w_of_z, z, c_inv_of_z_frob_1, LHS, f_i_of_z, hint.big_Q,
    );

    assert!(check == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }, "Final check failed");

    // Use precomputed miller loop result & check conj(f) * M = 1
    let f_conjugate = conjugate_e12D(*R_last, 1);
    let (s0, s1, s2) = hashing::hash_E12D_u384(precomputed_miller_loop_result, s0, s1, s2);
    let (z, _, _) = hashing::hash_E12DMulQuotient_u384(small_Q, s0, s1, s2);
    let (check) = run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit(
        f_conjugate, precomputed_miller_loop_result, small_Q, z.into(),
    );
    assert!(check == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
    return true;
}

fn conjugate_e12D(self: E12D<u384>, curve_index: usize) -> E12D<u384> {
    let modulus = get_modulus(curve_index);
    E12D {
        w0: self.w0,
        w1: neg_mod_p(self.w1, modulus),
        w2: self.w2,
        w3: neg_mod_p(self.w3, modulus),
        w4: self.w4,
        w5: neg_mod_p(self.w5, modulus),
        w6: self.w6,
        w7: neg_mod_p(self.w7, modulus),
        w8: self.w8,
        w9: neg_mod_p(self.w9, modulus),
        w10: self.w10,
        w11: neg_mod_p(self.w11, modulus),
    }
}
