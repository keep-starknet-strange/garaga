#!/bin/sh
# This script will apply the current folder ownership to its contents recursively
# It is useful to fix up the ownership of files handled by a docker container
FOLDER="${1:-$(dirname "$0")}"
UID=$(stat -c "%u" "$FOLDER")
GID=$(stat -c "%g" "$FOLDER")
chown -R "$UID:$GID" "$FOLDER"
