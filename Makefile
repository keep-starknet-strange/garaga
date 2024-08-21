.PHONY: build test coverage run run-profile
cairo_files = $(shell find ./tests/cairo_programs -name "*.cairo")

build:
	$(MAKE) clean
	./tools/make/build.sh

setup:
	./tools/make/setup.sh

bytecode-check:
	./tools/make/bytecode_check.sh

rewrite:
	./tools/make/rewrite.sh

steps:
	./tools/make/steps.sh

ci-e2e:
	./tools/make/ci_e2e.sh

profile:
	@echo "A script to select, run & profile one Cairo file."
	@echo "Thank you for trying to improve Garaga's speed!"
	./tools/make/launch_cairo_files.py -profile

profile-no-compile:
	@echo "A script to select, run & profile one Cairo file. File must be already compiled."
	@echo "Thank you for trying to improve Garaga's speed!"
	./tools/make/launch_cairo_files.py -profile -no_compile
run:
	@echo "A script to select, compile & run one Cairo file"
	@echo "Total number of steps will be shown at the end of the run."
	@echo "Thank you for testing Garaga!"
	./tools/make/launch_cairo_files.py

run-no-compile:
	@echo "A script to select, run one Cairo file without compiling it"
	@echo "Thank you for testing Garaga!"
	./tools/make/launch_cairo_files.py -no_compile

run-pie:
	@echo "A script to select, compile & run one Cairo file with pie mode enabled"
	@echo "Total number of steps will be shown at the end of the run."
	@echo "Thank you for proving Garaga!"
	./tools/make/launch_cairo_files.py -pie
clean:
	rm -rf build/compiled_cairo_files
	mkdir -p build
	mkdir build/compiled_cairo_files

hints:
	./tools/make/gen_hints_document.py
