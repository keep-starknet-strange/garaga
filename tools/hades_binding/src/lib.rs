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
fn hades_binding(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(hades_permutation, m)?)?;
    Ok(())
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
