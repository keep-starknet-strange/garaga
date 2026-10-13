import fnmatch
import json
from pathlib import Path

import pytest
import yaml

ROOT = Path(__file__).resolve().parents[2]


def workflow_path_filters(workflow):
    # BaseLoader keeps GitHub's `on` key a string, not a YAML 1.1 boolean.
    config = yaml.load(
        (ROOT / ".github" / "workflows" / f"{workflow}.yml").read_text(),
        Loader=yaml.BaseLoader,
    )
    if workflow == "setup":
        return [config["on"][event]["paths"] for event in ("push", "pull_request")]
    inputs = config["jobs"]["pre_job"]["steps"][0]["with"]
    return [json.loads(inputs["paths"])]


@pytest.mark.parametrize(
    "workflow,path",
    [
        ("node", "tools/npm/garaga_ts/package-lock.json"),
        ("node", "tools/garaga_rs/src/lib.rs"),
        ("node", ".github/workflows/node.yml"),
        (
            "node",
            "hydra/garaga/starknet/groth16_contract_generator/examples/vk_bn254.json",
        ),
        (
            "node",
            "hydra/garaga/starknet/honk_contract_generator/examples/proof_ultra_keccak_zk.bin",
        ),
        ("wasm", "tools/garaga_rs/src/lib.rs"),
        ("wasm", "tools/npm/garaga_ts/Dockerfile"),
        (
            "wasm",
            "tools/npm/integration-test-suite/packages/web-js-esm-react/package.json",
        ),
        ("wasm", "Cargo.toml"),
        ("wasm", "Cargo.lock"),
        ("wasm", ".cargo/config.toml"),
        ("wasm", ".github/workflows/wasm.yml"),
        ("setup", "tools/make/setup.sh"),
        ("setup", ".github/workflows/setup.yml"),
        ("setup", "Makefile"),
        ("setup", "pyproject.toml"),
        ("setup", "docs/PYPI_README.md"),
        ("setup", "uv.lock"),
        ("setup", "Cargo.toml"),
        ("setup", "Cargo.lock"),
        ("setup", ".cargo/config.toml"),
        ("setup", "tools/garaga_rs/Cargo.toml"),
        ("setup", "tools/garaga_rs/src/lib.rs"),
        ("setup", ".pre-commit-config.yaml"),
        ("setup", "hydra/garaga/points.py"),
    ],
)
def test_workflow_runs_for_dependency_changes(workflow, path):
    for paths in workflow_path_filters(workflow):
        assert any(fnmatch.fnmatchcase(path, pattern) for pattern in paths), path


@pytest.mark.parametrize("workflow", ["node", "wasm", "setup"])
@pytest.mark.parametrize(
    "path", ["README.md", "docs/CONTRIBUTING.md", "docs/benchmarks/test_summary.json"]
)
def test_workflow_skips_documentation_only_changes(workflow, path):
    for paths in workflow_path_filters(workflow):
        assert not any(fnmatch.fnmatchcase(path, pattern) for pattern in paths), path
