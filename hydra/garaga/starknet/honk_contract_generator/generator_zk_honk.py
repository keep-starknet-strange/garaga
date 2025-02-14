def gen_zk_honk_verifier(
    vk: str | Path | HonkVk | bytes,
    output_folder_path: str,
    output_folder_name: str,
    system: ProofSystem = ProofSystem.UltraKeccakZKHonk,
    cli_mode: bool = False,
) -> str:
    raise ValueError("Unimplemented")  # TODO


if __name__ == "__main__":

    for system in [ProofSystem.UltraKeccakZKHonk, ProofSystem.UltraStarknetZKHonk]:

        flavor = "keccak" if system == ProofSystem.UltraKeccakZKHonk else "starknet"

        VK_PATH = (
            "hydra/garaga/starknet/honk_contract_generator/examples/vk_ultra_keccak.bin"
        )
        VK_LARGE_PATH = (
            "hydra/garaga/starknet/honk_contract_generator/examples/vk_large.bin"
        )
        CONTRACTS_FOLDER = "src/contracts/"  # Do not change this

        FOLDER_NAME = f"noir_ultra_{flavor}_zk_honk_example"  # '_curve_id' is appended in the end.

        gen_zk_honk_verifier(VK_PATH, CONTRACTS_FOLDER, FOLDER_NAME, system=system)
        # gen_zk_honk_verifier(VK_LARGE_PATH, CONTRACTS_FOLDER, FOLDER_NAME + "_large", system=system)
