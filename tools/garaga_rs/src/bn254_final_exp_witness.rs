use ark_bn254::{Fq, Fq2, Fq6, Fq12, Fr};
use ark_ff::{BigInteger, Field, One, PrimeField, Zero};
use num_bigint::BigInt;
use std::str::FromStr;

pub fn get_final_exp_witness(f: Fq12) -> (Fq12, Fq12) {
    return find_c_e12(f, get_27th_bn254_root());
}

fn get_27th_bn254_root() -> Fq12 {
    let c0_c2_c0 = Fq::from_str("8204864362109909869166472767738877274689483185363591877943943203703805152849").unwrap();
    let c0_c2_c1 = Fq::from_str("17912368812864921115467448876996876278487602260484145953989158612875588124088").unwrap();
    Fq12::new(
        Fq6::new(Fq2::zero(), Fq2::zero(), Fq2::new(c0_c2_c0, c0_c2_c1)),
        Fq6::zero(),
    )
}

fn find_c_e12(f: Fq12, w: Fq12) -> (Fq12, Fq12) {
    // Algorithm 5: Algorithm for computing λ residues over BN curve
    // Input: Output of a Miller loop f and fixed 27-th root of unity w
    // Output: (c, wi) such that c**λ = f · wi
    // 1 s = 0
    let mut s = 0;
    let q = to_bigint(&Fq::MODULUS);
    let exp = to_words_le(&((q.pow(12) - 1) / 3));
    let fp12_one = Fq12::one();
    let mut c: Fq12;
    // 2 if f**(q**k-1)/3 = 1 then
    if f.pow(&exp) == fp12_one {
        // 3 continue
        // 4 end
        // 5 else if (f · w)**(q**k-1)/3 = 1 then
        c = f;
    }
    else
    if (f * w).pow(&exp) == fp12_one {
        // 6 s = 1
        s = 1;
        // 7 f ← f · w
        c = f * w;
    }
    // 8 end
    // 9 else
    else {
        // 10 s = 2
        s = 2;
        // 11 f ← f · w**2
        c = f * w * w;
    }
    // 12 end
    // 13 c ← f**r′
    c = get_rth_root(c);
    // 14 c ← c**m′′
    c = get_m_dash_root(c);
    // 15 c ← c**1/3 (by using modified Tonelli-Shanks 4)
    c = find_cube_root(c, w, q);
    // 16 return (c, ws)
    return (c, w.pow([s]));
}

fn get_rth_root(f: Fq12) -> Fq12 {
    /*
     * Computes x such that x^r = f
     */
    let r = to_bigint(&Fr::MODULUS);
    let p = to_bigint(&Fq::MODULUS);
    let h = (p.pow(12) - 1) / &r;
    let r_inv = r.modinv(&h).unwrap();
    let res = f.pow(to_words_le(&r_inv));
    return res;
}

fn get_m_dash_root(f: Fq12) -> Fq12 {
    let q = to_bigint(&Fq::MODULUS);
    let x = BigInt::from(0x44E992B44A6909F1u64); // CURVES[f.curve_id].x
    let r = to_bigint(&Fr::MODULUS);

    let h = (q.pow(12) - BigInt::from(1)) / &r;  // = 3^3 · l # where gcd(l, 3) = 1
    assert!(gcd(&r, &h) == BigInt::from(1));
    let base = 3;
    let (k, l) = decompose_scalar_into_b_powers_and_remainder(&h, base);
    assert!(base.pow(k) * &l == h, "3^k * l should be h");
    assert!(&h % (base.pow(k)) == BigInt::from(0), "h should be a multiple of 3^k");
    assert!(gcd(&l, &BigInt::from(base)) == BigInt::from(1), "l should be coprime with 3");

    let lam: BigInt = 6 * &x + 2 + &q - q.pow(2) + q.pow(3);  // https://eprint.iacr.org/2008/096.pdf See section 4 for BN curves.

    assert!(&lam % &r == BigInt::from(0), "λ should be a multiple of r. See section 4.2.2");
    let m = &lam / &r;
    let d = gcd(&m, &h);

    assert!(&m % &d == BigInt::from(0), "m should be a multiple of d");
    let m_dash = &m / &d;  // m' = m/d
    assert!(&m_dash % &h != BigInt::from(0), "m/d should not divide h. See section 4.2.2 Theorem 2.");
    assert!(&d * &r * &m_dash == lam, "incorrect parameters");  // sanity check
    assert!(gcd(&lam, &(q.pow(12) - BigInt::from(1))) == &d * &r);
    assert!(gcd(&m_dash, &(q.pow(12) - BigInt::from(1))) == BigInt::from(1), "m_dash should be coprime with q**12 - 1 'by construction'. See 4.3.2 computing m-th root");
    let m_d_inv = m_dash.modinv(&h).unwrap();

    return f.pow(to_words_le(&m_d_inv));
}

fn find_cube_root(a: Fq12, w: Fq12, q: BigInt) -> Fq12 {
    // Algorithm 4: Modified Tonelli-Shanks for cube roots
    // Input: Cube residue a, cube non residue w and write p − 1 = 3^r · s such that 3 ∤ s
    // Output: x such that x^3 = a
    // 1 exp = (s + 1)/3
    let (_, s) = decompose_scalar_into_b_powers_and_remainder(&(q.pow(12) - 1), 3);
    let exp = (&s + 1) / 3;
    let a_inv = Fq12::one() / a;
    // 2 x ← a^exp
    let mut x = a.pow(to_words_le(&exp));
    // 3 3^t ← ord((x^3)/a)
    let mut t = pow_3_ord(x.pow([3]) * a_inv);
    // 4 while t != 0 do
    while t != 0 {
        // 5 exp = (s + 1)/3
        // 6 x ← x · w^exp
        x = x * w.pow(to_words_le(&exp));
        // 7 3^t ← ord(x^3/a)
        t = pow_3_ord(x.pow([3]) * a_inv);
    }
    // 8 end
    // 9 return x
    return x;
}

fn decompose_scalar_into_b_powers_and_remainder(scalar: &BigInt, b: usize) -> (u32, BigInt) {
    /*
     * Decompose scalar into b^k * l, where l is not divisible by b.
     */
    let mut k: u32 = 0;
    let mut l: BigInt = scalar.clone();
    while &l % b == BigInt::from(0) {
        l /= b;
        k += 1;
    }
    assert!(&l % b != BigInt::from(0), "l should not be divisible by b");
    assert!(*scalar == b.pow(k) * &l, "scalar should be the product of b^k * l");
    return (k, l);
}

fn pow_3_ord(a: Fq12) -> usize {
    let mut t = 0;
    let mut a = a;
    let fp12_one = Fq12::one();
    while a != fp12_one {
        t += 1;
        a = a.pow([3]);
    }
    return t;
}

fn gcd(a: &BigInt, b: &BigInt) -> BigInt {
    let mut a = a.clone();
    let mut b = b.clone();
    while b != BigInt::from(0) {
        (a, b) = (b.clone(), a % b);
    }
    return a;
}

fn to_words_le(bigint: &BigInt) -> Vec<u64> {
    let (sign, bytes) = bigint.to_bytes_le();
    assert!(sign != num_bigint::Sign::Minus);
    let mut words = Vec::with_capacity((bytes.len() + 7) / 8);
    for chunk in bytes.chunks(8) {
        let mut word = [0u8; 8];
        word[..chunk.len()].copy_from_slice(chunk);
        words.push(u64::from_le_bytes(word));
    }
    return words;
}

fn to_bigint(v: &ark_ff::BigInt<4>) -> BigInt {
    return BigInt::from_bytes_be(num_bigint::Sign::Plus, &v.to_bytes_be());
}
