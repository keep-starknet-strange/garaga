# RISC Zero 3 Fibonacci prover

This example uses zkVM and build tools 3.0.6 with the RISC Zero v3.0.1 verifier parameters.
It proves that a private Fibonacci index belongs to the public interval `[l, u)`.
The journal contains `l`, `u`, and the Fibonacci number as little-endian `u32` values.

## Build and run

Run these commands from the repository root. Install [rzup](https://dev.risczero.com/api/zkvm/install) first.

```bash
rzup install rust 1.97.0
rzup install r0vm 3.0.6
cargo test --manifest-path src/contracts/risc0_sample_app/fibonacci_prover/Cargo.toml --package host
RISC0_PROVER=ipc cargo run --manifest-path src/contracts/risc0_sample_app/fibonacci_prover/Cargo.toml --package host
```

The host requests a Groth16 proof and verifies the receipt before it generates calldata.
Groth16 proving requires the RISC Zero prover dependencies, including Docker for the Groth16 container.
The output contains a proof JSON object followed by a JSON array of Starknet calldata.
Garaga's default Python, Rust, and TypeScript parsers use the same verifier parameters.

## Update the SDK and verifier together

`tools/make/constants.json` defines the SDK version, verifier release, control root, and BN254 control ID.
The SDK version and verifier release can have different patch versions.
The SDK tests verify their cryptographic compatibility.

1. Update those values in `tools/make/constants.json`.
2. Run `make constants` to update the three SDK manifests and the Python, Rust, and TypeScript constants.
3. Run the host command above to generate a new proof.
4. Save its proof JSON object as `src/contracts/risc0_sample_app/fibonacci_prover/proof.json`.
5. Replace the shared `proof_risc0.json` example with a valid receipt for the new parameters.
6. Run the following commands after `make setup`:

```bash
make rewrite
make update-risc0-class-hash
python tests/hydra/starknet/test_groth16_vk_proof_parsing.py --update-golden
make wasm
pytest tests/configuration/test_risc0_release.py
cargo test --manifest-path src/contracts/risc0_sample_app/fibonacci_prover/Cargo.toml --package host
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
