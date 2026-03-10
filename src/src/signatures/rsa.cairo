use core::circuit::{CircuitModulus, u384, u96};
use core::num::traits::Zero;
use core::panic_with_felt252;
use core::serde::Serde;
use core::traits::TryInto;
use corelib_imports::bounded_int::upcast;
use garaga::basic_field_ops::is_even_u384;
use garaga::circuits::rsa::{run_RSA_EVAL_6_CHUNKS_circuit, run_RSA_FUSED_EVAL_RELATION_circuit};
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

#[derive(Copy, Drop, Debug, PartialEq)]
pub struct RSA2048Residues {
    pub r0: u384,
    pub r1: u384,
    pub r2: u384,
    pub r3: u384,
    pub r4: u384,
    pub r5: u384,
    pub r6: u384,
    pub r7: u384,
    pub r8: u384,
    pub r9: u384,
    pub r10: u384,
}

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

fn serialize_rsa2048_residues(self: @RSA2048Residues, ref output: Array<felt252>) {
    serialize_u384(self.r0, ref output);
    serialize_u384(self.r1, ref output);
    serialize_u384(self.r2, ref output);
    serialize_u384(self.r3, ref output);
    serialize_u384(self.r4, ref output);
    serialize_u384(self.r5, ref output);
    serialize_u384(self.r6, ref output);
    serialize_u384(self.r7, ref output);
    serialize_u384(self.r8, ref output);
    serialize_u384(self.r9, ref output);
    serialize_u384(self.r10, ref output);
}

fn deserialize_rsa2048_residues(ref serialized: Span<felt252>) -> RSA2048Residues {
    let r0 = deserialize_u384(ref serialized);
    let r1 = deserialize_u384(ref serialized);
    let r2 = deserialize_u384(ref serialized);
    let r3 = deserialize_u384(ref serialized);
    let r4 = deserialize_u384(ref serialized);
    let r5 = deserialize_u384(ref serialized);
    let r6 = deserialize_u384(ref serialized);
    let r7 = deserialize_u384(ref serialized);
    let r8 = deserialize_u384(ref serialized);
    let r9 = deserialize_u384(ref serialized);
    let r10 = deserialize_u384(ref serialized);
    RSA2048Residues { r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10 }
}

pub impl RSA2048ResiduesSerde of Serde<RSA2048Residues> {
    fn serialize(self: @RSA2048Residues, ref output: Array<felt252>) {
        serialize_rsa2048_residues(self, ref output);
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<RSA2048Residues> {
        Option::Some(deserialize_rsa2048_residues(ref serialized))
    }
}

#[derive(Copy, Drop, Debug, PartialEq)]
pub struct RSA2048EncodedValue {
    pub chunks: RSA2048Chunks,
}

#[derive(Copy, Drop, Debug, PartialEq)]
struct RSA2048EvaluatedValue {
    pub chunks: RSA2048Chunks,
    pub residues: RSA2048Residues,
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
fn derive_rsa2048_residues(chunks: @RSA2048Chunks) -> RSA2048Residues {
    let (r0,) = run_RSA_EVAL_6_CHUNKS_circuit(
        *chunks, get_rsa_chunk_step(0), get_rsa_channel_modulus(0),
    );
    let (r1,) = run_RSA_EVAL_6_CHUNKS_circuit(
        *chunks, get_rsa_chunk_step(1), get_rsa_channel_modulus(1),
    );
    let (r2,) = run_RSA_EVAL_6_CHUNKS_circuit(
        *chunks, get_rsa_chunk_step(2), get_rsa_channel_modulus(2),
    );
    let (r3,) = run_RSA_EVAL_6_CHUNKS_circuit(
        *chunks, get_rsa_chunk_step(3), get_rsa_channel_modulus(3),
    );
    let (r4,) = run_RSA_EVAL_6_CHUNKS_circuit(
        *chunks, get_rsa_chunk_step(4), get_rsa_channel_modulus(4),
    );
    let (r5,) = run_RSA_EVAL_6_CHUNKS_circuit(
        *chunks, get_rsa_chunk_step(5), get_rsa_channel_modulus(5),
    );
    let (r6,) = run_RSA_EVAL_6_CHUNKS_circuit(
        *chunks, get_rsa_chunk_step(6), get_rsa_channel_modulus(6),
    );
    let (r7,) = run_RSA_EVAL_6_CHUNKS_circuit(
        *chunks, get_rsa_chunk_step(7), get_rsa_channel_modulus(7),
    );
    let (r8,) = run_RSA_EVAL_6_CHUNKS_circuit(
        *chunks, get_rsa_chunk_step(8), get_rsa_channel_modulus(8),
    );
    let (r9,) = run_RSA_EVAL_6_CHUNKS_circuit(
        *chunks, get_rsa_chunk_step(9), get_rsa_channel_modulus(9),
    );
    let (r10,) = run_RSA_EVAL_6_CHUNKS_circuit(
        *chunks, get_rsa_chunk_step(10), get_rsa_channel_modulus(10),
    );
    RSA2048Residues { r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10 }
}

#[inline(never)]
fn evaluate_rsa2048_encoded_value(x: @RSA2048EncodedValue) -> Option<RSA2048EvaluatedValue> {
    if !top_chunk_is_well_formed(*x.chunks.w5) {
        return Option::None;
    }
    let chunks = *x.chunks;
    let residues = derive_rsa2048_residues(x.chunks);
    Option::Some(RSA2048EvaluatedValue { chunks, residues })
}

#[inline(never)]
fn pop_and_validate_reduction_witness(
    lhs: @RSA2048EvaluatedValue,
    rhs: @RSA2048EvaluatedValue,
    modulus: @RSA2048EvaluatedValue,
    ref reductions_hint: Span<felt252>,
) -> Option<RSA2048EvaluatedValue> {
    if reductions_hint.len() < RSA2048_REDUCTION_WITNESS_SERIALIZED_LEN {
        return Option::None;
    }

    let witness = deserialize_rsa2048_reduction_witness(ref reductions_hint);

    if !top_chunk_is_well_formed(witness.quotient.chunks.w5) {
        return Option::None;
    }
    if !top_chunk_is_well_formed(witness.remainder.chunks.w5) {
        return Option::None;
    }
    if !chunks_lt(witness.remainder.chunks, *modulus.chunks) {
        return Option::None;
    }

    let (r0, diff0) = run_RSA_FUSED_EVAL_RELATION_circuit(
        witness.quotient.chunks,
        witness.remainder.chunks,
        get_rsa_chunk_step(0),
        *lhs.residues.r0,
        *rhs.residues.r0,
        *modulus.residues.r0,
        get_rsa_channel_modulus(0),
    );
    if !diff0.is_zero() {
        return Option::None;
    }
    let (r1, diff1) = run_RSA_FUSED_EVAL_RELATION_circuit(
        witness.quotient.chunks,
        witness.remainder.chunks,
        get_rsa_chunk_step(1),
        *lhs.residues.r1,
        *rhs.residues.r1,
        *modulus.residues.r1,
        get_rsa_channel_modulus(1),
    );
    if !diff1.is_zero() {
        return Option::None;
    }
    let (r2, diff2) = run_RSA_FUSED_EVAL_RELATION_circuit(
        witness.quotient.chunks,
        witness.remainder.chunks,
        get_rsa_chunk_step(2),
        *lhs.residues.r2,
        *rhs.residues.r2,
        *modulus.residues.r2,
        get_rsa_channel_modulus(2),
    );
    if !diff2.is_zero() {
        return Option::None;
    }
    let (r3, diff3) = run_RSA_FUSED_EVAL_RELATION_circuit(
        witness.quotient.chunks,
        witness.remainder.chunks,
        get_rsa_chunk_step(3),
        *lhs.residues.r3,
        *rhs.residues.r3,
        *modulus.residues.r3,
        get_rsa_channel_modulus(3),
    );
    if !diff3.is_zero() {
        return Option::None;
    }
    let (r4, diff4) = run_RSA_FUSED_EVAL_RELATION_circuit(
        witness.quotient.chunks,
        witness.remainder.chunks,
        get_rsa_chunk_step(4),
        *lhs.residues.r4,
        *rhs.residues.r4,
        *modulus.residues.r4,
        get_rsa_channel_modulus(4),
    );
    if !diff4.is_zero() {
        return Option::None;
    }
    let (r5, diff5) = run_RSA_FUSED_EVAL_RELATION_circuit(
        witness.quotient.chunks,
        witness.remainder.chunks,
        get_rsa_chunk_step(5),
        *lhs.residues.r5,
        *rhs.residues.r5,
        *modulus.residues.r5,
        get_rsa_channel_modulus(5),
    );
    if !diff5.is_zero() {
        return Option::None;
    }
    let (r6, diff6) = run_RSA_FUSED_EVAL_RELATION_circuit(
        witness.quotient.chunks,
        witness.remainder.chunks,
        get_rsa_chunk_step(6),
        *lhs.residues.r6,
        *rhs.residues.r6,
        *modulus.residues.r6,
        get_rsa_channel_modulus(6),
    );
    if !diff6.is_zero() {
        return Option::None;
    }
    let (r7, diff7) = run_RSA_FUSED_EVAL_RELATION_circuit(
        witness.quotient.chunks,
        witness.remainder.chunks,
        get_rsa_chunk_step(7),
        *lhs.residues.r7,
        *rhs.residues.r7,
        *modulus.residues.r7,
        get_rsa_channel_modulus(7),
    );
    if !diff7.is_zero() {
        return Option::None;
    }
    let (r8, diff8) = run_RSA_FUSED_EVAL_RELATION_circuit(
        witness.quotient.chunks,
        witness.remainder.chunks,
        get_rsa_chunk_step(8),
        *lhs.residues.r8,
        *rhs.residues.r8,
        *modulus.residues.r8,
        get_rsa_channel_modulus(8),
    );
    if !diff8.is_zero() {
        return Option::None;
    }
    let (r9, diff9) = run_RSA_FUSED_EVAL_RELATION_circuit(
        witness.quotient.chunks,
        witness.remainder.chunks,
        get_rsa_chunk_step(9),
        *lhs.residues.r9,
        *rhs.residues.r9,
        *modulus.residues.r9,
        get_rsa_channel_modulus(9),
    );
    if !diff9.is_zero() {
        return Option::None;
    }
    let (r10, diff10) = run_RSA_FUSED_EVAL_RELATION_circuit(
        witness.quotient.chunks,
        witness.remainder.chunks,
        get_rsa_chunk_step(10),
        *lhs.residues.r10,
        *rhs.residues.r10,
        *modulus.residues.r10,
        get_rsa_channel_modulus(10),
    );
    if !diff10.is_zero() {
        return Option::None;
    }

    Option::Some(
        RSA2048EvaluatedValue {
            chunks: witness.remainder.chunks,
            residues: RSA2048Residues { r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10 },
        },
    )
}

#[inline(never)]
fn validate_square_reductions(
    remaining: usize,
    current_remainder: RSA2048EvaluatedValue,
    modulus: @RSA2048EvaluatedValue,
    ref reductions_hint: Span<felt252>,
) -> Option<RSA2048EvaluatedValue> {
    if remaining == 0 {
        return Option::Some(current_remainder);
    }

    let next_remainder = pop_and_validate_reduction_witness(
        @current_remainder, @current_remainder, modulus, ref reductions_hint,
    )?;
    validate_square_reductions(remaining - 1, next_remainder, modulus, ref reductions_hint)
}

#[inline(never)]
pub(crate) fn is_valid_rsa2048_signature_assuming_encoded_message_ref(
    signature: @RSA2048SignatureWithHint, public_key: @RSA2048PublicKey,
) -> bool {
    let modulus = match evaluate_rsa2048_encoded_value(public_key.modulus) {
        Option::Some(value) => value,
        Option::None => { return false; },
    };
    let base_signature = match evaluate_rsa2048_encoded_value(signature.signature.signature) {
        Option::Some(value) => value,
        Option::None => { return false; },
    };
    let expected_message =
        match evaluate_rsa2048_encoded_value(signature.signature.expected_message) {
        Option::Some(value) => value,
        Option::None => { return false; },
    };

    if chunks_le(modulus.chunks, RSA_ONE_CHUNKS) {
        return false;
    }
    if is_even_u384(modulus.chunks.w0) {
        return false;
    }
    if !chunks_lt(base_signature.chunks, modulus.chunks) {
        return false;
    }
    if !chunks_lt(expected_message.chunks, modulus.chunks) {
        return false;
    }

    let mut reductions_hint = *signature.reductions_hint;
    let current_remainder =
        match pop_and_validate_reduction_witness(
            @base_signature, @base_signature, @modulus, ref reductions_hint,
        ) {
        Option::Some(remainder) => remainder,
        Option::None => { return false; },
    };
    let current_remainder =
        match validate_square_reductions(
            RSA2048_REDUCTION_COUNT - 2, current_remainder, @modulus, ref reductions_hint,
        ) {
        Option::Some(remainder) => remainder,
        Option::None => { return false; },
    };
    let current_remainder =
        match pop_and_validate_reduction_witness(
            @current_remainder, @base_signature, @modulus, ref reductions_hint,
        ) {
        Option::Some(remainder) => remainder,
        Option::None => { return false; },
    };

    if !reductions_hint.is_empty() {
        return false;
    }

    current_remainder.chunks == expected_message.chunks
}

pub fn is_valid_rsa2048_signature_assuming_encoded_message(
    signature: RSA2048SignatureWithHint, public_key: RSA2048PublicKey,
) -> bool {
    is_valid_rsa2048_signature_assuming_encoded_message_ref(@signature, @public_key)
}
