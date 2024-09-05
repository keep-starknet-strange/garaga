import typescript from '@rollup/plugin-typescript';
import dts from 'rollup-plugin-dts';
import node_externals from 'rollup-plugin-node-externals';

export default [
  {
    input: './src/node/index.ts',
    output: [
      {
        file: 'dist/index.mjs',
        format: 'esm',
        sourcemap: true,
      },
      {
        file: 'dist/index.cjs',
        format: 'cjs',
        sourcemap: true,
      },
    ],
    plugins: [node_externals(), typescript()],
  },
  {
    input: './src/node/index.ts',
    output: {
      file: 'dist/index.d.ts',
      format: 'esm',
      sourcemap: false,
    },
    plugins: [node_externals(), typescript(), dts()],
    external: [/^lib/],
  },
];
