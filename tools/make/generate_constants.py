#!/usr/bin/env python3
"""
Generate language-specific constants from the centralized constants.json file.
This script is used in the build process to ensure constants are synchronized across all languages.
"""

import json
import os
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
'''

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, "w") as f:
        f.write(python_code)
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


def main():
    """Main function to generate all constants files."""
    constants = load_constants()

    # Define output paths
    project_root = Path(__file__).parent.parent.parent

    python_output = project_root / "hydra" / "garaga" / "starknet" / "constants.py"
    rust_output = project_root / "tools" / "garaga_rs" / "src" / "constants.rs"
    typescript_output = (
        project_root / "tools" / "npm" / "garaga_ts" / "src" / "constants.ts"
    )

    # Generate constants files
    generate_python_constants(constants, str(python_output))
    generate_rust_constants(constants, str(rust_output))
    generate_typescript_constants(constants, str(typescript_output))

    print("All constants files generated successfully!")


if __name__ == "__main__":
    main()
