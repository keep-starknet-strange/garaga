from libc.stdio cimport printf
import cython
from cython.parallel import prange
from tools.py.polynome import load_coeff



ctypedef unsigned long long UINT64

ctypedef (UINT64, UINT64, UINT64, UINT64, UINT64) POLY4



cdef POLY4 sub_poly(POLY4 a, POLY4 b) nogil:
    cdef POLY4 res = (a[0]-b[0], a[1]-b[1], a[2]-b[2], a[3]-b[3], a[4]-b[4])
    return res
cdef POLY4 add_poly(POLY4 a, POLY4 b) nogil:
    cdef POLY4 res = (a[0]+b[0], a[1]+b[1], a[2]+b[2], a[3]+b[3], a[4]+b[4])
    return res
cdef UINT64 evaluate_poly(POLY4 P, UINT64 t) nogil:
    cdef UINT64 res=P[0] + P[1]*t + P[2]*t**2 + P[3]*t**3 + P[4]*t**4
    return res

@cython.cdivision(True)
cdef POLY4 to_polynome_c(UINT64 x, UINT64 t) nogil:
    cdef UINT64 q4, q3, q2, q1, q0, r

    q4 = x // t**4 
    r = x % t**4
    q3 = r // t**3
    r = r % t**3
    q2 = r // t**2
    r = r % t**2
    q1 = r // t**1
    r = r % t
    q0 = r
    cdef POLY4 res = (q0, q1, q2, q3, q4)

    return res



cdef int debug_return(POLY4 R, POLY4 C,  int i_case, UINT64 t, UINT64 true_value) nogil except -1:
    cdef UINT64 ev=evaluate_poly(R,t)
    cdef POLY4 true_poly

    if ev!=true_value:
        true_poly = to_polynome_c(true_value, t)
        printf("WRONG %i \n" ,i_case)
        printf("C [%llu, %llu, %llu, %llu, %llu] \n", C[0], C[1], C[2], C[3], C[4])
        printf("R [%llu, %llu, %llu, %llu, %llu] \n", R[0], R[1], R[2], R[3], R[4])
        printf("R(t)=%llu \n", ev)
        printf("(a+b) mod P(t)=%llu \n", true_value)
        printf("T [%llu, %llu, %llu, %llu, %llu] \n", true_poly[0], true_poly[1], true_poly[2], true_poly[3], true_poly[4])
        return -1
    else:
        # print("Correct" ,i)
        return 0


@cython.cdivision(True)
cdef int add_mod_poly_c(UINT64 a, UINT64 b, UINT64 p, UINT64 t, POLY4 P) nogil except -1:
    # print(P)
    cdef POLY4 A = to_polynome_c(a, t)
    cdef POLY4 B = to_polynome_c(b, t)
    cdef UINT64 true_value = (a+b)%p
    cdef POLY4 C

    C=add_poly(A,B)

    # Reduce all coefficients up to degree three so they are all < t)
    if C[0]>=t:
        C=(C[0]-t , C[1]+1, C[2], C[3], C[4])
    if C[1]>=t:
        C=(C[0] , C[1]-t, C[2]+1, C[3], C[4])
    if C[2]>=t:
        C=(C[0] , C[1], C[2]-t, C[3]+1, C[4])
    if C[3]>=t:
        C=(C[0] , C[1], C[2], C[3]-t, C[4]+1)

    if C[4]==P[4]:
        if C[3]==P[3]:
            if C[2]==P[2]:
                if C[1]==P[1]:
                    if C[0]==P[0]:
                        return debug_return(sub_poly(C, C), C, 0, t, true_value)
                    else:
                        if C[0]>P[0]:
                            return debug_return(sub_poly(C,P),C, 1, t, true_value)
                        else:
                            return debug_return(C, C, 2, t, true_value)
                else:
                    if C[1]>P[1]:
                        return debug_return(sub_poly(C,P), C,  3, t, true_value)
                    else:
                        return debug_return(C,C, 6, t, true_value)
            else:
                if C[2]>P[2]:
                    return debug_return(sub_poly(C,P),C, 7, t, true_value)
                else:
                    return debug_return(C,C, 10, t, true_value)
        else:
            if C[3]>P[3]:
                return debug_return(sub_poly(C,P),C, 11, t, true_value)
            else:
                return debug_return(C,C, 14, t, true_value)
    else:
        if C[4]>P[4]:
            return debug_return(sub_poly(C,P), C, 15, t, true_value)
        else:
            return debug_return(C,C, 17, t, true_value)



cpdef test_full_field(int n_cores):
    cdef UINT64 m,t,s
    cdef POLY4 P
    m, t, s, P = load_coeff(3)
    cdef UINT64 p=evaluate_poly(P,t)

    cdef UINT64 a
    cdef UINT64 b
    for a in prange(p,nogil=True, num_threads=n_cores):
        printf("%llu %llu \n", a, p)
        # Second loop starts at m because addition is commutative. 
        # Total number of unique couples is P*(P-1)/2, so the complexity is smaller than n^2
        for b in range(a, p):
            add_mod_poly_c(a, b, p, t, P)
