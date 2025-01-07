---
icon: octopus
---

# Noir

## Requirements

* Noir 0.36.0 (install with \`noirup --version 0.36.0\`)
* Barretenberg 0.61.0 (install with \`bbup --version 0.61.0\`)
* Garaga CLI [python-package.md](../installation/python-package.md "mention")

To install `noirup` and `bbup`, follow the [quickstart guide from aztec ](https://noir-lang.org/docs/getting_started/quick_start):&#x20;

We recall the installations commands here:&#x20;

```bash
curl -L noirup.dev | bash
```

```bash
curl -L bbup.dev | bash
```

## Generate a Starknet smart contract for your Noir program

First, we'll create a new Noir project and compile it.&#x20;

```bash
nargo init hello
cd hello
nargo build
```

This will create a json file in `hello/target/hello.json`&#x20;

Now you can generate the corresponding verifying key using barretenberg :

```bash
bb write_vk_ultra_keccak_honk -b target/hello.json -o target/vk.bin
```

Finally, you can generate a smart contract from the verifying key using the garaga CLI

```bash
garaga gen --system ultra_keccak_honk --vk target/vk.bin
```

This will create a smart contract folder with the following structure.&#x20;

```
Generating Smart Contract project for ProofSystem.UltraKeccakHonk using vk.bin...
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

The main function of interest is located in  `honk_verifier.cairo`

The contract interface will be

```rust
#[starknet::interface]
trait IUltraKeccakHonkVerifier<TContractState> {
    fn verify_ultra_keccak_honk_proof(
        self: @TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<Span<u256>>;
}

```



In order to interact with the endpoint, you need to generate the `full_proof_with_hints`array.&#x20;

To do so, you need a specific proof for your program. But first, Noir requires you to specify the inputs of your program in `hello/Prover.toml` &#x20;

```toml
// The "hello" program simply prove that x!=y, with x being private and y public.  
x = "1"
y = "2"
```

You can now generate a proof with barretenberg, after running the program :&#x20;

```bash
nargo execute witness
bb prove_ultra_keccak_honk -b target/hello.json -w target/witness.gz -o target/proof.bin
```

Finally, you can obtain the `full_proof_with_hints` array using the garaga CLI. From within the "target" directory:&#x20;

```bash
garaga calldata --system ultra_keccak_honk --vk vk.bin --proof proof.bin --format array
```



{% hint style="info" %}
Using `garaga calldata`with the `--format array`  lets you paste this array in cairo code for unit tests by doing let proof:Array\<felt252> = \[ ... ] ; . The `--format starkli`  has a formatting which is composable with starkli in the command line and also preprends the length of the array so that it can be deserialized by starknet.&#x20;
{% endhint %}
