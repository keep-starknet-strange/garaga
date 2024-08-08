/// This file contains utilities to verify a pairing check of the form :
/// e(P1, Qf1) * e(P2, Qf2) == 1, where Qf1 and Qf2 are fixed known points. (2P_2F circuits are used
/// for double pairs and double fixed G2 points)
/// Qf1 and Qf2 are represented by their pre-computed line functions for the specifc miller loop
/// implementation.
/// Two functions are provided for BN254 and BLS12-381 respectively.
/// To generate the lines functions, you can use garaga's python backend.

use core::option::OptionTrait;
use core::array::ArrayTrait;
use garaga::circuits::multi_pairing_check::{
    run_BLS12_381_MP_CHECK_BIT0_2P_2F_circuit, run_BLS12_381_MP_CHECK_BIT00_2P_2F_circuit,
    run_BLS12_381_MP_CHECK_BIT1_2P_2F_circuit, run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2P_circuit,
    run_BN254_MP_CHECK_BIT0_2P_2F_circuit, run_BN254_MP_CHECK_BIT00_2P_2F_circuit,
    run_BN254_MP_CHECK_BIT1_2P_2F_circuit, run_BN254_MP_CHECK_PREPARE_PAIRS_2P_circuit,
    run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit,
    run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit, run_BLS12_381_MP_CHECK_INIT_BIT_2P_2F_circuit,
    run_BN254_MP_CHECK_INIT_BIT_2P_2F_circuit, run_BN254_MP_CHECK_FINALIZE_BN_2P_2F_circuit,
    run_BLS12_381_MP_CHECK_FINALIZE_BLS_2P_circuit,
};
use garaga::circuits::extf_mul::{
    run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit, run_BN254_FP12_MUL_ASSERT_ONE_circuit,
    run_BN254_EVAL_E12D_circuit, run_BLS12_381_EVAL_E12D_circuit
};
use core::poseidon::hades_permutation;

use garaga::definitions::{
    G1Point, G2Point, G1G2Pair, u384, bn_bits, bls_bits, MillerLoopResultScalingFactor, E12D,
    E12DMulQuotient, BNProcessedPair, BLSProcessedPair, E12DDefinitions, G2Line
};
use core::option::Option;
use garaga::utils;
use core::array::{SpanTrait};


#[derive(Drop)]
struct MPCheckHintBN254 {
    lambda_root: E12D,
    lambda_root_inverse: E12D,
    w: MillerLoopResultScalingFactor,
    Ris: Span<E12D>,
    big_Q: Array<u384>,
}

#[derive(Drop)]
struct MPCheckHintBLS12_381 {
    lambda_root_inverse: E12D,
    w: MillerLoopResultScalingFactor,
    Ris: Span<E12D>,
    big_Q: Array<u384>,
}

fn multi_pairing_check_bn254_2P_2F(
    pair0: G1G2Pair, pair1: G1G2Pair, mut lines: Span<G2Line>, hint: MPCheckHintBN254,
) -> bool {
    assert!(
        hint.big_Q.len() == 87,
        "Wrong Q degree for BN254 2-Pairs Pairing check, should be degree 86 (87 coefficients)"
    );
    assert!(
        hint.Ris.len() == 53, "Wrong Number of Ris for BN254 Multi-Pairing check, should be 54"
    );

    let (processed_pair0, processed_pair1): (BNProcessedPair, BNProcessedPair) =
        run_BN254_MP_CHECK_PREPARE_PAIRS_2P_circuit(
        pair0.p, pair0.q.y0, pair0.q.y1, pair1.p, pair1.q.y0, pair1.q.y1
    );

    // Init sponge state
    let (s0, s1, s2) = hades_permutation('MPCHECK_BN254_2P_2F', 0, 1);
    // Hash Inputs
    let (s0, s1, s2) = utils::hash_G1G2Pair(pair0, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_G1G2Pair(pair1, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_E12D(hint.lambda_root, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_E12D(hint.lambda_root_inverse, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_MillerLoopResultScalingFactor(hint.w, s0, s1, s2);
    // Hash Ris to obtain base random coefficient c0
    let (s0, s1, s2) = utils::hash_E12D_transcript(hint.Ris, s0, s1, s2);
    let mut c_i: u384 = s1.into();

    // Hash Q = (Σ_i c_i*Q_i) to obtain random evaluation point z
    let (z_felt252, _, _) = utils::hash_u384_transcript(hint.big_Q.span(), s0, s1, s2);
    let z: u384 = z_felt252.into();

    let (
        c_of_z, w_of_z, c_inv_of_z, LHS, c_inv_frob_1_of_z, c_frob_2_of_z, c_inv_frob_3_of_z
    ): (u384, u384, u384, u384, u384, u384, u384) =
        run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
        hint.lambda_root, z, hint.w, hint.lambda_root_inverse, c_i
    );

    // init bit for bn254 is 0:
    let R_0 = hint.Ris.at(0);
    let (_lhs, _c_i, _f_1_of_z) = run_BN254_MP_CHECK_INIT_BIT_2P_2F_circuit(
        processed_pair0.yInv,
        processed_pair0.xNegOverY,
        *lines.pop_front().unwrap(),
        processed_pair1.yInv,
        processed_pair1.xNegOverY,
        *lines.pop_front().unwrap(),
        *R_0,
        c_i,
        z,
        c_inv_of_z,
        LHS
    );

    let mut LHS = _lhs;
    let mut f_i_of_z = _f_1_of_z;
    c_i = _c_i;

    // rest of miller loop
    let mut bits = bn_bits.span();
    let mut R_i_index = 1;

    while let Option::Some(bit) = bits.pop_front() {
        let R_i = hint.Ris.at(R_i_index);
        let (R_i_of_z) = run_BN254_EVAL_E12D_circuit(*R_i, z);
        R_i_index += 1;
        let (_LHS, _c_i): (u384, u384) = match *bit {
            0 => {
                run_BN254_MP_CHECK_BIT0_2P_2F_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    *lines.pop_front().unwrap(),
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    *lines.pop_front().unwrap(),
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    z,
                    c_i
                )
            },
            1 => {
                run_BN254_MP_CHECK_BIT1_2P_2F_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    c_inv_of_z,
                    z,
                    c_i,
                )
            },
            2 => {
                run_BN254_MP_CHECK_BIT1_2P_2F_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    c_of_z,
                    z,
                    c_i,
                )
            },
            _ => {
                run_BN254_MP_CHECK_BIT00_2P_2F_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    z,
                    c_i
                )
            }
        };
        LHS = _LHS;
        f_i_of_z = R_i_of_z;
        c_i = _c_i;
    };

    let R_n_minus_2 = hint.Ris.at(hint.Ris.len() - 2);
    let R_last = hint.Ris.at(hint.Ris.len() - 1);
    let (check) = run_BN254_MP_CHECK_FINALIZE_BN_2P_2F_circuit(
        processed_pair0.yInv,
        processed_pair0.xNegOverY,
        *lines.pop_front().unwrap(),
        *lines.pop_front().unwrap(),
        processed_pair1.yInv,
        processed_pair1.xNegOverY,
        *lines.pop_front().unwrap(),
        *lines.pop_front().unwrap(),
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
        hint.big_Q
    );

    assert!(check == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }, "Final check failed");

    assert!(*R_last == E12DDefinitions::one());
    return true;
}

fn multi_pairing_check_bls12_381_2P_2F(
    pair0: G1G2Pair, pair1: G1G2Pair, mut lines: Span<G2Line>, hint: MPCheckHintBLS12_381
) -> bool {
    assert!(
        hint.big_Q.len() == 81,
        "Wrong Q degree for BLS12-381 2-Pairs Paring check, should be degree 80 (81 coeffs)"
    );
    assert!(
        hint.Ris.len() == 36, "Wrong Number of Ris for BLS12-381 2-Pairs Paring check, should be 64"
    );
    let (processed_pair0, processed_pair1): (BLSProcessedPair, BLSProcessedPair) =
        run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2P_circuit(
        pair0.p, pair1.p
    );

    // Init sponge state
    let (s0, s1, s2) = hades_permutation('MPCHECK_BLS12_381_2P_2F', 0, 1);
    // Hash Inputs

    let (s0, s1, s2) = utils::hash_G1G2Pair(pair0, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_G1G2Pair(pair1, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_E12D(hint.lambda_root_inverse, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_MillerLoopResultScalingFactor(hint.w, s0, s1, s2);
    // Hash Ris to obtain base random coefficient c0
    let (s0, s1, s2) = utils::hash_E12D_transcript(hint.Ris, s0, s1, s2);

    let mut c_i: u384 = s1.into();

    // Hash Q = (Σ_i c_i*Q_i) to obtain random evaluation point z
    let (z_felt252, _, _) = utils::hash_u384_transcript(hint.big_Q.span(), s0, s1, s2);
    let z: u384 = z_felt252.into();

    // Precompute lambda root evaluated in Z:
    let (conjugate_c_inv_of_z, w_of_z, c_inv_of_z_frob_1): (u384, u384, u384) =
        run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
        hint.lambda_root_inverse, z, hint.w
    );

    // init bit for bls is 1:
    let R_0 = hint.Ris.at(0);
    let (_lhs, _f_1_of_z) = run_BLS12_381_MP_CHECK_INIT_BIT_2P_2F_circuit(
        processed_pair0.yInv,
        processed_pair0.xNegOverY,
        *lines.pop_front().unwrap(),
        *lines.pop_front().unwrap(),
        processed_pair1.yInv,
        processed_pair1.xNegOverY,
        *lines.pop_front().unwrap(),
        *lines.pop_front().unwrap(),
        *R_0,
        c_i,
        z,
        conjugate_c_inv_of_z
    );

    let mut LHS = _lhs;
    let mut f_i_of_z = _f_1_of_z;

    // Σ_i (Π_k (c_i*P_k(z)))  = (Σ_i c_i*Q_i(z)) * P(z) + Σ_i c_i * R_i(z)
    // <=> Σ_i (Π_k (c_i*P_k(z))) - Σ_i c_i * R_i(z) = (Σ_i c_i*Q_i(z)) * P(z)
    // => LHS = Σ_i (Π_k (c_i*P_k(z))) - Σ_i c_i * R_i(z)

    // rest of miller loop
    let mut bits = bls_bits.span();
    let mut R_i_index = 1;

    while let Option::Some(bit) = bits.pop_front() {
        let R_i = hint.Ris.at(R_i_index);
        let (R_i_of_z) = run_BLS12_381_EVAL_E12D_circuit(*R_i, z);
        R_i_index += 1;
        let (_LHS, _c_i): (u384, u384) = match *bit {
            0 => {
                run_BLS12_381_MP_CHECK_BIT0_2P_2F_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    *lines.pop_front().unwrap(),
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    *lines.pop_front().unwrap(),
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    z,
                    c_i
                )
            },
            1 => {
                run_BLS12_381_MP_CHECK_BIT1_2P_2F_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    conjugate_c_inv_of_z,
                    z,
                    c_i
                )
            },
            _ => {
                run_BLS12_381_MP_CHECK_BIT00_2P_2F_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    z,
                    c_i
                )
            }
        };
        LHS = _LHS;
        f_i_of_z = R_i_of_z;
        c_i = _c_i;
    };

    let R_last = hint.Ris.at(hint.Ris.len() - 1);
    let (check,) = run_BLS12_381_MP_CHECK_FINALIZE_BLS_2P_circuit(
        *R_last, c_i, w_of_z, z, c_inv_of_z_frob_1, LHS, f_i_of_z, hint.big_Q
    );

    assert!(check == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }, "Final check failed");

    assert!(*R_last == E12DDefinitions::one());
    return true;
}
