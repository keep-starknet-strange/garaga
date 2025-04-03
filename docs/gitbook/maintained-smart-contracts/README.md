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
  \


### Class hash for Garaga v0.15.4.

| Contract                                                                                                          | Class hash                                                          | Description                                                                                                   |
| ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| [Universal ECIP](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/universal_ecip)          | `0x338be2ec2d0672c64fb851dbefbce890c9e29382f4fa9535eabef98d6dada7a` | A contract allowing to compute elliptic curve multi scalar multiplication for all supported curve identifiers |
| [RiscZero Verifier](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/risc0_verifier_bn254) | `0x23f1262b7a1fbe799da9a947d27f6da465635832d2cc34a5dca2723b26d598a` | A verifier for RiscZero Groth16-wrapped proofs.                                                               |
| [Drand Quicknet Verifier](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/drand_quicknet) | 0x5828fe85f790c7972ff53e901fccc4136c771595ab46c5ccde887a9987cbf56   | A contract to verify Drand signatures. Soon with timelock encryption utilities.                               |
