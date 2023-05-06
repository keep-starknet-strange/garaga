import random
from typing import Tuple, List
from math import lcm

p = 3618502788666131213697322783095070105623107215331596699973092056135872020481
q = 21888242871839275222246405745257275088696311157297823662689037894645226208583

n = 3 # number of limbs
n_pi = 2*n - 1 # number of limbs in polynomial product
b = 2**86 # base

def get_felt(p:int):
    return random.randint(0, p-1)

def split_fq(x:int) -> List[int]:
    assert x >= 0, "Error: x must be positive"
    coeffs, degree = [], n-1
    for i in range(degree, 0, -1):
        q, r = divmod(x, b ** i)
        coeffs.append(q)
        x = r
    coeffs.append(x)
    return coeffs[::-1]

# evaluate x(b)
def sigma_b(x:list):
    result = 0
    for i in range(len(x)):
        assert x[i] < b, f"Error: wrong bounds {x[i]} >= {b}"
        result += b**i * x[i]
    assert 0 <= result < b**(len(x)) - 1, f"Error: wrong bounds {result} >= {b**(len(x)) - 1}"
    return result

# multiply x(b) and y(b), returns limbs and x(b)*y(b)
def pi_b(x:list, y:list) -> Tuple[List[int], int]:
    assert len(x) == len(y) == n, "Error: pi_b() requires two lists of length n"
    limbs = n_pi*[0]
    result = 0
    for i in range(n):
        for j in range(n):
            limbs[i+j] += x[i]*y[j]
            result += x[i]*y[j] * b**(i+j)
    assert 0 <= result < b**(2*n) - 1, f"Error: wrong bounds {result} >= {b**(2*n) - 1}"
    return limbs, result

# evaluate x(b) mod m
def sigma_b_mod_m(x:list, m:int):
    result = 0
    assert len(x) == n_pi or len(x) == n, "Error: sigma_b_mod_m() requires a list of length n or n_pi"
    for i in range(len(x)):
        result += (b**i % m) * x[i]
    assert result == sigma_b(x) % m, "Error: sigma_b_mod_m() is not working"
    assert 0 <= result < n*m*b, "Error: wrong bounds"
    return result

# multiply x(b) and y(b) mod m, returns limbs and x(b)*y(b) mod m
def pi_b_mod_m(x:list, y:list, m:int) -> Tuple[List[int], int]:
    assert len(x) == len(y) == n, "Error: pi_b() requires two lists of length n"
    limbs = n_pi*[0]
    result = 0
    for i in range(n):
        for j in range(n):
            limbs[i+j] += x[i]*y[j]
            result += x[i]*y[j] * (b**(i+j)%m)
    assert 0 <= result < n**2*m*b**2
    return limbs, result


x_o,y_o = get_felt(q), get_felt(q)
x,y = split_fq(x_o), split_fq(y_o)
max = split_fq(q-1)

assert sigma_b(x) == x_o, "Error: sigma_b() is not working"
assert sigma_b(y) == y_o, "Error: sigma_b() is not working"
assert pi_b(max, max)[1] == (q-1)**2, "Error: pi_b() is not working"
assert sigma_b_mod_m(max, q) == q-1, "Error: sigma_b_mod_m() is not working"

