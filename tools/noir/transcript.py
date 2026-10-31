"""Print the canonical v6 transcript for a stored Noir proof bundle."""

import argparse
import json
from dataclasses import asdict
from pathlib import Path

from garaga.precompiled_circuits.zk_honk import HonkVk, ZKHonkProof, ZKHonkTranscript


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--case", choices=("hello", "memory", "recursive"), default="hello"
    )
    args = parser.parse_args()
    directory = (
        Path(__file__).resolve().parents[2]
        / "hydra/garaga/starknet/honk_contract_generator/examples"
    )
    manifest = json.loads((directory / "noir_artifacts.json").read_text())
    files = {
        name: directory / item["path"]
        for name, item in manifest["cases"][args.case]["files"].items()
    }
    vk = HonkVk.from_bytes(files["vk"].read_bytes())
    proof = ZKHonkProof.from_bytes(
        files["proof"].read_bytes(), files["public_inputs"].read_bytes(), vk
    )
    print(json.dumps(asdict(ZKHonkTranscript.from_proof(vk, proof)), indent=2))


if __name__ == "__main__":
    main()
