use core::circuit::u384;
pub use core::poseidon::hades_permutation;
use garaga::definitions::{E12D, G1G2Pair, G1Point, MillerLoopResultScalingFactor, u288};

pub const TWO_POW_96: felt252 = 79228162514264337593543950336;

#[derive(Copy, Drop)]
pub struct PoseidonState {
    pub s0: felt252,
    pub s1: felt252,
    pub s2: felt252,
}

#[inline(always)]
pub fn hash_u384(elmt: u384, base: felt252, s: PoseidonState) -> PoseidonState {
    let in_1 = s.s0 + elmt.limb0.into() + base * elmt.limb1.into();
    let in_2 = s.s1 + elmt.limb2.into() + base * elmt.limb3.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s.s2);
    return PoseidonState { s0: _s0, s1: _s1, s2: _s2 };
}

#[inline(always)]
pub fn hash_u288(elmt: u288, base: felt252, s: PoseidonState) -> PoseidonState {
    let in_1 = s.s0 + elmt.limb0.into() + base * elmt.limb1.into();
    let in_2 = s.s1 + elmt.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s.s2);
    return PoseidonState { s0: _s0, s1: _s1, s2: _s2 };
}

#[inline(always)]
pub fn hash_quadruple_u288(
    elmt0: u288, elmt1: u288, elmt2: u288, elmt3: u288, base: felt252, s: PoseidonState,
) -> PoseidonState {
    let in_1 = s.s0 + elmt0.limb0.into() + base * elmt0.limb1.into();
    let in_2 = s.s1 + elmt0.limb2.into() + base * elmt1.limb0.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s.s2);
    let in_1 = _s0 + elmt1.limb1.into() + base * elmt1.limb2.into();
    let in_2 = _s1 + elmt2.limb0.into() + base * elmt2.limb1.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    let in_1 = _s0 + elmt2.limb2.into() + base * elmt3.limb0.into();
    let in_2 = _s1 + elmt3.limb1.into() + base * elmt3.limb2.into();
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
    return PoseidonState { s0: _s0, s1: _s1, s2: _s2 };
}
// Apply sponge construction to a transcript of u384 elements
#[inline(always)]
pub fn hash_u384_transcript(transcript: Span<u384>, mut s: PoseidonState) -> PoseidonState {
    let base: felt252 = TWO_POW_96; // 2**96
    for elmt in transcript {
        s = hash_u384(*elmt, base, s);
    }
    return s;
}

#[inline(always)]
pub fn hash_u288_transcript(transcript: Span<u288>, mut s: PoseidonState) -> PoseidonState {
    let base: felt252 = TWO_POW_96; // 2**96
    let (n_quadruples, rest) = DivRem::div_rem(transcript.len(), 4);
    let n_quadruples_index = n_quadruples * 4;
    let mut transcript_quadruples = transcript.slice(0, n_quadruples_index);

    while let Some(fours) = transcript_quadruples.multi_pop_front::<4>() {
        let [elmt0, elmt1, elmt2, elmt3] = fours.unbox();
        let _s = hash_quadruple_u288(elmt0, elmt1, elmt2, elmt3, base, s);
        s = _s;
    }
    let mut rest_transcript = transcript.slice(n_quadruples_index, rest);
    for elmt in rest_transcript {
        s = hash_u288(*elmt, base, s);
    }
    return s;
}

// Apply sponge construction to a E12D element from an initial state (s0, s1, s2)
pub fn hash_E12D_u384(elmt: E12D<u384>, mut s: PoseidonState) -> PoseidonState {
    let base: felt252 = TWO_POW_96; // 2**96
    let _s = hash_u384(elmt.w0, base, s);
    let _s = hash_u384(elmt.w1, base, _s);
    let _s = hash_u384(elmt.w2, base, _s);
    let _s = hash_u384(elmt.w3, base, _s);
    let _s = hash_u384(elmt.w4, base, _s);
    let _s = hash_u384(elmt.w5, base, _s);
    let _s = hash_u384(elmt.w6, base, _s);
    let _s = hash_u384(elmt.w7, base, _s);
    let _s = hash_u384(elmt.w8, base, _s);
    let _s = hash_u384(elmt.w9, base, _s);
    let _s = hash_u384(elmt.w10, base, _s);
    let _s = hash_u384(elmt.w11, base, _s);
    return _s;
}

pub fn hash_E12D_u288(elmt: E12D<u288>, mut s: PoseidonState) -> PoseidonState {
    let base: felt252 = TWO_POW_96; // 2**96
    let _s = hash_quadruple_u288(elmt.w0, elmt.w1, elmt.w2, elmt.w3, base, s);
    let _s = hash_quadruple_u288(elmt.w4, elmt.w5, elmt.w6, elmt.w7, base, _s);
    let _s = hash_quadruple_u288(elmt.w8, elmt.w9, elmt.w10, elmt.w11, base, _s);
    return _s;
}

// Hash a E12D element known to be 1
pub fn hash_E12D_one_u384(s: PoseidonState) -> PoseidonState {
    let in_1 = s.s0 + 1;
    let in_2 = s.s1;
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s.s2); // 1
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 2
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 3
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 4
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 5
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 6
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 7
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 8
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 9
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 10
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 11
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 12
    return PoseidonState { s0: _s0, s1: _s1, s2: _s2 };
}

// Hash a E12D element known to be 1
pub fn hash_E12D_one_u288(s: PoseidonState) -> PoseidonState {
    let in_1 = s.s0 + 1;
    let in_2 = s.s1;
    let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s.s2); // 1
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 2
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 3
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 4
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 5
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 6
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 7
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 8
    let (_s0, _s1, _s2) = hades_permutation(_s0, _s1, _s2); // 9
    return PoseidonState { s0: _s0, s1: _s1, s2: _s2 };
}

// Apply sponge construction to a MillerLoopResultScalingFactor element from an initial state (s0,
// s1, s2)
#[inline(always)]
pub fn hash_MillerLoopResultScalingFactor_u384(
    elmt: MillerLoopResultScalingFactor<u384>, s: PoseidonState,
) -> PoseidonState {
    let base: felt252 = TWO_POW_96; // 2**96
    let _s = hash_u384(elmt.w0, base, s);
    let _s = hash_u384(elmt.w2, base, _s);
    let _s = hash_u384(elmt.w4, base, _s);
    let _s = hash_u384(elmt.w6, base, _s);
    let _s = hash_u384(elmt.w8, base, _s);
    let _s = hash_u384(elmt.w10, base, _s);
    return _s;
}

#[inline(always)]
pub fn hash_MillerLoopResultScalingFactor_u288(
    elmt: MillerLoopResultScalingFactor<u288>, s: PoseidonState,
) -> PoseidonState {
    let base: felt252 = TWO_POW_96; // 2**96
    let _s = hash_quadruple_u288(elmt.w0, elmt.w2, elmt.w4, elmt.w6, base, s);
    let _s = hash_u288(elmt.w8, base, _s);
    let _s = hash_u288(elmt.w10, base, _s);
    return _s;
}

// Apply sponge construction to a sequence of E12D elements from an initial state (s0, s1, s2)
#[inline(always)]
pub fn hash_E12D_u384_transcript(
    transcript: Span<E12D<u384>>, mut s: PoseidonState,
) -> PoseidonState {
    let base: felt252 = TWO_POW_96; // 2**96

    for elmt in transcript {
        let elmt = *elmt;
        let _s = hash_u384(elmt.w0, base, s);
        let _s = hash_u384(elmt.w1, base, _s);
        let _s = hash_u384(elmt.w2, base, _s);
        let _s = hash_u384(elmt.w3, base, _s);
        let _s = hash_u384(elmt.w4, base, _s);
        let _s = hash_u384(elmt.w5, base, _s);
        let _s = hash_u384(elmt.w6, base, _s);
        let _s = hash_u384(elmt.w7, base, _s);
        let _s = hash_u384(elmt.w8, base, _s);
        let _s = hash_u384(elmt.w9, base, _s);
        let _s = hash_u384(elmt.w10, base, _s);
        let _s = hash_u384(elmt.w11, base, _s);
        s = _s;
    }
    return s;
}

#[inline(always)]
pub fn hash_E12D_u288_transcript(
    transcript: Span<E12D<u288>>, mut s: PoseidonState,
) -> PoseidonState {
    let base: felt252 = TWO_POW_96; // 2**96
    for elmt in transcript {
        let elmt = *elmt;
        let _s = hash_quadruple_u288(elmt.w0, elmt.w1, elmt.w2, elmt.w3, base, s);
        let _s = hash_quadruple_u288(elmt.w4, elmt.w5, elmt.w6, elmt.w7, base, _s);
        let _s = hash_quadruple_u288(elmt.w8, elmt.w9, elmt.w10, elmt.w11, base, _s);
        s = _s;
    }
    return s;
}


// Apply sponge construction to a pair of G1 and G2 points from an initial state (s0, s1, s2)
// #[inline(always)]
pub fn hash_G1G2Pair(pair: G1G2Pair, s: PoseidonState) -> PoseidonState {
    let base: felt252 = TWO_POW_96; // 2**96
    let _s = hash_u384(pair.p.x, base, s);
    let _s = hash_u384(pair.p.y, base, _s);
    let _s = hash_u384(pair.q.x0, base, _s);
    let _s = hash_u384(pair.q.x1, base, _s);
    let _s = hash_u384(pair.q.y0, base, _s);
    let _s = hash_u384(pair.q.y1, base, _s);
    return _s;
}

pub fn hash_G1Point(point: G1Point) -> felt252 {
    let base: felt252 = TWO_POW_96; // 2**96
    let in_1: felt252 = point.x.limb0.into() + base * point.x.limb1.into();
    let in_2: felt252 = point.x.limb2.into() + base * point.x.limb3.into();
    let (s0, s1, s2) = hades_permutation(in_1, in_2, 2);
    let in_1 = s0 + point.y.limb0.into() + base * point.y.limb1.into();
    let in_2 = s1 + point.y.limb2.into() + base * point.y.limb3.into();
    let (s0, _, _) = hades_permutation(in_1, in_2, s2);
    return s0;
}
