use ark_bls12_381::Fq12;
use ark_ff::Field;

/// Takes a miller loop output and returns root, shift such that
/// root ** lam = shift * mlo, if and only if mlo ** h == 1.
pub fn get_final_exp_witness(mlo: Fq12) -> (Fq12, Fq12) {
    let shift = mlo.pow(H3_S);
    let root = (shift * mlo).pow(E);
    (root, shift)
}

const H3_S: [u64; 68] = [
    0x3546cefb808890f0,
    0x641330f2e1e842d7,
    0x87f5d9df187f516a,
    0x859c07e6ea022bc0,
    0x9528051fe44630de,
    0xea11d7f897145eb9,
    0x889bb4506a0322fb,
    0x0d646b1efe54084a,
    0xc97e07cf5b584781,
    0xb935ad200614b088,
    0x62fc282e6b69e55e,
    0x1aa363aed49c65ac,
    0x67b40a59e5b8738e,
    0x6d10d4d358c7ef08,
    0xffdebea143aa81a2,
    0x3a3bdc3a328d93a7,
    0x7388a43206c95a9c,
    0x2818509193ed294f,
    0x9f45587930e7c088,
    0x60ad8d281c783b30,
    0x847e843a73a904fd,
    0x45812c8ae65aab68,
    0xc08229ab91464915,
    0x3206d41e1ba53f66,
    0xfc5966c331ec72e2,
    0x044826c4e7af7613,
    0x2407cbb0a82ed97e,
    0x7a4b4c3e69046f62,
    0x5f2b1a013f759119,
    0x6364ce56ec1689ef,
    0x45f668f6c66a15f2,
    0xc3b31ca6b881c438,
    0xb1517b99f1ca7257,
    0x22b0d2c6267403d9,
    0x9d15e60372cc338d,
    0x4b812aacfeb0b422,
    0x2fff766f9193bd25,
    0x000ff7ccf94859dd,
    0xd11b9d21c74d5e11,
    0x193efcb76e4075b4,
    0x3dc5d3624b226d9c,
    0xa28eab2d6f10d623,
    0x6d82b81d18973336,
    0x4d3cb074cbfb327f,
    0xaccd414c69208cfc,
    0xc73ef082a325fa4f,
    0x02355b9525fc9508,
    0xd0d1d3c39399eeb0,
    0xfcd8f64eecb22f47,
    0x48b77abab9c1250f,
    0xee2d2507d12c6c89,
    0xbf76bd8efed7c907,
    0xd356fac2fb717b68,
    0x49d83d768ec95330,
    0x074f36284b55f60f,
    0x519ebde1c30350fa,
    0xabd1ec4ee31955ee,
    0x4c061913753ece72,
    0xd59968daee6b65c8,
    0x2bd228194946730a,
    0x386e734e82cf750c,
    0x368f7530de524d17,
    0x4baa54ea85455a82,
    0x38974a9b00eab788,
    0xfadb7f89cb2c5de9,
    0xfdd66cdf6b27a928,
    0xe4b592105c07d08e,
    0x00000000004c6694,
];

const E: [u64; 67] = [
    0x00b6e3fefaaf6c23,
    0xba50f7521d495337,
    0x8fa40e48bef9c692,
    0xd0cabc76f961074d,
    0x805168994fad7512,
    0x6aa1c8c9776871c3,
    0x2a68a4a67f55a88e,
    0x9b798d4030a925b3,
    0xbd017f6f55031685,
    0x5941c1d1cc14bb00,
    0x8cab8b6b547ac1b1,
    0xe8ba0fa4956270d9,
    0x402e2ea408490f83,
    0xe18f6141e75e6151,
    0x46944b9ccc52a999,
    0x2d1a56bba3476aeb,
    0x2884afb4610957be,
    0x0c7f1ca9e35adf3a,
    0x25a8b21e58a3059d,
    0x23e0efdaa215a695,
    0xbe22bd36eae8284d,
    0x4941f4877fe7756e,
    0xed8552dabf485b53,
    0x3d6f68b235ee04c1,
    0xfba66f18e3f07980,
    0x9f0afd39b4ffa61a,
    0x770409ca39863bc3,
    0x1ec1adbd1d7fd6b0,
    0x27919600415dabdb,
    0xf2e39dc4a2ef8538,
    0x2c1761964cb5c1f1,
    0x7cc854792a8a9c52,
    0x10e35f0ec2b3fc7a,
    0xaf9e06161c9a4afc,
    0x6835191eddcb197f,
    0x851646957b8a14f5,
    0x23fb3f871de4d8e5,
    0x0b41c4306d335cb6,
    0x03c5be4d379339f3,
    0x7dc912d6e44a7fab,
    0x06d087dcd3618e42,
    0x64e6c398c568675b,
    0x5893e10ca8e48731,
    0xe9d43d3b7ad9af62,
    0x67bcb0d7498e2482,
    0xacaab294577b5f17,
    0xf82b66fd5a502089,
    0x7ffac9d4f6359297,
    0x2c27b262ebbdcb0c,
    0xf1bd69c020b89006,
    0x987f26d6b7de5b55,
    0x7a07bc5b60e1ed38,
    0x362f49e4dd57cf6c,
    0xd5d230c454517eb4,
    0x7b93fc9ccc5cd0d8,
    0x89def3e07ff5e35a,
    0xa70dcd395814cc0c,
    0xb18f69bd487a02af,
    0x066c5b338d11e220,
    0xa8bba4f42f4d8974,
    0x75e528ac2412d477,
    0xd46fda1e16fb9588,
    0xfc4e91d7468d4790,
    0x8a72692b8d18d58e,
    0x22142ac1801c949d,
    0xcb940d75d40a0772,
    0x00000000004ea48c,
];

#[cfg(test)]
mod tests {
    use super::{E, H3_S};
    use num_bigint::BigInt;

    #[test]
    fn test_hardcoded_consts() {
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

        let h3_s = &h3 * &s;

        assert_eq!(h % (27 * &p), BigInt::from(0));
        assert_eq!(m, 3 * p.pow(2));

        assert_eq!(gcd(&BigInt::from(3), &h3), BigInt::from(1));
        assert_eq!(gcd(&p.pow(2), &h3), BigInt::from(1));
        assert_eq!(gcd(&p, &h3), BigInt::from(1));
        assert_eq!(gcd(&p, &(27 * &h3)), BigInt::from(1));
        assert_eq!(gcd(&BigInt::from(27), &(&p * &h3)), BigInt::from(1));

        assert_eq!((q.pow(3) - 1) % 27, BigInt::from(0));

        assert_eq!(H3_S, to_words_le(&h3_s).as_slice());
        assert_eq!(E, to_words_le(&e).as_slice());
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
}
