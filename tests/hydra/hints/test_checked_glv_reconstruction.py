from math import isqrt

import pytest
from garaga.hints import eisenstein, fake_glv, lattice


def assert_contract(values, modulus, scalar, eigenvalue):
    u1, u2, v1, v2 = values
    denominator = (v1 + eigenvalue * v2) % modulus
    assert denominator != 0
    assert (u1 + eigenvalue * u2 + scalar * denominator) % modulus == 0
    width = (modulus.bit_length() + 3) // 4 + 1
    assert all(abs(value).bit_length() <= width for value in values)


@pytest.mark.parametrize("scalar", [5, 18, -8])
def test_valid_eisenstein_fast_path_does_not_call_lll(monkeypatch, scalar):
    def unexpected_lll(*args):
        pytest.fail("A valid bounded Eisenstein result must use the fast path")

    monkeypatch.setattr(lattice, "rational_reconstruct_extension", unexpected_lll)
    result = fake_glv.half_gcd_eisenstein_hint(13, scalar, 3)
    assert result == (1, 0, -2, -2)
    assert_contract(result, 13, scalar, 3)


def test_full_lll_fallback_accepts_the_proven_extra_bit():
    result = fake_glv.half_gcd_eisenstein_hint(13, 5, 0)
    assert result == lattice.rational_reconstruct_extension(13, 5, 0)
    assert max(map(abs, result)) == 3
    assert max(map(abs, result)) > isqrt(isqrt(13))
    assert_contract(result, 13, 5, 0)


def test_precompute_failure_uses_actual_lll():
    result = fake_glv.half_gcd_eisenstein_hint(15, 5, 5)
    assert result == lattice.rational_reconstruct_extension(15, 5, 5)
    assert_contract(result, 15, 5, 5)


@pytest.mark.parametrize(
    "numerator,denominator",
    [
        (
            (0, 0),
            (-3, 1),
        ),  # Nonzero coordinates can encode a zero effective denominator.
        ((0, 0), (1, 0)),  # Bounded coefficients do not establish the scalar relation.
        (
            (14, 0),
            (-2, -2),
        ),  # A valid scalar relation does not establish the width bound.
    ],
    ids=["zero_effective_denominator", "wrong_relation", "wide_valid_relation"],
)
def test_invalid_fast_candidate_uses_actual_lll(monkeypatch, numerator, denominator):
    real_lll = lattice.rational_reconstruct_extension
    calls = []

    def recorded_lll(*args):
        calls.append(args)
        return real_lll(*args)

    def forged_half_gcd(*args):
        return (
            eisenstein.EisensteinInteger(*numerator),
            eisenstein.EisensteinInteger(*denominator),
            eisenstein.EisensteinInteger(0, 0),
        )

    monkeypatch.setattr(lattice, "rational_reconstruct_extension", recorded_lll)
    monkeypatch.setattr(eisenstein, "half_gcd", forged_half_gcd)
    result = fake_glv.half_gcd_eisenstein_hint(13, 5, 3)
    assert calls == [(13, 5, 3)]
    assert result == real_lll(13, 5, 3)
    assert_contract(result, 13, 5, 3)


@pytest.mark.parametrize("modulus", [0, 1, -13])
def test_checked_reconstruction_rejects_invalid_modulus(modulus):
    with pytest.raises(ValueError, match="modulus"):
        fake_glv.half_gcd_eisenstein_hint(modulus, 5, 3)
