#!/usr/bin/env python3
"""
Garaga Test Profiling Tool

This script automates the process of running snforge tests with profiling,
generating performance visualizations using pprof, and organizing the results.

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
import logging
import os
import re
import shutil
import subprocess
import sys
from datetime import datetime
from pathlib import Path

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
logger = logging.getLogger(__name__)

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


class TestResourceInfo:
    """Container for parsed test resource information."""

    def __init__(
        self, full_name: str, steps: int, builtins: dict, syscalls: list = None
    ):
        self.full_name = full_name
        self.test_name = self._extract_test_name(full_name)
        self.steps = steps
        self.builtins = builtins or {}
        self.syscalls = syscalls or []
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
                logger.warning(f"Unknown builtin '{builtin_name}' not in weight table")

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
        self.profile_dir = self.src_dir / "profile"
        self.trace_dir = self.src_dir / "snfoundry_trace"
        self.docs_benchmarks = self.workspace_root / "docs" / "benchmarks"
        self.cargo_benchmarks = self.workspace_root / ".cargo" / "benchmarks"

    def check_dependencies(self):
        """Check if required tools are available."""
        logger.info("Checking dependencies...")

        # Check if snforge is available
        try:
            result = subprocess.run(
                ["snforge", "--version"], capture_output=True, text=True, check=True
            )
            logger.info(f"Found snforge: {result.stdout.strip()}")
        except (subprocess.CalledProcessError, FileNotFoundError):
            logger.error("snforge not found. Please install Starknet Foundry.")
            return False

        # Check if go tool pprof is available
        try:
            result = subprocess.run(
                ["go", "version"], capture_output=True, text=True, check=True
            )
            logger.info(f"Found Go: {result.stdout.strip()}")
        except (subprocess.CalledProcessError, FileNotFoundError):
            logger.error("Go not found. Please install Go to use pprof.")
            return False

        return True

    def setup_directories(self):
        """Create necessary directories."""
        logger.info("Setting up directories...")

        directories = [self.docs_benchmarks, self.cargo_benchmarks]

        for directory in directories:
            directory.mkdir(parents=True, exist_ok=True)
            logger.info(f"Ensured directory exists: {directory}")

    def cleanup_temp_directories(self):
        """Remove temporary directories from previous runs."""
        logger.info("Cleaning up temporary directories...")

        temp_dirs = [self.trace_dir, self.profile_dir]

        for temp_dir in temp_dirs:
            if temp_dir.exists():
                try:
                    shutil.rmtree(temp_dir)
                    logger.info(f"Removed temporary directory: {temp_dir}")
                except Exception as e:
                    logger.warning(f"Could not remove {temp_dir}: {e}")

    def parse_test_resources(self, stdout: str) -> list[TestResourceInfo]:
        """Parse test resource information from snforge stdout."""
        logger.info("Parsing test resource information...")

        test_resources = []

        # Pattern to match test results with detailed resources
        test_pattern = r"\[PASS\]\s+([^(]+)\s+\([^)]+\)\s*\n\s*steps:\s*(\d+)\s*\n\s*memory holes:[^\n]*\n\s*builtins:\s*\(([^)]*)\)\s*\n\s*syscalls:\s*\(([^)]*)\)"

        matches = re.finditer(test_pattern, stdout, re.MULTILINE)

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

            # Parse syscalls (for now just count them, could be enhanced later)
            syscalls = []
            if syscalls_str:
                # This could be enhanced to parse actual syscall names if needed
                syscalls = [s.strip() for s in syscalls_str.split(",") if s.strip()]

            test_info = TestResourceInfo(full_name, steps, builtins, syscalls)
            test_resources.append(test_info)

            logger.info(
                f"Parsed test: {test_info.test_name} - Steps: {steps}, Sierra Gas: {test_info.sierra_gas}"
            )

        logger.info(f"Parsed {len(test_resources)} test resource entries")
        return test_resources

    def run_snforge_test(self, test_filter: str = None):
        """Run snforge test with profiling enabled."""
        if test_filter:
            logger.info(f"Running snforge test with filter: {test_filter}")
        else:
            logger.info("Running all snforge tests")

        # Change to src directory for the test
        original_cwd = os.getcwd()
        try:
            os.chdir(self.src_dir)

            cmd = ["snforge", "test"]
            if test_filter:
                cmd.append(test_filter)
            cmd.extend(["--build-profile", "--detailed-resources"])

            logger.info(f"Executing: {' '.join(cmd)}")

            result = subprocess.run(cmd, capture_output=True, text=True)

            if result.returncode != 0:
                logger.error(
                    f"snforge test failed with return code {result.returncode}"
                )
                logger.error(f"stderr: {result.stderr}")
                return False, ""

            logger.info("snforge test completed successfully")
            logger.debug(f"stdout: {result.stdout}")
            return True, result.stdout

        except Exception as e:
            logger.error(f"Error running snforge test: {e}")
            return False, ""
        finally:
            os.chdir(original_cwd)

    def find_profile_files(self):
        """Find all .pb.gz files in the profile directory."""
        if not self.profile_dir.exists():
            logger.error(f"Profile directory not found: {self.profile_dir}")
            return []

        profile_files = list(self.profile_dir.glob("*.pb.gz"))
        logger.info(
            f"Found {len(profile_files)} profile files: {[f.name for f in profile_files]}"
        )
        return profile_files

    def generate_pprof_image(self, profile_file: Path, output_path: Path):
        """Generate PNG image from profile file using pprof."""
        logger.info(f"Generating pprof image for {profile_file.name}")

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
            logger.info(f"Generated image: {output_path}")
            return True

        except subprocess.CalledProcessError as e:
            logger.error(f"pprof failed for {profile_file.name}: {e.stderr}")
            return False
        except Exception as e:
            logger.error(f"Error generating pprof image: {e}")
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
            except (json.JSONDecodeError, IOError) as e:
                logger.warning(
                    f"Could not load existing history file {history_file}: {e}"
                )
                history_data = []

        # Add new entry for this specific test
        new_entry = test_info.to_dict(timestamp)
        history_data.append(new_entry)

        # Save updated history
        try:
            with open(history_file, "w") as f:
                json.dump(history_data, f, indent=2)
            logger.info(f"Updated test history: {history_file}")
        except IOError as e:
            logger.error(f"Could not save test history {history_file}: {e}")

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
            except (json.JSONDecodeError, IOError) as e:
                logger.warning(
                    f"Could not load existing summary file {summary_file}: {e}"
                )
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
            logger.info(f"Updated global summary: {summary_file}")
        except IOError as e:
            logger.error(f"Could not save global summary {summary_file}: {e}")

    def process_profile_files(
        self, test_filter: str, test_resources: list[TestResourceInfo]
    ):
        """Process all profile files and generate images."""
        profile_files = self.find_profile_files()

        if not profile_files:
            logger.warning("No profile files found to process")
            return False

        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        timestamp_iso = datetime.now().isoformat()
        success_count = 0

        # Update JSON files with test resource data
        if test_resources:
            for test_info in test_resources:
                self.update_test_history_json(test_info, timestamp_iso)
            self.update_global_summary_json(test_resources, timestamp_iso)

        # For docs/benchmarks - create one image per test
        if test_resources:
            for test_info in test_resources:
                # Use first profile file for each test (we can't map profile files to specific tests)
                profile_file = profile_files[0] if profile_files else None
                if profile_file:
                    docs_image_path = (
                        self.docs_benchmarks / f"{test_info.test_name}.png"
                    )
                    if self.generate_pprof_image(profile_file, docs_image_path):
                        success_count += 1
                    logger.info(f"Created docs image for test: {test_info.test_name}")
        else:
            # Fallback when no test resource info available - use test filter
            profile_file = profile_files[0] if profile_files else None
            if profile_file:
                docs_image_path = self.docs_benchmarks / f"{test_filter}.png"
                if self.generate_pprof_image(profile_file, docs_image_path):
                    success_count += 1

        # For .cargo/benchmarks - create folder per test with profile image
        if test_resources:
            for test_info in test_resources:
                test_dir = self.cargo_benchmarks / test_info.test_name
                test_dir.mkdir(parents=True, exist_ok=True)

                # Create profile image for this test (use first profile file for simplicity)
                profile_file = profile_files[0] if profile_files else None
                if profile_file:
                    cargo_image_path = test_dir / f"profile_{timestamp}.png"
                    self.generate_pprof_image(profile_file, cargo_image_path)
                    logger.info(f"Created profile for test: {test_info.test_name}")
        else:
            # Fallback when no test resource info available
            test_dir = self.cargo_benchmarks / test_filter
            test_dir.mkdir(parents=True, exist_ok=True)

            if profile_files:
                profile_file = profile_files[0]
                cargo_image_path = test_dir / f"profile_{timestamp}.png"
                self.generate_pprof_image(profile_file, cargo_image_path)

        logger.info(f"Successfully processed {success_count} profile files")
        return success_count > 0

    def run_profile_workflow(self, test_filter: str = None):
        """Run the complete profiling workflow."""
        if test_filter:
            logger.info(f"Starting profiling workflow for test filter: {test_filter}")
        else:
            logger.info("Starting profiling workflow for all tests")

        # Check dependencies
        if not self.check_dependencies():
            return False

        # Setup directories
        self.setup_directories()

        # Clean up any existing temp directories
        self.cleanup_temp_directories()

        try:
            # Run the test with profiling
            success, stdout = self.run_snforge_test(test_filter)
            if not success:
                logger.error("Test execution failed")
                return False

            # Parse test resource information
            test_resources = self.parse_test_resources(stdout)

            # Process profile files
            if not self.process_profile_files(
                test_filter or "all_tests", test_resources
            ):
                logger.error("Profile processing failed")
                return False

            logger.info("Profiling workflow completed successfully!")
            return True

        finally:
            # Always clean up temporary directories
            self.cleanup_temp_directories()


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="Run snforge tests with profiling and generate performance visualizations",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
    python tools/profile_tests.py msm_BN254_1P
    python tools/profile_tests.py --all
    python tools/profile_tests.py --workspace /path/to/garaga test_name
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

    args = parser.parse_args()

    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)

    # Handle --all flag or empty test_filter
    test_filter = None if args.all else args.test_filter

    # Initialize and run the profiler
    profiler = ProfileTestRunner(workspace_root=args.workspace)

    success = profiler.run_profile_workflow(test_filter)

    if success:
        logger.info("All operations completed successfully!")
        sys.exit(0)
    else:
        logger.error("Workflow failed!")
        sys.exit(1)


if __name__ == "__main__":
    main()
