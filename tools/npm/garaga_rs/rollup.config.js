import typescript from '@rollup/plugin-typescript';
import dts from 'rollup-plugin-dts';

export default [
  {
    input: './src/node/index.ts',
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
    plugins: [typescript()],
  },
  {
    input: './src/node/index.ts',
    output: {
      file: 'dist/index.d.ts',
      format: 'esm',
      sourcemap: false,
    },
    plugins: [typescript(), dts()],
  },
];
