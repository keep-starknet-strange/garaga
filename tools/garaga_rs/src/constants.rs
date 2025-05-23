//! Auto-generated constants file. Do not edit manually.
//! Generated from constants.json by tools/make/generate_constants.py

use num_bigint::BigUint;
use num_traits::Num;

/// RISC0 Constants
/// https://github.com/risc0/risc0-ethereum/blob/main/contracts/src/groth16/ControlID.sol
/// release 2.0
pub fn get_risc0_constants() -> (BigUint, BigUint) {
    let risc0_control_root = BigUint::from_str_radix(
        "539032186827B06719244873B17B2D4C122E2D02CFB1994FE958B2523B844576",
        16,
    )
    .unwrap();
    let risc0_bn254_control_id = BigUint::from_str_radix(
        "04446E66D300EB7FB45C9726BB53C793DDA407A62E9601618BB43C5C14657AC0",
        16,
    )
    .unwrap();

    (risc0_control_root, risc0_bn254_control_id)
}

/// SP1 Constants
/// https://github.com/succinctlabs/sp1-contracts/blob/main/contracts/src/v4.0.0-rc.3/SP1VerifierGroth16.sol
pub const SP1_VERIFIER_VERSION: &str = "v4.0.0-rc.3";
pub const SP1_VERIFIER_HASH: &str =
    "0x11b6a09d63d255ad425ee3a7f6211d5ec63fbde9805b40551c3136275b6f4eb4";

/// Additional RISC0 constants for internal use
pub const RISC0_SYSTEM_STATE_ZERO_DIGEST: &str =
    "0xA3ACC27117418996340B84E5A90F3EF4C49D22C79E44AAD822EC9C313E1EB8E2";
pub const RISC0_TAG_DIGEST: &str =
    "0xcb1fefcd1f2d9a64975cbbbf6e161e2914434b0cbb9960b84df5d717e86b48af";
pub const RISC0_OUTPUT_TAG: &str =
    "0x77eafeb366a78b47747de0d7bb176284085ff5564887009a5be63da32d3559d4";

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_risc0_constants() {
        let (control_root, bn254_control_id) = get_risc0_constants();

        // Verify the constants are not zero
        assert!(control_root > BigUint::from(0u32));
        assert!(bn254_control_id > BigUint::from(0u32));

        // Verify they have the expected bit length (256 bits)
        assert!(control_root.bits() <= 256);
        assert!(bn254_control_id.bits() <= 256);
    }

    #[test]
    fn test_sp1_constants() {
        assert_eq!(SP1_VERIFIER_VERSION, "v4.0.0-rc.3");
        assert!(SP1_VERIFIER_HASH.starts_with("0x"));
        assert_eq!(SP1_VERIFIER_HASH.len(), 66); // 0x + 64 hex chars = 66
    }
}
