#!/bin/bash

# Function to install GNU parallel
install_parallel() {
    case "$OSTYPE" in
        linux-gnu*)
            # Linux
            if command -v apt-get >/dev/null; then
                # Debian/Ubuntu
                sudo apt-get update && sudo apt-get install -y parallel
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

# Check if parallel is installed, if not, attempt to install it
if ! command -v parallel >/dev/null; then
    echo "GNU parallel not found. Attempting to install..."
    install_parallel
else
    echo "GNU parallel is already installed."
fi

python3.10 -m venv venv
echo 'export PYTHONPATH="$PWD/hydra/:$PYTHONPATH"' >> venv/bin/activate
echo 'export PYTHONPYCACHEPREFIX="$PWD/venv/build/__pycache__"' >> venv/bin/activate
echo 'export PROJECT_ROOT="$PWD"' >> venv/bin/activate
echo "PROJECT_ROOT=$PWD" > .env
source venv/bin/activate
pip install -r tools/make/requirements.txt

# Install the commit hooks (black, isort)
pre-commit install

echo "Applying patch to instances.py..."
patch venv/lib/python3.10/site-packages/starkware/cairo/lang/instances.py < tools/make/instances.patch

echo "Compiling garaga_rs Rust extension..."
cd tools/garaga_rs
maturin develop --release
cd ../../

echo "Generating input files for test_pairing.cairo..."
python3.10 tests/gen_inputs.py

echo "All done!"
