use crate::algebra::g1point::G1Point;
use crate::definitions::{
    get_modulus_from_curve_id, BLS12381PrimeField, BN254PrimeField, CurveParamsProvider,
    GrumpkinPrimeField, SECP256K1PrimeField, SECP256R1PrimeField, ToWeierstrassCurve,
    X25519PrimeField,
};

use crate::calldata::msm_calldata::msm_calldata_builder;
use crate::io::{biguint_split, element_from_biguint, element_to_biguint};
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::unsigned_integer::element::U256;
use num_bigint::BigUint;
use num_traits::{One, Zero};
use sha2::{Digest, Sha256, Sha512};

use crate::definitions::CurveID;

// Fix the get_curve_order function to use FieldElement
pub fn get_curve_order(curve_id: CurveID) -> BigUint {
    match curve_id {
        CurveID::BLS12_381 => BLS12381PrimeField::get_curve_params().n,
        CurveID::BN254 => BN254PrimeField::get_curve_params().n,
        CurveID::SECP256K1 => SECP256K1PrimeField::get_curve_params().n,
        CurveID::SECP256R1 => SECP256R1PrimeField::get_curve_params().n,
        CurveID::X25519 => X25519PrimeField::get_curve_params().n,
        CurveID::GRUMPKIN => GrumpkinPrimeField::get_curve_params().n,
    }
}
/// Build calldata for Schnorr signature verification
///
/// Arguments:
/// * `rx` - x-coordinate of R point
/// * `s` - signature value
/// * `e` - challenge hash
/// * `px` - public key x-coordinate
/// * `py` - public key y-coordinate
/// * `prepend_public_key` - whether to prepend the public key to the calldata
/// * `curve_id` - curve identifier
pub fn schnorr_calldata_builder(
    rx: BigUint,
    s: BigUint,
    e: BigUint,
    px: BigUint,
    py: BigUint,
    prepend_public_key: bool,
    curve_id: usize,
) -> Result<Vec<BigUint>, String> {
    let mut cd = Vec::new();

    if prepend_public_key {
        cd.extend(biguint_split::<4, 96>(&px).map(BigUint::from));
        cd.extend(biguint_split::<4, 96>(&py).map(BigUint::from));
    }
    // Add base signature components
    cd.extend(biguint_split::<4, 96>(&rx).map(BigUint::from));
    cd.extend(biguint_split::<2, 128>(&s).map(BigUint::from));
    cd.extend(biguint_split::<2, 128>(&e).map(BigUint::from));

    // Calculate e_neg = -e mod n
    let curve_id = CurveID::try_from(curve_id)?;
    let n = get_curve_order(curve_id);
    let e_neg = n - e;

    // Add MSM calldata for sG + (-e)P
    let msm_cd = msm_calldata_builder(
        &[
            match curve_id {
                CurveID::BN254 => element_to_biguint(&BN254PrimeField::get_curve_params().g_x),
                CurveID::BLS12_381 => {
                    element_to_biguint(&BLS12381PrimeField::get_curve_params().g_x)
                }
                CurveID::SECP256K1 => {
                    element_to_biguint(&SECP256K1PrimeField::get_curve_params().g_x)
                }
                CurveID::SECP256R1 => {
                    element_to_biguint(&SECP256R1PrimeField::get_curve_params().g_x)
                }
                CurveID::X25519 => element_to_biguint(&X25519PrimeField::get_curve_params().g_x),
                CurveID::GRUMPKIN => {
                    element_to_biguint(&GrumpkinPrimeField::get_curve_params().g_x)
                }
            },
            match curve_id {
                CurveID::BN254 => element_to_biguint(&BN254PrimeField::get_curve_params().g_y),
                CurveID::BLS12_381 => {
                    element_to_biguint(&BLS12381PrimeField::get_curve_params().g_y)
                }
                CurveID::SECP256K1 => {
                    element_to_biguint(&SECP256K1PrimeField::get_curve_params().g_y)
                }
                CurveID::SECP256R1 => {
                    element_to_biguint(&SECP256R1PrimeField::get_curve_params().g_y)
                }
                CurveID::X25519 => element_to_biguint(&X25519PrimeField::get_curve_params().g_y),
                CurveID::GRUMPKIN => {
                    element_to_biguint(&GrumpkinPrimeField::get_curve_params().g_y)
                }
            },
            px,
            py,
        ],
        &[s, e_neg],
        curve_id as usize,
        false,
        true,
    )?;

    cd.extend(msm_cd);
    Ok(cd)
}

/// Build calldata for ECDSA signature verification
///
/// Arguments:
/// * `r` - signature r value
/// * `s` - signature s value
/// * `v` - recovery parameter (0 or 1)
/// * `px` - public key x-coordinate
/// * `py` - public key y-coordinate
/// * `z` - message hash
/// * `prepend_public_key` - whether to prepend the public key to the calldata
/// * `curve_id` - curve identifier
#[allow(clippy::too_many_arguments)]
pub fn ecdsa_calldata_builder(
    r: BigUint,
    s: BigUint,
    v: u8,
    px: BigUint,
    py: BigUint,
    z: BigUint,
    prepend_public_key: bool,
    curve_id: usize,
) -> Result<Vec<BigUint>, String> {
    let mut cd = Vec::new();

    if prepend_public_key {
        cd.extend(biguint_split::<4, 96>(&px).map(BigUint::from));
        cd.extend(biguint_split::<4, 96>(&py).map(BigUint::from));
    }
    // Add base signature components
    cd.extend(biguint_split::<4, 96>(&r).map(BigUint::from));
    cd.extend(biguint_split::<2, 128>(&s).map(BigUint::from));
    cd.push(BigUint::from(v));
    cd.extend(biguint_split::<2, 128>(&z).map(BigUint::from));

    // Calculate s_inv, u1, u2
    let curve_id = CurveID::try_from(curve_id)?;
    let n = get_curve_order(curve_id);

    let s_inv = s.modpow(&(n.clone() - BigUint::from(2u32)), &n);
    let u1 = (z * &s_inv) % &n;
    let u2 = (r * &s_inv) % &n;

    // Add MSM calldata for u1*G + u2*P
    let msm_cd = msm_calldata_builder(
        &[
            match curve_id {
                CurveID::BN254 => element_to_biguint(&BN254PrimeField::get_curve_params().g_x),
                CurveID::BLS12_381 => {
                    element_to_biguint(&BLS12381PrimeField::get_curve_params().g_x)
                }
                CurveID::SECP256K1 => {
                    element_to_biguint(&SECP256K1PrimeField::get_curve_params().g_x)
                }
                CurveID::SECP256R1 => {
                    element_to_biguint(&SECP256R1PrimeField::get_curve_params().g_x)
                }
                CurveID::X25519 => element_to_biguint(&X25519PrimeField::get_curve_params().g_x),
                CurveID::GRUMPKIN => {
                    element_to_biguint(&GrumpkinPrimeField::get_curve_params().g_x)
                }
            },
            match curve_id {
                CurveID::BN254 => element_to_biguint(&BN254PrimeField::get_curve_params().g_y),
                CurveID::BLS12_381 => {
                    element_to_biguint(&BLS12381PrimeField::get_curve_params().g_y)
                }
                CurveID::SECP256K1 => {
                    element_to_biguint(&SECP256K1PrimeField::get_curve_params().g_y)
                }
                CurveID::SECP256R1 => {
                    element_to_biguint(&SECP256R1PrimeField::get_curve_params().g_y)
                }
                CurveID::X25519 => element_to_biguint(&X25519PrimeField::get_curve_params().g_y),
                CurveID::GRUMPKIN => {
                    element_to_biguint(&GrumpkinPrimeField::get_curve_params().g_y)
                }
            },
            px,
            py,
        ],
        &[u1, u2],
        curve_id as usize,
        false,
        true,
    )?;

    cd.extend(msm_cd);
    Ok(cd)
}

pub fn eddsa_calldata_builder(
    ry_twisted: BigUint,
    s: BigUint,
    py_twisted: BigUint,
    msg: Vec<u8>,
    prepend_public_key: bool,
) -> Result<Vec<BigUint>, String> {
    let mut cd = Vec::new();

    let max_value = BigUint::from(1u64) << 256;
    if ry_twisted >= max_value {
        return Err("Invalid Ry value".to_string());
    }
    if py_twisted >= max_value {
        return Err("Invalid Py value".to_string());
    }
    if s >= max_value {
        return Err("Invalid s value".to_string());
    }

    if prepend_public_key {
        cd.extend(biguint_split::<2, 128>(&py_twisted).map(BigUint::from));
    }

    cd.extend(biguint_split::<2, 128>(&ry_twisted).map(BigUint::from));
    cd.extend(biguint_split::<2, 128>(&s).map(BigUint::from));
    cd.push(BigUint::from(msg.len() as u64));
    for byte in msg.clone() {
        cd.push(BigUint::from(byte as u64));
    }

    let mut hasher = Sha512::new();

    let ry_bytes = ry_twisted.to_bytes_le();
    let py_bytes = py_twisted.to_bytes_le();

    // Ensure the byte arrays are of length 32
    let ry_bytes_padded = if ry_bytes.len() < 32 {
        let mut padded = vec![0; 32];
        padded[..ry_bytes.len()].copy_from_slice(&ry_bytes);
        padded
    } else {
        ry_bytes
    };

    let py_bytes_padded = if py_bytes.len() < 32 {
        let mut padded = vec![0; 32];
        padded[..py_bytes.len()].copy_from_slice(&py_bytes);
        padded
    } else {
        py_bytes
    };

    hasher.update(&ry_bytes_padded);
    hasher.update(&py_bytes_padded);
    hasher.update(msg);

    let hash = hasher.finalize();

    let hash_biguint = BigUint::from_bytes_le(&hash);

    fn xrecover(y_twisted: FieldElement<X25519PrimeField>) -> FieldElement<X25519PrimeField> {
        let d_twisted = FieldElement::<X25519PrimeField>::from_hex(
            "52036CEE2B6FFE738CC740797779E89800700A4D4141D8AB75EB4DCA135978A3",
        )
        .unwrap();
        let i = FieldElement::<X25519PrimeField>::from_hex(
            "2b8324804fc1df0b2b4d00993dfbd7a72f431806ad2fe478c4ee1b274a0ea0b0",
        )
        .unwrap();
        let y_sq = y_twisted.square();
        let xx = ((y_sq - FieldElement::<X25519PrimeField>::one())
            / (d_twisted * y_sq + FieldElement::<X25519PrimeField>::one()))
        .unwrap();
        // exp =(p+3) // 8
        let exp = U256::from_hex("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe")
            .unwrap();
        let x = xx.pow(exp);
        let x = if x.square() != xx { x * i } else { x };
        let is_even = element_to_biguint(&x) % 2_u32 == BigUint::zero();
        if is_even {
            x
        } else {
            -x
        }
    }
    fn decode_point(
        compressed_point_le: BigUint,
    ) -> (
        FieldElement<X25519PrimeField>,
        FieldElement<X25519PrimeField>,
    ) {
        let two_pow_255: BigUint = BigUint::from(1u64) << 255;
        let sign_bit: BigUint = compressed_point_le.clone() / two_pow_255.clone();

        let y_twisted = compressed_point_le % two_pow_255;

        let y_twisted = element_from_biguint(&y_twisted);
        let x_twisted = xrecover(y_twisted);

        let x_twisted = if element_to_biguint(&x_twisted.clone()) % 2_u32 != sign_bit {
            -x_twisted
        } else {
            x_twisted
        };

        (x_twisted, y_twisted)
    }

    let (r_point_x_twisted, r_point_y_twisted) = decode_point(ry_twisted);
    let (p_point_x_twisted, p_point_y_twisted) = decode_point(py_twisted);

    let (r_point_x_weierstrass, r_point_y_weierstrass) =
        X25519PrimeField::to_weirstrass(r_point_x_twisted, r_point_y_twisted);
    let (p_point_x_weierstrass, p_point_y_weierstrass) =
        X25519PrimeField::to_weirstrass(p_point_x_twisted, p_point_y_twisted);

    let _p_pt =
        G1Point::new(p_point_x_weierstrass, p_point_y_weierstrass, false).expect("Invalid point P");
    let _r_pt =
        G1Point::new(r_point_x_weierstrass, r_point_y_weierstrass, false).expect("Invalid point R");

    let gx = element_to_biguint(&X25519PrimeField::get_curve_params().g_x);
    let modulus = get_modulus_from_curve_id(CurveID::X25519);
    let neg_gy = modulus - element_to_biguint(&X25519PrimeField::get_curve_params().g_y);

    let h = hash_biguint % get_curve_order(CurveID::X25519);

    let values = &[
        gx,
        neg_gy,
        element_to_biguint(&p_point_x_weierstrass),
        element_to_biguint(&p_point_y_weierstrass),
    ];
    let scalars = &[s, h];

    let msm_cd = msm_calldata_builder(values, scalars, CurveID::X25519 as usize, false, true)?;

    cd.extend(msm_cd);

    cd.extend(biguint_split::<2, 128>(&element_to_biguint(&r_point_x_twisted)).map(BigUint::from));
    cd.extend(biguint_split::<2, 128>(&element_to_biguint(&p_point_x_twisted)).map(BigUint::from));

    Ok(cd)
}

/// PKCS#1 v1.5 SHA-256 DigestInfo prefix (DER-encoded AlgorithmIdentifier + NULL param).
/// RFC 8017, Section 9.2, Note 1.
const PKCS1_SHA256_DIGEST_INFO_PREFIX: [u8; 19] = [
    0x30, 0x31, 0x30, 0x0d, 0x06, 0x09, 0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01, 0x05,
    0x00, 0x04, 0x20,
];

/// Encode a SHA-256 hash as a PKCS#1 v1.5 padded integer (RFC 8017, Section 9.2).
///
/// Constructs: 0x00 || 0x01 || PS(0xFF × 202) || 0x00 || DigestInfo || H
fn pkcs1_v1_5_encode_sha256(message_hash: &[u8; 32]) -> BigUint {
    let mut encoded = vec![0x00, 0x01];
    encoded.extend(std::iter::repeat_n(0xff, 202));
    encoded.push(0x00);
    encoded.extend_from_slice(&PKCS1_SHA256_DIGEST_INFO_PREFIX);
    encoded.extend_from_slice(message_hash);
    BigUint::from_bytes_be(&encoded)
}

/// Serialize a Cairo `ByteArray` as felt252 calldata.
///
/// Layout: [num_full_words, word_0, ..., word_{n-1}, pending_word, pending_word_len]
/// Each full word is 31 bytes. The pending word is 0-30 bytes.
fn serialize_byte_array(data: &[u8]) -> Vec<BigUint> {
    let full_word_count = data.len() / 31;
    let pending_len = data.len() % 31;

    let mut cd = Vec::new();
    cd.push(BigUint::from(full_word_count as u64));

    for i in 0..full_word_count {
        let start = i * 31;
        let word = BigUint::from_bytes_be(&data[start..start + 31]);
        cd.push(word);
    }

    if pending_len > 0 {
        let pending = BigUint::from_bytes_be(&data[full_word_count * 31..]);
        cd.push(pending);
    } else {
        cd.push(BigUint::zero());
    }
    cd.push(BigUint::from(pending_len as u64));

    cd
}

/// Build calldata for RSA-2048 SHA-256 signature verification.
///
/// Computes SHA-256(message), builds PKCS#1 v1.5 encoding, generates
/// the RSA reduction witnesses, and appends the ByteArray-serialized message.
///
/// Arguments:
/// * `signature` - RSA signature s in [0, modulus)
/// * `message` - Raw message bytes
/// * `modulus` - RSA-2048 modulus n
/// * `prepend_public_key` - Whether to prepend n to the calldata
pub fn rsa_2048_sha256_calldata_builder(
    signature: BigUint,
    message: &[u8],
    modulus: BigUint,
    prepend_public_key: bool,
) -> Result<Vec<BigUint>, String> {
    let hash: [u8; 32] = Sha256::digest(message)
        .as_slice()
        .try_into()
        .map_err(|_| "SHA-256 digest failed")?;

    let expected_message = pkcs1_v1_5_encode_sha256(&hash);

    let mut cd =
        rsa_2048_calldata_builder(signature, expected_message, modulus, prepend_public_key)?;

    cd.extend(serialize_byte_array(message));

    Ok(cd)
}

/// Serialize a 2048-bit integer to 24 calldata elements (96-bit words).
///
/// Layout: 6 chunks of 4 words each. The first 5 chunks hold 384 bits,
/// the last chunk holds 128 bits (top 2 words are zero).
fn serialize_rsa2048_integer(x: &BigUint) -> Vec<BigUint> {
    biguint_split::<24, 96>(x)
        .iter()
        .map(|&w| BigUint::from(w))
        .collect()
}

/// Build calldata for RSA-2048 signature verification.
///
/// Computes s^{65537} mod n via square-and-multiply, generating 17
/// reduction witnesses (quotient, remainder) that certify each step.
///
/// Arguments:
/// * `signature` - RSA signature s in [0, modulus)
/// * `expected_message` - Expected result m = s^{65537} mod n
/// * `modulus` - RSA-2048 modulus n
/// * `prepend_public_key` - Whether to prepend n to the calldata
pub fn rsa_2048_calldata_builder(
    signature: BigUint,
    expected_message: BigUint,
    modulus: BigUint,
    prepend_public_key: bool,
) -> Result<Vec<BigUint>, String> {
    if modulus.bits() > 2048 || modulus <= BigUint::one() {
        return Err("modulus must be a positive integer fitting in 2048 bits".into());
    }
    if signature >= modulus {
        return Err("signature must be less than modulus".into());
    }
    if expected_message >= modulus {
        return Err("expected_message must be less than modulus".into());
    }

    // Verify s^{65537} ≡ m (mod n)
    let e = BigUint::from(65537u32);
    if signature.modpow(&e, &modulus) != expected_message {
        return Err("signature^65537 mod modulus does not equal expected_message".into());
    }

    // Square-and-multiply for e = 65537 = 2^16 + 1:
    // 16 squarings followed by 1 multiplication = 17 reductions.
    let mut acc = signature.clone();
    let mut witnesses: Vec<(BigUint, BigUint)> = Vec::with_capacity(17);

    for _ in 0..16 {
        let product = &acc * &acc;
        let quotient = &product / &modulus;
        let remainder = &product % &modulus;
        witnesses.push((quotient, remainder.clone()));
        acc = remainder;
    }

    let product = &acc * &signature;
    let quotient = &product / &modulus;
    let remainder = &product % &modulus;
    witnesses.push((quotient, remainder));

    // Serialize to calldata
    let mut cd = Vec::new();
    if prepend_public_key {
        cd.extend(serialize_rsa2048_integer(&modulus));
    }
    cd.extend(serialize_rsa2048_integer(&signature));
    cd.extend(serialize_rsa2048_integer(&expected_message));

    for (q, r) in &witnesses {
        cd.extend(serialize_rsa2048_integer(q));
        cd.extend(serialize_rsa2048_integer(r));
    }

    Ok(cd)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_pkcs1_v1_5_encode_sha256_structure() {
        let hash = [0u8; 32];
        let encoded = pkcs1_v1_5_encode_sha256(&hash);
        let encoded_bytes = encoded.to_bytes_be();

        // Pad to 256 bytes (leading 0x00 is dropped by BigUint)
        let mut padded = vec![0u8; 256 - encoded_bytes.len()];
        padded.extend_from_slice(&encoded_bytes);

        assert_eq!(padded[0], 0x00);
        assert_eq!(padded[1], 0x01);
        assert!(padded[2..204].iter().all(|&b| b == 0xff));
        assert_eq!(padded[204], 0x00);
        assert_eq!(&padded[205..224], &PKCS1_SHA256_DIGEST_INFO_PREFIX);
        assert_eq!(&padded[224..256], &hash);
    }

    #[test]
    fn test_serialize_byte_array_empty() {
        let cd = serialize_byte_array(b"");
        // [0 full words, pending_word=0, pending_word_len=0]
        assert_eq!(cd.len(), 3);
        assert_eq!(cd[0], BigUint::zero());
        assert_eq!(cd[1], BigUint::zero());
        assert_eq!(cd[2], BigUint::zero());
    }

    #[test]
    fn test_serialize_byte_array_short() {
        let msg = b"hello";
        let cd = serialize_byte_array(msg);
        // 5 bytes < 31, so 0 full words, pending = "hello", pending_len = 5
        assert_eq!(cd.len(), 3);
        assert_eq!(cd[0], BigUint::zero()); // 0 full words
        assert_eq!(cd[1], BigUint::from_bytes_be(msg)); // pending word
        assert_eq!(cd[2], BigUint::from(5u32)); // pending len
    }

    #[test]
    fn test_serialize_byte_array_exact_word() {
        let msg = vec![0xABu8; 31]; // exactly one full word
        let cd = serialize_byte_array(&msg);
        // 1 full word, pending = 0, pending_len = 0
        assert_eq!(cd.len(), 4);
        assert_eq!(cd[0], BigUint::one()); // 1 full word
        assert_eq!(cd[1], BigUint::from_bytes_be(&msg)); // word_0
        assert_eq!(cd[2], BigUint::zero()); // pending = 0
        assert_eq!(cd[3], BigUint::zero()); // pending_len = 0
    }

    #[test]
    fn test_serialize_byte_array_multi() {
        let msg = vec![0xCDu8; 65]; // 2 full words (62 bytes) + 3 pending
        let cd = serialize_byte_array(&msg);
        assert_eq!(cd.len(), 5); // num_full + word0 + word1 + pending + pending_len
        assert_eq!(cd[0], BigUint::from(2u32));
        assert_eq!(cd[4], BigUint::from(3u32)); // pending_len
    }

    #[test]
    fn test_rsa_2048_sha256_calldata_pkcs_encoding() {
        let hash: [u8; 32] = Sha256::digest(b"hello garaga").into();
        let expected_message = pkcs1_v1_5_encode_sha256(&hash);
        let em_bytes = expected_message.to_bytes_be();
        let mut padded = vec![0u8; 256 - em_bytes.len()];
        padded.extend_from_slice(&em_bytes);
        assert_eq!(&padded[224..256], &hash);
    }
}
