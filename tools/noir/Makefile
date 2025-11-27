# ==============================================================================
# Solidity Verifier Debugging
# ==============================================================================
# Run the Solidity ZK Honk verifier with the test proof and log variables.
# This is useful for comparing intermediate values with the Python implementation.
#
# Prerequisites:
#   1. Install Foundry: curl -L https://foundry.paradigm.xyz | bash && foundryup
#   2. Install forge-std: forge install foundry-rs/forge-std --no-commit
#
# Usage:
#   make sol-verify-debug              # Run with full logging
#   make sol-verify-debug-detailed     # Run with detailed proof parsing
#
# To add custom logging, edit tools/noir/hello/target/contract_ultra_keccak_zk.sol:
#   1. Add: import "forge-std/console.sol";
#   2. Add: console.log("varName:", value);  or  console.log("Fr:", Fr.unwrap(frValue));
#   3. Run: make sol-verify-debug
#
# See tools/noir/hello/README.md for more details.
# ==============================================================================

sol-verify-debug:
	@echo "=== Running Solidity ZK Honk Verifier Test ==="
	@echo "See tools/noir/hello/README.md for how to add custom logging"
	@echo ""
	cd hello && forge test -vv --match-test testVerifyProof

sol-verify-debug-verbose:
	@echo "=== Running Solidity ZK Honk Verifier Test (verbose) ==="
	cd hello && forge test -vvvv --match-test testVerifyProof

sol-verify-debug-detailed:
	@echo "=== Running Detailed Proof Parsing Test ==="
	cd hello && forge test -vv --match-test testVerifyProofWithDetailedLogging

sol-verify-setup:
	@echo "=== Setting up Foundry for Solidity testing ==="
	@if [ -d "hello/lib/forge-std" ]; then \
		echo "forge-std already installed"; \
	else \
		cd hello && forge install foundry-rs/forge-std --no-git; \
	fi
	@echo "Setup complete! Now run: make sol-verify-debug"
