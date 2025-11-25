import pytest

import garaga.hints.io as io
from garaga.curves import ProofSystem
from garaga.points import G1G2Pair
from garaga.precompiled_circuits.zk_honk import (
    G2_POINT_KZG_1,
    G2_POINT_KZG_2,
    NUMBER_OF_ENTITIES,
    CurveID,
    G1Point,
    HonkVk,
    ZKHonkProof,
    ZKHonkTranscript,
    ZKHonkVerifierCircuits,
    honk_proof_from_bytes,
)

PATH = "hydra/garaga/starknet/honk_contract_generator/examples"


@pytest.mark.parametrize(
    "proof_path, system",
    [
        (f"{PATH}/proof_ultra_keccak_zk.bin", ProofSystem.UltraKeccakZKHonk),
    ],
)
def test_verify_honk_proof(proof_path: str, system: ProofSystem):
    vk_hash: bytes = open(f"{PATH}/vk_hash_ultra_keccak.bin", "rb").read()

    vk: HonkVk = HonkVk.from_bytes(
        open(f"{PATH}/vk_ultra_keccak.bin", "rb").read(), vk_hash
    )

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
        gate_challenges=tp.gate_challenges,
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

    points = [
        proof.shplonk_q,  # 0
        proof.gemini_masking_poly,  # 1
        vk.qm,  # 2
        vk.qc,  # 3
        vk.ql,  # 4
        vk.qr,  # 5
        vk.qo,  # 6
        vk.q4,  # 7
        vk.qLookup,  # 8
        vk.qArith,  # 9
        vk.qDeltaRange,  # 10
        vk.qElliptic,  # 11
        vk.qMemory,  # 12
        vk.qNnf,  # 13
        vk.qPoseidon2External,  # 14
        vk.qPoseidon2Internal,  # 15
        vk.s1,  # 16
        vk.s2,  # 17
        vk.s3,  # 18
        vk.s4,  # 19
        vk.id1,  # 20
        vk.id2,  # 21
        vk.id3,  # 22
        vk.id4,  # 23
        vk.t1,  # 24
        vk.t2,  # 25
        vk.t3,  # 26
        vk.t4,  # 27
        vk.lagrange_first,  # 28
        vk.lagrange_last,  # 29
        proof.w1,  # 30
        proof.w2,  # 31
        proof.w3,  # 32
        proof.w4,  # 33
        proof.z_perm,  # 34
        proof.lookup_inverses,  # 35
        proof.lookup_read_counts,  # 36
        proof.lookup_read_tags,  # 37
    ]

    points.extend(proof.gemini_fold_comms)
    points.extend(proof.libra_commitments)
    points.append(G1Point.get_nG(CurveID.BN254, 1))
    points.append(proof.kzg_quotient)

    assert len(points) == NUMBER_OF_ENTITIES + vk.log_circuit_size + 3 + 3

    for i, (p, s) in enumerate(zip(points, scalars)):
        if s:
            print(i, hex(s.value))

    P_0 = G1Point.msm(
        points=points, scalars=[scalar.value if scalar else 0 for scalar in scalars]
    )

    P_1 = -proof.kzg_quotient

    pairs = [G1G2Pair(P_0, G2_POINT_KZG_1), G1G2Pair(P_1, G2_POINT_KZG_2)]

    assert G1G2Pair.pair(pairs).value_coeffs == [1] + [0] * 11


@pytest.mark.parametrize(
    "proof_path, system",
    [
        (f"{PATH}/proof_ultra_keccak_zk.bin", ProofSystem.UltraKeccakZKHonk),
    ],
)
def test_check_evals_consistency(proof_path: str, system: ProofSystem):
    vk_hash: bytes = open(f"{PATH}/vk_hash_ultra_keccak.bin", "rb").read()
    vk: HonkVk = HonkVk.from_bytes(
        open(f"{PATH}/vk_ultra_keccak.bin", "rb").read(), vk_hash
    )
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
