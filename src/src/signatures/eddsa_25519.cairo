use core::circuit::{
    AddInputResultTrait, AddMod, CircuitElement, CircuitInput, CircuitInputs, CircuitModulus,
    CircuitOutputsTrait, EvalCircuitTrait, MulMod, RangeCheck96, circuit_add, circuit_inverse,
    circuit_mul, circuit_sub, u384, u96,
};
use garaga::basic_field_ops::{add_mod_p, inv_mod_p, is_even_u384, mul_mod_p, neg_mod_p, u512_mod_p};
use garaga::core::circuit::AddInputResultTrait2;
use garaga::definitions::{
    Zero, deserialize_u384, get_ED25519_modulus, get_G, get_curve_order_modulus, get_modulus, get_n,
    serialize_u384, u288,
};
use garaga::ec_ops::{DerivePointFromXHint, G1Point, G1PointTrait, MSMHint, ec_safe_add, msm_g1};
use garaga::hashes::sha_512::{Word64, _sha512};
use garaga::utils::u384_eq_zero;

const POW_2_32_u64: NonZero<u64> = 0x100000000;
const POW_2_127_u128: NonZero<u128> = 0x80000000000000000000000000000000;
const POW_2_8_u128: NonZero<u128> = 0x100;

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

const G_neg: G1Point = G1Point {
    x: u384 {
        limb0: 0xd617c9aca55c89b025aef35,
        limb1: 0xf00b8f02f1c20618a9c13fdf,
        limb2: 0x2a78dd0fd02c0339,
        limb3: 0x0,
    },
    y: u384 {
        limb0: 0x7f8ece9a6487cf0c09d3e2d9,
        limb1: 0x41b7c45a9c867cdc30902f9e,
        limb2: 0x5639bb5a38e25dd1,
        limb3: 0x0,
    },
};


#[derive(Drop, Debug, PartialEq, Serde)]
pub struct EdDSASignature {
    Ry_twisted_le: u256, // Compressed form of Ry in little endian (compliant with RFC 8032)
    s: u256,
    Py_twisted_le: u256, // Compressed form of Public Key y in little endian (compliant with RFC 8032)
    msg: Array<u8>,
}

#[derive(Drop, Debug, PartialEq, Serde)]
pub struct EdDSASignatureWithHint {
    signature: EdDSASignature,
    msm_hint: MSMHint,
    msm_derive_hint: DerivePointFromXHint,
    sqrt_Rx_hint: u256,
    sqrt_Px_hint: u256,
}


pub fn is_valid_eddsa_signature(signature: EdDSASignatureWithHint) -> bool {
    let EdDSASignatureWithHint {
        signature, msm_hint, msm_derive_hint, sqrt_Rx_hint, sqrt_Px_hint,
    } = signature;
    let EdDSASignature { Ry_twisted_le, s, Py_twisted_le, msg } = signature;

    let Ry_twisted_be = u256_byte_reverse(Ry_twisted_le);
    println!("Ry_twisted_be: 0x{:x}", Ry_twisted_be);
    println!("Ry_twisted_le: 0x{:x}", Ry_twisted_le);

    println!("sqrt_Rx_hint: 0x{:x}", sqrt_Rx_hint);
    println!("sqrt_Px_hint: 0x{:x}", sqrt_Px_hint);

    let R_opt: Option<G1Point> = decompress_edwards_pt_from_y_compressed_le_into_weirstrass_point(
        Ry_twisted_le, sqrt_Rx_hint,
    );
    if R_opt.is_none() {
        println!("R_opt is none");
        return false;
    }
    let R: G1Point = R_opt.unwrap();
    println!("R: {:?}", R);

    let Py_twisted_be = u256_byte_reverse(Py_twisted_le);

    let P_opt: Option<G1Point> = decompress_edwards_pt_from_y_compressed_le_into_weirstrass_point(
        Py_twisted_le, sqrt_Px_hint,
    );

    if P_opt.is_none() {
        return false;
    }
    let P: G1Point = P_opt.unwrap();
    println!("P: {:?}", P);

    if !R.is_on_curve(4) || !P.is_on_curve(4) {
        println!("R or P is not on curve");
        return false;
    }

    let mut data: Array<u8> = array![];

    // Hash(Ry + Py + msg)
    append_u256_le_to_u8_be_array(Ry_twisted_be, ref data);
    append_u256_le_to_u8_be_array(Py_twisted_be, ref data);
    for byte in msg.span() {
        data.append(*byte);
    }

    let [h0, h1, h2, h3, h4, h5, h6, h7] = _sha512(data);

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

    // Calculate h = hash(R + pubKey + msg) mod q
    // Calculate P1 = s * G
    // Calculate P2 = R + h * pubKey
    // Return s*G == R + h * pubKey
    // <=> s*(-G) +  h * pubKey + R == 0

    let points: Span<G1Point> = array![G_neg, P].span();
    let scalars: Span<u256> = array![s, h_mod_p.try_into().unwrap()].span();

    let msm_result = msm_g1(None, msm_hint, msm_derive_hint, points, scalars, 4);

    return ec_safe_add(msm_result, R, 4).is_infinity();
}


pub fn decompress_edwards_pt_from_y_compressed_le_into_weirstrass_point(
    y_twisted_be_compressed: u256, sqrt_hint: u256,
) -> Option<G1Point> {
    let y_be_compressed = y_twisted_be_compressed;
    let (bit_sign, y_be_high): (u128, u128) = DivRem::div_rem(y_be_compressed.high, POW_2_127_u128);
    let modulus = get_ED25519_modulus();

    println!("sqrt_hint: 0x{:x}", sqrt_hint);
    let sqrt_hint_384: u384 = sqrt_hint.into();

    let x_384: u384 = match sqrt_hint.low % 2 == bit_sign % 2 {
        true => sqrt_hint_384,
        false => neg_mod_p(sqrt_hint_384, modulus),
    };

    let x_recovered: u256 = x_384.try_into().unwrap();
    println!("x_recovered: 0x{:x}", x_recovered);

    let y_be = u256 { low: y_be_compressed.low, high: y_be_high };
    println!("y_be: 0x{:x}", y_be);
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

    if sqrt_check.is_non_zero() {
        println!("sqrt_check is non_zero");
        return None;
    }

    if sqrt_hint >= X22519_u256 {
        println!("sqrt_hint is >= X22519_u256");
        return None;
    }

    return Some(to_weierstrass(x_384, y_be_u384));
}

pub fn to_weierstrass(x_twisted: u384, y_twisted: u384) -> G1Point {
    println!("TO WEIERSTRASS");
    let x_u256: u256 = x_twisted.try_into().unwrap();
    let y_u256: u256 = y_twisted.try_into().unwrap();
    println!("x_twisted: 0x{:x}", x_u256);
    println!("y_twisted: 0x{:x}", y_u256);
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

    let num_x = circuit_sub(circuit_add(five_a, a_y_twisted), circuit_add(five_d_y_twisted, d));
    let den_x = circuit_sub(twelve, circuit_mul(twelve, y_t));
    let _x = circuit_mul(num_x, circuit_inverse(den_x));

    let num_y = circuit_sub(circuit_add(a, a_y_twisted), circuit_add(d_y_twisted, d));
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


#[inline]
pub fn u256_byte_reverse(word: u256) -> u256 {
    u256 {
        low: core::integer::u128_byte_reverse(word.high),
        high: core::integer::u128_byte_reverse(word.low),
    }
}


// Append u256 in little endian to u8 array but in big endian
fn append_u256_le_to_u8_be_array(x_le: u256, ref arr: Array<u8>) {
    let mut high = x_le.high;
    let mut low = x_le.low;

    let mut i: felt252 = 0;
    while (i != 16) {
        let (temp_remaining, byte) = DivRem::div_rem(low, POW_2_8_u128);
        arr.append(byte.try_into().unwrap());
        low = temp_remaining;
        i += 1;
    }

    let mut j: felt252 = 0;
    while (j != 16) {
        let (temp_remaining, byte) = DivRem::div_rem(high, POW_2_8_u128);
        arr.append(byte.try_into().unwrap());
        high = temp_remaining;
        j += 1;
    }
}
