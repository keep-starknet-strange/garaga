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
use core::circuit::u384;
use core::num::traits::{One, Zero};
use core::option::Option;
use garaga::basic_field_ops;
use garaga::basic_field_ops::neg_mod_p;
use garaga::circuits::multi_pairing_check as mpc;
use garaga::circuits::multi_pairing_check::{
    run_BLS12_381_INITIALIZE_MPCHECK_EXT_MLR_circuit,
    run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3P_circuit, run_BN254_INITIALIZE_MPCHECK_EXT_MLR_circuit,
    run_BN254_MP_CHECK_PREPARE_PAIRS_1P_circuit,
};
use garaga::definitions::{
    BLS12_381_SEED_BITS_COMPRESSED, BN254_SEED_BITS_JY00_COMPRESSED, E12D, G1G2Pair, G1Point,
    G2Line, G2Point, get_BN254_modulus, get_modulus, u288,
};
use garaga::ec_ops::{G1PointTrait, ec_safe_add, msm_g1};
use garaga::ec_ops_g2::G2PointTrait;
use garaga::pairing_check::{
    BLSProcessedPair, BNProcessedPair, MPCheckHintBLS12_381, MPCheckHintBN254,
    compute_yInvXnegOverY,
};
use garaga::utils::hashing;
use garaga::utils::hashing::{PoseidonState, TWO_POW_96};


#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub struct Groth16ProofRaw {
    pub a: G1Point,
    pub b: G2Point,
    pub c: G1Point,
}

// Groth16 proof structure, generic for both BN254 and BLS12-381.
#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub struct Groth16Proof {
    pub raw: Groth16ProofRaw,
    pub public_inputs: Span<u256>,
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

#[generate_trait]
pub impl Groth16RawProofImpl of Groth16ProofRawTrait {
    fn check_proof_points(self: @Groth16ProofRaw, curve_id: u32) {
        self.a.assert_in_subgroup_excluding_infinity(curve_id);
        self.b.assert_in_subgroup_excluding_infinity(curve_id);
        self.c.assert_in_subgroup_excluding_infinity(curve_id);
    }
}

#[inline]
fn _groth16_get_vk_x(
    proof: Groth16Proof, ic: Span<G1Point>, public_inputs_msm_hint: Span<felt252>, curve_id: u32,
) -> G1Point {
    let vk_x_x: G1Point = msm_g1(
        ic.slice(1, ic.len() - 1), proof.public_inputs, curve_id, public_inputs_msm_hint,
    );
    let vk_x = ec_safe_add(vk_x_x, *ic.at(0), curve_id);
    return vk_x;
}


// Verify a groth16 proof for BN254.
// Parameters:
// - proof: the proof to verify
// - verification_key: the verifying key
// - lines: the lines of the gamma and delta points. Must correspond to the ones of gamma and
// delta.
// - ic: the points in the VK corresponding to the public inputs. The length must correspond to the
// number of public inputs in the proof.
// - public_inputs_msm_hint: the MSM hint of the public inputs
// - mpcheck_hint: the MPCheck hint of the proof
pub fn verify_groth16_bn254(
    verification_key: Groth16VerifyingKey<u288>,
    mut lines: Span<G2Line<u288>>,
    ic: Span<G1Point>,
    proof: Groth16Proof,
    public_inputs_msm_hint: Span<felt252>,
    mpcheck_hint: MPCheckHintBN254,
) -> Result<Span<u256>, felt252> {
    proof.raw.check_proof_points(0);
    let vk_x = _groth16_get_vk_x(proof, ic, public_inputs_msm_hint, 0);
    let check = multi_pairing_check_bn254_3P_2F_with_extra_miller_loop_result(
        G1G2Pair { p: vk_x, q: verification_key.gamma_g2 },
        G1G2Pair { p: proof.raw.c, q: verification_key.delta_g2 },
        G1G2Pair { p: proof.raw.a.negate(0), q: proof.raw.b },
        verification_key.alpha_beta_miller_loop_result,
        lines,
        mpcheck_hint,
    );

    match check {
        Result::Ok(_) => Result::Ok(proof.public_inputs),
        Result::Err(error) => Result::Err(error),
    }
}

// Verify a groth16 proof for BN254.
// Parameters:
// - proof: the proof to verify
// - verification_key: the verifying key
// - lines: the lines of the gamma and delta points. Must correspond to the ones of gamma and
// delta.
// - ic: the points in the VK corresponding to the public inputs. The length must correspond to the
// number of public inputs in the proof.
// - public_inputs_msm_hint: the MSM hint of the public inputs
// - mpcheck_hint: the MPCheck hint of the proof
pub fn verify_groth16_bls12_381(
    proof: Groth16Proof,
    verification_key: Groth16VerifyingKey<u384>,
    mut lines: Span<G2Line<u384>>,
    ic: Span<G1Point>,
    public_inputs_msm_hint: Span<felt252>,
    mpcheck_hint: MPCheckHintBLS12_381,
) -> Result<Span<u256>, felt252> {
    proof.raw.check_proof_points(1);
    let vk_x = _groth16_get_vk_x(proof, ic, public_inputs_msm_hint, 1);

    let check = multi_pairing_check_bls12_381_3P_2F_with_extra_miller_loop_result(
        G1G2Pair { p: vk_x, q: verification_key.gamma_g2 },
        G1G2Pair { p: proof.raw.c, q: verification_key.delta_g2 },
        G1G2Pair { p: proof.raw.a.negate(1), q: proof.raw.b },
        verification_key.alpha_beta_miller_loop_result,
        lines,
        mpcheck_hint,
    );
    match check {
        Result::Ok(_) => Result::Ok(proof.public_inputs),
        Result::Err(error) => Result::Err(error),
    }
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
pub fn multi_pairing_check_bn254_3P_2F_with_extra_miller_loop_result(
    pair0: G1G2Pair,
    pair1: G1G2Pair,
    pair2: G1G2Pair,
    precomputed_miller_loop_result: E12D<u288>,
    mut lines: Span<G2Line<u288>>,
    mpcheck_hint: MPCheckHintBN254,
) -> Result<bool, felt252> {
    if mpcheck_hint.big_Q.len() != 190 {
        return Result::Err('WRONG_BIG_Q_LEN');
    }
    if mpcheck_hint.Ris.len() != 34 {
        return Result::Err('WRONG_RIS_LEN');
    }

    let modulus = get_BN254_modulus(); // BN254 prime field modulus
    let (yInv_0, xNegOverY_0) = compute_yInvXnegOverY(pair0.p.x, pair0.p.y, modulus);
    let (yInv_1, xNegOverY_1) = compute_yInvXnegOverY(pair1.p.x, pair1.p.y, modulus);
    let (processed_pair2): (BNProcessedPair,) = run_BN254_MP_CHECK_PREPARE_PAIRS_1P_circuit(
        pair2.p, pair2.q.y0, pair2.q.y1,
    );

    // Init sponge state == hades_permutation(0, 0, int.from_bytes(b"MPCHECK_BN254_3P_2F", "big"))
    let hash_state = PoseidonState {
        s0: 0x63dd5cf2946ee642aef494d22ee96f6e9168664a2f9c485a6084bd03289b83f,
        s1: 0x22380e74267f899ea972f4f0fc327a181ed44093d778c9ad778437c7a41e418,
        s2: 0x3c3e169429d0a04b80b97617d27b5b37b8e7734bf57faaffc841b8f2cfb6bc7,
    };
    // Hash Inputs
    let hash_state = hashing::hash_G1G2Pair(pair0, hash_state);
    let hash_state = hashing::hash_G1G2Pair(pair1, hash_state);
    let hash_state = hashing::hash_G1G2Pair(pair2, hash_state);
    let hash_state = hashing::hash_E12D_u288(mpcheck_hint.lambda_root, hash_state);
    let hash_state = hashing::hash_E12D_u288(mpcheck_hint.lambda_root_inverse, hash_state);
    let hash_state = hashing::hash_MillerLoopResultScalingFactor_u288(mpcheck_hint.w, hash_state);
    // Hash Ris to obtain base random coefficient c1
    let z: u384 = mpcheck_hint.z.into();
    let (hash_state, mut evals) = basic_field_ops::eval_and_hash_E12D_u288_transcript(
        mpcheck_hint.Ris, hash_state, z,
    );
    let hash_state = hashing::hash_E12D_one_u288(hash_state);

    let hash_state = hashing::hash_E12D_u288(precomputed_miller_loop_result, hash_state);

    let mut evals = evals.span();
    let c_1: u384 = hash_state.s1.into();

    // hades_permutation(0,0,int.from_bytes(b"MPCHECK_BN254_3P_2F_II", "big"))
    let part_II_state = PoseidonState {
        s0: 0xe973a7c87240c35289f5fdac2ea94f1848022f9499f37b4ab94172b6742649,
        s1: 0x30d584d4a24b6615090c37103916bac45ed17401b63596cd0c29167e5fe1267,
        s2: 0x2073c3846b613a00ccc615a8ac460c372105a979ddde4ef9d484c15aca2b874,
    };
    let hash_state = hashing::hash_u384(c_1, TWO_POW_96, part_II_state);

    // Hash Q = (Σ_i c_i*Q_i) to obtain random evaluation point z
    let z_felt252 = hashing::hash_u288_transcript(mpcheck_hint.big_Q.span(), hash_state).s0;

    if z_felt252 != mpcheck_hint.z {
        return Result::Err('WRONG_Z');
    }

    let (
        c_of_z,
        w_of_z,
        c_inv_of_z,
        LHS,
        c_inv_frob_1_of_z,
        c_frob_2_of_z,
        c_inv_frob_3_of_z,
        mlr_of_z,
    ): (u384, u384, u384, u384, u384, u384, u384, u384) =
        run_BN254_INITIALIZE_MPCHECK_EXT_MLR_circuit(
        mpcheck_hint.lambda_root,
        z,
        mpcheck_hint.w,
        mpcheck_hint.lambda_root_inverse,
        precomputed_miller_loop_result,
    );

    // init bit for bn254 is 0:
    // let mut Ris = mpcheck_hint.Ris;
    let R_0_of_Z = *evals.pop_front().unwrap();
    let [l0, l1] = (*lines.multi_pop_front::<2>().unwrap()).unbox();

    let (_Q2, _lhs) = mpc::run_BN254_MP_CHECK_INIT_BIT_3P_2F_circuit(
        yInv_0,
        xNegOverY_0,
        l0,
        yInv_1,
        xNegOverY_1,
        l1,
        processed_pair2.yInv,
        processed_pair2.xNegOverY,
        pair2.q,
        R_0_of_Z,
        z,
        c_inv_of_z,
        c_1,
        LHS,
    );

    let mut Q2 = _Q2;
    let mut LHS = _lhs;
    let mut f_i_of_z = R_0_of_Z;

    // rest of miller loop
    let mut bits = BN254_SEED_BITS_JY00_COMPRESSED.span();
    while let Option::Some(bit) = bits.pop_front() {
        let R_i_of_z = *evals.pop_front().unwrap();
        let (_Q2, _LHS): (G2Point, u384) = match *bit {
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
                    c_1,
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
                    c_1,
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
                    c_1,
                )
            },
        };
        Q2 = _Q2;
        LHS = _LHS;
        f_i_of_z = R_i_of_z;
    }
    let R_n_minus_2_of_z = *evals.pop_front().unwrap();
    let R_n_minus_1_of_z: u384 = One::one();

    let [l0, l1, l2, l3] = (*lines.multi_pop_front::<4>().unwrap()).unbox();
    let (check) = mpc::run_BN254_MP_CHECK_FINALIZE_3P_2F_EXT_MLR_circuit(
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
        R_n_minus_2_of_z,
        R_n_minus_1_of_z,
        c_1,
        w_of_z,
        z,
        c_inv_frob_1_of_z,
        c_frob_2_of_z,
        c_inv_frob_3_of_z,
        LHS,
        f_i_of_z,
        mpcheck_hint.big_Q,
        mlr_of_z,
    );

    // Checks that LHS = Q(z) * P_irr(z)
    match check.is_zero() {
        true => Result::Ok(true),
        false => Result::Err('FINAL_CHECK_FAILED'),
    }
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
pub fn multi_pairing_check_bls12_381_3P_2F_with_extra_miller_loop_result(
    pair0: G1G2Pair,
    pair1: G1G2Pair,
    pair2: G1G2Pair,
    precomputed_miller_loop_result: E12D<u384>,
    mut lines: Span<G2Line<u384>>,
    hint: MPCheckHintBLS12_381,
) -> Result<bool, felt252> {
    if hint.big_Q.len() != 105 {
        return Result::Err('WRONG_BIG_Q_LEN');
    }
    if hint.Ris.len() != 35 {
        return Result::Err('WRONG_RIS_LEN');
    }

    let (
        processed_pair0, processed_pair1, processed_pair2,
    ): (BLSProcessedPair, BLSProcessedPair, BLSProcessedPair) =
        run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3P_circuit(
        pair0.p, pair1.p, pair2.p,
    );

    // Init sponge state :
    // >>> hades_permutation(0, 0, int.from_bytes(b"MPCHECK_BLS12_381_3P_2F", "big"))
    let hash_state = PoseidonState {
        s0: 0x2cdfabd228064e9e12d17c6b3c59bff3db6b737403a03e9b5f5e9f53409097b,
        s1: 0x37fe3519c1f442f6e45b0abd23d975f1937365ed27e08019d58d011269ecac2,
        s2: 0x2eec9f98b93d8f14927c5de60386404306a0e55acb61076c1ad847b456efe0e,
    };

    // Hash Inputs.
    let hash_state = hashing::hash_G1G2Pair(pair0, hash_state);
    let hash_state = hashing::hash_G1G2Pair(pair1, hash_state);
    let hash_state = hashing::hash_G1G2Pair(pair2, hash_state);
    let hash_state = hashing::hash_E12D_u384(hint.lambda_root_inverse, hash_state);
    let hash_state = hashing::hash_MillerLoopResultScalingFactor_u384(hint.w, hash_state);
    // Hash Ris to obtain base random coefficient c0
    let z: u384 = hint.z.into();
    let (hash_state, mut evals) = basic_field_ops::eval_and_hash_E12D_u384_transcript(
        hint.Ris, hash_state, z,
    );
    let hash_state = hashing::hash_E12D_one_u384(hash_state);

    let hash_state = hashing::hash_E12D_u384(precomputed_miller_loop_result, hash_state);

    let mut evals = evals.span();

    let c_1: u384 = hash_state.s1.into();

    // hades_permutation(0,0,int.from_bytes(b"MPCHECK_BLS12_381_3P_2F_II", "big"))
    let part_II_state = PoseidonState {
        s0: 0x145195a6df395d777bf1be74601510cbf888ca638394385ade2f0bd91396a34,
        s1: 0x1f144143bab9bbc63c8376ae067c0b15ae4611b1aa725dd654cd41c25e0c20f,
        s2: 0x25df9ac859e9e9db19383887d5c27d94b619b6c8d1de37b8e713cb653f7b55f,
    };
    let hash_state = hashing::hash_u384(c_1, TWO_POW_96, part_II_state);

    // Hash Q = (Σ_i c_i*Q_i) to obtain random evaluation point z
    let z_felt252 = hashing::hash_u384_transcript(hint.big_Q.span(), hash_state).s0;

    if z_felt252 != hint.z {
        return Result::Err('WRONG_Z');
    }

    // Precompute lambda root evaluated in Z:
    let (conjugate_c_inv_of_z, w_of_z, c_inv_of_z_frob_1, mlr_of_z): (u384, u384, u384, u384) =
        run_BLS12_381_INITIALIZE_MPCHECK_EXT_MLR_circuit(
        hint.lambda_root_inverse, z, hint.w, precomputed_miller_loop_result,
    );

    // init bit for bls is 1:
    let R_0_of_Z = *evals.pop_front().unwrap();
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
    let mut bits = BLS12_381_SEED_BITS_COMPRESSED.span();

    while let Option::Some(bit) = bits.pop_front() {
        let R_i_of_z = *evals.pop_front().unwrap();
        let (_Q2, _LHS): (G2Point, u384) = match *bit {
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
                    c_1,
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
                    c_1,
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
                    c_1,
                )
            },
        };
        Q2 = _Q2;
        LHS = _LHS;
        f_i_of_z = R_i_of_z;
    }

    let R_last_of_z: u384 = One::one();

    // Checks that LHS = Q(z) * P_irr(z)
    let (check) = mpc::run_BLS12_381_MP_CHECK_FINALIZE_3P_EXT_MLR_circuit(
        R_last_of_z, c_1, w_of_z, z, c_inv_of_z_frob_1, LHS, *hint.Ris.at(34), hint.big_Q, mlr_of_z,
    );

    match check.is_zero() {
        true => Result::Ok(true),
        false => Result::Err('FINAL_CHECK_FAILED'),
    }
}

pub fn conjugate_e12D(self: E12D<u384>, curve_index: usize) -> E12D<u384> {
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
