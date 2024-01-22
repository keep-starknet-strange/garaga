import random

p = 21888242871839275222246405745257275088696311157297823662689037894645226208583


def split_128(a):
    """Takes in value, returns uint256-ish tuple."""
    return (a & ((1 << 128) - 1), a >> 128)


a, b = [random.randint(0, p - 1) for _ in range(2)]
a_s, b_s, p_s = split_128(a), split_128(b), split_128(p)

q, r = divmod(a * b, p)
qs, rs = split_128(q), split_128(r)

assert a * b == q * p + r

# Evaluate in x=0
assert (
    a_s[0] * b_s[0] % 2**128 - qs[0] * p_s[0] % 2**128 - rs[0] == 0
), f"{a_s[0] * b_s[0] - qs[0] * p_s[0] - rs[0]}"
