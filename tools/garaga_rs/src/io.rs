use crate::ecip::rational_function::FunctionFelt;
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::traits::ByteConversion;
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
    let length = (F::field_bit_size() + 7) / 8;
    let bytes = value.to_bytes_be();
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
            v.push(FieldElement::from(0u64));
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
