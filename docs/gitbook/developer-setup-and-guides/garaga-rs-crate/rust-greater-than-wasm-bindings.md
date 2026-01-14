# Rust -> Wasm bindings

This guide explains how to add new WASM bindings for Rust functions in the `garaga_rs` crate.

## Overview

The WASM bindings are implemented using `wasm-bindgen`, which provides a way to expose Rust functions to JavaScript/TypeScript. The bindings are located in `tools/garaga_rs/src/wasm_bindings.rs`.

## Adding a New Binding

1. Add your function to `tools/garaga_rs/src/wasm_bindings.rs`
2. Use the `#[wasm_bindgen]` attribute to expose the function
3. Rebuild the WASM package

### Example Implementation

```rust
use wasm_bindgen::prelude::*;
use num_bigint::BigUint;

#[wasm_bindgen]
pub fn your_function(
    input_hex: &str,           // Hex string input
    input_array: Vec<JsValue>, // Array of values
) -> Result<JsValue, JsError> {
    // Parse hex string to BigUint
    let value = jsvalue_to_biguint(&JsValue::from_str(input_hex))?;

    // Process array elements
    let values: Vec<BigUint> = input_array
        .iter()
        .map(|v| jsvalue_to_biguint(v))
        .collect::<Result<Vec<_>, _>>()?;

    // Perform computation
    let result = compute_something(&value, &values)
        .map_err(|e| JsError::new(&e.to_string()))?;

    // Return result as BigInt string
    Ok(biguint_to_jsvalue(&result))
}
```

### Type Conversions

Common conversion patterns for WASM bindings:

```rust
// JsValue (hex string) -> BigUint
let biguint = jsvalue_to_biguint(&js_value)?;

// BigUint -> JsValue (string)
let js_value = biguint_to_jsvalue(&biguint);

// Parse G1 point from JS object
let point = parse_g1_point(&js_object)?;

// Parse G2 point from JS object
let point = parse_g2_point(&js_object)?;
```

### Error Handling

Use `JsError` for errors that should be visible in JavaScript:

```rust
.map_err(|e| JsError::new(&e.to_string()))?
```

## Available Functions

The following functions are currently exposed via WASM:

| Function | Description |
|----------|-------------|
| `msm_calldata_builder` | Generate MSM calldata |
| `mpc_calldata_builder` | Generate multi-pairing check calldata |
| `get_groth16_calldata` | Generate Groth16 proof calldata |
| `get_zk_honk_calldata` | Generate ZK Honk proof calldata |
| `schnorr_calldata_builder` | Schnorr signature calldata |
| `ecdsa_calldata_builder` | ECDSA signature calldata |
| `eddsa_calldata_builder` | EdDSA signature calldata |
| `drand_calldata_builder` | drand verification calldata |
| `poseidon_hash` | Poseidon hash (BN254) |
| `to_weirstrass` | Convert Ed25519 to Weierstrass form |
| `to_twistededwards` | Convert Weierstrass to Twisted Edwards |

## TypeScript Wrapper

The TypeScript API in `tools/npm/garaga_ts/src/node/api.ts` provides a friendlier interface over the raw WASM bindings:

```typescript
import { init, msmCalldataBuilder } from 'garaga';

// Initialize WASM module (required once)
await init();

// Use the API
const calldata = msmCalldataBuilder(
  points,    // Array of {x, y} objects
  scalars,   // Array of bigint or hex strings
  curveId,   // 0=BN254, 1=BLS12-381, etc.
  { includePointsAndScalars: true }
);
```

## Development notes

The Garaga NPM package is a mixed package. It is implemented in TypeScript but also reuses Rust code targeted to WebAssembly (WASM) with the help of [`wasm-pack`](https://rustwasm.github.io/wasm-pack/).

The `src` folder is organized into two subfolders: `node` which contains the implementation in TypeScript; and `wasm` which has the interoperabilty code produced by `wasm-pack`.

Changes to the TypeScript library should only be made to files under the `node` subfolder. Changes to the Rust implementation requires regenerating files under the `wasm` subfolder.

Onces changes are in place they can be made permanent into the repository by committing the contents of both folders. Here is the bulk of the process:

1. Open your terminal or command prompt.
2.  Use `git` to clone the repository:

    ```bash
    git clone https://github.com/keep-starknet-strange/garaga.git
    cd tools/npm/garaga_ts
    npm ci
    ```
3.  If you make TypeScript only changes, you can quickly rebuild the package using the `build:node` NPM script:

    ```bash
    npm run build:node
    npm pack
    ```
4.  If instead you make Rust changes, it is necessary to generate the WASM interoperability code using the `build` NPM script:

    ```bash
    npm run build
    npm pack
    ```
5.  However, before commiting changes, it is necessary to generate the WASM interoperability code in a reproducible manner using docker:

    ```bash
    docker compose up --build
    git commit .
    ```

### How `wasm-pack` is used to achieve interoperability

Internaly the `build` NPM script uses `wasm-pack` to produce the WASM interoperability code. This is achieved by running

````
```bash
cd tools/garaga_rs && wasm-pack build --target web --out-dir ../npm/garaga_ts/src/wasm/pkg --release --no-default-features --features wasm
cd tools/npm/garaga_ts && node patch.wasm.cjs
```
````

Let's unpack it.

In the Rust source folder we run `wasm-pack` in `--target web` mode. This generates TypeScript code targeting web pages. The `--release` option is required to minimize the size of the WASM module. The `--no-default-features` ensures we start with a clean slate (no bindings), and `--features wasm` explicitly enables only the WASM bindings we need.

Once the `wasm-pack` is done, the code is generated under the folder `src/wasm/pkg` of garaga\_ts that houses the TypeScript source code.

We then run a custom script `patch.wasm.cjs` which makes minimal changes to the code generated by wasm-pack to facilitate seamless support of the WASM module in both the browser and Node.js. Basically it converts the WASM module to a [Base64](https://en.wikipedia.org/wiki/Base64) string that can be loaded in a portable way in both environments, amongst other minor tweaks.

(It is important to note that the use of a custom script is only required so long `wasm-pack` itself does not provide a more portable/universal target mode.)
