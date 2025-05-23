import pytest

from garaga.starknet.groth16_contract_generator.calldata import (
    groth16_calldata_from_vk_and_proof,
)
from garaga.starknet.groth16_contract_generator.parsing_utils import (
    Groth16Proof,
    Groth16VerifyingKey,
)

PATH = "hydra/garaga/starknet/groth16_contract_generator/examples"


@pytest.mark.parametrize(
    "vk_path",
    [
        f"{PATH}/snarkjs_vk_bn254.json",
        f"{PATH}/snarkjs_vk_bls12381.json",
        f"{PATH}/vk_bn254.json",
        f"{PATH}/vk_bls.json",
        f"{PATH}/gnark_vk_bn254.json",
        f"{PATH}/vk_risc0.json",
        f"{PATH}/vk_sp1.json",
    ],
)
def test_vk_parsing(vk_path: str):
    vk = Groth16VerifyingKey.from_json(vk_path)
    print(vk)

    # if vk_path == f"{PATH}/vk_sp1.json":
    #     print("[")
    #     for e in vk.flatten():
    #         print(f'"{hex(e)[2:]}",')
    #     print("]")


@pytest.mark.parametrize(
    "proof_path",
    [
        f"{PATH}/proof_bn254.json",
        f"{PATH}/proof_bls.json",
        f"{PATH}/proof_risc0.json",
        f"{PATH}/proof_sp1.json",
    ],
)
def test_proof_parsing(proof_path: str):
    proof = Groth16Proof.from_json(proof_path)
    print(proof)


@pytest.mark.parametrize(
    "proof_path, pub_inputs_path",
    [
        (f"{PATH}/snarkjs_proof_bn254.json", f"{PATH}/snarkjs_public_bn254.json"),
        (f"{PATH}/snarkjs_proof_bls12381.json", f"{PATH}/snarkjs_public_bls12381.json"),
        (f"{PATH}/gnark_proof_bn254.json", f"{PATH}/gnark_public_bn254.json"),
    ],
)
def test_proof_parsing_with_public_input(proof_path: str, pub_inputs_path: str):
    proof = Groth16Proof.from_json(proof_path, pub_inputs_path)

    print(proof)


@pytest.mark.parametrize(
    "proof_path, vk_path, pub_inputs_path",
    [
        (f"{PATH}/proof_bn254.json", f"{PATH}/vk_bn254.json", None),
        (f"{PATH}/proof_bls.json", f"{PATH}/vk_bls.json", None),
        (
            f"{PATH}/gnark_proof_bn254.json",
            f"{PATH}/gnark_vk_bn254.json",
            f"{PATH}/gnark_public_bn254.json",
        ),
        (
            f"{PATH}/snarkjs_proof_bn254.json",
            f"{PATH}/snarkjs_vk_bn254.json",
            f"{PATH}/snarkjs_public_bn254.json",
        ),
        (f"{PATH}/proof_risc0.json", f"{PATH}/vk_risc0.json", None),
        (f"{PATH}/proof_sp1.json", f"{PATH}/vk_sp1.json", None),
    ],
)
def test_calldata_generation(
    proof_path: str, vk_path: str, pub_inputs_path: str | None
):
    import time

    vk = Groth16VerifyingKey.from_json(vk_path)
    proof = Groth16Proof.from_json(proof_path, pub_inputs_path)

    start = time.time()
    calldata = groth16_calldata_from_vk_and_proof(vk, proof, use_rust=False)
    end = time.time()
    print(f"Python time: {end - start}")

    start = time.time()
    calldata_rust = groth16_calldata_from_vk_and_proof(vk, proof, use_rust=True)
    end = time.time()
    print(f"Rust time: {end - start}")
    assert calldata == calldata_rust
