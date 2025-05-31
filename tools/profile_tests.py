#!/usr/bin/env python3
"""
Garaga Test Profiling Tool

This script automates the process of running snforge tests with trace data collection,
generating individual profile data using cairo-profiler, creating performance
visualizations using pprof, and organizing the results.

Usage:
    python tools/profile_tests.py [test_name_filter]
    python tools/profile_tests.py --all

Examples:
    python tools/profile_tests.py msm_BN254_1P    # Run specific test
    python tools/profile_tests.py --all           # Run all tests
    python tools/profile_tests.py                 # Run all tests (same as --all)
"""

import argparse
import glob
import json
import os
import re
import signal
import subprocess
import sys
import time

try:
    import tomllib  # Python 3.11+ built-in TOML parser
except ImportError:
    try:
        import tomli as tomllib  # Fallback for older Python versions
    except ImportError:
        tomllib = None  # Will handle this in the parsing function
from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path

import pandas as pd
from rich.align import Align
from rich.console import Console
from rich.panel import Panel
from rich.progress import (
    BarColumn,
    Progress,
    SpinnerColumn,
    TaskProgressColumn,
    TextColumn,
    TimeElapsedColumn,
    TimeRemainingColumn,
)
from rich.text import Text
from tabulate import tabulate

# Initialize rich console
console = Console()

# Global flag for graceful shutdown
_shutdown_requested = False


def signal_handler(signum, frame):
    """Handle SIGINT (Ctrl+C) gracefully."""
    global _shutdown_requested
    _shutdown_requested = True
    console.print("\n🛑 [bold red]Interrupt received[/bold red]")
    console.print("⏳ [dim]Waiting for current operations to complete...[/dim]")


# Register signal handler
signal.signal(signal.SIGINT, signal_handler)


# Logging level configuration
LOG_STYLES = {
    "info": ("ℹ️", "[dim]{message}[/dim]"),
    "success": ("✅", "[green]{message}[/green]"),
    "warning": ("⚠️", "[yellow]{message}[/yellow]"),
    "error": ("❌", "[bold red]{message}[/bold red]"),
    "debug": ("🔍", "[dim cyan]{message}[/dim cyan]"),
}


def log(message: str, level: str = "info", emoji: str = None):
    """Consolidated logging function with level-based styling."""
    if level == "debug" and not console.is_terminal:
        return  # Skip debug in non-terminal mode

    emoji_char, style_template = LOG_STYLES.get(level, LOG_STYLES["info"])
    if emoji:
        emoji_char = emoji

    formatted_message = style_template.format(message=message)
    console.print(f"{emoji_char} {formatted_message}")


def print_header(title: str):
    """Print a beautiful header."""
    panel = Panel(
        Align.center(Text(title, style="bold cyan")),
        border_style="cyan",
        padding=(0, 1),
        width=80,
    )
    console.print(panel)


def create_progress(advanced: bool = False) -> Progress:
    """Create progress bar - advanced mode for file processing."""
    if advanced:
        return Progress(
            SpinnerColumn(),
            TextColumn("[progress.description]{task.description}"),
            BarColumn(bar_width=40, style="cyan", complete_style="green"),
            "[progress.percentage]{task.percentage:>3.0f}%",
            "•",
            TextColumn("({task.completed}/{task.total} files)"),
            "•",
            TimeElapsedColumn(),
            "•",
            TimeRemainingColumn(),
            console=console,
            transient=False,
        )
    else:
        return Progress(
            SpinnerColumn(),
            TextColumn("[progress.description]{task.description}"),
            BarColumn(bar_width=30, style="cyan", complete_style="green"),
            TaskProgressColumn(),
            "•",
            TimeElapsedColumn(),
            "•",
            TimeRemainingColumn(),
            console=console,
            transient=False,
        )


def show_exit_panel(message: str, status: str, border_style: str = "green"):
    """Show standardized exit panel."""
    console.print(
        Panel(
            Align.center(message),
            border_style=border_style,
            title=f"[{border_style}]{status}[/{border_style}]",
        )
    )


def _submit_trace_processing_tasks(executor, trace_files, timestamp):
    """Submit all trace processing tasks to the executor."""
    return {
        executor.submit(
            ProfileTestRunner.process_single_trace_file_static,
            trace_file_info,
            timestamp,
        ): trace_file_info
        for trace_file_info in trace_files
    }


def _handle_shutdown_request(executor, future_to_file):
    """Handle graceful shutdown by cancelling all pending futures."""
    console.print("🛑 [bold red]Shutdown requested, cancelling all tasks...[/bold red]")
    for future in future_to_file:
        if not future.done():
            future.cancel()

    # Force executor shutdown
    try:
        executor.shutdown(wait=False, cancel_futures=True)
    except TypeError:
        # Fallback for older Python versions
        executor.shutdown(wait=False)


def _process_completed_future(future, trace_file_info, test_resources):
    """Process a single completed future and return success status."""
    try:
        success, test_name, image_path, test_info = future.result()
        if success and test_info:
            test_resources.append(test_info)
            console.print(f"✨ [green]{test_name}[/green]")
            return True
        else:
            console.print(f"💥 [red]{test_name}[/red]")
            return False
    except Exception as e:
        if _shutdown_requested:
            return False
        test_name = ProfileTestRunner.extract_test_name_from_trace_file_static(
            trace_file_info
        )
        console.print(f"💥 [red]{test_name}[/red]: {e}")
        return False


def _process_futures_with_progress(future_to_file, test_resources):
    """Process completed futures with progress tracking."""
    completed_futures = set()
    success_count = 0

    with create_progress(True) as progress:
        task = progress.add_task("Processing trace files", total=len(future_to_file))

        while len(completed_futures) < len(future_to_file):
            if _shutdown_requested:
                return success_count

            # Check for newly completed futures
            for future in list(future_to_file.keys()):
                if future in completed_futures or not future.done():
                    continue

                completed_futures.add(future)
                trace_file_info = future_to_file[future]

                if _process_completed_future(future, trace_file_info, test_resources):
                    success_count += 1

                progress.advance(task, 1)

            # Small sleep to prevent busy waiting but still be responsive
            time.sleep(0.1)

    return success_count


# Configuration constants
CONTRACTS_CONFIG = [
    "autogenerated/groth16_example_bn254",
    # "autogenerated/groth16_example_bls12_381",
    "autogenerated/noir_ultra_keccak_honk_example",
    # "autogenerated/noir_ultra_keccak_zk_honk_example",
    # "autogenerated/noir_ultra_starknet_honk_example",
    # "autogenerated/noir_ultra_starknet_zk_honk_example",
]

EXCLUDED_PROFILE_SAMPLES = {"memory holes", "casm size", "calls"}

# Sierra gas weights
SIERRA_GAS_WEIGHTS = {
    "steps": 100,
    "range_check": 70,
    "range_check96": 56,
    "keccak": 136189,
    "pedersen": 4050,
    "bitwise": 583,
    "ecop": 4085,
    "poseidon": 491,
    "add_mod": 230,
    "mul_mod": 604,
}


# Helper functions for common operations
def _run_command(
    cmd: list, check: bool = True, capture_output: bool = True, text: bool = True
) -> subprocess.CompletedProcess:
    """Execute command with consistent error handling."""
    try:
        return subprocess.run(
            cmd, capture_output=capture_output, text=text, check=check
        )
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"Command failed: {' '.join(cmd)}\nError: {e.stderr}")
    except Exception as e:
        raise RuntimeError(f"Command execution error: {e}")


def _read_json_file(file_path: Path, default=None):
    """Read JSON file with error handling."""
    if not file_path.exists():
        return default if default is not None else {}
    try:
        with open(file_path, "r") as f:
            return json.load(f)
    except (json.JSONDecodeError, IOError):
        return default if default is not None else {}


def _write_json_file(file_path: Path, data, indent: int = 2):
    """Write JSON file with error handling."""
    try:
        with open(file_path, "w") as f:
            json.dump(data, f, indent=indent)
        return True
    except IOError as e:
        log(f"Could not save JSON file {file_path}: {e}", level="error")
        return False


def _ensure_directory(path: Path):
    """Ensure directory exists, create if needed."""
    path.mkdir(parents=True, exist_ok=True)


@dataclass
class TestResourceInfo:
    """Container for test resource information extracted from profile files."""

    # Core test identification (from snforge stdout)
    test_name_hierarchical: str  # e.g., "garaga::ec::ec_ops_g2::tests::test_ec_mul_g2"
    test_name_simple: str  # e.g., "test_ec_mul_g2" (for backwards compatibility)

    # Derived paths and categorization
    predicted_trace_path: Path  # Predicted path based on hierarchical name
    actual_trace_path: Path  # Actual found trace file path
    profile_file_path: Path

    # Performance metrics
    steps: int
    builtins: dict = field(default_factory=dict)

    # Optional fields with defaults
    image_path: str = ""  # docs/benchmarks/ image path
    category: str = "garaga"  # "garaga" or "contracts"
    sierra_gas: int = field(init=False)

    def __post_init__(self):
        """Calculate derived fields after initialization."""
        self.sierra_gas = self._calculate_sierra_gas()

        # Auto-determine category from hierarchical name if not set
        if self.category == "garaga" and "::" in self.test_name_hierarchical:
            parts = self.test_name_hierarchical.split("::")
            # If first part is not "garaga", it's likely a contract
            if parts[0] != "garaga":
                self.category = "contracts"

    @staticmethod
    def predict_trace_path(test_name_hierarchical: str, base_trace_dir: Path) -> Path:
        """Predict trace file path from hierarchical test name."""
        # Replace "::" with "_" to get expected filename
        trace_filename = test_name_hierarchical.replace("::", "_") + ".json"
        return base_trace_dir / trace_filename

    @staticmethod
    def extract_hierarchy_parts(test_name_hierarchical: str) -> list[str]:
        """Extract module hierarchy parts from hierarchical test name."""
        parts = test_name_hierarchical.split("::")

        # Remove test function name if it starts with "test_"
        if parts and parts[-1].startswith("test_"):
            parts = parts[:-1]

        # For contract tests, keep the structure as-is
        # For garaga tests, remove the first "garaga" part to avoid redundancy
        if parts and parts[0] == "garaga":
            parts = parts[1:]

        return parts if parts else ["tests"]  # fallback

    def _calculate_sierra_gas(self) -> int:
        """Calculate Sierra gas using the weight table."""
        total_gas = self.steps * SIERRA_GAS_WEIGHTS["steps"]

        for builtin_name, count in self.builtins.items():
            if builtin_name in SIERRA_GAS_WEIGHTS:
                total_gas += count * SIERRA_GAS_WEIGHTS[builtin_name]
            else:
                log(
                    f"Unknown builtin '{builtin_name}' not in weight table",
                    level="warning",
                )

        return total_gas

    def to_dict(self, timestamp: str = None) -> dict:
        """Convert to dictionary for JSON serialization."""
        if timestamp is None:
            timestamp = datetime.now().isoformat()

        result = {
            "timestamp": timestamp,
            "test_name_hierarchical": self.test_name_hierarchical,
            "test_name": self.test_name_simple,  # For backwards compatibility
            "full_name": self.test_name_hierarchical,  # For grouping logic
            "predicted_trace_path": str(self.predicted_trace_path),
            "actual_trace_path": str(self.actual_trace_path),
            "steps": self.steps,
            "sierra_gas": self.sierra_gas,
            "profile_file_path": str(self.profile_file_path),
            "image_path": self.image_path,
            "category": self.category,
        }

        # Add individual builtin columns
        for builtin_name in SIERRA_GAS_WEIGHTS.keys():
            if builtin_name != "steps":
                result[builtin_name] = self.builtins.get(builtin_name, 0)

        return result


class ProfileTestRunner:
    def __init__(self, workspace_root: str = None):
        """Initialize the profiler runner."""
        self.workspace_root = Path(workspace_root or os.getcwd())
        self.src_dir = self.workspace_root / "src"
        self.trace_dir = self.src_dir / "snfoundry_trace"
        self.docs_benchmarks = self.workspace_root / "docs" / "benchmarks"

        # Parse workspace members from Scarb.toml
        self.workspace_members = self._parse_workspace_members()

    def _parse_workspace_members(self) -> list[Path]:
        """Parse workspace members from Scarb.toml."""
        scarb_toml_path = self.workspace_root / "Scarb.toml"

        if not scarb_toml_path.exists():
            log("Scarb.toml not found, using default src directory", level="warning")
            return [self.src_dir]

        if tomllib is None:
            log(
                "TOML parsing not available. Install 'tomli' package or use Python 3.11+",
                level="warning",
            )
            log("Falling back to default src directory", level="info")
            return [self.src_dir]

        try:
            with open(scarb_toml_path, "rb") as f:
                data = tomllib.load(f)

            workspace = data.get("workspace", {})
            members = workspace.get("members", ["src/"])

            # Expand glob patterns and resolve paths
            member_paths = []
            for member in members:
                if "*" in member:
                    glob_matches = glob.glob(str(self.workspace_root / member))
                    member_paths.extend(
                        [Path(match) for match in glob_matches if Path(match).is_dir()]
                    )
                else:
                    member_path = self.workspace_root / member
                    if member_path.exists() and member_path.is_dir():
                        member_paths.append(member_path)
                    else:
                        log(
                            f"Workspace member not found: {member_path}",
                            level="warning",
                        )

            if not member_paths:
                log(
                    "No valid workspace members found, using default src directory",
                    level="warning",
                )
                return [self.src_dir]

            log(f"Found {len(member_paths)} workspace members", level="success")

            # Add artificial members until scarb fixes https://github.com/software-mansion/scarb/issues/2267
            self.contracts_paths = [
                self.workspace_root / "src" / "contracts" / contract
                for contract in CONTRACTS_CONFIG
            ]
            return member_paths

        except Exception as e:
            log(f"Error parsing Scarb.toml: {e}", level="warning")
            log("Falling back to default src directory", level="info")
            return [self.src_dir]

    def get_all_trace_directories(self) -> list[Path]:
        """Get all potential trace directories from workspace members."""
        trace_dirs = []
        for member_path in self.workspace_members + self.contracts_paths:
            trace_dir = member_path / "snfoundry_trace"
            trace_dirs.append(trace_dir)

        # Also include the legacy trace directory for backwards compatibility
        if self.trace_dir not in trace_dirs:
            trace_dirs.append(self.trace_dir)
        log(f"Trace directories: {trace_dirs}", level="debug")
        return trace_dirs

    def check_dependencies(self):
        """Check if required tools are available."""
        print_header("🔍 Checking Dependencies")
        tools = [
            ("snforge", "Starknet Foundry", ["snforge", "--version"]),
            ("cairo-profiler", "cairo-profiler", ["cairo-profiler", "--version"]),
            ("go", "Go to use pprof", ["go", "version"]),
        ]
        for tool, install_msg, command in tools:
            try:
                result = _run_command(command)
                log(f"{tool}: {result.stdout.strip()}", level="success")
            except RuntimeError:
                log(f"{tool} not found. Please install {install_msg}.", level="error")
                return False

        console.print("✨ [green]All dependencies satisfied![/green]")
        return True

    def setup_directories(self):
        """Create necessary directories."""
        _ensure_directory(self.docs_benchmarks)
        log("Directories ready", level="success")

    def cleanup_temp_directories(self):
        """Remove temporary directories from previous runs."""
        # Note: Intentionally minimal cleanup - letting trace files persist for profile generation
        log("Cleanup completed", level="success")

    def extract_passed_tests_from_stdout(self, stdout: str) -> list[str]:
        """Extract passed test names from snforge test stdout using regex."""
        import re

        pattern = r"\[PASS\]\s+([^\s]+)\s+\(l1_gas:"
        matches = re.findall(pattern, stdout)
        return matches

    def run_snforge_test_with_trace_and_capture(
        self, test_filter: str = None
    ) -> tuple[bool, list[str]]:
        """Run snforge test with trace data collection and capture passed test names."""
        original_cwd = os.getcwd()
        all_passed_tests = []

        try:
            # Build base command
            base_cmd = ["snforge", "test"]
            if test_filter:
                base_cmd.append(test_filter)
            base_cmd.append("--save-trace-data")

            # List of directories to run tests in
            test_directories = [self.src_dir] + self.contracts_paths

            # Create indeterminate progress for test execution
            with Progress(
                SpinnerColumn(),
                TextColumn("[progress.description]{task.description}"),
                TimeElapsedColumn(),
                console=console,
                transient=True,
            ) as progress:
                if test_filter:
                    task_desc = (
                        f"Running tests matching: [bold cyan]{test_filter}[/bold cyan]"
                    )
                else:
                    task_desc = "Running [bold cyan]all tests[/bold cyan]"

                task = progress.add_task(task_desc, total=None)

                # Run tests in each directory and capture stdout
                success_count = 0
                for test_dir in test_directories:
                    if not test_dir.exists():
                        log(
                            f"Skipping non-existent directory: {test_dir}",
                            level="debug",
                        )
                        continue

                    # Check if directory has Scarb.toml (indicating it's a Cairo project)
                    scarb_toml = test_dir / "Scarb.toml"
                    if not scarb_toml.exists():
                        log(
                            f"Skipping directory without Scarb.toml: {test_dir}",
                            level="debug",
                        )
                        continue

                    log(f"Running tests in: {test_dir}", level="debug")

                    # Change to the test directory
                    os.chdir(test_dir)

                    # Run the snforge test command and capture output
                    result = subprocess.run(base_cmd, capture_output=True, text=True)

                    if result.returncode == 0:
                        success_count += 1
                        # Extract passed test names from stdout
                        passed_tests = self.extract_passed_tests_from_stdout(
                            result.stdout
                        )
                        all_passed_tests.extend(passed_tests)
                        log(
                            f"Found {len(passed_tests)} passed tests in {test_dir.name}",
                            level="debug",
                        )
                    else:
                        log(
                            f"Tests failed in {test_dir}: {result.stderr}",
                            level="warning",
                        )

            # Return to original directory
            os.chdir(original_cwd)

            if success_count > 0:
                log(
                    f"Tests completed successfully. Found {len(all_passed_tests)} passed tests total",
                    level="success",
                )
                return True, all_passed_tests
            else:
                log("No tests were successfully executed", level="error")
                return False, []

        except Exception as e:
            log(f"Error running snforge test: {e}", level="error")
            return False, []
        finally:
            os.chdir(original_cwd)

    def find_trace_files_from_test_names(
        self, passed_test_names: list[str]
    ) -> list[tuple[str, Path, Path]]:
        """Find trace files based on passed test names by predicting their paths."""
        found_traces = []
        trace_dirs = self.get_all_trace_directories()

        for test_name in passed_test_names:
            # Try to find the trace file in each possible trace directory
            trace_found = False
            for trace_dir in trace_dirs:
                if not trace_dir.exists():
                    continue

                predicted_path = TestResourceInfo.predict_trace_path(
                    test_name, trace_dir
                )
                if predicted_path.exists():
                    found_traces.append((test_name, predicted_path, trace_dir.parent))
                    trace_found = True
                    break

            if not trace_found:
                log(
                    f"Warning: No trace file found for test {test_name}",
                    level="warning",
                )

        log(
            f"Found trace files for {len(found_traces)} out of {len(passed_test_names)} passed tests",
            level="info",
        )
        return found_traces

    def generate_profile_from_trace(self, trace_file: Path) -> Path:
        """Generate profile data from trace file using cairo-profiler."""
        profile_file = trace_file.parent / f"{trace_file.stem}.pb.gz"

        try:
            cmd = [
                "cairo-profiler",
                "build-profile",
                str(trace_file),
                "--output-path",
                str(profile_file),
            ]
            _run_command(cmd)
            return profile_file
        except RuntimeError as e:
            log(f"cairo-profiler failed for {trace_file.name}: {e}", level="error")
            return None

    def extract_resources_from_profile(self, profile_file: Path) -> dict:
        """Extract resource information from profile file using cairo-profiler."""
        try:
            # Get list of available samples
            list_cmd = ["cairo-profiler", "view", str(profile_file), "--list-samples"]
            list_result = _run_command(list_cmd)

            # Parse and filter samples
            samples = [
                line.strip()
                for line in list_result.stdout.strip().split("\n")
                if line.strip() and line.strip() not in EXCLUDED_PROFILE_SAMPLES
            ]

            # Extract resource counts for each sample
            resources = {}
            for sample in samples:
                try:
                    sample_cmd = [
                        "cairo-profiler",
                        "view",
                        str(profile_file),
                        "--sample",
                        sample,
                    ]
                    sample_result = _run_command(sample_cmd)

                    # Parse the output to extract the total count
                    pattern = rf"of (\d+) {re.escape(sample)} total"
                    match = re.search(pattern, sample_result.stdout, re.IGNORECASE)

                    if match:
                        count = int(match.group(1))
                        normalized_name = self._normalize_sample_name(sample)
                        if normalized_name:
                            resources[normalized_name] = count

                except RuntimeError as e:
                    log(f"Failed to extract sample '{sample}': {e}", level="debug")
                    continue

            return resources

        except RuntimeError as e:
            log(f"Failed to list samples from {profile_file.name}: {e}", level="error")
            return {}

    def _normalize_sample_name(self, sample_name: str) -> str:
        """Normalize cairo-profiler sample name to match SIERRA_GAS_WEIGHTS keys."""
        # Mapping from cairo-profiler sample names to our weight table keys
        name_mapping = {
            "steps": "steps",
            "range check": "range_check",
            "range check96": "range_check96",
            "range check builtin": "range_check",
            "range check96 builtin": "range_check96",
            "keccak": "keccak",
            "pedersen": "pedersen",
            "bitwise": "bitwise",
            "bitwise builtin": "bitwise",
            "ecop": "ecop",
            "poseidon": "poseidon",
            "add mod": "add_mod",
            "add mod builtin": "add_mod",
            "mul mod": "mul_mod",
            "mul mod builtin": "mul_mod",
        }

        normalized = sample_name.lower().strip()
        return name_mapping.get(normalized)

    def generate_pprof_image(self, profile_file: Path, output_path: Path):
        """Generate PNG image from profile file using pprof."""
        try:
            cmd = [
                "go",
                "tool",
                "pprof",
                "-png",
                "-sample_index=steps",
                "-output",
                str(output_path),
                str(profile_file),
            ]
            _run_command(cmd)
            return True
        except RuntimeError as e:
            log(f"pprof failed for {profile_file.name}: {e}", level="error")
            return False

    def update_global_summary_json(
        self, test_resources: list[TestResourceInfo], timestamp: str
    ):
        """Update the global summary JSON file in docs/benchmarks/."""
        summary_file = self.docs_benchmarks / "test_summary.json"
        summary_data = _read_json_file(summary_file, {})

        # Update summary with new test results
        for test_info in test_resources:
            summary_data[test_info.test_name_simple] = {
                "last_updated": timestamp,
                "full_name": test_info.test_name_hierarchical,
                "latest_metrics": test_info.to_dict(timestamp),
            }

        # Save updated summary
        if _write_json_file(summary_file, summary_data):
            log("Performance data saved", level="success")

    def process_single_trace_file_from_test_name(
        self, test_name: str, trace_file_path: Path, package_path: Path, timestamp: str
    ) -> tuple[bool, str, str, TestResourceInfo]:
        """Process a single trace file identified by test name.

        Args:
            test_name: Hierarchical test name from snforge output
            trace_file_path: Path to the actual trace file
            package_path: Package/workspace path for context
            timestamp: Timestamp string for file naming

        Returns:
            tuple: (success: bool, test_name: str, image_path: str, test_info: TestResourceInfo)
        """
        try:
            # Generate profile from trace
            profile_file = self.generate_profile_from_trace(trace_file_path)
            if not profile_file or not profile_file.exists():
                return False, test_name, "", None

            # Extract resources from profile file using cairo-profiler
            resources = self.extract_resources_from_profile(profile_file)

            # Get steps count (required field)
            steps = resources.get("steps", 0)

            # Extract builtins (everything except steps)
            builtins = {k: v for k, v in resources.items() if k != "steps"}

            # Generate image filename from simple test name
            test_name_simple = test_name.split("::")[-1]
            image_filename_base = test_name_simple

            # Generate image for docs/benchmarks/
            docs_image_path = self.docs_benchmarks / f"{image_filename_base}.png"
            log(f"Generating image for {docs_image_path}", level="info")
            docs_success = self.generate_pprof_image(profile_file, docs_image_path)

            # Create relative image path
            relative_image_path = f"docs/benchmarks/{image_filename_base}.png"

            # Determine category from hierarchical test name
            category = "contracts" if not test_name.startswith("garaga::") else "garaga"

            test_info = TestResourceInfo(
                test_name_hierarchical=test_name,
                test_name_simple=test_name_simple,
                predicted_trace_path=TestResourceInfo.predict_trace_path(
                    test_name, trace_file_path.parent
                ),
                actual_trace_path=trace_file_path,
                profile_file_path=profile_file,
                steps=steps,
                builtins=builtins,
                image_path=relative_image_path,
                category=category,
            )

            return (
                docs_success,
                test_name,
                relative_image_path,
                test_info,
            )

        except Exception as e:
            log(
                f"Error processing trace file {trace_file_path.name}: {e}",
                level="debug",
            )
            return False, test_name, "", None

    def process_passed_tests_and_generate_profiles(
        self, passed_test_names: list[str], parallel_jobs: int = 4
    ):
        """Process passed tests, extract resources, and generate profile data and images."""
        global _shutdown_requested

        # Find trace files from test names
        trace_file_info = self.find_trace_files_from_test_names(passed_test_names)

        if not trace_file_info:
            log("No trace files found for passed tests", level="warning")
            return []

        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        timestamp_iso = datetime.now().isoformat()
        test_resources = []

        # Beautiful header for processing phase
        print_header(
            f"🚀 Processing {len(trace_file_info)} tests with {parallel_jobs} parallel jobs"
        )

        # Process trace files in parallel
        try:
            with ThreadPoolExecutor(max_workers=parallel_jobs) as executor:
                # Submit all tasks using test names and trace paths
                future_to_test = {
                    executor.submit(
                        self.process_single_trace_file_from_test_name,
                        test_name,
                        trace_path,
                        package_path,
                        timestamp,
                    ): test_name
                    for test_name, trace_path, package_path in trace_file_info
                }

                # Check for early shutdown
                if _shutdown_requested:
                    _handle_shutdown_request(executor, future_to_test)
                    return test_resources

                # Process completed futures with progress tracking
                success_count = self._process_test_futures_with_progress(
                    future_to_test, test_resources
                )

        except KeyboardInterrupt:
            log("Keyboard interrupt received during processing", level="warning")
            return test_resources

        # Update JSON files with extracted test resource data
        if test_resources:
            with Progress(
                SpinnerColumn(),
                TextColumn("Saving performance data..."),
                console=console,
                transient=True,
            ) as progress:
                task = progress.add_task("", total=None)
                # Update global summary
                self.update_global_summary_json(test_resources, timestamp_iso)

        if _shutdown_requested:
            log(
                f"Processing interrupted. Completed {success_count} out of {len(trace_file_info)} tests",
                level="warning",
            )
        else:
            log(
                f"Successfully processed [bold cyan]{success_count}[/bold cyan] out of [bold cyan]{len(trace_file_info)}[/bold cyan] tests",
                level="success",
            )

        return test_resources

    def _process_test_futures_with_progress(self, future_to_test, test_resources):
        """Process completed futures with progress tracking for test-based approach."""
        completed_futures = set()
        success_count = 0

        with create_progress(True) as progress:
            task = progress.add_task("Processing tests", total=len(future_to_test))

            while len(completed_futures) < len(future_to_test):
                if _shutdown_requested:
                    return success_count

                # Check for newly completed futures
                for future in list(future_to_test.keys()):
                    if future in completed_futures or not future.done():
                        continue

                    completed_futures.add(future)
                    test_name = future_to_test[future]

                    if self._process_completed_test_future(
                        future, test_name, test_resources
                    ):
                        success_count += 1

                    progress.advance(task, 1)

                # Small sleep to prevent busy waiting but still be responsive
                time.sleep(0.1)

        return success_count

    def _process_completed_test_future(self, future, test_name, test_resources):
        """Process a single completed future and return success status."""
        try:
            success, returned_test_name, image_path, test_info = future.result()
            if success and test_info:
                test_resources.append(test_info)
                console.print(f"✨ [green]{test_name}[/green]")
                return True
            else:
                console.print(f"💥 [red]{test_name}[/red]")
                return False
        except Exception as e:
            if _shutdown_requested:
                return False
            console.print(f"💥 [red]{test_name}[/red]: {e}")
            return False

    def run_profile_workflow(
        self,
        test_filter: str = None,
        parallel_jobs: int = 2,
        generate_benchmarks: bool = False,
    ):
        """Run the complete profiling workflow."""
        global _shutdown_requested

        # Check dependencies
        if not self.check_dependencies():
            return False

        # Setup directories
        self.setup_directories()

        # Clean up any existing temp directories
        self.cleanup_temp_directories()

        try:
            # Check for early shutdown
            if _shutdown_requested:
                log("Shutdown requested before test execution", level="info")
                return False

            # Run the test with trace data collection
            print_header("🧪 Running Tests & Collecting Traces")
            success, all_passed_tests = self.run_snforge_test_with_trace_and_capture(
                test_filter
            )
            if not success:
                log("Test execution failed", level="error")
                return False

            # Check for shutdown after test execution
            if _shutdown_requested:
                log("Shutdown requested after test execution", level="info")
                return False

            # Process trace files, extract resources, and generate profiles
            print_header("🚀 Processing Traces & Extracting Resources")
            test_resources = self.process_passed_tests_and_generate_profiles(
                all_passed_tests, parallel_jobs
            )

            # Check results
            if not test_resources:
                if _shutdown_requested:
                    log("Profile processing interrupted by user", level="info")
                else:
                    log(
                        "Profile processing failed - no test resources extracted",
                        level="error",
                    )
                return False

            if _shutdown_requested:
                log(
                    "Profiling workflow interrupted but partially completed",
                    level="info",
                )
            else:
                print_header("🎯 Workflow Complete")
                log("Profiling workflow completed successfully!", level="success")
            return True

        except Exception as e:
            if _shutdown_requested:
                log("Exception during shutdown - this is expected", level="info")
            else:
                log(f"Unexpected error in workflow: {e}", level="error")
            return False
        finally:
            # Always clean up temporary directories, even on interrupt
            try:
                self.cleanup_temp_directories()
                if _shutdown_requested:
                    log("Cleanup completed. Exiting gracefully.", level="success")
            except Exception as e:
                log(f"Error during cleanup: {e}", level="warning")

            # Generate Cairo benchmarks only if requested
            if generate_benchmarks:
                try:
                    self.generate_cairo_benchmarks()
                except Exception as e:
                    log(f"Error generating Cairo benchmarks: {e}", level="warning")

    def parse_test_summary_json(self) -> dict:
        """Parse the test summary JSON file."""
        summary_file = self.docs_benchmarks / "test_summary.json"
        if not summary_file.exists():
            log("No test summary file found to generate benchmarks", level="warning")
            return {}

        data = _read_json_file(summary_file, {})
        if not data:
            log("Could not parse test summary file", level="error")
        return data

    def group_tests_by_module(self, test_data: dict) -> dict:
        """Group tests by their module hierarchy with main categories."""
        # Create main categories
        main_grouped = {
            "garaga": defaultdict(lambda: defaultdict(list)),
            "contracts": defaultdict(lambda: defaultdict(list)),
        }

        for test_name, test_info in test_data.items():
            latest_metrics = test_info.get("latest_metrics", {})
            if not latest_metrics:
                continue

            # Get the hierarchical test name and category directly from metrics
            hierarchical_name = latest_metrics.get("test_name_hierarchical", "")
            if not hierarchical_name:
                # Fallback to old format
                hierarchical_name = latest_metrics.get("full_name", "")

            category = latest_metrics.get("category", "garaga")

            # Extract hierarchy parts using the static method
            hierarchy_parts = TestResourceInfo.extract_hierarchy_parts(
                hierarchical_name
            )

            # Create nested structure within the main category
            current = main_grouped[category]
            for module in hierarchy_parts[:-1]:
                if module not in current:
                    current[module] = defaultdict(list)
                current = current[module]

            # Add test to the final module
            final_module = hierarchy_parts[-1] if hierarchy_parts else "tests"
            # Ensure current[final_module] is a list
            if not isinstance(current[final_module], list):
                current[final_module] = []
            current[final_module].append(latest_metrics)

        # Convert defaultdicts to regular dicts and remove empty categories
        result = {}
        for category, category_data in main_grouped.items():
            if category_data:  # Only include non-empty categories
                result[category] = dict(category_data)

        return result

    def create_benchmark_dataframe(self, tests: list) -> pd.DataFrame:
        """Convert test data to pandas DataFrame for table generation."""
        if not tests:
            return pd.DataFrame()

        # Define the columns in the desired order (sierra_gas moved to end)
        columns = [
            "test_name",
            "steps",
            "range_check",
            "range_check96",
            "bitwise",
            "poseidon",
            "add_mod",
            "mul_mod",
            "keccak",
            "pedersen",
            "ecop",
            "syscalls_count",
            "sierra_gas",
            "image_path",  # Include image_path for link generation
        ]

        # Create DataFrame
        df = pd.DataFrame(tests)

        # Select only available columns
        available_columns = [col for col in columns if col in df.columns]
        df = df[available_columns]

        # Remove columns where all values are 0 (except test_name, steps, sierra_gas, and image_path)
        essential_columns = ["test_name", "steps", "sierra_gas", "image_path"]
        for col in df.columns:
            if col not in essential_columns:
                if (df[col] == 0).all():
                    df = df.drop(columns=[col])

        # Sort by sierra_gas descending
        if "sierra_gas" in df.columns:
            df = df.sort_values("sierra_gas", ascending=False)

        return df

    def generate_markdown_table(self, df: pd.DataFrame) -> str:
        """Generate markdown table using tabulate."""
        if df.empty:
            return "*No tests found.*\n"

        # Create a copy to avoid modifying the original DataFrame
        df = df.copy()

        # Convert test names to clickable links to profile images
        if "test_name" in df.columns:

            def create_link(row):
                test_name = row["test_name"]
                # Use stored image_path if available, otherwise fall back to constructed path
                if "image_path" in row and row["image_path"]:
                    image_path = row["image_path"]
                else:
                    # Fallback to constructed path for backward compatibility
                    image_path = f"docs/benchmarks/{test_name}.png"
                return f"[{test_name}]({image_path})"

            df["test_name"] = df.apply(create_link, axis=1)

        # Format large numbers with commas
        numeric_columns = [
            "steps",
            "range_check",
            "range_check96",
            "bitwise",
            "poseidon",
            "add_mod",
            "mul_mod",
            "keccak",
            "pedersen",
            "ecop",
            "syscalls_count",
            "sierra_gas",
        ]

        for col in numeric_columns:
            if col in df.columns:
                df[col] = df[col].apply(lambda x: f"{x:,}" if pd.notna(x) else "0")

        # Rename columns for display (exclude image_path from display)
        column_mapping = {
            "test_name": "Test Name",
            "steps": "Steps",
            "range_check": "Range Check",
            "range_check96": "Range Check 96",
            "bitwise": "Bitwise",
            "poseidon": "Poseidon",
            "add_mod": "Add Mod",
            "mul_mod": "Mul Mod",
            "keccak": "Keccak",
            "pedersen": "Pedersen",
            "ecop": "ECOP",
            "syscalls_count": "Syscalls",
            "sierra_gas": "Sierra Gas",
        }

        # Remove image_path column before display if it exists
        display_df = df.drop(columns=["image_path"], errors="ignore")
        df_display = display_df.rename(columns=column_mapping)

        return (
            tabulate(df_display, headers="keys", tablefmt="github", showindex=False)
            + "\n"
        )

    def generate_collapsible_section(
        self, title: str, content: str, is_open: bool = False, indent_level: int = 0
    ) -> str:
        """Generate collapsible markdown section with visual indentation."""
        open_attr = " open" if is_open else ""

        # Create proper tree structure with different indentation levels
        if indent_level > 0:
            # Each level gets progressively more indentation
            base_indent = "│   " * (indent_level - 1)
            branch = "└── "
            title = f"{base_indent}{branch}{title}"

        return f"""<details{open_attr}>
<summary><strong>{title}</strong></summary>

{content}
</details>

"""

    def generate_nested_hierarchy(
        self, grouped_data: dict, current_path: list = None
    ) -> str:
        """Generate nested collapsible hierarchy from grouped test data."""
        if current_path is None:
            current_path = []

        content = ""

        for module_name, module_data in grouped_data.items():
            new_path = current_path + [module_name]

            if isinstance(module_data, list):
                # This is a leaf module with tests - always closed so users click to see data
                df = self.create_benchmark_dataframe(module_data)
                table_content = self.generate_markdown_table(df)

                is_open = False  # Always closed for test data
                content += self.generate_collapsible_section(
                    module_name, table_content, is_open, len(current_path)
                )

            elif isinstance(module_data, dict):
                # Check if this is a chain of single children that can be merged
                merged_name = module_name
                current_data = module_data

                # Keep merging while there's only one child
                while len(current_data) == 1:
                    child_name = list(current_data.keys())[0]
                    child_data = list(current_data.values())[0]

                    # If the child is a list (tests), merge it and stop
                    if isinstance(child_data, list):
                        merged_name += "::" + child_name

                        # Generate content for the merged leaf section
                        df = self.create_benchmark_dataframe(child_data)
                        table_content = self.generate_markdown_table(df)

                        is_open = False  # Always closed for test data
                        content += self.generate_collapsible_section(
                            merged_name, table_content, is_open, len(current_path)
                        )
                        break

                    # If the child is a dict, continue merging
                    elif isinstance(child_data, dict):
                        merged_name += "::" + child_name
                        current_data = child_data
                    else:
                        break
                else:
                    # No more single children to merge, generate nested content
                    inner_content = self.generate_nested_hierarchy(
                        current_data, new_path
                    )

                    # Top-level categories (garaga, contracts) are closed by default
                    # Intermediate modules are open by default to show full hierarchy
                    if len(current_path) == 0:
                        # This is a top-level tree (garaga or contracts)
                        is_open = False
                    else:
                        # This is an intermediate module
                        is_open = True

                    content += self.generate_collapsible_section(
                        merged_name, inner_content, is_open, len(current_path)
                    )

        return content

    def find_cairo_benchmarks_section(self, readme_content: str) -> tuple[int, int]:
        """Find the Cairo Benchmarks section in README content."""
        lines = readme_content.split("\n")
        start_idx = None
        end_idx = None

        for i, line in enumerate(lines):
            if line.strip() == "## Cairo Benchmarks":
                start_idx = i
            elif (
                start_idx is not None
                and line.startswith("## ")
                and line.strip() != "## Cairo Benchmarks"
            ):
                end_idx = i
                break

        if start_idx is not None and end_idx is None:
            end_idx = len(lines)

        return start_idx, end_idx

    def generate_cairo_benchmarks_content(self, test_data: dict) -> str:
        """Generate complete Cairo benchmarks content with proper spacing."""
        if not test_data:
            return """## Cairo Benchmarks

*No benchmark data available.*

"""

        grouped_data = self.group_tests_by_module(test_data)
        hierarchy_content = self.generate_nested_hierarchy(grouped_data)

        # Ensure content ends with proper spacing
        return f"""## Cairo Benchmarks

📊 **Click on any section below to expand and view detailed benchmark tables with test performance metrics.**

{hierarchy_content.rstrip()}

---
🔄 **To regenerate these benchmarks:** Run `make benchmarks` from the project root.

"""

    def update_readme_with_benchmarks(self, test_data: dict):
        """Update README.md with Cairo benchmarks section."""
        readme_path = self.workspace_root / "README.md"

        if not readme_path.exists():
            log("README.md not found", level="error")
            return False

        try:
            # Read current README
            with open(readme_path, "r", encoding="utf-8") as f:
                content = f.read()

            # Find existing benchmarks section
            start_idx, end_idx = self.find_cairo_benchmarks_section(content)
            lines = content.split("\n")

            # Generate new benchmarks content
            new_content = self.generate_cairo_benchmarks_content(test_data)
            new_lines = new_content.rstrip().split("\n")

            if start_idx is not None:
                # Replace existing section, ensuring we maintain proper spacing
                # Look ahead to see if there's already blank line(s) after the section
                if end_idx < len(lines) and lines[end_idx - 1].strip() == "":
                    # There's already a blank line before the next section
                    updated_lines = lines[:start_idx] + new_lines + lines[end_idx:]
                else:
                    # Add a blank line to separate from the next section
                    updated_lines = (
                        lines[:start_idx] + new_lines + [""] + lines[end_idx:]
                    )
            else:
                # Add new section before "Support & How to Contribute"
                support_idx = None
                for i, line in enumerate(lines):
                    if "Support & How to Contribute" in line:
                        support_idx = i
                        break

                if support_idx is not None:
                    # Ensure there's proper spacing before the Support section
                    updated_lines = (
                        lines[:support_idx] + new_lines + [""] + lines[support_idx:]
                    )
                else:
                    # Add at the end
                    updated_lines = lines + [""] + new_lines

            # Write updated README
            with open(readme_path, "w", encoding="utf-8") as f:
                f.write("\n".join(updated_lines))

            log("Updated README.md with Cairo benchmarks", level="success")
            return True

        except IOError as e:
            log(f"Could not update README.md: {e}", level="error")
            return False

    def generate_cairo_benchmarks(self):
        """Generate and update Cairo benchmarks in README.md."""
        log("Generating Cairo benchmarks...", level="info")

        # Parse test summary data
        test_data = self.parse_test_summary_json()

        if not test_data:
            log("No test data available for benchmarks", level="warning")
            return False

        # Update README with benchmarks
        success = self.update_readme_with_benchmarks(test_data)

        if success:
            log(f"Generated benchmarks for {len(test_data)} tests", level="success")

        return success


def main():
    """Main entry point."""
    print_header("🐺 Garaga Test Profiler")

    # Setup argument parser
    parser = argparse.ArgumentParser(
        description="Run snforge tests with profiling and generate performance visualizations",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
    python tools/profile_tests.py msm_BN254_1P
    python tools/profile_tests.py --all
    python tools/profile_tests.py test_scalar_to_epns --parallel-jobs 4
        """,
    )

    parser.add_argument("test_filter", nargs="?", help="Test name filter (optional)")
    parser.add_argument("--all", action="store_true", help="Run all tests")
    parser.add_argument(
        "--workspace", help="Workspace root path (default: current directory)"
    )
    parser.add_argument(
        "--verbose", "-v", action="store_true", help="Enable verbose logging"
    )
    parser.add_argument(
        "--parallel-jobs", type=int, default=2, help="Number of parallel jobs"
    )
    parser.add_argument(
        "--generate-benchmarks",
        action="store_true",
        help="Generate Cairo benchmarks after profiling",
    )
    parser.add_argument(
        "--benchmarks-only", action="store_true", help="Only generate Cairo benchmarks"
    )

    args = parser.parse_args()

    # Handle benchmarks-only mode
    if args.benchmarks_only:
        log("🎯 Running in [bold cyan]benchmarks-only[/bold cyan] mode", level="info")
        profiler = ProfileTestRunner(workspace_root=args.workspace)
        success = profiler.generate_cairo_benchmarks()

        if success:
            show_exit_panel(
                "📊 Cairo benchmarks generated successfully!", "Success", "green"
            )
            sys.exit(0)
        else:
            show_exit_panel("💥 Failed to generate Cairo benchmarks!", "Error", "red")
            sys.exit(1)

    # Validate parallel jobs
    if not (1 <= args.parallel_jobs <= 8):
        if args.parallel_jobs < 1:
            log("--parallel-jobs must be at least 1", level="error")
            sys.exit(1)
        else:
            log(
                f"Using {args.parallel_jobs} parallel jobs may overwhelm the system. Consider using fewer jobs.",
                level="warning",
            )

    # Determine test filter and show configuration
    test_filter = None if args.all else args.test_filter
    if test_filter:
        log(
            f"🎯 Running tests matching: [bold cyan]{test_filter}[/bold cyan]",
            level="info",
        )
    else:
        log("🎯 Running [bold cyan]all tests[/bold cyan]", level="info")
    log(
        f"⚡ Using [bold cyan]{args.parallel_jobs}[/bold cyan] parallel jobs",
        level="info",
    )

    # Run profiling workflow
    profiler = ProfileTestRunner(workspace_root=args.workspace)
    success = profiler.run_profile_workflow(
        test_filter, args.parallel_jobs, args.generate_benchmarks
    )

    # Handle results
    if _shutdown_requested:
        show_exit_panel(
            "👋 Process interrupted by user\nPartial results may be available",
            "Interrupted",
            "yellow",
        )
        sys.exit(130)
    elif success:
        show_exit_panel("🎉 All operations completed successfully!", "Success", "green")
        sys.exit(0)
    else:
        show_exit_panel("💥 Workflow failed!", "Error", "red")
        sys.exit(1)


if __name__ == "__main__":
    main()
