import time

import pytest

from garaga.definitions import CurveID
from garaga.hints.tower_backup import E12


@pytest.mark.parametrize("curve_id", [CurveID.BN254.value, CurveID.BLS12_381.value])
def test_tower_final_exp(curve_id):
    e12 = E12.random(curve_id)
    start = time.time()
    e12t = e12.final_exp(use_rust=False)
    end = time.time()
    print(f"Python final_exp time: {end - start}")
    start = time.time()
    e12t_rust = e12.final_exp(use_rust=True)
    end = time.time()
    print(f"Rust final_exp time: {end - start}")
    assert e12t == e12t_rust
