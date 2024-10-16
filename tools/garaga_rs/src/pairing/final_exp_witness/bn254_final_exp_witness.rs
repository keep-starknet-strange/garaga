use ark_bn254::{Fq, Fq12, Fq2, Fq6};
use ark_ff::{Field, One, Zero};
use std::str::FromStr;

/// Algorithm 5: Algorithm for computing λ residues over BN curve
/// Input: Output of a Miller loop f
/// Output: (c, wi) such that c ** λ = f * wi
pub fn get_final_exp_witness(f: Fq12) -> (Fq12, Fq12) {
    // fixed 27-th root of unity
    let w = get_27th_root();
    // case 1: f ** ((q ** k - 1) / 3) = 1
    let mut c = f;
    let mut ws = Fq12::one();
    if c.pow(EXP) != Fq12::one() {
        // case 2: (f * w) ** ((q ** k - 1) / 3) = 1
        c *= w;
        ws *= w;
        if c.pow(EXP) != Fq12::one() {
            // case 3: (f * w * w) ** ((q ** k - 1) / 3) = 1
            c *= w;
            ws *= w;
        }
    }
    // c <- f ** (r′ * m′′)
    c = c.pow(R_M_D_INV);
    // c <- c ** (1 / 3) (by using modified Tonelli-Shanks 4)
    (find_cube_root(c, w), ws)
}

fn get_27th_root() -> Fq12 {
    Fq12::new(
        Fq6::new(
            Fq2::zero(),
            Fq2::zero(),
            Fq2::new(
                Fq::from_str(
                    "8204864362109909869166472767738877274689483185363591877943943203703805152849",
                )
                .unwrap(),
                Fq::from_str(
                    "17912368812864921115467448876996876278487602260484145953989158612875588124088",
                )
                .unwrap(),
            ),
        ),
        Fq6::zero(),
    )
}

/// Algorithm 4: Modified Tonelli-Shanks for cube roots
/// Input: Cube residue a, cube non residue w
/// Output: x such that x^3 = a
fn find_cube_root(a: Fq12, w: Fq12) -> Fq12 {
    let a_inv = a.inverse().unwrap();
    let we = w.pow(EXP0);
    let mut x = a.pow(EXP0);
    let mut t = pow_3_ord(x.pow([3]) * a_inv);
    while t != 0 {
        x *= we;
        t = pow_3_ord(x.pow([3]) * a_inv);
    }
    x
}

fn pow_3_ord(a: Fq12) -> usize {
    let mut a = a;
    let mut t = 0;
    while a != Fq12::one() {
        a = a.pow([3]);
        t += 1;
    }
    t
}

// (q ** k - 1) / 3
const EXP: [u64; 48] = [
    0xeb46f64643825060,
    0xc09504ce57838ff3,
    0xb6973b1dfda111a7,
    0x9e6a6b1d46fc408c,
    0x745bdaf039c199f6,
    0xe9f65a41395df713,
    0x4dcd3d267739953c,
    0x9f49699c7d2e3b27,
    0xb189f37c0ecd514e,
    0x55aa926463b3f1ad,
    0x6030fad438f67304,
    0x1dc6e7821edb8a5c,
    0x3fabe2a396c821ee,
    0xce442caa65704817,
    0xac5266c00ed4ded7,
    0x53aa9ef14c0ae51f,
    0x133df7ebbc224e97,
    0x88ce9faea263de92,
    0x8c4be6bdd2b88017,
    0x628d5a19e9c247d9,
    0xa93bf3094d3d5518,
    0x3939f77b19cd8e05,
    0x3c85c4759d907006,
    0xf47559371ceb7cb4,
    0x9868d7443cc60fe8,
    0x591589f02cf8ecb7,
    0x680fa342f7100bba,
    0xb44b431aae371e85,
    0x99625bea8196289d,
    0xa38d36e079b35749,
    0x08d38b7277eb44ec,
    0xb5de835af494b061,
    0x370bd1df6206ad8e,
    0xf755226d1fb5139f,
    0xedafa93168993756,
    0x5b43e8559e471ed9,
    0xe84ed08d6375382d,
    0x9b99a5c06b47a88a,
    0x19e45304da068978,
    0x12aff3b863cdce2f,
    0xb0178e622c3aaf92,
    0x19e6b3b6373de8df,
    0xeb4cec3eff8e12f1,
    0xc3fc152a73114859,
    0xd516d062f8015f36,
    0x6440dd3153897c68,
    0x73924a5d67a5d259,
    0x00000002fae42e49,
];

// (s + 1) / 3
const EXP0: [u64; 48] = [
    0x7102a0d331e861cb,
    0x1a187b6ff0473e38,
    0xcddfacdb2f51d13f,
    0x483cd48f4e7b1ed5,
    0xd4e6f5255778f2bd,
    0x83ecae026a6bc6c7,
    0x911a907caf15187d,
    0xe9747f2bb8c8d2c8,
    0x069354deab370302,
    0x61fcd603b7d741d7,
    0xcaac7b1157716c8e,
    0xb540417698d8b945,
    0x6aa78d2280d80141,
    0x4a028665203390e4,
    0x6eadb7f42679a970,
    0x586e9d9728be087c,
    0xedbfecbce10ac08a,
    0x1807a7196e4f8cfb,
    0xdf452e78ceea638f,
    0xb7cc58aba05c8766,
    0xb0ef41e3e66a915f,
    0x3b02259c43537709,
    0x31a623b881185000,
    0x4b6ca47d4cec46fd,
    0xd63cc59a3b23c7b3,
    0x7513c2bd0b25a9f3,
    0xdded9dc01c1d09ea,
    0xcdc9e60a783aee2a,
    0x9d62752e9c80d218,
    0x944799bc7649033b,
    0xed5d2b1733d94e67,
    0x19b2e86baa3e6558,
    0xe5982437ae4c1964,
    0xffadd1de1d9e6905,
    0x253f6514cafc3174,
    0x58b6a9ca483b85e2,
    0xe2ad95f2460dd2ac,
    0x8a80f32d0d746e89,
    0xe483b739118e76de,
    0x4c8b41ea6282e1b5,
    0x81c7fbcabf448b3e,
    0x4ccfa7d757611b96,
    0x2528c66125e8d14b,
    0x6612d16063139a62,
    0xd87c1aae55098844,
    0x628724a303180e16,
    0x33b015b79b8ae1dd,
    0x000000001c41570c,
];

// r_inv * m_dash_inv
const R_M_D_INV: [u64; 88] = [
    0x5269cbffa1de7d17,
    0x752a442f05402918,
    0xadc220e391c8b45d,
    0x0dbe15d89c0dfb4d,
    0x2ced6e1be7dd5e8a,
    0x575712a5d3d521dc,
    0xcadc50ae726c1eb2,
    0x7c7bb95af32e875b,
    0x66671e4a6d4f9732,
    0x2e1513eddd68cb99,
    0x35ec1147bc833f2d,
    0x813c5551bdfcedbb,
    0xafb52c74db67694d,
    0xa94f43e174bd3f6d,
    0xf176b9f29acc032e,
    0x983092561ca6e1fe,
    0xeaae5e50cd083d65,
    0x814477de35d5a366,
    0x2fcc4cffc1b1e3fd,
    0x03fa0ce334fb3fe4,
    0x66540780fb9ac8f7,
    0xb9f1db69db43907c,
    0xffa31ad233044010,
    0x2a2eb529ca2226e2,
    0x29bf149a2f7e4c09,
    0x1b51c305bd849dc1,
    0x18fc937dbfa56566,
    0xbbf6da52bb8e5703,
    0x332d30ae50878d68,
    0xf2902f5ff575a178,
    0x0be45ffc9c011320,
    0xd7f46d0e2bdbb46d,
    0xcc76c1af25c63a3e,
    0x41b9be93546909bd,
    0xe82c0ad99b03cea7,
    0x3d71429a78379fac,
    0x17bc76ca22e89651,
    0x46da9fc09404fe5b,
    0x5b7add89effe054b,
    0x2a55051203606c83,
    0x5ae677a94d11680d,
    0x8818c3dfb091ea0e,
    0xe7ca63d528ef0ce3,
    0x6540ab5b17bc3e4e,
    0xee17fccf70b3bfa6,
    0x4d269f99b85e3861,
    0x0f439a8ede245648,
    0x3017de195816c113,
    0x2ac5abaa37e5d43c,
    0x3e90bdbb16953cd0,
    0x8da22490e8158422,
    0xb1d0af2d2bce56e5,
    0x40939a400333329d,
    0x87c9c0b6aa231e84,
    0x22003c8e41d77534,
    0xa6e0d349cc2a3430,
    0x410c9e004cd770fa,
    0xde4616b947f58692,
    0x9f9af1729273af7a,
    0x0dab3d19889c8dfc,
    0xd9c2c4c7f76c2cdf,
    0x16e443a7d20359d8,
    0x7b1baced23deb8fe,
    0xf06f91873a3f53f9,
    0x2fe9cbacad4165e5,
    0x1c42aec2ef6eabb7,
    0x6b68c8c486218334,
    0x1f5191d84e6f1ce7,
    0xbcf4530ad9ba18f0,
    0xe3a540d126a882d9,
    0xe8c30bdcb670e368,
    0x244c1c4ce26fa40e,
    0x766d84f873c7479e,
    0xb5bb0451361c8bb1,
    0xdb3cad9e79c4cec4,
    0xb3a3c26108159c65,
    0xc73f5e0555a15603,
    0x49059e6d30de40ae,
    0x2d3521471b552560,
    0x709c2cfe852f9c82,
    0x4a4d30b72e03a39e,
    0xf3b7af30db17e951,
    0x871fb7dfdaac5fa6,
    0x1fe6c8220475c036,
    0x458467c2fd0c5f61,
    0xcde087ba1c0a1e85,
    0xd1e99cd525608c71,
    0x0000000000000040,
];

#[cfg(test)]
mod tests {
    use super::{get_27th_root, EXP, EXP0, R_M_D_INV};
    use ark_bn254::{Fq, Fq12, Fr};
    use ark_ff::{BigInteger, Field, One, PrimeField};
    use num_bigint::BigInt;

    #[test]
    fn test_hardcoded_consts() {
        let r = to_bigint(&Fr::MODULUS);
        let q = to_bigint(&Fq::MODULUS);
        let x = BigInt::from(0x44E992B44A6909F1u64); // CURVES[CurveID.BN254.value].x

        let w = get_27th_root();
        assert!(w.pow([27]) == Fq12::one(), "root_27th**27 should be one");
        assert!(w.pow([9]) != Fq12::one(), "root_27th**9 should not be one");

        let exp = (q.pow(12) - 1) / 3;

        let h = (q.pow(12) - 1) / &r; // = 3^3 · l # where gcd(l, 3) = 1
        assert!(gcd(&r, &h) == BigInt::from(1));

        let r_inv = r.modinv(&h).unwrap();

        let base = 3;
        let (k, l) = decompose_scalar_into_b_powers_and_remainder(&h, base);
        assert!(base.pow(k) * &l == h, "3^k * l should be h");
        assert!(
            &h % (base.pow(k)) == BigInt::from(0),
            "h should be a multiple of 3^k"
        );
        assert!(
            gcd(&l, &BigInt::from(base)) == BigInt::from(1),
            "l should be coprime with 3"
        );

        let lam: BigInt = 6 * &x + 2 + &q - q.pow(2) + q.pow(3); // https://eprint.iacr.org/2008/096.pdf See section 4 for BN curves.

        assert!(
            &lam % &r == BigInt::from(0),
            "λ should be a multiple of r. See section 4.2.2"
        );
        let m = &lam / &r;
        let d = gcd(&m, &h);

        assert!(&m % &d == BigInt::from(0), "m should be a multiple of d");
        let m_dash = &m / &d; // m' = m/d
        assert!(
            &m_dash % &h != BigInt::from(0),
            "m/d should not divide h. See section 4.2.2 Theorem 2."
        );
        assert!(&d * &r * &m_dash == lam, "incorrect parameters"); // sanity check
        assert!(gcd(&lam, &(q.pow(12) - BigInt::from(1))) == &d * &r);
        assert!(gcd(&m_dash, &(q.pow(12) - BigInt::from(1))) == BigInt::from(1), "m_dash should be coprime with q**12 - 1 'by construction'. See 4.3.2 computing m-th root");
        let m_d_inv = m_dash.modinv(&h).unwrap();

        let r_m_d_inv = &r_inv * &m_d_inv;

        let (_, s) = decompose_scalar_into_b_powers_and_remainder(&(q.pow(12) - 1), 3);
        let exp0 = (&s + 1) / 3;

        assert_eq!(EXP, to_words_le(&exp).as_slice());
        assert_eq!(EXP0, to_words_le(&exp0).as_slice());
        assert_eq!(R_M_D_INV, to_words_le(&r_m_d_inv).as_slice());
    }

    fn decompose_scalar_into_b_powers_and_remainder(scalar: &BigInt, b: usize) -> (u32, BigInt) {
        // Decompose scalar into b^k * l, where l is not divisible by b.
        let mut k: u32 = 0;
        let mut l: BigInt = scalar.clone();
        while &l % b == BigInt::from(0) {
            l /= b;
            k += 1;
        }
        assert!(&l % b != BigInt::from(0), "l should not be divisible by b");
        assert!(
            *scalar == b.pow(k) * &l,
            "scalar should be the product of b^k * l"
        );
        (k, l)
    }

    fn gcd(a: &BigInt, b: &BigInt) -> BigInt {
        assert!(a > &BigInt::from(0) && b > &BigInt::from(0));
        let mut a = a.clone();
        let mut b = b.clone();
        while b != BigInt::from(0) {
            (a, b) = (b.clone(), a % b);
        }
        a
    }

    fn to_words_le(bigint: &BigInt) -> Vec<u64> {
        let (sign, words) = bigint.to_u64_digits();
        assert!(sign != num_bigint::Sign::Minus);
        words
    }

    fn to_bigint(v: &ark_ff::BigInt<4>) -> BigInt {
        BigInt::from_bytes_be(num_bigint::Sign::Plus, &v.to_bytes_be())
    }
}
