use core::circuit::{CircuitModulus, u96};
use garaga::basic_field_ops::{add_mod_p, inv_mod_p, is_even_u384, mul_mod_p, neg_mod_p};
use garaga::definitions::{
    Zero, deserialize_u384, get_G, get_curve_order_modulus, get_modulus, get_n, serialize_u384,
};
use garaga::ec_ops::{DerivePointFromXHint, G1Point, G1PointTrait, MSMHint, msm_g1, u384};
use garaga::utils::u384_eq_zero;
use garaga::hashes::sha_512::{_sha512, Word64};

/// An EDDSA signature with associated public key and message hash.
///
/// # Fields
/// * `R`: `G1Point` - The point R of the signature.
/// * `s`: `u256` - The s component of the signature.
/// * `v`: `u256` - The recovery parameter (0 if R.y is even, 1 if odd).
/// * `P`: `G1Point` - The public key.
#[derive(Drop, Debug, PartialEq)]
struct EDDSASignature {
    R: G1Point,
    s: u256,
    P: G1Point,
}


pub fn eddsa_25519_verify(signature: EDDSASignature, msg: Array<u8>) -> bool {
    let h:Array<Word64> = _sha512(msg);

    return true;
}
