use core::circuit::{CircuitModulus, u384, u96};
use core::num::traits::Zero;
use core::panic_with_felt252;
use core::serde::Serde;
use core::traits::TryInto;
use corelib_imports::bounded_int::upcast;
use garaga::basic_field_ops::is_even_u384;
use garaga::circuits::rsa::run_RSA_FULL_VERIFICATION_circuit;
use garaga::definitions::{RSA2048Chunks, deserialize_u384, serialize_u384};

const RSA_TOP_CHUNK_LIMB1_MAX: u128 = 0xFFFF_FFFF_u128;
const RSA2048_CHUNKS_SERIALIZED_LEN: usize = 24;
const RSA2048_ENCODED_VALUE_SERIALIZED_LEN: usize = RSA2048_CHUNKS_SERIALIZED_LEN;
const RSA2048_REDUCTION_WITNESS_SERIALIZED_LEN: usize = 2 * RSA2048_ENCODED_VALUE_SERIALIZED_LEN;
const RSA2048_REDUCTION_COUNT: usize = 17;
const RSA2048_REDUCTIONS_HINT_SERIALIZED_LEN: usize = RSA2048_REDUCTION_COUNT
    * RSA2048_REDUCTION_WITNESS_SERIALIZED_LEN;
const RSA_CHANNEL_MODULI: [[u96; 4]; 11] = [
    [
        0xfffffffffffffffffffffd21, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
        0x1fffffffffffffffffffffff,
    ],
    [
        0xfffffffffffffffffffffb4d, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
        0x1fffffffffffffffffffffff,
    ],
    [
        0xfffffffffffffffffffff3ed, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
        0x1fffffffffffffffffffffff,
    ],
    [
        0xfffffffffffffffffffff05d, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
        0x1fffffffffffffffffffffff,
    ],
    [
        0xffffffffffffffffffffed33, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
        0x1fffffffffffffffffffffff,
    ],
    [
        0xffffffffffffffffffffe9b9, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
        0x1fffffffffffffffffffffff,
    ],
    [
        0xffffffffffffffffffffe877, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
        0x1fffffffffffffffffffffff,
    ],
    [
        0xffffffffffffffffffffe4db, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
        0x1fffffffffffffffffffffff,
    ],
    [
        0xffffffffffffffffffffe40f, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
        0x1fffffffffffffffffffffff,
    ],
    [
        0xffffffffffffffffffffe083, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
        0x1fffffffffffffffffffffff,
    ],
    [
        0xffffffffffffffffffffdd1d, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
        0x1fffffffffffffffffffffff,
    ],
];
const RSA_CHUNK_STEP_MODULI: [u384; 11] = [
    u384 { limb0: 0x16f8, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x2598, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x6098, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x7d18, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x9668, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0xb238, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0xbc48, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0xd928, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0xdf88, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0xfbe8, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 { limb0: 0x11718, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
];
const U384_ZERO: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };
const U384_ONE: u384 = u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 };
const RSA_ONE_CHUNKS: RSA2048Chunks = RSA2048Chunks {
    w0: U384_ONE, w1: U384_ZERO, w2: U384_ZERO, w3: U384_ZERO, w4: U384_ZERO, w5: U384_ZERO,
};

fn serialize_rsa2048_chunks(self: @RSA2048Chunks, ref output: Array<felt252>) {
    serialize_u384(self.w0, ref output);
    serialize_u384(self.w1, ref output);
    serialize_u384(self.w2, ref output);
    serialize_u384(self.w3, ref output);
    serialize_u384(self.w4, ref output);
    serialize_u384(self.w5, ref output);
}

fn deserialize_rsa2048_chunks(ref serialized: Span<felt252>) -> RSA2048Chunks {
    let w0 = deserialize_u384(ref serialized);
    let w1 = deserialize_u384(ref serialized);
    let w2 = deserialize_u384(ref serialized);
    let w3 = deserialize_u384(ref serialized);
    let w4 = deserialize_u384(ref serialized);
    let w5 = deserialize_u384(ref serialized);
    RSA2048Chunks { w0, w1, w2, w3, w4, w5 }
}

#[derive(Copy, Drop, Debug, PartialEq)]
pub struct RSA2048EncodedValue {
    pub chunks: RSA2048Chunks,
}

fn serialize_rsa2048_encoded_value(self: @RSA2048EncodedValue, ref output: Array<felt252>) {
    serialize_rsa2048_chunks(self.chunks, ref output);
}

fn deserialize_rsa2048_encoded_value(ref serialized: Span<felt252>) -> RSA2048EncodedValue {
    let chunks = deserialize_rsa2048_chunks(ref serialized);
    RSA2048EncodedValue { chunks }
}

pub impl RSA2048EncodedValueSerde of Serde<RSA2048EncodedValue> {
    fn serialize(self: @RSA2048EncodedValue, ref output: Array<felt252>) {
        serialize_rsa2048_encoded_value(self, ref output);
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<RSA2048EncodedValue> {
        Option::Some(deserialize_rsa2048_encoded_value(ref serialized))
    }
}

#[derive(Copy, Drop, Debug, PartialEq)]
pub struct RSA2048PublicKey {
    pub modulus: RSA2048EncodedValue,
}

fn serialize_rsa2048_public_key(self: @RSA2048PublicKey, ref output: Array<felt252>) {
    serialize_rsa2048_encoded_value(self.modulus, ref output);
}

fn deserialize_rsa2048_public_key(ref serialized: Span<felt252>) -> RSA2048PublicKey {
    let modulus = deserialize_rsa2048_encoded_value(ref serialized);
    RSA2048PublicKey { modulus }
}

pub impl RSA2048PublicKeySerde of Serde<RSA2048PublicKey> {
    fn serialize(self: @RSA2048PublicKey, ref output: Array<felt252>) {
        serialize_rsa2048_public_key(self, ref output);
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<RSA2048PublicKey> {
        Option::Some(deserialize_rsa2048_public_key(ref serialized))
    }
}

#[derive(Copy, Drop, Debug, PartialEq)]
pub struct RSA2048Signature {
    pub signature: RSA2048EncodedValue,
    pub expected_message: RSA2048EncodedValue,
}

fn serialize_rsa2048_signature(self: @RSA2048Signature, ref output: Array<felt252>) {
    serialize_rsa2048_encoded_value(self.signature, ref output);
    serialize_rsa2048_encoded_value(self.expected_message, ref output);
}

fn deserialize_rsa2048_signature(ref serialized: Span<felt252>) -> RSA2048Signature {
    let signature = deserialize_rsa2048_encoded_value(ref serialized);
    let expected_message = deserialize_rsa2048_encoded_value(ref serialized);
    RSA2048Signature { signature, expected_message }
}

pub impl RSA2048SignatureSerde of Serde<RSA2048Signature> {
    fn serialize(self: @RSA2048Signature, ref output: Array<felt252>) {
        serialize_rsa2048_signature(self, ref output);
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<RSA2048Signature> {
        Option::Some(deserialize_rsa2048_signature(ref serialized))
    }
}

#[derive(Copy, Drop, Debug, PartialEq)]
pub struct RSA2048ReductionWitness {
    pub quotient: RSA2048EncodedValue,
    pub remainder: RSA2048EncodedValue,
}

fn serialize_rsa2048_reduction_witness(self: @RSA2048ReductionWitness, ref output: Array<felt252>) {
    serialize_rsa2048_encoded_value(self.quotient, ref output);
    serialize_rsa2048_encoded_value(self.remainder, ref output);
}

fn deserialize_rsa2048_reduction_witness(ref serialized: Span<felt252>) -> RSA2048ReductionWitness {
    let quotient = deserialize_rsa2048_encoded_value(ref serialized);
    let remainder = deserialize_rsa2048_encoded_value(ref serialized);
    RSA2048ReductionWitness { quotient, remainder }
}

pub impl RSA2048ReductionWitnessSerde of Serde<RSA2048ReductionWitness> {
    fn serialize(self: @RSA2048ReductionWitness, ref output: Array<felt252>) {
        serialize_rsa2048_reduction_witness(self, ref output);
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<RSA2048ReductionWitness> {
        Option::Some(deserialize_rsa2048_reduction_witness(ref serialized))
    }
}

#[derive(Drop, Debug, PartialEq)]
pub struct RSA2048SignatureWithHint {
    pub signature: RSA2048Signature,
    pub reductions_hint: Span<felt252>,
}

fn serialize_rsa2048_reductions_hint(reductions_hint: Span<felt252>, ref output: Array<felt252>) {
    output.append_span(reductions_hint);
}

fn deserialize_rsa2048_reductions_hint(ref serialized: Span<felt252>) -> Option<Span<felt252>> {
    let serialized_len = serialized.len();
    if serialized_len < RSA2048_REDUCTIONS_HINT_SERIALIZED_LEN {
        return Option::None;
    }
    let reductions_hint = serialized.slice(0, RSA2048_REDUCTIONS_HINT_SERIALIZED_LEN);
    serialized = serialized
        .slice(
            RSA2048_REDUCTIONS_HINT_SERIALIZED_LEN,
            serialized_len - RSA2048_REDUCTIONS_HINT_SERIALIZED_LEN,
        );
    Option::Some(reductions_hint)
}

fn serialize_rsa2048_signature_with_hint(
    self: @RSA2048SignatureWithHint, ref output: Array<felt252>,
) {
    serialize_rsa2048_signature(self.signature, ref output);
    serialize_rsa2048_reductions_hint(*self.reductions_hint, ref output);
}

fn deserialize_rsa2048_signature_with_hint(
    ref serialized: Span<felt252>,
) -> Option<RSA2048SignatureWithHint> {
    let signature = Serde::<RSA2048Signature>::deserialize(ref serialized)?;
    let reductions_hint = deserialize_rsa2048_reductions_hint(ref serialized)?;
    Option::Some(RSA2048SignatureWithHint { signature, reductions_hint })
}

pub impl SerdeRSA2048SignatureWithHint of Serde<RSA2048SignatureWithHint> {
    fn serialize(self: @RSA2048SignatureWithHint, ref output: Array<felt252>) {
        serialize_rsa2048_signature_with_hint(self, ref output);
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<RSA2048SignatureWithHint> {
        deserialize_rsa2048_signature_with_hint(ref serialized)
    }
}

fn get_rsa_channel_modulus(i: usize) -> CircuitModulus {
    return match i {
        0 => TryInto::<
            _, CircuitModulus,
        >::try_into(
            [
                0xfffffffffffffffffffffd21, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
                0x1fffffffffffffffffffffff,
            ],
        )
            .unwrap(),
        1 => TryInto::<
            _, CircuitModulus,
        >::try_into(
            [
                0xfffffffffffffffffffffb4d, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
                0x1fffffffffffffffffffffff,
            ],
        )
            .unwrap(),
        2 => TryInto::<
            _, CircuitModulus,
        >::try_into(
            [
                0xfffffffffffffffffffff3ed, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
                0x1fffffffffffffffffffffff,
            ],
        )
            .unwrap(),
        3 => TryInto::<
            _, CircuitModulus,
        >::try_into(
            [
                0xfffffffffffffffffffff05d, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
                0x1fffffffffffffffffffffff,
            ],
        )
            .unwrap(),
        4 => TryInto::<
            _, CircuitModulus,
        >::try_into(
            [
                0xffffffffffffffffffffed33, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
                0x1fffffffffffffffffffffff,
            ],
        )
            .unwrap(),
        5 => TryInto::<
            _, CircuitModulus,
        >::try_into(
            [
                0xffffffffffffffffffffe9b9, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
                0x1fffffffffffffffffffffff,
            ],
        )
            .unwrap(),
        6 => TryInto::<
            _, CircuitModulus,
        >::try_into(
            [
                0xffffffffffffffffffffe877, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
                0x1fffffffffffffffffffffff,
            ],
        )
            .unwrap(),
        7 => TryInto::<
            _, CircuitModulus,
        >::try_into(
            [
                0xffffffffffffffffffffe4db, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
                0x1fffffffffffffffffffffff,
            ],
        )
            .unwrap(),
        8 => TryInto::<
            _, CircuitModulus,
        >::try_into(
            [
                0xffffffffffffffffffffe40f, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
                0x1fffffffffffffffffffffff,
            ],
        )
            .unwrap(),
        9 => TryInto::<
            _, CircuitModulus,
        >::try_into(
            [
                0xffffffffffffffffffffe083, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
                0x1fffffffffffffffffffffff,
            ],
        )
            .unwrap(),
        10 => TryInto::<
            _, CircuitModulus,
        >::try_into(
            [
                0xffffffffffffffffffffdd1d, 0xffffffffffffffffffffffff, 0xffffffffffffffffffffffff,
                0x1fffffffffffffffffffffff,
            ],
        )
            .unwrap(),
        _ => panic_with_felt252('bad channel'),
    };
}

fn get_rsa_chunk_step(i: usize) -> u384 {
    match i {
        0 => u384 { limb0: 0x16f8, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        1 => u384 { limb0: 0x2598, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        2 => u384 { limb0: 0x6098, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        3 => u384 { limb0: 0x7d18, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        4 => u384 { limb0: 0x9668, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        5 => u384 { limb0: 0xb238, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        6 => u384 { limb0: 0xbc48, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        7 => u384 { limb0: 0xd928, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        8 => u384 { limb0: 0xdf88, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        9 => u384 { limb0: 0xfbe8, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        10 => u384 { limb0: 0x11718, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        _ => panic_with_felt252('bad channel'),
    }
}

fn limb_lt(lhs: u96, rhs: u96) -> bool {
    let lhs_u128: u128 = upcast(lhs);
    let rhs_u128: u128 = upcast(rhs);
    lhs_u128 < rhs_u128
}

fn u384_lt(lhs: u384, rhs: u384) -> bool {
    if lhs.limb3 != rhs.limb3 {
        return limb_lt(lhs.limb3, rhs.limb3);
    }
    if lhs.limb2 != rhs.limb2 {
        return limb_lt(lhs.limb2, rhs.limb2);
    }
    if lhs.limb1 != rhs.limb1 {
        return limb_lt(lhs.limb1, rhs.limb1);
    }
    return limb_lt(lhs.limb0, rhs.limb0);
}

fn chunks_lt(lhs: RSA2048Chunks, rhs: RSA2048Chunks) -> bool {
    if lhs.w5 != rhs.w5 {
        return u384_lt(lhs.w5, rhs.w5);
    }
    if lhs.w4 != rhs.w4 {
        return u384_lt(lhs.w4, rhs.w4);
    }
    if lhs.w3 != rhs.w3 {
        return u384_lt(lhs.w3, rhs.w3);
    }
    if lhs.w2 != rhs.w2 {
        return u384_lt(lhs.w2, rhs.w2);
    }
    if lhs.w1 != rhs.w1 {
        return u384_lt(lhs.w1, rhs.w1);
    }
    return u384_lt(lhs.w0, rhs.w0);
}

fn chunks_le(lhs: RSA2048Chunks, rhs: RSA2048Chunks) -> bool {
    lhs == rhs || chunks_lt(lhs, rhs)
}

fn top_chunk_is_well_formed(top: u384) -> bool {
    if top.limb2 != 0 {
        return false;
    }
    if top.limb3 != 0 {
        return false;
    }
    let limb1: u128 = upcast(top.limb1);
    limb1 <= RSA_TOP_CHUNK_LIMB1_MAX
}

#[inline(never)]
pub(crate) fn is_valid_rsa2048_signature_assuming_encoded_message_ref(
    signature: @RSA2048SignatureWithHint, public_key: @RSA2048PublicKey,
) -> bool {
    let modulus_chunks = *public_key.modulus.chunks;
    let sig_chunks = *signature.signature.signature.chunks;
    let expected_message_chunks = *signature.signature.expected_message.chunks;

    if !top_chunk_is_well_formed(modulus_chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(sig_chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(expected_message_chunks.w5) {
        return false;
    }

    if chunks_le(modulus_chunks, RSA_ONE_CHUNKS) {
        return false;
    }
    if is_even_u384(modulus_chunks.w0) {
        return false;
    }
    if !chunks_lt(sig_chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(expected_message_chunks, modulus_chunks) {
        return false;
    }

    let mut reductions_hint = *signature.reductions_hint;

    // Deserialize all 17 witnesses upfront
    if reductions_hint.len() < RSA2048_REDUCTIONS_HINT_SERIALIZED_LEN {
        return false;
    }

    let w0 = deserialize_rsa2048_reduction_witness(ref reductions_hint);
    let w1 = deserialize_rsa2048_reduction_witness(ref reductions_hint);
    let w2 = deserialize_rsa2048_reduction_witness(ref reductions_hint);
    let w3 = deserialize_rsa2048_reduction_witness(ref reductions_hint);
    let w4 = deserialize_rsa2048_reduction_witness(ref reductions_hint);
    let w5 = deserialize_rsa2048_reduction_witness(ref reductions_hint);
    let w6 = deserialize_rsa2048_reduction_witness(ref reductions_hint);
    let w7 = deserialize_rsa2048_reduction_witness(ref reductions_hint);
    let w8 = deserialize_rsa2048_reduction_witness(ref reductions_hint);
    let w9 = deserialize_rsa2048_reduction_witness(ref reductions_hint);
    let w10 = deserialize_rsa2048_reduction_witness(ref reductions_hint);
    let w11 = deserialize_rsa2048_reduction_witness(ref reductions_hint);
    let w12 = deserialize_rsa2048_reduction_witness(ref reductions_hint);
    let w13 = deserialize_rsa2048_reduction_witness(ref reductions_hint);
    let w14 = deserialize_rsa2048_reduction_witness(ref reductions_hint);
    let w15 = deserialize_rsa2048_reduction_witness(ref reductions_hint);
    let w16 = deserialize_rsa2048_reduction_witness(ref reductions_hint);

    if !reductions_hint.is_empty() {
        return false;
    }

    // Validate top chunks for all 34 values (17 quotients + 17 remainders)
    if !top_chunk_is_well_formed(w0.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w0.remainder.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w1.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w1.remainder.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w2.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w2.remainder.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w3.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w3.remainder.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w4.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w4.remainder.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w5.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w5.remainder.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w6.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w6.remainder.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w7.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w7.remainder.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w8.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w8.remainder.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w9.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w9.remainder.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w10.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w10.remainder.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w11.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w11.remainder.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w12.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w12.remainder.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w13.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w13.remainder.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w14.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w14.remainder.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w15.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w15.remainder.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w16.quotient.chunks.w5) {
        return false;
    }
    if !top_chunk_is_well_formed(w16.remainder.chunks.w5) {
        return false;
    }

    // Validate all 17 remainders < modulus
    if !chunks_lt(w0.remainder.chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(w1.remainder.chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(w2.remainder.chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(w3.remainder.chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(w4.remainder.chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(w5.remainder.chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(w6.remainder.chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(w7.remainder.chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(w8.remainder.chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(w9.remainder.chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(w10.remainder.chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(w11.remainder.chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(w12.remainder.chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(w13.remainder.chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(w14.remainder.chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(w15.remainder.chunks, modulus_chunks) {
        return false;
    }
    if !chunks_lt(w16.remainder.chunks, modulus_chunks) {
        return false;
    }

    // Run mega-circuit for each of 11 channels
    let mut channel_idx: usize = 0;
    while channel_idx < 11 {
        let (d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15, d16) =
            run_RSA_FULL_VERIFICATION_circuit(
            modulus_chunks,
            sig_chunks,
            w0.quotient.chunks,
            w0.remainder.chunks,
            w1.quotient.chunks,
            w1.remainder.chunks,
            w2.quotient.chunks,
            w2.remainder.chunks,
            w3.quotient.chunks,
            w3.remainder.chunks,
            w4.quotient.chunks,
            w4.remainder.chunks,
            w5.quotient.chunks,
            w5.remainder.chunks,
            w6.quotient.chunks,
            w6.remainder.chunks,
            w7.quotient.chunks,
            w7.remainder.chunks,
            w8.quotient.chunks,
            w8.remainder.chunks,
            w9.quotient.chunks,
            w9.remainder.chunks,
            w10.quotient.chunks,
            w10.remainder.chunks,
            w11.quotient.chunks,
            w11.remainder.chunks,
            w12.quotient.chunks,
            w12.remainder.chunks,
            w13.quotient.chunks,
            w13.remainder.chunks,
            w14.quotient.chunks,
            w14.remainder.chunks,
            w15.quotient.chunks,
            w15.remainder.chunks,
            w16.quotient.chunks,
            w16.remainder.chunks,
            get_rsa_chunk_step(channel_idx),
            get_rsa_channel_modulus(channel_idx),
        );
        if !d0.is_zero()
            || !d1.is_zero()
            || !d2.is_zero()
            || !d3.is_zero()
            || !d4.is_zero()
            || !d5.is_zero()
            || !d6.is_zero()
            || !d7.is_zero()
            || !d8.is_zero()
            || !d9.is_zero()
            || !d10.is_zero()
            || !d11.is_zero()
            || !d12.is_zero()
            || !d13.is_zero()
            || !d14.is_zero()
            || !d15.is_zero()
            || !d16.is_zero() {
            return false;
        }
        channel_idx += 1;
    }

    // Compare last remainder == expected message
    w16.remainder.chunks == expected_message_chunks
}

pub fn is_valid_rsa2048_signature_assuming_encoded_message(
    signature: RSA2048SignatureWithHint, public_key: RSA2048PublicKey,
) -> bool {
    is_valid_rsa2048_signature_assuming_encoded_message_ref(@signature, @public_key)
}
