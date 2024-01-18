from starkware.cairo.common.math_utils import as_int
import functools

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


def bigint_pack(x: object, n_limbs: int, base: int) -> int:
    val = 0
    for i in range(n_limbs):
        val += as_int(getattr(x, f"d{i}"), PRIME) * base**i
    return val


def bigint_limbs(x: object, n_limbs: int):
    limbs = []
    for i in range(n_limbs):
        limbs.append(as_int(getattr(x, f"d{i}"), PRIME))
    return limbs


def pack_e12t(
    x: object, n_limbs: int, base: int
) -> (((int, int), (int, int), (int, int)), ((int, int), (int, int), (int, int))):
    refs = [
        x.c0.b0.a0,
        x.c0.b0.a1,
        x.c0.b1.a0,
        x.c0.b1.a1,
        x.c0.b2.a0,
        x.c0.b2.a1,
        x.c1.b0.a0,
        x.c1.b0.a1,
        x.c1.b1.a0,
        x.c1.b1.a1,
        x.c1.b2.a0,
        x.c1.b2.a1,
    ]
    val = []
    for i in range(12):
        val.append(bigint_pack(refs[i], n_limbs, base))
    return val


def pack_e12d(
    x: object, n_limbs: int, base: int
) -> (((int, int), (int, int), (int, int)), ((int, int), (int, int), (int, int))):
    val = []
    for i in range(12):
        val.append(bigint_pack(getattr(x, f"w{i}"), n_limbs, base))
    return val


def pack_e6d(x: object, n_limbs, base):
    val = []
    for i in range(6):
        val.append(bigint_pack(getattr(x, f"v{i}"), n_limbs, base))
    return val


#### WRITE HINTS


def fill_limbs(limbs: list, ids: object):
    """
    limbs: list of integers
    ids: reference to Cairo object
    """
    for i, l in enumerate(limbs):
        setattr(ids, f"d{i}", l)
    return


def bigint_fill(x: int, ids: object, n_limbs: int, base: int):
    xs = bigint_split(x, n_limbs, base)
    for i in range(n_limbs):
        setattr(ids, f"d{i}", xs[i])
    return


def rgetattr(obj, attr, *args):
    def _getattr(obj, attr):
        return getattr(obj, attr, *args)

    return functools.reduce(_getattr, [obj] + attr.split("."))


def rsetattr(obj, attr, val):
    pre, _, post = attr.rpartition(".")
    return setattr(rgetattr(obj, pre) if pre else obj, post, val)
