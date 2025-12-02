# Using Rust

Add the [rust-crate.md](../../../installation/rust-crate.md "mention") to your project.

```rust
// Version must match the pip package that generated the verifier
use garaga_rs::calldata::full_proof_with_hints::groth16::{
    get_groth16_calldata, Groth16Proof, Groth16VerifyingKey,
};
use garaga_rs::definitions::CurveID;
use std::fs;

fn main() -> Result<(), String> {
    // 1. Load and parse verification key from JSON
    let vk_json = fs::read_to_string("verification_key.json").map_err(|e| e.to_string())?;
    let vk = Groth16VerifyingKey::from_json(&vk_json)?;

    // 2. Load and parse proof from JSON
    let proof_json = fs::read_to_string("proof.json").map_err(|e| e.to_string())?;
    let public_inputs_json = fs::read_to_string("public.json").map_err(|e| e.to_string())?;
    let proof = Groth16Proof::from_json(&proof_json, &public_inputs_json)?;

    // 3. Generate calldata (curve is auto-detected from vk)
    let calldata = get_groth16_calldata(&proof, &vk, CurveID::BN254)?;

    println!("Calldata length: {}", calldata.len());

    // The calldata can now be used to call your deployed verifier contract
    Ok(())
}
```

{% hint style="info" %}
The `CurveID` should match your verifying key's curve: `CurveID::BN254` or `CurveID::BLS12_381`.
{% endhint %}

## Alternative: Using JSON files directly

If your proof and public inputs are in separate Snarkjs-style JSON files:

```rust
use garaga_rs::calldata::full_proof_with_hints::groth16::{
    get_groth16_calldata, Groth16Proof, Groth16VerifyingKey,
};
use garaga_rs::definitions::CurveID;

// Parse verification key
let vk = Groth16VerifyingKey::from_json(&vk_json_string)?;

// Parse proof with separate public inputs
let proof = Groth16Proof::from_json(&proof_json_string, &public_inputs_json_string)?;

// Generate calldata
let calldata = get_groth16_calldata(&proof, &vk, CurveID::BN254)?;
```

See the [Rust crate documentation](https://github.com/keep-starknet-strange/garaga/tree/main/tools/garaga_rs) for more details.
