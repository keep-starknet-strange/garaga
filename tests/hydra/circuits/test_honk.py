import pytest

import garaga.hints.io as io
from garaga.curves import ProofSystem
from garaga.hints.keccak256 import keccak_256
from garaga.points import G1G2Pair
from garaga.precompiled_circuits.zk_honk import (
    CURVES,
    G2_POINT_KZG_1,
    G2_POINT_KZG_2,
    CurveID,
    G1Point,
    HonkVk,
    ZKHonkProof,
    ZKHonkTranscript,
    ZKHonkVerifierCircuits,
    get_msm_points_from_vk_and_proof,
    honk_proof_from_bytes,
)

PATH = "hydra/garaga/starknet/honk_contract_generator/examples"


def convert_pairing_points_to_g1(
    pairing_point_object: list[int],
) -> tuple[G1Point, G1Point]:
    """Convert the 16 field element pairing point object to two G1 points (lhs, rhs).

    Each point is encoded as 4 68-bit limbs for x and 4 68-bit limbs for y.
    """

    def decode_coord(limbs):
        return limbs[0] | (limbs[1] << 68) | (limbs[2] << 136) | (limbs[3] << 204)

    lhs_x = decode_coord(pairing_point_object[0:4])
    lhs_y = decode_coord(pairing_point_object[4:8])
    rhs_x = decode_coord(pairing_point_object[8:12])
    rhs_y = decode_coord(pairing_point_object[12:16])

    lhs = G1Point(x=lhs_x, y=lhs_y, curve_id=CurveID.BN254)
    rhs = G1Point(x=rhs_x, y=rhs_y, curve_id=CurveID.BN254)

    return lhs, rhs


def generate_recursion_separator(
    pairing_point_object: list[int], acc_lhs: G1Point, acc_rhs: G1Point
) -> int:
    """Generate the recursion separator by hashing the proof and accumulator points.

    Matches Solidity's generateRecursionSeparator function.
    """
    proof_lhs, proof_rhs = convert_pairing_points_to_g1(pairing_point_object)

    # Hash 8 uint256 values: proofLhs.x, proofLhs.y, proofRhs.x, proofRhs.y, accLhs.x, accLhs.y, accRhs.x, accRhs.y
    data = b""
    data += proof_lhs.x.to_bytes(32, "big")
    data += proof_lhs.y.to_bytes(32, "big")
    data += proof_rhs.x.to_bytes(32, "big")
    data += proof_rhs.y.to_bytes(32, "big")
    data += acc_lhs.x.to_bytes(32, "big")
    data += acc_lhs.y.to_bytes(32, "big")
    data += acc_rhs.x.to_bytes(32, "big")
    data += acc_rhs.y.to_bytes(32, "big")

    hash_result = keccak_256(data).digest()
    # Convert to field element (mod p)
    FR = CURVES[CurveID.GRUMPKIN.value].p
    return int.from_bytes(hash_result, "big") % FR


@pytest.mark.parametrize(
    "proof_path, system",
    [
        (f"{PATH}/proof_ultra_keccak_zk.bin", ProofSystem.UltraKeccakZKHonk),
    ],
)
def test_verify_honk_proof(proof_path: str, system: ProofSystem):

    vk: HonkVk = HonkVk.from_bytes(open(f"{PATH}/vk_ultra_keccak.bin", "rb").read())

    proof: ZKHonkProof = honk_proof_from_bytes(
        open(proof_path, "rb").read(),
        open(f"{PATH}/public_inputs_ultra_keccak.bin", "rb").read(),
        vk,
        system,
    )

    tp = ZKHonkTranscript.from_proof(vk, proof, system)
    circuit: ZKHonkVerifierCircuits = ZKHonkVerifierCircuits(
        name="test", log_n=vk.log_circuit_size
    )

    vk_circuit = vk.to_circuit_elements(circuit)
    proof_circuit = proof.to_circuit_elements(circuit)
    tp = tp.to_circuit_elements(circuit)

    public_input_delta = circuit.compute_public_input_delta(
        public_inputs=proof_circuit.public_inputs,
        pairing_point_object=proof_circuit.pairing_point_object,
        beta=tp.beta,
        gamma=tp.gamma,
    )

    vanishing_check, diff_check = circuit.check_evals_consistency(
        proof_circuit.libra_evaluation,
        proof_circuit.libra_poly_evals,
        tp.gemini_r,
        tp.sum_check_u_challenges,
    )
    assert vanishing_check.value != 0
    assert diff_check.value == 0

    rlc_check, check = circuit.verify_sum_check(
        libra_sum=proof_circuit.libra_sum,
        sumcheck_univariates=proof_circuit.sumcheck_univariates,
        sumcheck_evaluations=(proof_circuit.sumcheck_evaluations),
        libra_evaluation=proof_circuit.libra_evaluation,
        beta=tp.beta,
        gamma=tp.gamma,
        public_inputs_delta=public_input_delta,
        eta=tp.eta,
        eta_two=tp.etaTwo,
        eta_three=tp.etaThree,
        libra_challenge=tp.libra_challenge,
        sum_check_u_challenges=tp.sum_check_u_challenges,
        gate_challenge=tp.gate_challenge,
        alpha=tp.alpha,
        log_n=vk.log_circuit_size,
        base_rlc=circuit.write_element(1234),
    )

    assert rlc_check.value == 0
    assert check.value == 0

    print(f"Pub input delta: {io.int_to_u384(public_input_delta, as_hex=False)}")

    scalars = circuit.compute_shplemini_msm_scalars(
        proof_circuit.sumcheck_evaluations,
        proof_circuit.gemini_masking_eval,
        proof_circuit.gemini_a_evaluations,
        proof_circuit.libra_poly_evals,
        tp.gemini_r,
        tp.rho,
        tp.shplonk_z,
        tp.shplonk_nu,
        tp.sum_check_u_challenges,
    )

    print([scalar.value if scalar else scalar for scalar in scalars])
    print(len(scalars))

    points = get_msm_points_from_vk_and_proof(vk, proof)

    for i, (p, s) in enumerate(zip(points, scalars)):
        if s:
            print(i, hex(s.value))

    P_0 = G1Point.msm(points=points, scalars=[scalar.value for scalar in scalars])

    P_1 = -proof.kzg_quotient

    # Extract the points from pairing_point_object
    P_0_other, P_1_other = convert_pairing_points_to_g1(proof.pairing_point_object)
    print(f"P_0_other: x={hex(P_0_other.x)}, y={hex(P_0_other.y)}")
    print(f"P_1_other: x={hex(P_1_other.x)}, y={hex(P_1_other.y)}")

    # Generate recursion separator
    recursion_separator = generate_recursion_separator(
        proof.pairing_point_object, P_0, P_1
    )
    print(f"Recursion separator: {hex(recursion_separator)}")

    # Aggregate: P_0_final = recursionSeparator * P_0 + P_0_other
    #            P_1_final = recursionSeparator * P_1 + P_1_other
    P_0_final = P_0.scalar_mul(recursion_separator).add(P_0_other)
    P_1_final = P_1.scalar_mul(recursion_separator).add(P_1_other)

    print(f"P_0_final: x={hex(P_0_final.x)}, y={hex(P_0_final.y)}")
    print(f"P_1_final: x={hex(P_1_final.x)}, y={hex(P_1_final.y)}")

    # Final pairing check with aggregated points
    pairs = [G1G2Pair(P_0_final, G2_POINT_KZG_1), G1G2Pair(P_1_final, G2_POINT_KZG_2)]
    pairing_result = G1G2Pair.pair(pairs).value_coeffs
    print(f"Pairing result WITH recursion aggregation: {pairing_result[:3]}...")

    assert (
        pairing_result == [1] + [0] * 11
    ), "Pairing check failed with recursion aggregation"


@pytest.mark.parametrize(
    "proof_path, system",
    [
        (f"{PATH}/proof_ultra_keccak_zk.bin", ProofSystem.UltraKeccakZKHonk),
    ],
)
def test_check_evals_consistency(proof_path: str, system: ProofSystem):
    vk: HonkVk = HonkVk.from_bytes(open(f"{PATH}/vk_ultra_keccak.bin", "rb").read())
    proof = honk_proof_from_bytes(
        open(proof_path, "rb").read(),
        open(f"{PATH}/public_inputs_ultra_keccak.bin", "rb").read(),
        vk,
        system,
    )

    tp = ZKHonkTranscript.from_proof(vk, proof, system)
    circuit = ZKHonkVerifierCircuits(name="test", log_n=vk.log_circuit_size)

    proof_circuit = proof.to_circuit_elements(circuit)
    tp = tp.to_circuit_elements(circuit)

    vanishing_check_expected, diff_check_expected = circuit.check_evals_consistency(
        proof_circuit.libra_evaluation,
        proof_circuit.libra_poly_evals,
        tp.gemini_r,
        tp.sum_check_u_challenges,
    )

    vanishing_check, diff_check = circuit.check_evals_consistency_split(
        proof_circuit.libra_evaluation,
        proof_circuit.libra_poly_evals,
        tp.gemini_r,
        tp.sum_check_u_challenges,
    )

    assert vanishing_check.value == vanishing_check_expected.value
    assert diff_check.value == diff_check_expected.value
