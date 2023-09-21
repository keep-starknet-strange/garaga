import random

B = 2**86


def generate_random_bit_number(bits):
    """Generate a random number with a given number of bits."""
    return random.getrandbits(bits)


def UnreducedUint256_to_UnreducedBigInt3(n0, n1):
    ks = felt_to_bigint3(n0, degree=2, base=B)  # Felt_To_BigInt3
    js = felt_to_bigint3(n1, degree=2, base=B)  # Felt_To_BigInt3
    return ks[0] + js[0] * 2**128, ks[1] + js[1] * 2**128, ks[2] + js[2] * 2**128


# Equivalent to split_felt + uint256_to_bigint3 in cairo
def felt_to_bigint3(x, degree=2, base=B):
    assert x < 2**251
    coeffs = []
    for n in range(degree, 0, -1):
        q, r = divmod(x, base**n)
        coeffs.append(q)
        x = r
    coeffs.append(x)

    return coeffs[::-1]


# Number of samples
num_samples = 180

# Initialize sums
sum_N0 = 0
sum_N1 = 0

# Simulate polynomial coefficient accumulation of emulated field element represented in two 128-bit chunks with random linear combination
for _ in range(num_samples):
    N0_i = generate_random_bit_number(128)
    N1_i = generate_random_bit_number(126)
    c_i = generate_random_bit_number(100)

    sum_N0 += N0_i * c_i
    sum_N1 += N1_i * c_i


print(f"sum_N0 bits = {sum_N0.bit_length()}")
print(f"sum_N1 bits = {sum_N1.bit_length()}")

k0, k1, k2 = UnreducedUint256_to_UnreducedBigInt3(sum_N0, sum_N1)

# Convert BigInt3 representation back to a single number
N_prime = k0 + k1 * (B) + k2 * (B**2)

N = sum_N0 + sum_N1 * (2**128)

# Assertion to check correctness
assert N == N_prime


print(f"k0_bits = {k0.bit_length()}")
print(f"k1_bits = {k1.bit_length()}")
print(f"k2_bits = {k2.bit_length()}")
