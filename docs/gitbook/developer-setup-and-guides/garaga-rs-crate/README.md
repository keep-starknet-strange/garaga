---
icon: crab
---

# garaga-rs crate

The `garaga_rs` crate is the performance-critical Rust library that powers Garaga's cryptographic operations. It provides high-performance implementations of elliptic curve operations, pairing computations, and proof serialization, with bindings to both Python (via PyO3) and WebAssembly (via wasm-bindgen).

## Overview

The crate serves as the computational backend for Garaga, accelerating operations that would be too slow in pure Python:

- **Elliptic curve operations**: Point addition, scalar multiplication, multi-scalar multiplication (MSM)
- **Pairing computations**: Miller loop, final exponentiation, multi-pairing checks
- **Proof serialization**: Calldata generation for Groth16, Honk, and signature verification
- **Cryptographic hints**: GLV decomposition, ECIP protocol, Frobenius maps

## Module Structure

```
tools/garaga_rs/src/
├── lib.rs                 # Crate entry point
├── definitions.rs         # Curve definitions (6 curves)
├── io.rs                  # Field element serialization
├── algebra/               # EC operations
│   ├── g1point.rs         # G1 point arithmetic
│   ├── g2point.rs         # G2 point arithmetic
│   ├── polynomial.rs      # Polynomial operations
│   └── extf_mul.rs        # Extension field multiplication
├── calldata/              # Proof serialization
│   ├── msm_calldata.rs    # MSM calldata generation
│   ├── mpc_calldata.rs    # Multi-pairing check calldata
│   └── full_proof_with_hints/
│       ├── groth16.rs     # Groth16 (+ RISC0, SP1)
│       └── zk_honk.rs     # ZK Honk calldata
├── pairing/               # Pairing operations
│   ├── multi_miller_loop.rs
│   └── final_exp_witness/
├── ecip/                  # ECIP protocol
│   ├── core.rs            # ECIP hint generation
│   └── ff.rs              # Function field arithmetic
├── hints/                 # Cryptographic hints
│   ├── fake_glv.rs        # GLV decomposition
│   └── eisenstein.rs      # Eisenstein integers
├── crypto/                # Hash functions
│   ├── poseidon_bn254.rs  # Poseidon hash
│   └── mmr/               # Merkle Mountain Range
├── python_bindings/       # PyO3 bindings
└── wasm_bindings.rs       # WASM bindings
```

## Supported Curves

| ID | Curve | Use Cases |
|----|-------|-----------|
| 0 | BN254 | Groth16, Honk, RISC0, SP1 |
| 1 | BLS12-381 | Groth16, drand signatures |
| 2 | SECP256K1 | Bitcoin/Ethereum ECDSA |
| 3 | SECP256R1 | NIST P-256, WebAuthn |
| 4 | X25519/ED25519 | EdDSA signatures |
| 5 | GRUMPKIN | Noir circuits |

## Feature Flags

The crate uses feature flags to control which bindings are compiled:

```toml
[features]
default = []           # Pure Rust library
python = ["pyo3"]      # Python bindings via PyO3
wasm = ["wasm-bindgen", "js-sys"]  # WASM bindings
```

## Key Exports

### Python Bindings

When compiled with `--features python`, the following functions are available:

```python
from garaga import garaga_rs

# G2 operations
garaga_rs.g2_add(...)
garaga_rs.g2_scalar_mul(...)

# Pairing operations
garaga_rs.multi_pairing(...)
garaga_rs.multi_miller_loop(...)
garaga_rs.final_exp(...)

# Hint generation
garaga_rs.get_final_exp_witness(...)
garaga_rs.zk_ecip_hint(...)

# Calldata builders
garaga_rs.msm_calldata_builder(...)
garaga_rs.mpc_calldata_builder(...)
garaga_rs.get_groth16_calldata(...)
garaga_rs.get_zk_honk_calldata(...)

# Signatures
garaga_rs.schnorr_calldata_builder(...)
garaga_rs.ecdsa_calldata_builder(...)
garaga_rs.eddsa_calldata_builder(...)

# Hashing
garaga_rs.poseidon_hash_bn254(...)
garaga_rs.hades_permutation(...)

# Extension field
garaga_rs.nondeterministic_extension_field_mul_divmod(...)

# drand
garaga_rs.drand_calldata_builder(...)
```

### WASM Bindings

When compiled with `--features wasm`, similar functions are exported for JavaScript/TypeScript use via `wasm-bindgen`.

## Building

### For Python (via maturin)

```bash
cd tools/garaga_rs
maturin develop --release --features python
```

### For WASM

```bash
cd tools/garaga_rs
wasm-pack build --target web --release --no-default-features --features wasm
```

### Docker build (reproducible)

```bash
cd tools/npm/garaga_ts
docker compose up --build
```

## Testing

```bash
cd tools/garaga_rs
cargo test
```

## Dependencies

Key external crates:

- **lambdaworks-math/crypto**: Field arithmetic and cryptographic primitives
- **num-bigint**: Arbitrary precision integers
- **pyo3**: Python bindings (optional)
- **wasm-bindgen**: WASM bindings (optional)
- **sha2/sha3**: Hash functions
- **rayon**: Parallel computation

## Next Steps

- [Rust -> Python bindings](rust-greater-than-python-bindings.md) — Adding new Python bindings
- [Rust -> WASM bindings](rust-greater-than-wasm-bindings.md) — Adding new WASM bindings
