import os
from textwrap import dedent

from garaga.curves import ProofSystem
from garaga.starknet.groth16_contract_generator.generator import (
    ECIP_OPS_CLASS_HASH,
    precompute_lines_from_vk,
    write_test_calldata_file_generic,
    write_verifier_files,
)
from garaga.starknet.groth16_contract_generator.parsing_utils import (
    Groth16Proof,
    Groth16VerifyingKey,
)


def gen_sp1_groth16_verifier(
    vk_path: str,
    output_folder_path: str,
    output_folder_name: str,
    ecip_class_hash: int = ECIP_OPS_CLASS_HASH,
    cli_mode: bool = False,
) -> str:
    vk = Groth16VerifyingKey.from_json(vk_path)
    curve_id = vk.curve_id
    output_folder_name = output_folder_name + f"_{curve_id.name.lower()}"
    output_folder_path = os.path.join(output_folder_path, output_folder_name)

    precomputed_lines = precompute_lines_from_vk(vk)

    contract_cairo_name = f"SP1Groth16Verifier{curve_id.name}"
    constants_code = (
        dedent(
            f"""
            use garaga::definitions::{{G1Point, G2Point, E12D, G2Line, u384, u288}};
            use garaga::groth16::Groth16VerifyingKey;

            pub const N_PUBLIC_INPUTS: usize = {len(vk.ic) - 1};
            {vk.serialize_to_cairo()}
            pub const precomputed_lines: [G2Line; {len(precomputed_lines) // 4}] = {precomputed_lines.serialize(raw=True, const=True)};
            """
        ).strip()
        + "\n"
    )
    verification_function_name = f"verify_sp1_groth16_proof_{curve_id.name.lower()}"

    contract_code = (
        dedent(
            f"""
            #[starknet::interface]
            pub trait ISP1Groth16Verifier{curve_id.name}<TContractState> {{
                fn {verification_function_name}(
                    self: @TContractState,
                    full_proof_with_hints: Span<felt252>,
                ) -> Result<(u256, Span<u256>), felt252>;
            }}

            #[starknet::contract]
            mod SP1Groth16Verifier{curve_id.name} {{
                use starknet::SyscallResultTrait;
                use garaga::definitions::{{G1Point, G1G2Pair}};
                use garaga::groth16::{{multi_pairing_check_{curve_id.name.lower()}_3P_2F_with_extra_miller_loop_result, Groth16ProofRawTrait}};
                use garaga::ec_ops::{{G1PointTrait, ec_safe_add}};
                use garaga::apps::sp1::{{deserialize_full_proof_with_hints_sp1, process_public_inputs_sp1}};
                use garaga::apps::sp1_constants::{{vk, ic, precomputed_lines, N_PUBLIC_INPUTS}};

                const ECIP_OPS_CLASS_HASH: felt252 = {hex(ecip_class_hash)};

                #[storage]
                struct Storage {{}}

                #[abi(embed_v0)]
                impl ISP1Groth16Verifier{curve_id.name} of super::ISP1Groth16Verifier{curve_id.name}<ContractState> {{
                    fn {verification_function_name}(
                        self: @ContractState,
                        full_proof_with_hints: Span<felt252>,
                    ) -> Result<(u256, Span<u256>), felt252> {{
                        // DO NOT EDIT THIS FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING.
                        // This function returns Result::Ok((vkey, public_inputs)) if the proof is valid.
                        // If the proof is invalid, it returns Result::Err(error).
                        // Read the documentation to learn how to generate the full_proof_with_hints array given a proof and a verifying key.

                        let fph = deserialize_full_proof_with_hints_sp1(full_proof_with_hints);
                        let groth16_proof = fph.groth16_proof;
                        let vkey = fph.vkey;
                        let public_inputs_sp1 = fph.public_inputs_sp1;
                        let mpcheck_hint = fph.mpcheck_hint;
                        let msm_hint = fph.msm_hint;

                        groth16_proof.check_proof_points({curve_id.value});

                        let ic = ic.span();

                        let (pub_inputs_256, pub_input_hash): (Span<u256>, u256) = process_public_inputs_sp1(public_inputs_sp1);

                        let vk_x: G1Point = match ic.len() {{
                            0 => panic!("Malformed VK"),
                            1 => *ic.at(0),
                            _ => {{
                                let mut msm_calldata: Array<felt252> = array![];
                                // Add the points from VK and public inputs to the proof.
                                Serde::serialize(@ic.slice(1, N_PUBLIC_INPUTS), ref msm_calldata);
                                // Serialize public inputs as u256 array.
                                Serde::serialize(@N_PUBLIC_INPUTS, ref msm_calldata);
                                Serde::serialize(@vkey, ref msm_calldata);
                                Serde::serialize(@pub_input_hash, ref msm_calldata);
                                // Complete with the curve indentifier ({curve_id.value} for {curve_id.name}):
                                msm_calldata.append({curve_id.value});
                                // Add the hint array.
                                for x in msm_hint {{
                                    msm_calldata.append(*x);
                                }}

                                // Call the multi scalar multiplication endpoint on the Garaga ECIP ops contract
                                // to obtain vk_x.
                                let mut _vx_x_serialized = starknet::syscalls::library_call_syscall(
                                    ECIP_OPS_CLASS_HASH.try_into().unwrap(),
                                    selector!("msm_g1"),
                                    msm_calldata.span()
                                )
                                    .unwrap_syscall();

                                ec_safe_add(
                                    Serde::<G1Point>::deserialize(ref _vx_x_serialized).unwrap(), *ic.at(0), {curve_id.value}
                                )
                            }}
                        }};
                        // Perform the pairing check.
                        let check = multi_pairing_check_{curve_id.name.lower()}_3P_2F_with_extra_miller_loop_result(
                            G1G2Pair {{ p: vk_x, q: vk.gamma_g2 }},
                            G1G2Pair {{ p: groth16_proof.c, q: vk.delta_g2 }},
                            G1G2Pair {{ p: groth16_proof.a.negate({curve_id.value}), q: groth16_proof.b }},
                            vk.alpha_beta_miller_loop_result,
                            precomputed_lines.span(),
                            mpcheck_hint,
                        );
                        match check {{
                            Result::Ok(_) => Result::Ok((vkey, pub_inputs_256)),
                            Result::Err(error) => Result::Err(error),
                        }}
                    }}
                }}
            }}
            """
        ).strip()
        + "\n"
    )

    # Use the reusable function to write all files
    write_verifier_files(
        output_folder_path,
        output_folder_name,
        constants_code,
        contract_code,
        contract_cairo_name,
        verification_function_name,
        ProofSystem.Groth16,
        cli_mode,
        modules=["groth16_verifier"],
        constants_output_path=os.path.join("src", "src", "apps", "sp1_constants.cairo"),
    )

    return constants_code


if __name__ == "__main__":
    pass

    SP1_VK_PATH = (
        "hydra/garaga/starknet/groth16_contract_generator/examples/vk_sp1.json"
    )
    PROOF_PATH = (
        "hydra/garaga/starknet/groth16_contract_generator/examples/proof_sp1.json"
    )

    CONTRACTS_FOLDER = "src/contracts/autogenerated/"  # Do not change this

    FOLDER_NAME = "sp1_verifier"  # '_curve_id' is appended in the end.

    gen_sp1_groth16_verifier(
        SP1_VK_PATH, CONTRACTS_FOLDER, FOLDER_NAME, ECIP_OPS_CLASS_HASH
    )

    # Check if proof file exists and generate calldata if it does
    if os.path.exists(PROOF_PATH):
        vk = Groth16VerifyingKey.from_json(file_path=SP1_VK_PATH)
        proof = Groth16Proof.from_json(proof_path=PROOF_PATH)

        # Generate the calldata and write test calldata file:
        output_folder_path = os.path.join(
            CONTRACTS_FOLDER, f"{FOLDER_NAME}_{vk.curve_id.name.lower()}"
        )
        write_test_calldata_file_generic(
            output_folder_path,
            system=ProofSystem.Groth16,  # SP1 uses Groth16
            vk_path=SP1_VK_PATH,
            proof_path=PROOF_PATH,
        )
    else:
        print(
            f"Warning: Proof file {PROOF_PATH} not found. Skipping calldata generation."
        )
