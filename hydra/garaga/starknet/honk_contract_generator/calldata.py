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
    aggregate_pairing_points,
    get_vk_msm_point_mask,
    get_vk_msm_points,
)
from garaga.starknet.tests_and_calldata_generators.mpcheck import MPCheckCalldataBuilder
from garaga.starknet.tests_and_calldata_generators.msm import MSMCalldataBuilder

N_VK_POINTS = 28


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


def get_msm_points_and_scalars(
    vk: HonkVk, proof: ZKHonkProof, scalars_msm: list[int]
) -> tuple[list[G1Point], list[int]]:
    """
    Order the MSM points & scalars as the Cairo verifier does:
    [non-infinity vk points, gemini_masking_poly, w1, w2, w3, w4, z_perm, lookup_inverses,
     lookup_read_counts, lookup_read_tags, gemini fold comms, libra comms, kzg_quotient, G].
    `scalars_msm` are the shplemini scalars without the leading 1 (shplonk_q).
    """
    # Swap last two scalars (kzg_quotient <-> G) :
    scalars_msm = scalars_msm[:-2] + scalars_msm[-2:][::-1]
    # Move the gemini masking scalar just after the vk points.
    first_scalar = scalars_msm.pop(0)
    scalars_msm.insert(N_VK_POINTS, first_scalar)

    points = get_vk_msm_points(vk) + [
        proof.gemini_masking_poly,
        proof.w1,
        proof.w2,
        proof.w3,
        proof.w4,
        proof.z_perm,
        proof.lookup_inverses,
        proof.lookup_read_counts,
        proof.lookup_read_tags,
    ]
    points.extend(proof.gemini_fold_comms[: vk.log_circuit_size - 1])
    points.extend(proof.libra_commitments)
    points.append(proof.kzg_quotient)
    points.append(G1Point.get_nG(CurveID.BN254, 1))

    assert len(points) == len(scalars_msm)

    # Drop the vk commitments to identically-zero polynomials (point at infinity).
    mask = get_vk_msm_point_mask(vk) + [True] * (len(points) - N_VK_POINTS)
    points = [pt for pt, keep in zip(points, mask) if keep]
    scalars_msm = [s for s, keep in zip(scalars_msm, mask) if keep]
    return points, scalars_msm


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

    points, scalars_msm = get_msm_points_and_scalars(
        vk, proof, extract_msm_scalars(scalars, vk.log_circuit_size)
    )

    msm_builder = MSMCalldataBuilder(
        CurveID.BN254,
        points=points,
        scalars=scalars_msm,
    )

    P_0 = G1Point.msm(points=points, scalars=scalars_msm).add(proof.shplonk_q)
    P_1 = -proof.kzg_quotient

    # Accumulate the recursive pairing points carried in the public inputs.
    P_0_agg, P_1_agg, separator = aggregate_pairing_points(
        proof.pairing_point_object, P_0, P_1
    )
    if separator is None:
        aggregation_hint = [0]  # Empty Span<felt252>
    else:
        aggregation_hint = MSMCalldataBuilder(
            CurveID.BN254,
            points=[P_0, P_1],
            scalars=[separator, separator],
        ).serialize_to_calldata(
            include_points_and_scalars=False,
            serialize_as_pure_felt252_array=True,
        )

    pairs = [G1G2Pair(P_0_agg, G2_POINT_KZG_1), G1G2Pair(P_1_agg, G2_POINT_KZG_2)]

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
    cd.extend(aggregation_hint)
    cd.extend(mpc_builder.serialize_to_calldata())

    res = [len(cd)] + cd

    return res


def _honk_calldata_from_vk_and_proof_rust(
    vk: HonkVk,
    proof: ZKHonkProof,
) -> list[int]:
    return garaga_rs.get_zk_honk_calldata(
        proof.proof_bytes, proof.public_inputs_bytes, vk.vk_bytes
    )
