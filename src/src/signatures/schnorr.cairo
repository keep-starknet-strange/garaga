use garaga::basic_field_ops::{is_even_u384, neg_mod_p};
use garaga::definitions::{
    G1Point, Zero, deserialize_u384, get_G, get_curve_order_modulus, get_n, serialize_u384, u384,
};
use garaga::ec_ops::{G1PointTrait, msm_g1};
use garaga::utils::u384_eq_zero;

/// A Schnorr signature.
///
/// # Fields
/// * `rx`: `u384` - The x-coordinate of the R point from the signature.
/// * `s`: `u256` - The s component of the signature.
/// * `e`: `u256` - The challenge hash.
#[derive(Drop, Debug, PartialEq)]
pub struct SchnorrSignature {
    rx: u384,
    s: u256,
    e: u256,
}

pub impl SerdeSchnorrSignature of Serde<SchnorrSignature> {
    fn serialize(self: @SchnorrSignature, ref output: Array<felt252>) {
        serialize_u384(self.rx, ref output);
        Serde::<u256>::serialize(self.s, ref output);
        Serde::<u256>::serialize(self.e, ref output);
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<SchnorrSignature> {
        let rx = deserialize_u384(ref serialized);
        let s = Serde::<u256>::deserialize(ref serialized).unwrap();
        let e = Serde::<u256>::deserialize(ref serialized).unwrap();
        return Option::Some(SchnorrSignature { rx: rx, s: s, e: e });
    }
}

/// A Schnorr signature bundled with computation hints required for Cairo verification.
///
/// # Fields
/// * `signature`: `SchnorrSignature` - The core signature data.
/// * `msm_hint`: `Span<felt252>` - Hint for multi-scalar multiplication computation.
#[derive(Drop, Debug, PartialEq, Serde)]
pub struct SchnorrSignatureWithHint {
    signature: SchnorrSignature,
    msm_hint: Span<felt252>,
}

/// Verifies a Schnorr signature with associated hints, assuming the hash challenge is correct.
///
/// # Important Assumption
/// **This function assumes that the hash `e` has been correctly derived from `x_R` and the message
/// by the caller.** It does not compute or verify the hash derivation itself. The caller is
/// responsible for ensuring that `e = H(x_R || message)` (or the appropriate hash construction for
/// their protocol) before calling this function.
///
/// # Arguments
/// * `signature`: `SchnorrSignatureWithHint` - The signature and verification data bundle
/// containing:
///     - rx: The x-coordinate of the R point
///     - s: The s component of the signature
///     - e: The challenge hash (assumed to be correctly computed by the caller)
///     - msm_hint: Hint for multi-scalar multiplication
/// * `public_key`: `G1Point` - The public key to verify against.
/// * `curve_id`: `usize` - The id of the curve. (0 for BN254, 1 for BLS12_381, 2 for SECP256K1, 3
/// for SECP256R1, 4 for ED25519, 5 for GRUMPKIN)
///
/// # Algorithm
/// The Schnorr signature verification checks if the signature (R, s) is valid for a given challenge
/// hash e and public key P:
/// 1. Verify that all inputs (rx, s, e) are non-zero and less than the curve order n
/// 2. Verify that the public key P is on the curve and has even y-coordinate (BIP340 requirement,
/// see
/// https://github.com/bitcoin/bips/blob/58ffd93812ff25e87d53d1f202fbb389fdfb85bb/bip-0340/reference.py#L71)
/// 3. Compute sG - eP where G is the generator point (using MSM)
/// 4. Verify that the result equals R (matching x-coordinate and even y-coordinate)
/// 5. The signature is valid if all checks pass
///
/// This implements the verification equation: sG - eP = R
/// Which proves the signer knew the private key x where P = xG, given that e was correctly derived.
/// Returns false if the signature is invalid.
pub fn is_valid_schnorr_signature_assuming_hash(
    signature: SchnorrSignatureWithHint, public_key: G1Point, curve_id: usize,
) -> bool {
    let SchnorrSignatureWithHint { signature, msm_hint } = signature;
    let SchnorrSignature { rx, s, e } = signature;

    let n: u256 = get_n(curve_id);

    if u384_eq_zero(rx)
        || s >= n
        || s == 0
        || e >= n
        || e == 0
        || is_even_u384(public_key.y) == false {
        return false;
    }

    let pk_on_curve = public_key.is_on_curve_excluding_infinity(curve_id);

    if pk_on_curve == false {
        return false;
    }

    let n_modulus = get_curve_order_modulus(curve_id);

    let e_neg: u256 = neg_mod_p(e.into(), n_modulus).try_into().unwrap();

    let points = array![get_G(curve_id), public_key].span();
    let scalars = array![s, e_neg].span();

    let res = msm_g1(points, scalars, curve_id, msm_hint);

    let ry_l0_f252: felt252 = res.y.limb0.into();
    let ry_l0_u128: u128 = ry_l0_f252.try_into().unwrap();

    if res.is_zero() || res.x != rx || (ry_l0_u128 % 2) != 0 {
        return false;
    }

    true
}

