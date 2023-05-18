from libc.stdint cimport int64_t, uint8_t
from libc.stdlib cimport calloc, free
cimport cython 
from libc.stdlib cimport llabs
import numpy as np
cimport numpy as np
from libc.stdio cimport printf

from cpython.list cimport PyList_New, PyList_Append

ctypedef int64_t INT64

ctypedef INT64* BigIntPtr
ctypedef INT64* Int64Ptr


cdef class EmulatedBigInt:
    cdef:
        public uint8_t n_limbs
        public uint8_t unreduced_n_limbs
        public uint8_t n_cores
        public INT64 value
        public INT64 base
        public INT64 base_inverse
        public INT64 native_prime
        public INT64 emulated_prime
        BigIntPtr limbs
        BigIntPtr emulated_prime_limbs
        BigIntPtr emulated_prime_max_limbs
        Int64Ptr n_terms_unreduced_n_limbs
        Int64Ptr base_inverses


    def __cinit__(self, uint8_t n_limbs, uint8_t n_cores, INT64 base, INT64 native_prime, INT64 emulated_prime, INT64 value=0):
        self.n_limbs = n_limbs
        self.n_cores = n_cores
        self.unreduced_n_limbs = (n_limbs-1)*2 + 1
        self.value = value
        self.base = base
        self.base_inverse = modular_inverse(base, native_prime)
        self.native_prime = native_prime
        self.emulated_prime = emulated_prime
        self.limbs = split_int64(value, base, n_limbs)
        self.emulated_prime_limbs = split_int64(emulated_prime, base, n_limbs)
        self.n_terms_unreduced_n_limbs = polynomial_multiplication_terms(n_limbs)
        self.emulated_prime_max_limbs = split_int64(emulated_prime-1, base, n_limbs)
        self.base_inverses = modular_inverse_nterms_base(self.unreduced_n_limbs, self.n_terms_unreduced_n_limbs, base, native_prime)

    def __dealloc__(self):
        if self.limbs != NULL:
            free(self.limbs)
    cpdef void set_value(self, INT64 value):
        cdef BigIntPtr new_limbs = split_int64(value, self.base, self.n_limbs)
        free(self.limbs)
        self.limbs = new_limbs
        self.value = value
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

    cdef Int64Ptr __compute_add_hint(self, BigIntPtr a_limbs, BigIntPtr b_limbs):
        cdef INT64 sum_unreduced = 0
        cdef INT64* sum_limbs = <INT64*>calloc(self.n_limbs, sizeof(INT64))
        cdef INT64* sum_reduced = <INT64*>calloc(self.n_limbs, sizeof(INT64))
        cdef INT64* has_carry = <INT64*>calloc(self.n_limbs, sizeof(INT64))
        cdef INT64* has_borrow_carry_reduced = <INT64*>calloc(self.n_limbs, sizeof(INT64))
        cdef int i, needs_reduction
        cdef Int64Ptr hint_data = <Int64Ptr>calloc(self.n_limbs, sizeof(INT64))

        for i in range(self.n_limbs):
            sum_limbs[i] = a_limbs[i] + b_limbs[i]
            sum_unreduced += sum_limbs[i] * self.base**i
            sum_reduced[i] = sum_limbs[i] - self.emulated_prime_limbs[i]
            
        has_carry[0] = 1 if sum_limbs[0] >= self.base else 0
        for i in range(1, self.n_limbs):
            if sum_limbs[i] + has_carry[i-1] >= self.base:
                has_carry[i] = 1
            else:
                has_carry[i] = 0

        needs_reduction = 1 if sum_unreduced >= self.emulated_prime else 0
        has_borrow_carry_reduced[0] = -1 if sum_reduced[0] < 0 else (1 if sum_reduced[0]>=self.base else 0)
        for i in range(1, self.n_limbs):
            if (sum_reduced[i] + has_borrow_carry_reduced[i-1]) < 0:
                has_borrow_carry_reduced[i] = -1
            elif (sum_reduced[i] + has_borrow_carry_reduced[i-1]) >= self.base:
                has_borrow_carry_reduced[i] = 1
            else:
                has_borrow_carry_reduced[i] = 0

        hint_data[0] = mod(needs_reduction, self.native_prime)
        for i in range(self.n_limbs-1):
            if needs_reduction:
                hint_data[i+1] = mod(has_borrow_carry_reduced[i], self.native_prime)
            else:
                hint_data[i+1] = mod(has_carry[i], self.native_prime)

        free(sum_limbs)
        free(sum_reduced)
        free(has_carry)
        free(has_borrow_carry_reduced)

        return hint_data

    cdef int __add_inner(self, BigIntPtr a, BigIntPtr b, BigIntPtr hint_data):
        cdef INT64 needs_reduction = hint_data[0]
        cdef BigIntPtr res = <INT64*>calloc(self.n_limbs, sizeof(INT64))
        cdef uint8_t i
        cdef int result = 0
        if needs_reduction!=0:
            for i in range(1, self.n_limbs):
                if hint_data[i] ==0 or hint_data[i] == 1 or hint_data[i] ==mod(-1, self.native_prime):
                    pass
                else:
                    result = 1
                    break
            res[0] = mod(a[0] + b[0] - hint_data[1] * self.base - self.emulated_prime_limbs[0], self.native_prime)
            for i in range(1, self.n_limbs-1):
                res[i] = mod(a[i] + b[i] + hint_data[i] - hint_data[i+1] * self.base - self.emulated_prime_limbs[i], self.native_prime)
            res[self.n_limbs-1] = mod(a[self.n_limbs-1] + b[self.n_limbs-1] + hint_data[self.n_limbs-1] - self.emulated_prime_limbs[self.n_limbs-1], self.native_prime)

        else:
            for i in range(1, self.n_limbs):
                if hint_data[i] ==0 or hint_data[i] == 1:
                    pass
                else:
                    result = 1
                    break        
            res[0] = mod(a[0] + b[0] - hint_data[1] * self.base, self.native_prime)
            for i in range(1, self.n_limbs-1):
                res[i] = mod(a[i] + b[i] + hint_data[i] - hint_data[i+1] * self.base, self.native_prime)
            res[self.n_limbs-1] = mod(a[self.n_limbs-1] + b[self.n_limbs-1] + hint_data[self.n_limbs-1], self.native_prime)
        
        is_felt = self.assert_reduced_emulated_felt(res)
        if is_felt != 0:
            result = 1

        free(res)
        return result

    cdef __get_carries(self, BigIntPtr self_limbs, BigIntPtr other_limbs, BigIntPtr hint_q, BigIntPtr hint_r):
        cdef uint8_t i
        cdef BigIntPtr val = __unreduced_mul_sub_c(self_limbs, other_limbs, hint_r, self.native_prime, self.n_limbs)
        cdef BigIntPtr q_P = __unreduced_mul(hint_q, self.emulated_prime_limbs, self.native_prime, self.n_limbs)
        cdef Int64Ptr carries = <INT64*>calloc(self.unreduced_n_limbs, sizeof(INT64))
        cdef list py_results = PyList_New(0)

        for i in range(self.unreduced_n_limbs):
            if i == 0:
                carries[i] = mod((q_P[i] - val[i]) * self.base_inverse, self.native_prime)
                PyList_Append(py_results, carries[i])
            else:
                carries[i] = mod((q_P[i] - val[i] + carries[i-1]) * self.base_inverse, self.native_prime)
                PyList_Append(py_results, carries[i])

        return py_results

    @cython.cdivision(True)
    cdef int __mul_inner_range_check(self, BigIntPtr diff, BigIntPtr hint_q, BigIntPtr hint_r, BigIntPtr hint_flags, BigIntPtr hint_carries):
        cdef uint8_t i
        cdef int  q_is_felt, r_is_felt
        cdef uint8_t carries_len = self.unreduced_n_limbs - 1
        cdef Int64Ptr computed_carries = <INT64*>calloc(carries_len, sizeof(INT64))
        cdef int result = 0

        # # Q and R a reduced emulateed elements constraints :
        # q_is_felt = self.assert_reduced_emulated_felt(hint_q)
        # r_is_felt = self.assert_reduced_emulated_felt(hint_r)
        # result = 0
        # if q_is_felt != 0 or r_is_felt != 0:
        #     printf("Q or R is not reduced\n")
        #     result= 1
        # # End of Q and R a reduced emulated elements constraints


        for i in range(carries_len):
            if i == 0:
                if hint_flags[i] !=0:
                    if diff[i] != mod(hint_carries[i] * self.base, self.native_prime):
                        result = 1
                        break
                    else:
                        computed_carries[i] = hint_carries[i]
                else:
                    if diff[i] != mod(-1 * hint_carries[i] * self.base, self.native_prime):
                        result = 1
                        break
                    else:
                        computed_carries[i] = mod(-1*hint_carries[i], self.native_prime)
            else:
                if hint_flags[i] !=0:
                    if mod(diff[i] + computed_carries[i-1], self.native_prime) != mod(hint_carries[i] * self.base, self.native_prime):
                        result = 1
                        break
                    else:
                        computed_carries[i] = hint_carries[i]
                else:
                    if mod(diff[i] + computed_carries[i-1], self.native_prime) != mod(-1 * hint_carries[i] * self.base, self.native_prime):
                        result = 1
                        break
                    else:
                        computed_carries[i] = mod(-1*hint_carries[i], self.native_prime)
        
        if result == 1:
            print(f"fail before last limb, i = {i}")

        if mod(diff[self.unreduced_n_limbs-1] + computed_carries[carries_len-1], self.native_prime) != 0:
            result = 1
                        
        return result

    @cython.cdivision(True)
    cpdef int mul_honest_range_check(self, EmulatedBigInt other):
        # %{
        cdef INT64 a = evaluate(self.limbs, self.n_limbs, self.base)
        cdef INT64 b = evaluate(other.limbs, other.n_limbs, other.base)
        cdef BigIntPtr hint_q = split_int64(a * b // self.emulated_prime, self.base, self.n_limbs)
        cdef BigIntPtr hint_r = split_int64(a * b % self.emulated_prime, self.base, self.n_limbs)
        # %}
        cdef BigIntPtr val = __unreduced_mul(self.limbs, other.limbs, self.native_prime, self.n_limbs)
        cdef BigIntPtr q_P = __unreduced_mul_plus_c(hint_q, self.emulated_prime_limbs, hint_r, self.native_prime, self.n_limbs)
        cdef BigIntPtr diff_limbs = __unreduced_sub_negative(q_P, val, self.unreduced_n_limbs)
        cdef BigIntPtr hint_carries = __reduce_zero_poly(diff_limbs, self.unreduced_n_limbs, self.base)
        cdef BigIntPtr diff = __mod_poly(diff_limbs, self.unreduced_n_limbs, self.native_prime)
        cdef BigIntPtr hint_flags = __get_flags(diff_limbs, self.unreduced_n_limbs)

        cdef int result
        result = self.__mul_inner_range_check(diff, hint_q, hint_r, hint_flags, hint_carries)
        return result

    # cpdef hack_mul_range_check(self, EmulatedBigInt other):
    #     cdef int result
    #     cdef INT64 q,r
    #     cdef BigIntPtr malicious_q, malicious_r
    #     cdef list py_results = PyList_New(0)

    #     for q in range(self.emulated_prime):
    #         for r in range(self.emulated_prime):
    #             malicious_q = split_int64(q, self.base, self.n_limbs)
    #             malicious_r = split_int64(r, self.base, self.n_limbs)
    #             result = self.__mul_inner_range_check(self.limbs, other.limbs, malicious_q, malicious_r)
    #             if result == 0:
    #                 PyList_Append(py_results, (q, r))
    #             free(malicious_q)
    #             free(malicious_r)

    #     return py_results


    cdef int __mul_inner_bitwise(self, BigIntPtr q_P, BigIntPtr val, BigIntPtr hint_flags):
        cdef uint8_t i
        cdef int result = 0
        cdef uint8_t carries_len = self.unreduced_n_limbs - 1
        cdef Int64Ptr carries = <INT64*>calloc(carries_len, sizeof(INT64))
        cdef Int64Ptr bitwise_ands = <INT64*>calloc(carries_len, sizeof(INT64))
        cdef INT64 b_min_1 = self.base - 1


        for i in range(carries_len):
            if i==0:
                if hint_flags[i] !=0:
                    bitwise_ands[i] = mod(q_P[i] - val[i], self.native_prime) & b_min_1
                    if bitwise_ands[i] != 0:
                        result = 1
                        printf("q_P[0] > val[0] but %lld & %lld != 0\n", q_P[i] - val[i], b_min_1)
                        break
                    carries[i] = mod((q_P[i] - val[i]) * self.base_inverse, self.native_prime)
                else:
                    bitwise_ands[i] = mod(val[i] - q_P[i], self.native_prime) & b_min_1
                    if bitwise_ands[i] != 0:
                        result = 1
                        printf("Val[0] > q_P[0] but %lld & %lld != 0\n", val[i] - q_P[i], b_min_1)
                        break
                    carries[i] = mod(-1 * (val[i] - q_P[i]) * self.base_inverse, self.native_prime)
                    
            else:
                if hint_flags[i] !=0:
                    bitwise_ands[i] = mod(q_P[i] - val[i] + carries[i-1], self.native_prime) & b_min_1
                    if bitwise_ands[i] != 0:
                        result = 1
                        printf("q_P[%d] > val[%d] but %lld & %lld != 0\n", i, i, q_P[i] - val[i] + carries[i-1], b_min_1)
                        break
                    carries[i] = mod((q_P[i] - val[i] + carries[i-1]) * self.base_inverse, self.native_prime)
                else:
                    bitwise_ands[i] = mod(val[i] - q_P[i] - carries[i-1], self.native_prime) & b_min_1
                    if bitwise_ands[i] != 0:
                        result = 1
                        printf("Val[%d] > q_P[%d] but %lld & %lld != 0\n", i, i, val[i] - q_P[i] - carries[i-1], b_min_1)
                        break
                    carries[i] = mod(-1 * (val[i] - q_P[i] - carries[i-1]) * self.base_inverse, self.native_prime)

        if result == 1:
            printf("Bitwise ands is not 0\n")
            print(f"val = {[val[i] for i in range(self.unreduced_n_limbs)]}")
            print(f"q_P = {[q_P[i] for i in range(self.unreduced_n_limbs)]}")

            print(f"bitwise_ands = {[bitwise_ands[i] for i in range(carries_len)]}")
            print(f"carries = {[carries[i] for i in range(carries_len)]}")
            free(carries)
            free(bitwise_ands)
            free(val)
            free(q_P)
            return result

        cdef INT64 last = mod(q_P[self.unreduced_n_limbs-1] - val[self.unreduced_n_limbs-1] + carries[carries_len-1], self.native_prime)
        if last != 0:
            printf("Last is not 0\n")
            result = 1

        return result

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

@cython.cdivision(True)
cdef INT64 mod(INT64 a, INT64 p) nogil:
    cdef INT64 r = a % p
    if r < 0:
        r += p
    return r if r < p else r - p


@cython.cdivision(True)
cdef BigIntPtr __reduce_zero_poly(BigIntPtr x, uint8_t n_limbs, INT64 base):
    cdef BigIntPtr new_limbs = <INT64*>calloc(n_limbs, sizeof(INT64))
    cdef BigIntPtr carries = <INT64*>calloc(n_limbs-1, sizeof(INT64))
    cdef uint8_t i
    
    for i in range(n_limbs):
        new_limbs[i] = x[i]
    
    for i in range(n_limbs-1):
        carries[i] = new_limbs[i] // base
        new_limbs[i] = new_limbs[i] % base
        assert new_limbs[i] == 0
        new_limbs[i+1] += carries[i]
    
    assert new_limbs[n_limbs-1] == 0
    for i in range(n_limbs-1):
        carries[i] = llabs(carries[i])
    free(new_limbs)
    return carries

cdef BigIntPtr __mod_poly(BigIntPtr x, uint8_t n_limbs, INT64 p):
    cdef BigIntPtr new_limbs = <INT64*>calloc(n_limbs, sizeof(INT64))
    cdef uint8_t i
    for i in range(n_limbs):
        new_limbs[i] = mod(x[i], p)
    return new_limbs

cdef BigIntPtr __get_flags(BigIntPtr x, uint8_t n_limbs):
    cdef BigIntPtr new_limbs = <INT64*>calloc(n_limbs, sizeof(INT64))
    cdef uint8_t i
    for i in range(n_limbs):
        if x[i] >= 0:
            new_limbs[i] = 1
        else:
            new_limbs[i] = 0
    return new_limbs

cdef BigIntPtr __unreduced_sub_negative(BigIntPtr a, BigIntPtr b, uint8_t n_limbs) nogil:
    cdef BigIntPtr new_limbs = <INT64*>calloc(n_limbs, sizeof(INT64))
    cdef uint8_t i
    for i in range(n_limbs):
        new_limbs[i] = a[i] - b[i]
    return new_limbs

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
        new_limbs[i] = mod(new_limbs[i] - c[i], p)

    for i in range(new_n_limbs):
        new_limbs[i] = mod(new_limbs[i], p)

    return new_limbs

cdef BigIntPtr __unreduced_mul_plus_c(BigIntPtr a, BigIntPtr b, BigIntPtr c, INT64 p, uint8_t n_limbs) nogil:
    cdef uint8_t new_n_limbs= (n_limbs-1)*2 + 1
    cdef BigIntPtr new_limbs = <INT64*>calloc(new_n_limbs, sizeof(INT64))
    cdef uint8_t i, j
    for i in range(n_limbs):
        for j in range(n_limbs):
            new_limbs[i+j] += a[i] * b[j]
    for i in range(n_limbs):
        new_limbs[i] = mod(new_limbs[i] + c[i], p)

    for i in range(new_n_limbs):
        new_limbs[i] = mod(new_limbs[i], p)

    return new_limbs


cdef Int64Ptr polynomial_multiplication_terms(uint8_t n_limbs):
    cdef int i
    cdef Int64Ptr result = <Int64Ptr>calloc(2 * n_limbs - 1, sizeof(INT64))
    for i in range(2 * n_limbs - 1):
        if i < n_limbs:
            result[i] = i + 1
        else:
            result[i] = 2 * n_limbs - i - 1

    return result

cdef Int64Ptr modular_inverse_nterms_base(uint8_t n_limbs_unreduced, Int64Ptr n_terms, INT64 base, INT64 p):
    cdef int i
    cdef Int64Ptr result = <Int64Ptr>calloc(n_limbs_unreduced, sizeof(INT64))
    for i in range(n_limbs_unreduced):
        result[i] = modular_inverse(n_terms[i]*base, p)

    return result


@cython.cdivision(True)
cpdef int test_assert_reduced_felt(EmulatedBigInt self):
    cdef INT64 x, i, val
    cdef int coefficients_reduced = 0
    cdef BigIntPtr limbs = <INT64*>calloc(self.n_limbs, sizeof(INT64))
    
    cdef int prime_product = self.native_prime**self.n_limbs

    for x in range(prime_product):
        coefficients_reduced = 0
        for i in range(self.n_limbs):
            limbs[i] = (x // (self.native_prime**i)) % self.native_prime

        result = self.assert_reduced_emulated_felt(limbs)
        val = evaluate(limbs, self.n_limbs, self.base)

        for i in range(self.n_limbs):
            if limbs[i] >= self.base:
                coefficients_reduced = 1
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


cpdef test_full_field_add_honest(EmulatedBigInt self):
    cdef INT64 a, b
    cdef int result
    cdef BigIntPtr a_limbs, b_limbs
    cdef Int64Ptr hint_data = NULL
    cdef list py_results = PyList_New(0)
    for a in range(self.emulated_prime):
        for b in range(self.emulated_prime):
            a_limbs = split_int64(a, self.base, self.n_limbs)
            b_limbs = split_int64(b, self.base, self.n_limbs)
            hint_data = self.__compute_add_hint(a_limbs, b_limbs)

            result = self.__add_inner(a_limbs, b_limbs, hint_data)
            if result == 0:
                PyList_Append(py_results, (a, b))
            free(a_limbs)
            free(b_limbs)
    free(hint_data)
    return py_results

@cython.cdivision(True)
cpdef hack_add_full_field(EmulatedBigInt self):
    cdef INT64 a, b
    cdef int result, i, j
    cdef BigIntPtr a_limbs, b_limbs
    cdef int hint_data_size = self.native_prime**(self.n_limbs - 1)
    cdef Int64Ptr* hint_data_array = <Int64Ptr*>calloc(hint_data_size, sizeof(Int64Ptr))
    cdef list py_results = []

    # Create hint_data_array.
    for j in range(hint_data_size):
        hint_data_array[j] = <Int64Ptr>calloc(self.n_limbs, sizeof(INT64))
        # hint_data_array[j][0] = 0
        for i in range(1, self.n_limbs):
            hint_data_array[j][i] = (j // self.native_prime**(i-1)) % self.native_prime

    for a in range(self.emulated_prime):
        for b in range(self.emulated_prime):
            a_limbs = split_int64(a, self.base, self.n_limbs)
            b_limbs = split_int64(b, self.base, self.n_limbs)

            # Iterate over all possible hint_data values for hint_data_array.
            for j in range(hint_data_size):
                # Call add_inner for hint_data[0] = 0.
                result = self.__add_inner(a_limbs, b_limbs, hint_data_array[j])
                if result == 0:
                    py_results.append((a, b, [hint_data_array[j][k] for k in range(self.n_limbs)]))

                # Change hint_data[0] to 1 and call add_inner again.
                hint_data_array[j][0] = 1
                result = self.__add_inner(a_limbs, b_limbs, hint_data_array[j])
                if result == 0:
                    py_results.append((a, b, [hint_data_array[j][k] for k in range(self.n_limbs)]))

                # Change hint_data[0] back to 0 for the next iteration.
                hint_data_array[j][0] = 0

            free(a_limbs)
            free(b_limbs)

    # Free hint_data_array.
    for j in range(hint_data_size):
        free(hint_data_array[j])
    free(hint_data_array)

    return py_results

cpdef test_full_field_mul_range_check_honest(EmulatedBigInt self):
    cdef INT64 i, j
    cdef int result
    cdef BigIntPtr a_limbs, b_limbs, true_q_limbs, true_r_limbs, val, q_P, diff_limbs, hint_carries, diff, hint_flags
    cdef list py_results = PyList_New(0)
    for i in range(self.emulated_prime):
        for j in range(self.emulated_prime):
            a_limbs = split_int64(i, self.base, self.n_limbs)
            b_limbs = split_int64(j, self.base, self.n_limbs)

            true_q_limbs = split_int64((i * j) // self.emulated_prime, self.base, self.n_limbs)
            true_r_limbs = split_int64((i * j) % self.emulated_prime, self.base, self.n_limbs)

            val = __unreduced_mul(a_limbs, b_limbs, self.native_prime, self.n_limbs)
            q_P = __unreduced_mul_plus_c(true_q_limbs, self.emulated_prime_limbs, true_r_limbs, self.native_prime, self.n_limbs)
            diff_limbs = __unreduced_sub_negative(q_P, val, self.unreduced_n_limbs)
            hint_flags = __get_flags(diff_limbs, self.unreduced_n_limbs)
            hint_carries = __reduce_zero_poly(diff_limbs, self.unreduced_n_limbs, self.base)
            diff = __mod_poly(diff_limbs, self.unreduced_n_limbs, self.native_prime)

            result = self.__mul_inner_range_check(diff, true_q_limbs, true_r_limbs, hint_flags, hint_carries)

            if result == 0:
                PyList_Append(py_results, (i, j))
            free(a_limbs)
            free(b_limbs)
            free(true_q_limbs)
            free(true_r_limbs)
            free(val)
            free(q_P)
            free(diff_limbs)
            free(hint_flags)
            free(hint_carries)
            free(diff)
    return py_results


cdef Int64Ptr compute_mul_bitwise_hint_flags(BigIntPtr q_P, BigIntPtr val, uint8_t n_limbs):
    cdef Int64Ptr hint_flags = <Int64Ptr>calloc(n_limbs, sizeof(INT64))
    cdef uint8_t i
    for i in range(n_limbs):
        if q_P[i] - val[i] >= 0:
            hint_flags[i] = 1
        else:
            hint_flags[i] = 0
    return hint_flags


    
@cython.cdivision(True)
cpdef test_full_field_mul_bitwise_honest(EmulatedBigInt self):
    cdef INT64 i, j
    cdef int result
    cdef BigIntPtr a_limbs, b_limbs, true_q_limbs, true_r_limbs
    cdef BigIntPtr val
    cdef BigIntPtr q_P
    cdef Int64Ptr hint_flags
    cdef list py_results = PyList_New(0)
    for i in range(self.emulated_prime):
        for j in range(self.emulated_prime):
            a_limbs = split_int64(i, self.base, self.n_limbs)
            b_limbs = split_int64(j, self.base, self.n_limbs)
            true_q_limbs = split_int64((i * j) // self.emulated_prime, self.base, self.n_limbs)
            true_r_limbs = split_int64((i * j) % self.emulated_prime, self.base, self.n_limbs)
            val = __unreduced_mul(a_limbs, b_limbs, self.native_prime, self.n_limbs)
            q_P =  __unreduced_mul_plus_c(true_q_limbs, self.emulated_prime_limbs, true_r_limbs, self.native_prime, self.n_limbs)
            hint_flags = compute_mul_bitwise_hint_flags(q_P, val, self.unreduced_n_limbs-1)
            result = self.__mul_inner_bitwise(q_P, val, hint_flags)
            if result == 0:
                PyList_Append(py_results, (i, j))
            else:
                print(f"Was {i} x {j} = {[a_limbs[i] for i in range(self.n_limbs)]} x {[b_limbs[i] for i in range(self.n_limbs)]}")
                print(f"q= {[true_q_limbs[i] for i in range(self.n_limbs)]}")
                print(f"r= {[true_r_limbs[i] for i in range(self.n_limbs)]}")
                printf("\n\n")

            free(hint_flags)
            free(a_limbs)
            free(b_limbs)
            free(true_q_limbs)
            free(true_r_limbs)

    return py_results

@cython.cdivision(True)
cpdef get_carries_full_field_honest(EmulatedBigInt self):
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
            carries = self.__get_carries(a_limbs, b_limbs, true_q_limbs, true_r_limbs)

            PyList_Append(py_results, carries)
            free(a_limbs)
            free(b_limbs)
            free(true_q_limbs)
            free(true_r_limbs)
    return py_results

# cdef get_carries_full_field_malicious(EmulatedBigInt self, BigIntPtr a_limbs, BigIntPtr b_limbs):
#     cdef int result
#     cdef INT64 q, r
#     cdef BigIntPtr malicious_q, malicious_r
#     cdef dict carries_dict
#     cdef list py_results = []

#     for q in range(self.emulated_prime):
#         for r in range(self.emulated_prime):
#             malicious_q = split_int64(q, self.base, self.n_limbs)
#             malicious_r = split_int64(r, self.base, self.n_limbs)
#             result = self.__mul_inner_range_check(a_limbs, b_limbs, malicious_q, malicious_r)
#             if result == 0:
#                 carries_dict = {'wrong_q': q, 'wrong_r': r, 'carries': self.__get_carries(a_limbs, b_limbs, malicious_q, malicious_r)}
#                 py_results.append(carries_dict)
#             free(malicious_q)
#             free(malicious_r)

#     return py_results

# @cython.cdivision(True)
# cpdef get_all_unique_combinations_carries(EmulatedBigInt self):
#     cdef INT64 a, b, true_r, true_q
#     cdef BigIntPtr a_limbs, b_limbs, true_q_limbs, true_r_limbs
#     cdef list py_results = []

#     for a in range(self.emulated_prime):
#         for b in range(a, self.emulated_prime):
#             a_limbs = split_int64(a, self.base, self.n_limbs)
#             b_limbs = split_int64(b, self.base, self.n_limbs)

#             true_r = (a * b) % self.emulated_prime
#             true_q = (a * b) // self.emulated_prime

#             true_q_limbs = split_int64(true_q, self.base, self.n_limbs)
#             true_r_limbs = split_int64(true_r, self.base, self.n_limbs)

#             true_carries = self.__get_carries(a_limbs, b_limbs, true_q_limbs, true_r_limbs)
#             hack_carries = get_carries_full_field_malicious(self, a_limbs, b_limbs)

#             py_results.append({'a': a, 'b': b, 'true_q': true_q, 'true_r': true_r, 'true_carries': true_carries, 'hack_carries': hack_carries})

#             free(a_limbs)
#             free(b_limbs)
#             free(true_q_limbs)
#             free(true_r_limbs)

#     return py_results