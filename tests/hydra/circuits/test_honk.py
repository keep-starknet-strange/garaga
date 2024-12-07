import garaga.hints.io as io
from garaga.definitions import G1G2Pair
from garaga.precompiled_circuits.honk import (
    CONST_PROOF_SIZE_LOG_N,
    G2_POINT_KZG_1,
    G2_POINT_KZG_2,
    NUMBER_OF_ENTITIES,
    CurveID,
    G1Point,
    HonkProof,
    HonkTranscript,
    HonkVerifierCircuits,
    HonkVk,
)

PATH = "hydra/garaga/starknet/honk_contract_generator/examples"


def test_sumcheck_circuit():
    vk = HonkVk.from_bytes(open(f"{PATH}/vk_ultra_keccak.bin", "rb").read())
    proof = HonkProof.from_bytes(open(f"{PATH}/proof_ultra_keccak.bin", "rb").read())
    tp = HonkTranscript.from_proof(proof)

    circuit = HonkVerifierCircuits(name="test", log_n=vk.log_circuit_size)

    vk_circuit = vk.to_circuit_elements(circuit)
    proof_circuit = proof.to_circuit_elements(circuit)
    tp = tp.to_circuit_elements(circuit)

    public_input_delta = circuit.compute_public_input_delta(
        public_inputs=proof_circuit.public_inputs,
        beta=tp.beta,
        gamma=tp.gamma,
        domain_size=vk.circuit_size,
        offset=vk_circuit.public_inputs_offset,
    )

    rlc_check, check = circuit.verify_sum_check(
        sumcheck_univariates=proof_circuit.sumcheck_univariates,
        sumcheck_evaluations=(proof_circuit.sumcheck_evaluations),
        beta=tp.beta,
        gamma=tp.gamma,
        public_inputs_delta=public_input_delta,
        eta=tp.eta,
        eta_two=tp.etaTwo,
        eta_three=tp.etaThree,
        sum_check_u_challenges=tp.sum_check_u_challenges,
        gate_challenges=tp.gate_challenges,
        alphas=tp.alphas,
        log_n=vk.log_circuit_size,
        base_rlc=circuit.write_element(1234),
    )

    assert rlc_check.value == 0
    assert check.value == 0

    print(f"Pub input delta: {io.int_to_u384(public_input_delta, as_hex=False)}")

    scalars = circuit.compute_shplemini_msm_scalars(
        proof_circuit.sumcheck_evaluations,
        proof_circuit.gemini_a_evaluations,
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
        vk.qm,  # 1
        vk.qc,  # 2
        vk.ql,  # 3
        vk.qr,  # 4
        vk.qo,  # 5
        vk.q4,  # 6
        vk.qArith,  # 7
        vk.qDeltaRange,  # 8
        vk.qElliptic,  # 9
        vk.qAux,  # 10
        vk.qLookup,  # 11
        vk.qPoseidon2External,  # 12
        vk.qPoseidon2Internal,  # 13
        vk.s1,  # 14
        vk.s2,  # 15
        vk.s3,  # 16
        vk.s4,  # 17
        vk.id1,  # 18
        vk.id2,  # 19
        vk.id3,  # 20
        vk.id4,  # 21
        vk.t1,  # 22
        vk.t2,  # 23
        vk.t3,  # 24
        vk.t4,  # 25
        vk.lagrange_first,  # 26
        vk.lagrange_last,  # 27
        proof.w1,  # 28
        proof.w2,  # 29
        proof.w3,  # 30
        proof.w4,  # 31
        proof.z_perm,  # 32
        proof.lookup_inverses,  # 33
        proof.lookup_read_counts,  # 34
        proof.lookup_read_tags,  # 35
        vk.t1,  # 36
        vk.t2,  # 37
        vk.t3,  # 38
        vk.t4,  # 39
        proof.w1,  # 40
        proof.w2,  # 41
        proof.w3,  # 42
        proof.w4,  # 43
        proof.z_perm,  # 44
    ]

    # t1 : 22 + 36
    # t2 : 23 + 37
    # t3 : 24 + 38
    # t4 : 25 + 39

    # w1 : 28 + 40
    # w2 : 29 + 41
    # w3 : 30 + 42
    # w4 : 31 + 43

    points.extend(proof.gemini_fold_comms)
    points.append(G1Point.get_nG(CurveID.BN254, 1))
    points.append(proof.kzg_quotient)

    assert len(points) == NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2

    for i, (p, s) in enumerate(zip(points, scalars)):
        if s:
            print(i, hex(s.value))

    P_0 = G1Point.msm(
        points=points, scalars=[scalar.value if scalar else 0 for scalar in scalars]
    )

    P_1 = -proof.kzg_quotient

    pairs = [G1G2Pair(P_0, G2_POINT_KZG_1), G1G2Pair(P_1, G2_POINT_KZG_2)]

    assert G1G2Pair.pair(pairs).value_coeffs == [1] + [0] * 11
