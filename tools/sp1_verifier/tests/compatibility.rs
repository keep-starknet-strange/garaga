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
fn committed_receipt_builds_garaga_calldata() {
    let data = fixture();
    let bytes =
        |key: &str| hex::decode(data[key].as_str().unwrap().trim_start_matches("0x")).unwrap();
    let proof = Groth16Proof::from_sp1(bytes("vkey"), bytes("publicValues"), bytes("proof"));
    assert_eq!(proof.public_inputs.len(), 5);
    get_groth16_calldata(&proof, &get_sp1_vk(), CurveID::BN254).unwrap();
}

#[test]
fn metadata_mutations_are_rejected() {
    let data = fixture();
    let bytes =
        |key: &str| hex::decode(data[key].as_str().unwrap().trim_start_matches("0x")).unwrap();
    for offset in [0, 35, 67, 99] {
        let mut raw = bytes("proof");
        raw[offset] ^= 1;
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
