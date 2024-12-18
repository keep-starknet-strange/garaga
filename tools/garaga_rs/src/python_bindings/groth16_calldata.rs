use super::*;
use crate::calldata::full_proof_with_hints::groth16;
use crate::calldata::full_proof_with_hints::groth16::{Groth16Proof, Groth16VerificationKey};
use crate::definitions::CurveID;
use pyo3::prelude::*;
use pyo3::types::PyList;

#[pyfunction(signature = (proof, vk, curve_id, image_id=None, journal=None))]
pub fn get_groth16_calldata(
    py: Python,
    proof: &Bound<'_, PyList>,
    vk: &Bound<'_, PyList>,
    curve_id: usize,
    image_id: Option<&[u8]>,
    journal: Option<&[u8]>,
) -> PyResult<PyObject> {
    let proof_values = proof
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;
    let vk_values = vk
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;

    // Handle optional parameters
    let image_id_values = image_id.map(|id| id.to_vec());

    let journal_values = journal.map(|j| j.to_vec());

    let result = groth16::get_groth16_calldata(
        &Groth16Proof::from(proof_values, image_id_values, journal_values),
        &Groth16VerificationKey::from(vk_values),
        CurveID::try_from(curve_id).map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?,
    )
    .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}
