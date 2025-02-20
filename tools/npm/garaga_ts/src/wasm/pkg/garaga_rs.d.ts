/* tslint:disable */
/* eslint-disable */
/**
 * @param {any[]} values
 * @param {any[]} scalars
 * @param {number} curve_id
 * @param {boolean} include_digits_decomposition
 * @param {boolean} include_points_and_scalars
 * @param {boolean} serialize_as_pure_felt252_array
 * @param {boolean} risc0_mode
 * @returns {any[]}
 */
export function msm_calldata_builder(values: any[], scalars: any[], curve_id: number, include_digits_decomposition: boolean, include_points_and_scalars: boolean, serialize_as_pure_felt252_array: boolean, risc0_mode: boolean): any[];
/**
 * @param {number} curve_id
 * @param {any[]} values1
 * @param {number} n_fixed_g2
 * @param {any[]} values2
 * @returns {any[]}
 */
export function mpc_calldata_builder(curve_id: number, values1: any[], n_fixed_g2: number, values2: any[]): any[];
/**
 * @param {any} rx
 * @param {any} s
 * @param {any} e
 * @param {any} px
 * @param {any} py
 * @param {number} curve_id
 * @returns {any[]}
 */
export function schnorr_calldata_builder(rx: any, s: any, e: any, px: any, py: any, curve_id: number): any[];
/**
 * @param {any} r
 * @param {any} s
 * @param {number} v
 * @param {any} px
 * @param {any} py
 * @param {any} z
 * @param {number} curve_id
 * @returns {any[]}
 */
export function ecdsa_calldata_builder(r: any, s: any, v: number, px: any, py: any, z: any, curve_id: number): any[];
/**
 * @param {any} x_twisted
 * @param {any} y_twisted
 * @returns {any[]}
 */
export function to_weirstrass(x_twisted: any, y_twisted: any): any[];
/**
 * @param {any} x_weirstrass
 * @param {any} y_weirstrass
 * @returns {any[]}
 */
export function to_twistededwards(x_weirstrass: any, y_weirstrass: any): any[];
/**
 * @param {any} proof_js
 * @param {any} vk_js
 * @param {any} curve_id_js
 * @returns {any[]}
 */
export function get_groth16_calldata(proof_js: any, vk_js: any, curve_id_js: any): any[];
/**
 * @param {any} uint8_array
 * @returns {any}
 */
export function parse_honk_proof(uint8_array: any): any;
/**
 * @param {any} uint8_array
 * @returns {any}
 */
export function parse_honk_verification_key(uint8_array: any): any;
/**
 * @param {any} proof_js
 * @param {any} vk_js
 * @param {any} flavor_js
 * @returns {any[]}
 */
export function get_honk_calldata(proof_js: any, vk_js: any, flavor_js: any): any[];
/**
 * @param {string} x
 * @param {string} y
 * @returns {string}
 */
export function poseidon_hash(x: string, y: string): string;

export type InitInput = RequestInfo | URL | Response | BufferSource | WebAssembly.Module;

export interface InitOutput {
  readonly memory: WebAssembly.Memory;
  readonly msm_calldata_builder: (a: number, b: number, c: number, d: number, e: number, f: number, g: number, h: number, i: number, j: number) => void;
  readonly mpc_calldata_builder: (a: number, b: number, c: number, d: number, e: number, f: number, g: number) => void;
  readonly schnorr_calldata_builder: (a: number, b: number, c: number, d: number, e: number, f: number, g: number) => void;
  readonly ecdsa_calldata_builder: (a: number, b: number, c: number, d: number, e: number, f: number, g: number, h: number) => void;
  readonly to_weirstrass: (a: number, b: number, c: number) => void;
  readonly to_twistededwards: (a: number, b: number, c: number) => void;
  readonly get_groth16_calldata: (a: number, b: number, c: number, d: number) => void;
  readonly parse_honk_proof: (a: number, b: number) => void;
  readonly parse_honk_verification_key: (a: number, b: number) => void;
  readonly get_honk_calldata: (a: number, b: number, c: number, d: number) => void;
  readonly poseidon_hash: (a: number, b: number, c: number, d: number, e: number) => void;
  readonly __wbindgen_malloc: (a: number, b: number) => number;
  readonly __wbindgen_realloc: (a: number, b: number, c: number, d: number) => number;
  readonly __wbindgen_add_to_stack_pointer: (a: number) => number;
  readonly __wbindgen_free: (a: number, b: number, c: number) => void;
  readonly __wbindgen_exn_store: (a: number) => void;
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
