"""Reject drift between the production relation factory and its Lean source model."""

import subprocess
import sys
from pathlib import Path


def test_cairo_lean_models_match_the_production_factory_and_keys():
    root = Path(__file__).resolve().parents[2]
    result = subprocess.run(
        [
            sys.executable,
            str(root / "tools/noir/formal/generate.py"),
            "--side",
            "cairo",
            "--check",
        ],
        cwd=root,
        text=True,
        capture_output=True,
    )
    assert result.returncode == 0, result.stdout + result.stderr
