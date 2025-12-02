#!/usr/bin/env python3
"""
Generate language-specific constants from constants.json and sync version numbers across files.
"""

import json
import logging
import os
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Dict, Optional, Protocol

from garaga.starknet.groth16_contract_generator.parsing_utils import Groth16VerifyingKey


class FormatterProtocol(Protocol):
    """Protocol for code formatters."""

    def format_file(self, file_path: str, cwd: Optional[str] = None) -> bool:
        """Format a file. Returns True if successful, False otherwise."""
        ...


class SubprocessFormatter:
    """Formatter that uses external subprocess commands."""

    def __init__(self, cmd: list[str], name: str):
        self.cmd = cmd
        self.name = name

    def format_file(self, file_path: str, cwd: Optional[str] = None) -> bool:
        """Format a file using subprocess command."""
        print(f"Formatting {file_path} with {self.name}")
        try:
            cmd = self.cmd + [file_path]
            subprocess.run(cmd, check=True, capture_output=True, text=True, cwd=cwd)
            logger.info(f"Successfully formatted with {self.name}")
            return True
        except subprocess.CalledProcessError as e:
            logger.warning(f"{self.name} formatting failed: {e.stderr}")
            return False
        except FileNotFoundError:
            logger.warning(f"{self.name} not found - skipping formatting")
            return False
        except Exception as e:
            logger.warning(f"Unexpected error running {self.name}: {e}")
            return False


from rich.logging import RichHandler

# Configure logging with rich for color-based level printing
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    handlers=[
        RichHandler(),
    ],
)
logger = logging.getLogger(__name__)


class ConstantsError(Exception):
    """Base exception for constants generation errors."""


class VKError(ConstantsError):
    """Raised when verification key processing fails."""


@dataclass(frozen=True)
class UpdateConfig:
    """Configuration for version update operations."""

    name: str
    pattern: str
    replacement: str
    description: str = ""
    version_key: str = (
        "garaga_version"  # Default to garaga_version for backward compatibility
    )

    def apply_update(self, content: str, version: str) -> tuple[str, bool]:
        """Apply the update to content and return (new_content, changed)."""
        replacement = self.replacement.replace("{version}", version)
        new_content = re.sub(self.pattern, replacement, content)
        return new_content, content != new_content


@dataclass(frozen=True)
class VKConfig:
    """Configuration for verification key updates."""

    name: str
    json_filename: str
    function_name: str

    def get_json_path(self, project_root: Path) -> Path:
        return (
            project_root
            / "hydra"
            / "garaga"
            / "starknet"
            / "groth16_contract_generator"
            / "examples"
            / self.json_filename
        )

    def get_function_pattern(self) -> str:
        """Generate the regex pattern for this VK function."""
        return (
            f"(pub fn {self.function_name}\\(\\) -> Groth16VerificationKey \\{{\\s*let vk_hex = \\[)"
            "([\\s\\S]*?)"
            "(\\];\\s*Groth16VerificationKey::from\\([\\s\\S]*?\\}\\s*\\})"
        )


# VK Configurations - simplified with pattern generation
SP1_VK_CONFIG = VKConfig(
    name="SP1",
    json_filename="vk_sp1.json",
    function_name="get_sp1_vk",
)

RISC0_VK_CONFIG = VKConfig(
    name="RISC0",
    json_filename="vk_risc0.json",
    function_name="get_risc0_vk",
)


@dataclass(frozen=True)
class PathConfig:
    """Configuration for all file paths used in the script."""

    project_root: Path

    @property
    def python_output(self) -> Path:
        return self.project_root / "hydra" / "garaga" / "starknet" / "constants.py"

    @property
    def rust_output(self) -> Path:
        return self.project_root / "tools" / "garaga_rs" / "src" / "constants.rs"

    @property
    def typescript_output(self) -> Path:
        return (
            self.project_root / "tools" / "npm" / "garaga_ts" / "src" / "constants.ts"
        )

    @property
    def readme_path(self) -> Path:
        return self.project_root / "docs" / "PYPI_README.md"

    @property
    def pyproject_path(self) -> Path:
        return self.project_root / "pyproject.toml"

    @property
    def garaga_rs_cargo_path(self) -> Path:
        return self.project_root / "tools" / "garaga_rs" / "Cargo.toml"

    @property
    def package_json_path(self) -> Path:
        return self.project_root / "tools" / "npm" / "garaga_ts" / "package.json"

    @property
    def npm_readme_path(self) -> Path:
        return self.project_root / "tools" / "npm" / "garaga_ts" / "README.md"

    @property
    def noir_smart_contract_docs_path(self) -> Path:
        return (
            self.project_root
            / "docs"
            / "gitbook"
            / "smart-contract-generators"
            / "noir.md"
        )

    @property
    def groth16_rust_file(self) -> Path:
        return (
            self.project_root
            / "tools"
            / "garaga_rs"
            / "src"
            / "calldata"
            / "full_proof_with_hints"
            / "groth16.rs"
        )


# File path to update config mappings
VERSION_UPDATES = [
    (
        "PYPI README",
        "readme_path",
        UpdateConfig(
            name="PYPI README",
            pattern=r"(pip\s+install\s+garaga==)[\d]+\.[\d]+\.[\d]+(?:[\w\-\.]*)?",
            replacement=r"\g<1>{version}",
            description="pip install commands",
        ),
    ),
    (
        "pyproject.toml",
        "pyproject_path",
        UpdateConfig(
            name="pyproject.toml",
            pattern=r'(version\s*=\s*["\'])[\d]+\.[\d]+\.[\d]+(?:[\w\-\.]*)?(["\'])',
            replacement=r"\g<1>{version}\g<2>",
            description="Python package version",
        ),
    ),
    (
        "Cargo.toml",
        "garaga_rs_cargo_path",
        UpdateConfig(
            name="Cargo.toml",
            pattern=r'(\[package\].*?^version\s*=\s*["\'])[\d]+\.[\d]+\.[\d]+(?:[\w\-\.]*)?(["\'])',
            replacement=r"\g<1>{version}\g<2>",
            description="Rust package version",
        ),
    ),
    (
        "package.json",
        "package_json_path",
        UpdateConfig(
            name="package.json",
            pattern=r'("version"\s*:\s*["\'])[\d]+\.[\d]+\.[\d]+(?:[\w\-\.]*)?(["\'])',
            replacement=r"\g<1>{version}\g<2>",
            description="NPM package version",
        ),
    ),
    (
        "npm README",
        "npm_readme_path",
        UpdateConfig(
            name="npm README",
            pattern=r"(📋 \*\*For complete API documentation.*?)v[\d]+\.[\d]+\.[\d]+(?:[\w\-\.]*)?(/tools/npm/garaga_ts/src/node/api\.ts)",
            replacement=r"\g<1>v{version}\g<2>",
            description="API documentation links",
        ),
    ),
    (
        "Noir version in smart contract docs",
        "noir_smart_contract_docs_path",
        UpdateConfig(
            name="Noir version in smart contract docs",
            pattern=r"(\* Noir\s+)[\d]+\.[\d]+\.[\d]+[-\w\.]*(\s+\(install with `noirup --version\s+)[\d]+\.[\d]+\.[\d]+[-\w\.]*(`\s+or `npm i @noir-lang/noir_js@)[\d]+\.[\d]+\.[\d]+[-\w\.]*(`\s*\))",
            replacement=r"\g<1>{version}\g<2>{version}\g<3>{version}\g<4>",
            description="Noir version in smart contract generator documentation",
            version_key="nargo_version",
        ),
    ),
    (
        "BB version in smart contract docs",
        "noir_smart_contract_docs_path",
        UpdateConfig(
            name="BB version in smart contract docs",
            pattern=r"(\* Barretenberg\s+)[\d]+\.[\d]+\.[\d]+[-\w\.]*(\s+\(install with `bbup --version\s+)[\d]+\.[\d]+\.[\d]+[-\w\.]*(`\s+or `npm i @aztec/bb\.js@)[\d]+\.[\d]+\.[\d]+[-\w\.]*(`\s+\))",
            replacement=r"\g<1>{version}\g<2>{version}\g<3>{version}\g<4>",
            description="Barretenberg version in smart contract generator documentation",
            version_key="bb_version",
        ),
    ),
]

VK_UPDATES = [
    ("SP1 VK in Rust", SP1_VK_CONFIG),
    ("RISC0 VK in Rust", RISC0_VK_CONFIG),
]


def load_constants() -> Dict[str, Any]:
    """Load constants from the centralized JSON file."""
    constants_file = Path(__file__).parent / "constants.json"

    try:
        if not constants_file.exists():
            raise ConstantsError(f"Constants file not found: {constants_file}")

        with open(constants_file, "r") as f:
            constants = json.load(f)

        # Basic validation
        required_keys = ["risc0", "sp1", "release_info", "noir"]
        missing_keys = [key for key in required_keys if key not in constants]
        if missing_keys:
            raise ConstantsError(
                f"Missing required keys in constants.json: {missing_keys}"
            )

        logger.info(f"Successfully loaded constants from {constants_file}")
        return constants

    except (json.JSONDecodeError, IOError) as e:
        raise ConstantsError(f"Failed to load constants from {constants_file}: {e}")
    except Exception as e:
        raise ConstantsError(f"Unexpected error loading constants: {e}")


@dataclass(frozen=True)
class LanguageConfig:
    """Configuration for language-specific code generation."""

    name: str
    comment_prefix: str
    constant_template: str
    formatter: FormatterProtocol


# Language-specific configurations
COMMON_FILE_HEADER = (
    "Auto-generated constants file from constants.json. Do not edit manually."
)

LANGUAGE_CONFIGS = [
    LanguageConfig(
        name="Python",
        comment_prefix="#",
        constant_template="{name} = {value}",
        formatter=SubprocessFormatter(["black"], "black"),
    ),
    LanguageConfig(
        name="Rust",
        comment_prefix="//",
        constant_template="pub const {name}: &str = {value};",
        formatter=SubprocessFormatter(["cargo", "fmt", "--"], "cargo fmt"),
    ),
    LanguageConfig(
        name="TypeScript",
        comment_prefix="//",
        constant_template="export const {name}: string = {value};",
        formatter=SubprocessFormatter(
            ["npx", "prettier", "--write"], "prettier (ensure it's installed)"
        ),
    ),
]


def safe_read_file(file_path: str) -> str:
    """Safely read a file with proper error handling."""
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            return f.read()
    except IOError as e:
        raise ConstantsError(f"Failed to read {file_path}: {e}")


def safe_write_file(file_path: str, content: str) -> None:
    """Safely write to a file with proper error handling."""
    try:
        os.makedirs(os.path.dirname(file_path), exist_ok=True)
        with open(file_path, "w", encoding="utf-8") as f:
            f.write(content)
    except IOError as e:
        raise ConstantsError(f"Failed to write {file_path}: {e}")


def generate_unified_constants(
    constants: Dict[str, Any], config: LanguageConfig
) -> str:
    """Generate constants file content using unified template."""

    # Build content sections
    lines = []

    # File header
    if config.name == "Python":
        lines.extend(['"""', COMMON_FILE_HEADER, '"""', ""])
    elif config.name == "TypeScript":
        lines.extend(
            ["/**", " * " + COMMON_FILE_HEADER.replace("\n", "\n * "), " */", ""]
        )
    else:  # Rust
        lines.extend([f"//! {line}" for line in COMMON_FILE_HEADER.split("\n")] + [""])

    # Add Rust-specific imports
    if config.name == "Rust":
        lines.extend(["use num_bigint::BigUint;", "use num_traits::Num;", ""])

    # RISC0 section
    risc0_info = constants["risc0"]
    release_version = constants["release_info"]["risc0_release"]
    lines.extend(
        [
            f"{config.comment_prefix} RISC0 Constants",
            f"{config.comment_prefix} https://github.com/risc0/risc0-ethereum/blob/{release_version}/contracts/src/groth16/ControlID.sol",
            f"{config.comment_prefix} release {release_version}",
        ]
    )

    if config.name == "Rust":
        lines.extend(
            [
                "pub fn get_risc0_constants() -> (BigUint, BigUint) {",
                f'    let risc0_control_root = BigUint::from_str_radix("{risc0_info["control_root"][2:]}", 16).unwrap();',
                f'    let risc0_bn254_control_id = BigUint::from_str_radix("{risc0_info["bn254_control_id"][2:]}", 16).unwrap();',
                "    (risc0_control_root, risc0_bn254_control_id)",
                "}",
            ]
        )
    elif config.name == "TypeScript":
        lines.extend(
            [
                f'export const RISC0_CONTROL_ROOT = BigInt("{risc0_info["control_root"]}");',
                f'export const RISC0_BN254_CONTROL_ID = BigInt("{risc0_info["bn254_control_id"]}");',
            ]
        )
    else:  # Python
        lines.extend(
            [
                f'RISC0_CONTROL_ROOT = {risc0_info["control_root"]}',
                f'RISC0_BN254_CONTROL_ID = {risc0_info["bn254_control_id"]}',
            ]
        )

    lines.append("")

    # SP1 section
    sp1_info = constants["sp1"]
    lines.extend(
        [
            f"{config.comment_prefix} SP1 Constants",
            f"{config.comment_prefix} https://github.com/succinctlabs/sp1-contracts/blob/main/contracts/src/{sp1_info['verifier_version']}/SP1VerifierGroth16.sol",
        ]
    )

    if config.name == "Python":
        lines.extend(
            [
                f'SP1_VERIFIER_VERSION = "{sp1_info["verifier_version"]}"',
                f'SP1_VERIFIER_HASH = bytes.fromhex("{sp1_info["verifier_hash"][2:]}")',
            ]
        )
    elif config.name == "TypeScript":
        lines.extend(
            [
                f'export const SP1_VERIFIER_VERSION = "{sp1_info["verifier_version"]}";',
                f'export const SP1_VERIFIER_HASH = "{sp1_info["verifier_hash"]}";',
            ]
        )
    else:  # Rust
        lines.extend(
            [
                f'pub const SP1_VERIFIER_VERSION: &str = "{sp1_info["verifier_version"]}";',
                f'pub const SP1_VERIFIER_HASH: &str = "{sp1_info["verifier_hash"]}";',
            ]
        )

    lines.append("")

    # Additional constants
    lines.extend(
        [
            f"{config.comment_prefix} Additional RISC0 constants for internal use",
        ]
    )

    if config.name == "Python":
        lines.extend(
            [
                f'RISC0_SYSTEM_STATE_ZERO_DIGEST = "{risc0_info["system_state_zero_digest"]}"',
                f'RISC0_TAG_DIGEST = "{risc0_info["tag_digest"]}"',
                f'RISC0_OUTPUT_TAG = "{risc0_info["output_tag"]}"',
                f'RISC0_RELEASE_VERSION = "{constants["release_info"]["risc0_release"]}"',
            ]
        )
    elif config.name == "TypeScript":
        lines.extend(
            [
                f'export const RISC0_SYSTEM_STATE_ZERO_DIGEST = Uint8Array.from(Buffer.from("{risc0_info["system_state_zero_digest"].lstrip("0x")}", "hex"));',
                f'export const RISC0_TAG_DIGEST = "{risc0_info["tag_digest"]}";',
                f'export const RISC0_OUTPUT_TAG = "{risc0_info["output_tag"]}";',
            ]
        )
    else:  # Rust
        lines.extend(
            [
                f'pub const RISC0_SYSTEM_STATE_ZERO_DIGEST: &str = "{risc0_info["system_state_zero_digest"]}";',
                f'pub const RISC0_TAG_DIGEST: &str = "{risc0_info["tag_digest"]}";',
                f'pub const RISC0_OUTPUT_TAG: &str = "{risc0_info["output_tag"]}";',
            ]
        )

    if config.name == "Python":
        release_info = constants["release_info"]
        noir_info = constants["noir"]
        lines.extend(
            [
                "",
                f"{config.comment_prefix} Version info",
                f'CAIRO_VERSION = "{release_info["cairo_version"]}"',
                f'STARKNET_FOUNDRY_VERSION = "{release_info["starknet_foundry_version"]}"',
                f'BB_VERSION = "{noir_info["bb_version"]}"',
                f'BBUP_VERSION = "{noir_info["bbup_version"]}"',
                f'NARGO_VERSION = "{noir_info["nargo_version"]}"',
            ]
        )

    return "\n".join(lines) + "\n"


def generate_language_constants(
    constants: Dict[str, Any], config: LanguageConfig, output_path: str
) -> None:
    """Generate constants file for a specific language."""
    try:
        content = generate_unified_constants(constants, config)
        safe_write_file(output_path, content)

        # Format if formatter available
        if config.formatter:
            cwd = os.path.dirname(output_path) if config.name == "Rust" else None
            config.formatter.format_file(output_path, cwd)

        logger.info(f"Generated {config.name} constants: {output_path}")

    except Exception as e:
        raise ConstantsError(f"Failed to generate {config.name} constants: {e}")


def generate_constants_by_language(
    constants: Dict[str, Any], language: str, output_path: str
):
    """Generate constants file for a specific language by name."""
    # Find language config
    config = next((cfg for cfg in LANGUAGE_CONFIGS if cfg.name == language), None)
    if not config:
        raise ConstantsError(f"Unknown language: {language}")

    generate_language_constants(constants, config, output_path)


def update_file_version(file_path: str, config: UpdateConfig, version: str) -> bool:
    """Generic file version update function."""
    try:
        if not Path(file_path).exists():
            logger.warning(f"{config.name} file not found: {file_path}")
            return False

        content = safe_read_file(file_path)
        new_content, changed = config.apply_update(content, version)

        if not changed:
            logger.info(f"No {config.name} update needed (already {version})")
            return True

        safe_write_file(file_path, new_content)
        logger.info(f"Updated {config.name} to version {version}")
        return True

    except Exception as e:
        raise ConstantsError(f"Failed to update {config.name}: {e}")


def update_vk_in_rust(
    project_root: Path, groth16_rust_file: str, config: VKConfig
) -> bool:
    """Update verification key function in Rust with values from JSON."""
    try:

        # Load and parse VK
        vk_path = config.get_json_path(project_root)
        if not vk_path.exists():
            raise ConstantsError(f"{config.name} VK file not found at {vk_path}")

        try:
            vk = Groth16VerifyingKey.from_json(vk_path)
            logger.info(f"Successfully loaded {config.name} VK from {vk_path}")
        except Exception as e:
            raise VKError(f"Failed to parse {config.name} VK: {e}")

        # Process VK data
        hex_values = [hex(value)[2:] for value in vk.flatten()]

        # Format hex array
        hex_lines = []
        for i in range(0, len(hex_values), 4):
            line_values = hex_values[i : i + 4]
            formatted_line = "        " + ", ".join(f'"{val}"' for val in line_values)
            hex_lines.append(formatted_line)
        new_hex_array = ",\n".join(hex_lines) + ","

        # Update file
        content = safe_read_file(groth16_rust_file)

        match = re.search(config.get_function_pattern(), content)
        if not match:
            raise VKError(f"Could not find {config.name} VK function pattern")

        new_content = re.sub(
            config.get_function_pattern(),
            f"\\g<1>\n{new_hex_array}\n    \\g<3>",
            content,
        )

        if content == new_content:
            logger.info(f"No {config.name} VK update needed - already current")
            return True

        safe_write_file(groth16_rust_file, new_content)
        logger.info(
            f"Updated {config.name} verification key ({len(hex_values)} values)"
        )

        # Format with cargo
        rust_config = next(
            (cfg for cfg in LANGUAGE_CONFIGS if cfg.name == "Rust"), None
        )
        if rust_config:
            rust_config.formatter.format_file(
                groth16_rust_file, os.path.dirname(groth16_rust_file)
            )

        return True

    except (VKError, ConstantsError):
        raise
    except Exception as e:
        raise VKError(f"Unexpected error updating {config.name} VK: {e}")
    finally:
        if str(project_root / "hydra") in sys.path:
            sys.path.remove(str(project_root / "hydra"))


def report_results(all_results: list[tuple[str, bool]]) -> int:
    """Report operation results and return exit code."""
    failed = [result for result in all_results if not result[1]]
    successful = [result for result in all_results if result[1]]

    logger.info(
        f"Operations completed: {len(successful)}/{len(all_results)} successful"
    )

    if successful:
        logger.info("Successful operations:")
        for result in successful:
            logger.info(f"  ✓ {result[0]}")

    if failed:
        logger.warning("Failed operations:")
        for result in failed:
            logger.warning(f"  ✗ {result[0]}")

        logger.warning(f"{len(failed)} operations failed")
        return 1
    else:
        logger.info("All constants files and version references updated successfully!")
        return 0


def generate_all_constants(constants: Dict[str, Any], paths: PathConfig) -> None:
    """Generate constants files for all languages."""
    generate_constants_by_language(constants, "Python", str(paths.python_output))
    generate_constants_by_language(constants, "Rust", str(paths.rust_output))
    generate_constants_by_language(
        constants, "TypeScript", str(paths.typescript_output)
    )
    logger.info("Successfully generated all constants files")


def update_all_versions(
    constants: Dict[str, Any], paths: PathConfig
) -> list[tuple[str, bool]]:
    """Update version references across all files."""
    results = []

    for mapping in VERSION_UPDATES:
        try:
            file_path = str(getattr(paths, mapping[1]))
            config = mapping[2]

            # Get the appropriate version based on the version_key
            if config.version_key == "nargo_version":
                version = constants["noir"]["nargo_version"]
            elif config.version_key == "bb_version":
                version = constants["noir"]["bb_version"]
            else:
                version = constants["release_info"]["garaga_version"]

            success = update_file_version(file_path, config, version)
            results.append((mapping[0], success))
            if success:
                logger.info(f"Successfully updated {mapping[0]}")
            else:
                logger.warning(f"No updates needed for {mapping[0]}")
        except Exception as e:
            logger.error(f"Failed to update {mapping[0]}: {e}")
            results.append((mapping[0], False))

    return results


def update_verification_keys(paths: PathConfig) -> list[tuple[str, bool]]:
    """Update verification keys in Rust code."""
    results = []

    for mapping in VK_UPDATES:
        try:
            success = update_vk_in_rust(
                paths.project_root,
                str(paths.groth16_rust_file),
                mapping[1],
            )
            results.append((mapping[0], success))
            if success:
                logger.info(f"Successfully updated {mapping[0]}")
        except (VKError, ConstantsError) as e:
            logger.error(f"Failed to update {mapping[0]}: {e}")
            results.append((mapping[0], False))
        except Exception as e:
            logger.error(f"Unexpected error updating {mapping[0]}: {e}")
            results.append((mapping[0], False))

    return results


def main():
    """Main function to generate all constants files and update version references."""
    try:
        logger.info("Starting constants generation and version updates...")

        # Load and validate constants
        constants = load_constants()

        # Define output paths
        project_root = Path(__file__).parent.parent.parent
        paths = PathConfig(project_root)

        # Generate constants files
        generate_all_constants(constants, paths)

        # Update version references and verification keys
        logger.info("Updating version references...")
        version_results = update_all_versions(constants, paths)

        logger.info("Updating verification keys...")
        vk_results = update_verification_keys(paths)

        # Report results and return appropriate exit code
        all_results = version_results + vk_results
        return report_results(all_results)

    except ConstantsError as e:
        logger.error(f"Constants error: {e}")
        return 1
    except Exception as e:
        logger.error(f"Unexpected error in main: {e}")
        return 1


if __name__ == "__main__":
    exit_code = main()
    sys.exit(exit_code)
