use lambdaworks_crypto::hash::poseidon::{starknet::PoseidonCairoStark252, Poseidon};
use lambdaworks_math::{
    field::{
        element::FieldElement, fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
    },
    traits::ByteConversion,
};
use pyo3::{
    types::{PyBytes, PyList},
    {prelude::*, wrap_pyfunction},
};

#[pymodule]
fn hades_binding(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(hades_permutation, m)?)?;
    Ok(())
}

#[pyfunction]
fn hades_permutation(py: Python, py_value_1: &PyBytes, py_value_2: &PyBytes) -> PyResult<PyObject> {
    let byte_slice_1: &[u8] = py_value_1.as_bytes();
    let byte_slice_2: &[u8] = py_value_2.as_bytes();

    let number: u32 = 2;
    let two_bytes = number.to_be_bytes(); // This will give you the big-endian byte representation of 2 as a u32.
    let mut padded_two_bytes = [0u8; 32];
    padded_two_bytes[32 - 4..].copy_from_slice(&two_bytes);

    let mut state: Vec<FieldElement<Stark252PrimeField>> = vec![
        FieldElement::<Stark252PrimeField>::from_bytes_be(byte_slice_1)
            .expect("Unable to convert first param from bytes to FieldElement"),
        FieldElement::<Stark252PrimeField>::from_bytes_be(byte_slice_2)
            .expect("Unable to convert second param from bytes to FieldElement"),
        FieldElement::<Stark252PrimeField>::from_bytes_be(&padded_two_bytes)
            .expect("Unable to convert `two` from bytes to FieldElement"),
    ];

    PoseidonCairoStark252::hades_permutation(&mut state);

    let py_result_list = PyList::new(
        py,
        state[0..2].iter().map(|fe| {
            let fe_bytes = fe.to_bytes_be();
            PyBytes::new(py, &fe_bytes)
        }),
    );

    Ok(py_result_list.into())
}
