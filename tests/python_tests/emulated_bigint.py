from tools.py.EmulatedBigInt import EmulatedBigInt, py_split_int64 as split
from tools.py.EmulatedBigInt import (
    test_full_field_add_honest,
    hack_add_full_field,
    test_assert_reduced_felt,
    get_all_unique_combinations_carries,
    test_full_field_mul_range_check_honest,
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

# THIS CONDITION IS TO ENSURE HIGHEST TERM IN POLYNOMIAL MULTIPLICATION DOESN'T OVERFLOW :
while N_LIMBS * (BASE - 1) ** 2 >= (NATIVE_PRIME) // 2:
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


def test_mul_range_check():
    x = get_all_unique_combinations_carries(a)
    ll = [len(x["hack_carries"]) for x in x]

    assert a.mul_honest_range_check(b) == 0, "Error: mul_honest() not passing"

    # l = test_full_field_mul_range_check_honest(a)
    # print(a)
    # print(b)
    # print(l, len(l))

    # assert len(l) == 0, "Error: test_full_field_mul_honest() not passing on all values"

    print(a, b)
    l = a.hack_mul_range_check(b)
    if len(l) == 1:
        print(f"Good! Hint is safe.")
        print(f"Number of values passing : {len(l)}")
    else:
        print(l)
        print(f"Number of values passing : {len(l)}")
        print(
            f"True q, true r : {a.value*b.value//EMULATED_PRIME}, {a.value*b.value%EMULATED_PRIME}"
        )
        print(f"Error: hack_mul() returned a list with more than one element")


test_add()
test_mul_range_check()
# test_mul_bitwise()

l = test_full_field_mul_bitwise_honest(a)
assert (
    len(l) == EMULATED_PRIME**2
), "Error: test_full_field_mul_bitwise_honest() not passing on all values"
