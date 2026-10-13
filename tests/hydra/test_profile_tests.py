from contextlib import contextmanager
from subprocess import CompletedProcess

import pytest

from tools.profile_tests import Paths, RunTestsCommand


@pytest.mark.parametrize(
    "result_line",
    [
        "[PASS] garaga::tests::test_example (l1_gas: ~0, l1_data_gas: ~0, l2_gas: ~100)",
        "[PASS] garaga::tests::test_example (gas: ~100)",
    ],
)
def test_profiler_collects_test_names_from_foundry_output(
    monkeypatch, tmp_path, result_line
):
    src_dir = tmp_path / "src"
    src_dir.mkdir()
    (src_dir / "Scarb.toml").touch()

    def run_command(cmd, **kwargs):
        assert cmd == [
            "snforge",
            "test",
            "--save-trace-data",
            "--tracked-resource",
            "cairo-steps",
        ]
        return CompletedProcess(cmd, 0, result_line, "")

    @contextmanager
    def managed_subprocess():
        yield run_command, None

    monkeypatch.setattr("tools.profile_tests.managed_subprocess", managed_subprocess)
    command = RunTestsCommand(Paths(tmp_path))

    assert command.execute()
    assert command.passed_tests == ["garaga::tests::test_example"]


def test_profiler_rejects_a_run_without_passed_tests(monkeypatch, tmp_path):
    src_dir = tmp_path / "src"
    src_dir.mkdir()
    (src_dir / "Scarb.toml").touch()

    @contextmanager
    def managed_subprocess():
        yield lambda cmd, **kwargs: CompletedProcess(
            cmd, 0, "Tests: 0 passed", ""
        ), None

    monkeypatch.setattr("tools.profile_tests.managed_subprocess", managed_subprocess)
    command = RunTestsCommand(Paths(tmp_path))

    assert not command.execute()
    assert command.passed_tests == []
