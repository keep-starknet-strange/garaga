"""Compare the same command in two directories, without extra dependencies.

Run from the repository root:
    python -m tools.measure --baseline ../baseline --candidate . --runs 5 \\
        --output /tmp/measurement.json -- make rewrite

The order alternates each round. Warmups do not enter the medians.
Artifact hashes do not enter command timings. Artifact differences exit nonzero.
Commands inherit the current environment. Commands must finish all child work.
Use separate directories and identical toolchains for a source comparison.
"""

import argparse
import hashlib
import json
import os
import platform
import resource
import statistics
import subprocess
import sys
import time
from collections.abc import Sequence
from datetime import datetime, timezone
from pathlib import Path

from tools.source_provenance import capture_source_provenance


def fingerprint_artifacts(directory: Path, patterns: Sequence[str]) -> dict[str, str]:
    """Hash relative file paths and contents selected by each glob or directory."""
    files = set()
    for pattern in patterns:
        path = Path(pattern)
        if path.is_absolute() or ".." in path.parts:
            raise ValueError(
                f"Artifact paths must stay inside each directory: {pattern}"
            )
        matches = list(directory.glob(pattern))
        if not matches:
            raise ValueError(f"No artifacts match {pattern!r} in {directory}")
        for match in matches:
            files.update(
                match.rglob("*")
                if match.is_dir() and not match.is_symlink()
                else [match]
            )
    hashes = {}
    for path in sorted(files):
        if path.is_symlink():
            content_hash = hashlib.sha256(os.fsencode(os.readlink(path))).hexdigest()
            content_hash = f"symlink:{content_hash}"
        elif path.is_file():
            digest = hashlib.sha256()
            with path.open("rb") as source:
                for chunk in iter(lambda: source.read(1024 * 1024), b""):
                    digest.update(chunk)
            content_hash = digest.hexdigest()
        else:
            continue
        hashes[path.relative_to(directory).as_posix()] = content_hash
    if patterns and not hashes:
        raise ValueError(f"Artifact selection contains no files in {directory}")
    return hashes


def run_sample(command: list[str], directory: Path) -> dict:
    """Measure the command, including child CPU and process startup."""
    cpu_before = resource.getrusage(resource.RUSAGE_CHILDREN)
    started = time.perf_counter()
    subprocess.run(command, cwd=directory, check=True, capture_output=True)
    wall_seconds = time.perf_counter() - started
    cpu_after = resource.getrusage(resource.RUSAGE_CHILDREN)
    return {
        "wall_seconds": wall_seconds,
        "child_cpu_seconds": (cpu_after.ru_utime - cpu_before.ru_utime)
        + (cpu_after.ru_stime - cpu_before.ru_stime),
    }


def measure(
    command: list[str],
    baseline: Path,
    candidate: Path,
    runs: int = 5,
    warmups: int = 1,
    artifacts: Sequence[str] = (),
) -> dict:
    if not command or runs < 1 or warmups < 0:
        raise ValueError(
            "A command, positive runs, and nonnegative warmups are required"
        )
    directories = {"baseline": baseline.resolve(), "candidate": candidate.resolve()}
    for directory in directories.values():
        if not directory.is_dir():
            raise ValueError(f"Measurement directory does not exist: {directory}")
    results = {
        name: {
            "directory": str(directory),
            "source_before": capture_source_provenance(directory),
            "samples": [],
        }
        for name, directory in directories.items()
    }
    artifact_samples = {name: [] for name in directories}
    for phase, count in [("warmup", warmups), ("sample", runs)]:
        for index in range(count):
            order = list(directories)
            if index % 2:
                order.reverse()
            for name in order:
                print(f"{phase} {index + 1}/{count}: {name}", file=sys.stderr)
                sample = run_sample(command, directories[name])
                if phase == "sample":
                    results[name]["samples"].append(sample)
                    if artifacts:
                        artifact_samples[name].append(
                            fingerprint_artifacts(directories[name], artifacts)
                        )
    for name, result in results.items():
        result["median"] = {
            metric: statistics.median(sample[metric] for sample in result["samples"])
            for metric in ["wall_seconds", "child_cpu_seconds"]
        }
        result["source_after"] = capture_source_provenance(directories[name])
        if artifacts:
            result["artifacts"] = artifact_samples[name][-1]
            result["artifacts_stable"] = all(
                sample == result["artifacts"] for sample in artifact_samples[name]
            )
    changes = {}
    for metric, before in results["baseline"]["median"].items():
        after = results["candidate"]["median"][metric]
        changes[metric] = 100 * (after / before - 1) if before else None
    report = {
        "recorded_at": datetime.now(timezone.utc).isoformat(),
        "platform": platform.platform(),
        "python": platform.python_version(),
        "command": command,
        "warmups": warmups,
        "runs": runs,
        **results,
        "change_percent": changes,
    }
    if artifacts:
        baseline_artifacts = results["baseline"]["artifacts"]
        candidate_artifacts = results["candidate"]["artifacts"]
        report["artifacts_match"] = (
            baseline_artifacts == candidate_artifacts
            and results["baseline"]["artifacts_stable"]
            and results["candidate"]["artifacts_stable"]
        )
        report["artifact_mismatches"] = sorted(
            name
            for name in baseline_artifacts.keys() | candidate_artifacts.keys()
            if baseline_artifacts.get(name) != candidate_artifacts.get(name)
        )
    return report


def main() -> int:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument("--baseline", type=Path, required=True)
    parser.add_argument("--candidate", type=Path, required=True)
    parser.add_argument("--runs", type=int, default=5)
    parser.add_argument("--warmups", type=int, default=1)
    parser.add_argument("--artifact", action="append", default=[], help="Relative glob")
    parser.add_argument("--output", type=Path, help="JSON output (default: stdout)")
    parser.add_argument("command", nargs=argparse.REMAINDER, help="Command after --")
    args = parser.parse_args()
    command = args.command[1:] if args.command[:1] == ["--"] else args.command
    try:
        report = measure(
            command,
            args.baseline,
            args.candidate,
            args.runs,
            args.warmups,
            args.artifact,
        )
    except subprocess.CalledProcessError as error:
        print(
            f"Command failed with exit code {error.returncode}: {error.cmd}",
            file=sys.stderr,
        )
        sys.stderr.write((error.stdout + error.stderr).decode(errors="replace"))
        return 1
    except (OSError, ValueError) as error:
        parser.error(str(error))
    payload = json.dumps(report, indent=2) + "\n"
    if args.output:
        args.output.write_text(payload)
        print(f"Measurement saved to {args.output}", file=sys.stderr)
    else:
        sys.stdout.write(payload)
    if not report.get("artifacts_match", True):
        print("Artifacts differ between directories or measured runs", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
