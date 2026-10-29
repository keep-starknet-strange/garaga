import os
import subprocess
import tomllib
from pathlib import Path

import pytest
import yaml

ROOT = Path(__file__).resolve().parents[2]
BLACK = ROOT / "venv" / "bin" / "black"
PRE_COMMIT = ROOT / "venv" / "bin" / "pre-commit"


@pytest.fixture
def hook_project(tmp_path):
    config = yaml.safe_load((ROOT / ".pre-commit-config.yaml").read_text())
    hooks = [
        (repo, hook)
        for repo in config["repos"]
        for hook in repo["hooks"]
        if hook["id"] == "black"
    ]
    assert len(hooks) == 1
    repo, hook = hooks[0]
    assert repo["repo"] == "local"
    (tmp_path / "venv").symlink_to(ROOT / "venv", target_is_directory=True)
    (tmp_path / "pyproject.toml").write_bytes((ROOT / "pyproject.toml").read_bytes())
    (tmp_path / ".pre-commit-config.yaml").write_text(
        yaml.safe_dump({"repos": [{"repo": "local", "hooks": [hook]}]})
    )
    subprocess.run(["git", "init", "-q"], cwd=tmp_path, check=True)
    env = os.environ.copy()
    env.pop("VIRTUAL_ENV", None)
    commands = tmp_path / "commands"
    commands.mkdir()
    shadow = commands / "black"
    shadow.write_text("#!/bin/sh\necho unexpected-global-black >&2\nexit 1\n")
    shadow.chmod(0o755)
    env["PATH"] = str(commands) + os.pathsep + env["PATH"]
    env["PRE_COMMIT_HOME"] = str(tmp_path / "hook-cache")
    return tmp_path, hook, env


def run_hook(project, env):
    return subprocess.run(
        [str(PRE_COMMIT), "run", "black", "--files", "sample.py", "--verbose"],
        cwd=project,
        env=env,
        capture_output=True,
        text=True,
    )


def test_hook_uses_locked_black_without_another_environment(hook_project):
    project, hook, env = hook_project
    version_hook = dict(hook, args=["--version"], pass_filenames=False)
    (project / ".pre-commit-config.yaml").write_text(
        yaml.safe_dump({"repos": [{"repo": "local", "hooks": [version_hook]}]})
    )
    (project / "sample.py").write_text("value = 1\n")
    subprocess.run(["git", "add", "sample.py"], cwd=project, check=True)
    lock = tomllib.loads((ROOT / "uv.lock").read_text())
    locked_version = next(
        package["version"] for package in lock["package"] if package["name"] == "black"
    )
    cli = subprocess.run(
        [str(BLACK), "--version"], capture_output=True, text=True, check=True
    )

    result = run_hook(project, env)

    assert result.returncode == 0, result.stdout + result.stderr
    assert cli.stdout.split()[1] == locked_version
    assert cli.stdout.strip() in result.stdout
    assert not list((project / "hook-cache").rglob("py_env-*"))
    assert "Installing environment" not in result.stdout + result.stderr


@pytest.mark.parametrize("source", ["values=[1,2,3]\n", "def broken(:\n"])
def test_hook_matches_cli_formatting_and_rejects_invalid_python(hook_project, source):
    project, hook, env = hook_project
    sample = project / "sample.py"
    sample.write_text(source)
    subprocess.run(["git", "add", "sample.py"], cwd=project, check=True)
    cli = subprocess.run(
        [str(BLACK), *hook["args"], "--code", source],
        cwd=project,
        capture_output=True,
        text=True,
    )

    result = run_hook(project, env)

    assert result.returncode == 1, result.stdout + result.stderr
    if cli.returncode == 0:
        assert sample.read_text() == cli.stdout
        assert run_hook(project, env).returncode == 0
    else:
        assert sample.read_text() == source
        assert source.strip() in result.stdout
        assert source.strip() in cli.stderr
