use ark_bls12_381::Fq12;
use ark_ff::Field;
use num_bigint::BigInt;

pub fn get_final_exp_witness(f: Fq12) -> (Fq12, Fq12) {
    return get_root_and_scaling_factor_bls(f)
}

fn init() -> (BigInt, BigInt, BigInt) {
    let x = -BigInt::from(0xD201000000010000u64); // CURVES[CurveID.BLS12_381.value].x
    let k = 12;
    let r = x.pow(4) - x.pow(2) + 1;
    let q: BigInt = (&x - BigInt::from(1)).pow(2) / 3 * &r + &x;
    let h = (q.pow(k) - 1) / &r;

    let lam = -&x + &q;
    let m = &lam / &r;

    let p = BigInt::from(5044125407647214251u64);
    let h3 = &h / (27 * &p);

    let e = lam.modinv(&h3).unwrap();
    let s = ((&p * 27 - 1) * h3.modinv(&(&p * 27)).unwrap()) % (&p * 27);

    assert!(h % (27 * &p) == BigInt::from(0));
    assert!(m == 3 * p.pow(2));

    assert!(gcd(&BigInt::from(3), &h3) == BigInt::from(1));
    assert!(gcd(&p.pow(2), &h3) == BigInt::from(1));
    assert!(gcd(&p, &h3) == BigInt::from(1));
    assert!(gcd(&p, &(27 * &h3)) == BigInt::from(1));
    assert!(gcd(&BigInt::from(27), &(&p * &h3)) == BigInt::from(1));

    assert!((q.pow(3) - 1) % 27 == BigInt::from(0));

    return (h3, s, e);
}

fn get_root_and_scaling_factor_bls(mlo: Fq12) -> (Fq12, Fq12) {
    /*
     * Takes a miller loop output and returns root, shift such that
     * root**lam = shift * mlo, if and only if mlo**h == 1.
     */
    let (h3, s, e) = init();
    let x = mlo.pow(&to_words_le(&h3));
    let shift = x.pow(&to_words_le(&s));
    let root = (shift * mlo).pow(&to_words_le(&e));
    return (root, shift);
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
