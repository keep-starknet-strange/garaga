---
icon: octopus
---

# Noir

## Requirements

* Noir 0.36.0 (install with \`noirup --version 0.36.0\`)
* Barretenberg 0.61.0 (install with \`bbup --version 0.61.0\`)
* Garaga CLI [python-package.md](../installation/python-package.md "mention")

To install `noirup` and `bbup`, follow the [quickstart guide from aztec ](https://noir-lang.org/docs/getting_started/quick_start):

We recall the installations commands here:

```bash
curl -L noirup.dev | bash
```

```bash
curl -L bbup.dev | bash
```

## Generate a Starknet smart contract for your Noir program

First, we'll create a new Noir project and compile it.

```bash
nargo new hello
cd hello
nargo build
```

This will create a json file in `hello/target/hello.json`

Now you can generate the corresponding verifying key using barretenberg :

```bash
bb write_vk_ultra_keccak_honk -b target/hello.json -o target/vk.bin
```

Finally, you can generate a smart contract from the verifying key using the garaga CLI

```bash
garaga gen --system ultra_keccak_honk --vk target/vk.bin
```

This will create a smart contract folder with the following structure.

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

The main function of interest is located in `honk_verifier.cairo`

The contract interface will be

```rust
#[starknet::interface]
trait IUltraKeccakHonkVerifier<TContractState> {
    fn verify_ultra_keccak_honk_proof(
        self: @TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<Span<u256>>;
}

```

In order to interact with the endpoint, you need to generate the `full_proof_with_hints`array.

To do so, you need a specific proof for your program. But first, Noir requires you to specify the inputs of your program in `hello/Prover.toml`

```toml
// The "hello" program simply prove that x!=y, with x being private and y public.
x = "1"
y = "2"
```

You can now generate a proof with barretenberg, after running the program :

```bash
nargo execute witness
bb prove_ultra_keccak_honk -b target/hello.json -w target/witness.gz -o target/proof.bin
```

Finally, you can obtain the `full_proof_with_hints` array using the garaga CLI. From within the "target" directory:

```bash
garaga calldata --system ultra_keccak_honk --vk vk.bin --proof proof.bin --format array
```

{% hint style="info" %}
Using `garaga calldata`with the `--format array` lets you paste this array in cairo code for unit tests by doing let proof:Array\<felt252> = \[ ... ] ; . The `--format starkli` has a formatting which is composable with starkli in the command line and also preprends the length of the array so that it can be deserialized by starknet.
{% endhint %}

## The Ultra Starknet Flavor

We are in the process of adding a new flavor to Noir proofs called Ultra Starknet. It contrasts with with Ultra Keccak presented in the previous section.

The Ultra Starknet flavor replaces the Keccak hash function by [Poseidon](https://www.poseidon-hash.info/), which is a ZK-friendly hash function and therefore better suited in the context of Starknet and Cairo contracts.

In order to provide the Ultra Starknet flavor we forked and customized the Barretenberg (`bb`) implementation. Here the steps to build the customized `bb`:

1. Install [build dependencies](https://github.com/AztecProtocol/aztec-packages/tree/master/barretenberg#development) (assuming here a Debian-compatible system)

```bash
sudo apt install -y cmake clang clang-16 clang-format libstdc++-12-dev ninja-build
```

2. Clone our fork of the Aztec Packages repository and checkout the specific branch

```bash
git clone https://github.com/raugfer/aztec-packages.git
cd aztec-packages
git checkout ultra-starknet-honk
```

3. Perform the build

```bash
cd barretenberg/cpp
cmake --preset clang16
cmake --build --preset clang16 --target bb
```

4. Manually install the custom `bb` command, conveniently, under the Nargo config folder

```bash
install build/bin/bb ~/.nargo/bin/
mkdir ~/.nargo/lib/
install build/src/barretenberg/crypto/poseidon/sources/lib_pos* ~/.nargo/lib/
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/.nargo/lib/"
```

Now, in order to generate a Ultra Starknet proof and verifying key using the customized Barretenberg implementation, simply issue the following commands:

```bash
bb prove_ultra_starnet_honk -b target/hello.json -w target/witness.gz -o target/proof.bin
bb write_vk_ultra_starnet_honk -b target/hello.json -o target/vk.bin
```

To generate a contract using the Ultra Starknet system, use the following command, which is similar to the previous process:

```bash
garaga gen --system ultra_starknet_honk --vk target/vk.bin
```

And, as with the Ultra Keccak flavor, one can obtain the `full_proof_with_hints` array using the garaga CLI :

```bash
garaga calldata --system ultra_starknet_honk --vk vk.bin --proof proof.bin --format array
```
