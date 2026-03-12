---
icon: key
---

# RSA-2048 Signature Verification

Garaga provides on-chain RSA-2048 signature verification using multi-channel Residue Number System (RNS) arithmetic. The verifier checks that `s^{65537} ≡ m (mod n)` without native 2048-bit arithmetic by decomposing the exponentiation into 17 certified modular reductions verified through 11 independent RNS channels.

{% hint style="warning" %}
**Important:** The verification function `is_valid_rsa2048_signature_assuming_encoded_message` assumes the expected message `m` is already in its final encoded form (e.g., PKCS#1 v1.5 padded). The caller is responsible for constructing `m` from the message hash. A helper `pkcs1_v1_5_encode_sha256` is provided in the Python SDK.
{% endhint %}

## How It Works

1. **RNS representation**: 2048-bit integers are decomposed into 6 chunks of 384 bits (top chunk: 128 bits), then evaluated modulo 11 pairwise coprime ~384-bit primes.
2. **Square-and-multiply**: For `e = 65537 = 2^16 + 1`, the chain consists of 16 squarings + 1 final multiplication = 17 reductions.
3. **CRT exactness**: Each reduction `a·b = q·n + r` is checked in all 11 RNS channels. Since the product of the channel primes exceeds the maximum deviation, channel congruences imply integer equality.

## Cairo Structs

```rust
use garaga::signatures::rsa::{
    RSA2048PublicKey,
    RSA2048SignatureWithHint,
    is_valid_rsa2048_signature_assuming_encoded_message,
};
use garaga::definitions::{RSA2048Chunks, RSA2048ReductionWitness};

/// RSA-2048 public key (the modulus n)
struct RSA2048PublicKey {
    modulus: RSA2048Chunks,  // 6 chunks × 4 × u96 = 24 felt252
}

/// Core signature data
struct RSA2048Signature {
    signature: RSA2048Chunks,          // s: the RSA signature
    expected_message: RSA2048Chunks,   // m: the expected encoded message
}

/// Signature bundled with 17 reduction witnesses
struct RSA2048SignatureWithHint {
    signature: RSA2048Signature,
    reductions_hint: Span<felt252>,  // 17 × (quotient + remainder) = 17 × 48 = 816 felt252
}
```

## Usage Example

```rust
use garaga::signatures::rsa::{
    RSA2048PublicKey,
    RSA2048SignatureWithHint,
    is_valid_rsa2048_signature_assuming_encoded_message,
};

fn verify_rsa_signature(
    serialized: Span<felt252>,
    public_key: RSA2048PublicKey,
) -> bool {
    let mut data = serialized;
    let sig = Serde::<RSA2048SignatureWithHint>::deserialize(ref data).unwrap();
    is_valid_rsa2048_signature_assuming_encoded_message(@sig, @public_key)
}
```

## Calldata Generation

{% tabs %}
{% tab title="Python" %}
```python
from garaga.starknet.tests_and_calldata_generators.signatures import RSA2048Signature
from garaga.rsa_rns import generate_rsa2048_witness, generate_rsa2048_sha256_witness

# From pre-computed witness (raw expected_message)
bundle = generate_rsa2048_witness(seed=0)
sig = RSA2048Signature.from_bundle(bundle)

# From SHA-256 message digest (PKCS#1 v1.5 encoded)
bundle = generate_rsa2048_sha256_witness(b"hello", seed=0)
sig = RSA2048Signature.from_bundle(bundle)

# Generate calldata (Python path)
calldata = sig.serialize_with_hints(prepend_public_key=True)

# Generate calldata (Rust path, byte-for-byte identical)
calldata = sig.serialize_with_hints(use_rust=True, prepend_public_key=True)

# Without public key (when modulus is hardcoded in contract)
calldata_no_pk = sig.serialize_with_hints(prepend_public_key=False)
```
{% endtab %}

{% tab title="Rust" %}
```rust
use garaga_rs::calldata::signatures::rsa_2048_calldata_builder;

// signature, expected_message, modulus are BigUint values
let calldata = rsa_2048_calldata_builder(
    signature,          // s value
    expected_message,   // m = s^65537 mod n (PKCS#1 v1.5 encoded)
    modulus,            // RSA-2048 modulus n
    true,               // prepend_public_key
)?;
```
{% endtab %}

{% tab title="TypeScript" %}
```typescript
import { rsa2048CalldataBuilder } from 'garaga';

const calldata = rsa2048CalldataBuilder(
    signature,        // RSA signature (bigint)
    expectedMessage,  // PKCS#1 v1.5 encoded message (bigint)
    modulus,          // RSA-2048 modulus (bigint)
    true              // prependPublicKey
);
```
{% endtab %}
{% endtabs %}

## Calldata Layout

| Section | Elements | Description |
|---------|----------|-------------|
| Public key (optional) | 24 | Modulus `n` as 6 chunks × 4 words |
| Signature | 24 | `s` as 6 chunks × 4 words |
| Expected message | 24 | `m` as 6 chunks × 4 words |
| Reduction witnesses | 816 | 17 × (quotient 24 + remainder 24) |
| **Total** | **888** (with key) / **864** (without) | |

## Full SHA-256 Verification

For end-to-end verification where the raw message is provided and SHA-256 + PKCS#1 v1.5 encoding is computed on-chain, use `is_valid_rsa2048_sha256_signature`:

```rust
use garaga::signatures::rsa::{
    RSA2048PublicKey,
    RSA2048SignatureWithHint,
    is_valid_rsa2048_sha256_signature,
};

fn verify_rsa_sha256(
    serialized: Span<felt252>,
    public_key: RSA2048PublicKey,
) -> bool {
    let mut data = serialized;
    let sig = Serde::<RSA2048SignatureWithHint>::deserialize(ref data).unwrap();
    let message = Serde::<ByteArray>::deserialize(ref data).unwrap();
    is_valid_rsa2048_sha256_signature(@sig, @public_key, @message)
}
```

This function:
1. Computes `SHA-256(message)` on-chain
2. Constructs the PKCS#1 v1.5 encoded message
3. Asserts it matches the `expected_message` hint
4. Verifies `s^{65537} ≡ m (mod n)` via RNS arithmetic

### SHA-256 Calldata Generation

{% tabs %}
{% tab title="Python" %}
```python
from garaga.starknet.tests_and_calldata_generators.signatures import RSA2048Signature

# Create signature from raw message
sig = RSA2048Signature.from_sha256_message(b"hello garaga", seed=0)

# Generate calldata (Python path)
calldata = sig.serialize_sha256_with_hints(
    message=b"hello garaga", prepend_public_key=True
)

# Generate calldata (Rust path, byte-for-byte identical)
calldata = sig.serialize_sha256_with_hints(
    message=b"hello garaga", use_rust=True, prepend_public_key=True
)
```
{% endtab %}

{% tab title="Rust" %}
```rust
use garaga_rs::calldata::signatures::rsa_2048_sha256_calldata_builder;

let calldata = rsa_2048_sha256_calldata_builder(
    signature,  // RSA signature s
    b"hello",   // raw message bytes
    modulus,    // RSA-2048 modulus n
    true,       // prepend_public_key
)?;
```
{% endtab %}

{% tab title="TypeScript" %}
```typescript
import { rsa2048Sha256CalldataBuilder } from 'garaga';

const message = new TextEncoder().encode("hello garaga");
const calldata = rsa2048Sha256CalldataBuilder(
    signature,  // RSA signature (bigint)
    message,    // raw message (Uint8Array)
    modulus,    // RSA-2048 modulus (bigint)
    true        // prependPublicKey
);
```
{% endtab %}
{% endtabs %}

### SHA-256 Calldata Layout

| Section | Elements | Description |
|---------|----------|-------------|
| Public key (optional) | 24 | Modulus `n` as 6 chunks × 4 words |
| Signature | 24 | `s` as 6 chunks × 4 words |
| Expected message | 24 | `m` (PKCS#1 v1.5 encoded) as 6 chunks × 4 words |
| Reduction witnesses | 816 | 17 × (quotient 24 + remainder 24) |
| ByteArray message | variable | Cairo ByteArray serde format |
| **Total** | **888 + ByteArray** (with key) | |

## PKCS#1 v1.5 Encoding

For standard RSA signature verification with SHA-256, the expected message must be PKCS#1 v1.5 encoded (RFC 8017, Section 9.2):

```
0x00 || 0x01 || PS(0xFF × 202) || 0x00 || DigestInfo(19 bytes) || SHA-256(msg)(32 bytes)
```

The Python SDK provides `pkcs1_v1_5_encode_sha256`:

```python
from garaga.rsa_rns import pkcs1_v1_5_encode_sha256
import hashlib

message_hash = hashlib.sha256(b"hello").digest()
encoded_message = pkcs1_v1_5_encode_sha256(message_hash)
# encoded_message is a 2048-bit integer ready for RSA verification
```

## Performance

RSA-2048 verification costs approximately **~11.8M Sierra gas** (L2 gas) on Starknet. For comparison:

| Scheme | Sierra Gas |
|--------|-----------|
| ECDSA (SECP256R1) | ~4.5M |
| Schnorr (SECP256K1) | ~4.2M |
| EdDSA (Ed25519, short msg) | ~9.8M |
| **RSA-2048** | **~11.8M** |
