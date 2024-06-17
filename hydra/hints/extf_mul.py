from hydra.algebra import Polynomial
from hydra.algebra import PyFelt, ModuloCircuitElement
from hydra.definitions import (
    get_irreducible_poly,
    direct_to_tower,
    tower_to_direct,
    get_base_field,
)
from hydra.hints.tower_backup import get_tower_object, E6
from functools import reduce
import operator


# Returns (Q(X), R(X)) such that Π(Pi)(X) = Q(X) * P_irr(X) + R(X), for a given curve and extension degree.
# R(X) is the result of the multiplication in the extension field.
# Q(X) is used for verification.
def nondeterministic_extension_field_mul_divmod(
    Ps: list[list[PyFelt | ModuloCircuitElement]],
    curve_id: int,
    extension_degree: int,
) -> tuple[list[PyFelt], list[PyFelt]]:

    Ps = [Polynomial(P) for P in Ps]
    field = get_base_field(curve_id)

    P_irr = get_irreducible_poly(curve_id, extension_degree)

    z_poly = reduce(operator.mul, Ps)  #  Π(Pi)
    z_polyr = z_poly % P_irr
    z_polyq = z_poly // P_irr
    z_polyr_coeffs = z_polyr.get_coeffs()
    z_polyq_coeffs = z_polyq.get_coeffs()
    # assert len(z_polyq_coeffs) <= (
    #     extension_degree - 1
    # ), f"len z_polyq_coeffs={len(z_polyq_coeffs)}, degree: {z_polyq.degree()}"
    assert (
        len(z_polyr_coeffs) <= extension_degree
    ), f"len z_polyr_coeffs={len(z_polyr_coeffs)}, degree: {z_polyr.degree()}"

    # Extend polynomials with 0 coefficients to match the expected lengths.
    # TODO : pass exact expected max degree when len(Ps)>2.
    z_polyq_coeffs += [field(0)] * (extension_degree - 1 - len(z_polyq_coeffs))
    z_polyr_coeffs += [field(0)] * (extension_degree - len(z_polyr_coeffs))

    return (z_polyq_coeffs, z_polyr_coeffs)


def nondeterministic_square_torus(
    A: list[PyFelt | ModuloCircuitElement],
    curve_id: int,
    biject_from_direct: bool = True,
) -> list[PyFelt]:
    """
    Computes 1/2 * (A(x) + x/A(x))
    """
    A = direct_to_tower(A, curve_id, 6) if biject_from_direct else A
    A = E6(A, curve_id)
    SQ: list[PyFelt] = A.square_torus().felt_coeffs
    return tower_to_direct(SQ, curve_id, 6) if biject_from_direct else SQ


# Returns (A/B)(X) mod P_irr(X)
def nondeterministic_extension_field_div(
    A: list[PyFelt | ModuloCircuitElement],
    B: list[PyFelt | ModuloCircuitElement],
    curve_id: int,
    extension_degree: int = 6,
) -> tuple[list[PyFelt], list[PyFelt]]:

    A = direct_to_tower(A, curve_id, extension_degree)
    B = direct_to_tower(B, curve_id, extension_degree)

    A = get_tower_object(A, curve_id, extension_degree)
    B = get_tower_object(B, curve_id, extension_degree)

    DIV = A.div(B).felt_coeffs
    return tower_to_direct(DIV, curve_id, extension_degree)


if __name__ == "__main__":
    from hydra.definitions import BN254_ID, get_base_field, CURVES, get_irreducible_poly
    from random import randint as rint
    import random

    field = get_base_field(BN254_ID)
    p = field.p
    # ins = [rint(0, p - 1) for _ in range(6)]
    # sq = nondeterministic_square_torus(
    #     [field_bn254(x) for x in ins],
    #     BN254_ID,
    # )

    # two_e6 = E6([2, 0, 0, 0, 0, 0], BN254_ID)
    # sq = E6(sq, BN254_ID)
    # x = E6(ins, BN254_ID)

    # print(f"Should be V : ", x * (two_e6 * sq - x))

    A = [field(rint(0, p - 1)) for _ in range(12)]
    Q, R = nondeterministic_extension_field_mul_divmod([A, A, A], BN254_ID, 12)
    Q, R = Polynomial(Q), Polynomial(R)

    z = field(rint(0, p - 1))

    P_irr = get_irreducible_poly(BN254_ID, 12)

    lhs = Polynomial(A).evaluate(z)
    lhs = lhs * lhs * lhs
    rhs = Q.evaluate(z) * P_irr.evaluate(z) + R.evaluate(z)
    assert lhs == rhs
