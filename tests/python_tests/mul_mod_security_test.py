import random
import sympy

def generate_prime(n):
    while True:
        # Generate a random n-bit number
        num = random.getrandbits(n)

        # Set the most significant and least significant bits to 1
        num |= (1 << n-1) | 1

        # Check if the number is prime
        if sympy.isprime(num):
            return num

p_stark=generate_prime(5)
p_emul=generate_prime(6)

