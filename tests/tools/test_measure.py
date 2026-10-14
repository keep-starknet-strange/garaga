import json
import subprocess
import sys
from pathlib import Path

import pytest

from tools.measure import fingerprint_artifacts, measure, run_sample


def test_measure_alternates_order_and_excludes_warmups(monkeypatch, tmp_path):
    baseline = tmp_path / "baseline"
    candidate = tmp_path / "candidate"
    baseline.mkdir()
    candidate.mkdir()
    calls = []
    values = iter([100, 100, 100, 100, 4, 2, 6, 8, 12, 10])

    def sample(command, directory):
        calls.append(directory.name)
        seconds = next(values)
        return {"wall_seconds": seconds, "child_cpu_seconds": seconds / 2}

    monkeypatch.setattr("tools.measure.run_sample", sample)
    report = measure(["command"], baseline, candidate, runs=3, warmups=2)
    assert calls == [
        "baseline",
        "candidate",
        "candidate",
        "baseline",
        "baseline",
        "candidate",
        "candidate",
        "baseline",
        "baseline",
        "candidate",
    ]
    assert report["baseline"]["median"] == {"wall_seconds": 8, "child_cpu_seconds": 4}
    assert report["candidate"]["median"] == {"wall_seconds": 6, "child_cpu_seconds": 3}
    assert report["change_percent"] == {"wall_seconds": -25, "child_cpu_seconds": -25}
    assert report["baseline"]["source_before"]["source_revision"] is None


@pytest.mark.parametrize("change", ["same", "different", "missing", "unstable"])
def test_artifact_comparison_detects_bytes_paths_and_nondeterminism(tmp_path, change):
    baseline = tmp_path / "baseline"
    candidate = tmp_path / "candidate"
    baseline.mkdir()
    candidate.mkdir()
    (baseline / "output.txt").write_text("same")
    output = candidate / ("other.txt" if change == "missing" else "output.txt")
    output.write_text("different" if change == "different" else "same")
    command = [sys.executable, "-c", "pass"]
    if change == "unstable":
        command[-1] = (
            "from pathlib import Path; p = Path('output.txt'); "
            "p.write_text('same' if p.read_text() != 'same' else 'different')"
        )
    report = measure(
        command, baseline, candidate, runs=2, warmups=0, artifacts=["*.txt"]
    )
    assert report["artifacts_match"] is (change == "same")
    if change == "unstable":
        assert report["baseline"]["artifacts_stable"] is False
        assert report["candidate"]["artifacts_stable"] is False
    elif change != "same":
        assert report["artifact_mismatches"]
    assert all(sample["wall_seconds"] > 0 for sample in report["baseline"]["samples"])


def test_artifact_directory_hashes_ignore_metadata_and_include_symlink(tmp_path):
    output = tmp_path / "output"
    output.mkdir()
    (output / "file").write_bytes(b"binary\0output")
    (output / "link").symlink_to("file")
    before = fingerprint_artifacts(tmp_path, ["output"])
    (output / "file").touch()
    assert fingerprint_artifacts(tmp_path, ["output/*", "output"]) == before
    assert set(before) == {"output/file", "output/link"}
    assert before["output/link"].startswith("symlink:")


def test_artifact_symlink_directory_hashes_the_link_without_reading_its_target(
    tmp_path,
):
    outside = tmp_path / "outside"
    outside.mkdir()
    (outside / "file").write_text("Do not hash the target")
    (tmp_path / "link").symlink_to("outside", target_is_directory=True)
    hashes = fingerprint_artifacts(tmp_path, ["link"])
    assert set(hashes) == {"link"}
    assert hashes["link"].startswith("symlink:")


@pytest.mark.parametrize(
    "command,runs,warmups", [([], 1, 0), (["command"], 0, 0), (["command"], 1, -1)]
)
def test_invalid_measurement_cannot_run_a_command(tmp_path, command, runs, warmups):
    with pytest.raises(ValueError):
        measure(command, tmp_path, tmp_path, runs=runs, warmups=warmups)


@pytest.mark.parametrize("pattern", ["missing", "../outside", "/absolute"])
def test_invalid_artifact_selection_is_rejected(tmp_path, pattern):
    with pytest.raises(ValueError):
        fingerprint_artifacts(tmp_path, [pattern])


def test_failed_command_cannot_produce_a_successful_sample(tmp_path):
    with pytest.raises(subprocess.CalledProcessError) as error:
        run_sample(
            [sys.executable, "-c", "print('failure'); raise SystemExit(7)"], tmp_path
        )
    assert error.value.returncode == 7
    assert b"failure" in error.value.stdout


def test_cli_writes_json_and_exits_nonzero_for_artifact_mismatch(tmp_path):
    baseline = tmp_path / "baseline"
    candidate = tmp_path / "candidate"
    baseline.mkdir()
    candidate.mkdir()
    (baseline / "output.txt").write_text("before")
    (candidate / "output.txt").write_text("after")
    output = tmp_path / "report.json"
    result = subprocess.run(
        [
            sys.executable,
            "-S",
            "-m",
            "tools.measure",
            "--baseline",
            str(baseline),
            "--candidate",
            str(candidate),
            "--runs",
            "1",
            "--warmups",
            "0",
            "--artifact",
            "output.txt",
            "--output",
            str(output),
            "--",
            sys.executable,
            "-c",
            "pass",
        ],
        cwd=Path(__file__).resolve().parents[2],
        capture_output=True,
        text=True,
    )
    assert result.returncode == 1, result.stderr
    report = json.loads(output.read_text())
    assert report["artifacts_match"] is False
    assert report["artifact_mismatches"] == ["output.txt"]
    assert report["command"] == [sys.executable, "-c", "pass"]
    assert "sample 1/1: baseline" in result.stderr
