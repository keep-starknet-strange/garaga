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
    ModuloCircuitElement,
)
from garaga.starknet.tests_and_calldata_generators.mpcheck import MPCheckCalldataBuilder
from garaga.starknet.tests_and_calldata_generators.msm import MSMCalldataBuilder


def extract_msm_scalars(scalars: list[ModuloCircuitElement], log_n: int) -> list[int]:
    assert len(scalars) == NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2

    start_dummy = NUMBER_OF_ENTITIES + log_n
    end_dummy = NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N

    scalars_no_dummy = scalars[:start_dummy] + scalars[end_dummy:]

    scalars_filtered = scalars_no_dummy[1:]
    scalars_filtered_no_nones = [
        scalar for scalar in scalars_filtered if scalar is not None
    ]
    return [s.value for s in scalars_filtered_no_nones]


def get_ultra_keccak_honk_calldata_from_vk_and_proof(
    vk: HonkVk, proof: HonkProof
) -> list[int]:
    tp = HonkTranscript.from_proof(proof)

    circuit = HonkVerifierCircuits(name="test", log_n=vk.log_circuit_size)

    vk_circuit = vk.to_circuit_elements(circuit)
    proof_circuit = proof.to_circuit_elements(circuit)
    tp = tp.to_circuit_elements(circuit)

    scalars = circuit.compute_shplemini_msm_scalars(
        proof_circuit.sumcheck_evaluations,
        proof_circuit.gemini_a_evaluations,
        tp.gemini_r,
        tp.rho,
        tp.shplonk_z,
        tp.shplonk_nu,
        tp.sum_check_u_challenges,
    )

    scalars_msm = extract_msm_scalars(scalars, vk.log_circuit_size)

    points = [
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
        proof.z_perm,  # 44
    ]
    points.extend(proof.gemini_fold_comms[: vk.log_circuit_size - 1])
    points.append(G1Point.get_nG(CurveID.BN254, 1))
    points.append(proof.kzg_quotient)

    msm_builder = MSMCalldataBuilder(
        CurveID.BN254, points=points, scalars=scalars_msm, risc0_mode=False
    )

    P_0 = G1Point.msm(points=points, scalars=scalars_msm).add(proof.shplonk_q)
    P_1 = -proof.kzg_quotient

    pairs = [G1G2Pair(P_0, G2_POINT_KZG_1), G1G2Pair(P_1, G2_POINT_KZG_2)]

    mpc_builder = MPCheckCalldataBuilder(
        curve_id=CurveID.BN254, pairs=pairs, n_fixed_g2=2, public_pair=None
    )
    cd = []
    cd.extend(proof.serialize_to_calldata())
    cd.extend(
        msm_builder.serialize_to_calldata(
            include_points_and_scalars=False,
            serialize_as_pure_felt252_array=False,
            include_digits_decomposition=None,
        )
    )
    cd.extend(mpc_builder.serialize_to_calldata())

    res = [len(cd)] + cd

    # print(f"HONK CALLDATA: {res}")
    # print(f"HONK CALLDATA LENGTH: {len(res)}")

    return res
