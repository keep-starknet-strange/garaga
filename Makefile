.PHONY: build test coverage run run-profile
cairo_files = $(shell find ./tests/cairo_programs -name "*.cairo")

build:
	$(MAKE) clean
	./tools/make/build.sh

setup:
	./tools/make/setup.sh

test:
	protostar test-cairo0

profile:
	@echo "A script to select, compile, run & profile one Cairo file"
	@echo "Thank you for trying to improve Garaga's speed!"
	./tools/make/launch_cairo_files.py -profile

run:
	@echo "A script to select, compile & run one Cairo file"
	@echo "Total number of steps will be shown at the end of the run." 
	@echo "Thank you for testing Garaga!"
	./tools/make/launch_cairo_files.py

run-prove:
	@echo "A script to select, compile, run and prove one Cairo file with Stone"
	@echo "Total number of steps will be shown at the end of the run." 
	@echo "Thank you for proving Garaga!"
	./tools/make/launch_cairo_files.py -prove

run-pie:
	@echo "A script to select, compile & run one Cairo file with pie mode enabled"
	@echo "Total number of steps will be shown at the end of the run." 
	@echo "Thank you for proving Garaga!"
	./tools/make/launch_cairo_files.py -pie
clean:
	rm -rf build/compiled_cairo_files
	mkdir -p build
	mkdir build/compiled_cairo_files

go:
	./tools/make/go.sh

hints:
	./tools/make/gen_hints_document.py