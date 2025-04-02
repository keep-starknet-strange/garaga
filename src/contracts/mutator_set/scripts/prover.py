import os
from dataclasses import dataclass
from typing import List

import toml

MAX_PEAKS = 32
MAX_PROOF_DEPTH = 32


@dataclass
class StorageElement:
    hash: str


@dataclass
class Proof:
    len: str
    storage: List[StorageElement]


@dataclass
class ProverConfig:
    leaf_index: str
    leaf_premiage: str
    num_leafs: str
    peaks: List[str]
    root_hash: str
    proof: Proof

    def to_dict(self) -> dict:
        """Convert the dataclass to a dictionary format suitable for TOML serialization."""
        return {
            "leaf_index": self.leaf_index,
            "leaf_premiage": self.leaf_premiage,
            "num_leafs": self.num_leafs,
            "peaks": self.peaks,
            "root_hash": self.root_hash,
            "proof": {
                "len": self.proof.len,
                "storage": [{"hash": s.hash} for s in self.proof.storage],
            },
        }

    def save_to_toml(self, filepath: str) -> None:
        """Save the configuration to a TOML file."""
        config_dict = self.to_dict()
        with open(filepath, "w") as f:
            toml.dump(config_dict, f)

    @classmethod
    def load_from_toml(cls, filepath: str) -> "ProverConfig":
        """Load configuration from a TOML file."""
        with open(filepath, "r") as f:
            config_dict = toml.load(f)

        # Convert the dictionary back to ProverConfig
        proof_dict = config_dict["proof"]
        storage = [StorageElement(hash=s["hash"]) for s in proof_dict["storage"]]
        proof = Proof(len=proof_dict["len"], storage=storage)

        return cls(
            leaf_index=config_dict["leaf_index"],
            leaf_premiage=config_dict["leaf_premiage"],
            num_leafs=config_dict["num_leafs"],
            peaks=config_dict["peaks"],
            root_hash=config_dict["root_hash"],
            proof=proof,
        )


def create_default_config() -> ProverConfig:
    """Create a default configuration matching the example Prover.toml."""
    storage_elements = [StorageElement(hash="0") for _ in range(MAX_PROOF_DEPTH)]
    storage_elements[1] = StorageElement(
        hash="0x2098f5fb9e239eab3ceac3f27b81e481dc3124d55ffed523a839ee8446b64864"
    )

    peaks = (
        ["0x1069673dcdb12263df301a6ff584a7ec261a44cb9dc68df067a4774460b1f1e1"]
        + ["0x0"]
        + ["0x0"] * (MAX_PEAKS - 2)
    )

    return ProverConfig(
        leaf_index=hex(2),
        leaf_premiage=hex(0),
        num_leafs=hex(5),
        peaks=peaks,
        root_hash="0x1ba30aaf15c7694786a1f118ca39fcc6c997b48da9dfa62e9ec3e83ac7d6304d",
        proof=Proof(len=hex(2), storage=storage_elements),
    )


if __name__ == "__main__":
    # Example usage
    config = create_default_config()

    # Save to TOML
    output_path = os.path.join(
        os.path.dirname(os.path.dirname(__file__)), "zk_program", "Prover.toml"
    )
    config.save_to_toml(output_path)
    print(f"Saved configuration to {output_path}")

    # Load from TOML
    loaded_config = ProverConfig.load_from_toml(output_path)
    print("Successfully loaded configuration from TOML")
