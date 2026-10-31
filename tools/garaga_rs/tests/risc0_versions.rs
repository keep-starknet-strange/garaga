// Receipt data: Copyright 2025 RISC Zero, Inc. SPDX-License-Identifier: Apache-2.0
// https://github.com/risc0/risc0-ethereum/blob/v3.0.1/contracts/test/TestReceiptV3_0.sol

use garaga_rs::calldata::full_proof_with_hints::groth16::{
    get_groth16_calldata, risc0_utils::get_risc0_vk, Groth16Proof,
};
use garaga_rs::constants::get_risc0_constants;
use garaga_rs::definitions::CurveID;
use num_bigint::BigUint;

fn receipt(control_root: Option<BigUint>) -> Groth16Proof {
    let fixture: serde_json::Value = serde_json::from_str(include_str!(
        "../../../hydra/garaga/starknet/groth16_contract_generator/examples/proof_risc0.json"
    ))
    .unwrap();
    let bytes =
        |key: &str| hex::decode(fixture[key].as_str().unwrap().trim_start_matches("0x")).unwrap();
    match control_root {
        None => Groth16Proof::from_risc0(bytes("seal"), bytes("image_id"), bytes("journal")),
        Some(root) => Groth16Proof::from_risc0_with_parameters(
            bytes("seal"),
            bytes("image_id"),
            bytes("journal"),
            root,
            get_risc0_constants().1,
        ),
    }
}

#[test]
fn risc0_v3_receipt_produces_valid_pairing_hints() {
    let proof = receipt(None);
    get_groth16_calldata(&proof, &get_risc0_vk(), CurveID::BN254).unwrap();
}

#[test]
fn risc0_v3_receipt_rejects_v2_control_root() {
    let root = BigUint::parse_bytes(
        b"ce52bf56033842021af3cf6db8a50d1b7535c125a34f1a22c6fdcf002c5a1529",
        16,
    )
    .unwrap();
    let proof = receipt(Some(root));
    let result =
        std::panic::catch_unwind(|| get_groth16_calldata(&proof, &get_risc0_vk(), CurveID::BN254));
    assert!(matches!(result, Err(_) | Ok(Err(_))));
}
