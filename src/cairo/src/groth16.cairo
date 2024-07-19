use garaga::definitions::{
    G1Point, G2Point, G1G2Pair, u384, bn_bits, bls_bits, MillerLoopResultScalingFactor, E12D,
    BNProcessedPair, BLSProcessedPair, get_p
};
use core::option::Option;
use garaga::utils;
use core::array::{SpanTrait};
use garaga::pairing::{multi_pairing_check_bls12_381_3_pairs, multi_pairing_check_bn254_3_pairs};
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
