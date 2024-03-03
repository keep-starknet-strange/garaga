use lazy_static::lazy_static; 

use pyo3::{prelude::*, wrap_pyfunction};
use sha2::{Sha256, Digest};
use std::str::FromStr;
use pyo3::types::PyList;

use num_bigint::{BigInt, Sign};
use num_traits::{Num, One}; 
use num_integer::Integer;



lazy_static! {
    static ref PARAMS: PoseidonParams = PoseidonParams::get_default();
    static ref FIELD_PRIME_CONST : BigInt= PARAMS.field_prime.clone();

}

const DEFAULT_PRIME: &str = "3618502788666131213697322783095070105623107215331596699973092056135872020481";

fn generate_round_constant(fn_name: &str, field_prime: &BigInt, idx: usize) -> BigInt {
    let input = format!("{}{}", fn_name, idx);
    let mut hasher = Sha256::new();
    hasher.update(input.as_bytes());
    let result = hasher.finalize();
    BigInt::from_bytes_be(Sign::Plus, &result) % field_prime
}

struct PoseidonParams {
    field_prime: BigInt,
    r: usize,
    c: usize,
    m: usize,
    r_f: usize,
    r_p: usize,
    n_rounds: usize,
    output_size: usize,
    ark: Vec<Vec<BigInt>>,
}

impl PoseidonParams {
    fn new(field_prime: BigInt, r: usize, c: usize, r_f: usize, r_p: usize) -> Self {
        let m = r + c;
        let n_rounds = r_f + r_p;
        let ark = (0..n_rounds).map(|i| 
            (0..m).map(|j| generate_round_constant("Hades", &field_prime, m * i + j))
            .collect()
        ).collect();
        Self {
            field_prime,
            r,
            c,
            m,
            r_f,
            r_p,
            n_rounds,
            output_size: c,
            ark,
        }
    }
    fn get_default() -> Self {
        Self::new(
            BigInt::from_str(DEFAULT_PRIME).unwrap(),
            2, // r
            1, // c
            8, // r_f
            83 // r_p
        )
    }
}

fn hades_round(values: Vec<BigInt>, is_full_round: bool, round_idx: usize) -> Vec<BigInt> {
    let mut new_values = values.iter().enumerate().map(|(i, val)| {
        (val + &PARAMS.ark[round_idx][i]) % &PARAMS.field_prime
    }).collect::<Vec<_>>();

    if is_full_round {
        for val in new_values.iter_mut() {
            *val = val.modpow(&BigInt::from(3), &PARAMS.field_prime);
        }
    } else {
        // Assume the last value is the one to apply the operation if it's not a full round
        let last = new_values.len() - 1;
        new_values[last] = new_values[last].modpow(&BigInt::from(3), &PARAMS.field_prime);
    }

    // MixLayer - Using mds_mul function
    mds_mul(new_values, &PARAMS.field_prime)

}

#[pyfunction]
fn hades_permutation(py: Python, py_values: &PyList) -> PyResult<PyObject> {
    let mut values: Vec<BigInt> = Vec::new();
    for py_val in py_values.iter() {
        let val_str: String = py_val.extract()?;
        let bigint = BigInt::from_str_radix(&val_str, 10).map_err(|e| {
            PyErr::new::<pyo3::exceptions::PyValueError, _>(
                format!("Failed to parse BigInt: {}", e)
            )
        })?;        
        values.push(bigint);
    }
    values.push(BigInt::from_str("2").expect(""));

    let mut round_idx = 0;
    // Apply r_f/2 full rounds
    for _ in 0..(PARAMS.r_f / 2) {
        values = hades_round(values.clone(), true, round_idx);
        round_idx += 1;
    }
    // Apply r_p partial rounds
    for _ in 0..PARAMS.r_p {
        values = hades_round(values.clone(), false, round_idx);
        round_idx += 1;
    }
    // Apply r_f/2 full rounds again
    for _ in 0..(PARAMS.r_f / 2) {
        values = hades_round(values.clone(), true, round_idx);
        round_idx += 1;
    }
    // Convert Vec<BigInt> back to a Python list of integers
    let result_list = PyList::empty(py);
    for value in values {
        let py_bigint = value.to_str_radix(10);
        let py_int = py.eval(&format!("int('{}')", py_bigint), None, None)?.to_object(py);
        result_list.append(py_int)?;
    }

    Ok((&result_list[0..2]).into())
}


fn mds_mul(vector: Vec<BigInt>, field: &BigInt) -> Vec<BigInt> {
    let three = BigInt::from(3);
    let two = BigInt::from(2);
    let one = BigInt::one();
    let minus_one = -&one;

    vec![
        (three.clone() * &vector[0] + &vector[1] + &vector[2]).mod_floor(field),
        (&vector[0] + minus_one * &vector[1] + &vector[2]).mod_floor(field),
        (&vector[0] + &vector[1] - two * &vector[2]).mod_floor(field),
    ]
}

#[pymodule]
fn hades_binding(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(hades_permutation,m)?)?;
    Ok(())
}
