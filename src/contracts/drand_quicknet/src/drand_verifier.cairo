use garaga::definitions::G1Point;
use garaga::utils::drand::DrandResult;
use super::drand_verifier_constants::{G2_GEN, precomputed_lines};


#[starknet::interface]
trait IDrandQuicknet<TContractState> {
    fn verify_round_and_get_randomness(
        self: @TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<DrandResult>;
}

#[starknet::contract]
mod DrandQuicknet {
    use garaga::definitions::{G1G2Pair, G1Point};
    use garaga::pairing_check::{MPCheckHintBLS12_381, multi_pairing_check_bls12_381_2P_2F};
    use garaga::utils::calldata::deserialize_mpcheck_hint_bls12_381;
    use garaga::utils::drand::{
        DRAND_QUICKNET_PUBLIC_KEY, DrandResult, HashToCurveHint, round_to_curve_bls12_381,
    };
    use garaga::utils::hashing::hash_G1Point;
    use super::{G2_GEN, precomputed_lines};

    #[storage]
    struct Storage {}

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
            let mpcheck_hint = deserialize_mpcheck_hint_bls12_381(ref serialized, true);
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
                true => Option::Some(
                    DrandResult {
                        round_number: drand_hint.round_number,
                        randomness: hash_G1Point(drand_hint.signature),
                    },
                ),
                false => Option::None,
            }
        }
    }
}

#[starknet::interface]
trait IDrandBeaconQuicknet<TContractState> {
    fn verify_round(ref self: TContractState, full_proof_with_hints: Span<felt252>) -> bool;
    fn get_signature_for_round(self: @TContractState, round_number: u64) -> Option<G1Point>;
    fn get_randomness_for_round(self: @TContractState, round_number: u64) -> Option<felt252>;
}

#[starknet::contract]
mod DrandBeaconQuicknet {
    use garaga::definitions::{G1G2Pair, G1Point, G1PointStorePacking, G1PointZero};
    use garaga::pairing_check::{MPCheckHintBLS12_381, multi_pairing_check_bls12_381_2P_2F};
    use garaga::utils::calldata::deserialize_mpcheck_hint_bls12_381;
    use garaga::utils::drand::{
        DRAND_QUICKNET_PUBLIC_KEY, HashToCurveHint, round_to_curve_bls12_381,
    };
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
            let round_number = Serde::<u64>::deserialize(ref serialized).unwrap();
            let signature = Serde::<G1Point>::deserialize(ref serialized).unwrap();
            let hash_to_curve_hint = Serde::<HashToCurveHint>::deserialize(ref serialized).unwrap();
            let mpcheck_hint = deserialize_mpcheck_hint_bls12_381(ref serialized, true);
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
    impl IDrandBeaconQuicknet of super::IDrandBeaconQuicknet<ContractState> {
        fn verify_round(ref self: ContractState, mut full_proof_with_hints: Span<felt252>) -> bool {
            let drand_hint = Serde::<DrandHint>::deserialize(ref full_proof_with_hints).unwrap();
            let message = round_to_curve_bls12_381(
                drand_hint.round_number, drand_hint.hash_to_curve_hint,
            );
            let check = multi_pairing_check_bls12_381_2P_2F(
                pair0: G1G2Pair { p: drand_hint.signature, q: G2_GEN },
                pair1: G1G2Pair { p: message, q: DRAND_QUICKNET_PUBLIC_KEY },
                lines: precomputed_lines.span(),
                hint: drand_hint.mpcheck_hint,
            );
            if check {
                self.signatures.entry(drand_hint.round_number).write(drand_hint.signature);
            }
            return check;
        }
        fn get_signature_for_round(self: @ContractState, round_number: u64) -> Option<G1Point> {
            let signature = self.signatures.entry(round_number).read();
            if signature.is_zero() {
                Option::None
            } else {
                Option::Some(signature)
            }
        }
        fn get_randomness_for_round(self: @ContractState, round_number: u64) -> Option<felt252> {
            let signature = self.signatures.entry(round_number).read();
            if signature.is_zero() {
                Option::None
            } else {
                Option::Some(hash_G1Point(signature))
            }
        }
    }
}

#[starknet::interface]
trait IDrandDecryptorQuicknet<TContractState> {
    fn decrypt_cipher_text(
        ref self: TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<Span<u8>>;
}

#[starknet::contract]
mod DrandDecryptorQuicknet {
    use garaga::utils::drand::{CipherText, decrypt_at_round};
    use starknet::ContractAddress;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use super::{IDrandBeaconQuicknetDispatcher, IDrandBeaconQuicknetDispatcherTrait};

    #[storage]
    struct Storage {
        beacon: ContractAddress,
    }

    #[derive(Drop, Serde)]
    struct DrandHint {
        round_number: u64,
        cipher_text: CipherText,
    }

    #[constructor]
    fn constructor(ref self: ContractState, beacon: ContractAddress) {
        self.beacon.write(beacon);
    }

    #[abi(embed_v0)]
    impl IDrandDecryptorQuicknet of super::IDrandDecryptorQuicknet<ContractState> {
        fn decrypt_cipher_text(
            ref self: ContractState, mut full_proof_with_hints: Span<felt252>,
        ) -> Option<Span<u8>> {
            let drand_hint = Serde::<DrandHint>::deserialize(ref full_proof_with_hints).unwrap();
            let dispatcher = IDrandBeaconQuicknetDispatcher {
                contract_address: self.beacon.read(),
            };
            let signature = dispatcher.get_signature_for_round(drand_hint.round_number)?;
            let msg_decrypted = decrypt_at_round(signature, drand_hint.cipher_text);
            Option::Some(msg_decrypted.span())
        }
    }
}
