cd tools/npm/integration-test-suite
rm -rf node_modules package-lock.json && npm cache clean --force && npm install garaga.tgz

FOLDERS=("packages/nodejs-ts-cjs-tsc" "packages/nodejs-ts-esm-tsc" "packages/web-js-esm-react" "packages/web-js-esm-webpack")

for folder in "${FOLDERS[@]}"; do
    echo "Running test-generate in $folder"
    echo "Current directory: $(pwd)"
    cd $folder
    npm run test-generate
    cd ../..
done
