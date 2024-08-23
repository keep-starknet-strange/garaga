import os

from starknet_py.net.models import StarknetChainId

from garaga.definitions import ProofSystem


def create_directory(path: str):
    if not os.path.exists(path):
        os.makedirs(path)
        # print(f"Directory created: {path}")


def complete_pairing_curve_id(incomplete: str):
    curve_ids = ["0", "1"]  # Corresponding to BN254 and BLS12_381
    return [cid for cid in curve_ids if cid.startswith(incomplete)]


def complete_proof_system(incomplete: str):
    systems = [ps.value for ps in ProofSystem]
    return [system for system in systems if system.startswith(incomplete)]


def complete_network(incomplete: str):
    networks = [network.name for network in StarknetChainId]
    return [network for network in networks if network.startswith(incomplete)]


def complete_pairing_curve_id(incomplete: str):
    curve_ids = ["0", "1"]  # Corresponding to BN254 and BLS12_381
    return [cid for cid in curve_ids if cid.startswith(incomplete)]
