"""
Auto-generated constants file. Do not edit manually.
Generated from constants.json by tools/make/generate_constants.py
"""

# RISC0 Constants
# https://github.com/risc0/risc0-ethereum/blob/main/contracts/src/groth16/ControlID.sol
# release 2.0
RISC0_CONTROL_ROOT = 0x539032186827B06719244873B17B2D4C122E2D02CFB1994FE958B2523B844576
RISC0_BN254_CONTROL_ID = (
    0x04446E66D300EB7FB45C9726BB53C793DDA407A62E9601618BB43C5C14657AC0
)

# SP1 Constants
# https://github.com/succinctlabs/sp1-contracts/blob/main/contracts/src/v4.0.0-rc.3/SP1VerifierGroth16.sol
SP1_VERIFIER_VERSION: str = "v4.0.0-rc.3"
SP1_VERIFIER_HASH: bytes = bytes.fromhex(
    "11b6a09d63d255ad425ee3a7f6211d5ec63fbde9805b40551c3136275b6f4eb4"
)

# Additional RISC0 constants for internal use
RISC0_SYSTEM_STATE_ZERO_DIGEST = (
    "0xA3ACC27117418996340B84E5A90F3EF4C49D22C79E44AAD822EC9C313E1EB8E2"
)
RISC0_TAG_DIGEST = "0xcb1fefcd1f2d9a64975cbbbf6e161e2914434b0cbb9960b84df5d717e86b48af"
RISC0_OUTPUT_TAG = "0x77eafeb366a78b47747de0d7bb176284085ff5564887009a5be63da32d3559d4"
