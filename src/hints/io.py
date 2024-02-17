from starkware.cairo.common.math_utils import as_int
import functools

PRIME = 2**251 + 17 * 2**192 + 1  # STARK prime

# TODO: remove N_LIMBS using object._struct_definition.size (==4 for UInt384)


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


def bigint_pack_ptr(memory: object, ptr: object, n_limbs: int, base: int):
    val = 0
    for i in range(n_limbs):
        val += as_int(memory[ptr + i], PRIME) * base**i
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


def pack_e12d(x: object, n_limbs: int, base: int):
    val = []
    for i in range(12):
        val.append(bigint_pack(getattr(x, f"w{i}"), n_limbs, base))
    return val


def pack_e6d(x: object, n_limbs, base):
    val = []
    for i in range(6):
        val.append(bigint_pack(getattr(x, f"v{i}"), n_limbs, base))
    return val


# ptr : Uint384*
def pack_bigint_array(
    ptr: object, n_limbs: int, base: int, n_elements: int, offset: int = 0
):
    val = []
    for i in range(n_elements):
        val.append(bigint_pack(ptr[offset + i], n_limbs, base))
    return val


def pack_bigint_ptr(
    memory: object,
    ptr: object,
    n_limbs: int,
    base: int,
    n_elements: int,
):
    val = []
    for i in range(n_elements):
        val.append(bigint_pack_ptr(memory, ptr + i * n_limbs, n_limbs, base))
    return val


#### WRITE HINTS


def fill_bigint_array(x: list, ptr: object, n_limbs: int, base: int, offset: int = 0):
    for i in range(len(x)):
        bigint_fill(x[i], ptr[offset + i], n_limbs, base)
    return


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


def fill_e6d(x: list, ids: object, n_limbs: int, base: int):
    for i in range(6):
        bigint_fill(x[i], getattr(ids, f"v{i}"), n_limbs, base)
    return


def fill_e12d(x: list, ids: object, n_limbs: int, base: int):
    for i in range(12):
        bigint_fill(x[i], getattr(ids, f"w{i}"), n_limbs, base)
    return


def fill_uint256(x: int, ids: object):
    x0, x1 = split_128(x)
    setattr(ids, "low", x0)
    setattr(ids, "high", x1)
    return


### OTHERS


def flatten(t):
    result = []
    for item in t:
        if isinstance(item, (tuple, list)):
            result.extend(flatten(item))
        else:
            result.append(item)
    return result


def split_128(a):
    """Takes in value, returns uint256-ish tuple."""
    return (a & ((1 << 128) - 1), a >> 128)


def rgetattr(obj, attr, *args):
    def _getattr(obj, attr):
        return getattr(obj, attr, *args)

    return functools.reduce(_getattr, [obj] + attr.split("."))


def rsetattr(obj, attr, val):
    pre, _, post = attr.rpartition(".")
    return setattr(rgetattr(obj, pre) if pre else obj, post, val)
