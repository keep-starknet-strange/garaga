import os
import subprocess
from enum import Enum

from garaga.definitions import CurveID, G1G2Pair, G1Point, G2Point
from garaga.hints.io import split_128
from garaga.modulo_circuit_structs import E12D, G1PointCircuit, G2Line, StructArray
from garaga.precompiled_circuits.multi_miller_loop import (
    MultiMillerLoopCircuit,
    precompute_lines,
)
from garaga.starknet.groth16_contract_generator.generator import (
    ECIP_OPS_CLASS_HASH,
    precompute_lines_from_vk,
)
from garaga.starknet.groth16_contract_generator.parsing_utils import (
    Groth16Proof,
    Groth16VerifyingKey,
)
from garaga.starknet.starknet_cli import create_directory


def reverse_byte_order_uint256(value: int) -> int:
    return int.from_bytes(value.to_bytes(32, byteorder="big")[::-1], byteorder="big")


def split_digest(digest: int):
    reversed_digest = reverse_byte_order_uint256(digest)
    return split_128(reversed_digest)


# https://github.com/risc0/risc0-ethereum/blob/7a0984e4b602b96920752392d1929ec135691be8/contracts/src/groth16/ControlID.sol#L22-L26
# Those are two constant public inputs corresponding to IC[1], IC[2], IC[5].
# https://github.com/risc0/risc0-ethereum/blob/ebec385cc526adb9279c1af55d699c645ca6d694/contracts/src/groth16/RiscZeroGroth16Verifier.sol#L165-L172


CONTROL_ROOT = 0x9A3767040E4CF554112AFA68BC043274A8636A06565E1D5E2B7FA90FDA941218

CONTROL_ROOT_0, CONTROL_ROOT_1 = split_digest(CONTROL_ROOT)
BN254_CONTROL_ID = 0x05A022E1DB38457FB510BC347B30EB8F8CF3EDA95587653D0EAC19E1F10D164E


def gen_risc0_groth16_verifier(
    vk_path: str,
    output_folder_path: str,
    output_folder_name: str,
    ecip_class_hash: ECIP_OPS_CLASS_HASH,
) -> str:
    vk = Groth16VerifyingKey.from_json(vk_path)
    curve_id = vk.curve_id
    output_folder_name = output_folder_name + f"_{curve_id.name.lower()}"
    output_folder_path = os.path.join(output_folder_path, output_folder_name)

    precomputed_lines = precompute_lines_from_vk(vk)

    T = G1PointCircuit.from_G1Point(
        name="T",
        point=(vk.ic[1].scalar_mul(CONTROL_ROOT_0))
        .add(vk.ic[2].scalar_mul(CONTROL_ROOT_1))
        .add(vk.ic[5].scalar_mul(BN254_CONTROL_ID).add(vk.ic[0])),
    )

    constants_code = f"""
    use garaga::definitions::{{G1Point, G2Point, E12D, G2Line, u384}};
    use garaga::groth16::Groth16VerifyingKey;

    pub const N_PUBLIC_INPUTS:usize = 2;
    pub const T: G1Point = {T.serialize(raw=True)}; // IC[0] + IC[1] * CONTROL_ROOT_0 + IC[2] * CONTROL_ROOT_1 + IC[5] * BN254_CONTROL_ID
    {vk.serialize_to_cairo()}
    pub const precomputed_lines: [G2Line; {len(precomputed_lines)//4}] = {precomputed_lines.serialize(raw=True, const=True)};
    """

    contract_code = f"""
use garaga::definitions::E12DMulQuotient;
use garaga::groth16::{{Groth16Proof, MPCheckHint{curve_id.name}}};
use super::groth16_verifier_constants::{{N_PUBLIC_INPUTS, vk, ic, precomputed_lines, T}};

#[starknet::interface]
trait IGroth16Verifier{curve_id.name}<TContractState> {{
    fn verify_groth16_proof_{curve_id.name.lower()}(
        ref self: TContractState,
        groth16_proof: Groth16Proof,
        mpcheck_hint: MPCheckHint{curve_id.name},
        small_Q: E12DMulQuotient,
        msm_hint: Array<felt252>,
    ) -> bool;
}}

#[starknet::contract]
mod Groth16Verifier{curve_id.name} {{
    use starknet::SyscallResultTrait;
    use garaga::definitions::{{G1Point, G1G2Pair, E12DMulQuotient}};
    use garaga::groth16::{{multi_pairing_check_{curve_id.name.lower()}_3P_2F_with_extra_miller_loop_result, Groth16Proof, MPCheckHint{curve_id.name}}};
    use garaga::ec_ops::{{G1PointTrait, G2PointTrait, ec_safe_add}};
    use super::{{N_PUBLIC_INPUTS, vk, ic, precomputed_lines, T}};

    const ECIP_OPS_CLASS_HASH: felt252 = {hex(ecip_class_hash.value)};
    use starknet::ContractAddress;

    #[storage]
    struct Storage {{}}

    #[abi(embed_v0)]
    impl IGroth16Verifier{curve_id.name} of super::IGroth16Verifier{curve_id.name}<ContractState> {{
        fn verify_groth16_proof_{curve_id.name.lower()}(
            ref self: ContractState,
            groth16_proof: Groth16Proof,
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

            // Start serialization with the hint array directly to avoid copying it.
            let mut msm_calldata: Array<felt252> = msm_hint;
            // Add the points from VK the and public inputs to the proof.
            Serde::serialize(@ic.slice(3, N_PUBLIC_INPUTS), ref msm_calldata);
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

            let vk_x = ec_safe_add(
                T, Serde::<G1Point>::deserialize(ref _vx_x_serialized).unwrap(), {curve_id.value}
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
                        starknet::get_caller_address(), groth16_proof.public_inputs
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
            ref self: ContractState, user: ContractAddress, public_inputs: Span<u256>,
        ) {{ // Process the public inputs with respect to the caller address (user).
        // Update the storage, emit events, call other contracts, etc.
            let _claim_0 = public_inputs.at(0);
            let _claim_1 = public_inputs.at(1);
            let _claim : u256 = u256{{low: _claim_0, high: _claim_1}};
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
        f.write(
            f"""
[package]
name = "risc0_bn254_verifier"
version = "0.1.0"
edition = "2024_07"

[dependencies]
garaga = {{ path = "../../" }}
starknet = "2.7.0"

[cairo]
sierra-replace-ids = false

[[target.starknet-contract]]
casm = true
casm-add-pythonic-hints = true
"""
        )

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

    RISCO_VK_PATH = (
        "hydra/garaga/starknet/groth16_contract_generator/examples/vk_risc0.json"
    )

    CONTRACTS_FOLDER = "src/cairo/contracts/"  # Do not change this

    FOLDER_NAME = "risc0_verifier"  # '_curve_id' is appended in the end.

    gen_risc0_groth16_verifier(
        RISCO_VK_PATH, CONTRACTS_FOLDER, FOLDER_NAME, ECIP_OPS_CLASS_HASH.SEPOLIA
    )
