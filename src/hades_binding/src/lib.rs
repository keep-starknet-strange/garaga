/*use pyo3::prelude::*;
use num_bigint::{BigInt, ToBigInt};
use num_traits::{One, Pow};
use std::vec::Vec;


fn hades_round(values: Vec<BigInt>, is_full_round: bool, round_idx: usize) -> Vec<BigInt> {
    let mut values = values.iter().enumerate().map(|(i, val)| {
        (val + &params.ark[round_idx][i]) % &params.field_prime
    }).collect::<Vec<BigInt>>();

    if is_full_round {
        values = values.into_iter().map(|val| {
            Pow::pow(&val, 3.to_bigint().unwrap()) % &params.field_prime
        }).collect();
    } else {
        let last = values.len() - 1;
        values[last] = Pow::pow(&values[last], 3.to_bigint().unwrap()) % &params.field_prime;
    }

    // MixLayer operation to be implemented according to your matrix handling
    // values = params.mds.dot_mod(values, &params.field_prime);

    values
}

#[pyfunction]
fn hades_permutation(values: Vec<BigInt>) -> PyResult<Vec<BigInt>> {
    assert!(values.len() == params.m, "Values length must match params.m");

    let mut values = values;
    let mut round_idx: usize = 0;

    // Full rounds
    for _ in 0..(params.r_f / 2) {
        values = hades_round(values, &params, true, round_idx);
        round_idx += 1;
    }

    // Partial rounds
    for _ in 0..params.r_p {
        values = hades_round(values, &params, false, round_idx);
        round_idx += 1;
    }

    // Full rounds
    for _ in 0..(params.r_f / 2) {
        values = hades_round(values, &params, true, round_idx);
        round_idx += 1;
    }

    assert!(round_idx == params.n_rounds, "Total rounds mismatch");

    Ok(values)
}

#[pymodule]
fn poseidon_rust(py: Python, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(hades_permutation, m)?)?;
    Ok(())
}*/

use pyo3::prelude::*;
use pyo3::types::{PyInt, PyList};
use num_bigint::BigInt;
use std::vec::Vec;

#[pyfunction]
fn hades_permutation(py: Python, is_full_round: bool, round_idx: usize) -> PyResult<PyObject> {
    let bigints = vec![BigInt::from(0), BigInt::from(1), BigInt::from(2)];
    let py_list = PyList::empty(py); // Corrected line

    for bigint in bigints {
        let bigint_str = bigint.to_string();
        // Correctly convert BigInt to PyInt and add to PyList
        let py_bigint: PyObject = py.eval(&format!("int({})", bigint_str), None, None)?.into();
        py_list.append(py_bigint)?;
    }

    Ok(py_list.into())
}

#[pymodule]
fn hades_binding(py: Python, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(hades_permutation, m)?)?;
    Ok(())
}
