from typing import Union

from garaga import garaga_rs
from garaga.definitions import G1G2Pair, ProofSystem
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
    ZKHonkProof,
    ZKHonkTranscript,
    ZKHonkVerifierCircuits,
)
from garaga.starknet.tests_and_calldata_generators.mpcheck import MPCheckCalldataBuilder
from garaga.starknet.tests_and_calldata_generators.msm import MSMCalldataBuilder


def filter_msm_scalars(
    scalars: list[ModuloCircuitElement], log_n: int, zk: bool = False
) -> list[ModuloCircuitElement]:
    if zk:
        assert len(scalars) == NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 3 + 3
        start_dummy = 1 + NUMBER_OF_ENTITIES + log_n
        end_dummy = 1 + NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N
    else:
        assert len(scalars) == NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2
        start_dummy = NUMBER_OF_ENTITIES + log_n
        end_dummy = NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N

    # Verify zeros in dummy section
    assert all(
        s.value == 0 for s in scalars[start_dummy:end_dummy]
    ), "Expected all dummy round scalars to be 0"

    # Keep everything except dummy section
    scalars_no_dummy = scalars[:start_dummy] + scalars[end_dummy:]
    # Remove the first element (== 1)
    scalars_filtered = scalars_no_dummy[1:]
    scalars_filtered_no_nones = [
        scalar for scalar in scalars_filtered if scalar is not None
    ]
    return scalars_filtered_no_nones


def extract_msm_scalars(
    scalars: list[ModuloCircuitElement], log_n: int, zk: bool = False
) -> list[ModuloCircuitElement]:
    scalars_msm = filter_msm_scalars(scalars, log_n, zk)
    return [s.value for s in scalars_msm]


def get_ultra_flavor_honk_calldata_from_vk_and_proof(
    vk: HonkVk,
    proof: Union[HonkProof, ZKHonkProof],
    system: ProofSystem = ProofSystem.UltraKeccakHonk,
    use_rust: bool = False,
) -> list[int]:
    if use_rust:
        return _honk_calldata_from_vk_and_proof_rust(vk, proof, system)

    zk = system in [ProofSystem.UltraKeccakZKHonk, ProofSystem.UltraStarknetZKHonk]

    if zk:
        assert isinstance(proof, ZKHonkProof)
        tp = ZKHonkTranscript.from_proof(vk, proof, system)
        circuit = ZKHonkVerifierCircuits(name="test", log_n=vk.log_circuit_size)
    else:
        assert isinstance(proof, HonkProof)
        tp = HonkTranscript.from_proof(vk, proof, system)
        circuit = HonkVerifierCircuits(name="test", log_n=vk.log_circuit_size)

    vk_circuit = vk.to_circuit_elements(circuit)
    proof_circuit = proof.to_circuit_elements(circuit)
    tp = tp.to_circuit_elements(circuit)

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

    scalars_msm = extract_msm_scalars(scalars, vk.log_circuit_size, zk)
    if zk:
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
        ]
        points.extend(proof.gemini_fold_comms[: vk.log_circuit_size - 1])
        points.extend(proof.libra_commitments)
        points.append(G1Point.get_nG(CurveID.BN254, 1))
        points.append(proof.kzg_quotient)
    else:
        points = [
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


def _honk_calldata_from_vk_and_proof_rust(
    vk: HonkVk,
    proof: HonkProof,
    system: ProofSystem = ProofSystem.UltraKeccakHonk,
) -> list[int]:
    match system:
        case ProofSystem.UltraKeccakHonk:
            flavor = 0
            zk = False
        case ProofSystem.UltraStarknetHonk:
            flavor = 1
            zk = False
        case ProofSystem.UltraKeccakZKHonk:
            flavor = 0
            zk = True
        case ProofSystem.UltraStarknetZKHonk:
            flavor = 1
            zk = True
        case _:
            raise ValueError(f"Proof system {system} not compatible")

    return garaga_rs.get_honk_calldata(proof.flatten(), vk.flatten(), flavor, zk)
