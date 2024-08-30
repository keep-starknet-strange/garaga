use crate::algebra::extf_mul;
use crate::algebra::polynomial::Polynomial;
use crate::definitions::{CurveID, CurveParamsProvider};
use crate::io::parse_field_elements_from_list;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::BLS12381PrimeField;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::BN254PrimeField;
use lambdaworks_math::{
    field::{element::FieldElement, traits::IsPrimeField},
    traits::ByteConversion,
};

use num_bigint::BigUint;
use pyo3::{
    types::{PyList, PyTuple},
    prelude::*,
};

#[pyfunction]
pub fn nondeterministic_extension_field_mul_divmod(
    py: Python,
    curve_id: usize,
    ext_degree: usize,
    py_list: &Bound<'_, PyList>,
) -> PyResult<PyObject> {
    let list_coeffs = py_list
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<Vec<BigUint>>, _>>()?;
    let curve_id = CurveID::from(curve_id);
    match curve_id {
        CurveID::BN254 => {
            handle_extension_field_mul_divmod::<BN254PrimeField>(py, ext_degree, list_coeffs)
        }
        CurveID::BLS12_381 => {
            handle_extension_field_mul_divmod::<BLS12381PrimeField>(py, ext_degree, list_coeffs)
        }
        _ => panic!("Curve ID {} not supported", curve_id as usize),
    }
}

fn handle_extension_field_mul_divmod<F>(
    py: Python,
    ext_degree: usize,
    list_coeffs: Vec<Vec<BigUint>>,
) -> PyResult<PyObject>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let mut ps = Vec::new();
    for coeffs in list_coeffs {
        let coeffs = parse_field_elements_from_list::<F>(&coeffs);
        ps.push(Polynomial::new(coeffs));
    }
    let (z_polyq, z_polyr) = extf_mul::nondeterministic_extension_field_mul_divmod(ext_degree, ps);
    let q = z_polyq
        .coefficients
        .into_iter()
        .map(|x| BigUint::from_bytes_be(&x.to_bytes_be()))
        .collect::<Vec<BigUint>>();
    let r = z_polyr
        .coefficients
        .into_iter()
        .map(|x| BigUint::from_bytes_be(&x.to_bytes_be()))
        .collect::<Vec<BigUint>>();
    let py_tuple = PyTuple::new_bound(py, [PyList::new_bound(py, q), PyList::new_bound(py, r)]);
    Ok(py_tuple.into())
}
