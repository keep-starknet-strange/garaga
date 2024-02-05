from src.algebra import Polynomial
from src.algebra import FieldElement, ModuloElement
from src.definitions import get_irreducible_poly, get_base_field
from typing import Union
from src.hints.tower_backup import E6


# Returns (Q(X), R(X)) such that (A*B)(X) = Q(X) * P_irr(X) + R(X), for a given curve and extension degree.
# R(X) is the result of the multiplication in the extension field.
# Q(X) is used for verification.
def nondeterministic_extension_field_mul_divmod(
    A: list[Union[FieldElement, ModuloElement]],
    B: list[Union[FieldElement, ModuloElement]],
    curve_id: int,
    extension_degree: int,
) -> tuple[list[FieldElement], list[FieldElement]]:

    A_poly = Polynomial(A)
    B_poly = Polynomial(B)

    P_irr = get_irreducible_poly(curve_id, extension_degree)

    z_poly = A_poly * B_poly
    z_polyr = z_poly % P_irr
    z_polyq = z_poly // P_irr
    z_polyr_coeffs = z_polyr.get_coeffs()
    z_polyq_coeffs = z_polyq.get_coeffs()
    assert len(z_polyq_coeffs) <= (
        extension_degree - 1
    ), f"len z_polyq_coeffs={len(z_polyq_coeffs)}, degree: {z_polyq.degree()}"
    assert (
        len(z_polyr_coeffs) <= extension_degree
    ), f"len z_polyr_coeffs={len(z_polyr_coeffs)}, degree: {z_polyr.degree()}"

    # Extend polynomials with 0 coefficients to match the expected lengths.
    z_polyq_coeffs = z_polyq_coeffs + [0] * (extension_degree - 1 - len(z_polyq_coeffs))
    z_polyr_coeffs = z_polyr_coeffs + [0] * (extension_degree - len(z_polyr_coeffs))

    return (z_polyq_coeffs, z_polyr_coeffs)


def nondeterministic_square_torus(
    A: list[Union[FieldElement, ModuloElement]], curve_id: int
) -> list[FieldElement]:
    # Computes 1/2 * (A(x) + x/A(x))
    A = E6([a.value for a in A], curve_id)
    SQ: E6 = A.square_torus()
    return SQ.felt_coeffs


if __name__ == "__main__":
    from src.definitions import BN254_ID, field_bn254, CURVES
    from random import randint as rint
    import random

    p = field_bn254.p
    ins = [rint(0, p - 1) for _ in range(6)]
    sq = nondeterministic_square_torus(
        [field_bn254(x) for x in ins],
        BN254_ID,
    )

    two_e6 = E6([2, 0, 0, 0, 0, 0], BN254_ID)
    sq = E6(sq, BN254_ID)
    x = E6(ins, BN254_ID)

    print(f"Should be V : ", x * (two_e6 * sq - x))
