---
icon: octopus
---

# Noir

## Requirements (read carefully to avoid 99% of issues!)

* Garaga CLI [python-package.md](../installation/python-package.md "mention") version 0.18.0 (install with `pip install garaga==0.18.0`
* Noir 1.0.0-beta.3 (install with `noirup --version 1.0.0-beta.3`)&#x20;
* Barretenberg 0.86.0-starknet.1 (install with `bbup --version 0.86.0-starknet.1`or `npm i @aztec/bb.js@0.86.0-starknet.1` )

To install `noirup` and `bbup`, follow the [quickstart guide from aztec](https://noir-lang.org/docs/getting_started/quick_start).

## Generate a Starknet smart contract for your Noir program

#### Supported barretenberg flavours



<table><thead><tr><th width="134">BB --scheme</th><th width="160.800048828125">BB --oracle_hash</th><th width="90.1666259765625" data-type="checkbox">--zk flag</th><th width="124.3665771484375">Local support</th><th>Browser (bb.js) support</th><th>System name in garaga</th></tr></thead><tbody><tr><td><code>ultra_honk</code></td><td><code>keccak</code></td><td>false</td><td>✅</td><td>✅</td><td><code>ultra_keccak_honk</code></td></tr><tr><td><code>ultra_honk</code></td><td><code>keccak</code></td><td>true</td><td>✅</td><td>✅</td><td><code>ultra_keccak_zk_honk</code></td></tr><tr><td><code>ultra_honk</code></td><td><code>poseidon</code></td><td>false</td><td>Not planned</td><td>-</td><td>-</td></tr><tr><td><code>ultra_honk</code></td><td><code>poseidon</code></td><td>true</td><td>Not planned</td><td>-</td><td>-</td></tr><tr><td><code>ultra_honk</code></td><td><code>starknet</code></td><td>false</td><td>✅</td><td>✅</td><td><code>ultra_starknet_honk</code></td></tr><tr><td><code>ultra_honk</code></td><td><code>starknet</code></td><td>true</td><td>✅</td><td>Missing ❌</td><td><code>ultra_starknet_zk_honk</code></td></tr></tbody></table>

First, create a new Noir project and compile it with `nargo build`.

```bash
nargo new hello
cd hello
nargo build
```

This will create a json file in `hello/target/hello.json`

Now, generate the corresponding verifying key `vk`using barretenberg :

```bash
bb write_vk --scheme ultra_honk --oracle_hash keccak -b target/hello.json -o target
```

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
trait IUltraKeccakZKHonkVerifier<TContractState> {
    fn verify_ultra_keccak_zk_honk_proof(
        self: @TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<Span<u256>>; // Returns the public inputs in case of success.  
}
```

In order to interact with the endpoint, we need to generate the `full_proof_with_hints`array.

To do so, we need a specific proof for your program. But first, Noir requires to specify the inputs of the program in `hello/Prover.toml`

```toml
// The "hello" program simply prove that x!=y, with x being private and y public.
x = "1"
y = "2"
```

Now, generate a proof with barretenberg, after running the program (notice that the `--zk`flag that occurs only in the proving part, not in the verifying key generation) :

```bash
nargo execute witness
bb prove -s ultra_honk --oracle_hash keccak --zk -b target/hello.json -w target/witness.gz -o target/
```

## Generating the calldata (`full_proof_with_hints` array)

{% tabs %}
{% tab title="CLI" %}
Finalizing the above CLI example, you can obtain the `full_proof_with_hints` array using the garaga CLI. From within the "target" directory:

```bash
garaga calldata --system ultra_keccak_zk_honk --proof proof --vk vk
```

{% hint style="info" %}
Using `garaga calldata`with the `--format array` lets you paste this array in cairo code for unit tests by doing let proof:Array\<felt252> = \[ ... ] ; . The `--format starkli` has a formatting which is composable with starkli in the command line and also preprends the length of the array so that it can be deserialized by starknet.
{% endhint %}
{% endtab %}

{% tab title="Rust" %}
Add the [rust-crate.md](../installation/rust-crate.md "mention") to your project **using the same release tag as the version of pip package that generated the verifier.**

```rust
use garaga_rs::calldata::full_proof_with_hints::{
    honk::{get_honk_calldata, HonkFlavor, HonkProof, HonkVerificationKey},
    zk_honk::{get_zk_honk_calldata, ZKHonkProof},
};
use std::fs::File;
use std::io::Read;

// 1. Add the Rust Crate to your project using the same release tag as the version of pip
// package that generated the verifier.

// 2. Load your verification key
let mut vk_file = File::open("path/to/vk.bin")?;
let mut vk_bytes = vec![];
vk_file.read_to_end(&mut vk_bytes)?;
let vk = HonkVerificationKey::from_bytes(&vk_bytes)?;

// 3. Load the proof and generate the calldata
// For Honk proofs
let mut proof_file = File::open("path/to/proof.bin")?;
let mut proof_bytes = vec![];
proof_file.read_to_end(&mut proof_bytes)?;
let proof = HonkProof::from_bytes(&proof_bytes)?;

let calldata = get_honk_calldata(&proof, &vk, HonkFlavor::KECCAK)?;

// For ZK Honk proofs
let mut zk_proof_file = File::open("path/to/zk_proof.bin")?;
let mut zk_proof_bytes = vec![];
zk_proof_file.read_to_end(&mut zk_proof_bytes)?;
let zk_proof = ZKHonkProof::from_bytes(&zk_proof_bytes)?;

let zk_calldata = get_zk_honk_calldata(&zk_proof, &vk, HonkFlavor::KECCAK)?;
```
{% endtab %}

{% tab title="Typescript" %}
Using the `garaga` [npm-package.md](../installation/npm-package.md "mention")

```typescript
import { getHonkCallData, getZKHonkCallData } from '@garaga/honk';
import { HonkFlavor } from '@garaga/honk/starknet/honkContractGenerator/parsingUtils';
import { readFile } from 'fs/promises';

// 1. Add the NPM package to your project using the same release tag as the version of pip
// package that generated the verifier.

// 2. Load your proof and verification key as Uint8Array
const vk: Uint8Array = await readFile('path/to/vk.bin');
const proof: Uint8Array = await readFile('path/to/proof.bin');

// For Honk proofs (Keccak flavor)
const calldata = getHonkCallData(
    proof,
    vk,
    HonkFlavor.KECCAK // or HonkFlavor.STARKNET for Starknet flavor
);

// For ZK Honk proofs (Keccak flavor)
const zkCalldata = getZKHonkCallData(
    proof,
    vk,
    HonkFlavor.KECCAK // or HonkFlavor.STARKNET for Starknet flavor
);

// The functions return bigint[]
```
{% endtab %}

{% tab title="Python" %}
Using the`garaga` [python-package.md](../installation/python-package.md "mention")

```python
from pathlib import Path
from garaga.definitions import ProofSystem
from garaga.precompiled_circuits.honk import (
    HonkVk,
    honk_proof_from_bytes
)
from garaga.starknet.honk_contract_generator.calldata import (
    get_ultra_flavor_honk_calldata_from_vk_and_proof
)

# 1. Add the pip package to your project using the same release tag as the version that 
# generated the verifier.

# 2. Load your proof and verification key
vk_path = Path('path/to/vk.bin')
proof_path = Path('path/to/proof.bin')

# Read the verification key
with open(vk_path, 'rb') as f:
    vk_bytes = f.read()
    vk = HonkVk.from_bytes(vk_bytes)

# Read and parse the proof
with open(proof_path, 'rb') as f:
    proof_bytes = f.read()
    # The proof will be parsed according to the system type
    # Available proof systems:
    # - ProofSystem.UltraKeccakHonk     # Regular Honk with Keccak
    # - ProofSystem.UltraStarknetHonk   # Regular Honk with Starknet hash
    # - ProofSystem.UltraKeccakZKHonk   # ZK Honk with Keccak
    # - ProofSystem.UltraStarknetZKHonk # ZK Honk with Starknet hash
    proof = honk_proof_from_bytes(proof_bytes, vk, system=ProofSystem.UltraKeccakHonk)

calldata: list[int] = get_ultra_flavor_honk_calldata_from_vk_and_proof(
    vk=vk,
    proof=proof,  # Can be either HonkProof or ZKHonkProof
    system=ProofSystem.UltraKeccakHonk,  # Or any other supported system
)
```
{% endtab %}
{% endtabs %}

## The UltraStarknet Flavour

The Ultra Starknet flavour replaces the Keccak hash function by [Starknet's Poseidon hash](https://docs.starknet.io/architecture-and-concepts/cryptography/#poseidon_hash), which is better suited in the context of Starknet and Cairo contracts.\
Using it will both optimize on-chain verification costs and verifier contract bytecode sizes.&#x20;

You can follow the previous tutorial using the starknet flavours of [#supported-barretenberg-flavours](noir.md#supported-barretenberg-flavours "mention") :

* `--oracle_hash starknet` in bb commands
* `--system ultra_starknet_honk` or `--system ultra_starknet_zk_honk` in garaga CLI
* etc. in the other python, rust, npm tooling.



## Complete dApp Tutorial

Follow the  [Scaffold‑Garaga repository](https://github.com/m-kus/scaffold-garaga). This starter kit combines **Noir**, **Garaga**, and **Starknet** with in‑browser proving to help you ship a privacy‑preserving dApp fast.

#### What you’ll learn

1. **Generate & deploy an UltraHonk proof verifier** to a local Starknet devnet.
2. **Add on‑chain state** to your privacy‑preserving app.
3. **Connect a wallet and deploy to a public testnet**.

***

Need [support.md](../support.md "mention") ?
