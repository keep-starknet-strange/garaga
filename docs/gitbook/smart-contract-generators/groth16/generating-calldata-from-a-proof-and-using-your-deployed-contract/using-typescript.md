# Using Typescript

Using the `garaga` [npm-package.md](../../../installation/npm-package.md "mention")

```typescript
// Ensure you use the same garaga npm version as the pip package that generated the verifier.
import * as garaga from 'garaga';
import { CurveId } from 'garaga';
import { readFileSync } from 'fs';

// 1. Initialize the WASM module (required before using any garaga functions)
await garaga.init();

// 2. Load your verification key and proof JSON files
const vkJson = JSON.parse(readFileSync('verification_key.json', 'utf-8'));
const proofJson = JSON.parse(readFileSync('proof.json', 'utf-8'));
const publicInputsJson = JSON.parse(readFileSync('public.json', 'utf-8'));

// 3. Parse the verification key and proof
const vk: garaga.Groth16VerifyingKey = garaga.parseGroth16VerifyingKeyFromJson(vkJson);
const proof: garaga.Groth16Proof = garaga.parseGroth16ProofFromJson(proofJson, publicInputsJson);

// 4. Generate calldata for Groth16 proof verification
const calldata: bigint[] = garaga.getGroth16CallData(proof, vk, CurveId.BN254);

console.log('Calldata length:', calldata.length);

// The calldata can now be used to call your deployed verifier contract
```

{% hint style="info" %}
The `CurveId` should match your verifying key's curve: `CurveId.BN254` or `CurveId.BLS12_381`.
{% endhint %}

## Browser Usage

The same code works in the browser. Make sure to call `garaga.init()` before using any functions:

```typescript
import * as garaga from 'garaga';
import { CurveId } from 'garaga';

async function verifyProof(vkJson: any, proofJson: any, publicInputsJson: any) {
    // Initialize WASM module
    await garaga.init();

    // Parse and generate calldata
    const vk = garaga.parseGroth16VerifyingKeyFromJson(vkJson);
    const proof = garaga.parseGroth16ProofFromJson(proofJson, publicInputsJson);
    const calldata = garaga.getGroth16CallData(proof, vk, CurveId.BN254);

    return calldata;
}
```

See the [npm package documentation](https://github.com/keep-starknet-strange/garaga/tree/main/tools/npm/garaga_ts) for more details.
