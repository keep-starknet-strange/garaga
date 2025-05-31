import os
from pathlib import Path

# Configure Hypothesis to store all its data in the .cargo/hypothesis directory
build_path = Path(__file__).parent.parent / ".cargo" / "hypothesis"
build_path.mkdir(
    parents=True, exist_ok=True
)  # Ensure the .cargo/hypothesis directory exists

# Set the environment variable before importing hypothesis
os.environ["HYPOTHESIS_STORAGE_DIRECTORY"] = str(build_path)

from hypothesis import settings
from hypothesis.database import DirectoryBasedExampleDatabase

# Also set the database for good measure
settings.register_profile("default", database=DirectoryBasedExampleDatabase(build_path))
settings.load_profile("default")

pytest_plugins = [
    "tests.contracts_e2e.fixtures.accounts",
    "tests.contracts_e2e.fixtures.clients",
    "tests.contracts_e2e.fixtures.devnet",
]
