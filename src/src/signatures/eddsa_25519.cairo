use core::circuit::{
    AddInputResultTrait, AddMod, CircuitElement, CircuitInput, CircuitInputs, CircuitModulus,
    CircuitOutputsTrait, EvalCircuitTrait, MulMod, RangeCheck96, circuit_add, circuit_inverse,
    circuit_mul, circuit_sub, u384, u96,
};
use garaga::basic_field_ops::{
    add_mod_p, inv_mod_p, is_even_u384, mul_mod_p, neg_mod_p, u384_mod_2, u512_mod_p,
};
use garaga::core::circuit::AddInputResultTrait2;
use garaga::definitions::{
    Zero, deserialize_u384, get_ED25519_modulus, get_G, get_curve_order_modulus, get_modulus, get_n,
    serialize_u384, u288,
};
use garaga::ec_ops::{DerivePointFromXHint, G1Point, G1PointTrait, MSMHint, msm_g1};
use garaga::hashes::sha_512::{Word64, _sha512};
use garaga::utils::u384_eq_zero;

const X22519_u256: u256 = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed;

const D_TWISTED: u384 = u384 {
    limb0: 0x4141d8ab75eb4dca135978a3,
    limb1: 0x8cc740797779e89800700a4d,
    limb2: 0x52036cee2b6ffe73,
    limb3: 0x0,
};
const A_TWISTED: u384 = u384 {
    limb0: 0xffffffffffffffffffffffec,
    limb1: 0xffffffffffffffffffffffff,
    limb2: 0x7fffffffffffffff,
    limb3: 0x0,
};


/// An EDDSA signature with associated public key and message hash.
#[derive(Drop, Debug, PartialEq)]
struct EDDSASignature {
    Ry_twisted_le: u256, // Compressed form of Ry in little endian (compliant with RFC 8032)
    s: u256,
    rx_sign: bool, // 0 (false) if Ry is even, 1 (true) if odd
    Px: u256,
    Py: u256,
}

#[derive(Drop, Debug, PartialEq)]
struct EDDSaSignatureWithHint {
    signature: EDDSASignature,
    msm_hint: MSMHint,
    msm_derive_hint: DerivePointFromXHint,
    sqrt_hint: u288,
}

const POW_2_32_u64: NonZero<u64> = 0x100000000;
const POW_2_127_u128: NonZero<u128> = 0x80000000000000000000000000000000;

#[inline]
fn u256_byte_reverse(word: u256) -> u256 {
    u256 {
        low: core::integer::u128_byte_reverse(word.high),
        high: core::integer::u128_byte_reverse(word.low),
    }
}

fn decompress_edwards_pt_from_y_compressed_le_into_weirstrass_point(
    y_twisted_le: u256, sqrt_hint: u256,
) -> Option<G1Point> {
    let y_be_compressed = u256_byte_reverse(y_twisted_le);
    let (bit_sign, y_be_high): (u128, u128) = DivRem::div_rem(y_be_compressed.high, POW_2_127_u128);
    let modulus = get_ED25519_modulus();

    let sqrt_hint_384: u384 = sqrt_hint.into();

    let x_384: u384 = match sqrt_hint.low % 2 == bit_sign % 2 {
        true => sqrt_hint_384,
        false => neg_mod_p(sqrt_hint_384, modulus),
    };
    let y_be = u256 { low: y_be_compressed.low, high: y_be_high };
    let y_be_u384: u384 = y_be.into();

    let y = CircuitElement::<CircuitInput<0>> {};
    let f1 = CircuitElement::<CircuitInput<1>> {};
    let d = CircuitElement::<CircuitInput<2>> {};
    let sqrt_x = CircuitElement::<CircuitInput<3>> {};

    let y_sq = circuit_mul(y, y);
    let num = circuit_sub(y_sq, f1);
    let d_mul_y_sq = circuit_mul(d, y_sq);
    let den = circuit_add(d_mul_y_sq, f1);

    let inv_den = circuit_inverse(den);
    let x_sq = circuit_mul(num, inv_den);

    let sqrt_x_sq = circuit_mul(sqrt_x, sqrt_x);
    let check = circuit_sub(sqrt_x_sq, x_sq);

    let outputs = (check,)
        .new_inputs()
        .next_2(y_be_u384)
        .next_2([1, 0, 0, 0])
        .next_2([0x4141d8ab75eb4dca135978a3, 0x8cc740797779e89800700a4d, 0x52036cee2b6ffe73, 0x0])
        .next_2(x_384)
        .done_2()
        .eval(modulus)
        .unwrap();

    let sqrt_check = outputs.get_output(check);

    if sqrt_check.is_non_zero() || sqrt_hint >= X22519_u256 {
        return None;
    }

    return Some(to_weierstrass(x_384, y_be_u384));
}

// def to_weierstrass(self, x_twisted, y_twisted):
// a = self.a_twisted
// d = self.d_twisted
// return (
//     (5 * a + a * y_twisted - 5 * d * y_twisted - d)
//     * pow(12 - 12 * y_twisted, -1, self.p)
//     % self.p,
//     (a + a * y_twisted - d * y_twisted - d)
//     * pow(4 * x_twisted - 4 * x_twisted * y_twisted, -1, self.p)
//     % self.p,
// )

// a_twisted = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEC
// d_twisted = 0x52036CEE2B6FFE738CC740797779E89800700A4D4141D8AB75EB4DCA135978A3

pub fn to_weierstrass(x_twisted: u384, y_twisted: u384) -> G1Point {
    let x_t = CircuitElement::<CircuitInput<0>> {};
    let y_t = CircuitElement::<CircuitInput<1>> {};
    let a = CircuitElement::<CircuitInput<2>> {};
    let d = CircuitElement::<CircuitInput<3>> {};
    let four = CircuitElement::<CircuitInput<4>> {};
    let five = CircuitElement::<CircuitInput<5>> {};
    let twelve = CircuitElement::<CircuitInput<6>> {};
    let modulus = get_ED25519_modulus();

    let five_a = circuit_mul(five, a);
    let a_y_twisted = circuit_mul(a, y_t);
    let d_y_twisted = circuit_mul(d, y_t);
    let five_d_y_twisted = circuit_mul(five, d_y_twisted);

    let num_x = circuit_sub(circuit_add(five_a, a_y_twisted), circuit_sub(five_d_y_twisted, d));
    let den_x = circuit_sub(twelve, circuit_mul(twelve, y_t));
    let _x = circuit_mul(num_x, circuit_inverse(den_x));

    let num_y = circuit_sub(circuit_add(a, a_y_twisted), circuit_sub(d_y_twisted, d));
    let four_xt = circuit_mul(four, x_t);
    let den_y = circuit_sub(four_xt, circuit_mul(four_xt, y_t));
    let _y = circuit_mul(num_y, circuit_inverse(den_y));

    let outputs = (_x, _y)
        .new_inputs()
        .next_2(x_twisted)
        .next_2(y_twisted)
        .next_2(A_TWISTED)
        .next_2(D_TWISTED)
        .next_2([4, 0, 0, 0])
        .next_2([5, 0, 0, 0])
        .next_2([12, 0, 0, 0])
        .done_2()
        .eval(modulus)
        .unwrap();

    let x = outputs.get_output(_x);
    let y = outputs.get_output(_y);

    G1Point { x: x, y: y }
}


pub fn eddsa_25519_verify(signature: EDDSaSignatureWithHint, msg: Array<u8>) -> bool {
    let EDDSaSignatureWithHint { signature, msm_hint, msm_derive_hint, sqrt_hint } = signature;
    let EDDSASignature { Ry_twisted_le, s, rx_sign, Px, Py } = signature;

    let mut data: Array<u8> = array![];

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
