#!/bin/bash
set -euo pipefail

PYTHON_VERSION_TARGET="3.14"

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

# Function to install GMP (required by fastecdsa)
install_gmp() {
    case "$OSTYPE" in
        linux-gnu*)
            if command -v apt-get >/dev/null; then
                sudo apt-get install -y libgmp-dev
            elif command -v dnf >/dev/null; then
                sudo dnf install -y gmp-devel
            else
                echo "Unsupported Linux distribution for automatic GMP installation."
                echo "Please install GMP manually: https://pypi.org/project/fastecdsa/#installing"
                exit 1
            fi
            ;;
        darwin*)
            if command -v brew >/dev/null; then
                brew install gmp
            else
                echo "Homebrew is not installed. Please install Homebrew and try again."
                exit 1
            fi
            ;;
        *)
            echo "Unsupported operating system for automatic GMP installation."
            echo "Please install GMP manually: https://gmplib.org/"
            exit 1
            ;;
    esac
}

# Function to install cmake (required by crypto-cpp-py)
install_cmake() {
    case "$OSTYPE" in
        linux-gnu*)
            if command -v apt-get >/dev/null; then
                sudo apt-get install -y cmake
            elif command -v dnf >/dev/null; then
                sudo dnf install -y cmake
            else
                echo "Unsupported Linux distribution for automatic cmake installation."
                exit 1
            fi
            ;;
        darwin*)
            if command -v brew >/dev/null; then
                brew install cmake
            else
                echo "Homebrew is not installed. Please install Homebrew and try again."
                exit 1
            fi
            ;;
        *)
            echo "Unsupported operating system for automatic cmake installation."
            exit 1
            ;;
    esac
}

# Ensure uv is available (installs if missing)
ensure_uv() {
    if command -v uv >/dev/null 2>&1; then
        return 0
    fi
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
}

# Find or install a suitable Python version (3.10-3.14)
find_python() {
    # If PYTHON_VERSION env var is set, use that specific version
    if [ -n "${PYTHON_VERSION:-}" ]; then
        PYTHON_VERSION_TARGET="$PYTHON_VERSION"
    fi

    # Try to find it on PATH first
    for version in $PYTHON_VERSION_TARGET 3.14 3.13 3.12 3.11 3.10; do
        if command -v "python${version}" >/dev/null 2>&1; then
            echo "python${version}"
            return 0
        fi
    done

    # Fall back to python3 if it's in the right version range
    if command -v python3 >/dev/null 2>&1; then
        local py_version=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
        case "$py_version" in
            3.10|3.11|3.12|3.13|3.14)
                echo "python3"
                return 0
                ;;
        esac
    fi

    # Not found — use uv to install it
    echo "Python ${PYTHON_VERSION_TARGET} not found. Installing via uv..." >&2
    ensure_uv
    uv python install "$PYTHON_VERSION_TARGET" >&2
    local uv_python
    uv_python=$(uv python find "$PYTHON_VERSION_TARGET" 2>/dev/null || true)
    if [ -n "$uv_python" ]; then
        echo "$uv_python"
        return 0
    fi

    return 1
}

# Check if existing venv is valid and matches expected Python version range
venv_is_valid() {
    [ -f "venv/bin/python" ] || return 1
    local py_version
    py_version=$(venv/bin/python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>/dev/null) || return 1
    case "$py_version" in
        3.10|3.11|3.12|3.13|3.14) return 0 ;;
        *) return 1 ;;
    esac
}

# Check if parallel is installed, if not, attempt to install it
if ! command -v parallel >/dev/null; then
    echo "GNU parallel not found. Attempting to install..."
    install_parallel
else
    echo "GNU parallel is already installed."
fi

# Check if GMP is installed (required by fastecdsa)
gmp_found=false
case "$OSTYPE" in
    linux-gnu*)
        # Check header in standard and multiarch paths, or via pkg-config/ldconfig
        if [ -f /usr/include/gmp.h ] \
            || pkg-config --exists gmp 2>/dev/null \
            || ldconfig -p 2>/dev/null | grep -q libgmp; then
            gmp_found=true
        fi
        ;;
    darwin*)
        # Use formula-specific prefix (works even if formula is unlinked)
        if command -v brew >/dev/null 2>&1; then
            GMP_PREFIX=$(brew --prefix gmp 2>/dev/null || true)
            if [ -n "$GMP_PREFIX" ] && [ -f "${GMP_PREFIX}/include/gmp.h" ]; then
                gmp_found=true
            fi
        fi
        ;;
esac

if [ "$gmp_found" = false ]; then
    echo "GMP not found. Attempting to install (required by fastecdsa)..."
    install_gmp
else
    echo "GMP is already installed."
fi

# Check if cmake is installed (required by crypto-cpp-py)
if ! command -v cmake >/dev/null; then
    echo "cmake not found. Attempting to install (required by crypto-cpp-py)..."
    install_cmake
else
    echo "cmake is already installed."
fi

ensure_uv

if venv_is_valid; then
    echo "Existing venv is valid ($(venv/bin/python --version)). Updating dependencies..."
else
    # Clean up broken/outdated venv
    if [ -d "venv" ]; then
        echo "Removing invalid venv..."
        rm -rf venv
    fi

    # Find a suitable Python version (installs via uv if needed)
    PYTHON_CMD=$(find_python || true)
    if [ -z "$PYTHON_CMD" ]; then
        echo "No suitable Python version found and uv install failed."
        echo "Please install Python 3.10 through 3.14 manually."
        exit 1
    fi

    echo "Using Python: $PYTHON_CMD ($($PYTHON_CMD --version))"

    # Create virtual environment using uv (no venv module needed)
    if ! uv venv --python "$PYTHON_CMD" venv; then
        echo "Failed to create virtual environment"
        exit 1
    fi

    echo 'export PYTHONPATH="$PWD/hydra:$PWD:${PYTHONPATH:-}"' >> venv/bin/activate
    echo 'export PYTHONPYCACHEPREFIX="$PWD/venv/build/__pycache__"' >> venv/bin/activate
fi

echo "PROJECT_ROOT=$PWD" > .env
echo "PYTHONPATH=$PWD/hydra" >> .env # For vscode python path when running in integrated terminal.
source venv/bin/activate

# On macOS, ensure compiler can find Homebrew-installed GMP
if [[ "$OSTYPE" == darwin* ]] && command -v brew >/dev/null; then
    GMP_PREFIX=$(brew --prefix gmp 2>/dev/null || true)
    if [ -n "$GMP_PREFIX" ] && [ -d "${GMP_PREFIX}/include" ]; then
        export CFLAGS="-I${GMP_PREFIX}/include ${CFLAGS:-}"
        export LDFLAGS="-L${GMP_PREFIX}/lib ${LDFLAGS:-}"
    fi
fi

# Allow crypto-cpp-py's bundled googletest to build with newer cmake (>= 4.x)
export CMAKE_POLICY_VERSION_MINIMUM=3.5
# crypto-cpp-py hardcodes a -target flag that conflicts with cmake's auto-detected
# -mmacosx-version-min on macOS; suppress the resulting -Werror to let it build.
if [[ "$OSTYPE" == darwin* ]]; then
    export CXXFLAGS="-Wno-overriding-option ${CXXFLAGS:-}"
fi

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
scarb_version=$(scarb --version 2>/dev/null || true)
if ! echo "$scarb_version" | grep -q "2.14.0"; then
    echo "Warning: Scarb is not installed or its version is not 2.14.0."
    echo "Got: ${scarb_version:-<not found>}"
    echo "Please install Scarb 2.14.0 before continuing. https://docs.swmansion.com/scarb/download.html"
fi
