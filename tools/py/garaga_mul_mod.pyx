from libc.stdio cimport printf
import cython
cimport cython 
from cython.parallel import prange
from libc.stdint cimport int64_t
from libc.stdlib cimport rand

ctypedef int64_t INT64

ctypedef INT64 BigInt3[3]
ctypedef INT64 UnreducedBigInt5[5]

prime = 17
prime2 = 37

cdef INT64 PRIME = prime # 5 Bit prime
cdef INT64 PRIME2 = prime2 # 6 Bit prime
cdef INT64 BASE = 2**2 # PRIME2 fits with a0 + a1 * BASE + a2 * BASE**2

@cython.boundscheck(False)
@cython.wraparound(False)
@cython.cdivision(True)
cpdef INT64 modular_inverse(INT64 a, INT64 p):
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

cdef INT64 BASE_INV = modular_inverse(BASE, PRIME)

@cython.cdivision(True)
cdef void to_BigInt3(INT64 x, INT64 BASE, BigInt3 *res) nogil:
    cdef INT64 q2, q1, q0, r

    q2 = x // BASE**2
    r = x % BASE**2
    q1 = r // BASE**1
    r = r % BASE
    q0 = r

    res[0][0] = q0
    res[0][1] = q1
    res[0][2] = q2

cdef BigInt3 EMULATED_PRIME
to_BigInt3(PRIME2, BASE, &EMULATED_PRIME)

cdef INT64 eval_poly3(BigInt3 *poly) nogil:
    cdef INT64 val = poly[0][0] + poly[0][1] * BASE + poly[0][2] * (BASE ** 2)
    return val

cdef INT64 eval_poly5(UnreducedBigInt5 *poly) nogil:
    cdef INT64 val = poly[0][0] + poly[0][1] * BASE + poly[0][2] * (BASE ** 2) + poly[0][3] * (BASE ** 3) + poly[0][4] * (BASE ** 4)
    return val


cdef void mul_ab(BigInt3 *a, BigInt3 *b, UnreducedBigInt5 *res) nogil:
    res[0][0] = a[0][0] * b[0][0] % PRIME
    res[0][1] = (a[0][0] * b[0][1] + a[0][1] * b[0][0]) % PRIME
    res[0][2] = (a[0][0] * b[0][2] + a[0][1] * b[0][1] + a[0][2] * b[0][0]) % PRIME
    res[0][3] = (a[0][1] * b[0][2] + a[0][2] * b[0][1]) % PRIME
    res[0][4] = a[0][2] * b[0][2] % PRIME


cdef void mul_ab_sub_c(BigInt3 *a, BigInt3 *b, BigInt3 *c, UnreducedBigInt5 *res) nogil:
    mul_ab(a, b, res)
    res[0][0] = (res[0][0] - c[0][0]) 
    res[0][1] = (res[0][1] - c[0][1]) 
    res[0][2] = (res[0][2] - c[0][2])


cdef int hack_mul(BigInt3 *a, BigInt3 *b, BigInt3 *wrong_q, BigInt3 *wrong_r) nogil except -1:
    cdef UnreducedBigInt5 val
    cdef UnreducedBigInt5 q_P
    
    mul_ab_sub_c(a, b, wrong_r, &val)
    mul_ab(wrong_q, &EMULATED_PRIME, &q_P)

    cdef INT64 carry1 = ((q_P[0] - val[0]) % PRIME) * BASE_INV % PRIME
    cdef INT64 carry2 = ((q_P[1] - val[1] + carry1) % PRIME) * BASE_INV % PRIME
    cdef INT64 carry3 = ((q_P[2] - val[2] + carry2) % PRIME) * BASE_INV % PRIME
    cdef INT64 carry4 = ((q_P[3] - val[3] + carry3) % PRIME) * BASE_INV % PRIME

    # Checking if the verification condition all passes : 
    if (q_P[4] - val[4] + carry4) % PRIME == 0:
        # if carry1 < PRIME//2:
        #     if carry2 < PRIME    
        with gil:
            message = f"Found hack with wrong q: {wrong_q[0][0] + wrong_q[0][1] * BASE + wrong_q[0][2] * BASE**2}, wrong r: {wrong_r[0][0] + wrong_r[0][1] * BASE + wrong_r[0][2] * BASE**2}"
            message+= f"\nwrong q : {wrong_q[0][0]} + {wrong_q[0][1]} * {BASE} + {wrong_q[0][2]} * {BASE**2}"
            message+= f"\nwrong r : {wrong_r[0][0]} + {wrong_r[0][1]} * {BASE} + {wrong_r[0][2]} * {BASE**2}"
            message+= f"\n carries : 1: {carry1}, 2: {carry2}, 3: {carry3}, 4: {carry4}"
            raise Exception(message)
    return 0

cdef int mul(BigInt3 *a, BigInt3 *b, BigInt3 *true_q, BigInt3 *true_r) nogil except -1:
    cdef UnreducedBigInt5 val
    cdef UnreducedBigInt5 q_P
    
    mul_ab_sub_c(a, b, true_r, &val)
    mul_ab(true_q, &EMULATED_PRIME, &q_P)

    cdef INT64 carry1 = ((q_P[0] - val[0]) % PRIME) * BASE_INV % PRIME
    cdef INT64 carry2 = ((q_P[1] - val[1] + carry1) % PRIME) * BASE_INV % PRIME
    cdef INT64 carry3 = ((q_P[2] - val[2] + carry2) % PRIME) * BASE_INV % PRIME
    cdef INT64 carry4 = ((q_P[3] - val[3] + carry3) % PRIME) * BASE_INV % PRIME

    # Checking if the verification does not pass
    if (q_P[4] - val[4] + carry4) % PRIME != 0:
        with gil:
            message = f"Mul failed"
            raise Exception(message)
    else:
        with gil:
            print("Mul passed")
    return 0

    
cpdef test_mul_ab():
    cdef INT64 x, y
    cdef BigInt3 a, b
    cdef UnreducedBigInt5 res

    # Generate two random integers between 1 and PRIME2
    x = rand() % (PRIME2 - 1) + 1
    y = rand() % (PRIME2 - 1) + 1

    # Split the integers into BigInt3 using to_BigInt3
    to_BigInt3(x, BASE, &a)
    to_BigInt3(y, BASE, &b)

    # Multiply the BigInt3 values using mul_ab
    mul_ab(&a, &b, &res)

    # Evaluate the resulting UnreducedBigInt5 back into an integer
    cdef INT64 eval_res = eval_poly5(&res)

    # Assert that the evaluated integer is equal to the product of the original random integers
    assert eval_res == x * y, f"Error: {eval_res} != {x * y}"
    print(f"Mul test passed with x: {x}, y: {y}, res: {eval_res}")

cpdef test_mul_ab_sub_c():
    cdef INT64 x, y
    cdef BigInt3 a, b, c
    cdef UnreducedBigInt5 res

    # Generate two random integers between 1 and PRIME2
    x = rand() % (PRIME2 - 1) + 1
    y = rand() % (PRIME2 - 1) + 1

    # Split the integers into BigInt3 using to_BigInt3
    to_BigInt3(x, BASE, &a)
    to_BigInt3(y, BASE, &b)

    # Create a random BigInt3 c by generating its three limbs randomly between 0 and P - 1
    c[0] = rand() % PRIME
    c[1] = rand() % PRIME
    c[2] = rand() % PRIME

    # Multiply the BigInt3 values a and b and subtract c using mul_ab_sub_c
    mul_ab_sub_c(&a, &b, &c, &res)
    # Evaluate the resulting UnreducedBigInt5 back into an integer
    cdef INT64 eval_res = eval_poly5(&res)

    # Calculate the expected result as (a * b) - c

    cdef INT64 c_val = eval_poly3(&c)
    cdef INT64 expected_res = (x * y - c_val) 


    # Assert that the evaluated integer is equal to the expected result
    assert eval_res == expected_res, f"Error with x: {x}, y: {y}, c: {c_val}, res: {eval_res}, expected: {expected_res}"
    print(f"Mul ab sub c test passed with x: {x}, y: {y}, c: {c_val}, res: {eval_res}")


cpdef test_hack_mul(int n_cores):
    cdef BigInt3 a, b
    cdef BigInt3 wrong_q, wrong_r
    cdef BigInt3 true_q_poly, true_r_poly
    cdef INT64 x, y, wrong_q_d0, wrong_q_d1, wrong_q_d2, wrong_r_d0, wrong_r_d1, wrong_r_d2, true_q, true_r

    x = rand() % (PRIME2 - 1) + 1
    y = rand() % (PRIME2 - 1) + 1
    true_q = (x * y) // PRIME2
    true_r = (x * y) % PRIME2

    to_BigInt3(x, BASE, &a)
    to_BigInt3(y, BASE, &b)
    to_BigInt3(true_q, BASE, &true_q_poly)
    to_BigInt3(true_r, BASE, &true_r_poly)

    print(f"x: {x}, y: {y}, true_q: {true_q_poly} = {true_q}, true_r: {true_r_poly} = {true_r}")

    mul(&a, &b, &true_q_poly, &true_r_poly)

    print(f"Start bruteforce")
    with nogil:
        for wrong_q_d0 in prange(PRIME, schedule='dynamic', num_threads=n_cores):
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

                                hack_mul(&a, &b, &wrong_q, &wrong_r)

