#!/bin/bash

# Function to install GNU parallel
install_parallel() {
    case "$OSTYPE" in
        linux-gnu*)
            # Linux
            if command -v apt-get >/dev/null; then
                # Debian/Ubuntu
                sudo apt-get install -y parallel
            elif command -v dnf >/dev/null; then
                # Fedora
                sudo dnf install -y parallel
            else
                echo "Unsupported Linux distribution for automatic parallel installation."
                exit 1
            fi
            ;;
        darwin*)
            # macOS
            if command -v brew >/dev/null; then
                brew install parallel
            else
                echo "Homebrew is not installed. Please install Homebrew and try again."
                exit 1
            fi
            ;;
        *)
            echo "Unsupported operating system for automatic parallel installation."
            exit 1
            ;;
    esac
}

# Function to find a suitable Python version (3.10, 3.11, or 3.12)
find_python() {
    # If PYTHON_VERSION env var is set, use that specific version
    if [ -n "$PYTHON_VERSION" ]; then
        local python_cmd="python${PYTHON_VERSION}"
        if command -v "$python_cmd" >/dev/null 2>&1; then
            echo "$python_cmd"
            return 0
        fi
        # Try without minor version for cases like "3.10" -> "python3.10"
        python_cmd="python$(echo $PYTHON_VERSION | sed 's/\.[0-9]*$//')"
        if command -v "$python_cmd" >/dev/null 2>&1; then
            echo "$python_cmd"
            return 0
        fi
        echo "Error: Requested Python version $PYTHON_VERSION not found" >&2
        exit 1
    fi

    # Otherwise, try to find an available Python 3.10-3.12
    for version in 3.12 3.11 3.10; do
        if command -v "python${version}" >/dev/null 2>&1; then
            echo "python${version}"
            return 0
        fi
    done

    # Fall back to python3 if it's in the right version range
    if command -v python3 >/dev/null 2>&1; then
        local py_version=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
        case "$py_version" in
            3.10|3.11|3.12)
                echo "python3"
                return 0
                ;;
        esac
    fi

    return 1
}

# Clean up any existing venv directory
if [ -d "venv" ]; then
    echo "Cleaning up existing venv directory..."
    rm -rf venv
fi

# Check if parallel is installed, if not, attempt to install it
if ! command -v parallel >/dev/null; then
    echo "GNU parallel not found. Attempting to install..."
    install_parallel
else
    echo "GNU parallel is already installed."
fi

# Find a suitable Python version
PYTHON_CMD=$(find_python)
if [ -z "$PYTHON_CMD" ]; then
    echo "No suitable Python version found. Please install Python 3.10, 3.11, or 3.12."
    case "$OSTYPE" in
        linux-gnu*)
            echo "On Debian/Ubuntu, you can install it with: sudo apt-get install python3.12"
            echo "On Fedora, you can install it with: sudo dnf install python3.12"
            ;;
        darwin*)
            echo "On macOS, you can install it with Homebrew: brew install python@3.12"
            ;;
        *)
            echo "Please refer to your operating system's documentation for installing Python."
            ;;
    esac
    exit 1
fi

echo "Using Python: $PYTHON_CMD ($($PYTHON_CMD --version))"

# Check if venv module is available
if ! $PYTHON_CMD -m venv --help >/dev/null 2>&1; then
    echo "The venv module is not available in your Python installation."
    PY_VERSION=$($PYTHON_CMD -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
    case "$OSTYPE" in
        linux-gnu*)
            echo "On Debian/Ubuntu, you can install it with: sudo apt-get install python${PY_VERSION}-venv"
            echo "On Fedora, you can install it with: sudo dnf install python${PY_VERSION}-venv"
            ;;
        darwin*)
            echo "On macOS, ensure your Python installation includes the venv module."
            ;;
        *)
            echo "Please refer to your operating system's documentation for installing the venv module."
            ;;
    esac
    exit 1
fi

# Create virtual environment
if ! $PYTHON_CMD -m venv venv; then
    echo "Failed to create virtual environment with $PYTHON_CMD"
    exit 1
fi

echo 'export PYTHONPATH="$PWD/hydra:$PWD:$PYTHONPATH"' >> venv/bin/activate
echo 'export PYTHONPYCACHEPREFIX="$PWD/venv/build/__pycache__"' >> venv/bin/activate
echo "PROJECT_ROOT=$PWD" > .env
echo "PYTHONPATH=$PWD/hydra" >> .env # For vscode python path when running in integrated terminal.
source venv/bin/activate
pip install uv
uv pip compile pyproject.toml --extra dev --output-file tools/make/requirements.txt -q
uv pip install -r tools/make/requirements.txt

# Install the commit hooks (black, isort)
pre-commit install

echo "Compiling garaga_rs Rust extension..."
# Create target directory with proper permissions in the correct location
mkdir -p .cargo/garaga_rs/target
chmod 755 .cargo/garaga_rs/target

# Build the Rust extension with Python feature enabled
maturin develop --release --features python

echo "All done!"

# Check Scarb version and print warning if it's not
cd src/ # To use the .tool-versions file with asdf.
if ! scarb --version | grep -q "2.14.0"; then
    echo "Warning: Scarb is not installed or its version is not 2.14.0."
    echo "Got: $(scarb --version)"
    echo "Please install Scarb 2.14.0 before continuing. https://docs.swmansion.com/scarb/download.html"
fi
