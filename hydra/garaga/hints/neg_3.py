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


def construct_digit_vectors(es: list[int]) -> list[list[int]]:
    dss_ = [neg_3_base_le(e) for e in es]  # Base -3 digits
    max_len = max(len(ds) for ds in dss_)
    dss_ = [ds + [0] * (max_len - len(ds)) for ds in dss_]
    # Transposing the matrix
    dss = [[dss_[row][col] for row in range(len(dss_))] for col in range(max_len)]
    return dss


def positive_negative_multiplicities(digits: list[int]) -> tuple[int, int]:

    sum_p = sum((-3) ** i for (i, d) in enumerate(digits) if d == 1)
    sum_n = sum((-3) ** i for (i, d) in enumerate(digits) if d == -1)

    return (sum_p, sum_n)


def scalar_to_base_neg3_le(u128: int) -> tuple[int, int, int, int]:
    def sign(felt252: int) -> int:
        # In cairo, the felt252 :
        # - is considered positive if it is in [0, STARK//2[
        # - is considered negative if it is in ]STARK//2, STARK[
        # Where STARK = 2**251+ 17* 2**192 + 1
        # Note :  value being exactly STARK//2 will not happen in the construction here.
        if felt252 > 0:
            return 1
        elif felt252 < 0:
            return -1
        else:
            # Note : the case where the input is 0, the sign does not matter.
            # Any value could be returned, so choose whatever is more performant in implementation.
            return 0

    digits = neg_3_base_le(u128)

    # Even if input is u128, both sum_p and sum_n might be larger and negative. Output of positive_negative_multiplicities should be felt252.

    sum_p, sum_n = positive_negative_multiplicities(digits)

    # return type : felt252, felt252, felt252, felt252
    return (abs(sum_p), abs(sum_n), sign(sum_p), sign(sum_n))


if __name__ == "__main__":
    print(positive_negative_multiplicities(neg_3_base_le(2**128)))
