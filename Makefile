SHELL := /bin/bash
ACTIVATE := source venv/bin/activate &&

.PHONY: build test coverage run run-profile generate-constants profile-test benchmarks update-risc0-class-hash

constants:
	$(ACTIVATE) python tools/make/generate_constants.py

setup:
	./tools/make/setup.sh

bytecode-check:
	./tools/make/bytecode_check.sh

check-max-log-n:
	./tools/make/bytecode_check_max_log_n.sh

rewrite:
	$(ACTIVATE) ./tools/make/rewrite.sh

rewrite-no-tests:
	$(ACTIVATE) ./tools/make/rewrite.sh no-tests

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
# Each job takes ~3GB of ram
DEFAULT_JOBS := 8

profile-test:
	@JOBS_VAL=$${JOBS:-$(DEFAULT_JOBS)}; \
	if [ -z "$(TEST)" ]; then \
		echo "Running all tests with profiling ($$JOBS_VAL jobs)..."; \
		$(ACTIVATE) python tools/profile_tests.py --all --parallel-jobs $$JOBS_VAL --generate-benchmarks; \
	else \
		echo "Running tests with filter: $(TEST) ($$JOBS_VAL jobs)"; \
		$(ACTIVATE) python tools/profile_tests.py $(TEST) --parallel-jobs $$JOBS_VAL --generate-benchmarks; \
	fi

benchmarks:
	@echo "Generating Cairo benchmarks from existing test data..."
	$(ACTIVATE) python tools/profile_tests.py --benchmarks-only

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
	$(ACTIVATE) maturin develop --release --features python

clean:
	sudo rm -rf build/
	mkdir -p build/
