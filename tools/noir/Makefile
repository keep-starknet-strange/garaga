.PHONY: prove check solidity sol-verify-debug sol-verify-debug-verbose

prove:
	./run.sh --prove

check:
	./run.sh --check

solidity:
	./run.sh --check --solidity

sol-verify-debug: solidity
	forge test --root . -vv

sol-verify-debug-verbose: solidity
	forge test --root . -vvvv
