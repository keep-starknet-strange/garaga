import os
import subprocess

from garaga.modulo_circuit_structs import G1PointCircuit
from garaga.starknet.cli.utils import create_directory
from garaga.starknet.groth16_contract_generator.generator import (
    ECIP_OPS_CLASS_HASH,
    get_scarb_toml_file,
    precompute_lines_from_vk,
)
from garaga.starknet.groth16_contract_generator.parsing_utils import (
    RISC0_BN254_CONTROL_ID,
    RISC0_CONTROL_ROOT,
    Groth16Proof,
    Groth16VerifyingKey,
    split_digest,
)


def gen_risc0_groth16_verifier(
    vk_path: str,
    output_folder_path: str,
    output_folder_name: str,
    ecip_class_hash: int = ECIP_OPS_CLASS_HASH,
    control_root: int = RISC0_CONTROL_ROOT,
    control_id: int = RISC0_BN254_CONTROL_ID,
    cli_mode: bool = False,
) -> str:
    vk = Groth16VerifyingKey.from_json(vk_path)
    curve_id = vk.curve_id
    output_folder_name = output_folder_name + f"_{curve_id.name.lower()}"
    output_folder_path = os.path.join(output_folder_path, output_folder_name)

    precomputed_lines = precompute_lines_from_vk(vk)
    CONTROL_ROOT_0, CONTROL_ROOT_1 = split_digest(control_root)

    T = G1PointCircuit.from_G1Point(
        name="T",
        point=(vk.ic[1].scalar_mul(CONTROL_ROOT_0))
        .add(vk.ic[2].scalar_mul(CONTROL_ROOT_1))
        .add(vk.ic[5].scalar_mul(control_id).add(vk.ic[0])),
    )

    constants_code = f"""
    use garaga::definitions::{{G1Point, G2Point, E12D, G2Line, u384}};
    use garaga::groth16::Groth16VerifyingKey;

    pub const N_FREE_PUBLIC_INPUTS:usize = 2;
    // CONTROL ROOT USED : {hex(control_root)}
    // \t CONTROL_ROOT_0 : {hex(CONTROL_ROOT_0)}
    // \t CONTROL_ROOT_1 : {hex(CONTROL_ROOT_1)}
    // BN254 CONTROL ID USED : {hex(control_id)}
    pub const T: G1Point = {T.serialize(raw=True)}; // IC[0] + IC[1] * CONTROL_ROOT_0 + IC[2] * CONTROL_ROOT_1 + IC[5] * BN254_CONTROL_ID
    {vk.serialize_to_cairo()}
    pub const precomputed_lines: [G2Line; {len(precomputed_lines)//4}] = {precomputed_lines.serialize(raw=True, const=True)};
    """

    contract_code = f"""
use garaga::definitions::E12DMulQuotient;
use garaga::groth16::{{Groth16ProofRaw, MPCheckHint{curve_id.name}}};
use super::groth16_verifier_constants::{{N_FREE_PUBLIC_INPUTS, vk, ic, precomputed_lines, T}};

#[starknet::interface]
trait IRisc0Groth16Verifier{curve_id.name}<TContractState> {{
    fn verify_groth16_proof_{curve_id.name.lower()}(
        ref self: TContractState,
        groth16_proof: Groth16ProofRaw,
        image_id: Span<u32>,
        journal_digest: Span<u32>,
        mpcheck_hint: MPCheckHint{curve_id.name},
        small_Q: E12DMulQuotient,
        msm_hint: Array<felt252>,
    ) -> bool;
}}

#[starknet::contract]
mod Risc0Groth16Verifier{curve_id.name} {{
    use starknet::SyscallResultTrait;
    use garaga::definitions::{{G1Point, G1G2Pair, E12DMulQuotient}};
    use garaga::groth16::{{multi_pairing_check_{curve_id.name.lower()}_3P_2F_with_extra_miller_loop_result, Groth16ProofRaw, MPCheckHint{curve_id.name}}};
    use garaga::ec_ops::{{G1PointTrait, G2PointTrait, ec_safe_add}};
    use garaga::risc0_utils::compute_receipt_claim;
    use super::{{N_FREE_PUBLIC_INPUTS, vk, ic, precomputed_lines, T}};

    const ECIP_OPS_CLASS_HASH: felt252 = {hex(ecip_class_hash)};
    use starknet::ContractAddress;

    #[storage]
    struct Storage {{}}

    #[abi(embed_v0)]
    impl IRisc0Groth16Verifier{curve_id.name} of super::IRisc0Groth16Verifier{curve_id.name}<ContractState> {{
        fn verify_groth16_proof_{curve_id.name.lower()}(
            ref self: ContractState,
            groth16_proof: Groth16ProofRaw,
            image_id: Span<u32>,
            journal_digest: Span<u32>,
            mpcheck_hint: MPCheckHint{curve_id.name},
            small_Q: E12DMulQuotient,
            msm_hint: Array<felt252>,
        ) -> bool {{
            // DO NOT EDIT THIS FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING.
            // ONLY EDIT THE process_public_inputs FUNCTION BELOW.
            groth16_proof.a.assert_on_curve({curve_id.value});
            groth16_proof.b.assert_on_curve({curve_id.value});
            groth16_proof.c.assert_on_curve({curve_id.value});

            let ic = ic.span();

            let claim_digest = compute_receipt_claim(image_id, journal_digest);

            // Start serialization with the hint array directly to avoid copying it.
            let mut msm_calldata: Array<felt252> = msm_hint;
            // Add the points from VK relative to the non-constant public inputs.
            Serde::serialize(@ic.slice(3, N_FREE_PUBLIC_INPUTS), ref msm_calldata);
            // Add the claim digest as scalars for the msm.
            Serde::serialize(@claim_digest, ref msm_calldata);
            // Complete with the curve indentifier ({curve_id.value} for {curve_id.name}):
            msm_calldata.append({curve_id.value});

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
                T, Serde::<G1Point>::deserialize(ref _msm_result_serialized).unwrap(), {curve_id.value}
            );

            // Perform the pairing check.
            let check = multi_pairing_check_{curve_id.name.lower()}_3P_2F_with_extra_miller_loop_result(
                G1G2Pair {{ p: vk_x, q: vk.gamma_g2 }},
                G1G2Pair {{ p: groth16_proof.c, q: vk.delta_g2 }},
                G1G2Pair {{ p: groth16_proof.a.negate({curve_id.value}), q: groth16_proof.b }},
                vk.alpha_beta_miller_loop_result,
                precomputed_lines.span(),
                mpcheck_hint,
                small_Q
            );
            if check == true {{
                self
                    .process_public_inputs(
                        starknet::get_caller_address(), claim_digest
                    );
                return true;
            }} else {{
                return false;
            }}
        }}
    }}
    #[generate_trait]
    impl InternalFunctions of InternalFunctionsTrait {{
        fn process_public_inputs(
            ref self: ContractState, user: ContractAddress, claim_digest: u256,
        ) {{ // Process the public inputs with respect to the caller address (user).
            // Update the storage, emit events, call other contracts, etc.
        }}
    }}
}}


    """

    create_directory(output_folder_path)
    src_dir = os.path.join(output_folder_path, "src")
    create_directory(src_dir)

    with open(os.path.join(src_dir, "groth16_verifier_constants.cairo"), "w") as f:
        f.write(constants_code)

    with open(os.path.join(src_dir, "groth16_verifier.cairo"), "w") as f:
        f.write(contract_code)

    with open(os.path.join(output_folder_path, "Scarb.toml"), "w") as f:
        f.write(get_scarb_toml_file("risc0_bn254_verifier", cli_mode=cli_mode))

    with open(os.path.join(src_dir, "lib.cairo"), "w") as f:
        f.write(
            f"""
mod groth16_verifier;
mod groth16_verifier_constants;
"""
        )
    subprocess.run(["scarb", "fmt"], check=True, cwd=output_folder_path)
    return constants_code


if __name__ == "__main__":
    pass

    RISCO_VK_PATH = (
        "hydra/garaga/starknet/groth16_contract_generator/examples/vk_risc0.json"
    )

    CONTRACTS_FOLDER = "src/contracts/"  # Do not change this

    FOLDER_NAME = "risc0_verifier"  # '_curve_id' is appended in the end.

    gen_risc0_groth16_verifier(
        RISCO_VK_PATH, CONTRACTS_FOLDER, FOLDER_NAME, ECIP_OPS_CLASS_HASH
    )

    # https://github.com/risc0/risc0-ethereum/blob/main/contracts/test/TestReceipt.sol

    seal = bytes.fromhex(
        "50bd1769096d29a4e342d93785757cde64ef07c09f317481f0ee9274f14281dc501c1b2e036ee070b7bd75b4f0253f7349afaa4074d73f77b09de60dd82d3fbeba8cc4a10dab619b389ed53ddfc3113e055729ff430a82f57d7edc24821e782653b9f1ba00558126e75bcb392a9a58d45af8489f4441d77e91d10c11dcea70c33c93f3ba03dab52a25735bb04f2526ec7289c1ee8912f921c4f5d380a5f906782f60044a0d44d7005528e1821e458e7bf108777452b2327ba1998710aa62e1e106858a302c0fe02760c5fda0000e039d263b2cc918eb2539da008bbbe7007f767d45d22d18f589ab466da35e0d0bfc300af4b0bc941a9897a863b48a2deb5f057c2f512c"
    )
    image_id = bytes.fromhex(
        "d01c15afa768a05b213a9e5fcdcc5724a2947e00098c7ec34ccbe2946bbc0013"
    )
    journal = bytes.fromhex("6a75737420612073696d706c652072656365697074")

    g16_proof = Groth16Proof.from_risc0(seal=seal, image_id=image_id, journal=journal)
    from garaga.starknet.groth16_contract_generator.calldata import (
        groth16_calldata_from_vk_and_proof,
    )

    calldata = groth16_calldata_from_vk_and_proof(
        vk=Groth16VerifyingKey.from_json(RISCO_VK_PATH), proof=g16_proof
    )

    print(calldata)
