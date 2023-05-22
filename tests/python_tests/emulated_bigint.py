from tools.py.EmulatedBigInt import EmulatedBigInt, py_split_int64 as split
from tools.py.EmulatedBigInt import (
    test_full_field_add_honest,
    hack_add_full_field,
    test_assert_reduced_felt,
    test_full_field_mul_range_check_honest,
    test_full_field_mul_range_check_malicious,
    test_full_field_mul_bitwise_honest,
)
import random
import sympy
import multiprocessing
from math import ceil


def generate_n_bits_prime(n):
    while True:
        num = random.getrandbits(n)
        num |= (1 << n - 1) | 1
        if sympy.isprime(num):
            return num


def polynomial_multiplication_terms(n_limbs):
    result = []
    for i in range(2 * n_limbs - 1):
        if i < n_limbs:
            result.append(i + 1)
        else:
            result.append(2 * n_limbs - i - 1)
    return result


def poly_mul(a: list, b: list) -> list:
    assert len(a) == len(b)
    n = len(a)
    result = [0] * (2 * n - 1)
    for i in range(n):
        for j in range(n):
            result[i + j] += a[i] * b[j]
    return result


N_CORES = multiprocessing.cpu_count()


NATIVE_BIT_LENGTH = 5
NATIVE_PRIME = generate_n_bits_prime(NATIVE_BIT_LENGTH)
EMULATED_PRIME = NATIVE_PRIME + 3
EMULATED_BIT_LENGTH = EMULATED_PRIME.bit_length()

###########################################################################################
# TWO APPROACHES TO RUN TESTS IN ACCEPTABLE TIME:
# FIRST IS USING NATIVE_BIT_LENGTH = 4 AND EMULATED_BIT_LENGTH = 5
# SECOND, IF WE WANT NATIVE TO BE 5 BITS AND EMULATED TO BE 6 BITS, WE CAN ALSO USE
# THESE VALUES AS THEY WILL GIVE ONLY 3 LIMBS :
###########################################################################################

NATIVE_PRIME = 41
EMULATED_PRIME = 15
NATIVE_BIT_LENGTH = NATIVE_PRIME.bit_length()  # 5
EMULATED_BIT_LENGTH = EMULATED_PRIME.bit_length()  # 6
###########################################################################################


N_LIMBS = 2
BASE = 2**2

# THIS CONDITION IS TO ENSURE HIGHEST TERM IN POLYNOMIAL MULTIPLICATION DOESN'T OVERFLOW NATIVE PRIME
# THE 2 factor enables a and b to be slighlty bigger than 2*EMULATED_PRIME, so we can use unreduced addition before multiplication.
while N_LIMBS * 2 * (BASE - 1) ** 2 >= (NATIVE_PRIME) - 2:
    print(
        f"Warning: {N_LIMBS} limbs are not enough to represent {EMULATED_PRIME} in base {BASE}. Increasing number of limbs."
    )
    N_LIMBS += 1
    BASE = 2 ** (ceil(EMULATED_BIT_LENGTH / N_LIMBS))
    if N_LIMBS > 10:
        print(
            f"Error: {N_LIMBS} limbs are not enough to represent {EMULATED_PRIME} in base {BASE}. Exiting."
        )
        exit(0)

print(
    f"Using {N_LIMBS} limbs to represent {EMULATED_PRIME} in base 2**{ceil(EMULATED_BIT_LENGTH/N_LIMBS)}"
)

# We take the max value of a*b limbs, divide it by base and add 1 to get a high bound on the max carry value
SIMULATED_RC_BOUND = HIGH_BOUND_MAX_CARRY = ((N_LIMBS * (BASE - 1) ** 2) // BASE) + 1
# Then ensure the check of coefficient reduction verification with the hint (q*base) fits in a cell to avoid wrap-around.
# see this when r = 0 https://github.com/starkware-libs/cairo-lang/blob/40404870166edc1e1fc5778fe39a29f981121ef9/src/starkware/cairo/common/math.cairo#L289-L312 )
assert HIGH_BOUND_MAX_CARRY * BASE < NATIVE_PRIME

MAX_VAL = EMULATED_PRIME - 1
MAX_UNREDUCED_ADD = 2 * MAX_VAL
MAX_UNREDUCED_MUL = MAX_UNREDUCED_ADD**2
MAX_Q = MAX_UNREDUCED_MUL // EMULATED_PRIME
MAX_Q_LIMBS = split(MAX_Q, BASE, N_LIMBS)
MAX_Q_P_LIMBS = poly_mul(MAX_Q_LIMBS, split(EMULATED_PRIME, BASE, N_LIMBS))
for i in range(N_LIMBS):
    assert MAX_Q_P_LIMBS[i] < NATIVE_PRIME - 1


A = random.randint(0, EMULATED_PRIME - 1)
B = random.randint(0, EMULATED_PRIME - 1)
a = EmulatedBigInt(N_LIMBS, N_CORES, BASE, NATIVE_PRIME, EMULATED_PRIME, A)
b = EmulatedBigInt(N_LIMBS, N_CORES, BASE, NATIVE_PRIME, EMULATED_PRIME, B)


assert test_assert_reduced_felt(a) == 0, "Error: test_assert_reduced_felt() not passing"


def test_add():
    h = test_full_field_add_honest(a)
    m = hack_add_full_field(a)
    print(len(h))
    print(len(m))

    assert len(h) == EMULATED_PRIME**2
    assert len(m) == EMULATED_PRIME**2


def test_mul_bitwise():
    l = test_full_field_mul_bitwise_honest(a)
    assert (
        len(l) == EMULATED_PRIME**2
    ), "Error: test_full_field_mul_bitwise_honest() not passing on all values"


def test_mul_range_check():
    assert a.mul_honest_range_check(b) == 0, "Error: mul_honest() not passing"

    h = test_full_field_mul_range_check_honest(a)
    print(a)
    print(b)
    print(h, len(h))

    assert (
        len(h) == EMULATED_PRIME**2
    ), "Error: test_full_field_mul_honest() not passing on all values"

    m = test_full_field_mul_range_check_malicious(a)

    assert (
        len(m) == EMULATED_PRIME**2
    ), "Error: test_full_field_mul_malicious() not passing"


# test_add()
# test_mul_bitwise()
# test_mul_range_check()

h = test_full_field_mul_range_check_honest(a)
print(a)
print(b)
print(h, len(h))

assert (
    len(h) == EMULATED_PRIME**2
), "Error: test_full_field_mul_honest() not passing on all values"

m = test_full_field_mul_range_check_malicious(a)
from tools.py.EmulatedBigInt import EmulatedBigInt, py_split_int64 as split
from tools.py.EmulatedBigInt import (
    test_full_field_add_honest,
    hack_add_full_field,
    test_assert_reduced_felt,
    test_full_field_mul_range_check_honest,
    test_full_field_mul_range_check_malicious,
    test_full_field_mul_bitwise_honest,
)
import random
import sympy
import multiprocessing
from math import ceil


def generate_n_bits_prime(n):
    while True:
        num = random.getrandbits(n)
        num |= (1 << n - 1) | 1
        if sympy.isprime(num):
            return num


def polynomial_multiplication_terms(n_limbs):
    result = []
    for i in range(2 * n_limbs - 1):
        if i < n_limbs:
            result.append(i + 1)
        else:
            result.append(2 * n_limbs - i - 1)
    return result


def poly_mul(a: list, b: list) -> list:
    assert len(a) == len(b)
    n = len(a)
    result = [0] * (2 * n - 1)
    for i in range(n):
        for j in range(n):
            result[i + j] += a[i] * b[j]
    return result


N_CORES = multiprocessing.cpu_count()


NATIVE_BIT_LENGTH = 5
NATIVE_PRIME = generate_n_bits_prime(NATIVE_BIT_LENGTH)
EMULATED_PRIME = NATIVE_PRIME + 3
EMULATED_BIT_LENGTH = EMULATED_PRIME.bit_length()

###########################################################################################
# TWO APPROACHES TO RUN TESTS IN ACCEPTABLE TIME:
# FIRST IS USING NATIVE_BIT_LENGTH = 4 AND EMULATED_BIT_LENGTH = 5
# SECOND, IF WE WANT NATIVE TO BE 5 BITS AND EMULATED TO BE 6 BITS, WE CAN ALSO USE
# THESE VALUES AS THEY WILL GIVE ONLY 3 LIMBS :
###########################################################################################

NATIVE_PRIME = 41
EMULATED_PRIME = 15
NATIVE_BIT_LENGTH = NATIVE_PRIME.bit_length()  # 5
EMULATED_BIT_LENGTH = EMULATED_PRIME.bit_length()  # 6
###########################################################################################


N_LIMBS = 2
BASE = 2**2

# THIS CONDITION IS TO ENSURE HIGHEST TERM IN POLYNOMIAL MULTIPLICATION DOESN'T OVERFLOW NATIVE PRIME
# THE 2 factor enables a and b to be slighlty bigger than 2*EMULATED_PRIME, so we can use unreduced addition before multiplication.
while N_LIMBS * 2 * (BASE - 1) ** 2 >= (NATIVE_PRIME) - 2:
    print(
        f"Warning: {N_LIMBS} limbs are not enough to represent {EMULATED_PRIME} in base {BASE}. Increasing number of limbs."
    )
    N_LIMBS += 1
    BASE = 2 ** (ceil(EMULATED_BIT_LENGTH / N_LIMBS))
    if N_LIMBS > 10:
        print(
            f"Error: {N_LIMBS} limbs are not enough to represent {EMULATED_PRIME} in base {BASE}. Exiting."
        )
        exit(0)

print(
    f"Using {N_LIMBS} limbs to represent {EMULATED_PRIME} in base 2**{ceil(EMULATED_BIT_LENGTH/N_LIMBS)}"
)

# We take the max value of a*b limbs, divide it by base and add 1 to get a high bound on the max carry value
SIMULATED_RC_BOUND = HIGH_BOUND_MAX_CARRY = ((N_LIMBS * (BASE - 1) ** 2) // BASE) + 1
# Then ensure the check of coefficient reduction verification with the hint (q*base) fits in a cell to avoid wrap-around.
# see this when r = 0 https://github.com/starkware-libs/cairo-lang/blob/40404870166edc1e1fc5778fe39a29f981121ef9/src/starkware/cairo/common/math.cairo#L289-L312 )
assert HIGH_BOUND_MAX_CARRY * BASE < NATIVE_PRIME

MAX_VAL = EMULATED_PRIME - 1
MAX_UNREDUCED_ADD = 2 * MAX_VAL
MAX_UNREDUCED_MUL = MAX_UNREDUCED_ADD**2
MAX_Q = MAX_UNREDUCED_MUL // EMULATED_PRIME
MAX_Q_LIMBS = split(MAX_Q, BASE, N_LIMBS)
MAX_Q_P_LIMBS = poly_mul(MAX_Q_LIMBS, split(EMULATED_PRIME, BASE, N_LIMBS))
for i in range(N_LIMBS):
    assert MAX_Q_P_LIMBS[i] < NATIVE_PRIME - 1


A = random.randint(0, EMULATED_PRIME - 1)
B = random.randint(0, EMULATED_PRIME - 1)
a = EmulatedBigInt(N_LIMBS, N_CORES, BASE, NATIVE_PRIME, EMULATED_PRIME, A)
b = EmulatedBigInt(N_LIMBS, N_CORES, BASE, NATIVE_PRIME, EMULATED_PRIME, B)


assert test_assert_reduced_felt(a) == 0, "Error: test_assert_reduced_felt() not passing"


def test_add():
    h = test_full_field_add_honest(a)
    m = hack_add_full_field(a)
    print(len(h))
    print(len(m))

    assert len(h) == EMULATED_PRIME**2
    assert len(m) == EMULATED_PRIME**2


def test_mul_bitwise():
    l = test_full_field_mul_bitwise_honest(a)
    assert (
        len(l) == EMULATED_PRIME**2
    ), "Error: test_full_field_mul_bitwise_honest() not passing on all values"


def test_mul_range_check():
    assert a.mul_honest_range_check(b) == 0, "Error: mul_honest() not passing"

    h = test_full_field_mul_range_check_honest(a)
    print(a)
    print(b)
    print(h, len(h))

    assert (
        len(h) == EMULATED_PRIME**2
    ), "Error: test_full_field_mul_honest() not passing on all values"

    m = test_full_field_mul_range_check_malicious(a)

    assert (
        len(m) == EMULATED_PRIME**2
    ), "Error: test_full_field_mul_malicious() not passing"


# test_add()
# test_mul_bitwise()
# test_mul_range_check()

h = test_full_field_mul_range_check_honest(a)
print(a)
print(b)
print(h, len(h))

assert (
    len(h) == EMULATED_PRIME**2
), "Error: test_full_field_mul_honest() not passing on all values"

m = test_full_field_mul_range_check_malicious(a)

assert len(m) == len(h)

# def max_limb_size():
#     max = 0
#     for x in range(2 * (EMULATED_PRIME - 1)):
#         m = x * x
#         split_m = split(m, BASE, N_LIMBS)
#         for i in range(N_LIMBS):
#             if split_m[i] > max:
#                 max = split_m[i]
#     return max
