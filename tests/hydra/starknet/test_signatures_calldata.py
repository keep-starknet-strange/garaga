import json

import pytest
from garaga.curves import CurveID
from garaga.starknet.tests_and_calldata_generators.signatures import (
    ECDSASignature,
    EdDSA25519Signature,
    RSA2048Signature,
    SchnorrSignature,
)

# Define the curves to be tested
curves = list(CurveID)


@pytest.mark.parametrize("curve_id", curves)
@pytest.mark.parametrize("prepend_public_key", [True, False])
def test_schnorr_calldata_builder(curve_id, prepend_public_key):
    """Test that Python and Rust implementations of Schnorr signature calldata match"""
    for _ in range(3):  # Test 3 random samples
        # Generate a random valid signature
        sig = SchnorrSignature.sample(curve_id)

        # Get calldata from Python implementation
        calldata1 = sig.serialize_with_hints(
            use_rust=False, prepend_public_key=prepend_public_key
        )

        # Get calldata from Rust implementation
        calldata2 = sig.serialize_with_hints(
            use_rust=True, prepend_public_key=prepend_public_key
        )

        assert (
            calldata1 == calldata2
        ), f"Mismatch in Schnorr calldata for curve {curve_id.name}"


@pytest.mark.parametrize("curve_id", curves)
@pytest.mark.parametrize("prepend_public_key", [True, False])
def test_ecdsa_calldata_builder(curve_id, prepend_public_key):
    """Test that Python and Rust implementations of ECDSA signature calldata match"""
    for _ in range(4):  # Test 4 random samples
        # Generate a random valid signature
        sig = ECDSASignature.sample(curve_id)

        # Get calldata from Python implementation
        calldata1 = sig.serialize_with_hints(
            use_rust=False, prepend_public_key=prepend_public_key
        )

        # Get calldata from Rust implementation
        calldata2 = sig.serialize_with_hints(
            use_rust=True, prepend_public_key=prepend_public_key
        )

        assert (
            calldata1 == calldata2
        ), f"Mismatch in ECDSA calldata for curve {curve_id.name}"


@pytest.mark.parametrize("prepend_public_key", [True, False])
def test_eddsa_25519_signatures(prepend_public_key, full=False):
    with open("tests/ed25519_test_vectors.json", "r") as f:
        test_vectors = json.load(f)

    if full:
        test_vectors = test_vectors
    else:
        test_vectors = test_vectors[0:96]

    for i, test_vector in enumerate(test_vectors):
        signature = EdDSA25519Signature.from_json(test_vector)
        assert signature.is_valid(), f"Signature {i} is invalid"

        calldata_py = signature.serialize_with_hints(
            use_rust=False, prepend_public_key=prepend_public_key
        )
        calldata_rust = signature.serialize_with_hints(
            use_rust=True, prepend_public_key=prepend_public_key
        )

        assert (
            calldata_py == calldata_rust
        ), f"Mismatch in EdDSA calldata for test vector {i}"


@pytest.mark.parametrize("prepend_public_key", [True, False])
def test_rsa2048_calldata_lengths(prepend_public_key):
    signature = RSA2048Signature.sample(seed=0)
    calldata = signature.serialize_with_hints(
        use_rust=False, prepend_public_key=prepend_public_key
    )
    expected_len = 888 if prepend_public_key else 864
    assert len(calldata) == expected_len


def test_rsa2048_calldata_public_key_prefix():
    signature = RSA2048Signature.sample(seed=0)
    full = signature.serialize_with_hints(use_rust=False, prepend_public_key=True)
    public_key = signature.serialize_public_key()
    witness = signature.serialize_signature_with_hints()

    assert full[: len(public_key)] == public_key
    assert full[len(public_key) :] == witness


@pytest.mark.parametrize("prepend_public_key", [True, False])
def test_rsa2048_calldata_builder(prepend_public_key):
    """Test that Python and Rust implementations of RSA-2048 calldata match"""
    for seed in range(3):
        sig = RSA2048Signature.sample(seed=seed)

        calldata_py = sig.serialize_with_hints(
            use_rust=False, prepend_public_key=prepend_public_key
        )
        calldata_rs = sig.serialize_with_hints(
            use_rust=True, prepend_public_key=prepend_public_key
        )

        assert (
            calldata_py == calldata_rs
        ), f"Mismatch in RSA-2048 calldata for seed {seed}"


@pytest.mark.parametrize("prepend_public_key", [True, False])
@pytest.mark.parametrize("message", [b"hello garaga", b"", b"a" * 100, b"\x00\x01\x02"])
def test_rsa2048_sha256_calldata_builder(prepend_public_key, message):
    """Test that Python and Rust implementations of RSA-2048 SHA-256 calldata match"""
    sig = RSA2048Signature.from_sha256_message(message, seed=0)

    calldata_py = sig.serialize_sha256_with_hints(
        message=message,
        use_rust=False,
        prepend_public_key=prepend_public_key,
    )
    calldata_rs = sig.serialize_sha256_with_hints(
        message=message,
        use_rust=True,
        prepend_public_key=prepend_public_key,
    )

    assert (
        calldata_py == calldata_rs
    ), f"Mismatch in RSA-2048 SHA-256 calldata for message {message!r}"


if __name__ == "__main__":
    pytest.main()
