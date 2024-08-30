use super::*;
use crate::ecip;
#[pyfunction]
pub fn zk_ecip_hint(
    py: Python,
    py_list_1: &Bound<'_, PyList>,
    py_list_2: &Bound<'_, PyList>,
    curve_id: usize,
) -> PyResult<PyObject> {
    let list_values = py_list_1
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;

    let list_scalars = py_list_2
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;

    let v = ecip::core::zk_ecip_hint(list_values, list_scalars, curve_id)
        .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let py_list = PyList::new_bound(py, v.into_iter().map(|x| PyList::new_bound(py, x)));

    Ok(py_list.into())
}
