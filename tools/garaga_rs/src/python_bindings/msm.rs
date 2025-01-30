use super::*;

#[pyfunction]
#[allow(clippy::too_many_arguments)]
pub fn msm_calldata_builder(
    py: Python,
    py_list1: &Bound<'_, PyList>,
    py_list2: &Bound<'_, PyList>,
    curve_id: usize,
    include_digits_decomposition: bool,
    include_points_and_scalars: bool,
    serialize_as_pure_felt252_array: bool,
    risc0_mode: bool,
) -> PyResult<PyObject> {
    let values = py_list1
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;
    let scalars = py_list2
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;
    let result = crate::calldata::msm_calldata::msm_calldata_builder(
        &values,
        &scalars,
        curve_id,
        Some(include_digits_decomposition),
        include_points_and_scalars,
        serialize_as_pure_felt252_array,
        risc0_mode,
    )
    .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;
    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}
