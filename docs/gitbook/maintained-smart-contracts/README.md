---
icon: file-lock
---

# Maintained Smart Contracts

We declare & maintain Smart Contracts for the community.

\
Those contracts:

* Are _declared_ both Starknet Sepolia and Mainnet.
* Those contracts are re-deployed at each release, so their code correspond to the release commit.
* The source code is always available in the main garaga repository under `src/contracts`
* The contracts are only declared and not deployed, their expected usage is through [library syscalls.](https://book.cairo-lang.org/ch15-03-executing-code-from-another-class.html#library-calls), their usage is done through their class hashes.  \
  \
  &#x20;



| Contract                                                                                                            | Class hash                                                          | Description                                                                                                   |
| ------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| [Universal ECIP](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/universal\_ecip)           | `0x70c1d1c709c75e3cf51d79d19cf7c84a0d4521f3a2b8bf7bff5cb45ee0dd289` | A contract allowing to compute elliptic curve multi scalar multiplication for all supported curve identifiers |
| [RiscZero Verifier](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/risc0\_verifier\_bn254) | `0x189d559773d197f7a4d0af561294e5d224455acddb541aa83f4262c8a25d56c` | A verifier for RiscZero Groth16-wrapped proofs.                                                               |
| [Drand Quicknet Verifier](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/drand\_quicknet)  | `0x5dc6c40dc3937670c0f644424d10ce90270193f3385bf6f4360f52402647c1b` | A contract to verify Drand signatures and use timelock encryption utilities (soon).                           |
