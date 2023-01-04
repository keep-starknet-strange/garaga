from polynomial import Polynomial

# Load coefficients for the polynomial
# Arguments:
#   i: 0 for the default curve, 1 for alt_bn128, 2 for experimental t
# Returns:
#   m: (the number of bits in t) - 1
#   t: parameter of BN curve prime
#   s: reminder of t when divided by 2**m
#   P: the prime polynomial for all BN curves. p = P(t)
def load_coeff(i=0):
    if i == 0:
        m = 63
        t = (
            2**63 + 857
        )  # t chosen in Efficient Hardware Implementation of IFp-Arithmetic for Pairing-Friendly Curves paper
        s = 857
    if i == 1:
        m = 62
        t = 4965661367192848881  # t for alt_bn128 (ethereum, noir,...) 2**62 < t < 2**63
        s = t - 2**62

    if i == 2:
        m = 62
        t = 2**62 + 857  # experimental t
        s = 857

    P = 36 * t**4 + 36 * t**3 + 24 * t**2 + 6 * t + 1

    return m, t, s, Polynomial([36, 36, 24, 6, 1])


# Convert a number to its polynomial representation
# Arguments:
#   x: the number to convert
# Returns:
#   P: the polynomial
def to_polynomial(x:int):
    m, t, s, P = load_coeff()
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
    P = Polynomial(reversed(res))
    assert P(t) == x
    return P


# Phase 1 as defined in Efficient Hardware Implementation of IFp-Arithmetic for Pairing-Friendly Curves paper
# Multiply two polynomials
# Arguments:
#   A: the first polynomial
#   B: the second polynomial
# Returns:
#   C: the result of the multiplication
def phase_1_polynomial_multiplication(A: Polynomial, B: Polynomial):
    m, t, s, P = load_coeff()
    print("\n Phase 1 - Polynomial Multiplication")
    C = A * B
    print(C)
    print(C(t) % P(t))
    return C


# Phase 2 as defined in Efficient Hardware Implementation of IFp-Arithmetic for Pairing-Friendly Curves paper
# Reduce the coefficients of a polynomial.
# Divide each coefficient by t and add the remainder to the next coefficient.
# Arguments:
#   C: the polynomial to reduce
# Returns:
#   C: the reduced polynomial
def phase_2_coefficient_reduction(C):
    C = C
    print("\n Phase 2 - Coefficient Reduction")

    m, t, s, P = load_coeff()
    for i in [0, 1, 2, 3, 4]:
        C[i + 1] = C[i + 1] + C[i] // t
        C[i] = C[i] % t

    print(C)
    print(C(t) % P(t))
    return C


# Phase 3 as defined in Efficient Hardware Implementation of IFp-Arithmetic for Pairing-Friendly Curves paper
# Reduce the polynomial degree.
# Arguments:
#   C: the polynomial to reduce
# Returns:
#   C: the reduced polynomial
def phase_3_polynomial_reduction(C):
    m, t, s, P = load_coeff()

    print("\n Phase 3 - Polynomial Reduction")
    MIN_P_MIN_ONE = Polynomial(reversed([-1, 6, -12, -36, 324]))
    print(MIN_P_MIN_ONE)
    print("Q=\n", C * MIN_P_MIN_ONE)
    Q = Polynomial(
        [
            -C[4] + 6 * (C[3] - 2 * C[2] - 6 * (C[1] - 9 * C[0])),
            -C[3] + 6 * (C[2] - 2 * C[1] - 6 * C[0]),
            -C[2] + 6 * (C[1] - 2 * C[0]),
            -C[1] + 6 * C[0],
            0,
        ]
    )
    assert Q.degree == 4
    print("Q paper (truncated, no constant term)=\n", Q)
    H = Polynomial(
        [
            36 * Q[4],
            36 * (Q[4] + Q[3]),
            12 * (2 * Q[4] + 3 * (Q[3] + Q[2])),
            6 * (Q[4] + 4 * Q[3] + 6 * (Q[2] + Q[1])),
        ]
    )
    assert H.degree == 3

    MIN_CT = C * MIN_P_MIN_ONE * P  # : ok mais trop grand
    MIN_C = Q * P  # pas congru à 0 mod t*5
    print("MIN_C")
    print(MIN_C)

    C_MIN_CT: Polynomial = C + MIN_CT

    C_MIN_C: Polynomial = C + MIN_C

    print("C_MIN_CT=C+MIN_CT # 0 mod t**5 \n", C_MIN_CT, "\n")
    print("C_MIN_C=C+MIN_C # 0 mod t**5 \n", C_MIN_C, "\n")

    def print_mod_ab_t5(X: Polynomial, n: str):
        print(X(t) % t**5 == 0, f"\t{n}(t) % t**5 == 0")
        print(X(t) % P(t) == C(t) % P(t), f"\t{n}(t) % P(t) == a*b % P \n")

    print_mod_ab_t5(C_MIN_CT, "C_MIN_CT")
    print_mod_ab_t5(C_MIN_C, "C_MIN_C")

    C_DIV_Z_5 = Polynomial([C_MIN_C[8], C_MIN_C[7], C_MIN_C[6], C_MIN_C[5]])

    print_mod_ab_t5(C_DIV_Z_5, "C_DIV_Z_5")

    C_DIV_Z_5T = Polynomial(
        [
            C_MIN_CT[16],
            C_MIN_CT[15],
            C_MIN_CT[14],
            C_MIN_CT[13],
            C_MIN_CT[12],
            C_MIN_CT[11],
            C_MIN_CT[10],
            C_MIN_CT[9],
            C_MIN_CT[8],
            C_MIN_CT[7],
            C_MIN_CT[6],
            C_MIN_CT[5],
        ]
    )

    print_mod_ab_t5(C_DIV_Z_5T, "C_DIV_Z_5T")
    print("\nC_DIV_Z_5 # C*Z^-5 mod P\n", C_DIV_Z_5)

    V = C_DIV_Z_5 + H
    # assert V.degree == 3

    print(C_DIV_Z_5(t) % P(t))
    print_mod_ab_t5(V, "V")
    return V


# Phase 4 as defined in Efficient Hardware Implementation of IFp-Arithmetic for Pairing-Friendly Curves paper
# Reduce the coefficients of a polynomial.
# Divide each coefficient by t and add the remainder to the next coefficient.
# Arguments:
#   V: the polynomial to reduce
# Returns:
#   R: the reduced polynomial
def phase_4_coefficient_reduction(V):
    print("\n Phase 4 - Coefficient Reduction")

    m, t, s, P = load_coeff()
    V = V
    c = [V[0], V[1], V[2], V[3], 0]
    print(Polynomial(reversed(c)))
    for i in [0, 1, 2, 3]:
        c[i + 1] = c[i + 1] + c[i] // t
        c[i] = c[i] % t
    print(c)
    R = Polynomial(reversed(c))
    # assert R.degree == 4
    return R


# Modular multiplication of two integers using the polynomial representation of each integer.
# Arguments:
#   a: the first integer
#   b: the second integer
# Returns:
#   V: the polynomial representation of a * b mod P
#   val: a * b mod P
def mulmod(a: int, b: int):
    m, t, s, P = load_coeff()
    A = to_polynomial(a)
    B = to_polynomial(b)

    C = phase_1_polynomial_multiplication(A, B)
    C = phase_2_coefficient_reduction(C)
    V = phase_3_polynomial_reduction(C)
    V = phase_4_coefficient_reduction(V)

    print("End. Final Polynomial:")
    print(V, "\n")

    return V, V(t)


# Test the modular multiplication
# Load the coefficients of the polynomial representation of P
m, t, s, P = load_coeff()
p = P(t)

a = p - 123
b = p - p // 7

# Compute the modular multiplication
V, val = mulmod(a, b)

# Check that the result is correct
print(val == a * b % p)
