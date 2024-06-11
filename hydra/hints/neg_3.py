def neg_3_base_le(scalar: int) -> list[int]:
    """
    Decomposes a scalar into base -3 representation.
    :param scalar: The integer to be decomposed.
    :return: A list of coefficients in base -3 representation. (Least significant bit first),
    with digits [-1, 0, 1] such that scalar = sum((-3) ** i * d for (i, d) in enumerate(digits))
    """
    if scalar == 0:
        return [0]
    digits = []
    while scalar != 0:
        remainder = scalar % 3
        if (
            remainder == 2
        ):  # if the remainder is 2, we set it to -1 and add 1 to the next digit
            remainder = -1
            scalar += 1
        # For remainder 1 and 0, no change is required
        digits.append(remainder)
        scalar = -(scalar // 3)  # divide by -3 for the next digit
    return digits


def positive_negative_multiplicities(digits: list[int]) -> tuple[int, int]:
    a = sum((-3) ** i for (i, d) in enumerate(digits) if d == 1)
    b = sum((-3) ** i for (i, d) in enumerate(digits) if d == -1)
    return (a, b)


if __name__ == "__main__":
    print(positive_negative_multiplicities(neg_3_base_le(2**127)))
    print(positive_negative_multiplicities(neg_3_base_le(2**128)))

    print(positive_negative_multiplicities(neg_3_base_le(2**126)))

    print(positive_negative_multiplicities(neg_3_base_le(2**125)))

    print(positive_negative_multiplicities(neg_3_base_le(2**124)))
    print(positive_negative_multiplicities(neg_3_base_le(2**123)))
    print(positive_negative_multiplicities(neg_3_base_le(2**122)))
    print(positive_negative_multiplicities(neg_3_base_le(2**121)))
    print(positive_negative_multiplicities(neg_3_base_le(2**120)))

    pp = False
    nn = False
    pn = False
    np = False

    import random

    max_tries = 100
    while not (pp and np and nn and pn) and max_tries > 0:
        still_false_cases_only = [
            case
            for case, value in zip(["pp", "np", "nn", "pn"], [pp, np, nn, pn])
            if not value
        ]
        max_tries -= 1
        print(f"Cases that are still false: {still_false_cases_only}")
        (a, b) = positive_negative_multiplicities(
            neg_3_base_le(random.randint(0, 2**128))
        )
        if a >= 0 and b >= 0:
            pp = True
        elif a >= 0 and b < 0:
            pn = True
        elif a < 0 and b < 0:
            nn = True
        elif a < 0 and b >= 0:
            np = True

    print("yes")
