#!/bin/bash

start_docker() {
    local os_type=$1
    echo "Attempting to start Docker daemon..."

    case "$os_type" in
        "macos")
            echo "Please start Docker Desktop manually for macOS"
            echo "Cannot automatically start Docker Desktop due to security restrictions"
            exit 1
            ;;
        "fedora")
            read -p "Docker daemon is not running. Would you like to start it? (y/N) " response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                if command -v sudo >/dev/null 2>&1; then
                    echo "Starting Docker daemon..."
                    sudo systemctl start docker
                    # Wait for Docker to be ready
                    echo "Waiting for Docker to be ready..."
                    sleep 3
                else
                    echo "Error: sudo is not available. Please start Docker manually:"
                    echo "sudo systemctl start docker"
                    exit 1
                fi
            else
                echo "Please start Docker manually when ready"
                exit 1
            fi
            ;;
        "debian")
            read -p "Docker daemon is not running. Would you like to start it? (y/N) " response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                if command -v sudo >/dev/null 2>&1; then
                    echo "Starting Docker daemon..."
                    sudo systemctl start docker
                    # Wait for Docker to be ready
                    echo "Waiting for Docker to be ready..."
                    sleep 3
                else
                    echo "Error: sudo is not available. Please start Docker manually:"
                    echo "sudo systemctl start docker"
                    exit 1
                fi
            else
                echo "Please start Docker manually when ready"
                exit 1
            fi
            ;;
        *)
            echo "Unsupported operating system. Please start Docker daemon manually"
            exit 1
            ;;
    esac
}

check_docker() {
    if ! docker info >/dev/null 2>&1; then
        echo "Docker daemon is not running."

        # Detect OS and try to start Docker
        if [[ "$OSTYPE" == "darwin"* ]]; then
            start_docker "macos"
        elif [ -f /etc/fedora-release ]; then
            start_docker "fedora"
        elif [ -f /etc/debian_version ] || [ -f /etc/lsb-release ]; then
            start_docker "debian"
        else
            echo "Unsupported operating system. Please start Docker daemon manually"
            exit 1
        fi

        # Double check if Docker started successfully
        if ! docker info >/dev/null 2>&1; then
            echo "Failed to start Docker daemon"
            exit 1
        fi
    fi
    echo "Docker daemon is running"
}

# Check if Docker is running and start if needed
check_docker

cd tools/npm/garaga_ts
docker compose up --build

cd ../integration-test-suite

GARAGA_VERSION=$(jq -r '.release_info.garaga_version' ../../make/constants.json)
cp ../garaga_ts/garaga-$GARAGA_VERSION.tgz garaga.tgz
npm install garaga.tgz
