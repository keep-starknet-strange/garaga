import pytest
from garaga.algebra import Polynomial
from garaga.curves import CurveID, get_base_field, get_irreducible_poly
from garaga.points import G1G2Pair, G1Point, G2Point
from garaga.starknet.tests_and_calldata_generators.mpcheck import MPCheckCalldataBuilder


@pytest.mark.parametrize("curve_id", [CurveID.BN254, CurveID.BLS12_381])
@pytest.mark.parametrize("corruption", [None, "quotient", "remainder", "challenge"])
def test_rlc_equation_accepts_valid_relation_and_rejects_corruption(
    curve_id, corruption
):
    field = get_base_field(curve_id)
    pair = G1G2Pair(G1Point.get_nG(curve_id, 1), G2Point.get_nG(curve_id, 1))
    builder = MPCheckCalldataBuilder(curve_id, [pair, pair], 2, None)
    irreducible = get_irreducible_poly(curve_id=curve_id, extension_degree=12)
    # At z=2, (x+1)(x+2)=12, (x+3)(x+4)=30, and Q(x)=x+7 gives Q(2)=9.
    modulus_at_z = (
        sum(
            coefficient.value * pow(2, index, field.p)
            for index, coefficient in enumerate(irreducible.coefficients)
        )
        % field.p
    )
    target = field(9 * modulus_at_z)
    products = [
        [[field(1), field(1)], [field(2), field(1)]],
        [[field(3), field(1)], [field(4), field(1)]],
    ]
    remainders = [[field.zero()], [field(90) - target]]
    quotient = Polynomial([field(7), field.one()])
    challenge = field(5)
    if corruption == "quotient":
        quotient = Polynomial([field(8), field.one()])
    elif corruption == "remainder":
        remainders[1][0] += field.one()
    elif corruption == "challenge":
        challenge = field(6)

    arguments = (field(2), challenge, 2, products, quotient, remainders)
    if corruption is None:
        builder._sanity_check_verify_rlc_equation(*arguments)
    else:
        with pytest.raises(AssertionError, match="Check failed"):
            builder._sanity_check_verify_rlc_equation(*arguments)
