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

### Class hash for Garaga v0.15.3.

| Contract                                                                                                          | Class hash                                                           | Description                                                                                                   |
| ----------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| [Universal ECIP](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/universal_ecip)          | `0x684d2756a4440c190a5fe54e367c0abe33aefa75084dec2fffc791b620c80e3`  | A contract allowing to compute elliptic curve multi scalar multiplication for all supported curve identifiers |
| [RiscZero Verifier](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/risc0_verifier_bn254) | `0x7f3157e83dc0d636c462c77fd8f309351b4a2c710f9a23a443 05830a29b0b27` | A verifier for RiscZero Groth16-wrapped proofs.                                                               |
| [Drand Quicknet Verifier](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/drand_quicknet) | `0x42462549f0c848750e734d6bc10a040f967ee517c0b316bfd9656ab65a2eef8`  | A contract to verify Drand signatures. Soon with timelock encryption utilities.                               |



