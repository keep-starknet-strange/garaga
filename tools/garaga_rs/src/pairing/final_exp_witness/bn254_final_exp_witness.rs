use crate::definitions::BN254PrimeField;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::{
    Degree12ExtensionField, Degree2ExtensionField, Degree6ExtensionField,
};
use lambdaworks_math::field::element::FieldElement;
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

/// Algorithm for computing λ residues over BN254 curve
/// Input: Output of a Miller loop f
/// Output: (c, wi) such that c ** λ = f * wi
pub fn get_final_exp_witness(
    f: FieldElement<Degree12ExtensionField>,
) -> (
    FieldElement<Degree12ExtensionField>,
    FieldElement<Degree12ExtensionField>,
) {
    let w = get_27th_root();
    let mut c = f.clone();
    let mut ws = FieldElement::<Degree12ExtensionField>::one();

    if pow_custom(&c, &BigUint::from_str_radix(EXP, 16).unwrap())
        != FieldElement::<Degree12ExtensionField>::one()
    {
        c = &c * &w;
        ws = &ws * &w;
        if pow_custom(&c, &BigUint::from_str_radix(EXP, 16).unwrap())
            != FieldElement::<Degree12ExtensionField>::one()
        {
            c = &c * &w;
            ws = &ws * &w;
        }
    }

    c = pow_custom(&c, &BigUint::from_str_radix(R_M_D_INV, 16).unwrap());
    (find_cube_root(c, w), ws)
}

fn get_27th_root() -> FieldElement<Degree12ExtensionField> {
    FieldElement::<Degree12ExtensionField>::new([
        FieldElement::<Degree6ExtensionField>::new([
            FieldElement::<Degree2ExtensionField>::zero(),
            FieldElement::<Degree2ExtensionField>::zero(),
            FieldElement::<Degree2ExtensionField>::new([
                FieldElement::<BN254PrimeField>::from_hex_unchecked(
                    "1223c9e5932f55ff4c5bb93e3ae400abc8ff620b6cd0ba64515fe1909e9f8e51",
                ),
                FieldElement::<BN254PrimeField>::from_hex_unchecked(
                    "279a0a9dbd98089c184dac0e71909eb223ea52bfc24790f6d545aed52a2fbdb8",
                ),
            ]),
        ]),
        FieldElement::<Degree6ExtensionField>::zero(),
    ])
}

fn find_cube_root(
    a: FieldElement<Degree12ExtensionField>,
    w: FieldElement<Degree12ExtensionField>,
) -> FieldElement<Degree12ExtensionField> {
    let a_inv = a.inv().unwrap();
    let we = pow_custom(&w, &BigUint::from_str_radix(EXP0, 16).unwrap());
    let mut x = pow_custom(&a, &BigUint::from_str_radix(EXP0, 16).unwrap());
    let mut t = pow_3_ord(&(&x.pow(3u64) * &a_inv));
    while t != 0 {
        x = &x * &we;
        t = pow_3_ord(&(&x.pow(3u64) * &a_inv));
    }
    x
}

fn pow_3_ord(a: &FieldElement<Degree12ExtensionField>) -> usize {
    let mut a = a.clone();
    let mut t = 0;
    while a != FieldElement::<Degree12ExtensionField>::one() {
        a = a.pow(3u64);
        t += 1;
    }
    t
}

// (q ** k - 1) / 3
const EXP: &str = "2fae42e4973924a5d67a5d2596440dd3153897c68d516d062f8015f36c3fc152a73114859eb4cec3eff8e12f119e6b3b6373de8dfb0178e622c3aaf9212aff3b863cdce2f19e45304da0689789b99a5c06b47a88ae84ed08d6375382d5b43e8559e471ed9edafa93168993756f755226d1fb5139f370bd1df6206ad8eb5de835af494b06108d38b7277eb44eca38d36e079b3574999625bea8196289db44b431aae371e85680fa342f7100bba591589f02cf8ecb79868d7443cc60fe8f47559371ceb7cb43c85c4759d9070063939f77b19cd8e05a93bf3094d3d5518628d5a19e9c247d98c4be6bdd2b8801788ce9faea263de92133df7ebbc224e9753aa9ef14c0ae51fac5266c00ed4ded7ce442caa657048173fabe2a396c821ee1dc6e7821edb8a5c6030fad438f6730455aa926463b3f1adb189f37c0ecd514e9f49699c7d2e3b274dcd3d267739953ce9f65a41395df713745bdaf039c199f69e6a6b1d46fc408cb6973b1dfda111a7c09504ce57838ff3eb46f64643825060";
// (s + 1) / 3
const EXP0: &str = "1c41570c33b015b79b8ae1dd628724a303180e16d87c1aae550988446612d16063139a622528c66125e8d14b4ccfa7d757611b9681c7fbcabf448b3e4c8b41ea6282e1b5e483b739118e76de8a80f32d0d746e89e2ad95f2460dd2ac58b6a9ca483b85e2253f6514cafc3174ffadd1de1d9e6905e5982437ae4c196419b2e86baa3e6558ed5d2b1733d94e67944799bc7649033b9d62752e9c80d218cdc9e60a783aee2added9dc01c1d09ea7513c2bd0b25a9f3d63cc59a3b23c7b34b6ca47d4cec46fd31a623b8811850003b02259c43537709b0ef41e3e66a915fb7cc58aba05c8766df452e78ceea638f1807a7196e4f8cfbedbfecbce10ac08a586e9d9728be087c6eadb7f42679a9704a028665203390e46aa78d2280d80141b540417698d8b945caac7b1157716c8e61fcd603b7d741d7069354deab370302e9747f2bb8c8d2c8911a907caf15187d83ecae026a6bc6c7d4e6f5255778f2bd483cd48f4e7b1ed5cddfacdb2f51d13f1a187b6ff0473e387102a0d331e861cb";

// r_inv * m_dash_inv
const R_M_D_INV: &str = "40d1e99cd525608c71cde087ba1c0a1e85458467c2fd0c5f611fe6c8220475c036871fb7dfdaac5fa6f3b7af30db17e9514a4d30b72e03a39e709c2cfe852f9c822d3521471b55256049059e6d30de40aec73f5e0555a15603b3a3c26108159c65db3cad9e79c4cec4b5bb0451361c8bb1766d84f873c7479e244c1c4ce26fa40ee8c30bdcb670e368e3a540d126a882d9bcf4530ad9ba18f01f5191d84e6f1ce76b68c8c4862183341c42aec2ef6eabb72fe9cbacad4165e5f06f91873a3f53f97b1baced23deb8fe16e443a7d20359d8d9c2c4c7f76c2cdf0dab3d19889c8dfc9f9af1729273af7ade4616b947f58692410c9e004cd770faa6e0d349cc2a343022003c8e41d7753487c9c0b6aa231e8440939a400333329db1d0af2d2bce56e58da22490e81584223e90bdbb16953cd02ac5abaa37e5d43c3017de195816c1130f439a8ede2456484d269f99b85e3861ee17fccf70b3bfa66540ab5b17bc3e4ee7ca63d528ef0ce38818c3dfb091ea0e5ae677a94d11680d2a55051203606c835b7add89effe054b46da9fc09404fe5b17bc76ca22e896513d71429a78379face82c0ad99b03cea741b9be93546909bdcc76c1af25c63a3ed7f46d0e2bdbb46d0be45ffc9c011320f2902f5ff575a178332d30ae50878d68bbf6da52bb8e570318fc937dbfa565661b51c305bd849dc129bf149a2f7e4c092a2eb529ca2226e2ffa31ad233044010b9f1db69db43907c66540780fb9ac8f703fa0ce334fb3fe42fcc4cffc1b1e3fd814477de35d5a366eaae5e50cd083d65983092561ca6e1fef176b9f29acc032ea94f43e174bd3f6dafb52c74db67694d813c5551bdfcedbb35ec1147bc833f2d2e1513eddd68cb9966671e4a6d4f97327c7bb95af32e875bcadc50ae726c1eb2575712a5d3d521dc2ced6e1be7dd5e8a0dbe15d89c0dfb4dadc220e391c8b45d752a442f054029185269cbffa1de7d17";
