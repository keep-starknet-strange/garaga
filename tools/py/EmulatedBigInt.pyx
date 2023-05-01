from libc.stdint cimport int64_t, uint8_t
from libc.stdlib cimport malloc, free
cimport cython 
ctypedef int64_t INT64

ctypedef INT64* BigIntPtr
ctypedef INT64* Int64Ptr

# cdef struct BigIntPair:
#     BigIntPtr x
#     BigIntPtr y

# ctypedef BigIntPair* BigIntPairPtr


cdef class EmulatedBigInt:
    cdef:
        uint8_t n_limbs
        uint8_t unreduced_n_limbs
        INT64 base
        INT64 base_inverse
        INT64 native_prime
        INT64 emulated_prime
        BigIntPtr limbs
        BigIntPtr emulated_prime_limbs

    def __cinit__(self, uint8_t n_limbs, INT64 base, INT64 native_prime, INT64 emulated_prime, INT64 value=0):
        self.n_limbs = n_limbs
        self.unreduced_n_limbs = (n_limbs-1)*2 + 1
        self.base = base
        self.base_inverse = modular_inverse(base, native_prime)
        self.native_prime = native_prime
        self.emulated_prime = emulated_prime
        self.limbs = split_int64(value, base, n_limbs)
        self.emulated_prime_limbs = split_int64(emulated_prime, base, n_limbs)

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

    @cython.cdivision(True)
    cdef int __mul_inner(self, EmulatedBigInt other, BigIntPtr hint_q, BigIntPtr hint_r) nogil:
        cdef uint8_t i

        cdef BigIntPtr val = __unreduced_mul_sub_c(self.limbs, other.limbs, hint_r, self.n_limbs)
        cdef BigIntPtr q_P = __unreduced_mul(self.emulated_prime_limbs, hint_q, self.n_limbs)
        cdef Int64Ptr carries = <INT64*>malloc((self.unreduced_n_limbs) * sizeof(INT64))
        carries[0] = 0 # First value is not used. 

        for i in range(1, self.unreduced_n_limbs):
            carries[i] = ((q_P[i] - val[i] + carries[i-1]) % self.native_prime) * self.base_inverse % self.native_prime
        free(val)
        free(q_P)
        if carries[self.unreduced_n_limbs-1] == 0:
            for i in range(1, self.unreduced_n_limbs-1):
                if carries[i] < self.base:
                    continue
                else:
                    return 1
            return 0
        else:
            return 1

    @cython.cdivision(True)
    cdef int mul_honest(self, EmulatedBigInt other) nogil:
        # %{
        cdef INT64 a = evaluate(self.limbs, self.n_limbs, self.base)
        cdef INT64 b = evaluate(other.limbs, other.n_limbs, other.base)
        cdef BigIntPtr true_q = split_int64(a * b // self.emulated_prime, self.base, self.n_limbs)
        cdef BigIntPtr true_r = split_int64(a * b % self.emulated_prime, self.base, self.n_limbs)
        # %}

        return self.__mul_inner(other, true_q, true_r)

    @cython.cdivision(True)
    cdef int mul_malicious(self, EmulatedBigInt other, BigIntPtr malicious_q, BigIntPtr malicious_r) nogil:
        if self.__mul_inner(other, malicious_q, malicious_r) == 0:
            return 1
        else:
            return 0
    cdef int hack_mul(self, EmulatedBigInt other):

        return 0



    def __str__(self):
        cdef INT64 eval_value = self.evaluate()
        cdef str repr = f"<EmulatedBigInt(base={self.base}, value={eval_value}, limbs=("
        for i in range(self.n_limbs):
            if i < self.n_limbs - 1:
                repr += f"{self.limbs[i]}, "
            else:
                repr += f"{self.limbs[i]}"
        repr += "))>"
        return repr


@cython.cdivision(True)
cdef BigIntPtr split_int64(INT64 value, INT64 base, INT64 n_limbs) nogil:
    cdef BigIntPtr limbs= <INT64*>malloc(n_limbs * sizeof(INT64))
    cdef INT64 r = value
    cdef uint8_t i
    for i in range(n_limbs-1, 0, -1):
        limbs[i] = r // (base ** i)
        r = r % (base ** i)
    limbs[0] = r
    return limbs

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



cdef BigIntPtr __unreduced_mul(BigIntPtr a, BigIntPtr b, uint8_t n_limbs) nogil:
    cdef uint8_t new_n_limbs= (n_limbs-1)*2 + 1
    cdef BigIntPtr new_limbs = <INT64*>malloc(new_n_limbs * sizeof(INT64))
    cdef uint8_t i, j
    for i in range(n_limbs):
        for j in range(n_limbs):
            new_limbs[i+j] += a[i] * b[j]
    return new_limbs

cdef BigIntPtr __unreduced_mul_sub_c(BigIntPtr a, BigIntPtr b, BigIntPtr c, uint8_t n_limbs) nogil:
    cdef uint8_t new_n_limbs= (n_limbs-1)*2 + 1
    cdef BigIntPtr new_limbs = <INT64*>malloc(new_n_limbs * sizeof(INT64))
    cdef uint8_t i, j
    for i in range(n_limbs):
        for j in range(n_limbs):
            new_limbs[i+j] += a[i] * b[j]
    for i in range(n_limbs):
        new_limbs[i] -= c[i]

    return new_limbs