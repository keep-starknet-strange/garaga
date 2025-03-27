use core::circuit::{CircuitModulus, u96};
use garaga::basic_field_ops::{add_mod_p, inv_mod_p, is_even_u384, mul_mod_p, neg_mod_p, u512_mod_p};
use garaga::definitions::{
    Zero, deserialize_u384, get_ED25519_modulus, get_G, get_curve_order_modulus, get_modulus, get_n,
    serialize_u384,
};
use garaga::ec_ops::{DerivePointFromXHint, G1Point, G1PointTrait, MSMHint, msm_g1, u384};
use garaga::hashes::sha_512::{Word64, _sha512};
use garaga::utils::u384_eq_zero;

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

const POW_2_32_u64: NonZero<u64> = 0x100000000;

pub fn eddsa_25519_verify(signature: EDDSASignature, msg: Array<u8>) -> bool {
    let mut h: Span<Word64> = _sha512(msg).span();
    let [h0, h1, h2, h3, h4, h5, h6, h7] = (*h.multi_pop_front::<8>().unwrap()).unbox();

    let (ah_0, ah_1) = DivRem::div_rem(h0.data, POW_2_32_u64);
    let (ah_2, ah_3) = DivRem::div_rem(h1.data, POW_2_32_u64);
    let (ah_4, ah_5) = DivRem::div_rem(h2.data, POW_2_32_u64);
    let (ah_6, ah_7) = DivRem::div_rem(h3.data, POW_2_32_u64);

    let (al_0, al_1) = DivRem::div_rem(h4.data, POW_2_32_u64);
    let (al_2, al_3) = DivRem::div_rem(h5.data, POW_2_32_u64);
    let (al_4, al_5) = DivRem::div_rem(h6.data, POW_2_32_u64);
    let (al_6, al_7) = DivRem::div_rem(h7.data, POW_2_32_u64);

    let order_modulus = get_curve_order_modulus(4);

    let h_mod_p = u512_mod_p(
        [
            ah_0.try_into().unwrap(), ah_1.try_into().unwrap(), ah_2.try_into().unwrap(),
            ah_3.try_into().unwrap(), ah_4.try_into().unwrap(), ah_5.try_into().unwrap(),
            ah_6.try_into().unwrap(), ah_7.try_into().unwrap(),
        ],
        [
            al_0.try_into().unwrap(), al_1.try_into().unwrap(), al_2.try_into().unwrap(),
            al_3.try_into().unwrap(), al_4.try_into().unwrap(), al_5.try_into().unwrap(),
            al_6.try_into().unwrap(), al_7.try_into().unwrap(),
        ],
        order_modulus,
    );

    return true;
}
