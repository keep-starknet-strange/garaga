use garaga::definitions::G1Point;
use garaga::utils::drand::CipherText;
use super::drand_verifier_constants::{G2_GEN, precomputed_lines};

#[starknet::interface]
trait IDrandQuicknet<TContractState> {
    fn verify_round(ref self: TContractState, full_proof_with_hints: Span<felt252>) -> Option<u64>;
    fn get_randomness_for_round(self: @TContractState, round_number: u64) -> Option<felt252>;
    fn decrypt_cipher_text(
        self: @TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<Span<u8>>;
}

#[starknet::contract]
mod DrandQuicknet {
    use garaga::definitions::{G1G2Pair, G1Point, G1PointStorePacking, G1PointZero};
    use garaga::pairing_check::{MPCheckHintBLS12_381, multi_pairing_check_bls12_381_2P_2F};
    use garaga::utils::calldata::deserialize_mpcheck_hint_bls12_381;
    use garaga::utils::drand::{
        CipherText, DRAND_QUICKNET_PUBLIC_KEY, HashToCurveHint, round_to_curve_bls12_381,
    };
    use garaga::utils::hashing::hash_G1Point;
    use starknet::ClassHash;
    use starknet::storage::{
        Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess,
    };
    use super::{
        G2_GEN, IDrandDecryptLibQuicknetDispatcherTrait, IDrandDecryptLibQuicknetLibraryDispatcher,
        precomputed_lines,
    };

    #[storage]
    struct Storage {
        decrypt_lib: ClassHash,
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

    #[derive(Drop, Serde)]
    struct DrandDecryptHint {
        round_number: u64,
        cipher_text: CipherText,
    }

    #[constructor]
    fn constructor(ref self: ContractState, decrypt_lib: ClassHash) {
        self.decrypt_lib.write(decrypt_lib);
    }

    #[abi(embed_v0)]
    impl IDrandQuicknet of super::IDrandQuicknet<ContractState> {
        fn verify_round(
            ref self: ContractState, mut full_proof_with_hints: Span<felt252>,
        ) -> Option<u64> {
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
            if !check {
                return Option::None;
            }
            self.signatures.entry(drand_hint.round_number).write(drand_hint.signature);
            return Option::Some(drand_hint.round_number);
        }
        fn get_randomness_for_round(self: @ContractState, round_number: u64) -> Option<felt252> {
            let signature = self.signatures.entry(round_number).read();
            if signature.is_zero() {
                Option::None
            } else {
                Option::Some(hash_G1Point(signature))
            }
        }
        fn decrypt_cipher_text(
            self: @ContractState, mut full_proof_with_hints: Span<felt252>,
        ) -> Option<Span<u8>> {
            let drand_hint = Serde::<DrandDecryptHint>::deserialize(ref full_proof_with_hints)
                .unwrap();
            let signature = self.signatures.entry(drand_hint.round_number).read();
            if signature.is_zero() {
                Option::None
            } else {
                let dispatcher = IDrandDecryptLibQuicknetLibraryDispatcher {
                    class_hash: self.decrypt_lib.read(),
                };
                let msg_decrypted = dispatcher
                    .decrypt_cipher_text(signature, drand_hint.cipher_text);
                Option::Some(msg_decrypted)
            }
        }
    }
}

#[starknet::interface]
trait IDrandDecryptLibQuicknet<TContractState> {
    fn decrypt_cipher_text(
        self: @TContractState, signature: G1Point, cipher_text: CipherText,
    ) -> Span<u8>;
}

#[starknet::contract]
mod DrandDecryptLibQuicknet {
    use garaga::definitions::G1Point;
    use garaga::utils::drand::{CipherText, decrypt_at_round};

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl IDrandDecryptLibQuicknet of super::IDrandDecryptLibQuicknet<ContractState> {
        fn decrypt_cipher_text(
            self: @ContractState, signature: G1Point, cipher_text: CipherText,
        ) -> Span<u8> {
            decrypt_at_round(signature, cipher_text).span()
        }
    }
}
