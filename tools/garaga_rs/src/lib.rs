pub mod bn254_final_exp_witness;
pub mod bls12_381_final_exp_witness;

use ark_ff::{BigInteger, PrimeField};
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

    if curve_id == 0 { // BN254
        use ark_bn254::{Fq, Fq2, Fq6, Fq12};
        let f = Fq12::new(
            Fq6::new(
                Fq2::new(Fq::from_be_bytes_mod_order(byte_slice_1), Fq::from_be_bytes_mod_order(byte_slice_2)),
                Fq2::new(Fq::from_be_bytes_mod_order(byte_slice_3), Fq::from_be_bytes_mod_order(byte_slice_4)),
                Fq2::new(Fq::from_be_bytes_mod_order(byte_slice_5), Fq::from_be_bytes_mod_order(byte_slice_6)),
            ),
            Fq6::new(
                Fq2::new(Fq::from_be_bytes_mod_order(byte_slice_7), Fq::from_be_bytes_mod_order(byte_slice_8)),
                Fq2::new(Fq::from_be_bytes_mod_order(byte_slice_9), Fq::from_be_bytes_mod_order(byte_slice_10)),
                Fq2::new(Fq::from_be_bytes_mod_order(byte_slice_11), Fq::from_be_bytes_mod_order(byte_slice_12)),
            ),
        );
        let (c, wi) = bn254_final_exp_witness::get_final_exp_witness(f);
        let py_tuple = PyTuple::new(
            py,
            &[
                &c.c0.c0.c0.into_bigint().to_bytes_be(), &c.c0.c0.c1.into_bigint().to_bytes_be(),
                &c.c0.c1.c0.into_bigint().to_bytes_be(), &c.c0.c1.c1.into_bigint().to_bytes_be(),
                &c.c0.c2.c0.into_bigint().to_bytes_be(), &c.c0.c2.c1.into_bigint().to_bytes_be(),
                &c.c1.c0.c0.into_bigint().to_bytes_be(), &c.c1.c0.c1.into_bigint().to_bytes_be(),
                &c.c1.c1.c0.into_bigint().to_bytes_be(), &c.c1.c1.c1.into_bigint().to_bytes_be(),
                &c.c1.c2.c0.into_bigint().to_bytes_be(), &c.c1.c2.c1.into_bigint().to_bytes_be(),
                &wi.c0.c0.c0.into_bigint().to_bytes_be(), &wi.c0.c0.c1.into_bigint().to_bytes_be(),
                &wi.c0.c1.c0.into_bigint().to_bytes_be(), &wi.c0.c1.c1.into_bigint().to_bytes_be(),
                &wi.c0.c2.c0.into_bigint().to_bytes_be(), &wi.c0.c2.c1.into_bigint().to_bytes_be(),
                &wi.c1.c0.c0.into_bigint().to_bytes_be(), &wi.c1.c0.c1.into_bigint().to_bytes_be(),
                &wi.c1.c1.c0.into_bigint().to_bytes_be(), &wi.c1.c1.c1.into_bigint().to_bytes_be(),
                &wi.c1.c2.c0.into_bigint().to_bytes_be(), &wi.c1.c2.c1.into_bigint().to_bytes_be(),
            ]
        );
        return Ok(py_tuple.into());
    }

    if curve_id == 1 { // BLS12_381
        use ark_bls12_381::{Fq, Fq2, Fq6, Fq12};
        let f = Fq12::new(
            Fq6::new(
                Fq2::new(Fq::from_be_bytes_mod_order(byte_slice_1), Fq::from_be_bytes_mod_order(byte_slice_2)),
                Fq2::new(Fq::from_be_bytes_mod_order(byte_slice_3), Fq::from_be_bytes_mod_order(byte_slice_4)),
                Fq2::new(Fq::from_be_bytes_mod_order(byte_slice_5), Fq::from_be_bytes_mod_order(byte_slice_6)),
            ),
            Fq6::new(
                Fq2::new(Fq::from_be_bytes_mod_order(byte_slice_7), Fq::from_be_bytes_mod_order(byte_slice_8)),
                Fq2::new(Fq::from_be_bytes_mod_order(byte_slice_9), Fq::from_be_bytes_mod_order(byte_slice_10)),
                Fq2::new(Fq::from_be_bytes_mod_order(byte_slice_11), Fq::from_be_bytes_mod_order(byte_slice_12)),
            ),
        );
        let (c, wi) = bls12_381_final_exp_witness::get_final_exp_witness(f);
        let py_tuple = PyTuple::new(
            py,
            &[
                &c.c0.c0.c0.into_bigint().to_bytes_be(), &c.c0.c0.c1.into_bigint().to_bytes_be(),
                &c.c0.c1.c0.into_bigint().to_bytes_be(), &c.c0.c1.c1.into_bigint().to_bytes_be(),
                &c.c0.c2.c0.into_bigint().to_bytes_be(), &c.c0.c2.c1.into_bigint().to_bytes_be(),
                &c.c1.c0.c0.into_bigint().to_bytes_be(), &c.c1.c0.c1.into_bigint().to_bytes_be(),
                &c.c1.c1.c0.into_bigint().to_bytes_be(), &c.c1.c1.c1.into_bigint().to_bytes_be(),
                &c.c1.c2.c0.into_bigint().to_bytes_be(), &c.c1.c2.c1.into_bigint().to_bytes_be(),
                &wi.c0.c0.c0.into_bigint().to_bytes_be(), &wi.c0.c0.c1.into_bigint().to_bytes_be(),
                &wi.c0.c1.c0.into_bigint().to_bytes_be(), &wi.c0.c1.c1.into_bigint().to_bytes_be(),
                &wi.c0.c2.c0.into_bigint().to_bytes_be(), &wi.c0.c2.c1.into_bigint().to_bytes_be(),
                &wi.c1.c0.c0.into_bigint().to_bytes_be(), &wi.c1.c0.c1.into_bigint().to_bytes_be(),
                &wi.c1.c1.c0.into_bigint().to_bytes_be(), &wi.c1.c1.c1.into_bigint().to_bytes_be(),
                &wi.c1.c2.c0.into_bigint().to_bytes_be(), &wi.c1.c2.c1.into_bigint().to_bytes_be(),
            ]
        );
        return Ok(py_tuple.into());
    }

    panic!("Curve ID {} not supported", curve_id);
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
