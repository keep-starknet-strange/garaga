import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def test_unit_collection_keeps_hypothesis_without_loading_e2e_plugins():
    result = subprocess.run(
        [
            sys.executable,
            "-c",
            "import os, pathlib, pytest, sys; "
            "assert pytest.main(['--collect-only', '-q', sys.argv[1]]) == 0; "
            "assert not any(name.startswith('tests.contracts_e2e.fixtures.') for name in sys.modules); "
            "from hypothesis import settings; "
            "expected = pathlib.Path('.cargo/hypothesis').resolve(); "
            "assert pathlib.Path(os.environ['HYPOTHESIS_STORAGE_DIRECTORY']) == expected; "
            "assert settings.default.database.path == expected",
            "tests/hydra/algebra/test_pyfelt.py",
        ],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, result.stdout + result.stderr


def test_e2e_collection_preserves_plugin_fixtures_and_assertion_rewriting():
    result = subprocess.run(
        [
            sys.executable,
            "-c",
            "import pytest, sys; "
            "assert pytest.main(['--fixtures', '-q', sys.argv[1]]) == 0; "
            "from _pytest.assertion.rewrite import AssertionRewritingHook; "
            "plugins = ('accounts', 'clients', 'devnet'); "
            "assert all(isinstance(sys.modules['tests.contracts_e2e.fixtures.' + name].__loader__, "
            "AssertionRewritingHook) for name in plugins)",
            "tests/contracts_e2e/e2e_test.py",
        ],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0, result.stdout + result.stderr
    fixture_names = {
        "account_devnet",
        "deploy_account_details_factory",
        "pre_deployed_account_with_validate_deploy",
        "argent_account_v040_data",
        "argent_account_v040",
        "client_devnet",
        "client_sepolia",
        "devnet",
        "devnet_forking_mode",
    }
    for name in fixture_names:
        assert re.search(rf"^{name}\s", result.stdout, re.MULTILINE), name
