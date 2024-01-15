from starkware.cairo.common.math_utils import as_int

PRIME = 2**251 + 17 * 2**192 + 1  # STARK prime


def get_p() -> int:
    p = 0
    for i in range(ids.N_LIMBS):
        p += getattr(ids, "P" + str(i)) * ids.BASE**i
    return p


def split(x, degree=ids.DEGREE, base=ids.BASE):
    coeffs = []
    for n in range(degree, 0, -1):
        q, r = divmod(x, base**n)
        coeffs.append(q)
        x = r
    coeffs.append(x)
    return coeffs[::-1]
