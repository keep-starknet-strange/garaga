use garaga::definitions::{
    G1Point, G2Point, G1G2Pair, u384, bn_bits, bls_bits, MillerLoopResultScalingFactor, E12D,
    BNProcessedPair, BLSProcessedPair, get_p, E12DMulQuotient, G2Line, E12DDefinitions
};
use garaga::circuits::multi_pairing_check::{
    run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit,
    run_BLS12_381_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit,
    run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit, run_BN254_MP_CHECK_PREPARE_PAIRS_3_circuit
};
use garaga::circuits::extf_mul::{
    run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit, run_BN254_FP12_MUL_ASSERT_ONE_circuit
};
use core::option::Option;
use garaga::utils;
use core::array::{SpanTrait};
use core::poseidon::hades_permutation;

use garaga::circuits::groth16_with_precomputation::{
    run_BLS12_381_GROTH16_BIT00_LOOP_circuit, run_BLS12_381_GROTH16_BIT0_LOOP_circuit,
    run_BLS12_381_GROTH16_BIT1_LOOP_circuit, run_BN254_GROTH16_BIT00_LOOP_circuit,
    run_BN254_GROTH16_BIT0_LOOP_circuit, run_BN254_GROTH16_BIT1_LOOP_circuit,
    run_BN254_GROTH16_INIT_BIT_circuit, run_BLS12_381_GROTH16_INIT_BIT_circuit,
    run_BN254_GROTH16_FINALIZE_BN_circuit, run_BLS12_381_GROTH16_FINALIZE_BLS_circuit
};

use garaga::basic_field_ops::{neg_mod_p};

#[derive(Drop)]
struct Groth16Proof {
    a: G1Point,
    b: G2Point,
    c: G1Point,
    public_inputs: Array<u256>,
}

#[derive(Drop)]
struct Groth16VerificationKey {
    alpha_beta_miller_loop_result: E12D,
    gamma_g2: G2Point,
    delta_g2: G2Point,
    ic: Array<G1Point>,
}
fn verify_groth16_bn254(proof: Groth16Proof, verification_key: Groth16VerificationKey) -> bool {
    let p = get_p(0);
    // let res = multi_pairing_check_bn254_3_pairs(
    //     G1G2Pair { p: G1Point { x: proof.a.x, y: neg_mod_p(proof.a.y, p) }, q: proof.b },
    //     G1G2Pair{},
    //     verification_key.alpha_beta_miller_loop_result,
    //     verification_key.gamma_g2,
    //     verification_key.delta_g2,
    //     verification_key.ic,
    // );
    return true;
}

fn multi_pairing_check_groth16_bn254(
    pair0: G1G2Pair,
    pair1: G1G2Pair,
    pair2: G1G2Pair,
    lambda_root: E12D,
    lambda_root_inverse: E12D,
    w: MillerLoopResultScalingFactor,
    Ris: Span<E12D>,
    mut lines: Span<G2Line>,
    big_Q: Array<u384>,
    precomputed_miller_loop_result: E12D,
    small_Q: E12DMulQuotient
) -> bool {
    assert!(
        big_Q.len() == 114,
        "Wrong Q degree for BN254 3-Pairs Pairing check, should be degree 113 (114 coefficients)"
    );
    assert!(Ris.len() == 53, "Wrong Number of Ris for BN254 Multi-Pairing check");

    let (
        processed_pair0, processed_pair1, processed_pair2
    ): (BNProcessedPair, BNProcessedPair, BNProcessedPair) =
        run_BN254_MP_CHECK_PREPARE_PAIRS_3_circuit(
        pair0.p,
        pair0.q.y0,
        pair0.q.y1,
        pair1.p,
        pair1.q.y0,
        pair1.q.y1,
        pair2.p,
        pair2.q.y0,
        pair2.q.y1
    );

    // Init sponge state
    let (s0, s1, s2) = hades_permutation('GROTH16_BN254', 0, 1);
    // Hash Inputs
    let (s0, s1, s2) = utils::hash_G1G2Pair(pair0, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_G1G2Pair(pair1, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_G1G2Pair(pair2, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_E12D(lambda_root, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_E12D(lambda_root_inverse, s0, s1, s2);
    let (s0, s1, s2) = utils::hash_MillerLoopResultScalingFactor(w, s0, s1, s2);
    // Hash Ris to obtain base random coefficient c0
    let (s0, s1, s2) = utils::hash_E12D_transcript(Ris, s0, s1, s2);

    let mut c_i: u384 = s1.into();

    // Hash Q = (Σ_i c_i*Q_i) to obtain random evaluation point z
    let (z_felt252, _, _) = utils::hash_u384_transcript(big_Q.span(), s0, s1, s2);

    let z: u384 = z_felt252.into();
    // Precompute lambda root evaluated in Z:
    let (
        c_of_z, w_of_z, c_inv_of_z, LHS, c_inv_frob_1_of_z, c_frob_2_of_z, c_inv_frob_3_of_z
    ): (u384, u384, u384, u384, u384, u384, u384) =
        run_BN254_MP_CHECK_PREPARE_LAMBDA_ROOT_circuit(
        lambda_root, z, w, lambda_root_inverse, c_i
    );

    // init bit for bn254 is 0:
    let R_0 = Ris.at(0);
    let (_Q2, _lhs, _c_i, _f_1_of_z) = run_BN254_GROTH16_INIT_BIT_circuit(
        processed_pair0.yInv,
        processed_pair0.xNegOverY,
        *lines.pop_front().unwrap(),
        processed_pair1.yInv,
        processed_pair1.xNegOverY,
        *lines.pop_front().unwrap(),
        processed_pair2.yInv,
        processed_pair2.xNegOverY,
        pair2.q,
        *R_0,
        c_i,
        z,
        c_inv_of_z,
        LHS
    );

    let mut Q2 = _Q2;
    let mut LHS = _lhs;
    let mut f_i_of_z = _f_1_of_z;
    c_i = _c_i;

    // rest of miller loop
    let mut bits = bn_bits.span();
    let mut R_i_index = 1;

    while let Option::Some(bit) = bits.pop_front() {
        let R_i = Ris.at(R_i_index);
        R_i_index += 1;
        let (_Q2, _f_i_plus_one_of_z, _LHS, _c_i): (G2Point, u384, u384, u384) = match *bit {
            0 => {
                run_BN254_GROTH16_BIT0_LOOP_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    *lines.pop_front().unwrap(),
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    *lines.pop_front().unwrap(),
                    processed_pair2.yInv,
                    processed_pair2.xNegOverY,
                    Q2,
                    LHS,
                    f_i_of_z,
                    *R_i,
                    z,
                    c_i
                )
            },
            1 => {
                run_BN254_GROTH16_BIT1_LOOP_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    processed_pair2.yInv,
                    processed_pair2.xNegOverY,
                    Q2,
                    pair2.q,
                    LHS,
                    f_i_of_z,
                    *R_i,
                    c_inv_of_z,
                    z,
                    c_i,
                )
            },
            2 => {
                run_BN254_GROTH16_BIT1_LOOP_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    processed_pair2.yInv,
                    processed_pair2.xNegOverY,
                    Q2,
                    G2Point {
                        x0: pair2.q.x0,
                        x1: pair2.q.x1,
                        y0: processed_pair2.QyNeg0,
                        y1: processed_pair2.QyNeg1
                    },
                    LHS,
                    f_i_of_z,
                    *R_i,
                    c_of_z,
                    z,
                    c_i,
                )
            },
            _ => {
                run_BN254_GROTH16_BIT00_LOOP_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    processed_pair2.yInv,
                    processed_pair2.xNegOverY,
                    Q2,
                    LHS,
                    f_i_of_z,
                    *R_i,
                    z,
                    c_i
                )
            }
        };
        Q2 = _Q2;
        LHS = _LHS;
        f_i_of_z = _f_i_plus_one_of_z;
        c_i = _c_i;
    };

    let R_n_minus_2 = Ris.at(Ris.len() - 2);
    let R_last = Ris.at(Ris.len() - 1);

    let (check) = run_BN254_GROTH16_FINALIZE_BN_circuit(
        processed_pair0.yInv,
        processed_pair0.xNegOverY,
        *lines.pop_front().unwrap(),
        *lines.pop_front().unwrap(),
        processed_pair1.yInv,
        processed_pair1.xNegOverY,
        *lines.pop_front().unwrap(),
        *lines.pop_front().unwrap(),
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
        big_Q
    );

    assert!(check == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }, "Final check failed");

    // Use precomputed miller loop result & check f * M = 1
    let (s0, s1, s2) = utils::hash_E12D(precomputed_miller_loop_result, s0, s1, s2);
    let (z, _, _) = utils::hash_E12DMulQuotient(small_Q, s0, s1, s2);
    let (check) = run_BN254_FP12_MUL_ASSERT_ONE_circuit(
        *R_last, precomputed_miller_loop_result, small_Q, z.into()
    );
    assert!(check == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
    return true;
}


fn multi_pairing_check_groth16_bls12_381(
    pair0: G1G2Pair,
    pair1: G1G2Pair,
    pair2: G1G2Pair,
    lambda_root_inverse: E12D,
    w: MillerLoopResultScalingFactor,
    Ris: Span<E12D>,
    mut lines: Span<G2Line>,
    big_Q: Array<u384>,
    precomputed_miller_loop_result: E12D,
    small_Q: E12DMulQuotient
) -> bool {
    assert!(
        big_Q.len() == 105,
        "Wrong Q degree for BLS12-381 3-Pairs Paring check, should be of degree 104 (105 coefficients)"
    );
    assert!(Ris.len() == 36, "Wrong Number of Ris for BLS12-381 3-Pairs Paring check");

    let (
        processed_pair0, processed_pair1, processed_pair2
    ): (BLSProcessedPair, BLSProcessedPair, BLSProcessedPair) =
        run_BLS12_381_MP_CHECK_PREPARE_PAIRS_3_circuit(
        pair0.p, pair1.p, pair2.p
    );

    // Init sponge state :
    let (s0, s1, s2) = hades_permutation('GROTH16_BLS12_381', 0, 1);
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
    let (_Q2, _lhs, _f_1_of_z) = run_BLS12_381_GROTH16_INIT_BIT_circuit(
        processed_pair0.yInv,
        processed_pair0.xNegOverY,
        *lines.pop_front().unwrap(),
        *lines.pop_front().unwrap(),
        processed_pair1.yInv,
        processed_pair1.xNegOverY,
        *lines.pop_front().unwrap(),
        *lines.pop_front().unwrap(),
        processed_pair2.yInv,
        processed_pair2.xNegOverY,
        pair2.q,
        *R_0,
        c_i,
        z,
        conjugate_c_inv_of_z
    );

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
        let R_i = Ris.at(R_i_index);
        let (_Q2, _f_i_plus_one_of_z, _LHS, _c_i): (G2Point, u384, u384, u384) = match *bit {
            0 => {
                run_BLS12_381_GROTH16_BIT0_LOOP_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    *lines.pop_front().unwrap(),
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    *lines.pop_front().unwrap(),
                    processed_pair2.yInv,
                    processed_pair2.xNegOverY,
                    Q2,
                    LHS,
                    f_i_of_z,
                    *R_i,
                    z,
                    c_i
                )
            },
            1 => {
                run_BLS12_381_GROTH16_BIT1_LOOP_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
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
                )
            },
            _ => {
                run_BLS12_381_GROTH16_BIT00_LOOP_circuit(
                    processed_pair0.yInv,
                    processed_pair0.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    processed_pair1.yInv,
                    processed_pair1.xNegOverY,
                    *lines.pop_front().unwrap(),
                    *lines.pop_front().unwrap(),
                    processed_pair2.yInv,
                    processed_pair2.xNegOverY,
                    Q2,
                    LHS,
                    f_i_of_z,
                    *R_i,
                    z,
                    c_i
                )
            }
        };
        R_i_index += 1;
        Q2 = _Q2;
        LHS = _LHS;
        f_i_of_z = _f_i_plus_one_of_z;
        c_i = _c_i;
    };

    let R_last = Ris.at(Ris.len() - 1);

    let (check) = run_BLS12_381_GROTH16_FINALIZE_BLS_circuit(
        *R_last, c_i, w_of_z, z, c_inv_of_z_frob_1, LHS, f_i_of_z, big_Q
    );

    assert!(check == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }, "Final check failed");

    // Use precomputed miller loop result & check conj(f) * M = 1
    let f_conjugate = (*R_last).conjugate(curve_index: 1);
    let (s0, s1, s2) = utils::hash_E12D(precomputed_miller_loop_result, s0, s1, s2);
    let (z, _, _) = utils::hash_E12DMulQuotient(small_Q, s0, s1, s2);
    let (check) = run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit(
        f_conjugate, precomputed_miller_loop_result, small_Q, z.into()
    );
    assert!(check == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
    return true;
}
