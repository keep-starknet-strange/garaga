from starkware.cairo.common.math_utils import as_int
import functools
from src.algebra import FunctionFelt

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


def pack_felt_ptr(memory: object, ptr: object, n_elements: int):
    val = []
    for i in range(n_elements):
        val.append(memory[ptr + i])
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


def bigint_fill(x: int, ids: object, n_limbs: int, base: int):
    xs = bigint_split(x, n_limbs, base)
    for i in range(n_limbs):
        setattr(ids, f"d{i}", xs[i])
    return


def fill_bigint_array(x: list, ptr: object, n_limbs: int, base: int, offset: int = 0):
    for i in range(len(x)):
        bigint_fill(x[i], ptr[offset + i], n_limbs, base)
    return


def fill_felt_ptr(x: list, memory: object, address: int):
    for i in range(len(x)):
        memory[address + i] = x[i]


def fill_limbs(limbs: list, ids: object):
    """
    limbs: list of integers
    ids: reference to Cairo object
    """
    for i, l in enumerate(limbs):
        setattr(ids, f"d{i}", l)
    return


def bigint_split_array(x: list, n_limbs: int, base: int):
    xs = []
    for i in range(len(x)):
        xs.extend(bigint_split(x[i], n_limbs, base))
    return xs


def fill_bigint_array_into_felt_ptr(
    x: list, memory: object, address: int, base: int, n_limbs: int
):
    felts = []
    for val in x:
        felts.extend(bigint_split(val, n_limbs, base))
    fill_felt_ptr(felts, memory, address)


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


def padd_function_felt(
    f: FunctionFelt, n: int
) -> tuple[list[int], list[int], list[int], list[int]]:
    a_num = f.a.numerator.get_value_coeffs()
    a_den = f.a.denominator.get_value_coeffs()
    b_num = f.b.numerator.get_value_coeffs()
    b_den = f.b.denominator.get_value_coeffs()
    assert len(a_num) <= n + 1
    assert len(a_den) <= n + 2
    assert len(b_num) <= n + 2
    assert len(b_den) <= n + 5
    a_num = a_num + [0] * (n + 1 - len(a_num))
    a_den = a_den + [0] * (n + 2 - len(a_den))
    b_num = b_num + [0] * (n + 2 - len(b_num))
    b_den = b_den + [0] * (n + 5 - len(b_den))
    return (a_num, a_den, b_num, b_den)


def fill_sum_dlog_div(f: FunctionFelt, n: int, ref: object, segments: object):
    a_num, a_den, b_num, b_den = padd_function_felt(f, n)

    ref.a_num = segments.gen_arg(bigint_split_array(a_num, 4, 2**96))
    ref.a_den = segments.gen_arg(bigint_split_array(a_den, 4, 2**96))
    ref.b_num = segments.gen_arg(bigint_split_array(b_num, 4, 2**96))
    ref.b_den = segments.gen_arg(bigint_split_array(b_den, 4, 2**96))


def fill_g1_point(p, ref: object):
    bigint_fill(p[0], ref.x, 4, 2**96)
    bigint_fill(p[1], ref.y, 4, 2**96)
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
