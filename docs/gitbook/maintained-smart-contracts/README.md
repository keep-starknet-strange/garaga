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
* The contracts are only declared and not deployed, their expected usage is through [library syscalls.](https://book.cairo-lang.org/ch15-03-executing-code-from-another-class.html#library-calls), their usage is done through their class hashes.\
  \\

### Class hash for Garaga v0.18.0.

| Contract                                                                                                          | Class hash                                                          | Description                                                                                                   |
| ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| [Universal ECIP](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/universal_ecip)          | 0x465991ec820cf53dbb2b27474b6663fb6f0c8bf3dac7db3991960214fad97f5   | A contract allowing to compute elliptic curve multi scalar multiplication for all supported curve identifiers |
| [RiscZero Verifier](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/risc0_verifier_bn254) | `0x16c2a7a796b3c4a4e83844be4242070f9706261c9e7e4fcc9e08d13ea7a0e92` | A verifier for RiscZero Groth16-wrapped proofs.                                                               |
| [Drand Quicknet Verifier](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/drand_quicknet) | `0x50356fea2d979b202c78623c6073deeea1a8e1c87f9f252ebf1b264e060533b` | A contract to verify Drand signatures. Soon with timelock encryption utilities.                               |
