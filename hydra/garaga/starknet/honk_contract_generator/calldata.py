from garaga.precompiled_circuits.honk_new import HonkProof, HonkVk


def get_ultra_keccak_honk_calldata_from_vk_and_proof(
    vk: HonkVk, proof: HonkProof
) -> list[int]:
    return proof.serialize_to_calldata()
