import logging
import os
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

from garaga.starknet.cli.utils import create_directory
from garaga.starknet.honk_contract_generator.generator_honk import (
    HonkVk,
    ProofSystem,
    gen_honk_verifier_files,
)

# Configure logging
logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


@dataclass
class VerifierConfig:
    """Configuration for verifier generation."""

    program_name: str = "zk_program"
    bb_path: str = "bb"
    scheme: str = "ultra_honk"
    oracle_hash: str = "keccak"
    proof_system: ProofSystem = ProofSystem.UltraKeccakZKHonk

    @property
    def paths(self) -> dict:
        """Get all relevant paths based on the script location."""
        script_dir = Path(__file__).parent
        project_root = script_dir.parent
        return {
            "noir_program_dir": project_root / self.program_name,
            "target_dir": project_root / self.program_name / "target",
            "verifier_dir": project_root / "src" / f"zk_verifier",
            "lib_cairo": project_root / "src" / "lib.cairo",
            "contract_class": project_root
            / "target"
            / "dev"
            / "mutator_set_UltraKeccakZKHonkVerifier.contract_class.json",
        }


class VerifierGenerator:
    """Handles the generation of verifier files for the ZK program."""

    def __init__(self, config: VerifierConfig):
        self.config = config
        self.paths = config.paths

    def run_command(self, cmd: list, cwd: Optional[Path] = None) -> str:
        logger.info(f"Running: {' '.join(cmd)}")
        try:
            result = subprocess.run(
                cmd, cwd=cwd, check=True, text=True, capture_output=True
            )
            return result.stdout.strip()
        except subprocess.CalledProcessError as e:
            error_msg = f"Command failed with output:\nstdout: {e.stdout.strip()}\nstderr: {e.stderr.strip()}"
            logger.error(error_msg)
            raise

    def update_class_hash(self, class_hash: str):
        """Update the class hash in lib.cairo."""
        try:
            content = f"""pub mod mutator_set_contract;

pub mod zk_verifier {{
    pub mod honk_verifier_circuits;
    pub mod honk_verifier_constants;
    pub mod honk_verifier_contract;
}}

const VERIFIER_CLASS_HASH: felt252 = {class_hash};
"""
            with open(self.paths["lib_cairo"], "w") as f:
                f.write(content)

            logger.info(f"Updated class hash in {self.paths['lib_cairo']}")
        except Exception as e:
            logger.error(f"Failed to update class hash: {str(e)}")
            raise

    def generate(self) -> bool:
        """Generate verifier files for the ZK program."""
        try:
            original_dir = os.getcwd()
            os.chdir(self.paths["noir_program_dir"])

            # Build project and generate verification key
            os.makedirs(self.paths["target_dir"], exist_ok=True)
            self.run_command(["nargo", "build"])
            self.run_command(
                [
                    self.config.bb_path,
                    "write_vk",
                    "--scheme",
                    self.config.scheme,
                    "--oracle_hash",
                    self.config.oracle_hash,
                    "-b",
                    str(self.paths["target_dir"] / f"{self.config.program_name}.json"),
                    "-o",
                    str(self.paths["target_dir"]),
                ]
            )

            # Generate and write verifier files
            with open(self.paths["target_dir"] / "vk", "rb") as f:
                vk = HonkVk.from_bytes(f.read())

            (
                constants_code,
                circuits_code,
                contract_code,
                contract_name,
                verification_function_name,
            ) = gen_honk_verifier_files(vk)

            # Write files
            create_directory(self.paths["verifier_dir"])
            # Remove existing files
            for filename in os.listdir(self.paths["verifier_dir"]):
                os.remove(self.paths["verifier_dir"] / filename)
            for filename, content in {
                "honk_verifier_constants.cairo": constants_code,
                "honk_verifier_circuits.cairo": circuits_code,
                "honk_verifier_contract.cairo": contract_code,
            }.items():
                with open(self.paths["verifier_dir"] / filename, "w") as f:
                    f.write(content)

            self.run_command(["scarb", "fmt", str(self.paths["verifier_dir"])])

            # Change to project root and run scarb build
            os.chdir(self.paths["noir_program_dir"].parent)
            self.run_command(["scarb", "build"])

            # Get class hash
            class_hash = self.run_command(
                ["starkli", "class-hash", str(self.paths["contract_class"])]
            )
            logger.info(f"Generated class hash: {class_hash}")

            # Update class hash in lib.cairo
            self.update_class_hash(class_hash)

            # Format lib.cairo
            self.run_command(["scarb", "fmt", str(self.paths["lib_cairo"])])

            os.chdir(original_dir)
            return True

        except Exception as e:
            logger.error(f"Verifier generation failed: {str(e)}")
            raise


def main():
    """Main function to build project and generate verifiers."""
    try:
        generator = VerifierGenerator(VerifierConfig())
        generator.generate()
        logger.info("Verifier generation completed successfully")
    except Exception as e:
        logger.error(f"Failed to generate verifier: {str(e)}")
        raise


if __name__ == "__main__":
    main()
