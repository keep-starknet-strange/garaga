import os
import shutil
import subprocess
import sys
import tarfile
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[2]


@pytest.mark.parametrize(
    "target",
    [
        "aarch64-apple-darwin",
        "x86_64-apple-darwin",
        "x86_64-unknown-linux-gnu",
        "wasm32-unknown-unknown",
    ],
)
def test_cargo_disables_strip_only_for_macos(tmp_path, target):
    if not shutil.which("cargo"):
        pytest.skip("native build configuration checks require Cargo")
    (tmp_path / ".cargo").mkdir()
    shutil.copyfile(ROOT / ".cargo/config.toml", tmp_path / ".cargo/config.toml")
    (tmp_path / "src").mkdir()
    (tmp_path / "src/lib.rs").write_text("")
    (tmp_path / "Cargo.toml").write_text(
        '[package]\nname = "config_probe"\nversion = "0.1.0"\nedition = "2021"\n'
        "[profile.release]\nopt-level = 3\nlto = true\ndebug = false\n"
    )
    environment = os.environ.copy()
    for key in ("RUSTFLAGS", "CARGO_ENCODED_RUSTFLAGS", "CARGO_BUILD_RUSTFLAGS"):
        environment.pop(key, None)
    # --print cfg exercises Cargo's target flags without cross-target standard libraries.
    result = subprocess.run(
        [
            "cargo",
            "rustc",
            "--offline",
            "--release",
            "--target",
            target,
            "-v",
            "--",
            "--print",
            "cfg",
        ],
        cwd=tmp_path,
        env=environment,
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, result.stderr
    commands = [
        line
        for line in result.stderr.splitlines()
        if "Running `" in line and "--crate-name config_probe " in line
    ]
    assert len(commands) == 1, result.stderr
    is_macos = 'target_os="macos"' in result.stdout
    assert ("-C strip=none" in commands[0]) == is_macos
    assert "-C opt-level=3" in commands[0]
    assert "-C linker-plugin-lto" in commands[0]


def test_sdist_keeps_native_build_configuration(tmp_path):
    result = subprocess.run(
        [sys.executable, "-m", "maturin", "sdist", "--out", str(tmp_path)],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, result.stderr
    (sdist,) = tmp_path.glob("*.tar.gz")
    with tarfile.open(sdist) as archive:
        (config,) = [
            entry
            for entry in archive.getmembers()
            if entry.name.endswith("/.cargo/config.toml")
        ]
        assert (
            archive.extractfile(config).read()
            == (ROOT / ".cargo/config.toml").read_bytes()
        )
