import concurrent.futures
import os
import subprocess
from pathlib import Path

from garaga.definitions import CurveID
from garaga.modulo_circuit_structs import G2Line, StructArray
from garaga.precompiled_circuits.multi_miller_loop import precompute_lines
from garaga.starknet.cli.utils import create_directory, get_package_version
from garaga.starknet.groth16_contract_generator.parsing_utils import Groth16VerifyingKey

ECIP_OPS_CLASS_HASH = 0x465991EC820CF53DBB2B27474B6663FB6F0C8BF3DAC7DB3991960214FAD97F5
CAIRO_VERSION = "2.11.4"


def precompute_lines_from_vk(vk: Groth16VerifyingKey) -> StructArray:

    # Precompute lines for fixed G2 points
    lines = precompute_lines([vk.gamma, vk.delta])
    precomputed_lines = StructArray(
        name="lines",
        elmts=[
            G2Line(name=f"line{i}", elmts=lines[i : i + 4])
            for i in range(0, len(lines), 4)
        ],
    )

    return precomputed_lines


def gen_groth16_verifier(
    vk: str | Path | Groth16VerifyingKey,
    output_folder_path: str,
    output_folder_name: str,
    ecip_class_hash: int = ECIP_OPS_CLASS_HASH,
    cli_mode: bool = False,
) -> str:
    if isinstance(vk, (Path, str)):
        vk = Groth16VerifyingKey.from_json(vk)
    else:
        vk = vk

    curve_id = vk.curve_id
    if cli_mode:
        output_folder_name = output_folder_name
    else:
        output_folder_name = output_folder_name + f"_{curve_id.name.lower()}"
    output_folder_path = os.path.join(output_folder_path, output_folder_name)

    precomputed_lines = precompute_lines_from_vk(vk)

    constants_code = f"""
    use garaga::definitions::{{G1Point, G2Point, E12D, G2Line, u384}};
    {f"use garaga::definitions::u288;" if curve_id!=CurveID.BLS12_381 else ""}
    use garaga::groth16::Groth16VerifyingKey;

    pub const N_PUBLIC_INPUTS:usize = {len(vk.ic)-1};
    {vk.serialize_to_cairo()}
    pub const precomputed_lines: [G2Line; {len(precomputed_lines)//4}] = {precomputed_lines.serialize(raw=True, const=True)};
    """
    contract_code = f"""
use super::groth16_verifier_constants::{{N_PUBLIC_INPUTS, vk, ic, precomputed_lines}};

#[starknet::interface]
trait IGroth16Verifier{curve_id.name}<TContractState> {{
    fn verify_groth16_proof_{curve_id.name.lower()}(
        self: @TContractState,
        full_proof_with_hints: Span<felt252>,
    ) -> Option<Span<u256>>;
}}

#[starknet::contract]
mod Groth16Verifier{curve_id.name} {{
    use starknet::SyscallResultTrait;
    use garaga::definitions::{{G1Point, G1G2Pair}};
    use garaga::groth16::{{multi_pairing_check_{curve_id.name.lower()}_3P_2F_with_extra_miller_loop_result}};
    use garaga::ec_ops::{{G1PointTrait, ec_safe_add}};
    use garaga::ec_ops_g2::{{G2PointTrait}};
    use garaga::utils::calldata::{{deserialize_full_proof_with_hints_{curve_id.name.lower()}}};
    use super::{{N_PUBLIC_INPUTS, vk, ic, precomputed_lines}};

    const ECIP_OPS_CLASS_HASH: felt252 = {hex(ecip_class_hash)};

    #[storage]
    struct Storage {{}}

    #[abi(embed_v0)]
    impl IGroth16Verifier{curve_id.name} of super::IGroth16Verifier{curve_id.name}<ContractState> {{
        fn verify_groth16_proof_{curve_id.name.lower()}(
            self: @ContractState,
            full_proof_with_hints: Span<felt252>,
        ) -> Option<Span<u256>> {{
            // DO NOT EDIT THIS FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING.
            // This function returns an Option for the public inputs if the proof is valid.
            // If the proof is invalid, the execution will either fail or return None.
            // Read the documentation to learn how to generate the full_proof_with_hints array given a proof and a verifying key.
            let fph = deserialize_full_proof_with_hints_{curve_id.name.lower()}(full_proof_with_hints);
            let groth16_proof = fph.groth16_proof;
            let mpcheck_hint = fph.mpcheck_hint;
            let small_Q = fph.small_Q;
            let msm_hint = fph.msm_hint;

            groth16_proof.a.assert_on_curve({curve_id.value});
            groth16_proof.b.assert_on_curve({curve_id.value});
            groth16_proof.c.assert_on_curve({curve_id.value});

            let ic = ic.span();

            let vk_x: G1Point = match ic.len() {{
                0 => panic!("Malformed VK"),
                1 => *ic.at(0),
                _ => {{
                    // Start serialization with the hint array directly to avoid copying it.
                    let mut msm_calldata: Array<felt252> = array![];
                    // Add the points from VK and public inputs to the proof.
                    Serde::serialize(@ic.slice(1, N_PUBLIC_INPUTS), ref msm_calldata);
                    Serde::serialize(@groth16_proof.public_inputs, ref msm_calldata);
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
                return Option::Some(groth16_proof.public_inputs);
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
        f.write(get_scarb_toml_file(output_folder_name, cli_mode))

    with open(os.path.join(src_dir, "lib.cairo"), "w") as f:
        f.write(
            """
mod groth16_verifier;
mod groth16_verifier_constants;
"""
        )
    subprocess.run(["scarb", "fmt", f"{output_folder_path}"], check=True)
    return constants_code


def get_scarb_toml_file(package_name: str, cli_mode: bool, inlining_level: int = 2):
    version = get_package_version()
    if version == "dev":
        suffix = ""
    else:
        suffix = ', tag = "v' + version + '"'
    if cli_mode:
        dep = 'git = "https://github.com/keep-starknet-strange/garaga.git"' + suffix
    else:
        dep = 'path = "../../../"'

    return f"""[package]
name = "{package_name}"
version = "0.1.0"
edition = "2024_07"

[dependencies]
garaga = {{ {dep} }}
starknet = "{CAIRO_VERSION}"

[cairo]
sierra-replace-ids = false
inlining-strategy = {inlining_level}

[dev-dependencies]
cairo_test = "{CAIRO_VERSION}"

[[target.starknet-contract]]
casm = true
casm-add-pythonic-hints = true
"""


if __name__ == "__main__":
    vk_paths = [
        "hydra/garaga/starknet/groth16_contract_generator/examples/vk_bn254.json",
        "hydra/garaga/starknet/groth16_contract_generator/examples/vk_bls.json",
    ]

    CONTRACTS_FOLDER = "src/contracts/autogenerated/"  # Do not change this

    FOLDER_NAME = "groth16_example"  # '_curve_id' is appended in the end.

    def _generate_verifier(vk_path):
        try:
            gen_groth16_verifier(
                vk_path, CONTRACTS_FOLDER, FOLDER_NAME, ECIP_OPS_CLASS_HASH
            )
        except Exception as e:
            print(f"An error occurred: {e}")

    with concurrent.futures.ProcessPoolExecutor(max_workers=2) as executor:
        executor.map(_generate_verifier, vk_paths)
