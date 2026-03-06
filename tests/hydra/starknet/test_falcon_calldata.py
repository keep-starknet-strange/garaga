"""Tests for Falcon-512 calldata builder via garaga_rs Python bindings."""

import json
import os

import pytest

# Skip entire module if garaga_rs is not built with falcon support
garaga_rs = pytest.importorskip("garaga.garaga_rs")


def test_pack_unpack_roundtrip():
    """Pack 512 Zq values into 29 felt252 and unpack back."""
    coeffs = [(i * 37) % 12289 for i in range(512)]
    packed = garaga_rs.pack_falcon_public_key(coeffs)
    assert len(packed) == 29
    unpacked = garaga_rs.unpack_falcon_public_key(packed)
    assert unpacked == coeffs


def test_pack_zeros():
    """Packing all zeros should roundtrip."""
    coeffs = [0] * 512
    assert (
        garaga_rs.unpack_falcon_public_key(garaga_rs.pack_falcon_public_key(coeffs))
        == coeffs
    )


def test_pack_max_values():
    """Packing all Q-1 = 12288 should roundtrip."""
    coeffs = [12288] * 512
    assert (
        garaga_rs.unpack_falcon_public_key(garaga_rs.pack_falcon_public_key(coeffs))
        == coeffs
    )


def test_calldata_against_vector():
    """Verify calldata builder output matches stored test vector."""
    vector_path = os.path.join(os.path.dirname(__file__), "falcon_test_vector.json")
    with open(vector_path) as f:
        vector = json.load(f)

    vk = bytes.fromhex(vector["vk_hex"])
    sig = bytes.fromhex(vector["sig_hex"])
    msg_bytes = bytes.fromhex(vector["message_hex"])
    msg_felt = int.from_bytes(msg_bytes, "big")
    expected = [int(x) for x in vector["calldata"]]

    result = garaga_rs.falcon_calldata_builder(vk, sig, [msg_felt], True)
    assert result == expected, "Calldata mismatch against test vector"
