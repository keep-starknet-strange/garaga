import ast
import json
import os
import shutil
import subprocess
import sys
import tomllib
from pathlib import Path

import pytest

from tools.make.sync_toolchain import toolchain_plan

ROOT = Path(__file__).resolve().parents[3]


def versions(root):
    release = json.loads((root / "tools/make/constants.json").read_text())[
        "release_info"
    ]
    return release["cairo_version"], release["starknet_foundry_version"]


@pytest.fixture
def config_repo(tmp_path):
    paths = [path for path, _, _, _ in toolchain_plan(ROOT)]
    paths += [
        Path("tools/make/constants.json"),
        Path("tools/make/sync_toolchain.py"),
        Path("Cargo.toml"),
        Path("tools/garaga_rs/Cargo.toml"),
        Path("pyproject.toml"),
        Path("tools/npm/garaga_ts/package.json"),
    ]
    for path in paths:
        (tmp_path / path).parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(ROOT / path, tmp_path / path)
    sentinel = tmp_path / "src/src/circuits/untouched.cairo"
    sentinel.parent.mkdir(parents=True)
    cairo, _ = versions(tmp_path)
    sentinel.write_text(
        f"// Cryptographic snapshot: {cairo}\nconst HASH: felt252 = 123;\n"
    )
    subprocess.run(["git", "init", "-q", str(tmp_path)], check=True)
    subprocess.run(["git", "-C", str(tmp_path), "add", "."], check=True)
    return tmp_path


def run_sync(root, *args):
    return subprocess.run(
        [sys.executable, str(root / "tools/make/sync_toolchain.py"), *args],
        text=True,
        capture_output=True,
    )


def snapshot(root):
    return {
        path.relative_to(root): path.read_bytes()
        for path in root.rglob("*")
        if path.is_file() and ".git" not in path.relative_to(root).parts
    }


def test_current_toolchain_matches_all_tracked_config():
    plan = toolchain_plan(ROOT)
    assert all(before == after for _, before, after, _ in plan)
    assert Path("hydra/garaga/starknet/constants.py") in {
        path for path, _, _, _ in plan
    }


@pytest.mark.parametrize(
    "path,literal",
    [
        ("Scarb.toml", 'starknet = "{cairo}"'),
        (".tool-versions", "scarb {cairo}"),
        (".github/workflows/cairo.yml", 'scarb-version: "{cairo}"'),
        ("hydra/garaga/starknet/constants.py", 'CAIRO_VERSION = "{cairo}"'),
    ],
)
def test_check_rejects_drift_without_writes(config_repo, path, literal):
    file = config_repo / path
    cairo, _ = versions(config_repo)
    old = literal.format(cairo=cairo)
    assert old in file.read_text()
    file.write_text(file.read_text().replace(old, literal.format(cairo="0.0.0"), 1))
    before = snapshot(config_repo)
    result = run_sync(config_repo, "--check")
    assert result.returncode == 1
    assert f"Drift: {path}" in result.stdout
    assert snapshot(config_repo) == before


def test_sync_updates_every_pin_and_preserves_other_facts(config_repo):
    cairo, foundry = versions(config_repo)
    manifest = config_repo / "Scarb.toml"
    manifest.write_text(
        manifest.read_text()
        + f'\n[package]\nname = "sentinel"\nversion = "{cairo}" # Keep this version\n'
        + f'\n[dependencies]\nother_package = "{foundry}"\n'
    )
    tools = config_repo / ".tool-versions"
    tools.write_text(tools.read_text() + f"unrelated-tool {cairo} # Keep this pin\n")
    source = config_repo / "tools/make/constants.json"
    constants = json.loads(source.read_text())
    next_cairo = f"{1000 + int(cairo.split('.')[0])}.8.7"
    next_foundry = f"{1000 + int(foundry.split('.')[0])}.7.6"
    constants["release_info"]["cairo_version"] = next_cairo
    constants["release_info"]["starknet_foundry_version"] = next_foundry
    source.write_text(json.dumps(constants, indent=4) + "\n")
    before = snapshot(config_repo)
    plan = toolchain_plan(config_repo)
    assert len([path for path, old, new, _ in plan if old != new]) == len(plan)

    result = run_sync(config_repo)
    assert result.returncode == 0, result.stderr
    assert run_sync(config_repo, "--check").returncode == 0
    after = snapshot(config_repo)
    expected = dict(before)
    expected.update({path: updated.encode() for path, _, updated, _ in plan})
    assert after == expected
    for path in config_repo.rglob("Scarb.toml"):
        data = tomllib.loads(path.read_text())
        for section in (
            data.get("dependencies", {}),
            data.get("dev-dependencies", {}),
            data.get("workspace", {}).get("dependencies", {}),
        ):
            for key in ("starknet", "cairo_test", "assert_macros", "cairo_execute"):
                if key in section:
                    assert section[key] == next_cairo
            if "snforge_std" in section:
                assert section["snforge_std"] == next_foundry
    for path in config_repo.rglob(".tool-versions"):
        for line in path.read_text().splitlines():
            key, value = line.split(maxsplit=1)
            if key == "scarb":
                assert value == next_cairo
            elif key == "starknet-foundry":
                assert value == next_foundry
    namespace = {
        node.targets[0].id: ast.literal_eval(node.value)
        for node in ast.parse(
            (config_repo / "hydra/garaga/starknet/constants.py").read_text()
        ).body
        if isinstance(node, ast.Assign)
        and isinstance(node.targets[0], ast.Name)
        and node.targets[0].id in {"CAIRO_VERSION", "STARKNET_FOUNDRY_VERSION"}
    }
    assert namespace == {
        "CAIRO_VERSION": next_cairo,
        "STARKNET_FOUNDRY_VERSION": next_foundry,
    }
    assert f'version = "{cairo}" # Keep this version' in manifest.read_text()
    assert f'other_package = "{foundry}"' in manifest.read_text()
    assert f"unrelated-tool {cairo} # Keep this pin" in tools.read_text()
    assert run_sync(config_repo).stdout.count("Sync:") == 0


def test_unknown_manifest_format_stops_before_any_write(config_repo):
    tools = config_repo / ".tool-versions"
    cairo, _ = versions(config_repo)
    tools.write_text(tools.read_text().replace(f"scarb {cairo}", "scarb 0.0.0"))
    manifest = config_repo / "Scarb.toml"
    manifest.write_text(
        manifest.read_text().replace(
            f'starknet = "{cairo}"',
            f'starknet = {{ version = "{cairo}", optional = true }}',
        )
    )
    before = snapshot(config_repo)
    result = run_sync(config_repo)
    assert result.returncode == 1
    assert (
        "Unsupported toolchain dependency: [workspace.dependencies] starknet"
        in result.stderr
    )
    assert snapshot(config_repo) == before


def test_discovers_tracked_config_outside_src(config_repo):
    cairo, foundry = versions(config_repo)
    example = config_repo / "examples/new-project"
    example.mkdir(parents=True)
    manifest = example / "Scarb.toml"
    manifest.write_text(
        '[package]\nname = "new"\nversion = "0.1.0"\n'
        '[dependencies]\nstarknet = "0.0.0"\n'
        '[dev-dependencies]\nsnforge_std = "0.0.0"\n'
    )
    tools = example / ".tool-versions"
    tools.write_text("scarb 0.0.0\nstarknet-foundry 0.0.0\nother-tool 0.0.0\n")
    subprocess.run(["git", "-C", str(config_repo), "add", "examples"], check=True)
    result = run_sync(config_repo, "--check")
    assert result.returncode == 1
    assert "Drift: examples/new-project/Scarb.toml" in result.stdout
    assert "Drift: examples/new-project/.tool-versions" in result.stdout
    assert run_sync(config_repo).returncode == 0
    assert tomllib.loads(manifest.read_text())["dependencies"]["starknet"] == cairo
    assert (
        tomllib.loads(manifest.read_text())["dev-dependencies"]["snforge_std"]
        == foundry
    )
    assert (
        tools.read_text()
        == f"scarb {cairo}\nstarknet-foundry {foundry}\nother-tool 0.0.0\n"
    )


def test_invalid_canonical_version_stops_before_any_write(config_repo):
    source = config_repo / "tools/make/constants.json"
    constants = json.loads(source.read_text())
    constants["release_info"]["cairo_version"] = "not-a-version"
    source.write_text(json.dumps(constants))
    before = snapshot(config_repo)
    result = run_sync(config_repo)
    assert result.returncode == 1
    assert "major.minor.patch" in result.stderr
    assert snapshot(config_repo) == before


@pytest.mark.parametrize(
    "installed", ["9.8.7", "9.8.7 (commit)", "9.8.70 (commit)", ""]
)
def test_setup_warning_reads_canonical_version(config_repo, installed):
    source = config_repo / "tools/make/constants.json"
    constants = json.loads(source.read_text())
    constants["release_info"]["cairo_version"] = "9.8.7"
    source.write_text(json.dumps(constants))
    fake_bin = config_repo / "bin"
    fake_bin.mkdir()
    (fake_bin / "python").symlink_to(sys.executable)
    scarb = fake_bin / "scarb"
    scarb.write_text(f"#!/bin/sh\nprintf '%s\\n' 'scarb {installed}'\n")
    scarb.chmod(0o755)
    env = os.environ | {"PATH": f"{fake_bin}:{os.environ['PATH']}"}
    block = (
        (ROOT / "tools/make/setup.sh")
        .read_text()
        .split("# Check Scarb version and print warning if it's not", 1)[1]
    )
    result = subprocess.run(
        ["bash", "-e", "-c", block],
        cwd=config_repo,
        env=env,
        text=True,
        capture_output=True,
    )
    assert result.returncode == 0, result.stderr
    if installed in {"9.8.7", "9.8.7 (commit)"}:
        assert "Warning:" not in result.stdout
    else:
        assert "Please install Scarb 9.8.7 before continuing" in result.stdout
