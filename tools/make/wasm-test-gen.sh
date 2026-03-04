cd tools/npm/integration-test-suite
rm -rf node_modules package-lock.json && npm cache clean --force && npm install garaga.tgz

# Uses turbo to build all packages first, then run test-generate sequentially
# (--concurrency 1 because web packages share port 8080)
npm run test-generate
