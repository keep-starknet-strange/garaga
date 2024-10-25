use crate::algebra::polynomial::Polynomial;
use crate::definitions::CurveID;
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use std::collections::HashMap;

type FrobeniusMap<F> = HashMap<usize, Vec<Vec<(usize, FieldElement<F>)>>>;

pub fn frobenius<F: IsPrimeField>(
    frobenius_maps: &FrobeniusMap<F>,
    x: &Polynomial<F>,
    frob_power: usize,
    ext_degree: usize,
) -> Polynomial<F> {
    let frobenius_map = frobenius_maps.get(&frob_power).unwrap();
    assert!(x.coefficients.len() <= ext_degree);
    let mut frob = vec![];
    for coeffs in frobenius_map.iter().take(x.coefficients.len()) {
        let mut v = FieldElement::from(0);
        for (index, constant) in coeffs {
            v += constant * &x.coefficients[*index];
        }
        frob.push(v);
    }
    Polynomial::new(frob)
}

// returns only the indices required by multi_pairing_check (bn254: 1, 2, 3; bls12-381: 1)
pub fn get_frobenius_maps_ext_degree_12<F: IsPrimeField>(curve_id: CurveID) -> FrobeniusMap<F> {
    match curve_id {
    CurveID::BN254 =>
        HashMap::from([
            (1, vec![
                vec![
                    (0, FieldElement::from_hex("1").unwrap()),
                    (6, FieldElement::from_hex("12").unwrap()),
                ],
                vec![
                    (1, FieldElement::from_hex("1d8c8daef3eee1e81b2522ec5eb28ded6895e1cdfde6a43f5daa971f3fa65955").unwrap()),
                    (7, FieldElement::from_hex("217e400dc9351e774e34e2ac06ead4000d14d1e242b29c567e9c385ce480a71a").unwrap()),
                ],
                vec![
                    (2, FieldElement::from_hex("242b719062f6737b8481d22c6934ce844d72f250fd28d102c0d147b2f4d521a7").unwrap()),
                    (8, FieldElement::from_hex("359809094bd5c8e1b9c22d81246ffc2e794e17643ac198484b8d9094aa82536").unwrap()),
                ],
                vec![
                    (3, FieldElement::from_hex("21436d48fcb50cc60dd4ef1e69a0c1f0dd2949fa6df7b44cbb259ef7cb58d5ed").unwrap()),
                    (9, FieldElement::from_hex("18857a58f3b5bb3038a4311a86919d9c7c6c15f88a4f4f0831364cf35f78f771").unwrap()),
                ],
                vec![
                    (4, FieldElement::from_hex("2c84bbad27c3671562b7adefd44038ab3c0bbad96fc008e7d6998c82f7fc048b").unwrap()),
                    (10, FieldElement::from_hex("c33b1c70e4fd11b6d1eab6fcd18b99ad4afd096a8697e0c9c36d8ca3339a7b5").unwrap()),
                ],
                vec![
                    (5, FieldElement::from_hex("1b007294a55accce13fe08bea73305ff6bdac77c5371c546d428780a6e3dcfa8").unwrap()),
                    (11, FieldElement::from_hex("215d42e7ac7bd17cefe88dd8e6965b3adae92c974f501fe811493d72543a3977").unwrap()),
                ],
                vec![
                    (6, FieldElement::from_hex("30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd46").unwrap()),
                ],
                vec![
                    (1, FieldElement::from_hex("246996f3b4fae7e6a6327cfe12150b8e747992778eeec7e5ca5cf05f80f362ac").unwrap()),
                    (7, FieldElement::from_hex("12d7c0c3ed42be419d2b22ca22ceca702eeb88c36a8b264dde75f4f798d6a3f2").unwrap()),
                ],
                vec![
                    (2, FieldElement::from_hex("16c9e55061ebae204ba4cc8bd75a079432ae2a1d0b7c9dce1665d51c640fcba2").unwrap()),
                    (8, FieldElement::from_hex("c38dce27e3b2cae33ce738a184c89d94a0e78406b48f98a7b4f4463e3a7dba0").unwrap()),
                ],
                vec![
                    (3, FieldElement::from_hex("7c03cbcac41049a0704b5a7ec796f2b21807dc98fa25bd282d37f632623b0e3").unwrap()),
                    (9, FieldElement::from_hex("f20e129e47c9363aa7b569817e0966cba582096fa7a164080faed1f0d24275a").unwrap()),
                ],
                vec![
                    (4, FieldElement::from_hex("2c145edbe7fd8aee9f3a80b03b0b1c923685d2ea1bdec763c13b4711cd2b8126").unwrap()),
                    (10, FieldElement::from_hex("3df92c5b96e3914559897c6ad411fb25b75afb7f8b1c1a56586ff93e080f8bc").unwrap()),
                ],
                vec![
                    (5, FieldElement::from_hex("12acf2ca76fd0675a27fb246c7729f7db080cb99678e2ac024c6b8ee6e0c2c4b").unwrap()),
                    (11, FieldElement::from_hex("1563dbde3bd6d35ba4523cf7da4e525e2ba6a3151500054667f8140c6a3f2d9f").unwrap()),
                ],
            ]),
            (2, vec![
                vec![
                    (0, FieldElement::from_hex("1").unwrap()),
                ],
                vec![
                    (1, FieldElement::from_hex("30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd49").unwrap()),
                ],
                vec![
                    (2, FieldElement::from_hex("30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd48").unwrap()),
                ],
                vec![
                    (3, FieldElement::from_hex("30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd46").unwrap()),
                ],
                vec![
                    (4, FieldElement::from_hex("59e26bcea0d48bacd4f263f1acdb5c4f5763473177fffffe").unwrap()),
                ],
                vec![
                    (5, FieldElement::from_hex("59e26bcea0d48bacd4f263f1acdb5c4f5763473177ffffff").unwrap()),
                ],
                vec![
                    (6, FieldElement::from_hex("1").unwrap()),
                ],
                vec![
                    (7, FieldElement::from_hex("30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd49").unwrap()),
                ],
                vec![
                    (8, FieldElement::from_hex("30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd48").unwrap()),
                ],
                vec![
                    (9, FieldElement::from_hex("30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd46").unwrap()),
                ],
                vec![
                    (10, FieldElement::from_hex("59e26bcea0d48bacd4f263f1acdb5c4f5763473177fffffe").unwrap()),
                ],
                vec![
                    (11, FieldElement::from_hex("59e26bcea0d48bacd4f263f1acdb5c4f5763473177ffffff").unwrap()),
                ],
            ]),
            (3, vec![
                vec![
                    (0, FieldElement::from_hex("1").unwrap()),
                    (6, FieldElement::from_hex("12").unwrap()),
                ],
                vec![
                    (1, FieldElement::from_hex("13d0c369615f7bb0b2bdfa8fef85fa07122bde8d67dfc8fabd3581ad840ddd76").unwrap()),
                    (7, FieldElement::from_hex("18a0f4219f4fdff6fc2bf531eb331a053a35744cac285af5685d3f90eacf7a66").unwrap()),
                ],
                vec![
                    (2, FieldElement::from_hex("c3a5e9c462a654779c3e050c9ca2a428908a81264e2b5a5bf22f67654883ae6").unwrap()),
                    (8, FieldElement::from_hex("2ce02aa5f9bf8cd65bdd2055c255cf9d9e08c1d9345582cc92fd973c74bd77f4").unwrap()),
                ],
                vec![
                    (3, FieldElement::from_hex("f20e129e47c9363aa7b569817e0966cba582096fa7a164080faed1f0d24275a").unwrap()),
                    (9, FieldElement::from_hex("17ded419ed7be4f97fac149bfaefbac11b155498de227b850aea3f23790405d6").unwrap()),
                ],
                vec![
                    (4, FieldElement::from_hex("1bfe7b214c0294242fb81a8dccd8a9b4441d64f34150a79753fb0cd31cc99cc0").unwrap()),
                    (10, FieldElement::from_hex("697b9c523e0390ed15da0ec97a9b8346513297b9efaf0f0f1a228f0d5662fbd").unwrap()),
                ],
                vec![
                    (5, FieldElement::from_hex("7a0e052f2b1c443b5186d6ac4c723b85d3f78a3182d2db0c413901c32b0c6fe").unwrap()),
                    (11, FieldElement::from_hex("1b76a37fba85f3cd5dc79824a3792597356c892c39c0d06b220500933945267f").unwrap()),
                ],
                vec![
                    (6, FieldElement::from_hex("30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd46").unwrap()),
                ],
                vec![
                    (1, FieldElement::from_hex("abf8b60be77d7306cbeee33576139d7f03a5e397d439ec7694aa2bf4c0c101").unwrap()),
                    (7, FieldElement::from_hex("1c938b097fd2247905924b2691fb5e5685558c04009201927eeb0a69546f1fd1").unwrap()),
                ],
                vec![
                    (2, FieldElement::from_hex("4f1de41b3d1766fa9f30e6dec26094f0fdf31bf98ff2631380cab2baaa586de").unwrap()),
                    (8, FieldElement::from_hex("2429efd69b073ae23e8c6565b7b72e1b0e78c27f038f14e77cfd95a083f4c261").unwrap()),
                ],
                vec![
                    (3, FieldElement::from_hex("28a411b634f09b8fb14b900e9507e9327600ecc7d8cf6ebab94d0cb3b2594c64").unwrap()),
                    (9, FieldElement::from_hex("21436d48fcb50cc60dd4ef1e69a0c1f0dd2949fa6df7b44cbb259ef7cb58d5ed").unwrap()),
                ],
                vec![
                    (4, FieldElement::from_hex("23d5e999e1910a12feb0f6ef0cd21d04a44a9e08737f96e55fe3ed9d730c239f").unwrap()),
                    (10, FieldElement::from_hex("1465d351952f0c0588982b28b4a8aea95364059e272122f5e8257f43bbb36087").unwrap()),
                ],
                vec![
                    (5, FieldElement::from_hex("16db366a59b1dd0b9fb1b2282a48633d3e2ddaea200280211f25041384282499").unwrap()),
                    (11, FieldElement::from_hex("28c36e1fee7fdbe60337d84bbcba34a53a41f1ee50449cdc780cfbfaa5cc3649").unwrap()),
                ],
            ]),
        ]),
    CurveID::BLS12_381 =>
        HashMap::from([
            (1, vec![
                vec![
                    (0, FieldElement::from_hex("1").unwrap()),
                    (6, FieldElement::from_hex("2").unwrap()),
                ],
                vec![
                    (1, FieldElement::from_hex("18089593cbf626353947d5b1fd0c6d66bb34bc7585f5abdf8f17b50e12c47d65ce514a7c167b027b600febdb244714c5").unwrap()),
                    (7, FieldElement::from_hex("18089593cbf626353947d5b1fd0c6d66bb34bc7585f5abdf8f17b50e12c47d65ce514a7c167b027b600febdb244714c5").unwrap()),
                ],
                vec![
                    (2, FieldElement::from_hex("5f19672fdf76ce51ba69c6076a0f77eaddb3a93be6f89688de17d813620a00022e01fffffffeffff").unwrap()),
                ],
                vec![
                    (9, FieldElement::from_hex("d5e1c086ffe8016d063c6dad7a2fffc9072bb5785a686bcefeedc2e0124838bdccf325ee5d80be9902109f7dbc79812").unwrap()),
                ],
                vec![
                    (4, FieldElement::from_hex("1a0111ea397fe699ec02408663d4de85aa0d857d89759ad4897d29650fb85f9b409427eb4f49fffd8bfd00000000aaad").unwrap()),
                    (10, FieldElement::from_hex("1a0111ea397fe6998ce8d956845e1033efa3bf761f6622e9abc9802928bfc912627c4fd7ed3ffffb5dfb00000001aaaf").unwrap()),
                ],
                vec![
                    (5, FieldElement::from_hex("b659fb20274bfb1be8ff4d69163c08be7302c4818171fdd17d5be9b1d380acd8c747cdc4aff0e653631f5d3000f022c").unwrap()),
                    (11, FieldElement::from_hex("b659fb20274bfb1be8ff4d69163c08be7302c4818171fdd17d5be9b1d380acd8c747cdc4aff0e653631f5d3000f022c").unwrap()),
                ],
                vec![
                    (6, FieldElement::from_hex("1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaaa").unwrap()),
                ],
                vec![
                    (1, FieldElement::from_hex("fc3e2b36c4e03288e9e902231f9fb854a14787b6c7b36fec0c8ec971f63c5f282d5ac14d6c7ec22cf78a126ddc4af3").unwrap()),
                    (7, FieldElement::from_hex("1f87c566d89c06511d3d204463f3f70a9428f0f6d8f66dfd8191d92e3ec78be505ab5829ad8fd8459ef1424dbb895e6").unwrap()),
                ],
                vec![
                    (2, FieldElement::from_hex("1a0111ea397fe699ec02408663d4de85aa0d857d89759ad4897d29650fb85f9b409427eb4f49fffd8bfd00000000aaac").unwrap()),
                    (8, FieldElement::from_hex("1a0111ea397fe699ec02408663d4de85aa0d857d89759ad4897d29650fb85f9b409427eb4f49fffd8bfd00000000aaac").unwrap()),
                ],
                vec![
                    (3, FieldElement::from_hex("6af0e0437ff400b6831e36d6bd17ffe48395dabc2d3435e77f76e17009241c5ee67992f72ec05f4c81084fbede3cc09").unwrap()),
                ],
                vec![
                    (10, FieldElement::from_hex("5f19672fdf76ce51ba69c6076a0f77eaddb3a93be6f89688de17d813620a00022e01fffffffefffe").unwrap()),
                ],
                vec![
                    (5, FieldElement::from_hex("144e4211384586c16bd3ad4afa99cc9170df3560e77982d0db45f3536814f0bd5871c1908bd478cd1ee605167ff82995").unwrap()),
                    (11, FieldElement::from_hex("e9b7238370b26e88c8bb2dfb1e7ec4b7d471f3cdb6df2e24f5b1405d978eb56923783226654f19a83cd0a2cfff0a87f").unwrap()),
                ],
            ]),
        ]),
    _ => unimplemented!(),
    }
}
