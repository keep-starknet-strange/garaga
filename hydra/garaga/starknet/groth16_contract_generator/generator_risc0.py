import os

from garaga.curves import ProofSystem
from garaga.modulo_circuit_structs import G1PointCircuit
from garaga.starknet.constants import RISC0_RELEASE_VERSION
from garaga.starknet.groth16_contract_generator.generator import (
    ECIP_OPS_CLASS_HASH,
    GeneratorConfig,
    Groth16VerifierGenerator,
    get_common_contract_imports,
    get_ecip_class_hash_const,
    get_msm_syscall_code,
    get_pairing_check_code,
    write_test_calldata_file_generic,
)
from garaga.starknet.groth16_contract_generator.parsing_utils import (
    RISC0_BN254_CONTROL_ID,
    RISC0_CONTROL_ROOT,
    Groth16Proof,
    Groth16VerifyingKey,
    split_digest,
)

PACKAGE_NAME = "risc0_verifier"


class Risc0VerifierGenerator(Groth16VerifierGenerator):
    """RISC0 Groth16 verifier with control root and control ID."""

    def __init__(self, config: GeneratorConfig, control_root: int, control_id: int):
        super().__init__(config)
        self.control_root = control_root
        self.control_id = control_id
        self.control_root_0, self.control_root_1 = split_digest(control_root)
        self.T = self._compute_T_point()

    def _compute_T_point(self) -> G1PointCircuit:
        """Precompute T = IC[0] + IC[1]*root_0 + IC[2]*root_1 + IC[5]*control_id."""
        vk = self.vk
        return G1PointCircuit.from_G1Point(
            name="T",
            point=(vk.ic[1].scalar_mul(self.control_root_0))
            .add(vk.ic[2].scalar_mul(self.control_root_1))
            .add(vk.ic[5].scalar_mul(self.control_id).add(vk.ic[0])),
        )

    @property
    def contract_name(self) -> str:
        return f"Risc0Groth16Verifier{self.curve_id.name}"

    @property
    def verification_function_name(self) -> str:
        return f"verify_r0_groth16_proof_{self.curve_id.name.lower()}"

    @property
    def proof_system(self) -> ProofSystem:
        return ProofSystem.Groth16

    def generate_constants_code(self) -> str:
        return f"""
    use garaga::definitions::{{G1Point, G2Point, E12D, G2Line, u384, u288}};
    use garaga::groth16::Groth16VerifyingKey;

    pub const N_FREE_PUBLIC_INPUTS:usize = 2;
    // RISC0 version tag : {RISC0_RELEASE_VERSION}
    // CONTROL ROOT USED : {hex(self.control_root)}
    // \t CONTROL_ROOT_0 : {hex(self.control_root_0)}
    // \t CONTROL_ROOT_1 : {hex(self.control_root_1)}
    // BN254 CONTROL ID USED : {hex(self.control_id)}
    pub const T: G1Point = {self.T.serialize(raw=True)}; // IC[0] + IC[1] * CONTROL_ROOT_0 + IC[2] * CONTROL_ROOT_1 + IC[5] * BN254_CONTROL_ID
    {self.vk.serialize_to_cairo()}
    {self.get_precomputed_lines_const()}
    """

    def generate_contract_code(self) -> str:
        curve_id = self.curve_id
        ecip_class_hash = self.config.ecip_class_hash
        return f"""
use super::groth16_verifier_constants::{{N_FREE_PUBLIC_INPUTS, vk, ic, precomputed_lines, T}};

#[starknet::interface]
pub trait IRisc0Groth16Verifier{curve_id.name}<TContractState> {{
    fn {self.verification_function_name}(
        self: @TContractState,
        full_proof_with_hints: Span<felt252>,
    ) -> Result<Span<u8>, felt252>;
}}

#[starknet::contract]
mod Risc0Groth16Verifier{curve_id.name} {{
{get_common_contract_imports(curve_id)}
    use garaga::apps::risc0::{{compute_receipt_claim, journal_sha256, deserialize_full_proof_with_hints_risc0}};
    use super::{{N_FREE_PUBLIC_INPUTS, vk, ic, precomputed_lines, T}};

{get_ecip_class_hash_const(ecip_class_hash)}

    #[storage]
    struct Storage {{}}

    #[abi(embed_v0)]
    impl IRisc0Groth16Verifier{curve_id.name} of super::IRisc0Groth16Verifier{curve_id.name}<ContractState> {{
        fn {self.verification_function_name}(
            self: @ContractState,
            full_proof_with_hints: Span<felt252>,
        ) -> Result<Span<u8>, felt252> {{
            // DO NOT EDIT THIS FUNCTION UNLESS YOU KNOW WHAT YOU ARE DOING.
            // This function returns Result::Ok(public_inputs) if the proof is valid.
            // If the proof is invalid, it returns Result::Err(error).
            // Read the documentation to learn how to generate the full_proof_with_hints array given a proof and a verifying key.

            let fph = deserialize_full_proof_with_hints_risc0(full_proof_with_hints);

            let groth16_proof = fph.groth16_proof;
            let image_id = fph.image_id;
            let journal = fph.journal;
            let mpcheck_hint = fph.mpcheck_hint;
            let msm_hint = fph.msm_hint;

            groth16_proof.check_proof_points({curve_id.value});

            let ic = ic.span();

            let journal_digest = journal_sha256(journal);
            let claim_digest = compute_receipt_claim(image_id, journal_digest);

            // Start serialization with the hint array directly to avoid copying it.
            let mut msm_calldata: Array<felt252> = array![];
            // Add the points from VK relative to the non-constant public inputs.
            Serde::serialize(@ic.slice(3, N_FREE_PUBLIC_INPUTS), ref msm_calldata);
            // Add the claim digest as u256 scalars for the msm.
            msm_calldata.append(2);
            msm_calldata.append(claim_digest.low.into());
            msm_calldata.append(0);
            msm_calldata.append(claim_digest.high.into());
            msm_calldata.append(0);
            // Complete with the curve indentifier ({curve_id.value} for {curve_id.name}):
            msm_calldata.append({curve_id.value});
            // Add the hint array.
            for x in msm_hint {{
                msm_calldata.append(*x);
            }}

            // Call the multi scalar multiplication endpoint on the Garaga ECIP ops contract
            // to obtain claim0 * IC[3] + claim1 * IC[4].
{get_msm_syscall_code()}
            // Finalize vk_x computation by adding the precomputed T point.
            let vk_x = ec_safe_add(
                T, Serde::<G1Point>::deserialize(ref _msm_result_serialized).unwrap(), {curve_id.value}
            );

            // Perform the pairing check.
{get_pairing_check_code(curve_id)}
            match check {{
                Result::Ok(_) => Result::Ok(journal),
                Result::Err(error) => Result::Err(error),
            }}
        }}
    }}
}}
    """


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

    config = GeneratorConfig(
        vk=vk,
        output_folder_path=output_folder_path,
        output_folder_name=output_folder_name,
        ecip_class_hash=ecip_class_hash,
        cli_mode=cli_mode,
    )
    generator = Risc0VerifierGenerator(config, control_root, control_id)
    return generator.generate()


if __name__ == "__main__":
    pass

    RISCO_VK_PATH = (
        "hydra/garaga/starknet/groth16_contract_generator/examples/vk_risc0.json"
    )
    PROOF_PATH = (
        "hydra/garaga/starknet/groth16_contract_generator/examples/proof_risc0.json"
    )

    CONTRACTS_FOLDER = "src/contracts/autogenerated/"  # Do not change this

    FOLDER_NAME = "risc0_verifier"  # '_curve_id' is appended in the end.

    gen_risc0_groth16_verifier(
        RISCO_VK_PATH, CONTRACTS_FOLDER, FOLDER_NAME, ECIP_OPS_CLASS_HASH
    )

    vk = Groth16VerifyingKey.from_json(file_path=RISCO_VK_PATH)
    proof = Groth16Proof.from_json(proof_path=PROOF_PATH)

    # Generate the calldata and write test calldata file:
    output_folder_path = os.path.join(
        CONTRACTS_FOLDER, f"{FOLDER_NAME}_{vk.curve_id.name.lower()}"
    )
    write_test_calldata_file_generic(
        output_folder_path,
        system=ProofSystem.Groth16,  # RISC0 uses Groth16
        vk_path=RISCO_VK_PATH,
        proof_path=PROOF_PATH,
    )
