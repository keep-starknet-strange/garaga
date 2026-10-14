import argparse
import hashlib
import json
from pathlib import Path

import pytest
from garaga.starknet.groth16_contract_generator.calldata import (
    groth16_calldata_from_vk_and_proof,
)
from garaga.starknet.groth16_contract_generator.parsing_utils import (
    Groth16Proof,
    Groth16VerifyingKey,
)

PATH = (
    Path(__file__).resolve().parents[3]
    / "hydra/garaga/starknet/groth16_contract_generator/examples"
)
VECTORS_PATH = PATH / "groth16_calldata_test_vectors.json"
VECTORS = json.loads(VECTORS_PATH.read_text())


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


def generate_calldata(vector):
    vk = Groth16VerifyingKey.from_json(PATH / vector["vk"])
    inputs = PATH / vector["public_inputs"] if vector["public_inputs"] else None
    proof = Groth16Proof.from_json(PATH / vector["proof"], inputs)
    python = groth16_calldata_from_vk_and_proof(vk, proof, use_rust=False)
    rust = groth16_calldata_from_vk_and_proof(vk, proof, use_rust=True)
    return python, rust


def calldata_digest(calldata):
    # Decimal ASCII words, separated by one newline with no trailing newline.
    return hashlib.sha256("\n".join(map(str, calldata)).encode("ascii")).hexdigest()


@pytest.mark.parametrize("vector", VECTORS, ids=lambda vector: vector["name"])
def test_calldata_generation(vector):
    calldata, calldata_rust = generate_calldata(vector)
    assert calldata == calldata_rust
    assert len(calldata) == vector["length"]
    assert calldata[0] == len(calldata) - 1
    assert calldata_digest(calldata) == vector["sha256"]


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Update Python-derived calldata vectors"
    )
    parser.add_argument("--update-golden", action="store_true")
    if not parser.parse_args().update_golden:
        parser.error("Use --update-golden to update the expected calldata fingerprints")
    updated = []
    for vector in VECTORS:
        calldata, calldata_rust = generate_calldata(vector)
        if (
            calldata != calldata_rust
            or not calldata
            or calldata[0] != len(calldata) - 1
        ):
            raise ValueError(f"Python and Rust calldata disagree for {vector['name']}")
        updated.append(
            {**vector, "length": len(calldata), "sha256": calldata_digest(calldata)}
        )
    VECTORS_PATH.write_text(json.dumps(updated, indent=2) + "\n")
    print(f"Updated {len(updated)} calldata vectors from the Python reference")
