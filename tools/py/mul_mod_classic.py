from polynomial import Polynomial
P = 21888242871839275222246405745257275088696311157297823662689037894645226208583

# "Classical" techniques for mul mod using reduction techniques such as Barett or Modified Barett reduction (intel)
# see intel paper : https://www.lirmm.fr/arith18/papers/hasenplaugh-FastModularReduction.pdf
# No significant performance improvements seen implementing this in pure Cairo
# compared to the current approach with a hint

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


def barett_reduction(x):
    mu = 2**509//P
    limbs = split(x, 128, 4)
    T_mu = mu//2**254
    R = x - (x//2**254)*T_mu*P
    return R


L = (P-93849028375890238420398403284234)*(P-P//5)
R = intel(L)
B = barett_reduction(L)



