use crate::algebra::g1point::G1Point;
use crate::definitions::{
    BLS12381PrimeField, BN254PrimeField, CurveParamsProvider, FieldElement, GrumpkinPrimeField,
    SECP256K1PrimeField, SECP256R1PrimeField, X25519PrimeField,
};
use crate::hints::fake_glv::{get_fake_glv_hint, get_glv_fake_glv_hint};
use crate::io::{
    element_to_biguint, field_element_to_u288_limbs, field_element_to_u384_limbs,
    field_elements_from_big_uints, parse_g1_points_from_flattened_field_elements_list,
    scalar_to_limbs,
};
use lambdaworks_math::{field::traits::IsPrimeField, traits::ByteConversion};

use num_bigint::BigUint;

use crate::definitions::CurveID;

pub fn msm_calldata_builder(
    values: &[BigUint],
    scalars: &[BigUint],
    curve_id: usize,
    include_points_and_scalars: bool,
    serialize_as_pure_felt252_array: bool,
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
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
        ),
        CurveID::BLS12_381 => handle_curve::<BLS12381PrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
        ),
        CurveID::SECP256K1 => handle_curve::<SECP256K1PrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
        ),
        CurveID::SECP256R1 => handle_curve::<SECP256R1PrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
        ),
        CurveID::X25519 => handle_curve::<X25519PrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
        ),
        CurveID::GRUMPKIN => handle_curve::<GrumpkinPrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
        ),
    }
}

fn handle_curve<F>(
    values: &[BigUint],
    scalars: &[BigUint],
    curve_id: usize,
    include_points_and_scalars: bool,
    serialize_as_pure_felt252_array: bool,
) -> Result<Vec<BigUint>, String>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let elements = field_elements_from_big_uints::<F>(values);
    let points = parse_g1_points_from_flattened_field_elements_list(&elements)?;
    let limit = &F::get_curve_params().n;

    if !scalars.iter().all(|x| x < limit) {
        return Err("Scalar value must be less than the curve order".to_string());
    }

    Ok(calldata_builder::<F>(
        &points,
        scalars,
        curve_id,
        include_points_and_scalars,
        serialize_as_pure_felt252_array,
    ))
}

#[allow(non_snake_case)]
pub fn calldata_builder<F: IsPrimeField + CurveParamsProvider<F>>(
    points: &[G1Point<F>],
    scalars: &[BigUint],
    curve_id: usize,
    include_points_and_scalars: bool,
    serialize_as_pure_felt252_array: bool,
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

    let mut call_data = vec![];
    let call_data_ref = &mut call_data;

    fn push<T>(call_data_ref: &mut Vec<BigUint>, value: T)
    where
        BigUint: From<T>,
    {
        call_data_ref.push(value.into());
    }

    fn push_element<F>(call_data_ref: &mut Vec<BigUint>, element: &FieldElement<F>, use_288: bool)
    where
        F: IsPrimeField,
        FieldElement<F>: ByteConversion,
    {
        if use_288 {
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

    if serialize_as_pure_felt252_array {
        // placeholder, actual length is updated at the end
        push(call_data_ref, 0usize);
    }

    if include_points_and_scalars {
        // points
        {
            push(call_data_ref, points.len());
            for point in points {
                push_element(call_data_ref, &point.x, false);
                push_element(call_data_ref, &point.y, false);
            }
        }

        // scalars
        {
            push(call_data_ref, scalars.len());
            for i in 0..scalars.len() {
                push(call_data_ref, scalars_low[i].clone());
                push(call_data_ref, scalars_high[i].clone());
            }
        }

        // curve id
        push(call_data_ref, curve_id);
    }

    // Hint
    for (pt, scalar) in points.iter().zip(scalars.iter()) {
        match curve_id {
            0..=2 => {
                let (Q, u1, u2, v1, v2) = get_glv_fake_glv_hint(pt, scalar).unwrap();
                push_element(call_data_ref, &Q.x, false);
                push_element(call_data_ref, &Q.y, false);
                push(call_data_ref, u1);
                push(call_data_ref, u2);
                push(call_data_ref, v1);
                push(call_data_ref, v2);
            }
            _ => {
                let scalar = if scalar == &BigUint::from(0u64) {
                    BigUint::from(1u64)
                } else {
                    scalar.clone()
                };

                let (Q, u1, u2) = get_fake_glv_hint(pt, &scalar).unwrap();

                push_element(call_data_ref, &Q.x, false);
                push_element(call_data_ref, &Q.y, false);
                push(call_data_ref, u1);
                push(call_data_ref, u2);
            }
        }
    }

    if serialize_as_pure_felt252_array {
        // updates overall length
        call_data[0] = (call_data.len() - 1).into();
    }

    call_data
}

#[allow(dead_code)]
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
mod tests {}
