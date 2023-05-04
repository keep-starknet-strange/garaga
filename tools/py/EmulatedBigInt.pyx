from libc.stdint cimport int64_t, uint8_t
from libc.stdlib cimport calloc, realloc, free
cimport cython 
from cython.parallel import prange, parallel
from openmp cimport omp_get_thread_num, omp_lock_t, omp_init_lock, omp_destroy_lock, omp_set_lock, omp_unset_lock
import numpy as np
cimport numpy as np
ctypedef int64_t INT64
from libc.stdio cimport printf

from cpython.list cimport PyList_New, PyList_Append

ctypedef INT64* BigIntPtr
ctypedef INT64* Int64Ptr

cdef struct BigIntPair:
    BigIntPtr x
    BigIntPtr y

cdef struct ResultTuple:
    INT64 x
    INT64 y
ctypedef ResultTuple* ResultTuplePtr
ctypedef BigIntPair* BigIntPairPtr


cdef class EmulatedBigInt:
    cdef:
        public uint8_t n_limbs
        public uint8_t unreduced_n_limbs
        public uint8_t n_cores
        public INT64 base
        public INT64 base_inverse
        public INT64 native_prime
        public INT64 emulated_prime
        BigIntPtr limbs
        BigIntPtr emulated_prime_limbs
        BigIntPtr emulated_prime_max_limbs
        Int64Ptr n_terms_unreduced_n_limbs


    def __cinit__(self, uint8_t n_limbs, uint8_t n_cores, INT64 base, INT64 native_prime, INT64 emulated_prime, INT64 value=0):
        self.n_limbs = n_limbs
        self.n_cores = n_cores
        self.unreduced_n_limbs = (n_limbs-1)*2 + 1
        self.base = base
        self.base_inverse = modular_inverse(base, native_prime)
        self.native_prime = native_prime
        self.emulated_prime = emulated_prime
        self.limbs = split_int64(value, base, n_limbs)
        self.emulated_prime_limbs = split_int64(emulated_prime, base, n_limbs)
        self.n_terms_unreduced_n_limbs = polynomial_multiplication_terms(n_limbs)
        self.emulated_prime_max_limbs = split_int64(emulated_prime-1, base, n_limbs)


    def __dealloc__(self):
        if self.limbs != NULL:
            free(self.limbs)
    cdef void __unreduced_add(self, EmulatedBigInt other) nogil:
        cdef uint8_t i
        for i in range(self.n_limbs):
            self.limbs[i] = self.limbs[i] + other.limbs[i]
    cdef void __unreduced_sub(self, EmulatedBigInt other) nogil:
        cdef uint8_t i
        for i in range(self.n_limbs):
            self.limbs[i] = self.limbs[i] - other.limbs[i]
    cpdef void set_value(self, INT64 value):
        cdef BigIntPtr new_limbs = split_int64(value, self.base, self.n_limbs)
        free(self.limbs)
        self.limbs = new_limbs
    cdef int assert_reduced_emulated_felt(self, BigIntPtr limbs) nogil:
        cdef uint8_t i
        cdef uint8_t last_limb_index = self.n_limbs - 1
        cdef int lower_order_smaller_index = -1

        # Check limbs in reverse order (from higher to lower powers of base)
        # This ensures that if any higher-order limb is greater than the
        # corresponding limb in the emulated prime, the function returns 1,
        # indicating the input limbs represent a number greater than the emulated prime.
        for i in range(last_limb_index, 0, -1):
            if limbs[i] > self.emulated_prime_max_limbs[i]:
                return 1
            # If a limb is smaller than the corresponding limb in the emulated prime,
            # store the index and break the loop. This is because we know that the
            # input limbs represent a number less than the emulated prime beyond this point.
            if limbs[i] < self.emulated_prime_max_limbs[i]:
                lower_order_smaller_index = i
                break

        # Check the least significant limb
        # If the least significant limb is greater than the corresponding limb in the
        # emulated prime and we haven't found a smaller limb before, return 1 as the
        # input limbs represent a number greater than the emulated prime.
        if lower_order_smaller_index == -1 and limbs[0] > self.emulated_prime_max_limbs[0]:
            return 1

        # If we have found a smaller limb at index lower_order_smaller_index,
        # we know that the input limbs represent a number less than the emulated prime
        # up to this point. Now, we need to check all limbs from lower_order_smaller_index
        # to 0 against self.base to ensure that each limb is strictly less than the base.
        if lower_order_smaller_index != -1:
            for i in range(lower_order_smaller_index+1):
                # If any limb is greater than or equal to self.base, return 1
                # as the input limbs do not represent a reduced emulated field element.
                if limbs[i] >= self.base:
                    return 1

        # If all checks passed, the input limbs represent a reduced emulated field element,
        # and the function returns 0.
        return 0
    @cython.cdivision(True)
    cdef int __mul_inner(self, BigIntPtr self_limbs, BigIntPtr other_limbs, BigIntPtr hint_q, BigIntPtr hint_r) nogil:
        cdef uint8_t i
        cdef int result, q_is_felt, r_is_felt
        cdef BigIntPtr val = __unreduced_mul_sub_c(self_limbs, other_limbs, hint_r, self.native_prime, self.n_limbs)
        cdef BigIntPtr q_P = __unreduced_mul(hint_q, self.emulated_prime_limbs, self.native_prime, self.n_limbs)
        cdef Int64Ptr carries = <INT64*>calloc(self.unreduced_n_limbs, sizeof(INT64))
        cdef Int64Ptr lefts = <INT64*>calloc(self.unreduced_n_limbs, sizeof(INT64))
        cdef Int64Ptr rights = <INT64*>calloc(self.unreduced_n_limbs, sizeof(INT64))
        for i in range(self.unreduced_n_limbs):
            if i == 0:
                carries[i] = mod((q_P[i] - val[i]) * self.base_inverse, self.native_prime)
            else:
                carries[i] = mod((q_P[i] - val[i] + carries[i-1]) * self.base_inverse, self.native_prime)

        free(val)
        free(q_P)
        q_is_felt = self.assert_reduced_emulated_felt(hint_q)
        r_is_felt = self.assert_reduced_emulated_felt(hint_r)
        if q_is_felt != 0 or r_is_felt != 0:
            free(carries)
            free(lefts)
            free(rights)
            return 1

        if carries[self.unreduced_n_limbs-1] == 0:
            result = 0
            for i in range(0, self.unreduced_n_limbs-1):
                lefts[i] = mod(carries[i] + self.n_terms_unreduced_n_limbs[i]*self.base, self.native_prime)
                rights[i] = (1+self.n_terms_unreduced_n_limbs[i])*self.base + self.emulated_prime_max_limbs[i]
                if lefts[i] >= rights[i]:
                    # with gil:
                    #     print(f"{evaluate(self_limbs, self.n_limbs, self.base)} * {evaluate(other_limbs, self.n_limbs, self.base)} = {[carries[i] for i in range(self.unreduced_n_limbs)]} fail_index={i}")
                    #     print(f"left={left} right={right}")
                    result = 1
                    
        else:
            result = 1
        if result==0:
            printf("%lld * %lld = ", evaluate(self_limbs, self.n_limbs, self.base), evaluate(other_limbs, self.n_limbs, self.base));
            printf("[");
            for i in range(self.unreduced_n_limbs):
                printf("%lld", carries[i]);
                if i < self.unreduced_n_limbs - 1:
                    printf(", ");
            printf("]\n");
            printf("lefts=[");
            for i in range(self.unreduced_n_limbs):
                printf("%lld", lefts[i]);
                if i < self.unreduced_n_limbs - 1:
                    printf(", ");
            printf("] ");
            printf("rights=[");
            for i in range(self.unreduced_n_limbs):
                printf("%lld", rights[i]);
                if i < self.unreduced_n_limbs - 1:
                    printf(", ");
            printf("]\n");
            printf("q=%lld r=%lld\n\n", evaluate(hint_q, self.n_limbs, self.base), evaluate(hint_r, self.n_limbs, self.base));
            
            # with gil:
            #     print(f"{evaluate(self_limbs, self.n_limbs, self.base)} * {evaluate(other_limbs, self.n_limbs, self.base)} = {[carries[i] for i in range(self.unreduced_n_limbs)]}")
            #     print(f"lefts={[lefts[i] for i in range(self.unreduced_n_limbs)]} rights={[rights[i] for i in range(self.unreduced_n_limbs)]}")
            #     print(f"q={evaluate(hint_q, self.n_limbs, self.base)} r={evaluate(hint_r, self.n_limbs, self.base)}")
        free(carries)
        free(lefts)
        free(rights)
        return result

    @cython.cdivision(True)
    cpdef int mul_honest(self, EmulatedBigInt other):
        # %{
        cdef INT64 a = evaluate(self.limbs, self.n_limbs, self.base)
        cdef INT64 b = evaluate(other.limbs, other.n_limbs, other.base)
        cdef BigIntPtr true_q = split_int64(a * b // self.emulated_prime, self.base, self.n_limbs)
        cdef BigIntPtr true_r = split_int64(a * b % self.emulated_prime, self.base, self.n_limbs)
        # %}
        cdef int result
        with nogil:
            result = self.__mul_inner(self.limbs, other.limbs, true_q, true_r)
        return result

    @cython.cdivision(True)
    cdef int mul_malicious(self, EmulatedBigInt other, BigIntPtr malicious_q, BigIntPtr malicious_r) nogil:
        if self.__mul_inner(self.limbs, other.limbs, malicious_q, malicious_r) == 0:
            return 1
        else:
            return 0
    cpdef hack_mul(self, EmulatedBigInt other):
        cdef int result
        cdef INT64 q,r
        cdef BigIntPtr malicious_q, malicious_r
        cdef list py_results = PyList_New(0)

        for q in range(self.emulated_prime):
            for r in range(self.emulated_prime):
                malicious_q = split_int64(q, self.base, self.n_limbs)
                malicious_r = split_int64(r, self.base, self.n_limbs)
                result = self.mul_malicious(other, malicious_q, malicious_r)
                if result == 1:
                    PyList_Append(py_results, (q, r))
                free(malicious_q)
                free(malicious_r)

        return py_results

    cpdef test_full_field_mul_honest(self):
        cdef INT64 i, j
        cdef int result
        cdef INT64 cardinal_emulated_field_pow_2 = 1
        for i in range(2):
            cardinal_emulated_field_pow_2 *= self.emulated_prime
        cdef BigIntPtr a_limbs, b_limbs, true_q_limbs, true_r_limbs
        cdef list py_results = PyList_New(0)
        for i in range(self.emulated_prime):
            for j in range(self.emulated_prime):
                a_limbs = split_int64(i, self.base, self.n_limbs)
                b_limbs = split_int64(j, self.base, self.n_limbs)

                true_q_limbs = split_int64((i * j) // self.emulated_prime, self.base, self.n_limbs)
                true_r_limbs = split_int64((i * j) % self.emulated_prime, self.base, self.n_limbs)
                result = self.__mul_inner(a_limbs, b_limbs, true_q_limbs, true_r_limbs)
                if result == 1:
                    PyList_Append(py_results, (i, j))
                free(a_limbs)
                free(b_limbs)
                free(true_q_limbs)
                free(true_r_limbs)
        return py_results

    cpdef int test_assert_reduced_felt(self):
        if self.n_limbs!=3:
            print("This test is only valid for 3 limbs")
            return 1
        cdef INT64 x,y,z, i, val
        cdef int coefficients_reduced = 0
        cdef BigIntPtr limbs= <INT64*>calloc(self.n_limbs, sizeof(INT64))
        for x in range(self.native_prime):
            for y in range(self.native_prime):
                for z in range(self.native_prime):
                    coefficients_reduced=0
                    limbs[0] = x
                    limbs[1] = y
                    limbs[2] = z
                    result = self.assert_reduced_emulated_felt(limbs)
                    val = evaluate(limbs, self.n_limbs, self.base)
                    for i in range(self.n_limbs):
                        if limbs[i] >= self.base:
                            coefficients_reduced=1
                            break
                    if val >= self.emulated_prime:
                        if result == 0:
                            print("Higher than P but passes as reduced")
                            print([limbs[i] for i in range(self.n_limbs)])
                            print([self.emulated_prime_max_limbs[i] for i in range(self.n_limbs)])
                            return 1
                    if val < self.emulated_prime and coefficients_reduced==0:
                        if result == 1:
                            print("reduced limbs and smaller than P but passes as not reduced")
                            print([limbs[i] for i in range(self.n_limbs)])
                            print([self.emulated_prime_max_limbs[i] for i in range(self.n_limbs)])
                            return 1
                    if val<self.emulated_prime and coefficients_reduced==1:
                        if result==0:
                            print(f"Val {val} < {self.emulated_prime} but one limb at least is higher than base and passes as reduced")
                            print([limbs[i] for i in range(self.n_limbs)])
                            print([self.emulated_prime_max_limbs[i] for i in range(self.n_limbs)])
                            return 1
        return 0

    def __str__(self):
        cdef INT64 eval_value = evaluate(self.limbs, self.n_limbs, self.base)
        cdef str repr = f"<EmulatedBigInt(base={self.base}, value={eval_value}, prime={self.native_prime}, emulated_prime={self.emulated_prime}, limbs=("
        for i in range(self.n_limbs):
            if i < self.n_limbs - 1:
                repr += f"{self.limbs[i]}, "
            else:
                repr += f"{self.limbs[i]}"
        repr += "))>"
        return repr
    def __repr__(self):
        cdef INT64 eval_value = evaluate(self.limbs, self.n_limbs, self.base)
        cdef str repr = f"<EmulatedBigInt(base={self.base}, value={eval_value}, prime={self.native_prime}, emulated_prime={self.emulated_prime}, limbs=("
        for i in range(self.n_limbs):
            if i < self.n_limbs - 1:
                repr += f"{self.limbs[i]}, "
            else:
                repr += f"{self.limbs[i]}"
        repr += "))>"
        return repr


@cython.cdivision(True)
cdef BigIntPtr split_int64(INT64 value, INT64 base, INT64 n_limbs) nogil:
    cdef BigIntPtr limbs= <INT64*>calloc(n_limbs, sizeof(INT64))
    cdef INT64 r = value
    cdef uint8_t i
    for i in range(n_limbs-1, 0, -1):
        limbs[i] = r // (base ** i)
        r = r % (base ** i)
    limbs[0] = r
    return limbs

@cython.cdivision(True)
cpdef list py_split_int64(INT64 value, INT64 base, INT64 n_limbs):
    cdef BigIntPtr limbs= split_int64(value, base, n_limbs)
    cdef list py_limbs = PyList_New(0)
    cdef uint8_t i
    for i in range(n_limbs):
        PyList_Append(py_limbs, limbs[i])
    free(limbs)
    return py_limbs

@cython.cdivision(True)
cdef INT64 modular_inverse(INT64 a, INT64 p):
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

cdef INT64 evaluate(BigIntPtr limbs, uint8_t n_limbs, INT64 base) nogil:
    cdef INT64 result = 0
    cdef INT64 power_of_base = 1
    for i in range(n_limbs):
        result += limbs[i] * power_of_base
        power_of_base *= base
    return result

cdef INT64 mod(INT64 a, INT64 p) nogil:
    cdef INT64 r = a % p
    return r if r >= 0 else r + p


cdef BigIntPtr __unreduced_mul(BigIntPtr a, BigIntPtr b, INT64 p, uint8_t n_limbs) nogil:
    cdef uint8_t new_n_limbs= (n_limbs-1)*2 + 1
    cdef BigIntPtr new_limbs = <INT64*>calloc(new_n_limbs, sizeof(INT64))
    cdef uint8_t i, j
    for i in range(n_limbs):
        for j in range(n_limbs):
            new_limbs[i+j] += a[i] * b[j]
    for i in range(new_n_limbs):
        new_limbs[i] = mod(new_limbs[i], p)
    return new_limbs

cdef BigIntPtr __unreduced_mul_sub_c(BigIntPtr a, BigIntPtr b, BigIntPtr c, INT64 p, uint8_t n_limbs) nogil:
    cdef uint8_t new_n_limbs= (n_limbs-1)*2 + 1
    cdef BigIntPtr new_limbs = <INT64*>calloc(new_n_limbs, sizeof(INT64))
    cdef uint8_t i, j
    for i in range(n_limbs):
        for j in range(n_limbs):
            new_limbs[i+j] += a[i] * b[j]
    for i in range(n_limbs):
        new_limbs[i] -= c[i]
    for i in range(new_n_limbs):
        new_limbs[i] = mod(new_limbs[i], p)

    return new_limbs

cdef Int64Ptr polynomial_multiplication_terms(uint8_t n_limbs) nogil:
    cdef int i
    cdef Int64Ptr result = <Int64Ptr>calloc(2 * n_limbs - 1, sizeof(INT64))
    for i in range(2 * n_limbs - 1):
        if i < n_limbs:
            result[i] = i + 1
        else:
            result[i] = 2 * n_limbs - i - 1

    return result
