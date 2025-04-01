pub mod algebra {
    pub mod extf_mul;
    pub mod g1g2pair;
    pub mod g1point;
    pub mod g2point;
    pub mod polynomial;
    pub mod rational_function;
}
pub mod calldata;

pub mod crypto {
    #[allow(dead_code)]
    pub mod poseidon_bn254;
}
pub mod definitions;
pub mod ecip {
    pub mod core;
    pub mod ff;
}
pub mod frobenius;
pub mod io;

pub mod pairing {
    pub mod final_exp_witness;
    pub mod multi_miller_loop;
    pub mod multi_pairing_check;
}

pub mod poseidon_transcript;

// automatically excludes python bindings on wasm32-unknown-unknown (pyo3 not supported)
#[cfg(all(feature = "python", not(target_arch = "wasm32")))]
pub mod python_bindings;

// automatically includes wasm bindings on wasm32-unknown-unknown
#[cfg(any(feature = "wasm", target_arch = "wasm32"))]
pub mod wasm_bindings;
