import os
import subprocess

from hydra.definitions import CurveID, G1G2Pair, G1Point, G2Point
from hydra.modulo_circuit_structs import E12D, G2Line, StructArray
from hydra.precompiled_circuits.multi_miller_loop import (
    MultiMillerLoopCircuit,
    precompute_lines,
)
from tools.make.utils import create_directory
from tools.starknet.groth16_contract_generator.parsing_utils import (
    Groth16Proof,
    Groth16VerifyingKey,
)


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


def gen_groth16_verifier(vk_path: str, output_folder_path: str) -> str:
    vk = Groth16VerifyingKey.from_json(vk_path)
    curve_id = vk.curve_id
    precomputed_lines = precompute_lines_from_vk(vk)

    constants_code = f"""
    use garaga::definitions::{{G1Point, G2Point, E12D, G2Line, u384}};
    use garaga::groth16::Groth16VerifyingKey;

    pub const N_PUBLIC_INPUTS:usize = {len(vk.ic)};
    {vk.serialize_to_cairo()}
    pub const precomputed_lines: [G2Line; {len(precomputed_lines)//4}] = {precomputed_lines.serialize(raw=True, const=True)};
    """

    contract_code = f"""
use garaga::definitions::{{u384, u96, G1Point}};
use garaga::groth16::{{Groth16Proof}};
use super::groth16_verifier_constants::{{N_PUBLIC_INPUTS, vk, ic, precomputed_lines}};

#[starknet::interface]
trait IGroth16Verifier{curve_id.name}<TContractState> {{
    fn verify_groth16_proof(
        self: @TContractState,
        _groth16_proof: Span<felt252>,
        _mpcheck_hint: Span<felt252>,
        _small_Q_hint: Span<felt252>,
        _msm_hint: Span<felt252>,
        msm_scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
    ) -> bool;
}}

#[starknet::contract]
mod Groth16Verifier{curve_id.name} {{
    use garaga::definitions::{{u384, u96, G1Point, G1G2Pair, E12D, E12DMulQuotient}};
    use garaga::groth16::{{verify_groth16_{curve_id.name.lower()}, Groth16Proof, MPCheckHint{curve_id.name}}};
    use garaga::utils_calldata::{{
        parse_mp_check_hint_{curve_id.name.lower()}, parse_groth16_proof, parse_E12DMulQuotient, parse_msm_hint, MSMHint, DerivePointFromXHint
    }};
    use super::{{N_PUBLIC_INPUTS, vk, ic, precomputed_lines}};

    #[storage]
    struct Storage {{}}

    #[abi(embed_v0)]
    impl IGroth16Verifier{curve_id.name} of super::IGroth16Verifier{curve_id.name}<ContractState> {{
        fn verify_groth16_proof(
            self: @ContractState,
            _groth16_proof: Span<felt252>,
            _mpcheck_hint: Span<felt252>,
            _small_Q_hint: Span<felt252>,
            _msm_hint: Span<felt252>,
            msm_scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
        ) -> bool {{
            let groth16_proof: Box<Groth16Proof> = parse_groth16_proof(_groth16_proof, N_PUBLIC_INPUTS);
            let mpcheck_hint: Box<MPCheckHint{curve_id.name}> = parse_mp_check_hint_{curve_id.name.lower()}(_mpcheck_hint, {curve_id.value}, 1);
            let small_Q: Box<E12DMulQuotient> = parse_E12DMulQuotient(_small_Q_hint);
            let (
                public_inputs_msm_hint, public_inputs_derive_point_from_x_hint
            ): (Box<MSMHint>, Box<DerivePointFromXHint>) =
                parse_msm_hint(
                _msm_hint, N_PUBLIC_INPUTS
            );

            verify_groth16_{curve_id.name.lower()}(
                proof: groth16_proof.unbox(),
                verification_key: vk,
                lines: precomputed_lines.span(),
                ic: ic.span(),
                public_inputs_digits_decompositions: msm_scalars_digits_decompositions,
                public_inputs_msm_hint: public_inputs_msm_hint,
                public_inputs_msm_derive_point_from_x_hint: public_inputs_derive_point_from_x_hint,
                mpcheck_hint: mpcheck_hint,
                small_Q: small_Q,
            )
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
name = "groth16_example"
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

    VK_PATH = "tools/starknet/groth16_contract_generator/verifier_config.json"
    CONTRACTS_FOLDER = "src/cairo/contracts/"  # Do not change this

    FOLDER_NAME = "groth16_example"

    CONTRACTS_FOLDER = os.path.join(CONTRACTS_FOLDER, FOLDER_NAME)

    gen_groth16_verifier(VK_PATH, CONTRACTS_FOLDER)
