import { readFileSync } from 'node:fs';
import dts from 'rollup-plugin-dts';

const emittedSourceMaps = {
  name: 'tsc-source-maps',
  load(id) {
    if (!id.endsWith('.js')) return null;
    return { code: readFileSync(id, 'utf8'), map: readFileSync(id + '.map', 'utf8') };
  },
};

export default [
  {
    input: './.build/src/node/index.js',
    output: [
      {
        file: 'dist/index.cjs',
        format: 'cjs',
        sourcemap: true,
      },
      {
        file: 'dist/index.mjs',
        format: 'esm',
        sourcemap: true,
      },
    ],
    external: ['fs', '@noble/hashes/sha2.js', 'path', 'util', 'os', 'stream', 'buffer'],
    plugins: [emittedSourceMaps],
  },
  {
    input: './src/node/index.ts',
    output: {
      file: 'dist/index.d.ts',
      format: 'esm',
      sourcemap: false,
    },
    external: ['fs', '@noble/hashes/sha2.js', 'path', 'util', 'os', 'stream', 'buffer'],
    plugins: [dts()],
  },
];
