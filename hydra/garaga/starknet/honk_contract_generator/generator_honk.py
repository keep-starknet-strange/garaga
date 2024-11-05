import os
import subprocess
from pathlib import Path

from garaga.definitions import CurveID
from garaga.modulo_circuit_structs import G2Line, StructArray
from garaga.precompiled_circuits.honk_new import G2_POINT_KZG_1, G2_POINT_KZG_2, HonkVk
from garaga.precompiled_circuits.multi_miller_loop import precompute_lines
from garaga.starknet.cli.utils import create_directory
from garaga.starknet.groth16_contract_generator.generator import (
    ECIP_OPS_CLASS_HASH,
    get_scarb_toml_file,
)


def precompute_lines_honk() -> StructArray:

    # Precompute lines for fixed G2 points
    lines = precompute_lines([G2_POINT_KZG_1, G2_POINT_KZG_2])
    precomputed_lines = StructArray(
        name="lines",
        elmts=[
            G2Line(name=f"line{i}", elmts=lines[i : i + 4])
            for i in range(0, len(lines), 4)
        ],
    )

    return precomputed_lines


def gen_honk_verifier(
    vk: str | Path | HonkVk | bytes,
    output_folder_path: str,
    output_folder_name: str,
    ecip_class_hash: int = ECIP_OPS_CLASS_HASH,
    cli_mode: bool = False,
) -> str:
    if isinstance(vk, (Path, str)):
        vk = HonkVk.from_bytes(open(vk, "rb").read())
    elif isinstance(vk, bytes):
        vk = HonkVk.from_bytes(vk)
    else:
        assert isinstance(
            vk, HonkVk
        ), f"Invalid type for vk: {type(vk)}. Should be str, Path, HonkVk or bytes."

    curve_id = CurveID.GRUMPKIN

    output_folder_path = os.path.join(output_folder_path, output_folder_name)

    precomputed_lines = precompute_lines_honk()

    constants_code = f"""
    use garaga::definitions::{{G1Point, G2Point, G2Line, u384, u288}};
    use garaga::utils::noir::HonkVk;

    {vk.serialize_to_cairo()}\n
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
    use starknet::ContractAddress;

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
                    let mut msm_calldata: Array<felt252> = msm_hint;
                    // Add the points from VK and public inputs to the proof.
                    Serde::serialize(@ic.slice(1, N_PUBLIC_INPUTS), ref msm_calldata);
                    Serde::serialize(@groth16_proof.public_inputs, ref msm_calldata);
                    // Complete with the curve indentifier ({curve_id.value} for {curve_id.name}):
                    msm_calldata.append({curve_id.value});

                    // Call the multi scalar multiplication endpoint on the Garaga ECIP ops contract
                    // to obtain vk_x.
                    let mut _vx_x_serialized = core::starknet::syscalls::library_call_syscall(
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

    with open(os.path.join(output_folder_path, ".tools-versions"), "w") as f:
        f.write("scarb 2.8.4\n")

    with open(os.path.join(src_dir, "honk_verifier_constants.cairo"), "w") as f:
        f.write(constants_code)

    # with open(os.path.join(src_dir, "groth16_verifier.cairo"), "w") as f:
    #     f.write(contract_code)

    with open(os.path.join(output_folder_path, "Scarb.toml"), "w") as f:
        f.write(get_scarb_toml_file(output_folder_name, cli_mode))

    with open(os.path.join(src_dir, "lib.cairo"), "w") as f:
        f.write(
            """
// mod honk_verifier;
mod honk_verifier_constants;
"""
        )
    subprocess.run(["scarb", "fmt"], check=True, cwd=output_folder_path)
    return constants_code


if __name__ == "__main__":

    VK_PATH = (
        "hydra/garaga/starknet/honk_contract_generator/examples/vk_ultra_keccak.bin"
    )

    CONTRACTS_FOLDER = "src/contracts/"  # Do not change this

    FOLDER_NAME = (
        "noir_ultra_keccak_honk_example"  # '_curve_id' is appended in the end.
    )

    gen_honk_verifier(VK_PATH, CONTRACTS_FOLDER, FOLDER_NAME, ECIP_OPS_CLASS_HASH)
