---
icon: file-lock
---

# Generate and deploy your verifier contract



{% hint style="info" %}
Only Starknet Sepolia is supported. Starknet Mainnet will be supported on version 0.13.2
{% endhint %}

## Prepare your Groth16 verifying key

{% hint style="info" %}
Pairing operations over BLS12-381 are cheaper than BN254 on Garaga, so if possible, prefer using BLS12-381. The security of this curve is also much closer to 128 bits than BN254.&#x20;
{% endhint %}

\
To deploy a groth16 verifier, you need the associated verifying key in `.json` format. Both BN254 and BLS12-381 are supported.&#x20;

[Snarkjs](https://github.com/iden3/snarkjs?tab=readme-ov-file#22-export-the-verification-key) and [Gnark](https://docs.gnark.consensys.io/HowTo/serialize) jsons output are supported out of the box.&#x20;

You can find a bunch of example of verifying keys that will work directly in the [`hydra/garaga/starknet/groth16_contract_generator/examples`](https://github.com/keep-starknet-strange/garaga/tree/main/hydra/garaga/starknet/groth16\_contract\_generator/examples) folder.

While Snarkjs jsons export are easy and working well, the gnark documentation is a bit outdated. Below we show a quick example on how to export the verifying key from your Gnark circuit .



<details>

<summary>Gnark export to json example</summary>

```go
package main

import (
	"encoding/json"
	"os"

	"github.com/consensys/gnark-crypto/ecc"
	"github.com/consensys/gnark/backend/groth16"
	"github.com/consensys/gnark/frontend"
	"github.com/consensys/gnark/frontend/cs/r1cs"
)

// CubicCircuit defines a simple circuit
// x**3 + x + 5 == y
type CubicCircuit struct {
	// struct tags on a variable is optional
	// default uses variable name and secret visibility.
	X frontend.Variable `gnark:"x"`
	Y frontend.Variable `gnark:",public"`
	B frontend.Variable
	A frontend.Variable `gnark:",public"`
}

// Define declares the circuit constraints
// x**3 + x + 5 == y
func (circuit *CubicCircuit) Define(api frontend.API) error {
	x3 := api.Mul(circuit.X, circuit.X, circuit.X)
	api.AssertIsEqual(circuit.Y, api.Add(x3, circuit.X, 5))
	api.AssertIsEqual(circuit.B, circuit.A)
	return nil
}

func main() {
	// compiles our circuit into a R1CS
	var circuit CubicCircuit
	ccs, _ := frontend.Compile(ecc.BN254.ScalarField(), r1cs.NewBuilder, &circuit)

	// groth16 zkSNARK: Setup
	pk, vk, _ := groth16.Setup(ccs)

	// witness definition
	assignment := CubicCircuit{X: 3, Y: 35, A: 3, B: 3}
	witness, _ := frontend.NewWitness(&assignment, ecc.BN254.ScalarField())
	publicWitness, _ := witness.Public()

	// groth16: Prove & Verify
	proof, _ := groth16.Prove(ccs, pk, witness)

	groth16.Verify(proof, vk, publicWitness)
	vk.ExportSolidity(os.Stdout)
	// Export to JSON:
	schema, _ := frontend.NewSchema(&circuit)
	pubWitnessJSON, _ := publicWitness.ToJSON(schema)

	SaveToJSON("gnark_vk_bn254.json", vk)
	SaveToJSON("gnark_proof_bn254.json", proof)
	os.WriteFile("gnark_public_bn254.json", pubWitnessJSON, 0644)

}

func SaveToJSON(filePath string, v interface{}) error {
	jsonData, err := json.MarshalIndent(v, "", "  ")

	if err != nil {
		return err
	}

	err = os.WriteFile(filePath, jsonData, 0644)
	if err != nil {
		return err
	}
	return nil
}

```

</details>

## Generate the Smart contract code

\
Using the [developer-setup.md](../../installation/developer-setup.md "mention") or the [python-package.md](../../installation/python-package.md "mention"), you should now have access to the Garaga CLI from your terminal, using the command `garaga`

```bash
garaga
```

Once your verifying key is ready, you can use the following command :&#x20;

```
garaga gen --system groth16 --vk vk.json
```

You should see an output like this :

```bash
(venv) :~/garaga-flow garaga gen --system groth16 --vk vk_bls.json
Please enter the name of your project. Press enter for default name. [my_project]:
Detected curve: CurveID.BLS12_381
⠧ Generating Smart Contract project for ProofSystem.Groth16 using vk_bls.json...
Done!
Smart Contract project created:
/home/garaga-flow/my_project/
├── Scarb.lock
├── Scarb.toml
├── src/
│   ├── groth16_verifier.cairo
│   ├── groth16_verifier_constants.cairo
│   └── lib.cairo
└── target/
    └── dev/
        ├── groth16_example_bls12_381.starknet_artifacts.json
        ├── groth16_example_bls12_381_Groth16VerifierBLS12_381.compiled_contract
        │   _class.json
        └── groth16_example_bls12_381_Groth16VerifierBLS12_381.contract_class.js
            on
You can now modify the groth16_verifier.cairo file to adapt the verifier to your
use case.

```

The curve identifier is automatically detected from the content of your verifying key.&#x20;

## Build your contract

{% hint style="info" %}
The generated verifier contract does nothing besides verifying a proof! You must extend the template to add all the extra logic needed for your dapp, for example calling an external contract and sending it the public inputs.
{% endhint %}

The generated template is as follow. The main endpoint to call is `verify_groth16_proof_[curve_name]`

If the verification succeeds, it will call the internal function `process_public_inputs.`

This function is the starting point of your dapp logic.&#x20;

{% code title="groth16_verifier.cairo" %}
```rust
use garaga::definitions::E12DMulQuotient;
use garaga::groth16::{Groth16Proof, MPCheckHintBLS12_381};
use super::groth16_verifier_constants::{N_PUBLIC_INPUTS, vk, ic, precomputed_lines};

#[starknet::interface]
trait IGroth16VerifierBLS12_381<TContractState> {
    fn verify_groth16_proof_bls12_381(
        ref self: TContractState,
        groth16_proof: Groth16Proof,
        mpcheck_hint: MPCheckHintBLS12_381,
        small_Q: E12DMulQuotient,
        msm_hint: Array<felt252>,
    ) -> bool;
}

#[starknet::contract]
mod Groth16VerifierBLS12_381 {
    use starknet::SyscallResultTrait;
    use garaga::definitions::{G1Point, G1G2Pair, E12DMulQuotient};
    use garaga::groth16::{
        multi_pairing_check_bls12_381_3P_2F_with_extra_miller_loop_result, Groth16Proof,
        MPCheckHintBLS12_381
    };
    use garaga::ec_ops::{G1PointTrait, G2PointTrait, ec_safe_add};
    use super::{N_PUBLIC_INPUTS, vk, ic, precomputed_lines};

    const ECIP_OPS_CLASS_HASH: felt252 =
        0x29aefd3c293b3d97a9caf77fac5f3c23a6ab8c7e70190ce8d7a12ac71ceac4c;
    use starknet::ContractAddress;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl IGroth16VerifierBLS12_381 of super::IGroth16VerifierBLS12_381<ContractState> {
        fn verify_groth16_proof_bls12_381(
            ref self: ContractState,
            groth16_proof: Groth16Proof,
            mpcheck_hint: MPCheckHintBLS12_381,
            small_Q: E12DMulQuotient,
            msm_hint: Array<felt252>,
        ) -> bool {
            // DO NOT EDIT THIS FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING.
            // ONLY EDIT THE process_public_inputs FUNCTION BELOW.
            groth16_proof.a.assert_on_curve(1);
            groth16_proof.b.assert_on_curve(1);
            groth16_proof.c.assert_on_curve(1);

            let ic = ic.span();

            let vk_x: G1Point = match ic.len() {
                0 => panic!("Malformed VK"),
                1 => *ic.at(0),
                _ => {
                    // Start serialization with the hint array directly to avoid copying it.
                    let mut msm_calldata: Array<felt252> = msm_hint;
                    // Add the points from VK and public inputs to the proof.
                    Serde::serialize(@ic.slice(1, N_PUBLIC_INPUTS), ref msm_calldata);
                    Serde::serialize(@groth16_proof.public_inputs, ref msm_calldata);
                    // Complete with the curve indentifier (1 for BLS12_381):
                    msm_calldata.append(1);

                    // Call the multi scalar multiplication endpoint on the Garaga ECIP ops contract
                    // to obtain vk_x.
                    let mut _vx_x_serialized = core::starknet::syscalls::library_call_syscall(
                        ECIP_OPS_CLASS_HASH.try_into().unwrap(),
                        selector!("msm_g1"),
                        msm_calldata.span()
                    )
                        .unwrap_syscall();

                    ec_safe_add(
                        Serde::<G1Point>::deserialize(ref _vx_x_serialized).unwrap(), *ic.at(0), 1
                    )
                }
            };
            // Perform the pairing check.
            let check = multi_pairing_check_bls12_381_3P_2F_with_extra_miller_loop_result(
                G1G2Pair { p: vk_x, q: vk.gamma_g2 },
                G1G2Pair { p: groth16_proof.c, q: vk.delta_g2 },
                G1G2Pair { p: groth16_proof.a.negate(1), q: groth16_proof.b },
                vk.alpha_beta_miller_loop_result,
                precomputed_lines.span(),
                mpcheck_hint,
                small_Q
            );
            if check == true {
                self
                    .process_public_inputs(
                        starknet::get_caller_address(), groth16_proof.public_inputs
                    );
                return true;
            } else {
                return false;
            }
        }
    }
    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {
        fn process_public_inputs(
            ref self: ContractState, user: ContractAddress, public_inputs: Span<u256>,
        ) { // Process the public inputs with respect to the caller address (user).
        // Update the storage, emit events, call other contracts, etc.
        }
    }
}


```
{% endcode %}

## Declare and deploy your contract

When you are satisfied with your contract it's time to send it to Starknet!

The CLI provides utilities to simplify the process. Otherwise, it is a similar process than for every other contracts, please refer to [Starknet documentation](https://docs.starknet.io/quick-start/declare-a-smart-contract/).\
\
You will to create a file containing the following variables, depending on if you want to declare & deploy on Starknet Sepolia or Starknet Mainnet. \
Create the following file and update its content.&#x20;

{% code title=".secrets" %}
```
SEPOLIA_RPC_URL="https://free-rpc.nethermind.io/sepolia-juno"
SEPOLIA_ACCOUNT_PRIVATE_KEY=0x1
SEPOLIA_ACCOUNT_ADDRESS=0x2

MAINNET_RPC_URL="https://"
MAINNET_ACCOUNT_PRIVATE_KEY=0x3
MAINNET_ACCOUNT_ADDRESS=0x4
```
{% endcode %}

Then, you can run the command `garaga declare`, which will build the contract and declare it to Starknet. If the class hash is already deployed, it will return it as well. Declaring the contract involves sending all its bytecode and it is quite an expensive operation. Make sure you dapp is properly tested before!

```bash
 Usage: garaga declare [OPTIONS]

 Declare your smart contract to Starknet. Obtain its class hash and a explorer link.

╭─ Options ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ --project-path          DIRECTORY          Path to the Cairo project holding the Scarb.toml file to declare                         │
│                                            [default: /home/felt/garaga-flow/my_project/]                            │
│ --env-file              FILE               Path to the environment file                                                             │
│                                            [default: /home/felt/garaga-flow/my_project/.secrets]                    │
│ --network               [sepolia|mainnet]  Starknet network [default: sepolia]                                                      │
│ --fee                   TEXT               Fee token type [eth, strk] [default: eth]                                                │
│ --help          -h                         Show this message and exit.                                                              │
╰─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
```

```bash
garaga declare --project-path my_project/ --env-file .secrets --network sepolia --fee strk
```

This command will return the class hash, used in the next step.\
\
Finally, to deploy the contract, a use `garaga deploy` :

```bash
 Usage: garaga deploy [OPTIONS]

 Deploy an instance of a smart contract class hash to Starknet. Obtain its address, the available endpoints and a explorer link.

╭─ Options ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ *  --class-hash          TEXT               Contract class hash to deploy. Can be decimal or hex string [default: None] [required]  │
│    --env-file            FILE               Path to the environment file containing rpc, address, private_key                       │
│                                             [default: /home/felt/garaga-flow/my_project/.secrets]                   │
│    --network             [sepolia|mainnet]  Starknet network [default: sepolia]                                                     │
│    --fee                 TEXT               Fee token type [eth, strk] [default: strk]                                              │
│    --help        -h                         Show this message and exit.                                                             │
╰─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
```

The contract address will be prompted. Be sure to save it! \
