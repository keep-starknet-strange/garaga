use core::sha256::compute_sha256_u32_array;
use garaga::utils::usize_assert_eq;
use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitTrait, CircuitOutputsTrait, CircuitModulus,
    AddInputResultTrait, CircuitInputs,
};
use garaga::core::circuit::AddInputResultTrait2;
use garaga::definitions::{G1Point, G2Point, u384Serde, BLS_G2_GENERATOR};
use garaga::basic_field_ops::{u512_mod_bls12_381, is_even_u384};
use core::num::traits::Zero;
use garaga::ec_ops::{
    ec_safe_add, scalar_mul_g1_fixed_small_scalar, MSMHintSmallScalar, DerivePointFromXHint,
    FunctionFelt, msm_g1_u128,
};
use garaga::ec_ops_g2;
use garaga::circuits::isogeny::run_BLS12_381_APPLY_ISOGENY_BLS12_381_circuit;
use garaga::circuits::ec::run_ADD_EC_POINT_circuit;

use garaga::single_pairing_tower::{miller_loop_bls12_381_tower, final_exp_bls12_381_tower};

// Chain: 52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971
//   Public Key:
//   G2Point(x=(2020076495541918814736776030432697997716141464538799718886374996015782362070437455929656164150586936230283253179482,
//   586231829158603972936263795113906716025771067144631327612230935308837823978471744132589153452744931590357767971921),
//   y=(1791278522428100783277199431487181031376873968689022069271761201187685493801088467849610331824611383166297460070456,
//   3748041376541174045371877684805027382480271890984968787916314231755985669195299696440090936404461850913289003455520),
//   curve_id=<CurveID.BLS12_381: 1>)
//   Period: 3 seconds
//   Genesis Time: 1692803367
//   Hash: 52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971
//   Group Hash: f477d5c89f21a17c863a7f937c6a6d15859414d2be09cd448d4279af331c5d3e
//   Scheme ID: bls-unchained-g1-rfc9380
//   Beacon ID: quicknet
// ----------------------------------------
// Note : Negated to use in pairing check.
const DRAND_QUICKNET_PUBLIC_KEY: G2Point = G2Point {
    x0: u384 {
        limb0: 0x4bc09e76eae8991ef5ece45a,
        limb1: 0xbd274ca73bab4af5a6e9c76a,
        limb2: 0x3aaf4bcb5ed66304de9cf809,
        limb3: 0xd1fec758c921cc22b0e17e6,
    },
    x1: u384 {
        limb0: 0x6a0a6c3ac6a5776a2d106451,
        limb1: 0xb90022d3e760183c8c4b450b,
        limb2: 0xcad3912212c437e0073e911f,
        limb3: 0x3cf0f2896adee7eb8b5f01f,
    },
    y0: u384 {
        limb0: 0xdfd038b83dbad4e0fbae5838,
        limb1: 0x942ea644bed4152aa6d85248,
        limb2: 0x43812423f8525883c7e472fa,
        limb3: 0xba35f3379c4e4d1e3a70b08,
    },
    y1: u384 {
        limb0: 0xd9aa8e74b5823224c149d420,
        limb1: 0x1851f5129301fe6603fc716a,
        limb2: 0x9b84512e61a5e814e923569d,
        limb3: 0x1859fcf74bc8a580a828f6e0,
    },
};

const a_iso_swu: u384 = u384 {
    limb0: 0xa0e0f97f5cf428082d584c1d,
    limb1: 0xd8e8981aefd881ac98936f8d,
    limb2: 0xc96d4982b0ea985383ee66a8,
    limb3: 0x144698a3b8e9433d693a02,
};
const b_iso_swu: u384 = u384 {
    limb0: 0x316ceaa5d1cc48e98e172be0,
    limb1: 0xa0b9c14fcef35ef55a23215a,
    limb2: 0x753eee3b2016c1f0f24f4070,
    limb3: 0x12e2908d11688030018b12e8,
};

const z_iso_swu: u384 = u384 { limb0: 11, limb1: 0, limb2: 0, limb3: 0 };


const NZ_POW2_32_64: NonZero<u64> = 0x100000000;
// lib_str + bytes([0]) + dst_prime
// LIB_DST = b'\x00\x80\x00BLS_SIG_BLS12381G1_XMD:SHA-256_SSWU_RO_NUL_+'
// bytes len : 47.
const LIB_DST: [u32; 11] = [
    0x800042, 0x4c535f53, 0x49475f42, 0x4c533132, 0x33383147, 0x315f584d, 0x443a5348, 0x412d3235,
    0x365f5353, 0x57555f52, 0x4f5f4e55,
];

const LIB_DST_LAST_WORD: u32 = 0x4c5f2b;


const I_DST_PRIME: [u32; 10] = [
    0x5f534947, 0x5f424c53, 0x31323338, 0x3147315f, 0x584d443a, 0x5348412d, 0x3235365f, 0x53535755,
    0x5f524f5f, 0x4e554c5f,
];
const I_DST_PRIME_LAST_WORD: u32 = 0x2b;

fn get_i_dst_prime_first_word(i: usize) -> u32 {
    return i.into() * 0x1000000 + 0x424c53;
}

#[derive(Drop, Serde)]
struct MapToCurveHint {
    gx1_is_square: bool,
    y1: u384,
    y_flag: bool // true if y and u have same parity, false otherwise
}

#[derive(Drop, Serde)]
struct HashToCurveHint {
    f0_hint: MapToCurveHint,
    f1_hint: MapToCurveHint,
    scalar_mul_hint: MSMHintSmallScalar,
    derive_point_from_x_hint: DerivePointFromXHint,
}


// Like hash to curve but we start with the drand round number for simplicity.
fn round_to_curve_bls12_381(round: u64, hash_to_curve_hint: HashToCurveHint) -> G1Point {
    let message = round_to_message(round);
    return hash_to_curve_bls12_381(message, hash_to_curve_hint);
}

#[inline]
fn hash_to_curve_bls12_381(message: [u32; 8], hash_to_curve_hint: HashToCurveHint) -> G1Point {
    let (felt0, felt1) = hash_to_two_bls_felts(message);
    let pt0 = map_to_curve(felt0, hash_to_curve_hint.f0_hint);
    let pt1 = map_to_curve(felt1, hash_to_curve_hint.f1_hint);

    let (sum) = run_ADD_EC_POINT_circuit(pt0, pt1, 1);
    let (sum) = run_BLS12_381_APPLY_ISOGENY_BLS12_381_circuit(sum);

    // clear cofactor :
    let res = scalar_mul_g1_fixed_small_scalar(
        sum,
        BLS_COFACTOR_EPNS,
        BLS_COFACTOR,
        hash_to_curve_hint.scalar_mul_hint,
        hash_to_curve_hint.derive_point_from_x_hint,
        1,
    );
    return res;
}


// x = BLS seed
// n = BLS12_381 EC prime order subgroup
// cofactor = (1 - (x % n)) % n
// const bls_cofactor: u128 = 0xd201000000010001;
const BLS_COFACTOR_EPNS: (felt252, felt252, felt252, felt252) = (
    12124305939094075449, 3008070283847567304, 1, -1,
);
const BLS_COFACTOR: u128 = 0xd201000000010001;

// "digest function"
fn round_to_message(round: u64) -> [u32; 8] {
    let (high, low) = DivRem::div_rem(round, NZ_POW2_32_64);
    let mut array: Array<u32> = array![];
    array.append(high.try_into().unwrap());
    array.append(low.try_into().unwrap());
    return compute_sha256_u32_array(input: array, last_input_word: 0, last_input_num_bytes: 0);
}


#[inline]
fn xor_u32_array_8(a: [u32; 8], b: [u32; 8]) -> [u32; 8] {
    let [a0, a1, a2, a3, a4, a5, a6, a7] = a;
    let [b0, b1, b2, b3, b4, b5, b6, b7] = b;
    return [a0 ^ b0, a1 ^ b1, a2 ^ b2, a3 ^ b3, a4 ^ b4, a5 ^ b5, a6 ^ b6, a7 ^ b7];
}

#[inline]
fn xor_u32_array_4(a: [u32; 4], b: [u32; 4]) -> [u32; 4] {
    let [a0, a1, a2, a3] = a;
    let [b0, b1, b2, b3] = b;
    return [a0 ^ b0, a1 ^ b1, a2 ^ b2, a3 ^ b3];
}

const POW_2_32: u128 = 0x100000000;
const POW_2_64: u128 = 0x10000000000000000;
const POW_2_96: u128 = 0x1000000000000000000000000;

fn u32_array_to_u256(d: [u32; 8]) -> u256 {
    let [d0, d1, d2, d3, d4, d5, d6, d7] = d;
    let high: felt252 = d0.into() * POW_2_96.into()
        + d1.into() * POW_2_64.into()
        + d2.into() * POW_2_32.into()
        + d3.into();
    let low: felt252 = d4.into() * POW_2_96.into()
        + d5.into() * POW_2_64.into()
        + d6.into() * POW_2_32.into()
        + d7.into();

    return u256 { low: low.try_into().unwrap(), high: high.try_into().unwrap() };
}

fn hash_to_two_bls_felts(message: [u32; 8]) -> (u384, u384) {
    let mut array: Array<u32> = array![];
    // Pad with 64 0-bytes. In u32, this is 64 / 4 = 16 elements.
    // "Z_padd"
    array.append(0);
    array.append(0);
    array.append(0);
    array.append(0);
    array.append(0);
    array.append(0);
    array.append(0);
    array.append(0);
    array.append(0);
    array.append(0);
    array.append(0);
    array.append(0);
    array.append(0);
    array.append(0);
    array.append(0);
    array.append(0);
    // msg. 8*4 = 32 bytes
    for v in message.span() {
        array.append(*v);
    };
    // LIB_DST 47 bytes
    for v in LIB_DST.span() {
        array.append(*v);
    };
    // Total : 64 + 32 + 47 = 143 bytes = 1144 bits.
    let b0 = compute_sha256_u32_array(
        input: array, last_input_word: LIB_DST_LAST_WORD, last_input_num_bytes: 3,
    );
    let mut array: Array<u32> = array![];
    for v in b0.span() {
        array.append(*v);
    };

    array.append(get_i_dst_prime_first_word(1));
    for v in I_DST_PRIME.span() {
        array.append(*v);
    };
    let bi = compute_sha256_u32_array(
        input: array, last_input_word: I_DST_PRIME_LAST_WORD, last_input_num_bytes: 1,
    );
    let bi_xor_b0 = xor_u32_array_8(bi, b0);
    let mut array: Array<u32> = array![];

    for v in bi_xor_b0.span() {
        array.append(*v);
    };
    array.append(get_i_dst_prime_first_word(2));
    for v in I_DST_PRIME.span() {
        array.append(*v);
    };

    let bi_1 = compute_sha256_u32_array(array, I_DST_PRIME_LAST_WORD, 1);

    let bi1_xor_b0 = xor_u32_array_8(bi_1, b0);
    let mut array: Array<u32> = array![];
    for v in bi1_xor_b0.span() {
        array.append(*v);
    };
    array.append(get_i_dst_prime_first_word(3));
    for v in I_DST_PRIME.span() {
        array.append(*v);
    };
    let bi_2 = compute_sha256_u32_array(array, I_DST_PRIME_LAST_WORD, 1);

    let bi2_xor_b0 = xor_u32_array_8(bi_2, b0);
    let mut array: Array<u32> = array![];
    for v in bi2_xor_b0.span() {
        array.append(*v);
    };
    array.append(get_i_dst_prime_first_word(4));
    for v in I_DST_PRIME.span() {
        array.append(*v);
    };
    let bi_3 = compute_sha256_u32_array(array, I_DST_PRIME_LAST_WORD, 1);

    return (u512_mod_bls12_381(bi, bi_1), u512_mod_bls12_381(bi_2, bi_3));
}


fn map_to_curve(_u: u384, hint: MapToCurveHint) -> G1Point {
    let (neg_ta, num_x1) = map_to_curve_inner_1(_u);
    let (gx1, div) = map_to_curve_inner_2(neg_ta, num_x1);
    match hint.gx1_is_square {
        true => map_to_curve_inner_final_quad_res(num_x1, gx1, hint.y1, hint.y_flag, div, _u),
        false => map_to_curve_inner_final_not_quad_res(num_x1, hint.y1, hint.y_flag, div, _u, gx1),
    }
}

fn map_to_curve_inner_1(_u: u384) -> (u384, u384) {
    let z = CircuitElement::<CircuitInput<0>> {};
    let u = CircuitElement::<CircuitInput<1>> {};
    let zero = CircuitElement::<CircuitInput<2>> {};
    let one = CircuitElement::<CircuitInput<3>> {};
    let b = CircuitElement::<CircuitInput<4>> {};

    let u2 = circuit_mul(u, u);
    let zeta_u2 = circuit_mul(z, u2);
    let zeta_u2_square = circuit_mul(zeta_u2, zeta_u2);
    let ta = circuit_add(zeta_u2_square, zeta_u2);
    let neg_ta = circuit_sub(zero, ta);
    let num_x1 = circuit_mul(b, circuit_add(ta, one));

    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into(
        [
            0xb153ffffb9feffffffffaaab, 0x6730d2a0f6b0f6241eabfffe, 0x434bacd764774b84f38512bf,
            0x1a0111ea397fe69a4b1ba7b6,
        ],
    )
        .unwrap(); // BLS12_381 prime field modulus

    let outputs = (neg_ta, num_x1)
        .new_inputs()
        .next_2(z_iso_swu)
        .next_2(_u)
        .next_2([0, 0, 0, 0])
        .next_2([1, 0, 0, 0])
        .next_2(b_iso_swu)
        .done_2()
        .eval(modulus)
        .unwrap();

    return (outputs.get_output(neg_ta), outputs.get_output(num_x1));
}

fn map_to_curve_inner_2(_neg_ta: u384, _num_x1: u384) -> (u384, u384) {
    let neg_ta_or_z = CircuitElement::<CircuitInput<0>> {};
    let a = CircuitElement::<CircuitInput<1>> {};
    let b = CircuitElement::<CircuitInput<2>> {};
    // let quad_res_correction = CircuitElement::<CircuitInput<3>> {};
    // let y1_hint = CircuitElement::<CircuitInput<4>> {};
    let num_x1 = CircuitElement::<CircuitInput<3>> {};
    // let zeta_u2 = CircuitElement::<CircuitInput<6>> {};
    // let u = CircuitElement::<CircuitInput<7>> {};

    let div = circuit_mul(a, neg_ta_or_z);
    let num2_x1 = circuit_mul(num_x1, num_x1);
    let div2 = circuit_mul(div, div);
    let div3 = circuit_mul(div2, div);
    //  num_gx1 = (num2_x1 + a * div2) * num_x1 + b * div3

    let num_gx1 = circuit_add(
        circuit_mul(circuit_add(num2_x1, circuit_mul(a, div2)), num_x1), circuit_mul(b, div3),
    );

    // let num_x2 = circuit_mul(zeta_u2, num_x1);

    let gx1 = circuit_mul(num_gx1, circuit_inverse(div3));

    // let gx1_quad_res = circuit_mul(gx1, quad_res_correction);
    // let check = circuit_sub(gx1_quad_res, circuit_mul(y1_hint, y1_hint));

    // let y2 = circuit_mul(zeta_u2, circuit_mul(u, y1_hint));

    let _neg_ta_or_z = match _neg_ta.is_zero() {
        true => z_iso_swu,
        false => _neg_ta,
    };

    // let _quad_res_correction = match hint.gx1_is_square {
    //     true => u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0, },
    //     false => z_iso_swu,
    // };

    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into(
        [
            0xb153ffffb9feffffffffaaab, 0x6730d2a0f6b0f6241eabfffe, 0x434bacd764774b84f38512bf,
            0x1a0111ea397fe69a4b1ba7b6,
        ],
    )
        .unwrap(); // BLS12_381 prime field modulus

    let outputs = (gx1, div)
        .new_inputs()
        .next_2(_neg_ta_or_z)
        .next_2(a_iso_swu)
        .next_2(b_iso_swu)
        .next_2(_num_x1)
        .done_2()
        .eval(modulus)
        .unwrap();

    return (outputs.get_output(gx1), outputs.get_output(div));
}


fn map_to_curve_inner_final_quad_res(
    _num_x1: u384, _gx1: u384, _y1_hint: u384, __parity_flag: bool, _div: u384, u: u384,
) -> G1Point {
    let num_x1 = CircuitElement::<CircuitInput<0>> {};
    let gx1 = CircuitElement::<CircuitInput<1>> {};
    let y1_hint = CircuitElement::<CircuitInput<2>> {};
    let parity_flag = CircuitElement::<CircuitInput<3>> {};
    let div = CircuitElement::<CircuitInput<4>> {};

    let check = circuit_sub(gx1, circuit_mul(y1_hint, y1_hint));
    let x_affine = circuit_mul(num_x1, circuit_inverse(div));
    let y_affine = circuit_mul(parity_flag, y1_hint);

    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into(
        [
            0xb153ffffb9feffffffffaaab, 0x6730d2a0f6b0f6241eabfffe, 0x434bacd764774b84f38512bf,
            0x1a0111ea397fe69a4b1ba7b6,
        ],
    )
        .unwrap(); // BLS12_381 prime field modulus

    // Flag = -1 if y%2 !=u%1 ; 1 if y%2 == u%2.

    let _parity_flag: u384 = match __parity_flag {
        true => u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        false => crate::definitions::get_min_one(curve_index: 1),
    };

    let outputs = (x_affine, y_affine, check)
        .new_inputs()
        .next_2(_num_x1)
        .next_2(_gx1)
        .next_2(_y1_hint)
        .next_2(_parity_flag)
        .next_2(_div)
        .done_2()
        .eval(modulus)
        .unwrap();

    let chk = outputs.get_output(check);
    assert(chk == Zero::zero(), 'm2cI wrong square root');
    // Verify parity. base is even so high parts doesn't affect parity.
    // (l0 + l1*2^b + l2*2^2b + l3*2^3b % 2
    // l0 % 2 + (l1 % 2)*2^b % 2 + (l2 % 2)*2^2b % 2 + (l3 % 2)*2^3b % 2
    // 2^b = 0 for all b>=1
    // so u384 % 2 = limb0 % 2.
    match __parity_flag {
        true => assert(is_even_u384(_y1_hint) == is_even_u384(u), 'm2cI wrong parity'),
        false => assert(is_even_u384(_y1_hint) != is_even_u384(u), 'm2cI wrong parity'),
    }

    return G1Point { x: outputs.get_output(x_affine), y: outputs.get_output(y_affine) };
}


fn map_to_curve_inner_final_not_quad_res(
    _num_x1: u384, _y1_hint: u384, __parity_flag: bool, _div: u384, _u: u384, _gx1: u384,
) -> G1Point {
    let num_x1 = CircuitElement::<CircuitInput<0>> {};
    let y1_hint = CircuitElement::<CircuitInput<1>> {};
    let parity_flag = CircuitElement::<CircuitInput<2>> {};
    let div = CircuitElement::<CircuitInput<3>> {};
    let u = CircuitElement::<CircuitInput<4>> {};
    let gx1 = CircuitElement::<CircuitInput<5>> {};
    let z = CircuitElement::<CircuitInput<6>> {};

    let u2 = circuit_mul(u, u);
    let zeta_u2 = circuit_mul(z, u2);
    let gx1_quad_res = circuit_mul(gx1, z);
    let check = circuit_sub(gx1_quad_res, circuit_mul(y1_hint, y1_hint));
    let y2 = circuit_mul(zeta_u2, circuit_mul(u, y1_hint));
    let num_x = circuit_mul(zeta_u2, num_x1);
    let x_affine = circuit_mul(num_x, circuit_inverse(div));
    let y_affine = circuit_mul(parity_flag, y2);

    // Flag = -1 if y%2 !=u%1 ; 1 if y%2 == u%2.
    let _parity_flag: u384 = match __parity_flag {
        true => u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        false => crate::definitions::get_min_one(curve_index: 1),
    };
    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into(
        [
            0xb153ffffb9feffffffffaaab, 0x6730d2a0f6b0f6241eabfffe, 0x434bacd764774b84f38512bf,
            0x1a0111ea397fe69a4b1ba7b6,
        ],
    )
        .unwrap(); // BLS12_381 prime field modulus

    let outputs = (x_affine, y_affine, check)
        .new_inputs()
        .next_2(_num_x1)
        .next_2(_y1_hint)
        .next_2(_parity_flag)
        .next_2(_div)
        .next_2(_u)
        .next_2(_gx1)
        .next_2(z_iso_swu)
        .done_2()
        .eval(modulus)
        .unwrap();

    let chk = outputs.get_output(check);
    assert(chk == Zero::zero(), 'm2cII wrong square root');

    // Verify parity. base is even so high parts doesn't affect parity.
    match __parity_flag {
        true => assert(
            is_even_u384(outputs.get_output(y2)) == is_even_u384(_u), 'm2cI wrong parity',
        ),
        false => assert(
            is_even_u384(outputs.get_output(y2)) != is_even_u384(_u), 'm2cI wrong parity',
        ),
    }
    return G1Point { x: outputs.get_output(x_affine), y: outputs.get_output(y_affine) };
}

// The result of a timelock encryption over drand quicknet.
struct CipherText {
    U: G2Point,
    V: [u8; 16],
    W: [u8; 16],
}

// bytes("IBE-H2") (4 + 2 bytes)
const IBE_H2: [u32; 2] = [0x4942452d, 0x4832];
// bytes("IBE-H4") (4 + 2 bytes)
const IBE_H4: [u32; 2] = [0x4942452d, 0x4834];
const IBE_H3: [u32; 2] = [0x4942452d, 0x4833];

use core::circuit::conversions::{
    DivRemU96By32, DivRemU96By64, ConstValue, POW64, POW64_TYPED, NZ_POW64_TYPED, POW32,
    POW32_TYPED, NZ_POW32_TYPED,
};

use core::internal::bounded_int::{BoundedInt, bounded_int_div_rem, DivRemHelper};

const POW80: felt252 = 0x100000000000000000000;
const NZ_POW80_TYPED: NonZero<ConstValue<POW80>> = 0x100000000000000000000;
const POW16: felt252 = 0x10000;
const NZ_POW16_TYPED: NonZero<ConstValue<POW16>> = 0x10000;

const POW48: felt252 = 0x1000000000000;
const NZ_POW48_TYPED: NonZero<ConstValue<POW48>> = 0x1000000000000;


const POW24: felt252 = 0x1000000;
const POW8: felt252 = 0x100;
type u64_bi = BoundedInt<0, { POW64 - 1 }>;
type u80_bi = BoundedInt<0, { POW80 - 1 }>;
type u48_bi = BoundedInt<0, { POW48 - 1 }>;
type u32_bi = BoundedInt<0, { POW32 - 1 }>;

impl DivRemU64By32 of DivRemHelper<u64_bi, ConstValue<POW32>> {
    type DivT = BoundedInt<0, { POW32 - 1 }>;
    type RemT = BoundedInt<0, { POW32 - 1 }>;
}

impl DivRemU96By80 of DivRemHelper<u96, ConstValue<POW80>> {
    type DivT = BoundedInt<0, { POW16 - 1 }>;
    type RemT = BoundedInt<0, { POW80 - 1 }>;
}

impl DivRemU80By48 of DivRemHelper<u80_bi, ConstValue<POW48>> {
    type DivT = BoundedInt<0, { POW32 - 1 }>;
    type RemT = BoundedInt<0, { POW48 - 1 }>;
}

impl DivRemU48By16 of DivRemHelper<u48_bi, ConstValue<POW16>> {
    type DivT = BoundedInt<0, { POW32 - 1 }>;
    type RemT = BoundedInt<0, { POW16 - 1 }>;
}

impl DivRemU32By16 of DivRemHelper<u32_bi, ConstValue<POW16>> {
    type DivT = BoundedInt<0, { POW16 - 1 }>;
    type RemT = BoundedInt<0, { POW16 - 1 }>;
}


#[inline(always)]
pub fn append_u96_to_u32_array(ref array: Array<u32>, u: u96) {
    let (u32_h, u64_l): (DivRemU96By64::DivT, DivRemU96By64::RemT) = bounded_int_div_rem(
        u, NZ_POW64_TYPED,
    );
    let (u32_mid, u32_low): (DivRemU64By32::DivT, DivRemU64By32::RemT) = bounded_int_div_rem(
        u64_l, NZ_POW32_TYPED,
    );
    let u32_hf: felt252 = u32_h.into();
    let u32_mf: felt252 = u32_mid.into();
    let u32_lf: felt252 = u32_low.into();
    array.append(u32_hf.try_into().unwrap());
    array.append(u32_mf.try_into().unwrap());
    array.append(u32_lf.try_into().unwrap());
}
#[inline]
pub fn append_u384_be_to_u32_array(ref array: Array<u32>, u: u384) {
    append_u96_to_u32_array(ref array, u.limb3);
    append_u96_to_u32_array(ref array, u.limb2);
    append_u96_to_u32_array(ref array, u.limb1);
    append_u96_to_u32_array(ref array, u.limb0);
}

const NZ_POW24_32: NonZero<u32> = 0x1000000;
const NZ_POW16_32: NonZero<u32> = 0x10000;
const NZ_POW8_32: NonZero<u32> = 0x100;

#[inline(always)]
pub fn u32_to_u8_4(a: u32) -> [u8; 4] {
    let (b3, r) = DivRem::div_rem(a, NZ_POW24_32);
    let (b2, r) = DivRem::div_rem(r, NZ_POW16_32);
    let (b1, b0) = DivRem::div_rem(r, NZ_POW8_32);
    return [
        b3.try_into().unwrap(), b2.try_into().unwrap(), b1.try_into().unwrap(),
        b0.try_into().unwrap(),
    ];
}


#[inline(always)]
pub fn u32_4_to_u8_16(a: [u32; 4]) -> [u8; 16] {
    let [a3, a2, a1, a0] = a;
    let [b15, b14, b13, b12] = u32_to_u8_4(a3);
    let [b11, b10, b9, b8] = u32_to_u8_4(a2);
    let [b7, b6, b5, b4] = u32_to_u8_4(a1);
    let [b3, b2, b1, b0] = u32_to_u8_4(a0);
    return [b15, b14, b13, b12, b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1, b0];
}

#[inline(always)]
pub fn append_u96_with_pending_u16(ref array: Array<u32>, pending_u16: u32, u: u96) -> u32 {
    let (u16_h, u80_l): (DivRemU96By80::DivT, DivRemU96By80::RemT) = bounded_int_div_rem(
        u, NZ_POW80_TYPED,
    );
    let (u32_mid, u48_low): (DivRemU80By48::DivT, DivRemU80By48::RemT) = bounded_int_div_rem(
        u80_l, NZ_POW48_TYPED,
    );
    let (u32_low, u16_low): (DivRemU48By16::DivT, DivRemU48By16::RemT) = bounded_int_div_rem(
        u48_low, NZ_POW16_TYPED,
    );
    let u16_hf: felt252 = u16_h.into();
    let u32_mf: felt252 = u32_mid.into();
    let u32_lf: felt252 = u32_low.into();
    let next_u16_pending: felt252 = u16_low.into();

    array.append((pending_u16.into() * POW16 + u16_hf).try_into().unwrap());
    array.append(u32_mf.try_into().unwrap());
    array.append(u32_lf.try_into().unwrap());

    return next_u16_pending.try_into().unwrap();
}


#[inline(always)]
pub fn append_u32_with_pending_u16(ref array: Array<u32>, pending_u16: u32, u: u32) -> u32 {
    let (u16_h, next_pending) = DivRem::div_rem(u, NZ_POW16_32);
    let u16_hf: felt252 = u16_h.into();
    array.append((pending_u16.into() * POW16 + u16_hf).try_into().unwrap());
    return next_pending;
}

pub fn append_u384_with_pending_u16(ref array: Array<u32>, pending_u16: u32, u: u384) -> u32 {
    let pending_u16 = append_u96_with_pending_u16(ref array, pending_u16, u.limb3);
    let pending_u16 = append_u96_with_pending_u16(ref array, pending_u16, u.limb2);
    let pending_u16 = append_u96_with_pending_u16(ref array, pending_u16, u.limb1);
    let pending_u16 = append_u96_with_pending_u16(ref array, pending_u16, u.limb0);
    return pending_u16;
}


pub fn u8_16_to_u32_4(a: [u8; 16]) -> [u32; 4] {
    let [a15, a14, a13, a12, a11, a10, a9, a8, a7, a6, a5, a4, a3, a2, a1, a0] = a;
    let w3: felt252 = a15.into() * POW24 + a14.into() * POW16 + a13.into() * POW8 + a12.into();
    let w2: felt252 = a11.into() * POW24 + a10.into() * POW16 + a9.into() * POW8 + a8.into();
    let w1: felt252 = a7.into() * POW24 + a6.into() * POW16 + a5.into() * POW8 + a4.into();
    let w0: felt252 = a3.into() * POW24 + a2.into() * POW16 + a1.into() * POW8 + a0.into();
    return [
        w3.try_into().unwrap(), w2.try_into().unwrap(), w1.try_into().unwrap(),
        w0.try_into().unwrap(),
    ];
}

pub fn decrypt_at_round(signature_at_round: G1Point, ciphertext: CipherText) -> [u8; 16] {
    let (M) = miller_loop_bls12_381_tower(signature_at_round, ciphertext.U);
    let rgid = final_exp_bls12_381_tower(M);

    let mut array: Array<u32> = array![];

    let [ibe_h2_0, ibe_h2_1] = IBE_H2;
    array.append(ibe_h2_0);
    let pending = append_u384_with_pending_u16(ref array, ibe_h2_1, rgid.c1b2a1);
    let pending = append_u384_with_pending_u16(ref array, pending, rgid.c1b2a0);
    let pending = append_u384_with_pending_u16(ref array, pending, rgid.c1b1a1);
    let pending = append_u384_with_pending_u16(ref array, pending, rgid.c1b1a0);
    let pending = append_u384_with_pending_u16(ref array, pending, rgid.c1b0a1);
    let pending = append_u384_with_pending_u16(ref array, pending, rgid.c1b0a0);
    let pending = append_u384_with_pending_u16(ref array, pending, rgid.c0b2a1);
    let pending = append_u384_with_pending_u16(ref array, pending, rgid.c0b2a0);
    let pending = append_u384_with_pending_u16(ref array, pending, rgid.c0b1a1);
    let pending = append_u384_with_pending_u16(ref array, pending, rgid.c0b1a0);
    let pending = append_u384_with_pending_u16(ref array, pending, rgid.c0b0a1);
    let pending = append_u384_with_pending_u16(ref array, pending, rgid.c0b0a0);

    let [r7, r6, r5, r4, _, _, _, _] = compute_sha256_u32_array(
        input: array, last_input_word: pending, last_input_num_bytes: 2,
    );

    let v: [u32; 4] = u8_16_to_u32_4(ciphertext.V);
    let sigma: [u32; 4] = xor_u32_array_4([r7, r6, r5, r4], v);

    let mut array: Array<u32> = array![];
    let [ibe_h4_0, ibe_h4_1] = IBE_H4;
    array.append(ibe_h4_0);

    let [s3, s2, s1, s0] = sigma;
    let pending = append_u32_with_pending_u16(ref array, ibe_h4_1, s3);
    let pending = append_u32_with_pending_u16(ref array, pending, s2);
    let pending = append_u32_with_pending_u16(ref array, pending, s1);
    let pending = append_u32_with_pending_u16(ref array, pending, s0);

    let [sh7, sh6, sh5, sh4, _, _, _, _] = compute_sha256_u32_array(
        input: array, last_input_word: pending, last_input_num_bytes: 2,
    );

    let w = u8_16_to_u32_4(ciphertext.W);
    let message: [u32; 4] = xor_u32_array_4([sh7, sh6, sh5, sh4], w);
    let [m3, m2, m1, m0] = message;
    // Convert to bytes :
    let message_bytes = u32_4_to_u8_16(message);

    // Verify U = G^R

    let mut array: Array<u32> = array![];
    let [ibe_h3_0, ibe_h3_1] = IBE_H3;
    array.append(ibe_h3_0);
    // Append sigma
    let pending = append_u32_with_pending_u16(ref array, ibe_h3_1, s3);
    let pending = append_u32_with_pending_u16(ref array, pending, s2);
    let pending = append_u32_with_pending_u16(ref array, pending, s1);
    let pending = append_u32_with_pending_u16(ref array, pending, s0);
    // Append message :
    let pending = append_u32_with_pending_u16(ref array, pending, m3);
    let pending = append_u32_with_pending_u16(ref array, pending, m2);
    let pending = append_u32_with_pending_u16(ref array, pending, m1);
    let pending = append_u32_with_pending_u16(ref array, pending, m0);

    // Little endian
    let rh = compute_sha256_u32_array(
        input: array, last_input_word: pending, last_input_num_bytes: 2,
    );

    let mut i = 1;
    let mut r = expand_message_drand(rh, i);

    // r must be non-zero:
    while r == 0 {
        i += 1;
        let _r = expand_message_drand(rh, i);
        r = _r;
    };

    let U = ec_ops_g2::ec_mul(BLS_G2_GENERATOR, r, 1).unwrap();
    assert(U == ciphertext.U, 'Incorrect ciphertext proof.');
    return message_bytes;
}

pub fn expand_message_drand(msg: [u32; 8], i: u8) -> u256 {
    let mut array: Array<u32> = array![];
    let [m7, m6, m5, m4, m3, m2, m1, m0] = msg;
    // i.to_bytes(2, byteorder="little")
    let pending = append_u32_with_pending_u16(ref array, i.into() * 0x100, m7);
    let pending = append_u32_with_pending_u16(ref array, pending, m6);
    let pending = append_u32_with_pending_u16(ref array, pending, m5);
    let pending = append_u32_with_pending_u16(ref array, pending, m4);
    let pending = append_u32_with_pending_u16(ref array, pending, m3);
    let pending = append_u32_with_pending_u16(ref array, pending, m2);
    let pending = append_u32_with_pending_u16(ref array, pending, m1);
    let pending = append_u32_with_pending_u16(ref array, pending, m0);

    let hash_result = compute_sha256_u32_array(
        input: array, last_input_word: pending, last_input_num_bytes: 2,
    );

    let [r0, r1, r2, r3, r4, r5, r6, r7] = hash_result;

    // Mask the first byte of r0
    // Extract the leftmost byte
    let first_byte = r0 & 0xFF000000;

    // Right shift the first byte by 1 bit
    let shifted_byte = first_byte / 2;

    // Combine the shifted byte back with the rest of r0
    let r0 = shifted_byte | (r0 & 0x00FFFFFF);

    return hash_to_u256([r0, r1, r2, r3, r4, r5, r6, r7]);
}


pub fn hash_to_u256(msg: [u32; 8]) -> u256 {
    let [a, b, c, d, e, f, g, h] = msg;
    let low: u128 = h.into() + g.into() * POW_2_32 + f.into() * POW_2_64 + e.into() * POW_2_96;
    let high: u128 = d.into() + c.into() * POW_2_32 + b.into() * POW_2_64 + a.into() * POW_2_96;

    u256 { low: low, high: high }
}


#[cfg(test)]
mod tests {
    use super::{
        DRAND_QUICKNET_PUBLIC_KEY, hash_to_two_bls_felts, u384, G1Point, MapToCurveHint,
        map_to_curve, HashToCurveHint, MSMHintSmallScalar, DerivePointFromXHint,
        hash_to_curve_bls12_381, FunctionFelt, run_BLS12_381_APPLY_ISOGENY_BLS12_381_circuit,
        CipherText, decrypt_at_round, G2Point,
    };
    use garaga::ec_ops_g2::G2PointTrait;

    #[test]
    fn test_drand_quicknet_public_key() {
        DRAND_QUICKNET_PUBLIC_KEY.assert_on_curve(1);
    }
    #[test]
    fn test_hash_to_two_bls_felts() {
        // sha256("Hello, World!")
        let message: [u32; 8] = [
            0xdffd6021, 0xbb2bd5b0, 0xaf676290, 0x809ec3a5, 0x3191dd81, 0xc7f70a4b, 0x28688a36,
            0x2182986f,
        ];
        let (a, b) = hash_to_two_bls_felts(message);

        assert_eq!(
            a,
            u384 {
                limb0: 0x3424dff585d947fedf210456,
                limb1: 0xd67576428da87a9356340b2e,
                limb2: 0x135e368f3927494b3933a985,
                limb3: 0x85a31dc6b81af709df9ba4e,
            },
        );
        assert_eq!(
            b,
            u384 {
                limb0: 0xdb509060a0293b7d9e20ae9,
                limb1: 0x189ad7a1508b89604e165848,
                limb2: 0x74a42a64a63d7c9dd6bfec2c,
                limb3: 0x1049922d5dcd716806ccfa3e,
            },
        );
    }

    #[test]
    fn test_map_to_curve() {
        let u = u384 { limb0: 42, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

        let expected = G1Point {
            x: u384 {
                limb0: 0x1c94f3121ca3e1454e60bded,
                limb1: 0xe09a5f66977f922ae74baf50,
                limb2: 0xa471b958de9a5099a84aca44,
                limb3: 0x923f1e3115dc78a457fffa1,
            },
            y: u384 {
                limb0: 0xaa8806e6b469554a91758ec,
                limb1: 0xdbfb03df4a53a534ac80def7,
                limb2: 0xb81c6297bbac342050bff567,
                limb3: 0xfb9022e050807db4b155d87,
            },
        };
        let hint = MapToCurveHint {
            gx1_is_square: false,
            y1: u384 {
                limb0: 0x8c74c126c6351052ebf1965,
                limb1: 0x979aba6acb3e5dfca5581a51,
                limb2: 0x49e43c123f4e034706485bde,
                limb3: 0x152ffaf0e2cd3fbbb102b5e1,
            },
            y_flag: false,
        };
        let res = map_to_curve(u, hint);
        assert_eq!(res, expected);
    }

    #[test]
    fn test_isogeny() {
        let pt = G1Point {
            x: u384 {
                limb0: 0xfe95b6d6dc4c28b03aa82194,
                limb1: 0xc06a9cdc69f9d39a1cb3c132,
                limb2: 0xc0637d447baf4f55d4658b59,
                limb3: 0x166e53a3af1733961f92e08,
            },
            y: u384 {
                limb0: 0x5dc860b68c76e432263e15dc,
                limb1: 0x8c9990a0f89eadd580f71395,
                limb2: 0xaf300dff12d93cfe32b45c5d,
                limb3: 0x8f6e2a59628049aecb84109,
            },
        };

        let expected = G1Point {
            x: u384 {
                limb0: 0x5fad5b4abf0d9b5a5500069,
                limb1: 0x88e3293255d2172755b29514,
                limb2: 0x2562887a0b9a729cf8f6f807,
                limb3: 0xfb545dd46e90e6f6bd679a1,
            },
            y: u384 {
                limb0: 0xbea8d03c186753a97b5e8e0b,
                limb1: 0xbe3e7a1eb25cf6d7fa6f686d,
                limb2: 0x72026b41a862ff1fa8508191,
                limb3: 0xd596c01e510faf25030e9a5,
            },
        };
        let (res) = run_BLS12_381_APPLY_ISOGENY_BLS12_381_circuit(pt);
        assert_eq!(res, expected);
    }
    #[test]
    fn test_hash_to_curve() {
        let message: [u32; 8] = [
            0xdffd6021, 0xbb2bd5b0, 0xaf676290, 0x809ec3a5, 0x3191dd81, 0xc7f70a4b, 0x28688a36,
            0x2182986f,
        ];
        let hint = HashToCurveHint {
            f0_hint: MapToCurveHint {
                gx1_is_square: true,
                y1: u384 {
                    limb0: 0xf26e7fd3c2733a0413db4463,
                    limb1: 0xa1562d011f360461be8e36dd,
                    limb2: 0x84a83147a7e7a1311a712501,
                    limb3: 0x1290f63f6daa85ad6bf7088a,
                },
                y_flag: false,
            },
            f1_hint: MapToCurveHint {
                gx1_is_square: false,
                y1: u384 {
                    limb0: 0xb88f6c46cebe267f9e2afa6c,
                    limb1: 0xa845982734193f6f44e49212,
                    limb2: 0x63e1f53f7553752da88fb12c,
                    limb3: 0xd613d3f488be39870f05a5c,
                },
                y_flag: false,
            },
            scalar_mul_hint: MSMHintSmallScalar {
                Q: G1Point {
                    x: u384 {
                        limb0: 0x931f614913b4e856c2a5dd1b,
                        limb1: 0xce68eade0d43210615956b1d,
                        limb2: 0x4f2c8c74301387552679068d,
                        limb3: 0xcc12bfa116dae0017adb178,
                    },
                    y: u384 {
                        limb0: 0x6b02cc408fda040be6918d1e,
                        limb1: 0x325a198e22c4131c6fed473b,
                        limb2: 0xf0bbbddfea59e5a96a11bd20,
                        limb3: 0xeb05659d43180b59cee2ea0,
                    },
                },
                SumDlogDiv: FunctionFelt {
                    a_num: array![
                        u384 {
                            limb0: 0xe9547e3c22c368f3668c26d2,
                            limb1: 0x75bc3174101565eeb65968d6,
                            limb2: 0x3afe08b77f8913061d67f0b2,
                            limb3: 0xc3a508ed77d2e5fd684d134,
                        },
                        u384 { limb0: 0x3f41b003a7dbf839, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    ]
                        .span(),
                    a_den: array![
                        u384 {
                            limb0: 0xe992bce6bcd56741b4be8dda,
                            limb1: 0x975f2e11a8fc4e110f1b44ba,
                            limb2: 0xc1e9530f84e3a7e0a46d33e1,
                            limb3: 0x88dd6a0666b7d5a4c14ea85,
                        },
                        u384 {
                            limb0: 0x4d6f4786473f4ff1643a5ee,
                            limb1: 0x25cb9788a504f44e94bddec4,
                            limb2: 0xe8adc9bc8ead85ba812bddf7,
                            limb3: 0x53655ff5e6a7e350e3028ac,
                        },
                        u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    ]
                        .span(),
                    b_num: array![
                        u384 {
                            limb0: 0x743a827dc9c4737c7a70322d,
                            limb1: 0x7bfda798292e0429f35febf0,
                            limb2: 0x7bca28663f0d7795d8629dc2,
                            limb3: 0x1eb8b6c2989bb00ee12bd00,
                        },
                        u384 {
                            limb0: 0xdc2fa95b1c3dadfa185f4ff4,
                            limb1: 0x9daea3eea2647b9adc25d4ea,
                            limb2: 0x24dbf64222ab9fcb34052520,
                            limb3: 0x124e8c93a451aaeb0b256a,
                        },
                        u384 {
                            limb0: 0x3e58c1d601349a222ca499e8,
                            limb1: 0x6c6aaf8d55c9039164e09e20,
                            limb2: 0xfb431077e445c903bc81ed03,
                            limb3: 0xc08aa0954aa40b81be4fdf9,
                        },
                    ]
                        .span(),
                    b_den: array![
                        u384 {
                            limb0: 0xf4f6f39b39569d06d2fa8cbd,
                            limb1: 0xf64be5a5ad4042201dc112ec,
                            limb2: 0xc4599f66af1753fd9e2fbcc6,
                            limb3: 0x8364897602e0ecee5380260,
                        },
                        u384 {
                            limb0: 0x135bd1e191cfd3fc590e97b8,
                            limb1: 0x972e5e229413d13a52f77b10,
                            limb2: 0xa2b726f23ab616ea04af77dc,
                            limb3: 0x14d957fd79a9f8d438c0a2b3,
                        },
                        u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                        u384 {
                            limb0: 0xe992bce6bcd56741b4be8dda,
                            limb1: 0x975f2e11a8fc4e110f1b44ba,
                            limb2: 0xc1e9530f84e3a7e0a46d33e1,
                            limb3: 0x88dd6a0666b7d5a4c14ea85,
                        },
                        u384 {
                            limb0: 0x4d6f4786473f4ff1643a5ee,
                            limb1: 0x25cb9788a504f44e94bddec4,
                            limb2: 0xe8adc9bc8ead85ba812bddf7,
                            limb3: 0x53655ff5e6a7e350e3028ac,
                        },
                        u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    ]
                        .span(),
                },
            },
            derive_point_from_x_hint: DerivePointFromXHint {
                y_last_attempt: u384 {
                    limb0: 0x6515783d21f573c7cd61fbae,
                    limb1: 0x1013607aa988eeb0dbea896a,
                    limb2: 0xc459d27f6d3a34be79bbb31a,
                    limb3: 0xb32862ff9309b9044f09471,
                },
                g_rhs_sqrt: array![].span(),
            },
        };

        let expected = G1Point {
            x: u384 {
                limb0: 0x931f614913b4e856c2a5dd1b,
                limb1: 0xce68eade0d43210615956b1d,
                limb2: 0x4f2c8c74301387552679068d,
                limb3: 0xcc12bfa116dae0017adb178,
            },
            y: u384 {
                limb0: 0x6b02cc408fda040be6918d1e,
                limb1: 0x325a198e22c4131c6fed473b,
                limb2: 0xf0bbbddfea59e5a96a11bd20,
                limb3: 0xeb05659d43180b59cee2ea0,
            },
        };
        let res = hash_to_curve_bls12_381(message, hint);
        assert_eq!(res, expected);
    }

    #[test]
    fn test_decrypt_at_round() {
        // msg: b'hello\x00\x00\x00\x00\x00\x00\x00\x00abc'
        // round: 128
        // network: DrandNetwork.quicknet

        let signature_at_round: G1Point = G1Point {
            x: u384 {
                limb0: 0xc0bcbd3576ff11f14722cf6c,
                limb1: 0xd452247305c00e921bd480d6,
                limb2: 0x8b9980255afbf088406ce2e9,
                limb3: 0x3783c94f8000028fa31f457,
            },
            y: u384 {
                limb0: 0x2b4d36d607cf825974c364b4,
                limb1: 0x44cd6938390204bd3a17bf08,
                limb2: 0x92d3ea3afc64bf69e6c4cf27,
                limb3: 0x9ee7907fd3b11fa8ec81ccc,
            },
        };

        let ciph = CipherText {
            U: G2Point {
                x0: u384 {
                    limb0: 0x340fdd978d12a78af62a4938,
                    limb1: 0xf70620e8446a28e3d2071039,
                    limb2: 0xe08fd6ca0d6e9bdcb5dbf048,
                    limb3: 0x14fb6e4f383578999fe9250,
                },
                x1: u384 {
                    limb0: 0x25a2b053807bd5aa950143b1,
                    limb1: 0x845c1664a97d715be868b2d2,
                    limb2: 0x5c1891819cbeaf9241827325,
                    limb3: 0x1db774cee6dd8860aad23b7,
                },
                y0: u384 {
                    limb0: 0x941e76c3d4243c3a29eb37b6,
                    limb1: 0xeb7d54ef8c76445a546aa67e,
                    limb2: 0x945908b037be402a146d92cc,
                    limb3: 0x51401dcca71a5b8e961858,
                },
                y1: u384 {
                    limb0: 0x83136ccccc82c994f1c19abe,
                    limb1: 0x638557d8f6ba3dbceffb0d86,
                    limb2: 0xd81843d33e29bd92ca715eca,
                    limb3: 0x12d802c5957e9cab6e1e8c82,
                },
            },
            V: [
                0xa7, 0x35, 0xd6, 0x12, 0x47, 0x88, 0xc9, 0x3f, 0x2c, 0xc4, 0xdd, 0xe5, 0x5d, 0x54,
                0x31, 0x15,
            ],
            W: [
                0x7f, 0x10, 0x1c, 0x52, 0x8b, 0xf7, 0x63, 0x15, 0x57, 0x8d, 0x77, 0x2e, 0x79, 0x3f,
                0x01, 0x29,
            ],
        };
        let msg_decrypted = decrypt_at_round(signature_at_round, ciph);
        assert(
            msg_decrypted
                .span() == [
                    0x68, 0x65, 0x6c, 0x6c, 0x6f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                    0x61, 0x62, 0x63,
                ]
                .span(),
            'wrong msg',
        );
    }
}

