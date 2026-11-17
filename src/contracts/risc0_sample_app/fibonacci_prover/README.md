# RISC Zero 3.1 Fibonacci prover

This example uses `risc0-zkvm` 3.1.0, `risc0-build` 3.0.7, and the RISC Zero 3.1.0 Groth16 verifier.
It proves that a private Fibonacci index belongs to the public interval `[l, u)`.
The journal contains `l`, `u`, and the Fibonacci number as little-endian `u32` values.

## Build and run

Guest compilation requires Docker with BuildKit.
The build script pins the official guest-builder image by digest and uses the committed Cargo lockfiles.
This keeps panic source paths and dependency versions identical locally and in CI.

Run these commands from the repository root. Install [rzup](https://dev.risczero.com/api/zkvm/install) first.

```bash
rzup install rust 1.97.0
rzup install r0vm 3.1.0
CARGO_TARGET_DIR=.cargo/risc0_sample/target cargo test --locked --manifest-path src/contracts/risc0_sample_app/fibonacci_prover/Cargo.toml --package host
CARGO_TARGET_DIR=.cargo/risc0_sample/target RISC0_PROVER=ipc RISC0_DEV_MODE=0 cargo run --locked --manifest-path src/contracts/risc0_sample_app/fibonacci_prover/Cargo.toml --package host
```

The sample uses the local RISC Zero client. The host requests a Groth16 proof and verifies the receipt before it generates calldata.
CPU Groth16 proving uses the `risczero/risc0-groth16-prover:v2026-10-20.1` Docker image.
The output contains a proof JSON object followed by a JSON array of Starknet calldata.
Garaga's default Python, Rust, and TypeScript parsers use the same verifier parameters.
Regenerate earlier receipts with `r0vm` 3.1.0 and use the new verifier class. [RISC Zero 3.1.0 release](https://github.com/risc0/risc0/releases/tag/v3.1.0)

## Update the SDK and verifier together

`tools/make/constants.json` defines the SDK and build versions, verifier release, control root, BN254 control ID, and Groth16 selector.
The SDK and build crate have separate versions.
The SDK tests verify their cryptographic compatibility.

1. Update those values in `tools/make/constants.json`.
2. Update `vk_risc0.json` from the corresponding upstream Groth16 verification key.
3. Run `make constants` to update the SDK manifests and the Python, Rust, and TypeScript constants.
4. Update both Cargo lockfiles.
5. Run the host command above to generate a proof.
6. Save its proof JSON object as `src/contracts/risc0_sample_app/fibonacci_prover/proof.json`.
7. Update the shared reference receipt in `proof_risc0.json`.
8. Run these commands after `make setup`.

```bash
make maturin
make rewrite
make update-risc0-class-hash
python tests/hydra/starknet/test_groth16_vk_proof_parsing.py --update-golden
make wasm
pytest tests/configuration/test_risc0_release.py
CARGO_TARGET_DIR=.cargo/risc0_sample/target cargo test --locked --manifest-path src/contracts/risc0_sample_app/fibonacci_prover/Cargo.toml --package host
(cd src/contracts/risc0_sample_app/fibonacci_sequencer && snforge test)
```

`make rewrite` regenerates the Cairo verifier and both stored calldata files.
`make update-risc0-class-hash` compiles that verifier and updates the sequencer constant.
`make wasm` rebuilds the committed bindings and integration package.
Before deployment, declare the generated verifier and UniversalECIP classes on the target network.

## Automatic consistency tests

The Python suite verifies SDK versions, default parameters, the generated Cairo point `T`, both receipts, and both stored calldata files.
It also compares Python and Rust calldata for both receipts.
The shared calldata vectors test the default Rust and TypeScript/WASM implementations.

The RISC Zero CI job builds the guest and verifies both committed receipts with the installed SDK.
It also compares the Fibonacci receipt image ID with the compiled guest image ID.
The Cairo CI job declares the compiled verifier locally, verifies its class hash, and submits the Fibonacci proof through the sequencer.
The devnet CI job also tests the verifier and sequencer as deployed contracts.
These tests require no public RPC endpoint and no new proof generation during CI.

The shared reference receipt comes from RISC Zero's Ethereum 3.1.0 tests.
The verification key comes from the same release. [Reference receipt](https://github.com/risc0/risc0-ethereum/blob/v3.1.0/contracts/test/TestReceiptV3_1.sol) · [Groth16 verifier](https://github.com/risc0/risc0-ethereum/blob/v3.1.0/contracts/src/groth16/Groth16Verifier.sol)
