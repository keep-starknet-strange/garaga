use garaga::definitions::{u384, u96, G1Point};
use garaga::groth16::{Groth16Proof};
use super::groth16_verifier_constants::{N_PUBLIC_INPUTS, vk, ic, precomputed_lines};

#[starknet::interface]
trait IGroth16VerifierBN254<TContractState> {
    fn verify_groth16_proof(
        self: @TContractState,
        _groth16_proof: Span<felt252>,
        _mpcheck_hint: Span<felt252>,
        _small_Q_hint: Span<felt252>,
        _msm_hint: Span<felt252>,
        msm_scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
    ) -> bool;
}

#[starknet::contract]
mod Groth16VerifierBN254 {
    use garaga::definitions::{u384, u96, G1Point, G1G2Pair, E12D, E12DMulQuotient};
    use garaga::groth16::{verify_groth16_bn254, Groth16Proof, MPCheckHintBN254};
    use garaga::utils_calldata::{
        parse_mp_check_hint_bn254, parse_groth16_proof, parse_E12DMulQuotient, parse_msm_hint,
        MSMHint, DerivePointFromXHint
    };
    use super::{N_PUBLIC_INPUTS, vk, ic, precomputed_lines};

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl IGroth16VerifierBN254 of super::IGroth16VerifierBN254<ContractState> {
        fn verify_groth16_proof(
            self: @ContractState,
            _groth16_proof: Span<felt252>,
            _mpcheck_hint: Span<felt252>,
            _small_Q_hint: Span<felt252>,
            _msm_hint: Span<felt252>,
            msm_scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
        ) -> bool {
            let groth16_proof: Box<Groth16Proof> = parse_groth16_proof(
                _groth16_proof, N_PUBLIC_INPUTS
            );
            let mpcheck_hint: Box<MPCheckHintBN254> = parse_mp_check_hint_bn254(
                _mpcheck_hint, 0, 1
            );
            let small_Q: Box<E12DMulQuotient> = parse_E12DMulQuotient(_small_Q_hint);
            let (
                public_inputs_msm_hint, public_inputs_derive_point_from_x_hint
            ): (Box<MSMHint>, Box<DerivePointFromXHint>) =
                parse_msm_hint(
                _msm_hint, N_PUBLIC_INPUTS
            );

            verify_groth16_bn254(
                proof: groth16_proof.unbox(),
                verification_key: vk,
                lines: precomputed_lines.span(),
                ic: ic.span(),
                public_inputs_digits_decompositions: msm_scalars_digits_decompositions,
                public_inputs_msm_hint: public_inputs_msm_hint,
                public_inputs_msm_derive_point_from_x_hint: public_inputs_derive_point_from_x_hint,
                mpcheck_hint: mpcheck_hint,
                small_Q: small_Q,
            )
        }
    }
}
