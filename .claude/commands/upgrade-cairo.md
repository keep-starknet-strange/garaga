# Upgrade Cairo Version

Upgrade the Cairo/Scarb toolchain from its canonical version source, then run the full compatibility checks.

## Arguments

- **NEW_CAIRO_VERSION**: The exact target Cairo/Scarb version, in `major.minor.patch` format.
- **NEW_FOUNDRY_VERSION**: An optional exact Starknet Foundry version. Without this argument, keep the current Foundry version.

## Procedure

### 1. Select the target versions

Read `release_info` in `tools/make/constants.json` for the current versions.
Use the target versions that the user already selected.
If the user has not selected versions, inspect the available releases:

```sh
asdf list all scarb
asdf list all starknet-foundry
```

Present stable target versions and obtain the user's selection before changing them.
Record the current and target versions for the upgrade report.

### 2. Synchronize the toolchain configuration

If `venv` is absent, run `make setup` before changing the version source.
Update `release_info.cairo_version` in `tools/make/constants.json`.
If the user selected a Foundry update, also update `release_info.starknet_foundry_version`.
From the repository root, run:

```sh
make sync-toolchain
make check-toolchain
```

The synchronization command updates tracked Scarb manifests, `.tool-versions`, CI toolchain inputs, and the two Python generator version constants.
It includes manual and generated projects. Setup reads its required Scarb version directly from the canonical source.
It preserves package versions, unrelated constants, comments, and cryptographic source files.
If an unsupported configuration format stops synchronization, resolve that format before continuing.
Require the check command to exit successfully.

### 3. Install the selected toolchain

From the repository root, run:

```sh
asdf install
scarb --version
snforge --version
```

Require the installed versions to match the selected versions.
If asdf is unavailable, install those exact releases through the supported Scarb and Foundry installers.
Report installation failures before proceeding.

### 4. Regenerate and format the artifacts

Run the complete regeneration:

```sh
make rewrite
make check-toolchain
```

This step regenerates Cairo circuits, verifier contracts, and application tests. It is separate from configuration synchronization.
Review the generated diff and require both commands to succeed.
If the compiler requires Cairo or generator logic changes, handle those changes in separate compatibility work.
Keep the upgrade incomplete until that work and its checks pass.

### 5. Recompute compiler-dependent class hashes

Build the universal ECIP contract and compute its class hash:

```sh
(cd src/contracts/universal_ecip && scarb build)
(cd src/contracts/universal_ecip && sncast utils class-hash --contract-name UniversalECIP)
```

Remove leading hexadecimal zeroes after `0x` from the reported hash.
Update `ECIP_OPS_CLASS_HASH` in `hydra/garaga/starknet/groth16_contract_generator/generator.py` with that value.
Regenerate the verifier contracts, then update the RISC0 sample application hash:

```sh
make rewrite
make update-risc0-class-hash
make check-toolchain
```

Require the generated ECIP references and the RISC0 sample hash to match the compiled contracts.
These deployment references require separate recomputation. The synchronization command does not change them.

### 6. Update current installation instructions

Review Scarb and Foundry version references in:

- `README.md`
- `docs/gitbook/installation/developer-setup.md`
- `docs/gitbook/maintained-smart-contracts/risczero.md`
- `docs/CONTRIBUTING.md`

Update current installation requirements to the selected versions.
Preserve historical version references in changelogs and benchmark reports.
Use `rg` to find remaining references to the previous versions and account for each intentional reference.

### 7. Run the full compatibility checks

Run the local compilation and formatting checks:

```sh
(cd src && scarb build && scarb fmt --check)
source venv/bin/activate
black --check .
```

Black comes from the locked `venv` environment. Its version owner is `uv.lock`, not a separate requirements file.
The commit hook uses that same executable and retains the Python 3.11 formatting target.

With `act` or `gh act` configured, run the existing workflow runners:

```sh
make ci-hydra
make ci-cairo
make ci-e2e
make ci-wasm
```

Require all hosted Hydra, Cairo, E2E, WASM, Node, and setup checks to pass for the upgrade commit.
Include every Python matrix entry, generated-code cleanliness, bytecode size limits, and package integration checks.
Configuration consistency alone does not prove compiler or runtime compatibility.

### 8. Report the result

Report the selected versions, synchronization result, regenerated artifacts, recomputed hashes, and compatibility-check results.
Identify any intentional historical references and any incomplete compatibility work.
Complete the upgrade only after every required check passes.
