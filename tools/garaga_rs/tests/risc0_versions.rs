// Receipt data: Copyright 2025 RISC Zero, Inc. SPDX-License-Identifier: Apache-2.0
// https://github.com/risc0/risc0-ethereum/blob/v3.0.1/contracts/test/TestReceiptV3_0.sol

use garaga_rs::calldata::full_proof_with_hints::groth16::{
    get_groth16_calldata, risc0_utils::get_risc0_vk, Groth16Proof,
};
use garaga_rs::constants::get_risc0_constants;
use garaga_rs::definitions::CurveID;
use num_bigint::BigUint;

fn receipt(control_root: BigUint) -> Groth16Proof {
    let (_, control_id) = get_risc0_constants();
    Groth16Proof::from_risc0_with_parameters(
        hex::decode("73c457ba2ccb718fd9092cc11546eeded62a44d3ed274076dd3ec154fae8739f3432050b2005be2c5dbe6c08bfd04b30601a462540962bc26a2f38c5cfc0a4d76d8f1b8015e690a1b230081234867edeedb2f98bcdf33d0471c2aa5e8db63b72333f871527eb5d1fcf0a7af50fb8f42e8699e2c4eda3cd93f4e2a930096ae78e38bea4020c5c3d963dc453b4b302170e47c0cf53382255143c8fcef474d8b6eaaa8daaaf092c2f650809a3afbd122ef128cb882c2de7a6ccddd2e544b645fa3fedf6bcc92e09be04876a07778231fd5b93305d35fd8af23f040a11682a8c64130370804f28f07a76fa538755276e42c04b5f7eb97b04b68b65fa50e3181a0452069a3667").unwrap(),
        hex::decode("11d264ed8dfdee222b820f0278e4d7f55d4b69a5472253a471c102265a91ea1a").unwrap(),
        hex::decode("6a75737420612073696d706c652072656365697074").unwrap(),
        control_root,
        control_id,
    )
}

#[test]
fn risc0_v3_receipt_produces_valid_pairing_hints() {
    // https://github.com/risc0/risc0-ethereum/blob/v3.0.1/contracts/src/groth16/ControlID.sol
    let root = BigUint::parse_bytes(
        b"a54dc85ac99f851c92d7c96d7318af41dbe7c0194edfcc37eb4d422a998c1f56",
        16,
    )
    .unwrap();
    let proof = receipt(root);
    get_groth16_calldata(&proof, &get_risc0_vk(), CurveID::BN254).unwrap();
}

#[test]
fn risc0_v3_receipt_rejects_v2_control_root() {
    let (root, _) = get_risc0_constants();
    let proof = receipt(root);
    let result =
        std::panic::catch_unwind(|| get_groth16_calldata(&proof, &get_risc0_vk(), CurveID::BN254));
    assert!(matches!(result, Err(_) | Ok(Err(_))));
}
