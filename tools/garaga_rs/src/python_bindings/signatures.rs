use super::*;

#[pyfunction]
pub fn schnorr_calldata_builder(
    py: Python,
    rx: &Bound<'_, PyInt>,
    s: &Bound<'_, PyInt>,
    e: &Bound<'_, PyInt>,
    px: &Bound<'_, PyInt>,
    py_coord: &Bound<'_, PyInt>,
    prepend_public_key: bool,
    curve_id: usize,
) -> PyResult<Py<PyAny>> {
    let rx: BigUint = rx.extract()?;
    let s: BigUint = s.extract()?;
    let e: BigUint = e.extract()?;
    let px: BigUint = px.extract()?;
    let py_coord: BigUint = py_coord.extract()?;

    let result = crate::calldata::signatures::schnorr_calldata_builder(
        rx,
        s,
        e,
        px,
        py_coord,
        prepend_public_key,
        curve_id,
    )
    .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}

#[pyfunction]
pub fn ecdsa_calldata_builder(
    py: Python,
    r: &Bound<'_, PyInt>,
    s: &Bound<'_, PyInt>,
    v: u8,
    px: &Bound<'_, PyInt>,
    py_coord: &Bound<'_, PyInt>,
    z: &Bound<'_, PyInt>,
    prepend_public_key: bool,
    curve_id: usize,
) -> PyResult<Py<PyAny>> {
    let r: BigUint = r.extract()?;
    let s: BigUint = s.extract()?;
    let px: BigUint = px.extract()?;
    let py_coord: BigUint = py_coord.extract()?;
    let z: BigUint = z.extract()?;

    let result = crate::calldata::signatures::ecdsa_calldata_builder(
        r,
        s,
        v,
        px,
        py_coord,
        z,
        prepend_public_key,
        curve_id,
    )
    .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}

#[pyfunction]
pub fn eddsa_calldata_builder(
    py: Python,
    rx: &Bound<'_, PyInt>,
    s: &Bound<'_, PyInt>,
    py_coord: &Bound<'_, PyInt>,
    msg: &Bound<'_, PyBytes>,
    prepend_public_key: bool,
) -> PyResult<Py<PyAny>> {
    let rx: BigUint = rx.extract()?;
    let s: BigUint = s.extract()?;
    let py_coord: BigUint = py_coord.extract()?;
    let msg: Vec<u8> = msg.extract()?;

    let result = crate::calldata::signatures::eddsa_calldata_builder(
        rx,
        s,
        py_coord,
        msg,
        prepend_public_key,
    )
    .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}

#[pyfunction]
pub fn rsa_2048_calldata_builder(
    py: Python,
    signature: &Bound<'_, PyInt>,
    expected_message: &Bound<'_, PyInt>,
    modulus: &Bound<'_, PyInt>,
    prepend_public_key: bool,
) -> PyResult<Py<PyAny>> {
    let signature: BigUint = signature.extract()?;
    let expected_message: BigUint = expected_message.extract()?;
    let modulus: BigUint = modulus.extract()?;

    let result = crate::calldata::signatures::rsa_2048_calldata_builder(
        signature,
        expected_message,
        modulus,
        prepend_public_key,
    )
    .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}

#[pyfunction]
pub fn rsa_2048_sha256_calldata_builder(
    py: Python,
    signature: &Bound<'_, PyInt>,
    message: &Bound<'_, PyBytes>,
    modulus: &Bound<'_, PyInt>,
    prepend_public_key: bool,
) -> PyResult<Py<PyAny>> {
    let signature: BigUint = signature.extract()?;
    let message: Vec<u8> = message.extract()?;
    let modulus: BigUint = modulus.extract()?;

    let result = crate::calldata::signatures::rsa_2048_sha256_calldata_builder(
        signature,
        &message,
        modulus,
        prepend_public_key,
    )
    .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}
