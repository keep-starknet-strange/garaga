use core::array::{ArrayTrait, SpanTrait};
use core::circuit::{
    CircuitElement as CE, CircuitInput as CI, CircuitInputs, CircuitModulus, CircuitOutputsTrait,
    EvalCircuitTrait, circuit_inverse, circuit_mul, circuit_sub, u384,
};
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
use garaga::basic_field_ops;
use garaga::circuits::multi_pairing_check::{
    run_BLS12_381_INITIALIZE_MPCHECK_circuit, run_BLS12_381_MP_CHECK_BIT00_2P_2F_circuit,
    run_BLS12_381_MP_CHECK_BIT0_2P_2F_circuit, run_BLS12_381_MP_CHECK_BIT1_2P_2F_circuit,
    run_BLS12_381_MP_CHECK_FINALIZE_BLS_2P_circuit, run_BLS12_381_MP_CHECK_INIT_BIT_2P_2F_circuit,
    run_BN254_INITIALIZE_MPCHECK_circuit, run_BN254_MP_CHECK_BIT00_2P_2F_circuit,
    run_BN254_MP_CHECK_BIT01_2P_2F_circuit, run_BN254_MP_CHECK_BIT10_2P_2F_circuit,
    run_BN254_MP_CHECK_FINALIZE_BN_2P_2F_circuit, run_BN254_MP_CHECK_INIT_BIT_2P_2F_circuit,
};
use garaga::definitions::{
    BLS12_381_SEED_BITS_COMPRESSED, BN254_SEED_BITS_JY00_COMPRESSED, E12D, G1G2Pair, G2Line,
    MillerLoopResultScalingFactor, get_BLS12_381_modulus, get_BN254_modulus, u288,
};
use garaga::utils::{hashing, usize_assert_eq};
use crate::core::circuit::AddInputResultTrait2;


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

// From a G1G2Pair(Px, Py, Qx0, Qx1, Qy0, Qy1), returns (1/Py, -Px/Py)
#[derive(Drop, Debug, PartialEq)]
pub struct BLSProcessedPair {
    pub yInv: u384,
    pub xNegOverY: u384,
}

// From a G1G2Pair(Px, Py, Qx0, Qx1, Qy0, Qy1), returns (1/Py, -Px/Py,-Qy0, -Qy1)
#[derive(Drop, Debug, PartialEq)]
pub struct BNProcessedPair {
    pub yInv: u384,
    pub xNegOverY: u384,
    pub QyNeg0: u384,
    pub QyNeg1: u384,
}

// From a point (x, y), returns (1/y, -x/y)
pub fn compute_yInvXnegOverY(x: u384, y: u384, modulus: CircuitModulus) -> (u384, u384) {
    let in1 = CE::<CI<0>> {};
    let in2 = CE::<CI<1>> {};
    let in3 = CE::<CI<2>> {};
    let yInv = circuit_inverse(in3);
    let xNeg = circuit_sub(in1, in2);
    let xNegOverY = circuit_mul(xNeg, yInv);

    let outputs = (yInv, xNegOverY)
        .new_inputs()
        .next_2([0, 0, 0, 0])
        .next_2(x)
        .next_2(y)
        .done_2()
        .eval(modulus)
        .unwrap();

    return (outputs.get_output(yInv), outputs.get_output(xNegOverY));
}
#[inline(always)]
pub fn multi_pairing_check_bn254_2P_2F(
    pair0: G1G2Pair, pair1: G1G2Pair, mut lines: Span<G2Line<u288>>, hint: MPCheckHintBN254,
) -> bool {
    usize_assert_eq(hint.big_Q.len(), 145);
    usize_assert_eq(hint.Ris.len(), 34);

    let modulus = get_BN254_modulus(); // BN254 prime field modulus
    let (yInv_0, xNegOverY_0) = compute_yInvXnegOverY(pair0.p.x, pair0.p.y, modulus);
    let (yInv_1, xNegOverY_1) = compute_yInvXnegOverY(pair1.p.x, pair1.p.y, modulus);

    // Init sponge state
    // >>> hades_permutation(0, 0, int.from_bytes(b"MPCHECK_BN254_2P_2F", "big"))

    let (s0, s1, s2) = (
        0x1a0eeac356472db3074d1ca6bb7bbb60fa9f0d53b34ef38a4eddde21b332b28,
        0x2783a4227674921675bfa12e30fda0dad992bb9be9785908ac1338b14018182,
        0x5d4b7659197d4e54258057765dd5e6dbf106bb3bd5a559fe1951303901e2e81,
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
    let c_1: u384 = s1.into();

    // Hash Q = (Σ_i c_i*Q_i) to obtain random evaluation point z
    let (z_felt252, _, _) = hashing::hash_u288_transcript(hint.big_Q.span(), s0, s1, s2);

    assert!(z_felt252 == hint.z);

    let (
        c_of_z, w_of_z, c_inv_of_z, LHS, c_inv_frob_1_of_z, c_frob_2_of_z, c_inv_frob_3_of_z,
    ): (u384, u384, u384, u384, u384, u384, u384) =
        run_BN254_INITIALIZE_MPCHECK_circuit(
        hint.lambda_root, z, hint.w, hint.lambda_root_inverse,
    );

    let R_0_of_Z = *evals.pop_front().unwrap();
    let [l0, l1] = (*lines.multi_pop_front::<2>().unwrap()).unbox();
    let (_lhs) = run_BN254_MP_CHECK_INIT_BIT_2P_2F_circuit(
        yInv_0, xNegOverY_0, l0, yInv_1, xNegOverY_1, l1, R_0_of_Z, z, c_inv_of_z, c_1, LHS,
    );

    let mut LHS = _lhs;
    let mut f_i_of_z = R_0_of_Z;

    // rest of miller loop
    let mut bits = BN254_SEED_BITS_JY00_COMPRESSED.span();

    while let Option::Some(bit) = bits.pop_front() {
        // println!("bit {}", *bit);
        let R_i_of_z = *evals.pop_front().unwrap();
        let (_LHS): (u384,) = match *bit {
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
                    c_1,
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
                    c_1,
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
                    c_1,
                )
            },
        };
        LHS = _LHS;
        f_i_of_z = R_i_of_z;
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
        c_1,
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
pub fn multi_pairing_check_bls12_381_2P_2F(
    pair0: G1G2Pair, pair1: G1G2Pair, mut lines: Span<G2Line<u384>>, hint: MPCheckHintBLS12_381,
) -> bool {
    usize_assert_eq(hint.big_Q.len(), 81);
    usize_assert_eq(hint.Ris.len(), 35);

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus
    let (yInv_0, xNegOverY_0) = compute_yInvXnegOverY(pair0.p.x, pair0.p.y, modulus);
    let (yInv_1, xNegOverY_1) = compute_yInvXnegOverY(pair1.p.x, pair1.p.y, modulus);

    // Init sponge state
    // >>> hades_permutation(0, 0, int.from_bytes(b"MPCHECK_BLS12_381_2P_2F", "big"))
    let (s0, s1, s2) = (
        0x38fc487c6a5413cb099f102857912e93570c7a3628b34722ec1fff8cefa6f5f,
        0x3cec4f7f551bccf7cbfbfd86cde672f2104b89d5443707c7ca7aca8196f4d0f,
        0x5ff52024b20f5cd082b347b5455a15a265874a39983c38ed544090b750ee718,
    );

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

    let c_1: u384 = s1.into();

    // Hash Q = (Σ_i c_i*Q_i) to obtain random evaluation point z
    let (z_felt252, _, _) = hashing::hash_u384_transcript(hint.big_Q.span(), s0, s1, s2);
    assert(z_felt252 == hint.z, 'z mismatch');

    // Precompute lambda root evaluated in Z:
    let (conjugate_c_inv_of_z, w_of_z, c_inv_of_z_frob_1): (u384, u384, u384) =
        run_BLS12_381_INITIALIZE_MPCHECK_circuit(
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
        z,
        conjugate_c_inv_of_z,
    );

    let mut LHS = _lhs;
    let mut f_i_of_z = R_0_of_Z;

    // Σ_i (Π_k (c_i*P_k(z)))  = (Σ_i c_i*Q_i(z)) * P(z) + Σ_i c_i * R_i(z)
    // <=> Σ_i (Π_k (c_i*P_k(z))) - Σ_i c_i * R_i(z) = (Σ_i c_i*Q_i(z)) * P(z)
    // => LHS = Σ_i (Π_k (c_i*P_k(z))) - Σ_i c_i * R_i(z)

    // rest of miller loop
    let mut bits = BLS12_381_SEED_BITS_COMPRESSED.span();

    while let Option::Some(bit) = bits.pop_front() {
        let R_i_of_z = *evals.pop_front().unwrap();
        let (_LHS): (u384,) = match *bit {
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
                    c_1,
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
                    c_1,
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
                    c_1,
                )
            },
        };
        LHS = _LHS;
        f_i_of_z = R_i_of_z;
    }

    let R_last_of_z: u384 = One::one();
    let (check,) = run_BLS12_381_MP_CHECK_FINALIZE_BLS_2P_circuit(
        R_last_of_z, c_1, w_of_z, z, c_inv_of_z_frob_1, LHS, f_i_of_z, hint.big_Q,
    );

    return check.is_zero();
}
