.PHONY: build test coverage run run-profile generate-constants

constants:
	python tools/make/generate_constants.py

setup:
	./tools/make/setup.sh

bytecode-check:
	./tools/make/bytecode_check.sh

check-max-log-n:
	./tools/make/bytecode_check_max_log_n.sh

rewrite:
	./tools/make/rewrite.sh

rewrite-no-tests:
	./tools/make/rewrite.sh no-tests

regen:
	cd src/contracts/mutator_set && make regen

steps:
	./tools/make/steps.sh

fmt:
	scarb fmt && cargo fmt
ci-e2e:
	./tools/make/ci_e2e.sh

ci-hydra:
	./tools/make/ci_hydra.sh

ci-cairo:
	./tools/make/ci_cairo.sh

ci-wasm:
	./tools/make/ci_wasm.sh

wasm:
	./tools/make/wasm.sh
