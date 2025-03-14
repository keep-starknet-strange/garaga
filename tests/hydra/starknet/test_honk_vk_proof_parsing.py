import pytest

from garaga.definitions import ProofSystem
from garaga.precompiled_circuits.honk import HonkVk
from garaga.precompiled_circuits.zk_honk import honk_proof_from_bytes
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
    "proof_path, system",
    [
        (
            f"{PATH}/proof_ultra_keccak.bin",
            ProofSystem.UltraKeccakHonk,
        ),
        (
            f"{PATH}/proof_ultra_starknet.bin",
            ProofSystem.UltraStarknetHonk,
        ),
        (
            f"{PATH}/proof_ultra_keccak_zk.bin",
            ProofSystem.UltraKeccakZKHonk,
        ),
        (
            f"{PATH}/proof_ultra_starknet_zk.bin",
            ProofSystem.UltraStarknetZKHonk,
        ),
    ],
)
def test_proof_parsing(proof_path: str, system: ProofSystem):
    proof = honk_proof_from_bytes(open(proof_path, "rb").read(), system)
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
        (
            f"{PATH}/proof_ultra_keccak_zk.bin",
            f"{PATH}/vk_ultra_keccak.bin",
            ProofSystem.UltraKeccakZKHonk,
        ),
        (
            f"{PATH}/proof_ultra_starknet_zk.bin",
            f"{PATH}/vk_ultra_keccak.bin",
            ProofSystem.UltraStarknetZKHonk,
        ),
    ],
)
def test_calldata_generation(proof_path: str, vk_path: str, system: ProofSystem):
    import time

    vk = HonkVk.from_bytes(open(vk_path, "rb").read())
    proof = honk_proof_from_bytes(open(proof_path, "rb").read(), system)

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
