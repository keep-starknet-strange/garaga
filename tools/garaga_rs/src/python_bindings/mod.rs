pub mod ecip;
pub mod extf_mul;
pub mod final_exp_witness;
pub mod g2;
pub mod groth16_calldata;
pub mod hades_permutation;
pub mod honk_calldata;
pub mod mpc_calldata;
pub mod msm;
pub mod pairing;
pub mod signatures;

use lambdaworks_crypto::hash::poseidon::{starknet::PoseidonCairoStark252, Poseidon};

use lambdaworks_math::{field::traits::IsPrimeField, traits::ByteConversion};

use crate::crypto::poseidon_bn254::poseidon_hash_bn254 as core_poseidon_hash_bn254;
use crate::definitions::{
    BLS12381PrimeField, BN254PrimeField, FieldElement, GrumpkinPrimeField, Stark252PrimeField,
};

use crate::io::{element_from_biguint, element_to_biguint};
use num_bigint::BigUint;
use pyo3::{
    conversion::IntoPyObject,
    prelude::*,
    types::{PyBytes, PyInt, PyList, PyTuple},
};

const CURVE_BN254: usize = 0;
const CURVE_BLS12_381: usize = 1;

#[pyfunction]
pub fn poseidon_hash_bn254(
    py: Python,
    x: &Bound<'_, PyInt>,
    y: &Bound<'_, PyInt>,
) -> PyResult<PyObject> {
    let x_biguint: BigUint = x.extract()?;
    let y_biguint: BigUint = y.extract()?;

    let x_fe = element_from_biguint::<GrumpkinPrimeField>(&x_biguint);
    let y_fe = element_from_biguint::<GrumpkinPrimeField>(&y_biguint);

    let result = core_poseidon_hash_bn254(&x_fe, &y_fe);
    let result_biguint = element_to_biguint(&result);

    Ok(result_biguint.into_pyobject(py)?.into())
}

#[pymodule]
fn garaga_rs(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(g2::g2_add, m)?)?;
    m.add_function(wrap_pyfunction!(g2::g2_scalar_mul, m)?)?;
    m.add_function(wrap_pyfunction!(pairing::multi_pairing, m)?)?;
    m.add_function(wrap_pyfunction!(pairing::multi_miller_loop, m)?)?;
    m.add_function(wrap_pyfunction!(
        final_exp_witness::get_final_exp_witness,
        m
    )?)?;
    m.add_function(wrap_pyfunction!(hades_permutation::hades_permutation, m)?)?;
    m.add_function(wrap_pyfunction!(
        extf_mul::nondeterministic_extension_field_mul_divmod,
        m
    )?)?;
    m.add_function(wrap_pyfunction!(ecip::zk_ecip_hint, m)?)?;
    m.add_function(wrap_pyfunction!(msm::msm_calldata_builder, m)?)?;
    m.add_function(wrap_pyfunction!(mpc_calldata::mpc_calldata_builder, m)?)?;
    m.add_function(wrap_pyfunction!(groth16_calldata::get_groth16_calldata, m)?)?;
    m.add_function(wrap_pyfunction!(honk_calldata::get_honk_calldata, m)?)?;
    m.add_function(wrap_pyfunction!(signatures::schnorr_calldata_builder, m)?)?;
    m.add_function(wrap_pyfunction!(signatures::ecdsa_calldata_builder, m)?)?;
    m.add_function(wrap_pyfunction!(signatures::eddsa_calldata_builder, m)?)?;
    m.add_function(wrap_pyfunction!(poseidon_hash_bn254, m)?)?;
    m.add_function(wrap_pyfunction!(pairing::final_exp, m)?)?;
    Ok(())
}
