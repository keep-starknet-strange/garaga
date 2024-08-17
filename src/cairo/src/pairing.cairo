use core::option::OptionTrait;
use core::array::ArrayTrait;
use garaga::circuits::multi_pairing_check::{
    run_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit, run_BLS12_381_MP_CHECK_BIT0_LOOP_3_circuit,
    run_BLS12_381_MP_CHECK_BIT1_LOOP_2_circuit, run_BLS12_381_MP_CHECK_BIT1_LOOP_3_circuit,
    run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit, run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit,
    run_BN254_MP_CHECK_BIT0_LOOP_2_circuit, run_BN254_MP_CHECK_BIT0_LOOP_3_circuit,
    run_BN254_MP_CHECK_BIT1_LOOP_2_circuit, run_BN254_MP_CHECK_BIT1_LOOP_3_circuit,
    run_BN254_MP_CHECK_PREPARE_PAIRS_3_circuit, run_BN254_MP_CHECK_PREPARE_PAIRS_2_circuit,
    run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit,
    run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit, run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit,
    run_BLS12_381_MP_CHECK_INIT_BIT_3_circuit, run_BN254_MP_CHECK_INIT_BIT_2_circuit,
    run_BN254_MP_CHECK_INIT_BIT_3_circuit, run_BN254_MP_CHECK_FINALIZE_BN_2_circuit,
    run_BN254_MP_CHECK_FINALIZE_BN_3_circuit, run_BLS12_381_MP_CHECK_FINALIZE_BLS_2_circuit,
    run_BLS12_381_MP_CHECK_FINALIZE_BLS_3_circuit
};
use garaga::circuits::extf_mul::{run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit};
use core::poseidon::hades_permutation;

use garaga::definitions::{
    G1Point, G2Point, G1G2Pair, u384, bn_bits, bls_bits, MillerLoopResultScalingFactor, E12D,
    E12DMulQuotient, BNProcessedPair, BLSProcessedPair, E12DDefinitions
};
use core::option::Option;
use garaga::utils;
use core::array::{SpanTrait};


fn multi_pairing_check_bn254_2_pairs(
    pair0: G1G2Pair,
    pair1: G1G2Pair,
    lambda_root: E12D,
    w: MillerLoopResultScalingFactor,
    Ris: Array<E12D>,
    Q: Array<u384>
) -> bool {
    assert!(
        Q.len() == 58,
        "Wrong Q degree for BN254 2-Pairs Pairing check, should be degree 58 (59 coefficients)"
    );
    assert!(Ris.len() == 68, "Wrong Number of Ris for BN254 Multi-Pairing check, should be 68");

    return true;
}

fn multi_pairing_check_bn254_3_pairs(
    pair0: G1G2Pair,
    pair1: G1G2Pair,
    lambda_root: E12D,
    w: MillerLoopResultScalingFactor,
    Ris: Array<E12D>,
    Q: Array<u384>
) -> bool {
    assert!(
        Q.len() == 76,
        "Wrong Q degree for BN254 3-Pairs Pairing check, should be degree 75 (76 coefficients)"
    );
    assert!(Ris.len() == 68, "Wrong Number of Ris for BN254 Multi-Pairing check");

    return true;
}

fn multi_pairing_check_bls12_381_2_pairs(
    pair0: G1G2Pair,
    pair1: G1G2Pair,
    lambda_root_inverse: E12D,
    w: MillerLoopResultScalingFactor,
    Ris: Span<E12D>,
    big_Q: Array<u384>
) -> bool {
    assert!(
        big_Q.len() == 54,
        "Wrong Q degree for BLS12-381 2-Pairs Paring check, should be degree 53 (54 coeffs)"
    );
    assert!(
        Ris.len() == 64, "Wrong Number of Ris for BLS12-381 2-Pairs Paring check, should be 64"
    );
    let (processed_pair0, processed_pair1): (BLSProcessedPair, BLSProcessedPair) =
        run_BLS12_381_MP_CHECK_PREPARE_PAIRS_2_circuit(
        pair0.p, pair1.p
    );

    // Init sponge state
    let (s0, s1, s2) = hades_permutation('MPCHECK_BLS12_381_2P', 0, 1);
    // Hash Inputs

    let (s0, s1, s2) = utils::hash_G1G2Pair(pair0, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_G1G2Pair(pair1, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_E12D(lambda_root_inverse, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_MillerLoopResultScalingFactor(w, s0, s1, s2);
    // Hash Ris to obtain base random coefficient c0
    let (s0, s1, s2) = utils::hash_E12D_transcript(Ris, s0, s1, s2);
    let mut c_i: u384 = s1.into();

    // Hash Q = (Σ_i c_i*Q_i) to obtain random evaluation point z
    let (z_felt252, _, _) = utils::hash_u384_transcript(big_Q.span(), s0, s1, s2);
    let z: u384 = z_felt252.into();

    // Precompute lambda root evaluated in Z:
    let (conjugate_c_inv_of_z, w_of_z, c_inv_of_z_frob_1): (u384, u384, u384) =
        run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
        lambda_root_inverse, z, w
    );

    // init bit for bls is 1:
    let R_0 = Ris.at(0);
    let (_Q0, _Q1, _lhs, _f_1_of_z) = run_BLS12_381_MP_CHECK_INIT_BIT_2_circuit(
        processed_pair0.yInv,
        processed_pair0.xNegOverY,
        pair0.q,
        processed_pair1.yInv,
        processed_pair1.xNegOverY,
        pair1.q,
        *R_0,
        c_i,
        z,
        conjugate_c_inv_of_z
    );

    let mut Q0 = _Q0;
    let mut Q1 = _Q1;
    let mut LHS = _lhs;
    let mut f_i_of_z = _f_1_of_z;

    // Σ_i (Π_k (c_i*P_k(z)))  = (Σ_i c_i*Q_i(z)) * P(z) + Σ_i c_i * R_i(z)
    // <=> Σ_i (Π_k (c_i*P_k(z))) - Σ_i c_i * R_i(z) = (Σ_i c_i*Q_i(z)) * P(z)
    // => LHS = Σ_i (Π_k (c_i*P_k(z))) - Σ_i c_i * R_i(z)

    // rest of miller loop
    let mut bits = bls_bits.span();
    let mut R_i_index = 1;

    while let Option::Some(bit) = bits.pop_front() {
        let R_i = Ris.at(R_i_index);
        R_i_index += 1;
        match *bit {
            0 => {
                let (
                    _Q0, _Q1, _f_i_plus_one_of_z, _LHS, _c_i
                ): (G2Point, G2Point, u384, u384, u384) =
                    run_BLS12_381_MP_CHECK_BIT0_LOOP_2_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    Q0,
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    Q1,
                    LHS,
                    f_i_of_z,
                    *R_i,
                    c_i,
                    z
                );
                Q0 = _Q0;
                Q1 = _Q1;
                LHS = _LHS;
                f_i_of_z = _f_i_plus_one_of_z;
                c_i = _c_i;
            },
            _ => {
                let (_Q0, _Q1, _f_i_plus_one_of_z, _LHS, _c_i) =
                    run_BLS12_381_MP_CHECK_BIT1_LOOP_2_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    Q0,
                    pair0.q,
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    Q1,
                    pair1.q,
                    LHS,
                    f_i_of_z,
                    *R_i,
                    conjugate_c_inv_of_z,
                    z,
                    c_i
                );
                Q0 = _Q0;
                Q1 = _Q1;
                LHS = _LHS;
                f_i_of_z = _f_i_plus_one_of_z;
                c_i = _c_i;
            },
        }
    };

    let R_last = Ris.at(Ris.len() - 1);
    println!("reached");
    let (check,) = run_BLS12_381_MP_CHECK_FINALIZE_BLS_2_circuit(
        *R_last, c_i, w_of_z, z, c_inv_of_z_frob_1, LHS, f_i_of_z, big_Q
    );

    assert!(check == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }, "Final check failed");

    assert!(*R_last == E12DDefinitions::one());
    return true;
}

fn multi_pairing_check_bls12_381_3_pairs(
    pair0: G1G2Pair,
    pair1: G1G2Pair,
    pair2: G1G2Pair,
    lambda_root_inverse: E12D,
    w: MillerLoopResultScalingFactor,
    Ris: Span<E12D>,
    big_Q: Array<u384>,
    precomputed_miller_loop_result: Option<E12D>,
    small_Q: Option<E12DMulQuotient>
) -> bool {
    assert!(
        big_Q.len() == 70,
        "Wrong Q degree for BLS12-381 3-Pairs Paring check, should be of degree 69 (70 coefficients)"
    );
    assert!(Ris.len() == 64, "Wrong Number of Ris for BLS12-381 3-Pairs Paring check");

    let (
        processed_pair0, processed_pair1, processed_pair2
    ): (BLSProcessedPair, BLSProcessedPair, BLSProcessedPair) =
        run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit(
        pair0.p, pair1.p, pair2.p
    );

    // Init sponge state :
    let (s0, s1, s2) = hades_permutation('MPCHECK_BLS12_381_3P', 0, 1);
    // Hash Inputs.

    let (s0, s1, s2) = utils::hash_G1G2Pair(pair0, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_G1G2Pair(pair1, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_G1G2Pair(pair2, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_E12D(lambda_root_inverse, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_MillerLoopResultScalingFactor(w, s0, s1, s2);
    // Hash Ris to obtain base random coefficient c0
    let (s0, s1, s2) = utils::hash_E12D_transcript(Ris, s0, s1, s2);
    let mut c_i: u384 = s1.into();

    // Hash Q = (Σ_i c_i*Q_i) to obtain random evaluation point z
    let (z_felt252, s1, s2) = utils::hash_u384_transcript(big_Q.span(), s0, s1, s2);
    let z: u384 = z_felt252.into();
    // Precompute lambda root evaluated in Z:
    let (conjugate_c_inv_of_z, w_of_z, c_inv_of_z_frob_1): (u384, u384, u384) =
        run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
        lambda_root_inverse, z, w
    );

    // init bit for bls is 1:
    let R_0 = Ris.at(0);
    let (_Q0, _Q1, _Q2, _lhs, _f_1_of_z) = run_BLS12_381_MP_CHECK_INIT_BIT_3_circuit(
        processed_pair0.yInv,
        processed_pair0.xNegOverY,
        pair0.q,
        processed_pair1.yInv,
        processed_pair1.xNegOverY,
        pair1.q,
        processed_pair2.yInv,
        processed_pair2.xNegOverY,
        pair2.q,
        *R_0,
        c_i,
        z,
        conjugate_c_inv_of_z
    );

    let mut Q0 = _Q0;
    let mut Q1 = _Q1;
    let mut Q2 = _Q2;
    let mut LHS = _lhs;
    let mut f_i_of_z = _f_1_of_z;

    // Σ_i (Π_k (c_i*P_k(z)))  = (Σ_i c_i*Q_i(z)) * P(z) + Σ_i c_i * R_i(z)
    // <=> Σ_i (Π_k (c_i*P_k(z))) - Σ_i c_i * R_i(z) = (Σ_i c_i*Q_i(z)) * P(z)
    // => LHS = Σ_i (Π_k (c_i*P_k(z))) - Σ_i c_i * R_i(z)

    // rest of miller loop
    let mut bits = bls_bits.span();
    let mut R_i_index = 1;

    while let Option::Some(bit) = bits.pop_front() {
        // // println!("R_i_index: {}", R_i_index);
        let R_i = Ris.at(R_i_index);
        R_i_index += 1;
        match *bit {
            0 => {
                let (
                    _Q0, _Q1, _Q2, _f_i_plus_one_of_z, _LHS, _c_i
                ): (G2Point, G2Point, G2Point, u384, u384, u384) =
                    run_BLS12_381_MP_CHECK_BIT0_LOOP_3_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    Q0,
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    Q1,
                    processed_pair2.yInv,
                    processed_pair2.xNegOverY,
                    Q2,
                    LHS,
                    f_i_of_z,
                    *R_i,
                    c_i,
                    z
                );
                Q0 = _Q0;
                Q1 = _Q1;
                Q2 = _Q2;
                LHS = _LHS;
                f_i_of_z = _f_i_plus_one_of_z;
                c_i = _c_i;
            },
            _ => {
                let (_Q0, _Q1, _Q2, _f_i_plus_one_of_z, _LHS, _c_i) =
                    run_BLS12_381_MP_CHECK_BIT1_LOOP_3_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    Q0,
                    pair0.q,
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    Q1,
                    pair1.q,
                    processed_pair2.yInv,
                    processed_pair2.xNegOverY,
                    Q2,
                    pair2.q,
                    LHS,
                    f_i_of_z,
                    *R_i,
                    conjugate_c_inv_of_z,
                    z,
                    c_i,
                );
                Q0 = _Q0;
                Q1 = _Q1;
                Q2 = _Q2;
                LHS = _LHS;
                f_i_of_z = _f_i_plus_one_of_z;
                c_i = _c_i;
            },
        }
    };

    let R_last = Ris.at(Ris.len() - 1);

    let (check) = run_BLS12_381_MP_CHECK_FINALIZE_BLS_3_circuit(
        *R_last, c_i, w_of_z, z, c_inv_of_z_frob_1, LHS, f_i_of_z, big_Q
    );

    assert!(check == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }, "Final check failed");

    match precomputed_miller_loop_result {
        Option::Some(M) => {
            // Use precomputed miller loop result & check conj(f) * M = 1
            let f_conjugate = (*R_last).conjugate(curve_index: 1);
            let (s0, s1, s2) = utils::hash_E12D(M, s0, s1, s2);
            let (z, _, _) = utils::hash_E12DMulQuotient(small_Q.unwrap(), s0, s1, s2);
            let (check) = run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit(
                f_conjugate, M, small_Q.unwrap(), z.into()
            );
            assert!(check == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
            return true;
        },
        Option::None => {
            // No need to conjugate as conjugate(One) = One
            assert!(*R_last == E12DDefinitions::one());
            return true;
        },
    }
}
