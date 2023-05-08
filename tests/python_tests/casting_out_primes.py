import random
from typing import Tuple, List
from math import lcm
from sympy import gcd

p = 3618502788666131213697322783095070105623107215331596699973092056135872020481
q = 21888242871839275222246405745257275088696311157297823662689037894645226208583

n = 3 # number of limbs
n_pi = 2*n - 1 # number of limbs in polynomial product
b = 2**86 # base

def get_felt(p:int) -> int:
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
def sigma_b(x:list) -> int:
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
def sigma_b_mod_m(x:list, m:int) -> int:
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

def sigma_b_mod_q_mod_m(x, m):
    result = 0
    for i in range(len(x)):
        result += ((b**i % q) % m) * x[i]
    assert result % m == (sigma_b(x) % q) % m, f"Error : {result} != {sigma_b_mod_m(x, q) % m}"
    return result

def pi_b_mod_q_mod_m(x, y, m):
    assert len(x) == len(y) == n, "Error: pi_b() requires two lists of length n"
    limbs = n_pi*[0]
    result = 0
    for i in range(n):
        for j in range(n):
            limbs[i+j] += x[i]*y[j]
            result += x[i]*y[j] * ((b**(i+j)%q)%m)
    assert 0 <= result < n**2*m*b**2
    return limbs, result


def get_m_bound() -> int:
    return p//(4*(n**2)*(b**2))
def get_lcm_bound() -> int:
    return 2*(n**2)*q*(b**2)

def generate_coprime_set(m_bound, lcm_bound) -> List[int]:
    M=[p]
    # Check if a candidate number is coprime to all elements in M
    def is_coprime_to_all(candidate, M):
        return all(gcd(candidate, m) == 1 for m in M)
    candidate = m_bound
    while candidate >= 2:
        if is_coprime_to_all(candidate, M):
            M.append(candidate)
        if lcm(*M) >= lcm_bound:
            break
        candidate -= 1
    return M

def get_witness_z_r_s(x:list, y:list, M:list):
    assert len(x) == len(y) == n, "Error: get_witness_z_and_q() requires two lists of length n"
    z:list = split_fq(sigma_b(x) * sigma_b(y) % q)
    pi:int = pi_b_mod_m(x, y, q)[1]
    sigma:int = sigma_b_mod_m(z, q)
    r_q = pi - sigma
    assert r_q % q == 0, "Error: r_q is not divisible by q"
    r = r_q // q
    S = []
    for i in range(len(M)):
        m = M[i]
        pi:int = pi_b_mod_q_mod_m(x, y, m)[1]
        sigma:int = sigma_b_mod_q_mod_m(z, m)
        s_m = pi - sigma - r*(q%m)
        assert s_m % m == 0, "Error: s_m is not divisible by m"
        s = s_m // m
        S.append(s)
    return z, r, S

m_bound = get_m_bound()
lcm_bound = get_lcm_bound()
M = generate_coprime_set(m_bound, lcm_bound)
print("Coprime set M:", set(M))

x_o,y_o = get_felt(q), get_felt(q)
x,y = split_fq(x_o), split_fq(y_o)
max = split_fq(q-1)

assert sigma_b(x) == x_o, "Error: sigma_b() is not working"
assert sigma_b(y) == y_o, "Error: sigma_b() is not working"
assert pi_b(max, max)[1] == (q-1)**2, "Error: pi_b() is not working"
assert sigma_b_mod_m(max, q) == q-1, "Error: sigma_b_mod_m() is not working"

z, r, S = get_witness_z_r_s(x, y, M)
