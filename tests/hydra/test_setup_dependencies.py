import json
import os
import shutil
import subprocess
import sys
from pathlib import Path
from zipfile import ZipFile

import pytest

SETUP = Path(__file__).resolve().parents[2] / "tools" / "make" / "setup.sh"
CONSTANTS = SETUP.with_name("constants.json")


def wheel(directory, name, version="1.0.0"):
    path = directory / f"{name}-{version}-py3-none-any.whl"
    metadata = f"{name}-{version}.dist-info"
    with ZipFile(path, "w") as archive:
        archive.writestr(
            f"{metadata}/METADATA",
            f"Metadata-Version: 2.1\nName: {name}\nVersion: {version}\n",
        )
        archive.writestr(
            f"{metadata}/WHEEL",
            "Wheel-Version: 1.0\nRoot-Is-Purelib: true\nTag: py3-none-any\n",
        )
        archive.writestr(f"{metadata}/RECORD", "")
    return path


@pytest.fixture
def setup_project(tmp_path):
    if not shutil.which("uv"):
        pytest.skip("setup integration tests require uv")
    dependency = wheel(tmp_path, "locked_dev")
    (tmp_path / "pyproject.toml").write_text(
        '[build-system]\nrequires = []\nbuild-backend = "must_not_build"\n'
        '[project]\nname = "setup_fixture"\nversion = "1.0.0"\n'
        'requires-python = ">=3.11,<3.15"\n'
        '[project.optional-dependencies]\ndev = ["locked-dev"]\n'
        f'[tool.uv.sources]\nlocked-dev = {{ path = "{dependency.name}" }}\n'
    )
    env = {key: value for key, value in os.environ.items() if not key.startswith("UV_")}
    env["UV_OFFLINE"] = "1"
    env.pop("VIRTUAL_ENV", None)
    subprocess.run(
        ["uv", "lock", "--python", sys.executable],
        cwd=tmp_path,
        env=env,
        check=True,
        capture_output=True,
    )
    subprocess.run(
        ["uv", "venv", "--python", sys.executable, "venv"],
        cwd=tmp_path,
        env=env,
        check=True,
        capture_output=True,
    )
    subprocess.run(
        [
            "uv",
            "pip",
            "install",
            "--python",
            str(tmp_path / "venv" / "bin" / "python"),
            str(wheel(tmp_path, "user_tool")),
            str(wheel(tmp_path, "setup_fixture", "0.5.0")),
        ],
        cwd=tmp_path,
        env=env,
        check=True,
        capture_output=True,
    )
    commands = tmp_path / "commands"
    commands.mkdir()
    cairo_version = json.loads(CONSTANTS.read_text())["release_info"]["cairo_version"]
    for name in ("parallel", "cmake", "pre-commit", "maturin", "scarb"):
        command = commands / name
        command.write_text(
            f'#!/bin/sh\necho "{name} $*" >> "$SETUP_COMMAND_LOG"\n'
            + (f'echo "scarb {cairo_version}"\n' if name == "scarb" else "")
        )
        command.chmod(0o755)
    (tmp_path / "src").mkdir()
    (tmp_path / "tools" / "make").mkdir(parents=True)
    shutil.copyfile(CONSTANTS, tmp_path / "tools" / "make" / "constants.json")
    env["PATH"] = str(commands) + os.pathsep + env["PATH"]
    env["SETUP_COMMAND_LOG"] = str(tmp_path / "commands.log")
    return tmp_path, env


def test_setup_uses_locked_dependencies_in_existing_venv(setup_project):
    project, env = setup_project
    lock = (project / "uv.lock").read_bytes()
    interpreter = (project / "venv" / "pyvenv.cfg").read_bytes()

    result = subprocess.run(
        ["bash", str(SETUP)], cwd=project, env=env, capture_output=True, text=True
    )

    assert result.returncode == 0, result.stderr
    packages = subprocess.check_output(
        [
            str(project / "venv" / "bin" / "python"),
            "-c",
            "from importlib.metadata import version; "
            "print(version('locked-dev'), version('user-tool'), version('setup-fixture'))",
        ],
        text=True,
    )
    assert packages.strip() == "1.0.0 1.0.0 0.5.0"
    assert (project / "uv.lock").read_bytes() == lock
    assert (project / "venv" / "pyvenv.cfg").read_bytes() == interpreter
    assert not (project / ".venv").exists()
    assert not (project / "tools" / "make" / "requirements.txt").exists()
    assert (project / "commands.log").read_text().splitlines() == [
        "pre-commit install",
        "maturin develop --release --features python",
        "scarb --version",
    ]


def test_setup_rejects_stale_lock_before_building(setup_project):
    project, env = setup_project
    lock = (project / "uv.lock").read_bytes()
    metadata = project / "pyproject.toml"
    metadata.write_text(
        metadata.read_text().replace('version = "1.0.0"', 'version = "2.0.0"')
    )

    result = subprocess.run(
        ["bash", str(SETUP)], cwd=project, env=env, capture_output=True, text=True
    )

    assert result.returncode != 0
    assert "lockfile" in result.stderr.lower()
    assert (project / "uv.lock").read_bytes() == lock
    assert not (project / "commands.log").exists()
