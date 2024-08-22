use crate::ecip::{
    curve::{get_irreducible_poly, CurveParamsProvider},
    polynomial::{pad_with_zero_coefficients_to_length, Polynomial},
};
use lambdaworks_math::field::traits::IsPrimeField;

// Returns (Q(X), R(X)) such that Π(Pi)(X) = Q(X) * P_irr(X) + R(X), for a given curve and extension degree.
// R(X) is the result of the multiplication in the extension field.
// Q(X) is used for verification.
pub fn nondeterministic_extension_field_mul_divmod<F: IsPrimeField + CurveParamsProvider<F>>(
    ext_degree: usize,
    ps: Vec<Polynomial<F>>,
) -> (Polynomial<F>, Polynomial<F>) {
    let mut z_poly = Polynomial::one();
    for poly in ps {
        z_poly = z_poly.mul_with_ref(&poly);
    }

    let p_irr = get_irreducible_poly(ext_degree);

    let (z_polyq, mut z_polyr) = z_poly.divmod(&p_irr);
    assert!(z_polyr.coefficients.len() <= ext_degree);

    // Extend polynomial with 0 coefficients to match the expected length.
    if z_polyr.coefficients.len() < ext_degree {
        pad_with_zero_coefficients_to_length(&mut z_polyr, ext_degree);
    }

    (z_polyq, z_polyr)
}
