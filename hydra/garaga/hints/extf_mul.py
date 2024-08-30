from garaga import garaga_rs
from garaga.algebra import ModuloCircuitElement, Polynomial, PyFelt
from garaga.definitions import (
    direct_to_tower,
    get_base_field,
    get_irreducible_poly,
    tower_to_direct,
)
from garaga.hints.tower_backup import E6, get_tower_object


def nondeterministic_extension_field_mul_divmod(
    Ps: list[list[PyFelt | ModuloCircuitElement]],
    curve_id: int,
    extension_degree: int,
) -> tuple[list[PyFelt], list[PyFelt]]:
    """
    From a list of Polynomials Ps = [P1, ..., Pn]
    Returns (Q(X), R(X)) such that Π(Pi)(X) = Q(X) * P_irr(X) + R(X), for a given curve and extension degree.
    R(X) is the result of the multiplication in the extension field.
    Q(X) is used for verification.
    """
    field = get_base_field(curve_id)
    ps = [[c.value for c in P] for P in Ps]
    q, r = garaga_rs.nondeterministic_extension_field_mul_divmod(
        curve_id, extension_degree, ps
    )
    z_polyq_coeffs = [field(c) for c in q] if len(q) > 0 else [field.zero()]
    z_polyr_coeffs = [field(c) for c in r] if len(r) > 0 else [field.zero()]
    return (z_polyq_coeffs, z_polyr_coeffs)


def nondeterministic_square_torus(
    A: list[PyFelt | ModuloCircuitElement],
    curve_id: int,
    biject_from_direct: bool = True,
) -> list[PyFelt]:
    """
    Computes 1/2 * (A(x) + x/A(x))
    Deprecated usage as Torus based arithmetic is not used anymore with the final exp witness.
    """
    A = direct_to_tower(A, curve_id, 6) if biject_from_direct else A
    A = E6(A, curve_id)
    SQ: list[PyFelt] = A.square_torus().felt_coeffs
    return tower_to_direct(SQ, curve_id, 6) if biject_from_direct else SQ


def nondeterministic_extension_field_div(
    A: list[PyFelt | ModuloCircuitElement],
    B: list[PyFelt | ModuloCircuitElement],
    curve_id: int,
    extension_degree: int = 6,
) -> tuple[list[PyFelt], list[PyFelt]]:
    """
    From two Polynomials A and B
    Returns (A/B)(X) mod P_irr(X)
    Converts back and forth to tower representaion for faster inversion.
    """

    A = direct_to_tower(A, curve_id, extension_degree)
    B = direct_to_tower(B, curve_id, extension_degree)

    A = get_tower_object(A, curve_id, extension_degree)
    B = get_tower_object(B, curve_id, extension_degree)

    DIV = A.div(B).felt_coeffs
    return tower_to_direct(DIV, curve_id, extension_degree)


if __name__ == "__main__":
    from random import randint as rint

    from garaga.definitions import (
        BLS12_381_ID,
        BN254_ID,
        get_base_field,
        get_irreducible_poly,
    )

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

    # Test BLS12-381
    field = get_base_field(BLS12_381_ID)
    p = field.p
    A = [field(rint(0, p - 1)) for _ in range(12)]
    Q, R = nondeterministic_extension_field_mul_divmod([A, A], BLS12_381_ID, 12)
    Q, R = Polynomial(Q), Polynomial(R)

    def print_as_sage_poly(X: Polynomial, var_name="z"):
        coeffs = X.get_value_coeffs()
        string = ""
        for coeff in coeffs[::-1]:
            string += f"{hex(coeff)}*{var_name}^{coeffs.index(coeff)} + "
        print(string[:-3])

    print_as_sage_poly(Polynomial(A))
    print_as_sage_poly(R)
