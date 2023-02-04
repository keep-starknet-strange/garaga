.PHONY: build test coverage
cairo_files = $(shell find ./tests/cairo_programs -name "*.cairo")

build:
	$(MAKE) clean
	./tools/make/build.sh

setup:
	./tools/make/setup.sh

test:
	protostar test

run-profile:
	./tools/make/launch_cairo_files.py

clean:
	rm -rf build/compiled_cairo_files
	mkdir -p build
	mkdir build/compiled_cairo_files

cython:
	./tools/make/cython.sh

go:
	./tools/make/go.sh
