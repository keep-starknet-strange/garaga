.PHONY: build test coverage run run-profile
cairo_files = $(shell find ./tests/cairo_programs -name "*.cairo")

build:
	$(MAKE) clean
	./tools/make/build.sh

setup:
	./tools/make/setup.sh

test:
	protostar test-cairo0

run-profile:
	@echo "A script to select, compile, run & profile one Cairo file"
	@echo "Thank you for trying to improve Garaga's speed!"
	./tools/make/launch_cairo_files.py -profile

run:
	@echo "A script to select, compile & run one Cairo file"
	@echo "Total number of steps will be shown at the end of the run." 
	@echo "Thank you for testing Garaga!"
	./tools/make/launch_cairo_files.py


clean:
	rm -rf build/compiled_cairo_files
	mkdir -p build
	mkdir build/compiled_cairo_files

cython:
	./tools/make/cython.sh

go:
	./tools/make/go.sh
