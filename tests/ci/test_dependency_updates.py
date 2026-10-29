import fnmatch
import json
import subprocess
import tomllib
from pathlib import Path

import pytest
import yaml

ROOT = Path(__file__).resolve().parents[2]
CONFIG = yaml.safe_load((ROOT / ".github" / "dependabot.yml").read_text())
UPDATES = CONFIG["updates"]
TRACKED = {
    ROOT / name
    for name in subprocess.check_output(
        ["git", "ls-files", "-z"], cwd=ROOT, text=True
    ).split("\0")
    if name
}
MANIFESTS = {
    "uv": "pyproject.toml",
    "cargo": "Cargo.toml",
    "npm": "package.json",
    "docker": "Dockerfile",
    "pre-commit": ".pre-commit-config.yaml",
}


def update_directories(update):
    return update.get("directories", [update.get("directory")])


def owned_manifests(update):
    ecosystem = update["package-ecosystem"]
    name = MANIFESTS[ecosystem]
    owned = set()
    for directory in update_directories(update):
        folder = ROOT / directory.lstrip("/")
        manifest = folder / name
        assert manifest in TRACKED, manifest
        owned.add(manifest)
        members = []
        excluded = []
        if ecosystem == "cargo":
            workspace = tomllib.loads(manifest.read_text()).get("workspace", {})
            members = workspace.get("members", [])
            excluded = workspace.get("exclude", [])
        elif ecosystem == "npm":
            members = json.loads(manifest.read_text()).get("workspaces", [])
            if isinstance(members, dict):
                members = members.get("packages", [])
        for pattern in members:
            for member in folder.glob(f"{pattern}/{name}"):
                relative = str(member.parent.relative_to(folder))
                if not any(fnmatch.fnmatchcase(relative, path) for path in excluded):
                    owned.add(member)
    return owned


@pytest.mark.parametrize("ecosystem", MANIFESTS)
def test_updates_cover_tracked_dependency_manifests(ecosystem):
    manifests = {path for path in TRACKED if path.name == MANIFESTS[ecosystem]}
    if ecosystem == "npm":
        # wasm-pack's generated package has no third-party dependencies.
        manifests = {
            path
            for path in manifests
            if any(
                json.loads(path.read_text()).get(key)
                for key in (
                    "dependencies",
                    "devDependencies",
                    "peerDependencies",
                    "optionalDependencies",
                    "workspaces",
                )
            )
        }
    owned = set()
    for update in UPDATES:
        if update["package-ecosystem"] == ecosystem:
            owned.update(owned_manifests(update))
    assert manifests <= owned, sorted(
        str(path.relative_to(ROOT)) for path in manifests - owned
    )


def test_actions_updates_cover_workflows():
    workflows = {
        path for path in TRACKED if path.parent == ROOT / ".github" / "workflows"
    }
    assert workflows
    actions = [
        entry for entry in UPDATES if entry["package-ecosystem"] == "github-actions"
    ]
    assert len(actions) == 1
    assert update_directories(actions[0]) == ["/"]


def test_locked_projects_update_from_their_lockfile_roots():
    names = {"uv": "uv.lock", "cargo": "Cargo.lock", "npm": "package-lock.json"}
    for ecosystem, name in names.items():
        directories = {
            ROOT / directory.lstrip("/")
            for entry in UPDATES
            if entry["package-ecosystem"] == ecosystem
            for directory in update_directories(entry)
        }
        locks = {path for path in TRACKED if path.name == name}
        assert locks
        assert {path.parent for path in locks} <= directories
    assert not any(entry["package-ecosystem"] == "pip" for entry in UPDATES)


def test_weekly_groups_coordinate_projects_without_grouping_major_updates():
    assert CONFIG["version"] == 2
    owners = {}
    for entry in UPDATES:
        ecosystem = entry["package-ecosystem"]
        if ecosystem in MANIFESTS:
            manifests = owned_manifests(entry)
            existing = owners.setdefault(ecosystem, set())
            assert manifests.isdisjoint(existing), sorted(manifests & existing)
            existing.update(manifests)
        directories = update_directories(entry)
        assert len(directories) == len(set(directories))
        assert all(directory.startswith("/") for directory in directories)
        assert entry["schedule"]["interval"] == "weekly"
        assert 0 < entry["open-pull-requests-limit"] <= 3
        groups = entry["groups"].values()
        assert any(group["patterns"] == ["*"] for group in groups)
        assert all(set(group["update-types"]) == {"patch", "minor"} for group in groups)
