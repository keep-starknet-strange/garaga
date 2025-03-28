import json

import pytest

from garaga.definitions import CurveID
from garaga.starknet.tests_and_calldata_generators.signatures import (
    ECDSASignature,
    EdDSA25519Signature,
    SchnorrSignature,
)

# Define the curves to be tested
curves = list(CurveID)


@pytest.mark.parametrize("curve_id", curves)
def test_schnorr_calldata_builder(curve_id):
    """Test that Python and Rust implementations of Schnorr signature calldata match"""
    for _ in range(3):  # Test 3 random samples
        # Generate a random valid signature
        sig = SchnorrSignature.sample(curve_id)

        # Get calldata from Python implementation
        calldata1 = sig.serialize_with_hints(use_rust=False)

        # Get calldata from Rust implementation
        calldata2 = sig.serialize_with_hints(use_rust=True)

        assert (
            calldata1 == calldata2
        ), f"Mismatch in Schnorr calldata for curve {curve_id.name}"


@pytest.mark.parametrize("curve_id", curves)
def test_ecdsa_calldata_builder(curve_id):
    """Test that Python and Rust implementations of ECDSA signature calldata match"""
    for _ in range(4):  # Test 4 random samples
        # Generate a random valid signature
        sig = ECDSASignature.sample(curve_id)

        # Get calldata from Python implementation
        calldata1 = sig.serialize_with_hints(use_rust=False)

        # Get calldata from Rust implementation
        calldata2 = sig.serialize_with_hints(use_rust=True)

        assert (
            calldata1 == calldata2
        ), f"Mismatch in ECDSA calldata for curve {curve_id.name}"


def test_eddsa_25519_signatures(full=False):
    with open("build/ed25519_test_vectors.json", "r") as f:
        test_vectors = json.load(f)

    if full:
        test_vectors = test_vectors
    else:
        test_vectors = test_vectors[0:96]

    for i, test_vector in enumerate(test_vectors):
        signature = EdDSA25519Signature.from_json(test_vector)
        assert signature.is_valid(), f"Signature {i} is invalid"

        calldata_py = signature.serialize_with_hints(use_rust=False)
        calldata_rust = signature.serialize_with_hints(use_rust=True)

        assert (
            calldata_py == calldata_rust
        ), f"Mismatch in EdDSA calldata for test vector {i}"


if __name__ == "__main__":
    pytest.main()
