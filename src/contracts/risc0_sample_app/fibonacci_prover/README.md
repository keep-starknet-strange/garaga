# RISC Zero 3 Fibonacci prover

This example uses zkVM and build tools 3.0.6 with the RISC Zero 3 receipt seal format.
It proves that a private Fibonacci index belongs to the public interval `[l, u)`.
The journal contains `l`, `u`, and the Fibonacci number as little-endian `u32` values.

## Build and run

Run these commands from the repository root. Install [rzup](https://dev.risczero.com/api/zkvm/install) first.

```bash
rzup install rust 1.97.0
rzup install r0vm 3.0.6
cargo test --manifest-path src/contracts/risc0_sample_app/fibonacci_prover/Cargo.toml --package host
cargo run --manifest-path src/contracts/risc0_sample_app/fibonacci_prover/Cargo.toml --package host
```

The host requests a Groth16 proof and verifies the receipt before it generates calldata.
Groth16 proving requires the RISC Zero prover dependencies, including Docker when the prover uses the Groth16 container.
The output contains a proof JSON object followed by a JSON array of Starknet calldata.
Use the host-generated calldata for this version.
Garaga's default JSON proof parser still uses the existing RISC Zero 2 parameters.

## Match the Cairo verifier

RISC Zero 3 uses this control root:

```text
0xa54dc85ac99f851c92d7c96d7318af41dbe7c0194edfcc37eb4d422a998c1f56
```

The BN254 control ID and Groth16 verification key match the previous release.
The host obtains both control parameters from `Groth16ReceiptVerifierParameters` in the installed SDK.
It passes them to `Groth16Proof::from_risc0_with_parameters`.
The default `Groth16Proof::from_risc0` method retains its RISC Zero 2 behavior.

Generate a matching Cairo verifier from the repository root after `make setup`:

```python
from garaga.starknet.groth16_contract_generator.generator_risc0 import (
    gen_risc0_groth16_verifier,
)

gen_risc0_groth16_verifier(
    vk_path="hydra/garaga/starknet/groth16_contract_generator/examples/vk_risc0.json",
    output_folder_path="/tmp/garaga-risc0-v3",
    output_folder_name="risc0_v3_verifier",
    control_root=0xA54DC85AC99F851C92D7C96D7318AF41DBE7C0194EDFCC37EB4D422A998C1F56,
)
```

The generated constants record the selected control root.
Their release tag still describes Garaga's default RISC Zero release, rather than this explicit parameter override.

Before you use the Fibonacci sequencer, declare the generated verifier on the target network.
Set `RISC_ZERO_VERIFIER_CLASS_HASH` in the sequencer to its class hash, then deploy the sequencer.
The checked-in sequencer class hash and `make update-risc0-class-hash` refer to the default RISC Zero 2 verifier.
They cannot verify receipts from this updated prover.

## Validation

The RISC Zero CI workflow builds the guest and runs the host parameter test.
The Rust library tests use the official RISC Zero 3 receipt fixture.
They accept the v3 control root and reject the same receipt with the v2 control root.
