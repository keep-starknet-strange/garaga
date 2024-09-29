use super::bls_sig_constants::{pk, precomputed_lines};

#[starknet::interface]
trait IDrandQuicknet<TContractState> {
    fn verify_round(
        ref self: TContractState, round_number: u64, full_proof_with_hints: Span<felt252>,
    ) -> Option<felt252>;
}

#[starknet::contract]
mod DrandQuicknet {
    use starknet::SyscallResultTrait;
    use garaga::definitions::{G1Point, G1G2Pair};
    use garaga::pairing_check::{multi_pairing_check_bls12_381_2P_2F, MPCheckHintBLS12_381};
    use garaga::ec_ops::{G1PointTrait, G2PointTrait, ec_safe_add};
    use garaga::utils::calldata::{deserialize_full_proof_with_hints_bls12_381};
    use garaga::utils::drand::{round_to_curve_bls12_381};
    use super::{N_PUBLIC_INPUTS, vk, ic, precomputed_lines};

    const ECIP_OPS_CLASS_HASH: felt252 =
        0x7918f484291eb154e13d0e43ba6403e62dc1f5fbb3a191d868e2e37359f8713;
    use starknet::ContractAddress;

    #[storage]
    struct Storage {}

    #[derive(Drop, Serde)]
    struct BLSSigHint {
        signature: G1Point,
        hash_to_curve_hint: HashToCurveHint,
        mpcheck_hint: MPCheckHintBLS12_381,
    }
    #[abi(embed_v0)]
    impl IDrandQuicknet of super::IDrandQuicknet<ContractState> {
        fn verify_round(
            ref self: ContractState, round_number: u64, full_proof_with_hints: Span<felt252>,
        ) -> Option<felt252> {
            let sig_hint: BLSSigHint = Serde::deserialize(full_proof_with_hints);
            let message = round_to_curve_bls12_381(round_number, sig_hint.hash_to_curve_hint);

            let g2_gen = G2Point {
                x0: u384 {
                    limb0: 0xa805bbefd48056c8c121bdb8,
                    limb1: 0xb4510b647ae3d1770bac0326,
                    limb2: 0x2dc51051c6e47ad4fa403b02,
                    limb3: 0x24aa2b2f08f0a9126080527
                },
                x1: u384 {
                    limb0: 0x13945d57e5ac7d055d042b7e,
                    limb1: 0xb5da61bbdc7f5049334cf112,
                    limb2: 0x88274f65596bd0d09920b61a,
                    limb3: 0x13e02b6052719f607dacd3a0
                },
                y0: u384 {
                    limb0: 0x3baca289e193548608b82801,
                    limb1: 0x6d429a695160d12c923ac9cc,
                    limb2: 0xda2e351aadfd9baa8cbdd3a7,
                    limb3: 0xce5d527727d6e118cc9cdc6
                },
                y1: u384 {
                    limb0: 0x5cec1da1aaa9075ff05f79be,
                    limb1: 0x267492ab572e99ab3f370d27,
                    limb2: 0x2bc28b99cb3e287e85a763af,
                    limb3: 0x606c4a02ea734cc32acd2b0
                }
            };

            let res = multi_pairing_check_bls12_381_2P_2F(
                pair0: G1G2Pair { p: sig_hint.signature, q: g2_gen },
                pair1: G1G2Pair { p: message, q: pk },
                lines: precomputed_lines.span(),
                hint: sig_hint.mpcheck_hint,
            );
            return Option::Some(1);
        }
    }
}

