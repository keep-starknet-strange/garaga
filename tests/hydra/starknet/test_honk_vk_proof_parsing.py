import pytest

from garaga.definitions import ProofSystem
from garaga.precompiled_circuits.honk import HonkProof, HonkVk
from garaga.starknet.honk_contract_generator.calldata import (
    get_ultra_flavor_honk_calldata_from_vk_and_proof,
)

PATH = "hydra/garaga/starknet/honk_contract_generator/examples"


@pytest.mark.parametrize(
    "vk_path",
    [
        f"{PATH}/vk_ultra_keccak.bin",
    ],
)
def test_vk_parsing(vk_path: str):
    vk = HonkVk.from_bytes(open(vk_path, "rb").read())
    print(vk)


@pytest.mark.parametrize(
    "proof_path",
    [f"{PATH}/proof_ultra_keccak.bin", f"{PATH}/proof_ultra_starknet.bin"],
)
def test_proof_parsing(proof_path: str):
    proof = HonkProof.from_bytes(open(proof_path, "rb").read())
    print(proof)


@pytest.mark.parametrize(
    "proof_path, vk_path, system",
    [
        (
            f"{PATH}/proof_ultra_keccak.bin",
            f"{PATH}/vk_ultra_keccak.bin",
            ProofSystem.UltraKeccakHonk,
        ),
        (
            f"{PATH}/proof_ultra_starknet.bin",
            f"{PATH}/vk_ultra_keccak.bin",
            ProofSystem.UltraStarknetHonk,
        ),
    ],
)
def test_calldata_generation(proof_path: str, vk_path: str, system: ProofSystem):
    import time

    vk = HonkVk.from_bytes(open(vk_path, "rb").read())
    proof = HonkProof.from_bytes(open(proof_path, "rb").read())

    start = time.time()
    calldata = get_ultra_flavor_honk_calldata_from_vk_and_proof(
        vk, proof, system, use_rust=False
    )
    end = time.time()
    print(f"Python time: {end - start}")

    start = time.time()
    calldata_rust = get_ultra_flavor_honk_calldata_from_vk_and_proof(
        vk, proof, system, use_rust=True
    )
    end = time.time()
    print(f"Rust time: {end - start}")
    assert calldata == calldata_rust
