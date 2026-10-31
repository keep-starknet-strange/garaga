# Noir proof artifacts

This directory uses the Noir and Barretenberg versions in `tools/make/constants.json`.
Barretenberg's `evm` target selects the Ultra Keccak ZK flavor used by Garaga.

Run commands from the repository root:

```bash
make -C tools/noir prove
make constants
make rewrite
```

`prove` generates real receipts for four circuits:

- `hello` proves a private value differs from the public value.
- `memory` uses indexed ROM reads and RAM writes.
- `mutator_set` proves MMR inclusion for the embedded example contract.
- `recursive` verifies an inner proof of `hello` and exposes a nonzero pairing accumulator.

The command verifies each receipt before it updates the stored bundle.
It also updates the recursive witness and the inner key constant.
The bundle manifest records source hashes, bytecode hashes, SDK revisions, and artifact hashes.

Use this command for ordinary tests:

```bash
make -C tools/noir check
```

`check` compiles sources, rebuilds verification keys, verifies stored receipts, and rejects altered receipts.
It does not generate proofs.
The CI workflow installs checksum-pinned Linux binaries in an isolated directory and runs this command.

Set `BB_PATH` and `NARGO_PATH` to use binaries outside `PATH`.
Both binaries must match the pinned versions.

To inspect the canonical Python transcript:

```bash
uv run tools/noir/transcript.py --case hello
uv run tools/noir/transcript.py --case memory
uv run tools/noir/transcript.py --case recursive
```

Optional Solidity reference generation uses the same verified bundle:

```bash
make -C tools/noir solidity
make -C tools/noir sol-verify-debug
```

The generated Solidity files remain under each program's ignored `target` directory.

The Solidity reference tests run the four stored receipts and reject changed public inputs.
They use Foundry and the Solidity compiler pinned in `foundry.toml`.

To regenerate one independent receipt, add `--case`:

```bash
tools/noir/run.sh --prove --case mutator_set
```

The recursive case also needs `--case hello` because it verifies that circuit.
`make rewrite` regenerates the embedded MMR verifier and updates its class hash.
