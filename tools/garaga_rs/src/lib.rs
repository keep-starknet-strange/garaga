use lambdaworks_crypto::hash::poseidon::{starknet::PoseidonCairoStark252, Poseidon};
use lambdaworks_math::{
    field::{
        element::FieldElement, fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
    },
    traits::ByteConversion,
};
use pyo3::{
    types::{PyBytes, PyTuple},
    {prelude::*, wrap_pyfunction},
};

#[pymodule]
fn garaga_rs(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(get_final_exp_witness, m)?)?;
    m.add_function(wrap_pyfunction!(hades_permutation, m)?)?;
    Ok(())
}

#[pyfunction]
fn get_final_exp_witness(
    py: Python,
    curve_id: usize,
    py_value_1: &PyBytes,
    py_value_2: &PyBytes,
    py_value_3: &PyBytes,
    py_value_4: &PyBytes,
    py_value_5: &PyBytes,
    py_value_6: &PyBytes,
    py_value_7: &PyBytes,
    py_value_8: &PyBytes,
    py_value_9: &PyBytes,
    py_value_10: &PyBytes,
    py_value_11: &PyBytes,
    py_value_12: &PyBytes,
) -> PyResult<PyObject> {
    let byte_slice_1: &[u8] = py_value_1.as_bytes();
    let byte_slice_2: &[u8] = py_value_2.as_bytes();
    let byte_slice_3: &[u8] = py_value_3.as_bytes();
    let byte_slice_4: &[u8] = py_value_4.as_bytes();
    let byte_slice_5: &[u8] = py_value_5.as_bytes();
    let byte_slice_6: &[u8] = py_value_6.as_bytes();
    let byte_slice_7: &[u8] = py_value_7.as_bytes();
    let byte_slice_8: &[u8] = py_value_8.as_bytes();
    let byte_slice_9: &[u8] = py_value_9.as_bytes();
    let byte_slice_10: &[u8] = py_value_10.as_bytes();
    let byte_slice_11: &[u8] = py_value_11.as_bytes();
    let byte_slice_12: &[u8] = py_value_12.as_bytes();

    if curve_id == 0 {
        // c, wi = find_c_e12(f, get_27th_bn254_root())
    }
    else
    if curve_id == 1 {
        // c, wi = get_root_and_scaling_factor_bls(f)
    }
    else {
        panic!("Curve ID {} not supported", curve_id);
    }

    let py_tuple = PyTuple::new(
        py,
        &[
            byte_slice_1, byte_slice_2, byte_slice_3, byte_slice_4, byte_slice_5, byte_slice_6,
            byte_slice_7, byte_slice_8, byte_slice_9, byte_slice_10, byte_slice_11, byte_slice_12,
            byte_slice_1, byte_slice_2, byte_slice_3, byte_slice_4, byte_slice_5, byte_slice_6,
            byte_slice_7, byte_slice_8, byte_slice_9, byte_slice_10, byte_slice_11, byte_slice_12,
        ]
    );

    Ok(py_tuple.into())
}

#[pyfunction]
fn hades_permutation(
    py: Python,
    py_value_1: &PyBytes,
    py_value_2: &PyBytes,
    py_value_3: &PyBytes,
) -> PyResult<PyObject> {
    let byte_slice_1: &[u8] = py_value_1.as_bytes();
    let byte_slice_2: &[u8] = py_value_2.as_bytes();
    let byte_slice_3: &[u8] = py_value_3.as_bytes();

    let mut state: Vec<FieldElement<Stark252PrimeField>> = vec![
        FieldElement::<Stark252PrimeField>::from_bytes_be(byte_slice_1)
            .expect("Unable to convert first param from bytes to FieldElement"),
        FieldElement::<Stark252PrimeField>::from_bytes_be(byte_slice_2)
            .expect("Unable to convert second param from bytes to FieldElement"),
        FieldElement::<Stark252PrimeField>::from_bytes_be(byte_slice_3)
            .expect("Unable to convert third param from bytes to FieldElement"),
    ];

    PoseidonCairoStark252::hades_permutation(&mut state);

    let py_tuple = PyTuple::new(
        py,
        state.iter().map(|fe| {
            let fe_bytes = fe.to_bytes_be();
            PyBytes::new(py, &fe_bytes)
        }),
    );
    
    Ok(py_tuple.into())
}
