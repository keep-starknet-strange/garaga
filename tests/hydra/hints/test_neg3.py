import random

import pytest

from garaga.hints.neg_3 import neg_3_base_le, positive_negative_multiplicities


@pytest.fixture
def test_params():
    return list(range(128)) + [random.randint(0, 2**128) for _ in range(128)]


def test_neg_3_base_le(test_params):
    for integer in test_params:
        assert (
            sum((-3) ** i * x for i, x in enumerate(neg_3_base_le(integer))) == integer
        )


def test_positive_negative_multiplicities(test_params):
    for integer in test_params:
        ep, en = positive_negative_multiplicities(neg_3_base_le(integer))
        assert integer == ep - en


if __name__ == "__main__":
    pytest.main()
