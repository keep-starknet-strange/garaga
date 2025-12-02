---
icon: dice
---

# Drand

Garaga provides a maintained contract for verifying signatures from the [drand](https://drand.love) distributed randomness beacon. This enables on-chain verification of publicly verifiable randomness.

## What is drand?

drand is a distributed randomness beacon that provides:

- **Unpredictable randomness**: Values cannot be known before generation
- **Unbiasable output**: No single party can influence results
- **Public verifiability**: Anyone can verify the randomness is legitimate
- **Regular intervals**: New randomness every 3 seconds (quicknet)

## Contract Information

| Network | Class Hash |
|---------|------------|
| **Mainnet** | `0x59d24936725776758dc34d74b254d15f74b26683018470b6357d23dcab6b4bd` |
| **Sepolia** | `0x59d24936725776758dc34d74b254d15f74b26683018470b6357d23dcab6b4bd` |

{% hint style="info" %}
This contract is designed for **library calls**. Use it via `library_call_syscall` rather than deploying your own instance.
{% endhint %}

## Contract Interface

The drand verifier exposes a single function:

```cairo
#[starknet::interface]
trait IDrandQuicknet<TContractState> {
    fn verify_round_and_get_randomness(
        self: @TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<DrandResult>;
}

struct DrandResult {
    round_number: u64,
    randomness: felt252,
}
```

## Quicknet Configuration

The maintained contract is configured for drand's **quicknet** network:

| Parameter | Value |
|-----------|-------|
| **Chain Hash** | `52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971` |
| **Public Key** | G2 point on BLS12-381 (hardcoded in contract) |
| **Period** | 3 seconds |
| **Genesis** | 1692803367 (Aug 23, 2023) |

## Usage

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

### Generating Calldata

Use the Garaga SDK to generate the `full_proof_with_hints` calldata from the drand response:

{% tabs %}
{% tab title="Python" %}
```python
from garaga.starknet.tests_and_calldata_generators.drand import DrandCalldata

# From drand API response
calldata = DrandCalldata.from_round(round_number=12345)
# Returns list[int] ready for on-chain verification
```
{% endtab %}
{% endtabs %}

### On-Chain Verification with Library Call

Use `library_call_syscall` to call the drand verifier contract:

```cairo
use starknet::{SyscallResultTrait, syscalls};
use garaga::apps::drand::DrandResult;

const DRAND_QUICKNET_CLASS_HASH: felt252 =
    0x59d24936725776758dc34d74b254d15f74b26683018470b6357d23dcab6b4bd;

fn verify_drand_randomness(full_proof_with_hints: Span<felt252>) -> Option<DrandResult> {
    // Serialize the calldata
    let mut call_data: Array<felt252> = array![];
    Serde::serialize(@full_proof_with_hints, ref call_data);

    // Call the drand verifier via library call
    let mut result = syscalls::library_call_syscall(
        DRAND_QUICKNET_CLASS_HASH.try_into().unwrap(),
        selector!("verify_round_and_get_randomness"),
        call_data.span(),
    ).unwrap_syscall();

    // Deserialize the result
    Serde::<Option<DrandResult>>::deserialize(ref result).unwrap()
}
```

## Example: On-Chain Lottery

```cairo
#[starknet::contract]
mod Lottery {
    use starknet::ContractAddress;
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess, StoragePointerReadAccess, StoragePointerWriteAccess};
    use starknet::{SyscallResultTrait, syscalls};
    use garaga::apps::drand::DrandResult;

    const DRAND_QUICKNET_CLASS_HASH: felt252 =
        0x59d24936725776758dc34d74b254d15f74b26683018470b6357d23dcab6b4bd;

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
        // Serialize calldata for library call
        let mut call_data: Array<felt252> = array![];
        Serde::serialize(@full_proof_with_hints, ref call_data);

        // Verify the drand signature via library call
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

## Security Considerations

- **Round timing**: Ensure you're using the correct round for your application's timing requirements
- **Finality**: Wait for sufficient confirmations before considering randomness final
- **Fallback**: Consider implementing fallback mechanisms if drand becomes unavailable

## Resources

- [drand Website](https://drand.love)
- [drand API Documentation](https://drand.love/developer/http-api/)
- [Quicknet Information](https://drand.love/blog/2023/07/03/quicknet-is-live/)
- [Source Code](https://github.com/keep-starknet-strange/garaga/tree/main/src/contracts/drand_quicknet)
