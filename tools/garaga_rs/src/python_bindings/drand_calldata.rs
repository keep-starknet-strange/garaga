use super::*;

#[pyfunction]
pub fn drand_calldata_builder(py: Python, py_list1: &Bound<'_, PyList>) -> PyResult<PyObject> {
    let values1 = py_list1
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;
    let result = crate::calldata::drand_calldata::drand_calldata_builder(&values1)
        .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;
    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}
