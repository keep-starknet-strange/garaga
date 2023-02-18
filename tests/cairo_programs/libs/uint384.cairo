from starkware.cairo.common.bitwise import bitwise_and, bitwise_or, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import assert_in_range, assert_le, assert_nn_le, assert_not_zero
from starkware.cairo.common.math import unsigned_div_rem as frem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.uint256 import Uint256, uint256_add  // , uint256_square, word_reverse_endian
from starkware.cairo.common.pow import pow
from starkware.cairo.common.registers import get_ap, get_fp_and_pc

from tests.cairo_programs.libs.uint256_improvements import uint256_square

// This library is adapted from Cairo's common library Uint256 and it follows it as closely as possible.
// The library implements basic operations between 384-bit integers.
// Most operations use unsigned integers. Only a few operations are implemented for signed integers

// Represents an integer in the range [0, 2^384).
struct Uint384 {
    // The low 128 bits of the value.
    d0: felt,
    // The middle 128 bits of the value.
    d1: felt,
    // The # 128 bits of the value.
    d2: felt,
}

struct Uint384_expand {
    B0: felt,
    b01: felt,
    b12: felt,
    b23: felt,
    b34: felt,
    b45: felt,
    b5: felt,
}

const SHIFT = 2 ** 128;
const ALL_ONES = 2 ** 128 - 1;
const HALF_SHIFT = 2 ** 64;

namespace uint384_lib {
    // Verifies that the given integer is valid.
    func check{range_check_ptr}(a: Uint384) {
        [range_check_ptr] = a.d0;
        [range_check_ptr + 1] = a.d1;
        [range_check_ptr + 2] = a.d2;
        let range_check_ptr = range_check_ptr + 3;
        return ();
    }

    // Arithmetics.

    // Adds two integers. Returns the result as a 384-bit integer and the (1-bit) carry.
    func add{range_check_ptr}(a: Uint384, b: Uint384) -> (res: Uint384, carry: felt) {
        alloc_locals;
        local res: Uint384;
        local carry_d0: felt;
        local carry_d1: felt;
        local carry_d2: felt;
        %{
            sum_d0 = ids.a.d0 + ids.b.d0
            ids.carry_d0 = 1 if sum_d0 >= ids.SHIFT else 0
            sum_d1 = ids.a.d1 + ids.b.d1 + ids.carry_d0
            ids.carry_d1 = 1 if sum_d1 >= ids.SHIFT else 0
            sum_d2 = ids.a.d2 + ids.b.d2 + ids.carry_d1
            ids.carry_d2 = 1 if sum_d2 >= ids.SHIFT else 0
        %}

        // Either 0 or 1
        assert carry_d0 * carry_d0 = carry_d0;
        assert carry_d1 * carry_d1 = carry_d1;
        assert carry_d2 * carry_d2 = carry_d2;

        assert res.d0 = a.d0 + b.d0 - carry_d0 * SHIFT;
        assert res.d1 = a.d1 + b.d1 + carry_d0 - carry_d1 * SHIFT;
        assert res.d2 = a.d2 + b.d2 + carry_d1 - carry_d2 * SHIFT;

        check(res);

        return (res, carry_d2);
    }

    // Adds two integers. Returns the result as a 384-bit integer and the (1-bit) carry.
    // Doesn't verify that the result is a proper Uint384, that's now the responsibility of the calling function
    func _add_no_uint384_check{range_check_ptr}(a: Uint384, b: Uint384) -> Uint384 {
        alloc_locals;
        local res: Uint384;
        local carry_d0: felt;
        local carry_d1: felt;
        // local carry_d2: felt;
        %{
            sum_d0 = ids.a.d0 + ids.b.d0
            ids.carry_d0 = 1 if sum_d0 >= ids.SHIFT else 0
            sum_d1 = ids.a.d1 + ids.b.d1 + ids.carry_d0
            ids.carry_d1 = 1 if sum_d1 >= ids.SHIFT else 0
            sum_d2 = ids.a.d2 + ids.b.d2 + ids.carry_d1
            # ids.carry_d2 = 1 if sum_d2 >= ids.SHIFT else 0
        %}

        // Either 0 or 1
        assert carry_d0 * carry_d0 = carry_d0;
        assert carry_d1 * carry_d1 = carry_d1;
        // assert carry_d2 * carry_d2 = carry_d2;

        assert res.d0 = a.d0 + b.d0 - carry_d0 * SHIFT;
        assert res.d1 = a.d1 + b.d1 + carry_d0 - carry_d1 * SHIFT;
        assert res.d2 = a.d2 + b.d2 + carry_d1;

        return res;
    }

    // Splits a field element in the range [0, 2^192) to its low 64-bit and high 128-bit parts.
    func split_64{range_check_ptr}(a: felt) -> (low: felt, high: felt) {
        alloc_locals;
        local low: felt;
        local high: felt;

        %{
            ids.low = ids.a & ((1<<64) - 1)
            ids.high = ids.a >> 64
        %}
        assert a = low + high * HALF_SHIFT;
        assert [range_check_ptr + 0] = low;
        assert [range_check_ptr + 1] = HALF_SHIFT - 1 - low;
        assert [range_check_ptr + 2] = high;
        let range_check_ptr = range_check_ptr + 3;
        return (low, high);
    }

    func assert_160_bit{range_check_ptr}(value) {
        const UPPER_BOUND = 2 ** 160;
        const SHIFT = 2 ** 128;
        const HIGH_BOUND = UPPER_BOUND / SHIFT;

        let low = [range_check_ptr];
        let high = [range_check_ptr + 1];

        %{
            from starkware.cairo.common.math_utils import as_int

            # Correctness check.
            value = as_int(ids.value, PRIME) % PRIME
            assert value < ids.UPPER_BOUND, f'{value} is outside of the range [0, 2**160).'

            # Calculation for the assertion.
            ids.high, ids.low = divmod(ids.value, ids.SHIFT)
        %}

        assert [range_check_ptr + 2] = HIGH_BOUND - 1 - high;

        // The assert below guarantees that
        //   value = high * SHIFT + low <= (HIGH_BOUND - 1) * SHIFT + 2**128 - 1 =
        //   HIGH_BOUND * SHIFT - SHIFT + SHIFT - 1 = 2**160 - 1.
        assert value = high * SHIFT + low;

        let range_check_ptr = range_check_ptr + 3;
        return ();
    }

    // Splits a field element in the range [0, 2^224) to its low 64-bit and high 160-bit parts.
    func split_64b{range_check_ptr}(a: felt) -> (low: felt, high: felt) {
        alloc_locals;
        local low: felt;
        local high: felt;

        %{
            ids.low = ids.a & ((1<<64) - 1)
            ids.high = ids.a >> 64
        %}
        assert a = low + high * HALF_SHIFT;
        assert [range_check_ptr + 0] = low;
        assert [range_check_ptr + 1] = HALF_SHIFT - 1 - low;
        let range_check_ptr = range_check_ptr + 2;
        assert_160_bit(high);
        return (low, high);
    }

    // Splits a field element in the range [0, 2^224) to its low 128-bit and high 96-bit parts.
    func split_128{range_check_ptr}(a: felt) -> (low: felt, high: felt) {
        alloc_locals;
        const UPPER_BOUND = 2 ** 224;
        const HIGH_BOUND = UPPER_BOUND / SHIFT;
        local low: felt;
        local high: felt;

        %{
            ids.low = ids.a & ((1<<128) - 1)
            ids.high = ids.a >> 128
        %}
        assert a = low + high * SHIFT;
        assert [range_check_ptr + 0] = high;
        assert [range_check_ptr + 1] = HIGH_BOUND - 1 - high;
        assert [range_check_ptr + 2] = low;
        let range_check_ptr = range_check_ptr + 3;
        return (low, high);
    }

    // Multiplies two integers. Returns the result as two 384-bit integers: the result has 2*384 bits,
    // the returned integers represent the lower 384-bits and the higher 384-bits, respectively.
    func mul{range_check_ptr}(a: Uint384, b: Uint384) -> (low: Uint384, high: Uint384) {
        let (a0, a1) = split_64(a.d0);
        let (a2, a3) = split_64(a.d1);
        let (a4, a5) = split_64(a.d2);
        let (b0, b1) = split_64(b.d0);
        let (b2, b3) = split_64(b.d1);
        let (b4, b5) = split_64(b.d2);

        let (res0, carry) = split_64(a0 * b0);
        let (res1, carry) = split_64(a1 * b0 + a0 * b1 + carry);
        let (res2, carry) = split_64(a2 * b0 + a1 * b1 + a0 * b2 + carry);
        let (res3, carry) = split_64(a3 * b0 + a2 * b1 + a1 * b2 + a0 * b3 + carry);
        let (res4, carry) = split_64(a4 * b0 + a3 * b1 + a2 * b2 + a1 * b3 + a0 * b4 + carry);
        let (res5, carry) = split_64(
            a5 * b0 + a4 * b1 + a3 * b2 + a2 * b3 + a1 * b4 + a0 * b5 + carry
        );
        let (res6, carry) = split_64(a5 * b1 + a4 * b2 + a3 * b3 + a2 * b4 + a1 * b5 + carry);
        let (res7, carry) = split_64(a5 * b2 + a4 * b3 + a3 * b4 + a2 * b5 + carry);
        let (res8, carry) = split_64(a5 * b3 + a4 * b4 + a3 * b5 + carry);
        let (res9, carry) = split_64(a5 * b4 + a4 * b5 + carry);
        let (res10, carry) = split_64(a5 * b5 + carry);

        return (
            low=Uint384(
                d0=res0 + HALF_SHIFT * res1,
                d1=res2 + HALF_SHIFT * res3,
                d2=res4 + HALF_SHIFT * res5,
            ),
            high=Uint384(
                d0=res6 + HALF_SHIFT * res7,
                d1=res8 + HALF_SHIFT * res9,
                d2=res10 + HALF_SHIFT * carry,
            ),
        );
    }

    // Multiplies two integers. Returns the result as two 256-bit integers (low and high parts).
    // func mul{range_check_ptr}(a : Uint384, b : Uint384) -> (low : Uint384, high : Uint384):
    //     alloc_locals
    //
    //     let (res0, carry) = split_128(a.d0 * b.d0)
    //     let (res1, carry) = split_128(a.d1 * b.d0 + a.d0 * b.d1 + carry)
    //     let (res2, carry) = split_128(a.d2 * b.d0 + a.d1 * b.d1  + a.d0 * b.d2 + carry)
    //     let (res3, carry) = split_128(a.d2 * b.d1 + a.d1 * b.d2  + carry)
    //     let (res4, carry) = split_128(a.d2 * b.d2  + carry)
    //     return (low=Uint384(d0=res0, d1=res1, d2 = res2), high=Uint384(d0=res3, d1=res4, d2=carry))
    // end

    func mul_b{range_check_ptr}(a: Uint384, b: Uint384) -> (low: Uint384, high: Uint384) {
        let a0 = a.d0;
        let a2 = a.d1;
        let a4 = a.d2;
        let (b0, b1) = split_64(b.d0);
        let (b2, b3) = split_64(b.d1);
        let (b4, b5) = split_64(b.d2);

        let (res0, carry) = split_64(a0 * b0);
        let (res1, carry) = split_64(a0 * b1 + carry);
        let (res2, carry) = split_64b(a2 * b0 + a0 * b2 + carry);
        let (res3, carry) = split_64b(a2 * b1 + a0 * b3 + carry);
        let (res4, carry) = split_64b(a4 * b0 + a2 * b2 + a0 * b4 + carry);
        let (res5, carry) = split_64b(a4 * b1 + a2 * b3 + a0 * b5 + carry);
        let (res6, carry) = split_64b(a4 * b2 + a2 * b4 + carry);
        let (res7, carry) = split_64b(a4 * b3 + a2 * b5 + carry);
        let (res8, carry) = split_64b(a4 * b4 + carry);
        let (res9, carry) = split_64(a4 * b5 + carry);
        let (res10, carry) = split_64(carry);

        return (
            low=Uint384(
                d0=res0 + HALF_SHIFT * res1,
                d1=res2 + HALF_SHIFT * res3,
                d2=res4 + HALF_SHIFT * res5,
            ),
            high=Uint384(
                d0=res6 + HALF_SHIFT * res7,
                d1=res8 + HALF_SHIFT * res9,
                d2=res10 + HALF_SHIFT * carry,
            ),
        );
    }

    func mul_c{range_check_ptr}(a: Uint384, b: Uint384) -> (low: Uint384, high: Uint384) {
        alloc_locals;
        let (a0, a1) = split_64(a.d0);
        let (a2, a3) = split_64(a.d1);
        let (a4, a5) = split_64(a.d2);
        let (b0, b1) = split_64(b.d0);
        let (b2, b3) = split_64(b.d1);
        let (b4, b5) = split_64(b.d2);

        let (res0, carry) = split_128(a0 * b0 + (a1 * b0 + a0 * b1) * HALF_SHIFT);
        let (res2, carry) = split_128(
            a2 * b0 + a1 * b1 + a0 * b2 + (a3 * b0 + a2 * b1 + a1 * b2 + a0 * b3) * HALF_SHIFT +
            carry,
        );
        let (res4, carry) = split_128(
            a4 * b0 + a3 * b1 + a2 * b2 + a1 * b3 + a0 * b4 + (
                a5 * b0 + a4 * b1 + a3 * b2 + a2 * b3 + a1 * b4 + a0 * b5
            ) * HALF_SHIFT + carry,
        );
        let (res6, carry) = split_128(
            a5 * b1 + a4 * b2 + a3 * b3 + a2 * b4 + a1 * b5 + (
                a5 * b2 + a4 * b3 + a3 * b4 + a2 * b5
            ) * HALF_SHIFT + carry,
        );
        let (res8, carry) = split_128(
            a5 * b3 + a4 * b4 + a3 * b5 + (a5 * b4 + a4 * b5) * HALF_SHIFT + carry
        );
        // let (res10, carry) = split_64(a5 * b5 + carry)

        return (
            low=Uint384(d0=res0, d1=res2, d2=res4),
            high=Uint384(d0=res6, d1=res8, d2=a5 * b5 + carry),
        );
    }

    func mul_d{range_check_ptr}(a: Uint384, b: Uint384) -> (low: Uint384, high: Uint384) {
        alloc_locals;
        let (a0, a1) = split_64(a.d0);
        let (a2, a3) = split_64(a.d1);
        let (a4, a5) = split_64(a.d2);
        let (b0, b1) = split_64(b.d0);
        let (b2, b3) = split_64(b.d1);
        let (b4, b5) = split_64(b.d2);

        local B0 = b0 * HALF_SHIFT;
        local b12 = b1 + b2 * HALF_SHIFT;
        local b34 = b3 + b4 * HALF_SHIFT;

        let (res0, carry) = split_128(a1 * B0 + a0 * b.d0);
        let (res2, carry) = split_128(a3 * B0 + a2 * b.d0 + a1 * b12 + a0 * b.d1 + carry);
        let (res4, carry) = split_128(
            a5 * B0 + a4 * b.d0 + a3 * b12 + a2 * b.d1 + a1 * b34 + a0 * b.d2 + carry
        );
        let (res6, carry) = split_128(
            a5 * b12 + a4 * b.d1 + a3 * b34 + a2 * b.d2 + a1 * b5 + carry
        );
        let (res8, carry) = split_128(a5 * b34 + a4 * b.d2 + a3 * b5 + carry);
        // let (res10, carry) = split_64(a5 * b5 + carry)

        return (
            low=Uint384(d0=res0, d1=res2, d2=res4),
            high=Uint384(d0=res6, d1=res8, d2=a5 * b5 + carry),
        );
    }

    func expand{range_check_ptr}(a: Uint384) -> (exp: Uint384_expand) {
        let (a0, a1) = split_64(a.d0);
        let (a2, a3) = split_64(a.d1);
        let (a4, a5) = split_64(a.d2);

        return (
            exp=Uint384_expand(
                a0 * HALF_SHIFT, a.d0, a1 + a2 * HALF_SHIFT, a.d1, a3 + a4 * HALF_SHIFT, a.d2, a5
            ),
        );
    }

    func mul_expanded{range_check_ptr}(a: Uint384, b: Uint384_expand) -> (
        low: Uint384, high: Uint384
    ) {
        let (a0, a1) = split_64(a.d0);
        let (a2, a3) = split_64(a.d1);
        let (a4, a5) = split_64(a.d2);

        let (res0, carry) = split_128(a1 * b.B0 + a0 * b.b01);
        let (res2, carry) = split_128(a3 * b.B0 + a2 * b.b01 + a1 * b.b12 + a0 * b.b23 + carry);
        let (res4, carry) = split_128(
            a5 * b.B0 + a4 * b.b01 + a3 * b.b12 + a2 * b.b23 + a1 * b.b34 + a0 * b.b45 + carry
        );
        let (res6, carry) = split_128(
            a5 * b.b12 + a4 * b.b23 + a3 * b.b34 + a2 * b.b45 + a1 * b.b5 + carry
        );
        let (res8, carry) = split_128(a5 * b.b34 + a4 * b.b45 + a3 * b.b5 + carry);
        // let (res10, carry) = split_64(a5 * b.b5 + carry)

        return (
            low=Uint384(d0=res0, d1=res2, d2=res4),
            high=Uint384(d0=res6, d1=res8, d2=a5 * b.b5 + carry),
        );
    }

    // assumes b < 2**128
    func mul_by_uint128{range_check_ptr}(a: Uint384, b: felt) -> (low: Uint384, high: felt) {
        alloc_locals;
        let (a0, a1) = split_64(a.d0);
        let (a2, a3) = split_64(a.d1);
        let (a4, a5) = split_64(a.d2);
        let (b0, b1) = split_64(b);

        local B0 = b0 * HALF_SHIFT;

        let (res0, carry) = split_128(a1 * B0 + a0 * b);
        let (res2, carry) = split_128(a3 * B0 + a2 * b + a1 * b1 + carry);
        let (res4, carry) = split_128(a5 * B0 + a4 * b + a3 * b1 + carry);
        // let (res6, carry) = split_64(a5 * b1 + carry)

        return (low=Uint384(d0=res0, d1=res2, d2=res4), high=a5 * b1 + carry);
    }

    // assumes b < 2**64
    func mul_by_uint64{range_check_ptr}(a: Uint384, b: felt) -> (low: Uint384, high: felt) {
        let (res0, carry) = split_128(a.d0 * b);
        let (res2, carry) = split_128(a.d1 * b + carry);
        let (res4, carry) = split_128(a.d2 * b + carry);

        return (low=Uint384(d0=res0, d1=res2, d2=res4), high=carry);
    }

    func Toom3_eval(m0: felt, m1: felt, m2: felt) -> (p1: felt, pm1: felt, pm2: felt) {
        alloc_locals;
        local p = m0 + m2;
        local pm1 = p - m1;
        return (p + m1, pm1, (pm1 + m2) * 2 - m0);
    }

    func uint128_mul_split(x0: felt, x1: felt, y0: felt, y1: felt) -> (z0: felt, z2: felt) {
        return (x0 * y0 + (x1 * y0 + y1 * x0) * HALF_SHIFT, x1 * y1);
    }

    func Toom3_interp(z0: felt, z4: felt, p1: felt, pm1: felt, pm2: felt) -> (
        z1: felt, z2: felt, z3: felt
    ) {
        alloc_locals;
        local r3 = (pm2 - p1) / 3;
        // local r3 : felt
        // %{
        //    ids.r3 = (ids.pm2 - ids.p1)//3
        // %}
        // assert pm2 = p1 + 3*r3
        local r1 = (p1 - pm1) / 2;
        // local r1 : felt
        // %{
        //    ids.r1 = (ids.p1 - ids.pm1)//2
        // %}
        // assert p1 = pm1 + r1+r1
        local r2 = pm1 - z0;
        local z3 = (r2 - r3) / 2 + 2 * z4;
        local z2 = r2 + r1 - z4;
        // local z3 = (pm1 - z0 - r3)/2 + 2*z4
        // local z2 = pm1 - z0 + r1 - z4
        local z1 = r1 - z3;
        return (z1, z2, z3);
    }

    func mul_Toom3{range_check_ptr}(a: Uint384, b: Uint384) -> (low: Uint384, high: Uint384) {
        let (a0, a1) = split_64(a.d0);
        let (a2, a3) = split_64(a.d1);
        let (a4, a5) = split_64(a.d2);
        let (b0, b1) = split_64(b.d0);
        let (b2, b3) = split_64(b.d1);
        let (b4, b5) = split_64(b.d2);

        let (pa1, pam1, pam2) = Toom3_eval(a0, a2, a4);
        let (pa1b, pam1b, pam2b) = Toom3_eval(a1, a3, a5);
        let (pb1, pbm1, pbm2) = Toom3_eval(b0, b2, b4);
        let (pb1b, pbm1b, pbm2b) = Toom3_eval(b1, b3, b5);

        let (Z0, w2) = uint128_mul_split(a0, a1, b0, b1);
        let (Z8, w10) = uint128_mul_split(a4, a5, b4, b5);
        let (r1, r1b) = uint128_mul_split(pa1, pa1b, pb1, pb1b);
        let (rm1, rm1b) = uint128_mul_split(pam1, pam1b, pbm1, pbm1b);
        let (rm2, rm2b) = uint128_mul_split(pam2, pam2b, pbm2, pbm2b);

        let (Z2, Z4, Z6) = Toom3_interp(Z0, Z8, r1, rm1, rm2);
        let (w4, w6, w8) = Toom3_interp(w2, w10, r1b, rm1b, rm2b);

        let (res0, carry) = split_128(Z0);
        let (res2, carry) = split_128(Z2 + w2 + carry);
        let (res4, carry) = split_128(Z4 + w4 + carry);
        let (res6, carry) = split_128(Z6 + w6 + carry);
        let (res8, carry) = split_128(Z8 + w8 + carry);
        // let (res10, carry) = split_64(w10 + carry)

        return (
            low=Uint384(d0=res0, d1=res2, d2=res4), high=Uint384(d0=res6, d1=res8, d2=w10 + carry)
        );
    }

    func mul_kar{range_check_ptr}(a: Uint384, b: Uint384) -> (low: Uint384, high: Uint384) {
        alloc_locals;
        let (a0, a1) = split_64(a.d0);
        let (a2, a3) = split_64(a.d1);
        let (a4, a5) = split_64(a.d2);
        let (b0, b1) = split_64(b.d0);
        let (b2, b3) = split_64(b.d1);
        let (b4, b5) = split_64(b.d2);

        local A0 = a0 + a3;
        local A1 = a1 + a4;
        local A2 = a2 + a5;
        local B0 = b0 + b3;
        local B1 = b1 + b4;
        local B2 = b2 + b5;

        local d0 = a0 * b0;
        local d1 = a1 * b0 + a0 * b1;
        local d2 = a2 * b0 + a1 * b1 + a0 * b2;
        local d3 = a2 * b1 + a1 * b2;
        local d4 = a2 * b2;

        local d6 = a3 * b3;
        local d7 = a4 * b3 + a3 * b4;
        local d8 = a5 * b3 + a4 * b4 + a3 * b5;
        local d9 = a5 * b4 + a4 * b5;
        local d10 = a5 * b5;

        let (res0, carry) = split_128(d0 + d1 * HALF_SHIFT);
        let (res2, carry) = split_128(d2 + (d3 + A0 * B0 - d0 - d6) * HALF_SHIFT + carry);
        let (res4, carry) = split_128(
            d4 + A1 * B0 + A0 * B1 - d1 - d7 + (A2 * B0 + A1 * B1 + A0 * B2 - d2 - d8) *
            HALF_SHIFT + carry,
        );
        let (res6, carry) = split_128(
            d6 + A2 * B1 + A1 * B2 - d3 - d9 + (d7 + A2 * B2 - d4 - d10) * HALF_SHIFT + carry
        );
        let (res8, carry) = split_128(d8 + d9 * HALF_SHIFT + carry);
        // let (res10, carry) = split_64(d10 + carry)

        return (
            low=Uint384(d0=res0, d1=res2, d2=res4), high=Uint384(d0=res6, d1=res8, d2=d10 + carry)
        );
    }

    func assert_div{range_check_ptr}(value, div) -> () {
        let q = [range_check_ptr];
        let range_check_ptr = range_check_ptr + 1;
        %{
            from starkware.cairo.common.math_utils import assert_integer
            assert_integer(ids.div)
            assert 0 < ids.div <= PRIME // range_check_builtin.bound, \
               f'div={hex(ids.div)} is out of the valid range.'
            ids.q, r = divmod(ids.value, ids.div)
            assert r == 0
        %}

        assert value = q * div;
        return ();
    }

    func mul_mont{range_check_ptr}(a: Uint384, b: Uint384) -> (low: Uint384, high: Uint384) {
        alloc_locals;
        const B0_1 = SHIFT;
        const B0_2 = SHIFT ** 2;
        const B0_3 = SHIFT ** 3;
        const B0_4 = SHIFT ** 4;
        const B0_5 = SHIFT ** 5;

        const FAC1 = 2 ** 118;
        const B1_1 = 0;
        const B1_2 = 0;
        const B1_3 = 0;
        const B1_4 = 0;
        const B1_5 = 0;

        const FAC2 = 332306998946228968225951765070086143;
        // apparantly we can't create arrays of consts for some reason
        const B2_1 = 1024;
        const B2_2 = 1048576;
        const B2_3 = 1073741824;
        const B2_4 = 1099511627776;
        const B2_5 = 1125899906842624;

        const FAC3 = 332306998946228968225951765070086141;
        const B3_1 = 3072;
        const B3_2 = 9437184;
        const B3_3 = 28991029248;
        const B3_4 = 89060441849856;
        const B3_5 = 273593677362757632;

        const FAC4 = 332306998946228968225951765070086139;
        const B4_1 = 5120;
        const B4_2 = 26214400;
        const B4_3 = 134217728000;
        const B4_4 = 687194767360000;
        const B4_5 = 3518437208883200000;

        const FAC5 = 332306998946228968225951765070086135;
        const B5_1 = 9216;
        const B5_2 = 84934656;
        const B5_3 = 782757789696;
        const B5_4 = 7213895789838336;
        const B5_5 = 66483263599150104576;

        local low: Uint384;
        local high: Uint384;
        %{
            #from tests.utils import split, pack
            exec(open('tests/utils.py').read()) #horible kludge, fix when we have a good name space
            #a=pack(ids.a) #that this doesn't work is a flaw in Cairo
            a=pack((ids.a.d0,ids.a.d1,ids.a.d2))
            #b=pack(ids.b) #that this doesn't work is a flaw in Cairo
            b=pack((ids.b.d0,ids.b.d1,ids.b.d2))

            (ids.low.d0,ids.low.d1,ids.low.d2,ids.high.d0,ids.high.d1,ids.high.d2) = split(a*b, length=6)
        %}

        check(low);
        check(high);

        assert (a.d0 + a.d1 * B0_1 + a.d2 * B0_2) * (b.d0 + b.d1 * B0_1 + b.d2 * B0_2) = (
            low.d0 +
            low.d1 * B0_1 +
            low.d2 * B0_2 +
            high.d0 * B0_3 +
            high.d1 * B0_4 +
            high.d2 * B0_5
        );

        let (_, va) = frem(a.d0, FAC1);
        let (_, vb) = frem(b.d0, FAC1);
        assert_div(low.d0 + FAC1 ** 2 - va * vb, FAC1);

        let (_, va) = frem(a.d0 + a.d1 * B2_1 + a.d2 * B2_2, FAC2);
        let (_, vb) = frem(b.d0 + b.d1 * B2_1 + b.d2 * B2_2, FAC2);
        assert_div(
            low.d0 + low.d1 * B2_1 + low.d2 * B2_2 + high.d0 * B2_3 + high.d1 * B2_4 + high.d2 *
            B2_5 + FAC2 ** 2 - va * vb,
            FAC2,
        );

        let (_, va) = frem(a.d0 + a.d1 * B3_1 + a.d2 * B3_2, FAC3);
        let (_, vb) = frem(b.d0 + b.d1 * B3_1 + b.d2 * B3_2, FAC3);
        assert_div(
            low.d0 + low.d1 * B3_1 + low.d2 * B3_2 + high.d0 * B3_3 + high.d1 * B3_4 + high.d2 *
            B3_5 + FAC3 ** 2 - va * vb,
            FAC3,
        );

        let (_, va) = frem(a.d0 + a.d1 * B4_1 + a.d2 * B4_2, FAC4);
        let (_, vb) = frem(b.d0 + b.d1 * B4_1 + b.d2 * B4_2, FAC4);
        assert_div(
            low.d0 + low.d1 * B4_1 + low.d2 * B4_2 + high.d0 * B4_3 + high.d1 * B4_4 + high.d2 *
            B4_5 + FAC4 ** 2 - va * vb,
            FAC4,
        );

        let (_, va) = frem(a.d0 + a.d1 * B5_1 + a.d2 * B5_2, FAC5);
        let (_, vb) = frem(b.d0 + b.d1 * B5_1 + b.d2 * B5_2, FAC5);
        assert_div(
            low.d0 + low.d1 * B5_1 + low.d2 * B5_2 + high.d0 * B5_3 + high.d1 * B5_4 + high.d2 *
            B5_5 + FAC5 ** 2 - va * vb,
            FAC5,
        );

        return (low, high);
    }

    func square_c{range_check_ptr}(a: Uint384) -> (low: Uint384, high: Uint384) {
        let (a0, a1) = split_64(a.d0);
        let (a2, a3) = split_64(a.d1);
        let (a4, a5) = split_64(a.d2);

        const HALF_SHIFT2 = 2 * HALF_SHIFT;

        let (res0, carry) = split_128(a0 * a0 + (a1 * a0) * HALF_SHIFT2);
        let (res2, carry) = split_128(
            a2 * a0 * 2 + a1 * a1 + (a3 * a0 + a2 * a1) * HALF_SHIFT2 + carry
        );
        let (res4, carry) = split_128(
            (a4 * a0 + a3 * a1) * 2 + a2 * a2 + (a5 * a0 + a4 * a1 + a3 * a2) * HALF_SHIFT2 + carry
        );
        let (res6, carry) = split_128(
            (a5 * a1 + a4 * a2) * 2 + a3 * a3 + (a5 * a2 + a4 * a3) * HALF_SHIFT2 + carry
        );
        let (res8, carry) = split_128(a5 * a3 * 2 + a4 * a4 + (a5 * a4) * HALF_SHIFT2 + carry);
        // let (res10, carry) = split_64(a5 * a5 + carry)

        return (
            low=Uint384(d0=res0, d1=res2, d2=res4),
            high=Uint384(d0=res6, d1=res8, d2=a5 * a5 + carry),
        );
    }

    func square_d{range_check_ptr}(a: Uint384) -> (low: Uint384, high: Uint384) {
        alloc_locals;
        let (a0, a1) = split_64(a.d0);
        let (a2, a3) = split_64(a.d1);
        let (a4, a5) = split_64(a.d2);

        const HALF_SHIFT2 = 2 * HALF_SHIFT;
        local A0 = a0 * HALF_SHIFT2;
        local ad0_2 = a.d0 * 2;
        local a12 = a1 + a2 * HALF_SHIFT;

        let (res0, carry) = split_128(a0 * (ad0_2 - a0));
        let (res2, carry) = split_128(a2 * ad0_2 + a1 * a1 + a3 * A0 + carry);
        let (res4, carry) = split_128((a4 * a.d0 + a3 * a12) * 2 + a2 * a2 + a5 * A0 + carry);
        let (res6, carry) = split_128((a5 * a12 + a4 * a.d1) * 2 + a3 * a3 + carry);
        let (res8, carry) = split_128(a5 * a3 * 2 + a4 * (a4 + a5 * HALF_SHIFT2) + carry);
        // let (res10, carry) = split_64(a5*a5 + carry)

        return (
            low=Uint384(d0=res0, d1=res2, d2=res4),
            high=Uint384(d0=res6, d1=res8, d2=a5 * a5 + carry),
        );
    }

    func square_e{range_check_ptr}(a: Uint384) -> (low: Uint384, high: Uint384) {
        alloc_locals;
        let (a0, a1) = split_64(a.d0);
        let (a2, a3) = split_64(a.d1);
        let (a4, a5) = split_64(a.d2);

        const HALF_SHIFT2 = 2 * HALF_SHIFT;
        local a0_2 = a0 * 2;
        local a34 = a3 + a4 * HALF_SHIFT2;

        let (res0, carry) = split_128(a0 * (a0 + a1 * HALF_SHIFT2));
        let (res2, carry) = split_128(a.d1 * a0_2 + a1 * (a1 + a2 * HALF_SHIFT2) + carry);
        let (res4, carry) = split_128(
            a.d2 * a0_2 + (a3 + a34) * a1 + a2 * (a2 + a3 * HALF_SHIFT2) + carry
        );
        let (res6, carry) = split_128((a5 * a1 + a.d2 * a2) * 2 + a3 * a34 + carry);
        let (res8, carry) = split_128(a5 * (a3 + a34) + a4 * a4 + carry);
        // let (res10, carry) = split_64(a5*a5 + carry)

        return (
            low=Uint384(d0=res0, d1=res2, d2=res4),
            high=Uint384(d0=res6, d1=res8, d2=a5 * a5 + carry),
        );
    }

    // Returns the floor value of the square root of a Uint384 integer.
    func sqrt{range_check_ptr}(a: Uint384) -> (res: Uint384) {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local root: Uint384;

        %{
            from starkware.python.math_utils import isqrt

            def split(num: int, num_bits_shift: int, length: int):
                a = []
                for _ in range(length):
                    a.append( num & ((1 << num_bits_shift) - 1) )
                    num = num >> num_bits_shift
                return tuple(a)

            def pack(z, num_bits_shift: int) -> int:
                limbs = (z.d0, z.d1, z.d2)
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

            a = pack(ids.a, num_bits_shift=128)
            root = isqrt(a)
            assert 0 <= root < 2 ** 192
            root_split = split(root, num_bits_shift=128, length=3)
            ids.root.d0 = root_split[0]
            ids.root.d1 = root_split[1]
            ids.root.d2 = root_split[2]
        %}

        // Verify that 0 <= root < 2**192.
        assert root.d2 = 0;
        [range_check_ptr] = root.d0;

        // We don't need to check that 0 <= d1 < 2**64, since this gets checked
        // when we check that carry==0 later
        assert [range_check_ptr + 1] = root.d1;
        let range_check_ptr = range_check_ptr + 2;

        // Verify that n >= root**2.
        let (root_squared, carry) = square_e(root);
        assert carry = Uint384(0, 0, 0);
        let (check_lower_bound) = le(root_squared, a);
        assert check_lower_bound = 1;

        // Verify that n <= (root+1)**2 - 1.
        // In the case where root = 2**192 - 1, we will have next_root_squared=0, since
        // (root+1)**2 = 2**384. Therefore next_root_squared - 1 = 2**384 - 1, as desired.
        let (next_root, add_carry) = add(root, Uint384(1, 0, 0));
        assert add_carry = 0;
        let (next_root_squared, _) = square_e(next_root);
        let (next_root_squared_minus_one) = sub(next_root_squared, Uint384(1, 0, 0));
        let (check_upper_bound) = le(a, next_root_squared_minus_one);
        assert check_upper_bound = 1;

        return (res=root);
    }

    // Returns the floor value of the square root of a Uint384 integer.
    func sqrt_b{range_check_ptr}(a: Uint384) -> (res: Uint384) {
        alloc_locals;
        // let (__fp__, _) = get_fp_and_pc();
        local root: Uint256;

        %{
            from starkware.python.math_utils import isqrt

            def split(num: int, num_bits_shift: int, length: int):
                a = []
                for _ in range(length):
                    a.append( num & ((1 << num_bits_shift) - 1) )
                    num = num >> num_bits_shift
                return tuple(a)

            def pack(z, num_bits_shift: int) -> int:
                limbs = (z.d0, z.d1, z.d2)
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

            a = pack(ids.a, num_bits_shift=128)
            root = isqrt(a)
            assert 0 <= root < 2 ** 192
            root_split = split(root, num_bits_shift=128, length=2)
            ids.root.low = root_split[0]
            ids.root.high = root_split[1]
        %}

        // Verify that 0 <= root < 2**192.
        [range_check_ptr] = root.low;

        // We don't need to check that 0 <= d1 < 2**64, since this gets checked
        // when we check that root_squared_h.high==0 later
        assert [range_check_ptr + 1] = root.high;
        let range_check_ptr = range_check_ptr + 2;

        // Verify that n >= root**2.
        let (root_squared_l, root_squared_h) = uint256_square(root);
        assert root_squared_h.high = 0;
        let root_squared = Uint384(root_squared_l.low, root_squared_l.high, root_squared_h.low);
        let (check_lower_bound) = le(root_squared, a);
        assert check_lower_bound = 1;

        // Verify that n <= (root+1)**2 - 1.
        // Note that (root+1)**2 - 1 = root**2 + 2*root.
        // In the case where root = 2**192 - 1, since
        // (root+1)**2 = 2**384, next_root_squared - 1 = 2**384 - 1, as desired.
        let (twice_root, carry) = uint256_add(root, root);
        let (next_root_squared_minus_one, _) = add(
            root_squared, Uint384(twice_root.low, twice_root.high, carry)
        );
        let (check_upper_bound) = le(a, next_root_squared_minus_one);
        assert check_upper_bound = 1;

        return (res=Uint384(root.low, root.high, 0));
    }

    // Returns 1 if the first unsigned integer is less than the second unsigned integer.
    func lt{range_check_ptr}(a: Uint384, b: Uint384) -> (res: felt) {
        if (a.d2 == b.d2) {
            if (a.d1 == b.d1) {
                return (is_le(a.d0 + 1, b.d0),);
            }
            return (is_le(a.d1 + 1, b.d1),);
        }
        return (is_le(a.d2 + 1, b.d2),);
    }

    // Returns 1 if the first signed integer is less than the second signed integer.
    func signed_lt{range_check_ptr}(a: Uint384, b: Uint384) -> (res: felt) {
        let (a, _) = add(a, Uint384(d0=0, d1=0, d2=2 ** 127));
        let (b, _) = add(b, Uint384(d0=0, d1=0, d2=2 ** 127));
        return lt(a, b);
    }

    // Returns 1 if the first unsigned integer is less than or equal to the second unsigned integer.
    func le{range_check_ptr}(a: Uint384, b: Uint384) -> (res: felt) {
        let (not_le) = lt(a=b, b=a);
        return (1 - not_le,);
    }

    // Returns 1 if the first signed integer is less than or equal to the second signed integer.
    func signed_le{range_check_ptr}(a: Uint384, b: Uint384) -> (res: felt) {
        let (not_le) = signed_lt(a=b, b=a);
        return (1 - not_le,);
    }

    // TODO: do we need to use `@known_ap_change` here?
    // Returns 1 if the signed integer is nonnegative.
    @known_ap_change
    func signed_nn{range_check_ptr}(a: Uint384) -> (res: felt) {
        %{ memory[ap] = 1 if 0 <= (ids.a.d2 % PRIME) < 2 ** 127 else 0 %}
        jmp non_negative if [ap] != 0, ap++;

        assert [range_check_ptr] = a.d2 - 2 ** 127;
        let range_check_ptr = range_check_ptr + 1;
        return (res=0);

        non_negative:
        assert [range_check_ptr] = a.d2 + 2 ** 127;
        let range_check_ptr = range_check_ptr + 1;
        return (res=1);
    }

    // hiding version of signed_nn
    // also avoids using `@known_ap_change`
    func hiding_signed_nn{range_check_ptr}(a: Uint384) -> (res: felt) {
        alloc_locals;
        local inv_res: felt;
        %{ ids.inv_res = 1 if ids.a.d2*2 >= ids.SHIFT else 0 %}
        // Either 0 or 1
        assert inv_res * inv_res = inv_res;
        assert [range_check_ptr] = a.d2 * 2 - inv_res * SHIFT;
        let range_check_ptr = range_check_ptr + 1;

        return (res=1 - inv_res);
    }

    // Returns 1 if the first signed integer is less than or equal to the second signed integer
    // and is greater than or equal to zero.
    func signed_nn_le{range_check_ptr}(a: Uint384, b: Uint384) -> (res: felt) {
        let (is_le) = signed_le(a=a, b=b);
        if (is_le == 0) {
            return (res=0);
        }
        let (is_nn) = signed_nn(a=a);
        return (res=is_nn);
    }

    // Unsigned integer division between two integers. Returns the quotient and the remainder.
    // Conforms to EVM specifications: division by 0 yields 0.
    func unsigned_div_rem{range_check_ptr}(a: Uint384, div: Uint384) -> (
        quotient: Uint384, remainder: Uint384
    ) {
        alloc_locals;
        local quotient: Uint384;
        local remainder: Uint384;

        // If div == 0, return (0, 0, 0).
        if (div.d0 + div.d1 + div.d2 == 0) {
            return (quotient=Uint384(0, 0, 0), remainder=Uint384(0, 0, 0));
        }

        %{
            def split(num: int, num_bits_shift: int, length: int):
                a = []
                for _ in range(length):
                    a.append( num & ((1 << num_bits_shift) - 1) )
                    num = num >> num_bits_shift
                return tuple(a)

            def pack(z, num_bits_shift: int) -> int:
                limbs = (z.d0, z.d1, z.d2)
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

            a = pack(ids.a, num_bits_shift = 128)
            div = pack(ids.div, num_bits_shift = 128)
            quotient, remainder = divmod(a, div)

            quotient_split = split(quotient, num_bits_shift=128, length=3)
            assert len(quotient_split) == 3

            ids.quotient.d0 = quotient_split[0]
            ids.quotient.d1 = quotient_split[1]
            ids.quotient.d2 = quotient_split[2]

            remainder_split = split(remainder, num_bits_shift=128, length=3)
            ids.remainder.d0 = remainder_split[0]
            ids.remainder.d1 = remainder_split[1]
            ids.remainder.d2 = remainder_split[2]
        %}
        check(quotient);
        check(remainder);
        let (res_mul: Uint384, carry: Uint384) = mul_d(quotient, div);
        assert carry = Uint384(0, 0, 0);

        let (check_val: Uint384, add_carry: felt) = _add_no_uint384_check(res_mul, remainder);
        assert check_val = a;
        assert add_carry = 0;

        let (is_valid) = lt(remainder, div);
        assert is_valid = 1;
        return (quotient=quotient, remainder=remainder);
    }

    // Unsigned integer division between two integers. Returns the quotient and the remainder.
    func unsigned_div_rem_expanded{range_check_ptr}(a: Uint384, div: Uint384_expand) -> (
        quotient: Uint384, remainder: Uint384
    ) {
        alloc_locals;
        local quotient: Uint384;
        local remainder: Uint384;

        let div2 = Uint384(div.b01, div.b23, div.b45);

        %{
            def split(num: int, num_bits_shift: int, length: int):
                a = []
                for _ in range(length):
                    a.append( num & ((1 << num_bits_shift) - 1) )
                    num = num >> num_bits_shift
                return tuple(a)

            def pack(z, num_bits_shift: int) -> int:
                limbs = (z.d0, z.d1, z.d2)
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

            def pack2(z, num_bits_shift: int) -> int:
                limbs = (z.b01, z.b23, z.b45)
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

            a = pack(ids.a, num_bits_shift = 128)
            div = pack2(ids.div, num_bits_shift = 128)
            quotient, remainder = divmod(a, div)

            quotient_split = split(quotient, num_bits_shift=128, length=3)
            assert len(quotient_split) == 3

            ids.quotient.d0 = quotient_split[0]
            ids.quotient.d1 = quotient_split[1]
            ids.quotient.d2 = quotient_split[2]

            remainder_split = split(remainder, num_bits_shift=128, length=3)
            ids.remainder.d0 = remainder_split[0]
            ids.remainder.d1 = remainder_split[1]
            ids.remainder.d2 = remainder_split[2]
        %}
        check(quotient);
        check(remainder);
        let (res_mul: Uint384, carry: Uint384) = mul_expanded(quotient, div);
        assert carry = Uint384(0, 0, 0);

        let (check_val: Uint384, add_carry: felt) = _add_no_uint384_check(res_mul, remainder);
        assert check_val = a;
        assert add_carry = 0;

        let (is_valid) = lt(remainder, div2);
        assert is_valid = 1;
        return (quotient=quotient, remainder=remainder);
    }

    // Unsigned integer division by 2. Returns the quotient and the remainder.
    func unsigned_div_rem2{range_check_ptr}(a: Uint384) -> (quotient: Uint384, remainder: felt) {
        alloc_locals;
        local quotient: Uint384;
        local remainder: felt;

        %{
            def split(num: int, num_bits_shift: int, length: int):
                a = []
                for _ in range(length):
                    a.append( num & ((1 << num_bits_shift) - 1) )
                    num = num >> num_bits_shift
                return tuple(a)

            def pack(z, num_bits_shift: int) -> int:
                limbs = (z.d0, z.d1, z.d2)
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

            a = pack(ids.a, num_bits_shift = 128)
            quotient, remainder = divmod(a, 2)

            quotient_split = split(quotient, num_bits_shift=128, length=3)
            assert len(quotient_split) == 3

            ids.quotient.d0 = quotient_split[0]
            ids.quotient.d1 = quotient_split[1]
            ids.quotient.d2 = quotient_split[2]

            ids.remainder = remainder
        %}
        check(quotient);
        let (res_mul: Uint384, carry: felt) = add(quotient, quotient);
        assert carry = 0;

        let (check_val: Uint384, add_carry: felt) = _add_no_uint384_check(
            res_mul, Uint384(remainder, 0, 0)
        );
        assert check_val = a;
        assert add_carry = 0;

        assert remainder = remainder * remainder;
        return (quotient=quotient, remainder=remainder);
    }

    // Returns the bitwise NOT of an integer.
    func not(a: Uint384) -> (res: Uint384) {
        return (Uint384(d0=ALL_ONES - a.d0, d1=ALL_ONES - a.d1, d2=ALL_ONES - a.d2),);
    }

    // Returns the negation of an integer.
    // Note that the negation of -2**383 is -2**383.
    func neg{range_check_ptr}(a: Uint384) -> (res: Uint384) {
        let (not_num) = not(a);
        let (res, _) = add(not_num, Uint384(d0=1, d1=0, d2=0));
        return (res,);
    }

    func neg_b{range_check_ptr}(a: Uint384) -> (res: Uint384) {
        let (res, _) = sub_b(Uint384(d0=0, d1=0, d2=0), a);
        return (res,);
    }

    // Conditionally negates an integer.
    func cond_neg{range_check_ptr}(a: Uint384, should_neg) -> (res: Uint384) {
        if (should_neg != 0) {
            return neg(a);
        } else {
            return (res=a);
        }
    }

    // Signed integer division between two integers. Returns the quotient and the remainder.
    // Conforms to EVM specifications.
    // See ethereum yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf, page 29).
    // Note that the remainder may be negative if one of the inputs is negative and that
    // (-2**383) / (-1) = -2**383 because 2**383 is out of range.
    func signed_div_rem{range_check_ptr}(a: Uint384, div: Uint384) -> (
        quot: Uint384, rem: Uint384
    ) {
        alloc_locals;

        // When div=-1, simply return -a.
        if (div.d0 == SHIFT - 1) {
            if (div.d1 == SHIFT - 1) {
                if (div.d2 == SHIFT - 1) {
                    let (quot) = neg(a);
                    return (quot, Uint384(0, 0, 0));
                }
            }
        }

        // Take the absolute value of a.
        local a_sign = is_le(2 ** 127, a.d2);
        local range_check_ptr = range_check_ptr;
        let (local a) = cond_neg(a, should_neg=a_sign);

        // Take the absolute value of div.
        local div_sign = is_le(2 ** 127, div.d2);
        local range_check_ptr = range_check_ptr;
        let (div) = cond_neg(div, should_neg=div_sign);

        // Unsigned division.
        let (local quot, local rem) = unsigned_div_rem(a, div);
        local range_check_ptr = range_check_ptr;

        // Fix the remainder according to the sign of a.
        let (rem) = cond_neg(rem, should_neg=a_sign);

        // Fix the quotient according to the signs of a and div.
        if (a_sign == div_sign) {
            return (quot=quot, rem=rem);
        }
        let (local quot_neg) = neg(quot);

        return (quot=quot_neg, rem=rem);
    }

    // Subtracts two integers. Returns the result as a 384-bit integer.
    func sub{range_check_ptr}(a: Uint384, b: Uint384) -> Uint384 {
        let (b_neg) = neg(b);
        let (res, _) = add(a, b_neg);
        return (res,);
    }

    // Subtracts two integers. Returns the result as a 384-bit integer
    // and a sign felt that is 1 if the result is non-negative, convention based on signed_nn
    func sub_b{range_check_ptr}(a: Uint384, b: Uint384) -> Uint384 {
        alloc_locals;
        local res: Uint384;
        %{
            def split(num: int, num_bits_shift: int = 128, length: int = 3):
                a = []
                for _ in range(length):
                    a.append( num & ((1 << num_bits_shift) - 1) )
                    num = num >> num_bits_shift
                return tuple(a)

            def pack(z, num_bits_shift: int = 128) -> int:
                limbs = (z.d0, z.d1, z.d2)
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

            a = pack(ids.a)
            b = pack(ids.b)
            res = (a - b)%2**384
            res_split = split(res)
            ids.res.d0 = res_split[0]
            ids.res.d1 = res_split[1]
            ids.res.d2 = res_split[2]
        %}
        check(res);
        let aa: Uint384 = _add_no_uint384_check(res, b);
        assert aa = a;
        return res;
    }

    // Return true if both integers are equal.
    func eq(a: Uint384, b: Uint384) -> (res: felt) {
        if (a.d2 != b.d2) {
            return (0,);
        }
        if (a.d1 != b.d1) {
            return (0,);
        }
        if (a.d0 != b.d0) {
            return (0,);
        }
        return (1,);
    }

    // Return true if a = 0
    func is_zero(a: Uint384) -> (res: felt) {
        let (is_a_zero) = eq(a, Uint384(0, 0, 0));
        if (is_a_zero == 1) {
            return (1,);
        } else {
            return (0,);
        }
    }

    // Computes the bitwise XOR of 2 uint256 integers.
    func xor{bitwise_ptr: BitwiseBuiltin*}(a: Uint384, b: Uint384) -> (res: Uint384) {
        let (d0) = bitwise_xor(a.d0, b.d0);
        let (d1) = bitwise_xor(a.d1, b.d1);
        let (d2) = bitwise_xor(a.d2, b.d2);
        return (Uint384(d0, d1, d2),);
    }

    // Computes the bitwise AND of 2 uint384 integers.
    // NOTE: `and` will be a reserved word in future Cairo versions, so we cannot call this function `and`
    func bit_and{bitwise_ptr: BitwiseBuiltin*}(a: Uint384, b: Uint384) -> (res: Uint384) {
        let (d0) = bitwise_and(a.d0, b.d0);
        let (d1) = bitwise_and(a.d1, b.d1);
        let (d2) = bitwise_and(a.d2, b.d2);
        return (Uint384(d0, d1, d2),);
    }

    // Computes the bitwise OR of 2 uint384 integers.
    func or{bitwise_ptr: BitwiseBuiltin*}(a: Uint384, b: Uint384) -> (res: Uint384) {
        let (d0) = bitwise_or(a.d0, b.d0);
        let (d1) = bitwise_or(a.d1, b.d1);
        let (d2) = bitwise_or(a.d2, b.d2);
        return (Uint384(d0, d1, d2),);
    }

    // Computes 2**exp % 2**384 as a uint384 integer.
    func pow2{range_check_ptr}(exp: Uint384) -> (res: Uint384) {
        // If exp >= 384, the result will be zero modulo 2**384.
        // We can hence assume that exp.d0 = exp.d1 = exp.d2 = 0
        let (res) = lt(exp, Uint384(384, 0, 0));
        if (res == 0) {
            return (Uint384(0, 0, 0),);
        }

        let res = is_le(exp.d0, 127);
        if (res != 0) {
            let (x) = pow(2, exp.d0);
            return (Uint384(x, 0, 0),);
        } else {
            let res = is_le(exp.d0, 255);
            if (res != 0) {
                let (x) = pow(2, exp.d0 - 128);
                return (Uint384(0, x, 0),);
            } else {
                let (x) = pow(2, exp.d0 - 256);
                return (Uint384(0, 0, x),);
            }
        }
    }

    // Computes the logical left shift of a uint384 integer.
    func shl{range_check_ptr}(a: Uint384, b: Uint384) -> (res: Uint384) {
        let (c) = pow2(b);
        let (res, _) = mul_d(a, c);
        return (res,);
    }

    // Computes the logical right shift of a uint384 integer.
    func shr{range_check_ptr}(a: Uint384, b: Uint384) -> (res: Uint384) {
        let (c) = pow2(b);
        let (res, _) = unsigned_div_rem(a, c);
        return (res,);
    }

    // Reverses byte endianness of a uint384 integer.
    func reverse_endian{bitwise_ptr: BitwiseBuiltin*}(num: Uint384) -> (res: Uint384) {
        alloc_locals;
        let (d0) = word_reverse_endian(num.d0);
        let (local d1) = word_reverse_endian(num.d1);
        let (d2) = word_reverse_endian(num.d2);

        return (res=Uint384(d0=d2, d1=d1, d2=d0));
    }
}

// Copied from Cairo's common library since for some reason I couldn't import it
func word_reverse_endian{bitwise_ptr: BitwiseBuiltin*}(word: felt) -> (res: felt) {
    // Step 1.
    assert bitwise_ptr[0].x = word;
    assert bitwise_ptr[0].y = 0x00ff00ff00ff00ff00ff00ff00ff00ff;
    tempvar word = word + (2 ** 16 - 1) * bitwise_ptr[0].x_and_y;
    // Step 2.
    assert bitwise_ptr[1].x = word;
    assert bitwise_ptr[1].y = 0x00ffff0000ffff0000ffff0000ffff00;
    tempvar word = word + (2 ** 32 - 1) * bitwise_ptr[1].x_and_y;
    // Step 3.
    assert bitwise_ptr[2].x = word;
    assert bitwise_ptr[2].y = 0x00ffffffff00000000ffffffff000000;
    tempvar word = word + (2 ** 64 - 1) * bitwise_ptr[2].x_and_y;
    // Step 4.
    assert bitwise_ptr[3].x = word;
    assert bitwise_ptr[3].y = 0x00ffffffffffffffff00000000000000;
    tempvar word = word + (2 ** 128 - 1) * bitwise_ptr[3].x_and_y;
    let bitwise_ptr = bitwise_ptr + 4 * BitwiseBuiltin.SIZE;
    return (res=word / 2 ** (8 + 16 + 32 + 64));
}
