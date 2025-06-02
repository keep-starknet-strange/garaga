from garaga import garaga_rs
from garaga.definitions import G1G2Pair, G1Point
from garaga.starknet.groth16_contract_generator.parsing_utils import (
    Groth16Proof,
    Groth16VerifyingKey,
)
from garaga.starknet.tests_and_calldata_generators.mpcheck import MPCheckCalldataBuilder
from garaga.starknet.tests_and_calldata_generators.msm import MSMCalldataBuilder


def groth16_calldata_from_vk_and_proof(
    vk: Groth16VerifyingKey, proof: Groth16Proof, use_rust: bool = False
) -> list[int]:
    if use_rust:
        return _groth16_calldata_from_vk_and_proof_rust(vk, proof)

    assert (
        vk.curve_id == proof.curve_id
    ), f"Curve ID mismatch: {vk.curve_id} != {proof.curve_id}"

    vk_x = vk.ic[0].add(G1Point.msm(vk.ic[1:], proof.public_inputs))

    calldata = []

    mpc = MPCheckCalldataBuilder(
        vk.curve_id,
        pairs=[
            G1G2Pair(p=vk_x, q=vk.gamma, curve_id=vk.curve_id),
            G1G2Pair(p=proof.c, q=vk.delta, curve_id=vk.curve_id),
            G1G2Pair(p=-proof.a, q=proof.b, curve_id=vk.curve_id),
        ],
        n_fixed_g2=2,
        public_pair=G1G2Pair(vk.alpha, vk.beta, vk.curve_id),
    )

    calldata.extend(proof.serialize_to_calldata())
    calldata.extend(mpc.serialize_to_calldata())

    if proof.image_id and proof.journal:
        # Risc0 mode.
        print("Risc0 mode")
        msm = MSMCalldataBuilder(
            curve_id=vk.curve_id,
            points=[vk.ic[3], vk.ic[4]],
            scalars=[proof.public_inputs[2], proof.public_inputs[3]],
        )
        calldata.extend(
            msm.serialize_to_calldata(
                include_points_and_scalars=False,
                serialize_as_pure_felt252_array=True,
            )
        )
    else:
        msm = MSMCalldataBuilder(
            curve_id=vk.curve_id,
            points=vk.ic[1:],
            scalars=proof.public_inputs,
        )

        calldata.extend(
            msm.serialize_to_calldata(
                include_points_and_scalars=False,
                serialize_as_pure_felt252_array=True,
            )
        )

    # return calldata
    return [len(calldata)] + calldata


def _groth16_calldata_from_vk_and_proof_rust(
    vk: Groth16VerifyingKey, proof: Groth16Proof
) -> list[int]:
    assert (
        vk.curve_id == proof.curve_id
    ), f"Curve ID mismatch: {vk.curve_id} != {proof.curve_id}"

    # Determine vkey for SP1 proofs - it's embedded in public_inputs[0]
    vkey = None
    if proof.public_inputs_sp1 is not None:
        # For SP1 proofs, the vkey is stored as public_inputs[0] as a big integer
        # We need to convert it back to bytes (32 bytes, big endian)
        vkey_int = proof.public_inputs[0]
        vkey = vkey_int.to_bytes(32, byteorder="big")

    return garaga_rs.get_groth16_calldata(
        proof.flatten(),
        vk.flatten(),
        proof.curve_id.value,
        proof.image_id,
        proof.journal,
        proof.public_inputs_sp1,
        vkey,
    )


if __name__ == "__main__":
    VK_PATH = "hydra/garaga/starknet/groth16_contract_generator/examples/snarkjs_vk_bn254.json"
    PROOF_PATH = "hydra/garaga/starknet/groth16_contract_generator/examples/snarkjs_proof_bn254.json"
    PUBLIC_INPUTS_PATH = "hydra/garaga/starknet/groth16_contract_generator/examples/snarkjs_public_bn254.json"

    vk = Groth16VerifyingKey.from_json(file_path=VK_PATH)
    proof = Groth16Proof.from_json(
        proof_path=PROOF_PATH, public_inputs_path=PUBLIC_INPUTS_PATH
    )

    calldata = groth16_calldata_from_vk_and_proof(vk, proof)

    print(calldata)
    print(len(calldata))
