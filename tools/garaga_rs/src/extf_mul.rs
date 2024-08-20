use crate::ecip::polynomial::{pad_with_zero_coefficients_to_length, Polynomial};
use lambdaworks_math::{
    elliptic_curve::short_weierstrass::curves::{
        bls12_381::field_extension::{BLS12381PrimeField, BLS12381_PRIME_FIELD_ORDER},
        bn_254::field_extension::{BN254PrimeField, BN254_PRIME_FIELD_ORDER},
    },
    field::element::FieldElement,
    traits::ByteConversion,
    unsigned_integer::element::{U256, U384},
};
use num_bigint::BigUint;

// irreducible polynomial coefficients
const IPC: [[&[i8]; 2]; 2] = [
    // curve 0: BN254
    [
        &[82, 0, 0, -18, 0, 0, 1],                   // 6
        &[82, 0, 0, 0, 0, 0, -18, 0, 0, 0, 0, 0, 1], // 12
    ],
    // curve 1: BLS12-381
    [
        &[2, 0, 0, -2, 0, 0, 1],                   // 6
        &[2, 0, 0, 0, 0, 0, -2, 0, 0, 0, 0, 0, 1], // 12
    ],
];

// Returns (Q(X), R(X)) such that Π(Pi)(X) = Q(X) * P_irr(X) + R(X), for a given curve and extension degree.
// R(X) is the result of the multiplication in the extension field.
// Q(X) is used for verification.
pub fn nondeterministic_extension_field_mul_divmod(
    curve_id: usize,
    ext_degree: usize,
    list_coeffs: Vec<Vec<Vec<u8>>>,
) -> Result<(Vec<BigUint>, Vec<BigUint>), String> {
    assert!(6 <= ext_degree && ext_degree <= 12 && ext_degree % 6 == 0);
    let ext_degree_index = ext_degree / 6 - 1;

    if curve_id == 0 {
        let mut ps = Vec::new();
        for i in 0..list_coeffs.len() {
            let coeffs = (&list_coeffs[i])
                .into_iter()
                .map(|x| {
                    FieldElement::<BN254PrimeField>::from_bytes_be(&x)
                        .map_err(|e| format!("Byte conversion error: {:?}", e))
                })
                .collect::<Result<Vec<FieldElement<BN254PrimeField>>, _>>()?;
            ps.push(Polynomial::new(coeffs));
        }

        let coeffs = IPC[curve_id][ext_degree_index]
            .into_iter()
            .map(|x| {
                if *x >= 0 {
                    FieldElement::<BN254PrimeField>::from(*x as u64)
                } else {
                    FieldElement::<BN254PrimeField>::from(
                        &(BN254_PRIME_FIELD_ORDER - U256::from_u64(-x as u64)),
                    )
                }
            })
            .collect::<Vec<FieldElement<BN254PrimeField>>>();
        let p_irr = Polynomial::new(coeffs);

        let mut z_poly = Polynomial::one();
        for i in 0..ps.len() {
            z_poly = z_poly.mul_with_ref(&ps[i]);
        }

        let (mut z_polyq, mut z_polyr) = z_poly.divmod(&p_irr);
        assert!(z_polyr.coefficients.len() <= ext_degree);

        // Extend polynomials with 0 coefficients to match the expected lengths.
        // TODO : pass exact expected max degree when len(Ps)>2.
        if z_polyq.coefficients.len() < ext_degree - 1 {
            pad_with_zero_coefficients_to_length(&mut z_polyq, ext_degree - 1);
        }
        if z_polyr.coefficients.len() < ext_degree {
            pad_with_zero_coefficients_to_length(&mut z_polyr, ext_degree);
        }

        let q = z_polyq
            .coefficients
            .into_iter()
            .map(|x| BigUint::from_bytes_be(&x.to_bytes_be()))
            .collect();
        let r = z_polyr
            .coefficients
            .into_iter()
            .map(|x| BigUint::from_bytes_be(&x.to_bytes_be()))
            .collect();

        return Ok((q, r));
    }

    if curve_id == 1 {
        let mut ps = Vec::new();
        for i in 0..list_coeffs.len() {
            let coeffs = (&list_coeffs[i])
                .into_iter()
                .map(|x| {
                    FieldElement::<BLS12381PrimeField>::from_bytes_be(&x)
                        .map_err(|e| format!("Byte conversion error: {:?}", e))
                })
                .collect::<Result<Vec<FieldElement<BLS12381PrimeField>>, _>>()?;
            ps.push(Polynomial::new(coeffs));
        }

        let coeffs = IPC[curve_id][ext_degree_index]
            .into_iter()
            .map(|x| {
                if *x >= 0 {
                    FieldElement::<BLS12381PrimeField>::from(*x as u64)
                } else {
                    FieldElement::<BLS12381PrimeField>::from(
                        &(BLS12381_PRIME_FIELD_ORDER - U384::from_u64(-x as u64)),
                    )
                }
            })
            .collect::<Vec<FieldElement<BLS12381PrimeField>>>();
        let p_irr = Polynomial::new(coeffs);

        let mut z_poly = Polynomial::one();
        for i in 0..ps.len() {
            z_poly = z_poly.mul_with_ref(&ps[i]);
        }

        let (mut z_polyq, mut z_polyr) = z_poly.divmod(&p_irr);
        assert!(z_polyr.coefficients.len() <= ext_degree);

        // Extend polynomials with 0 coefficients to match the expected lengths.
        // TODO : pass exact expected max degree when len(Ps)>2.
        if z_polyq.coefficients.len() < ext_degree - 1 {
            pad_with_zero_coefficients_to_length(&mut z_polyq, ext_degree - 1);
        }
        if z_polyr.coefficients.len() < ext_degree {
            pad_with_zero_coefficients_to_length(&mut z_polyr, ext_degree);
        }

        let q = z_polyq
            .coefficients
            .into_iter()
            .map(|x| BigUint::from_bytes_be(&x.to_bytes_be()))
            .collect();
        let r = z_polyr
            .coefficients
            .into_iter()
            .map(|x| BigUint::from_bytes_be(&x.to_bytes_be()))
            .collect();

        return Ok((q, r));
    }

    panic!("Curve ID {} not supported", curve_id);
}
