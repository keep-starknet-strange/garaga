from garaga import garaga_rs
from garaga.curves import ProofSystem
from garaga.points import G1G2Pair
from garaga.precompiled_circuits.zk_honk import (
    G2_POINT_KZG_1,
    G2_POINT_KZG_2,
    LIBRA_COMMITMENTS,
    NUMBER_UNSHIFTED,
    CurveID,
    G1Point,
    HonkVk,
    ModuloCircuitElement,
    ZKHonkProof,
    ZKHonkTranscript,
    ZKHonkVerifierCircuits,
)
from garaga.starknet.tests_and_calldata_generators.mpcheck import MPCheckCalldataBuilder
from garaga.starknet.tests_and_calldata_generators.msm import MSMCalldataBuilder


def filter_msm_scalars(
    scalars: list[ModuloCircuitElement], log_n: int
) -> list[ModuloCircuitElement]:

    assert len(scalars) == NUMBER_UNSHIFTED + log_n + LIBRA_COMMITMENTS + 3
    # Remove the first element (== 1)
    scalars_filtered = scalars[1:]

    return scalars_filtered


def extract_msm_scalars(
    scalars: list[ModuloCircuitElement], log_n: int
) -> list[ModuloCircuitElement]:
    scalars_msm = filter_msm_scalars(scalars, log_n)
    return [s.value for s in scalars_msm]


def get_ultra_flavor_honk_calldata_from_vk_and_proof(
    vk: HonkVk,
    proof: ZKHonkProof,
    system: ProofSystem = ProofSystem.UltraKeccakZKHonk,
    use_rust: bool = False,
) -> list[int]:
    if use_rust:
        return _honk_calldata_from_vk_and_proof_rust(vk, proof)

    assert isinstance(proof, ZKHonkProof)
    tp = ZKHonkTranscript.from_proof(vk, proof, system)
    circuit = ZKHonkVerifierCircuits(name="test", log_n=vk.log_circuit_size)

    vk_circuit = vk.to_circuit_elements(circuit)
    proof_circuit = proof.to_circuit_elements(circuit)
    tp = tp.to_circuit_elements(circuit)

    public_input_delta = circuit.compute_public_input_delta(
        public_inputs=proof_circuit.public_inputs,
        pairing_point_object=proof_circuit.pairing_point_object,
        beta=tp.beta,
        gamma=tp.gamma,
    )
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

    scalars_msm = extract_msm_scalars(scalars, vk.log_circuit_size)
    # Swap last two scalars :
    scalars_msm = scalars_msm[:-2] + scalars_msm[-2:][::-1]

    # Place first scalar just after the vk_lagrange_last point (index 27)
    first_scalar = scalars_msm.pop(0)
    scalars_msm.insert(28, first_scalar)

    points = [
        vk.qm,  # 0
        vk.qc,  # 1
        vk.ql,  # 2
        vk.qr,  # 3
        vk.qo,  # 4
        vk.q4,  # 5
        vk.qLookup,  # 6
        vk.qArith,  # 7
        vk.qDeltaRange,  # 8
        vk.qElliptic,  # 9
        vk.qMemory,  # 10
        vk.qNnf,  # 11
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
        proof.gemini_masking_poly,  # 28
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
    points.append(proof.kzg_quotient)
    points.append(G1Point.get_nG(CurveID.BN254, 1))

    msm_builder = MSMCalldataBuilder(
        CurveID.BN254,
        points=points,
        scalars=scalars_msm,
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
            serialize_as_pure_felt252_array=True,
        )
    )
    cd.extend(mpc_builder.serialize_to_calldata())

    res = [len(cd)] + cd

    # print(f"HONK CALLDATA: {res}")
    # print(f"HONK CALLDATA LENGTH: {len(res)}")

    return res


def _honk_calldata_from_vk_and_proof_rust(
    vk: HonkVk,
    proof: ZKHonkProof,
) -> list[int]:
    return garaga_rs.get_zk_honk_calldata(
        proof.proof_bytes, proof.public_inputs_bytes, vk.vk_bytes
    )
