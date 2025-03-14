import pytest

import garaga.hints.io as io
from garaga.definitions import G1G2Pair, ProofSystem
from garaga.precompiled_circuits.honk import (
    CONST_PROOF_SIZE_LOG_N,
    G2_POINT_KZG_1,
    G2_POINT_KZG_2,
    NUMBER_OF_ENTITIES,
    CurveID,
    G1Point,
    HonkTranscript,
    HonkVerifierCircuits,
    HonkVk,
)
from garaga.precompiled_circuits.zk_honk import (
    ZKHonkTranscript,
    ZKHonkVerifierCircuits,
    honk_proof_from_bytes,
)

PATH = "hydra/garaga/starknet/honk_contract_generator/examples"


@pytest.mark.parametrize(
    "proof_path, system",
    [
        (f"{PATH}/proof_ultra_keccak.bin", ProofSystem.UltraKeccakHonk),
        (f"{PATH}/proof_ultra_starknet.bin", ProofSystem.UltraStarknetHonk),
        (f"{PATH}/proof_ultra_keccak_zk.bin", ProofSystem.UltraKeccakZKHonk),
        (f"{PATH}/proof_ultra_starknet_zk.bin", ProofSystem.UltraStarknetZKHonk),
    ],
)
def test_verify_honk_proof(proof_path: str, system: ProofSystem):
    zk = system in [ProofSystem.UltraKeccakZKHonk, ProofSystem.UltraStarknetZKHonk]

    vk = HonkVk.from_bytes(open(f"{PATH}/vk_ultra_keccak.bin", "rb").read())
    proof = honk_proof_from_bytes(open(proof_path, "rb").read(), system)

    if zk:
        tp = ZKHonkTranscript.from_proof(proof, system)
        circuit = ZKHonkVerifierCircuits(name="test", log_n=vk.log_circuit_size)
    else:
        tp = HonkTranscript.from_proof(proof, system)
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

    if zk:
        vanishing_check, diff_check = circuit.check_evals_consistency(
            proof_circuit.libra_evaluation,
            proof_circuit.libra_poly_evals,
            tp.gemini_r,
            tp.sum_check_u_challenges,
        )
        assert vanishing_check.value != 0
        assert diff_check.value == 0

    if zk:
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
            alphas=tp.alphas,
            log_n=vk.log_circuit_size,
            base_rlc=circuit.write_element(1234),
        )
    else:
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

    if zk:
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
    else:
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

    if zk:
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
            vk.qAux,  # 12
            vk.qPoseidon2External,  # 13
            vk.qPoseidon2Internal,  # 14
            vk.s1,  # 15
            vk.s2,  # 16
            vk.s3,  # 17
            vk.s4,  # 18
            vk.id1,  # 19
            vk.id2,  # 20
            vk.id3,  # 21
            vk.id4,  # 22
            vk.t1,  # 23
            vk.t2,  # 24
            vk.t3,  # 25
            vk.t4,  # 26
            vk.lagrange_first,  # 27
            vk.lagrange_last,  # 28
            proof.w1,  # 29
            proof.w2,  # 30
            proof.w3,  # 31
            proof.w4,  # 32
            proof.z_perm,  # 33
            proof.lookup_inverses,  # 34
            proof.lookup_read_counts,  # 35
            proof.lookup_read_tags,  # 36
            proof.w1,  # 37
            proof.w2,  # 38
            proof.w3,  # 39
            proof.w4,  # 40
            proof.z_perm,  # 41
        ]

        # w1 : 29 + 37
        # w2 : 30 + 38
        # w3 : 31 + 39
        # w4 : 32 + 40

        points.extend(proof.gemini_fold_comms)
        points.extend(proof.libra_commitments)
        points.append(G1Point.get_nG(CurveID.BN254, 1))
        points.append(proof.kzg_quotient)

        assert len(points) == NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 3 + 3
    else:
        points = [
            proof.shplonk_q,  # 0
            vk.qm,  # 1
            vk.qc,  # 2
            vk.ql,  # 3
            vk.qr,  # 4
            vk.qo,  # 5
            vk.q4,  # 6
            vk.qLookup,  # 7
            vk.qArith,  # 8
            vk.qDeltaRange,  # 9
            vk.qElliptic,  # 10
            vk.qAux,  # 11
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
            proof.w1,  # 36
            proof.w2,  # 37
            proof.w3,  # 38
            proof.w4,  # 39
            proof.z_perm,  # 40
        ]

        # w1 : 28 + 36
        # w2 : 29 + 37
        # w3 : 30 + 38
        # w4 : 31 + 39

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


@pytest.mark.parametrize(
    "proof_path, system",
    [
        (f"{PATH}/proof_ultra_keccak_zk.bin", ProofSystem.UltraKeccakZKHonk),
        (f"{PATH}/proof_ultra_starknet_zk.bin", ProofSystem.UltraStarknetZKHonk),
    ],
)
def test_check_evals_consistency(proof_path: str, system: ProofSystem):
    vk = HonkVk.from_bytes(open(f"{PATH}/vk_ultra_keccak.bin", "rb").read())
    proof = honk_proof_from_bytes(open(proof_path, "rb").read(), system)

    tp = ZKHonkTranscript.from_proof(proof, system)
    circuit = ZKHonkVerifierCircuits(name="test", log_n=vk.log_circuit_size)

    proof_circuit = proof.to_circuit_elements(circuit)
    tp = tp.to_circuit_elements(circuit)

    vanishing_check_expected, diff_check_expected = (
        circuit.check_evals_consistency_original(
            proof_circuit.libra_evaluation,
            proof_circuit.libra_poly_evals,
            tp.gemini_r,
            tp.sum_check_u_challenges,
        )
    )

    vanishing_check, diff_check = circuit.check_evals_consistency(
        proof_circuit.libra_evaluation,
        proof_circuit.libra_poly_evals,
        tp.gemini_r,
        tp.sum_check_u_challenges,
    )

    assert vanishing_check.value == vanishing_check_expected.value
    assert diff_check.value == diff_check_expected.value
