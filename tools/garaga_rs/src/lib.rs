pub mod algebra;
pub mod definitions;
pub mod ecip;
pub mod final_exp_witness;
pub mod io;
pub mod msm;
pub mod poseidon_transcript;
pub mod python_bindings;

use pyo3::{prelude::*, wrap_pyfunction};

#[pymodule]
fn garaga_rs(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(python_bindings::g2::g2_add, m)?)?;
    m.add_function(wrap_pyfunction!(python_bindings::g2::g2_scalar_mul, m)?)?;
    m.add_function(wrap_pyfunction!(
        python_bindings::pairing::multi_pairing,
        m
    )?)?;
    m.add_function(wrap_pyfunction!(
        python_bindings::pairing::multi_miller_loop,
        m
    )?)?;
    m.add_function(wrap_pyfunction!(
        python_bindings::final_exp_witness::get_final_exp_witness,
        m
    )?)?;
    m.add_function(wrap_pyfunction!(
        python_bindings::hades_permutation::hades_permutation,
        m
    )?)?;
    m.add_function(wrap_pyfunction!(
        python_bindings::extf_mul::nondeterministic_extension_field_mul_divmod,
        m
    )?)?;
    m.add_function(wrap_pyfunction!(python_bindings::ecip::zk_ecip_hint, m)?)?;
    Ok(())
}
