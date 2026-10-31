---
icon: octopus
---

# Noir

## Toolchain

* Garaga CLI built from the source revision that generates the Cairo contract.
* Noir 1.0.0 (install with `noirup --version 1.0.0` or `npm i @noir-lang/noir_js@1.0.0`)
* Barretenberg 6.0.0 (install with `bbup --version 6.0.0` or `npm i @aztec-foundation/bb.js@6.0.0`)

Until this integration is released, install Garaga from this checkout:

```bash
uv pip install -e .
```

To install `noirup` and `bbup`, follow the [quickstart guide from aztec](https://noir-lang.org/docs/getting_started/quick_start).

## Generate a Starknet smart contract for your Noir program

First, create a new Noir project and compile it with `nargo build`.

```bash
nargo new hello
cd hello
nargo build
```

This will create a json file in `hello/target/hello.json`

Now, generate the corresponding verifying key `vk` using barretenberg:

```bash
bb write_vk -t evm -b target/hello.json -o target/honk
```

{% hint style="info" %}
`-t evm` selects the Ultra Keccak ZK flavor. Other targets produce different keys or transcripts. Generate the key and proof with the same target.
{% endhint %}

Finally, generate a smart contract from the verifying key using the garaga CLI.

```bash
garaga gen --system ultra_keccak_zk_honk --vk target/honk/vk
```

This will create a smart contract folder with the following structure.

```
Generating Smart Contract project for ProofSystem.UltraKeccakZKHonk using vk...
Done!
Smart Contract project created:
/noir/hello/my_project/
├── .tools-versions
├── Scarb.toml
└── src/
    ├── honk_verifier.cairo
    ├── honk_verifier_circuits.cairo
    ├── honk_verifier_constants.cairo
    └── lib.cairo
```

The main function of interest is located in `honk_verifier.cairo`

The contract interface will be

```rust
#[starknet::interface]
pub trait IUltraKeccakZKHonkVerifier<TContractState> {
    fn verify_ultra_keccak_zk_honk_proof(
        self: @TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Result<Span<u256>, felt252>; // Returns Ok(public_inputs) on success, Err on failure.
}
```

In order to interact with the endpoint, we need to generate the `full_proof_with_hints` array.

To do so, we need a specific proof for your program. But first, Noir requires to specify the inputs of the program in `hello/Prover.toml`

```toml
# The hello program proves x != y. The value x is private, and y is public.
x = "1"
y = "2"
```

Now, generate a proof with barretenberg:

```bash
nargo execute witness
bb prove -t evm --write_vk --verify -b target/hello.json -w target/witness.gz -o target/honk
```

This writes the proof, public inputs, key, and key hash in `target/honk/`:
- `target/honk/proof` - the ZK proof
- `target/honk/public_inputs` - the public inputs

{% hint style="info" %}
This verifier accepts Ultra Keccak ZK proofs. The `evm-no-zk`, `noir-recursive`, and `starknet` targets do not produce receipts for this endpoint.
{% endhint %}

## Generating the calldata (`full_proof_with_hints` array)

{% hint style="warning" %}
**Version compatibility:** Use the same Garaga source revision or release for the SDK and generated contract. The earlier published `1.1.0` packages do not contain this Barretenberg 6 integration.
{% endhint %}

{% tabs %}
{% tab title="CLI" %}
Finalizing the above CLI example, you can obtain the `full_proof_with_hints` array using the garaga CLI. From within the "hello" directory:

```bash
garaga calldata --system ultra_keccak_zk_honk --proof target/honk/proof --vk target/honk/vk --public-inputs target/honk/public_inputs
```

{% hint style="info" %}
Using `garaga calldata` with the `--format array` lets you paste this array in cairo code for unit tests by doing `let proof: Array<felt252> = [...];`. The `--format starkli` has a formatting which is composable with starkli in the command line and also prepends the length of the array so that it can be deserialized by starknet. The `--format snforge` (default) creates a file that can be used with snforge.
{% endhint %}
{% endtab %}

{% tab title="Rust" %}
Add the [rust-crate.md](../installation/rust-crate.md "mention") to your project.

```rust
// Version must match the pip package that generated the verifier
use garaga_rs::calldata::full_proof_with_hints::zk_honk::{
    get_zk_honk_calldata, HonkVerificationKey, ZKHonkProof,
};
use std::fs;

fn main() -> Result<(), String> {
    // 1. Load your verification key
    let vk_bytes = fs::read("target/honk/vk").map_err(|e| e.to_string())?;
    let vk = HonkVerificationKey::from_bytes(&vk_bytes)?;

    // 2. Load the proof file
    let proof_bytes = fs::read("target/honk/proof").map_err(|e| e.to_string())?;

    // 3. Load public inputs file
    let pub_inputs_bytes = fs::read("target/honk/public_inputs").map_err(|e| e.to_string())?;

    // 4. Parse the proof (requires log_circuit_size from vk)
    let proof = ZKHonkProof::from_bytes(&proof_bytes, &pub_inputs_bytes, vk.log_circuit_size)?;

    // 5. Generate calldata
    let calldata = get_zk_honk_calldata(&proof, &vk)?;

    println!("Calldata length: {}", calldata.len());
    Ok(())
}
```
{% endtab %}

{% tab title="Typescript" %}
Using the `garaga` [npm-package.md](../installation/npm-package.md "mention")

```typescript
// Version must match the pip package that generated the verifier
import * as garaga from 'garaga';
import { readFileSync } from 'fs';

// 1. Initialize the WASM module (required before using any garaga functions)
await garaga.init();

// 2. Load your proof, public inputs, and verification key as Uint8Array
const vk = new Uint8Array(readFileSync('target/honk/vk'));
const proof = new Uint8Array(readFileSync('target/honk/proof'));
const publicInputs = new Uint8Array(readFileSync('target/honk/public_inputs'));

// 3. Generate calldata for ZK Honk proofs
const calldata: bigint[] = garaga.getZKHonkCallData(proof, publicInputs, vk);

console.log('Calldata length:', calldata.length);
```
{% endtab %}

{% tab title="Python" %}
Using the `garaga` [python-package.md](../installation/python-package.md "mention")

```python
# Version must match the pip package that generated the verifier
from garaga.precompiled_circuits.zk_honk import HonkVk, ZKHonkProof
from garaga.starknet.honk_contract_generator.calldata import (
    get_ultra_flavor_honk_calldata_from_vk_and_proof
)

# 1. Load your verification key
vk = HonkVk.from_bytes(open('target/honk/vk', 'rb').read())

# 2. Load proof and public inputs
proof_bytes = open('target/honk/proof', 'rb').read()
public_inputs_bytes = open('target/honk/public_inputs', 'rb').read()

# 3. Parse the proof
proof = ZKHonkProof.from_bytes(proof_bytes, public_inputs_bytes, vk)

# 4. Generate calldata
calldata: list[int] = get_ultra_flavor_honk_calldata_from_vk_and_proof(vk=vk, proof=proof)

print(f'Calldata length: {len(calldata)}')
```
{% endtab %}
{% endtabs %}

## BB CLI Reference

{% hint style="info" %}
Use `bb write_vk --help` and `bb prove --help` to see all available options.
{% endhint %}

**Verification Key Generation:**

```bash
bb write_vk -t evm -b target/hello.json -o target/honk
```

**Proof Generation (ZK mode is default):**

```bash
bb prove -t evm --write_vk --verify -b target/hello.json -w target/witness.gz -o target/honk
```

**Proof Verification (optional, for local testing):**

```bash
bb verify -t evm -p target/honk/proof -k target/honk/vk -i target/honk/public_inputs
```

## Version migration and proof artifacts

Barretenberg 6 changes the proof layout, entity order, relation parameters, and transcript challenges.
Regenerate verification keys, proofs, calldata, and Cairo contracts together.
Old verifier classes cannot verify these receipts.

The verifier validates canonical scalar values, point coordinates, and accumulator limbs.
It aggregates nondefault recursive pairing accumulators before the final pairing check.
The generated contract tests include public outputs and rejection cases.

From the Garaga repository, regenerate the example, memory, and recursive proof bundles with:

```bash
make -C tools/noir prove
make constants
make rewrite
```

The recursive fixture verifies the example circuit with an SDK-generated inner proof.
The regeneration command updates its inner key constant and witness before the outer proof.
Proof generation is explicit and changes the stored artifacts.

Verify the stored artifacts without proof generation:

```bash
make -C tools/noir check
```

This command compiles the Noir sources, rebuilds their verification keys, and compares the keys with the stored artifacts.
It also verifies the stored proofs with the pinned Barretenberg CLI and rejects modified receipts.
The Noir CI workflow runs this command.
Python tests compare the Python and Rust calldata with the generated Cairo fixtures.

See [the Cairo measurements](../../benchmarks/barretenberg-v6/README.md) for steps, Sierra gas, contract size, and profiling results.

## Complete dApp Tutorial

Follow the [Scaffold‑Garaga repository](https://github.com/m-kus/scaffold-garaga). This starter kit combines **Noir**, **Garaga**, and **Starknet** with in‑browser proving to help you ship a privacy‑preserving dApp fast.

#### What you'll learn

1. **Generate & deploy an UltraHonk proof verifier** to a local Starknet devnet.
2. **Add on‑chain state** to your privacy‑preserving app.
3. **Connect a wallet and deploy to a public testnet**.

---

Need [support.md](../support.md "mention") ?
