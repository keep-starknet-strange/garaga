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
    values.iter().map(parse_field_element).collect()
}

pub fn parse_field_element<F>(value: &BigUint) -> Result<FieldElement<F>, String>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    from_unpadded_bytes_be(&value.to_bytes_be())
}

pub fn from_unpadded_bytes_be<F>(bytes: &[u8]) -> Result<FieldElement<F>, String>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    let length = (F::field_bit_size() + 7) / 8;
    let pad_length = length.saturating_sub(bytes.len());
    let mut padded_bytes = vec![0u8; pad_length];
    padded_bytes.extend(bytes);
    FieldElement::from_bytes_be(&padded_bytes)
        .map_err(|e| format!("Byte conversion error: {:?}", e))
}

pub fn convert_field_elements_from_list<F: IsPrimeField>(
    values: &[FieldElement<F>],
) -> Vec<BigUint> {
    values.iter().map(convert_field_element).collect()
}

pub fn convert_field_element<F: IsPrimeField>(x: &FieldElement<F>) -> BigUint {
    // TODO improve this to use BigUint::from_bytes_be(x.to_bytes_be())
    let mut s = x.representative().to_string();
    if let Some(stripped) = s.strip_prefix("0x") {
        s = stripped.to_string();
    }
    BigUint::parse_bytes(s.as_bytes(), 16).unwrap()
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

pub fn u128_to_bytes_be(v: u128) -> [u8; 16] {
    let mut bytes = [0u8; 16];
    let mut v = v;
    for i in 1..=16 {
        bytes[16 - i] = v as u8;
        v >>= 8;
    }
    bytes
}

pub fn from_u128<F>(value: u128) -> FieldElement<F>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    from_unpadded_bytes_be(&u128_to_bytes_be(value)).unwrap() // must never fail
}

pub fn biguint_split<const N: usize, const SIZE: usize>(x: &BigUint) -> [u128; N] {
    assert!(SIZE <= 128);
    let mask: BigUint = (!0u128 >> (128 - SIZE)).into();
    let mut x = x.clone();
    let mut result = [0u128; N];
    for loc in result.iter_mut().take(N) {
        *loc = (&x & &mask).try_into().unwrap(); // must never fail
        x >>= SIZE;
    }
    assert_eq!(x, (0usize).into());
    result
}
