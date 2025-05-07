use core::circuit::{CircuitModulus, u96};
use garaga::basic_field_ops::{add_mod_p, inv_mod_p, is_even_u384, mul_mod_p, neg_mod_p};
use garaga::core::circuit::IntoCircuitInputValue;
use garaga::definitions::{
    Zero, deserialize_u384, get_G, get_curve_order_modulus, get_modulus, get_n, serialize_u384,
};
use garaga::ec_ops::{G1Point, G1PointTrait, msm_g1, u384};
use garaga::utils::hashing::HashFeltTranscriptTrait;
use garaga::utils::u384_eq_zero;

/// An ECDSA signature with associated public key and message hash.
///
/// # Fields
/// * `rx`: `u384` - The r component (R.x mod n) of the signature.
/// * `s`: `u256` - The s component of the signature.
/// * `v`: `u256` - The recovery parameter (0 if R.y is even, 1 if odd).
/// * `px`: `u384` - The x-coordinate of the public key.
/// * `py`: `u384` - The y-coordinate of the public key.
/// * `z`: `u256` - The message hash.
#[derive(Drop, Debug, PartialEq)]
struct ECDSASignature {
    rx: u384,
    s: u256,
    v: bool,
    px: u384,
    py: u384,
    z: u256,
}

impl SerdeECDSASignature of Serde<ECDSASignature> {
    fn serialize(self: @ECDSASignature, ref output: Array<felt252>) {
        serialize_u384(self.rx, ref output);
        Serde::<u256>::serialize(self.s, ref output);
        Serde::<bool>::serialize(self.v, ref output);
        serialize_u384(self.px, ref output);
        serialize_u384(self.py, ref output);
        Serde::<u256>::serialize(self.z, ref output);
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<ECDSASignature> {
        let rx = deserialize_u384(ref serialized);
        let s = Serde::<u256>::deserialize(ref serialized).unwrap();
        let v = Serde::<bool>::deserialize(ref serialized).unwrap();
        let px = deserialize_u384(ref serialized);
        let py = deserialize_u384(ref serialized);
        let z = Serde::<u256>::deserialize(ref serialized).unwrap();
        return Option::Some(ECDSASignature { rx, s, v, px, py, z });
    }
}

/// An ECDSA signature bundled with computation hints required for Cairo verification.
///
/// # Fields
/// * `signature`: `ECDSASignature` - The core signature data.
/// * `msm_hint`: `MSMHint` - Hint for multi-scalar multiplication computation.
/// * `msm_derive_hint`: `DerivePointFromXHint` - Hint for deriving point from x-coordinate.
#[derive(Drop, Debug, PartialEq, Serde)]
struct ECDSASignatureWithHint {
    signature: ECDSASignature,
    msm_hint: Span<felt252>,
}

/// Verifies an ECDSA signature with associated hints.
///
/// # Arguments
/// * `signature`: `ECDSASignatureWithHint` - The signature and verification data bundle
/// * `curve_id`: `usize` - The curve identifier
///
/// # Algorithm
/// The ECDSA signature verification checks if the signature (r,s) is valid for message hash z:
/// 1. Verify that r, s are non-zero and less than the curve order n
/// 2. Verify that the public key P is on the curve
/// 3. Compute w = s⁻¹ mod n
/// 4. Compute u₁ = zw mod n and u₂ = rw mod n
/// 5. Compute R' = u₁G + u₂P
/// 6. Verify that R'.x mod n equals r and R'.y's parity matches v
/// /!\ Behaviour unclear for cofactor > 1.
/// (BN254, SECP256K1/R1, GRUMPKIN) A.
pub fn is_valid_ecdsa_signature(signature: ECDSASignatureWithHint, curve_id: usize) -> bool {
    let ECDSASignatureWithHint { signature, msm_hint } = signature;
    let ECDSASignature { rx, s, v, px, py, z } = signature;

    let n: u256 = get_n(curve_id);
    let modulus = get_curve_order_modulus(curve_id);

    // Check that r, s are non-zero and less than n
    if u384_eq_zero(rx) || s >= n || s == 0 || z >= n || z == 0 {
        return false;
    }

    // Verify public key is on curve
    let pk_point = G1Point { x: px, y: py };
    if !pk_point.is_on_curve(curve_id) {
        return false;
    }

    // Compute s⁻¹ mod n using the inv_mod_p function
    let s_u384: u384 = s.into();
    let s_inv = inv_mod_p(s_u384, modulus);

    // Compute u₁ = z·s⁻¹ mod n and u₂ = r·s⁻¹ mod n
    let u1: u256 = mul_mod_p(z.into(), s_inv, modulus).try_into().unwrap();
    let u2: u256 = mul_mod_p(rx, s_inv, modulus).try_into().unwrap();

    // Compute R' = u₁G + u₂P using MSM
    let points = array![get_G(curve_id), pk_point].span();
    let scalars = array![u1, u2].span();
    let R_prime = msm_g1(points, scalars, curve_id, msm_hint);

    // Check R'.x mod n equals r and R'.y parity matches v
    // Note : if cofactor is 1, no need to reduce r_prime.x mod n
    let ry_prime_parity = is_even_u384(R_prime.y);
    let r_prime_x_mod_n = add_mod_p(
        R_prime.x, u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }, modulus,
    );

    if R_prime.x.is_zero() || r_prime_x_mod_n != rx || R_prime.y.is_zero() || ry_prime_parity == v {
        return false;
    }

    true
}
