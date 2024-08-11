from hydra.definitions import G1G2Pair, G1Point, G2Point
from tools.starknet.groth16_contract_generator.parsing_utils import (
    Groth16Proof,
    Groth16VerifyingKey,
)
from tools.starknet.tests_and_calldata_generators.mpcheck import MPCheckCalldataBuilder
from tools.starknet.tests_and_calldata_generators.msm import MSMCalldataBuilder


def groth16_calldata_from_vk_and_proof(
    vk: Groth16VerifyingKey, proof: Groth16Proof
) -> list[int]:
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

    msm = MSMCalldataBuilder(
        curve_id=vk.curve_id,
        points=vk.ic[1:],
        scalars=proof.public_inputs,
    )

    calldata.extend(proof.serialize_to_calldata())
    calldata.extend(mpc.serialize_to_calldata())
    calldata.extend(msm.serialize_to_calldata(include_points_and_scalars=False))

    return calldata


if __name__ == "__main__":
    VK_PATH = "tools/starknet/groth16_contract_generator/examples/vk_bls.json"
    PROOF_PATH = "tools/starknet/groth16_contract_generator/examples/proof_bls.json"
    vk = Groth16VerifyingKey.from_json(VK_PATH)
    proof = Groth16Proof.from_json(PROOF_PATH)

    calldata = groth16_calldata_from_vk_and_proof(vk, proof)

    print(calldata)
    print(len(calldata))
