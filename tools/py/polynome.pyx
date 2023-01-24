from polynomial import Polynomial
from math import inf
import sympy


ctypedef unsigned long long UINT64

ctypedef (UINT64, UINT64, UINT64, UINT64, UINT64) POLY4

cpdef UINT64 evaluate_poly(POLY4 P, UINT64 t):
    cdef UINT64 res=P[0] + P[1]*t + P[2]*t**2 + P[3]*t**3 + P[4]*t**4
    return res

# Load coefficients for the polynomial
# Arguments:
#   i: 0 for the default curve, 1 for alt_bn128, 2 for experimental t
# Returns:
#   m: (the number of bits in t) - 1
#   t: parameter of BN curve prime
#   s: reminder of t when divided by 2**m
#   P: the prime polynomial for all BN curves. p = P(t)
#  t_div_prime_div: t divided by the prime divisor of t
cpdef (UINT64, UINT64, UINT64, UINT64, POLY4) load_coeff(int i):
    cdef UINT64 m,t,s
    if i == 0:
        m = 63
        t = 2**63 + 857  # t chosen in Efficient Hardware Implementation of IFp-Arithmetic for Pairing-Friendly Curves paper
        s = 857
        prime_divisor=1
    if i == 1:
        m = 62
        t = 4965661367192848881  # t for alt_bn128 (ethereum, noir,...) 2**62 < t < 2**63
        s = 353975348765460977 # == t - 2**62
        prime_divisor=1
    if i == 2:
        m = 62
        t = 2**62 + 857  # experimental t
        s = 857
        t_div_prime_div=t//1
    if i==3: # smallest t for testing all values in a reduced field. t<37 leads to wrong polynomials (why?)
        m = 5
        t = 37
        s = 5
        t_div_prime_div=t//1
    if i==4: # smallest non-prime t with prime divisors. 2 and 19 are prime divisors. 
        m = 5
        t = 38
        s = 6
        prime_divs=[x for x in sympy.divisors(39) if sympy.isprime(x) == True]
        t_div_prime_div=t//max(prime_divs)
    if i==5: # smallest non-prime odd t with prime divisors. 2 and 19 are prime divisors. 
        m = 5
        t = 39
        s = 7
        prime_divs=[x for x in sympy.divisors(39) if sympy.isprime(x) == True]
        t_div_prime_div=t//max(prime_divs)
    else:
        return(0,i,0,i, (1,6,24,36,36))
    return (m, t, s, t_div_prime_div, (1,6,24,36,36))
