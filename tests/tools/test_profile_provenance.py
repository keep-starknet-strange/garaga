import json
import subprocess
from pathlib import Path

import pytest

from tools.profile_tests import (
    CheckDependenciesCommand,
    Config,
    Paths,
    ProcessTracesCommand,
    RunTestsCommand,
)
from tools.profile_tests import TestResourceInfo as ResourceInfo
from tools.profile_tests import WorkflowExecutor, capture_source_provenance


def git(repo: Path, *arguments):
    return subprocess.run(
        ["git", "-C", str(repo), *arguments], check=True, capture_output=True, text=True
    ).stdout.strip()


@pytest.fixture
def clean_repo(tmp_path):
    git(tmp_path, "init", "--quiet")
    (tmp_path / "source.py").write_text("value = 1\n")
    (tmp_path / "README.md").write_text("Previous report\n")
    (tmp_path / ".gitignore").write_text("ignored.py\n")
    git(tmp_path, "add", ".")
    git(
        tmp_path,
        "-c",
        "user.name=Provenance Test",
        "-c",
        "user.email=provenance@example.test",
        "commit",
        "--quiet",
        "-m",
        "Baseline",
    )
    return tmp_path


def test_clean_provenance_resolves_git_root(clean_repo):
    nested = clean_repo / "nested"
    nested.mkdir()
    assert capture_source_provenance(nested) == {
        "source_revision": git(clean_repo, "rev-parse", "HEAD"),
        "source_dirty": False,
        "source_changes_sha256": None,
    }


@pytest.mark.parametrize(
    "change",
    ["staged", "unstaged", "both", "cancelled", "untracked", "binary", "symlink"],
)
def test_dirty_provenance_fingerprints_each_change_state(clean_repo, change):
    source = clean_repo / "source.py"
    if change in ["staged", "unstaged", "both", "cancelled"]:
        source.write_text("value = 2\n")
        if change != "unstaged":
            git(clean_repo, "add", "source.py")
        if change == "both":
            source.write_text("value = 3\n")
        elif change == "cancelled":
            source.write_text("value = 1\n")
    else:
        source = clean_repo / "new source.py"
        if change == "symlink":
            source.symlink_to("source.py")
        else:
            source.write_bytes(b"new\0source" if change == "binary" else b"new source")

    before = capture_source_provenance(clean_repo)
    assert before["source_revision"] == git(clean_repo, "rev-parse", "HEAD")
    assert before["source_dirty"] is True
    assert len(before["source_changes_sha256"]) == 64
    assert capture_source_provenance(clean_repo) == before

    if change == "symlink":
        source.unlink()
        source.symlink_to("missing.py")
    else:
        source.write_bytes(b"different\0source")
        if change == "staged":
            git(clean_repo, "add", "source.py")
    assert (
        capture_source_provenance(clean_repo)["source_changes_sha256"]
        != before["source_changes_sha256"]
    )


def test_ignored_files_do_not_change_git_provenance(clean_repo):
    before = capture_source_provenance(clean_repo)
    (clean_repo / "ignored.py").write_text("Ignored source\n")
    assert capture_source_provenance(clean_repo) == before


def test_repoless_provenance_is_unknown(tmp_path):
    assert capture_source_provenance(tmp_path) == {
        "source_revision": None,
        "source_dirty": None,
        "source_changes_sha256": None,
    }


def test_summary_uses_provenance_captured_before_report_outputs(clean_repo):
    paths = Paths(clean_repo)
    paths.ensure_dirs()
    resource = ResourceInfo("garaga::tests::test_sample", "test_sample", 10)
    command = ProcessTracesCommand(paths, [resource.test_name_hierarchical])
    command.test_resources = [resource]
    captured = command.source_provenance.copy()

    (clean_repo / "README.md").write_text("New report\n")
    (paths.docs_benchmarks / "test_sample.png").write_bytes(b"profile image")
    historical = {"latest_metrics": {"steps": 42}, "source_revision": "old"}
    summary_file = paths.docs_benchmarks / "test_summary.json"
    summary_file.write_text(json.dumps({"historical": historical}))
    assert capture_source_provenance(clean_repo)["source_dirty"] is True
    command._update_summary()

    summary = json.loads(summary_file.read_text())
    assert summary["historical"] == historical
    assert summary["test_sample"]["latest_metrics"] == resource.to_benchmark_row()
    assert {key: summary["test_sample"][key] for key in captured} == captured
    assert summary["test_sample"]["source_dirty"] is False


def test_workflow_captures_input_source_before_running_tests(monkeypatch, clean_repo):
    expected = capture_source_provenance(clean_repo)
    monkeypatch.setattr(CheckDependenciesCommand, "can_execute", lambda self: True)
    monkeypatch.setattr(CheckDependenciesCommand, "execute", lambda self: True)
    monkeypatch.setattr(RunTestsCommand, "can_execute", lambda self: True)

    def run_tests(command):
        (clean_repo / "source.py").write_text("value = 2\n")
        command.passed_tests = ["garaga::tests::test_sample"]
        return True

    def process_traces(command):
        assert capture_source_provenance(clean_repo)["source_dirty"] is True
        assert command.source_provenance == expected
        return True

    monkeypatch.setattr(RunTestsCommand, "execute", run_tests)
    monkeypatch.setattr(ProcessTracesCommand, "execute", process_traces)
    assert WorkflowExecutor(Config(), Paths(clean_repo)).execute_workflow()
