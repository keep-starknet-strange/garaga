import functools

from garaga.algebra import FunctionFelt, ModuloCircuitElement, PyFelt

PRIME = 2**251 + 17 * 2**192 + 1  # STARK prime


def assert_integer(val):
    """
    Asserts that the input is an integer (and not relocatable value).
    """
    assert isinstance(val, int), f"Expected integer, found: {val}."


def as_int(val, prime):
    """
    Returns the lift of the given field element, val, as an integer in the range
    (-prime/2, prime/2).
    """
    assert_integer(val)
    return val if val < prime // 2 else val - prime


def to_hex_str(value: str | int):
    if isinstance(value, str):
        value = value.strip()  # Trim whitespaces
        if value.lower().startswith("0x"):
            try:
                # Validate hexadecimal and return in lowercase
                return "0x" + hex(int(value, 16))[2:].lower()
            except ValueError:
                raise ValueError(f"Invalid hexadecimal value: {value}")
        else:
            try:
                # Convert decimal string to int then to hex
                return hex(int(value)).lower()
            except ValueError:
                raise ValueError(f"Invalid decimal value: {value}")
    elif isinstance(value, int):
        return hex(value).lower()
    else:
        raise TypeError(f"Expected str or int, got {type(value).__name__}")


def bigint_split(
    x: int | ModuloCircuitElement | PyFelt, n_limbs: int = 4, base: int = 2**96
) -> list[int]:
    if isinstance(x, (ModuloCircuitElement, PyFelt)):
        x = x.value
    elif isinstance(x, int):
        pass
    else:
        raise ValueError(f"Invalid type for bigint_split: {type(x)}")

    coeffs = []
    degree = n_limbs - 1
    for n in range(degree, 0, -1):
        q, r = divmod(x, base**n)
        coeffs.append(q)
        x = r
    coeffs.append(x)
    return coeffs[::-1]


def to_int(value: str | int) -> int:
    """
    Convert a string or integer to an integer. Supports hexadecimal and decimal strings.
    """
    if isinstance(value, str):
        value = value.strip()  # Trim whitespaces
        if value.lower().startswith("0x"):
            try:
                return int(value, 16)
            except ValueError:
                raise ValueError(f"Invalid hexadecimal value: {value}")
        else:
            try:
                return int(value)
            except ValueError:
                raise ValueError(f"Invalid decimal value: {value}")
    elif isinstance(value, int):
        return value
    else:
        raise TypeError(f"Expected str or int, got {type(value).__name__}")


def int_to_u384(x: int | PyFelt, as_hex=True) -> str:
    limbs = bigint_split(x, 4, 2**96)
    if as_hex:
        return f"u384{{limb0:{hex(limbs[0])}, limb1:{hex(limbs[1])}, limb2:{hex(limbs[2])}, limb3:{hex(limbs[3])}}}"
    else:
        return f"u384{{limb0:{limbs[0]}, limb1:{limbs[1]}, limb2:{limbs[2]}, limb3:{limbs[3]}}}"


def int_to_u256(x: int | PyFelt) -> str:
    assert 0 <= x < 2**256, f"Value {x} is too large to fit in a u256"
    limbs = bigint_split(x, 2, 2**128)
    return f"u256{{low:{hex(limbs[0])}, high:{hex(limbs[1])}}}"


def int_array_to_u256_array(x: list[int] | list[PyFelt]) -> str:
    return f"array![{', '.join([int_to_u256(i) for i in x])}]"


def int_array_to_u384_array(x: list[int] | list[PyFelt], const=False) -> str:
    if const:
        return f"[{', '.join([int_to_u384(i) for i in x])}]"
    else:
        return f"array![{', '.join([int_to_u384(i) for i in x])}]"


def bigint_pack(x: object, n_limbs: int, base: int) -> int:
    val = 0
    for i in range(n_limbs):
        val += as_int(getattr(x, f"d{i}"), PRIME) * base**i
    return val


def bigint_pack_ptr(memory: object, ptr: object, n_limbs: int, base: int) -> int:
    val = 0
    for i in range(n_limbs):
        val += as_int(memory[ptr + i], PRIME) * base**i
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


def fill_felt_ptr(x: list, memory: object, address: int):
    for i in range(len(x)):
        memory[address + i] = x[i]


def fill_limbs(limbs: list, ids: object):
    """
    limbs: list of integers
    ids: reference to Cairo object
    """
    for i, limb in enumerate(limbs):
        setattr(ids, f"d{i}", limb)
    return


def bigint_split_array(
    x: list[int | PyFelt | ModuloCircuitElement],
    n_limbs: int = 4,
    base: int = 2**96,
    prepend_length=False,
) -> list[int]:
    xs = []
    if prepend_length:
        xs.append(len(x))
    for e in x:
        xs.extend(bigint_split(e, n_limbs, base))
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
    f: FunctionFelt, n: int, py_felt: bool = False
) -> tuple[list[int], list[int], list[int], list[int]]:
    a_num = f.a.numerator.get_coeffs() if py_felt else f.a.numerator.get_value_coeffs()
    a_den = (
        f.a.denominator.get_coeffs() if py_felt else f.a.denominator.get_value_coeffs()
    )
    b_num = f.b.numerator.get_coeffs() if py_felt else f.b.numerator.get_value_coeffs()
    b_den = (
        f.b.denominator.get_coeffs() if py_felt else f.b.denominator.get_value_coeffs()
    )
    assert len(a_num) <= n + 1
    assert len(a_den) <= n + 2
    assert len(b_num) <= n + 2
    assert len(b_den) <= n + 5
    zero = [f.a.numerator.field.zero()] if py_felt else [0]
    a_num = a_num + zero * (n + 1 - len(a_num))
    a_den = a_den + zero * (n + 2 - len(a_den))
    b_num = b_num + zero * (n + 2 - len(b_num))
    b_den = b_den + zero * (n + 5 - len(b_den))
    return (a_num, a_den, b_num, b_den)


def fill_sum_dlog_div(f: FunctionFelt, n: int, ref: object, segments: object):
    a_num, a_den, b_num, b_den = padd_function_felt(f, n)

    ref.a_num = segments.gen_arg(bigint_split_array(a_num, 4, 2**96))
    ref.a_den = segments.gen_arg(bigint_split_array(a_den, 4, 2**96))
    ref.b_num = segments.gen_arg(bigint_split_array(b_num, 4, 2**96))
    ref.b_den = segments.gen_arg(bigint_split_array(b_den, 4, 2**96))


def fill_g1_point(p: tuple[int, int], ref: object):
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
