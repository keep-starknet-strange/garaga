import json
from contextlib import contextmanager
from subprocess import CompletedProcess

import pytest

from tools.profile_tests import (
    Config,
    Paths,
    ProcessTracesCommand,
    RunTestsCommand,
    TraceProcessor,
)


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


def test_profiler_keeps_same_named_library_and_contract_artifacts(
    monkeypatch, tmp_path
):
    monkeypatch.chdir(tmp_path)
    paths = Paths(tmp_path)
    paths.ensure_dirs()
    profile_file = tmp_path / "profile.pb.gz"
    profile_file.touch()

    @contextmanager
    def managed_subprocess():
        yield None, None

    def generate_image(self, profile_path, output_path, run_cmd):
        output_path.touch()
        return True

    monkeypatch.setattr("tools.profile_tests.managed_subprocess", managed_subprocess)
    monkeypatch.setattr(TraceProcessor, "_generate_profile", lambda *args: profile_file)
    monkeypatch.setattr(
        TraceProcessor, "_extract_resources", lambda *args: {"steps": 10}
    )
    monkeypatch.setattr(TraceProcessor, "_generate_image", generate_image)
    processor = TraceProcessor(Config())
    test_names = [
        "garaga::tests::test_shared_name",
        "verifier_integrationtest::test_contract::test_shared_name",
    ]
    results = [processor.process(name, tmp_path / "trace.json") for name in test_names]
    command = ProcessTracesCommand(paths, test_names)
    command.test_resources = [result[3] for result in results]
    command._update_summary()

    assert all(result[0] for result in results)
    assert (paths.docs_benchmarks / "test_shared_name.png").exists()
    assert (paths.docs_benchmarks / "verifier_test_shared_name.png").exists()
    summary = json.loads((paths.docs_benchmarks / "test_summary.json").read_text())
    assert set(summary) == {"test_shared_name", "verifier_test_shared_name"}
