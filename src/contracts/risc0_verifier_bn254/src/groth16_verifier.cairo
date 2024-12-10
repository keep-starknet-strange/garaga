use super::groth16_verifier_constants::{N_FREE_PUBLIC_INPUTS, vk, ic, precomputed_lines, T};

#[starknet::interface]
trait IRisc0Groth16VerifierBN254<TContractState> {
    fn verify_groth16_proof_bn254(
        self: @TContractState, full_proof_with_hints: Span<felt252>,
    ) -> Option<Span<u8>>;
}

#[starknet::contract]
mod Risc0Groth16VerifierBN254 {
    use starknet::SyscallResultTrait;
    use garaga::definitions::{G1Point, G1G2Pair};
    use garaga::groth16::{multi_pairing_check_bn254_3P_2F_with_extra_miller_loop_result};
    use garaga::ec_ops::{G1PointTrait, ec_safe_add};
    use garaga::ec_ops_g2::{G2PointTrait};
    use garaga::utils::risc0::{compute_receipt_claim, journal_sha256};
    use garaga::utils::calldata::deserialize_full_proof_with_hints_risc0;
    use super::{N_FREE_PUBLIC_INPUTS, vk, ic, precomputed_lines, T};

    const ECIP_OPS_CLASS_HASH: felt252 =
        0xc4b7aa28a27b5fb8d7d43928b2a3ee960cf5b4e06cb9ae1ee3f102400b1700;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl IRisc0Groth16VerifierBN254 of super::IRisc0Groth16VerifierBN254<ContractState> {
        fn verify_groth16_proof_bn254(
            self: @ContractState, full_proof_with_hints: Span<felt252>,
        ) -> Option<Span<u8>> {
            // DO NOT EDIT THIS FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING.
            // This function returns an Option for the public inputs if the proof is valid.
            // If the proof is invalid, the execution will either fail or return None.
            // Read the documentation to learn how to generate the full_proof_with_hints array given
            // a proof and a verifying key.

            let fph = deserialize_full_proof_with_hints_risc0(full_proof_with_hints);

            let groth16_proof = fph.groth16_proof;
            let image_id = fph.image_id;
            let journal = fph.journal;
            let mpcheck_hint = fph.mpcheck_hint;
            let small_Q = fph.small_Q;
            let msm_hint = fph.msm_hint;

            groth16_proof.a.assert_on_curve(0);
            groth16_proof.b.assert_on_curve(0);
            groth16_proof.c.assert_on_curve(0);

            let ic = ic.span();

            let journal_digest = journal_sha256(journal);
            let claim_digest = compute_receipt_claim(image_id, journal_digest);

            // Start serialization with the hint array directly to avoid copying it.
            let mut msm_calldata: Array<felt252> = msm_hint;
            // Add the points from VK relative to the non-constant public inputs.
            Serde::serialize(@ic.slice(3, N_FREE_PUBLIC_INPUTS), ref msm_calldata);
            // Add the claim digest as scalars for the msm.
            msm_calldata.append(2);
            msm_calldata.append(claim_digest.low.into());
            msm_calldata.append(claim_digest.high.into());
            // Complete with the curve indentifier (0 for BN254):
            msm_calldata.append(0);

            // Call the multi scalar multiplication endpoint on the Garaga ECIP ops contract
            // to obtain claim0 * IC[3] + claim1 * IC[4].
            let mut _msm_result_serialized = core::starknet::syscalls::library_call_syscall(
                ECIP_OPS_CLASS_HASH.try_into().unwrap(),
                selector!("msm_g1_u128"),
                msm_calldata.span(),
            )
                .unwrap_syscall();

            // Finalize vk_x computation by adding the precomputed T point.
            let vk_x = ec_safe_add(
                T, Serde::<G1Point>::deserialize(ref _msm_result_serialized).unwrap(), 0,
            );

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
                return Option::Some(journal);
            } else {
                return Option::None;
            }
        }
    }
}

