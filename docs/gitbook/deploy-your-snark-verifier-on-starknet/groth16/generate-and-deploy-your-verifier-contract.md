---
icon: file-lock
---

# Generate and deploy your verifier contract



{% hint style="info" %}
Note : This process will be streamlined and easier in the near future
{% endhint %}

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

You can find a bunch of example of verifying keys that will work directly in the [`hydra/garaga/starknet/groth16_contract_generator/examples`](https://github.com/keep-starknet-strange/garaga/tree/main/hydra/garaga/starknet/groth16\_contract\_generator/examples) folder

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
Make sure as always to activate the virtual environment created after setting up.&#x20;

```
source venv/bin/activate
```

Once your verifying key is ready, you will need to edit the `__main__` part of the [`hydra/garaga/starknet/groth16_contract_generator/generator.py`](https://github.com/keep-starknet-strange/garaga/blob/main/hydra/garaga/starknet/groth16\_contract\_generator/generator.py) file. \
\
By default, it looks as following :&#x20;

```python
if __name__ == "__main__":

    BN_VK_PATH = "hydra/garaga/starknet/groth16_contract_generator/examples/vk_bn254.json"
    BLS_VK_PATH = "hydra/garaga/starknet/groth16_contract_generator/examples/vk_bls.json"

    CONTRACTS_FOLDER = "src/cairo/contracts/"  # Do not change this

    FOLDER_NAME = "groth16_example"  # '_curve_id' is appended in the end.

    gen_groth16_verifier(
        BN_VK_PATH, CONTRACTS_FOLDER, FOLDER_NAME, ECIP_OPS_CLASS_HASH.SEPOLIA
    )
    gen_groth16_verifier(
        BLS_VK_PATH, CONTRACTS_FOLDER, FOLDER_NAME, ECIP_OPS_CLASS_HASH.SEPOLIA
    )
```

\
As you can see, two verifying keys are provided as example, and the associated contracts are already available in [`src/cairo/contracts` ](https://github.com/keep-starknet-strange/garaga/tree/main/src/cairo/contracts)



Assuming your verifying key is located in `hydra/garaga/starknet/groth16_contract_generator/examples/my_vk.json`

&#x20;You will need to update the file as follow:&#x20;

```python
if __name__ == "__main__":

    MY_VK_PATH = "hydra/garaga/starknet/groth16_contract_generator/examples/my_vk.json"

    CONTRACTS_FOLDER = "src/cairo/contracts/"  # Do not change this

    FOLDER_NAME = "my_groth16_verfier"  # '_curve_id' is appended in the end.

    gen_groth16_verifier(
        MY_VK_PATH, CONTRACTS_FOLDER, FOLDER_NAME, ECIP_OPS_CLASS_HASH.SEPOLIA
    )
```

Finally, simply run the script from the root of the repository :

```bash
python tools/starknet/groth16_contract_generator/generator.py
```

{% hint style="info" %}
Make sure to activate the virtual environment created at setup, using `source/venv/activate`
{% endhint %}

You contract will be located under `src/cairo/contracts`

## Build your contract

Navigate into `src/cairo/contracts/my_groth16_verifier_[curve_id_name]`

Assuming the curve identifier in the verifying key was '`bn254`':

```bash
cd src/cairo/contracts/my_groth16_verifier_bn254
```

{% hint style="info" %}
The generated verifier contract does nothing besides verifying a proof! Feel free to use the template to add all the extra logic needed, for example calling an external contract and sending it the public inputs (AFTER the verification succeeds  ;))
{% endhint %}



When you are satisfied with your contract, simply run :&#x20;

```bash
scarb build
```



The `target/dev` folder will be created and two important files will be generated by scarb :&#x20;

* `src/cairo/contracts/my_groth16_verifier/target/dev/my_groth16_verifier_bn254_Groth16VerifierBN254.compiled_contract_class.json`
* `src/cairo/contracts/groth16_example_bn254/target/dev/groth16_example_bn254_Groth16VerifierBN254.contract_class.json`



At this point the usual Starknet DECLARE then DEPLOY workflow is required. \
For more information, refer to [Starknet documentation](https://docs.starknet.io/quick-start/declare-a-smart-contract/)

\
