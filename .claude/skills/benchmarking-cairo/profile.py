#!/usr/bin/env python3
"""
Cairo profiling CLI — deterministic pipeline for generating profiles.

Usage:
    # snforge mode (run test, build profile, export PNG)
    python3 profile.py profile \
        --mode snforge \
        --package falcon \
        --test test_ntt_zknox_vs_felt252 \
        --name ntt-zknox-reduced \
        --metric steps

    # scarb execute mode
    python3 profile.py profile \
        --mode scarb \
        --package falcon \
        --executable bench_ntt \
        --args-file tests/data/ntt_input_512.json \
        --name ntt-felt252 \
        --metric steps

Exit codes:
    0  Success
    1  Argument error
    2  snforge/scarb execution failed
    3  Trace file not found after execution
    4  cairo-profiler build failed
    5  pprof PNG export failed
    6  Missing external tool (snforge, scarb, cairo-profiler, pprof)
"""

import argparse
import glob
import os
import subprocess
import sys
from datetime import datetime
from pathlib import Path

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------


def _check_tool(name: str) -> str:
    """Return path to tool or exit with code 6."""
    import shutil

    path = shutil.which(name)
    if path is None:
        _fail(6, f"Required tool '{name}' not found on PATH. See installation.md.")
    return path


def _fail(code: int, msg: str) -> None:
    """Print error and exit."""
    print(f"ERROR [{code}]: {msg}", file=sys.stderr)
    sys.exit(code)


def _run(
    cmd: list[str], cwd: str | None = None, timeout: int = 600
) -> subprocess.CompletedProcess:
    """Run a command, printing it first. Returns CompletedProcess."""
    print(f"  $ {' '.join(cmd)}")
    return subprocess.run(cmd, cwd=cwd, timeout=timeout, capture_output=False)


def _git_short_hash(repo_root: str) -> str:
    """Return short git hash or 'unknown'."""
    try:
        result = subprocess.run(
            ["git", "rev-parse", "--short", "HEAD"],
            cwd=repo_root,
            capture_output=True,
            text=True,
            timeout=5,
        )
        return result.stdout.strip() if result.returncode == 0 else "unknown"
    except Exception:
        return "unknown"


def _profile_filename(
    output_dir: str, package: str, name: str, metric: str, commit: str, ext: str
) -> str:
    """Generate deterministic profile filename."""
    ts = datetime.now().strftime("%y-%m-%d-%H:%M")
    return os.path.join(output_dir, f"{ts}_{package}_{name}_{metric}_{commit}.{ext}")


# ---------------------------------------------------------------------------
# Metric → sample mapping
# ---------------------------------------------------------------------------

METRIC_CONFIG = {
    "steps": {
        "tracked_resource": "cairo-steps",
        "sample_name": "steps",
        "pprof_sample_index": "steps",
    },
    "rc": {
        "tracked_resource": "cairo-steps",
        "sample_name": "range check builtin",
        "pprof_sample_index": "range_check_builtin",
    },
    "sierra-gas": {
        "tracked_resource": "sierra-gas",
        "sample_name": "sierra gas",
        "pprof_sample_index": "sierra_gas",
    },
    "l2-gas": {
        "tracked_resource": "sierra-gas",
        "sample_name": "l2 gas",
        "pprof_sample_index": "l2_gas",
    },
}


# ---------------------------------------------------------------------------
# Pipeline steps
# ---------------------------------------------------------------------------


def _find_package_dir(repo_root: str, package: str) -> str:
    """Resolve package directory from workspace."""
    pkg_dir = os.path.join(repo_root, "packages", package)
    if os.path.isdir(pkg_dir) and os.path.isfile(os.path.join(pkg_dir, "Scarb.toml")):
        return pkg_dir
    # Maybe it's a top-level package
    if os.path.isfile(os.path.join(repo_root, "Scarb.toml")):
        return repo_root
    _fail(
        1,
        f"Cannot find package '{package}'. Looked in packages/{package}/ and repo root.",
    )
    return ""  # unreachable


def _step_snforge(pkg_dir: str, test_filter: str, tracked_resource: str) -> None:
    """Run snforge test with trace generation."""
    _check_tool("snforge")
    print(
        f"\n[1/4] Running snforge test (filter: {test_filter}, resource: {tracked_resource})"
    )
    result = _run(
        [
            "snforge",
            "test",
            test_filter,
            "--save-trace-data",
            "--tracked-resource",
            tracked_resource,
        ],
        cwd=pkg_dir,
        timeout=600,
    )
    if result.returncode != 0:
        _fail(2, f"snforge test failed with exit code {result.returncode}")


def _step_scarb(pkg_dir: str, executable: str, args_file: str) -> None:
    """Run scarb execute with trace generation."""
    _check_tool("scarb")
    print(f"\n[1/4] Running scarb execute (executable: {executable})")
    cmd = [
        "scarb",
        "execute",
        "--executable-name",
        executable,
        "--print-resource-usage",
        "--save-profiler-trace-data",
    ]
    if args_file:
        cmd.extend(["--arguments-file", args_file])
    result = _run(cmd, cwd=pkg_dir, timeout=600)
    if result.returncode != 0:
        _fail(2, f"scarb execute failed with exit code {result.returncode}")


def _find_trace_snforge(pkg_dir: str, test_filter: str) -> str:
    """Find the trace JSON generated by snforge."""
    trace_dir = os.path.join(pkg_dir, "snfoundry_trace")
    if not os.path.isdir(trace_dir):
        _fail(
            3,
            f"Trace directory not found: {trace_dir}\n"
            f"  Did snforge run successfully? Check that the test passed.",
        )

    # snforge names traces like: <package>_<test_module>_<test_name>.json
    # Find files matching the test filter
    pattern = os.path.join(trace_dir, f"*{test_filter}*.json")
    matches = sorted(glob.glob(pattern), key=os.path.getmtime, reverse=True)

    if not matches:
        # List what IS there for debugging
        all_traces = glob.glob(os.path.join(trace_dir, "*.json"))
        available = (
            "\n  ".join(os.path.basename(f) for f in all_traces)
            if all_traces
            else "(none)"
        )
        _fail(
            3,
            f"No trace file matching '*{test_filter}*' in {trace_dir}/\n"
            f"  Available traces:\n  {available}\n"
            f"  Hint: The test must PASS to generate a trace. Failing/filtered tests produce no trace.",
        )

    if len(matches) > 1:
        print(f"  Warning: Multiple traces match '{test_filter}', using most recent:")
        for m in matches:
            print(f"    {os.path.basename(m)}")

    trace = matches[0]
    print(f"  Trace: {os.path.basename(trace)}")
    return trace


def _find_trace_scarb(pkg_dir: str, package: str) -> str:
    """Find the trace JSON generated by scarb execute."""
    # Standard location: target/execute/<package>/execution1/cairo_profiler_trace.json
    trace = os.path.join(
        pkg_dir, "target", "execute", package, "execution1", "cairo_profiler_trace.json"
    )
    if not os.path.isfile(trace):
        _fail(
            3,
            f"Trace file not found: {trace}\n"
            f"  Expected at: target/execute/{package}/execution1/cairo_profiler_trace.json\n"
            f"  Did scarb execute succeed? Check --save-profiler-trace-data was used.",
        )
    print(f"  Trace: {trace}")
    return trace


def _step_build_profile(trace_path: str, output_path: str) -> None:
    """Build pprof profile from trace JSON."""
    _check_tool("cairo-profiler")
    print(f"\n[3/4] Building profile: {os.path.basename(output_path)}")
    result = _run(
        [
            "cairo-profiler",
            "build-profile",
            trace_path,
            "--show-libfuncs",
            "--output-path",
            output_path,
        ]
    )
    if result.returncode != 0:
        _fail(
            4,
            f"cairo-profiler build-profile failed with exit code {result.returncode}\n"
            f"  Trace: {trace_path}",
        )
    if not os.path.isfile(output_path):
        _fail(4, f"cairo-profiler completed but output file not found: {output_path}")


def _step_view_profile(profile_path: str, sample_name: str) -> None:
    """Print top-20 functions by the chosen sample."""
    print(f"\n  Top functions by {sample_name}:")
    _run(
        [
            "cairo-profiler",
            "view",
            profile_path,
            "--sample",
            sample_name,
            "--limit",
            "20",
        ]
    )


def _step_export_png(
    profile_path: str,
    png_path: str,
    pprof_sample_index: str,
    nodefraction: float = 0.005,
    edgefraction: float = 0.001,
) -> None:
    """Export PNG call graph via pprof."""
    _check_tool("pprof")
    print(f"\n[4/4] Exporting PNG: {os.path.basename(png_path)}")
    result = _run(
        [
            "pprof",
            "-png",
            f"-sample_index={pprof_sample_index}",
            f"-nodefraction={nodefraction}",
            f"-edgefraction={edgefraction}",
            "-output",
            png_path,
            profile_path,
        ]
    )
    if result.returncode != 0:
        _fail(
            5,
            f"pprof PNG export failed with exit code {result.returncode}\n"
            f"  Profile: {profile_path}\n"
            f"  Hint: Is graphviz (dot) installed? Run: apt install graphviz",
        )
    if not os.path.isfile(png_path):
        _fail(5, f"pprof completed but PNG not found: {png_path}")


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="profile.py",
        description="Cairo profiling CLI — run tests, build profiles, export PNGs.",
    )
    sub = parser.add_subparsers(dest="command")

    p = sub.add_parser("profile", help="Full profiling pipeline")
    p.add_argument(
        "--mode",
        required=True,
        choices=["snforge", "scarb"],
        help="Execution mode: snforge (test) or scarb (executable)",
    )
    p.add_argument("--package", required=True, help="Scarb package name (e.g. falcon)")
    p.add_argument(
        "--name",
        required=True,
        help="Human-friendly profile name (e.g. ntt-zknox-reduced)",
    )
    p.add_argument(
        "--metric",
        default="steps",
        choices=list(METRIC_CONFIG.keys()),
        help="Metric to profile (default: steps)",
    )
    p.add_argument(
        "--output", default="profiles", help="Output directory (default: profiles/)"
    )

    # snforge-specific
    p.add_argument(
        "--test",
        default=None,
        help="[snforge] Test filter (e.g. test_ntt_zknox_vs_felt252)",
    )

    # scarb-specific
    p.add_argument("--executable", default=None, help="[scarb] Executable name")
    p.add_argument("--args-file", default=None, help="[scarb] Arguments file path")

    # pprof display options
    p.add_argument(
        "--nodefraction",
        type=float,
        default=0.005,
        help="Hide nodes below this fraction of total (default: 0.005). Use 0 to show all.",
    )
    p.add_argument(
        "--edgefraction",
        type=float,
        default=0.001,
        help="Hide edges below this fraction of total (default: 0.001). Use 0 to show all.",
    )

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()

    if args.command != "profile":
        parser.print_help()
        return 1

    # Validate mode-specific args
    if args.mode == "snforge" and not args.test:
        _fail(
            1,
            "--test is required for snforge mode.\n"
            "  Example: --test test_ntt_zknox_vs_felt252",
        )
    if args.mode == "scarb" and not args.executable:
        _fail(
            1,
            "--executable is required for scarb mode.\n"
            "  Example: --executable bench_ntt",
        )

    # Resolve paths
    repo_root = _find_repo_root()
    pkg_dir = _find_package_dir(repo_root, args.package)
    output_dir = os.path.join(repo_root, args.output)
    os.makedirs(output_dir, exist_ok=True)

    commit = _git_short_hash(repo_root)
    metric_cfg = METRIC_CONFIG[args.metric]

    # Generate output filenames
    pb_path = _profile_filename(
        output_dir, args.package, args.name, args.metric, commit, "pb.gz"
    )
    png_path = _profile_filename(
        output_dir, args.package, args.name, args.metric, commit, "png"
    )

    print(f"Cairo Profiling Pipeline")
    print(f"  Mode:    {args.mode}")
    print(f"  Package: {args.package} ({pkg_dir})")
    print(f"  Name:    {args.name}")
    print(f"  Metric:  {args.metric} (sample: {metric_cfg['sample_name']})")
    print(f"  Commit:  {commit}")
    print(f"  Output:  {os.path.basename(pb_path)}")
    sys.stdout.flush()

    # Step 1: Run test/executable
    if args.mode == "snforge":
        _step_snforge(pkg_dir, args.test, metric_cfg["tracked_resource"])
    else:
        _step_scarb(pkg_dir, args.executable, args.args_file)

    # Step 2: Find trace
    print(f"\n[2/4] Locating trace file")
    if args.mode == "snforge":
        trace_path = _find_trace_snforge(pkg_dir, args.test)
    else:
        trace_path = _find_trace_scarb(pkg_dir, args.package)

    # Step 3: Build profile
    _step_build_profile(trace_path, pb_path)
    _step_view_profile(pb_path, metric_cfg["sample_name"])

    # Step 4: Export PNG
    _step_export_png(
        pb_path,
        png_path,
        metric_cfg["pprof_sample_index"],
        nodefraction=args.nodefraction,
        edgefraction=args.edgefraction,
    )

    # Summary
    print(f"\n{'='*60}")
    print(f"Profile: {pb_path}")
    print(f"PNG:     {png_path}")
    print(f"{'='*60}")

    return 0


def _find_repo_root() -> str:
    """Walk up from cwd to find the git repo root."""
    path = Path.cwd()
    while path != path.parent:
        if (path / ".git").exists():
            return str(path)
        path = path.parent
    # Fallback to cwd
    return str(Path.cwd())


if __name__ == "__main__":
    sys.exit(main())
