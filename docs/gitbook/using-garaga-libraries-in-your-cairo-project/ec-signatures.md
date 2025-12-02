---
icon: pen-field
---

# ECDSA, Schnorr & EdDSA Signatures

All three signature schemes follow a similar pattern with a Cairo struct containing the signature data and hints for efficient verification. Garaga provides tooling in Python/Rust/JavaScript to generate the full expected Cairo struct given signature information.

All signature verification schemes work with all [#supported-elliptic-curves](./#supported-elliptic-curves "mention") in Garaga (except EdDSA which is specific to Ed25519), using the corresponding curve identifier.

## Cairo Verification Functions

Verification functions take the public key as a **separate parameter**:
- `is_valid_ecdsa_signature_assuming_hash(signature, public_key, curve_id) -> bool`
- `is_valid_schnorr_signature_assuming_hash(signature, public_key, curve_id) -> bool`
- `is_valid_eddsa_signature(signature, Py_twisted) -> bool`

{% hint style="warning" %}
**Important:** The ECDSA and Schnorr verification functions assume that the message hash has been correctly computed by the caller. They verify the signature equation but do not hash the message themselves.
{% endhint %}

## Public Key Handling

The public key is always passed as a **separate parameter** to the verification function. This allows you to:

1. **Hardcode the public key** in your contract if it's known at compile time
2. **Provide the public key dynamically** at runtime

When generating calldata with the SDK, use the `prepend_public_key` parameter:
- `prepend_public_key=True` (default): The public key is included in the serialized calldata, allowing you to deserialize both the signature and public key from the same array
- `prepend_public_key=False`: Only the signature is serialized; you must provide the public key separately (useful when the public key is hardcoded in your contract)

---

## ECDSA Signature Verification

### Cairo Structs

```rust
use garaga::signatures::ecdsa::{ECDSASignature, ECDSASignatureWithHint, is_valid_ecdsa_signature_assuming_hash};
use garaga::definitions::{G1Point, u384};

/// Core signature data
struct ECDSASignature {
    rx: u384,   // r component (R.x mod n)
    s: u256,    // s component
    v: bool,    // Parity of R.y (false if even, true if odd)
    z: u256,    // Message hash (assumed correctly computed by caller)
}

/// Signature bundled with verification hints
struct ECDSASignatureWithHint {
    signature: ECDSASignature,
    msm_hint: Span<felt252>,
}
```

### Usage Example

```rust
use garaga::signatures::ecdsa::{ECDSASignatureWithHint, is_valid_ecdsa_signature_assuming_hash};
use garaga::definitions::{G1Point, u384};

fn verify_ecdsa_signature(
    serialized_signature: Span<felt252>,
    public_key: G1Point,
    curve_id: usize,
) -> bool {
    // Deserialize the signature with hints
    let mut data = serialized_signature;
    let signature_with_hints = Serde::<ECDSASignatureWithHint>::deserialize(ref data).unwrap();

    // Verify the signature
    // curve_id: 0=BN254, 1=BLS12_381, 2=SECP256K1, 3=SECP256R1, 5=GRUMPKIN
    is_valid_ecdsa_signature_assuming_hash(signature_with_hints, public_key, curve_id)
}
```

### Calldata Generation

{% tabs %}
{% tab title="Python" %}
```python
from garaga.starknet.tests_and_calldata_generators.signatures import ECDSASignature
from garaga.definitions import CurveID

# Create signature object with all required fields
sig = ECDSASignature(
    r=0x...,              # r component of signature
    s=0x...,              # s component of signature
    v=0,                  # 0 if R.y is even, 1 if odd
    px=0x...,             # Public key x-coordinate
    py=0x...,             # Public key y-coordinate
    z=0x...,              # Message hash
    curve_id=CurveID.SECP256K1
)

# Generate calldata with public key included (for dynamic public key)
calldata = sig.serialize_with_hints(prepend_public_key=True)

# Generate calldata without public key (for hardcoded public key in contract)
calldata_no_pk = sig.serialize_with_hints(prepend_public_key=False)
```
{% endtab %}

{% tab title="Rust" %}
```rust
use garaga_rs::calldata::signatures::ecdsa_calldata_builder;
use garaga_rs::definitions::CurveID;

// Generate calldata with public key included
let calldata = ecdsa_calldata_builder(
    r,              // r component
    s,              // s component
    v,              // recovery parameter (0 or 1)
    px,             // public key x
    py,             // public key y
    z,              // message hash
    true,           // prepend_public_key
    CurveID::SECP256K1 as usize,
)?;

// Generate calldata without public key (for hardcoded public key)
let calldata_no_pk = ecdsa_calldata_builder(r, s, v, px, py, z, false, CurveID::SECP256K1 as usize)?;
```
{% endtab %}

{% tab title="TypeScript" %}
```typescript
import { ecdsaCalldataBuilder, CurveId } from 'garaga';

// Generate calldata with public key included
const calldata = ecdsaCalldataBuilder(
    r,              // r component (bigint)
    s,              // s component (bigint)
    v,              // recovery parameter (0 or 1)
    px,             // public key x (bigint)
    py,             // public key y (bigint)
    z,              // message hash (bigint)
    true,           // prependPublickey
    CurveId.SECP256K1
);

// Generate calldata without public key (for hardcoded public key)
const calldataNoKey = ecdsaCalldataBuilder(r, s, v, px, py, z, false, CurveId.SECP256K1);
```
{% endtab %}
{% endtabs %}

---

## Schnorr Signature Verification

### Cairo Structs

```rust
use garaga::signatures::schnorr::{SchnorrSignature, SchnorrSignatureWithHint, is_valid_schnorr_signature_assuming_hash};
use garaga::definitions::{G1Point, u384};

/// Core signature data
struct SchnorrSignature {
    rx: u384,   // x-coordinate of R point
    s: u256,    // s component
    e: u256,    // Challenge hash (assumed correctly computed by caller)
}

/// Signature bundled with verification hints
struct SchnorrSignatureWithHint {
    signature: SchnorrSignature,
    msm_hint: Span<felt252>,
}
```

{% hint style="info" %}
**BIP340 Requirement:** The public key's y-coordinate must be even. The verification function will return `false` if the public key has an odd y-coordinate.
{% endhint %}

### Usage Example

```rust
use garaga::signatures::schnorr::{SchnorrSignatureWithHint, is_valid_schnorr_signature_assuming_hash};
use garaga::definitions::{G1Point, u384};

fn verify_schnorr_signature(
    serialized_signature: Span<felt252>,
    public_key: G1Point,
    curve_id: usize,
) -> bool {
    // Deserialize the signature with hints
    let mut data = serialized_signature;
    let signature_with_hints = Serde::<SchnorrSignatureWithHint>::deserialize(ref data).unwrap();

    // Verify the signature
    // Note: public_key.y must be even (BIP340 requirement)
    is_valid_schnorr_signature_assuming_hash(signature_with_hints, public_key, curve_id)
}
```

### Calldata Generation

{% tabs %}
{% tab title="Python" %}
```python
from garaga.starknet.tests_and_calldata_generators.signatures import SchnorrSignature
from garaga.definitions import CurveID

# Create signature object (py must be even)
sig = SchnorrSignature(
    rx=0x...,             # x-coordinate of R point
    s=0x...,              # s component
    e=0x...,              # Challenge hash
    px=0x...,             # Public key x-coordinate
    py=0x...,             # Public key y-coordinate (must be even!)
    curve_id=CurveID.BN254
)

# Generate calldata with public key included
calldata = sig.serialize_with_hints(prepend_public_key=True)

# Generate calldata without public key (for hardcoded public key)
calldata_no_pk = sig.serialize_with_hints(prepend_public_key=False)
```
{% endtab %}

{% tab title="Rust" %}
```rust
use garaga_rs::calldata::signatures::schnorr_calldata_builder;
use garaga_rs::definitions::CurveID;

// Generate calldata with public key included
let calldata = schnorr_calldata_builder(
    rx,             // R.x coordinate
    s,              // s component
    e,              // challenge hash
    px,             // public key x
    py,             // public key y (must be even!)
    true,           // prepend_public_key
    CurveID::BN254 as usize,
)?;

// Generate calldata without public key
let calldata_no_pk = schnorr_calldata_builder(rx, s, e, px, py, false, CurveID::BN254 as usize)?;
```
{% endtab %}

{% tab title="TypeScript" %}
```typescript
import { schnorrCalldataBuilder, CurveId } from 'garaga';

// Generate calldata with public key included
const calldata = schnorrCalldataBuilder(
    rx,             // R.x coordinate (bigint)
    s,              // s component (bigint)
    e,              // challenge hash (bigint)
    px,             // public key x (bigint)
    py,             // public key y (bigint, must be even!)
    true,           // prependPublickey
    CurveId.BN254
);

// Generate calldata without public key
const calldataNoKey = schnorrCalldataBuilder(rx, s, e, px, py, false, CurveId.BN254);
```
{% endtab %}
{% endtabs %}

---

## EdDSA Signature Verification (Ed25519)

EdDSA signatures use the Ed25519 curve following RFC 8032. The implementation explicitly rejects small-order points to prevent key-compromise and signature-malleability attacks.

### Cairo Structs

```rust
use garaga::signatures::eddsa_25519::{EdDSASignature, EdDSASignatureWithHint, is_valid_eddsa_signature};

/// Core signature data
struct EdDSASignature {
    Ry_twisted: u256,    // Compressed R point y-coordinate (little-endian)
    s: u256,             // Signature scalar
    msg: Span<u8>,       // Original message bytes
}

/// Signature bundled with verification hints
struct EdDSASignatureWithHint {
    signature: EdDSASignature,
    msm_hint: Span<felt252>,
    sqrt_Rx_hint: u256,  // Hint for R point decompression
    sqrt_Px_hint: u256,  // Hint for public key decompression
}
```

{% hint style="info" %}
**Note:** EdDSA takes the raw message bytes, not a hash. The verification function computes `SHA-512(R || A || msg)` internally as per RFC 8032.
{% endhint %}

### Usage Example

```rust
use garaga::signatures::eddsa_25519::{EdDSASignatureWithHint, is_valid_eddsa_signature};

fn verify_eddsa_signature(
    serialized_signature: Span<felt252>,
    Py_twisted: u256,  // Compressed public key y-coordinate (little-endian)
) -> bool {
    // Deserialize the signature with hints
    let mut data = serialized_signature;
    let signature_with_hints = Serde::<EdDSASignatureWithHint>::deserialize(ref data).unwrap();

    // Verify the signature
    is_valid_eddsa_signature(signature_with_hints, Py_twisted)
}
```

### Calldata Generation

{% tabs %}
{% tab title="Python" %}
```python
from garaga.starknet.tests_and_calldata_generators.signatures import EdDSA25519Signature

# Create signature object
sig = EdDSA25519Signature(
    Ry_twisted=0x...,     # Compressed R point (little-endian integer)
    s=0x...,              # Signature scalar
    Py_twisted=0x...,     # Compressed public key (little-endian integer)
    msg=b"Hello, World!"  # Raw message bytes
)

# Generate calldata with public key included
calldata = sig.serialize_with_hints(prepend_public_key=True)

# Generate calldata without public key (for hardcoded public key)
calldata_no_pk = sig.serialize_with_hints(prepend_public_key=False)
```
{% endtab %}

{% tab title="Rust" %}
```rust
use garaga_rs::calldata::signatures::eddsa_calldata_builder;

let message = b"Hello, World!".to_vec();

// Generate calldata with public key included
let calldata = eddsa_calldata_builder(
    ry_twisted,     // Compressed R point y-coordinate
    s,              // Signature scalar
    py_twisted,     // Compressed public key y-coordinate
    message.clone(),
    true,           // prepend_public_key
)?;

// Generate calldata without public key
let calldata_no_pk = eddsa_calldata_builder(ry_twisted, s, py_twisted, message, false)?;
```
{% endtab %}

{% tab title="TypeScript" %}
```typescript
import { eddsaCalldataBuilder } from 'garaga';

const message = new TextEncoder().encode("Hello, World!");

// Generate calldata with public key included
const calldata = eddsaCalldataBuilder(
    ry_twisted_le,  // Compressed R point (bigint, little-endian)
    s,              // Signature scalar (bigint)
    py_twisted_le,  // Compressed public key (bigint, little-endian)
    message,        // Uint8Array
    true            // prependPublickey
);

// Generate calldata without public key
const calldataNoKey = eddsaCalldataBuilder(ry_twisted_le, s, py_twisted_le, message, false);
```
{% endtab %}
{% endtabs %}

---

## Curve Identifiers

| Curve ID | Value | Notes |
|----------|-------|-------|
| BN254 | 0 | - |
| BLS12_381 | 1 | - |
| SECP256K1 | 2 | Bitcoin/Ethereum |
| SECP256R1 | 3 | P-256/NIST |
| ED25519 | 4 | Only for EdDSA |
| GRUMPKIN | 5 | - |
