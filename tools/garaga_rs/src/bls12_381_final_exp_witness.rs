use ark_bls12_381::Fq12;
use ark_ff::{Field, Zero};
use num_bigint::BigInt;

pub fn get_final_exp_witness(f: Fq12) -> (Fq12, Fq12) {
    return get_root_and_scaling_factor_bls(f)
}

use std::fs::OpenOptions;
use std::io::prelude::*;

fn init() -> (BigInt, BigInt, BigInt) {
    let x: BigInt = -BigInt::from(0xD201000000010000u64); // CURVES[CurveID.BLS12_381.value].x
    let k = 12;
    let r: BigInt = x.pow(4) - x.pow(2) + 1;
    let q: BigInt = (x.clone() - BigInt::from(1)).pow(2) / 3 * r.clone() + x.clone();
    let h: BigInt = (q.pow(k) - 1) / r.clone();

    let lam = -x + q.clone();
    let m = lam.clone() / r;

    let p = BigInt::from(5044125407647214251u64);
    let h3 = h.clone() / (27 * p.clone());

    let e = lam.modinv(&h3).unwrap();
    let s: BigInt = ((p.clone() * 27 - 1) * h3.modinv(&(p.clone() * 27)).unwrap()) % (p.clone() * 27);

    assert!(h % (27 * p.clone()) == BigInt::zero());
    assert!(m == 3 * p.pow(2));

    assert!(gcd(BigInt::from(3), h3.clone()) == BigInt::from(1));
    assert!(gcd(p.pow(2), h3.clone()) == BigInt::from(1));
    assert!(gcd(p.clone(), h3.clone()) == BigInt::from(1));
    assert!(gcd(p.clone(), 27 * h3.clone()) == BigInt::from(1));
    assert!(gcd(BigInt::from(27), p * h3.clone()) == BigInt::from(1));

    assert!((q.pow(3) - 1) % 27 == BigInt::zero());

    let file_path = "/tmp/output.txt";
    let mut file = OpenOptions::new()
        .write(true)
        .append(true)
        .open(file_path).unwrap();
    writeln!(file, "{}", h3.to_string()).unwrap();
    writeln!(file, "{}", s.to_string()).unwrap();
    writeln!(file, "{}", e.to_string()).unwrap();

    return (h3, s, e);
}

fn get_root_and_scaling_factor_bls(mlo: Fq12) -> (Fq12, Fq12) {
    let (h3, s, e) = init();
    /*
     * Takes a miller loop output and returns root, shift such that
     * root**lam = shift * mlo, if and only if mlo**h == 1.
     */
    let x = mlo.pow(&bigint_to_u64ref_le(&h3));
    let shift = x.pow(&bigint_to_u64ref_le(&s));
    let root = (shift * mlo).pow(&bigint_to_u64ref_le(&e));
    return (root, shift);
}

fn gcd(a: BigInt, b: BigInt) -> BigInt {
    let mut a = a;
    let mut b = b;
    while b != BigInt::zero() {
        let temp = b.clone();
        b = a % &b;
        a = temp;
    }
    a
}

fn bigint_to_u64ref_le(bigint: &BigInt) -> Vec<u64> {
    let bytes = bigint.to_bytes_le().1;
    let num_words = (bytes.len() + 7) / 8;
    let mut u64_words = Vec::with_capacity(num_words);
    for chunk in bytes.chunks(8) {
        let mut word = [0u8; 8];
        word[..chunk.len()].copy_from_slice(chunk);
        let u64_word = u64::from_le_bytes(word);
        u64_words.push(u64_word);
    }
    u64_words
}
