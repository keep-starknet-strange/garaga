import time

import pytest

from garaga import garaga_rs
from garaga.precompiled_circuits.poseidon_bn254 import poseidon_hash


def test_poseidon_hash_bn254():
    # Test with valid inputs
    x = 1
    y = 2
    expected = 0x115CC0F5E7D690413DF64C6B9662E9CF2A3617F2743245519E19607A4417189A

    tr0 = time.time()
    for _ in range(20):
        result = garaga_rs.poseidon_hash_bn254(x, y)
    tr1 = time.time()
    print(f"Garaga RS time: {tr1 - tr0} seconds")
    assert result == expected

    tp0 = time.time()
    for _ in range(20):
        result = poseidon_hash(x, y)
    tp1 = time.time()

    print(f"Garaga Python time: {tp1 - tp0} seconds")
    assert result.value == expected

    # Test different inputs give different results
    result2 = garaga_rs.poseidon_hash_bn254(2, 1)
    assert result != result2

    # Test with large numbers
    x_large = 2**255 - 1
    y_large = 2**255 - 2
    result = garaga_rs.poseidon_hash_bn254(x_large, y_large)
    assert isinstance(result, int)
    assert len(hex(result)[2:]) <= 64  # Result should be within field size

    # Test invalid inputs
    with pytest.raises(OverflowError):
        garaga_rs.poseidon_hash_bn254(-1, 1)  # Negative numbers not allowed
