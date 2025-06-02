use super::groth16_verifier_constants::{N_PUBLIC_INPUTS, ic, precomputed_lines, vk};

#[starknet::interface]
pub trait ISP1Groth16VerifierBN254<TContractState> {
    fn verify_sp1_groth16_proof_bn254(
        self: @TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<(u256, Span<u256>)>;
}

#[starknet::contract]
mod SP1Groth16VerifierBN254 {
    use garaga::definitions::{G1G2Pair, G1Point};
    use garaga::ec_ops::{G1PointTrait, ec_safe_add};
    use garaga::ec_ops_g2::G2PointTrait;
    use garaga::groth16::multi_pairing_check_bn254_3P_2F_with_extra_miller_loop_result;
    use garaga::utils::calldata::deserialize_full_proof_with_hints_sp1;
    use garaga::utils::sp1::process_public_inputs_sp1;
    use starknet::SyscallResultTrait;
    use super::{N_PUBLIC_INPUTS, ic, precomputed_lines, vk};

    const ECIP_OPS_CLASS_HASH: felt252 =
        0x146ee805dd0252256484a6001dc932dd940b1787c0f24e65629f4f6645f0692;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl ISP1Groth16VerifierBN254 of super::ISP1Groth16VerifierBN254<ContractState> {
        fn verify_sp1_groth16_proof_bn254(
            self: @ContractState, full_proof_with_hints: Span<felt252>,
        ) -> Option<(u256, Span<u256>)> {
            // DO NOT EDIT THIS FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING.
            // This function returns an Option for the SP1 verifying key and public inputs if the
            // proof is valid.
            // If the proof is invalid, the execution will either fail or return None.
            // Read the documentation to learn how to generate the full_proof_with_hints array given
            // a proof and a verifying key.

            let fph = deserialize_full_proof_with_hints_sp1(full_proof_with_hints);
            let groth16_proof = fph.groth16_proof;
            let vkey = fph.vkey;
            let public_inputs_sp1 = fph.public_inputs_sp1;
            let mpcheck_hint = fph.mpcheck_hint;
            let small_Q = fph.small_Q;
            let msm_hint = fph.msm_hint;

            groth16_proof.a.assert_on_curve(0);
            groth16_proof.b.assert_on_curve(0);
            groth16_proof.c.assert_on_curve(0);

            let ic = ic.span();

            let (pub_inputs_256, pub_input_hash): (Span<u256>, u256) = process_public_inputs_sp1(
                public_inputs_sp1,
            );

            let vk_x: G1Point = match ic.len() {
                0 => panic!("Malformed VK"),
                1 => *ic.at(0),
                _ => {
                    let mut msm_calldata: Array<felt252> = array![];
                    // Add the points from VK and public inputs to the proof.
                    Serde::serialize(@ic.slice(1, N_PUBLIC_INPUTS), ref msm_calldata);
                    // Serialize public inputs as u256 array.
                    Serde::serialize(@N_PUBLIC_INPUTS, ref msm_calldata);
                    Serde::serialize(@vkey, ref msm_calldata);
                    Serde::serialize(@pub_input_hash, ref msm_calldata);
                    // Complete with the curve indentifier (0 for BN254):
                    msm_calldata.append(0);
                    // Add the hint array.
                    for x in msm_hint {
                        msm_calldata.append(*x);
                    }

                    // Call the multi scalar multiplication endpoint on the Garaga ECIP ops contract
                    // to obtain vk_x.
                    let mut _vx_x_serialized = starknet::syscalls::library_call_syscall(
                        ECIP_OPS_CLASS_HASH.try_into().unwrap(),
                        selector!("msm_g1"),
                        msm_calldata.span(),
                    )
                        .unwrap_syscall();

                    ec_safe_add(
                        Serde::<G1Point>::deserialize(ref _vx_x_serialized).unwrap(), *ic.at(0), 0,
                    )
                },
            };
            // Perform the pairing check.
            let check = multi_pairing_check_bn254_3P_2F_with_extra_miller_loop_result(
                G1G2Pair { p: vk_x, q: vk.gamma_g2 },
                G1G2Pair { p: groth16_proof.c, q: vk.delta_g2 },
                G1G2Pair { p: groth16_proof.a.negate(0), q: groth16_proof.b },
                vk.alpha_beta_miller_loop_result,
                precomputed_lines.span(),
                mpcheck_hint,
                small_Q,
            );
            if check == true {
                return Option::Some((vkey, pub_inputs_256));
            } else {
                return Option::None;
            }
        }
    }
}

