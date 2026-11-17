#!/bin/bash
set -euo pipefail

cd tools/npm/integration-test-suite
npm install --ignore-scripts garaga.tgz
npm run install-browser
npm run test-generate
