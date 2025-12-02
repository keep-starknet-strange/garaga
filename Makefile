.PHONY: build test coverage run run-profile generate-constants profile-test benchmarks update-risc0-class-hash

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

update-risc0-class-hash:
	./tools/make/update_risc0_class_hash.sh

steps:
	./tools/make/steps.sh

fmt:
	scarb fmt && cargo fmt

# Profile a specific test and generate performance visualizations
# Usage: make profile-test [TEST=<test_name_filter>] [JOBS=<parallel_jobs>]
# Examples:
#   make profile-test TEST=msm_BN254_1P       (run specific test)
#   make profile-test                         (run all tests)
#   make profile-test TEST=msm_BN254_1P JOBS=4  (run with 4 parallel jobs)
#   make profile-test JOBS=2                  (run all tests with 2 parallel jobs)


# Each job takes ~3GB of ram
DEFAULT_JOBS := 8

profile-test:
	@if [ -z "$(TEST)" ]; then \
		if [ -z "$(JOBS)" ]; then \
			echo "Running all tests with profiling..."; \
			source venv/bin/activate && python tools/profile_tests.py --all --parallel-jobs $(DEFAULT_JOBS) --generate-benchmarks; \
		else \
			echo "Running all tests with profiling using $(JOBS) parallel jobs..."; \
			source venv/bin/activate && python tools/profile_tests.py --all --parallel-jobs $(JOBS) --generate-benchmarks; \
		fi \
	else \
		if [ -z "$(JOBS)" ]; then \
			echo "Running tests with filter: $(TEST)"; \
			source venv/bin/activate && python tools/profile_tests.py $(TEST) --parallel-jobs $(DEFAULT_JOBS) --generate-benchmarks; \
		else \
			echo "Running tests with filter: $(TEST) using $(JOBS) parallel jobs"; \
			source venv/bin/activate && python tools/profile_tests.py $(TEST) --parallel-jobs $(JOBS) --generate-benchmarks; \
		fi \
	fi

# Generate only Cairo benchmarks in README (no profiling)
# Uses existing test data from docs/benchmarks/test_summary.json
benchmarks:
	@echo "Generating Cairo benchmarks from existing test data..."
	python tools/profile_tests.py --benchmarks-only

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

wasm-test-gen:
	./tools/make/wasm-test-gen.sh

maturin:
	maturin develop --release --features python

clean:
	sudo rm -rf build/
	mkdir -p build/
