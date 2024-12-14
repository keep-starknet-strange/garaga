use super::*;
use crate::ecip;
#[pyfunction]
pub fn zk_ecip_hint(
    py: Python,
    flattened_g1_points_list: &Bound<'_, PyList>,
    scalars_list: &Bound<'_, PyList>,
    curve_id: usize,
) -> PyResult<PyObject> {
    let list_values = flattened_g1_points_list
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;

    let list_scalars = scalars_list
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;

    let v = ecip::core::zk_ecip_hint(list_values, list_scalars, curve_id)
        .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let inner_lists: Vec<_> = v
        .into_iter()
        .map(|x| PyList::new(py, x))
        .collect::<PyResult<_>>()?;
    let py_list = PyList::new(py, inner_lists)?;
    Ok(py_list.into())
}
