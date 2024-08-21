use crate::ecip::{
    curve::{get_irreducible_poly, CurveParamsProvider},
    polynomial::{pad_with_zero_coefficients_to_length, Polynomial},
};
use lambdaworks_math::{
    elliptic_curve::short_weierstrass::curves::{
        bls12_381::field_extension::BLS12381PrimeField, bn_254::field_extension::BN254PrimeField,
    },
    field::{element::FieldElement, traits::IsPrimeField},
    traits::ByteConversion,
};
use num_bigint::BigUint;

// Returns (Q(X), R(X)) such that Π(Pi)(X) = Q(X) * P_irr(X) + R(X), for a given curve and extension degree.
// R(X) is the result of the multiplication in the extension field.
// Q(X) is used for verification.
pub fn nondeterministic_extension_field_mul_divmod(
    curve_id: usize,
    ext_degree: usize,
    list_coeffs: Vec<Vec<Vec<u8>>>,
) -> Result<(Vec<BigUint>, Vec<BigUint>), String> {
    if curve_id == 0 {
        let mut ps = Vec::new();
        for i in 0..list_coeffs.len() {
            let coeffs = (&list_coeffs[i])
                .into_iter()
                .map(|x| {
                    FieldElement::from_bytes_be(&x)
                        .map_err(|e| format!("Byte conversion error: {:?}", e))
                })
                .collect::<Result<Vec<FieldElement<BN254PrimeField>>, _>>()?;
            ps.push(Polynomial::new(coeffs));
        }

        let (z_polyq, z_polyr) = extf_mul(ext_degree, ps);

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
                    FieldElement::from_bytes_be(&x)
                        .map_err(|e| format!("Byte conversion error: {:?}", e))
                })
                .collect::<Result<Vec<FieldElement<BLS12381PrimeField>>, _>>()?;
            ps.push(Polynomial::new(coeffs));
        }

        let (z_polyq, z_polyr) = extf_mul(ext_degree, ps);

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

pub fn extf_mul<F: IsPrimeField + CurveParamsProvider<F>>(
    ext_degree: usize,
    ps: Vec<Polynomial<F>>,
) -> (Polynomial<F>, Polynomial<F>) {
    let mut z_poly = Polynomial::one();
    for i in 0..ps.len() {
        z_poly = z_poly.mul_with_ref(&ps[i]);
    }

    let p_irr = get_irreducible_poly(ext_degree);

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

    return (z_polyq, z_polyr);
}
