use super::drand_verifier_constants::{G2_GEN, precomputed_lines};

#[starknet::interface]
pub trait IDrandQuicknet<TContractState> {
    /// Verify a drand round BLS signature and store it on-chain.
    /// Returns the round number on success.
    fn verify_round(
        ref self: TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Result<u64, felt252>;

    /// Look up the stored signature for a previously verified round.
    fn get_signature_for_round(
        self: @TContractState, round_number: u64,
    ) -> Result<G1Point, felt252>;

    /// Look up the randomness for a previously verified round.
    /// Randomness = poseidon_hash(signature).
    fn get_randomness_for_round(
        self: @TContractState, round_number: u64,
    ) -> Result<felt252, felt252>;
}
use garaga::definitions::G1Point;

#[starknet::contract]
mod DrandQuicknet {
    use garaga::apps::drand::{DRAND_QUICKNET_PUBLIC_KEY, HashToCurveHint, round_to_curve_bls12_381};
    use garaga::definitions::{G1G2Pair, G1Point, G1PointStorePacking, G1PointZero};
    use garaga::pairing_check::{MPCheckHintBLS12_381, multi_pairing_check_bls12_381_2P_2F};
    use garaga::utils::calldata::deserialize_mpcheck_hint_bls12_381;
    use garaga::utils::hashing::hash_G1Point;
    use starknet::storage::{
        Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess,
    };
    use super::{G2_GEN, precomputed_lines};

    #[storage]
    struct Storage {
        signatures: Map<u64, G1Point>,
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
            let round_number = Serde::<u64>::deserialize(ref serialized)?;
            let signature = Serde::<G1Point>::deserialize(ref serialized)?;
            let hash_to_curve_hint = Serde::<HashToCurveHint>::deserialize(ref serialized)?;
            let mpcheck_hint = deserialize_mpcheck_hint_bls12_381(ref serialized);
            Option::Some(DrandHint { round_number, signature, hash_to_curve_hint, mpcheck_hint })
        }
    }

    #[abi(embed_v0)]
    impl IDrandQuicknet of super::IDrandQuicknet<ContractState> {
        fn verify_round(
            ref self: ContractState, mut full_proof_with_hints: Span<felt252>,
        ) -> Result<u64, felt252> {
            let hint = Serde::<DrandHint>::deserialize(ref full_proof_with_hints)
                .ok_or('Bad calldata: DrandHint')?;

            let round_number = hint.round_number;
            let message = round_to_curve_bls12_381(hint.round_number, hint.hash_to_curve_hint);

            multi_pairing_check_bls12_381_2P_2F(
                pair0: G1G2Pair { p: hint.signature, q: G2_GEN },
                pair1: G1G2Pair { p: message, q: DRAND_QUICKNET_PUBLIC_KEY },
                lines: precomputed_lines.span(),
                hint: hint.mpcheck_hint,
            )
                .map_err(|_e| 'BLS signature invalid')?;

            self.signatures.entry(round_number).write(hint.signature);
            Result::Ok(round_number)
        }

        fn get_signature_for_round(
            self: @ContractState, round_number: u64,
        ) -> Result<G1Point, felt252> {
            let signature = self.signatures.entry(round_number).read();
            if signature.is_zero() {
                Result::Err('Round not verified yet')
            } else {
                Result::Ok(signature)
            }
        }

        fn get_randomness_for_round(
            self: @ContractState, round_number: u64,
        ) -> Result<felt252, felt252> {
            let signature = self.signatures.entry(round_number).read();
            if signature.is_zero() {
                Result::Err('Round not verified yet')
            } else {
                Result::Ok(hash_G1Point(signature))
            }
        }
    }
}
