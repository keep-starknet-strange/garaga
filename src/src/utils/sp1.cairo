use core::integer;
use core::internal::bounded_int;
use core::internal::bounded_int::{AddHelper, BoundedInt, DivRemHelper, MulHelper, UnitInt, upcast};
use core::sha256::{compute_sha256_byte_array, compute_sha256_u32_array};
use garaga::utils::usize_assert_eq;

const POW_32: felt252 = 0x100000000;
const POW_64: felt252 = 0x10000000000000000;
const POW_96: felt252 = 0x1000000000000000000000000;

const POW_32_UI: UnitInt<POW_32> = 0x100000000;
const POW_64_UI: UnitInt<POW_64> = 0x10000000000000000;
const POW_96_UI: UnitInt<POW_96> = 0x1000000000000000000000000;

const POW_128: felt252 = 0x100000000000000000000000000000000;


pub type u32_bi = BoundedInt<0, { POW_32 - 1 }>;
pub type u64_bi = BoundedInt<0, { POW_64 - 1 }>;
pub type u96_bi = BoundedInt<0, { POW_96 - 1 }>;
pub type u128_bi = BoundedInt<0, { POW_128 - 1 }>;

pub type w1_shift_32 = BoundedInt<0, { 0xffffffff00000000 }>; // (2**32)-1 * 2**32
pub type w2_shift_64 = BoundedInt<0, { 0xffffffff0000000000000000 }>; // (2**32)-1 * 2**64
pub type w3_shift_96 = BoundedInt<0, { 0xffffffff000000000000000000000000 }>; // (2**32)-1 * 2**96


impl MulHelperU32ByPow32Impl of MulHelper<u32_bi, UnitInt<POW_32>> {
    type Result = w1_shift_32;
}

impl MulHelperU32ByPow64Impl of MulHelper<u32_bi, UnitInt<POW_64>> {
    type Result = w2_shift_64;
}

impl MulHelperU32ByPow96Impl of MulHelper<u32_bi, UnitInt<POW_96>> {
    type Result = w3_shift_96;
}

impl AddHelperU32ByW1Impl of AddHelper<u32_bi, w1_shift_32> {
    type Result = u64_bi;
}

impl AddHelperU64ByW2Impl of AddHelper<u64_bi, w2_shift_64> {
    type Result = u96_bi;
}

impl AddHelperU96ByW3Impl of AddHelper<u96_bi, w3_shift_96> {
    type Result = u128_bi;
}


pub fn convert_u32_to_u128(input: [u32; 4]) -> u128 {
    let [w3, w2, w1, w0] = input;
    let w3_bi: u32_bi = upcast(w3);
    let w2_bi: u32_bi = upcast(w2);
    let w1_bi: u32_bi = upcast(w1);
    let w0_bi: u32_bi = upcast(w0);
    let tmp: u64_bi = bounded_int::add(w0_bi, bounded_int::mul(w1_bi, POW_32_UI));
    let tmp: u96_bi = bounded_int::add(tmp, bounded_int::mul(w2_bi, POW_64_UI));
    let result: u128_bi = bounded_int::add(tmp, bounded_int::mul(w3_bi, POW_96_UI));
    return upcast(result);
}

// 2**253
const POW_253: u256 = 0x2000000000000000000000000000000000000000000000000000000000000000;

pub fn process_public_inputs_sp1(public_inputs: Array<u32>) -> (Span<u256>, u256) {
    let mut pi = public_inputs.span();

    let mut pub_inputs_256: Array<u256> = array![];

    assert(public_inputs.len() % 8 == 0, 'wrong sp1 pub inputs size');

    while let Option::Some(word) = pi.multi_pop_front::<8>() {
        let [w7, w6, w5, w4, w3, w2, w1, w0] = (*word).unbox();
        let high_128 = convert_u32_to_u128([w7, w6, w5, w4]);
        let low_128 = convert_u32_to_u128([w3, w2, w1, w0]);
        pub_inputs_256.append(u256 { low: low_128, high: high_128 });
    }
    let [h7, h6, h5, h4, h3, h2, h1, h0] = compute_sha256_u32_array(
        input: public_inputs, last_input_word: 0, last_input_num_bytes: 0,
    );

    let hash_raw = u256 {
        low: convert_u32_to_u128([h3, h2, h1, h0]), high: convert_u32_to_u128([h7, h6, h5, h4]),
    };
    let hash_mod = hash_raw % POW_253;

    return (pub_inputs_256.span(), hash_mod);
}


#[cfg(test)]
mod tests {
    use super::convert_u32_to_u128;

    #[test]
    fn test_convert_u32_to_u128() {
        let input = [0, 0, 0, 1];
        let result = convert_u32_to_u128(input);
        assert_eq!(result, 1);
    }
}
