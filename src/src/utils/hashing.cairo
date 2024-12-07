pub use core::poseidon::hades_permutation;
use core::circuit::{u384, u96};
use garaga::definitions::{
    E12D, u288, G1G2Pair, G1Point, E12DMulQuotient, MillerLoopResultScalingFactor,
};

#[derive(Copy, Drop)]
pub struct PoseidonState {
    s0: felt252,
    s1: felt252,
    s2: felt252,
}

// Apply sponge construction to a transcript of u384 elements
#[inline(always)]
pub fn hash_u384_transcript(
    transcript: Span<u384>, mut s0: felt252, mut s1: felt252, mut s2: felt252,
) -> (felt252, felt252, felt252) {
    let base: felt252 = 79228162514264337593543950336; // 2**96
    for elmt in transcript {
        // println!("384_transcript s0 : {:?}", s0);
        let elmt = *elmt;
        // println!("384_transcript elmt : {:?}", elmt);
        let in_1 = s0 + elmt.limb0.into() + base * elmt.limb1.into();
        let in_2 = s1 + elmt.limb2.into() + base * elmt.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s2);
        s0 = _s0;
        s1 = _s1;
        s2 = _s2;
    };
    return (s0, s1, s2);
}

#[inline(always)]
pub fn hash_u288_transcript(
    transcript: Span<u288>, mut s0: felt252, mut s1: felt252, mut s2: felt252,
) -> (felt252, felt252, felt252) {
    let base: felt252 = 79228162514264337593543950336; // 2**96
    for elmt in transcript {
        let elmt = *elmt;
        let in_1 = s0 + elmt.limb0.into() + base * elmt.limb1.into();
        let in_2 = s1 + elmt.limb2.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s2);
        s0 = _s0;
        s1 = _s1;
        s2 = _s2;
    };
    return (s0, s1, s2);
}

#[inline(always)]
pub fn hash_E12DMulQuotient_u384(
    elmt: E12DMulQuotient<u384>, mut s0: felt252, mut s1: felt252, mut s2: felt252,
) -> (felt252, felt252, felt252) {
    let base: felt252 = 79228162514264337593543950336; // 2**96

    let in_1 = s0 + elmt.w0.limb0.into() + base * elmt.w0.limb1.into();
    let in_2 = s1 + elmt.w0.limb2.into() + base * elmt.w0.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s2);
    let in_1 = _s0 + elmt.w1.limb0.into() + base * elmt.w1.limb1.into();
    let in_2 = _s1 + elmt.w1.limb2.into() + base * elmt.w1.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w2.limb0.into() + base * elmt.w2.limb1.into();
    let in_2 = _s1 + elmt.w2.limb2.into() + base * elmt.w2.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w3.limb0.into() + base * elmt.w3.limb1.into();
    let in_2 = _s1 + elmt.w3.limb2.into() + base * elmt.w3.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w4.limb0.into() + base * elmt.w4.limb1.into();
    let in_2 = _s1 + elmt.w4.limb2.into() + base * elmt.w4.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w5.limb0.into() + base * elmt.w5.limb1.into();
    let in_2 = _s1 + elmt.w5.limb2.into() + base * elmt.w5.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w6.limb0.into() + base * elmt.w6.limb1.into();
    let in_2 = _s1 + elmt.w6.limb2.into() + base * elmt.w6.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w7.limb0.into() + base * elmt.w7.limb1.into();
    let in_2 = _s1 + elmt.w7.limb2.into() + base * elmt.w7.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w8.limb0.into() + base * elmt.w8.limb1.into();
    let in_2 = _s1 + elmt.w8.limb2.into() + base * elmt.w8.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w9.limb0.into() + base * elmt.w9.limb1.into();
    let in_2 = _s1 + elmt.w9.limb2.into() + base * elmt.w9.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w10.limb0.into() + base * elmt.w10.limb1.into();
    let in_2 = _s1 + elmt.w10.limb2.into() + base * elmt.w10.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    return (_s0, _s1, _s2);
}

#[inline(always)]
pub fn hash_E12DMulQuotient_u288(
    elmt: E12DMulQuotient<u288>, mut s0: felt252, mut s1: felt252, mut s2: felt252,
) -> (felt252, felt252, felt252) {
    let base: felt252 = 79228162514264337593543950336; // 2**96

    let in_1 = s0 + elmt.w0.limb0.into() + base * elmt.w0.limb1.into();
    let in_2 = s1 + elmt.w0.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s2);
    let in_1 = _s0 + elmt.w1.limb0.into() + base * elmt.w1.limb1.into();
    let in_2 = _s1 + elmt.w1.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w2.limb0.into() + base * elmt.w2.limb1.into();
    let in_2 = _s1 + elmt.w2.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w3.limb0.into() + base * elmt.w3.limb1.into();
    let in_2 = _s1 + elmt.w3.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w4.limb0.into() + base * elmt.w4.limb1.into();
    let in_2 = _s1 + elmt.w4.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w5.limb0.into() + base * elmt.w5.limb1.into();
    let in_2 = _s1 + elmt.w5.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w6.limb0.into() + base * elmt.w6.limb1.into();
    let in_2 = _s1 + elmt.w6.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w7.limb0.into() + base * elmt.w7.limb1.into();
    let in_2 = _s1 + elmt.w7.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w8.limb0.into() + base * elmt.w8.limb1.into();
    let in_2 = _s1 + elmt.w8.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w9.limb0.into() + base * elmt.w9.limb1.into();
    let in_2 = _s1 + elmt.w9.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w10.limb0.into() + base * elmt.w10.limb1.into();
    let in_2 = _s1 + elmt.w10.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    return (_s0, _s1, _s2);
}


// Apply sponge construction to a E12D element from an initial state (s0, s1, s2)
#[inline(always)]
pub fn hash_E12D_u384(
    elmt: E12D<u384>, mut s0: felt252, mut s1: felt252, mut s2: felt252,
) -> (felt252, felt252, felt252) {
    let base: felt252 = 79228162514264337593543950336; // 2**96

    let in_1 = s0 + elmt.w0.limb0.into() + base * elmt.w0.limb1.into();
    let in_2 = s1 + elmt.w0.limb2.into() + base * elmt.w0.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s2);
    let in_1 = _s0 + elmt.w1.limb0.into() + base * elmt.w1.limb1.into();
    let in_2 = _s1 + elmt.w1.limb2.into() + base * elmt.w1.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w2.limb0.into() + base * elmt.w2.limb1.into();
    let in_2 = _s1 + elmt.w2.limb2.into() + base * elmt.w2.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w3.limb0.into() + base * elmt.w3.limb1.into();
    let in_2 = _s1 + elmt.w3.limb2.into() + base * elmt.w3.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w4.limb0.into() + base * elmt.w4.limb1.into();
    let in_2 = _s1 + elmt.w4.limb2.into() + base * elmt.w4.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w5.limb0.into() + base * elmt.w5.limb1.into();
    let in_2 = _s1 + elmt.w5.limb2.into() + base * elmt.w5.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w6.limb0.into() + base * elmt.w6.limb1.into();
    let in_2 = _s1 + elmt.w6.limb2.into() + base * elmt.w6.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w7.limb0.into() + base * elmt.w7.limb1.into();
    let in_2 = _s1 + elmt.w7.limb2.into() + base * elmt.w7.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w8.limb0.into() + base * elmt.w8.limb1.into();
    let in_2 = _s1 + elmt.w8.limb2.into() + base * elmt.w8.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w9.limb0.into() + base * elmt.w9.limb1.into();
    let in_2 = _s1 + elmt.w9.limb2.into() + base * elmt.w9.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w10.limb0.into() + base * elmt.w10.limb1.into();
    let in_2 = _s1 + elmt.w10.limb2.into() + base * elmt.w10.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w11.limb0.into() + base * elmt.w11.limb1.into();
    let in_2 = _s1 + elmt.w11.limb2.into() + base * elmt.w11.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    return (_s0, _s1, _s2);
}

#[inline(always)]
pub fn hash_E12D_u288(
    elmt: E12D<u288>, mut s0: felt252, mut s1: felt252, mut s2: felt252,
) -> (felt252, felt252, felt252) {
    let base: felt252 = 79228162514264337593543950336; // 2**96

    let in_1 = s0 + elmt.w0.limb0.into() + base * elmt.w0.limb1.into();
    let in_2 = s1 + elmt.w0.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s2);
    let in_1 = _s0 + elmt.w1.limb0.into() + base * elmt.w1.limb1.into();
    let in_2 = _s1 + elmt.w1.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w2.limb0.into() + base * elmt.w2.limb1.into();
    let in_2 = _s1 + elmt.w2.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w3.limb0.into() + base * elmt.w3.limb1.into();
    let in_2 = _s1 + elmt.w3.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w4.limb0.into() + base * elmt.w4.limb1.into();
    let in_2 = _s1 + elmt.w4.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w5.limb0.into() + base * elmt.w5.limb1.into();
    let in_2 = _s1 + elmt.w5.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w6.limb0.into() + base * elmt.w6.limb1.into();
    let in_2 = _s1 + elmt.w6.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w7.limb0.into() + base * elmt.w7.limb1.into();
    let in_2 = _s1 + elmt.w7.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w8.limb0.into() + base * elmt.w8.limb1.into();
    let in_2 = _s1 + elmt.w8.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w9.limb0.into() + base * elmt.w9.limb1.into();
    let in_2 = _s1 + elmt.w9.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w10.limb0.into() + base * elmt.w10.limb1.into();
    let in_2 = _s1 + elmt.w10.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w11.limb0.into() + base * elmt.w11.limb1.into();
    let in_2 = _s1 + elmt.w11.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    return (_s0, _s1, _s2);
}

// Apply sponge construction to a MillerLoopResultScalingFactor element from an initial state (s0,
// s1, s2)
#[inline(always)]
pub fn hash_MillerLoopResultScalingFactor_u384(
    elmt: MillerLoopResultScalingFactor<u384>, mut s0: felt252, mut s1: felt252, mut s2: felt252,
) -> (felt252, felt252, felt252) {
    let base: felt252 = 79228162514264337593543950336; // 2**96

    let in_1 = s0 + elmt.w0.limb0.into() + base * elmt.w0.limb1.into();
    let in_2 = s1 + elmt.w0.limb2.into() + base * elmt.w0.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s2);
    let in_1 = _s0 + elmt.w2.limb0.into() + base * elmt.w2.limb1.into();
    let in_2 = _s1 + elmt.w2.limb2.into() + base * elmt.w2.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w4.limb0.into() + base * elmt.w4.limb1.into();
    let in_2 = _s1 + elmt.w4.limb2.into() + base * elmt.w4.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w6.limb0.into() + base * elmt.w6.limb1.into();
    let in_2 = _s1 + elmt.w6.limb2.into() + base * elmt.w6.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w8.limb0.into() + base * elmt.w8.limb1.into();
    let in_2 = _s1 + elmt.w8.limb2.into() + base * elmt.w8.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w10.limb0.into() + base * elmt.w10.limb1.into();
    let in_2 = _s1 + elmt.w10.limb2.into() + base * elmt.w10.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    return (_s0, _s1, _s2);
}

#[inline(always)]
pub fn hash_MillerLoopResultScalingFactor_u288(
    elmt: MillerLoopResultScalingFactor<u288>, mut s0: felt252, mut s1: felt252, mut s2: felt252,
) -> (felt252, felt252, felt252) {
    let base: felt252 = 79228162514264337593543950336; // 2**96

    let in_1 = s0 + elmt.w0.limb0.into() + base * elmt.w0.limb1.into();
    let in_2 = s1 + elmt.w0.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s2);
    let in_1 = _s0 + elmt.w2.limb0.into() + base * elmt.w2.limb1.into();
    let in_2 = _s1 + elmt.w2.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w4.limb0.into() + base * elmt.w4.limb1.into();
    let in_2 = _s1 + elmt.w4.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w6.limb0.into() + base * elmt.w6.limb1.into();
    let in_2 = _s1 + elmt.w6.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w8.limb0.into() + base * elmt.w8.limb1.into();
    let in_2 = _s1 + elmt.w8.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt.w10.limb0.into() + base * elmt.w10.limb1.into();
    let in_2 = _s1 + elmt.w10.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    return (_s0, _s1, _s2);
}

// Apply sponge construction to a sequence of E12D elements from an initial state (s0, s1, s2)
#[inline(always)]
pub fn hash_E12D_u384_transcript(
    transcript: Span<E12D<u384>>, mut s0: felt252, mut s1: felt252, mut s2: felt252,
) -> (felt252, felt252, felt252) {
    let base: felt252 = 79228162514264337593543950336; // 2**96

    for elmt in transcript {
        let elmt = *elmt;
        let in_1 = s0 + elmt.w0.limb0.into() + base * elmt.w0.limb1.into();
        let in_2 = s1 + elmt.w0.limb2.into() + base * elmt.w0.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s2);
        let in_1 = _s0 + elmt.w1.limb0.into() + base * elmt.w1.limb1.into();
        let in_2 = _s1 + elmt.w1.limb2.into() + base * elmt.w1.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w2.limb0.into() + base * elmt.w2.limb1.into();
        let in_2 = _s1 + elmt.w2.limb2.into() + base * elmt.w2.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w3.limb0.into() + base * elmt.w3.limb1.into();
        let in_2 = _s1 + elmt.w3.limb2.into() + base * elmt.w3.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w4.limb0.into() + base * elmt.w4.limb1.into();
        let in_2 = _s1 + elmt.w4.limb2.into() + base * elmt.w4.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w5.limb0.into() + base * elmt.w5.limb1.into();
        let in_2 = _s1 + elmt.w5.limb2.into() + base * elmt.w5.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w6.limb0.into() + base * elmt.w6.limb1.into();
        let in_2 = _s1 + elmt.w6.limb2.into() + base * elmt.w6.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w7.limb0.into() + base * elmt.w7.limb1.into();
        let in_2 = _s1 + elmt.w7.limb2.into() + base * elmt.w7.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w8.limb0.into() + base * elmt.w8.limb1.into();
        let in_2 = _s1 + elmt.w8.limb2.into() + base * elmt.w8.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w9.limb0.into() + base * elmt.w9.limb1.into();
        let in_2 = _s1 + elmt.w9.limb2.into() + base * elmt.w9.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w10.limb0.into() + base * elmt.w10.limb1.into();
        let in_2 = _s1 + elmt.w10.limb2.into() + base * elmt.w10.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w11.limb0.into() + base * elmt.w11.limb1.into();
        let in_2 = _s1 + elmt.w11.limb2.into() + base * elmt.w11.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        s0 = _s0;
        s1 = _s1;
        s2 = _s2;
    };
    return (s0, s1, s2);
}

#[inline(always)]
pub fn hash_E12D_u288_transcript(
    transcript: Span<E12D<u288>>, mut s0: felt252, mut s1: felt252, mut s2: felt252,
) -> (felt252, felt252, felt252) {
    let base: felt252 = 79228162514264337593543950336; // 2**96

    for elmt in transcript {
        let elmt = *elmt;
        let in_1 = s0 + elmt.w0.limb0.into() + base * elmt.w0.limb1.into();
        let in_2 = s1 + elmt.w0.limb2.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s2);
        let in_1 = _s0 + elmt.w1.limb0.into() + base * elmt.w1.limb1.into();
        let in_2 = _s1 + elmt.w1.limb2.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w2.limb0.into() + base * elmt.w2.limb1.into();
        let in_2 = _s1 + elmt.w2.limb2.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w3.limb0.into() + base * elmt.w3.limb1.into();
        let in_2 = _s1 + elmt.w3.limb2.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w4.limb0.into() + base * elmt.w4.limb1.into();
        let in_2 = _s1 + elmt.w4.limb2.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w5.limb0.into() + base * elmt.w5.limb1.into();
        let in_2 = _s1 + elmt.w5.limb2.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w6.limb0.into() + base * elmt.w6.limb1.into();
        let in_2 = _s1 + elmt.w6.limb2.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w7.limb0.into() + base * elmt.w7.limb1.into();
        let in_2 = _s1 + elmt.w7.limb2.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w8.limb0.into() + base * elmt.w8.limb1.into();
        let in_2 = _s1 + elmt.w8.limb2.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w9.limb0.into() + base * elmt.w9.limb1.into();
        let in_2 = _s1 + elmt.w9.limb2.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w10.limb0.into() + base * elmt.w10.limb1.into();
        let in_2 = _s1 + elmt.w10.limb2.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w11.limb0.into() + base * elmt.w11.limb1.into();
        let in_2 = _s1 + elmt.w11.limb2.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        s0 = _s0;
        s1 = _s1;
        s2 = _s2;
    };
    return (s0, s1, s2);
}


// Apply sponge construction to a pair of G1 and G2 points from an initial state (s0, s1, s2)
#[inline(always)]
pub fn hash_G1G2Pair(
    pair: G1G2Pair, s0: felt252, s1: felt252, s2: felt252,
) -> (felt252, felt252, felt252) {
    let base: felt252 = 79228162514264337593543950336; // 2**96

    let in_1 = s0 + pair.p.x.limb0.into() + base * pair.p.x.limb1.into();
    let in_2 = s1 + pair.p.x.limb2.into() + base * pair.p.x.limb3.into();
    let (s0, s1, s2) = hades_permutation(in_1, in_2, s2);
    let in_1 = s0 + pair.p.y.limb0.into() + base * pair.p.y.limb1.into();
    let in_2 = s1 + pair.p.y.limb2.into() + base * pair.p.y.limb3.into();
    let (s0, s1, s2) = hades_permutation(in_1, in_2, s2);
    let in_1 = s0 + pair.q.x0.limb0.into() + base * pair.q.x0.limb1.into();
    let in_2 = s1 + pair.q.x0.limb2.into() + base * pair.q.x0.limb3.into();
    let (s0, s1, s2) = hades_permutation(in_1, in_2, s2);
    let in_1 = s0 + pair.q.x1.limb0.into() + base * pair.q.x1.limb1.into();
    let in_2 = s1 + pair.q.x1.limb2.into() + base * pair.q.x1.limb3.into();
    let (s0, s1, s2) = hades_permutation(in_1, in_2, s2);
    let in_1 = s0 + pair.q.y0.limb0.into() + base * pair.q.y0.limb1.into();
    let in_2 = s1 + pair.q.y0.limb2.into() + base * pair.q.y0.limb3.into();
    let (s0, s1, s2) = hades_permutation(in_1, in_2, s2);
    let in_1 = s0 + pair.q.y1.limb0.into() + base * pair.q.y1.limb1.into();
    let in_2 = s1 + pair.q.y1.limb2.into() + base * pair.q.y1.limb3.into();
    let (s0, s1, s2) = hades_permutation(in_1, in_2, s2);

    return (s0, s1, s2);
}

pub fn hash_G1Point(point: G1Point) -> felt252 {
    let base: felt252 = 79228162514264337593543950336; // 2**96
    let in_1: felt252 = point.x.limb0.into() + base * point.x.limb1.into();
    let in_2: felt252 = point.x.limb2.into() + base * point.x.limb3.into();
    let (s0, s1, s2) = hades_permutation(in_1, in_2, 2);
    let in_1 = s0 + point.y.limb0.into() + base * point.y.limb1.into();
    let in_2 = s1 + point.y.limb2.into() + base * point.y.limb3.into();
    let (s0, _, _) = hades_permutation(in_1, in_2, s2);
    return s0;
}
