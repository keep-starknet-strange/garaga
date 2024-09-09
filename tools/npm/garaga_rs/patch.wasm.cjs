// This script will patch a 'wasm-pack --target web' output folder
// towards a platform agnostic build

const fs = require('fs');
const path = require('path');

function patch() {
  // package folder
  const pkgFolder = path.join(__dirname, 'src/wasm/pkg');

  // package file name/path
  const jsonName = 'package.json';
  const jsonFile = path.join(pkgFolder, jsonName);

  // package name
  const pkgName = JSON.parse(fs.readFileSync(jsonFile, 'utf8'))['name'];

  // other files
  const gitignoreName = '.gitignore';
  const gitignoreFile = path.join(pkgFolder, gitignoreName);

  const jsName = pkgName + '.js';
  const jsFile = path.join(pkgFolder, jsName);

  const wasmName = pkgName + '_bg.wasm';
  const wasmFile = path.join(pkgFolder, wasmName);

  const wasmjsName = pkgName + '_bg.wasm.js';
  const wasmjsFile = path.join(pkgFolder, wasmjsName);

  const wasmtsName = pkgName + '_bg.wasm.d.ts';
  const wasmtsFile = path.join(pkgFolder, wasmtsName);

  // patches .js file:
  // - replaces the default WASM load behavior via URL by error (cjs compatibility)
  {
    const input = fs.readFileSync(jsFile, 'utf8');
    const output = input
      .replaceAll('module_or_path = new URL(\'' + wasmName + '\', import.meta.url)', 'throw new Error()');
    fs.writeFileSync(jsFile, output, 'utf8');
  }

  // encodes .wasm file as .wasm.js:
  // - creates .wasm.js exporting the binary contents of the .wasm file
  {
    const input = fs.readFileSync(wasmFile).toString('base64');
    const output =
      'export default \'data:application/wasm;base64,' + input + '\';';
    fs.writeFileSync(wasmjsFile, output, 'utf8');
  }

  // overwrites .wasm.d.ts file:
  // - updates .wasm.d.ts with the type signature of the .wasm.js file
  {
    const output =
      'declare const wasm_module_base64: string;' + '\n' +
      'export default wasm_module_base64;';
    fs.writeFileSync(wasmtsFile, output, 'utf8');
  }

  // cleans up now obsolete files:
  // - removes .gitignore and .wasm files
  {
    fs.rmSync(gitignoreFile);
    fs.rmSync(wasmFile);
  }
}

patch();
