---
icon: arrow-down-to-bracket
---

# Using Garaga Libraries in Your Cairo Project

Garaga provides a powerful Cairo library for elliptic curve operations, signature verification, and cryptographic primitives. The library is designed to work **uniformly across all supported curves**—the same functions, the same patterns, just change the curve identifier.

## Installation

Garaga is available on the [scarbs.xyz registry](https://scarbs.xyz/packages/garaga). Add it to your project using `scarb add`:

```bash
scarb add garaga
```

Or add it manually to your `Scarb.toml`:

{% code title="Scarb.toml" %}
```toml
[dependencies]
garaga = "1.0.1"

[cairo]
sierra-replace-ids = false # Required to avoid compilation errors
```
{% endcode %}

{% hint style="info" %}
Using the registry is the recommended approach. For more details on managing dependencies, see the [Scarb documentation](https://docs.swmansion.com/scarb/docs/guides/dependencies.html).
{% endhint %}

{% hint style="warning" %}
**Important**: The `sierra-replace-ids = false` setting is required. See [issue #198](https://github.com/keep-starknet-strange/garaga/issues/198) for details about using Garaga with workspaces.
{% endhint %}

### Installing from Git (alternative)

If you need a specific commit or unreleased version, you can install from Git:

```toml
[dependencies]
garaga = { git = "https://github.com/keep-starknet-strange/garaga.git", tag = "v1.0.1" }
```

---

## Generic Over Any Curve

One of Garaga's key architectural decisions is that **all operations work uniformly across any supported curve**. This means:

- ✅ The same `msm_g1` function works for BN254, BLS12-381, SECP256K1, and more
- ✅ The same signature verification patterns apply to all curves
- ✅ Switching curves requires only changing the `curve_id` parameter
- ✅ Future curves can be added without changing your code

### Example: Curve-Agnostic MSM

```cairo
use garaga::ec_ops::msm_g1;
use garaga::definitions::{G1Point, u384};

// This exact same function works for ANY supported curve
fn compute_msm(
    points: Span<G1Point>,
    scalars: Span<u256>,
    curve_id: usize,  // Just change this to switch curves!
    hints: Span<felt252>,
) -> G1Point {
    msm_g1(points, scalars, hints, curve_id)
}

// Usage:
// compute_msm(points, scalars, 0, hints)  // BN254
// compute_msm(points, scalars, 2, hints)  // SECP256K1
// compute_msm(points, scalars, 3, hints)  // SECP256R1
```

This design enables maximum code reuse and flexibility across your applications.

---

## Supported Elliptic Curves

| Curve ID | Curve | Common Use Cases |
|----------|-------|------------------|
| **0** | BN254 | Ethereum zkSNARKs, Groth16 |
| **1** | BLS12-381 | Ethereum 2.0, Zcash, drand |
| **2** | SECP256K1 | Bitcoin, Ethereum ECDSA |
| **3** | SECP256R1 | WebAuthn, TLS, P-256 |
| **4** | ED25519 | Solana, SSH, general EdDSA |
| **5** | GRUMPKIN | Noir circuits, Aztec |

{% hint style="info" %}
These curve identifiers are consistent across **all** Garaga code—Cairo, Python, Rust, and TypeScript. Use the same ID everywhere.
{% endhint %}

---

## Available Operations

### Elliptic Curve Operations

| Operation | Description | Curves |
|-----------|-------------|--------|
| **Multi-Scalar Multiplication (MSM)** | Compute `∑ sᵢ·Pᵢ` efficiently | All |
| **Scalar Multiplication** | Compute `s·P` for a single point | All |
| **Point Addition** | Add two elliptic curve points | All |
| **Pairing Check** | Verify pairing equations | BN254, BLS12-381 |

[→ EC Operations Documentation](ec-multi-scalar-multiplication.md)

### Signature Verification

| Scheme | Description | Curves |
|--------|-------------|--------|
| **ECDSA** | Standard elliptic curve signatures | SECP256K1, SECP256R1, BN254, BLS12-381 |
| **Schnorr** | BIP340-compatible Schnorr signatures | All Weierstrass curves |
| **EdDSA** | Edwards-curve signatures | ED25519 |

[→ Signatures Documentation](ec-signatures.md)

### Hashing Functions

| Function | Description | Use Case |
|----------|-------------|----------|
| **SHA-512** | Standard SHA-512 | EdDSA, general hashing |
| **Poseidon (BN254)** | ZK-friendly hash | Grumpkin circuits |

[→ Hashing Documentation](hashing-functions.md)

---

## Performance Characteristics

Garaga achieves efficiency through **precomputed hints**. The SDK (Python/Rust/TypeScript) generates these hints off-chain, and the Cairo code verifies them on-chain. This means:

1. **Off-chain**: Complex computations happen in the SDK
2. **On-chain**: Cairo only verifies the results are correct

```
┌─────────────────────────────────────────────────────────────┐
│  Off-chain (SDK)                                            │
│  - Compute MSM/signature verification                       │
│  - Generate verification hints                              │
│  - Serialize as calldata                                    │
└───────────────────────────┬─────────────────────────────────┘
                            │ calldata with hints
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  On-chain (Cairo)                                           │
│  - Deserialize calldata                                     │
│  - Verify hints are correct                                 │
│  - Return result (success/failure)                          │
└─────────────────────────────────────────────────────────────┘
```

This architecture enables operations that would otherwise be prohibitively expensive on-chain.

---

## Next Steps

- [**EC Multi-Scalar Multiplication**](ec-multi-scalar-multiplication.md) — Compute MSMs on any curve
- [**Signature Verification**](ec-signatures.md) — ECDSA, Schnorr, and EdDSA
- [**Hashing Functions**](hashing-functions.md) — SHA-512 and Poseidon
