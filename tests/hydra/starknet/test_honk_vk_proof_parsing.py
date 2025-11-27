import pytest

from garaga.curves import ProofSystem
from garaga.precompiled_circuits.zk_honk import HonkVk, honk_proof_from_bytes
from garaga.starknet.honk_contract_generator.calldata import (
    get_ultra_flavor_honk_calldata_from_vk_and_proof,
)

PATH = "hydra/garaga/starknet/honk_contract_generator/examples"


@pytest.mark.parametrize(
    "vk_path, vk_hash_path",
    [
        (f"{PATH}/vk_ultra_keccak.bin", f"{PATH}/vk_hash_ultra_keccak.bin"),
    ],
)
def test_vk_parsing(vk_path: str, vk_hash_path: str):
    vk = HonkVk.from_bytes(open(vk_path, "rb").read())
    vk_hash_expected = int.from_bytes(open(vk_hash_path, "rb").read(), "big")
    assert (
        vk.vk_hash == vk_hash_expected
    ), f"vk_hash: {hex(vk.vk_hash)} != vk_hash_expected: {hex(vk_hash_expected)}"
    print(vk)


@pytest.mark.parametrize(
    "proof_path, public_inputs_path, vk_path, system",
    [
        (
            f"{PATH}/proof_ultra_keccak_zk.bin",
            f"{PATH}/public_inputs_ultra_keccak.bin",
            f"{PATH}/vk_ultra_keccak.bin",
            ProofSystem.UltraKeccakZKHonk,
        ),
    ],
)
def test_proof_parsing(
    proof_path: str,
    public_inputs_path: str,
    vk_path: str,
    system: ProofSystem,
):
    vk = HonkVk.from_bytes(open(vk_path, "rb").read())
    proof = honk_proof_from_bytes(
        open(proof_path, "rb").read(), open(public_inputs_path, "rb").read(), vk, system
    )
    print(proof)


@pytest.mark.parametrize(
    "proof_path, public_inputs_path, vk_path, system",
    [
        (
            f"{PATH}/proof_ultra_keccak_zk.bin",
            f"{PATH}/public_inputs_ultra_keccak.bin",
            f"{PATH}/vk_ultra_keccak.bin",
            ProofSystem.UltraKeccakZKHonk,
        ),
    ],
)
def test_calldata_generation(
    proof_path: str,
    public_inputs_path: str,
    vk_path: str,
    system: ProofSystem,
):
    import time

    vk = HonkVk.from_bytes(open(vk_path, "rb").read())
    proof = honk_proof_from_bytes(
        open(proof_path, "rb").read(), open(public_inputs_path, "rb").read(), vk, system
    )

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
