from starkware.cairo.common.math_utils import as_int

PRIME = 2**251 + 17 * 2**192 + 1  # STARK prime


###### READ HINTS ####
def get_p(ids: object) -> int:
    p = 0
    for i in range(ids.N_LIMBS):
        p += getattr(ids, "P" + str(i)) * ids.BASE**i
    return p


def get_p_limbs(ids: object):
    limbs = []
    for i in range(ids.N_LIMBS):
        limbs.append(getattr(ids, "P" + str(i)))
    return limbs


def bigint_split(x: int, n_limbs: int, base: int):
    coeffs = []
    degree = n_limbs - 1
    for n in range(degree, 0, -1):
        q, r = divmod(x, base**n)
        coeffs.append(q)
        x = r
    coeffs.append(x)
    return coeffs[::-1]


def bigint_pack(x: object, n_limbs: int, base: int):
    val = 0
    for i in range(n_limbs):
        val += as_int(getattr(x, f"d{i}"), PRIME) * base**i
    return val


def bigint_limbs(x: object, n_limbs: int):
    limbs = []
    for i in range(n_limbs):
        limbs.append(as_int(getattr(x, f"d{i}"), PRIME))
    return limbs


#### WRITE HINTS


def fill_limbs(limbs: list, ids: object):
    for i, l in enumerate(limbs):
        setattr(ids, f"d{i}", l)
    return


def bigint_fill(x: int, ids: object, n_limbs: int, base: int):
    xs = bigint_split(x, n_limbs, base)
    for i in range(n_limbs):
        setattr(ids, f"d{i}", xs[i])
    return
