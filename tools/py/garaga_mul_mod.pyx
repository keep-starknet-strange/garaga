from libc.stdio cimport printf
import cython
cimport cython 
from cython.parallel import prange
from libc.stdint cimport uint64_t

ctypedef uint64_t UINT64

ctypedef UINT64 POLY3[3]
ctypedef UINT64 POLY5[5]

cdef UINT64 PRIME = 17 # 5 Bit prime
cdef UINT64 PRIME2 = 37 # 6 Bit prime
cdef UINT64 BASE = 2**2 # PRIME2 fits with a0 + a1 * BASE + a2 * BASE**2

@cython.boundscheck(False)
@cython.wraparound(False)
@cython.cdivision(True)
cpdef UINT64 modular_inverse(UINT64 a, UINT64 p):
    cdef int x, y
    if extended_gcd(a, p, &x, &y) != 1:
        raise ValueError("Modular inverse does not exist")
    else:
        return (x % p + p) % p

cdef int extended_gcd(int a, int b, int* x, int* y):
    if a == 0:
        x[0] = 0
        y[0] = 1
        return b

    cdef int x1, y1, gcd
    gcd = extended_gcd(b % a, a, &x1, &y1)

    x[0] = y1 - (b // a) * x1
    y[0] = x1

    return gcd

cdef UINT64 BASE_INV = modular_inverse(BASE, PRIME)

@cython.cdivision(True)
cdef void to_poly3(UINT64 x, UINT64 BASE, POLY3 *res) nogil:
    cdef UINT64 q2, q1, q0, r

    q2 = x // BASE**2
    r = x % BASE**2
    q1 = r // BASE**1
    r = r % BASE
    q0 = r

    res[0][0] = q0
    res[0][1] = q1
    res[0][2] = q2

cdef POLY3 EMULATED_PRIME
to_poly3(PRIME2, BASE, &EMULATED_PRIME)


cdef void mul_ab(POLY3 *a, POLY3 *b, POLY5 *res) nogil:
    res[0][0] = a[0][0] * b[0][0] % PRIME
    res[0][1] = (a[0][0] * b[0][1] + a[0][1] * b[0][0]) % PRIME
    res[0][2] = (a[0][0] * b[0][2] + a[0][1] * b[0][1] + a[0][2] * b[0][0]) % PRIME
    res[0][3] = (a[0][1] * b[0][2] + a[0][2] * b[0][1]) % PRIME
    res[0][4] = a[0][2] * b[0][2] % PRIME


cdef void mul_ab_sub_c(POLY3 *a, POLY3 *b, POLY3 *c, POLY5 *res) nogil:
    mul_ab(a, b, res)
    res[0][0] = (res[0][0] - c[0][0]) % PRIME
    res[0][1] = (res[0][1] - c[0][1]) % PRIME
    res[0][2] = (res[0][2] - c[0][2]) % PRIME


cdef int hack_mul(POLY3 *a, POLY3 *b, POLY3 *wrong_q, POLY3 *wrong_r) nogil:
    cdef POLY5 val
    cdef POLY5 q_P
    
    mul_ab_sub_c(a, b, wrong_r, &val)
    mul_ab(wrong_q, &EMULATED_PRIME, &q_P)

    cdef UINT64 carry1 = ((q_P[0] - val[0]) % PRIME) * BASE_INV % PRIME
    cdef UINT64 carry2 = ((q_P[1] - val[1] + carry1) % PRIME) * BASE_INV % PRIME
    cdef UINT64 carry3 = ((q_P[2] - val[2] + carry2) % PRIME) * BASE_INV % PRIME
    cdef UINT64 carry4 = ((q_P[3] - val[3] + carry3) % PRIME) * BASE_INV % PRIME

    assert (q_P[4] - val[4] + carry4) % PRIME != 0
    return 0


    

cpdef test_hack_mul(int n_cores):
    cdef POLY3 a, b
    cdef POLY3 wrong_q, wrong_r
    cdef UINT64 x, y, wrong_q_d0, wrong_q_d1, wrong_q_d2, wrong_r_d0, wrong_r_d1, wrong_r_d2
    with nogil:
        for x in prange(PRIME2, schedule='dynamic', num_threads=n_cores):
            for y in range(PRIME2):
                for wrong_q_d0 in range(PRIME):
                    for wrong_q_d1 in range(PRIME):
                        for wrong_q_d2 in range(PRIME):
                            for wrong_r_d0 in range(PRIME):
                                for wrong_r_d1 in range(PRIME):
                                    for wrong_r_d2 in range(PRIME):
                                        wrong_q[0] = wrong_q_d0
                                        wrong_q[1] = wrong_q_d1
                                        wrong_q[2] = wrong_q_d2
                                        wrong_r[0] = wrong_r_d0
                                        wrong_r[1] = wrong_r_d1
                                        wrong_r[2] = wrong_r_d2

                                        to_poly3(x, BASE, &a)
                                        to_poly3(y, BASE, &b)
                                        hack_mul(&a, &b, &wrong_q, &wrong_r)

        




