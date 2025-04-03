from functools import lru_cache

from garaga.algebra import BaseField, Polynomial, PyFelt
from garaga.definitions import CURVES, CurveID, get_irreducible_poly
from garaga.hints.tower_backup import E6, E12

# Cache directory path
CACHE_DIR = "build/frobenius_cache"


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
                constants_list[i].append([f_index, poly[i].value])

    return k_expressions, constants_list


def get_frobenius_maps(curve_id, extension_degree, frob_power):
    res = FROBENIUS_MAPS[curve_id][extension_degree][frob_power]
    return res["k_expressions"], res["constants_list"]


FROBENIUS_MAPS = {
    CurveID.BN254.value: {
        6: {
            1: {
                "k_expressions": [
                    " + 0x1 * f_0 + 0x12 * f_3",
                    " + 0x242b...21a7 * f_1 + 0x3598...2536 * f_4",
                    " + 0x2c84...048b * f_2 + 0xc33b...a7b5 * f_5",
                    " + 0x3064...fd46 * f_3",
                    " + 0x16c9...cba2 * f_1 + 0xc38d...dba0 * f_4",
                    " + 0x2c14...8126 * f_2 + 0x3df9...f8bc * f_5",
                ],
                "constants_list": [
                    [[0, 0x1], [3, 0x12]],
                    [
                        [
                            1,
                            0x242B719062F6737B8481D22C6934CE844D72F250FD28D102C0D147B2F4D521A7,
                        ],
                        [
                            4,
                            0x359809094BD5C8E1B9C22D81246FFC2E794E17643AC198484B8D9094AA82536,
                        ],
                    ],
                    [
                        [
                            2,
                            0x2C84BBAD27C3671562B7ADEFD44038AB3C0BBAD96FC008E7D6998C82F7FC048B,
                        ],
                        [
                            5,
                            0xC33B1C70E4FD11B6D1EAB6FCD18B99AD4AFD096A8697E0C9C36D8CA3339A7B5,
                        ],
                    ],
                    [
                        [
                            3,
                            0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD46,
                        ]
                    ],
                    [
                        [
                            1,
                            0x16C9E55061EBAE204BA4CC8BD75A079432AE2A1D0B7C9DCE1665D51C640FCBA2,
                        ],
                        [
                            4,
                            0xC38DCE27E3B2CAE33CE738A184C89D94A0E78406B48F98A7B4F4463E3A7DBA0,
                        ],
                    ],
                    [
                        [
                            2,
                            0x2C145EDBE7FD8AEE9F3A80B03B0B1C923685D2EA1BDEC763C13B4711CD2B8126,
                        ],
                        [
                            5,
                            0x3DF92C5B96E3914559897C6AD411FB25B75AFB7F8B1C1A56586FF93E080F8BC,
                        ],
                    ],
                ],
            },
            2: {
                "k_expressions": [
                    " + 0x1 * f_0",
                    " + 0x3064...fd48 * f_1",
                    " + 0x59e2...fffe * f_2",
                    " + 0x1 * f_3",
                    " + 0x3064...fd48 * f_4",
                    " + 0x59e2...fffe * f_5",
                ],
                "constants_list": [
                    [[0, 0x1]],
                    [
                        [
                            1,
                            0x30644E72E131A0295E6DD9E7E0ACCCB0C28F069FBB966E3DE4BD44E5607CFD48,
                        ]
                    ],
                    [[2, 0x59E26BCEA0D48BACD4F263F1ACDB5C4F5763473177FFFFFE]],
                    [[3, 0x1]],
                    [
                        [
                            4,
                            0x30644E72E131A0295E6DD9E7E0ACCCB0C28F069FBB966E3DE4BD44E5607CFD48,
                        ]
                    ],
                    [[5, 0x59E26BCEA0D48BACD4F263F1ACDB5C4F5763473177FFFFFE]],
                ],
            },
            3: {
                "k_expressions": [
                    " + 0x1 * f_0 + 0x12 * f_3",
                    " + 0xc3a5...3ae6 * f_1 + 0x2ce0...77f4 * f_4",
                    " + 0x1bfe...9cc0 * f_2 + 0x697b...2fbd * f_5",
                    " + 0x3064...fd46 * f_3",
                    " + 0x4f1d...86de * f_1 + 0x2429...c261 * f_4",
                    " + 0x23d5...239f * f_2 + 0x1465...6087 * f_5",
                ],
                "constants_list": [
                    [[0, 0x1], [3, 0x12]],
                    [
                        [
                            1,
                            0xC3A5E9C462A654779C3E050C9CA2A428908A81264E2B5A5BF22F67654883AE6,
                        ],
                        [
                            4,
                            0x2CE02AA5F9BF8CD65BDD2055C255CF9D9E08C1D9345582CC92FD973C74BD77F4,
                        ],
                    ],
                    [
                        [
                            2,
                            0x1BFE7B214C0294242FB81A8DCCD8A9B4441D64F34150A79753FB0CD31CC99CC0,
                        ],
                        [
                            5,
                            0x697B9C523E0390ED15DA0EC97A9B8346513297B9EFAF0F0F1A228F0D5662FBD,
                        ],
                    ],
                    [
                        [
                            3,
                            0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD46,
                        ]
                    ],
                    [
                        [
                            1,
                            0x4F1DE41B3D1766FA9F30E6DEC26094F0FDF31BF98FF2631380CAB2BAAA586DE,
                        ],
                        [
                            4,
                            0x2429EFD69B073AE23E8C6565B7B72E1B0E78C27F038F14E77CFD95A083F4C261,
                        ],
                    ],
                    [
                        [
                            2,
                            0x23D5E999E1910A12FEB0F6EF0CD21D04A44A9E08737F96E55FE3ED9D730C239F,
                        ],
                        [
                            5,
                            0x1465D351952F0C0588982B28B4A8AEA95364059E272122F5E8257F43BBB36087,
                        ],
                    ],
                ],
            },
        },
        12: {
            1: {
                "k_expressions": [
                    " + 0x1 * f_0 + 0x12 * f_6",
                    " + 0x1d8c...5955 * f_1 + 0x217e...a71a * f_7",
                    " + 0x242b...21a7 * f_2 + 0x3598...2536 * f_8",
                    " + 0x2143...d5ed * f_3 + 0x1885...f771 * f_9",
                    " + 0x2c84...048b * f_4 + 0xc33b...a7b5 * f_10",
                    " + 0x1b00...cfa8 * f_5 + 0x215d...3977 * f_11",
                    " + 0x3064...fd46 * f_6",
                    " + 0x2469...62ac * f_1 + 0x12d7...a3f2 * f_7",
                    " + 0x16c9...cba2 * f_2 + 0xc38d...dba0 * f_8",
                    " + 0x7c03...b0e3 * f_3 + 0xf20e...275a * f_9",
                    " + 0x2c14...8126 * f_4 + 0x3df9...f8bc * f_10",
                    " + 0x12ac...2c4b * f_5 + 0x1563...2d9f * f_11",
                ],
                "constants_list": [
                    [[0, 0x1], [6, 0x12]],
                    [
                        [
                            1,
                            0x1D8C8DAEF3EEE1E81B2522EC5EB28DED6895E1CDFDE6A43F5DAA971F3FA65955,
                        ],
                        [
                            7,
                            0x217E400DC9351E774E34E2AC06EAD4000D14D1E242B29C567E9C385CE480A71A,
                        ],
                    ],
                    [
                        [
                            2,
                            0x242B719062F6737B8481D22C6934CE844D72F250FD28D102C0D147B2F4D521A7,
                        ],
                        [
                            8,
                            0x359809094BD5C8E1B9C22D81246FFC2E794E17643AC198484B8D9094AA82536,
                        ],
                    ],
                    [
                        [
                            3,
                            0x21436D48FCB50CC60DD4EF1E69A0C1F0DD2949FA6DF7B44CBB259EF7CB58D5ED,
                        ],
                        [
                            9,
                            0x18857A58F3B5BB3038A4311A86919D9C7C6C15F88A4F4F0831364CF35F78F771,
                        ],
                    ],
                    [
                        [
                            4,
                            0x2C84BBAD27C3671562B7ADEFD44038AB3C0BBAD96FC008E7D6998C82F7FC048B,
                        ],
                        [
                            10,
                            0xC33B1C70E4FD11B6D1EAB6FCD18B99AD4AFD096A8697E0C9C36D8CA3339A7B5,
                        ],
                    ],
                    [
                        [
                            5,
                            0x1B007294A55ACCCE13FE08BEA73305FF6BDAC77C5371C546D428780A6E3DCFA8,
                        ],
                        [
                            11,
                            0x215D42E7AC7BD17CEFE88DD8E6965B3ADAE92C974F501FE811493D72543A3977,
                        ],
                    ],
                    [
                        [
                            6,
                            0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD46,
                        ]
                    ],
                    [
                        [
                            1,
                            0x246996F3B4FAE7E6A6327CFE12150B8E747992778EEEC7E5CA5CF05F80F362AC,
                        ],
                        [
                            7,
                            0x12D7C0C3ED42BE419D2B22CA22CECA702EEB88C36A8B264DDE75F4F798D6A3F2,
                        ],
                    ],
                    [
                        [
                            2,
                            0x16C9E55061EBAE204BA4CC8BD75A079432AE2A1D0B7C9DCE1665D51C640FCBA2,
                        ],
                        [
                            8,
                            0xC38DCE27E3B2CAE33CE738A184C89D94A0E78406B48F98A7B4F4463E3A7DBA0,
                        ],
                    ],
                    [
                        [
                            3,
                            0x7C03CBCAC41049A0704B5A7EC796F2B21807DC98FA25BD282D37F632623B0E3,
                        ],
                        [
                            9,
                            0xF20E129E47C9363AA7B569817E0966CBA582096FA7A164080FAED1F0D24275A,
                        ],
                    ],
                    [
                        [
                            4,
                            0x2C145EDBE7FD8AEE9F3A80B03B0B1C923685D2EA1BDEC763C13B4711CD2B8126,
                        ],
                        [
                            10,
                            0x3DF92C5B96E3914559897C6AD411FB25B75AFB7F8B1C1A56586FF93E080F8BC,
                        ],
                    ],
                    [
                        [
                            5,
                            0x12ACF2CA76FD0675A27FB246C7729F7DB080CB99678E2AC024C6B8EE6E0C2C4B,
                        ],
                        [
                            11,
                            0x1563DBDE3BD6D35BA4523CF7DA4E525E2BA6A3151500054667F8140C6A3F2D9F,
                        ],
                    ],
                ],
            },
            2: {
                "k_expressions": [
                    " + 0x1 * f_0",
                    " + 0x3064...fd49 * f_1",
                    " + 0x3064...fd48 * f_2",
                    " + 0x3064...fd46 * f_3",
                    " + 0x59e2...fffe * f_4",
                    " + 0x59e2...ffff * f_5",
                    " + 0x1 * f_6",
                    " + 0x3064...fd49 * f_7",
                    " + 0x3064...fd48 * f_8",
                    " + 0x3064...fd46 * f_9",
                    " + 0x59e2...fffe * f_10",
                    " + 0x59e2...ffff * f_11",
                ],
                "constants_list": [
                    [[0, 0x1]],
                    [
                        [
                            1,
                            0x30644E72E131A0295E6DD9E7E0ACCCB0C28F069FBB966E3DE4BD44E5607CFD49,
                        ]
                    ],
                    [
                        [
                            2,
                            0x30644E72E131A0295E6DD9E7E0ACCCB0C28F069FBB966E3DE4BD44E5607CFD48,
                        ]
                    ],
                    [
                        [
                            3,
                            0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD46,
                        ]
                    ],
                    [[4, 0x59E26BCEA0D48BACD4F263F1ACDB5C4F5763473177FFFFFE]],
                    [[5, 0x59E26BCEA0D48BACD4F263F1ACDB5C4F5763473177FFFFFF]],
                    [[6, 0x1]],
                    [
                        [
                            7,
                            0x30644E72E131A0295E6DD9E7E0ACCCB0C28F069FBB966E3DE4BD44E5607CFD49,
                        ]
                    ],
                    [
                        [
                            8,
                            0x30644E72E131A0295E6DD9E7E0ACCCB0C28F069FBB966E3DE4BD44E5607CFD48,
                        ]
                    ],
                    [
                        [
                            9,
                            0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD46,
                        ]
                    ],
                    [[10, 0x59E26BCEA0D48BACD4F263F1ACDB5C4F5763473177FFFFFE]],
                    [[11, 0x59E26BCEA0D48BACD4F263F1ACDB5C4F5763473177FFFFFF]],
                ],
            },
            3: {
                "k_expressions": [
                    " + 0x1 * f_0 + 0x12 * f_6",
                    " + 0x13d0...dd76 * f_1 + 0x18a0...7a66 * f_7",
                    " + 0xc3a5...3ae6 * f_2 + 0x2ce0...77f4 * f_8",
                    " + 0xf20e...275a * f_3 + 0x17de...05d6 * f_9",
                    " + 0x1bfe...9cc0 * f_4 + 0x697b...2fbd * f_10",
                    " + 0x7a0e...c6fe * f_5 + 0x1b76...267f * f_11",
                    " + 0x3064...fd46 * f_6",
                    " + 0xabf8...c101 * f_1 + 0x1c93...1fd1 * f_7",
                    " + 0x4f1d...86de * f_2 + 0x2429...c261 * f_8",
                    " + 0x28a4...4c64 * f_3 + 0x2143...d5ed * f_9",
                    " + 0x23d5...239f * f_4 + 0x1465...6087 * f_10",
                    " + 0x16db...2499 * f_5 + 0x28c3...3649 * f_11",
                ],
                "constants_list": [
                    [[0, 0x1], [6, 0x12]],
                    [
                        [
                            1,
                            0x13D0C369615F7BB0B2BDFA8FEF85FA07122BDE8D67DFC8FABD3581AD840DDD76,
                        ],
                        [
                            7,
                            0x18A0F4219F4FDFF6FC2BF531EB331A053A35744CAC285AF5685D3F90EACF7A66,
                        ],
                    ],
                    [
                        [
                            2,
                            0xC3A5E9C462A654779C3E050C9CA2A428908A81264E2B5A5BF22F67654883AE6,
                        ],
                        [
                            8,
                            0x2CE02AA5F9BF8CD65BDD2055C255CF9D9E08C1D9345582CC92FD973C74BD77F4,
                        ],
                    ],
                    [
                        [
                            3,
                            0xF20E129E47C9363AA7B569817E0966CBA582096FA7A164080FAED1F0D24275A,
                        ],
                        [
                            9,
                            0x17DED419ED7BE4F97FAC149BFAEFBAC11B155498DE227B850AEA3F23790405D6,
                        ],
                    ],
                    [
                        [
                            4,
                            0x1BFE7B214C0294242FB81A8DCCD8A9B4441D64F34150A79753FB0CD31CC99CC0,
                        ],
                        [
                            10,
                            0x697B9C523E0390ED15DA0EC97A9B8346513297B9EFAF0F0F1A228F0D5662FBD,
                        ],
                    ],
                    [
                        [
                            5,
                            0x7A0E052F2B1C443B5186D6AC4C723B85D3F78A3182D2DB0C413901C32B0C6FE,
                        ],
                        [
                            11,
                            0x1B76A37FBA85F3CD5DC79824A3792597356C892C39C0D06B220500933945267F,
                        ],
                    ],
                    [
                        [
                            6,
                            0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD46,
                        ]
                    ],
                    [
                        [
                            1,
                            0xABF8B60BE77D7306CBEEE33576139D7F03A5E397D439EC7694AA2BF4C0C101,
                        ],
                        [
                            7,
                            0x1C938B097FD2247905924B2691FB5E5685558C04009201927EEB0A69546F1FD1,
                        ],
                    ],
                    [
                        [
                            2,
                            0x4F1DE41B3D1766FA9F30E6DEC26094F0FDF31BF98FF2631380CAB2BAAA586DE,
                        ],
                        [
                            8,
                            0x2429EFD69B073AE23E8C6565B7B72E1B0E78C27F038F14E77CFD95A083F4C261,
                        ],
                    ],
                    [
                        [
                            3,
                            0x28A411B634F09B8FB14B900E9507E9327600ECC7D8CF6EBAB94D0CB3B2594C64,
                        ],
                        [
                            9,
                            0x21436D48FCB50CC60DD4EF1E69A0C1F0DD2949FA6DF7B44CBB259EF7CB58D5ED,
                        ],
                    ],
                    [
                        [
                            4,
                            0x23D5E999E1910A12FEB0F6EF0CD21D04A44A9E08737F96E55FE3ED9D730C239F,
                        ],
                        [
                            10,
                            0x1465D351952F0C0588982B28B4A8AEA95364059E272122F5E8257F43BBB36087,
                        ],
                    ],
                    [
                        [
                            5,
                            0x16DB366A59B1DD0B9FB1B2282A48633D3E2DDAEA200280211F25041384282499,
                        ],
                        [
                            11,
                            0x28C36E1FEE7FDBE60337D84BBCBA34A53A41F1EE50449CDC780CFBFAA5CC3649,
                        ],
                    ],
                ],
            },
        },
    },
    CurveID.BLS12_381.value: {
        6: {
            1: {
                "k_expressions": [
                    " + 0x1 * f_0 + 0x2 * f_3",
                    " + 0x5f19...ffff * f_1",
                    " + 0x1a01...aaad * f_2 + 0x1a01...aaaf * f_5",
                    " + 0x1a01...aaaa * f_3",
                    " + 0x1a01...aaac * f_1 + 0x1a01...aaac * f_4",
                    " + 0x5f19...fffe * f_5",
                ],
                "constants_list": [
                    [[0x0, 0x1], [0x3, 0x2]],
                    [
                        [
                            0x1,
                            0x5F19672FDF76CE51BA69C6076A0F77EADDB3A93BE6F89688DE17D813620A00022E01FFFFFFFEFFFF,
                        ]
                    ],
                    [
                        [
                            0x2,
                            0x1A0111EA397FE699EC02408663D4DE85AA0D857D89759AD4897D29650FB85F9B409427EB4F49FFFD8BFD00000000AAAD,
                        ],
                        [
                            0x5,
                            0x1A0111EA397FE6998CE8D956845E1033EFA3BF761F6622E9ABC9802928BFC912627C4FD7ED3FFFFB5DFB00000001AAAF,
                        ],
                    ],
                    [
                        [
                            0x3,
                            0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAA,
                        ]
                    ],
                    [
                        [
                            0x1,
                            0x1A0111EA397FE699EC02408663D4DE85AA0D857D89759AD4897D29650FB85F9B409427EB4F49FFFD8BFD00000000AAAC,
                        ],
                        [
                            0x4,
                            0x1A0111EA397FE699EC02408663D4DE85AA0D857D89759AD4897D29650FB85F9B409427EB4F49FFFD8BFD00000000AAAC,
                        ],
                    ],
                    [
                        [
                            0x5,
                            0x5F19672FDF76CE51BA69C6076A0F77EADDB3A93BE6F89688DE17D813620A00022E01FFFFFFFEFFFE,
                        ]
                    ],
                ],
            },
            2: {
                "k_expressions": [
                    " + 0x1 * f_0",
                    " + 0x5f19...fffe * f_1",
                    " + 0x1a01...aaac * f_2",
                    " + 0x1 * f_3",
                    " + 0x5f19...fffe * f_4",
                    " + 0x1a01...aaac * f_5",
                ],
                "constants_list": [
                    [[0x0, 0x1]],
                    [
                        [
                            0x1,
                            0x5F19672FDF76CE51BA69C6076A0F77EADDB3A93BE6F89688DE17D813620A00022E01FFFFFFFEFFFE,
                        ]
                    ],
                    [
                        [
                            0x2,
                            0x1A0111EA397FE699EC02408663D4DE85AA0D857D89759AD4897D29650FB85F9B409427EB4F49FFFD8BFD00000000AAAC,
                        ]
                    ],
                    [[0x3, 0x1]],
                    [
                        [
                            0x4,
                            0x5F19672FDF76CE51BA69C6076A0F77EADDB3A93BE6F89688DE17D813620A00022E01FFFFFFFEFFFE,
                        ]
                    ],
                    [
                        [
                            0x5,
                            0x1A0111EA397FE699EC02408663D4DE85AA0D857D89759AD4897D29650FB85F9B409427EB4F49FFFD8BFD00000000AAAC,
                        ]
                    ],
                ],
            },
            3: {
                "k_expressions": [
                    " + 0x1 * f_0 + 0x2 * f_3",
                    " + 0x1a01...aaaa * f_1",
                    " + 0x1a01...aaaa * f_2 + 0x1a01...aaa9 * f_5",
                    " + 0x1a01...aaaa * f_3",
                    " + 0x1 * f_1 + 0x1 * f_4",
                    " + 0x1 * f_5",
                ],
                "constants_list": [
                    [[0, 0x1], [3, 0x2]],
                    [
                        [
                            1,
                            0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAA,
                        ]
                    ],
                    [
                        [
                            2,
                            0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAA,
                        ],
                        [
                            5,
                            0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAA9,
                        ],
                    ],
                    [
                        [
                            3,
                            0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAA,
                        ]
                    ],
                    [[1, 0x1], [4, 0x1]],
                    [[5, 0x1]],
                ],
            },
        },
        12: {
            1: {
                "k_expressions": [
                    " + 0x1 * f_0 + 0x2 * f_6",
                    " + 0x1808...14c5 * f_1 + 0x1808...14c5 * f_7",
                    " + 0x5f19...ffff * f_2",
                    " + 0xd5e1...9812 * f_9",
                    " + 0x1a01...aaad * f_4 + 0x1a01...aaaf * f_10",
                    " + 0xb659...022c * f_5 + 0xb659...022c * f_11",
                    " + 0x1a01...aaaa * f_6",
                    " + 0xfc3e...4af3 * f_1 + 0x1f87...95e6 * f_7",
                    " + 0x1a01...aaac * f_2 + 0x1a01...aaac * f_8",
                    " + 0x6af0...cc09 * f_3",
                    " + 0x5f19...fffe * f_10",
                    " + 0x144e...2995 * f_5 + 0xe9b7...a87f * f_11",
                ],
                "constants_list": [
                    [[0, 0x1], [6, 0x2]],
                    [
                        [
                            1,
                            0x18089593CBF626353947D5B1FD0C6D66BB34BC7585F5ABDF8F17B50E12C47D65CE514A7C167B027B600FEBDB244714C5,
                        ],
                        [
                            7,
                            0x18089593CBF626353947D5B1FD0C6D66BB34BC7585F5ABDF8F17B50E12C47D65CE514A7C167B027B600FEBDB244714C5,
                        ],
                    ],
                    [
                        [
                            2,
                            0x5F19672FDF76CE51BA69C6076A0F77EADDB3A93BE6F89688DE17D813620A00022E01FFFFFFFEFFFF,
                        ]
                    ],
                    [
                        [
                            9,
                            0xD5E1C086FFE8016D063C6DAD7A2FFFC9072BB5785A686BCEFEEDC2E0124838BDCCF325EE5D80BE9902109F7DBC79812,
                        ]
                    ],
                    [
                        [
                            4,
                            0x1A0111EA397FE699EC02408663D4DE85AA0D857D89759AD4897D29650FB85F9B409427EB4F49FFFD8BFD00000000AAAD,
                        ],
                        [
                            10,
                            0x1A0111EA397FE6998CE8D956845E1033EFA3BF761F6622E9ABC9802928BFC912627C4FD7ED3FFFFB5DFB00000001AAAF,
                        ],
                    ],
                    [
                        [
                            5,
                            0xB659FB20274BFB1BE8FF4D69163C08BE7302C4818171FDD17D5BE9B1D380ACD8C747CDC4AFF0E653631F5D3000F022C,
                        ],
                        [
                            11,
                            0xB659FB20274BFB1BE8FF4D69163C08BE7302C4818171FDD17D5BE9B1D380ACD8C747CDC4AFF0E653631F5D3000F022C,
                        ],
                    ],
                    [
                        [
                            6,
                            0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAA,
                        ]
                    ],
                    [
                        [
                            1,
                            0xFC3E2B36C4E03288E9E902231F9FB854A14787B6C7B36FEC0C8EC971F63C5F282D5AC14D6C7EC22CF78A126DDC4AF3,
                        ],
                        [
                            7,
                            0x1F87C566D89C06511D3D204463F3F70A9428F0F6D8F66DFD8191D92E3EC78BE505AB5829AD8FD8459EF1424DBB895E6,
                        ],
                    ],
                    [
                        [
                            2,
                            0x1A0111EA397FE699EC02408663D4DE85AA0D857D89759AD4897D29650FB85F9B409427EB4F49FFFD8BFD00000000AAAC,
                        ],
                        [
                            8,
                            0x1A0111EA397FE699EC02408663D4DE85AA0D857D89759AD4897D29650FB85F9B409427EB4F49FFFD8BFD00000000AAAC,
                        ],
                    ],
                    [
                        [
                            3,
                            0x6AF0E0437FF400B6831E36D6BD17FFE48395DABC2D3435E77F76E17009241C5EE67992F72EC05F4C81084FBEDE3CC09,
                        ]
                    ],
                    [
                        [
                            10,
                            0x5F19672FDF76CE51BA69C6076A0F77EADDB3A93BE6F89688DE17D813620A00022E01FFFFFFFEFFFE,
                        ]
                    ],
                    [
                        [
                            5,
                            0x144E4211384586C16BD3AD4AFA99CC9170DF3560E77982D0DB45F3536814F0BD5871C1908BD478CD1EE605167FF82995,
                        ],
                        [
                            11,
                            0xE9B7238370B26E88C8BB2DFB1E7EC4B7D471F3CDB6DF2E24F5B1405D978EB56923783226654F19A83CD0A2CFFF0A87F,
                        ],
                    ],
                ],
            },
            2: {
                "k_expressions": [
                    " + 0x1 * f_0",
                    " + 0x5f19...ffff * f_1",
                    " + 0x5f19...fffe * f_2",
                    " + 0x1a01...aaaa * f_3",
                    " + 0x1a01...aaac * f_4",
                    " + 0x1a01...aaad * f_5",
                    " + 0x1 * f_6",
                    " + 0x5f19...ffff * f_7",
                    " + 0x5f19...fffe * f_8",
                    " + 0x1a01...aaaa * f_9",
                    " + 0x1a01...aaac * f_10",
                    " + 0x1a01...aaad * f_11",
                ],
                "constants_list": [
                    [[0, 0x1]],
                    [
                        [
                            1,
                            0x5F19672FDF76CE51BA69C6076A0F77EADDB3A93BE6F89688DE17D813620A00022E01FFFFFFFEFFFF,
                        ]
                    ],
                    [
                        [
                            2,
                            0x5F19672FDF76CE51BA69C6076A0F77EADDB3A93BE6F89688DE17D813620A00022E01FFFFFFFEFFFE,
                        ]
                    ],
                    [
                        [
                            3,
                            0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAA,
                        ]
                    ],
                    [
                        [
                            4,
                            0x1A0111EA397FE699EC02408663D4DE85AA0D857D89759AD4897D29650FB85F9B409427EB4F49FFFD8BFD00000000AAAC,
                        ]
                    ],
                    [
                        [
                            5,
                            0x1A0111EA397FE699EC02408663D4DE85AA0D857D89759AD4897D29650FB85F9B409427EB4F49FFFD8BFD00000000AAAD,
                        ]
                    ],
                    [[6, 0x1]],
                    [
                        [
                            7,
                            0x5F19672FDF76CE51BA69C6076A0F77EADDB3A93BE6F89688DE17D813620A00022E01FFFFFFFEFFFF,
                        ]
                    ],
                    [
                        [
                            8,
                            0x5F19672FDF76CE51BA69C6076A0F77EADDB3A93BE6F89688DE17D813620A00022E01FFFFFFFEFFFE,
                        ]
                    ],
                    [
                        [
                            9,
                            0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAA,
                        ]
                    ],
                    [
                        [
                            10,
                            0x1A0111EA397FE699EC02408663D4DE85AA0D857D89759AD4897D29650FB85F9B409427EB4F49FFFD8BFD00000000AAAC,
                        ]
                    ],
                    [
                        [
                            11,
                            0x1A0111EA397FE699EC02408663D4DE85AA0D857D89759AD4897D29650FB85F9B409427EB4F49FFFD8BFD00000000AAAD,
                        ]
                    ],
                ],
            },
            3: {
                "k_expressions": [
                    " + 0x1 * f_0 + 0x2 * f_6",
                    " + 0xca2f...1299 * f_1 + 0xca2f...1299 * f_7",
                    " + 0x1a01...aaaa * f_2",
                    " + 0xca2f...1299 * f_9",
                    " + 0x1a01...aaaa * f_4 + 0x1a01...aaa9 * f_10",
                    " + 0xd5e1...9812 * f_5 + 0xd5e1...9812 * f_11",
                    " + 0x1a01...aaaa * f_6",
                    " + 0x6af0...cc09 * f_1 + 0xd5e1...9812 * f_7",
                    " + 0x1 * f_2 + 0x1 * f_8",
                    " + 0x1352...dea2 * f_3",
                    " + 0x1 * f_10",
                    " + 0x1352...dea2 * f_5 + 0xca2f...1299 * f_11",
                ],
                "constants_list": [
                    [[0, 0x1], [6, 0x2]],
                    [
                        [
                            1,
                            0xCA2F5E1C98166837AB7E0DB6BA8ACDAD404902D6DDE8C027741F672F58C729841DCCD9FCB7BF41629DDF60824381299,
                        ],
                        [
                            7,
                            0xCA2F5E1C98166837AB7E0DB6BA8ACDAD404902D6DDE8C027741F672F58C729841DCCD9FCB7BF41629DDF60824381299,
                        ],
                    ],
                    [
                        [
                            2,
                            0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAA,
                        ]
                    ],
                    [
                        [
                            9,
                            0xCA2F5E1C98166837AB7E0DB6BA8ACDAD404902D6DDE8C027741F672F58C729841DCCD9FCB7BF41629DDF60824381299,
                        ]
                    ],
                    [
                        [
                            4,
                            0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAA,
                        ],
                        [
                            10,
                            0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAA9,
                        ],
                    ],
                    [
                        [
                            5,
                            0xD5E1C086FFE8016D063C6DAD7A2FFFC9072BB5785A686BCEFEEDC2E0124838BDCCF325EE5D80BE9902109F7DBC79812,
                        ],
                        [
                            11,
                            0xD5E1C086FFE8016D063C6DAD7A2FFFC9072BB5785A686BCEFEEDC2E0124838BDCCF325EE5D80BE9902109F7DBC79812,
                        ],
                    ],
                    [
                        [
                            6,
                            0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAA,
                        ]
                    ],
                    [
                        [
                            1,
                            0x6AF0E0437FF400B6831E36D6BD17FFE48395DABC2D3435E77F76E17009241C5EE67992F72EC05F4C81084FBEDE3CC09,
                        ],
                        [
                            7,
                            0xD5E1C086FFE8016D063C6DAD7A2FFFC9072BB5785A686BCEFEEDC2E0124838BDCCF325EE5D80BE9902109F7DBC79812,
                        ],
                    ],
                    [[2, 0x1], [8, 0x1]],
                    [
                        [
                            3,
                            0x135203E60180A68EE2E9C448D77A2CD91C3DEDD930B1CF60EF396489F61EB45E304466CF3E67FA0AF1EE7B04121BDEA2,
                        ]
                    ],
                    [[10, 0x1]],
                    [
                        [
                            5,
                            0x135203E60180A68EE2E9C448D77A2CD91C3DEDD930B1CF60EF396489F61EB45E304466CF3E67FA0AF1EE7B04121BDEA2,
                        ],
                        [
                            11,
                            0xCA2F5E1C98166837AB7E0DB6BA8ACDAD404902D6DDE8C027741F672F58C729841DCCD9FCB7BF41629DDF60824381299,
                        ],
                    ],
                ],
            },
        },
    },
}


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
