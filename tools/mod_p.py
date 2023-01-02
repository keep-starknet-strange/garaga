from polynomial import Polynomial
P = 21888242871839275222246405745257275088696311157297823662689037894645226208583


def split(num: int, num_bits_shift: int, length: int):
    a = []
    for _ in range(length):
        a.append(num & ((1 << num_bits_shift) - 1))
        num = num >> num_bits_shift
    return tuple(a)


def q_fn(x):
    x_limbs = split(x, 64, 5)
    print(x_limbs)
    x_4 = x_limbs[4]
    print("x4", x_4)
    x_3 = x_limbs[3]
    print("x3", x_3)
    q = x_4 << 3 | x_3 >> 61

    return q


def f(x):
    q = q_fn(x)
    print("q=", q, bin(q))
    p_Tbl = p_Tbl_fn(q)
    print("p_Tbl=", p_Tbl)
    z = x-p_Tbl
    if z < 0:
        z = z+P

    print("real_res_mod_p", x % P)
    print("Z=")
    print(x % P == z)

    return z


def p_Tbl_fn(q):
    if 0 <= q <= 3:  # 9
        return q*P
    # if 10<=q<=14:
    #     return (q-1)*P
    else:
        raise ValueError(q)


def p_Tbl_bn254(q):
    if q == 0:
        return q*P
    if q == 1:
        return q*P
    if q == 2:
        return 3*P
    if q == 3:
        return 4*P
    if q == 4:
        return 6*P


f(P+P//2)


def g(x):
    limbs = split(x, 128, 4)
    bl = x.bit_length()
    print('x_bl=', bl)
    s = 2**253*P
    print("sub bl=", s.bit_length())
    z = x-s
    print('z_bl=', z.bit_length())
    print(z == x % P)
    print("z_result=", z)
    print("z_mod_p=", z % P)
    print("x_mod_p", x % P)


g((P-P//8)*(P-12657978788898))


def compute_Pp_mu(P):
    M = 2**381 % P
    mu = 2**381//P
    return M, mu


M, mu = compute_Pp_mu(P)


def pack(z, num_bits_shift: int) -> int:
    limbs = z
    return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))


def intel(x):
    M, mu = compute_Pp_mu(P)
    limbs = split(x, 128, 4)
    N = M*(x//2**381) + x % 2**381

    print('N', N, N.bit_length())
    T_mu = mu * (N//2**254)
    print("n_div254", N//2**254, (N//2**254).bit_length())
    print("T_mu=", T_mu, T_mu.bit_length())
    T_P = (T_mu//2**127)*P
    print(N, T_P)    # s=857

    R = N-T_P
    return R


def barett(x):
    mu = 2**509//P
    limbs = split(x, 128, 4)
    T_mu = mu//2**254
    R = x - (x//2**254)*T_mu*P
    return R


L = (P-93849028375890238420398403284234)*(P-P//5)
R = intel(L)
B = barett(L)


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


def first_loop_cf(ap, bp):
    t, s, P = load_coeff()
    c = [0, 0, 0, 0, 0]
    c_full = [0, 0, 0, 0, 0]

    for j in [0, 1, 2, 3, 4]:

        print("c", c, j)
        c_full = to_poly_256(evaluate(c_full)+a*bp[j])

        for i in range(5):
            c[i] = c[i]+ap[i]*bp[j]

        assert evaluate(c_full) == evaluate(c)
        print(evaluate(c_full) == evaluate(c))
        print(c_full == c)
        print(c_full, c)

        mu = c_full[0]//2**62
        mu = c[0]//2**62
        gamma_full = (c_full[0] % 2**62) - s*mu
        gamma = (c[0] % 2**62) - s*mu

        g_full = -P*gamma_full
        # assert (evaluate(c_full)+g_full) % t == 0
        g = [-gamma, -6*gamma, -24*gamma, -36*gamma, -36*gamma]

        c_full = to_poly_256((evaluate(c_full)+g_full) //
                             t + (evaluate(c_full)+g_full) % t + mu)
        print(c_full)
        for i in range(5):
            c[i] = (c[i]+g[i])//t
            print(c[i])

        print(j, c_full, c)


def divmod_by_t(a):
    m, t, s, P = load_coeff()
    mu = 0
    gamma = a
    while gamma >= t:
        rho = gamma//2**m
        gamma = gamma % 2**m
        mu = mu + rho
        gamma = gamma-s*rho
    assert a == mu*t+gamma
    return mu, gamma


def first_loop(A: Polynomial, B: Polynomial):
    m, t, s, P = load_coeff()

    c = [0, 0, 0, 0, 0]
    C = Polynomial([0])

    for j in [0, 1, 2, 3, 4]:
        print(f"\n ============ {j} ============= \n")
        C = C + A*B[j]

        for i in range(5):
            c[i] = c[i]+A[i]*B[j]

        try:
            assert C.calculate(t) == evaluate(c), "C==c"
        except AssertionError:
            print("/!\ C(t) != c(t)")
        else:
            print("/ok\ C(t) == c(t)")

        MU = C[0]//2**62
        mu = c[0]//2**62

        try:
            assert MU == mu, "mu==MU"
        except AssertionError:
            print("/!\ MU != mu")
        else:
            print("/ok\ MU == mu")

        GAMMA = (C[0] % 2**62) - s*MU
        gamma = (c[0] % 2**62) - s*mu

        # g_full = -P*gamma_full
        G = -P*GAMMA
        # assert (evaluate(c_full)+g_full) % t == 0
        g = [-gamma, -6*gamma, -24*gamma, -36*gamma, -36*gamma]

        # c_full = to_poly_256((evaluate(c_full)+g_full) //
        #                      t + (evaluate(c_full)+g_full) % t + mu)
        # print(c_full)

        print('C BEFORE <- (C+G) div T +s \n', C, '\n')
        print('c BEFORE <- (c+g) div T \n', Polynomial(reversed(c)), '\n')

        K = C+G
        K_COPY = K
        print('K=C+G \n', K)
        print(K[0]//t, '*t ,,, + ',  K[0] % t)
        L = Polynomial([K[4], K[3], K[2], K[1]+K[0]//t+int((K[0] % t)/t)])
        print(f"K*t^(-1) with int_rem={(K[0] % t)/t} \n", L)
        print('\n REST OF (C+G)/t =', K % Polynomial(t), '\n')
        # C: Polynomial = (K//Polynomial(t))+Polynomial([mu])
        # print(C)
        # x = int(C(t))
        # print(x)
        C = L+Polynomial([mu])
        # print(C(t), abs(x-C(t)))
        print(C)

        for i in range(5):
            c[i] = (c[i]+g[i])//t
            c
            # print(c[i])

        print("C AFTER div T + s \n", C, '\n\nc after div T')
        print(Polynomial(reversed(c)), '\n')
    return C


def mul_poly(a, b):
    m, t, s, P = load_coeff()

    ap = to_poly_256(a)
    bp = to_poly_256(b)
    A = Polynomial(reversed(ap))
    B = Polynomial(reversed(bp))
    C = A*200
    print(C)
    print("\nA\n", A, '\nB\n', B, "\n")
    print(A[0], A[1])
    assert len(ap) == 5
    assert len(bp) == 5

    assert evaluate(ap) == a
    assert evaluate(bp) == b

    C = first_loop(A, B)

    # c_p = to_poly_256(c_full)

    # print("c_p_inter", c_p)

    # second_loop(c)

    val = C.calculate(t)
    print(C)
    print('val', val,)
    return C, val


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


def second_loop(c_p):
    m, t, s, P = load_coeff()

    for i in [0, 1, 2, 3]:
        mu = c_p[i]//2**62
        gamma = c_p[i] % 2**62 - s*mu
        c_p[i+1] = c_p[i+1]+mu
        c_p[i] = gamma
        if i == 3:
            print("mu4", mu)
    for i in [0, 1, 2, 3]:
        mu = c_p[i]//2**62
        gamma = c_p[i] % 2**62 - s*mu
        c_p[i+1] = c_p[i+1]+mu
        c_p[i] = gamma
        print('gamma', gamma)
        if i == 3 or i == 2 or i == 1 or i == 0:
            print("c4", c_p[4])
        if i == 3:
            print("mu4", mu)


def second_loop_fi(c):
    for i in [0, 1, 2, 3]:
        mu = c_p[i]//2**62
        gamma = c_p[i] % 2**62 - s*mu
        c_p[i+1] = c_p[i+1]+mu
        c_p[i] = gamma
        if i == 3:
            print("mu4", mu)
    for i in [0, 1, 2, 3]:
        mu = c_p[i]//2**62
        gamma = c_p[i] % 2**62 - s*mu
        c_p[i+1] = c_p[i+1]+mu
        c_p[i] = gamma
        print('gamma', gamma)
        if i == 3 or i == 2 or i == 1 or i == 0:
            print("c4", c_p[4])
        if i == 3:
            print("mu4", mu)


def verify_t_assertions(m, s):
    t = 2**m+s


a = P-123
b = P-P//7
print(to_poly_256(a))
print(to_poly_256(b))
print(to_poly_256(a*b))

c, val = mul_poly(a, b)
true = a*b % P
c_t = to_poly_256(true)
