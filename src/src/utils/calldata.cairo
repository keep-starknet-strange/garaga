use core::RangeCheck;
use core::circuit::u384;
pub use garaga::definitions::{
    E12D, E12DMulQuotient, G1Point, G2Point, MillerLoopResultScalingFactor, u288,
};
pub use garaga::groth16::{Groth16Proof, Groth16ProofRaw};
pub use garaga::pairing_check::{MPCheckHintBLS12_381, MPCheckHintBN254};

#[derive(Drop)]
pub struct FullProofWithHintsBN254 {
    pub groth16_proof: Groth16Proof,
    pub mpcheck_hint: MPCheckHintBN254,
    pub small_Q: E12DMulQuotient<u288>,
    pub msm_hint: Span<felt252>,
}

#[derive(Drop, Debug)]
pub struct FullProofWithHintsBLS12_381 {
    pub groth16_proof: Groth16Proof,
    pub mpcheck_hint: MPCheckHintBLS12_381,
    pub small_Q: E12DMulQuotient<u384>,
    pub msm_hint: Span<felt252>,
}

#[derive(Drop)]
pub struct FullProofWithHintsRisc0 {
    pub groth16_proof: Groth16ProofRaw,
    pub image_id: Span<u32>,
    pub journal: Span<u8>,
    pub mpcheck_hint: MPCheckHintBN254,
    pub small_Q: E12DMulQuotient<u288>,
    pub msm_hint: Span<felt252>,
}

#[derive(Drop)]
pub struct FullProofWithHintsSP1 {
    pub groth16_proof: Groth16ProofRaw,
    pub vkey: u256,
    pub public_inputs_sp1: Array<u32>,
    pub mpcheck_hint: MPCheckHintBN254,
    pub small_Q: E12DMulQuotient<u288>,
    pub msm_hint: Span<felt252>,
}

const U288_N_LIMBS: usize = 3;
const U384_N_LIMBS: usize = 4;

extern fn downcast<felt252, u96>(x: felt252) -> Option<u96> implicits(RangeCheck) nopanic;

#[inline(always)]
fn downcast_u288(l0: felt252, l1: felt252, l2: felt252) -> u288 {
    u288 {
        limb0: downcast(l0).unwrap(), limb1: downcast(l1).unwrap(), limb2: downcast(l2).unwrap(),
    }
}
#[inline(always)]
fn downcast_u384(l0: felt252, l1: felt252, l2: felt252, l3: felt252) -> u384 {
    u384 {
        limb0: downcast(l0).unwrap(),
        limb1: downcast(l1).unwrap(),
        limb2: downcast(l2).unwrap(),
        limb3: downcast(l3).unwrap(),
    }
}

#[inline(always)]
pub fn _deserialize_groth16_proof_points(ref serialized: Span<felt252>) -> (G1Point, G2Point, G1Point) {
    let [
        a_x_l0,
        a_x_l1,
        a_x_l2,
        a_x_l3,
        a_y_l0,
        a_y_l1,
        a_y_l2,
        a_y_l3,
        b_x0_l0,
        b_x0_l1,
        b_x0_l2,
        b_x0_l3,
        b_x1_l0,
        b_x1_l1,
        b_x1_l2,
        b_x1_l3,
        b_y0_l0,
        b_y0_l1,
        b_y0_l2,
        b_y0_l3,
        b_y1_l0,
        b_y1_l1,
        b_y1_l2,
        b_y1_l3,
        c_x_l0,
        c_x_l1,
        c_x_l2,
        c_x_l3,
        c_y_l0,
        c_y_l1,
        c_y_l2,
        c_y_l3,
    ] =
        (*serialized
        .multi_pop_front::<32>()
        .unwrap())
        .unbox();

    let a = G1Point {
        x: downcast_u384(a_x_l0, a_x_l1, a_x_l2, a_x_l3),
        y: downcast_u384(a_y_l0, a_y_l1, a_y_l2, a_y_l3),
    };

    let b = G2Point {
        x0: downcast_u384(b_x0_l0, b_x0_l1, b_x0_l2, b_x0_l3),
        x1: downcast_u384(b_x1_l0, b_x1_l1, b_x1_l2, b_x1_l3),
        y0: downcast_u384(b_y0_l0, b_y0_l1, b_y0_l2, b_y0_l3),
        y1: downcast_u384(b_y1_l0, b_y1_l1, b_y1_l2, b_y1_l3),
    };
    let c = G1Point {
        x: downcast_u384(c_x_l0, c_x_l1, c_x_l2, c_x_l3),
        y: downcast_u384(c_y_l0, c_y_l1, c_y_l2, c_y_l3),
    };
    return (a, b, c);
}

#[inline(always)]
pub fn _deserialize_E12D_u288(ref serialized: Span<felt252>) -> E12D<u288> {
    let [
        w0l0,
        w0l1,
        w0l2,
        w1l0,
        w1l1,
        w1l2,
        w2l0,
        w2l1,
        w2l2,
        w3l0,
        w3l1,
        w3l2,
        w4l0,
        w4l1,
        w4l2,
        w5l0,
        w5l1,
        w5l2,
        w6l0,
        w6l1,
        w6l2,
        w7l0,
        w7l1,
        w7l2,
        w8l0,
        w8l1,
        w8l2,
        w9l0,
        w9l1,
        w9l2,
        w10l0,
        w10l1,
        w10l2,
        w11l0,
        w11l1,
        w11l2,
    ] =
        (*serialized
        .multi_pop_front::<36>()
        .unwrap())
        .unbox();

    E12D {
        w0: downcast_u288(w0l0, w0l1, w0l2),
        w1: downcast_u288(w1l0, w1l1, w1l2),
        w2: downcast_u288(w2l0, w2l1, w2l2),
        w3: downcast_u288(w3l0, w3l1, w3l2),
        w4: downcast_u288(w4l0, w4l1, w4l2),
        w5: downcast_u288(w5l0, w5l1, w5l2),
        w6: downcast_u288(w6l0, w6l1, w6l2),
        w7: downcast_u288(w7l0, w7l1, w7l2),
        w8: downcast_u288(w8l0, w8l1, w8l2),
        w9: downcast_u288(w9l0, w9l1, w9l2),
        w10: downcast_u288(w10l0, w10l1, w10l2),
        w11: downcast_u288(w11l0, w11l1, w11l2),
    }
}

#[inline(always)]
pub fn _deserialize_E12DMulQuotient_u288(ref serialized: Span<felt252>) -> E12DMulQuotient<u288> {
    let [
        w0l0,
        w0l1,
        w0l2,
        w1l0,
        w1l1,
        w1l2,
        w2l0,
        w2l1,
        w2l2,
        w3l0,
        w3l1,
        w3l2,
        w4l0,
        w4l1,
        w4l2,
        w5l0,
        w5l1,
        w5l2,
        w6l0,
        w6l1,
        w6l2,
        w7l0,
        w7l1,
        w7l2,
        w8l0,
        w8l1,
        w8l2,
        w9l0,
        w9l1,
        w9l2,
        w10l0,
        w10l1,
        w10l2,
    ] =
        (*serialized
        .multi_pop_front::<33>()
        .unwrap())
        .unbox();

    E12DMulQuotient {
        w0: downcast_u288(w0l0, w0l1, w0l2),
        w1: downcast_u288(w1l0, w1l1, w1l2),
        w2: downcast_u288(w2l0, w2l1, w2l2),
        w3: downcast_u288(w3l0, w3l1, w3l2),
        w4: downcast_u288(w4l0, w4l1, w4l2),
        w5: downcast_u288(w5l0, w5l1, w5l2),
        w6: downcast_u288(w6l0, w6l1, w6l2),
        w7: downcast_u288(w7l0, w7l1, w7l2),
        w8: downcast_u288(w8l0, w8l1, w8l2),
        w9: downcast_u288(w9l0, w9l1, w9l2),
        w10: downcast_u288(w10l0, w10l1, w10l2),
    }
}

#[inline(always)]
pub fn deserialize_full_proof_with_hints_bn254(
    mut serialized: Span<felt252>,
) -> FullProofWithHintsBN254 {
    let (a, b, c) = _deserialize_groth16_proof_points(ref serialized);

    let n_public_inputs: u32 = (*serialized.pop_front().unwrap()).try_into().unwrap();
    let mut public_inputs = array![];
    for _ in 0..n_public_inputs {
        public_inputs
            .append(
                u256 {
                    low: (*serialized.pop_front().unwrap()).try_into().unwrap(),
                    high: (*serialized.pop_front().unwrap()).try_into().unwrap(),
                },
            );
    }

    let groth16_proof = Groth16Proof { a: a, b: b, c: c, public_inputs: public_inputs.span() };

    let mpcheck_hint = _deserialize_mpcheck_hint_bn254(ref serialized);

    let small_Q = _deserialize_E12DMulQuotient_u288(ref serialized);

    let msm_hint = serialized;
    return FullProofWithHintsBN254 { groth16_proof, mpcheck_hint, small_Q, msm_hint };
}

pub fn deserialize_full_proof_with_hints_risc0(
    mut serialized: Span<felt252>,
) -> FullProofWithHintsRisc0 {
    let (a, b, c) = _deserialize_groth16_proof_points(ref serialized);

    let n_image_id: u32 = (*serialized.pop_front().unwrap()).try_into().unwrap();
    let mut image_id: Array<u32> = array![];
    for _ in 0..n_image_id {
        image_id.append((*serialized.pop_front().unwrap()).try_into().unwrap());
    }

    let n_journal: u32 = (*serialized.pop_front().unwrap()).try_into().unwrap();
    let mut journal: Array<u8> = array![];
    for _ in 0..n_journal {
        journal.append((*serialized.pop_front().unwrap()).try_into().unwrap());
    }

    let groth16_proof = Groth16ProofRaw { a: a, b: b, c: c };

    let mpcheck_hint = _deserialize_mpcheck_hint_bn254(ref serialized);

    let small_Q = _deserialize_E12DMulQuotient_u288(ref serialized);

    let msm_hint = serialized;
    return FullProofWithHintsRisc0 {
        groth16_proof: groth16_proof,
        image_id: image_id.span(),
        journal: journal.span(),
        mpcheck_hint: mpcheck_hint,
        small_Q: small_Q,
        msm_hint: msm_hint,
    };
}


pub fn deserialize_full_proof_with_hints_sp1(mut serialized: Span<felt252>) -> FullProofWithHintsSP1 {
    let (a, b, c) = _deserialize_groth16_proof_points(ref serialized);
    let groth16_proof = Groth16ProofRaw { a: a, b: b, c: c };
    let vkey = u256 {
        low: (*serialized.pop_front().unwrap()).try_into().unwrap(),
        high: (*serialized.pop_front().unwrap()).try_into().unwrap(),
    };
    let n_words: u32 = (*serialized.pop_front().unwrap()).try_into().unwrap();
    let mut public_inputs_sp1: Array<u32> = array![];

    for _ in 0..n_words {
        let [w7, w6, w5, w4, w3, w2, w1, w0] = (*serialized.multi_pop_front::<8>().unwrap())
            .unbox();
        public_inputs_sp1.append(w7.try_into().unwrap());
        public_inputs_sp1.append(w6.try_into().unwrap());
        public_inputs_sp1.append(w5.try_into().unwrap());
        public_inputs_sp1.append(w4.try_into().unwrap());
        public_inputs_sp1.append(w3.try_into().unwrap());
        public_inputs_sp1.append(w2.try_into().unwrap());
        public_inputs_sp1.append(w1.try_into().unwrap());
        public_inputs_sp1.append(w0.try_into().unwrap());
    }

    let mpcheck_hint = _deserialize_mpcheck_hint_bn254(ref serialized);

    let small_Q = _deserialize_E12DMulQuotient_u288(ref serialized);

    let msm_hint = serialized;
    return FullProofWithHintsSP1 {
        groth16_proof: groth16_proof,
        vkey: vkey,
        public_inputs_sp1: public_inputs_sp1,
        mpcheck_hint: mpcheck_hint,
        small_Q: small_Q,
        msm_hint: msm_hint,
    };
}


#[inline(always)]
pub fn _deserialize_mpcheck_hint_bn254(ref serialized: Span<felt252>) -> MPCheckHintBN254 {
    let lambda_root = _deserialize_E12D_u288(ref serialized);
    let lambda_root_inverse = _deserialize_E12D_u288(ref serialized);

    let [
        w0_l0,
        w0_l1,
        w0_l2,
        w2_l0,
        w2_l1,
        w2_l2,
        w4_l0,
        w4_l1,
        w4_l2,
        w6_l0,
        w6_l1,
        w6_l2,
        w8_l0,
        w8_l1,
        w8_l2,
        w10_l0,
        w10_l1,
        w10_l2,
    ] =
        (*serialized
        .multi_pop_front::<18>()
        .unwrap())
        .unbox();

    // full_len -= 18;
    // assert(full_len == serialized.len(), 'F');

    let w = MillerLoopResultScalingFactor {
        w0: downcast_u288(w0_l0, w0_l1, w0_l2),
        w2: downcast_u288(w2_l0, w2_l1, w2_l2),
        w4: downcast_u288(w4_l0, w4_l1, w4_l2),
        w6: downcast_u288(w6_l0, w6_l1, w6_l2),
        w8: downcast_u288(w8_l0, w8_l1, w8_l2),
        w10: downcast_u288(w10_l0, w10_l1, w10_l2),
    };
    // usize_assert_eq(mpcheck_hint.Ris.len(), 35);
    // 35 * 12 * 3 = 1260
    let mut ris_slice = serialized.slice(1, 1260);
    // println!("ris_slice.len(): {}", ris_slice.len());

    let end = serialized.len();
    serialized = serialized.slice(1261, end - 1260 - 1);
    // println!("serialized.len(): {}", serialized.len());
    let mut Ris = array![];
    while let Option::Some(ri) = ris_slice.multi_pop_front::<36>() {
        let [
            w0l0,
            w0l1,
            w0l2,
            w1l0,
            w1l1,
            w1l2,
            w2l0,
            w2l1,
            w2l2,
            w3l0,
            w3l1,
            w3l2,
            w4l0,
            w4l1,
            w4l2,
            w5l0,
            w5l1,
            w5l2,
            w6l0,
            w6l1,
            w6l2,
            w7l0,
            w7l1,
            w7l2,
            w8l0,
            w8l1,
            w8l2,
            w9l0,
            w9l1,
            w9l2,
            w10l0,
            w10l1,
            w10l2,
            w11l0,
            w11l1,
            w11l2,
        ] =
            (*ri)
            .unbox();
        Ris
            .append(
                E12D {
                    w0: downcast_u288(w0l0, w0l1, w0l2),
                    w1: downcast_u288(w1l0, w1l1, w1l2),
                    w2: downcast_u288(w2l0, w2l1, w2l2),
                    w3: downcast_u288(w3l0, w3l1, w3l2),
                    w4: downcast_u288(w4l0, w4l1, w4l2),
                    w5: downcast_u288(w5l0, w5l1, w5l2),
                    w6: downcast_u288(w6l0, w6l1, w6l2),
                    w7: downcast_u288(w7l0, w7l1, w7l2),
                    w8: downcast_u288(w8l0, w8l1, w8l2),
                    w9: downcast_u288(w9l0, w9l1, w9l2),
                    w10: downcast_u288(w10l0, w10l1, w10l2),
                    w11: downcast_u288(w11l0, w11l1, w11l2),
                },
            )
    }
    // usize_assert_eq(mpcheck_hint.big_Q.len(), 190);
    let mut big_q_slice = serialized.slice(1, 190 * 3);
    let end = serialized.len();
    serialized = serialized.slice(190 * 3 + 1, end - 190 * 3 - 1);
    let mut big_q = array![];
    while let Option::Some(q) = big_q_slice.multi_pop_front::<3>() {
        let [l0, l1, l2] = (*q).unbox();
        big_q.append(downcast_u288(l0, l1, l2))
    }

    let z = (*serialized.pop_front().unwrap()).try_into().unwrap();

    let mpcheck_hint = MPCheckHintBN254 {
        lambda_root: lambda_root,
        lambda_root_inverse: lambda_root_inverse,
        w: w,
        Ris: Ris.span(),
        big_Q: big_q,
        z: z,
    };
    return mpcheck_hint;
}


pub fn deserialize_mpcheck_hint_bls12_381(
    ref serialized: Span<felt252>, two_pairs: bool,
) -> MPCheckHintBLS12_381 {
    let [
        w0l0,
        w0l1,
        w0l2,
        w0l3,
        w1l0,
        w1l1,
        w1l2,
        w1l3,
        w2l0,
        w2l1,
        w2l2,
        w2l3,
        w3l0,
        w3l1,
        w3l2,
        w3l3,
        w4l0,
        w4l1,
        w4l2,
        w4l3,
        w5l0,
        w5l1,
        w5l2,
        w5l3,
        w6l0,
        w6l1,
        w6l2,
        w6l3,
        w7l0,
        w7l1,
        w7l2,
        w7l3,
        w8l0,
        w8l1,
        w8l2,
        w8l3,
        w9l0,
        w9l1,
        w9l2,
        w9l3,
        w10l0,
        w10l1,
        w10l2,
        w10l3,
        w11l0,
        w11l1,
        w11l2,
        w11l3,
    ] =
        (*serialized
        .multi_pop_front::<48>()
        .unwrap())
        .unbox();

    let lambda_root_inverse = E12D {
        w0: downcast_u384(w0l0, w0l1, w0l2, w0l3),
        w1: downcast_u384(w1l0, w1l1, w1l2, w1l3),
        w2: downcast_u384(w2l0, w2l1, w2l2, w2l3),
        w3: downcast_u384(w3l0, w3l1, w3l2, w3l3),
        w4: downcast_u384(w4l0, w4l1, w4l2, w4l3),
        w5: downcast_u384(w5l0, w5l1, w5l2, w5l3),
        w6: downcast_u384(w6l0, w6l1, w6l2, w6l3),
        w7: downcast_u384(w7l0, w7l1, w7l2, w7l3),
        w8: downcast_u384(w8l0, w8l1, w8l2, w8l3),
        w9: downcast_u384(w9l0, w9l1, w9l2, w9l3),
        w10: downcast_u384(w10l0, w10l1, w10l2, w10l3),
        w11: downcast_u384(w11l0, w11l1, w11l2, w11l3),
    };

    let [
        w0_l0,
        w0_l1,
        w0_l2,
        w0_l3,
        w2_l0,
        w2_l1,
        w2_l2,
        w2_l3,
        w4_l0,
        w4_l1,
        w4_l2,
        w4_l3,
        w6_l0,
        w6_l1,
        w6_l2,
        w6_l3,
        w8_l0,
        w8_l1,
        w8_l2,
        w8_l3,
        w10_l0,
        w10_l1,
        w10_l2,
        w10_l3,
    ] =
        (*serialized
        .multi_pop_front::<24>()
        .unwrap())
        .unbox();

    let w = MillerLoopResultScalingFactor {
        w0: downcast_u384(w0_l0, w0_l1, w0_l2, w0_l3),
        w2: downcast_u384(w2_l0, w2_l1, w2_l2, w2_l3),
        w4: downcast_u384(w4_l0, w4_l1, w4_l2, w4_l3),
        w6: downcast_u384(w6_l0, w6_l1, w6_l2, w6_l3),
        w8: downcast_u384(w8_l0, w8_l1, w8_l2, w8_l3),
        w10: downcast_u384(w10_l0, w10_l1, w10_l2, w10_l3),
    };
    // assert!(hint.Ris.len() == 36, "Wrong Number of Ris for BLS12-381 3-Pairs Paring check");
    // 36 * 12 * 4 = 1728
    let end_ris = match two_pairs {
        false => 1728,
        true => 1680,
    };
    let mut ris_slice = serialized.slice(1, end_ris);

    let end = serialized.len();
    serialized = serialized.slice(end_ris + 1, end - end_ris - 1);
    let mut Ris = array![];
    while let Option::Some(ri) = ris_slice.multi_pop_front::<48>() {
        let [
            w0l0,
            w0l1,
            w0l2,
            w0l3,
            w1l0,
            w1l1,
            w1l2,
            w1l3,
            w2l0,
            w2l1,
            w2l2,
            w2l3,
            w3l0,
            w3l1,
            w3l2,
            w3l3,
            w4l0,
            w4l1,
            w4l2,
            w4l3,
            w5l0,
            w5l1,
            w5l2,
            w5l3,
            w6l0,
            w6l1,
            w6l2,
            w6l3,
            w7l0,
            w7l1,
            w7l2,
            w7l3,
            w8l0,
            w8l1,
            w8l2,
            w8l3,
            w9l0,
            w9l1,
            w9l2,
            w9l3,
            w10l0,
            w10l1,
            w10l2,
            w10l3,
            w11l0,
            w11l1,
            w11l2,
            w11l3,
        ] =
            (*ri)
            .unbox();
        Ris
            .append(
                E12D {
                    w0: downcast_u384(w0l0, w0l1, w0l2, w0l3),
                    w1: downcast_u384(w1l0, w1l1, w1l2, w1l3),
                    w2: downcast_u384(w2l0, w2l1, w2l2, w2l3),
                    w3: downcast_u384(w3l0, w3l1, w3l2, w3l3),
                    w4: downcast_u384(w4l0, w4l1, w4l2, w4l3),
                    w5: downcast_u384(w5l0, w5l1, w5l2, w5l3),
                    w6: downcast_u384(w6l0, w6l1, w6l2, w6l3),
                    w7: downcast_u384(w7l0, w7l1, w7l2, w7l3),
                    w8: downcast_u384(w8l0, w8l1, w8l2, w8l3),
                    w9: downcast_u384(w9l0, w9l1, w9l2, w9l3),
                    w10: downcast_u384(w10l0, w10l1, w10l2, w10l3),
                    w11: downcast_u384(w11l0, w11l1, w11l2, w11l3),
                },
            )
    }

    let big_q_len: u32 = (*serialized.pop_front().unwrap()).try_into().unwrap();
    let biq_len_n_limbs = big_q_len * 4;
    let mut big_q_slice = serialized.slice(0, biq_len_n_limbs);

    serialized = serialized.slice(biq_len_n_limbs, serialized.len() - biq_len_n_limbs);
    let mut big_q = array![];
    while let Option::Some(q) = big_q_slice.multi_pop_front::<4>() {
        let [l0, l1, l2, l3] = (*q).unbox();
        big_q.append(downcast_u384(l0, l1, l2, l3))
    }
    let z = *serialized.pop_front().unwrap();
    let mpcheck_hint = MPCheckHintBLS12_381 {
        lambda_root_inverse: lambda_root_inverse, w: w, Ris: Ris.span(), big_Q: big_q, z: z,
    };

    return mpcheck_hint;
}

pub fn deserialize_full_proof_with_hints_bls12_381(
    mut serialized: Span<felt252>,
) -> FullProofWithHintsBLS12_381 {
    let (a, b, c) = _deserialize_groth16_proof_points(ref serialized);

    let n_public_inputs: u32 = (*serialized.pop_front().unwrap()).try_into().unwrap();
    let mut public_inputs = array![];
    for _ in 0..n_public_inputs {
        public_inputs
            .append(
                u256 {
                    low: (*serialized.pop_front().unwrap()).try_into().unwrap(),
                    high: (*serialized.pop_front().unwrap()).try_into().unwrap(),
                },
            );
    }

    // full_len -= (1 + 2 * n_public_inputs);
    // assert(full_len == serialized.len(), 'C');

    let groth16_proof = Groth16Proof { a: a, b: b, c: c, public_inputs: public_inputs.span() };
    // Deserialize mpcheck_hint
    let mpcheck_hint = deserialize_mpcheck_hint_bls12_381(ref serialized, false);

    let [
        w0l0,
        w0l1,
        w0l2,
        w0l3,
        w1l0,
        w1l1,
        w1l2,
        w1l3,
        w2l0,
        w2l1,
        w2l2,
        w2l3,
        w3l0,
        w3l1,
        w3l2,
        w3l3,
        w4l0,
        w4l1,
        w4l2,
        w4l3,
        w5l0,
        w5l1,
        w5l2,
        w5l3,
        w6l0,
        w6l1,
        w6l2,
        w6l3,
        w7l0,
        w7l1,
        w7l2,
        w7l3,
        w8l0,
        w8l1,
        w8l2,
        w8l3,
        w9l0,
        w9l1,
        w9l2,
        w9l3,
        w10l0,
        w10l1,
        w10l2,
        w10l3,
    ] =
        (*serialized
        .multi_pop_front::<44>()
        .unwrap())
        .unbox();

    let small_Q = E12DMulQuotient {
        w0: downcast_u384(w0l0, w0l1, w0l2, w0l3),
        w1: downcast_u384(w1l0, w1l1, w1l2, w1l3),
        w2: downcast_u384(w2l0, w2l1, w2l2, w2l3),
        w3: downcast_u384(w3l0, w3l1, w3l2, w3l3),
        w4: downcast_u384(w4l0, w4l1, w4l2, w4l3),
        w5: downcast_u384(w5l0, w5l1, w5l2, w5l3),
        w6: downcast_u384(w6l0, w6l1, w6l2, w6l3),
        w7: downcast_u384(w7l0, w7l1, w7l2, w7l3),
        w8: downcast_u384(w8l0, w8l1, w8l2, w8l3),
        w9: downcast_u384(w9l0, w9l1, w9l2, w9l3),
        w10: downcast_u384(w10l0, w10l1, w10l2, w10l3),
    };

    let msm_hint = serialized;

    return FullProofWithHintsBLS12_381 { groth16_proof, mpcheck_hint, small_Q, msm_hint };
}
