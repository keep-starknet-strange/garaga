// Originally taken from Alexandria library.

use core::num::traits::{Bounded, WrappingAdd};
use core::traits::{BitAnd, BitOr, BitXor};

// Variable naming is compliant to RFC-6234 (https://datatracker.ietf.org/doc/html/rfc6234)

pub const SHA512_LEN: usize = 64;

pub const U64_BIT_NUM: u64 = 64;

// Powers of two to avoid recomputing
pub const TWO_POW_56: u64 = 0x100000000000000;
pub const TWO_POW_48: u64 = 0x1000000000000;
pub const TWO_POW_40: u64 = 0x10000000000;
pub const TWO_POW_32: u64 = 0x100000000;
pub const TWO_POW_24: u64 = 0x1000000;
pub const TWO_POW_16: u64 = 0x10000;
pub const TWO_POW_8: u64 = 0x100;
pub const TWO_POW_4: u64 = 0x10;
pub const TWO_POW_2: u64 = 0x4;
pub const TWO_POW_1: u64 = 0x2;
pub const TWO_POW_0: u64 = 0x1;

const TWO_POW_7: u64 = 0x80;
const TWO_POW_14: u64 = 0x4000;
const TWO_POW_18: u64 = 0x40000;
const TWO_POW_19: u64 = 0x80000;
const TWO_POW_28: u64 = 0x10000000;
const TWO_POW_34: u64 = 0x400000000;
const TWO_POW_39: u64 = 0x8000000000;
const TWO_POW_41: u64 = 0x20000000000;
const TWO_POW_61: u64 = 0x2000000000000000;

const TWO_POW_64_MINUS_1: u64 = 0x8000000000000000;
const TWO_POW_64_MINUS_6: u64 = 0x40;
const TWO_POW_64_MINUS_8: u64 = 0x100000000000000;
const TWO_POW_64_MINUS_14: u64 = 0x4000000000000;
const TWO_POW_64_MINUS_18: u64 = 0x400000000000;
const TWO_POW_64_MINUS_19: u64 = 0x200000000000;
const TWO_POW_64_MINUS_28: u64 = 0x1000000000;
const TWO_POW_64_MINUS_34: u64 = 0x40000000;
const TWO_POW_64_MINUS_39: u64 = 0x2000000;
const TWO_POW_64_MINUS_41: u64 = 0x800000;
const TWO_POW_64_MINUS_61: u64 = 0x8;

// Max u8 and u64 for bitwise operations
pub const MAX_U8: u64 = 0xff;
pub const MAX_U64: u128 = 0xffffffffffffffff;

#[derive(Drop, Copy)]
pub struct Word64 {
    pub data: u64,
}

impl WordBitAnd of BitAnd<Word64> {
    fn bitand(lhs: Word64, rhs: Word64) -> Word64 {
        let data = BitAnd::bitand(lhs.data, rhs.data);
        Word64 { data }
    }
}

impl WordBitXor of BitXor<Word64> {
    fn bitxor(lhs: Word64, rhs: Word64) -> Word64 {
        let data = BitXor::bitxor(lhs.data, rhs.data);
        Word64 { data }
    }
}

impl WordBitOr of BitOr<Word64> {
    fn bitor(lhs: Word64, rhs: Word64) -> Word64 {
        let data = BitOr::bitor(lhs.data, rhs.data);
        Word64 { data }
    }
}

impl WordBitNot of BitNot<Word64> {
    fn bitnot(a: Word64) -> Word64 {
        Word64 { data: Bounded::MAX - a.data }
    }
}

impl WordAdd of Add<Word64> {
    fn add(lhs: Word64, rhs: Word64) -> Word64 {
        Word64 { data: lhs.data.wrapping_add(rhs.data) }
    }
}

impl U128IntoWord of Into<u128, Word64> {
    fn into(self: u128) -> Word64 {
        Word64 { data: self.try_into().unwrap() }
    }
}

impl U64IntoWord of Into<u64, Word64> {
    fn into(self: u64) -> Word64 {
        Word64 { data: self }
    }
}

pub trait WordOperations<T> {
    fn rotr_precomputed(self: T, two_pow_n: u64, two_pow_64_n: u64) -> T;
}

pub impl Word64WordOperations of WordOperations<Word64> {
    // does the work of rotr but with precomputed values 2**n and 2**(64-n)
    fn rotr_precomputed(self: Word64, two_pow_n: u64, two_pow_64_n: u64) -> Word64 {
        let data = self.data.into();
        let data: u128 = BitOr::bitor(
            math_shr_precomputed::<u128>(data, two_pow_n.into()),
            math_shl_precomputed::<u128>(data, two_pow_64_n.into()),
        );

        let data: u64 = match data.try_into() {
            Option::Some(data) => data,
            Option::None => (data & MAX_U64).try_into().unwrap(),
        };

        Word64 { data }
    }
}


fn ch(x: Word64, y: Word64, z: Word64) -> Word64 {
    (x & y) ^ (~x & z)
}

fn maj(x: Word64, y: Word64, z: Word64) -> Word64 {
    (x & y) ^ (x & z) ^ (y & z)
}

/// Performs x.rotr(28) ^ x.rotr(34) ^ x.rotr(39),
/// Using precomputed values to avoid recomputation
fn bsig0(x: Word64) -> Word64 {
    // x.rotr(28) ^ x.rotr(34) ^ x.rotr(39)
    x.rotr_precomputed(TWO_POW_28, TWO_POW_64_MINUS_28)
        ^ x.rotr_precomputed(TWO_POW_34, TWO_POW_64_MINUS_34)
        ^ x.rotr_precomputed(TWO_POW_39, TWO_POW_64_MINUS_39)
}

/// Performs x.rotr(14) ^ x.rotr(18) ^ x.rotr(41),
/// Using precomputed values to avoid recomputation
fn bsig1(x: Word64) -> Word64 {
    // x.rotr(14) ^ x.rotr(18) ^ x.rotr(41)
    x.rotr_precomputed(TWO_POW_14, TWO_POW_64_MINUS_14)
        ^ x.rotr_precomputed(TWO_POW_18, TWO_POW_64_MINUS_18)
        ^ x.rotr_precomputed(TWO_POW_41, TWO_POW_64_MINUS_41)
}

/// Performs x.rotr(1) ^ x.rotr(8) ^ x.shr(7),
/// Using precomputed values to avoid recomputation
fn ssig0(x: Word64) -> Word64 {
    // x.rotr(1) ^ x.rotr(8) ^ x.shr(7)
    x.rotr_precomputed(TWO_POW_1, TWO_POW_64_MINUS_1)
        ^ x.rotr_precomputed(TWO_POW_8, TWO_POW_64_MINUS_8)
        ^ math_shr_precomputed::<u64>(x.data.into(), TWO_POW_7).into() // 2 ** 7
}

/// Performs x.rotr(19) ^ x.rotr(61) ^ x.shr(6),
/// Using precomputed values to avoid recomputation
fn ssig1(x: Word64) -> Word64 {
    // x.rotr(19) ^ x.rotr(61) ^ x.shr(6)
    x.rotr_precomputed(TWO_POW_19, TWO_POW_64_MINUS_19)
        ^ x.rotr_precomputed(TWO_POW_61, TWO_POW_64_MINUS_61)
        ^ math_shr_precomputed::<u64>(x.data, TWO_POW_64_MINUS_6).into() // 2 ** 6
}

const two_squarings: [u64; 6] = [
    TWO_POW_1, TWO_POW_2, TWO_POW_4, TWO_POW_8, TWO_POW_16, TWO_POW_32,
];

// Shift left with precomputed powers of 2
fn math_shl_precomputed<T, +Mul<T>, +Rem<T>, +Drop<T>, +Copy<T>, +Into<T, u128>>(
    x: T, two_power_n: T,
) -> T {
    x * two_power_n
}

// Shift right with precomputed powers of 2
fn math_shr_precomputed<T, +Div<T>, +Rem<T>, +Drop<T>, +Copy<T>, +Into<T, u128>>(
    x: T, two_power_n: T,
) -> T {
    x / two_power_n
}

fn add_trailing_zeroes(ref data: Array<u8>, msg_len: usize) {
    let mdi = msg_len % 128;
    let padding_len = if (mdi < 112) {
        119 - mdi
    } else {
        247 - mdi
    };

    let mut i = 0;
    while (i != padding_len) {
        data.append(0);
        i += 1;
    };
}

fn from_u8Array_to_WordArray(data: Array<u8>) -> Array<Word64> {
    let mut new_arr: Array<Word64> = array![];
    let mut i = 0;

    // Use precomputed powers of 2 for shift left to avoid recomputation
    // Safe to use u64 coz we shift u8 to the left by max 56 bits in u64
    while (i != data.len()) {
        let new_word: u64 = math_shl_precomputed::<u64>((*data[i + 0]).into(), TWO_POW_56)
            + math_shl_precomputed((*data[i + 1]).into(), TWO_POW_48)
            + math_shl_precomputed((*data[i + 2]).into(), TWO_POW_40)
            + math_shl_precomputed((*data[i + 3]).into(), TWO_POW_32)
            + math_shl_precomputed((*data[i + 4]).into(), TWO_POW_24)
            + math_shl_precomputed((*data[i + 5]).into(), TWO_POW_16)
            + math_shl_precomputed((*data[i + 6]).into(), TWO_POW_8)
            + math_shl_precomputed((*data[i + 7]).into(), TWO_POW_0);
        new_arr.append(Word64 { data: new_word });
        i += 8;
    }
    new_arr
}

fn from_WordArray_to_u8array(data: Span<Word64>) -> Array<u8> {
    let mut arr: Array<u8> = array![];

    let mut i = 0;
    // Use precomputed powers of 2 for shift right to avoid recomputation
    while (i != data.len()) {
        let mut res = math_shr_precomputed((*data.at(i).data).into(), TWO_POW_56) & MAX_U8;
        arr.append(res.try_into().unwrap());
        res = math_shr_precomputed((*data.at(i).data).into(), TWO_POW_48) & MAX_U8;
        arr.append(res.try_into().unwrap());
        res = math_shr_precomputed((*data.at(i).data).into(), TWO_POW_40) & MAX_U8;
        arr.append(res.try_into().unwrap());
        res = math_shr_precomputed((*data.at(i).data).into(), TWO_POW_32) & MAX_U8;
        arr.append(res.try_into().unwrap());
        res = math_shr_precomputed((*data.at(i).data).into(), TWO_POW_24) & MAX_U8;
        arr.append(res.try_into().unwrap());
        res = math_shr_precomputed((*data.at(i).data).into(), TWO_POW_16) & MAX_U8;
        arr.append(res.try_into().unwrap());
        res = math_shr_precomputed((*data.at(i).data).into(), TWO_POW_8) & MAX_U8;
        arr.append(res.try_into().unwrap());
        res = math_shr_precomputed((*data.at(i).data).into(), TWO_POW_0) & MAX_U8;
        arr.append(res.try_into().unwrap());
        i += 1;
    }
    arr
}

fn digest_hash(data: Span<Word64>, msg_len: usize) -> Array<Word64> {
    let k = K.span();
    let mut h = H.span();

    let block_nb = msg_len / 128;

    let [mut h_0, mut h_1, mut h_2, mut h_3, mut h_4, mut h_5, mut h_6, mut h_7] = (*h.multi_pop_front::<8>().unwrap()).unbox();

    let mut i = 0;

    while (i != block_nb) {
        // Prepare message schedule
        let mut t: usize = 0;

        let mut W: Array<Word64> = array![];
        while (t != 80) {
            if t < 16 {
                W.append(*data.at(i * 16 + t));
            } else {
                let buf = ssig1(*W.at(t - 2)) + *W.at(t - 7) + ssig0(*W.at(t - 15)) + *W.at(t - 16);
                W.append(buf);
            }
            t += 1;
        }

        let mut a = h_0;
        let mut b = h_1;
        let mut c = h_2;
        let mut d = h_3;
        let mut e = h_4;
        let mut f = h_5;
        let mut g = h_6;
        let mut h = h_7;

        let mut W = W.span();
        for _k in k {
            let T1 = h + bsig1(e) + ch(e, f, g) + *_k + *W.pop_front().unwrap();
            let T2 = bsig0(a) + maj(a, b, c);
            h = g;
            g = f;
            f = e;
            e = d + T1;
            d = c;
            c = b;
            b = a;
            a = T1 + T2;
        }

        h_0 = a + h_0;
        h_1 = b + h_1;
        h_2 = c + h_2;
        h_3 = d + h_3;
        h_4 = e + h_4;
        h_5 = f + h_5;
        h_6 = g + h_6;
        h_7 = h + h_7;

        i += 1;
    }

    array![h_0, h_1, h_2, h_3, h_4, h_5, h_6, h_7]
}

pub fn sha512(mut data: Array<u8>) -> Array<u8> {
    let hash = _sha512(data);
    from_WordArray_to_u8array(hash.span())
}

pub fn _sha512(mut data: Array<u8>) -> Array<Word64> {
    let bit_numbers: u128 = data.len().into() * 8;
    // any u32 * 8 fits in u64
    // let bit_numbers = bit_numbers & Bounded::<u64>::MAX.into();

    let max_u8: u128 = MAX_U8.into();
    let mut msg_len = data.len();

    // Appends 1
    data.append(0x80);

    add_trailing_zeroes(ref data, msg_len);

    // add length to the end
    // Use precomputed powers of 2 for shift right to avoid recomputation
    let mut res: u128 = math_shr_precomputed(bit_numbers, TWO_POW_56.into()) & max_u8;
    data.append(res.try_into().unwrap());
    res = math_shr_precomputed(bit_numbers, TWO_POW_48.into()) & max_u8;
    data.append(res.try_into().unwrap());
    res = math_shr_precomputed(bit_numbers, TWO_POW_40.into()) & max_u8;
    data.append(res.try_into().unwrap());
    res = math_shr_precomputed(bit_numbers, TWO_POW_32.into()) & max_u8;
    data.append(res.try_into().unwrap());
    res = math_shr_precomputed(bit_numbers, TWO_POW_24.into()) & max_u8;
    data.append(res.try_into().unwrap());
    res = math_shr_precomputed(bit_numbers, TWO_POW_16.into()) & max_u8;
    data.append(res.try_into().unwrap());
    res = math_shr_precomputed(bit_numbers, TWO_POW_8.into()) & max_u8;
    data.append(res.try_into().unwrap());
    res = math_shr_precomputed(bit_numbers, TWO_POW_0.into()) & max_u8;
    data.append(res.try_into().unwrap());

    msg_len = data.len();

    let mut data = from_u8Array_to_WordArray(data);

    let hash = digest_hash(data.span(), msg_len);
    hash
}


const H: [Word64; 8] = [
    Word64 { data: 0x6a09e667f3bcc908 }, Word64 { data: 0xbb67ae8584caa73b },
    Word64 { data: 0x3c6ef372fe94f82b }, Word64 { data: 0xa54ff53a5f1d36f1 },
    Word64 { data: 0x510e527fade682d1 }, Word64 { data: 0x9b05688c2b3e6c1f },
    Word64 { data: 0x1f83d9abfb41bd6b }, Word64 { data: 0x5be0cd19137e2179 },
];


const K: [Word64; 80] = [
    Word64 { data: 0x428a2f98d728ae22 }, Word64 { data: 0x7137449123ef65cd },
    Word64 { data: 0xb5c0fbcfec4d3b2f }, Word64 { data: 0xe9b5dba58189dbbc },
    Word64 { data: 0x3956c25bf348b538 }, Word64 { data: 0x59f111f1b605d019 },
    Word64 { data: 0x923f82a4af194f9b }, Word64 { data: 0xab1c5ed5da6d8118 },
    Word64 { data: 0xd807aa98a3030242 }, Word64 { data: 0x12835b0145706fbe },
    Word64 { data: 0x243185be4ee4b28c }, Word64 { data: 0x550c7dc3d5ffb4e2 },
    Word64 { data: 0x72be5d74f27b896f }, Word64 { data: 0x80deb1fe3b1696b1 },
    Word64 { data: 0x9bdc06a725c71235 }, Word64 { data: 0xc19bf174cf692694 },
    Word64 { data: 0xe49b69c19ef14ad2 }, Word64 { data: 0xefbe4786384f25e3 },
    Word64 { data: 0x0fc19dc68b8cd5b5 }, Word64 { data: 0x240ca1cc77ac9c65 },
    Word64 { data: 0x2de92c6f592b0275 }, Word64 { data: 0x4a7484aa6ea6e483 },
    Word64 { data: 0x5cb0a9dcbd41fbd4 }, Word64 { data: 0x76f988da831153b5 },
    Word64 { data: 0x983e5152ee66dfab }, Word64 { data: 0xa831c66d2db43210 },
    Word64 { data: 0xb00327c898fb213f }, Word64 { data: 0xbf597fc7beef0ee4 },
    Word64 { data: 0xc6e00bf33da88fc2 }, Word64 { data: 0xd5a79147930aa725 },
    Word64 { data: 0x06ca6351e003826f }, Word64 { data: 0x142929670a0e6e70 },
    Word64 { data: 0x27b70a8546d22ffc }, Word64 { data: 0x2e1b21385c26c926 },
    Word64 { data: 0x4d2c6dfc5ac42aed }, Word64 { data: 0x53380d139d95b3df },
    Word64 { data: 0x650a73548baf63de }, Word64 { data: 0x766a0abb3c77b2a8 },
    Word64 { data: 0x81c2c92e47edaee6 }, Word64 { data: 0x92722c851482353b },
    Word64 { data: 0xa2bfe8a14cf10364 }, Word64 { data: 0xa81a664bbc423001 },
    Word64 { data: 0xc24b8b70d0f89791 }, Word64 { data: 0xc76c51a30654be30 },
    Word64 { data: 0xd192e819d6ef5218 }, Word64 { data: 0xd69906245565a910 },
    Word64 { data: 0xf40e35855771202a }, Word64 { data: 0x106aa07032bbd1b8 },
    Word64 { data: 0x19a4c116b8d2d0c8 }, Word64 { data: 0x1e376c085141ab53 },
    Word64 { data: 0x2748774cdf8eeb99 }, Word64 { data: 0x34b0bcb5e19b48a8 },
    Word64 { data: 0x391c0cb3c5c95a63 }, Word64 { data: 0x4ed8aa4ae3418acb },
    Word64 { data: 0x5b9cca4f7763e373 }, Word64 { data: 0x682e6ff3d6b2b8a3 },
    Word64 { data: 0x748f82ee5defb2fc }, Word64 { data: 0x78a5636f43172f60 },
    Word64 { data: 0x84c87814a1f0ab72 }, Word64 { data: 0x8cc702081a6439ec },
    Word64 { data: 0x90befffa23631e28 }, Word64 { data: 0xa4506cebde82bde9 },
    Word64 { data: 0xbef9a3f7b2c67915 }, Word64 { data: 0xc67178f2e372532b },
    Word64 { data: 0xca273eceea26619c }, Word64 { data: 0xd186b8c721c0c207 },
    Word64 { data: 0xeada7dd6cde0eb1e }, Word64 { data: 0xf57d4f7fee6ed178 },
    Word64 { data: 0x06f067aa72176fba }, Word64 { data: 0x0a637dc5a2c898a6 },
    Word64 { data: 0x113f9804bef90dae }, Word64 { data: 0x1b710b35131c471b },
    Word64 { data: 0x28db77f523047d84 }, Word64 { data: 0x32caab7b40c72493 },
    Word64 { data: 0x3c9ebe0a15c9bebc }, Word64 { data: 0x431d67c49c100d4c },
    Word64 { data: 0x4cc5d4becb3e42b6 }, Word64 { data: 0x597f299cfc657e2a },
    Word64 { data: 0x5fcb6fab3ad6faec }, Word64 { data: 0x6c44198c4a475817 },
];


#[cfg(test)]
mod sha512_test {
    use super::{Word64WordOperations, sha512};

    fn get_lorem_ipsum() -> Array<u8> {
        let mut input: Array<u8> = array![
            0x4C,
            0x6F,
            0x72,
            0x65,
            0x6D,
            0x20,
            0x69,
            0x70,
            0x73,
            0x75,
            0x6D,
            0x2C,
            0x20,
            0x6F,
            0x72,
            0x20,
            0x6C,
            0x73,
            0x69,
            0x70,
            0x73,
            0x75,
            0x6D,
            0x20,
            0x61,
            0x73,
            0x20,
            0x69,
            0x74,
            0x20,
            0x69,
            0x73,
            0x20,
            0x73,
            0x6F,
            0x6D,
            0x65,
            0x74,
            0x69,
            0x6D,
            0x65,
            0x73,
            0x20,
            0x6B,
            0x6E,
            0x6F,
            0x77,
            0x6E,
            0x2C,
            0x20,
            0x69,
            0x73,
            0x20,
            0x64,
            0x75,
            0x6D,
            0x6D,
            0x79,
            0x20,
            0x74,
            0x65,
            0x78,
            0x74,
            0x20,
            0x75,
            0x73,
            0x65,
            0x64,
            0x20,
            0x69,
            0x6E,
            0x20,
            0x6C,
            0x61,
            0x79,
            0x69,
            0x6E,
            0x67,
            0x20,
            0x6F,
            0x75,
            0x74,
            0x20,
            0x70,
            0x72,
            0x69,
            0x6E,
            0x74,
            0x2C,
            0x20,
            0x67,
            0x72,
            0x61,
            0x70,
            0x68,
            0x69,
            0x63,
            0x20,
            0x6F,
            0x72,
            0x20,
            0x77,
            0x65,
            0x62,
            0x20,
            0x64,
            0x65,
            0x73,
            0x69,
            0x67,
            0x6E,
            0x73,
            0x2E,
            0x20,
            0x54,
            0x68,
            0x65,
            0x20,
            0x70,
            0x61,
            0x73,
            0x73,
            0x61,
            0x67,
            0x65,
            0x20,
            0x69,
            0x73,
            0x20,
            0x61,
            0x74,
            0x74,
            0x72,
            0x69,
            0x62,
            0x75,
            0x74,
            0x65,
            0x64,
            0x20,
            0x74,
            0x6F,
            0x20,
            0x61,
            0x6E,
            0x20,
            0x75,
            0x6E,
            0x6B,
            0x6E,
            0x6F,
            0x77,
            0x6E,
            0x20,
            0x74,
            0x79,
            0x70,
            0x65,
            0x73,
            0x65,
            0x74,
            0x74,
            0x65,
            0x72,
            0x20,
            0x69,
            0x6E,
            0x20,
            0x74,
            0x68,
            0x65,
            0x20,
            0x31,
            0x35,
            0x74,
            0x68,
            0x20,
            0x63,
            0x65,
            0x6E,
            0x74,
            0x75,
            0x72,
            0x79,
            0x20,
            0x77,
            0x68,
            0x6F,
            0x20,
            0x69,
            0x73,
            0x20,
            0x74,
            0x68,
            0x6F,
            0x75,
            0x67,
            0x68,
            0x74,
            0x20,
            0x74,
            0x6F,
            0x20,
            0x68,
            0x61,
            0x76,
            0x65,
            0x20,
            0x73,
            0x63,
            0x72,
            0x61,
            0x6D,
            0x62,
            0x6C,
            0x65,
            0x64,
            0x20,
            0x70,
            0x61,
            0x72,
            0x74,
            0x73,
            0x20,
            0x6F,
            0x66,
            0x20,
            0x43,
            0x69,
            0x63,
            0x65,
            0x72,
            0x6F,
            0x27,
            0x73,
            0x20,
            0x44,
            0x65,
            0x20,
            0x46,
            0x69,
            0x6E,
            0x69,
            0x62,
            0x75,
            0x73,
            0x20,
            0x42,
            0x6F,
            0x6E,
            0x6F,
            0x72,
            0x75,
            0x6D,
            0x20,
            0x65,
            0x74,
            0x20,
            0x4D,
            0x61,
            0x6C,
            0x6F,
            0x72,
            0x75,
            0x6D,
            0x20,
            0x66,
            0x6F,
            0x72,
            0x20,
            0x75,
            0x73,
            0x65,
            0x20,
            0x69,
            0x6E,
            0x20,
            0x61,
            0x20,
            0x74,
            0x79,
            0x70,
            0x65,
            0x20,
            0x73,
            0x70,
            0x65,
            0x63,
            0x69,
            0x6D,
            0x65,
            0x6E,
            0x20,
            0x62,
            0x6F,
            0x6F,
            0x6B,
            0x2E,
            0x20,
            0x49,
            0x74,
            0x20,
            0x75,
            0x73,
            0x75,
            0x61,
            0x6C,
            0x6C,
            0x79,
            0x20,
            0x62,
            0x65,
            0x67,
            0x69,
            0x6E,
            0x73,
            0x20,
            0x77,
            0x69,
            0x74,
            0x68,
        ];
        input
    }

    #[test]
    #[available_gas(20000000000)]
    fn test_sha512_lorem_ipsum() {
        let msg = get_lorem_ipsum();
        let res = sha512(msg).span();

        assert_eq!(
            res,
            array![
                0xd5,
                0xa2,
                0xe1,
                0x4e,
                0xf4,
                0x20,
                0xf8,
                0x2d,
                0x68,
                0x2b,
                0x19,
                0xc3,
                0xd0,
                0x70,
                0xf4,
                0x81,
                0x14,
                0xcb,
                0xb9,
                0x74,
                0x7c,
                0x7d,
                0xb1,
                0x15,
                0xce,
                0xa5,
                0x41,
                0x3e,
                0xf8,
                0xcb,
                0x8f,
                0xba,
                0xc6,
                0x90,
                0x17,
                0xc5,
                0x17,
                0x0f,
                0x01,
                0xc4,
                0x77,
                0xb3,
                0xdf,
                0x3d,
                0xfb,
                0x34,
                0xd3,
                0x50,
                0x8f,
                0xa0,
                0xb2,
                0xb1,
                0x37,
                0xd4,
                0xcb,
                0x54,
                0x60,
                0x9e,
                0x63,
                0x3d,
                0x14,
                0x45,
                0x82,
                0xc9,
            ]
                .span(),
        );
    }

    #[test]
    #[available_gas(20000000000)]
    fn test_sha512_size_one() {
        let mut arr: Array<u8> = array![49];
        let res = sha512(arr).span();

        assert_eq!(
            res,
            array![
                0x4d,
                0xff,
                0x4e,
                0xa3,
                0x40,
                0xf0,
                0xa8,
                0x23,
                0xf1,
                0x5d,
                0x3f,
                0x4f,
                0x01,
                0xab,
                0x62,
                0xea,
                0xe0,
                0xe5,
                0xda,
                0x57,
                0x9c,
                0xcb,
                0x85,
                0x1f,
                0x8d,
                0xb9,
                0xdf,
                0xe8,
                0x4c,
                0x58,
                0xb2,
                0xb3,
                0x7b,
                0x89,
                0x90,
                0x3a,
                0x74,
                0x0e,
                0x1e,
                0xe1,
                0x72,
                0xda,
                0x79,
                0x3a,
                0x6e,
                0x79,
                0xd5,
                0x60,
                0xe5,
                0xf7,
                0xf9,
                0xbd,
                0x05,
                0x8a,
                0x12,
                0xa2,
                0x80,
                0x43,
                0x3e,
                0xd6,
                0xfa,
                0x46,
                0x51,
                0x0a,
            ]
                .span(),
        );
    }

    #[test]
    #[available_gas(20000000000)]
    fn test_size_zero() {
        let msg = array![];

        let res = sha512(msg).span();

        assert_eq!(
            res,
            array![
                0xcf,
                0x83,
                0xe1,
                0x35,
                0x7e,
                0xef,
                0xb8,
                0xbd,
                0xf1,
                0x54,
                0x28,
                0x50,
                0xd6,
                0x6d,
                0x80,
                0x07,
                0xd6,
                0x20,
                0xe4,
                0x05,
                0x0b,
                0x57,
                0x15,
                0xdc,
                0x83,
                0xf4,
                0xa9,
                0x21,
                0xd3,
                0x6c,
                0xe9,
                0xce,
                0x47,
                0xd0,
                0xd1,
                0x3c,
                0x5d,
                0x85,
                0xf2,
                0xb0,
                0xff,
                0x83,
                0x18,
                0xd2,
                0x87,
                0x7e,
                0xec,
                0x2f,
                0x63,
                0xb9,
                0x31,
                0xbd,
                0x47,
                0x41,
                0x7a,
                0x81,
                0xa5,
                0x38,
                0x32,
                0x7a,
                0xf9,
                0x27,
                0xda,
                0x3e,
            ]
                .span(),
        );
    }
}
