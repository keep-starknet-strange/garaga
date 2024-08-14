import pytest
from tools.starknet.groth16_contract_generator.parsing_utils import (
    Groth16Proof,
    Groth16VerifyingKey,
)

PATH = "tools/starknet/groth16_contract_generator/examples"


@pytest.mark.parametrize(
    "vk_path",
    [
        f"{PATH}/snarkjs_vk_bn254.json",
        f"{PATH}/vk_bn254.json",
        f"{PATH}/vk_bls.json",
        f"{PATH}/gnark_vk_bn254.json",
        f"{PATH}/vk_risc0.json",
    ],
)
def test_vk_parsing(vk_path: str):
    vk = Groth16VerifyingKey.from_json(vk_path)
    print(vk)


@pytest.mark.parametrize(
    "proof_path",
    [f"{PATH}/proof_bn254.json", f"{PATH}/proof_bls.json"],
)
def test_proof_parsing(proof_path: str):
    proof = Groth16Proof.from_json(proof_path)
    print(proof)


@pytest.mark.parametrize(
    "vk_path, pub_inputs_path",
    [
        (f"{PATH}/snarkjs_vk_bn254.json", f"{PATH}/snarkjs_public_bn254.json"),
        (f"{PATH}/gnark_vk_bn254.json", f"{PATH}/gnark_public_bn254.json"),
    ],
)
def test_proof_parsing_with_public_input(vk_path: str, pub_inputs_path: str):
    proof = Groth16Proof.from_json(proof_path, pub_inputs_path)

    print(proof)
