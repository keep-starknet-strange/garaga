import math

from garaga.rsa_rns import (
    BASE,
    CHANNEL_MODULI,
    CHUNK_LIMBS,
    CRT_EXACTNESS_BOUND,
    RSA_PUBLIC_EXPONENT,
    RSA_REDUCTION_COUNT,
    RNSContext,
    generate_rsa2048_witness,
    modular_exponentiation_with_proof,
)
from garaga.starknet.tests_and_calldata_generators.signatures import RSA2048Signature


def eval_chunks_mod(chunks: tuple[int, ...], step: int, modulus: int) -> int:
    """Horner evaluation of chunk polynomial at step, reduced modulo modulus."""
    acc = 0
    for chunk in reversed(chunks):
        acc = (acc * step + chunk) % modulus
    return acc


def test_rsa_channel_moduli_are_pairwise_coprime():
    for i, lhs in enumerate(CHANNEL_MODULI):
        assert lhs > 1
        for j, rhs in enumerate(CHANNEL_MODULI[i + 1 :], start=i + 1):
            assert (
                math.gcd(lhs, rhs) == 1
            ), f"channel moduli {i} and {j} are not coprime"


def test_rsa_chunk_steps_match_chunk_radix_mod_channel_moduli():
    expected_steps = [pow(BASE, CHUNK_LIMBS, p) for p in CHANNEL_MODULI]
    assert expected_steps == [
        5880,
        9624,
        24728,
        32024,
        38504,
        45624,
        48200,
        55592,
        57224,
        64488,
        71448,
    ]


def test_rsa_chunk_horner_evaluation_matches_residues():
    ctx = RNSContext(CHANNEL_MODULI)
    steps = [pow(BASE, CHUNK_LIMBS, p) for p in CHANNEL_MODULI]

    for seed in range(3):
        sample = RSA2048Signature.sample(seed=seed)
        encoded_values = [
            sample.modulus,
            sample.signature,
            sample.expected_message,
            sample.reductions[0].quotient,
            sample.reductions[0].remainder,
            sample.reductions[-1].quotient,
            sample.reductions[-1].remainder,
        ]
        for encoded_value in encoded_values:
            horner_residues = tuple(
                eval_chunks_mod(encoded_value.chunks, step, modulus)
                for step, modulus in zip(steps, CHANNEL_MODULI)
            )
            assert horner_residues == ctx.residues_from_limbs(encoded_value.limbs)


def test_rsa_context_exactness_bound():
    ctx = RNSContext(CHANNEL_MODULI)
    assert ctx.M > CRT_EXACTNESS_BOUND


def test_rsa_sample_is_valid():
    sample = RSA2048Signature.sample(seed=0)
    assert sample.is_valid()
    assert len(sample.reductions) == RSA_REDUCTION_COUNT
    assert len(sample.serialize_public_key()) == 24
    assert len(sample.serialize_signature_with_hints()) == 864
    assert len(sample.serialize()) == 888


def test_rsa_verification_path_uses_expected_reductions():
    ctx = RNSContext(CHANNEL_MODULI)
    bundle = generate_rsa2048_witness(seed=0)
    verified_message, reduction_count = modular_exponentiation_with_proof(
        ctx,
        bundle.signature.value,
        RSA_PUBLIC_EXPONENT,
        bundle.modulus.value,
    )
    assert reduction_count == RSA_REDUCTION_COUNT
    assert verified_message == bundle.expected_message.value


def test_rsa_tampered_residue_is_invalid():
    assert not RSA2048Signature.tampered_residue_sample(seed=0).is_valid()


def test_rsa_tampered_limb_is_invalid():
    assert not RSA2048Signature.tampered_limb_sample(seed=0).is_valid()


def test_rsa_tampered_expected_message_is_invalid():
    assert not RSA2048Signature.tampered_expected_message_sample(seed=0).is_valid()
