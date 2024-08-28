use crate::ecip::rational_function::FunctionFelt;
use lambdaworks_math::{
    field::{element::FieldElement, traits::IsPrimeField},
    traits::ByteConversion,
};
use num_bigint::BigUint;

pub fn parse_field_elements_from_list<F>(values: &[BigUint]) -> Result<Vec<FieldElement<F>>, String>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    values.iter().map(element_from_biguint).collect()
}

pub fn element_from_biguint<F>(value: &BigUint) -> Result<FieldElement<F>, String>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    element_from_bytes_be(&value.to_bytes_be())
}

pub fn element_from_bytes_be<F>(bytes: &[u8]) -> Result<FieldElement<F>, String>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    // TODO instead of error wrap value within prime field
    let length = (F::field_bit_size() + 7) / 8;
    let pad_length = length.saturating_sub(bytes.len());
    let mut padded_bytes = vec![0u8; pad_length];
    padded_bytes.extend(bytes);
    FieldElement::from_bytes_be(&padded_bytes)
        .map_err(|e| format!("Byte conversion error: {:?}", e))
}

pub fn format_field_elements_from_list<F: IsPrimeField>(
    values: &[FieldElement<F>],
) -> Vec<BigUint> {
    values.iter().map(element_to_biguint).collect()
}

pub fn element_to_biguint<F: IsPrimeField>(x: &FieldElement<F>) -> BigUint {
    // TODO improve this to use BigUint::from_bytes_be(x.to_bytes_be())
    let mut s = x.representative().to_string();
    if let Some(stripped) = s.strip_prefix("0x") {
        s = stripped.to_string();
    }
    BigUint::parse_bytes(s.as_bytes(), 16).unwrap()
}

pub fn element_to_element<F1, F2>(x: &FieldElement<F1>) -> FieldElement<F2>
where
    F1: IsPrimeField,
    F2: IsPrimeField,
    FieldElement<F1>: ByteConversion,
    FieldElement<F2>: ByteConversion,
{
    element_from_biguint(&element_to_biguint(x)).unwrap()
}

pub fn padd_function_felt<F: IsPrimeField>(
    f: &FunctionFelt<F>,
    n: usize,
) -> [Vec<FieldElement<F>>; 4] {
    fn pad_vec<F: IsPrimeField>(v: &mut Vec<FieldElement<F>>, n: usize) {
        assert!(v.len() <= n);
        while v.len() < n {
            v.push((0u64).into());
        }
    }
    let mut a_num = f.a.numerator.coefficients.clone();
    let mut a_den = f.a.denominator.coefficients.clone();
    let mut b_num = f.b.numerator.coefficients.clone();
    let mut b_den = f.b.denominator.coefficients.clone();
    pad_vec(&mut a_num, n + 1);
    pad_vec(&mut a_den, n + 2);
    pad_vec(&mut b_num, n + 2);
    pad_vec(&mut b_den, n + 5);
    [a_num, a_den, b_num, b_den]
}

pub fn u128_from_bytes_be(bytes: &[u8]) -> u128 {
    assert!(bytes.len() <= 16);
    let mut v = 0;
    for byte in bytes {
        v = (v << 8) | (*byte as u128);
    }
    v
}

pub fn u128_to_bytes_be(v: u128) -> Vec<u8> {
    let mut bytes = vec![];
    let mut v = v;
    while v > 0 {
        bytes.push(v as u8);
        v >>= 8;
    }
    bytes.reverse();
    bytes
}

pub fn element_from_u128<F>(value: u128) -> FieldElement<F>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    element_from_bytes_be(&u128_to_bytes_be(value)).expect("larger than field element")
}

pub fn element_to_limbs<F>(x: &FieldElement<F>) -> [u128; 4]
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    byte_slice_split::<4, 96>(&x.to_bytes_be())
}

pub fn scalar_to_limbs(x: &BigUint) -> [u128; 2] {
    byte_slice_split::<2, 128>(&x.to_bytes_be())
}

pub fn biguint_split<const N: usize, const SIZE: usize>(x: &BigUint) -> [u128; N] {
    byte_slice_split::<N, SIZE>(&x.to_bytes_be())
}

pub fn byte_slice_split<const N: usize, const SIZE: usize>(bytes: &[u8]) -> [u128; N] {
    assert!(SIZE <= 128 && SIZE % 8 == 0);
    assert!(bytes.len() <= N * SIZE / 8);
    let mut bytes = bytes;
    let mut limbs = [0u128; N];
    for limb in limbs.iter_mut().take(N) {
        let index = bytes.len().saturating_sub(SIZE / 8);
        let slice = &bytes[index..];
        *limb = u128_from_bytes_be(slice);
        bytes = &bytes[..index];
    }
    limbs
}
