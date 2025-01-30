use super::*;
use crate::calldata::full_proof_with_hints::honk;
use crate::calldata::full_proof_with_hints::honk::{HonkFlavor, HonkProof, HonkVerificationKey};
use pyo3::prelude::*;
use pyo3::types::PyList;

#[pyfunction]
pub fn get_honk_calldata(
    py: Python,
    proof: &Bound<'_, PyList>,
    vk: &Bound<'_, PyList>,
    flavor: usize,
) -> PyResult<PyObject> {
    let proof_values = proof
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;
    let vk_values = vk
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;

    let result = honk::get_honk_calldata(
        &HonkProof::from(proof_values).map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?,
        &HonkVerificationKey::from(vk_values)
            .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?,
        HonkFlavor::try_from(flavor).map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?,
    )
    .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}
