from polynomial import Polynomial
from math import inf

ctypedef unsigned long long UINT64

ctypedef (UINT64, UINT64, UINT64, UINT64, UINT64) POLY4

class Polynome(Polynomial):
    def __getitem__(self, degree):
        """Get the coefficient of the term with the given degree."""
        if isinstance(degree, slice):
            return self._vector[degree]
        if degree == -inf and self.degree == -inf:
            return 0
        if degree > self.degree or degree < 0:
            return 0
        return self._vector[degree]
    

cpdef UINT64 evaluate_poly(POLY4 P, UINT64 t):
    cdef UINT64 res=P[0] + P[1]*t + P[2]*t**2 + P[3]*t**3 + P[4]*t**4
    return res

cpdef (UINT64, UINT64, UINT64, POLY4) load_coeff(int i):
    cdef UINT64 m,t,s
    if i == 0:
        m = 63
        t = 2**63 + 857  # t chosen in Efficient Hardware Implementation of IFp-Arithmetic for Pairing-Friendly Curves paper
        s = 857
    if i == 1:
        m = 62
        t = 4965661367192848881  # t for alt_bn128 (ethereum, noir,...) 2**62 < t < 2**63
        s = 353975348765460977 # == t - 2**62
    if i == 2:
        m = 62
        t = 2**62 + 857  # experimental t
        s = 857
    if i==3: # smallest t for testing all values in a reduced field. t<37 leads to wrong polynomials (why?)
        m = 5
        t = 37
        s = 5
    return (m, t, s, (1,6,24,36,36))


# Load coefficients for the polynomial
# Arguments:
#   i: 0 for the default curve, 1 for alt_bn128, 2 for experimental t
# Returns:
#   m: (the number of bits in t) - 1
#   t: parameter of BN curve prime
#   s: reminder of t when divided by 2**m
#   P: the prime polynomial for all BN curves. p = P(t)
def load_coeff_py(i=0):
    if i == 0:
        m = 63
        t = 2**63 + 857  # t chosen in Efficient Hardware Implementation of IFp-Arithmetic for Pairing-Friendly Curves paper
        s = 857
    if i == 1:
        m = 62
        t = 4965661367192848881  # t for alt_bn128 (ethereum, noir,...) 2**62 < t < 2**63
        s = t - 2**62

    if i == 2:
        m = 62
        t = 2**62 + 857  # experimental t
        s = 857
    if i==3: # small t for testing all values in a reduced field
        m = 2
        t = 9
        s = 1

    P = 36 * t**4 + 36 * t**3 + 24 * t**2 + 6 * t + 1

    return m, t, s, Polynome([36, 36, 24, 6, 1])


# Convert a number to its polynomial representation
# Arguments:
#   x: the number to convert
# Returns:
#   P: the polynomial 
def to_polynome_py(x:int):
    m, t, s, P = load_coeff_py()
    res = []

    q4 = x // t**4
    r = x % t**4
    q3 = r // t**3
    r = r % t**3
    q2 = r // t**2
    r = r % t**2
    q1 = r // t**1
    r = r % t
    q0 = r

    res = [q0, q1, q2, q3, q4]
    P = Polynome(reversed(res))
    assert P(t) == x
    return P

