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


result = 1
while result == 1:
    # Temporary : Needs more research on the exact carry constraints needed in EmulatedBigInt
    # But for now, if mul_honest is passing, hack_mul works only with the correct value (as expected)
    A=random.randint(0, EMULATED_PRIME-1)
    B=random.randint(0, EMULATED_PRIME-1)

    a=EmulatedBigInt(N_LIMBS, N_CORES, BASE, NATIVE_PRIME, EMULATED_PRIME, A)
    b=EmulatedBigInt(N_LIMBS, N_CORES, BASE, NATIVE_PRIME, EMULATED_PRIME, B)
    result = a.mul_honest(b)


print(a)
print(b)

l=a.hack_mul(b)


if len(l)==1:
    print(f"Good! Hint is safe.")
    print(f"Exactly one couple of hint output is passing assertions!")

else:
    print(l)
    print(f"Error: hack_mul() returned a list with more than one element")