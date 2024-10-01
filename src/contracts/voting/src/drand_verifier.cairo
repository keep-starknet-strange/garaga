use super::drand_verifier_constants::{G2_GEN, precomputed_lines};

#[starknet::interface]
trait IDrandQuicknet<TContractState> {
    fn verify_round_and_get_randomness(
        ref self: TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<felt252>;
}

#[starknet::contract]
mod DrandQuicknet {
    // use starknet::SyscallResultTrait;
    use garaga::definitions::{G1Point, G1G2Pair};
    use garaga::pairing_check::{multi_pairing_check_bls12_381_2P_2F, MPCheckHintBLS12_381};
    // use garaga::ec_ops::{G1PointTrait, G2PointTrait};
    use garaga::utils::drand::{
        round_to_curve_bls12_381, DRAND_QUICKNET_PUBLIC_KEY, HashToCurveHint
    };
    use super::{precomputed_lines, G2_GEN};
    use garaga::utils::hashing::hash_G1Point;

    // const ECIP_OPS_CLASS_HASH: felt252 =
    //     0x7918f484291eb154e13d0e43ba6403e62dc1f5fbb3a191d868e2e37359f8713;
    // use starknet::ContractAddress;

    #[storage]
    struct Storage {}

    #[derive(Drop, Serde)]
    struct DrandHint {
        round_number: u64,
        signature: G1Point,
        hash_to_curve_hint: HashToCurveHint,
        mpcheck_hint: MPCheckHintBLS12_381,
    }
    #[abi(embed_v0)]
    impl IDrandQuicknet of super::IDrandQuicknet<ContractState> {
        fn verify_round_and_get_randomness(
            ref self: ContractState, mut full_proof_with_hints: Span<felt252>,
        ) -> Option<felt252> {
            let drand_hint: DrandHint = Serde::deserialize(ref full_proof_with_hints).unwrap();
            let message = round_to_curve_bls12_381(
                drand_hint.round_number, drand_hint.hash_to_curve_hint
            );

            let check = multi_pairing_check_bls12_381_2P_2F(
                pair0: G1G2Pair { p: drand_hint.signature, q: G2_GEN },
                pair1: G1G2Pair { p: message, q: DRAND_QUICKNET_PUBLIC_KEY },
                lines: precomputed_lines.span(),
                hint: drand_hint.mpcheck_hint,
            );

            match check {
                true => Option::Some(hash_G1Point(message)),
                false => Option::None,
            }
        }
    }
}

