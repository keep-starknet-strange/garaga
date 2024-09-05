import { readFileSync, rmSync, writeFileSync } from 'fs';

const name = 'garaga_rs';

const wasm = readFileSync(`./src/wasm/pkg/${name}_bg.wasm`);
writeFileSync(`./src/wasm/pkg/${name}_bg.wasm.js`, `export default "data:application/wasm;base64,${wasm.toString("base64")}";`);
writeFileSync(`./src/wasm/pkg/${name}_bg.wasm.d.ts`, `declare const _default: string;\nexport default _default;`);

const glueJs = readFileSync(`./src/wasm/pkg/${name}.js`, "utf8")
  .replaceAll(`module_or_path = new URL('${name}_bg.wasm', import.meta.url);`, `throw new Error();`);
writeFileSync(`./src/wasm/pkg/${name}.js`, glueJs);

rmSync(`./src/wasm/pkg/.gitignore`, { force: true });
rmSync(`./src/wasm/pkg/${name}_bg.wasm`, { force: true });
