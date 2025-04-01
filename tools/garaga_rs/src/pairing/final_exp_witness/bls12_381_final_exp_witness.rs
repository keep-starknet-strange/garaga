use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree12ExtensionField;
use lambdaworks_math::field::element::FieldElement;
use lazy_static::lazy_static;
use num_bigint::BigUint;
use num_traits::Num;

// Optimized implementation of exponentiation using square-and-multiply algorithm
// with binary representation scanning
fn pow_custom(
    base: &FieldElement<Degree12ExtensionField>,
    exponent: &BigUint,
) -> FieldElement<Degree12ExtensionField> {
    if exponent == &BigUint::from(0u64) {
        return FieldElement::<Degree12ExtensionField>::one();
    }
    if exponent == &BigUint::from(1u64) {
        return base.clone();
    }

    let mut result = FieldElement::<Degree12ExtensionField>::one();
    let temp = base.clone();

    // Use bytes directly instead of string conversion for better performance
    let exponent_bytes = exponent.to_bytes_be();

    for byte in exponent_bytes {
        for i in (0..8).rev() {
            result = result.square();

            if (byte >> i) & 1 == 1 {
                result = &result * &temp;
            }
        }
    }

    result
}

/// Takes a miller loop output and returns root, shift such that
/// root ** lam = shift * mlo, if and only if mlo ** h == 1.
pub fn get_final_exp_witness(
    mlo: FieldElement<Degree12ExtensionField>,
) -> (
    FieldElement<Degree12ExtensionField>,
    FieldElement<Degree12ExtensionField>,
) {
    // Calculate shift and root
    let shift = pow_custom(&mlo, &H3_S);
    let root = pow_custom(&(&shift * &mlo), &E);

    (root, shift)
}

lazy_static! {
    static ref H3_S: BigUint = BigUint::from_str_radix("4c6694e4b592105c07d08efdd66cdf6b27a928fadb7f89cb2c5de938974a9b00eab7884baa54ea85455a82368f7530de524d17386e734e82cf750c2bd228194946730ad59968daee6b65c84c061913753ece72abd1ec4ee31955ee519ebde1c30350fa074f36284b55f60f49d83d768ec95330d356fac2fb717b68bf76bd8efed7c907ee2d2507d12c6c8948b77abab9c1250ffcd8f64eecb22f47d0d1d3c39399eeb002355b9525fc9508c73ef082a325fa4faccd414c69208cfc4d3cb074cbfb327f6d82b81d18973336a28eab2d6f10d6233dc5d3624b226d9c193efcb76e4075b4d11b9d21c74d5e11000ff7ccf94859dd2fff766f9193bd254b812aacfeb0b4229d15e60372cc338d22b0d2c6267403d9b1517b99f1ca7257c3b31ca6b881c43845f668f6c66a15f26364ce56ec1689ef5f2b1a013f7591197a4b4c3e69046f622407cbb0a82ed97e044826c4e7af7613fc5966c331ec72e23206d41e1ba53f66c08229ab9146491545812c8ae65aab68847e843a73a904fd60ad8d281c783b309f45587930e7c0882818509193ed294f7388a43206c95a9c3a3bdc3a328d93a7ffdebea143aa81a26d10d4d358c7ef0867b40a59e5b8738e1aa363aed49c65ac62fc282e6b69e55eb935ad200614b088c97e07cf5b5847810d646b1efe54084a889bb4506a0322fbea11d7f897145eb99528051fe44630de859c07e6ea022bc087f5d9df187f516a641330f2e1e842d73546cefb808890f0", 16).unwrap();
    static ref E: BigUint = BigUint::from_str_radix("4ea48ccb940d75d40a077222142ac1801c949d8a72692b8d18d58efc4e91d7468d4790d46fda1e16fb958875e528ac2412d477a8bba4f42f4d8974066c5b338d11e220b18f69bd487a02afa70dcd395814cc0c89def3e07ff5e35a7b93fc9ccc5cd0d8d5d230c454517eb4362f49e4dd57cf6c7a07bc5b60e1ed38987f26d6b7de5b55f1bd69c020b890062c27b262ebbdcb0c7ffac9d4f6359297f82b66fd5a502089acaab294577b5f1767bcb0d7498e2482e9d43d3b7ad9af625893e10ca8e4873164e6c398c568675b06d087dcd3618e427dc912d6e44a7fab03c5be4d379339f30b41c4306d335cb623fb3f871de4d8e5851646957b8a14f56835191eddcb197faf9e06161c9a4afc10e35f0ec2b3fc7a7cc854792a8a9c522c1761964cb5c1f1f2e39dc4a2ef853827919600415dabdb1ec1adbd1d7fd6b0770409ca39863bc39f0afd39b4ffa61afba66f18e3f079803d6f68b235ee04c1ed8552dabf485b534941f4877fe7756ebe22bd36eae8284d23e0efdaa215a69525a8b21e58a3059d0c7f1ca9e35adf3a2884afb4610957be2d1a56bba3476aeb46944b9ccc52a999e18f6141e75e6151402e2ea408490f83e8ba0fa4956270d98cab8b6b547ac1b15941c1d1cc14bb00bd017f6f550316859b798d4030a925b32a68a4a67f55a88e6aa1c8c9776871c3805168994fad7512d0cabc76f961074d8fa40e48bef9c692ba50f7521d49533700b6e3fefaaf6c23", 16).unwrap();
}

#[cfg(test)]
mod tests {
    // use super::{E, H3_S};
    // use num_bigint::BigInt;
    // use num_traits::Num;

    // #[test]
    // fn test_hardcoded_consts() {
    //     let h3_s = BigInt::from_str_radix(H3_S, 16).unwrap();
    //     let e = BigInt::from_str_radix(E, 16).unwrap();
    //     let x = -BigInt::from(0xD201000000010000u64); // CURVES[CurveID.BLS12_381.value].x
    //     let k = 12;
    //     let r = x.pow(4) - x.pow(2) + 1;
    //     let q: BigInt = (&x - BigInt::from(1)).pow(2) / 3 * &r + &x;
    //     let h = (q.pow(k) - 1) / &r;

    //     let lam = -&x + &q;
    //     let m = &lam / &r;

    //     let p = BigInt::from(5044125407647214251u64);
    //     let h3 = &h / (27 * &p);

    //     let e = lam.modinv(&h3).unwrap();
    //     let s = ((&p * 27 - 1) * h3.modinv(&(&p * 27)).unwrap()) % (&p * 27);

    //     let h3_s = &h3 * &s;

    //     assert_eq!(h % (27 * &p), BigInt::from(0));
    //     assert_eq!(m, 3 * p.pow(2));

    //     assert_eq!(gcd(&BigInt::from(3), &h3), BigInt::from(1));
    //     assert_eq!(gcd(&p.pow(2), &h3), BigInt::from(1));
    //     assert_eq!(gcd(&p, &h3), BigInt::from(1));
    //     assert_eq!(gcd(&p, &(27 * &h3)), BigInt::from(1));
    //     assert_eq!(gcd(&BigInt::from(27), &(&p * &h3)), BigInt::from(1));

    //     assert_eq!((q.pow(3) - 1) % 27, BigInt::from(0));

    //     assert_eq!(H3_S, &h3_s.to_string());
    //     assert_eq!(E, &e.to_string());
    // }

    // fn gcd(a: &BigInt, b: &BigInt) -> BigInt {
    //     assert!(a > &BigInt::from(0) && b > &BigInt::from(0));
    //     let mut a = a.clone();
    //     let mut b = b.clone();
    //     while b != BigInt::from(0) {
    //         (a, b) = (b.clone(), a % b);
    //     }
    //     a
    // }

    // fn to_words_le(bigint: &BigInt) -> Vec<u64> {
    //     let (sign, words) = bigint.to_u64_digits();
    //     assert!(sign != num_bigint::Sign::Minus);
    //     words
    // }
}
