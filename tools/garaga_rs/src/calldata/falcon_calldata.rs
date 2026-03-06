//! Falcon-512 calldata builder for Cairo verification.
//!
//! Uses falcon-rs for decompression, NTT, and hint generation.
//! Packing to felt252 (BigUint) is done here to avoid lambdaworks version conflicts.

use falcon_rs::encoding::decompress;
use falcon_rs::falcon::{Signature, VerifyingKey, PUBLIC_KEY_LEN};
use falcon_rs::hints::generate_mul_hint;
use falcon_rs::ntt::ntt;
use falcon_rs::{N, Q};
use num_bigint::BigUint;

const VALS_PER_U128: usize = 9;
const VALS_PER_FELT: usize = 18;
pub const PACKED_SLOTS: usize = 29;

// =============================================================================
// Base-Q packing (BigUint version, matching Cairo/falcon-rs exactly)
// =============================================================================

/// Horner-encode up to 9 u16 values into a u128.
/// Encoding: v0 + Q*(v1 + Q*(v2 + ... + Q*v8))
fn horner_pack(values: &[u16]) -> u128 {
    let mut acc: u128 = 0;
    for &v in values.iter().rev() {
        acc = acc * Q as u128 + v as u128;
    }
    acc
}

/// Extract `count` base-Q digits from a u128.
fn base_q_extract(mut value: u128, count: usize, out: &mut Vec<u16>) {
    for _ in 0..count {
        out.push((value % Q as u128) as u16);
        value /= Q as u128;
    }
}

/// Pack 512 u16 Zq values into 29 BigUint (felt252) values.
pub fn pack_falcon_public_key(coeffs: &[u16]) -> Vec<BigUint> {
    assert_eq!(coeffs.len(), 512);
    let two_128 = BigUint::from(1u64) << 128;
    coeffs
        .chunks(VALS_PER_FELT)
        .map(|chunk| {
            let lo = horner_pack(&chunk[..chunk.len().min(VALS_PER_U128)]);
            let hi = if chunk.len() > VALS_PER_U128 {
                horner_pack(&chunk[VALS_PER_U128..])
            } else {
                0u128
            };
            BigUint::from(lo) + BigUint::from(hi) * &two_128
        })
        .collect()
}

/// Unpack 29 BigUint (felt252) values back to 512 u16 Zq values.
pub fn unpack_falcon_public_key(packed: &[BigUint]) -> Vec<u16> {
    let mut result = Vec::with_capacity(512);
    let mut remaining = 512usize;
    let two_128 = BigUint::from(1u64) << 128;
    let mask = &two_128 - BigUint::from(1u64);

    for felt in packed {
        let low: u128 = (felt & &mask).try_into().unwrap_or(0u128);
        let high: u128 = (felt >> 128u32).try_into().unwrap_or(0u128);

        let lo_count = remaining.min(VALS_PER_U128);
        base_q_extract(low, lo_count, &mut result);
        remaining -= lo_count;

        if remaining > 0 {
            let hi_count = remaining.min(VALS_PER_U128);
            base_q_extract(high, hi_count, &mut result);
            remaining -= hi_count;
        }
    }
    result
}

// =============================================================================
// Calldata builder
// =============================================================================

/// Build calldata for Falcon-512 signature verification in Cairo.
///
/// Takes raw byte-encoded public key and signature, plus a felt252 message,
/// and produces the calldata array matching Cairo's Serde layout:
///
/// ```text
/// [optional: pk_ntt_packed (29 felt252)]
/// s1_packed        (29 felt252)
/// salt_len         (1 felt252)
/// salt             (salt_len felt252)
/// mul_hint_packed  (29 felt252)
/// message_len      (1 felt252)
/// message          (message_len felt252)
/// ```
pub fn falcon_calldata_builder(
    vk_bytes: &[u8],
    signature_bytes: &[u8],
    message: &[BigUint],
    prepend_public_key: bool,
) -> Result<Vec<BigUint>, String> {
    // 1. Parse and validate public key
    if vk_bytes.len() != PUBLIC_KEY_LEN {
        return Err(format!(
            "Invalid public key length: expected {}, got {}",
            PUBLIC_KEY_LEN,
            vk_bytes.len()
        ));
    }
    let vk = VerifyingKey::from_bytes(vk_bytes.try_into().unwrap())
        .map_err(|e| format!("Invalid public key: {e}"))?;

    // 2. Compute NTT of public key
    let h = vk.h();
    let h_ntt = ntt(h.as_ref());
    let pk_ntt_u16: Vec<u16> = h_ntt.iter().map(|&v| v.rem_euclid(Q) as u16).collect();

    // 3. Parse signature and decompress s1
    let sig =
        Signature::from_bytes(signature_bytes).map_err(|e| format!("Invalid signature: {e}"))?;

    // Decompress s1 from the signature
    let sig_bytes = sig.to_bytes();
    // Signature format: [header(1), salt(40), s1_enc(rest)]
    let s1_enc = &sig_bytes[1 + 40..];
    let s1_i32 =
        decompress(s1_enc, N).ok_or_else(|| "Failed to decompress signature s1".to_string())?;
    let s1_u16: Vec<u16> = s1_i32.iter().map(|&v| v.rem_euclid(Q) as u16).collect();

    // 4. Extract salt as felt252 values
    let salt = sig.salt();
    // Pack salt bytes into felt252 (31 bytes per felt, big-endian)
    let salt_felts: Vec<BigUint> = salt
        .chunks(31)
        .map(|chunk| BigUint::from_bytes_be(chunk))
        .collect();

    // 5. Generate mul_hint = INTT(NTT(s1) * pk_ntt)
    let mul_hint = generate_mul_hint(&s1_u16, &pk_ntt_u16);

    // 6. Pack polynomials into felt252
    let packed_pk = pack_falcon_public_key(&pk_ntt_u16);
    let packed_s1 = pack_falcon_public_key(&s1_u16);
    let packed_hint = pack_falcon_public_key(&mul_hint);

    // 7. Assemble calldata
    let mut cd = Vec::new();

    if prepend_public_key {
        cd.extend(packed_pk);
    }

    // s1 packed (29 felt252)
    cd.extend(packed_s1);

    // salt as Array<felt252>: length prefix + data
    cd.push(BigUint::from(salt_felts.len()));
    cd.extend(salt_felts);

    // mul_hint packed (29 felt252)
    cd.extend(packed_hint);

    // message as Array<felt252>: length prefix + data
    cd.push(BigUint::from(message.len()));
    cd.extend_from_slice(message);

    Ok(cd)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_packing_roundtrip() {
        let values: Vec<u16> = (0..512).map(|i| (i * 37 % 12289) as u16).collect();
        let packed = pack_falcon_public_key(&values);
        assert_eq!(packed.len(), PACKED_SLOTS);
        let unpacked = unpack_falcon_public_key(&packed);
        assert_eq!(unpacked, values);
    }

    #[test]
    fn test_packing_zeros() {
        let zeros = vec![0u16; 512];
        assert_eq!(
            unpack_falcon_public_key(&pack_falcon_public_key(&zeros)),
            zeros
        );
    }

    #[test]
    fn test_packing_max_values() {
        let maxes = vec![12288u16; 512];
        assert_eq!(
            unpack_falcon_public_key(&pack_falcon_public_key(&maxes)),
            maxes
        );
    }

    #[test]
    fn test_packing_matches_falcon_rs() {
        // Verify our BigUint packing matches falcon-rs's Felt packing.
        // Compare via limbs to avoid cross-crate lambdaworks version conflicts.
        let values: Vec<u16> = (0..512).map(|i| (i * 37 % 12289) as u16).collect();
        let our_packed = pack_falcon_public_key(&values);
        let falcon_packed = falcon_rs::packing::pack_public_key(&values);

        for (ours, theirs) in our_packed.iter().zip(falcon_packed.iter()) {
            let limbs = theirs.representative().limbs;
            // UnsignedInteger<4> has 4 u64 limbs in big-endian order
            let mut bytes = Vec::with_capacity(32);
            for limb in &limbs {
                bytes.extend_from_slice(&limb.to_be_bytes());
            }
            let their_biguint = BigUint::from_bytes_be(&bytes);
            assert_eq!(ours, &their_biguint, "Packing mismatch");
        }
    }

    #[test]
    fn test_calldata_builder_basic() {
        use falcon_rs::falcon::Falcon;
        use falcon_rs::hash_to_point::Shake256Hash;

        // Generate a keypair
        let seed = [42u8; 56];
        let (sk, vk) = Falcon::<Shake256Hash>::keygen_with_seed(&seed);

        // Sign a message
        let salt = [0u8; 40];
        let msg = b"test message";
        let sig = Falcon::<Shake256Hash>::sign_with_salt(&sk, msg, &salt);

        // Build calldata
        let message_felts = vec![BigUint::from_bytes_be(msg)];
        let result = falcon_calldata_builder(&vk.to_bytes(), &sig.to_bytes(), &message_felts, true);

        assert!(
            result.is_ok(),
            "calldata builder failed: {:?}",
            result.err()
        );
        let cd = result.unwrap();

        // With prepend_pk: 29 (pk) + 29 (s1) + 1 (salt_len) + 2 (salt) + 29 (hint) + 1 (msg_len) + 1 (msg) = 92
        // Salt is 40 bytes = 2 chunks of 31 bytes
        assert!(cd.len() > 60, "calldata too short: {}", cd.len());
    }

    #[test]
    fn test_calldata_builder_roundtrip_verify() {
        use falcon_rs::falcon::Falcon;
        use falcon_rs::hash_to_point::Shake256Hash;

        // Generate keypair with fixed seed for reproducibility
        let seed = [42u8; 56];
        let (sk, vk) = Falcon::<Shake256Hash>::keygen_with_seed(&seed);

        // Sign a message using SHAKE256
        let msg = b"hello garaga falcon";
        let salt = [1u8; 40];
        let sig = Falcon::<Shake256Hash>::sign_with_salt(&sk, msg, &salt);

        // Verify original signature
        assert!(
            Falcon::<Shake256Hash>::verify(&vk, msg, &sig).unwrap(),
            "Original signature must verify"
        );

        // Build calldata with prepend_public_key=true
        let message_felts = vec![BigUint::from_bytes_be(msg)];
        let cd_with_pk =
            falcon_calldata_builder(&vk.to_bytes(), &sig.to_bytes(), &message_felts, true)
                .expect("calldata builder with pk failed");

        // Build calldata with prepend_public_key=false
        let cd_without_pk =
            falcon_calldata_builder(&vk.to_bytes(), &sig.to_bytes(), &message_felts, false)
                .expect("calldata builder without pk failed");

        // The difference should be exactly 29 (packed pk)
        assert_eq!(cd_with_pk.len(), cd_without_pk.len() + PACKED_SLOTS);

        // Verify the packed pk portion matches standalone packing
        let h_ntt = ntt(vk.h().as_ref());
        let pk_u16: Vec<u16> = h_ntt.iter().map(|&v| v.rem_euclid(Q) as u16).collect();
        let standalone_packed = pack_falcon_public_key(&pk_u16);
        assert_eq!(&cd_with_pk[..PACKED_SLOTS], &standalone_packed[..]);
    }

    #[test]
    fn test_calldata_builder_rejects_bad_pk() {
        let bad_pk = vec![0u8; 10];
        let sig = vec![0u8; 666];
        let msg = vec![BigUint::from(1u64)];
        let result = falcon_calldata_builder(&bad_pk, &sig, &msg, false);
        assert!(result.is_err());
    }
}
