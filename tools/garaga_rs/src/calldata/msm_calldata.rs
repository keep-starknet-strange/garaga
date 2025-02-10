use crate::algebra::{g1point::G1Point, rational_function::FunctionFelt};
use crate::definitions::{
    BLS12381PrimeField, BN254PrimeField, CurveParamsProvider, FieldElement, GrumpkinPrimeField,
    SECP256K1PrimeField, SECP256R1PrimeField, Stark252PrimeField, X25519PrimeField,
};
use crate::{
    ecip::core::{neg_3_base_le, run_ecip},
    io::{
        element_to_biguint, felt252_to_element, field_element_to_u384_limbs,
        field_elements_from_big_uints, padd_function_felt,
        parse_g1_points_from_flattened_field_elements_list, scalar_to_limbs,
    },
    poseidon_transcript::CairoPoseidonTranscript,
};
use lambdaworks_crypto::hash::poseidon::{starknet::PoseidonCairoStark252, Poseidon};
use lambdaworks_math::{
    field::traits::{IsPrimeField, LegendreSymbol},
    traits::ByteConversion,
};

use num_bigint::BigUint;

use crate::definitions::CurveID;

pub fn msm_calldata_builder(
    values: &[BigUint],
    scalars: &[BigUint],
    curve_id: usize,
    include_digits_decomposition: Option<bool>,
    include_points_and_scalars: bool,
    serialize_as_pure_felt252_array: bool,
    risc0_mode: bool,
) -> Result<Vec<BigUint>, String> {
    if values.len() != 2 * scalars.len() {
        return Err("Values length must be twice the scalars length".to_string());
    }
    let curve_id = CurveID::try_from(curve_id)?;
    match curve_id {
        CurveID::BN254 => handle_curve::<BN254PrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_digits_decomposition,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
            risc0_mode,
        ),
        CurveID::BLS12_381 => handle_curve::<BLS12381PrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_digits_decomposition,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
            risc0_mode,
        ),
        CurveID::SECP256K1 => handle_curve::<SECP256K1PrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_digits_decomposition,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
            risc0_mode,
        ),
        CurveID::SECP256R1 => handle_curve::<SECP256R1PrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_digits_decomposition,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
            risc0_mode,
        ),
        CurveID::X25519 => handle_curve::<X25519PrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_digits_decomposition,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
            risc0_mode,
        ),
        CurveID::GRUMPKIN => handle_curve::<GrumpkinPrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_digits_decomposition,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
            risc0_mode,
        ),
    }
}

fn handle_curve<F>(
    values: &[BigUint],
    scalars: &[BigUint],
    curve_id: usize,
    include_digits_decomposition: Option<bool>,
    include_points_and_scalars: bool,
    serialize_as_pure_felt252_array: bool,
    risc0_mode: bool,
) -> Result<Vec<BigUint>, String>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let elements = field_elements_from_big_uints::<F>(values);
    let points = parse_g1_points_from_flattened_field_elements_list(&elements)?;
    let limit = if risc0_mode {
        &(BigUint::from(1usize) << 128)
    } else {
        &F::get_curve_params().n
    };
    if !scalars.iter().all(|x| x < limit) {
        if risc0_mode {
            return Err("Scalar value must be less than 2**128".to_string());
        } else {
            return Err("Scalar value must be less than the curve order".to_string());
        }
    }
    Ok(calldata_builder(
        &points,
        scalars,
        curve_id,
        include_digits_decomposition,
        include_points_and_scalars,
        serialize_as_pure_felt252_array,
        risc0_mode,
    ))
}

pub fn calldata_builder<F: IsPrimeField + CurveParamsProvider<F>>(
    points: &[G1Point<F>],
    scalars: &[BigUint],
    curve_id: usize,
    include_digits_decomposition: Option<bool>,
    include_points_and_scalars: bool,
    serialize_as_pure_felt252_array: bool,
    risc0_mode: bool,
) -> Vec<BigUint>
where
    FieldElement<F>: ByteConversion,
{
    let mut scalars_low = vec![];
    let mut scalars_high = vec![];
    for scalar in scalars {
        let [low, high] = scalar_to_limbs(scalar);
        scalars_low.push(BigUint::from(low));
        scalars_high.push(BigUint::from(high));
    }

    let (q_low, sum_dlog_div_low) = run_ecip::<F>(points, &scalars_low);
    let (q_high, sum_dlog_div_high) = run_ecip::<F>(points, &scalars_high);
    let (q_high_shifted, sum_dlog_div_high_shifted) =
        run_ecip::<F>(&[q_high.clone()], &[BigUint::from(1usize) << 128]);

    let mut transcript = hash_inputs_points_scalars_and_result_points(
        points,
        scalars,
        [&q_low, &q_high, &q_high_shifted],
        curve_id,
        risc0_mode,
    );
    let sum_dlog_div_maybe_batched = match risc0_mode {
        true => &sum_dlog_div_low,
        false => {
            let c0 = felt252_to_element(&transcript.state[1]);
            let c1 = c0.clone().square();
            let c2 = c1.clone() * c0.clone();
            &(sum_dlog_div_low.scale_by_coeff(c0)
                + sum_dlog_div_high.scale_by_coeff(c1)
                + sum_dlog_div_high_shifted.scale_by_coeff(c2))
        }
    };
    let x = retrieve_random_x_coordinate(
        &mut transcript,
        sum_dlog_div_maybe_batched,
        scalars.len(),
        !risc0_mode,
    );
    let (point, roots) = derive_ec_point_from_x(&x);

    let mut call_data = vec![];
    let call_data_ref = &mut call_data;

    fn push<T>(call_data_ref: &mut Vec<BigUint>, value: T)
    where
        BigUint: From<T>,
    {
        call_data_ref.push(value.into());
    }

    fn push_digit(call_data_ref: &mut Vec<BigUint>, digit: i8) {
        let mut value = FieldElement::<Stark252PrimeField>::from(0);
        if digit >= 0 {
            value += FieldElement::<Stark252PrimeField>::from(digit as u64);
        } else {
            value = value - FieldElement::<Stark252PrimeField>::from(-digit as u64);
        }
        push(call_data_ref, element_to_biguint(&value));
    }

    fn push_element<F>(call_data_ref: &mut Vec<BigUint>, element: &FieldElement<F>)
    where
        F: IsPrimeField,
        FieldElement<F>: ByteConversion,
    {
        let limbs = field_element_to_u384_limbs(element);
        for limb in limbs {
            push(call_data_ref, limb);
        }
    }

    if serialize_as_pure_felt252_array {
        // placeholder, actual length is updated at the end
        push(call_data_ref, 0usize);
    }

    // scalars_digits_decompositions
    if let Some(include_digits_decomposition) = include_digits_decomposition {
        let flag: usize = if include_digits_decomposition { 0 } else { 1 };
        push(call_data_ref, flag);
        if include_digits_decomposition {
            push(call_data_ref, scalars.len());
            for i in 0..scalars.len() {
                let limbs = [&scalars_low[i], &scalars_high[i]];
                for limb in limbs {
                    let digits = neg_3_base_le(limb);
                    push(call_data_ref, digits.len());
                    for digit in digits {
                        push_digit(call_data_ref, digit);
                    }
                    if risc0_mode {
                        break;
                    }
                }
            }
        }
    }

    // msm_hint
    {
        // Q_low, Q_high, Q_high_shifted
        let q_list = [&q_low, &q_high, &q_high_shifted];
        for q in q_list {
            push_element(call_data_ref, &q.x);
            push_element(call_data_ref, &q.y);
            if risc0_mode {
                break;
            }
        }

        let ff_4_polys = padd_function_felt(sum_dlog_div_maybe_batched, scalars.len(), !risc0_mode);
        for poly in ff_4_polys {
            push(call_data_ref, poly.len());
            for coeff in poly {
                push_element(call_data_ref, &coeff);
            }
        }
    }

    // derive_point_from_x_hint
    {
        // y_last_attempt
        {
            push_element(call_data_ref, &point.y);
        }

        // g_rhs_sqrt
        {
            push(call_data_ref, roots.len());
            for root in roots {
                push_element(call_data_ref, &root);
            }
        }
    }

    if include_points_and_scalars {
        // points
        {
            push(call_data_ref, points.len());
            for point in points {
                push_element(call_data_ref, &point.x);
                push_element(call_data_ref, &point.y);
            }
        }

        // scalars
        {
            push(call_data_ref, scalars.len());
            for i in 0..scalars.len() {
                push(call_data_ref, scalars_low[i].clone());
                if !risc0_mode {
                    push(call_data_ref, scalars_high[i].clone());
                }
            }
        }

        // curve id
        push(call_data_ref, curve_id);
    }

    if serialize_as_pure_felt252_array {
        // updates overall length
        call_data[0] = (call_data.len() - 1).into();
    }

    call_data
}

const INIT_HASH: &str = "0x4D534D5F4731"; // "MSM_G1" in hex
const INIT_HASH_U128: &str = "0x4D534D5F47315F55313238"; // "MSM_G1_U128" in hex

fn hash_inputs_points_scalars_and_result_points<F>(
    points: &[G1Point<F>],
    scalars: &[BigUint],
    q_list: [&G1Point<F>; 3],
    curve_id: usize,
    risc0_mode: bool,
) -> CairoPoseidonTranscript
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    let init_hash = if risc0_mode {
        INIT_HASH_U128
    } else {
        INIT_HASH
    };
    let mut transcript = CairoPoseidonTranscript::new(FieldElement::from_hex_unchecked(init_hash));
    let transcript_ref = &mut transcript;
    // curve id, msm size
    transcript_ref.update_sponge_state(
        FieldElement::<Stark252PrimeField>::from(curve_id as u64),
        FieldElement::<Stark252PrimeField>::from(scalars.len() as u64),
    );

    // points
    for point in points {
        transcript_ref.hash_emulated_field_element(&point.x);
        transcript_ref.hash_emulated_field_element(&point.y);
    }

    // Q_low, Q_high, Q_high_shifted
    for q in q_list {
        transcript_ref.hash_emulated_field_element(&q.x);
        transcript_ref.hash_emulated_field_element(&q.y);
        if risc0_mode {
            break;
        }
    }

    // scalars
    if risc0_mode {
        transcript_ref.hash_u128_multi(scalars);
    } else {
        transcript_ref.hash_u256_multi(scalars);
    }

    transcript
}

fn retrieve_random_x_coordinate<F>(
    transcript: &mut CairoPoseidonTranscript,
    sum_dlog_div_maybe_batched: &FunctionFelt<F>,
    msm_size: usize,
    batched: bool,
) -> FieldElement<Stark252PrimeField>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    // SumDlogDivLow, SumDlogDivHigh, SumDlogDivHighShifted
    let parts = padd_function_felt(sum_dlog_div_maybe_batched, msm_size, batched);
    for coeffs in parts {
        transcript.hash_emulated_field_elements(&coeffs, Option::None);
    }

    transcript.state[0]
}

fn derive_ec_point_from_x<F>(
    x_252: &FieldElement<Stark252PrimeField>,
) -> (G1Point<F>, Vec<FieldElement<F>>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let params = F::get_curve_params();
    let a = params.a;
    let b = params.b;
    let g = params.fp_generator;
    let rhs_compute = |x: &FieldElement<F>| x * x * x + &a * x + &b;

    let mut x_252 = *x_252;
    let mut rhs = rhs_compute(&felt252_to_element(&x_252));
    let mut g_rhs_roots = vec![];
    let mut attempt = 0;
    while rhs.legendre_symbol() != LegendreSymbol::One {
        let g_rhs = &rhs * &g;
        g_rhs_roots.push(sqrt(&g_rhs));
        let mut state = [x_252, FieldElement::from(attempt), FieldElement::from(2)];
        PoseidonCairoStark252::hades_permutation(&mut state);
        x_252 = state[0];
        rhs = rhs_compute(&felt252_to_element(&x_252));
        attempt += 1;
    }
    let y = sqrt(&rhs);
    (
        G1Point::new_unchecked(felt252_to_element(&x_252), y),
        g_rhs_roots,
    )
}

fn sqrt<F>(value: &FieldElement<F>) -> FieldElement<F>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    let (root1, root2) = value.sqrt().expect("there is no root");
    if element_to_biguint(&root1) < element_to_biguint(&root2) {
        root1
    } else {
        root2
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_init_hashes() {
        {
            let key = "MSM_G1";
            let bytes = key.as_bytes();
            let hex_string = bytes
                .iter()
                .map(|byte| format!("{:02X}", byte))
                .collect::<String>();
            assert_eq!(String::from("0x") + &hex_string, INIT_HASH);
        }
        {
            let key = "MSM_G1_U128";
            let bytes = key.as_bytes();
            let hex_string = bytes
                .iter()
                .map(|byte| format!("{:02X}", byte))
                .collect::<String>();
            assert_eq!(String::from("0x") + &hex_string, INIT_HASH_U128);
        }
    }
}
