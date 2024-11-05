from hydra.garaga.precompiled_circuits.honk_new import (
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

    vk = vk.to_circuit_elements(circuit)
    proof = proof.to_circuit_elements(circuit)
    tp = tp.to_circuit_elements(circuit)

    public_input_delta = circuit.compute_public_input_delta(
        public_inputs=proof.public_inputs,
        beta=tp.beta,
        gamma=tp.gamma,
        domain_size=vk.circuit_size,
        offset=vk.public_inputs_offset,
    )

    rlc_check, check = circuit.verify_sum_check(
        sumcheck_univariates=proof.sumcheck_univariates,
        sumcheck_evaluations=proof.sumcheck_evaluations,
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
