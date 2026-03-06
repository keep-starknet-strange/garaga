# Falcon-512 Signature Verification — Integration Design

## Overview

Add Falcon-512 lattice-based signature verification to Garaga as a new signature type. Falcon uses NTT-based polynomial arithmetic over Z_12289, with Poseidon hash-to-point for Starknet compatibility.

## Architecture

```
falcon-rs (external Cargo dependency — source of truth)
    |
    v
garaga_rs (calldata builder + packing utils + Python/WASM bindings)
    |
    v
Cairo library (src/src/signatures/falcon/ — verification + hash-to-point)
```

- **falcon-rs** is a Cargo dependency of garaga_rs. No code duplication.
- **No pure-Python implementation.** Rust via maturin bindings is the only Python path.
- **Cairo is a library**, not a contract. No on-chain storage concepts.

## Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| falcon-rs integration | Cargo dependency | DRY, updates flow through |
| Cairo BoundedInt | Use garaga's corelib_imports (already a local dep) | Native support |
| Unrolled NTT | Copy ntt_felt252.cairo as-is | Fixed for Falcon-512, no generator needed |
| Message hashing | On-chain (Poseidon hash-to-point in Cairo) | Cheap, no trust assumption |
| Public key in calldata | Separate via `prepend_public_key` flag | PK is large (29 felt252) |
| Python backend | Bindings only, no pure-Python impl | falcon-rs is source of truth |
| WASM exports | Calldata builder + pack/unpack utilities | Covers calldata + key storage |
| Cairo module structure | Subdirectory `falcon/` | Complex enough to warrant it |

## Cairo Library — `src/src/signatures/falcon/`

| File | Content |
|------|---------|
| `lib.cairo` | Module exports |
| `types.cairo` | `FalconPublicKey`, `FalconSignature`, `FalconSignatureWithHint`, `PackedPolynomial512` + Serde |
| `zq.cairo` | `Zq = BoundedInt<0, 12288>`, modular add/sub/mul with lazy reduction type chains |
| `falcon.cairo` | `verify_falcon(pk, sig_with_hint, message, salt) -> bool` — hashes then verifies |
| `ntt.cairo` | NTT wrapper: `ntt_fast()`, `mul_ntt()` |
| `ntt_felt252.cairo` | Auto-generated unrolled 512-point NTT (~11K lines, copied from s2morrow) |
| `hash_to_point.cairo` | Poseidon PRNG-based hash-to-field -> 512 Zq coefficients |
| `packing.cairo` | Base-Q Horner pack/unpack (512 Zq <-> 29 felt252), `PackedPolynomial512` struct + roundtrip test |

### Verification Algorithm (hint-based)

1. Caller provides: `pk` (h_ntt), `s1`, `salt`, `mul_hint`, `message`
2. Cairo computes `msg_point = hash_to_point(message, salt)` (Poseidon)
3. Compute `s1_ntt = NTT(s1)`, `hint_ntt = NTT(mul_hint)`
4. Verify hint: for each i, assert `s1_ntt[i] * pk_ntt[i] == hint_ntt[i]` (mod Q)
5. Compute norm: `||msg_point - mul_hint||^2 + ||s1||^2`
6. Check `norm <= SIG_BOUND_512` (34034726)

No INTT needed — the hint avoids it by providing the INTT result, verified via 2 forward NTTs.

## Rust — `tools/garaga_rs/`

### Cargo dependency

Add to `tools/garaga_rs/Cargo.toml`:
```toml
falcon-rs = { path = "../../path/to/falcon-rs" }  # or git
```

### Calldata builder — `src/calldata/signatures.rs`

```rust
pub fn falcon_calldata_builder(
    vk_bytes: &[u8],        // 896-byte serialized public key
    signature_bytes: &[u8],  // compressed Falcon signature
    message: &[BigUint],     // felt252 message elements
    prepend_public_key: bool,
) -> Result<Vec<BigUint>, String>
```

Steps:
1. Parse public key -> h coefficients, compute NTT(h)
2. Decompress signature -> s1 + salt
3. Generate `mul_hint = INTT(NTT(s1) * NTT(h))` via falcon-rs
4. Pack pk_ntt, s1, mul_hint into 29 felt252 each via base-Q Horner
5. Assemble calldata with optional pk prefix

Also expose:
- `pack_falcon_public_key(coeffs) -> Vec<BigUint>` (512 Zq -> 29 felt252)
- `unpack_falcon_public_key(packed) -> Vec<u16>` (29 felt252 -> 512 Zq)

### Calldata format

```
[optional: pk_ntt_packed (29 felt252)]
s1_packed        (29 felt252)
salt_len         (1 felt252)
salt             (salt_len felt252)
mul_hint_packed  (29 felt252)
message_len      (1 felt252)
message          (message_len felt252)
```

## Python Bindings

Exposed via maturin in garaga_rs's Python module:
- `garaga_rs.falcon_calldata_builder(vk_bytes, sig_bytes, message, prepend_pk)`
- `garaga_rs.pack_falcon_public_key(coeffs)`
- `garaga_rs.unpack_falcon_public_key(packed)`

No pure-Python fallback. falcon-rs is source of truth.

## WASM + TypeScript

### WASM exports (`src/wasm_bindings.rs`)
- `falcon_calldata_builder(vk, signature, message, prepend_public_key)`
- `pack_falcon_public_key(vk_bytes)`
- `unpack_falcon_public_key(packed)`

### TypeScript wrappers (`tools/npm/garaga_ts/src/node/api.ts`)
```typescript
export function falconCalldataBuilder(
    vk: Uint8Array, signature: Uint8Array,
    message: bigint[], prependPublicKey: boolean
): bigint[]

export function packFalconPublicKey(coeffs: number[]): bigint[]
export function unpackFalconPublicKey(packed: bigint[]): number[]
```

## Tests

### Static vectors
Ship JSON test vectors from falcon-rs: pk, sig, message, expected calldata.

### Rust tests (`tools/garaga_rs/`)
- Calldata builder produces output that falcon-rs can verify
- Pack/unpack roundtrip: `unpack(pack(coeffs)) == coeffs`
- Cross-validation with falcon-rs test vectors

### Python tests (`tests/hydra/starknet/`)
- Call `garaga_rs.falcon_calldata_builder()` via maturin
- Verify against static vectors

### Cairo tests
- Verification with known-good test vectors
- Pack/unpack roundtrip for `PackedPolynomial512`
- NTT correctness
- Hash-to-point correctness

## References

- Falcon Cairo implementation: `/Users/felt/PycharmProjects/starknet/s2morrow/packages/falcon/`
- Falcon-RS: `/Users/felt/PycharmProjects/zk-crypto/falcon-rs/`
- Falcon spec: https://falcon-sign.info/
