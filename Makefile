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
	python ./tools/make/launch_cairo_files.py

clean:
	rm -rf build
	mkdir build


