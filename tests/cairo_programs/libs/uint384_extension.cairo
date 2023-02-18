from starkware.cairo.common.bitwise import bitwise_and, bitwise_or, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import assert_in_range, assert_le, assert_nn_le, assert_not_zero
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.pow import pow
from starkware.cairo.common.registers import get_ap, get_fp_and_pc
// Import uint384 files (path may change in the future)
from tests.cairo_programs.libs.uint384 import uint384_lib, Uint384, Uint384_expand, ALL_ONES

// Functions for operating 384-bit integers with 768-bit integers

// Represents an integer in the range [0, 2^768).
// NOTE: As in Uint256 and Uint384, all functions expect each d_0, d_1, ..., d_5 to be less than 2**128
struct Uint768 {
    d0: felt,
    d1: felt,
    d2: felt,
    d3: felt,
    d4: felt,
    d5: felt,
}

const HALF_SHIFT = 2 ** 64;

namespace uint384_extension_lib {
    // Verifies that the given integer is valid.
    func check{range_check_ptr}(a: Uint768) {
        [range_check_ptr] = a.d0;
        [range_check_ptr + 1] = a.d1;
        [range_check_ptr + 2] = a.d2;
        [range_check_ptr + 3] = a.d3;
        [range_check_ptr + 4] = a.d4;
        [range_check_ptr + 5] = a.d5;
        let range_check_ptr = range_check_ptr + 6;
        return ();
    }

    func eq(a: Uint768, b: Uint768) -> felt {
        if (a.d5 != b.d5) {
            return 0;
        }
        if (a.d4 != b.d4) {
            return 0;
        }
        if (a.d3 != b.d3) {
            return 0;
        }

        if (a.d2 != b.d2) {
            return 0;
        }
        if (a.d1 != b.d1) {
            return 0;
        }
        if (a.d0 != b.d0) {
            return 0;
        }
        return 1;
    }

    // Adds a 768-bit integer and a 384-bit integer. Returns the result as a 768-bit integer and the (1-bit) carry.
    func add_uint768_and_uint384{range_check_ptr}(a: Uint768, b: Uint384) -> (
        res: Uint768, carry: felt
    ) {
        alloc_locals;

        let a_low = Uint384(d0=a.d0, d1=a.d1, d2=a.d2);
        let a_high = Uint384(d0=a.d3, d1=a.d4, d2=a.d5);

        let (sum_low, carry0) = uint384_lib.add(a_low, b);

        local res: Uint768;

        res.d0 = sum_low.d0;
        res.d1 = sum_low.d1;
        res.d2 = sum_low.d2;

        let (a_high_plus_carry, carry1) = uint384_lib.add(a_high, Uint384(carry0, 0, 0));

        res.d3 = a_high_plus_carry.d0;
        res.d4 = a_high_plus_carry.d1;
        res.d5 = a_high_plus_carry.d2;

        return (res, carry1);
    }

    // Multiplies a 768-bit integer and a 384-bit integer.
    // Returns the result (1152 bits) as a 768-bit integer (the lower bits of the result) and
    // a 384-bit integer (the higher bits of the result)
    func mul_uint768_by_uint384{range_check_ptr}(a: Uint768, b: Uint384) -> (
        low: Uint768, high: Uint384
    ) {
        alloc_locals;
        let a_low = Uint384(d0=a.d0, d1=a.d1, d2=a.d2);
        let a_high = Uint384(d0=a.d3, d1=a.d4, d2=a.d5);

        let (low_low, low_high) = uint384_lib.mul_d(a_low, b);
        let (high_low, high_high) = uint384_lib.mul_d(a_high, b);

        let (sum_low_high_and_high_low: Uint384, carry0: felt) = uint384_lib.add(
            low_high, high_low
        );

        assert_le(carry0, 2);

        let (high_high_with_carry: Uint384, carry1: felt) = uint384_lib.add(
            high_high, Uint384(carry0, 0, 0)
        );
        assert carry1 = 0;

        local res_low: Uint768;
        local res_high: Uint384;

        res_low.d0 = low_low.d0;
        res_low.d1 = low_low.d1;
        res_low.d2 = low_low.d2;

        res_low.d3 = sum_low_high_and_high_low.d0;
        res_low.d4 = sum_low_high_and_high_low.d1;
        res_low.d5 = sum_low_high_and_high_low.d2;

        res_high.d0 = high_high_with_carry.d0;
        res_high.d1 = high_high_with_carry.d1;
        res_high.d2 = high_high_with_carry.d2;

        return (low=res_low, high=res_high);
    }

    func mul_uint768_by_uint384_c{range_check_ptr}(a: Uint768, b: Uint384) -> (
        low: Uint768, high: Uint384
    ) {
        let (a0, a1) = uint384_lib.split_64(a.d0);
        let (a2, a3) = uint384_lib.split_64(a.d1);
        let (a4, a5) = uint384_lib.split_64(a.d2);
        let (a6, a7) = uint384_lib.split_64(a.d3);
        let (a8, a9) = uint384_lib.split_64(a.d4);
        let (a10, a11) = uint384_lib.split_64(a.d5);
        let (b0, b1) = uint384_lib.split_64(b.d0);
        let (b2, b3) = uint384_lib.split_64(b.d1);
        let (b4, b5) = uint384_lib.split_64(b.d2);

        let (res0, carry) = uint384_lib.split_128(a0 * b0 + (a1 * b0 + a0 * b1) * HALF_SHIFT);
        let (res2, carry) = uint384_lib.split_128(
            a2 * b0 + a1 * b1 + a0 * b2 + (a3 * b0 + a2 * b1 + a1 * b2 + a0 * b3) * HALF_SHIFT +
            carry,
        );
        let (res4, carry) = uint384_lib.split_128(
            a4 * b0 + a3 * b1 + a2 * b2 + a1 * b3 + a0 * b4 + (
                a5 * b0 + a4 * b1 + a3 * b2 + a2 * b3 + a1 * b4 + a0 * b5
            ) * HALF_SHIFT + carry,
        );
        let (res6, carry) = uint384_lib.split_128(
            a6 * b0 + a5 * b1 + a4 * b2 + a3 * b3 + a2 * b4 + a1 * b5 + (
                a7 * b0 + a6 * b1 + a5 * b2 + a4 * b3 + a3 * b4 + a2 * b5
            ) * HALF_SHIFT + carry,
        );
        let (res8, carry) = uint384_lib.split_128(
            a8 * b0 + a7 * b1 + a6 * b2 + a5 * b3 + a4 * b4 + a3 * b5 + (
                a9 * b0 + a8 * b1 + a7 * b2 + a6 * b3 + a5 * b4 + a4 * b5
            ) * HALF_SHIFT + carry,
        );
        let (res10, carry) = uint384_lib.split_128(
            a10 * b0 + a9 * b1 + a8 * b2 + a7 * b3 + a6 * b4 + a5 * b5 + (
                a11 * b0 + a10 * b1 + a9 * b2 + a8 * b3 + a7 * b4 + a6 * b5
            ) * HALF_SHIFT + carry,
        );
        let (res12, carry) = uint384_lib.split_128(
            a11 * b1 + a10 * b2 + a9 * b3 + a8 * b4 + a7 * b5 + (
                a11 * b2 + a10 * b3 + a9 * b4 + a8 * b5
            ) * HALF_SHIFT + carry,
        );
        let (res14, carry) = uint384_lib.split_128(
            a11 * b3 + a10 * b4 + a9 * b5 + (a11 * b4 + a10 * b5) * HALF_SHIFT + carry
        );
        // let (res16, carry) = split_64(a11 * b5 + carry)

        return (
            low=Uint768(d0=res0, d1=res2, d2=res4, d3=res6, d4=res8, d5=res10),
            high=Uint384(d0=res12, d1=res14, d2=a11 * b5 + carry),
        );
    }

    func mul_uint768_by_uint384_d{range_check_ptr}(a: Uint768, b: Uint384) -> (
        low: Uint768, high: Uint384
    ) {
        alloc_locals;
        let (a0, a1) = uint384_lib.split_64(a.d0);
        let (a2, a3) = uint384_lib.split_64(a.d1);
        let (a4, a5) = uint384_lib.split_64(a.d2);
        let (a6, a7) = uint384_lib.split_64(a.d3);
        let (a8, a9) = uint384_lib.split_64(a.d4);
        let (a10, a11) = uint384_lib.split_64(a.d5);
        let (b0, b1) = uint384_lib.split_64(b.d0);
        let (b2, b3) = uint384_lib.split_64(b.d1);
        let (b4, b5) = uint384_lib.split_64(b.d2);

        local B0 = b0 * HALF_SHIFT;
        local b12 = b1 + b2 * HALF_SHIFT;
        local b34 = b3 + b4 * HALF_SHIFT;

        let (res0, carry) = uint384_lib.split_128(a1 * B0 + a0 * b.d0);
        let (res2, carry) = uint384_lib.split_128(
            a3 * B0 + a2 * b.d0 + a1 * b12 + a0 * b.d1 + carry
        );
        let (res4, carry) = uint384_lib.split_128(
            a5 * B0 + a4 * b.d0 + a3 * b12 + a2 * b.d1 + a1 * b34 + a0 * b.d2 + carry
        );
        let (res6, carry) = uint384_lib.split_128(
            a7 * B0 + a6 * b.d0 + a5 * b12 + a4 * b.d1 + a3 * b34 + a2 * b.d2 + a1 * b5 + carry
        );
        let (res8, carry) = uint384_lib.split_128(
            a9 * B0 + a8 * b.d0 + a7 * b12 + a6 * b.d1 + a5 * b34 + a4 * b.d2 + a3 * b5 + carry
        );
        let (res10, carry) = uint384_lib.split_128(
            a11 * B0 + a10 * b.d0 + a9 * b12 + a8 * b.d1 + a7 * b34 + a6 * b.d2 + a5 * b5 + carry
        );
        let (res12, carry) = uint384_lib.split_128(
            a11 * b12 + a10 * b.d1 + a9 * b34 + a8 * b.d2 + a7 * b5 + carry
        );
        let (res14, carry) = uint384_lib.split_128(a11 * b34 + a10 * b.d2 + a9 * b5 + carry);
        // let (res16, carry) = split_64(a11 * b5 + carry)

        return (
            low=Uint768(d0=res0, d1=res2, d2=res4, d3=res6, d4=res8, d5=res10),
            high=Uint384(d0=res12, d1=res14, d2=a11 * b5 + carry),
        );
    }

    func mul_uint768_by_uint384_expanded{range_check_ptr}(a: Uint768, b: Uint384_expand) -> (
        low: Uint768, high: Uint384
    ) {
        let (a0, a1) = uint384_lib.split_64(a.d0);
        let (a2, a3) = uint384_lib.split_64(a.d1);
        let (a4, a5) = uint384_lib.split_64(a.d2);
        let (a6, a7) = uint384_lib.split_64(a.d3);
        let (a8, a9) = uint384_lib.split_64(a.d4);
        let (a10, a11) = uint384_lib.split_64(a.d5);

        let (res0, carry) = uint384_lib.split_128(a1 * b.B0 + a0 * b.b01);
        let (res2, carry) = uint384_lib.split_128(
            a3 * b.B0 + a2 * b.b01 + a1 * b.b12 + a0 * b.b23 + carry
        );
        let (res4, carry) = uint384_lib.split_128(
            a5 * b.B0 + a4 * b.b01 + a3 * b.b12 + a2 * b.b23 + a1 * b.b34 + a0 * b.b45 + carry
        );
        let (res6, carry) = uint384_lib.split_128(
            a7 * b.B0 + a6 * b.b01 + a5 * b.b12 + a4 * b.b23 + a3 * b.b34 + a2 * b.b45 + a1 * b.b5 +
            carry,
        );
        let (res8, carry) = uint384_lib.split_128(
            a9 * b.B0 + a8 * b.b01 + a7 * b.b12 + a6 * b.b23 + a5 * b.b34 + a4 * b.b45 + a3 * b.b5 +
            carry,
        );
        let (res10, carry) = uint384_lib.split_128(
            a11 * b.B0 + a10 * b.b01 + a9 * b.b12 + a8 * b.b23 + a7 * b.b34 + a6 * b.b45 + a5 *
            b.b5 + carry,
        );
        let (res12, carry) = uint384_lib.split_128(
            a11 * b.b12 + a10 * b.b23 + a9 * b.b34 + a8 * b.b45 + a7 * b.b5 + carry
        );
        let (res14, carry) = uint384_lib.split_128(a11 * b.b34 + a10 * b.b45 + a9 * b.b5 + carry);
        // let (res16, carry) = split_64(a11 * b.b5 + carry)

        return (
            low=Uint768(d0=res0, d1=res2, d2=res4, d3=res6, d4=res8, d5=res10),
            high=Uint384(d0=res12, d1=res14, d2=a11 * b.b5 + carry),
        );
    }

    func mul_uint768_by_uint384_kar{range_check_ptr}(a: Uint768, b: Uint384) -> (
        low: Uint768, high: Uint384
    ) {
        alloc_locals;
        let (a0, a1) = uint384_lib.split_64(a.d0);
        let (a2, a3) = uint384_lib.split_64(a.d1);
        let (a4, a5) = uint384_lib.split_64(a.d2);
        let (a6, a7) = uint384_lib.split_64(a.d3);
        let (a8, a9) = uint384_lib.split_64(a.d4);
        let (a10, a11) = uint384_lib.split_64(a.d5);
        let (b0, b1) = uint384_lib.split_64(b.d0);
        let (b2, b3) = uint384_lib.split_64(b.d1);
        let (b4, b5) = uint384_lib.split_64(b.d2);

        local A0 = a0 + a3;
        local A1 = a1 + a4;
        local A2 = a2 + a5;

        local A6 = a6 + a9;
        local A7 = a7 + a10;
        local A8 = a8 + a11;

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

        local e6 = a6 * b0;
        local e7 = a7 * b0 + a6 * b1;
        local e8 = a8 * b0 + a7 * b1 + a6 * b2;
        local e9 = a8 * b1 + a7 * b2;
        local e10 = a8 * b2;

        local e12 = a9 * b3;
        local e13 = a10 * b3 + a9 * b4;
        local e14 = a11 * b3 + a10 * b4 + a9 * b5;
        local e15 = a11 * b4 + a10 * b5;
        local e16 = a11 * b5;

        let (res0, carry) = uint384_lib.split_128(d0 + d1 * HALF_SHIFT);
        let (res2, carry) = uint384_lib.split_128(
            d2 + (d3 + A0 * B0 - d0 - d6) * HALF_SHIFT + carry
        );
        let (res4, carry) = uint384_lib.split_128(
            d4 + A1 * B0 + A0 * B1 - d1 - d7 + (A2 * B0 + A1 * B1 + A0 * B2 - d2 - d8) *
            HALF_SHIFT + carry,
        );
        let (res6, carry) = uint384_lib.split_128(
            d6 + e6 + A2 * B1 + A1 * B2 - d3 - d9 + (d7 + e7 + A2 * B2 - d4 - d10) * HALF_SHIFT +
            carry,
        );
        let (res8, carry) = uint384_lib.split_128(
            d8 + e8 + (d9 + e9 + A6 * B0 - e6 - e12) * HALF_SHIFT + carry
        );
        let (res10, carry) = uint384_lib.split_128(
            d10 + e10 + A7 * B0 + A6 * B1 - e7 - e13 + (A8 * B0 + A7 * B1 + A6 * B2 - e8 - e14) *
            HALF_SHIFT + carry,
        );
        let (res12, carry) = uint384_lib.split_128(
            e12 + A8 * B1 + A7 * B2 - e9 - e15 + (e13 + A8 * B2 - e10 - e16) * HALF_SHIFT + carry
        );
        let (res14, carry) = uint384_lib.split_128(e14 + e15 * HALF_SHIFT + carry);
        // let (res16, carry) = split_64(e16 + carry)

        return (
            low=Uint768(d0=res0, d1=res2, d2=res4, d3=res6, d4=res8, d5=res10),
            high=Uint384(d0=res12, d1=res14, d2=e16 + carry),
        );
    }

    func mul_uint768_by_uint384_kar_d{range_check_ptr}(a: Uint768, b: Uint384) -> (
        low: Uint768, high: Uint384
    ) {
        alloc_locals;
        let (a0, a1) = uint384_lib.split_64(a.d0);
        let (a2, a3) = uint384_lib.split_64(a.d1);
        let (a4, a5) = uint384_lib.split_64(a.d2);
        let (a6, a7) = uint384_lib.split_64(a.d3);
        let (a8, a9) = uint384_lib.split_64(a.d4);
        let (a10, a11) = uint384_lib.split_64(a.d5);
        let (b0, b1) = uint384_lib.split_64(b.d0);
        let (b2, b3) = uint384_lib.split_64(b.d1);
        let (b4, b5) = uint384_lib.split_64(b.d2);

        local A0 = a0 + a3;
        local A1 = a1 + a4;
        local A2 = a2 + a5;

        local A6 = a6 + a9;
        local A7 = a7 + a10;
        local A8 = a8 + a11;

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

        local e6 = a6 * b0;
        local e7 = a7 * b0 + a6 * b1;
        local e8 = a8 * b0 + a7 * b1 + a6 * b2;
        local e9 = a8 * b1 + a7 * b2;
        local e10 = a8 * b2;

        local e12 = a9 * b3;
        local e13 = a10 * b3 + a9 * b4;
        local e14 = a11 * b3 + a10 * b4 + a9 * b5;
        local e15 = a11 * b4 + a10 * b5;
        local e16 = a11 * b5;

        local B01 = B0 + B1 * HALF_SHIFT;
        local B12 = B1 + B2 * HALF_SHIFT;

        let (res0, carry) = uint384_lib.split_128(d0 + d1 * HALF_SHIFT);
        let (res2, carry) = uint384_lib.split_128(
            d2 + (d3 + A0 * B0 - d0 - d6) * HALF_SHIFT + carry
        );
        let (res4, carry) = uint384_lib.split_128(
            d4 + A1 * B01 + A0 * B12 - d1 - d7 + (A2 * B0 - d2 - d8) * HALF_SHIFT + carry
        );
        let (res6, carry) = uint384_lib.split_128(
            d6 + e6 + A2 * B12 + A1 * B2 - d3 - d9 + (d7 + e7 - d4 - d10) * HALF_SHIFT + carry
        );
        let (res8, carry) = uint384_lib.split_128(
            d8 + e8 + (d9 + e9 + A6 * B0 - e6 - e12) * HALF_SHIFT + carry
        );
        let (res10, carry) = uint384_lib.split_128(
            d10 + e10 + A7 * B01 + A6 * B12 - e7 - e13 + (A8 * B0 - e8 - e14) * HALF_SHIFT + carry
        );
        let (res12, carry) = uint384_lib.split_128(
            e12 + A8 * B12 + A7 * B2 - e9 - e15 + (e13 - e10 - e16) * HALF_SHIFT + carry
        );
        let (res14, carry) = uint384_lib.split_128(e14 + e15 * HALF_SHIFT + carry);
        // let (res16, carry) = split_64(e16 + carry)

        return (
            low=Uint768(d0=res0, d1=res2, d2=res4, d3=res6, d4=res8, d5=res10),
            high=Uint384(d0=res12, d1=res14, d2=e16 + carry),
        );
    }

    func Toom25_eval(m0: felt, m1: felt, m2: felt) -> (p1: felt, pm1: felt) {
        alloc_locals;
        local p = m0 + m2;
        return (p + m1, p - m1);
    }

    func unit256_mul_split(
        x0: felt, x1: felt, x2: felt, x3: felt, y0: felt, y1: felt, y2: felt, y3: felt
    ) -> (z0: felt, z2: felt, z4: felt, z6: felt) {
        return (
            x0 * y0 + (x1 * y0 + x0 * y1) * HALF_SHIFT,
            x2 * y0 + x1 * y1 + x0 * y2 + (x3 * y0 + x2 * y1 + x1 * y2 + x0 * y3) * HALF_SHIFT,
            x3 * y1 + x2 * y2 + x1 * y3 + (x3 * y2 + x2 * y3) * HALF_SHIFT,
            x3 * y3,
        );
    }

    func unit256_mul_splitb(x0: felt, x1: felt, x2: felt, x3: felt, y0: felt, y1: felt) -> (
        z0: felt, z2: felt, z4: felt
    ) {
        return (
            x0 * y0 + (x1 * y0 + x0 * y1) * HALF_SHIFT,
            x2 * y0 + x1 * y1 + (x3 * y0 + x2 * y1) * HALF_SHIFT,
            x3 * y1,
        );
    }

    func Toom25_interp(z0: felt, z4: felt, p1: felt, pm1: felt) -> (z1: felt, z2: felt) {
        alloc_locals;
        const HALF = 1 / 2;
        local r2: felt;
        %{
            p = 2**251 + 17*2**192 + 1
            ids.r2 = ((ids.p1 + ids.pm1)*ids.HALF)%p
        %}  // aparently hints don't automatically cast to felt.
        // assert p1 = r2 + r1;
        local r1 = p1 - r2;
        assert pm1 = r2 - r1;
        return (r1 - z4, r2 - z0);
    }

    func mul_uint768_by_uint384_Toom25{range_check_ptr}(a: Uint768, b: Uint384) -> (
        low: Uint768, high: Uint384
    ) {
        alloc_locals;
        let (a0, a1) = uint384_lib.split_64(a.d0);
        let (a2, a3) = uint384_lib.split_64(a.d1);
        let (a4, a5) = uint384_lib.split_64(a.d2);
        let (a6, a7) = uint384_lib.split_64(a.d3);
        let (a8, a9) = uint384_lib.split_64(a.d4);
        let (a10, a11) = uint384_lib.split_64(a.d5);
        let (b0, b1) = uint384_lib.split_64(b.d0);
        let (b2, b3) = uint384_lib.split_64(b.d1);
        let (b4, b5) = uint384_lib.split_64(b.d2);

        // let (pa1, pam1) = Toom25_eval(a0, a4, a8);
        local p1 = a0 + a8;
        local pa1 = p1 + a4;
        local pam1 = p1 - a4;
        // let (pa1b, pam1b) = Toom25_eval(a1, a5, a9);
        local p1b = a1 + a9;
        local pa1b = p1b + a5;
        local pam1b = p1b - a5;
        // let (pa1c, pam1c) = Toom25_eval(a2, a6, a10);
        local p1c = a2 + a10;
        local pa1c = p1c + a6;
        local pam1c = p1c - a6;
        // let (pa1d, pam1d) = Toom25_eval(a3, a7, a11);
        local p1d = a3 + a11;
        local pa1d = p1d + a7;
        local pam1d = p1d - a7;

        local pb1 = b0 + b4;
        local pbm1 = b0 - b4;
        local pb1b = b1 + b5;
        local pbm1b = b1 - b5;

        local B0 = b0 * HALF_SHIFT;
        local B2 = b2 * HALF_SHIFT;
        local b12 = b1 + B2;
        local B4 = b4 * HALF_SHIFT;
        // let (X0, Y2, Z4, w6) = unit256_mul_split(a0, a1, a2, a3, b0, b1, b2, b3);
        // local X0 = a0*b0 + (a1*b0 + a0*b1) * HALF_SHIFT;
        local X0 = a0 * b.d0 + a1 * B0;
        // local Y2 = a2*b0 + a1*b1 + a0*b2 + (a3*b0 + a2*b1 + a1*b2 + a0*b3) * HALF_SHIFT;
        local Y2 = a2 * b.d0 + a1 * b12 + a0 * b.d1 + a3 * B0;
        // local Z4 = a3*b1 + a2*b2 + a1*b3 + (a3*b2 + a2*b3) * HALF_SHIFT;
        local Z4 = a3 * b12 + a2 * b.d1 + a1 * b3;
        local w6 = a3 * b3;

        // let (X12, Y14, Z16) = unit256_mul_splitb(a8, a9, a10, a11, b4, b5);
        // local X12 = a8*b4 + (a9*b4 + a8*b5) * HALF_SHIFT;
        local X12 = a8 * b.d2 + a9 * B4;
        // local Y14 = a10*b4 + a9*b5 + (a11*b4 + a10*b5) * HALF_SHIFT;
        local Y14 = a10 * b.d2 + a9 * b5 + a11 * B4;
        local Z16 = a11 * b5;

        local Pb1 = pb1 * HALF_SHIFT;
        local pb1ab = pb1 + pb1b * HALF_SHIFT;
        local pb1bc = pb1b + B2;
        // let (r1, r1b, r1c, r1d) = unit256_mul_split(pa1, pa1b, pa1c, pa1d, pb1, pb1b, b2, b3);
        local r1 = pa1 * pb1ab + pa1b * Pb1;
        // local r1b = pa1c*pb1 + pa1b*pb1b + pa1*b2 + (pa1d*pb1 + pa1c*pb1b + pa1b*b2 + pa1*b3) * HALF_SHIFT;
        local r1b = pa1c * pb1ab + pa1b * pb1bc + pa1 * b.d1 + pa1d * Pb1;
        // local r1c = pa1d*pb1b + pa1c*b2 + pa1b*b3 + (pa1d*b2 + pa1c*b3) * HALF_SHIFT;
        local r1c = pa1d * pb1bc + pa1c * b.d1 + pa1b * b3;
        local r1d = pa1d * b3;

        local Pbm1 = pbm1 * HALF_SHIFT;
        local pbm1ab = pbm1 + pbm1b * HALF_SHIFT;
        local pbm1bc = pbm1b + B2;
        // let (rm1, rm1b, rm1c, rm1d) = unit256_mul_split(pam1, pam1b, pam1c, pam1d, pbm1, pbm1b, b2, b3);
        local rm1 = pam1 * pbm1ab + pam1b * Pbm1;
        // local rm1b = pam1c*pbm1 + pam1b*pbm1b + pam1*b2 + (pam1d*pbm1 + pam1c*pbm1b + pam1b*b2 + pam1*b3) * HALF_SHIFT;
        local rm1b = pam1c * pbm1ab + pam1b * pbm1bc + pam1 * b.d1 + pam1d * Pbm1;
        // local rm1c = pam1d*pbm1b + pam1c*b2 + pam1b*b3 + (pam1d*b2 + pam1c*b3) * HALF_SHIFT;
        local rm1c = pam1d * pbm1bc + pam1c * b.d1 + pam1b * b3;
        local rm1d = pam1d * b3;

        const HALF = 1 / 2;
        // let (X4, X8) = Toom25_interp(X0, X12, r1, rm1);
        local t2a: felt;
        %{
            p = 2**251 + 17*2**192 + 1
            ids.t2a = ((ids.r1 + ids.rm1)*ids.HALF)%p
        %}
        // assert r1 = t2a + t1a;
        local t1a = r1 - t2a;
        assert rm1 = t2a - t1a;
        let X4 = t1a - X12;
        let X8 = t2a - X0;

        // let (Y6, Y10) = Toom25_interp(Y2, Y14, r1b, rm1b);
        local t2b: felt;
        %{
            p = 2**251 + 17*2**192 + 1
            ids.t2b = ((ids.r1b + ids.rm1b)*ids.HALF)%p
        %}
        // assert r1b = t2b + t1b;
        local t1b = r1b - t2b;
        assert rm1b = t2b - t1b;
        let Y6 = t1b - Y14;
        let Y10 = t2b - Y2;

        // let (Z8, Z12) = Toom25_interp(Z4, Z16, r1c, rm1c);
        local t2c: felt;
        %{
            p = 2**251 + 17*2**192 + 1
            ids.t2c = ((ids.r1c + ids.rm1c)*ids.HALF)%p
        %}
        // assert r1c = t2c + t1c;
        local t1c = r1c - t2c;
        assert rm1c = t2c - t1c;
        let Z8 = t1c - Z16;
        let Z12 = t2c - Z4;

        // let (w10, w14) = Toom25_interp(w6, 0, r1d, rm1d);
        local t2d: felt;
        %{
            p = 2**251 + 17*2**192 + 1
            ids.t2d = ((ids.r1d + ids.rm1d)*ids.HALF)%p
        %}
        // assert r1d = t2d + t1d;
        local t1d = r1d - t2d;
        assert rm1d = t2d - t1d;
        let w10 = t1d;
        let w14 = t2d - w6;

        let (res0, carry) = uint384_lib.split_128(X0);
        let (res2, carry) = uint384_lib.split_128(Y2 + carry);
        let (res4, carry) = uint384_lib.split_128(X4 + Z4 + carry);
        let (res6, carry) = uint384_lib.split_128(Y6 + w6 + carry);
        let (res8, carry) = uint384_lib.split_128(X8 + Z8 + carry);
        let (res10, carry) = uint384_lib.split_128(Y10 + w10 + carry);
        let (res12, carry) = uint384_lib.split_128(X12 + Z12 + carry);
        let (res14, carry) = uint384_lib.split_128(Y14 + w14 + carry);
        // let (res16, carry) = split_64(Z16 + carry)

        return (
            low=Uint768(d0=res0, d1=res2, d2=res4, d3=res6, d4=res8, d5=res10),
            high=Uint384(d0=res12, d1=res14, d2=Z16 + carry),
        );
    }

    // Unsigned integer division between a 768-bit integer and a 384-bit integer. Returns the quotient (768 bits) and the remainder (384 bits).
    // Conforms to EVM specifications: division by 0 yields 0.
    func unsigned_div_rem_uint768_by_uint384{range_check_ptr}(a: Uint768, div: Uint384) -> (
        quotient: Uint768, remainder: Uint384
    ) {
        alloc_locals;
        local quotient: Uint768;
        local remainder: Uint384;

        // If div == 0, return (0, 0).
        if (div.d0 + div.d1 + div.d2 == 0) {
            return (quotient=Uint768(0, 0, 0, 0, 0, 0), remainder=Uint384(0, 0, 0));
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
                
            def pack_extended(z, num_bits_shift: int) -> int:
                limbs = (z.d0, z.d1, z.d2, z.d3, z.d4, z.d5)
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

            a = pack_extended(ids.a, num_bits_shift = 128)
            div = pack(ids.div, num_bits_shift = 128)

            quotient, remainder = divmod(a, div)

            quotient_split = split(quotient, num_bits_shift=128, length=6)

            ids.quotient.d0 = quotient_split[0]
            ids.quotient.d1 = quotient_split[1]
            ids.quotient.d2 = quotient_split[2]
            ids.quotient.d3 = quotient_split[3]
            ids.quotient.d4 = quotient_split[4]
            ids.quotient.d5 = quotient_split[5]

            remainder_split = split(remainder, num_bits_shift=128, length=3)
            ids.remainder.d0 = remainder_split[0]
            ids.remainder.d1 = remainder_split[1]
            ids.remainder.d2 = remainder_split[2]
        %}
        check(quotient);
        uint384_lib.check(remainder);

        let (res_mul_low: Uint768, res_mul_high: Uint384) = mul_uint768_by_uint384_d(quotient, div);

        assert res_mul_high = Uint384(0, 0, 0);

        let (check_val: Uint768, add_carry: felt) = add_uint768_and_uint384(res_mul_low, remainder);

        assert add_carry = 0;
        assert check_val = a;

        let (is_valid) = uint384_lib.lt(remainder, div);
        assert is_valid = 1;

        return (quotient=quotient, remainder=remainder);
    }

    // Unsigned integer division between a 768-bit integer and a 384-bit integer. Returns the quotient (768 bits) and the remainder (384 bits).
    func unsigned_div_rem_uint768_by_uint384_expand{range_check_ptr}(
        a: Uint768, div: Uint384_expand
    ) -> (quotient: Uint768, remainder: Uint384) {
        alloc_locals;
        local quotient: Uint768;
        local remainder: Uint384;

        %{
            def split(num: int, num_bits_shift: int, length: int):
                a = []
                for _ in range(length):
                    a.append( num & ((1 << num_bits_shift) - 1) )
                    num = num >> num_bits_shift 
                return tuple(a)

            def pack(z, num_bits_shift: int) -> int:
                limbs = (z.b01, z.b23, z.b45)
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))
                
            def pack_extended(z, num_bits_shift: int) -> int:
                limbs = (z.d0, z.d1, z.d2, z.d3, z.d4, z.d5)
                return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

            a = pack_extended(ids.a, num_bits_shift = 128)
            div = pack(ids.div, num_bits_shift = 128)

            quotient, remainder = divmod(a, div)

            quotient_split = split(quotient, num_bits_shift=128, length=6)

            ids.quotient.d0 = quotient_split[0]
            ids.quotient.d1 = quotient_split[1]
            ids.quotient.d2 = quotient_split[2]
            ids.quotient.d3 = quotient_split[3]
            ids.quotient.d4 = quotient_split[4]
            ids.quotient.d5 = quotient_split[5]

            remainder_split = split(remainder, num_bits_shift=128, length=3)
            ids.remainder.d0 = remainder_split[0]
            ids.remainder.d1 = remainder_split[1]
            ids.remainder.d2 = remainder_split[2]
        %}
        check(quotient);
        uint384_lib.check(remainder);

        let (res_mul_low: Uint768, res_mul_high: Uint384) = mul_uint768_by_uint384_expanded(
            quotient, div
        );

        assert res_mul_high = Uint384(0, 0, 0);

        let (check_val: Uint768, add_carry: felt) = add_uint768_and_uint384(res_mul_low, remainder);

        assert add_carry = 0;
        assert check_val = a;

        let div2 = Uint384(div.b01, div.b23, div.b45);
        let (is_valid) = uint384_lib.lt(remainder, div2);
        assert is_valid = 1;

        return (quotient=quotient, remainder=remainder);
    }
}
