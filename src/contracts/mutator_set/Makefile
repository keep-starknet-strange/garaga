REPO_ROOT := ../../..

.PHONY: regen build prove verify

regen:
	uv run --active --no-project python scripts/regenerate_verifier.py

build:
	cd zk_program && nargo execute witness

prove:
	cd $(REPO_ROOT) && tools/noir/run.sh --prove --case mutator_set

verify:
	cd $(REPO_ROOT) && tools/noir/run.sh --check --case mutator_set
