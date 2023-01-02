
from polynomial import Polynomial
p = 21888242871839275222246405745257275088696311157297823662689037894645226208583


def load_coeff(i=0):
    if i == 0:
        m = 63
        t = 2**63 + 857
        s = 857
    if i == 1:
        m = 62
        t = 4965661367192848881
        s = t-2**62

    if i == 2:
        m = 62
        t = 2**62+857
        s = 857

    P = 36*t**4+36*t**3+24*t**2 + 6*t + 1

    return m, t, s, Polynomial([36, 36, 24, 6, 1])


def evaluate(c):
    m, t, s, P = load_coeff()
    # t=2**62+857
    # t=2**63 + 2**9 + 2**8 + 2**6 + 2**4 + 2**3 + 1
    r = c[0] + c[1]*t + c[2]*t**2+c[3]*t**3+c[4]*t**4
    return r


def to_poly_256(x):
    m, t, s, P = load_coeff()
    res = []

    q4 = x//t**4
    r = x % t**4
    q3 = r//t**3
    r = r % t**3
    q2 = r//t**2
    r = r % t**2
    q1 = r//t**1
    r = r % t
    q0 = r

    res = [q0, q1, q2, q3, q4]
    assert evaluate(res) == x
    return res


def phase_1_polynomial_multiplication(A: Polynomial, B: Polynomial):
    m, t, s, P = load_coeff()
    print("\n Phase 1")
    C = A*B
    # print(C(t))
    print(C)
    print(C(t) % P(t))
    return C


def phase_2_coefficient_reduction(C):
    C = C
    print("\n Phase 2")

    m, t, s, P = load_coeff()
    for i in [0, 1, 2, 3, 4]:
        C[i+1] = C[i+1] + C[i]//t
        C[i] = C[i] % t

    print(C)
    print(C(t) % P(t))
    return C


def phase_3_polynomial_reduction(C):
    m, t, s, P = load_coeff()

    print("\n Phase 3")
    MIN_P_MIN_ONE = Polynomial(reversed([-1, 6, -12, -36, 324]))
    print(MIN_P_MIN_ONE)
    print('Q=\n', C*MIN_P_MIN_ONE)
    Q = Polynomial([-C[4] + 6*(C[3] - 2*C[2] - 6*(C[1]-9*C[0])),
                    -C[3] + 6*(C[2] - 2*C[1] - 6*C[0]),
                    -C[2] + 6*(C[1] - 2*C[0]),
                    -C[1] + 6*C[0],
                    0])
    assert Q.degree == 4
    print('Q paper (truncated, no constant term)=\n', Q)
    H = Polynomial([36*Q[4],
                    36*(Q[4]+Q[3]),
                    12*(2*Q[4]+3*(Q[3]+Q[2])),
                    6*(Q[4]+4*Q[3]+6*(Q[2]+Q[1]))])
    assert H.degree == 3

    MIN_CT = C*MIN_P_MIN_ONE*P  # : ok mais trop grand
    MIN_C = Q*P  # pas congru à 0 mod t*5
    print('MIN_C')
    print(MIN_C)

    C_MIN_CT: Polynomial = C + MIN_CT

    C_MIN_C: Polynomial = C + MIN_C

    print('C_MIN_CT=C+MIN_CT # 0 mod t**5 \n', C_MIN_CT, '\n')
    print('C_MIN_C=C+MIN_C # 0 mod t**5 \n', C_MIN_C, '\n')

    def print_mod_ab_t5(X: Polynomial, n: str):
        print(X(t) % t**5 == 0, f"\t{n}(t) % t**5 == 0")
        print(X(t) % P(t) == C(t) %
              P(t), f"\t{n}(t) % P(t) == a*b % P \n")

    print_mod_ab_t5(C_MIN_CT, "C_MIN_CT")
    print_mod_ab_t5(C_MIN_C, "C_MIN_C")

    C_DIV_Z_5 = Polynomial(
        [C_MIN_C[8], C_MIN_C[7], C_MIN_C[6], C_MIN_C[5]])

    print_mod_ab_t5(C_DIV_Z_5, 'C_DIV_Z_5')

    C_DIV_Z_5T = Polynomial(
        [C_MIN_CT[16], C_MIN_CT[15], C_MIN_CT[14], C_MIN_CT[13],
         C_MIN_CT[12], C_MIN_CT[11], C_MIN_CT[10], C_MIN_CT[9],
         C_MIN_CT[8], C_MIN_CT[7], C_MIN_CT[6], C_MIN_CT[5]])

    print_mod_ab_t5(C_DIV_Z_5T, 'C_DIV_Z_5T')
    print('\nC_DIV_Z_5 # C*Z^-5 mod P\n', C_DIV_Z_5)

    V = C_DIV_Z_5 + H
    # assert V.degree == 3

    print(C_DIV_Z_5(t) % P(t))
    print_mod_ab_t5(V, 'V')
    return V


def phase_4_coefficient_reduction(V):
    print("\n Phase 4")

    m, t, s, P = load_coeff()
    V = V
    c = [V[0], V[1], V[2], V[3], 0]
    print(Polynomial(reversed(c)))
    for i in [0, 1, 2, 3]:
        c[i+1] = c[i+1] + c[i]//t
        c[i] = c[i] % t
    print(c)
    R = Polynomial(reversed(c))
    # assert R.degree == 4
    return R


def mulmod(a: int, b: int):
    m, t, s, P = load_coeff()
    A = Polynomial(reversed(to_poly_256(a)))
    B = Polynomial(reversed(to_poly_256(b)))

    C = phase_1_polynomial_multiplication(A, B)
    C = phase_2_coefficient_reduction(C)
    V = phase_3_polynomial_reduction(C)
    V = phase_4_coefficient_reduction(V)

    print('end. Final Polynome:')
    print(V, '\n')

    return V, V(t)


m, t, s, P = load_coeff()
p = P(t)
print(p, p.bit_length(), 'bits')

a = p-123
b = p-p//7

V, val = mulmod(a, b)

print(val, val.bit_length(), 'bits')
print(val == a*b % p)
print(a*b % p, (a*b % p).bit_length(), 'bits')
