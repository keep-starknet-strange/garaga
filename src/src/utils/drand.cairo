use core::sha256::compute_sha256_u32_array;
use garaga::utils::usize_assert_eq;
use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitInputAccumulator
};
use garaga::core::circuit::AddInputResultTrait2;
use garaga::definitions::{G1Point, G2Point, u384};
use garaga::basic_field_ops::{u512_mod_bls12_381};

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
const DRAND_QUICKNET_PUBLIC_KEY: G2Point =
    G2Point {
        x0: u384 {
            limb0: 0x4bc09e76eae8991ef5ece45a,
            limb1: 0xbd274ca73bab4af5a6e9c76a,
            limb2: 0x3aaf4bcb5ed66304de9cf809,
            limb3: 0xd1fec758c921cc22b0e17e6
        },
        x1: u384 {
            limb0: 0x6a0a6c3ac6a5776a2d106451,
            limb1: 0xb90022d3e760183c8c4b450b,
            limb2: 0xcad3912212c437e0073e911f,
            limb3: 0x3cf0f2896adee7eb8b5f01f
        },
        y0: u384 {
            limb0: 0xd183c7477c442b1f04515273,
            limb1: 0xd3022c5c37dce0f977d3adb5,
            limb2: 0xffca88b36c24f3012ba09fc4,
            limb3: 0xe5db2b6bfbb01c867749cad
        },
        y1: u384 {
            limb0: 0xd7a9718b047ccddb3eb5d68b,
            limb1: 0x4ededd8e63aef7be1aaf8e93,
            limb2: 0xa7c75ba902d163700a61bc22,
            limb3: 0x1a714f2edb74119a2f2b0d5
        }
    };

const NZ_POW2_32_64: NonZero<u64> = 0x100000000;
// lib_str + bytes([0]) + dst_prime
// LIB_DST = b'\x00\x80\x00BLS_SIG_BLS12381G1_XMD:SHA-256_SSWU_RO_NUL_+'
const LIB_DST: [
    u32
    ; 12] = [
    32768,
    1112298335,
    1397311327,
    1112298289,
    842217521,
    1194418008,
    1296317011,
    1212230962,
    892755795,
    1398232415,
    1380933454,
    1431068459
];

// DST + bytes([len(dst_prime)])
//b'BLS_SIG_BLS12381G1_XMD:SHA-256_SSWU_RO_NUL_+'
// Can be prefixed safely, words are full.
const DST_PRIME: [
    u32
    ; 11] = [
    0x424c535f,
    0x5349475f,
    0x424c5331,
    0x32333831,
    0x47315f58,
    0x4d443a53,
    0x48412d32,
    0x35365f53,
    0x5357555f,
    0x524f5f4e,
    0x554c5f2b,
];

// "digest function"
fn round_to_message(round: u64) -> [u32; 8] {
    let (high, low) = DivRem::div_rem(round, NZ_POW2_32_64);
    let mut array: Array<u32> = array![];
    array.append(high.try_into().unwrap());
    array.append(low.try_into().unwrap());
    return compute_sha256_u32_array(input: array, last_input_word: 0, last_input_num_bytes: 0);
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
    // msg
    for v in message.span() {
        array.append(*v);
    };
    for v in LIB_DST.span() {
        array.append(*v);
    };
    let b0 = compute_sha256_u32_array(input: array, last_input_word: 0, last_input_num_bytes: 0);

    let mut array: Array<u32> = array![];
    for v in b0.span() {
        array.append(*v);
    };
    array.append(1);

    for v in LIB_DST.span() {
        array.append(*v);
    };
    let bi = compute_sha256_u32_array(input: array, last_input_word: 0, last_input_num_bytes: 0);

    let bi_xor_b0 = xor_u32_array(bi, b0);
    let mut array: Array<u32> = array![];

    for v in bi_xor_b0.span() {
        array.append(*v);
    };
    array.append(2);

    for v in DST_PRIME.span() {
        array.append(*v);
    };

    let bi_1 = compute_sha256_u32_array(array, 0, 0);

    let bi1_xor_b0 = xor_u32_array(bi_1, b0);
    let mut array: Array<u32> = array![];
    for v in bi1_xor_b0.span() {
        array.append(*v);
    };
    array.append(3);
    for v in DST_PRIME.span() {
        array.append(*v);
    };
    let bi_2 = compute_sha256_u32_array(array, 0, 0);

    let bi2_xor_b0 = xor_u32_array(bi_2, b0);
    let mut array: Array<u32> = array![];
    for v in bi2_xor_b0.span() {
        array.append(*v);
    };
    array.append(4);
    for v in DST_PRIME.span() {
        array.append(*v);
    };
    let bi_3 = compute_sha256_u32_array(array, 0, 0);

    return (u512_mod_bls12_381(bi, bi_1), u512_mod_bls12_381(bi_2, bi_3));
}

fn map_to_curve_bls(u: u384) -> G1Point {
    // SWU isogeny curve params.
    let a = u384 {
        limb0: 0xa0e0f97f5cf428082d584c1d,
        limb1: 0xd8e8981aefd881ac98936f8d,
        limb2: 0xc96d4982b0ea985383ee66a8,
        limb3: 0x144698a3b8e9433d693a02
    };
    let b = u384 {
        limb0: 0x316ceaa5d1cc48e98e172be0,
        limb1: 0xa0b9c14fcef35ef55a23215a,
        limb2: 0x753eee3b2016c1f0f24f4070,
        limb3: 0x12e2908d11688030018b12e8
    };
    let z = u384 { limb0: 0x11, limb1: 0x0, limb2: 0x0, limb3: 0x0 };

    let u = felt;
    let zeta_u2 = z * u * *2;
}
#[inline]
fn xor_u32_array(a: [u32; 8], b: [u32; 8]) -> [u32; 8] {
    let [a0, a1, a2, a3, a4, a5, a6, a7] = a;
    let [b0, b1, b2, b3, b4, b5, b6, b7] = b;
    return [a0 ^ b0, a1 ^ b1, a2 ^ b2, a3 ^ b3, a4 ^ b4, a5 ^ b5, a6 ^ b6, a7 ^ b7];
}

fn map_to_curve_inner_ta(_u: u384) ->(u384) {
    let modulus = TryInto::<
    _, CircuitModulus
>::try_into(
    [
        0xb153ffffb9feffffffffaaab,
        0x6730d2a0f6b0f6241eabfffe,
        0x434bacd764774b84f38512bf,
        0x1a0111ea397fe69a4b1ba7b6
    ]
)
    .unwrap(); // BLS12_381 prime field modulus


    let z = CircuitElement::<CircuitInput<0>> {};
    let u = CircuitElement::<CircuitInput<1>> {};
    let u2 = circuit_mul(u, u);
    let zeta_u2 = circuit_mul(z, u2);
    let zeta_u2_square = circuit_mul(zeta_u2, zeta_u2);
    let ta = circuit_add(zeta_u2_square, zeta_u2);


    let outputs = (ta,)
        .new_inputs()
        .next_2([11, 0, 0, 0])
        .next_2(_u)
        .done_2()
        .eval(modulus)
        .unwrap();

    return outputs.get_output(ta);

}

#[cfg(test)]
mod tests {
    use super::DRAND_QUICKNET_PUBLIC_KEY;
    use garaga::ec_ops::{G2PointTrait};

    #[test]
    fn test_drand_quicknet_public_key() {
        DRAND_QUICKNET_PUBLIC_KEY.assert_on_curve(1);
    }
}
