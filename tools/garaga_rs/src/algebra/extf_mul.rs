use crate::algebra::polynomial::{pad_with_zero_coefficients_to_length, Polynomial};
use crate::definitions::{get_irreducible_poly, CurveParamsProvider};
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::{IsField, IsPrimeField, IsSubFieldOf};

// Returns (Q(X), R(X)) such that Π(Pi)(X) = Q(X) * P_irr(X) + R(X), for a given curve and extension degree.
// R(X) is the result of the multiplication in the extension field.
// Q(X) is used for verification.
pub fn nondeterministic_extension_field_mul_divmod<F: IsPrimeField + CurveParamsProvider<F>>(
    ext_degree: usize,
    ps: Vec<Polynomial<F>>,
) -> (Polynomial<F>, Polynomial<F>) {
    let mut z_poly = Polynomial::one();
    for poly in ps {
        z_poly = z_poly.mul_with_ref(&poly);
    }

    let p_irr = get_irreducible_poly(ext_degree);

    let (z_polyq, mut z_polyr) = z_poly.divmod(&p_irr);
    assert!(z_polyr.coefficients.len() <= ext_degree);

    // Extend polynomial with 0 coefficients to match the expected length.
    if z_polyr.coefficients.len() < ext_degree {
        pad_with_zero_coefficients_to_length(&mut z_polyr, ext_degree);
    }

    (z_polyq, z_polyr)
}

pub fn nondeterministic_extension_field_div<F, E2, E6, E12>(
    x: Polynomial<F>,
    y: Polynomial<F>,
    ext_degree: usize,
) -> Polynomial<F>
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]> + IsSubFieldOf<E6>,
    E6: IsField<BaseType = [FieldElement<E2>; 3]> + IsSubFieldOf<E12>,
    E12: IsField<BaseType = [FieldElement<E6>; 2]>,
{
    let a = direct_to_tower(&x.get_coefficients_ext_degree(ext_degree), ext_degree);
    let b = direct_to_tower(&y.get_coefficients_ext_degree(ext_degree), ext_degree);
    let div = tower_div(&a, &b, ext_degree);
    Polynomial::new(tower_to_direct(&div, ext_degree))
}

pub fn tower_to_direct<F>(x: &[FieldElement<F>], ext_degree: usize) -> Vec<FieldElement<F>>
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    assert_eq!(x.len(), ext_degree);
    let nr_a0 = &FieldElement::<F>::from(F::get_curve_params().nr_a0);
    match ext_degree {
        2 => x.to_vec(),
        6 => vec![
            &x[0] - nr_a0 * &x[1],
            &x[2] - nr_a0 * &x[3],
            &x[4] - nr_a0 * &x[5],
            x[1].clone(),
            x[3].clone(),
            x[5].clone(),
        ],
        12 => vec![
            &x[0] - nr_a0 * &x[1],
            &x[6] - nr_a0 * &x[7],
            &x[2] - nr_a0 * &x[3],
            &x[8] - nr_a0 * &x[9],
            &x[4] - nr_a0 * &x[5],
            &x[10] - nr_a0 * &x[11],
            x[1].clone(),
            x[7].clone(),
            x[3].clone(),
            x[9].clone(),
            x[5].clone(),
            x[11].clone(),
        ],
        _ => panic!("Unsupported extension degree"),
    }
}

pub fn direct_to_tower<F>(x: &[FieldElement<F>], ext_degree: usize) -> Vec<FieldElement<F>>
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    assert_eq!(x.len(), ext_degree);
    let nr_a0 = &FieldElement::<F>::from(F::get_curve_params().nr_a0);
    match ext_degree {
        2 => x.to_vec(),
        6 => vec![
            &x[0] + nr_a0 * &x[3],
            x[3].clone(),
            &x[1] + nr_a0 * &x[4],
            x[4].clone(),
            &x[2] + nr_a0 * &x[5],
            x[5].clone(),
        ],
        12 => vec![
            &x[0] + nr_a0 * &x[6],
            x[6].clone(),
            &x[2] + nr_a0 * &x[8],
            x[8].clone(),
            &x[4] + nr_a0 * &x[10],
            x[10].clone(),
            &x[1] + nr_a0 * &x[7],
            x[7].clone(),
            &x[3] + nr_a0 * &x[9],
            x[9].clone(),
            &x[5] + nr_a0 * &x[11],
            x[11].clone(),
        ],
        _ => panic!("Unsupported extension degree"),
    }
}

pub fn tower_mul<F, E2, E6, E12>(
    a: &[FieldElement<F>],
    b: &[FieldElement<F>],
    ext_degree: usize,
) -> Vec<FieldElement<F>>
where
    F: IsPrimeField + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]> + IsSubFieldOf<E6>,
    E6: IsField<BaseType = [FieldElement<E2>; 3]> + IsSubFieldOf<E12>,
    E12: IsField<BaseType = [FieldElement<E6>; 2]>,
{
    assert_eq!(a.len(), ext_degree);
    assert_eq!(b.len(), ext_degree);
    match ext_degree {
        2 => {
            let a = to_e2(a.to_vec().try_into().unwrap());
            let b = to_e2(b.to_vec().try_into().unwrap());
            let c = a * b;
            from_e2(c).to_vec()
        }
        6 => {
            let a = to_e6(a.to_vec().try_into().unwrap());
            let b = to_e6(b.to_vec().try_into().unwrap());
            let c = a * b;
            from_e6(c).to_vec()
        }
        12 => {
            let a = to_e12(a.to_vec().try_into().unwrap());
            let b = to_e12(b.to_vec().try_into().unwrap());
            let c = a * b;
            from_e12(c).to_vec()
        }
        _ => panic!("Unsupported extension degree"),
    }
}

pub fn tower_div<F, E2, E6, E12>(
    a: &[FieldElement<F>],
    b: &[FieldElement<F>],
    ext_degree: usize,
) -> Vec<FieldElement<F>>
where
    F: IsPrimeField + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]> + IsSubFieldOf<E6>,
    E6: IsField<BaseType = [FieldElement<E2>; 3]> + IsSubFieldOf<E12>,
    E12: IsField<BaseType = [FieldElement<E6>; 2]>,
{
    assert_eq!(a.len(), ext_degree);
    assert_eq!(b.len(), ext_degree);
    match ext_degree {
        2 => {
            let a = to_e2(a.to_vec().try_into().unwrap());
            let b = to_e2(b.to_vec().try_into().unwrap());
            let c = (a / b).unwrap();
            from_e2(c).to_vec()
        }
        6 => {
            let a = to_e6(a.to_vec().try_into().unwrap());
            let b = to_e6(b.to_vec().try_into().unwrap());
            let c = (a / b).unwrap();
            from_e6(c).to_vec()
        }
        12 => {
            let a = to_e12(a.to_vec().try_into().unwrap());
            let b = to_e12(b.to_vec().try_into().unwrap());
            let c = (a / b).unwrap();
            from_e12(c).to_vec()
        }
        _ => panic!("Unsupported extension degree"),
    }
}

pub fn tower_inv<F, E2, E6, E12>(a: &[FieldElement<F>], ext_degree: usize) -> Vec<FieldElement<F>>
where
    F: IsPrimeField + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]> + IsSubFieldOf<E6>,
    E6: IsField<BaseType = [FieldElement<E2>; 3]> + IsSubFieldOf<E12>,
    E12: IsField<BaseType = [FieldElement<E6>; 2]>,
{
    let mut one = vec![FieldElement::from(0); ext_degree];
    one[0] = FieldElement::from(1);
    tower_div(&one, a, ext_degree)
}

pub fn to_e2<F, E2>(v: [FieldElement<F>; 2]) -> FieldElement<E2>
where
    F: IsPrimeField + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    FieldElement::new(v)
}

pub fn to_e6<F, E2, E6>(v: [FieldElement<F>; 6]) -> FieldElement<E6>
where
    F: IsPrimeField + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]> + IsSubFieldOf<E6>,
    E6: IsField<BaseType = [FieldElement<E2>; 3]>,
{
    let [v0, v1, v2, v3, v4, v5] = v;
    FieldElement::new([to_e2([v0, v1]), to_e2([v2, v3]), to_e2([v4, v5])])
}

pub fn to_e12<F, E2, E6, E12>(v: [FieldElement<F>; 12]) -> FieldElement<E12>
where
    F: IsPrimeField + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]> + IsSubFieldOf<E6>,
    E6: IsField<BaseType = [FieldElement<E2>; 3]> + IsSubFieldOf<E12>,
    E12: IsField<BaseType = [FieldElement<E6>; 2]>,
{
    let [v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11] = v;
    FieldElement::new([
        to_e6([v0, v1, v2, v3, v4, v5]),
        to_e6([v6, v7, v8, v9, v10, v11]),
    ])
}

pub fn from_e2<F, E2>(v: FieldElement<E2>) -> [FieldElement<F>; 2]
where
    F: IsPrimeField + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    let [v0, v1] = v.to_subfield_vec().try_into().unwrap();
    [v0, v1]
}

pub fn from_e6<F, E2, E6>(v: FieldElement<E6>) -> [FieldElement<F>; 6]
where
    F: IsPrimeField + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]> + IsSubFieldOf<E6>,
    E6: IsField<BaseType = [FieldElement<E2>; 3]>,
{
    let [a1, a2, a3] = v.to_subfield_vec().try_into().unwrap();
    let [v0, v1] = from_e2(a1);
    let [v2, v3] = from_e2(a2);
    let [v4, v5] = from_e2(a3);
    [v0, v1, v2, v3, v4, v5]
}

pub fn from_e12<F, E2, E6, E12>(v: FieldElement<E12>) -> [FieldElement<F>; 12]
where
    F: IsPrimeField + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]> + IsSubFieldOf<E6>,
    E6: IsField<BaseType = [FieldElement<E2>; 3]> + IsSubFieldOf<E12>,
    E12: IsField<BaseType = [FieldElement<E6>; 2]>,
{
    let [a0, a1] = v.to_subfield_vec().try_into().unwrap();
    let [v0, v1, v2, v3, v4, v5] = from_e6(a0);
    let [v6, v7, v8, v9, v10, v11] = from_e6(a1);
    [v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11]
}

pub fn e2_conjugate<F, E2>(a: FieldElement<E2>) -> FieldElement<E2>
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    let [x, y] = from_e2(a);
    to_e2([x, -y])
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::definitions::{BLS12381PrimeField, BN254PrimeField};

    #[test]
    fn test_nondeterministic_extension_field_mul_divmod_1() {
        let ps = [
            [
                "0x1", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0",
            ],
            [
                "0x1", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0",
            ],
            [
                "0x1",
                "0x3049ed443e0ee79060270c9094ac6390a5c1ab3db65328a47174c6c33f6bd5f2",
                "0x0",
                "0xa279a60d390f263fa2b23afda6a2160c7af52ea6fdddb7ffe26ded0e216c821",
                "0x0",
                "0x0",
                "0x0",
                "0x146bccf3dc47e8eedf574326c5188ea8e4978a568116c9aa5b8517cdeb0e1f38",
                "0x0",
                "0x10b71d55b795eb0c1590286e48c412e3434b0def1afddfc8840541b6936825fd",
                "0x0",
                "0x0",
            ],
            [
                "0x1",
                "0x10b80d23f4e55970de219c8bb6cc99af9ca48837a7da389ff6e02693c8912bf3",
                "0x0",
                "0x1999e3b5911b71ef05b218f5be987ba6f43afb6a702ffca89c7a6643b411046f",
                "0x0",
                "0x0",
                "0x0",
                "0x2a00794e593076aab0ec5e6283a9ed0ddbe6ef97af88861febd351722d50802a",
                "0x0",
                "0x22583e5a131ce5504fbb720b2081781441eeb10978efac409e27787d1fa359b6",
                "0x0",
                "0x0",
            ],
        ];
        let q = [
            "0xe894c747efef08ab122e832492446abf3359cf28786e81ab3a81a74fce2c75b",
            "0x0",
            "0x221a77eeae1aacc77e771d8440e698d3b8d2447bb8de2a046cf8c063f7523fb7",
            "0x0",
            "0x1d9393fe1dfd5bf8174a7b2086cdc6288de8ee5409946e58d5385d342633aa56",
            "0x0",
            "0x122377527927c40e63ddc4c9ef6a51a864d1e6575602045f81ddf7ae83afc4c3",
        ];
        let r = [
            "0x11d12be7502f97a642a86eb73802fe0fe4772283c9e66f3d535534c22390e0ca",
            "0x109dabf551c2a0d785f86365c9f7a4e2aae4c8e3f5bb96b72c3461402f80049e",
            "0x15e06e6b765f21da4c21d50705a9bf0f72ba0283f93e75a896235fa107d4ca4d",
            "0x23c17e1664ac6452ffdd3ca599029d07bbea4e54e00dd8289aa145149627cc90",
            "0x751d37ad50cc00d6245f08ca81ce16f9a3714c3efe87c95ae8e132234b5dd07",
            "0x0",
            "0x1535e3c0e51be5f14093e8501425031896dfb26ec8759e3409e44e94d81e17cf",
            "0xe07f7cf5446bf6fd7f35bd2c741235928fd0f5cc82d853d0b37dd293fe1a21b",
            "0x2eae2d9b2332fb1f1c3617826ac6ede574d04ed01692a36b9743fc604b3f3bf",
            "0x2ab0d3ce9813032acfb54c2e7c43299edb854672b7bc17be60c2e1cda8e826c",
            "0x1f316d8807400efe60a15b7e5311a9031439eb344c0d84fb80044f8786d59de4",
            "0x0",
        ];
        let ps = ps
            .into_iter()
            .map(|v| {
                Polynomial::new(
                    v.into_iter()
                        .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<Vec<_>>();
        let xq = q
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let xr = r
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let (q, r) = nondeterministic_extension_field_mul_divmod(12, ps);
        let q = q.coefficients;
        let r = r.coefficients;
        assert_eq!(q, xq);
        assert_eq!(r, xr);
    }

    #[test]
    fn test_nondeterministic_extension_field_mul_divmod_2() {
        let ps = [
            [
                "0x1d7a9ffbbe137d697794dbccbd7925ea98507cf8d4445d3e89123811ede12825",
                "0x1f45aa2ee73f15e275e5c1fc0ff08be0981a61d8e7642301653a6307c7467811",
                "0x2446d99f276e4c8bc63d81e8d0c1e37c901a5a569865533968e39b5083fc576e",
                "0x223bd50b771fcaa905131a5f04c3c634c9df344731b5aada49be919aaa447cc7",
                "0x24cfef2958a7c9c4d7ddfacdd59750105dcc37f6aefbf4a9ce706bc36252c47",
                "0x3a974db52b274684955cb370b0ac66e3e295ea6e9789fb7259c294210f7720e",
                "0x160b7346ec9fdd9841feb355a44845dc30c2a9ae3fb8266ad697b531de5e2fb6",
                "0xe46af84e1cbba805f204fa5ce1c9a99c79799110a56b5d534495a358f9c739f",
                "0x1f2b5709d0d7c9499b9524e9708ac412d3fa05fea9b51192113e131bd5572a21",
                "0x8a75eef583ffc3b0f690cd9eab121b1f329194c1052a86d50224b92838c5d76",
                "0xef3a64570d17038de7ec74175c125ac7e8780509764f07572ce9593878da9fb",
                "0x2a6290607745b58a7b87bc78053320664e06d12b35825f15893ad52a39f54331",
            ],
            [
                "0x14156ca1853095df27f3cb7c50eca75e794d2f14195c16df4a0f8f9dcb48bee9",
                "0xdc2a20a6107d4c49fed6b2018946bcc2a8dad06f01d099a6df0a4a55ed21b59",
                "0x14260c5afb0b1148ed80f8339cf9e06ff04257cb6c1817c4efa721fc98f69503",
                "0xafe8a09df07bf3dffefe512eb9448ef436dd090f98323135baab8ae3c766c60",
                "0x114692950f53d4f707bb02cc2b5dc98aff5936811707d6579371dae20368253c",
                "0x2dd3fca72591963149646f1e106dc0ee917551f5a9da397fe12d4a3939ce650c",
                "0x1750bd450b85cbd62ea3f1b228beff5fd364a127d6054be99a9248497b82062a",
                "0x1248cfad33a2147726169d3ce55db12ecafd74bc4b83377c168d89b919386546",
                "0x28d156bac04e64938816b055888399c99a954b82724e5f5589d549a709b2b5ef",
                "0x39e1ab153bd709556afece475580f453f9126f256fbb49c235bc75082f5f26e",
                "0x14853f940bf5c557c7f558d3e74e6617d7f08b54fd83597fed1d7e7b9d09e04",
                "0xaa480d613601947fee14a3ce2b7af4e1872fe49ae3473546aa01a618b78b125",
            ],
        ];
        let q = [
            "0x13e8e196ed7970229c16369f6f62a54fe9848ec0abbb56e77355358805db92a6",
            "0x29aa20be8afc3104b3211fb1c2636e3291bca41e1276bdbbb485917fae34c150",
            "0xcbdf387c0036815f944eeedb8a3ed8babb406326444cbed0df3e47fc7a3f440",
            "0xcc614e3d877550dc9bb19f8dfdc513f2f8fed01d3a180a2a9e475c9a29f6d96",
            "0x1a6e474f0a5394b39bd15f2390e0cfa64391cb4ffc5d435a63028ac3c744d064",
            "0x8fc0b38f1129ab34ebd5a5888f0711adecaecc7aa5312cc62508d51da03aa1e",
            "0xff9b26cf44e068601c663a62662f0ef698166a3410d4f36a68b2e46800daa6e",
            "0xf4ec161da901a5ab3f6088ede93acdbf15f0c18b653b9f7146d132c6d4111c5",
            "0x1843faa07a91bed2c949f1b3f126e0ae88d429bf7d37b5e00696b22be53ac607",
            "0x1c151df931008732415af45f4616affed9e0e64976e66cc5e2e57c799ddfa646",
            "0x1526c80d7045ccb0ae04a7cf1de7a2519ad52f885c7b9acb7bed0d027459433",
        ];
        let r = [
            "0x1", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0",
        ];
        let ps = ps
            .into_iter()
            .map(|v| {
                Polynomial::new(
                    v.into_iter()
                        .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<Vec<_>>();
        let xq = q
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let xr = r
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let (q, r) = nondeterministic_extension_field_mul_divmod(12, ps);
        let q = q.coefficients;
        let r = r.coefficients;
        assert_eq!(q, xq);
        assert_eq!(r, xr);
    }

    #[test]
    fn test_nondeterministic_extension_field_mul_divmod_3() {
        let ps = [
            ["0x1", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0"],
            ["0x1", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0"],
            ["0x183a80ffaffb035552f419948ba0d8b0148bb90e6bcbb072eece2a095bc3205571aa45062fb615d5204db9b0c13f16e4", "0x0", "0x141ce6d849b3b3ffd366962219920de592e0ea7888507ff651543f3d3a8c57b5778f9afcad1c00079fa2fc01d02a31de", "0x1", "0x0", "0x0", "0x12b7ea026b36040c682213ecc6663b4f916612568d3ceaa4876f9acffd4c8fb349a27daa5d44ff45bb92b5007dd00a56", "0x0", "0xead53480ba83b742644a3d8bfd432993007ed23c1a85090c6434e1ddd4dc8f16f8f6673fda2e538f5e9e9599b6062bc", "0x0", "0x0", "0x0"],
            ["0x9cbaaa39d75e767a38004c5e4e834cda92fe4fff0759cdfb078c61cff1349b3342fb6a19dc7ce19412c60791e787332", "0x0", "0x16422cfd0179e176be2c6e27226f61c162e6b3a7051f9e20ca33a1c7e99bd8cd5877aff6a82f042819707e2978027054", "0x1", "0x0", "0x0", "0x12138c3d7561ca85c9104207590388d773edbd1c46ecd9a2c1361c65ba39f487ff39a9d5edbbd942ee1bd5aae5fba357", "0x0", "0x709ac70c47538c5c9b0049aed2d39ed130b9053cd39a2c8534dfa6cb7ae9a6e13d78c0d5c7382ae146e085e91eeb43c", "0x0", "0x0", "0x0"],
            ["0x9f80115619172e4eaaf3a62b7d000cc462cff591e011ff8c39ec0595d8b263320711ed10ee74568947c52ac80f129bc", "0x0", "0x31679196cf9cc8a93705f2bb6cbcbb0e7b0196b962472706b416552474f667dd33b2d50a9800ac99110e7750e1d1618", "0x1", "0x0", "0x0", "0x4569b6e40372c16710ab2e2f85b80033cfab50f70f991c76de84083a53f47d14e26fa59b9a8fc74f8b95bcefb1f92fb", "0x0", "0x11efd369477790f94456f4fc5baea8c480249c8f56623b31e444435bd1e8b39e757ca81b8d19b958d6b425a17c15ec7f", "0x0", "0x0", "0x0"],
            ["0x142105c43e7e33dbcc983f7b693970ae4ea601a5c627832343932cf6f182d6ef712a0d4b0cfbfb92da1e505c39cf5bc0", "0x0", "0x83e650c23da50b57d95f2ef421a27900ff6e0f98249dd136de37c6c48fa04f830455843af17f7b00406d3ee2534e65d", "0x1", "0x0", "0x0", "0x15ad49314f1e2bbf517f7d37bb828abdedefb77d9e7762477bac0436451e74e9131399b84307d62da5495a0f3708b9cb", "0x0", "0x195ed72d7f572bb7dc0a78b45f824d75e155eb0dc7430f1544193109d75e4dbf5167d465a21b346c1ece84d7938e7107", "0x0", "0x0", "0x0"],
        ];
        let q = ["0x15b1a92444c003fd30d2759337ee1d2b521d89eb3e8d5f9c89def701a70b9e590d409ee54018189157fb5b83fbc6e281", "0x3b383b5cd40d3b067def58412145c9dabdd2b59b7cd1cf07f832e97d05219ca794c099ba76477110a811e0a886fb833", "0xadbf541db6df55a263938da2e0ae43b6c9217f748fc8d2e668133cc88eec729e76b65fc361a4b58266ae0c46b5d3b7e", "0x19da2ede02f3dc475518f4df24b7478c26ef3e18edce534e307f24161b09dd2f287fe8a27c63bd9f145b2a3f782eb0d1", "0x13f314681f4f7af49a1de550de5c171c36fa385ab2c0ecdbc73aee60cf8374ab43795b72d38f3e3bfe70505932163789", "0x12426b3d3990b9b961f1686e6274f1b97fbd3646512c80a0e5ee05c2ff5193709e760abbb6c676531078a768bedd7124", "0x10c8f0fec5ead5f4d5d7bb706d5e3da8f609a48a4da086ee82bc3b9d27ef5e52af16c8b309cf88c0d433985fc56b1e42", "0x5cb67da1dd940f40ecffb3f4683b6f6253fc005fbd345d5fa74ed9b0c33de90b875699040e7a4298059eb58baced6bf", "0xecffb82dcfdf5bdf438503c919684f0cfe228611387f6b404c7fdd0d0a4c1f2615e65450f4cc416f27038f083bc5e9c", "0x44b8912d0d9311ae5eb2205969a85d426b3d6c5d58cd3db35ffe118abb24510c503b91a0c476274832acc12327506d8", "0x151de551fd53045ea8127ed3887126378157871289970127638dcf0214f26b2c946216c5e4418a0b5b8e19e14984714b", "0x1b9bcc051f541e88e9377684505f5ded93b7d350b427ec2ba79970220ad2f6f781be5559762b1789038fe7c8f1d8fd7", "0x539e9ef4cfe0c1c409c6b724f8420997dcd0d0e0b8c12d44a883d8188fc1f8802753128bcb3533c154c449e4986e2d7", "0x10e1aafbcaeb68abb0fa69263c5a78ffea85c3fcee39a9ea478f3e7953407c81d32bb8808bde55c8c2b4fd37a4aeea73", "0x17b51d4ffaf4e7cb1b66757d4658959ee4492146684bac3062740594c753d58362c79d57ba6a46323404ea6219f70a51", "0xc0084a4d0393cd3768c8733ac77addd268dd86fcd3de379a08aab70a1a96c8bad202694ab0cc9e9dd401bf576ccc0ac", "0x14fdce739f217fefb6716848b5618143fdfb07de6c348ce5d0dcaaf3d3dfb07f8bc0883376eb80ccdc7db9ca23acee1c", "0x0", "0x2b05f7876fe128e401cd7f696383c57f638f58d1dd09fdcbd0d28ff4561e9e3f3a90da3b62783914f74a2bce9c76cfc", "0x0", "0x186ebefaece7849868ec8c230d6c288155e9f9376c0e6db3e75dbd02d80456323a4bfd6ea33441ab580942a3fe2f9364"];
        let r = ["0xc71fb5b76cf57e5c7c9dbbd201062289f97dedce8bbb72d15abaec86c40039d3b4f3fccb7338ff3e7701b7f6619769b", "0x129a0a7e9efe3f397b5dbcae1f22f39c0cbcf4d183ead8de682a7571560cc28f2c13ecc7628b11dda4fcc3eaef203a45", "0x162ca20e57a4ad07f919b85c9975acd11d5f0cddd22192ebc465e5a89a0546be2ec98581fcda54c808aa8790189addd6", "0x10a05ef6bc41b1ac2ba68a585a4c7016589ffad9c5412bf00fd0f50f8ac9ea3d9a7db639e62eae3ca960447fb588a60b", "0x16dbc5bd5769b32d94959f3a71085f5adc66454928e158caeecda06706afd32cea844001820431c1f3534760c01c3ce5", "0x199988fcc386f48448a34d747599bd68a9bb4993cc0e6d2434e9182475096fe323352ae743be4cec47278fbbb8d52f52", "0x189109c92dac219f6b362d169e4ca995bbd0536c8727610f0f361f3490e9d41a94c69d397c1401b31b5a973bc393f3b1", "0x19ea64dde64bbb01d1072ca0532cbe26f8227deaf22155b2ba4bacf79ec45d43bbecca1bb35c6efdd163d6d7ff862979", "0xd9b819680b2cfa830393d2a883cbf07d691020e2a01580c62c9bb1869a1c40317ab6b0df57ff873f2b4bc93d71985e5", "0x704a7bc9193e53c9dde39b3a0a34d0e76345261a4caa612bb3ee39b3715a0d649760f83a32b24cc4b37fe549e80afde", "0x117957ce838607a66a58785c7af8af5a2d3a1832a559f19b20af84c9a5e968cabea23dd6815968b93234b9b34f8108e1", "0xae22d05bd7cd226ba438387b13606f1ad88319c787ccdcec28ab4de6e9bd5fd1ede497ebb746c3313cd6655b961689d"];
        let ps = ps
            .into_iter()
            .map(|v| {
                Polynomial::new(
                    v.into_iter()
                        .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<Vec<_>>();
        let xq = q
            .into_iter()
            .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let xr = r
            .into_iter()
            .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let (q, r) = nondeterministic_extension_field_mul_divmod(12, ps);
        let q = q.coefficients;
        let r = r.coefficients;
        assert_eq!(q, xq);
        assert_eq!(r, xr);
    }

    #[test]
    fn nondeterministic_extension_field_div_1() {
        let x = [
            "0x2f6a437ba87bf892de86475ec2155dd6bf2acf7ddb7ad74c028c1a0bd146a17d",
            "0xc2fc4dd8bf1d0a89f2a486ff97fe6ba7ef3267310f51196b7463fd620b3b35a",
        ];
        let y = [
            "0x2590bd4bb718dbd69556e3011b96811fc7a3ced21887a6f699cd9802cdf4fb54",
            "0x120d13a0b0bfe0ebd93d335ad218672b78966266e1671de6ab59b5b9a2452eb6",
        ];
        let z = [
            "0x237db2935c4432bc98005e68cacde68a193b54e64d347301094edcbfa224d3d5",
            "0x124077e14a7d826a707c3ec1809ae9bafafa05dd6b4ba735fba44e801d415637",
        ];
        let x = Polynomial::new(
            x.into_iter()
                .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let y = Polynomial::new(
            y.into_iter()
                .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let xz = z
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree12ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree2ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree6ExtensionField;
        let z = nondeterministic_extension_field_div::<
            BN254PrimeField,
            Degree2ExtensionField,
            Degree6ExtensionField,
            Degree12ExtensionField,
        >(x, y, 2);
        let z = z.coefficients;
        assert_eq!(z, xz);
    }

    #[test]
    fn nondeterministic_extension_field_div_2() {
        let x = [
            "0x1", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0",
        ];
        let y = [
            "0x14156ca1853095df27f3cb7c50eca75e794d2f14195c16df4a0f8f9dcb48bee9",
            "0xdc2a20a6107d4c49fed6b2018946bcc2a8dad06f01d099a6df0a4a55ed21b59",
            "0x14260c5afb0b1148ed80f8339cf9e06ff04257cb6c1817c4efa721fc98f69503",
            "0xafe8a09df07bf3dffefe512eb9448ef436dd090f98323135baab8ae3c766c60",
            "0x114692950f53d4f707bb02cc2b5dc98aff5936811707d6579371dae20368253c",
            "0x2dd3fca72591963149646f1e106dc0ee917551f5a9da397fe12d4a3939ce650c",
            "0x1750bd450b85cbd62ea3f1b228beff5fd364a127d6054be99a9248497b82062a",
            "0x1248cfad33a2147726169d3ce55db12ecafd74bc4b83377c168d89b919386546",
            "0x28d156bac04e64938816b055888399c99a954b82724e5f5589d549a709b2b5ef",
            "0x39e1ab153bd709556afece475580f453f9126f256fbb49c235bc75082f5f26e",
            "0x14853f940bf5c557c7f558d3e74e6617d7f08b54fd83597fed1d7e7b9d09e04",
            "0xaa480d613601947fee14a3ce2b7af4e1872fe49ae3473546aa01a618b78b125",
        ];
        let z = [
            "0x1d7a9ffbbe137d697794dbccbd7925ea98507cf8d4445d3e89123811ede12825",
            "0x1f45aa2ee73f15e275e5c1fc0ff08be0981a61d8e7642301653a6307c7467811",
            "0x2446d99f276e4c8bc63d81e8d0c1e37c901a5a569865533968e39b5083fc576e",
            "0x223bd50b771fcaa905131a5f04c3c634c9df344731b5aada49be919aaa447cc7",
            "0x24cfef2958a7c9c4d7ddfacdd59750105dcc37f6aefbf4a9ce706bc36252c47",
            "0x3a974db52b274684955cb370b0ac66e3e295ea6e9789fb7259c294210f7720e",
            "0x160b7346ec9fdd9841feb355a44845dc30c2a9ae3fb8266ad697b531de5e2fb6",
            "0xe46af84e1cbba805f204fa5ce1c9a99c79799110a56b5d534495a358f9c739f",
            "0x1f2b5709d0d7c9499b9524e9708ac412d3fa05fea9b51192113e131bd5572a21",
            "0x8a75eef583ffc3b0f690cd9eab121b1f329194c1052a86d50224b92838c5d76",
            "0xef3a64570d17038de7ec74175c125ac7e8780509764f07572ce9593878da9fb",
            "0x2a6290607745b58a7b87bc78053320664e06d12b35825f15893ad52a39f54331",
        ];
        let x = Polynomial::new(
            x.into_iter()
                .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let y = Polynomial::new(
            y.into_iter()
                .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let xz = z
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree12ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree2ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree6ExtensionField;
        let z = nondeterministic_extension_field_div::<
            BN254PrimeField,
            Degree2ExtensionField,
            Degree6ExtensionField,
            Degree12ExtensionField,
        >(x, y, 12);
        let z = z.coefficients;
        assert_eq!(z, xz);
    }

    #[test]
    fn nondeterministic_extension_field_div_3() {
        let x = ["0xcebfbdf0b4abf3a47cd17cf6b889effc2af960568f453fe4b87e955f8a854ba4df986c2aa1974e16b32c53379d3e81f", "0x8acd6cd869315ed3703b767ffdbb324a2e3f13b6352bdcb503496ebf38b120e3b623f3a913c43356e4431c1e9ca9332"];
        let y = ["0x19cbaa4ee4fadc2319939b8db45c6a355bfb3755197ba74eda8534d2a2c1a2592475939877594513c326a90c11705002", "0xc0d89405d4e69986559a56057851733967c50fd0b4ec75e4ce92556ae5d33567e6e1a4eb9d83b4355520ebfe0bef37c"];
        let z = ["0x15a76ee3d8d1c3451005d56067cd27cf7598a85f81c23cd926ad0ec05ad6440f1df034cf36701a5831c9fb39250e2ea9", "0x16d96e785c797fb5d6afcb1400d7656829a6a71c42deb7ddce5cd2ccda4704dc0e4b92b69009367bbf6e6aa19488df66"];
        let x = Polynomial::new(
            x.into_iter()
                .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let y = Polynomial::new(
            y.into_iter()
                .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let xz = z
            .into_iter()
            .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree6ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree12ExtensionField;
        let z = nondeterministic_extension_field_div::<
            BLS12381PrimeField,
            Degree2ExtensionField,
            Degree6ExtensionField,
            Degree12ExtensionField,
        >(x, y, 2);
        let z = z.coefficients;
        assert_eq!(z, xz);
    }
}
