use num_bigint::BigUint;
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::traits::ByteConversion;
use crate::algebra::g1point::G1Point;
use crate::algebra::g2point::G2Point;
use crate::algebra::polynomial::Polynomial;
use crate::definitions::{BLS12381PrimeField, BN254PrimeField, CurveID, CurveParamsProvider};
use crate::io::{element_from_bytes_be, field_elements_from_big_uints, field_element_to_u384_limbs, parse_g1_g2_pairs_from_flattened_field_elements_list};
use crate::multi_miller_loop::miller_loop;
use crate::multi_pairing_check::{get_max_q_degree, multi_pairing_check};
use crate::poseidon_transcript::CairoPoseidonTranscript;

#[derive(Debug, Clone)]
pub struct G1G2Pair<F: IsPrimeField> {
    pub g1: G1Point<F>,
    pub g2: G2Point<F>,
}

impl<F: IsPrimeField> G1G2Pair<F> {
    pub fn new(g1: G1Point<F>, g2: G2Point<F>) -> Self {
        Self { g1, g2 }
    }
}

fn extra_miller_loop_result<F>(curve_id: usize, public_pair: &G1G2Pair<F>) -> [FieldElement<F>; 12]
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    let p = [public_pair.g1.x.clone(), public_pair.g1.x.clone()];
    let q = (public_pair.g2.x.clone(), public_pair.g2.x.clone());
    return miller_loop(curve_id, &[p], &[q]);
}

fn multi_pairing_check_result<F>(curve_id: usize, pairs: &[G1G2Pair<F>], n_fixed_g2: usize, public_pair: &Option<G1G2Pair<F>>, m: &Option<[FieldElement<F>; 12]>)
    -> (Option<[FieldElement<F>; 12]>, [FieldElement<F>; 12], Vec<FieldElement<F>>, Vec<Polynomial<F>>, Vec<Vec<FieldElement<F>>>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    assert!(pairs.len() >= 2);
    let mut p = vec![];
    let mut q = vec![];
    for pair in pairs {
        let pi = [pair.g1.x.clone(), pair.g1.x.clone()];
        let qi = (pair.g2.x.clone(), pair.g2.x.clone());
        p.push(pi);
        q.push(qi);
    }
    let (lambda_root, lambda_root_inverse, scaling_factor, qis, ris) = multi_pairing_check(curve_id, &p, &q, n_fixed_g2, m);
    let ris = if curve_id == 1 { ris } else { ris[1..].to_vec() };
    let ris = if let None = public_pair { ris } else { ris[..ris.len() - 1].to_vec() };
    return (lambda_root, lambda_root_inverse, scaling_factor, qis, ris);
}

fn hash_hints_and_get_base_random_rlc_coeff<F>(curve_id: usize, pairs: &[G1G2Pair<F>], n_fixed_g2: usize, lambda_root: &Option<[FieldElement<F>; 12]>, lambda_root_inverse: &[FieldElement<F>; 12], scaling_factor: &[FieldElement<F>], ris: &[Vec<FieldElement<F>>])
    -> FieldElement<F>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    let curve_name = if curve_id == 0 { "BN254" } else { "BLS12_381" };
    let init_hash_text = format!("MPCHECK_{}_{}P_{}F", curve_name, pairs.len(), n_fixed_g2);
    let init_hash_hex = "0x".to_owned() + &init_hash_text.as_bytes().iter().map(|byte| format!("{:02X}", byte)).collect::<String>();
    let init_hash = FieldElement::from_hex(&init_hash_hex).unwrap();
    let mut transcript = CairoPoseidonTranscript::new(init_hash);
    for pair in pairs {
        transcript.hash_emulated_field_element(&pair.g1.x);
        transcript.hash_emulated_field_element(&pair.g1.y);
        transcript.hash_emulated_field_elements(&pair.g2.x, None);
        transcript.hash_emulated_field_elements(&pair.g2.y, None);
    }
    if let Some(lambda_root) = lambda_root {
        assert_eq!(curve_id, 0);
        transcript.hash_emulated_field_elements(lambda_root, None);
    }
    transcript.hash_emulated_field_elements(lambda_root_inverse, None);
    transcript.hash_emulated_field_elements(scaling_factor, None);
    for ri in ris {
        assert_eq!(ri.len(), 12);
        transcript.hash_emulated_field_elements(ri, None);
    }
    return element_from_bytes_be(&transcript.state[1].to_bytes_be());
}

fn compute_big_q_coeffs<F: IsPrimeField>(curve_id: usize, n_pairs: usize, qis: &[Polynomial<F>], ris: &[Vec<FieldElement<F>>], c0: &FieldElement<F>) -> Vec<FieldElement<F>>
{
    let n_relations_with_ci = ris.len() + (if curve_id == 0 { 1 } else { 0 });
    let (mut ci, mut big_q) = (c0.clone(), Polynomial::<F>::zero());
    for i in 0..n_relations_with_ci {
        big_q = big_q + (&qis[i] * &Polynomial::new(vec![ci.clone()]));
        ci *= ci.clone();
    }
    let big_q_expected_len = get_max_q_degree(curve_id, n_pairs) + 1;
    let mut big_q_coeffs = big_q.coefficients;
    while big_q_coeffs.len() < big_q_expected_len {
        big_q_coeffs.push(FieldElement::from(0));
    }
    return big_q_coeffs;
}

fn build_mpcheck_hint<F>(curve_id: usize, pairs: &[G1G2Pair<F>], n_fixed_g2: usize, public_pair: &Option<G1G2Pair<F>>)
    -> (Option<[FieldElement<F>; 12]>, [FieldElement<F>; 12], Vec<FieldElement<F>>, Vec<Vec<FieldElement<F>>>, Vec<FieldElement<F>>, Option<Vec<FieldElement<F>>>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let n_pairs = pairs.len();
    assert!(n_pairs >= 2);
    assert!(n_fixed_g2 <= n_pairs);

    let m = if let Some(public_pair) = public_pair { Some(extra_miller_loop_result(curve_id, public_pair)) } else  { None };
    let (lambda_root, lambda_root_inverse, scaling_factor, qis, ris) = multi_pairing_check_result(curve_id, pairs, n_fixed_g2, public_pair, &m);
    let c0 = hash_hints_and_get_base_random_rlc_coeff(curve_id, pairs, n_fixed_g2, &lambda_root, &lambda_root_inverse, &scaling_factor, &ris);
    let big_q_coeffs = compute_big_q_coeffs(curve_id, n_pairs, &qis, &ris, &c0);

    let small_q = if let None = public_pair {
        None
    }
    else {
        let mut coeffs = qis[qis.len() - 1].coefficients.clone();
        while coeffs.len() < 11 {
            coeffs.push(FieldElement::from(0));
        }
        Some(coeffs)
    };

    return (lambda_root, lambda_root_inverse, scaling_factor, ris, big_q_coeffs, small_q);
}

fn calldata_builder<F>(curve_id: usize, pairs: &[G1G2Pair<F>], n_fixed_g2: usize, public_pair: &Option<G1G2Pair<F>>) -> Vec<BigUint>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let (_lambda_root, _lambda_root_inverse, _scaling_factor, _ris, _big_q_coeffs, _small_q) = build_mpcheck_hint(curve_id, pairs, n_fixed_g2, public_pair);

    let mut call_data = vec![];
    let _call_data_ref = &mut call_data;

    fn _push<T>(call_data_ref: &mut Vec<BigUint>, value: T)
    where
        BigUint: From<T>,
    {
        call_data_ref.push(value.into());
    }

    fn _push_element<F>(call_data_ref: &mut Vec<BigUint>, element: &FieldElement<F>)
    where
        F: IsPrimeField,
        FieldElement<F>: ByteConversion,
    {
        let limbs = field_element_to_u384_limbs(element);
        for limb in limbs {
            _push(call_data_ref, limb);
        }
    }

    // TODO
    /*
    call_data.extend(mpcheck_hint.serialize_to_calldata())
    if small_Q is not None:
        call_data.extend(small_Q.serialize_to_calldata())
    */

    call_data
}

pub fn mpc_calldata_builder(
    curve_id: usize,
    values1: &[BigUint],
    n_fixed_g2: usize,
    values2: &[BigUint],
) -> Result<Vec<BigUint>, String> {
    if values1.len() % 6 == 0 && values1.len() >= 12 {
        return Err("Pairs values length must be a multiple of 6, at least 12".to_string());
    }
    if values2.len() == 0 || values2.len() == 6 {
        return Err("Public pair values length must be 0 or 6".to_string());
    }
    if n_fixed_g2 <= values1.len() / 6 {
        return Err("Fixed G2 count must be less than or equal to pairs count".to_string());
    }
    let curve_id = CurveID::try_from(curve_id)?;
    match curve_id {
        CurveID::BN254 => handle_curve::<BN254PrimeField>(
            curve_id as usize,
            values1,
            n_fixed_g2,
            values2,
        ),
        CurveID::BLS12_381 => handle_curve::<BLS12381PrimeField>(
            curve_id as usize,
            values1,
            n_fixed_g2,
            values2,
        ),
        _ => Err("Unsupported curve".to_string())
    }
}

fn handle_curve<F>(
    curve_id: usize,
    values1: &[BigUint],
    n_fixed_g2: usize,
    values2: &[BigUint],
) -> Result<Vec<BigUint>, String>
where
    F: IsPrimeField + CurveParamsProvider<F>,
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
    Ok(calldata_builder(
        curve_id,
        &pairs,
        n_fixed_g2,
        &public_pair,
    ))
}
