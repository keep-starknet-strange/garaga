# Falcon-512 Integration Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add Falcon-512 lattice-based signature verification to Garaga across all layers (Cairo, Rust, Python, WASM, TypeScript).

**Architecture:** falcon-rs is added as a Cargo dependency to garaga_rs. The Rust calldata builder calls falcon-rs for decompression, NTT, and hint generation, then packs results into `Vec<BigUint>` for Cairo consumption. Cairo verification code is copied from s2morrow with import path adjustments. No pure-Python implementation — only maturin bindings.

**Tech Stack:** Cairo (BoundedInt/Zq arithmetic), Rust (falcon-rs, num-bigint, pyo3, wasm-bindgen), Python (pytest), TypeScript, WASM.

**Reference files:**
- Falcon Cairo source: `/Users/felt/PycharmProjects/starknet/s2morrow/packages/falcon/src/`
- Falcon-RS source: `/Users/felt/PycharmProjects/zk-crypto/falcon-rs/src/`
- Garaga worktree: `/Users/felt/PycharmProjects/starknet/garaga/.claude/worktrees/falcon/`

---

### Task 1: Copy Cairo Falcon module into garaga

**Files:**
- Create: `src/src/signatures/falcon/lib.cairo`
- Create: `src/src/signatures/falcon/types.cairo`
- Create: `src/src/signatures/falcon/zq.cairo`
- Create: `src/src/signatures/falcon/falcon.cairo`
- Create: `src/src/signatures/falcon/ntt.cairo`
- Create: `src/src/signatures/falcon/ntt_felt252.cairo`
- Create: `src/src/signatures/falcon/hash_to_point.cairo`
- Create: `src/src/signatures/falcon/packing.cairo`
- Modify: `src/src/lib.cairo:45-49` (add falcon to signatures module)

**Step 1: Create the falcon directory**

```bash
mkdir -p src/src/signatures/falcon
```

**Step 2: Copy source files from s2morrow**

Copy each file from `/Users/felt/PycharmProjects/starknet/s2morrow/packages/falcon/src/` to `src/src/signatures/falcon/`, making these import adjustments:

For ALL files, replace:
- `use falcon::` → `use super::`
- `use crate::` → `use super::`

The `use corelib_imports::` imports stay unchanged (garaga has the same local dep).

**lib.cairo:**
```cairo
pub mod falcon;
pub mod hash_to_point;
pub mod ntt;
pub mod ntt_felt252;
pub mod packing;
pub mod types;
pub mod zq;
```

**types.cairo** — copy from s2morrow, replace `use falcon::zq::Zq` → `use super::zq::Zq` and `use falcon::packing::PackedPolynomial512` → `use super::packing::PackedPolynomial512`.

**zq.cairo** — copy verbatim (only imports `corelib_imports::`, no `falcon::` or `crate::`).

**falcon.cairo** — copy from s2morrow, replace:
- `use falcon::types::` → `use super::types::`
- `use crate::ntt::` → `use super::ntt::`
- `use crate::packing::` → `use super::packing::`
- `use crate::zq::` → `use super::zq::`

**ntt.cairo** — copy from s2morrow, replace:
- `use crate::ntt_felt252::` → `use super::ntt_felt252::`
- `use crate::zq::` → `use super::zq::`

**ntt_felt252.cairo** — copy verbatim from s2morrow (~11,602 lines). Replace:
- `use crate::zq::` → `use super::zq::`

**hash_to_point.cairo** — copy from s2morrow, replace:
- `use falcon::types::HashToPoint` → `use super::types::HashToPoint`
- `use falcon::zq::` → `use super::zq::`

**packing.cairo** — copy from s2morrow, replace:
- `use falcon::zq::` → `use super::zq::`

**Step 3: Register falcon module in garaga's lib.cairo**

Modify `src/src/lib.cairo:45-49` from:
```cairo
pub mod signatures {
    pub mod ecdsa;
    pub mod eddsa_25519;
    pub mod schnorr;
}
```
to:
```cairo
pub mod signatures {
    pub mod ecdsa;
    pub mod eddsa_25519;
    pub mod falcon;
    pub mod schnorr;
}
```

**Step 4: Verify Cairo compilation**

Run: `cd src && scarb build 2>&1 | head -50`

Expected: Compiles successfully (warnings OK, no errors).

**Step 5: Commit**

```bash
git add src/src/signatures/falcon/ src/src/lib.cairo
git commit -m "feat: add Falcon-512 Cairo verification module

Copy from s2morrow/packages/falcon with import paths adjusted
for garaga module structure. Includes: types, Zq arithmetic,
unrolled NTT, Poseidon hash-to-point, base-Q packing, and
hint-based verification."
```

---

### Task 2: Add falcon-rs dependency to garaga_rs and implement packing

**Files:**
- Modify: `tools/garaga_rs/Cargo.toml:45-62` (add falcon-rs dep)
- Create: `tools/garaga_rs/src/calldata/falcon_calldata.rs`
- Modify: `tools/garaga_rs/src/calldata/mod.rs:1-9` (add module)

**Step 1: Add falcon-rs to Cargo.toml**

Add to `tools/garaga_rs/Cargo.toml` dependencies section (after line 61):

```toml
falcon-rs = { path = "../../../zk-crypto/falcon-rs", default-features = false }
```

Note: `default-features = false` disables the `shake` feature (which pulls in `sha3` and `getrandom`). We only need the core NTT, hints, encoding, and packing logic. If compilation fails due to missing shake feature, use `features = ["shake"]` instead.

**Important:** falcon-rs uses `lambdaworks-math = "0.13"` (crates.io) while garaga_rs uses a git rev. Cargo handles this fine — they coexist as separate crate versions. We avoid calling any falcon-rs function that returns a lambdaworks `Felt` type; instead we work with `i32`/`u16`/`u8` and convert to `BigUint` in garaga_rs.

**Step 2: Create falcon_calldata module with packing utilities**

Create `tools/garaga_rs/src/calldata/falcon_calldata.rs`:

```rust
//! Falcon-512 calldata builder for Cairo verification.
//!
//! Uses falcon-rs for decompression, NTT, and hint generation.
//! Packing to felt252 (BigUint) is done here to avoid lambdaworks version conflicts.

use falcon_rs::encoding::{decompress, deserialize_public_key};
use falcon_rs::falcon::{VerifyingKey, Signature, FalconError, PUBLIC_KEY_LEN};
use falcon_rs::hints::generate_mul_hint;
use falcon_rs::ntt::ntt;
use falcon_rs::{N, Q};
use num_bigint::BigUint;
use num_traits::Zero;

const VALS_PER_U128: usize = 9;
const VALS_PER_FELT: usize = 18;
pub const PACKED_SLOTS: usize = 29;

// =============================================================================
// Base-Q packing (BigUint version, matching Cairo/falcon-rs exactly)
// =============================================================================

/// Horner-encode up to 9 u16 values into a u128.
/// Encoding: v0 + Q*(v1 + Q*(v2 + ... + Q*v8))
fn horner_pack(values: &[u16]) -> u128 {
    let mut acc: u128 = 0;
    for &v in values.iter().rev() {
        acc = acc * Q as u128 + v as u128;
    }
    acc
}

/// Extract `count` base-Q digits from a u128.
fn base_q_extract(mut value: u128, count: usize, out: &mut Vec<u16>) {
    for _ in 0..count {
        out.push((value % Q as u128) as u16);
        value /= Q as u128;
    }
}

/// Pack 512 u16 Zq values into 29 BigUint (felt252) values.
pub fn pack_falcon_public_key(coeffs: &[u16]) -> Vec<BigUint> {
    assert_eq!(coeffs.len(), 512);
    let two_128 = BigUint::from(1u64) << 128;
    coeffs
        .chunks(VALS_PER_FELT)
        .map(|chunk| {
            let lo = horner_pack(&chunk[..chunk.len().min(VALS_PER_U128)]);
            let hi = if chunk.len() > VALS_PER_U128 {
                horner_pack(&chunk[VALS_PER_U128..])
            } else {
                0u128
            };
            BigUint::from(lo) + BigUint::from(hi) * &two_128
        })
        .collect()
}

/// Unpack 29 BigUint (felt252) values back to 512 u16 Zq values.
pub fn unpack_falcon_public_key(packed: &[BigUint]) -> Vec<u16> {
    let mut result = Vec::with_capacity(512);
    let mut remaining = 512usize;
    let two_128 = BigUint::from(1u64) << 128;
    let mask = &two_128 - BigUint::from(1u64);

    for felt in packed {
        let low = (felt & &mask).try_into().unwrap_or(0u128);
        let high = (felt >> 128).try_into().unwrap_or(0u128);

        let lo_count = remaining.min(VALS_PER_U128);
        base_q_extract(low, lo_count, &mut result);
        remaining -= lo_count;

        if remaining > 0 {
            let hi_count = remaining.min(VALS_PER_U128);
            base_q_extract(high, hi_count, &mut result);
            remaining -= hi_count;
        }
    }
    result
}

// =============================================================================
// Calldata builder
// =============================================================================

/// Build calldata for Falcon-512 signature verification in Cairo.
///
/// Takes raw byte-encoded public key and signature, plus a felt252 message,
/// and produces the calldata array matching Cairo's Serde layout:
///
/// ```text
/// [optional: pk_ntt_packed (29 felt252)]
/// s1_packed        (29 felt252)
/// salt_len         (1 felt252)
/// salt             (salt_len felt252)
/// mul_hint_packed  (29 felt252)
/// message_len      (1 felt252)
/// message          (message_len felt252)
/// ```
pub fn falcon_calldata_builder(
    vk_bytes: &[u8],
    signature_bytes: &[u8],
    message: &[BigUint],
    prepend_public_key: bool,
) -> Result<Vec<BigUint>, String> {
    // 1. Parse and validate public key
    if vk_bytes.len() != PUBLIC_KEY_LEN {
        return Err(format!(
            "Invalid public key length: expected {}, got {}",
            PUBLIC_KEY_LEN,
            vk_bytes.len()
        ));
    }
    let vk = VerifyingKey::from_bytes(vk_bytes.try_into().unwrap())
        .map_err(|e| format!("Invalid public key: {e}"))?;

    // 2. Compute NTT of public key
    let h = vk.h();
    let h_ntt = ntt(h.as_ref());
    let pk_ntt_u16: Vec<u16> = h_ntt.iter().map(|&v| v.rem_euclid(Q) as u16).collect();

    // 3. Parse signature and decompress s1
    let sig = Signature::from_bytes(signature_bytes)
        .map_err(|e| format!("Invalid signature: {e}"))?;

    // Decompress s1 from the signature
    let sig_bytes = sig.to_bytes();
    // Signature format: [header(1), salt(40), s1_enc(rest)]
    let s1_enc = &sig_bytes[1 + 40..];
    let s1_i32 = decompress(s1_enc, N)
        .ok_or_else(|| "Failed to decompress signature s1".to_string())?;
    let s1_u16: Vec<u16> = s1_i32.iter().map(|&v| v.rem_euclid(Q) as u16).collect();

    // 4. Extract salt as felt252 values
    let salt = sig.salt();
    // Pack salt bytes into felt252 (31 bytes per felt, big-endian)
    let salt_felts: Vec<BigUint> = salt
        .chunks(31)
        .map(|chunk| BigUint::from_bytes_be(chunk))
        .collect();

    // 5. Generate mul_hint = INTT(NTT(s1) * pk_ntt)
    let mul_hint = generate_mul_hint(&s1_u16, &pk_ntt_u16);

    // 6. Pack polynomials into felt252
    let packed_pk = pack_falcon_public_key(&pk_ntt_u16);
    let packed_s1 = pack_falcon_public_key(&s1_u16);
    let packed_hint = pack_falcon_public_key(&mul_hint);

    // 7. Assemble calldata
    let mut cd = Vec::new();

    if prepend_public_key {
        cd.extend(packed_pk);
    }

    // s1 packed (29 felt252)
    cd.extend(packed_s1);

    // salt as Array<felt252>: length prefix + data
    cd.push(BigUint::from(salt_felts.len()));
    cd.extend(salt_felts);

    // mul_hint packed (29 felt252)
    cd.extend(packed_hint);

    // message as Array<felt252>: length prefix + data
    cd.push(BigUint::from(message.len()));
    cd.extend_from_slice(message);

    Ok(cd)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_packing_roundtrip() {
        let values: Vec<u16> = (0..512).map(|i| (i * 37 % 12289) as u16).collect();
        let packed = pack_falcon_public_key(&values);
        assert_eq!(packed.len(), PACKED_SLOTS);
        let unpacked = unpack_falcon_public_key(&packed);
        assert_eq!(unpacked, values);
    }

    #[test]
    fn test_packing_zeros() {
        let zeros = vec![0u16; 512];
        assert_eq!(unpack_falcon_public_key(&pack_falcon_public_key(&zeros)), zeros);
    }

    #[test]
    fn test_packing_max_values() {
        let maxes = vec![12288u16; 512];
        assert_eq!(
            unpack_falcon_public_key(&pack_falcon_public_key(&maxes)),
            maxes
        );
    }

    #[test]
    fn test_packing_matches_falcon_rs() {
        // Verify our BigUint packing matches falcon-rs's Felt packing
        let values: Vec<u16> = (0..512).map(|i| (i * 37 % 12289) as u16).collect();
        let our_packed = pack_falcon_public_key(&values);
        let falcon_packed = falcon_rs::packing::pack_public_key(&values);

        // Compare via bytes (different Felt types, same values)
        for (ours, theirs) in our_packed.iter().zip(falcon_packed.iter()) {
            let their_bytes = theirs.to_bytes_be();
            let their_biguint = BigUint::from_bytes_be(&their_bytes);
            assert_eq!(ours, &their_biguint, "Packing mismatch");
        }
    }

    #[test]
    fn test_calldata_builder_basic() {
        use falcon_rs::falcon::Falcon;
        use falcon_rs::hash_to_point::Shake256Hash;

        // Generate a keypair
        let seed = [42u8; 56];
        let (sk, vk) = Falcon::<Shake256Hash>::keygen_with_seed(&seed);

        // Sign a message
        let salt = [0u8; 40];
        let msg = b"test message";
        let sig = Falcon::<Shake256Hash>::sign_with_salt(&sk, msg, &salt);

        // Build calldata
        let message_felts = vec![BigUint::from_bytes_be(msg)];
        let result = falcon_calldata_builder(
            &vk.to_bytes(),
            &sig.to_bytes(),
            &message_felts,
            true,
        );

        assert!(result.is_ok(), "calldata builder failed: {:?}", result.err());
        let cd = result.unwrap();

        // With prepend_pk: 29 (pk) + 29 (s1) + 1 (salt_len) + 2 (salt) + 29 (hint) + 1 (msg_len) + 1 (msg) = 92
        // Salt is 40 bytes = 2 chunks of 31 bytes
        assert!(cd.len() > 60, "calldata too short: {}", cd.len());
    }
}
```

**Step 3: Register module in calldata/mod.rs**

Add to `tools/garaga_rs/src/calldata/mod.rs` after line 9:

```rust
pub mod falcon_calldata;
```

**Step 4: Verify Rust compilation**

Run: `cd tools/garaga_rs && cargo test -p garaga_rs --lib calldata::falcon_calldata 2>&1 | tail -20`

Expected: All 5 tests pass.

**Step 5: Commit**

```bash
git add tools/garaga_rs/Cargo.toml tools/garaga_rs/Cargo.lock tools/garaga_rs/src/calldata/falcon_calldata.rs tools/garaga_rs/src/calldata/mod.rs
git commit -m "feat: add falcon-rs dep and calldata builder to garaga_rs

Implements falcon_calldata_builder() which takes raw VK+sig bytes,
decompresses, computes NTT and mul_hint via falcon-rs, packs into
BigUint felt252 format. Includes pack/unpack roundtrip tests and
cross-validation against falcon-rs packing."
```

---

### Task 3: Add Python bindings for Falcon

**Files:**
- Create: `tools/garaga_rs/src/python_bindings/falcon.rs`
- Modify: `tools/garaga_rs/src/python_bindings/mod.rs:72-82` (register functions)

**Step 1: Create Python binding wrappers**

Create `tools/garaga_rs/src/python_bindings/falcon.rs`:

```rust
use super::*;

#[pyfunction]
pub fn falcon_calldata_builder(
    py: Python,
    vk_bytes: &Bound<'_, PyBytes>,
    signature_bytes: &Bound<'_, PyBytes>,
    message: &Bound<'_, PyList>,
    prepend_public_key: bool,
) -> PyResult<Py<PyAny>> {
    let vk: Vec<u8> = vk_bytes.extract()?;
    let sig: Vec<u8> = signature_bytes.extract()?;
    let msg: Vec<BigUint> = message
        .iter()
        .map(|item| item.extract::<BigUint>())
        .collect::<PyResult<Vec<_>>>()?;

    let result = crate::calldata::falcon_calldata::falcon_calldata_builder(
        &vk, &sig, &msg, prepend_public_key,
    )
    .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}

#[pyfunction]
pub fn pack_falcon_public_key(
    py: Python,
    coeffs: Vec<u16>,
) -> PyResult<Py<PyAny>> {
    let result = crate::calldata::falcon_calldata::pack_falcon_public_key(&coeffs);
    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}

#[pyfunction]
pub fn unpack_falcon_public_key(
    py: Python,
    packed: &Bound<'_, PyList>,
) -> PyResult<Vec<u16>> {
    let packed: Vec<BigUint> = packed
        .iter()
        .map(|item| item.extract::<BigUint>())
        .collect::<PyResult<Vec<_>>>()?;

    Ok(crate::calldata::falcon_calldata::unpack_falcon_public_key(&packed))
}
```

**Step 2: Register in pymodule**

Modify `tools/garaga_rs/src/python_bindings/mod.rs`:

Add at the top (after `pub mod drand_calldata;` equivalent):
```rust
pub mod falcon;
```

Add to the `garaga_rs` pymodule function, before `Ok(())` (around line 81):
```rust
    m.add_function(wrap_pyfunction!(falcon::falcon_calldata_builder, m)?)?;
    m.add_function(wrap_pyfunction!(falcon::pack_falcon_public_key, m)?)?;
    m.add_function(wrap_pyfunction!(falcon::unpack_falcon_public_key, m)?)?;
```

**Step 3: Verify Python bindings compile**

Run: `cd tools/garaga_rs && cargo check --features python 2>&1 | tail -10`

Expected: Compiles without errors.

**Step 4: Build maturin and test import**

Run: `maturin develop --release --features python && python -c "import garaga.garaga_rs as g; print(dir(g))" 2>&1 | tail -5`

Expected: Output includes `falcon_calldata_builder`, `pack_falcon_public_key`, `unpack_falcon_public_key`.

**Step 5: Commit**

```bash
git add tools/garaga_rs/src/python_bindings/falcon.rs tools/garaga_rs/src/python_bindings/mod.rs
git commit -m "feat: add Python bindings for Falcon calldata builder"
```

---

### Task 4: Add WASM bindings for Falcon

**Files:**
- Modify: `tools/garaga_rs/src/wasm_bindings.rs:196-216` (add WASM exports)

**Step 1: Add WASM exports**

Add after the `eddsa_calldata_builder` function (line 196), before `fn jsvalue_to_biguint`:

```rust
#[wasm_bindgen]
pub fn falcon_calldata_builder(
    vk_bytes: &[u8],
    signature_bytes: &[u8],
    message: Vec<JsValue>,
    prepend_public_key: bool,
) -> Result<Vec<JsValue>, JsValue> {
    let msg: Vec<BigUint> = message
        .into_iter()
        .map(jsvalue_to_biguint)
        .collect::<Result<Vec<_>, _>>()?;

    let result = crate::calldata::falcon_calldata::falcon_calldata_builder(
        vk_bytes, signature_bytes, &msg, prepend_public_key,
    )
    .map_err(|e| JsValue::from_str(&e.to_string()))?;

    Ok(result.into_iter().map(biguint_to_jsvalue).collect())
}

#[wasm_bindgen]
pub fn pack_falcon_public_key(coeffs: &[u16]) -> Result<Vec<JsValue>, JsValue> {
    if coeffs.len() != 512 {
        return Err(JsValue::from_str(&format!(
            "Expected 512 coefficients, got {}",
            coeffs.len()
        )));
    }
    let result = crate::calldata::falcon_calldata::pack_falcon_public_key(coeffs);
    Ok(result.into_iter().map(biguint_to_jsvalue).collect())
}

#[wasm_bindgen]
pub fn unpack_falcon_public_key(packed: Vec<JsValue>) -> Result<Vec<u16>, JsValue> {
    let packed: Vec<BigUint> = packed
        .into_iter()
        .map(jsvalue_to_biguint)
        .collect::<Result<Vec<_>, _>>()?;
    Ok(crate::calldata::falcon_calldata::unpack_falcon_public_key(&packed))
}
```

**Step 2: Verify WASM compilation**

Run: `cd tools/garaga_rs && cargo check --features wasm --target wasm32-unknown-unknown 2>&1 | tail -10`

Expected: Compiles without errors. (If wasm32 target not installed, run `rustup target add wasm32-unknown-unknown` first.)

**Step 3: Commit**

```bash
git add tools/garaga_rs/src/wasm_bindings.rs
git commit -m "feat: add WASM bindings for Falcon calldata builder"
```

---

### Task 5: Add TypeScript wrapper

**Files:**
- Modify: `tools/npm/garaga_ts/src/node/api.ts:1-17` (add imports)
- Modify: `tools/npm/garaga_ts/src/node/api.ts:249` (add functions)

**Step 1: Add WASM imports**

In `tools/npm/garaga_ts/src/node/api.ts`, add to the import block (line 4-17):

```typescript
  falcon_calldata_builder,
  pack_falcon_public_key,
  unpack_falcon_public_key,
```

**Step 2: Add TypeScript wrapper functions**

Add after the `eddsaCalldataBuilder` function (around line 249):

```typescript
/**
 * Builds calldata for Falcon-512 signature verification.
 * Falcon is a post-quantum lattice-based signature scheme using NTT-based
 * polynomial arithmetic over Z_12289.
 *
 * @param vk - Public key bytes (896 bytes, 512 coefficients at 14 bits each)
 * @param signature - Compressed signature bytes (666 bytes)
 * @param message - Message as array of felt252 values
 * @param prependPublicKey - Whether to include the packed public key in calldata.
 *                           When true, prepends 29 packed felt252 values.
 *                           When false, only includes signature + hint + message.
 * @returns Array of bigint values representing the Falcon verification calldata
 */
export function falconCalldataBuilder(
  vk: Uint8Array,
  signature: Uint8Array,
  message: bigint[],
  prependPublicKey: boolean,
): bigint[] {
  return falcon_calldata_builder(vk, signature, message, prependPublicKey);
}

/**
 * Pack 512 Falcon Zq coefficients (u16, values in [0, 12288]) into 29 felt252 values
 * using base-Q Horner encoding. Useful for preparing public keys for on-chain storage.
 *
 * @param coeffs - Array of 512 u16 values, each in [0, 12288]
 * @returns Array of 29 bigint (felt252) values
 */
export function packFalconPublicKey(coeffs: number[]): bigint[] {
  return pack_falcon_public_key(new Uint16Array(coeffs));
}

/**
 * Unpack 29 felt252 values back to 512 Falcon Zq coefficients.
 *
 * @param packed - Array of 29 bigint (felt252) values
 * @returns Array of 512 u16 values, each in [0, 12288]
 */
export function unpackFalconPublicKey(packed: bigint[]): number[] {
  return Array.from(unpack_falcon_public_key(packed));
}
```

**Step 3: Commit**

```bash
git add tools/npm/garaga_ts/src/node/api.ts
git commit -m "feat: add TypeScript wrappers for Falcon calldata builder"
```

---

### Task 6: Add Rust tests with full verification roundtrip

**Files:**
- Modify: `tools/garaga_rs/src/calldata/falcon_calldata.rs` (expand tests)

**Step 1: Add end-to-end verification test**

Add to the `#[cfg(test)] mod tests` block in `falcon_calldata.rs`:

```rust
    #[test]
    fn test_calldata_builder_roundtrip_verify() {
        use falcon_rs::falcon::Falcon;
        use falcon_rs::hash_to_point::Shake256Hash;

        // Generate keypair with fixed seed for reproducibility
        let seed = [42u8; 56];
        let (sk, vk) = Falcon::<Shake256Hash>::keygen_with_seed(&seed);

        // Sign a message using SHAKE256
        let msg = b"hello garaga falcon";
        let salt = [1u8; 40];
        let sig = Falcon::<Shake256Hash>::sign_with_salt(&sk, msg, &salt);

        // Verify original signature
        assert!(
            Falcon::<Shake256Hash>::verify(&vk, msg, &sig).unwrap(),
            "Original signature must verify"
        );

        // Build calldata with prepend_public_key=true
        let message_felts = vec![BigUint::from_bytes_be(msg)];
        let cd_with_pk = falcon_calldata_builder(
            &vk.to_bytes(),
            &sig.to_bytes(),
            &message_felts,
            true,
        )
        .expect("calldata builder with pk failed");

        // Build calldata with prepend_public_key=false
        let cd_without_pk = falcon_calldata_builder(
            &vk.to_bytes(),
            &sig.to_bytes(),
            &message_felts,
            false,
        )
        .expect("calldata builder without pk failed");

        // The difference should be exactly 29 (packed pk)
        assert_eq!(cd_with_pk.len(), cd_without_pk.len() + PACKED_SLOTS);

        // Verify the packed pk portion matches standalone packing
        let h_ntt = ntt(vk.h().as_ref());
        let pk_u16: Vec<u16> = h_ntt.iter().map(|&v| v.rem_euclid(Q) as u16).collect();
        let standalone_packed = pack_falcon_public_key(&pk_u16);
        assert_eq!(&cd_with_pk[..PACKED_SLOTS], &standalone_packed[..]);
    }

    #[test]
    fn test_calldata_builder_rejects_bad_pk() {
        let bad_pk = vec![0u8; 10];
        let sig = vec![0u8; 666];
        let msg = vec![BigUint::from(1u64)];
        let result = falcon_calldata_builder(&bad_pk, &sig, &msg, false);
        assert!(result.is_err());
    }
```

**Step 2: Run all tests**

Run: `cd tools/garaga_rs && cargo test -p garaga_rs --lib calldata::falcon_calldata -- --nocapture 2>&1 | tail -20`

Expected: All tests pass.

**Step 3: Commit**

```bash
git add tools/garaga_rs/src/calldata/falcon_calldata.rs
git commit -m "test: add Falcon calldata builder end-to-end verification tests"
```

---

### Task 7: Add Python tests

**Files:**
- Create: `tests/hydra/starknet/test_falcon_calldata.py`

**Step 1: Create Python test file**

```python
"""Tests for Falcon-512 calldata builder via garaga_rs Python bindings."""

import pytest

# Skip entire module if garaga_rs is not built with falcon support
garaga_rs = pytest.importorskip("garaga.garaga_rs")


def test_pack_unpack_roundtrip():
    """Pack 512 Zq values into 29 felt252 and unpack back."""
    coeffs = [(i * 37) % 12289 for i in range(512)]
    packed = garaga_rs.pack_falcon_public_key(coeffs)
    assert len(packed) == 29
    unpacked = garaga_rs.unpack_falcon_public_key(packed)
    assert unpacked == coeffs


def test_pack_zeros():
    """Packing all zeros should roundtrip."""
    coeffs = [0] * 512
    assert garaga_rs.unpack_falcon_public_key(
        garaga_rs.pack_falcon_public_key(coeffs)
    ) == coeffs


def test_pack_max_values():
    """Packing all Q-1 = 12288 should roundtrip."""
    coeffs = [12288] * 512
    assert garaga_rs.unpack_falcon_public_key(
        garaga_rs.pack_falcon_public_key(coeffs)
    ) == coeffs
```

**Step 2: Build maturin and run tests**

Run: `maturin develop --release --features python && pytest tests/hydra/starknet/test_falcon_calldata.py -v 2>&1 | tail -20`

Expected: All 3 tests pass.

**Step 3: Commit**

```bash
git add tests/hydra/starknet/test_falcon_calldata.py
git commit -m "test: add Python tests for Falcon packing roundtrip"
```

---

### Task 8: Add Cairo tests

**Files:**
- Create: `src/src/signatures/falcon/tests/` directory
- Create: `src/src/signatures/falcon/tests/test_packing.cairo`
- Modify: `src/src/signatures/falcon/lib.cairo` (add test module)

**Step 1: Create test directory and packing roundtrip test**

```bash
mkdir -p src/src/signatures/falcon/tests
```

Create `src/src/signatures/falcon/tests/test_packing.cairo`:

```cairo
use garaga::signatures::falcon::zq::Zq;
use garaga::signatures::falcon::packing::{
    PackedPolynomial512, PackedPolynomial512Trait, pack_public_key, unpack_public_key,
};
use corelib_imports::bounded_int::downcast;

/// Test that pack -> unpack roundtrips correctly with known values.
#[test]
fn test_packing_roundtrip() {
    // Create 512 Zq values with varied pattern
    let mut values: Array<Zq> = array![];
    let mut i: u32 = 0;
    while i != 512 {
        let val: u16 = (i * 37 % 12289).try_into().unwrap();
        let zq: Zq = downcast(val).expect('val exceeds Q-1');
        values.append(zq);
        i += 1;
    };

    let packed = pack_public_key(values.span());
    assert!(packed.len() == 29, "expected 29 packed slots");
    let unpacked = unpack_public_key(packed.span());
    assert!(unpacked.len() == 512, "expected 512 unpacked values");

    // Verify roundtrip
    let mut j: u32 = 0;
    while j != 512 {
        assert!(*unpacked.at(j) == *values.at(j), "mismatch at index");
        j += 1;
    };
}

/// Test PackedPolynomial512 struct roundtrip.
#[test]
fn test_packed_polynomial_roundtrip() {
    let mut values: Array<Zq> = array![];
    let mut i: u32 = 0;
    while i != 512 {
        let val: u16 = (i * 13 % 12289).try_into().unwrap();
        let zq: Zq = downcast(val).expect('val exceeds Q-1');
        values.append(zq);
        i += 1;
    };

    let packed_struct = PackedPolynomial512Trait::from_coeffs(values.span());
    let unpacked = packed_struct.to_coeffs();

    let mut j: u32 = 0;
    while j != 512 {
        assert!(*unpacked.at(j) == *values.at(j), "struct roundtrip mismatch");
        j += 1;
    };
}
```

**Step 2: Register test module in lib.cairo**

Add to `src/src/signatures/falcon/lib.cairo`:

```cairo
#[cfg(test)]
mod tests {
    mod test_packing;
}
```

**Step 3: Run Cairo tests**

Run: `cd src && snforge test -p garaga --filter falcon 2>&1 | tail -20`

Expected: 2 tests pass.

**Step 4: Commit**

```bash
git add src/src/signatures/falcon/tests/ src/src/signatures/falcon/lib.cairo
git commit -m "test: add Cairo packing roundtrip tests for Falcon"
```

---

### Task 9: Generate and add cross-language test vectors

**Files:**
- Create: `tests/hydra/starknet/falcon_test_vectors/` directory
- Create: script to generate test vectors from falcon-rs
- Update: `tests/hydra/starknet/test_falcon_calldata.py` with vector-based tests

**Step 1: Create a Rust binary to generate test vectors**

Add to `tools/garaga_rs/src/calldata/falcon_calldata.rs` tests:

```rust
    #[test]
    fn generate_test_vector() {
        use falcon_rs::falcon::Falcon;
        use falcon_rs::hash_to_point::Shake256Hash;

        let seed = [42u8; 56];
        let (sk, vk) = Falcon::<Shake256Hash>::keygen_with_seed(&seed);

        let msg = b"garaga falcon test";
        let salt = [7u8; 40];
        let sig = Falcon::<Shake256Hash>::sign_with_salt(&sk, msg, &salt);

        // Verify
        assert!(Falcon::<Shake256Hash>::verify(&vk, msg, &sig).unwrap());

        let message_felts = vec![BigUint::from_bytes_be(msg)];
        let cd = falcon_calldata_builder(
            &vk.to_bytes(),
            &sig.to_bytes(),
            &message_felts,
            true,
        )
        .unwrap();

        // Print test vector as JSON for cross-language use
        println!("{{");
        println!("  \"vk_hex\": \"{}\",", hex::encode(vk.to_bytes()));
        println!("  \"sig_hex\": \"{}\",", hex::encode(sig.to_bytes()));
        println!("  \"message_hex\": \"{}\",", hex::encode(msg));
        println!("  \"calldata\": [{}]", cd.iter().map(|v| format!("\"{}\"", v)).collect::<Vec<_>>().join(", "));
        println!("}}");
    }
```

Run: `cd tools/garaga_rs && cargo test -p garaga_rs --lib calldata::falcon_calldata::tests::generate_test_vector -- --nocapture 2>&1 | grep -A1000 '{' > ../../tests/hydra/starknet/falcon_test_vector.json`

**Step 2: Add vector-based Python test**

Update `tests/hydra/starknet/test_falcon_calldata.py`:

```python
import json
import os

def test_calldata_against_vector():
    """Verify calldata builder output matches stored test vector."""
    vector_path = os.path.join(
        os.path.dirname(__file__), "falcon_test_vector.json"
    )
    if not os.path.exists(vector_path):
        pytest.skip("Test vector not generated yet")

    with open(vector_path) as f:
        vector = json.load(f)

    vk = bytes.fromhex(vector["vk_hex"])
    sig = bytes.fromhex(vector["sig_hex"])
    msg_bytes = bytes.fromhex(vector["message_hex"])
    expected = [int(v) for v in vector["calldata"]]

    msg_felt = int.from_bytes(msg_bytes, "big")
    result = garaga_rs.falcon_calldata_builder(vk, sig, [msg_felt], True)
    assert result == expected, "Calldata mismatch against test vector"
```

**Step 3: Run tests**

Run: `maturin develop --release --features python && pytest tests/hydra/starknet/test_falcon_calldata.py -v`

Expected: All tests pass.

**Step 4: Commit**

```bash
git add tests/hydra/starknet/test_falcon_calldata.py tests/hydra/starknet/falcon_test_vector.json tools/garaga_rs/src/calldata/falcon_calldata.rs
git commit -m "test: add cross-language Falcon test vectors and Python verification"
```

---

### Task 10: Final verification and cleanup

**Step 1: Run full Rust test suite**

Run: `cd tools/garaga_rs && cargo test -p garaga_rs 2>&1 | tail -20`

Expected: All existing tests still pass, plus new falcon tests.

**Step 2: Run full Cairo test suite**

Run: `cd src && snforge test -p garaga 2>&1 | tail -30`

Expected: All existing tests still pass, plus new falcon tests.

**Step 3: Run full Python test suite**

Run: `pytest tests/hydra/starknet/ -v 2>&1 | tail -30`

Expected: All tests pass.

**Step 4: Verify scarb fmt**

Run: `cd src && scarb fmt`

**Step 5: Verify cargo fmt**

Run: `cd tools/garaga_rs && cargo fmt`

**Step 6: Commit any formatting fixes**

```bash
git add -A && git commit -m "style: format Falcon code" || true
```
