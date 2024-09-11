pub mod algebra;
pub mod definitions;
pub mod ecip;
pub mod final_exp_witness;
pub mod io;
pub mod msm;
pub mod poseidon_transcript;

// automatically excludes python bindings on wasm32-unknown-unknown (pyo3 not supported)
#[cfg(all(feature = "python", not(target_arch = "wasm32")))]
pub mod python_bindings;

// automatically includes wasm bindings on wasm32-unknown-unknown
#[cfg(any(feature = "wasm", target_arch = "wasm32"))]
pub mod wasm_bindings;
