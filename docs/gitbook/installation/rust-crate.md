---
icon: rust
---

# Rust Crate

To use the [`garaga_rs`](https://github.com/keep-starknet-strange/garaga/tree/main/tools/garaga_rs) crate in your project, add the following to your `Cargo.toml`

```toml
[dependencies]
garaga_rs = { git = "https://github.com/keep-starknet-strange/garaga.git"}
```

It is recommended to use the latest [release tag](https://github.com/keep-starknet-strange/garaga/releases) of the form `vX.Y.Z` (example `v1.0.0`) to be in sync with the latest declared [maintained-smart-contracts](../maintained-smart-contracts/ "mention").

```toml
[dependencies]
garaga_rs = { git = "https://github.com/keep-starknet-strange/garaga.git", tag = "v1.0.0" }
```

## Features

The `garaga_rs` crate provides optional features for different use cases:

- **No features (default)**: Pure Rust library without any bindings
- **`python` feature**: Enables Python bindings via PyO3 (for use with maturin)
- **`wasm` feature**: Enables WebAssembly bindings via wasm-bindgen (for use with wasm-pack)

For example, if you're building a Python extension:
```toml
[dependencies]
garaga_rs = { git = "https://github.com/keep-starknet-strange/garaga.git", tag = "v1.0.0", features = ["python"] }
```
