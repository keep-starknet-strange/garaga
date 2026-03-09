from garaga.rsa_rns import (
    CHANNEL_MODULI,
    DELTA_ABS_BOUND,
    RSA_PUBLIC_EXPONENT,
    RSA_REDUCTION_COUNT,
    CairoRNSContext,
    build_rsa2048_witness_bundle,
    verify_rsa_signature_with_exact_checks,
)
from garaga.starknet.tests_and_calldata_generators.signatures import RSA2048Signature


def test_rsa_context_exactness_bound():
    ctx = CairoRNSContext(CHANNEL_MODULI)
    assert ctx.M > DELTA_ABS_BOUND


def test_rsa_sample_is_valid():
    sample = RSA2048Signature.sample(seed=0)
    assert sample.is_valid()
    assert len(sample.reductions) == RSA_REDUCTION_COUNT
    assert len(sample.serialize_public_key()) == 24
    assert len(sample.serialize_signature_with_hints()) == 864
    assert len(sample.serialize()) == 888


def test_rsa_verification_path_uses_expected_reductions():
    ctx = CairoRNSContext(CHANNEL_MODULI)
    bundle = build_rsa2048_witness_bundle(seed=0)
    verified_message, steps = verify_rsa_signature_with_exact_checks(
        ctx,
        bundle.signature.value,
        RSA_PUBLIC_EXPONENT,
        bundle.modulus.value,
    )
    assert steps == RSA_REDUCTION_COUNT
    assert verified_message == bundle.expected_message.value


def test_rsa_tampered_residue_is_invalid():
    assert not RSA2048Signature.tampered_residue_sample(seed=0).is_valid()


def test_rsa_tampered_limb_is_invalid():
    assert not RSA2048Signature.tampered_limb_sample(seed=0).is_valid()


def test_rsa_tampered_expected_message_is_invalid():
    assert not RSA2048Signature.tampered_expected_message_sample(seed=0).is_valid()
