export * from './api'; // exports "ts" interface
export * from '../wasm/pkg/garaga_rs'; // export "raw" interface

export { CurveId } from './definitions';

import pkg_init from '../wasm/pkg/garaga_rs';
import module_or_path from '../wasm/pkg/garaga_rs_bg.wasm';

let initialization: ReturnType<typeof pkg_init> | undefined;

export function init(): ReturnType<typeof pkg_init> {
  initialization ??= pkg_init({
    module_or_path: typeof Buffer === 'undefined'
      ? module_or_path
      : Buffer.from(module_or_path.slice(module_or_path.indexOf(',') + 1), 'base64'),
  }).catch((error: unknown) => {
    initialization = undefined;
    throw error;
  });
  return initialization;
}
