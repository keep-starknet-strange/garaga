use super::*;

#[pyfunction]
pub fn mpc_calldata_builder(
    py: Python,
    curve_id: usize,
    py_list1: &Bound<'_, PyList>,
    n_fixed_g2: usize,
    py_list2: &Bound<'_, PyList>,
) -> PyResult<PyObject> {
    let values1 = py_list1
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;
    let values2 = py_list2
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;
    let result = crate::calldata::mpc_calldata::mpc_calldata_builder(
        curve_id, &values1, n_fixed_g2, &values2,
    )
    .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;
    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}
