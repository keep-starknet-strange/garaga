pub mod ecip;
pub mod extf_mul;
pub mod final_exp_witness;
pub mod g2;
pub mod hades_permutation;
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
