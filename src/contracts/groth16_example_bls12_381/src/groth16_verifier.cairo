use super::groth16_verifier_constants::{N_PUBLIC_INPUTS, vk, ic, precomputed_lines};

#[starknet::interface]
trait IGroth16VerifierBLS12_381<TContractState> {
    fn verify_groth16_proof_bls12_381(
        ref self: TContractState, full_proof_with_hints: Span<felt252>,
    ) -> bool;
}

#[starknet::contract]
mod Groth16VerifierBLS12_381 {
    use starknet::SyscallResultTrait;
    use garaga::definitions::{G1Point, G1G2Pair};
    use garaga::groth16::{multi_pairing_check_bls12_381_3P_2F_with_extra_miller_loop_result};
    use garaga::ec_ops::{G1PointTrait, G2PointTrait, ec_safe_add};
    use garaga::utils::calldata::{deserialize_full_proof_with_hints_bls12_381};
    use super::{N_PUBLIC_INPUTS, vk, ic, precomputed_lines};

    const ECIP_OPS_CLASS_HASH: felt252 =
        0x7918f484291eb154e13d0e43ba6403e62dc1f5fbb3a191d868e2e37359f8713;
    use starknet::ContractAddress;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl IGroth16VerifierBLS12_381 of super::IGroth16VerifierBLS12_381<ContractState> {
        fn verify_groth16_proof_bls12_381(
            ref self: ContractState, full_proof_with_hints: Span<felt252>,
        ) -> bool {
            // DO NOT EDIT THIS FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING.
            // ONLY EDIT THE process_public_inputs FUNCTION BELOW.
            let fph = deserialize_full_proof_with_hints_bls12_381(full_proof_with_hints);
            let groth16_proof = fph.groth16_proof;
            let mpcheck_hint = fph.mpcheck_hint;
            let small_Q = fph.small_Q;
            let msm_hint = fph.msm_hint;

            groth16_proof.a.assert_on_curve(1);
            groth16_proof.b.assert_on_curve(1);
            groth16_proof.c.assert_on_curve(1);

            let ic = ic.span();

            let vk_x: G1Point = match ic.len() {
                0 => panic!("Malformed VK"),
                1 => *ic.at(0),
                _ => {
                    // Start serialization with the hint array directly to avoid copying it.
                    let mut msm_calldata: Array<felt252> = msm_hint;
                    // Add the points from VK and public inputs to the proof.
                    Serde::serialize(@ic.slice(1, N_PUBLIC_INPUTS), ref msm_calldata);
                    Serde::serialize(@groth16_proof.public_inputs, ref msm_calldata);
                    // Complete with the curve indentifier (1 for BLS12_381):
                    msm_calldata.append(1);

                    // Call the multi scalar multiplication endpoint on the Garaga ECIP ops contract
                    // to obtain vk_x.
                    let mut _vx_x_serialized = core::starknet::syscalls::library_call_syscall(
                        ECIP_OPS_CLASS_HASH.try_into().unwrap(),
                        selector!("msm_g1"),
                        msm_calldata.span()
                    )
                        .unwrap_syscall();

                    ec_safe_add(
                        Serde::<G1Point>::deserialize(ref _vx_x_serialized).unwrap(), *ic.at(0), 1
                    )
                }
            };
            // Perform the pairing check.
            let check = multi_pairing_check_bls12_381_3P_2F_with_extra_miller_loop_result(
                G1G2Pair { p: vk_x, q: vk.gamma_g2 },
                G1G2Pair { p: groth16_proof.c, q: vk.delta_g2 },
                G1G2Pair { p: groth16_proof.a.negate(1), q: groth16_proof.b },
                vk.alpha_beta_miller_loop_result,
                precomputed_lines.span(),
                mpcheck_hint,
                small_Q
            );
            if check == true {
                self
                    .process_public_inputs(
                        starknet::get_caller_address(), groth16_proof.public_inputs
                    );
                return true;
            } else {
                return false;
            }
        }
    }
    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {
        fn process_public_inputs(
            ref self: ContractState, user: ContractAddress, public_inputs: Span<u256>,
        ) { // Process the public inputs with respect to the caller address (user).
        // Update the storage, emit events, call other contracts, etc.
        }
    }
}

