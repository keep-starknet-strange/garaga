//! Auto-generated constants file from constants.json. Do not edit manually.

use num_bigint::BigUint;
use num_traits::Num;

// RISC0 Constants
// https://github.com/risc0/risc0-ethereum/blob/v3.0.1/contracts/src/groth16/ControlID.sol
// release v3.0.1
pub fn get_risc0_constants() -> (BigUint, BigUint) {
    let risc0_control_root = BigUint::from_str_radix(
        "A54DC85AC99F851C92D7C96D7318AF41DBE7C0194EDFCC37EB4D422A998C1F56",
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

// SP1 Constants
// https://github.com/succinctlabs/sp1-contracts/blob/main/contracts/src/v6.1.0/SP1VerifierGroth16.sol
pub const SP1_VERIFIER_VERSION: &str = "v6.1.0";
pub const SP1_SDK_VERSION: &str = "6.10.0";
pub const SP1_VK_ROOT: [u8; 32] = [
    0, 47, 133, 14, 233, 152, 151, 77, 108, 192, 14, 80, 205, 8, 20, 176, 152, 192, 91, 250, 222,
    70, 109, 40, 87, 50, 64, 208, 87, 242, 83, 82,
];
pub const SP1_VERIFIER_HASH: &str =
    "0x4388a21c687fdd5f218d7e3d13190cac4c5355818d3605fd5fb811df468ee696";

// Additional RISC0 constants for internal use
pub const RISC0_SYSTEM_STATE_ZERO_DIGEST: &str =
    "0xA3ACC27117418996340B84E5A90F3EF4C49D22C79E44AAD822EC9C313E1EB8E2";
pub const RISC0_TAG_DIGEST: &str =
    "0xcb1fefcd1f2d9a64975cbbbf6e161e2914434b0cbb9960b84df5d717e86b48af";
pub const RISC0_OUTPUT_TAG: &str =
    "0x77eafeb366a78b47747de0d7bb176284085ff5564887009a5be63da32d3559d4";
