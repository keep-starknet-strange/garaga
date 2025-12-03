---
icon: microchip
---

# RiscZero

RiscZero is a Zero-Knowledge Proof system designed to enable efficient and scalable construction of computational proofs based on the RISC-V architecture. It is Groth16-based and works over the BN254 elliptic curve.

Garaga provides the tools and makes it possible to verify such proofs on-chain in a Starknet/Cairo smart contract.

A Zero-Knowledge proof is a mathematical construct that guarantees that a given value is the output of a predefined computation where some of the inputs are private and must not be disclosed.

This is achieved in two steps:

1- A Prover performs the computation and constructs the proof artifact. The proof artifact contains the computational journal which is, in simple terms, the list of public inputs and the output value. The proof artifact attests the integrity of the computation, which means the prover ran the computation properly and the output value registered in the journal corresponds to the result of such computation given the public inputs, also registered in the jornal, an some undisclosed private inputs. Here the Prover is a RiscZero user-defined program that implements the desired computation and is augmented to produce the desired proof artifact.

2- Given the proof artifact, a Verifier must check its integrity before processing the output as valid. Here the Verifier is a Starknet smart contract written in Cairo and Garaga acts as a library to which the verification is delegated to.

### Setting up the development environment

Before starting development we need to install all the software prerequisites for building either or both the Prover and Verifier components.

Below we provide general installation instructions for a Linux-based system. Depending on your setup you may already have some of the software installed, in which case you can skip the associated sections. But if you need additional help for a specific set up, please follow the links provided.\
\
In order to implement the Prover one needs to install the tooling required by RiscZero:

1. Install Rust/Cargo using [`rustup`](https://rustup.rs/) (default version 1.8.3)

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
export PATH="$HOME/.cargo/bin:$PATH"
```

2. Install the RiscZero tool-chain using [`rzup`](https://dev.risczero.com/api/zkvm/install) (default version 1.2.0)

```bash
curl -L https://risczero.com/install | bash
export PATH="$HOME/.risc0/bin:$PATH"
rzup install
```

_Important: Make sure the RiscZero version installed matches the version supported by Garaga. For RiscZero v2.2.2 use Garaga 1.0.1. Check [constants.json](https://github.com/keep-starknet-strange/garaga/blob/main/tools/make/constants.json) for the latest supported versions._

3. Install RiscZero additional/custom dependencies

A C compiler, such as `gcc`, `pkg-config` and OpenSSL development libraries (`libssl-dev)` are necessary to build a RiscZero project. You should refer to your system documentation on how to install those. Here is a quick reference for Debian compatible systems

```bash
sudo apt install -y gcc libssl-dev pkg-config
```

Optionally, if you intend to have the Prover generate the contract call data explicitly, Garaga requires that Python is available in your environment. If necessary, check their [documentation](https://docs.python.org/3/using/index.html) for installation instructions for your system. Again, here is a quick reference for Debian compatible systems

```bash
sudo apt install -y python3
```

In order to implement the Verifier one needs to install the tooling for Cairo development and Garaga:

4. Install the Starknet/Cairo bundler tool [`scarb`](https://docs.swmansion.com/scarb/download#install-via-installation-script) (default version 2.14.0)

```bash
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | bash
export PATH="$HOME/.local/bin:$PATH"
```

5. Install Starknet Foundry using [`snfoundryup`](https://foundry-rs.github.io/starknet-foundry/getting-started/installation.html) (default version 0.53.0)

```bash
curl -L https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh | bash
export PATH="$HOME/.local/bin:$PATH"
snfoundryup
```

### Create or configure the RiscZero project

1. If you are setting up a new RiscZero project, run the command below, it will create a new project folder and define the Guest program name. The Guest program is the program that is compiled to and will run in the RiscZero VM. The project setup also creates a Host program that runs outside the RiscZero VM and interacts with the Guest, providing inputs and collecting outputs, to produce the ZK proof. Here we set up a sample project called `fibonacci_prover` with a Guest called `fibonacci_guest` (for reference, the complete RiscZero app presented here is available in [Garaga's GitHub repository](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/risc0_sample_app))

```
cargo risczero new fibonacci_prover --guest-name fibonacci_guest
```

If you already have a RiscZero project set up, make sure the RiscZero version configured as dependencies is consistent with the RiscZero toolchain installed in the previous steps.

2. Next we need to modify the RiscZero Host program to output the proof artifact in the desired JSON format. Add the following dependencies to `host/Cargo.toml`

```toml
[dependencies]
risc0-ethereum-contracts = { version = "1.2.0" }
hex = "0.4"
...
```

Optionally, if you intend to explicitly generate and handle the call-data, also add the following dependency to `host/Cargo.toml`. Make sure to use a Garaga version tag that is consistent with your setup.

<pre class="language-toml"><code class="lang-toml">[dependencies]
<strong>garaga_rs = { git = "https://github.com/keep-starknet-strange/garaga.git", tag = "v1.0.1" }
</strong>...
</code></pre>

Then we modify the Host program `host/src/main.rs` to generate the JSON file containing the proof artifact. We start by adding the required imports

```rust
use risc0_zkvm::{
    compute_image_id, default_prover, ExecutorEnv, ProverOpts, VerifierContext
};
use risc0_ethereum_contracts::encode_seal;
```

Optionally, if you intend to generate the call-data explicitly, add the following imports

```rust
use garaga_rs::definitions::CurveID;
use garaga_rs::calldata::full_proof_with_hints::groth16::{
    get_groth16_calldata, Groth16Proof
};
use garaga_rs::calldata::full_proof_with_hints::groth16::risc0_utils::get_risc0_vk;
```

Next we need to modify the Host main function.

If you are starting a fresh RiscZero project, you will need to setup the environment for the computation. This is basically the set of inputs that will be used by the Guest program to perform the computation.

Below is an example for the `fibonacci_prover`. In this example, we want to compute the number at position `n` of the Fibonacci sequence. However we do not want to reveal `n`, but instead show that `n` lies in a given interval defined by a lower bound `l` and an upper bound `u`.

```rust
let l: u32 = 3; // public lower bound for n
let u: u32 = 8; // public upper bound for n
let n: u32 = 6; // private n for which we will compute fibonacci(n)
let env = ExecutorEnv::builder()
    .write(&l)
    .unwrap()
    .write(&u)
    .unwrap()
    .write(&n)
    .unwrap()
    .build()
    .unwrap();
```

_As a note, the sample app provided here exists only to demonstrate how to setup a ZK project using Garaga/RiscZero. It is clear that datatype `u32` is not appropriate datatype to host a secret Fibonacci number as it can be easily discovered by brute force checking all possibilities between the bounds._

Next we modify the default Prover setup to explicitly use Groth16

```rust
let prove_info = prover
    .prove_with_ctx(
        env,
        &VerifierContext::default(),
        FIBONACCI_GUEST_ELF,
        &ProverOpts::groth16()
    )
    .unwrap();
```

Finally, as the last step of the Host program, we extract and print the proof artifact JSON to the standard output

<pre class="language-rust"><code class="lang-rust"><strong>let receipt = prove_info.receipt;
</strong>let seal = to_bytes(encode_seal(&#x26;receipt).unwrap());
let image_id = to_bytes(compute_image_id(&#x26;FIBONACCI_GUEST_ELF).unwrap());
let journal = to_bytes(receipt.journal);
println!(
    "{{\"seal\": \"0x{}\", \"image_id\": \"0x{}\", \"journal\": \"0x{}\"}}",
    hex::encode(&#x26;seal),
    hex::encode(&#x26;image_id),
    hex::encode(&#x26;journal)
);

// helper function to convert objects to array of bytes
fn to_bytes&#x3C;T: AsRef&#x3C;[u8]>>(obj: T) -> Vec&#x3C;u8> {
    obj.as_ref().to_vec()
}
</code></pre>

Optionally, if you also intend to handle the call-data explicitly, it can be computed and output as a JSON as well. This produces a large array that encodes the full RiscZero proof wih hints

```rust
let proof = Groth16Proof::from_risc0(seal, image_id, journal);
let calldata = get_groth16_calldata(&proof, &get_risc0_vk(), CurveID::BN254).unwrap();
println!("[{}]", calldata.iter().skip(1).map(|v| format!("\"{}\"", v)).collect::<Vec<_>>().join(", "));
```

Now we need to set up the Guest program that performs the computation required by our use case.

If you started a fresh RiscZero project, then you will need to write the Guest program that performs the computation. It is done by modifying the main function of the Guest source file at `methods/guest/src/main.rs`

In our example, here is what the Guest code looks like for the `fibonacci_guest`

```rust
// reads the public bounds and private n provided by the Host
let l: u32 = env::read();
let u: u32 = env::read();
let n: u32 = env::read();

// sanity check for the bounds
assert!(l <= n && n < u);

// performs the computation
let fib_n: u32 = fibonacci(n);

fn fibonacci(n: u32) -> u32 {
    let mut a = 0;
    let mut b = 1;
    for _ in 0..n {
        (a, b) = (b, a + b);
    }
    a
}

// writes the public inputs and output to the journal
env::commit(&l);
env::commit(&u);
env::commit(&fib_n);
```

### RiscZero Proof Generation

RiscZero provides some options when it comes to proof generation. Please refer to their [documentation](https://dev.risczero.com/api/generating-proofs/proving-options) in case you need to in depth information on that. The easiest and most convenient way is to use the provided [Bonsai](https://www.bonsai.xyz/) service, which works fine for many purposes. In that case, an API key for the service is required.

_It is important to note that, if your computation has private inputs, you should definitely protect them from being exposed to external services like Bonsai by performing the proof generation locally._

Here is the command to run the Prover via Bonsai

```
BONSAI_API_KEY=<YOUR_API_KEY> BONSAI_API_URL=<BONSAI_URL> RISC0_DEV_MODE=0 \
    cargo run --release
```

### Developing the RiscZero Verifier smart contract

There are different ways one can choose to develop a Cairo smart contract, we recommend using Staknet Foundry. A fresh new project can be created by issuing the following command

```bash
snforge new fibonacci_sequencer
```

This will output a template for a smart contract along with the necessary tooling configuration to build and test it. In this case we are creating a contract called `fibonacci_sequencer`, that will process and update its state with a new number in the Fibonacci sequence that is guaranteed to have an index `n` in the sequence that is higher than the last one currently registered by the contract, although that exact index `n` is never revealed publicly.

Garaga already provides a smart contract to verify RiscZero proofs. To make use of that functionality, one just has to call a predefined library function from the client smart contract. In order to do that, one needs to declare the interface of the RiscZero verifying library function in `src/lib.cairo`:

```rust
#[starknet::interface]
trait IRisc0Groth16VerifierBN254<TContractState> {
    fn verify_groth16_proof_bn254(
        self: @TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<Span<u8>>;
}
```

The `verify_groth16_proof_bn254` function takes the call data that encodes the proof with hints as a list of integers of type `felt252` and returns the journal (as a list of bytes) on proof verification success, or nothing if the verification fails.

Here is how to verify the RiscZero proof and update the smart contract state for our Fibonacci sequencer example:

```rust
fn verify_and_submit_fibonacci_number(ref self: ContractState, full_proof_with_hints: Span<felt252>) {
    // sets the class hash for the RiscZero verifier already declared on-chain
    // by the Garaga team
    let class_hash: ClassHash = RISC_ZERO_VERIFIER_CLASS_HASH.try_into().unwrap();

    // instantiate a library dispatcher to perform the library call
    // to the RiscZero verifier class, given that verifying a proof is
    // a read-only operation
    let dispatcher = IRisc0Groth16VerifierBN254LibraryDispatcher { class_hash };

    // calls the RiscZero verifier passing along the proof artifact and
    // checks whether the proof is valid or not, aborting the transaction if not
    let optional_journal = dispatcher.verify_groth16_proof_bn254(full_proof_with_hints);
    assert(optional_journal != Option::None, 'Invalid proof');

    // parses the public inputs and output from the journal
    let mut journal = optional_journal.unwrap();
    let l = pop_front_u32_le(ref journal);
    let u = pop_front_u32_le(ref journal);
    let fib_n = pop_front_u32_le(ref journal);

    // performs the necessary state update check, updates the state,
    // and emits an event with the new fibnoacci number submitted
    // the smart contract invariant guarantees that every fiboacci number
    // accepted comes later in the fibonacci sequence without revealing
    // its index, which is trivial for monotonic sequences like fibnacci,
    // but would also work as expected also for non-monotonic ones
    let b = self.lower_bound.read();
    assert(l >= b, 'Invalid lower bound');
    self.lower_bound.write(u);
    self.emit(FibonnacciNumberSubmitted { n: fib_n });
    self.emit(LowerBoundUpdated { n: u });
}
```

Along with the `verify_and_submit_fibonacci_number` contract method, we need to define the RiscZero Verifier class hash, which can be obtained [here](./)

```rust
use core::starknet::ClassHash;

pub const RISC_ZERO_VERIFIER_CLASS_HASH: felt252 =
    0x1367d4ed2f58cfaaeda8cb18a8fb108d77c33b847e9beced89351adece9fd5a;
```

The contract state which stores the current lower bound which gets updated whenever a new Fibonacci number is submitted

```rust
#[storage]
struct Storage {
    lower_bound: u32,
}
```

And also the helper function used to decode the journal values

```rust
fn pop_front_u32_le(ref bytes: Span<u8>) -> u32 {
    let [b0, b1, b2, b3] = (*bytes.multi_pop_front::<4>().unwrap()).unbox();
    let b0: u32 = b0.into();
    let b1: u32 = b1.into();
    let b2: u32 = b2.into();
    let b3: u32 = b3.into();
    b0 + 256 * (b1 + 256 * (b2 + 256 * b3))
}
```

For completeness, we also provide the definition of the events emitted by the operation

```rust
#[event]
#[derive(Drop, starknet::Event)]
enum Event {
    FibonnacciNumberSubmitted: FibonnacciNumberSubmitted,
    LowerBoundUpdated: LowerBoundUpdated,
}

#[derive(Drop, starknet::Event)]
struct FibonnacciNumberSubmitted {
    #[key]
    n: u32,
}

#[derive(Drop, starknet::Event)]
struct LowerBoundUpdated {
    #[key]
    n: u32,
}
```

It is important to note that the `verify_and_submit_fibonacci_number` function defined in this sample contract has a signature that takes a single argument: the proof artifact. This is useful because we can then submit the transaction to the blockchain directly, simply using the Garaga CLI passing along the JSON file output by the RiscZero Host program. This avoids the need to encode the proof as a customized call data. It also spares us from dealing with the transaction submission details which is handled internally by the Garaga CLI.

This is an approach that makes sense when all the information required to validate and update the smart contract state can be extracted from the journal, exempting us from the need of passing additional parameters to the function which would deem it incompatible with the interface expected by the CLI. The CLI also requires the contract method processing the proof (referred to as endpoint) to have the word `verify` as part of it.

Once the Cairo smart contract is ready, it can be deployed in three steps:

*   Declare

    ```bash
    sncast --profile <PROFILE_NAME> declare --contract-name <CAIRO_MOD_NAME>
    ```

    This will declare the smart contract class and return its hash.
*   Deploy

    ```bash
    sncast --profile <PROFILE_NAME> deploy --class-hash <CLASS_HASH>
    ```

    This will deploy the smart contract instance and return its address.
*   Verify (Optional)

    ```bash
    sncast --profile <PROFILE_NAME> verify \
        --network <MAINNET_OR_SEPOLIA> \
        --contract-name <CAIRO_MOD_NAME> \
        --contract-address <CONTRACT_ADDRESS>
    ```

    This will match the deployed code with the smart contract source code and make it available on Starknet block explorers.

Before running any of the commands above, one has to configure foundry to add the desired profile name. That is achieved by editing the `snfoundry.toml` file. Here is a sample configuration as reference

```toml
[sncast.sepolia]
account = "deployer"
accounts-file = "./accounts.json"
url = "https://starknet-sepolia.public.blastapi.io/rpc/v0_7"
```

This requires an `accounts.json` file. One such a way to generate it is using the following command

```bash
sncast account import \
    --name deployer \
    --type <ACCOUNT_TYPE> \
    --address <ACCOUNT_ADDRESS> \
    --private-key <ACCOUNT_PRIVATE_KEY>
```

One can setup an [ArgentX](https://www.argent.xyz/) or [Braavos](https://braavos.app/) wallet, fund it, and export its private key.

### Submitting the proof to the blockchain using the Garaga CLI

Once the smart contract is published on the blockchain network, users can interact with it. In our case, one such interaction would be to perform a computation off-chain with RiscZero and submit it to the smart contract.

As mentioned before, the JSON proof artifact generated by the RiscZero execution can be submitted to the blockchain using Garaga CLI:

```bash
garaga verify-onchain \
  --system risc0_groth16 \
  --network <mainnet_OR_sepolia> \
  --contract-address <CONTRACT_ADDRESS> \
  --endpoint <SMART_CONTRACT_FUNCTION_NAME> \
  --proof <PATH_TO_PROOF_ARTIFACT_JSON>
```

In order to run the Garaga `verify-onchain` command you will need to provide a .`secrets` file in the current folder, or elsewhere using the `--env-file` option. Here is the format for the `.secrets` file

```
SEPOLIA_RPC_URL="https://starknet-sepolia.public.blastapi.io/rpc/v0_7"
SEPOLIA_ACCOUNT_PRIVATE_KEY=
SEPOLIA_ACCOUNT_ADDRESS=

MAINNET_RPC_URL="https://starknet-mainnet.public.blastapi.io/rpc/v0_7"
MAINNET_ACCOUNT_PRIVATE_KEY=
MAINNET_ACCOUNT_ADDRESS=
```

Please make sure to provide RPC endpoints that supports version 0.7 of the Starknet JSON API
