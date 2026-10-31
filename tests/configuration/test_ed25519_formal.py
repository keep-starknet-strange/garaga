"""Reject arithmetic models that no longer match the production sources."""

import subprocess
import sys
from pathlib import Path


def test_ed25519_formal_models_match_production():
    root = Path(__file__).resolve().parents[2]
    subprocess.run(
        [sys.executable, "tools/divide_and_pair/formal/generate.py", "--check"],
        cwd=root,
        check=True,
        capture_output=True,
        text=True,
    )
