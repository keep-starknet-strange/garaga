from tools.py.EmulatedBigInt import EmulatedBigInt, py_split_int64 as split
import random
import sympy
import multiprocessing

def generate_n_bits_prime(n):
    while True:
        num = random.getrandbits(n)
        num |= (1 << n-1) | 1
        if sympy.isprime(num):
            return num

N_LIMBS = 3
N_CORES = multiprocessing.cpu_count()
BASE = 2**2
NATIVE_PRIME = generate_n_bits_prime(5)
EMULATED_PRIME = generate_n_bits_prime(6)

NATIVE_PRIME = 31
EMULATED_PRIME = 47

A=random.randint(0, EMULATED_PRIME-1)
B=random.randint(0, EMULATED_PRIME-1)
a=EmulatedBigInt(N_LIMBS, N_CORES, BASE, NATIVE_PRIME, EMULATED_PRIME, A)
b=EmulatedBigInt(N_LIMBS, N_CORES, BASE, NATIVE_PRIME, EMULATED_PRIME, B)

assert a.test_assert_reduced_felt() == 0, "Error: test_assert_reduced_felt() not passing"

assert a.mul_honest(b) == 0, "Error: mul_honest() not passing"


l=a.test_full_field_mul_honest()
print(a)
print(b)
print(l)
print(len(l))

assert len(l) == 0, "Error: test_full_field_mul_honest() not passing on all values"


print(a, b)


a.set_value(37)
b.set_value(15)
l=a.hack_mul(b)

if len(l)==1:
    print(f"Good! Hint is safe.")
    print(f"Number of values passing : {len(l)}")

else:
    print(l)
    print(f"Number of values passing : {len(l)}")
    print(f"Error: hack_mul() returned a list with more than one element")