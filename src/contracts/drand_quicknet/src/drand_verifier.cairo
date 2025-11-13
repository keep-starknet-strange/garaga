use garaga::apps::drand::DrandResult;
use super::drand_verifier_constants::{G2_GEN, precomputed_lines};


#[starknet::interface]
trait IDrandQuicknet<TContractState> {
    fn verify_round_and_get_randomness(
        self: @TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<DrandResult>;
}

#[starknet::contract]
mod DrandQuicknet {
    // use starknet::SyscallResultTrait;
    use garaga::apps::drand::{
        CipherText, DRAND_QUICKNET_GENESIS_TIME, DRAND_QUICKNET_PERIOD, DRAND_QUICKNET_PUBLIC_KEY,
        DrandResult, HashToCurveHint, round_to_curve_bls12_381,
    };
    use garaga::definitions::{G1G2Pair, G1Point};
    use garaga::pairing_check::{MPCheckHintBLS12_381, multi_pairing_check_bls12_381_2P_2F};
    use garaga::utils::calldata::deserialize_mpcheck_hint_bls12_381;
    use garaga::utils::hashing::hash_G1Point;
    use starknet::storage::Map;
    use super::{G2_GEN, precomputed_lines};
    // use starknet::ContractAddress;

    #[storage]
    struct Storage {
        randomness: Map<u64, felt252>,
    }

    #[derive(Drop)]
    struct DrandHint {
        round_number: u64,
        signature: G1Point,
        hash_to_curve_hint: HashToCurveHint,
        mpcheck_hint: MPCheckHintBLS12_381,
    }

    impl DrandHintSerde of Serde<DrandHint> {
        fn serialize(self: @DrandHint, ref output: Array<felt252>) {}

        fn deserialize(ref serialized: Span<felt252>) -> Option<DrandHint> {
            let round_number = Serde::<u64>::deserialize(ref serialized).unwrap();
            let signature = Serde::<G1Point>::deserialize(ref serialized).unwrap();
            let hash_to_curve_hint = Serde::<HashToCurveHint>::deserialize(ref serialized).unwrap();
            let mpcheck_hint = deserialize_mpcheck_hint_bls12_381(ref serialized);
            return Option::Some(
                DrandHint {
                    round_number: round_number,
                    signature: signature,
                    hash_to_curve_hint: hash_to_curve_hint,
                    mpcheck_hint: mpcheck_hint,
                },
            );
        }
    }
    #[abi(embed_v0)]
    impl IDrandQuicknet of super::IDrandQuicknet<ContractState> {
        // Returns the round number and the randomness if the proof for a given round is valid.
        fn verify_round_and_get_randomness(
            self: @ContractState, mut full_proof_with_hints: Span<felt252>,
        ) -> Option<DrandResult> {
            let drand_hint: DrandHint = Serde::deserialize(ref full_proof_with_hints).unwrap();
            let message = round_to_curve_bls12_381(
                drand_hint.round_number, drand_hint.hash_to_curve_hint,
            );

            let check = multi_pairing_check_bls12_381_2P_2F(
                pair0: G1G2Pair { p: drand_hint.signature, q: G2_GEN },
                pair1: G1G2Pair { p: message, q: DRAND_QUICKNET_PUBLIC_KEY },
                lines: precomputed_lines.span(),
                hint: drand_hint.mpcheck_hint,
            );

            match check {
                Result::Ok(_) => Option::Some(
                    DrandResult {
                        round_number: drand_hint.round_number,
                        randomness: hash_G1Point(drand_hint.signature),
                    },
                ),
                Result::Err(error) => Option::None,
            }
        }
    }
}

