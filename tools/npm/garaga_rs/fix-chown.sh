#!/bin/sh
FOLDER="$(dirname "$0")"
UID=$(stat -c "%u" "$FOLDER")
GID=$(stat -c "%g" "$FOLDER")
chown -R "$UID:$GID" "$FOLDER"
