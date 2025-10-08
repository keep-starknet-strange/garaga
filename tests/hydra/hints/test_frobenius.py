import pytest

from garaga.curves import CurveID
from garaga.hints.frobenius import generate_frobenius_maps, get_frobenius_maps


@pytest.mark.parametrize("curve_id", [CurveID.BN254.value, CurveID.BLS12_381.value])
@pytest.mark.parametrize("extension_degree", [6, 12])
@pytest.mark.parametrize("frob_power", [1, 2, 3])
def test_get_frobenius_maps(curve_id, extension_degree, frob_power):
    k_expressions, constants_list = get_frobenius_maps(
        curve_id, extension_degree, frob_power
    )
    k_expressions_gen, constants_list_gen = generate_frobenius_maps(
        curve_id, extension_degree, frob_power
    )
    assert k_expressions == k_expressions_gen, f"{k_expressions} != {k_expressions_gen}"
    assert constants_list == constants_list_gen
