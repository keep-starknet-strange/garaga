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

# Extracts the full coefficients from a polynomial splitted in three parts
# Let C(t) = c0 + c1*t + c2*t**2 + c3*t**3 + c4*t**4
# Then its three parts are (c0, c1 + c2*t, c3 + c4*t)
# Parameters :
#   C : tuple of three parts of the evaluated polynomial
#   t : prime parameter
# Returns :
#   res : tuple of five coefficients
@cython.cdivision(True)
cdef POLY4 to_polynome_from_poly3((UINT64, UINT64, UINT64) C, UINT64 t) nogil:
    cdef UINT64 c0, c1, c2, c3, c4
    c0 = C[0]
    c1 = C[1] % t
    c2 = C[1] // t
    c3 = C[2] % t
    c4 = C[2] // t

    cdef POLY4 res = (c0, c1, c2, c3, c4)
    return res


## Irremediably Broken function
## Tries to retrieve the unique coefficients of X(t) from coefficients of X(t/t_div_prime_div))
## It is very likely that it is infeasible. 
## And since X(t/t_div_prime_div) > P(t/t_div_prime_div) => X(t) > P(t) is a proven false assertion,
## it is useless anyway. 
## The idea was to evaluated the polynomial in a smaller value so
## it fits inside one felt to check cheaply if reduction modulo P was needed. 
@cython.cdivision(True)
cdef POLY4 to_polynome_2(UINT64 x, UINT64 t, UINT64 t_div_prime_div):
    cdef UINT64 q4, q3, q2, q1, q0, r, q_prime
    q_prime = t // t_div_prime_div
    # printf("Decomposing x=%llu \n", x)
    q4 = x // q_prime**4 
    r = x % q_prime**4
    q3 = r // (q_prime)**3
    r = r % q_prime**3
    q2 = r // q_prime**2
    r = r % q_prime**2
    q1 = (r // q_prime**1)//t_div_prime_div
    if q1==0:
        # printf("q1=0 \n")
        r = r
    q0 = r
    cdef POLY4 res = (q0, q1, q2, q3, q4)
    return res

    
@cython.cdivision(True)
cpdef int add_mod_reduced_t(UINT64 a, UINT64 b, UINT64 t, UINT64 t_div_prime_div, UINT64 p_of_t_div, UINT64 p) except -1:
    cdef POLY4 A = to_polynome_c(a, t)
    # printf("\nA [%llu, %llu, %llu, %llu, %llu] \n", A[0], A[1], A[2], A[3], A[4])
    cdef POLY4 B = to_polynome_c(b, t)
    # printf("B [%llu, %llu, %llu, %llu, %llu] \n", B[0], B[1], B[2], B[3], B[4])
    cdef UINT64 c=evaluate_poly(A,t_div_prime_div)+evaluate_poly(B,t_div_prime_div)
    # printf("c =%llu \n", c)
    cdef UINT64 c_reduced = c - p_of_t_div
    cdef UINT64 true_value = (a+b)%p
    if c >= p_of_t_div:
        return verify_return_reduced_t(c_reduced, 0, t, t_div_prime_div, true_value)
    else:
        return verify_return_reduced_t(c, 1, t,t_div_prime_div, true_value)

cdef int verify_return_reduced_t(UINT64 c, int i_case, UINT64 t, UINT64 t_div_prime_div, UINT64 true_value) except -1:
    cdef POLY4 C =to_polynome_2(c, t, t_div_prime_div)
    cdef UINT64 ev =evaluate_poly(C, t)
    cdef POLY4 true_poly
    if ev!=true_value:
        true_poly = to_polynome_c(true_value, t)
        printf("WRONG %i \n", i_case)
        printf("C [%llu, %llu, %llu, %llu, %llu] \n", C[0], C[1], C[2], C[3], C[4])
        printf("C(t)=%llu \n", ev)
        printf("(a+b) mod P(t)=%llu \n", true_value)
        printf("T [%llu, %llu, %llu, %llu, %llu] \n", true_poly[0], true_poly[1], true_poly[2], true_poly[3], true_poly[4])
        return -1
    else:
        # true_poly = to_polynome_c(true_value, t)
        # printf("Correct %i \n" ,i_case)
        # printf("C [%llu, %llu, %llu, %llu, %llu] \n", C[0], C[1], C[2], C[3], C[4])
        # printf("C(t)=%llu \n", ev)
        # printf("(a+b) mod P(t)=%llu \n", true_value)
        # printf("T [%llu, %llu, %llu, %llu, %llu] \n", true_poly[0], true_poly[1], true_poly[2], true_poly[3], true_poly[4])
        return 0


# Polynomial modular addition 
# Parameters:
#   a: field element (UINT64)
#   b: field element (UINT64)
#   p: prime (UINT64)
#   t: prime parameter (UINT64)
#   P: polynomial representation of p (36*t⁴ + 36*t³ + 24*t² + 6*t + 1) (POLY4)
@cython.cdivision(True)
cdef int polyadd(UINT64 a, UINT64 b, UINT64 p, UINT64 t, POLY4 P) nogil except -1:
    # print(P)
    cdef POLY4 A = to_polynome_c(a, t)
    # printf("A [%llu, %llu, %llu, %llu, %llu] \n", A[0], A[1], A[2], A[3], A[4])

    cdef POLY4 B = to_polynome_c(b, t)
    # printf("B [%llu, %llu, %llu, %llu, %llu] \n", B[0], B[1], B[2], B[3], B[4])

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
                        return verify_return(sub_poly(C, C), C, 0, t, true_value)
                    else:
                        if C[0]>P[0]:
                            return verify_return(sub_poly(C,P),C, 1, t, true_value)
                        else:
                            return verify_return(C, C, 2, t, true_value)
                else:
                    if C[1]>P[1]:
                        return verify_return(sub_poly(C,P), C,  3, t, true_value)
                    else:
                        return verify_return(C,C, 6, t, true_value)
            else:
                if C[2]>P[2]:
                    return verify_return(sub_poly(C,P),C, 7, t, true_value)
                else:
                    return verify_return(C,C, 10, t, true_value)
        else:
            if C[3]>P[3]:
                return verify_return(sub_poly(C,P),C, 11, t, true_value)
            else:
                return verify_return(C,C, 14, t, true_value)
    else:
        if C[4]>P[4]:
            return verify_return(sub_poly(C,P), C, 15, t, true_value)
        else:
            return verify_return(C,C, 17, t, true_value)

# Checks the return of polyadd function. Raises error (-1) if incorrect. 
# Parameters:
#   R: the result of polyadd (possibly reduced) (POLY4)
#   C: unreduced result of polyadd (POLY4)
#   i_case: a integer for debugging in case of error (handled by the calling function) (int)
#   t: prime parameter (UINT64)
#   true_value: the true value of the modular addition computed with native Cython
cdef int verify_return(POLY4 R, POLY4 C, int i_case, UINT64 t, UINT64 true_value) nogil except -1:
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
        # printf("Correct %i \n" ,i_case)
        return 0

@cython.cdivision(True)
cdef int polyadd_3(UINT64 a, UINT64 b, UINT64 t, UINT64 p) nogil except -1:
    cdef POLY4 A = to_polynome_c(a, t)
    # printf("\nA [%llu, %llu, %llu, %llu, %llu] \n", A[0], A[1], A[2], A[3], A[4])
    cdef POLY4 B = to_polynome_c(b, t)
    # printf("B [%llu, %llu, %llu, %llu, %llu] \n", B[0], B[1], B[2], B[3], B[4])
    
    # decompose and add 

    cdef UINT64 c00 = A[0]+B[0]
    cdef UINT64 c12 = A[1]+A[2]*t + B[1]+B[2]*t
    cdef UINT64 c23 = A[3]+A[4]*t + B[3]+B[4]*t

    # Simulate Cairo hint 
    cdef UINT64 c = c00 + c12*t + c23*t**3
    if c>=p:
        c=c-p
        c00=c00 - 1
        c12=c12 - 6 - 24*t
        c23=c23 - 36 - 36*t
    # printf("c =%llu \n", c)
    
    cdef UINT64 true_value = (a+b)%p
    cdef (UINT64, UINT64, UINT64) C = (c00, c12, c23)

    return verify_return_3_parts_polynomial(C, c, 1, t, true_value)

# Check the return for garagadd_3 funtion. Raises error if incorrect. 
# This shouldn't be called by itself, 
# inputs are handled by the calling function. 
# Parameters:
#   R: tuple of 3 parts of the result
#   c: the result of the evaluation of the polynomial c=R[0] + t * R[1] + t**3 * R[2]
#   i_case: an integer for debugging in case of error (handled by the calling function)
#   t: the prime parameter
#   true_value: the true value of the modular addition computed with native Cython
cdef int verify_return_3_parts_polynomial((UINT64, UINT64, UINT64) R, UINT64 c, int i_case, UINT64 t, UINT64 true_value) nogil except -1:
    cdef POLY4 true_poly
    cdef POLY4 C = to_polynome_from_poly3(R, t)
    if c!=true_value:
        true_poly = to_polynome_c(true_value, t)
        printf("WRONG %i \n" ,i_case)
        printf("C [%llu, %llu, %llu, %llu, %llu] \n", C[0], C[1], C[2], C[3], C[4])
        printf("C(t)=%llu \n", c)
        printf("(a+b) mod P(t)=%llu \n", true_value)
        printf("T [%llu, %llu, %llu, %llu, %llu] \n", true_poly[0], true_poly[1], true_poly[2], true_poly[3], true_poly[4])
        return -1
    else:
        # printf("Correct %i \n" ,i_case)
        return 0

## Test functions
# Paremeters:
# n_cores: number of cores to use
# t_case: the case corresponding to a specific field to test (see load_coeff)
# subfield: if True, the field is a subfield of GF(p) (for realistic testing time), otherwise it is GF(p) (takes 120 days on a i7-12700H and t = 39)
cpdef test_full_field_polyadd(int n_cores, int t_case, int subfield=True):
    cdef UINT64 m,t,s
    cdef POLY4 P
    m, t, s, prime_divisor, P = load_coeff(t_case)
    cdef UINT64 p=evaluate_poly(P,t)

    cdef UINT64 a,b,c

    cdef UINT64 field_divisor
    if subfield:
        field_divisor=8000000
    else:
        field_divisor=1

    # Loop on all unique couples (a,b) in GF(p) or GF(p//field_divisor).
    for a in prange(p//field_divisor,nogil=True, num_threads=n_cores):
        printf("%llu %llu \n", a, p)
        # Second loop starts at m because addition is commutative. 
        # Total number of unique couples is P*(P-1)/2, so the complexity is smaller than n^2
        for b in range(a, p):
            # printf("%llu %llu %llu \n", a, b, p)
            polyadd(a, b, p, t, P)

    # Loop on all possibles c=a+b values:
    # Need to prove that to_polynome_c(a+b)=to_polynome_c(a)+to_polynome_c(b)., 
    # to make sure this fast full field testing is correct. 
    for c in prange(2*p, nogil=True, num_threads=n_cores):
        polyadd(c, 0, p, t, P)

cpdef test_full_field_add_mod_reduced_t(int t_case):
    cdef UINT64 m,t,s
    cdef POLY4 P
    m, t, s, t_div_prime_div, P = load_coeff(t_case)
    cdef UINT64 p=evaluate_poly(P,t)
    cdef UINT64 p_of_t_div = evaluate_poly(P, t_div_prime_div)
    cdef UINT64 a
    cdef UINT64 b
    for a in range(p):
        # printf("%llu %llu \n", a, p)
        # Second loop starts at a because addition is commutative. 
        # Total number of unique couples is P*(P-1)/2, so the complexity is smaller than n^2
        for b in range(a, p):
            # printf("\n %llu %llu", a, b)
            add_mod_reduced_t(a, b,t, t_div_prime_div, p_of_t_div, p)



# Shows that the euclidean decomposition in to_polynome_c is correct and 
# that coefficients are all less than t 
# Paremeter:
# t_case: field case depending on t value (see load_coeff function)
cpdef test_full_field_decomposition(int t_case):
    cdef UINT64 m,t,s, _
    cdef POLY4 P
    m, t, s, _, P = load_coeff(t_case)
    cdef UINT64 p=evaluate_poly(P,t)
    cdef POLY4 A
    cdef UINT64 max0, max1, max2, max3, max4
    max0=0
    max1=0
    max2=0
    max3=0
    max4=0
    cdef UINT64 a

    for a in range(p):
        A=to_polynome_c(a, t)
        if A[0]>max0:
            max0=A[0]
        if A[1]>max1:
            max1=A[1]
        if A[2]>max2:
            max2=A[2]
        if A[3]>max3:
            max3=A[3]
        if A[4]>max4:
            max4=A[4]
        
    printf("max0 = %llu \n", max0)
    printf("max1 = %llu \n", max1)
    printf("max2 = %llu \n", max2)
    printf("max3 = %llu \n", max3)
    printf("max4 = %llu \n", max4)
    printf("t = %llu \n", t)


# Test if C(x) > P(x) implies C(t)>P(t) with x < t
# Paremeter:
# t_case: field case depending on t value (see load_coeff function)   
# Spoiler alert: it is false except for t-1 and t-2. 
cpdef test_assertion(int t_case):
    cdef UINT64 m,t,s
    cdef POLY4 P
    m, t, s, t_div_prime_div, P = load_coeff(t_case)
    cdef UINT64 p=evaluate_poly(P,t)
    cdef POLY4 A
    cdef UINT64 ev, evt, evp
    cdef int true_x
    cdef UINT64 a
    cdef list false_x_list = []
    cdef list true_x_list=[]
    for x in range(t):
        true_x=True
        for a in range(p-3,2*p-1):
            A=to_polynome_c(a, t)
            ev=evaluate_poly(A, x)
            evt=evaluate_poly(A,t)
            evp=evaluate_poly(P,x)
            if ev > evp:
                if evt<=p:
                    true_x=False
                    break
        if true_x:
            true_x_list.append(x)
        else:
            false_x_list.append(x)
    print('False x: ', false_x_list)
    print("True x: ", true_x_list)


            


 
# Tests modular addition algorithm with the a polynomial representation splitted in 3 parts
# Let A(x) = a0 + a1*x + a2*x^2 + a3*x^3 + a4*x^4
# Then part 1 is a0
# part 2 is a1 + a2*x
# part 3 is a3 + a4*x
# Paremeter:
# t_case: field case depending on t value (see load_coeff function)
# n_cores: number of cores to use
cpdef test_polyadd_3(int t_case, int n_cores):
    cdef UINT64 m,t,s
    cdef POLY4 P
    m, t, s, t_div_prime_div, P = load_coeff(t_case)
    cdef UINT64 p=evaluate_poly(P,t)

    cdef UINT64 c
    # Loop on all possibles c=a+b values:
    # Need to prove that to_polynome_3(a+b)=to_polynome_3(a)+to_polynome_3(b).,
    # to make sure this fast full field testing is correct.
    for c in prange(2*p, nogil=True, num_threads=n_cores):
        polyadd_3(c, 0, t, p)
