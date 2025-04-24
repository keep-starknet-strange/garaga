pub mod curves;
pub mod structs {
    pub mod fields;
    pub mod points;
}
use core::RangeCheck;

pub use core::circuit::{u384, u96};
use core::num::traits::{One, Zero};
use core::serde::Serde;


pub use curves::{
    BLS12_381, BLSProcessedPair, BLS_G2_GENERATOR, BLS_X_SEED_SQ, BLS_X_SEED_SQ_EPNS, BN254,
    BN254_G1_GENERATOR, BNProcessedPair, Curve, ED25519, GRUMPKIN, SECP256K1, SECP256R1,
    THIRD_ROOT_OF_UNITY_BLS12_381_G1, bls_bits, bn_bits, get_BLS12_381_modulus, get_BN254_modulus,
    get_ED25519_modulus, get_G, get_GRUMPKIN_modulus, get_SECP256K1_modulus, get_SECP256R1_modulus,
    get_a, get_b, get_b2, get_curve_order_modulus, get_eigenvalue, get_g, get_min_one, get_min_one_order, get_modulus,
    get_n, get_nbits_and_nG_glv_fake_glv, get_p,
};
pub use structs::fields::{
    E12D, E12DMulQuotient, E12T, MillerLoopResultScalingFactor, u288, u288Serde,
};
pub use structs::points::{
    G1G2Pair, G1Point, G1PointSerde, G1PointZero, G2Line, G2Point, G2PointSerde, G2PointZero,
};


extern fn downcast<felt252, u96>(x: felt252) -> Option<u96> implicits(RangeCheck) nopanic;


pub impl u384Serde of Serde<u384> {
    fn serialize(self: @u384, ref output: Array<felt252>) {
        output.append((*self.limb0).into());
        output.append((*self.limb1).into());
        output.append((*self.limb2).into());
        output.append((*self.limb3).into());
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<u384> {
        let [l0, l1, l2, l3] = (*serialized.multi_pop_front::<4>().unwrap()).unbox();
        let limb0 = downcast(l0).unwrap();
        let limb1 = downcast(l1).unwrap();
        let limb2 = downcast(l2).unwrap();
        let limb3 = downcast(l3).unwrap();
        return Option::Some(u384 { limb0: limb0, limb1: limb1, limb2: limb2, limb3: limb3 });
    }
}

// pub impl u384Serde of Serde<u384> {
pub fn serialize_u384(self: @u384, ref output: Array<felt252>) {
    output.append((*self.limb0).into());
    output.append((*self.limb1).into());
    output.append((*self.limb2).into());
    output.append((*self.limb3).into());
}
pub fn deserialize_u384(ref serialized: Span<felt252>) -> u384 {
    let [l0, l1, l2, l3] = (*serialized.multi_pop_front::<4>().unwrap()).unbox();
    let limb0 = downcast(l0).unwrap();
    let limb1 = downcast(l1).unwrap();
    let limb2 = downcast(l2).unwrap();
    let limb3 = downcast(l3).unwrap();
    return u384 { limb0: limb0, limb1: limb1, limb2: limb2, limb3: limb3 };
}

fn serialize_u384_array(self: @Array<u384>, ref output: Array<felt252>) {
    self.len().serialize(ref output);
    serialize_u384_array_helper(self.span(), ref output);
}

fn serialize_u384_array_helper(mut input: Span<u384>, ref output: Array<felt252>) {
    if let Option::Some(value) = input.pop_front() {
        serialize_u384(value, ref output);
        serialize_u384_array_helper(input, ref output);
    }
}

fn deserialize_u384_array(ref serialized: Span<felt252>) -> Array<u384> {
    let length = *serialized.pop_front().unwrap();
    let mut arr = array![];
    deserialize_u384_array_helper(ref serialized, arr, length)
}

fn deserialize_u384_array_helper(
    ref serialized: Span<felt252>, mut curr_output: Array<u384>, remaining: felt252,
) -> Array<u384> {
    if remaining == 0 {
        return curr_output;
    }
    curr_output.append(deserialize_u384(ref serialized));
    deserialize_u384_array_helper(ref serialized, curr_output, remaining - 1)
}


fn serialize_u288_array(self: @Array<u288>, ref output: Array<felt252>) {
    self.len().serialize(ref output);
    serialize_u288_array_helper(self.span(), ref output);
}

fn serialize_u288_array_helper(mut input: Span<u288>, ref output: Array<felt252>) {
    if let Option::Some(value) = input.pop_front() {
        u288Serde::serialize(value, ref output);
        serialize_u288_array_helper(input, ref output);
    }
}

fn deserialize_u288_array(ref serialized: Span<felt252>) -> Array<u288> {
    let length = *serialized.pop_front().unwrap();
    let mut arr = array![];
    deserialize_u288_array_helper(ref serialized, arr, length)
}


fn deserialize_u288(ref serialized: Span<felt252>) -> u288 {
    let [l0, l1, l2] = (*serialized.multi_pop_front::<3>().unwrap()).unbox();
    let limb0 = downcast(l0).unwrap();
    let limb1 = downcast(l1).unwrap();
    let limb2 = downcast(l2).unwrap();
    return u288 { limb0: limb0, limb1: limb1, limb2: limb2 };
}

fn deserialize_u288_array_helper(
    ref serialized: Span<felt252>, mut curr_output: Array<u288>, remaining: felt252,
) -> Array<u288> {
    if remaining == 0 {
        return curr_output;
    }
    curr_output.append(deserialize_u288(ref serialized));
    deserialize_u288_array_helper(ref serialized, curr_output, remaining - 1)
}
