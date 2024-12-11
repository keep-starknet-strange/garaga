---
icon: file-lock
---

# Maintained Smart Contracts

We declare & maintain Smart Contracts for the community so they can be used as library calls.

\
Those contracts:

* Are _declared_ both Starknet Sepolia and Mainnet.
* Those contracts are re-deployed at each release, so their code correspond to the release commit.
* The source code is always available in the main garaga repository under `src/contracts`
* The contracts are only declared and not deployed, their expected usage is through [library syscalls.](https://book.cairo-lang.org/ch15-03-executing-code-from-another-class.html#library-calls), their usage is done through their class hashes.  \
  \
  &#x20;

### Class hash for Garaga v0.15.1.

| Contract                                                                                                          | Class hash                                                          | Description                                                                                                   |
| ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| [Universal ECIP](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/universal_ecip)          | `0xc4b7aa28a27b5fb8d7d43928b2a3ee960cf5b4e06cb9ae1ee3f102400b1700`  | A contract allowing to compute elliptic curve multi scalar multiplication for all supported curve identifiers |
| [RiscZero Verifier](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/risc0_verifier_bn254) | `0x34fda7d39c28c2fb0d8e876f1c51a38f9fa395023c3749a0ee793611baa6095` | A verifier for RiscZero Groth16-wrapped proofs.                                                               |
| [Drand Quicknet Verifier](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/drand_quicknet) | `0x381e2dda664bb383a95b49bf83f04eef1a656aca8ab2e66c9499fa9a8079624` | A contract to verify Drand signatures. Soon with timelock encryption utilities.                               |



