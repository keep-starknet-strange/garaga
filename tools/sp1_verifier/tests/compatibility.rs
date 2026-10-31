#![cfg(not(target_arch = "wasm32"))]

use garaga_rs::calldata::full_proof_with_hints::groth16::{
    get_groth16_calldata, get_sp1_vk, Groth16Proof,
};
use garaga_rs::definitions::CurveID;

fn fixture() -> serde_json::Value {
    serde_json::from_str(include_str!(
        "../../../hydra/garaga/starknet/groth16_contract_generator/examples/proof_sp1.json"
    ))
    .unwrap()
}

#[test]
fn committed_receipt_verifies_with_the_current_sdk_and_garaga() {
    let data = fixture();
    let bytes =
        |key: &str| hex::decode(data[key].as_str().unwrap().trim_start_matches("0x")).unwrap();
    sp1_verifier::Groth16Verifier::verify(
        &bytes("proof"),
        &bytes("publicValues"),
        data["vkey"].as_str().unwrap(),
        &sp1_verifier::GROTH16_VK_BYTES,
    )
    .unwrap();
    let proof = Groth16Proof::from_sp1(bytes("vkey"), bytes("publicValues"), bytes("proof"));
    assert_eq!(proof.public_inputs.len(), 5);
    get_groth16_calldata(&proof, &get_sp1_vk(), CurveID::BN254).unwrap();
}

#[test]
fn sdk_parameters_match_the_generated_defaults() {
    use garaga_rs::constants::{SP1_VERIFIER_HASH, SP1_VK_ROOT};
    use sha2::{Digest, Sha256};
    assert_eq!(
        hex::encode(Sha256::digest(*sp1_verifier::GROTH16_VK_BYTES)),
        &SP1_VERIFIER_HASH[2..]
    );
    assert_eq!(SP1_VK_ROOT, *sp1_verifier::VK_ROOT_BYTES);
}

#[test]
fn metadata_mutations_are_rejected() {
    let data = fixture();
    let bytes =
        |key: &str| hex::decode(data[key].as_str().unwrap().trim_start_matches("0x")).unwrap();
    for offset in [0, 35, 67, 99] {
        let mut raw = bytes("proof");
        raw[offset] ^= 1;
        assert!(sp1_verifier::Groth16Verifier::verify(
            &raw,
            &bytes("publicValues"),
            data["vkey"].as_str().unwrap(),
            &sp1_verifier::GROTH16_VK_BYTES
        )
        .is_err());
        let result = std::panic::catch_unwind(|| {
            let proof = Groth16Proof::from_sp1(bytes("vkey"), bytes("publicValues"), raw);
            get_groth16_calldata(&proof, &get_sp1_vk(), CurveID::BN254)
        });
        assert!(matches!(result, Err(_) | Ok(Err(_))));
    }
    for length in [0, 3, 260, 355, 357] {
        let raw = vec![0; length];
        assert!(std::panic::catch_unwind(|| Groth16Proof::from_sp1(
            bytes("vkey"),
            bytes("publicValues"),
            raw
        ))
        .is_err());
    }
}
