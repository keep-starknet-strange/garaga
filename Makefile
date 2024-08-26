.PHONY: build test coverage run run-profile

build:
	$(MAKE) clean

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

clean:
	rm -rf build/compiled_cairo_files
	mkdir -p build
	mkdir build/compiled_cairo_files

hints:
	./tools/make/gen_hints_document.py
