#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$#" -eq 0 ]; then
    set -- --prove
fi
exec uv run --no-project --python 3.11 "$SCRIPT_DIR/regenerate.py" "$@"
