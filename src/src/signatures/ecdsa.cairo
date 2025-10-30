use garaga::basic_field_ops::{inv_mod_p, is_even_u384, mul_mod_p, reduce_mod_p};
use garaga::definitions::{
    G1Point, Zero, deserialize_u384, get_G, get_curve_order_modulus, get_n, serialize_u384, u384,
};
use garaga::ec_ops::{G1PointTrait, msm_g1};
use garaga::utils::u384_eq_zero;

/// An ECDSA signature with message hash.
///
/// # Fields
/// * `rx`: `u384` - The r component (R.x mod n) of the signature.
/// * `s`: `u256` - The s component of the signature.
/// * `v`: `bool` - The parity of R.y (false if R.y is even, true if odd).
/// * `z`: `u256` - The message hash.
#[derive(Drop, Debug, PartialEq)]
pub struct ECDSASignature {
    rx: u384,
    s: u256,
    v: bool,
    z: u256,
}

pub impl SerdeECDSASignature of Serde<ECDSASignature> {
    fn serialize(self: @ECDSASignature, ref output: Array<felt252>) {
        serialize_u384(self.rx, ref output);
        Serde::<u256>::serialize(self.s, ref output);
        Serde::<bool>::serialize(self.v, ref output);
        Serde::<u256>::serialize(self.z, ref output);
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<ECDSASignature> {
        let rx = deserialize_u384(ref serialized);
        let s = Serde::<u256>::deserialize(ref serialized).unwrap();
        let v = Serde::<bool>::deserialize(ref serialized).unwrap();
        let z = Serde::<u256>::deserialize(ref serialized).unwrap();
        return Option::Some(ECDSASignature { rx, s, v, z });
    }
}

/// An ECDSA signature bundled with computation hints required for Cairo verification.
///
/// # Fields
/// * `signature`: `ECDSASignature` - The core signature data.
/// * `msm_hint`: `Span<felt252>` - Hint for multi-scalar multiplication computation.
#[derive(Drop, Debug, PartialEq, Serde)]
pub struct ECDSASignatureWithHint {
    signature: ECDSASignature,
    msm_hint: Span<felt252>,
}

/// Verifies an ECDSA signature with associated hints, assuming the message hash is correct.
///
/// # Important Assumption
/// **This function assumes that the message hash `z` has been correctly computed from the message
/// by the caller.** It does not compute or verify the hash derivation itself. The caller is
/// responsible for ensuring that `z = H(message)` (or the appropriate hash function for their
/// protocol) before calling this function.
///
/// # Arguments
/// * `signature`: `ECDSASignatureWithHint` - The signature and verification data bundle containing:
///     - rx: The r component (R.x mod n) of the signature
///     - s: The s component of the signature
///     - v: The parity of R.y
///     - z: The message hash (assumed to be correctly computed by the caller)
///     - msm_hint: Hint for multi-scalar multiplication
/// * `public_key`: `G1Point` - The public key to verify against.
/// * `curve_id`: `usize` - The curve identifier
///
/// # Algorithm
/// The ECDSA signature verification checks if the signature (r,s) is valid for a given message hash
/// z:
/// 1. Verify that r is non-zero and s ∈ {1, ..., n-1}
/// 2. Verify that the public key P is on the curve
/// 3. Compute w = s⁻¹ mod n
/// 4. Compute u₁ = zw mod n and u₂ = rw mod n
/// 5. Compute R' = u₁G + u₂P
/// 6. Verify that R'.x mod n equals r (implicitly checks r < n) and R'.y's parity does NOT match v
/// /!\ Note: Behaviour for cofactor > 1 only tested on curves with cofactor 1
/// (BN254, SECP256K1/R1, GRUMPKIN).
pub fn is_valid_ecdsa_signature_assuming_hash(
    signature: ECDSASignatureWithHint, public_key: G1Point, curve_id: usize,
) -> bool {
    let ECDSASignatureWithHint { signature, msm_hint } = signature;
    let ECDSASignature { rx, s, v, z } = signature;

    let n: u256 = get_n(curve_id);
    let modulus = get_curve_order_modulus(curve_id);

    // Check that r is non-zero and s is in range {1, ..., n-1}
    // Note: r < n is implicitly checked later when comparing r_prime.x mod n == r
    if u384_eq_zero(rx) || s >= n || s == 0 {
        return false;
    }

    // Verify public key is on curve
    if !public_key.is_on_curve_excluding_infinity(curve_id) {
        return false;
    }

    // Compute s⁻¹ mod n using the inv_mod_p function
    let s_u384: u384 = s.into();
    let s_inv = inv_mod_p(s_u384, modulus);

    // Compute u₁ = z·s⁻¹ mod n and u₂ = r·s⁻¹ mod n
    let u1: u256 = mul_mod_p(z.into(), s_inv, modulus).try_into().unwrap();
    let u2: u256 = mul_mod_p(rx, s_inv, modulus).try_into().unwrap();

    // Compute R' = u₁G + u₂P using MSM
    let points = array![get_G(curve_id), public_key].span();
    let scalars = array![u1, u2].span();
    let R_prime = msm_g1(points, scalars, curve_id, msm_hint);

    // Check R'.x mod n equals r and R'.y parity matches v
    // Note : if cofactor is 1, no need to reduce r_prime.x mod n
    let ry_prime_parity = is_even_u384(R_prime.y);
    let r_prime_x_mod_n = reduce_mod_p(R_prime.x, modulus);

    if R_prime.is_zero() || r_prime_x_mod_n != rx || ry_prime_parity == v {
        return false;
    }

    true
}
