"""Regenerate the embedded verifier from the checked Noir bundle and update its class hash."""

import re
import subprocess
from pathlib import Path

from starknet_py.common import create_sierra_compiled_contract
from starknet_py.hash.sierra_class_hash import compute_sierra_class_hash

from garaga.curves import ProofSystem
from garaga.starknet.groth16_contract_generator.generator import (
    write_test_calldata_file_generic,
)
from garaga.starknet.honk_contract_generator.generator_honk import (
    gen_honk_verifier_files,
)

ROOT = Path(__file__).resolve().parents[4]
PROJECT = ROOT / "src/contracts/mutator_set"
KEY = ROOT / "hydra/garaga/starknet/honk_contract_generator/examples/mutator_set/vk.bin"


def write_embedded_verifier():
    constants, circuits, contract, _, _ = gen_honk_verifier_files(KEY)
    directory = PROJECT / "src/zk_verifier"
    for filename, code in {
        "honk_verifier_constants.cairo": constants,
        "honk_verifier_circuits.cairo": circuits,
        "honk_verifier_contract.cairo": contract,
    }.items():
        (directory / filename).write_text(code)
    subprocess.run(["scarb", "fmt"], cwd=PROJECT, check=True)
    write_test_calldata_file_generic(
        str(PROJECT),
        ProofSystem.UltraKeccakZKHonk,
        KEY,
        KEY.parent / "proof.bin",
        KEY.parent / "public_inputs.bin",
    )


def main():
    write_embedded_verifier()
    subprocess.run(["scarb", "build"], cwd=PROJECT, check=True)
    artifact = (
        PROJECT / "target/dev/mutator_set_UltraKeccakZKHonkVerifier.contract_class.json"
    )
    class_hash = compute_sierra_class_hash(
        create_sierra_compiled_contract(artifact.read_text())
    )
    path = PROJECT / "src/lib.cairo"
    code, count = re.subn(
        r"(const VERIFIER_CLASS_HASH: felt252\s*=\s*)0x[0-9a-fA-F]+",
        lambda found: found[1] + hex(class_hash),
        path.read_text(),
    )
    assert count == 1
    path.write_text(code)
    subprocess.run(["scarb", "fmt"], cwd=PROJECT, check=True)
    print(f"Updated the embedded verifier class hash: {hex(class_hash)}")


if __name__ == "__main__":
    main()
