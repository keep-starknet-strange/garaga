export * from '../wasm/pkg/garaga_rs.js';

import pkg_init from '../wasm/pkg/garaga_rs.js';
import default_module_or_path from '../wasm/pkg/garaga_rs_bg.wasm.js';

export async function init() {
  return await pkg_init({ module_or_path: default_module_or_path });
}
