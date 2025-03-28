use super::*;

#[pyfunction]
pub fn schnorr_calldata_builder(
    py: Python,
    rx: &Bound<'_, PyInt>,
    s: &Bound<'_, PyInt>,
    e: &Bound<'_, PyInt>,
    px: &Bound<'_, PyInt>,
    py_coord: &Bound<'_, PyInt>,
    curve_id: usize,
) -> PyResult<PyObject> {
    let rx: BigUint = rx.extract()?;
    let s: BigUint = s.extract()?;
    let e: BigUint = e.extract()?;
    let px: BigUint = px.extract()?;
    let py_coord: BigUint = py_coord.extract()?;

    let result =
        crate::calldata::signatures::schnorr_calldata_builder(rx, s, e, px, py_coord, curve_id)
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
    curve_id: usize,
) -> PyResult<PyObject> {
    let r: BigUint = r.extract()?;
    let s: BigUint = s.extract()?;
    let px: BigUint = px.extract()?;
    let py_coord: BigUint = py_coord.extract()?;
    let z: BigUint = z.extract()?;

    let result =
        crate::calldata::signatures::ecdsa_calldata_builder(r, s, v, px, py_coord, z, curve_id)
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
) -> PyResult<PyObject> {
    let rx: BigUint = rx.extract()?;
    let s: BigUint = s.extract()?;
    let py_coord: BigUint = py_coord.extract()?;
    let msg: Vec<u8> = msg.extract()?;

    let result = crate::calldata::signatures::eddsa_calldata_builder(rx, s, py_coord, msg)
        .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}
