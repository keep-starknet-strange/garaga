#!/usr/bin/env python3
"""
Generate language-specific constants from the centralized constants.json file.
This script is used in the build process to ensure constants are synchronized across all languages.

Additionally, this script syncs version numbers across:
- pyproject.toml (Python package version)
- tools/garaga_rs/Cargo.toml (Rust crate version)
- tools/npm/garaga_ts/package.json (TypeScript package version)
- tools/npm/garaga_ts/README.md (API documentation links)
- docs/PYPI_README.md (pip install commands)
"""

import json
import os
import re
from pathlib import Path
from typing import Any, Dict


def load_constants() -> Dict[str, Any]:
    """Load constants from the centralized JSON file."""
    constants_file = Path(__file__).parent / "constants.json"
    with open(constants_file, "r") as f:
        return json.load(f)


def generate_python_constants(constants: Dict[str, Any], output_path: str):
    """Generate Python constants file."""
    risc0 = constants["risc0"]
    sp1 = constants["sp1"]

    python_code = f'''"""
Auto-generated constants file. Do not edit manually.
Generated from constants.json by tools/make/generate_constants.py
"""

# RISC0 Constants
# https://github.com/risc0/risc0-ethereum/blob/main/contracts/src/groth16/ControlID.sol
# release {constants["release_info"]["risc0_release"]}
RISC0_CONTROL_ROOT = {risc0["control_root"]}
RISC0_BN254_CONTROL_ID = {risc0["bn254_control_id"]}

# SP1 Constants
# https://github.com/succinctlabs/sp1-contracts/blob/main/contracts/src/{sp1["verifier_version"]}/SP1VerifierGroth16.sol
SP1_VERIFIER_VERSION: str = "{sp1["verifier_version"]}"
SP1_VERIFIER_HASH: bytes = bytes.fromhex(
    "{sp1["verifier_hash"][2:]}"
)

# Additional RISC0 constants for internal use
RISC0_SYSTEM_STATE_ZERO_DIGEST = "{risc0["system_state_zero_digest"]}"
RISC0_TAG_DIGEST = "{risc0["tag_digest"]}"
RISC0_OUTPUT_TAG = "{risc0["output_tag"]}"

# Cairo version
CAIRO_VERSION = "{constants["release_info"]["cairo_version"]}"

# Starknet Foundry version
STARKNET_FOUNDRY_VERSION = "{constants["release_info"]["starknet_foundry_version"]}"

# Noir versions
BB_VERSION = "{constants["noir"]["bb_version"]}"
BBUP_VERSION = "{constants["noir"]["bbup_version"]}"
NARGO_VERSION = "{constants["noir"]["nargo_version"]}"
'''

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, "w") as f:
        f.write(python_code)
    # Run black on the generated file to ensure formatting
    try:
        import subprocess

        subprocess.run(
            ["black", output_path],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
    except Exception as e:
        print(f"Warning: Could not run black on {output_path}: {e}")
    print(f"Generated Python constants: {output_path}")


def generate_rust_constants(constants: Dict[str, Any], output_path: str):
    """Generate Rust constants file."""
    risc0 = constants["risc0"]
    sp1 = constants["sp1"]

    rust_code = f"""//! Auto-generated constants file. Do not edit manually.
//! Generated from constants.json by tools/make/generate_constants.py

use num_bigint::BigUint;
use num_traits::Num;

/// RISC0 Constants
/// https://github.com/risc0/risc0-ethereum/blob/main/contracts/src/groth16/ControlID.sol
/// release {constants["release_info"]["risc0_release"]}
pub fn get_risc0_constants() -> (BigUint, BigUint) {{
    let risc0_control_root = BigUint::from_str_radix(
        "{risc0["control_root"][2:]}",
        16,
    )
    .unwrap();
    let risc0_bn254_control_id = BigUint::from_str_radix(
        "{risc0["bn254_control_id"][2:]}",
        16,
    )
    .unwrap();

    (risc0_control_root, risc0_bn254_control_id)
}}

/// SP1 Constants
/// https://github.com/succinctlabs/sp1-contracts/blob/main/contracts/src/{sp1["verifier_version"]}/SP1VerifierGroth16.sol
pub const SP1_VERIFIER_VERSION: &str = "{sp1["verifier_version"]}";
pub const SP1_VERIFIER_HASH: &str = "{sp1["verifier_hash"]}";

/// Additional RISC0 constants for internal use
pub const RISC0_SYSTEM_STATE_ZERO_DIGEST: &str = "{risc0["system_state_zero_digest"]}";
pub const RISC0_TAG_DIGEST: &str = "{risc0["tag_digest"]}";
pub const RISC0_OUTPUT_TAG: &str = "{risc0["output_tag"]}";

#[cfg(test)]
mod tests {{
    use super::*;

    #[test]
    fn test_risc0_constants() {{
        let (control_root, bn254_control_id) = get_risc0_constants();

        // Verify the constants are not zero
        assert!(control_root > BigUint::from(0u32));
        assert!(bn254_control_id > BigUint::from(0u32));

        // Verify they have the expected bit length (256 bits)
        assert!(control_root.bits() <= 256);
        assert!(bn254_control_id.bits() <= 256);
    }}

    #[test]
    fn test_sp1_constants() {{
        assert_eq!(SP1_VERIFIER_VERSION, "{sp1["verifier_version"]}");
        assert!(SP1_VERIFIER_HASH.starts_with("0x"));
        assert_eq!(SP1_VERIFIER_HASH.len(), 66); // 0x + 64 hex chars = 66
    }}
}}
"""

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, "w") as f:
        f.write(rust_code)
    print(f"Generated Rust constants: {output_path}")

    # Run cargo fmt on the output file to ensure proper formatting
    import subprocess

    try:
        subprocess.run(
            ["cargo", "fmt", "--", str(output_path)],
            check=True,
            cwd=os.path.dirname(output_path),
        )
        print(f"Ran cargo fmt on: {output_path}")
    except Exception as e:
        print(f"Warning: cargo fmt failed on {output_path}: {e}")


def generate_typescript_constants(constants: Dict[str, Any], output_path: str):
    """Generate TypeScript constants file."""
    risc0 = constants["risc0"]
    sp1 = constants["sp1"]

    typescript_code = f"""/**
 * Auto-generated constants file. Do not edit manually.
 * Generated from constants.json by tools/make/generate_constants.py
 */

// RISC0 Constants
// https://github.com/risc0/risc0-ethereum/blob/main/contracts/src/groth16/ControlID.sol
// release {constants["release_info"]["risc0_release"]}
export const RISC0_CONTROL_ROOT = BigInt("{risc0["control_root"]}");
export const RISC0_BN254_CONTROL_ID = BigInt("{risc0["bn254_control_id"]}");

// SP1 Constants
// https://github.com/succinctlabs/sp1-contracts/blob/main/contracts/src/{sp1["verifier_version"]}/SP1VerifierGroth16.sol
export const SP1_VERIFIER_VERSION: string = "{sp1["verifier_version"]}";
export const SP1_VERIFIER_HASH: string = "{sp1["verifier_hash"]}";

// Additional RISC0 constants for internal use
export const RISC0_SYSTEM_STATE_ZERO_DIGEST = Uint8Array.from(Buffer.from(
    "{risc0["system_state_zero_digest"][2:]}",
    "hex"
));
export const RISC0_TAG_DIGEST = "{risc0["tag_digest"]}";
export const RISC0_OUTPUT_TAG = "{risc0["output_tag"]}";
"""

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, "w") as f:
        f.write(typescript_code)
    print(f"Generated TypeScript constants: {output_path}")


def update_readme_version(constants: Dict[str, Any], readme_path: str):
    """
    Update the version in the PYPI README file robustly.

    This function uses regex patterns to find and replace version strings
    in pip install commands, making it resilient to formatting changes.
    """
    version = constants["release_info"]["garaga_version"]

    try:
        with open(readme_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Pattern to match pip install garaga==X.Y.Z
        # This pattern is flexible and handles various formatting
        pip_install_pattern = (
            r"(pip\s+install\s+garaga==)[\d]+\.[\d]+\.[\d]+(?:[\w\-\.]*)?"
        )
        replacement = f"\\g<1>{version}"

        # Count matches before replacement for verification
        matches = re.findall(pip_install_pattern, content)
        if not matches:
            print(f"Warning: No pip install garaga== pattern found in {readme_path}")
            return False

        # Perform the replacement
        updated_content = re.sub(pip_install_pattern, replacement, content)

        # Verify that content actually changed
        if content == updated_content:
            print(f"No version update needed in {readme_path} (already {version})")
            return True

        # Write the updated content back
        with open(readme_path, "w", encoding="utf-8") as f:
            f.write(updated_content)

        print(f"Updated README version to {version} in {readme_path}")
        print(f"  - Updated {len(matches)} pip install command(s)")
        return True

    except FileNotFoundError:
        print(f"Error: README file not found at {readme_path}")
        return False
    except Exception as e:
        print(f"Error updating README version: {e}")
        return False


def update_pyproject_version(constants: Dict[str, Any], pyproject_path: str):
    """
    Update the version in pyproject.toml file robustly.

    This function updates the version field in the [tool.poetry] section.
    """
    version = constants["release_info"]["garaga_version"]

    try:
        with open(pyproject_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Pattern to match version = "X.Y.Z" in pyproject.toml
        # This handles both single and double quotes
        version_pattern = (
            r'(version\s*=\s*["\'])[\d]+\.[\d]+\.[\d]+(?:[\w\-\.]*)?(["\'])'
        )
        replacement = f"\\g<1>{version}\\g<2>"

        # Count matches before replacement
        matches = re.findall(version_pattern, content)
        if not matches:
            print(f"Warning: No version field found in {pyproject_path}")
            return False

        # Perform the replacement
        updated_content = re.sub(version_pattern, replacement, content)

        # Verify that content actually changed
        if content == updated_content:
            print(f"No version update needed in {pyproject_path} (already {version})")
            return True

        # Write the updated content back
        with open(pyproject_path, "w", encoding="utf-8") as f:
            f.write(updated_content)

        print(f"Updated pyproject.toml version to {version} in {pyproject_path}")
        return True

    except FileNotFoundError:
        print(f"Error: pyproject.toml file not found at {pyproject_path}")
        return False
    except Exception as e:
        print(f"Error updating pyproject.toml version: {e}")
        return False


def update_cargo_toml_version(constants: Dict[str, Any], cargo_toml_path: str):
    """
    Update the version in Cargo.toml file robustly.

    This function updates ONLY the version field in the [package] section,
    not dependency versions.
    """
    version = constants["release_info"]["garaga_version"]

    try:
        with open(cargo_toml_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Pattern to match version = "X.Y.Z" ONLY in the [package] section
        # This uses a more specific pattern that looks for the package section
        # and stops at the next section or end of file
        package_section_pattern = r'(\[package\].*?^version\s*=\s*["\'])[\d]+\.[\d]+\.[\d]+(?:[\w\-\.]*)?(["\'])'
        replacement = f"\\g<1>{version}\\g<2>"

        # Count matches before replacement
        matches = re.findall(package_section_pattern, content, re.MULTILINE | re.DOTALL)
        if not matches:
            print(f"Warning: No package version field found in {cargo_toml_path}")
            return False

        # Perform the replacement
        updated_content = re.sub(
            package_section_pattern,
            replacement,
            content,
            flags=re.MULTILINE | re.DOTALL,
        )

        # Verify that content actually changed
        if content == updated_content:
            print(f"No version update needed in {cargo_toml_path} (already {version})")
            return True

        # Write the updated content back
        with open(cargo_toml_path, "w", encoding="utf-8") as f:
            f.write(updated_content)

        print(f"Updated Cargo.toml package version to {version} in {cargo_toml_path}")
        return True

    except FileNotFoundError:
        print(f"Error: Cargo.toml file not found at {cargo_toml_path}")
        return False
    except Exception as e:
        print(f"Error updating Cargo.toml version: {e}")
        return False


def update_package_json_version(constants: Dict[str, Any], package_json_path: str):
    """
    Update the version in package.json file robustly.

    This function updates the version field in the package.json file.
    """
    version = constants["release_info"]["garaga_version"]

    try:
        with open(package_json_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Pattern to match "version": "X.Y.Z" in package.json
        # This handles both single and double quotes
        version_pattern = (
            r'("version"\s*:\s*["\'])[\d]+\.[\d]+\.[\d]+(?:[\w\-\.]*)?(["\'])'
        )
        replacement = f"\\g<1>{version}\\g<2>"

        # Count matches before replacement
        matches = re.findall(version_pattern, content)
        if not matches:
            print(f"Warning: No version field found in {package_json_path}")
            return False

        # Perform the replacement
        updated_content = re.sub(version_pattern, replacement, content)

        # Verify that content actually changed
        if content == updated_content:
            print(
                f"No version update needed in {package_json_path} (already {version})"
            )
            return True

        # Write the updated content back
        with open(package_json_path, "w", encoding="utf-8") as f:
            f.write(updated_content)

        print(f"Updated package.json version to {version} in {package_json_path}")
        return True

    except FileNotFoundError:
        print(f"Error: package.json file not found at {package_json_path}")
        return False
    except Exception as e:
        print(f"Error updating package.json version: {e}")
        return False


def update_npm_readme_version(constants: Dict[str, Any], npm_readme_path: str):
    """
    Update the npm README.md file to include version-specific API links.

    This function adds or updates links to the API documentation for the specific version.
    """
    version = constants["release_info"]["garaga_version"]

    try:
        with open(npm_readme_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Create the API link with clear call-to-action
        api_section = f"""📋 **For complete API documentation with examples, see:** [API Reference](https://github.com/keep-starknet-strange/garaga/blob/v{version}/tools/npm/garaga_ts/src/node/api.ts)

"""

        # Pattern to find the Available Functions section
        available_functions_pattern = r"(## Available Functions\s*\n\n?)"

        # Check if the section exists
        functions_match = re.search(available_functions_pattern, content)
        if not functions_match:
            print(
                f"Warning: Available Functions section not found in {npm_readme_path}"
            )
            return False

        # Check if API reference already exists in this section
        # Look for the pattern from the start of Available Functions to the next section
        next_section_pattern = r"(## Available Functions\s*\n)(.*?)(\n## |$)"
        section_match = re.search(next_section_pattern, content, re.DOTALL)

        if section_match:
            current_section_content = section_match.group(2)
            api_reference_pattern = r"📋 \*\*For complete API documentation.*?\n\n"

            if re.search(api_reference_pattern, current_section_content):
                # Update existing API reference
                updated_section = re.sub(
                    api_reference_pattern, api_section, current_section_content
                )
                updated_content = (
                    content[: section_match.start(2)]
                    + updated_section
                    + content[section_match.end(2) :]
                )
            else:
                # Add API reference at the beginning of the section
                updated_content = (
                    content[: functions_match.end()]
                    + api_section
                    + content[functions_match.end() :]
                )
        else:
            # Fallback: just add after the header
            updated_content = (
                content[: functions_match.end()]
                + api_section
                + content[functions_match.end() :]
            )

        # Verify that content actually changed
        if content == updated_content:
            print(
                f"No API link update needed in {npm_readme_path} (already v{version})"
            )
            return True

        # Write the updated content back
        with open(npm_readme_path, "w", encoding="utf-8") as f:
            f.write(updated_content)

        print(
            f"Updated npm README.md API link to v{version} in Available Functions section"
        )
        return True

    except FileNotFoundError:
        print(f"Error: npm README.md file not found at {npm_readme_path}")
        return False
    except Exception as e:
        print(f"Error updating npm README.md: {e}")
        return False


def update_noir_docs_version(constants: Dict[str, Any], noir_docs_path: str):
    """
    Update the Noir documentation file with current versions.

    This function updates the Garaga CLI, Noir, and Barretenberg versions
    in the requirements section of the Noir documentation.
    """
    garaga_version = constants["release_info"]["garaga_version"]
    nargo_version = constants["noir"]["nargo_version"]
    bbup_version = constants["noir"]["bbup_version"]

    try:
        with open(noir_docs_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Track if any changes were made
        changes_made = False
        updated_content = content

        # Update Garaga CLI version
        # Pattern: "version X.Y.Z (install with `pip install garaga==X.Y.Z`" (handles incomplete backticks too)
        garaga_pattern = r"(version\s+)[\d]+\.[\d]+\.[\d]+(?:[\w\-\.]*)?(\s+\(install with `pip install garaga==)[\d]+\.[\d]+\.[\d]+(?:[\w\-\.]*)?(`?)"
        garaga_replacement = f"\\g<1>{garaga_version}\\g<2>{garaga_version}\\g<3>"

        new_content = re.sub(garaga_pattern, garaga_replacement, updated_content)
        if new_content != updated_content:
            changes_made = True
            updated_content = new_content

        # Update Noir version - use multiple simple replacements
        # Replace all instances of old version with new version
        noir_old_version = re.search(
            r"Noir\s+([\d]+\.[\d]+\.[\d]+(?:-[\w\.]+)?)", updated_content
        )
        if noir_old_version:
            old_version = noir_old_version.group(1)
            if old_version != nargo_version:
                updated_content = updated_content.replace(old_version, nargo_version)
                changes_made = True

        # Update Barretenberg version - use multiple simple replacements
        bb_old_version = re.search(
            r"Barretenberg\s+([\d]+\.[\d]+\.[\d]+(?:-[\w\.]+)?)", updated_content
        )
        if bb_old_version:
            old_version = bb_old_version.group(1)
            if old_version != bbup_version:
                updated_content = updated_content.replace(old_version, bbup_version)
                changes_made = True

        # Verify that content actually changed
        if not changes_made:
            print(f"No version updates needed in {noir_docs_path} (already current)")
            return True

        # Write the updated content back
        with open(noir_docs_path, "w", encoding="utf-8") as f:
            f.write(updated_content)

        print(f"Updated Noir documentation versions in {noir_docs_path}")
        print(f"  - Garaga CLI: {garaga_version}")
        print(f"  - Noir: {nargo_version}")
        print(f"  - Barretenberg: {bbup_version}")
        return True

    except FileNotFoundError:
        print(f"Error: Noir docs file not found at {noir_docs_path}")
        return False
    except Exception as e:
        print(f"Error updating Noir docs versions: {e}")
        return False


def main():
    """Main function to generate all constants files and update version references."""
    constants = load_constants()

    # Define output paths
    project_root = Path(__file__).parent.parent.parent

    python_output = project_root / "hydra" / "garaga" / "starknet" / "constants.py"
    rust_output = project_root / "tools" / "garaga_rs" / "src" / "constants.rs"
    typescript_output = (
        project_root / "tools" / "npm" / "garaga_ts" / "src" / "constants.ts"
    )
    readme_path = project_root / "docs" / "PYPI_README.md"
    pyproject_path = project_root / "pyproject.toml"
    garaga_rs_cargo_path = project_root / "tools" / "garaga_rs" / "Cargo.toml"
    package_json_path = project_root / "tools" / "npm" / "garaga_ts" / "package.json"
    npm_readme_path = project_root / "tools" / "npm" / "garaga_ts" / "README.md"
    noir_docs_path = (
        project_root
        / "docs"
        / "gitbook"
        / "deploy-your-snark-verifier-on-starknet"
        / "noir.md"
    )

    # Generate constants files
    generate_python_constants(constants, str(python_output))
    generate_rust_constants(constants, str(rust_output))
    generate_typescript_constants(constants, str(typescript_output))

    # Update version references
    results = []
    results.append(("PYPI README", update_readme_version(constants, str(readme_path))))
    results.append(
        ("pyproject.toml", update_pyproject_version(constants, str(pyproject_path)))
    )
    results.append(
        ("Cargo.toml", update_cargo_toml_version(constants, str(garaga_rs_cargo_path)))
    )
    results.append(
        ("package.json", update_package_json_version(constants, str(package_json_path)))
    )
    results.append(
        ("npm README", update_npm_readme_version(constants, str(npm_readme_path)))
    )
    results.append(
        ("Noir docs", update_noir_docs_version(constants, str(noir_docs_path)))
    )

    failed = [(name, result) for name, result in results if not result]
    if failed:
        print("\nWarning: Some updates failed:")
        for name, _ in failed:
            print(f"  - {name}")

    if not failed:
        print("All constants files and version references updated successfully!")
    else:
        print(
            f"\n{len(results) - len(failed)}/{len(results)} updates completed successfully."
        )


if __name__ == "__main__":
    main()
