use core::array::{ArrayTrait, SpanTrait};
use core::circuit::u384;
use core::num::traits::{One, Zero};
use core::option::Option;

/// This file contains utilities to verify a pairing check of the form :
/// e(P1, Qf1) * e(P2, Qf2) == 1, where Qf1 and Qf2 are fixed known points. (2P_2F circuits are used
/// for double pairs and double fixed G2 points)
/// Qf1 and Qf2 are represented by their pre-computed line functions for the specifc miller loop
/// implementation.
/// Two functions are provided for BN254 and BLS12-381 respectively.
/// To generate the lines functions, you can use garaga's python backend.

use core::option::OptionTrait;
use core::poseidon::hades_permutation;
use garaga::basic_field_ops::{compute_yInvXnegOverY_BLS12_381, compute_yInvXnegOverY_BN254};
use garaga::circuits::extf_mul::run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit;
use garaga::circuits::multi_pairing_check::{
    run_BLS12_381_MP_CHECK_BIT00_2P_2F_circuit, run_BLS12_381_MP_CHECK_BIT0_2P_2F_circuit,
    run_BLS12_381_MP_CHECK_BIT1_2P_2F_circuit, run_BLS12_381_MP_CHECK_FINALIZE_BLS_2P_circuit,
    run_BLS12_381_MP_CHECK_INIT_BIT_2P_2F_circuit,
    run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit,
    run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2P_circuit, run_BN254_MP_CHECK_BIT00_2P_2F_circuit,
    run_BN254_MP_CHECK_BIT01_2P_2F_circuit, run_BN254_MP_CHECK_BIT10_2P_2F_circuit,
    run_BN254_MP_CHECK_FINALIZE_BN_2P_2F_circuit, run_BN254_MP_CHECK_INIT_BIT_2P_2F_circuit,
    run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit, run_BN254_MP_CHECK_PREPARE_PAIRS_2P_circuit,
};
use garaga::definitions::{
    BLSProcessedPair, BNProcessedPair, E12D, G1G2Pair, G1Point, G2Line, G2Point,
    MillerLoopResultScalingFactor, bls_bits, bn_bits, u288,
};
use garaga::utils::{hashing, u384_assert_zero, usize_assert_eq};
use garaga::{basic_field_ops, utils};


#[derive(Drop, Serde, Debug)]
pub struct MPCheckHintBN254 {
    pub lambda_root: E12D<u288>,
    pub lambda_root_inverse: E12D<u288>,
    pub w: MillerLoopResultScalingFactor<u288>,
    pub Ris: Span<E12D<u288>>,
    pub big_Q: Array<u288>,
    pub z: felt252,
}

#[derive(Drop, Debug, PartialEq)]
pub struct MPCheckHintBLS12_381 {
    pub lambda_root_inverse: E12D<u384>,
    pub w: MillerLoopResultScalingFactor<u384>,
    pub Ris: Span<E12D<u384>>,
    pub big_Q: Array<u384>,
    pub z: felt252,
}


#[inline(always)]
fn multi_pairing_check_bn254_2P_2F(
    pair0: G1G2Pair, pair1: G1G2Pair, mut lines: Span<G2Line<u288>>, hint: MPCheckHintBN254,
) -> bool {
    usize_assert_eq(hint.big_Q.len(), 145);
    usize_assert_eq(hint.Ris.len(), 34);

    let (yInv_0, xNegOverY_0) = compute_yInvXnegOverY_BN254(pair0.p.x, pair0.p.y);
    let (yInv_1, xNegOverY_1) = compute_yInvXnegOverY_BN254(pair1.p.x, pair1.p.y);

    // Init sponge state
    // >>> hades_permutation(int.from_bytes(b"MPCHECK_BN254_2P_2F", "big"), 0, 1)

    let (s0, s1, s2) = (
        0x68d2a3cc4a3b2f1d317e7666256ca63efd983952025ffa78d32d4032e76e918,
        0x4ea762aacef0cbba4cf150cf273fcc20874daaf40937062001104ce970a76f3,
        0x42aab602bbf1944066179f43c84e0eee75c531ec7b2c7d479d554e368c4e07c,
    );
    // Hash Inputs
    let (s0, s1, s2) = hashing::hash_G1G2Pair(pair0, s0, s1, s2);
    let (s0, s1, s2) = hashing::hash_G1G2Pair(pair1, s0, s1, s2);
    let (s0, s1, s2) = hashing::hash_E12D_u288(hint.lambda_root, s0, s1, s2);
    let (s0, s1, s2) = hashing::hash_E12D_u288(hint.lambda_root_inverse, s0, s1, s2);
    let (s0, s1, s2) = hashing::hash_MillerLoopResultScalingFactor_u288(hint.w, s0, s1, s2);
    // Hash Ris to obtain base random coefficient c0 and evals
    let z: u384 = hint.z.into();

    let (s0, s1, s2, mut evals) = basic_field_ops::eval_and_hash_E12D_u288_transcript(
        hint.Ris, s0, s1, s2, z,
    );
    // Last Ri is known to be 1:
    let (s0, s1, s2) = hashing::hash_E12D_one(s0, s1, s2);

    let mut evals = evals.span();
    let mut c_i: u384 = s1.into();

    // Hash Q = (Σ_i c_i*Q_i) to obtain random evaluation point z
    let (z_felt252, _, _) = hashing::hash_u288_transcript(hint.big_Q.span(), s0, s1, s2);

    assert!(z_felt252 == hint.z);

    let (
        c_of_z, w_of_z, c_inv_of_z, LHS, c_inv_frob_1_of_z, c_frob_2_of_z, c_inv_frob_3_of_z,
    ): (u384, u384, u384, u384, u384, u384, u384) =
        run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
        hint.lambda_root, z, hint.w, hint.lambda_root_inverse, c_i,
    );

    let R_0_of_Z = *evals.pop_front().unwrap();
    let [l0, l1] = (*lines.multi_pop_front::<2>().unwrap()).unbox();
    let (_lhs, _c_i) = run_BN254_MP_CHECK_INIT_BIT_2P_2F_circuit(
        yInv_0, xNegOverY_0, l0, yInv_1, xNegOverY_1, l1, R_0_of_Z, c_i, z, c_inv_of_z, LHS,
    );

    let mut LHS = _lhs;
    let mut f_i_of_z = R_0_of_Z;
    c_i = _c_i;

    // rest of miller loop
    let mut bits = bn_bits.span();

    while let Option::Some(bit) = bits.pop_front() {
        // println!("bit {}", *bit);
        let R_i_of_z = *evals.pop_front().unwrap();
        let (_LHS, _c_i): (u384, u384) = match *bit {
            0 => {
                let [l0, l1, l2, l3] = (*lines.multi_pop_front::<4>().unwrap()).unbox();
                run_BN254_MP_CHECK_BIT00_2P_2F_circuit(
                    yInv_0,
                    xNegOverY_0,
                    l0,
                    l1,
                    yInv_1,
                    xNegOverY_1,
                    l2,
                    l3,
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    z,
                    c_i,
                )
            },
            1 |
            2 => {
                let [l0, l1, l2, l3, l4, l5] = (*lines.multi_pop_front::<6>().unwrap()).unbox();
                let c_or_c_inv_of_z = match (*bit - 1) {
                    0 => c_inv_of_z,
                    _ => c_of_z,
                };
                run_BN254_MP_CHECK_BIT10_2P_2F_circuit(
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
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    c_or_c_inv_of_z,
                    z,
                    c_i,
                )
            },
            _ => {
                // 3 -> 01, 4 -> 10
                let [l0, l1, l2, l3, l4, l5] = (*lines.multi_pop_front::<6>().unwrap()).unbox();
                let c_or_c_inv_of_z = match (*bit - 3) {
                    0 => c_inv_of_z,
                    _ => c_of_z,
                };
                run_BN254_MP_CHECK_BIT01_2P_2F_circuit(
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
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    c_or_c_inv_of_z,
                    z,
                    c_i,
                )
            },
        };
        LHS = _LHS;
        f_i_of_z = R_i_of_z;
        c_i = _c_i;
    }

    let R_n_minus_2_of_z = *evals.pop_front().unwrap();
    let R_n_minus_1_of_z: u384 = One::one();
    let [l0, l1, l2, l3] = (*lines.multi_pop_front::<4>().unwrap()).unbox();
    let (check) = run_BN254_MP_CHECK_FINALIZE_BN_2P_2F_circuit(
        yInv_0,
        xNegOverY_0,
        l0,
        l1,
        yInv_1,
        xNegOverY_1,
        l2,
        l3,
        R_n_minus_2_of_z,
        R_n_minus_1_of_z,
        c_i,
        w_of_z,
        z,
        c_inv_frob_1_of_z,
        c_frob_2_of_z,
        c_inv_frob_3_of_z,
        LHS,
        f_i_of_z,
        hint.big_Q,
    );

    return check.is_zero();
}

#[inline(always)]
fn multi_pairing_check_bls12_381_2P_2F(
    pair0: G1G2Pair, pair1: G1G2Pair, mut lines: Span<G2Line<u384>>, hint: MPCheckHintBLS12_381,
) -> bool {
    usize_assert_eq(hint.big_Q.len(), 81);
    usize_assert_eq(hint.Ris.len(), 35);

    let (yInv_0, xNegOverY_0) = compute_yInvXnegOverY_BLS12_381(pair0.p.x, pair0.p.y);
    let (yInv_1, xNegOverY_1) = compute_yInvXnegOverY_BLS12_381(pair1.p.x, pair1.p.y);

    // Init sponge state
    let (s0, s1, s2) = hades_permutation('MPCHECK_BLS12_381_2P_2F', 0, 1);
    // Hash Inputs

    let (s0, s1, s2) = hashing::hash_G1G2Pair(pair0, s0, s1, s2);
    let (s0, s1, s2) = hashing::hash_G1G2Pair(pair1, s0, s1, s2);
    let (s0, s1, s2) = hashing::hash_E12D_u384(hint.lambda_root_inverse, s0, s1, s2);
    let (s0, s1, s2) = hashing::hash_MillerLoopResultScalingFactor_u384(hint.w, s0, s1, s2);
    // Hash Ris to obtain base random coefficient c0 & evaluate all Ris at z (given in advance).
    let z: u384 = hint.z.into();
    let (s0, s1, s2, mut evals) = basic_field_ops::eval_and_hash_E12D_u384_transcript(
        hint.Ris, s0, s1, s2, z,
    );
    // Last Ri is known to be 1:
    let (s0, s1, s2) = hashing::hash_E12D_one(s0, s1, s2);

    let mut evals = evals.span();

    let mut c_i: u384 = s1.into();

    // Hash Q = (Σ_i c_i*Q_i) to obtain random evaluation point z
    let (z_felt252, _, _) = hashing::hash_u384_transcript(hint.big_Q.span(), s0, s1, s2);
    assert(z_felt252 == hint.z, 'z mismatch');

    // Precompute lambda root evaluated in Z:
    let (conjugate_c_inv_of_z, w_of_z, c_inv_of_z_frob_1): (u384, u384, u384) =
        run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
        hint.lambda_root_inverse, z, hint.w,
    );

    // init bit for bls is 1:
    let R_0_of_Z = *evals.pop_front().unwrap();
    let [l0, l1, l2, l3] = (*lines.multi_pop_front::<4>().unwrap()).unbox();
    let (_lhs) = run_BLS12_381_MP_CHECK_INIT_BIT_2P_2F_circuit(
        yInv_0,
        xNegOverY_0,
        l0,
        l1,
        yInv_1,
        xNegOverY_1,
        l2,
        l3,
        R_0_of_Z,
        c_i,
        z,
        conjugate_c_inv_of_z,
    );

    let mut LHS = _lhs;
    let mut f_i_of_z = R_0_of_Z;

    // Σ_i (Π_k (c_i*P_k(z)))  = (Σ_i c_i*Q_i(z)) * P(z) + Σ_i c_i * R_i(z)
    // <=> Σ_i (Π_k (c_i*P_k(z))) - Σ_i c_i * R_i(z) = (Σ_i c_i*Q_i(z)) * P(z)
    // => LHS = Σ_i (Π_k (c_i*P_k(z))) - Σ_i c_i * R_i(z)

    // rest of miller loop
    let mut bits = bls_bits.span();

    while let Option::Some(bit) = bits.pop_front() {
        let R_i_of_z = *evals.pop_front().unwrap();
        let (_LHS, _c_i): (u384, u384) = match *bit {
            0 => {
                let [l0, l1] = (*lines.multi_pop_front::<2>().unwrap()).unbox();
                run_BLS12_381_MP_CHECK_BIT0_2P_2F_circuit(
                    yInv_0,
                    xNegOverY_0,
                    l0,
                    yInv_1,
                    xNegOverY_1,
                    l1,
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    z,
                    c_i,
                )
            },
            1 => {
                let [l0, l1, l2, l3] = (*lines.multi_pop_front::<4>().unwrap()).unbox();
                run_BLS12_381_MP_CHECK_BIT1_2P_2F_circuit(
                    yInv_0,
                    xNegOverY_0,
                    l0,
                    l1,
                    yInv_1,
                    xNegOverY_1,
                    l2,
                    l3,
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
                run_BLS12_381_MP_CHECK_BIT00_2P_2F_circuit(
                    yInv_0,
                    xNegOverY_0,
                    l0,
                    l1,
                    yInv_1,
                    xNegOverY_1,
                    l2,
                    l3,
                    LHS,
                    f_i_of_z,
                    R_i_of_z,
                    z,
                    c_i,
                )
            },
        };
        LHS = _LHS;
        f_i_of_z = R_i_of_z;
        c_i = _c_i;
    }

    let R_last_of_z: u384 = One::one();
    let (check,) = run_BLS12_381_MP_CHECK_FINALIZE_BLS_2P_circuit(
        R_last_of_z, c_i, w_of_z, z, c_inv_of_z_frob_1, LHS, f_i_of_z, hint.big_Q,
    );

    return check.is_zero();
}
