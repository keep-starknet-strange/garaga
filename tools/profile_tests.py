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
import json
import os
import re
import shutil
import signal
import subprocess
import sys
import time
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


def log_info(message: str, emoji: str = "ℹ️"):
    """Log info message with beautiful formatting."""
    console.print(f"{emoji} [dim]{message}[/dim]")


def log_success(message: str, emoji: str = "✅"):
    """Log success message with beautiful formatting."""
    console.print(f"{emoji} [green]{message}[/green]")


def log_warning(message: str, emoji: str = "⚠️"):
    """Log warning message with beautiful formatting."""
    console.print(f"{emoji} [yellow]{message}[/yellow]")


def log_error(message: str, emoji: str = "❌"):
    """Log error message with beautiful formatting."""
    console.print(f"{emoji} [bold red]{message}[/bold red]")


def log_debug(message: str, emoji: str = "🔍"):
    """Log debug message with beautiful formatting."""
    if console.is_terminal:  # Only show debug in terminal mode
        console.print(f"{emoji} [dim cyan]{message}[/dim cyan]")


def print_header(title: str):
    """Print a beautiful header."""
    panel = Panel(
        Align.center(Text(title, style="bold cyan")),
        border_style="cyan",
        padding=(0, 1),
        width=80,
    )
    console.print(panel)


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


@dataclass
class TestResourceInfo:
    """Container for parsed test resource information."""

    full_name: str
    steps: int
    builtins: dict = field(default_factory=dict)
    syscalls: list = field(default_factory=list)
    test_name: str = field(init=False)
    sierra_gas: int = field(init=False)

    def __post_init__(self):
        """Calculate derived fields after initialization."""
        self.test_name = self._extract_test_name(self.full_name)
        self.sierra_gas = self._calculate_sierra_gas()

    def _extract_test_name(self, full_name: str) -> str:
        """Extract the test name from the full qualified name."""
        return full_name.split("::")[-1]

    def _calculate_sierra_gas(self) -> int:
        """Calculate Sierra gas using the weight table."""
        total_gas = self.steps * SIERRA_GAS_WEIGHTS["steps"]

        for builtin_name, count in self.builtins.items():
            if builtin_name in SIERRA_GAS_WEIGHTS:
                total_gas += count * SIERRA_GAS_WEIGHTS[builtin_name]
            else:
                log_warning(f"Unknown builtin '{builtin_name}' not in weight table")

        return total_gas

    def to_dict(self, timestamp: str = None) -> dict:
        """Convert to dictionary for JSON serialization."""
        if timestamp is None:
            timestamp = datetime.now().isoformat()

        result = {
            "timestamp": timestamp,
            "full_name": self.full_name,
            "test_name": self.test_name,
            "steps": self.steps,
            "sierra_gas": self.sierra_gas,
        }

        # Add individual builtin columns
        for builtin_name in SIERRA_GAS_WEIGHTS.keys():
            if builtin_name != "steps":
                result[builtin_name] = self.builtins.get(builtin_name, 0)

        # Add syscalls count
        result["syscalls_count"] = len(self.syscalls)

        return result


class ProfileTestRunner:
    def __init__(self, workspace_root: str = None):
        """Initialize the profiler runner."""
        self.workspace_root = Path(workspace_root or os.getcwd())
        self.src_dir = self.workspace_root / "src"
        self.trace_dir = self.src_dir / "snfoundry_trace"
        self.docs_benchmarks = self.workspace_root / "docs" / "benchmarks"
        self.cargo_benchmarks = self.workspace_root / ".cargo" / "benchmarks"

    def check_dependencies(self):
        """Check if required tools are available."""
        print_header("🔍 Checking Dependencies")

        # Check if snforge is available
        try:
            result = subprocess.run(
                ["snforge", "--version"], capture_output=True, text=True, check=True
            )
            log_success(f"snforge: {result.stdout.strip()}")
        except (subprocess.CalledProcessError, FileNotFoundError):
            log_error("snforge not found. Please install Starknet Foundry.")
            return False

        # Check if cairo-profiler is available
        try:
            result = subprocess.run(
                ["cairo-profiler", "--version"],
                capture_output=True,
                text=True,
                check=True,
            )
            log_success(f"cairo-profiler: {result.stdout.strip()}")
        except (subprocess.CalledProcessError, FileNotFoundError):
            log_error("cairo-profiler not found. Please install cairo-profiler.")
            return False

        # Check if go tool pprof is available
        try:
            result = subprocess.run(
                ["go", "version"], capture_output=True, text=True, check=True
            )
            log_success(f"go: {result.stdout.strip()}")
        except (subprocess.CalledProcessError, FileNotFoundError):
            log_error("Go not found. Please install Go to use pprof.")
            return False

        console.print("✨ [green]All dependencies satisfied![/green]")
        return True

    def setup_directories(self):
        """Create necessary directories."""
        directories = [self.docs_benchmarks, self.cargo_benchmarks]

        for directory in directories:
            directory.mkdir(parents=True, exist_ok=True)

        log_success("Directories ready")

    def cleanup_temp_directories(self):
        """Remove temporary directories from previous runs."""
        temp_dirs = [self.trace_dir]

        for temp_dir in temp_dirs:
            if temp_dir.exists():
                try:
                    shutil.rmtree(temp_dir)
                except Exception:
                    pass  # Ignore cleanup failures

        log_success("Cleanup completed")

    def parse_test_resources(self, stdout: str) -> list[TestResourceInfo]:
        """Parse test resource information from snforge stdout."""
        # Pattern to match test results with detailed resources
        test_pattern = r"\[PASS\]\s+([^\s]+)\s+\([^)]+\)\s*\n\s*steps:\s*(\d+)\s*\n\s*memory holes:[^\n]*\n\s*builtins:\s*\(([^)]*)\)\s*\n\s*syscalls:\s*\(([^)]*)\)"

        matches = list(re.finditer(test_pattern, stdout, re.MULTILINE))
        test_resources = []

        if not matches:
            log_warning("No test resource data found to parse")
            return test_resources

        # Create progress bar for parsing
        with Progress(
            SpinnerColumn(),
            TextColumn("[progress.description]{task.description}"),
            BarColumn(bar_width=30, style="cyan", complete_style="green"),
            TaskProgressColumn(),
            "•",
            TimeElapsedColumn(),
            console=console,
            transient=True,
        ) as progress:
            task = progress.add_task("Parsing test resources", total=len(matches))

            for match in matches:
                full_name = match.group(1).strip()
                steps = int(match.group(2))
                builtins_str = match.group(3).strip()
                syscalls_str = match.group(4).strip()

                # Parse builtins
                builtins = {}
                if builtins_str:
                    builtin_pairs = re.findall(r"(\w+):\s*(\d+)", builtins_str)
                    builtins = {name: int(count) for name, count in builtin_pairs}

                # Parse syscalls
                syscalls = []
                if syscalls_str:
                    syscalls = [s.strip() for s in syscalls_str.split(",") if s.strip()]

                test_info = TestResourceInfo(full_name, steps, builtins, syscalls)
                test_resources.append(test_info)

                progress.update(task, advance=1)

        log_success(
            f"Parsed [bold cyan]{len(test_resources)}[/bold cyan] test resource entries"
        )
        return test_resources

    def run_snforge_test_with_trace(self, test_filter: str = None):
        """Run snforge test with trace data collection."""
        # Change to src directory for the test
        original_cwd = os.getcwd()
        try:
            os.chdir(self.src_dir)

            cmd = ["snforge", "test"]
            if test_filter:
                cmd.append(test_filter)
            cmd.extend(["--save-trace-data", "--detailed-resources"])

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

                result = subprocess.run(cmd, capture_output=True, text=True)

                if result.returncode != 0:
                    log_error(
                        f"snforge test failed with return code {result.returncode}"
                    )
                    log_error(f"stderr: {result.stderr}")
                    return False, ""

            log_success("Tests completed successfully")
            return True, result.stdout

        except Exception as e:
            log_error(f"Error running snforge test: {e}")
            return False, ""
        finally:
            os.chdir(original_cwd)

    def find_trace_files(self):
        """Find all .json trace files in the trace directory."""
        if not self.trace_dir.exists():
            log_error(f"Trace directory not found: {self.trace_dir}")
            return []

        trace_files = list(self.trace_dir.glob("*.json"))
        log_success(f"Found [bold cyan]{len(trace_files)}[/bold cyan] trace files")
        return trace_files

    def extract_test_name_from_trace_file(self, trace_file: Path) -> str:
        """Extract test name from trace file path."""
        # Trace files are typically named like: garaga_tests_autogenerated_msm_tests_test_msm_BN254_1P.json
        filename = trace_file.stem
        # Extract the test name (last part after splitting by underscores starting with 'test_')
        parts = filename.split("_")
        for i, part in enumerate(parts):
            if part == "test" and i + 1 < len(parts):
                # Join all parts from 'test_' onwards
                return "_".join(parts[i:])

        # Fallback - just use the filename without extension
        return filename

    def generate_profile_from_trace(self, trace_file: Path) -> Path:
        """Generate profile data from trace file using cairo-profiler."""
        test_name = self.extract_test_name_from_trace_file(trace_file)
        profile_file = trace_file.parent / f"{test_name}.pb.gz"

        try:
            cmd = [
                "cairo-profiler",
                "build-profile",
                str(trace_file),
                "--output-path",
                str(profile_file),
            ]

            result = subprocess.run(cmd, capture_output=True, text=True, check=True)
            return profile_file

        except subprocess.CalledProcessError as e:
            log_error(f"cairo-profiler failed for {trace_file.name}: {e.stderr}")
            return None
        except Exception as e:
            log_error(f"Error generating profile from trace: {e}")
            return None

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

            result = subprocess.run(cmd, capture_output=True, text=True, check=True)
            return True

        except subprocess.CalledProcessError as e:
            log_error(f"pprof failed for {profile_file.name}: {e.stderr}")
            return False
        except Exception as e:
            log_error(f"Error generating pprof image: {e}")
            return False

    def update_test_history_json(self, test_info: TestResourceInfo, timestamp: str):
        """Update the test history JSON file for a specific test."""
        test_dir = self.cargo_benchmarks / test_info.test_name
        test_dir.mkdir(parents=True, exist_ok=True)

        history_file = test_dir / "test_history.json"

        # Load existing history or create new
        history_data = []
        if history_file.exists():
            try:
                with open(history_file, "r") as f:
                    history_data = json.load(f)
            except (json.JSONDecodeError, IOError):
                history_data = []

        # Add new entry for this specific test
        new_entry = test_info.to_dict(timestamp)
        history_data.append(new_entry)

        # Save updated history
        try:
            with open(history_file, "w") as f:
                json.dump(history_data, f, indent=2)
        except IOError as e:
            log_error(f"Could not save test history {history_file}: {e}")

    def update_global_summary_json(
        self, test_resources: list[TestResourceInfo], timestamp: str
    ):
        """Update the global summary JSON file in docs/benchmarks/."""
        summary_file = self.docs_benchmarks / "test_summary.json"

        # Load existing summary or create new
        summary_data = {}
        if summary_file.exists():
            try:
                with open(summary_file, "r") as f:
                    summary_data = json.load(f)
            except (json.JSONDecodeError, IOError):
                summary_data = {}

        # Update summary with new test results
        for test_info in test_resources:
            summary_data[test_info.test_name] = {
                "last_updated": timestamp,
                "full_name": test_info.full_name,
                "latest_metrics": test_info.to_dict(timestamp),
            }

        # Save updated summary
        try:
            with open(summary_file, "w") as f:
                json.dump(summary_data, f, indent=2)
            log_success("Performance data saved")
        except IOError as e:
            log_error(f"Could not save global summary {summary_file}: {e}")

    def process_single_trace_file(
        self, trace_file: Path, test_info_map: dict, timestamp: str
    ) -> tuple[bool, str]:
        """Process a single trace file and generate profile images.

        Returns:
            tuple: (success: bool, test_name: str)
        """
        test_name = self.extract_test_name_from_trace_file(trace_file)

        try:
            # Generate profile from trace
            profile_file = self.generate_profile_from_trace(trace_file)
            if not profile_file or not profile_file.exists():
                return False, test_name

            # Get test info if available
            test_info = test_info_map.get(test_name)
            if not test_info:
                # Create a basic test info from the test name
                class BasicTestInfo:
                    def __init__(self, test_name):
                        self.test_name = test_name
                        self.full_name = f"unknown::{test_name}"

                test_info = BasicTestInfo(test_name)

            # Generate image for docs/benchmarks/
            docs_image_path = self.docs_benchmarks / f"{test_info.test_name}.png"
            docs_success = self.generate_pprof_image(profile_file, docs_image_path)

            # Generate image for .cargo/benchmarks/test_name/
            test_dir = self.cargo_benchmarks / test_info.test_name
            test_dir.mkdir(parents=True, exist_ok=True)
            cargo_image_path = test_dir / f"profile_{timestamp}.png"
            cargo_success = self.generate_pprof_image(profile_file, cargo_image_path)

            # Clean up the temporary profile file
            try:
                profile_file.unlink()
            except Exception:
                pass  # Ignore cleanup failures

            return docs_success and cargo_success, test_name

        except Exception as e:
            return False, test_name

    def process_trace_and_generate_profiles(
        self, test_resources: list[TestResourceInfo], parallel_jobs: int = 2
    ):
        """Process trace files and generate profile data and images."""
        global _shutdown_requested

        trace_files = self.find_trace_files()

        if not trace_files:
            log_warning("No trace files found to process")
            return False

        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        timestamp_iso = datetime.now().isoformat()
        success_count = 0

        # Update JSON files with test resource data
        if test_resources:
            with Progress(
                SpinnerColumn(),
                TextColumn("Saving performance data..."),
                console=console,
                transient=True,
            ) as progress:
                task = progress.add_task("", total=None)

                for test_info in test_resources:
                    self.update_test_history_json(test_info, timestamp_iso)
                self.update_global_summary_json(test_resources, timestamp_iso)

        # Create a mapping of test names to test resource info
        test_info_map = {}
        if test_resources:
            for test_info in test_resources:
                test_info_map[test_info.test_name] = test_info

        # Beautiful header for processing phase
        print_header(
            f"🚀 Processing {len(trace_files)} tests with {parallel_jobs} parallel jobs"
        )

        # Process trace files in parallel
        try:
            with ThreadPoolExecutor(max_workers=parallel_jobs) as executor:
                # Submit all tasks
                future_to_file = {
                    executor.submit(
                        self.process_single_trace_file,
                        trace_file,
                        test_info_map,
                        timestamp,
                    ): trace_file
                    for trace_file in trace_files
                }

                # Process completed tasks with beautiful progress bar
                with create_file_progress() as progress:
                    task = progress.add_task(
                        "Processing trace files", total=len(trace_files)
                    )

                    completed_futures = set()

                    while len(completed_futures) < len(future_to_file):
                        # Check for shutdown immediately
                        if _shutdown_requested:
                            console.print(
                                "🛑 [bold red]Shutdown requested, cancelling all tasks...[/bold red]"
                            )
                            # Cancel all futures immediately
                            for f in future_to_file:
                                if not f.done():
                                    f.cancel()
                            # Force executor shutdown
                            try:
                                executor.shutdown(wait=False, cancel_futures=True)
                            except TypeError:
                                # Fallback for older Python versions
                                executor.shutdown(wait=False)
                            return success_count > 0

                        # Check for completed futures without blocking
                        for future in list(future_to_file.keys()):
                            if future in completed_futures:
                                continue

                            if future.done():
                                completed_futures.add(future)
                                trace_file = future_to_file[future]

                                try:
                                    success, test_name = future.result()
                                    if success:
                                        success_count += 1
                                        console.print(f"✨ [green]{test_name}[/green]")
                                    else:
                                        console.print(f"💥 [red]{test_name}[/red]")
                                except Exception as e:
                                    if _shutdown_requested:
                                        break
                                    test_name = self.extract_test_name_from_trace_file(
                                        trace_file
                                    )
                                    console.print(f"💥 [red]{test_name}[/red]: {e}")

                                progress.advance(task, 1)

                        # Small sleep to prevent busy waiting but still be responsive
                        time.sleep(0.1)

        except KeyboardInterrupt:
            # This shouldn't happen since we handle SIGINT, but just in case
            log_warning("Keyboard interrupt received during processing")
            return False

        if _shutdown_requested:
            log_warning(
                f"Processing interrupted. Completed {success_count} out of {len(trace_files)} trace files"
            )
            return success_count > 0
        else:
            log_success(
                f"Successfully processed [bold cyan]{success_count}[/bold cyan] out of [bold cyan]{len(trace_files)}[/bold cyan] trace files"
            )
            return success_count > 0

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
                log_info("Shutdown requested before test execution")
                return False

            # Run the test with trace data collection
            print_header("🧪 Running Tests & Collecting Traces")
            success, stdout = self.run_snforge_test_with_trace(test_filter)
            if not success:
                log_error("Test execution failed")
                return False

            # Check for shutdown after test execution
            if _shutdown_requested:
                log_info("Shutdown requested after test execution")
                return False

            # Parse test resource information
            print_header("📊 Parsing Test Resources")
            test_resources = self.parse_test_resources(stdout)

            # Check for shutdown after parsing
            if _shutdown_requested:
                log_info("Shutdown requested after parsing test resources")
                return False

            # Process trace files and generate profiles
            if not self.process_trace_and_generate_profiles(
                test_resources, parallel_jobs
            ):
                if _shutdown_requested:
                    log_info("Profile processing interrupted by user")
                else:
                    log_error("Profile processing failed")
                return False

            if _shutdown_requested:
                log_info("Profiling workflow interrupted but partially completed")
            else:
                print_header("🎯 Workflow Complete")
                log_success("Profiling workflow completed successfully!")
            return True

        except Exception as e:
            if _shutdown_requested:
                log_info("Exception during shutdown - this is expected")
            else:
                log_error(f"Unexpected error in workflow: {e}")
            return False
        finally:
            # Always clean up temporary directories, even on interrupt
            try:
                self.cleanup_temp_directories()
                if _shutdown_requested:
                    log_success("Cleanup completed. Exiting gracefully.")
            except Exception as e:
                log_warning(f"Error during cleanup: {e}")

            # Generate Cairo benchmarks only if requested
            if generate_benchmarks:
                try:
                    self.generate_cairo_benchmarks()
                except Exception as e:
                    log_warning(f"Error generating Cairo benchmarks: {e}")

    def parse_test_summary_json(self) -> dict:
        """Parse the test summary JSON file."""
        summary_file = self.docs_benchmarks / "test_summary.json"

        if not summary_file.exists():
            log_warning("No test summary file found to generate benchmarks")
            return {}

        try:
            with open(summary_file, "r") as f:
                return json.load(f)
        except (json.JSONDecodeError, IOError) as e:
            log_error(f"Could not parse test summary file: {e}")
            return {}

    def extract_module_hierarchy(self, full_name: str) -> list[str]:
        """Extract module hierarchy from full test name."""
        # Remove the test function name from the end
        parts = full_name.split("::")
        if parts[-1].startswith("test_"):
            parts = parts[:-1]
        return parts

    def group_tests_by_module(self, test_data: dict) -> dict:
        """Group tests by their module hierarchy."""
        grouped = defaultdict(lambda: defaultdict(list))

        for test_name, test_info in test_data.items():
            full_name = test_info.get("full_name", "")
            if not full_name:
                continue

            hierarchy = self.extract_module_hierarchy(full_name)
            if len(hierarchy) < 2:
                continue

            # Create nested structure
            current = grouped
            for module in hierarchy[:-1]:
                if module not in current:
                    current[module] = defaultdict(list)
                current = current[module]

            # Add test to the final module
            final_module = hierarchy[-1] if hierarchy else "unknown"
            current[final_module].append(test_info["latest_metrics"])

        return dict(grouped)

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
        ]

        # Create DataFrame
        df = pd.DataFrame(tests)

        # Select only available columns
        available_columns = [col for col in columns if col in df.columns]
        df = df[available_columns]

        # Remove columns where all values are 0 (except test_name, steps, and sierra_gas)
        essential_columns = ["test_name", "steps", "sierra_gas"]
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
            df["test_name"] = df["test_name"].apply(
                lambda test_name: f"[{test_name}](docs/benchmarks/{test_name}.png)"
            )

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

        # Rename columns for display
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

        df_display = df.rename(columns=column_mapping)

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

                    # Intermediate modules are open by default to show full hierarchy
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
            log_error("README.md not found")
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

            log_success("Updated README.md with Cairo benchmarks")
            return True

        except IOError as e:
            log_error(f"Could not update README.md: {e}")
            return False

    def generate_cairo_benchmarks(self):
        """Generate and update Cairo benchmarks in README.md."""
        log_info("Generating Cairo benchmarks...")

        # Parse test summary data
        test_data = self.parse_test_summary_json()

        if not test_data:
            log_warning("No test data available for benchmarks")
            return False

        # Update README with benchmarks
        success = self.update_readme_with_benchmarks(test_data)

        if success:
            log_success(f"Generated benchmarks for {len(test_data)} tests")

        return success


def create_progress() -> Progress:
    """Create a beautiful progress bar."""
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


def create_file_progress() -> Progress:
    """Create an advanced progress bar for file processing."""
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


def main():
    """Main entry point."""
    # Beautiful welcome header
    print_header("🐺 Garaga Test Profiler")

    parser = argparse.ArgumentParser(
        description="Run snforge tests with profiling and generate performance visualizations",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
    python tools/profile_tests.py msm_BN254_1P
    python tools/profile_tests.py --all
    python tools/profile_tests.py test_scalar_to_epns --parallel-jobs 4
    python tools/profile_tests.py --workspace /path/to/garaga test_name --parallel-jobs 2
        """,
    )

    parser.add_argument(
        "test_filter",
        nargs="?",
        default=None,
        help="Test name filter to pass to snforge test (optional)",
    )

    parser.add_argument(
        "--all",
        action="store_true",
        help="Run all tests (same as providing no test filter)",
    )

    parser.add_argument(
        "--workspace",
        default=None,
        help="Path to the workspace root (default: current directory)",
    )

    parser.add_argument(
        "--verbose", "-v", action="store_true", help="Enable verbose logging"
    )

    parser.add_argument(
        "--parallel-jobs",
        type=int,
        default=2,
        help="Number of parallel jobs to use for processing trace files",
    )

    parser.add_argument(
        "--generate-benchmarks",
        action="store_true",
        help="Generate Cairo benchmarks after profiling workflow completes",
    )

    parser.add_argument(
        "--benchmarks-only",
        action="store_true",
        help="Only generate Cairo benchmarks without running profiling workflow",
    )

    args = parser.parse_args()

    # Handle --benchmarks-only flag
    if args.benchmarks_only:
        log_info("🎯 Running in [bold cyan]benchmarks-only[/bold cyan] mode")
        profiler = ProfileTestRunner(workspace_root=args.workspace)

        success = profiler.generate_cairo_benchmarks()

        if success:
            console.print(
                Panel(
                    Align.center("📊 Cairo benchmarks generated successfully!"),
                    border_style="green",
                    title="[green]Benchmarks Complete[/green]",
                )
            )
            sys.exit(0)
        else:
            console.print(
                Panel(
                    Align.center("💥 Failed to generate Cairo benchmarks!"),
                    border_style="red",
                    title="[red]Error[/red]",
                )
            )
            sys.exit(1)

    # Validate parallel_jobs parameter
    if args.parallel_jobs < 1:
        log_error("--parallel-jobs must be at least 1")
        sys.exit(1)
    elif args.parallel_jobs > 8:
        log_warning(
            f"Using {args.parallel_jobs} parallel jobs may overwhelm the system. Consider using fewer jobs."
        )

    # Handle --all flag or empty test_filter
    test_filter = None if args.all else args.test_filter

    # Show configuration
    if test_filter:
        log_info(f"🎯 Running tests matching: [bold cyan]{test_filter}[/bold cyan]")
    else:
        log_info("🎯 Running [bold cyan]all tests[/bold cyan]")

    log_info(f"⚡ Using [bold cyan]{args.parallel_jobs}[/bold cyan] parallel jobs")

    # Initialize and run the profiler
    profiler = ProfileTestRunner(workspace_root=args.workspace)

    success = profiler.run_profile_workflow(
        test_filter, args.parallel_jobs, args.generate_benchmarks
    )

    if _shutdown_requested:
        console.print(
            Panel(
                Align.center(
                    "👋 Process interrupted by user\nPartial results may be available"
                ),
                border_style="yellow",
                title="[yellow]Interrupted[/yellow]",
            )
        )
        sys.exit(130)  # Standard exit code for SIGINT
    elif success:
        console.print(
            Panel(
                Align.center("🎉 All operations completed successfully!"),
                border_style="green",
                title="[green]Success[/green]",
            )
        )
        sys.exit(0)
    else:
        console.print(
            Panel(
                Align.center("💥 Workflow failed!"),
                border_style="red",
                title="[red]Error[/red]",
            )
        )
        sys.exit(1)


if __name__ == "__main__":
    main()
