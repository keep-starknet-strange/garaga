use super::*;
use crate::calldata::full_proof_with_hints::zk_honk;
use crate::calldata::full_proof_with_hints::zk_honk::{HonkVerificationKey, ZKHonkProof};
use pyo3::prelude::*;
use pyo3::types::PyList;

#[pyfunction]
pub fn get_zk_honk_calldata(
    py: Python,
    proof: &Bound<'_, PyBytes>,
    public_inputs: &Bound<'_, PyBytes>,
    vk: &Bound<'_, PyBytes>,
) -> PyResult<PyObject> {
    let proof_bytes = proof.as_bytes();
    let public_inputs_bytes = public_inputs.as_bytes();
    let vk_bytes = vk.as_bytes();

    let vk = HonkVerificationKey::from_bytes(vk_bytes)
        .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let proof = ZKHonkProof::from_bytes(proof_bytes, public_inputs_bytes, vk.log_circuit_size)
        .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let result = zk_honk::get_zk_honk_calldata(&proof, &vk)
        .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}
