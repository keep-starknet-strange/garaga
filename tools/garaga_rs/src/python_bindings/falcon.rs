use super::*;

#[pyfunction]
pub fn falcon_calldata_builder(
    py: Python,
    vk_bytes: &Bound<'_, PyBytes>,
    signature_bytes: &Bound<'_, PyBytes>,
    message: &Bound<'_, PyList>,
    prepend_public_key: bool,
) -> PyResult<Py<PyAny>> {
    let vk: Vec<u8> = vk_bytes.extract()?;
    let sig: Vec<u8> = signature_bytes.extract()?;
    let msg: Vec<BigUint> = message
        .iter()
        .map(|item| item.extract::<BigUint>())
        .collect::<PyResult<Vec<_>>>()?;

    let result = crate::calldata::falcon_calldata::falcon_calldata_builder(
        &vk,
        &sig,
        &msg,
        prepend_public_key,
    )
    .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}

#[pyfunction]
pub fn pack_falcon_public_key(py: Python, coeffs: Vec<u16>) -> PyResult<Py<PyAny>> {
    let result = crate::calldata::falcon_calldata::pack_falcon_public_key(&coeffs);
    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}

#[pyfunction]
pub fn unpack_falcon_public_key(packed: &Bound<'_, PyList>) -> PyResult<Vec<u16>> {
    let packed: Vec<BigUint> = packed
        .iter()
        .map(|item| item.extract::<BigUint>())
        .collect::<PyResult<Vec<_>>>()?;

    Ok(crate::calldata::falcon_calldata::unpack_falcon_public_key(
        &packed,
    ))
}
