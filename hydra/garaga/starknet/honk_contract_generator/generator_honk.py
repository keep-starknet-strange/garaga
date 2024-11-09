import os
import subprocess
from pathlib import Path

from garaga.definitions import CurveID
from garaga.modulo_circuit_structs import G2Line, StructArray
from garaga.precompiled_circuits.compilable_circuits.ultra_honk import SumCheckCircuit
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


def gen_sumcheck_circuit_code(vk: HonkVk) -> str:
    """
    Generate the code for the sumcheck circuit.
    """
    header = """
use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, circuit_add, circuit_sub, circuit_mul, circuit_inverse,
    EvalCircuitTrait, CircuitOutputsTrait, CircuitModulus, AddInputResultTrait, CircuitInputs,
};
use garaga::core::circuit::AddInputResultTrait2;
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{
    get_a, get_b, get_p, get_g, get_min_one, G1Point, G2Point, u288, get_GRUMPKIN_modulus};
use core::option::Option;\n
"""
    code = header
    sumcheck_circuit = SumCheckCircuit(vk)
    function_name = f"{CurveID.GRUMPKIN.name}_{sumcheck_circuit.name.upper()}"

    sumcheck_code, function_name = sumcheck_circuit.circuit.compile_circuit(
        function_name=function_name, pub=True
    )
    code += sumcheck_code
    return code, function_name


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

    circuits_code, sumcheck_function_name = gen_sumcheck_circuit_code(vk)

    contract_code = f"""
use super::honk_verifier_constants::{{vk, precomputed_lines}};
use super::honk_verifier_circuits::{{{sumcheck_function_name}}};

#[starknet::interface]
trait IUltraKeccakHonkVerifier<TContractState> {{
    fn verify_ultra_keccak_honk(
        self: @TContractState,
        full_proof_with_hints: Span<felt252>,
    ) -> Option<Span<u256>>;
}}

#[starknet::contract]
mod UltraKeccakHonkVerifier {{
    use starknet::SyscallResultTrait;
    use garaga::definitions::{{G1Point, G1G2Pair}};
    use garaga::pairing_check::{{multi_pairing_check_bn254_2P_2F}};
    use garaga::ec_ops::{{G1PointTrait, ec_safe_add}};
    use garaga::ec_ops_g2::{{G2PointTrait}};
    use super::{{vk, precomputed_lines, {sumcheck_function_name}}};
    use garaga::utils::noir::{{HonkProof, remove_unused_variables_sumcheck_evaluations}};
    use garaga::utils::noir::keccak_transcript::HonkTranscriptTrait;
    use garaga::core::circuit::U64IntoU384;
    use core::num::traits::Zero;

    const ECIP_OPS_CLASS_HASH: felt252 = {hex(ecip_class_hash)};
    use starknet::ContractAddress;

    #[storage]
    struct Storage {{}}

    #[abi(embed_v0)]
    impl IUltraKeccakHonkVerifier of super::IUltraKeccakHonkVerifier<ContractState> {{
        fn verify_ultra_keccak_honk(
            self: @ContractState,
            full_proof_with_hints: Span<felt252>,
        ) -> Option<Span<u256>> {{
            // DO NOT EDIT THIS FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING.
            // This function returns an Option for the public inputs if the proof is valid.
            // If the proof is invalid, the execution will either fail or return None.
            // Read the documentation to learn how to generate the full_proof_with_hints array given a proof and a verifying key.
            let mut full_proof_with_hints = full_proof_with_hints;
            let proof = Serde::<HonkProof>::deserialize(ref full_proof_with_hints).expect('deserialization failed');
            // let mpcheck_hint = fph.mpcheck_hint;
            // let msm_hint = fph.msm_hint;



            // Perform the pairing check.
            // let check = multi_pairing_check_bn254_2P_2F(
            //    G1G2Pair {{ p: vk_x, q: vk.gamma_g2 }},
            //    G1G2Pair {{ p: groth16_proof.c, q: vk.delta_g2 }},
            //    precomputed_lines.span(),
            //    mpcheck_hint,
            //);

            let (transcript, base_rlc) = HonkTranscriptTrait::from_proof(proof);
            let log_n = vk.log_circuit_size;
            let (check_rlc, check) = {sumcheck_function_name}(
                p_public_inputs: proof.public_inputs,
                p_public_inputs_offset: proof.public_inputs_offset.into(),
                {', '.join([f'sumcheck_univariate_{i}: (*proof.sumcheck_univariates.at({i}))' for i in range(vk.log_circuit_size)])},
                sumcheck_evaluations: remove_unused_variables_sumcheck_evaluations(
                    proof.sumcheck_evaluations
                ),
                tp_sum_check_u_challenges: transcript.sum_check_u_challenges.span().slice(0, log_n),
                tp_gate_challenges: transcript.gate_challenges.span().slice(0, log_n),
                tp_eta_1: transcript.eta.into(),
                tp_eta_2: transcript.eta_two.into(),
                tp_eta_3: transcript.eta_three.into(),
                tp_beta: transcript.beta.into(),
                tp_gamma: transcript.gamma.into(),
                tp_base_rlc: base_rlc.into(),
                tp_alphas: transcript.alphas.span(),
            );



            if check.is_zero() && check_rlc.is_zero() {{
                return Option::Some(proof.public_inputs);
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

    with open(os.path.join(src_dir, "honk_verifier_circuits.cairo"), "w") as f:
        f.write(circuits_code)

    with open(os.path.join(src_dir, "honk_verifier.cairo"), "w") as f:
        f.write(contract_code)

    with open(os.path.join(output_folder_path, "Scarb.toml"), "w") as f:
        f.write(get_scarb_toml_file(output_folder_name, cli_mode))

    with open(os.path.join(src_dir, "lib.cairo"), "w") as f:
        f.write(
            """
mod honk_verifier;
mod honk_verifier_constants;
mod honk_verifier_circuits;
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
