pub mod bn254_final_exp_witness;
pub mod bls12_381_final_exp_witness;

use ark_ff::PrimeField;
use num_bigint::BigUint;
use lambdaworks_crypto::hash::poseidon::{starknet::PoseidonCairoStark252, Poseidon};
use lambdaworks_math::{
    field::{
        element::FieldElement, fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
    },
    traits::ByteConversion,
};
use pyo3::{
    types::{PyBytes, PyList, PyTuple},
    {prelude::*, wrap_pyfunction},
};

#[pymodule]
fn garaga_rs(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(get_final_exp_witness, m)?)?;
    m.add_function(wrap_pyfunction!(hades_permutation, m)?)?;
    Ok(())
}

#[pyfunction]
fn get_final_exp_witness(py: Python, curve_id: usize, py_list: &PyList) -> PyResult<PyObject> {
    let f_0: BigUint = py_list[0].extract()?;
    let f_1: BigUint = py_list[1].extract()?;
    let f_2: BigUint = py_list[2].extract()?;
    let f_3: BigUint = py_list[3].extract()?;
    let f_4: BigUint = py_list[4].extract()?;
    let f_5: BigUint = py_list[5].extract()?;
    let f_6: BigUint = py_list[6].extract()?;
    let f_7: BigUint = py_list[7].extract()?;
    let f_8: BigUint = py_list[8].extract()?;
    let f_9: BigUint = py_list[9].extract()?;
    let f_10: BigUint = py_list[10].extract()?;
    let f_11: BigUint = py_list[11].extract()?;

    if curve_id == 0 { // BN254
        use ark_bn254::{Fq, Fq2, Fq6, Fq12};
        let f = Fq12::new(
            Fq6::new(
                Fq2::new(Fq::from(f_0), Fq::from(f_1)),
                Fq2::new(Fq::from(f_2), Fq::from(f_3)),
                Fq2::new(Fq::from(f_4), Fq::from(f_5)),
            ),
            Fq6::new(
                Fq2::new(Fq::from(f_6), Fq::from(f_7)),
                Fq2::new(Fq::from(f_8), Fq::from(f_9)),
                Fq2::new(Fq::from(f_10), Fq::from(f_11)),
            ),
        );
        let (c, wi) = bn254_final_exp_witness::get_final_exp_witness(f);
        fn to(v: Fq12) -> [BigUint; 12] {
            [
                BigUint::from(v.c0.c0.c0.into_bigint()), BigUint::from(v.c0.c0.c1.into_bigint()),
                BigUint::from(v.c0.c1.c0.into_bigint()), BigUint::from(v.c0.c1.c1.into_bigint()),
                BigUint::from(v.c0.c2.c0.into_bigint()), BigUint::from(v.c0.c2.c1.into_bigint()),
                BigUint::from(v.c1.c0.c0.into_bigint()), BigUint::from(v.c1.c0.c1.into_bigint()),
                BigUint::from(v.c1.c1.c0.into_bigint()), BigUint::from(v.c1.c1.c1.into_bigint()),
                BigUint::from(v.c1.c2.c0.into_bigint()), BigUint::from(v.c1.c2.c1.into_bigint()),
            ]
        }
        let py_tuple = PyTuple::new(py, [PyList::new(py, to(c)), PyList::new(py, to(wi))]);
        return Ok(py_tuple.into());
    }

    if curve_id == 1 { // BLS12_381
        use ark_bls12_381::{Fq, Fq2, Fq6, Fq12};
        let f = Fq12::new(
            Fq6::new(
                Fq2::new(Fq::from(f_0), Fq::from(f_1)),
                Fq2::new(Fq::from(f_2), Fq::from(f_3)),
                Fq2::new(Fq::from(f_4), Fq::from(f_5)),
            ),
            Fq6::new(
                Fq2::new(Fq::from(f_6), Fq::from(f_7)),
                Fq2::new(Fq::from(f_8), Fq::from(f_9)),
                Fq2::new(Fq::from(f_10), Fq::from(f_11)),
            ),
        );
        let (c, wi) = bls12_381_final_exp_witness::get_final_exp_witness(f);
        fn to(v: Fq12) -> [BigUint; 12] {
            [
                BigUint::from(v.c0.c0.c0.into_bigint()), BigUint::from(v.c0.c0.c1.into_bigint()),
                BigUint::from(v.c0.c1.c0.into_bigint()), BigUint::from(v.c0.c1.c1.into_bigint()),
                BigUint::from(v.c0.c2.c0.into_bigint()), BigUint::from(v.c0.c2.c1.into_bigint()),
                BigUint::from(v.c1.c0.c0.into_bigint()), BigUint::from(v.c1.c0.c1.into_bigint()),
                BigUint::from(v.c1.c1.c0.into_bigint()), BigUint::from(v.c1.c1.c1.into_bigint()),
                BigUint::from(v.c1.c2.c0.into_bigint()), BigUint::from(v.c1.c2.c1.into_bigint()),
            ]
        }
        let py_tuple = PyTuple::new(py, [PyList::new(py, to(c)), PyList::new(py, to(wi))]);
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
