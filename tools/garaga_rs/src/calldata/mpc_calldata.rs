use crate::algebra::g1g2pair::G1G2Pair;
use crate::algebra::polynomial::Polynomial;
use crate::definitions::{CurveID, CurveParamsProvider, Stark252PrimeField};
use crate::io::{
    element_from_bytes_be, field_element_to_u288_limbs, field_element_to_u384_limbs,
    field_elements_from_big_uints, parse_g1_g2_pairs_from_flattened_field_elements_list,
};
use crate::pairing::multi_miller_loop::miller_loop;
use crate::pairing::multi_pairing_check::{get_max_q_degree, multi_pairing_check};
use crate::poseidon_transcript::CairoPoseidonTranscript;
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::{IsField, IsPrimeField, IsSubFieldOf};
use lambdaworks_math::traits::ByteConversion;
use num_bigint::BigUint;

pub fn mpc_calldata_builder(
    curve_id: usize,
    values1: &[BigUint],
    n_fixed_g2: usize,
    values2: &[BigUint],
) -> Result<Vec<BigUint>, String> {
    if values1.len() % 6 != 0 {
        return Err("Pairs values length must be a multiple of 6".to_string());
    }
    let n_pairs = values1.len() / 6;
    if n_pairs < 2 {
        return Err("A minimum number of 2 pairs is required".to_string());
    }
    if !values2.is_empty() && values2.len() != 6 {
        return Err("Public pair values length must be 0 or 6".to_string());
    }
    if n_fixed_g2 > n_pairs {
        return Err("Fixed G2 count must be less than or equal to pairs count".to_string());
    }
    let curve_id = CurveID::try_from(curve_id)?;
    match curve_id {
        CurveID::BN254 => {
            use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::BN254PrimeField;
            use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree2ExtensionField;
            use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree6ExtensionField;
            use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree12ExtensionField;
            handle_curve::<
                true,
                BN254PrimeField,
                Degree2ExtensionField,
                Degree6ExtensionField,
                Degree12ExtensionField,
            >(values1, n_fixed_g2, values2)
        }
        CurveID::BLS12_381 => {
            use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::BLS12381PrimeField;
            use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField;
            use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree6ExtensionField;
            use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree12ExtensionField;
            handle_curve::<
                false,
                BLS12381PrimeField,
                Degree2ExtensionField,
                Degree6ExtensionField,
                Degree12ExtensionField,
            >(values1, n_fixed_g2, values2)
        }
        _ => Err("Unsupported curve".to_string()),
    }
}

fn handle_curve<const USE_288: bool, F, E2, E6, E12>(
    values1: &[BigUint],
    n_fixed_g2: usize,
    values2: &[BigUint],
) -> Result<Vec<BigUint>, String>
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]> + IsSubFieldOf<E6>,
    E6: IsField<BaseType = [FieldElement<E2>; 3]> + IsSubFieldOf<E12>,
    E12: IsField<BaseType = [FieldElement<E6>; 2]>,
    FieldElement<F>: ByteConversion,
{
    let elements = field_elements_from_big_uints::<F>(values1);
    let pairs = parse_g1_g2_pairs_from_flattened_field_elements_list(&elements)?;
    let public_pair = if values2.len() == 6 {
        let elements = field_elements_from_big_uints::<F>(values2);
        let pairs = parse_g1_g2_pairs_from_flattened_field_elements_list(&elements)?;
        Some(pairs[0].clone())
    } else {
        None
    };
    calldata_builder::<USE_288, F, E2, E6, E12>(&pairs, n_fixed_g2, &public_pair)
}

fn extra_miller_loop_result<F, E2>(public_pair: &G1G2Pair<F, E2>) -> Polynomial<F>
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    miller_loop(&[public_pair.g1.clone()], &[public_pair.g2.clone()])
}

fn multi_pairing_check_result<F, E2, E6, E12>(
    pairs: &[G1G2Pair<F, E2>],
    public_pair: &Option<G1G2Pair<F, E2>>,
    m: &Option<Polynomial<F>>,
) -> (
    Polynomial<F>,
    Option<Polynomial<F>>,
    Polynomial<F>,
    Vec<FieldElement<F>>,
    Vec<Polynomial<F>>,
    Vec<Polynomial<F>>,
)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]> + IsSubFieldOf<E6>,
    E6: IsField<BaseType = [FieldElement<E2>; 3]> + IsSubFieldOf<E12>,
    E12: IsField<BaseType = [FieldElement<E6>; 2]>,
    FieldElement<F>: ByteConversion,
{
    assert!(pairs.len() >= 2);
    let mut p = vec![];
    let mut q = vec![];
    for pair in pairs {
        p.push(pair.g1.clone());
        q.push(pair.g2.clone());
    }
    let (f, lambda_root, lambda_root_inverse, scaling_factor, qis, ris) =
        multi_pairing_check(&p, &q, m);
    let curve_id = F::get_curve_params().curve_id;
    let ris = match curve_id {
        CurveID::BN254 => ris[1..].to_vec(),
        CurveID::BLS12_381 => ris,
        _ => unimplemented!(),
    };
    let ris = if public_pair.is_none() {
        ris
    } else {
        ris[..ris.len() - 1].to_vec()
    };
    (
        f,
        lambda_root,
        lambda_root_inverse,
        scaling_factor,
        qis,
        ris,
    )
}

fn hash_hints_and_get_base_random_rlc_coeff<F, E2>(
    pairs: &[G1G2Pair<F, E2>],
    n_fixed_g2: usize,
    lambda_root: &Option<Polynomial<F>>,
    lambda_root_inverse: &Polynomial<F>,
    scaling_factor: &[FieldElement<F>],
    ris: &[Polynomial<F>],
) -> (FieldElement<F>, CairoPoseidonTranscript)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
    FieldElement<F>: ByteConversion,
{
    let curve_id = F::get_curve_params().curve_id;
    let curve_name = match curve_id {
        CurveID::BN254 => "BN254",
        CurveID::BLS12_381 => "BLS12_381",
        _ => unimplemented!(),
    };
    let init_hash_text = format!("MPCHECK_{}_{}P_{}F", curve_name, pairs.len(), n_fixed_g2);
    let init_hash_hex = "0x".to_owned()
        + &init_hash_text
            .as_bytes()
            .iter()
            .fold(String::new(), |mut acc, byte| {
                use std::fmt::Write;
                write!(&mut acc, "{:02X}", byte).unwrap();
                acc
            });
    let init_hash = FieldElement::from_hex(&init_hash_hex).unwrap();
    let mut transcript = CairoPoseidonTranscript::new(init_hash);
    for pair in pairs {
        let (x, y) = pair.g1.get_coords();
        transcript.hash_emulated_field_elements(&x, None);
        transcript.hash_emulated_field_elements(&y, None);
        let (x, y) = pair.g2.get_coords();
        transcript.hash_emulated_field_elements(&x, None);
        transcript.hash_emulated_field_elements(&y, None);
    }
    if let Some(lambda_root) = lambda_root {
        assert_eq!(curve_id, CurveID::BN254);
        transcript.hash_emulated_field_elements(&lambda_root.get_coefficients_ext_degree(12), None);
    }
    transcript
        .hash_emulated_field_elements(&lambda_root_inverse.get_coefficients_ext_degree(12), None);
    transcript.hash_emulated_field_elements(scaling_factor, None);
    for ri in ris {
        transcript.hash_emulated_field_elements(&ri.get_coefficients_ext_degree(12), None);
    }
    (
        element_from_bytes_be(&transcript.state[1].to_bytes_be()),
        transcript,
    )
}

fn compute_big_q_coeffs<F>(
    n_pairs: usize,
    qis: &[Polynomial<F>],
    ris_len: usize,
    c0: &FieldElement<F>,
) -> Vec<FieldElement<F>>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let curve_id = F::get_curve_params().curve_id;
    let extra_n = match curve_id {
        CurveID::BN254 => 1,
        CurveID::BLS12_381 => 0,
        _ => unimplemented!(),
    };
    let n_relations_with_ci = ris_len + extra_n;
    let (mut ci, mut big_q) = (c0.clone(), Polynomial::<F>::zero());
    for qi in qis.iter().take(n_relations_with_ci) {
        big_q = big_q + (qi * &Polynomial::new(vec![ci.clone()]));
        ci *= ci.clone();
    }
    let big_q_expected_len = get_max_q_degree(curve_id, n_pairs) + 1;
    let mut big_q_coeffs = big_q.coefficients;
    while big_q_coeffs.len() < big_q_expected_len {
        big_q_coeffs.push(FieldElement::from(0));
    }
    big_q_coeffs
}

// def _hash_big_Q_and_get_z(
//     self, transcript: CairoPoseidonTranscript, big_Q: list[PyFelt]
// ):
//     transcript.hash_limbs_multi(big_Q)
//     return self.field(transcript.s0)

fn hash_big_q_and_get_z<F, E2>(
    transcript: &mut CairoPoseidonTranscript,
    big_q: &[FieldElement<F>],
) -> FieldElement<Stark252PrimeField>
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
    FieldElement<F>: ByteConversion,
{
    transcript.hash_emulated_field_elements(big_q, None);
    transcript.state[0]
}

fn build_mpcheck_hint<F, E2, E6, E12>(
    pairs: &[G1G2Pair<F, E2>],
    n_fixed_g2: usize,
    public_pair: &Option<G1G2Pair<F, E2>>,
) -> (
    Polynomial<F>,
    Option<Polynomial<F>>,
    Polynomial<F>,
    Vec<FieldElement<F>>,
    Vec<Polynomial<F>>,
    Vec<FieldElement<F>>,
    FieldElement<Stark252PrimeField>,
    Option<Vec<FieldElement<F>>>,
)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]> + IsSubFieldOf<E6>,
    E6: IsField<BaseType = [FieldElement<E2>; 3]> + IsSubFieldOf<E12>,
    E12: IsField<BaseType = [FieldElement<E6>; 2]>,
    FieldElement<F>: ByteConversion,
{
    let n_pairs = pairs.len();
    assert!(n_pairs >= 2);
    assert!(n_fixed_g2 <= n_pairs);

    let m = public_pair
        .as_ref()
        .map(|public_pair| extra_miller_loop_result(public_pair));
    let (f, lambda_root, lambda_root_inverse, scaling_factor, qis, ris) =
        multi_pairing_check_result(pairs, public_pair, &m);
    let (c0, mut transcript) = hash_hints_and_get_base_random_rlc_coeff(
        pairs,
        n_fixed_g2,
        &lambda_root,
        &lambda_root_inverse,
        &scaling_factor,
        &ris,
    );
    let big_q_coeffs = compute_big_q_coeffs(n_pairs, &qis, ris.len(), &c0);
    let z = hash_big_q_and_get_z(&mut transcript, &big_q_coeffs);

    let small_q = if public_pair.is_none() {
        None
    } else {
        let mut coeffs = qis[qis.len() - 1].coefficients.clone();
        while coeffs.len() < 11 {
            coeffs.push(FieldElement::from(0));
        }
        Some(coeffs)
    };

    (
        f,
        lambda_root,
        lambda_root_inverse,
        scaling_factor,
        ris,
        big_q_coeffs,
        z,
        small_q,
    )
}

pub fn calldata_builder<const USE_288: bool, F, E2, E6, E12>(
    pairs: &[G1G2Pair<F, E2>],
    n_fixed_g2: usize,
    public_pair: &Option<G1G2Pair<F, E2>>,
) -> Result<Vec<BigUint>, String>
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]> + IsSubFieldOf<E6>,
    E6: IsField<BaseType = [FieldElement<E2>; 3]> + IsSubFieldOf<E12>,
    E12: IsField<BaseType = [FieldElement<E6>; 2]>,
    FieldElement<F>: ByteConversion,
{
    let (f, lambda_root, lambda_root_inverse, scaling_factor, ris, big_q_coeffs, z, small_q) =
        build_mpcheck_hint(pairs, n_fixed_g2, public_pair);

    if f != Polynomial::one() {
        return Err("Pairing check is not == 1".to_string());
    }

    let mut call_data = vec![];
    let call_data_ref = &mut call_data;

    fn push<T>(call_data_ref: &mut Vec<BigUint>, value: T)
    where
        BigUint: From<T>,
    {
        call_data_ref.push(value.into());
    }

    fn push_element<const USE_288: bool, F>(
        call_data_ref: &mut Vec<BigUint>,
        element: &FieldElement<F>,
    ) where
        F: IsPrimeField,
        FieldElement<F>: ByteConversion,
    {
        if USE_288 {
            let limbs = field_element_to_u288_limbs(element);
            for limb in limbs {
                push(call_data_ref, limb);
            }
        } else {
            let limbs = field_element_to_u384_limbs(element);
            for limb in limbs {
                push(call_data_ref, limb);
            }
        }
    }

    fn push_elements<const USE_288: bool, F>(
        call_data_ref: &mut Vec<BigUint>,
        elements: &[FieldElement<F>],
        prepend_length: bool,
    ) where
        F: IsPrimeField,
        FieldElement<F>: ByteConversion,
    {
        if prepend_length {
            push(call_data_ref, elements.len());
        }
        for element in elements {
            push_element::<USE_288, F>(call_data_ref, element);
        }
    }

    if let Some(lambda_root) = lambda_root {
        push_elements::<USE_288, F>(
            call_data_ref,
            &lambda_root.get_coefficients_ext_degree(12),
            false,
        );
    }
    push_elements::<USE_288, F>(
        call_data_ref,
        &lambda_root_inverse.get_coefficients_ext_degree(12),
        false,
    );
    push_elements::<USE_288, F>(call_data_ref, &scaling_factor, false);
    push(call_data_ref, ris.len());
    for ri in ris {
        push_elements::<USE_288, F>(call_data_ref, &ri.get_coefficients_ext_degree(12), false);
    }
    push_elements::<USE_288, F>(call_data_ref, &big_q_coeffs, true);

    push(call_data_ref, BigUint::from_bytes_be(&z.to_bytes_be()));

    if let Some(small_q) = small_q {
        push_elements::<USE_288, F>(call_data_ref, &small_q, false);
    }

    Ok(call_data)
}
