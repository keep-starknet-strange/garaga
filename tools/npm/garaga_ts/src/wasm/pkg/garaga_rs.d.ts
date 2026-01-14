/* tslint:disable */
/* eslint-disable */
export function drand_calldata_builder(values: any[]): any[];
export function msm_calldata_builder(values: any[], scalars: any[], curve_id: number, include_points_and_scalars: boolean, serialize_as_pure_felt252_array: boolean): any[];
export function mpc_calldata_builder(curve_id: number, values1: any[], n_fixed_g2: number, values2: any[]): any[];
export function schnorr_calldata_builder(rx: any, s: any, e: any, px: any, py: any, prepend_public_key: boolean, curve_id: number): any[];
export function ecdsa_calldata_builder(r: any, s: any, v: number, px: any, py: any, z: any, prepend_public_key: boolean, curve_id: number): any[];
export function eddsa_calldata_builder(ry_twisted: any, s: any, py_twisted: any, msg: any, prepend_public_key: boolean): any[];
export function to_weirstrass(x_twisted: any, y_twisted: any): any[];
export function to_twistededwards(x_weirstrass: any, y_weirstrass: any): any[];
export function get_groth16_calldata(proof_js: any, vk_js: any, curve_id_js: any): any[];
export function get_zk_honk_calldata(proof_js: any, public_inputs_js: any, vk_js: any): any[];
export function poseidon_hash(x: any, y: any): any;

export type InitInput = RequestInfo | URL | Response | BufferSource | WebAssembly.Module;

export interface InitOutput {
  readonly memory: WebAssembly.Memory;
  readonly drand_calldata_builder: (a: number, b: number) => [number, number, number, number];
  readonly msm_calldata_builder: (a: number, b: number, c: number, d: number, e: number, f: number, g: number) => [number, number, number, number];
  readonly mpc_calldata_builder: (a: number, b: number, c: number, d: number, e: number, f: number) => [number, number, number, number];
  readonly schnorr_calldata_builder: (a: any, b: any, c: any, d: any, e: any, f: number, g: number) => [number, number, number, number];
  readonly ecdsa_calldata_builder: (a: any, b: any, c: number, d: any, e: any, f: any, g: number, h: number) => [number, number, number, number];
  readonly eddsa_calldata_builder: (a: any, b: any, c: any, d: any, e: number) => [number, number, number, number];
  readonly to_weirstrass: (a: any, b: any) => [number, number, number, number];
  readonly to_twistededwards: (a: any, b: any) => [number, number, number, number];
  readonly get_groth16_calldata: (a: any, b: any, c: any) => [number, number, number, number];
  readonly get_zk_honk_calldata: (a: any, b: any, c: any) => [number, number, number, number];
  readonly poseidon_hash: (a: any, b: any) => [number, number, number];
  readonly __wbindgen_exn_store: (a: number) => void;
  readonly __externref_table_alloc: () => number;
  readonly __wbindgen_export_2: WebAssembly.Table;
  readonly __wbindgen_malloc: (a: number, b: number) => number;
  readonly __wbindgen_realloc: (a: number, b: number, c: number, d: number) => number;
  readonly __externref_table_dealloc: (a: number) => void;
  readonly __externref_drop_slice: (a: number, b: number) => void;
  readonly __wbindgen_free: (a: number, b: number, c: number) => void;
  readonly __wbindgen_start: () => void;
}

export type SyncInitInput = BufferSource | WebAssembly.Module;
/**
* Instantiates the given `module`, which can either be bytes or
* a precompiled `WebAssembly.Module`.
*
* @param {{ module: SyncInitInput }} module - Passing `SyncInitInput` directly is deprecated.
*
* @returns {InitOutput}
*/
export function initSync(module: { module: SyncInitInput } | SyncInitInput): InitOutput;

/**
* If `module_or_path` is {RequestInfo} or {URL}, makes a request and
* for everything else, calls `WebAssembly.instantiate` directly.
*
* @param {{ module_or_path: InitInput | Promise<InitInput> }} module_or_path - Passing `InitInput` directly is deprecated.
*
* @returns {Promise<InitOutput>}
*/
export default function __wbg_init (module_or_path?: { module_or_path: InitInput | Promise<InitInput> } | InitInput | Promise<InitInput>): Promise<InitOutput>;
