---
icon: rocket
---

# Building Powerful Applications

Garaga's cryptographic primitives enable a wide range of powerful applications on Starknet. This page showcases what you can build and links to production-ready implementations.

***

## Validity Rollups & L2 Solutions

Verify SNARK proofs on Starknet to build trustless bridges and rollup solutions.

### How It Works

1. **Off-chain**: Execute computation and generate a ZK proof (Groth16 or Honk)
2. **On-chain**: Verify the proof using Garaga's optimized verifier contracts
3. **Result**: Trustless verification of arbitrary computation

### Example: Cross-Chain Bridge

```rust
use garaga::groth16::{Groth16Proof, verify_groth16_proof};

#[starknet::contract]
mod Bridge {
    #[storage]
    struct Storage {
        processed_proofs: LegacyMap<felt252, bool>,
    }

    #[external(v0)]
    fn process_deposit(
        ref self: ContractState,
        proof_with_hints: Span<felt252>,
        deposit_hash: felt252,
    ) -> Result<(), felt252> {
        // Verify the proof that a deposit occurred on the source chain
        let public_inputs = verify_groth16_proof(proof_with_hints)?;

        // Check the deposit hash matches
        assert(*public_inputs.at(0) == deposit_hash, 'Invalid deposit');

        // Process the deposit...
        Result::Ok(())
    }
}
```

{% hint style="info" %}
**Real-world usage**: Teams use Garaga to verify proofs from RISC Zero and SP1 zkVMs, enabling trustless verification of arbitrary Rust programs on Starknet.
{% endhint %}

***

## Privacy-Preserving Applications

Build applications where users can prove statements without revealing underlying data.

### Use Cases

| Application                | What's Proven             | What's Hidden      |
| -------------------------- | ------------------------- | ------------------ |
| **Private Voting**         | Vote is valid and counted | Who voted for whom |
| **Anonymous Credentials**  | User meets criteria       | User's identity    |
| **Confidential Transfers** | Balance is sufficient     | Transfer amount    |
| **Private Auctions**       | Bid is valid              | Bid amount         |

### Implementation with Noir

Noir makes it easy to write privacy-preserving circuits:

```rust
// circuit.nr - Private voting circuit
fn main(
    // Private inputs (not revealed on-chain)
    private_key: Field,
    vote_choice: Field,

    // Public inputs (verified on-chain)
    public_key_hash: pub Field,
    merkle_root: pub Field,
    nullifier: pub Field,
) {
    // Prove ownership of private key
    let computed_hash = std::hash::pedersen([private_key]);
    assert(computed_hash == public_key_hash);

    // Prove membership in voter set (merkle proof)
    // ... merkle verification ...

    // Generate unique nullifier to prevent double voting
    let computed_nullifier = std::hash::pedersen([private_key, vote_choice]);
    assert(computed_nullifier == nullifier);
}
```

Then verify on Starknet with a single function call.

***

## Verifiable Randomness (drand)

Generate provably fair random numbers using the [drand](https://drand.love) distributed randomness beacon.

### Why drand?

* **Unpredictable**: Random values can't be known before they're generated
* **Unbiasable**: No single party can influence the output
* **Publicly verifiable**: Anyone can verify the randomness is legitimate

### Example: On-Chain Lottery

Use the maintained drand verifier contract via library call:

```rust
use starknet::{SyscallResultTrait, syscalls};
use garaga::apps::drand::DrandResult;

const DRAND_QUICKNET_CLASS_HASH: felt252 =
    0x59d24936725776758dc34d74b254d15f74b26683018470b6357d23dcab6b4bd;

#[starknet::contract]
mod Lottery {
    use starknet::storage::{Map, StorageMapReadAccess, StoragePointerReadAccess};
    use super::{DRAND_QUICKNET_CLASS_HASH, DrandResult, SyscallResultTrait, syscalls};

    #[storage]
    struct Storage {
        participants: Map<u32, ContractAddress>,
        participant_count: u32,
        target_round: u64,
    }

    #[external(v0)]
    fn draw_winner(
        ref self: ContractState,
        full_proof_with_hints: Span<felt252>,
    ) -> ContractAddress {
        // Serialize calldata for library call
        let mut call_data: Array<felt252> = array![];
        Serde::serialize(@full_proof_with_hints, ref call_data);

        // Verify drand signature via library call to maintained contract
        let mut result = syscalls::library_call_syscall(
            DRAND_QUICKNET_CLASS_HASH.try_into().unwrap(),
            selector!("verify_round_and_get_randomness"),
            call_data.span(),
        ).unwrap_syscall();

        let drand_result: Option<DrandResult> = Serde::deserialize(ref result).unwrap();
        let verified = drand_result.expect('Invalid drand proof');

        // Ensure we're using the correct round
        assert!(verified.round_number == self.target_round.read(), "Wrong round");

        // Use randomness to select winner
        let count: u256 = self.participant_count.read().into();
        let winner_index: u32 = (verified.randomness.into() % count).try_into().unwrap();
        self.participants.read(winner_index)
    }
}
```

{% hint style="success" %}
**Production contract available**: Use the [maintained drand verifier](maintained-smart-contracts/drand.md) via library call - no deployment needed!
{% endhint %}

***

## Signature Verification at Scale

Verify signatures from external systems (Bitcoin, Ethereum, Solana) on Starknet.

### Supported Signature Schemes

| Scheme      | Curves                                 | Use Case                      |
| ----------- | -------------------------------------- | ----------------------------- |
| **ECDSA**   | SECP256K1, SECP256R1, BN254, BLS12-381 | Bitcoin, Ethereum, WebAuthn   |
| **Schnorr** | All Weierstrass curves                 | BIP340 (Taproot), general use |
| **EdDSA**   | Ed25519                                | Solana, general use           |

### Example: Multi-Chain Message Verification

```rust
use garaga::signatures::ecdsa::{ECDSASignatureWithHint, is_valid_ecdsa_signature_assuming_hash};
use garaga::definitions::G1Point;

fn verify_ethereum_message(
    signature_with_hints: ECDSASignatureWithHint,
    public_key: G1Point,
    message_hash: u256,
) -> bool {
    // curve_id 2 = SECP256K1 (Ethereum's curve)
    is_valid_ecdsa_signature_assuming_hash(signature_with_hints, public_key, 2)
}

fn verify_webauthn_signature(
    signature_with_hints: ECDSASignatureWithHint,
    public_key: G1Point,
    message_hash: u256,
) -> bool {
    // curve_id 3 = SECP256R1 (WebAuthn/Passkeys)
    is_valid_ecdsa_signature_assuming_hash(signature_with_hints, public_key, 3)
}
```

***

## zkVM Proof Verification

Verify proofs from zkVMs like RISC Zero and SP1 to enable trustless execution of arbitrary programs.

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Off-Chain (zkVM)                         │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Your Rust Program                                   │   │
│  │  - Complex business logic                            │   │
│  │  - State transitions                                 │   │
│  │  - Any computation you can write in Rust             │   │
│  └─────────────────────────────────────────────────────┘   │
│                          ↓                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  zkVM (RISC Zero / SP1)                              │   │
│  │  - Executes program                                  │   │
│  │  - Generates Groth16 proof                           │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                          ↓ proof
┌─────────────────────────────────────────────────────────────┐
│                    On-Chain (Starknet)                      │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Garaga Verifier Contract                            │   │
│  │  - Verifies Groth16 proof                            │   │
│  │  - Returns public outputs                            │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Getting Started

See the maintained contracts:

* [RISC Zero Integration](maintained-smart-contracts/risczero.md)
* [SP1 Integration](maintained-smart-contracts/sp1.md)

***

## Time-Lock Encryption (Coming Soon)

{% hint style="warning" %}
**Under Development**: Time-lock encryption utilities are being added to the drand module.
{% endhint %}

Time-lock encryption allows you to encrypt data that can only be decrypted at a specific future time, using drand's distributed randomness.

### Use Cases

* **Sealed-bid auctions**: Bids are encrypted until the auction ends
* **Scheduled reveals**: Information released at a predetermined time
* **Fair launches**: Token distributions with time-locked claiming

***

## Build Your Own

The primitives above can be combined to create novel applications:

| Combination          | Application                                  |
| -------------------- | -------------------------------------------- |
| Groth16 + Signatures | Cross-chain asset bridges                    |
| Noir + drand         | Private lotteries with verifiable randomness |
| zkVM + MSM           | Verifiable ML inference                      |
| EdDSA + Groth16      | Solana → Starknet bridges                    |

**Need help?** Join our [Telegram community](https://t.me/GaragaPairingCairo) to discuss your use case.
