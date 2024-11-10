import garaga.hints.io as io
from garaga.definitions import G1G2Pair
from hydra.garaga.precompiled_circuits.honk_new import (
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

    # commitments[1] = vk.qm;
    # commitments[2] = vk.qc;
    # commitments[3] = vk.ql;
    # commitments[4] = vk.qr;
    # commitments[5] = vk.qo;
    # commitments[6] = vk.q4;
    # commitments[7] = vk.qArith;
    # commitments[8] = vk.qDeltaRange;
    # commitments[9] = vk.qElliptic;
    # commitments[10] = vk.qAux;
    # commitments[11] = vk.qLookup;
    # commitments[12] = vk.qPoseidon2External;
    # commitments[13] = vk.qPoseidon2Internal;
    # commitments[14] = vk.s1;
    # commitments[15] = vk.s2;
    # commitments[16] = vk.s3;
    # commitments[17] = vk.s4;
    # commitments[18] = vk.id1;
    # commitments[19] = vk.id2;
    # commitments[20] = vk.id3;
    # commitments[21] = vk.id4;
    # commitments[22] = vk.t1;
    # commitments[23] = vk.t2;
    # commitments[24] = vk.t3;
    # commitments[25] = vk.t4;
    # commitments[26] = vk.lagrangeFirst;
    # commitments[27] = vk.lagrangeLast;

    # // Accumulate proof points
    # commitments[28] = convertProofPoint(proof.w1);
    # commitments[29] = convertProofPoint(proof.w2);
    # commitments[30] = convertProofPoint(proof.w3);
    # commitments[31] = convertProofPoint(proof.w4);
    # commitments[32] = convertProofPoint(proof.zPerm);
    # commitments[33] = convertProofPoint(proof.lookupInverses);
    # commitments[34] = convertProofPoint(proof.lookupReadCounts);
    # commitments[35] = convertProofPoint(proof.lookupReadTags);

    # // to be Shifted
    # commitments[36] = vk.t1;
    # commitments[37] = vk.t2;
    # commitments[38] = vk.t3;
    # commitments[39] = vk.t4;
    # commitments[40] = convertProofPoint(proof.w1);
    # commitments[41] = convertProofPoint(proof.w2);
    # commitments[42] = convertProofPoint(proof.w3);
    # commitments[43] = convertProofPoint(proof.w4);
    # commitments[44] = convertProofPoint(proof.zPerm);
    points = [
        proof.shplonk_q,
        vk.qm,
        vk.qc,
        vk.ql,
        vk.qr,
        vk.qo,
        vk.q4,
        vk.qArith,
        vk.qDeltaRange,
        vk.qElliptic,
        vk.qAux,
        vk.qLookup,
        vk.qPoseidon2External,
        vk.qPoseidon2Internal,
        vk.s1,
        vk.s2,
        vk.s3,
        vk.s4,
        vk.id1,
        vk.id2,
        vk.id3,
        vk.id4,
        vk.t1,
        vk.t2,
        vk.t3,
        vk.t4,
        vk.lagrange_first,
        vk.lagrange_last,
        proof.w1,
        proof.w2,
        proof.w3,
        proof.w4,
        proof.z_perm,
        proof.lookup_inverses,
        proof.lookup_read_counts,
        proof.lookup_read_tags,
        vk.t1,
        vk.t2,
        vk.t3,
        vk.t4,
        proof.w1,
        proof.w2,
        proof.w3,
        proof.w4,
        proof.z_perm,
    ]

    points.extend(proof.gemini_fold_comms)
    points.append(G1Point.get_nG(CurveID.BN254, 1))
    points.append(proof.kzg_quotient)

    assert len(points) == NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2

    for i, (p, s) in enumerate(zip(points, scalars)):
        print(i, hex(s.value))

    P_0 = G1Point.msm(points=points, scalars=[scalar.value for scalar in scalars])
    P_1 = -proof.kzg_quotient

    pairs = [G1G2Pair(P_0, G2_POINT_KZG_1), G1G2Pair(P_1, G2_POINT_KZG_2)]

    assert G1G2Pair.pair(pairs).value_coeffs == [1] + [0] * 11
