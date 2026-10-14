import tomllib
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[2]


def workflow(name):
    return yaml.load(
        (ROOT / ".github/workflows" / f"{name}.yml").read_text(),
        Loader=yaml.BaseLoader,
    )


def cache_step(job):
    steps = [
        step for step in job["steps"] if step.get("uses") == "Swatinem/rust-cache@v2"
    ]
    assert len(steps) == 1
    return steps[0]


def test_cache_matches_cargo_target_and_keeps_dependency_hashes():
    job = workflow("wasm")["jobs"]["test-wasm"]
    cache = cache_step(job)
    cargo = tomllib.loads((ROOT / ".cargo/config.toml").read_text())
    root, target = map(str.strip, cache["with"]["workspaces"].split("->"))
    assert (ROOT / root / target).resolve() == (
        ROOT / cargo["build"]["target-dir"]
    ).resolve()
    assert "hashFiles('Cargo.toml')" in cache["with"]["key"]
    # Retain the action's compiler, Cargo.lock/config/member-manifest hashing defaults.
    for option in ("add-rust-environment-hash-key", "add-job-id-key", "cache-targets"):
        assert cache["with"].get(option, "true") == "true"
    for option in ("cache-all-crates", "cache-workspace-crates"):
        assert cache["with"].get(option, "false") == "false"
    steps = job["steps"]
    cache_index = steps.index(cache)
    assert any(
        step.get("uses", "").startswith("actions/checkout@")
        for step in steps[:cache_index]
    )
    assert any(
        step.get("uses", "").startswith("dtolnay/rust-toolchain@")
        for step in steps[:cache_index]
    )
    assert not any(
        "make setup" in step.get("run", "") or "wasm-pack test" in step.get("run", "")
        for step in steps[:cache_index]
    )


def test_wasm_flags_are_available_to_cache_and_build():
    job = workflow("wasm")["jobs"]["test-wasm"]
    assert job["env"]["RUSTFLAGS"] == '--cfg getrandom_backend="wasm_js"'
    assert cache_step(job)["with"]["key"].startswith("wasm-")
    test = next(
        step for step in job["steps"] if "wasm-pack test" in step.get("run", "")
    )
    assert (
        test["run"]
        == "wasm-pack test --node --release --no-default-features --features wasm"
    )
    assert "RUSTFLAGS" not in test.get("env", {})


def test_native_setup_release_and_scarb_jobs_remain_uncached():
    for path in (ROOT / ".github/workflows").glob("*.yml"):
        for name, job in workflow(path.stem)["jobs"].items():
            if (path.stem, name) != ("wasm", "test-wasm"):
                assert not any(
                    step.get("uses", "").startswith("Swatinem/rust-cache@")
                    for step in job.get("steps", [])
                )
            for step in job.get("steps", []):
                if step.get("uses", "").startswith("software-mansion/setup-scarb@"):
                    assert step["with"]["cache"] == "false"
