# Using Typescript

Using the `garaga` [npm-package.md](../../../installation/npm-package.md "mention")

## Node.js (with file reading)

```typescript
import * as garaga from 'garaga';
import { CurveId } from 'garaga';
import { readFileSync } from 'fs';

await garaga.init();

// Parse from file paths (Node.js only)
const vk = garaga.parseGroth16VerifyingKeyFromJson('verification_key.json');
const proof = garaga.parseGroth16ProofFromJson('proof.json', 'public.json');

const calldata = garaga.getGroth16CallData(proof, vk, CurveId.BN254);
```

## From JSON objects (Node.js and Browser)

```typescript
import * as garaga from 'garaga';
import { CurveId } from 'garaga';

await garaga.init();

// Parse from already-loaded JSON objects
const vkJson = { /* verification key JSON */ };
const proofJson = { /* proof JSON */ };
const publicInputs = [/* public inputs as bigint[] */];

const vk = garaga.parseGroth16VerifyingKeyFromObject(vkJson);
const proof = garaga.parseGroth16ProofFromObject(proofJson, publicInputs);

const calldata = garaga.getGroth16CallData(proof, vk, CurveId.BN254);
```

{% hint style="info" %}
The `CurveId` should match your verifying key's curve: `CurveId.BN254` or `CurveId.BLS12_381`.
{% endhint %}

## Browser Usage

Use `parseGroth16*FromObject` functions in the browser (no filesystem access):

```typescript
import * as garaga from 'garaga';
import { CurveId } from 'garaga';

async function generateCalldata(vkJson: object, proofJson: object, publicInputs?: bigint[]) {
    await garaga.init();

    const vk = garaga.parseGroth16VerifyingKeyFromObject(vkJson);
    const proof = garaga.parseGroth16ProofFromObject(proofJson, publicInputs);

    return garaga.getGroth16CallData(proof, vk, CurveId.BN254);
}
```
