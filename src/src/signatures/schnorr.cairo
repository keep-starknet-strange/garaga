use core::circuit::{CircuitModulus, u96};
use garaga::basic_field_ops::neg_mod_p;
use garaga::definitions::{Zero, get_n, get_modulus, get_G};
use garaga::ec_ops::{DerivePointFromXHint, G1Point, G1PointTrait, MSMHint, msm_g1, u384};

/// A Schnorr signature with associated public key and challenge.
///
/// # Fields
/// * `rx`: `u256` - The x-coordinate of the R point from the signature.
/// * `s`: `u256` - The s-coordinate of the signature.
/// * `e`: `u256` - The challenge hash.
/// * `px`: `u256` - The x-coordinate of the public key.
/// * `py`: `u256` - The y-coordinate of the public key.
#[derive(Drop, Debug, PartialEq, Serde)]
struct SchnorrSignature {
    rx: u256,
    s: u256,
    e: u256,
    px: u256,
    py: u256,
}

/// A Schnorr signature bundled with computation hints required for Cairo verification.
///
/// # Fields
/// * `signature`: `SchnorrSignature` - The core signature data.
/// * `msm_hint`: `MSMHint` - Hint for multi-scalar multiplication computation.
/// * `msm_derive_hint`: `DerivePointFromXHint` - Hint for deriving the full point from
/// x-coordinate (part of MSM algo).
#[derive(Drop, Debug, PartialEq, Serde)]
struct SchnorrSignatureWithHint {
    signature: SchnorrSignature,
    msm_hint: MSMHint,
    msm_derive_hint: DerivePointFromXHint,
}

/// Verifies a Schnorr signature with associated hints for a hash challenge.
///
/// # Arguments
/// * `signature`: `SchnorrSignatureWithHint` - The signature and verification data bundle
/// containing:
///     - rx: The x-coordinate of the R point
///     - s: The s-coordinate of the signature
///     - e: The challenge hash
///     - px, py: The public key coordinates
///     - msm_hint: Hint for multi-scalar multiplication
///     - msm_derive_hint: Hint for point derivation
/// * `curve_id`: `usize` - The id of the curve. (0 for BN254, 1 for BLS12_381, 2 for SECP256K1, 3
/// for SECP256R1, 4 for ED25519, 5 for GRUMPKIN)
///
/// # Algorithm
/// The Schnorr signature verification checks if the signature (R, s) is valid for a message hash e
/// and public key P:
/// 1. Verify that all inputs (rx, s, e) are non-zero and less than the curve order n
/// 2. Verify that the public key P is on the curve and has even y-coordinate (BIP340 requirement)
/// 3. Compute sG - eP where G is the generator point (using MSM)
/// 4. Verify that the result equals R (matching x-coordinate and even y-coordinate)
/// 5. The signature is valid if all checks pass
///
/// This implements the verification equation: sG - eP = R
/// Which proves the signer knew the private key x where P = xG
/// Returns false if the signature is invalid.
pub fn is_valid_schnorr_signature(signature: SchnorrSignatureWithHint, curve_id: usize) -> bool {
    let SchnorrSignatureWithHint { signature, msm_hint, msm_derive_hint } = signature;
    let SchnorrSignature { rx, s, e, px, py } = signature;
    // println!("rx: {rx}");
    // println!("s: {s}");
    // println!("e: {e}");
    // println!("px: {px}");
    // println!("py: {py}");

    let n = get_n(curve_id);

    if rx >= n || rx == 0 || s >= n || s == 0 || e >= n || e == 0 || py.low % 2 != 0 {
        return false;
    }

    let pk_point = G1Point { x: px.into(), y: py.into() };
    // See
    // https://github.com/bitcoin/bips/blob/58ffd93812ff25e87d53d1f202fbb389fdfb85bb/bip-0340/reference.py#L71
    let pk_on_curve = pk_point.is_on_curve(curve_id);

    if pk_on_curve == false {
        return false;
    }

    let modulus = get_modulus(curve_id);
    let e_neg: u256 = neg_mod_p(e.into(), modulus).try_into().unwrap();
    let rx: u384 = rx.into();

    let points = array![get_G(curve_id), pk_point].span();
    let scalars = array![s, e_neg].span();

    let res = msm_g1(Option::None, msm_hint, msm_derive_hint, points, scalars, curve_id);

    let ry_l0_f252: felt252 = res.y.limb0.into();
    let ry_l0_u128: u128 = ry_l0_f252.try_into().unwrap();

    if res.x.is_zero() || res.x != rx || res.y.is_zero() || (ry_l0_u128 % 2) != 0 {
        return false;
    }

    true
}

