from garaga import garaga_rs
from garaga.definitions import G1G2Pair, ProofSystem
from garaga.precompiled_circuits.honk import (
    CONST_PROOF_SIZE_LOG_N,
    G2_POINT_KZG_1,
    G2_POINT_KZG_2,
    NUMBER_OF_ENTITIES,
    CurveID,
    G1Point,
    HonkVk,
    ModuloCircuitElement,
)
from garaga.precompiled_circuits.zk_honk import (
    ZKHonkProof,
    ZKHonkTranscript,
    ZKHonkVerifierCircuits,
)
from garaga.starknet.tests_and_calldata_generators.mpcheck import MPCheckCalldataBuilder
from garaga.starknet.tests_and_calldata_generators.msm import MSMCalldataBuilder


def extract_msm_scalars_zk(
    scalars: list[ModuloCircuitElement], log_n: int
) -> list[int]:
    assert len(scalars) == NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 3 + 3

    start_dummy = 1 + NUMBER_OF_ENTITIES + log_n
    end_dummy = 1 + NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N

    scalars_no_dummy = scalars[:start_dummy] + scalars[end_dummy:]

    scalars_filtered = scalars_no_dummy[1:]
    scalars_filtered_no_nones = [
        scalar for scalar in scalars_filtered if scalar is not None
    ]
    return [s.value for s in scalars_filtered_no_nones]


def get_ultra_flavor_zk_honk_calldata_from_vk_and_proof(
    vk: HonkVk,
    proof: ZKHonkProof,
    system: ProofSystem = ProofSystem.UltraKeccakZKHonk,
    use_rust: bool = False,
) -> list[int]:
    if use_rust:
        return _zk_honk_calldata_from_vk_and_proof_rust(vk, proof, system)

    tp = ZKHonkTranscript.from_proof(proof, system)

    circuit = ZKHonkVerifierCircuits(name="test", log_n=vk.log_circuit_size)

    vk_circuit = vk.to_circuit_elements(circuit)
    proof_circuit = proof.to_circuit_elements(circuit)
    tp = tp.to_circuit_elements(circuit)

    vanishing_check, diff_check = circuit.check_evals_consistency(
        proof_circuit.libra_evaluation,
        proof_circuit.libra_poly_evals,
        tp.gemini_r,
        tp.sum_check_u_challenges,
    )
    assert vanishing_check.value != 0
    assert diff_check.value == 0

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

    scalars_msm = extract_msm_scalars_zk(scalars, vk.log_circuit_size)

    points = [
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
        proof.z_perm,  # 41
    ]
    points.extend(proof.gemini_fold_comms[: vk.log_circuit_size - 1])
    points.extend(proof.libra_commitments)
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


def _zk_honk_calldata_from_vk_and_proof_rust(
    vk: HonkVk,
    proof: ZKHonkProof,
    system: ProofSystem = ProofSystem.UltraKeccakZKHonk,
) -> list[int]:
    match system:
        case ProofSystem.UltraKeccakZKHonk:
            flavor = 0
        case ProofSystem.UltraStarknetZKHonk:
            flavor = 1
        case _:
            raise ValueError(f"Proof system {system} not compatible")

    return garaga_rs.get_honk_calldata(proof.flatten(), vk.flatten(), flavor, True)
