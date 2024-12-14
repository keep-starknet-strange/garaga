use crate::algebra::extf_mul;
use crate::algebra::polynomial::Polynomial;
use crate::definitions::{CurveID, CurveParamsProvider};
use crate::io::field_elements_from_big_uints;

use super::*;

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
    let curve_id = CurveID::try_from(curve_id).unwrap();
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
        let coeffs = field_elements_from_big_uints::<F>(&coeffs);
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
    let q_list = PyList::new(py, q)?;
    let r_list = PyList::new(py, r)?;
    let py_tuple = PyTuple::new(py, [q_list, r_list])?;
    Ok(py_tuple.into())
}
