use garaga::definitions::G1Point;

#[starknet::interface]
trait IDrandDecryptQuicknet<TContractState> {
    /// Verify a drand round BLS signature via library_call to the verifier class,
    /// which stores the signature in this contract's storage.
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
    /// If the round is not yet verified, a DrandHint must follow in the calldata.
    fn decrypt_cipher_text(
        ref self: TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Result<Span<u8>, felt252>;
}

#[starknet::contract]
mod DrandDecryptQuicknet {
    use drand_quicknet::drand_verifier::{
        IDrandQuicknetDispatcherTrait, IDrandQuicknetLibraryDispatcher,
    };
    use garaga::apps::drand::{CipherText, decrypt_at_round};
    use garaga::definitions::{G1Point, G1PointStorePacking, G1PointZero};
    use starknet::storage::{Map, StoragePathEntry, StoragePointerReadAccess};
    use super::super::drand_decrypt_constants::VERIFIER_CLASS_HASH;

    #[storage]
    struct Storage {
        signatures: Map<u64, G1Point>,
    }

    #[derive(Drop, Serde)]
    struct DrandDecryptHint {
        round_number: u64,
        cipher_text: CipherText,
    }

    fn verifier() -> IDrandQuicknetLibraryDispatcher {
        IDrandQuicknetLibraryDispatcher { class_hash: VERIFIER_CLASS_HASH.try_into().unwrap() }
    }

    #[abi(embed_v0)]
    impl IDrandDecryptQuicknetImpl of super::IDrandDecryptQuicknet<ContractState> {
        fn verify_round(
            ref self: ContractState, full_proof_with_hints: Span<felt252>,
        ) -> Result<u64, felt252> {
            let mut v = verifier();
            v.verify_round(full_proof_with_hints)
        }

        fn get_signature_for_round(
            self: @ContractState, round_number: u64,
        ) -> Result<G1Point, felt252> {
            verifier().get_signature_for_round(round_number)
        }

        fn get_randomness_for_round(
            self: @ContractState, round_number: u64,
        ) -> Result<felt252, felt252> {
            verifier().get_randomness_for_round(round_number)
        }

        fn decrypt_cipher_text(
            ref self: ContractState, mut full_proof_with_hints: Span<felt252>,
        ) -> Result<Span<u8>, felt252> {
            let hint = Serde::<DrandDecryptHint>::deserialize(ref full_proof_with_hints)
                .ok_or('Bad calldata: DecryptHint')?;

            let signature = self.signatures.entry(hint.round_number).read();

            let signature = if signature.is_zero() {
                let mut v = verifier();
                v.verify_round(full_proof_with_hints)?;
                let sig = self.signatures.entry(hint.round_number).read();
                if sig.is_zero() {
                    return Result::Err('Verification did not store sig');
                }
                sig
            } else {
                signature
            };

            Result::Ok(decrypt_at_round(signature, hint.cipher_text).span())
        }
    }
}
