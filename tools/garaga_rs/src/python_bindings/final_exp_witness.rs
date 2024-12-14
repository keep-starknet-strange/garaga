use super::*;

#[pyfunction]
pub fn get_final_exp_witness(
    py: Python,
    curve_id: usize,
    py_list: &Bound<'_, PyList>,
) -> PyResult<PyObject> {
    let f_0: BigUint = py_list.get_item(0)?.extract()?;
    let f_1: BigUint = py_list.get_item(1)?.extract()?;
    let f_2: BigUint = py_list.get_item(2)?.extract()?;
    let f_3: BigUint = py_list.get_item(3)?.extract()?;
    let f_4: BigUint = py_list.get_item(4)?.extract()?;
    let f_5: BigUint = py_list.get_item(5)?.extract()?;
    let f_6: BigUint = py_list.get_item(6)?.extract()?;
    let f_7: BigUint = py_list.get_item(7)?.extract()?;
    let f_8: BigUint = py_list.get_item(8)?.extract()?;
    let f_9: BigUint = py_list.get_item(9)?.extract()?;
    let f_10: BigUint = py_list.get_item(10)?.extract()?;
    let f_11: BigUint = py_list.get_item(11)?.extract()?;
    let f = [f_0, f_1, f_2, f_3, f_4, f_5, f_6, f_7, f_8, f_9, f_10, f_11];
    let (c, wi) = crate::pairing::final_exp_witness::get_final_exp_witness(curve_id, f);
    let c_list = PyList::new(py, c)?;
    let wi_list = PyList::new(py, wi)?;
    let py_tuple = PyTuple::new(py, [c_list, wi_list])?;
    Ok(Py::from(py_tuple))
}
