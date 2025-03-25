use crate::algebra::{
    g1g2pair::G1G2Pair, g1point::G1Point, g2point::G2Point, rational_function::FunctionFelt,
};
use crate::definitions::{CurveParamsProvider, FieldElement, Stark252PrimeField};
use lambdaworks_math::{
    field::traits::{IsField, IsPrimeField, IsSubFieldOf},
    traits::ByteConversion,
};
use num_bigint::BigUint;

use lambdaworks_math::unsigned_integer::element::U256;

pub fn biguint_to_u256(x: &BigUint) -> U256 {
    U256::from_hex_unchecked(&x.to_str_radix(16))
}

pub fn parse_g1_points_from_flattened_field_elements_list<F>(
    values: &[FieldElement<F>],
) -> Result<Vec<G1Point<F>>, String>
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    values
        .chunks(2)
        .map(|chunk| G1Point::new(chunk[0].clone(), chunk[1].clone()))
        .collect::<Result<Vec<_>, _>>()
}

pub fn parse_g1_g2_pairs_from_flattened_field_elements_list<F, E2>(
    values: &[FieldElement<F>],
) -> Result<Vec<G1G2Pair<F, E2>>, String>
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    values
        .chunks(6)
        .map(|chunk| {
            let g1 = G1Point::new(chunk[0].clone(), chunk[1].clone())?;
            let g2 = G2Point::new(
                [chunk[2].clone(), chunk[3].clone()],
                [chunk[4].clone(), chunk[5].clone()],
            )?;
            Ok(G1G2Pair::new(g1, g2))
        })
        .collect::<Result<Vec<_>, _>>()
}

pub fn field_elements_from_big_uints<F>(values: &[BigUint]) -> Vec<FieldElement<F>>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    values.iter().map(element_from_biguint).collect()
}

pub fn element_from_biguint<F>(value: &BigUint) -> FieldElement<F>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    element_from_bytes_be(&value.to_bytes_be())
}

pub fn element_from_bytes_be<F>(bytes: &[u8]) -> FieldElement<F>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    let length = (F::field_bit_size() + 7) / 8;
    if bytes.len() > length {
        let x = BigUint::from_bytes_be(bytes);
        let p = biguint_from_hex(&F::modulus_minus_one().to_string()) + 1usize;
        return element_from_bytes_be(&(x % p).to_bytes_be());
    }
    let pad_length = length - bytes.len();
    let mut padded_bytes = vec![0u8; pad_length];
    padded_bytes.extend(bytes);
    FieldElement::from_bytes_be(&padded_bytes).unwrap() // must never fail
}

pub fn field_elements_to_big_uints<F>(values: &[FieldElement<F>]) -> Vec<BigUint>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    values.iter().map(element_to_biguint).collect()
}

pub fn element_to_biguint<F>(x: &FieldElement<F>) -> BigUint
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    BigUint::from_bytes_be(&x.to_bytes_be())
}

pub fn felt252_to_element<F>(x: &FieldElement<Stark252PrimeField>) -> FieldElement<F>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    element_from_bytes_be(&x.to_bytes_be())
}

pub fn padd_function_felt<F: IsPrimeField>(
    f: &FunctionFelt<F>,
    n: usize,
    batched: bool,
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

    let extra_padding = if batched { 2 } else { 0 };
    pad_vec(&mut a_num, n + 1 + extra_padding);
    pad_vec(&mut a_den, n + 2 + extra_padding);
    pad_vec(&mut b_num, n + 2 + extra_padding);
    pad_vec(&mut b_den, n + 5 + extra_padding);
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
    element_from_bytes_be(&u128_to_bytes_be(value))
}

pub fn field_element_to_u256_limbs<F>(x: &FieldElement<F>) -> [u128; 2]
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    byte_slice_split::<2, 128>(&x.to_bytes_be())
}

pub fn field_element_to_u288_limbs<F>(x: &FieldElement<F>) -> [u128; 3]
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    byte_slice_split::<3, 96>(&x.to_bytes_be())
}

pub fn field_element_to_u384_limbs<F>(x: &FieldElement<F>) -> [u128; 4]
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

pub fn biguint_from_hex(hex: &str) -> BigUint {
    let mut s = hex;
    if let Some(stripped) = s.strip_prefix("0x") {
        s = stripped;
    }
    BigUint::parse_bytes(s.as_bytes(), 16).unwrap_or_else(|| panic!("invalid hex string: {}", hex))
}

#[cfg(test)]
mod tests {
    use super::{biguint_from_hex, element_from_biguint, FieldElement};
    use crate::definitions::{
        BLS12381PrimeField, BN254PrimeField, SECP256K1PrimeField, SECP256R1PrimeField,
        Stark252PrimeField, X25519PrimeField,
    };

    #[test]
    fn test_element_from_hex() {
        let s = "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
        let x = biguint_from_hex(s);

        {
            let s = "6D89F71CAB8351F47AB1EFF0A417FF6B5E71911D44501FBF32CFC5B538AFA88";
            let one = element_from_biguint::<BN254PrimeField>(&x);
            assert_eq!(one, FieldElement::from_hex(s).unwrap());
        }
        {
            let s = "2CB5D3A884E56C4FAB7CD07EE4E16BC15EFEBB5D396D7CF82383087033108464532383FA8EAFF4E967D3988A62B6C9C";
            let one = element_from_biguint::<BLS12381PrimeField>(&x);
            assert_eq!(one, FieldElement::from_hex(s).unwrap());
        }
        {
            let s = "1000007A2000E90A0";
            let one = element_from_biguint::<SECP256K1PrimeField>(&x);
            assert_eq!(one, FieldElement::from_hex(s).unwrap());
        }
        {
            let s = "4FFFFFFFDFFFFFFFFFFFFFFFEFFFFFFFBFFFFFFFF0000000000000002";
            let one = element_from_biguint::<SECP256R1PrimeField>(&x);
            assert_eq!(one, FieldElement::from_hex(s).unwrap());
        }
        {
            let s = "5A3";
            let one = element_from_biguint::<X25519PrimeField>(&x);
            assert_eq!(one, FieldElement::from_hex(s).unwrap());
        }
        {
            let s = "7FFD4AB5E008810FFFFFFFFFF6F800000000001330FFFFFFFFFFD737E000400";
            let one = element_from_biguint::<Stark252PrimeField>(&x);
            assert_eq!(one, FieldElement::from_hex(s).unwrap());
        }
    }
}
