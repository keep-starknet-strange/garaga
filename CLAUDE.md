# Garaga Standards

- **Rust/Python parity**: Every calldata builder has both a Python and Rust path via `use_rust` flag. Parity is enforced by pytest asserting `calldata_py == calldata_rs` byte-for-byte. Use `fixed_sigma` or equivalent for determinism.
- **TypeScript/Browser**: Every WASM binding gets a typed wrapper in `tools/npm/garaga_ts/src/node/api.ts`, a Jest test in `tests/starknet/`, and coverage across all 4 integration suites (Node CJS, Node ESM, Webpack, React).
- **E2E tests**: Deploy on starknet-devnet via `SmartContractProject.declare_class_hash()`, generate calldata via Python helpers, invoke contract, assert via `wait_for_acceptance()`. Test all calldata paths.
- **Build pipeline**: `make maturin` for Python bindings. `make wasm` for WASM+TypeScript+npm (Docker-based: builds wasm-pack, patches, bundles, copies tgz to integration-test-suite). `cargo test -p garaga_rs` for Rust tests.
