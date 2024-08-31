use garaga::definitions::E12DMulQuotient;
use garaga::groth16::{Groth16ProofRaw, MPCheckHintBN254};
use super::groth16_verifier_constants::{N_FREE_PUBLIC_INPUTS, vk, ic, precomputed_lines, T};

#[starknet::interface]
trait IRisc0Groth16VerifierBN254<TContractState> {
    fn verify_groth16_proof_bn254(
        ref self: TContractState,
        groth16_proof: Groth16ProofRaw,
        image_id: Span<u32>,
        journal_digest: Span<u32>,
        mpcheck_hint: MPCheckHintBN254,
        small_Q: E12DMulQuotient,
        msm_hint: Array<felt252>,
    ) -> bool;
}

#[starknet::contract]
mod Risc0Groth16VerifierBN254 {
    use starknet::SyscallResultTrait;
    use garaga::definitions::{G1Point, G1G2Pair, E12DMulQuotient};
    use garaga::groth16::{
        multi_pairing_check_bn254_3P_2F_with_extra_miller_loop_result, Groth16ProofRaw,
        MPCheckHintBN254
    };
    use garaga::ec_ops::{G1PointTrait, G2PointTrait, ec_safe_add};
    use garaga::risc0_utils::compute_receipt_claim;
    use super::{N_FREE_PUBLIC_INPUTS, vk, ic, precomputed_lines, T};

    const ECIP_OPS_CLASS_HASH: felt252 =
        0x25bdbb933fdbef07894633039aacc53fdc1f89c6cf8a32324b5fefdcc3d329e;
    use starknet::ContractAddress;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl IRisc0Groth16VerifierBN254 of super::IRisc0Groth16VerifierBN254<ContractState> {
        fn verify_groth16_proof_bn254(
            ref self: ContractState,
            groth16_proof: Groth16ProofRaw,
            image_id: Span<u32>,
            journal_digest: Span<u32>,
            mpcheck_hint: MPCheckHintBN254,
            small_Q: E12DMulQuotient,
            msm_hint: Array<felt252>,
        ) -> bool {
            // DO NOT EDIT THIS FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING.
            // ONLY EDIT THE process_public_inputs FUNCTION BELOW.
            groth16_proof.a.assert_on_curve(0);
            groth16_proof.b.assert_on_curve(0);
            groth16_proof.c.assert_on_curve(0);

            let ic = ic.span();

            let claim_digest = compute_receipt_claim(image_id, journal_digest);

            // Start serialization with the hint array directly to avoid copying it.
            let mut msm_calldata: Array<felt252> = msm_hint;
            // Add the points from VK relative to the non-constant public inputs.
            Serde::serialize(@ic.slice(3, N_FREE_PUBLIC_INPUTS), ref msm_calldata);
            // Add the claim digest as scalars for the msm.
            Serde::serialize(@claim_digest, ref msm_calldata);
            // Complete with the curve indentifier (0 for BN254):
            msm_calldata.append(0);

            // Call the multi scalar multiplication endpoint on the Garaga ECIP ops contract
            // to obtain claim0 * IC[3] + claim1 * IC[4].
            let mut _msm_result_serialized = core::starknet::syscalls::library_call_syscall(
                ECIP_OPS_CLASS_HASH.try_into().unwrap(),
                selector!("msm_g1_u128"),
                msm_calldata.span()
            )
                .unwrap_syscall();

            // Finalize vk_x computation by adding the precomputed T point.
            let vk_x = ec_safe_add(
                T, Serde::<G1Point>::deserialize(ref _msm_result_serialized).unwrap(), 0
            );

            // Perform the pairing check.
            let check = multi_pairing_check_bn254_3P_2F_with_extra_miller_loop_result(
                G1G2Pair { p: vk_x, q: vk.gamma_g2 },
                G1G2Pair { p: groth16_proof.c, q: vk.delta_g2 },
                G1G2Pair { p: groth16_proof.a.negate(0), q: groth16_proof.b },
                vk.alpha_beta_miller_loop_result,
                precomputed_lines.span(),
                mpcheck_hint,
                small_Q
            );
            if check == true {
                self.process_public_inputs(starknet::get_caller_address(), claim_digest);
                return true;
            } else {
                return false;
            }
        }
    }
    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {
        fn process_public_inputs(
            ref self: ContractState, user: ContractAddress, claim_digest: u256,
        ) { // Process the public inputs with respect to the caller address (user).
        // Update the storage, emit events, call other contracts, etc.
        }
    }
}

