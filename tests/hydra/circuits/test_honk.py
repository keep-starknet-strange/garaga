import pytest
from garaga.curves import ProofSystem
from garaga.points import G1G2Pair
from garaga.precompiled_circuits.zk_honk import (
    G2_POINT_KZG_1,
    G2_POINT_KZG_2,
    CurveID,
    G1Point,
    HonkVk,
    ZKHonkProof,
    ZKHonkTranscript,
    ZKHonkVerifierCircuits,
    aggregate_pairing_points,
    convert_pairing_points_to_g1,
    generate_recursion_separator,
    get_msm_points_from_vk_and_proof,
    honk_proof_from_bytes,
    pairing_points_are_default,
)

PATH = "hydra/garaga/starknet/honk_contract_generator/examples"

# (vk, proof, public_inputs). The recursive proof verifies an inner ZK Honk proof in-circuit,
# so its public inputs carry a non-default pairing point accumulator.
FIXTURES = {
    "default": (
        f"{PATH}/vk_ultra_keccak.bin",
        f"{PATH}/proof_ultra_keccak_zk.bin",
        f"{PATH}/public_inputs_ultra_keccak.bin",
    ),
    "recursive": (
        f"{PATH}/vk_ultra_keccak_recursive.bin",
        f"{PATH}/proof_ultra_keccak_zk_recursive.bin",
        f"{PATH}/public_inputs_ultra_keccak_recursive.bin",
    ),
}

ONE = [1] + [0] * 11


def load_fixture(name: str) -> tuple[HonkVk, ZKHonkProof]:
    vk_path, proof_path, public_inputs_path = FIXTURES[name]
    vk = HonkVk.from_bytes(open(vk_path, "rb").read())
    proof = honk_proof_from_bytes(
        open(proof_path, "rb").read(),
        open(public_inputs_path, "rb").read(),
        vk,
        ProofSystem.UltraKeccakZKHonk,
    )
    return vk, proof


def pairing_holds(p_0: G1Point, p_1: G1Point) -> bool:
    pairs = [G1G2Pair(p_0, G2_POINT_KZG_1), G1G2Pair(p_1, G2_POINT_KZG_2)]
    return G1G2Pair.pair(pairs).value_coeffs == ONE


def kzg_pairing_points(vk: HonkVk, proof: ZKHonkProof) -> tuple[G1Point, G1Point]:
    """Runs the full verifier but the final pairing and returns the KZG pairing points."""
    tp = ZKHonkTranscript.from_proof(vk, proof, ProofSystem.UltraKeccakZKHonk)
    circuit: ZKHonkVerifierCircuits = ZKHonkVerifierCircuits(
        name="test", log_n=vk.log_circuit_size
    )

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
        rom_logup_gamma=tp.rom_logup_gamma,
        libra_challenge=tp.libra_challenge,
        sum_check_u_challenges=tp.sum_check_u_challenges,
        gate_challenge=tp.gate_challenge,
        alpha=tp.alpha,
        log_n=vk.log_circuit_size,
        base_rlc=circuit.write_element(1234),
    )

    assert rlc_check.value == 0
    assert check.value == 0

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

    points = get_msm_points_from_vk_and_proof(vk, proof)
    P_0 = G1Point.msm(points=points, scalars=[scalar.value for scalar in scalars])
    P_1 = -proof.kzg_quotient
    return P_0, P_1


@pytest.mark.parametrize("fixture", ["default", "recursive"])
def test_verify_honk_proof(fixture: str):
    vk, proof = load_fixture(fixture)
    assert pairing_points_are_default(proof.pairing_point_object) == (
        fixture == "default"
    )

    P_0, P_1 = kzg_pairing_points(vk, proof)
    P_0_final, P_1_final, _ = aggregate_pairing_points(
        proof.pairing_point_object, P_0, P_1
    )
    assert pairing_holds(P_0_final, P_1_final), "Pairing check failed"


def test_forged_recursive_accumulator_rejected():
    """
    A forged inner accumulator (on the curve, not at infinity, but not satisfying the pairing)
    must be rejected. Checking the outer KZG pairing alone, without aggregating the pairing
    points, would accept it.
    """
    vk, proof = load_fixture("recursive")
    P_0, P_1 = kzg_pairing_points(vk, proof)
    assert pairing_holds(P_0, P_1)

    proof_lhs, proof_rhs = convert_pairing_points_to_g1(proof.pairing_point_object)
    assert pairing_holds(proof_lhs, proof_rhs)

    forged_lhs = proof_lhs.add(G1Point.get_nG(CurveID.BN254, 1))
    separator = generate_recursion_separator(forged_lhs, proof_rhs, P_0, P_1)
    assert not pairing_holds(
        P_0.scalar_mul(separator).add(forged_lhs),
        P_1.scalar_mul(separator).add(proof_rhs),
    )


def test_mixed_infinity_pairing_points_rejected():
    vk, proof = load_fixture("recursive")
    P_0, P_1 = kzg_pairing_points(vk, proof)
    pairing_point_object = proof.pairing_point_object[:4] + [0] * 4
    with pytest.raises(AssertionError, match="infinity"):
        aggregate_pairing_points(pairing_point_object, P_0, P_1)


def test_non_canonical_pairing_point_limbs_rejected():
    _, proof = load_fixture("recursive")
    ppo = list(proof.pairing_point_object)
    # Same x coordinate as lo + hi * 2^136, with lo >= 2^136.
    ppo[0], ppo[1] = ppo[0] + 2**136, ppo[1] - 1
    with pytest.raises(AssertionError, match="lo limb"):
        convert_pairing_points_to_g1(ppo)


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
