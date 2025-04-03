import pytest

from garaga.definitions import CurveID
from garaga.starknet.tests_and_calldata_generators.signatures import (
    ECDSASignature,
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


if __name__ == "__main__":
    pytest.main()
