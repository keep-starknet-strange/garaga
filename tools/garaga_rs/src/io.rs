use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::traits::ByteConversion;
use num_bigint::BigUint;

pub fn parse_field_elements_from_list<F: IsPrimeField>(
    values: &[BigUint],
) -> Result<Vec<FieldElement<F>>, String>
where
    FieldElement<F>: ByteConversion,
{
    let length = (F::field_bit_size() + 7) / 8;
    values
        .iter()
        .map(|x| {
            let bytes = x.to_bytes_be();
            let pad_length = length.saturating_sub(bytes.len());
            let mut padded_bytes = vec![0u8; pad_length];
            padded_bytes.extend(bytes);
            FieldElement::from_bytes_be(&padded_bytes)
                .map_err(|e| format!("Byte conversion error: {:?}", e))
        })
        .collect()
}
