use super::*;
use crate::calldata::full_proof_with_hints::groth16;
use crate::calldata::full_proof_with_hints::groth16::{Groth16Proof, Groth16VerificationKey};
use crate::definitions::CurveID;
use pyo3::prelude::*;
use pyo3::types::PyList;

#[pyfunction(signature = (proof, vk, curve_id, image_id=None, journal=None, public_inputs_sp1=None, vkey=None))]
pub fn get_groth16_calldata(
    py: Python,
    proof: &Bound<'_, PyList>,
    vk: &Bound<'_, PyList>,
    curve_id: usize,
    image_id: Option<&[u8]>,
    journal: Option<&[u8]>,
    public_inputs_sp1: Option<&[u8]>,
    vkey: Option<&[u8]>,
) -> PyResult<PyObject> {
    let proof_values = proof
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;
    let vk_values = vk
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;

    // Handle RISC0 optional parameters
    let image_id_journal_risc0 = if let (Some(image_id), Some(journal)) = (image_id, journal) {
        Some((image_id.to_vec(), journal.to_vec()))
    } else {
        None
    };

    let verifying_key = Groth16VerificationKey::from(vk_values);

    // Handle SP1 optional parameters
    let vkey_public_values_sp1 =
        if let (Some(vkey), Some(public_inputs_sp1)) = (vkey, public_inputs_sp1) {
            assert!(verifying_key == groth16::get_sp1_vk());
            Some((vkey.to_vec(), public_inputs_sp1.to_vec()))
        } else {
            None
        };

    let result = groth16::get_groth16_calldata(
        &Groth16Proof::from(proof_values, image_id_journal_risc0, vkey_public_values_sp1),
        &verifying_key,
        CurveID::try_from(curve_id).map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?,
    )
    .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}
