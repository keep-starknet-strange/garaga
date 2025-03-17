use super::*;
use crate::calldata::full_proof_with_hints::honk;
use crate::calldata::full_proof_with_hints::honk::{HonkFlavor, HonkProof, HonkVerificationKey};
use crate::calldata::full_proof_with_hints::zk_honk;
use crate::calldata::full_proof_with_hints::zk_honk::ZKHonkProof;
use pyo3::prelude::*;
use pyo3::types::PyList;

#[pyfunction]
pub fn get_honk_calldata(
    py: Python,
    proof: &Bound<'_, PyList>,
    vk: &Bound<'_, PyList>,
    flavor: usize,
    zk: bool,
) -> PyResult<PyObject> {
    let proof_values = proof
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;
    let vk_values = vk
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;

    let flavor =
        HonkFlavor::try_from(flavor).map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let vk = HonkVerificationKey::from(vk_values)
        .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let result = if zk {
        let proof = ZKHonkProof::from(proof_values)
            .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;
        zk_honk::get_zk_honk_calldata(&proof, &vk, flavor)
            .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?
    } else {
        let proof = HonkProof::from(proof_values)
            .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;
        honk::get_honk_calldata(&proof, &vk, flavor)
            .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?
    };

    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}
