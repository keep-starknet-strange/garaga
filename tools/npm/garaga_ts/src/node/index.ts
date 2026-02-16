export * from './api';
export * from '../wasm/pkg/garaga_rs';
export * from './starknet/groth16ContractGenerator/parsingUtils';

export { CurveId } from './definitions';

import pkg_init from '../wasm/pkg/garaga_rs';
import module_or_path from '../wasm/pkg/garaga_rs_bg.wasm';


export function init(): ReturnType<typeof pkg_init> {
  return pkg_init({ module_or_path });
}
