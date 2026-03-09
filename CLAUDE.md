# Garaga

## Project layout
- `src/` — Cairo contracts and library (Scarb workspace, `snforge test`)
- `tools/garaga_rs/` — Rust core (`cargo test -p garaga_rs`, `cargo clippy`)
- `tools/garaga_rs/src/python_bindings/` — PyO3 bindings (`make maturin`)
- `tools/garaga_rs/src/wasm_bindings.rs` — WASM bindings (`make wasm`, Docker-based)
- `tools/npm/garaga_ts/` — TypeScript wrappers + WASM pkg
- `hydra/` — Python calldata builders and helpers
- `tests/` — E2E and integration tests

## Build commands
| What | Command |
|------|---------|
| Rust tests | `cargo test -p garaga_rs` |
| Rust lint | `cargo clippy --workspace` |
| Python bindings | `make maturin` |
| WASM + TS + npm | `make wasm` (Docker) |
| Cairo tests | `snforge test -p garaga` |
| Format | `make fmt` (scarb fmt + cargo fmt) |

## Critical invariants

**Rust/Python parity**: Every calldata builder has both a Python and Rust path via `use_rust` flag. Parity is enforced by pytest asserting `calldata_py == calldata_rs` byte-for-byte. Use `fixed_sigma` or equivalent for determinism.

**WASM regeneration**: After any change to Rust source in `tools/garaga_rs/src/` (except `python_bindings/`) or `Cargo.toml`, run `make wasm` and commit regenerated files in `tools/npm/garaga_ts/src/wasm/pkg/`. CI will fail if out of sync.

**TypeScript coverage**: Every WASM binding needs a typed wrapper in `tools/npm/garaga_ts/src/node/api.ts`, a Jest test, and coverage across all 4 integration suites (Node CJS, Node ESM, Webpack, React).

**E2E tests**: Deploy on starknet-devnet via `SmartContractProject.declare_class_hash()`, generate calldata via Python, invoke contract, assert via `wait_for_acceptance()`.
