# Garaga

<figure><img src=".gitbook/assets/logo.png" alt="Garaga Logo" width="200"><figcaption></figcaption></figure>

## State-of-the-Art Elliptic Curve Tooling & ZK Proof Verification for Starknet

Garaga enables **efficient verification of zero-knowledge proofs** and **cryptographic operations** on Starknet. It achieves state-of-the-art performance through:

* A **dedicated builtin** from StarkWare for emulated modular arithmetic
* **Non-deterministic techniques** for extension field multiplication, pairings, and multi-scalar multiplication
* **Precomputed verification hints** that dramatically reduce on-chain computation

***

## What Can You Build?

<table data-view="cards"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>🛡️ ZK Proof Verification</strong></td><td>Verify Groth16 and Honk proofs on-chain with production-ready verifier contracts.</td><td><a href="smart-contract-generators/">Learn more →</a></td></tr><tr><td><strong>🔗 zkVM Integration</strong></td><td>Verify proofs from RISC Zero and SP1 using maintained, audited contracts.</td><td><a href="maintained-smart-contracts/">Learn more →</a></td></tr><tr><td><strong>✍️ Signature Verification</strong></td><td>ECDSA, Schnorr, and EdDSA verification across multiple elliptic curves.</td><td><a href="using-garaga-libraries-in-your-cairo-project/ec-signatures.md">Learn more →</a></td></tr><tr><td><strong>🎲 Verifiable Randomness</strong></td><td>On-chain verification of drand beacon signatures for provably fair randomness.</td><td><a href="maintained-smart-contracts/drand.md">Learn more →</a></td></tr><tr><td><strong>🧮 Elliptic Curve Operations</strong></td><td>Multi-scalar multiplication on 6 curves, pairing operations for BN254/BLS12-381.</td><td><a href="using-garaga-libraries-in-your-cairo-project/ec-multi-scalar-multiplication.md">Learn more →</a></td></tr><tr><td><strong>🔒 Privacy-Preserving dApps</strong></td><td>Build applications with Noir/Honk circuits for complex privacy logic.</td><td><a href="smart-contract-generators/noir.md">Learn more →</a></td></tr></tbody></table>

***

## Architecture Overview

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                           YOUR STARKNET DAPP                                 │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   Smart Contract Generators          │       Cairo Libraries                 │
│   ─────────────────────────          │       ───────────────                 │
│   • Groth16 Verifier (BN254/BLS)     │       • EC Operations (MSM)           │
│   • Noir/Honk Verifier               │       • Signatures (ECDSA/Schnorr)    │
│   • Custom circuit verifiers         │       • Pairing Checks                │
│                                      │       • Hashing (SHA-512, Poseidon)   │
│                                                                              │
├──────────────────────────────────────────────────────────────────────────────┤
│                       Maintained Contracts (Declared on Mainnet)             │
│   ─────────────────────────────────────────────────────────────              │
│   • Universal ECIP (MSM)  • RISC Zero Verifier  • SP1 Verifier  • Drand      │
│                                                                              │
├──────────────────────────────────────────────────────────────────────────────┤
│                         SDK (Python / Rust / TypeScript)                     │
│   ─────────────────────────────────────────────────────────────              │
│   Calldata generation • Proof preprocessing • Contract generation            │
│                                                                              │
├──────────────────────────────────────────────────────────────────────────────┤
│  Supported Curves                                                            │
│  ────────────────                                                            │
│  BN254 │ BLS12-381 │ SECP256K1 │ SECP256R1 │ ED25519 │ GRUMPKIN             │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

***

## Performance

Garaga achieves remarkable efficiency through optimized Cairo implementations. See the [full benchmark suite](https://github.com/keep-starknet-strange/garaga#cairo-benchmarks) for detailed metrics on all operations including:

* Groth16 verification (BN254 & BLS12-381)
* Honk/Noir proof verification
* RISC Zero & SP1 proof verification
* Signature verification (ECDSA, Schnorr, EdDSA)
* Multi-scalar multiplication
* Pairing operations

***

## Version Compatibility

{% hint style="warning" %}
**Important:** Garaga SDK versions (Python, Rust, npm) must match across your toolchain to ensure calldata is correctly formatted for on-chain verification.

* **For generated contracts** (Groth16, Noir): Use the same SDK version that generated your verifier contract
* **For maintained contracts** (RISC Zero, SP1, drand): Use the SDK version matching the Garaga release that declared the contract class hashes

All packages are released together with matching version numbers (e.g., `pip install garaga==1.0.1` + `garaga = "1.0.1"` in Scarb.toml + `garaga_rs` tag `v1.0.1` + `npm install garaga@1.0.1`).
{% endhint %}

***

## Quick Start

### 1. Install

{% tabs %}
{% tab title="Python (Recommended)" %}
```bash
pip install garaga
```
{% endtab %}

{% tab title="Cairo Library" %}
```bash
scarb add garaga
```

Or add to `Scarb.toml`:

```toml
[dependencies]
garaga = "1.0.1"
```
{% endtab %}

{% tab title="Rust" %}
```bash
cargo add garaga_rs
```
{% endtab %}

{% tab title="npm" %}
```bash
npm install garaga
```
{% endtab %}
{% endtabs %}

### 2. Generate a Verifier Contract

```bash
# Generate a Groth16 verifier from your verification key
garaga gen --system groth16 --vk your_vk.json

# Or generate a Noir/Honk verifier
garaga gen --system ultra_keccak_honk --vk target/vk
```

### 3. Deploy & Verify

```bash
# Declare and deploy your contract
garaga declare
garaga deploy --class-hash <CLASS_HASH>

# Verify a proof on-chain
garaga verify-onchain --address <CONTRACT_ADDRESS> \
  --vk your_vk.json --proof proof.json --public-inputs inputs.json
```

***

## Production Ready

Garaga is used in production by teams building:

* **Validity rollups** and L2 solutions
* **Cross-chain bridges** with ZK verification
* **Privacy-preserving applications**
* **Verifiable computation** platforms

### Security

* ✅ [**Audited**](https://github.com/keep-starknet-strange/garaga/blob/main/docs/Garaga-audit-report-v2.pdf) by [CryptoExperts](https://www.cryptoexperts.com/)
* ✅ **Battle-tested** on Starknet mainnet
* ✅ **Open source** under MIT license

***

## Resources

* **GitHub**: [github.com/keep-starknet-strange/garaga](https://github.com/keep-starknet-strange/garaga)
* **Telegram**: [t.me/GaragaPairingCairo](https://t.me/GaragaPairingCairo)
* **Academic Papers**: See [References](./#references) below

***

## References

Garaga's cryptographic implementations are based on peer-reviewed research:

1. **Groth16**: Groth, J. "On the Size of Pairing-Based Non-interactive Arguments." EUROCRYPT 2016. [ePrint 2016/260](https://eprint.iacr.org/2016/260)
2. **Efficient Pairings**: El Housni, Y. "Pairings in Rank-1 Constraint Systems." [ePrint 2022/1162](https://eprint.iacr.org/2022/1162)
3. **ECIP**: Eagen, L. "Zero Knowledge Proofs of Elliptic Curve Inner Products." [ePrint 2022/596](https://eprint.iacr.org/2022/596)
4. **On Proving Pairings**: Novakovic, A. & Eagen, L. [ePrint 2024/640](https://eprint.iacr.org/2024/640)
5. **Fast EC Scalar Multiplications**: Eagen, L., El Housni, Y., Masson, S., Piellard, T. [ePrint 2025/933](https://eprint.iacr.org/2025/933)
