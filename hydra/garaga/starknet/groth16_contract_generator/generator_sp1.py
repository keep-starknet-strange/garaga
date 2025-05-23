import os
import subprocess

from garaga.starknet.cli.utils import create_directory
from garaga.starknet.groth16_contract_generator.generator import (
    CAIRO_VERSION,
    ECIP_OPS_CLASS_HASH,
    get_scarb_toml_file,
    precompute_lines_from_vk,
)
from garaga.starknet.groth16_contract_generator.parsing_utils import Groth16VerifyingKey


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

    constants_code = f"""
    use garaga::definitions::{{G1Point, G2Point, E12D, G2Line, u384, u288}};
    use garaga::groth16::Groth16VerifyingKey;

    pub const N_PUBLIC_INPUTS:usize = {len(vk.ic)-1};
    {vk.serialize_to_cairo()}
    pub const precomputed_lines: [G2Line; {len(precomputed_lines)//4}] = {precomputed_lines.serialize(raw=True, const=True)};
    """

    contract_code = f"""
use super::groth16_verifier_constants::{{vk, ic, precomputed_lines, N_PUBLIC_INPUTS}};

#[starknet::interface]
trait ISP1Groth16Verifier{curve_id.name}<TContractState> {{
    fn verify_sp1_groth16_proof_{curve_id.name.lower()}(
        self: @TContractState,
        full_proof_with_hints: Span<felt252>,
    ) -> Option<(u256, Span<u256>)>;
}}

#[starknet::contract]
mod SP1Groth16Verifier{curve_id.name} {{
    use starknet::SyscallResultTrait;
    use garaga::definitions::{{G1Point, G1G2Pair}};
    use garaga::groth16::{{multi_pairing_check_{curve_id.name.lower()}_3P_2F_with_extra_miller_loop_result}};
    use garaga::ec_ops::{{G1PointTrait, ec_safe_add}};
    use garaga::ec_ops_g2::{{G2PointTrait}};
    use garaga::utils::calldata::deserialize_full_proof_with_hints_sp1;
    use garaga::utils::sp1::process_public_inputs_sp1;
    use super::{{vk, ic, precomputed_lines, N_PUBLIC_INPUTS}};

    const ECIP_OPS_CLASS_HASH: felt252 = {hex(ecip_class_hash)};

    #[storage]
    struct Storage {{}}

    #[abi(embed_v0)]
    impl ISP1Groth16Verifier{curve_id.name} of super::ISP1Groth16Verifier{curve_id.name}<ContractState> {{
        fn verify_sp1_groth16_proof_{curve_id.name.lower()}(
            self: @ContractState,
            full_proof_with_hints: Span<felt252>,
        ) -> Option<(u256, Span<u256>)> {{
            // DO NOT EDIT THIS FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING.
            // This function returns an Option for the SP1 verifying key and public inputs if the proof is valid.
            // If the proof is invalid, the execution will either fail or return None.
            // Read the documentation to learn how to generate the full_proof_with_hints array given a proof and a verifying key.


            let fph = deserialize_full_proof_with_hints_sp1(full_proof_with_hints);
            let groth16_proof = fph.groth16_proof;
            let vkey = fph.vkey;
            let public_inputs_sp1 = fph.public_inputs_sp1;
            let mpcheck_hint = fph.mpcheck_hint;
            let small_Q = fph.small_Q;
            let msm_hint = fph.msm_hint;

            groth16_proof.a.assert_on_curve({curve_id.value});
            groth16_proof.b.assert_on_curve({curve_id.value});
            groth16_proof.c.assert_on_curve({curve_id.value});

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
                small_Q
            );
            if check == true {{
                return Option::Some((vkey, pub_inputs_256));
            }} else {{
                return Option::None;
            }}
        }}
    }}
}}
    """

    create_directory(output_folder_path)
    src_dir = os.path.join(output_folder_path, "src")
    create_directory(src_dir)

    with open(os.path.join(output_folder_path, ".tool-versions"), "w") as f:
        f.write(f"scarb {CAIRO_VERSION}\n")

    with open(os.path.join(src_dir, "groth16_verifier_constants.cairo"), "w") as f:
        f.write(constants_code)

    with open(os.path.join(src_dir, "groth16_verifier.cairo"), "w") as f:
        f.write(contract_code)

    with open(os.path.join(output_folder_path, "Scarb.toml"), "w") as f:
        f.write(get_scarb_toml_file("sp1_verifier_bn254", cli_mode=cli_mode))

    with open(os.path.join(src_dir, "lib.cairo"), "w") as f:
        f.write(
            f"""
mod groth16_verifier;
mod groth16_verifier_constants;
"""
        )
    subprocess.run(["scarb", "fmt", f"{output_folder_path}"], check=True)
    return constants_code


if __name__ == "__main__":
    pass

    SP1_VK_PATH = (
        "hydra/garaga/starknet/groth16_contract_generator/examples/vk_sp1.json"
    )

    CONTRACTS_FOLDER = "src/contracts/autogenerated/"  # Do not change this

    FOLDER_NAME = "sp1_verifier"  # '_curve_id' is appended in the end.

    gen_sp1_groth16_verifier(
        SP1_VK_PATH, CONTRACTS_FOLDER, FOLDER_NAME, ECIP_OPS_CLASS_HASH
    )
