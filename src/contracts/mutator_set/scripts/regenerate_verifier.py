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

    program_name: str = "zk"
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
            "verifier_dir": project_root / "src" / f"{self.program_name}_verifier",
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
            error_msg = f"Command failed: {e.stderr.strip()}"
            logger.error(error_msg)
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

            constants_code, circuits_code, contract_code = gen_honk_verifier_files(
                vk, self.config.proof_system
            )

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
