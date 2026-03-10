//! RSA-2048 signature verification via multi-channel RNS arithmetic.
//!
//! Verifies s^{65537} ≡ m (mod n) for a 2048-bit RSA modulus n without
//! native 2048-bit arithmetic. Integers are represented in a Residue Number
//! System (RNS) defined by 11 pairwise coprime ~384-bit primes p_1, ..., p_{11}.
//!
//! Each modular reduction a·b = q·n + r in the exponentiation chain is verified
//! by evaluating chunk polynomials at α_i = (2^{96})^4 mod p_i via Horner's method
//! and checking a(α_i)·b(α_i) - q(α_i)·n(α_i) - r(α_i) = 0 for all i.
//!
//! The CRT exactness theorem guarantees that if all 11 channel checks pass and
//! ∏ p_i exceeds the maximum deviation |a·b - q·n - r|, then the integer
//! relation holds exactly.

use core::circuit::{CircuitModulus, u384, u96};
use core::num::traits::Zero;
use core::serde::Serde;
use core::sha256::compute_sha256_byte_array;
use core::traits::TryInto;
use corelib_imports::bounded_int::{downcast, upcast};
use garaga::basic_field_ops::is_even_u384;
use garaga::circuits::rsa::run_RSA_FULL_VERIFICATION_circuit;
use garaga::definitions::{RSA2048Chunks, RSA2048ReductionWitness, deserialize_u384, serialize_u384};

const RSA_TOP_CHUNK_LIMB1_MAX: u128 = 0xFFFF_FFFF_u128;
const RSA2048_CHUNKS_SERIALIZED_LEN: usize = 24;
const RSA2048_REDUCTION_WITNESS_SERIALIZED_LEN: usize = 2 * RSA2048_CHUNKS_SERIALIZED_LEN;
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
const U384_ZERO: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 };
const U384_ONE: u384 = u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 };
/// The multiplicative identity 1 in chunk representation.
const RSA_ONE_CHUNKS: RSA2048Chunks = RSA2048Chunks {
    w0: U384_ONE, w1: U384_ZERO, w2: U384_ZERO, w3: U384_ZERO, w4: U384_ZERO, w5: U384_ZERO,
};

/// Horner evaluation bases: α_i = (2^96)^4 mod p_i for each of the 11 channel primes.
/// Used to evaluate the chunk polynomial representation of 2048-bit integers
/// within each RNS channel circuit.
const RSA_CHUNK_STEPS: [u384; 11] = [
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
pub struct RSA2048PublicKey {
    pub modulus: RSA2048Chunks,
}

pub impl RSA2048PublicKeySerde of Serde<RSA2048PublicKey> {
    fn serialize(self: @RSA2048PublicKey, ref output: Array<felt252>) {
        serialize_rsa2048_chunks(self.modulus, ref output);
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<RSA2048PublicKey> {
        Option::Some(RSA2048PublicKey { modulus: deserialize_rsa2048_chunks(ref serialized) })
    }
}

#[derive(Copy, Drop, Debug, PartialEq)]
pub struct RSA2048Signature {
    pub signature: RSA2048Chunks,
    pub expected_message: RSA2048Chunks,
}

pub impl RSA2048SignatureSerde of Serde<RSA2048Signature> {
    fn serialize(self: @RSA2048Signature, ref output: Array<felt252>) {
        serialize_rsa2048_chunks(self.signature, ref output);
        serialize_rsa2048_chunks(self.expected_message, ref output);
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<RSA2048Signature> {
        let signature = deserialize_rsa2048_chunks(ref serialized);
        let expected_message = deserialize_rsa2048_chunks(ref serialized);
        Option::Some(RSA2048Signature { signature, expected_message })
    }
}

pub impl RSA2048ReductionWitnessSerde of Serde<RSA2048ReductionWitness> {
    fn serialize(self: @RSA2048ReductionWitness, ref output: Array<felt252>) {
        serialize_rsa2048_chunks(self.quotient, ref output);
        serialize_rsa2048_chunks(self.remainder, ref output);
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<RSA2048ReductionWitness> {
        let quotient = deserialize_rsa2048_chunks(ref serialized);
        let remainder = deserialize_rsa2048_chunks(ref serialized);
        Option::Some(RSA2048ReductionWitness { quotient, remainder })
    }
}

#[derive(Drop, Debug, PartialEq)]
pub struct RSA2048SignatureWithHint {
    pub signature: RSA2048Signature,
    pub reductions_hint: Span<felt252>,
}

pub impl SerdeRSA2048SignatureWithHint of Serde<RSA2048SignatureWithHint> {
    fn serialize(self: @RSA2048SignatureWithHint, ref output: Array<felt252>) {
        Serde::<RSA2048Signature>::serialize(self.signature, ref output);
        output.append_span(*self.reductions_hint);
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<RSA2048SignatureWithHint> {
        let signature = Serde::<RSA2048Signature>::deserialize(ref serialized)?;
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
        Option::Some(RSA2048SignatureWithHint { signature, reductions_hint })
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

/// Deserialize and validate a modular reduction witness (q, r) from raw felt252 data.
/// Checks that both quotient and remainder have well-formed top chunks,
/// and that the remainder is strictly less than the modulus.
fn deserialize_and_validate_witness(
    ref hint: Span<felt252>, modulus_chunks: RSA2048Chunks,
) -> RSA2048ReductionWitness {
    let quotient = deserialize_rsa2048_chunks(ref hint);
    let remainder = deserialize_rsa2048_chunks(ref hint);
    assert(top_chunk_is_well_formed(quotient.w5), 'RSA:bad quotient top chunk');
    assert(top_chunk_is_well_formed(remainder.w5), 'RSA:bad remainder top chunk');
    assert(chunks_lt(remainder, modulus_chunks), 'RSA:remainder >= modulus');
    RSA2048ReductionWitness { quotient, remainder }
}

/// Verify an RSA-2048 signature assuming the message is already encoded.
///
/// Given public key n and signature data (s, m, 17 reduction witnesses),
/// verifies s^{65537} ≡ m (mod n) by:
///   1. Well-formedness: n > 1 odd, 0 ≤ s < n, 0 ≤ m < n, valid chunk bounds.
///   2. For each of 11 RNS channels: run the mega-circuit to verify all 17
///      reduction steps of the square-and-multiply chain.
///   3. Final equality: the last reduction remainder equals the expected message m.
#[inline(never)]
pub fn is_valid_rsa2048_signature_assuming_encoded_message(
    signature: @RSA2048SignatureWithHint, public_key: @RSA2048PublicKey,
) -> bool {
    let modulus_chunks = *public_key.modulus;
    let sig_chunks = *signature.signature.signature;
    let expected_message_chunks = *signature.signature.expected_message;

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

    // Deserialize and validate all 17 modular reduction witnesses (q_i, r_i)
    if reductions_hint.len() < RSA2048_REDUCTIONS_HINT_SERIALIZED_LEN {
        return false;
    }

    let w0 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);
    let w1 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);
    let w2 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);
    let w3 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);
    let w4 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);
    let w5 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);
    let w6 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);
    let w7 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);
    let w8 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);
    let w9 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);
    let w10 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);
    let w11 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);
    let w12 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);
    let w13 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);
    let w14 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);
    let w15 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);
    let w16 = deserialize_and_validate_witness(ref reductions_hint, modulus_chunks);

    if !reductions_hint.is_empty() {
        return false;
    }

    // For each RNS channel p_i, verify all 17 reductions via the fused circuit
    let mut steps = RSA_CHUNK_STEPS.span();
    for channel_modulus_limbs in RSA_CHANNEL_MODULI.span() {
        let step = *steps.pop_front().unwrap();
        let channel_modulus: CircuitModulus = (*channel_modulus_limbs).try_into().unwrap();
        let (d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15, d16) =
            run_RSA_FULL_VERIFICATION_circuit(
            modulus_chunks,
            sig_chunks,
            w0,
            w1,
            w2,
            w3,
            w4,
            w5,
            w6,
            w7,
            w8,
            w9,
            w10,
            w11,
            w12,
            w13,
            w14,
            w15,
            w16,
            step,
            channel_modulus,
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
    }

    // The final remainder r_{16} must equal the expected message m
    w16.remainder == expected_message_chunks
}

// PKCS#1 v1.5 SHA-256 constant chunks (W1..W5).
// These encode: 0x00||0x01||0xFF×202||0x00||DigestInfo[12:19]
// W0 depends on the hash and is built dynamically.

const PKCS1_SHA256_W5: u384 = u384 {
    limb0: 0xffffffffffffffffffffffff, limb1: 0x0001ffff, limb2: 0x0, limb3: 0x0,
};
const PKCS1_SHA256_W4: u384 = u384 {
    limb0: 0xffffffffffffffffffffffff,
    limb1: 0xffffffffffffffffffffffff,
    limb2: 0xffffffffffffffffffffffff,
    limb3: 0xffffffffffffffffffffffff,
};
const PKCS1_SHA256_W3: u384 = u384 {
    limb0: 0xffffffffffffffffffffffff,
    limb1: 0xffffffffffffffffffffffff,
    limb2: 0xffffffffffffffffffffffff,
    limb3: 0xffffffffffffffffffffffff,
};
const PKCS1_SHA256_W2: u384 = u384 {
    limb0: 0xffffffffffffffffffffffff,
    limb1: 0xffffffffffffffffffffffff,
    limb2: 0xffffffffffffffffffffffff,
    limb3: 0xffffffffffffffffffffffff,
};
const PKCS1_SHA256_W1: u384 = u384 {
    limb0: 0xffffffffffffffff00303130,
    limb1: 0xffffffffffffffffffffffff,
    limb2: 0xffffffffffffffffffffffff,
    limb3: 0xffffffffffffffffffffffff,
};
// W0.limb3 is the constant part: DigestInfo[3:15] encoded as 96 bits.
const PKCS1_SHA256_W0_LIMB3: u96 = 0x0d0609608648016503040201;

/// Build the PKCS#1 v1.5 SHA-256 encoded message from 8 hash words.
///
/// Layout (256 bytes big-endian):
///   0x00||0x01||PS(0xFF×202)||0x00||DigestInfo(19)||SHA-256(32)
///
/// W0 limb packing:
///   limb0 = hw5 * 2^64 + hw6 * 2^32 + hw7
///   limb1 = hw2 * 2^64 + hw3 * 2^32 + hw4
///   limb2 = 0x05000420 * 2^64 + hw0 * 2^32 + hw1
///   limb3 = 0x0d0609608648016503040201 (constant)
fn pkcs1_v1_5_sha256_encode(hash: [u32; 8]) -> RSA2048Chunks {
    let [hw0, hw1, hw2, hw3, hw4, hw5, hw6, hw7] = hash;

    let hw0: felt252 = hw0.into();
    let hw1: felt252 = hw1.into();
    let hw2: felt252 = hw2.into();
    let hw3: felt252 = hw3.into();
    let hw4: felt252 = hw4.into();
    let hw5: felt252 = hw5.into();
    let hw6: felt252 = hw6.into();
    let hw7: felt252 = hw7.into();

    let limb0: u96 = downcast(hw5 * 0x10000000000000000 + hw6 * 0x100000000 + hw7).unwrap();
    let limb1: u96 = downcast(hw2 * 0x10000000000000000 + hw3 * 0x100000000 + hw4).unwrap();
    let limb2: u96 = downcast(0x05000420 * 0x10000000000000000 + hw0 * 0x100000000 + hw1).unwrap();

    let w0 = u384 { limb0, limb1, limb2, limb3: PKCS1_SHA256_W0_LIMB3 };

    RSA2048Chunks {
        w0,
        w1: PKCS1_SHA256_W1,
        w2: PKCS1_SHA256_W2,
        w3: PKCS1_SHA256_W3,
        w4: PKCS1_SHA256_W4,
        w5: PKCS1_SHA256_W5,
    }
}

/// Verify an RSA-2048 signature against a raw message using SHA-256.
///
/// Computes SHA-256(message) on-chain, constructs the PKCS#1 v1.5 encoding,
/// asserts it matches the expected_message hint, then delegates to the
/// existing RNS-based RSA verification.
#[inline(never)]
pub fn is_valid_rsa2048_sha256_signature(
    signature: @RSA2048SignatureWithHint, public_key: @RSA2048PublicKey, message: @ByteArray,
) -> bool {
    // Compute SHA-256 of the message on-chain
    let hash: [u32; 8] = compute_sha256_byte_array(message);

    // Build the PKCS#1 v1.5 encoded message from the hash
    let encoded = pkcs1_v1_5_sha256_encode(hash);

    // Assert the hint matches the on-chain computation
    if encoded != *signature.signature.expected_message {
        return false;
    }

    // Delegate to the existing RSA verifier
    is_valid_rsa2048_signature_assuming_encoded_message(signature, public_key)
}
