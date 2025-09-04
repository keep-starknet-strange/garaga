use std::array;

use lambdaworks_math::{field::traits::IsPrimeField, traits::ByteConversion};
use num_bigint::BigUint;

use crate::{
    algebra::g1point::G1Point,
    calldata::{
        full_proof_with_hints::honk::{CONST_PROOF_SIZE_LOG_N, NUMBER_OF_ENTITIES},
        G1PointBigUint,
    },
    definitions::{BN254PrimeField, FieldElement, GrumpkinPrimeField},
    io::{element_from_biguint, field_element_to_u256_limbs},
};

pub fn extract_msm_scalars<const N: usize>(
    log_circuit_size: usize,
    scalars: [Option<BigUint>; N],
) -> Vec<BigUint> {
    let i = NUMBER_OF_ENTITIES + log_circuit_size;
    let j = NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N;

    let (i, j) = if N == NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 6 {
        (i + 1, j + 1)
    } else {
        (i, j)
    };

    [&scalars[1..i], &scalars[j..]]
        .concat()
        .into_iter()
        .flatten()
        .collect()
}

// Honk/ZK_Honk Proofs related functions.
pub fn honk_proof_from_bytes_internal(
    proof_bytes: &[u8],
    public_inputs_bytes: &[u8],
    proof_size: usize,
) -> Result<(Vec<BigUint>, Vec<BigUint>), String> {
    if proof_bytes.len() != 32 * proof_size {
        return Err(format!("Invalid proof bytes length: {}", proof_bytes.len()));
    }

    if public_inputs_bytes.len() % 32 != 0 {
        return Err(format!(
            "Invalid public input bytes length: {}",
            public_inputs_bytes.len()
        ));
    }

    let values = proof_bytes
        .chunks_exact(32)
        .map(|chunk| BigUint::from_bytes_be(chunk))
        .collect();
    let public_inputs = public_inputs_bytes
        .chunks_exact(32)
        .map(|chunk| BigUint::from_bytes_be(chunk))
        .collect();

    Ok((values, public_inputs))
}

fn parse_g1_proof_point(values: [BigUint; 4]) -> G1PointBigUint {
    let [x0, x1, y0, y1] = values;
    let x = (x1 << 136) | x0;
    let y = (y1 << 136) | y0;
    G1PointBigUint::from(vec![x, y])
}

pub struct ProofParser {
    values: Vec<BigUint>,
    offset: usize,
}

impl ProofParser {
    pub fn new(values: Vec<BigUint>) -> Self {
        Self { values, offset: 0 }
    }

    pub fn extract_single(&mut self) -> BigUint {
        let value = self.values[self.offset].clone();
        self.offset += 1;
        value
    }

    pub fn extract_vec(&mut self, count: usize) -> Vec<BigUint> {
        let end = self.offset + count;
        assert!(end <= self.values.len(), "Out of bounds");
        let result = self.values[self.offset..end].to_vec();
        self.offset = end;
        result
    }

    pub fn extract_array<const N: usize>(&mut self) -> [BigUint; N] {
        self.extract_vec(N).try_into().unwrap()
    }

    pub fn extract_g1_points(&mut self, count: usize) -> Vec<G1PointBigUint> {
        (0..count)
            .map(|_| parse_g1_proof_point(self.extract_array()))
            .collect()
    }

    pub fn extract_g1_points_array<const N: usize>(&mut self) -> [G1PointBigUint; N] {
        self.extract_g1_points(N).try_into().unwrap()
    }

    pub fn extract_sumcheck_univariates<const N: usize>(
        &mut self,
    ) -> [[BigUint; N]; CONST_PROOF_SIZE_LOG_N] {
        array::from_fn(|_| self.extract_array())
    }

    pub fn current_offset(&self) -> usize {
        self.offset
    }
}

// Honk Calldata
pub fn element_on_curve(element: &BigUint) -> FieldElement<GrumpkinPrimeField> {
    element_from_biguint(element)
}

pub fn g1_point_on_curve(point: &G1PointBigUint) -> Result<G1Point<BN254PrimeField>, String> {
    G1Point::new(
        element_from_biguint(&point.x),
        element_from_biguint(&point.y),
        false,
    )
}

pub fn biguint_slice_to_field_element(b: &[BigUint]) -> Vec<FieldElement<GrumpkinPrimeField>> {
    b.iter().map(element_from_biguint).collect()
}

pub fn array_to_field_element<const N: usize>(
    a: &[BigUint; N],
) -> [FieldElement<GrumpkinPrimeField>; N] {
    std::array::from_fn(|i| element_from_biguint(&a[i]))
}

pub fn g1_slice_to_curve<const N: usize>(
    pts: &[G1PointBigUint; N],
) -> Result<[G1Point<BN254PrimeField>; N], String> {
    pts.iter()
        .map(g1_point_on_curve)
        .collect::<Result<Vec<_>, _>>()?
        .try_into()
        .map_err(|_| "length mismatch".to_string())
}

pub fn g1_slice_ref_to_curve<const N: usize>(
    pts: &[&G1PointBigUint; N],
) -> Result<[G1Point<BN254PrimeField>; N], String> {
    pts.iter()
        .map(|point| g1_point_on_curve(point))
        .collect::<Result<Vec<_>, _>>()?
        .try_into()
        .map_err(|_| "length mismatch".to_string())
}

#[macro_export]
macro_rules! declare_element_on_curve {
    ($transcript:expr, $curve:ident, $($name:ident),*) => {
        $(
            let $name = $curve(&$transcript.$name);
        )*
    };
}

#[macro_export]
macro_rules! transform_fields {
    ($vk:expr, $transform:ident, $($field:ident),+ $(,)?) => {
        $(
        let $field =$transform(&$vk.$field)?;
        )+
    };
}

pub fn push<T>(call_data_ref: &mut Vec<BigUint>, value: T)
where
    BigUint: From<T>,
{
    call_data_ref.push(value.into());
}

pub fn push_element<F>(call_data_ref: &mut Vec<BigUint>, element: &FieldElement<F>)
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    let limbs = field_element_to_u256_limbs(element);
    for limb in limbs {
        push(call_data_ref, limb);
    }
}

pub fn push_elements(
    call_data_ref: &mut Vec<BigUint>,
    elements: &[FieldElement<GrumpkinPrimeField>],
    prepend_length: bool,
) {
    if prepend_length {
        push(call_data_ref, elements.len());
    }
    for element in elements {
        push_element(call_data_ref, element);
    }
}

pub fn push_point(call_data_ref: &mut Vec<BigUint>, point: &G1Point<BN254PrimeField>) {
    push_element(call_data_ref, &point.x);
    push_element(call_data_ref, &point.y);
}
