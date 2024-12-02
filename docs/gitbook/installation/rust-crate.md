---
icon: rust
---

# Rust Crate

To use the [`garaga_rs`](https://github.com/keep-starknet-strange/garaga/tree/main/tools/garaga\_rs) crate in your project, add the following to your `Cargo.toml`



```
[dependencies]
garaga_rs = { git = "https://github.com/keep-starknet-strange/garaga.git"}

```

It is recommended to use the latest [release tag](https://github.com/keep-starknet-strange/garaga/releases) of the form `vX.Y.Z` (example `v0.14.0`) to be in sync with the latest declared [maintained-smart-contracts](../maintained-smart-contracts/ "mention").&#x20;

```
[dependencies]
garaga_rs = { git = "https://github.com/keep-starknet-strange/garaga.git", tag = "v0.14.0" }

```



