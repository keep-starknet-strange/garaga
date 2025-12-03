---
icon: shield-check
---

# Security

Garaga is designed with security as a primary concern. This page documents our security practices, audit history, and important considerations for users.

---

## Audit Status

### ✅ Audited by CryptoExperts

Garaga has undergone a comprehensive security audit:

| Audit | Auditor | Date | Report |
|-------|---------|------|--------|
| **Garaga v1.0.1** | [CryptoExperts](https://www.cryptoexperts.com/) | June 27, 2025 | [View Report (PDF)](https://github.com/keep-starknet-strange/garaga/blob/main/docs/Garaga-audit-report-v2.pdf) |

{% hint style="success" %}
The audit covered core cryptographic operations including pairing checks, multi-scalar multiplication, and the Groth16 verifier implementation.
{% endhint %}

---

## Security Considerations

### Signature Verification

{% hint style="warning" %}
**Hash Computation Responsibility**

The functions `is_valid_ecdsa_signature_assuming_hash` and `is_valid_schnorr_signature_assuming_hash` verify signature equations but **do not hash the message**. The caller is responsible for:

1. Correctly computing the message hash
2. Using the appropriate hash function for the signature scheme
3. Ensuring the hash is computed over the correct message

**Incorrect hash computation will result in invalid signatures being accepted or valid signatures being rejected.**
{% endhint %}

### EdDSA (Ed25519) Specific

The EdDSA implementation includes protections against common attacks:

- ✅ **Small-order point rejection**: Explicitly rejects points in small subgroups
- ✅ **Cofactor handling**: Properly handles the Ed25519 cofactor
- ✅ **Canonical encoding**: Enforces canonical point encoding

### Curve Selection

When using Garaga's curve-agnostic APIs, ensure you:

1. Use the correct `curve_id` for your application
2. Understand the security properties of your chosen curve
3. Use appropriate key sizes and parameters

| Curve | Security Level | Notes |
|-------|----------------|-------|
| BN254 | ~100 bits | Widely used in Ethereum ecosystem |
| BLS12-381 | ~128 bits | Recommended for new applications |
| SECP256K1 | ~128 bits | Bitcoin/Ethereum compatibility |
| SECP256R1 | ~128 bits | WebAuthn/TLS compatibility |
| ED25519 | ~128 bits | High performance EdDSA |

---

## Responsible Disclosure

If you discover a security vulnerability in Garaga:

1. **Do NOT** open a public GitHub issue
2. **DO** email the maintainers privately
3. **DO** provide detailed information about the vulnerability
4. **DO** allow reasonable time for a fix before public disclosure

See our [Security Policy](https://github.com/keep-starknet-strange/garaga/blob/main/docs/SECURITY.md) for contact information.

---

## Cryptographic References

Garaga's implementations are based on peer-reviewed cryptographic research. We recommend understanding these papers if you're building security-critical applications:

### Zero-Knowledge Proofs

| Paper | Authors | Reference |
|-------|---------|-----------|
| **Groth16** | Jens Groth | "On the Size of Pairing-Based Non-interactive Arguments" EUROCRYPT 2016. [ePrint 2016/260](https://eprint.iacr.org/2016/260) |
| **PLONK** | Gabizon, Williamson, Ciobotaru | "PLONK: Permutations over Lagrange-bases for Oecumenical Noninteractive arguments of Knowledge" [ePrint 2019/953](https://eprint.iacr.org/2019/953) |

### Elliptic Curves & Pairings

| Paper | Authors | Reference |
|-------|---------|-----------|
| **Efficient Pairings** | Youssef El Housni | "Pairings in Rank-1 Constraint Systems" [ePrint 2022/1162](https://eprint.iacr.org/2022/1162) |
| **ECIP** | Liam Eagen | "Zero Knowledge Proofs of Elliptic Curve Inner Products from Principal Divisors and Weil Reciprocity" [ePrint 2022/596](https://eprint.iacr.org/2022/596) |
| **On Proving Pairings** | Novakovic & Eagen | [ePrint 2024/640](https://eprint.iacr.org/2024/640) |
| **Fast EC Scalar Multiplications** | Eagen, El Housni, Masson, Piellard | [ePrint 2025/933](https://eprint.iacr.org/2025/933) |
| **Pairing for Beginners** | Craig Costello | [PDF](https://static1.squarespace.com/static/5fdbb09f31d71c1227082339/t/5ff394720493bd28278889c6/1609798774687/PairingsForBeginners.pdf) |

### Signatures

| Paper | Authors | Reference |
|-------|---------|-----------|
| **EdDSA** | Bernstein et al. | "High-speed high-security signatures" [ed25519.cr.yp.to](https://ed25519.cr.yp.to/) |
| **Taming EdDSAs** | Chalkias, Garillot, Nikolaenko | "Taming the Many EdDSAs" SSR 2020. [ACM DL](https://dl.acm.org/doi/abs/10.1007/978-3-030-64357-7_4) |
| **BIP340** | Wuille, Nick, Towns | "Schnorr Signatures for secp256k1" [BIP340](https://github.com/bitcoin/bips/blob/master/bip-0340.mediawiki) |

### Randomness

| Paper | Authors | Reference |
|-------|---------|-----------|
| **drand** | Syta et al. | "Scalable Bias-Resistant Distributed Randomness" IEEE S&P 2017 |
| **Time-Lock Encryption** | Gailly, Melissaris, Romailler | "tlock: Practical Timelock Encryption from Threshold BLS" [ePrint 2023/189](https://eprint.iacr.org/2023/189) |

---

## Disclaimer

{% hint style="danger" %}
**USE AT YOUR OWN RISK**

Garaga is provided "as is" without any warranty. While we strive for correctness and security:

- 100% security cannot be assured
- Cryptographic software is inherently complex
- Always perform your own security review for production use
- Consider additional audits for high-value applications

See the [MIT License](https://github.com/keep-starknet-strange/garaga/blob/main/LICENSE) for full terms.
{% endhint %}

---

## Security Checklist

Before deploying to production:

- [ ] Understand the cryptographic assumptions
- [ ] Test thoroughly on testnet first
- [ ] Use the latest stable release
- [ ] Monitor for security advisories
- [ ] Consider additional application-level audits
