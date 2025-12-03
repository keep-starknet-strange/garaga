---
icon: octopus
---

# Noir

## Requirements (read carefully to avoid 99% of issues!)

* Garaga CLI [python-package.md](../installation/python-package.md "mention") version 1.0.1 (install with `pip install garaga==1.0.1`)
* Noir 1.0.0-beta.16 (install with `noirup --version 1.0.0-beta.16` or `npm i @noir-lang/noir_js@1.0.0-beta.16`)
* Barretenberg 3.0.0-nightly.20251104 (install with `bbup --version 3.0.0-nightly.20251104` or `npm i @aztec/bb.js@3.0.0-nightly.20251104`)

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
bb write_vk -s ultra_honk --oracle_hash keccak -b target/hello.json -o target/vk
```

{% hint style="info" %}
Note: ZK mode is enabled by default in barretenberg. The verification key is the same whether you generate a ZK proof or not.
{% endhint %}

Finally, generate a smart contract from the verifying key using the garaga CLI.

```bash
garaga gen --system ultra_keccak_zk_honk --vk target/vk
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
// The "hello" program simply proves that x!=y, with x being private and y public.
x = "1"
y = "2"
```

Now, generate a proof with barretenberg:

```bash
nargo execute witness
bb prove -s ultra_honk --oracle_hash keccak -b target/hello.json -w target/witness.gz -o target/
```

This creates two files in the `target/` directory:
- `target/proof` - the ZK proof
- `target/public_inputs` - the public inputs

{% hint style="info" %}
ZK mode is enabled by default. Use `--disable_zk` flag if you want to generate a non-ZK proof (not recommended for production).
{% endhint %}

## Generating the calldata (`full_proof_with_hints` array)

{% hint style="warning" %}
**Version Compatibility:** Use the same Garaga SDK version (pip/npm/Rust) that generated your verifier contract. Mismatched versions produce incompatible calldata and cause verification to fail.
{% endhint %}

{% tabs %}
{% tab title="CLI" %}
Finalizing the above CLI example, you can obtain the `full_proof_with_hints` array using the garaga CLI. From within the "hello" directory:

```bash
garaga calldata --system ultra_keccak_zk_honk --proof target/proof --vk target/vk --public-inputs target/public_inputs
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
    let vk_bytes = fs::read("target/vk").map_err(|e| e.to_string())?;
    let vk = HonkVerificationKey::from_bytes(&vk_bytes)?;

    // 2. Load the proof file
    let proof_bytes = fs::read("target/proof").map_err(|e| e.to_string())?;

    // 3. Load public inputs file
    let pub_inputs_bytes = fs::read("target/public_inputs").map_err(|e| e.to_string())?;

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
const vk = new Uint8Array(readFileSync('target/vk'));
const proof = new Uint8Array(readFileSync('target/proof'));
const publicInputs = new Uint8Array(readFileSync('target/public_inputs'));

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
vk = HonkVk.from_bytes(open('target/vk', 'rb').read())

# 2. Load proof and public inputs
proof_bytes = open('target/proof', 'rb').read()
public_inputs_bytes = open('target/public_inputs', 'rb').read()

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
bb write_vk -s ultra_honk --oracle_hash keccak -b target/hello.json -o target/vk
```

**Proof Generation (ZK mode is default):**

```bash
bb prove -s ultra_honk --oracle_hash keccak -b target/hello.json -w target/witness.gz -o target/
```

**Proof Verification (optional, for local testing):**

```bash
bb verify -s ultra_honk --oracle_hash keccak -p target/proof -k target/vk -i target/public_inputs
```

## Complete dApp Tutorial

Follow the [Scaffold‑Garaga repository](https://github.com/m-kus/scaffold-garaga). This starter kit combines **Noir**, **Garaga**, and **Starknet** with in‑browser proving to help you ship a privacy‑preserving dApp fast.

#### What you'll learn

1. **Generate & deploy an UltraHonk proof verifier** to a local Starknet devnet.
2. **Add on‑chain state** to your privacy‑preserving app.
3. **Connect a wallet and deploy to a public testnet**.

---

Need [support.md](../support.md "mention") ?
