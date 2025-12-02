---
icon: binary-circle-check
---

# Hashing functions

Garaga provides implementations of common hash functions optimized for Cairo.

***

## SHA-512

A pure Cairo implementation of SHA-512 following [RFC-6234](https://datatracker.ietf.org/doc/html/rfc6234). This is used internally for EdDSA signature verification but is also available for general use.

### Usage

```rust
use garaga::hashes::sha_512::sha512;

fn hash_message() {
    // Hash a single byte
    let input: Array<u8> = array![49]; // ASCII '1'
    let hash: Array<u8> = sha512(input);

    // hash is a 64-byte (512-bit) array
    assert!(hash.len() == 64);
}

fn hash_empty() {
    // Hash empty input
    let empty: Array<u8> = array![];
    let hash = sha512(empty);

    // SHA-512 of empty string
    assert!(
        hash.span() == array![
            0xcf, 0x83, 0xe1, 0x35, 0x7e, 0xef, 0xb8, 0xbd,
            0xf1, 0x54, 0x28, 0x50, 0xd6, 0x6d, 0x80, 0x07,
            0xd6, 0x20, 0xe4, 0x05, 0x0b, 0x57, 0x15, 0xdc,
            0x83, 0xf4, 0xa9, 0x21, 0xd3, 0x6c, 0xe9, 0xce,
            0x47, 0xd0, 0xd1, 0x3c, 0x5d, 0x85, 0xf2, 0xb0,
            0xff, 0x83, 0x18, 0xd2, 0x87, 0x7e, 0xec, 0x2f,
            0x63, 0xb9, 0x31, 0xbd, 0x47, 0x41, 0x7a, 0x81,
            0xa5, 0x38, 0x32, 0x7a, 0xf9, 0x27, 0xda, 0x3e,
        ].span()
    );
}

fn hash_text() {
    // Hash arbitrary text
    let msg: Array<u8> = array![
        0x4C, 0x6F, 0x72, 0x65, 0x6D, 0x20, 0x69, 0x70,
        0x73, 0x75, 0x6D  // "Lorem ipsum"
    ];
    let hash = sha512(msg);
    // Returns 64-byte hash
}
```

### Function Signature

```rust
pub fn sha512(data: Array<u8>) -> Array<u8>
```

* **Input**: `Array<u8>` - The message bytes to hash
* **Output**: `Array<u8>` - 64-byte (512-bit) hash result

***

## Poseidon (BN254 Scalar Field)

A ZK-friendly hash function operating on the BN254 scalar field. This implementation is compatible with:

* [Circom Poseidon](https://github.com/iden3/circomlib/blob/252f8130105a66c8ae8b4a23c7f5662e17458f3f/circuits/poseidon.circom#L198-L208) (`nInputs=2`)
* [Noir Poseidon](https://noir-lang.org/docs/noir/standard_library/cryptographic_primitives/hashes#poseidon) (`std::hash::poseidon::hash::hash_2`)

### Cross-Language Example

The same hash computed in Noir and Cairo:

{% tabs %}
{% tab title="Noir" %}
```rust
// For nargo < 1.0.0-beta.4:
use std::hash::poseidon::bn254::hash_2;

// For nargo >= 1.0.0-beta.4: (poseidon has been moved to a separate package)
// Add to Nargo.toml:
// [dependencies]
// poseidon = { tag = "v0.1.1", git = "https://github.com/noir-lang/poseidon" }
use poseidon::poseidon::bn254::hash_2;

fn main(x: Field, y: pub Field) {
    let x1 = [x, y];
    let z = hash_2(x1);
    assert(z == 7853200120776062878684798364095072458815029376092732009249414926327459813530);
}

#[test]
fn test_main() {
    main(1, 2);
}
```
{% endtab %}

{% tab title="Cairo" %}
```rust
use garaga::hashes::poseidon_hash_2_bn254;
use garaga::definitions::u384;

fn test_poseidon_bn254() {
    let x: u384 = u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 };
    let y: u384 = u384 { limb0: 2, limb1: 0, limb2: 0, limb3: 0 };
    let expected: u384 =
        7853200120776062878684798364095072458815029376092732009249414926327459813530_u256
        .into();

    assert_eq!(poseidon_hash_2_bn254(x, y), expected);
}
```
{% endtab %}
{% endtabs %}

### Function Signature

```rust
pub fn poseidon_hash_2_bn254(x: u384, y: u384) -> u384
```

* **Input**: Two `u384` field elements
* **Output**: `u384` - The Poseidon hash result

{% hint style="info" %}
This hash function is particularly useful when building circuits in Noir that need to verify hashes computed on Starknet, or vice versa.
{% endhint %}
