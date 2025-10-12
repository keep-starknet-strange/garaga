use core::circuit::{
    CircuitElement, CircuitInput, CircuitInputs, CircuitOutputsTrait, EvalCircuitTrait, circuit_add,
    circuit_inverse, circuit_mul, circuit_sub, u384,
};
use core::integer::u128_byte_reverse;
use garaga::basic_field_ops::{neg_mod_p, u512_mod_p};
use garaga::circuits::ec;
use garaga::core::circuit::{AddInputResultTrait2, u288IntoCircuitInputValue};
use garaga::definitions::{
    G1Point, Zero, get_ED25519_modulus, get_a, get_curve_order_modulus, get_modulus, u288Serde,
};
use garaga::ec_ops::{G1PointTrait, ec_safe_add, msm_fake_glv};
use garaga::hashes::sha_512::_sha512;

const POW_2_32_u64: NonZero<u64> = 0x100000000;
const POW_2_127_u128: NonZero<u128> = 0x80000000000000000000000000000000;
const POW_2_8_u128: NonZero<u128> = 0x100;

const POW_2_64_u128: u128 = 0x10000000000000000;
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


#[derive(Copy, Drop, Debug, PartialEq, Serde)]
pub struct EdDSASignature {
    Ry_twisted: u256, // Compressed form of Ry (converted to integer from little endian bytes)
    s: u256,
    msg: Span<u8>,
}

#[derive(Copy, Drop, Debug, PartialEq, Serde)]
pub struct EdDSASignatureWithHint {
    signature: EdDSASignature,
    msm_hint: Span<felt252>,
    sqrt_Rx_hint: u256,
    sqrt_Px_hint: u256,
}


/// Verifies an Ed25519 signature according to RFC 8032.
///
/// # Security
/// This implementation follows RFC 8032 Section 5.1.7 by explicitly rejecting
/// small-order points. Both the signature point R and public key A are tested
/// to ensure [8]P ≠ 𝒪, preventing key-compromise and signature-malleability
/// attacks that could arise from small-order components.
///
/// # Parameters
/// - `signature`: The signature with hints for point decompression and MSM
/// - `Py_twisted`: Compressed form of Public Key y-coordinate (converted to integer from little
/// endian bytes)
///
/// # Returns
/// - `true` if the signature is valid
/// - `false` if the signature is invalid or contains small-order points
pub fn is_valid_eddsa_signature(signature: EdDSASignatureWithHint, Py_twisted: u256) -> bool {
    let EdDSASignatureWithHint { signature, mut msm_hint, sqrt_Rx_hint, sqrt_Px_hint } = signature;
    let EdDSASignature { Ry_twisted, s, msg } = signature;

    let R_opt: Option<G1Point> = decompress_edwards_pt_from_y_compressed_le_into_weirstrass_point(
        Ry_twisted, sqrt_Rx_hint,
    );
    let P_opt: Option<G1Point> = decompress_edwards_pt_from_y_compressed_le_into_weirstrass_point(
        Py_twisted, sqrt_Px_hint,
    );

    if P_opt.is_none() || R_opt.is_none() {
        return false;
    }

    let P: G1Point = P_opt.unwrap();
    let R: G1Point = R_opt.unwrap();

    // Verify points lie on the curve (but may be outside the prime-order subgroup)
    if !R.is_on_curve_excluding_infinity(4) || !P.is_on_curve_excluding_infinity(4) {
        return false;
    }

    // Reject small-order points explicitly to prevent key-compromise and
    // signature-malleability attacks. Check [8]P = 𝒪 for both R and the public key.
    if is_small_order_point(R, 4) || is_small_order_point(P, 4) {
        return false;
    }

    let mut data: Array<u8> = array![];

    // Hash(Ry + Py + msg)
    append_u256_le_to_u8_be_array(Ry_twisted, ref data);
    append_u256_le_to_u8_be_array(Py_twisted, ref data);
    for byte in msg {
        data.append(*byte);
    }

    // println!("preimage: {:?}", data);

    let hash = _sha512(data);
    let [h0, h1, h2, h3, h4, h5, h6, h7] = hash;

    // println!("hash_bytes: {:?}", hash_bytes);

    let high_high_128: u128 = h1.data.into() + h0.data.into() * POW_2_64_u128;
    let high_low_128: u128 = h3.data.into() + h2.data.into() * POW_2_64_u128;
    let low_high_128: u128 = h5.data.into() + h4.data.into() * POW_2_64_u128;
    let low_low_128: u128 = h7.data.into() + h6.data.into() * POW_2_64_u128;

    let high_256 = u256 { low: high_low_128, high: high_high_128 };
    let low_256 = u256 { low: low_low_128, high: low_high_128 };

    // [hh0, ..., hh15] [hl0, ..., hl15] [lh0, ..., lh15] [ll0, ..., ll15]

    let hh_le = u128_byte_reverse(low_256.low);
    let hl_le = u128_byte_reverse(low_256.high);
    let lh_le = u128_byte_reverse(high_256.low);
    let ll_le = u128_byte_reverse(high_256.high);

    // u512 from hash bytes (little endian)
    // [ll15, ..., ll0] [lh15, ..., lh0] [hl15, ..., hl0] [hh15, ..., hh0]

    let h_le: u384 = u256 { low: hl_le, high: hh_le }.into();
    let l_le: u384 = u256 { low: ll_le, high: lh_le }.into();

    // println!("h_le: {:?}", h_le);
    // println!("l_le: {:?}", l_le);

    let order_modulus = get_curve_order_modulus(4);

    let h_mod_p = u512_mod_p(h_le, l_le, order_modulus);

    // Calculate h = hash(R + pubKey + msg) mod q
    // Calculate P1 = s * G
    // Calculate P2 = R + h * pubKey
    // Return s*G == R + h * pubKey
    // <=> s*(-G) +  h * pubKey + R == 0

    let points: Span<G1Point> = array![G_neg, P].span();
    let scalars: Span<u256> = array![s, h_mod_p.try_into().unwrap()].span();

    let msm_result = msm_fake_glv(points, scalars, 4, ref msm_hint);

    return ec_safe_add(msm_result, R, 4).is_infinity();
}

/// Checks if a point has small order (order dividing the cofactor 8).
///
/// For Ed25519 the full curve has order 8×ℓ where ℓ is the prime-order subgroup.
/// Small-order points (orders 1, 2, 4, 8) can enable attacks, so they must be rejected.
///
/// # Implementation
/// Tests for small-order by checking if [2^k]P = 𝒪 for k = 1, 2, or 3 (i.e., orders 2, 4, or 8).
/// Uses the fact that on Weierstrass curves, a point equals its negation (hence has order 2)
/// iff its y-coordinate is zero. Returns true if P has order dividing 8.
///
/// # Parameters
/// - `p`: The point to test
/// - `curve_index`: Must be 4 (Ed25519)
///
/// # Returns
/// - `true` if P has small order (should be rejected)
/// - `false` if P is in the large subgroup (acceptable)
fn is_small_order_point(p: G1Point, curve_index: usize) -> bool {
    // Compute [8]P = [2^3]P by three doublings

    if p.y.is_zero() {
        // => P=-P => 2P = 0
        return true;
    }

    let modulus = get_modulus(curve_index);
    let a = get_a(curve_index);
    let (p2) = ec::run_DOUBLE_EC_POINT_circuit(p, a, modulus);

    if p2.y.is_zero() {
        // => 2P=-2P => 4P = 0
        return true;
    }

    let (p4) = ec::run_DOUBLE_EC_POINT_circuit(p2, a, modulus);

    if p4.y.is_zero() {
        // => 4P=-4P => 8P = 0
        return true;
    }

    // If [8]P = 𝒪 then P has order dividing 8 (small-order point)
    return false;
}


pub fn decompress_edwards_pt_from_y_compressed_le_into_weirstrass_point(
    y_twisted_compressed: u256, sqrt_hint: u256,
) -> Option<G1Point> {
    let (bit_sign, y_high): (u128, u128) = DivRem::div_rem(
        y_twisted_compressed.high, POW_2_127_u128,
    );
    let modulus = get_ED25519_modulus();

    // println!("sqrt_hint: 0x{:x}", sqrt_hint);
    let sqrt_hint_384: u384 = sqrt_hint.into();

    let x_384: u384 = match sqrt_hint.low % 2 == bit_sign % 2 {
        true => sqrt_hint_384,
        false => neg_mod_p(sqrt_hint_384, modulus),
    };

    let y = u256 { low: y_twisted_compressed.low, high: y_high };
    let y_u384: u384 = y.into();

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
        .next_2(y_u384)
        .next_2([1, 0, 0, 0])
        .next_2([0x4141d8ab75eb4dca135978a3, 0x8cc740797779e89800700a4d, 0x52036cee2b6ffe73, 0x0])
        .next_2(x_384)
        .done_2()
        .eval(modulus)
        .unwrap();

    let sqrt_check = outputs.get_output(check);

    if sqrt_check.is_non_zero() {
        return None;
    }

    if sqrt_hint >= X22519_u256 {
        return None;
    }

    return Some(to_weierstrass(x_384, y_u384));
}

// Convert twisted Edwards Ed25519 point to equivalent Weierstrass point
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


// Append u256 as little endian to u8 array
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
