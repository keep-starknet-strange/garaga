import json
import os
from functools import lru_cache

from garaga.algebra import BaseField, Polynomial, PyFelt
from garaga.definitions import CURVES, CurveID, get_irreducible_poly
from garaga.hints.tower_backup import E6, E12


@lru_cache(maxsize=32)
def get_p_powers_of_V(curve_id: int, extension_degree: int, k: int) -> list[Polynomial]:
    """
    Computes V^(i*p^k) for i in range(extension_degree), where V is the polynomial V(X) = X.

    Args:
        curve_id (int): Identifier for the curve.
        extension_degree (int): Degree of the field extension.
        k (int): Exponent in p^k, must be 1, 2, or 3.

    Returns:
        list[Polynomial]: List of polynomials representing V^(i*p^k) for i in range(extension_degree).
    """
    assert k in [1, 2, 3], f"Supported k values are 1, 2, 3. Received: {k}"

    field = BaseField(CURVES[curve_id].p)

    V = Polynomial(
        [field.zero() if i != 1 else field.one() for i in range(extension_degree)]
    )
    if extension_degree == 12:
        V_tower = E12.from_poly(V, curve_id)
    elif extension_degree == 6:
        V_tower = E6.from_poly(V, curve_id)
    else:
        raise ValueError(f"Unsupported extension degree: {extension_degree}")

    V_pow_E12 = [V_tower ** (i * field.p**k) for i in range(extension_degree)]

    V_pow = [v.to_poly() for v in V_pow_E12]
    return V_pow


@lru_cache(maxsize=32)
def get_V_torus_powers(curve_id: int, extension_degree: int, k: int) -> Polynomial:
    """
    Computes 1/V^((p^k - 1) // 2) where V is the polynomial V(X) = X.
    This is used to compute the Frobenius automorphism in the Torus.
    Usage is deprecated since torus arithmetic is not used anymore with the final exp witness.

    Args:
        curve_id (int): Identifier for the curve.
        extension_degree (int): Degree of the field extension.
        k (int): Exponent in p^k, must be 1, 2, or 3.

    Returns:
        list[Polynomial]: List of polynomials representing V^(i*p^k) for i in range(extension_degree).
    """
    assert k in [1, 2, 3], f"Supported k values are 1, 2, 3. Received: {k}"

    field = BaseField(CURVES[curve_id].p)
    irr = get_irreducible_poly(curve_id, extension_degree)

    V = Polynomial(
        [field.zero() if i != 1 else field.one() for i in range(extension_degree)]
    )

    V_pow = V.pow((field.p**k - 1) // 2, irr)
    inverse, _, _ = Polynomial.xgcd(V_pow, irr)
    return inverse


def frobenius(
    F: list[PyFelt], V_pow: list[Polynomial], p: int, frob_power: int, irr: Polynomial
) -> Polynomial:
    """
    Applies the Frobenius automorphism to a polynomial in a direct extension field.

    Args:
        F (list[PyFelt]): Coefficients of the polynomial.
        V_pow (list[Polynomial]): Precomputed powers of V (using get_p_powers_of_V).
        p (int): Prime number of the base field.
        frob_power (int): Power of the Frobenius automorphism.
        irr (Polynomial): Irreducible polynomial for the field extension.

    Returns:
        Polynomial: Result of applying Frobenius automorphism.
    """
    assert len(F) == len(V_pow), "Mismatch in lengths of F and V_pow."
    acc = Polynomial([PyFelt(0, p)])
    for i, f in enumerate(F):
        acc += V_pow[i] * f
    assert acc == (
        Polynomial(F).pow(p**frob_power, irr)
    ), "Mismatch in expected result."
    return acc


CACHE_DIR = "build/frobenius_cache"
os.makedirs(CACHE_DIR, exist_ok=True)


def save_frobenius_maps(
    curve_id, extension_degree, frob_power, k_expressions, constants_list
):
    filename = f"{CACHE_DIR}/frobenius_{curve_id}_{extension_degree}_{frob_power}.json"
    with open(filename, "w") as f:
        json.dump({"k_expressions": k_expressions, "constants_list": constants_list}, f)


def load_frobenius_maps(curve_id, extension_degree, frob_power):
    filename = f"{CACHE_DIR}/frobenius_{curve_id}_{extension_degree}_{frob_power}.json"
    if os.path.exists(filename):
        with open(filename, "r") as f:
            data = json.load(f)
        return data["k_expressions"], data["constants_list"]
    return None, None


@lru_cache(maxsize=32)
def generate_frobenius_maps(
    curve_id, extension_degree: int, frob_power: int
) -> tuple[list[str], list[list[tuple[int, int]]]]:
    """
    Generates symbolic expressions for Frobenius map coefficients and a list of tuples with constants.

    Args:
        curve_id (CurveID): Identifier for the curve.
        extension_degree (int): Degree of the field extension.
        frob_power (int): Power of the Frobenius automorphism.

    Returns:
        tuple[list[str], list[list[tuple[int, int]]]]: Symbolic expressions for each coefficient and a list of tuples with constants.
    """
    curve_id = curve_id if isinstance(curve_id, int) else curve_id.value

    # Try to load from disk first
    k_expressions, constants_list = load_frobenius_maps(
        curve_id, extension_degree, frob_power
    )
    if k_expressions is not None and constants_list is not None:
        return k_expressions, constants_list

    V_pow = get_p_powers_of_V(curve_id, extension_degree, frob_power)

    k_expressions = ["" for _ in range(extension_degree)]
    constants_list = [[] for _ in range(extension_degree)]
    for i in range(extension_degree):
        for f_index, poly in enumerate(V_pow):
            if poly[i] != 0:
                hex_value = f"0x{poly[i].value:x}"
                compact_hex = (
                    f"{hex_value[:6]}...{hex_value[-4:]}"
                    if len(hex_value) > 10
                    else hex_value
                )
                k_expressions[i] += f" + {compact_hex} * f_{f_index}"
                constants_list[i].append((f_index, poly[i].value))

    # Save to disk
    save_frobenius_maps(
        curve_id, extension_degree, frob_power, k_expressions, constants_list
    )

    return k_expressions, constants_list


if __name__ == "__main__":
    from random import randint

    # Frobenius maps
    def test_frobenius_maps():
        constants_lists = {}
        for extension_degree in [6, 12]:
            for curve_id in [CurveID.BN254, CurveID.BLS12_381]:
                if curve_id.name not in constants_lists:
                    constants_lists[curve_id.name] = {}
                if extension_degree not in constants_lists[curve_id.name]:
                    constants_lists[curve_id.name][extension_degree] = {}
                p = CURVES[curve_id.value].p
                for frob_power in [1, 2, 3]:
                    print(
                        f"\nFrobenius^{frob_power} for {curve_id.name} Fp{extension_degree}"
                    )
                    irr = get_irreducible_poly(curve_id.value, extension_degree)

                    V_pow = get_p_powers_of_V(
                        curve_id.value, extension_degree, frob_power
                    )
                    # print(
                    #     f"Torus Inv: {get_V_torus_powers(curve_id.value, extension_degree, frob_power).get_value_coeffs()}"
                    # )
                    F = [PyFelt(randint(0, p - 1), p) for _ in range(extension_degree)]
                    _ = frobenius(F, V_pow, p, frob_power, irr)

                    k_expressions, constants_list = generate_frobenius_maps(
                        curve_id, extension_degree, frob_power
                    )
                    print(
                        f"f = f0 + f1v + ... + f{extension_degree-1}v^{extension_degree-1}"
                    )
                    print(
                        f"Frob(f) = f^p = f0 + f1v^(p^{frob_power}) + f2v^(2p^{frob_power}) + ... + f{extension_degree-1}*v^(({extension_degree-1})p^{frob_power})"
                    )
                    print(
                        f"Frob(f) = k0 + k1v + ... + k{extension_degree-1}v^{extension_degree-1}"
                    )
                    for i, expr in enumerate(k_expressions):
                        print(f"k_{i} = {expr}")
                        print(f"Constants: {constants_list[i]}")
                    constants_lists[curve_id.name][extension_degree][
                        frob_power
                    ] = constants_list
        return constants_lists

    frobs = test_frobenius_maps()

    from garaga.hints.tower_backup import E12

    x = E12.random(1)
    frobenius(
        x.to_poly().get_coeffs(),
        get_p_powers_of_V(1, 12, 1),
        CURVES[1].p,
        1,
        get_irreducible_poly(1, 12),
    )
