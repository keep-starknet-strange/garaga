# Rust -> Wasm bidings

## Adding bindings

To add new Rust to WASM bindings for the Garaga library, follow these steps:

1. Create a new function in the Rust codebase (`tools/garaga_rs/src`) that implements the functionality you want to expose to JavaScript/TypeScript.

2. Add a new `#[wasm_bindgen]` annotated function in `tools/garaga_rs/src/wasm_bindings.rs`. This function will act as the bridge between the Rust implementation and the JavaScript/TypeScript world. For example:

   ```rust
   #[wasm_bindgen]
   pub fn my_new_function(input1: JsValue, input2: JsValue) -> Result<JsValue, JsValue> {
       // 1. Convert JsValue inputs to Rust types using helper functions like jsvalue_to_biguint
       let rust_input1 = jsvalue_to_biguint(input1)?;
       let rust_input2 = jsvalue_to_biguint(input2)?;
       
       // 2. Call the internal Rust function with the converted values
       let result = crate::module::path::internal_rust_function(rust_input1, rust_input2)
           .map_err(|e| JsValue::from_str(&e.to_string()))?;
       
       // 3. Convert Rust result back to JsValue
       Ok(biguint_to_jsvalue(result))
   }
   ```

3. Ensure your function handles all necessary type conversions between JavaScript and Rust:
   - Use existing helper functions from `wasm_bindings.rs` like `jsvalue_to_biguint`, `biguint_to_jsvalue`, `parse_g1_point`, etc.
   - Implement new helper functions if needed for your specific data types.

4. Add error handling using Rust's `Result` type, converting any Rust errors to `JsValue` that can be thrown as JavaScript exceptions.

5. Rebuild the WASM package using the `build` NPM script:
   ```bash
   cd tools/npm/garaga_ts
   npm run build
   ```

6. Test your new function by writing a test case in TypeScript, located in `tools/npm/garaga_ts/src/node/tests/`.

7. Expose your function in the TypeScript API by adding it to the appropriate file in `tools/npm/garaga_ts/src/node/`.

8. Before committing, rebuild the WASM package in a reproducible manner using Docker:
   ```bash
   docker compose up --build
   ```

Remember that properly typed input/output parameters in your WASM binding functions will make it easier for TypeScript developers to use your function.

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

```bash
cd tools/garaga_rs && wasm-pack build --target web --out-dir ../npm/garaga_ts/src/wasm/pkg --release --no-default-features
cd tools/npm/garaga_ts && node patch.wasm.cjs
```
