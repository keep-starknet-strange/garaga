---
icon: dice
---

# Drand

Garaga provides maintained contracts for the [drand](https://drand.love) distributed randomness beacon. These enable:

- **On-chain signature verification** of drand rounds for verifiable randomness
- **Time-lock encryption (tlock)**: encrypt data that can only be decrypted after a specific drand round is published

## What is drand?

drand is a distributed randomness beacon that provides:

- **Unpredictable randomness**: Values cannot be known before generation
- **Unbiasable output**: No single party can influence results
- **Public verifiability**: Anyone can verify the randomness is legitimate
- **Regular intervals**: New randomness every 3 seconds (quicknet)

## What is tlock?

Time-lock encryption (tlock) leverages drand's BLS threshold signatures to create an identity-based encryption (IBE) scheme where the "identity" is a future drand round number. A message encrypted for round `N` can only be decrypted once drand publishes the signature for round `N`. No single party can decrypt early.

### Use Cases

| Application | How tlock helps |
|---|---|
| **Sealed-bid auctions** | Bids encrypted until auction close (a specific drand round) |
| **Scheduled reveals** | Information released at a predetermined time |
| **Fair launches** | Token distributions with time-locked claiming |
| **Commit-reveal schemes** | Players commit encrypted moves, revealed together after a round |

## Contracts

### Drand Quicknet Verifier

Verifies drand BLS signatures and stores them on-chain.

| Network | Class Hash |
|---------|------------|
| **Mainnet** | `0x86bf4360e082cd786bd785d3345df32777db89cd26b761f3e85b1993addfd0` |
| **Sepolia** | `0x86bf4360e082cd786bd785d3345df32777db89cd26b761f3e85b1993addfd0` |

```cairo
#[starknet::interface]
trait IDrandQuicknet<TContractState> {
    /// Verify a drand round BLS signature and store it on-chain.
    fn verify_round(
        ref self: TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Result<u64, felt252>;

    /// Look up the stored signature for a previously verified round.
    fn get_signature_for_round(
        self: @TContractState, round_number: u64,
    ) -> Result<G1Point, felt252>;

    /// Look up the randomness (poseidon_hash(signature)) for a previously verified round.
    fn get_randomness_for_round(
        self: @TContractState, round_number: u64,
    ) -> Result<felt252, felt252>;
}
```

### Drand Decrypt Quicknet

Wraps the verifier to add on-chain tlock decryption. Deploy this contract yourself and point it at the verifier class hash.

```cairo
#[starknet::interface]
trait IDrandDecryptQuicknet<TContractState> {
    /// Verify a drand round BLS signature via library_call to the verifier class.
    fn verify_round(
        ref self: TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Result<u64, felt252>;

    /// Read the stored signature for a previously verified round.
    fn get_signature_for_round(
        self: @TContractState, round_number: u64,
    ) -> Result<G1Point, felt252>;

    /// Get poseidon_hash(signature) for a previously verified round.
    fn get_randomness_for_round(
        self: @TContractState, round_number: u64,
    ) -> Result<felt252, felt252>;

    /// Decrypt a tlock ciphertext for a given round.
    /// If the round signature is not yet stored, a DrandHint must follow in the calldata.
    fn decrypt_cipher_text(
        ref self: TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Result<Span<u8>, felt252>;
}
```

{% hint style="info" %}
The verifier contract is designed for **library calls** and does not need to be deployed. The decrypt contract wraps it and **must be deployed** since it stores signatures in its own storage.
{% endhint %}

## Quicknet Configuration

Both contracts are configured for drand's **quicknet** network:

| Parameter | Value |
|-----------|-------|
| **Chain Hash** | `52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971` |
| **Public Key** | G2 point on BLS12-381 (hardcoded in contract) |
| **Period** | 3 seconds |
| **Genesis** | 1692803367 (Aug 23, 2023) |

---

## Verifiable Randomness

### Fetching drand Randomness

First, fetch randomness from drand's HTTP API:

```bash
# Get the latest round
curl https://api.drand.sh/52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971/public/latest

# Get a specific round
curl https://api.drand.sh/52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971/public/12345
```

Response:
```json
{
  "round": 12345,
  "randomness": "8b9c...",
  "signature": "a1b2..."
}
```

### Generating Verification Calldata

Use the Garaga SDK to generate the `full_proof_with_hints` calldata from the drand response:

{% tabs %}
{% tab title="Python" %}
```python
from garaga.starknet.tests_and_calldata_generators.drand_calldata import (
    drand_round_to_calldata,
)

# Generate calldata for a specific round (fetches from drand API automatically)
calldata = drand_round_to_calldata(round_number=12345)
# Returns list[int] ready for on-chain verification

# Use the Rust backend for better performance
calldata = drand_round_to_calldata(round_number=12345, use_rust=True)
```
{% endtab %}

{% tab title="TypeScript" %}
```typescript
import * as garaga from 'garaga';

await garaga.init();

// Fetch drand randomness and build calldata
const drandData = await garaga.fetchDrandRandomness(12345);
const calldata = garaga.getDrandCallData(drandData);
```
{% endtab %}
{% endtabs %}

### On-Chain Verification with Library Call

Use `library_call_syscall` to call the drand verifier contract:

```cairo
use starknet::{SyscallResultTrait, syscalls};
use garaga::definitions::G1Point;

const DRAND_QUICKNET_CLASS_HASH: felt252 =
    0x86bf4360e082cd786bd785d3345df32777db89cd26b761f3e85b1993addfd0;

fn verify_drand_round(full_proof_with_hints: Span<felt252>) -> u64 {
    let mut call_data: Array<felt252> = array![];
    Serde::serialize(@full_proof_with_hints, ref call_data);

    let mut result = syscalls::library_call_syscall(
        DRAND_QUICKNET_CLASS_HASH.try_into().unwrap(),
        selector!("verify_round"),
        call_data.span(),
    ).unwrap_syscall();

    let round: Result<u64, felt252> = Serde::deserialize(ref result).unwrap();
    round.unwrap()
}
```

---

## Time-Lock Encryption (tlock)

### How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│                        ENCRYPTION (off-chain)                    │
│                                                                  │
│   1. Choose a future drand round number N                        │
│   2. Encrypt 16-byte message using drand's public key + round N  │
│   3. Produces CipherText { U: G2Point, V: [u8;16], W: [u8;16] } │
│   4. Store ciphertext on-chain or off-chain                      │
│                                                                  │
└──────────────────────────────┬──────────────────────────────────┘
                               │
                          time passes...
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│              drand publishes round N signature                   │
└──────────────────────────────┬──────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                       DECRYPTION (on-chain)                      │
│                                                                  │
│   1. Verify the drand signature for round N (BLS pairing check)  │
│   2. Use signature to decrypt: e(signature, U) recovers key      │
│   3. XOR-decrypt to recover the original 16-byte message         │
│   4. Verify ciphertext integrity (U = r·G₂ check)               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

{% hint style="info" %}
**Message size**: tlock encrypts a 16-byte (128-bit) message. For larger payloads, encrypt a symmetric key with tlock and use it to encrypt the larger data off-chain.
{% endhint %}

### Encrypting a Message (Off-Chain)

Use the Garaga SDK to encrypt a message for a future drand round:

{% tabs %}
{% tab title="Python" %}
```python
from garaga.starknet.tests_and_calldata_generators.drand_calldata import (
    drand_encrypt_to_calldata,
)

# Encrypt a 16-byte message for a future round
message = b"secret message!!"  # exactly 16 bytes
round_number = 100000  # a future drand round

# Generate calldata containing the encrypted ciphertext
calldata = drand_encrypt_to_calldata(round_number, message)

# Use the Rust backend for better performance
calldata = drand_encrypt_to_calldata(round_number, message, use_rust=True)
```
{% endtab %}

{% tab title="TypeScript" %}
```typescript
import * as garaga from 'garaga';

await garaga.init();

// Prepare 16-byte message and randomness
const message = new Uint8Array(16);
message.set(new TextEncoder().encode('secret message!!'));

const randomness = crypto.getRandomValues(new Uint8Array(16));

// Encrypt for a specific future round
const calldata = garaga.encryptToDrandRoundAndGetCallData(
  100000,     // round number
  message,    // 16-byte message
  randomness, // 16-byte randomness
);
```
{% endtab %}

{% tab title="Rust" %}
```rust
use garaga_rs::calldata::drand_tlock_calldata::drand_tlock_encrypt_calldata_builder;
use num_bigint::BigUint;

let round_number = 100000u64;
let message: [u8; 16] = *b"secret message!!";
let randomness: [u8; 16] = rand::random();

let values = vec![
    BigUint::from(round_number),
    BigUint::from_bytes_be(&message),
    BigUint::from_bytes_be(&randomness),
];

let calldata = drand_tlock_encrypt_calldata_builder(&values).unwrap();
```
{% endtab %}
{% endtabs %}

### Decrypting On-Chain

The `decrypt_cipher_text` function on the decrypt contract handles two scenarios:

1. **Round already verified**: If the drand signature for the round is already stored, only the ciphertext calldata is needed.
2. **Round not yet verified**: The ciphertext calldata is followed by the drand verification hint, and both verification and decryption happen in a single transaction.

#### Scenario 1: Verify first, then decrypt

```python
from garaga.starknet.tests_and_calldata_generators.drand_calldata import (
    drand_round_to_calldata,
    drand_encrypt_to_calldata,
)

# Step 1: Verify the round (stores the signature)
verify_calldata = drand_round_to_calldata(round_number=12345)
# Call contract.verify_round(verify_calldata)

# Step 2: Decrypt (uses stored signature)
decrypt_calldata = drand_encrypt_to_calldata(12345, message)
# Call contract.decrypt_cipher_text(decrypt_calldata)
```

#### Scenario 2: Verify and decrypt in one transaction

```python
# Combine encryption calldata + verification calldata
encrypt_cd = drand_encrypt_to_calldata(round_number, message)
verify_cd = drand_round_to_calldata(round_number)

# Strip the length prefix from each, combine, and add new length prefix.
# This works because decrypt_cipher_text deserializes the DrandDecryptHint
# (round + ciphertext) first, then passes the remaining bytes to verify_round.
combined_data = encrypt_cd[1:] + verify_cd[1:]
combined_calldata = [len(combined_data)] + combined_data
# Call contract.decrypt_cipher_text(combined_calldata)
```

### Cairo: CipherText Struct

The tlock ciphertext is defined in `garaga::apps::drand`:

```cairo
use garaga::apps::drand::CipherText;
use garaga::definitions::G2Point;

/// The result of a timelock encryption over drand quicknet.
struct CipherText {
    U: G2Point,   // r·G₂ — the ephemeral public key
    V: [u8; 16],  // sigma XOR H₂(r·e(H(round), pk))
    W: [u8; 16],  // message XOR H₄(sigma)
}
```

### Cairo: Direct Decryption in Your Contract

If you want to call the `decrypt_at_round` function directly from the garaga library:

```cairo
use garaga::apps::drand::{CipherText, decrypt_at_round};
use garaga::definitions::G1Point;

fn my_decrypt(signature: G1Point, ciphertext: CipherText) -> [u8; 16] {
    // Performs: miller loop, final exponentiation, XOR decryption, and U = r·G₂ check
    decrypt_at_round(signature, ciphertext)
}
```

{% hint style="warning" %}
`decrypt_at_round` verifies ciphertext integrity (`U = r·G₂`) but does **not** verify that the provided signature is a valid drand BLS signature. You must verify the signature separately via `verify_round` or perform your own pairing check before calling this function.
{% endhint %}

---

## Example: On-Chain Lottery

```cairo
#[starknet::contract]
mod Lottery {
    use starknet::ContractAddress;
    use starknet::storage::{
        Map, StorageMapReadAccess, StorageMapWriteAccess,
        StoragePointerReadAccess, StoragePointerWriteAccess,
    };
    use starknet::{SyscallResultTrait, syscalls};

    const DRAND_QUICKNET_CLASS_HASH: felt252 =
        0x86bf4360e082cd786bd785d3345df32777db89cd26b761f3e85b1993addfd0;

    #[storage]
    struct Storage {
        participants: Map<u32, ContractAddress>,
        participant_count: u32,
        target_round: u64,
        is_open: bool,
    }

    #[external(v0)]
    fn enter_lottery(ref self: ContractState) {
        assert!(self.is_open.read(), "Lottery closed");
        let count = self.participant_count.read();
        self.participants.write(count, starknet::get_caller_address());
        self.participant_count.write(count + 1);
    }

    #[external(v0)]
    fn draw_winner(
        ref self: ContractState,
        full_proof_with_hints: Span<felt252>,
    ) -> ContractAddress {
        let mut call_data: Array<felt252> = array![];
        Serde::serialize(@full_proof_with_hints, ref call_data);

        let mut result = syscalls::library_call_syscall(
            DRAND_QUICKNET_CLASS_HASH.try_into().unwrap(),
            selector!("verify_round"),
            call_data.span(),
        ).unwrap_syscall();

        let round_result: Result<u64, felt252> = Serde::deserialize(ref result).unwrap();
        let verified_round = round_result.unwrap();

        assert!(verified_round == self.target_round.read(), "Wrong round");

        let count: u256 = self.participant_count.read().into();
        // Retrieve randomness from the verified round
        let mut rand_call_data: Array<felt252> = array![];
        Serde::serialize(@verified_round, ref rand_call_data);

        let mut rand_result = syscalls::library_call_syscall(
            DRAND_QUICKNET_CLASS_HASH.try_into().unwrap(),
            selector!("get_randomness_for_round"),
            rand_call_data.span(),
        ).unwrap_syscall();

        let randomness: Result<felt252, felt252> = Serde::deserialize(ref rand_result).unwrap();
        let winner_index: u32 = (randomness.unwrap().into() % count).try_into().unwrap();

        self.participants.read(winner_index)
    }
}
```

## Example: Sealed-Bid Auction with tlock

A sketch of how tlock enables sealed-bid auctions. Bids are encrypted for a future reveal round. Once drand publishes that round, bids can be decrypted on-chain.

```
1. Auction opens — bidders encrypt their bids for reveal_round using tlock
2. Bidders submit a hash of their ciphertext on-chain (commitment)
3. Auction closes — no more bids accepted
4. drand publishes reveal_round signature
5. Anyone calls decrypt_cipher_text to reveal each bid on-chain
6. Contract determines the winner from the decrypted bids
```

The ciphertext itself (a `G2Point` + 32 bytes) can be stored off-chain (e.g., IPFS) with only a commitment hash on-chain, or submitted directly in the decryption transaction.

## Helper Functions

The `garaga::apps::drand` module provides utilities for working with drand rounds:

```cairo
use garaga::apps::drand::{timestamp_to_round, round_to_timestamp};

// Convert a Unix timestamp to a drand round number
let round = timestamp_to_round(1692803370);  // returns 2

// Convert a drand round number to a Unix timestamp
let timestamp = round_to_timestamp(2);  // returns 1692803370
```

## Security Considerations

- **Round timing**: Ensure you're using the correct round for your application's timing requirements. Use `timestamp_to_round` to map wall-clock time to drand rounds.
- **Message size**: tlock encrypts exactly 16 bytes. Use it to encrypt a symmetric key for larger payloads.
- **Ciphertext integrity**: The `decrypt_at_round` function verifies `U = r·G₂` to ensure the ciphertext was formed correctly. Tampered ciphertexts will be rejected.
- **Finality**: Once a drand round is published, the signature is permanent. The ciphertext becomes decryptable by anyone with the round signature.
- **Fallback**: Consider implementing fallback mechanisms if drand becomes unavailable.

## Resources

- [drand Website](https://drand.love)
- [drand API Documentation](https://drand.love/developer/http-api/)
- [Quicknet Information](https://drand.love/blog/2023/07/03/quicknet-is-live/)
- [tlock Paper](https://eprint.iacr.org/2023/189) — "tlock: Practical Timelock Encryption from Threshold BLS"
- [Verifier Source Code](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/drand_quicknet)
- [Decrypt Contract Source Code](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/drand_decrypt_quicknet)
