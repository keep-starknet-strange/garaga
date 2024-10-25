pub mod ecip;
pub mod extf_mul;
pub mod final_exp_witness;
pub mod g2;
pub mod groth16_calldata;
pub mod hades_permutation;
pub mod mpc_calldata;
pub mod msm;
pub mod pairing;

use ark_ec::pairing::Pairing;
use ark_ec::AffineRepr;
use ark_ff::PrimeField;
use lambdaworks_crypto::hash::poseidon::{starknet::PoseidonCairoStark252, Poseidon};

use lambdaworks_math::{field::traits::IsPrimeField, traits::ByteConversion};

use crate::definitions::{BLS12381PrimeField, BN254PrimeField, FieldElement, Stark252PrimeField};
use num_bigint::BigUint;
use pyo3::{
    prelude::*,
    types::{PyBytes, PyInt, PyList, PyTuple},
};

const CURVE_BN254: usize = 0;
const CURVE_BLS12_381: usize = 1;

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
    Ok(())
}
