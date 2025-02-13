---
icon: binary-circle-check
---

# Hashing functions

Garaga support some relevant hashing functions :&#x20;



### Poseidon(x,y) for BN254 scalar field

This hash function is both compatible with [Circom poseidon implementation](https://github.com/iden3/circomlib/blob/252f8130105a66c8ae8b4a23c7f5662e17458f3f/circuits/poseidon.circom#L198-L208) (`nInputs=2`) and [Noir Poseidon hash](https://noir-lang.org/docs/noir/standard_library/cryptographic_primitives/hashes#poseidon) (`std::hash::poseidon::hash::hash_2)`

Below we show Noir and Cairo code computing the same hash (it might not look like it but z are the same here, it's because in cairo the result is splitted in 96 bit limbs)

{% code title="main.nr" %}
```rust
use std::hash::poseidon;

fn main(x: Field, y: pub Field) {
    let x1 = [x, y];
    let z = poseidon::bn254::hash_2(x1);
    assert(z == 7853200120776062878684798364095072458815029376092732009249414926327459813530);
}

#[test]
fn test_main() {
    main(1, 2);

    // Uncomment to make test fail
    // main(1, 1);
}

```
{% endcode %}

{% code title="main.cairo" %}
```rust
use garaga::hashes::poseidon_hash_2_bn254;

fn test_poseidon_bn254() {
    let x: u384 = u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 };
    let y: u384 = u384 { limb0: 2, limb1: 0, limb2: 0, limb3: 0 };
    let z: u384 =
    7853200120776062878684798364095072458815029376092732009249414926327459813530_u256
    .into();

    assert_eq!(poseidon_hash_2_bn254(x, y), z);
}
```
{% endcode %}
