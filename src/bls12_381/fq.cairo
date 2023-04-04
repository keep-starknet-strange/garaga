from starkware.cairo.common.math import unsigned_div_rem as felt_divmod
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math_cmp import is_le, is_nn

from starkware.cairo.common.uint256 import SHIFT

from starkware.cairo.common.registers import get_fp_and_pc
from src.bls12_381.curve import P0, P1, P2, P3, BASE

const SHIFT_MIN_BASE = SHIFT - BASE;
const SHIFT_MIN_P3 = SHIFT - P3 - 1;

struct BigInt4 {
    d0: felt,
    d1: felt,
    d2: felt,
    d3: felt,
}

struct UnreducedBigInt7 {
    d0: felt,
    d1: felt,
    d2: felt,
    d3: felt,
    d4: felt,
    d5: felt,
    d6: felt,
}
func fq_zero() -> BigInt4 {
    let res = BigInt4(0, 0, 0);
    return res;
}
func fq_eq_zero(x: BigInt4*) -> felt {
    if (x.d0 != 0) {
        return 0;
    }
    if (x.d1 != 0) {
        return 0;
    }
    if (x.d2 != 0) {
        return 0;
    }
    return 1;
}
func bigint4_mul(x: BigInt4, y: BigInt4) -> (res: UnreducedBigInt7) {
    return (
        UnreducedBigInt7(
            d0=x.d0 * y.d0,
            d1=x.d0 * y.d1 + x.d1 * y.d0,
            d2=x.d0 * y.d2 + x.d1 * y.d1 + x.d2 * y.d0,
            d3=x.d0 * y.d3 + x.d1 * y.d2 + x.d2 * y.d1 + x.d3 * y.d0,
            d4=x.d1 * y.d3 + x.d2 * y.d2 + x.d3 * y.d1,
            d5=x.d2 * y.d3 + x.d3 * y.d2,
            d6=x.d3 * y.d3,
        ),
    );
}
namespace fq_bigint4 {
    func add{range_check_ptr}(a: BigInt4*, b: BigInt4*) -> BigInt4* {
        alloc_locals;
        local res: BigInt4;
        let (__fp__, _) = get_fp_and_pc();
        %{
            P0, P1, P2, P3, BASE = ids.P0, ids.P1, ids.P2, ids.P3, ids.BASE
            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

            sum_d0 = ids.a.d0 + ids.b.d0
            sum_d1 = ids.a.d1 + ids.b.d1
            sum_d2 = ids.a.d2 + ids.b.d2
            sum_d3 = ids.a.d3 + ids.b.d3

            sum_d0_reduced = (sum_d0 - P0)
            sum_d1_reduced = (sum_d1 - P1)
            sum_d2_reduced = (sum_d2 - P2)
            sum_d3_reduced = (sum_d3 - P3)

            has_carry_d0 = 1 if sum_d0 >= BASE else 0
            has_carry_d1 = 1 if (sum_d1 + has_carry_d0) >= BASE else 0
            has_carry_d2 = 1 if (sum_d2 + has_carry_d1) >= BASE else 0
            needs_reduction = 1 if (sum_d0 + sum_d1*2**86 + sum_d2*2**172 + sum_d3*2**258) >= p else 0

            has_borrow_carry_reduced_d0 = -1 if sum_d0_reduced < 0 else (1 if sum_d0_reduced >= BASE else 0)

            has_borrow_reduced_d0 = 1 if sum_d0_reduced < 0 else 0
            has_borrow_reduced_d1 = 1 if (sum_d1_reduced + has_borrow_carry_reduced_d0) < 0 else 0
            has_borrow_reduced_d2 = 1 if (sum_d2_reduced + has_borrow_reduced_d1) < 0 else 0

            has_carry_reduced_d0 = 1 if sum_d0_reduced >= BASE else 0
            has_carry_reduced_d1 = 1 if (sum_d1_reduced + has_borrow_carry_reduced_d0) >= BASE else 0
            has_carry_reduced_d2 = 1 if (sum_d2_reduced + has_carry_reduced_d1) >= BASE else 0

            memory[ap] = has_carry_d0 if needs_reduction == 0 else has_borrow_reduced_d0 # ap -7
            memory[ap+1] = has_carry_d1 if needs_reduction == 0 else has_borrow_reduced_d1 # ap -6
            memory[ap+2] = has_carry_d2 if needs_reduction == 0 else has_borrow_reduced_d2 # ap -5
            memory[ap+3] = needs_reduction # != 0 <=> sum >= P =>  needs to remove P # ap -4
            memory[ap+4] = has_carry_reduced_d0 # ap -3
            memory[ap+5] = has_carry_reduced_d1 # ap -2
            memory[ap+6] = has_carry_reduced_d2 # ap -1
        %}

        ap += 7;

        // Previous comments :
        // [ap -5] => has_carry_low or has_borrow_reduced_low
        // [ap -4] => has_carry_mid or has_borrow_reduced_mid
        // [ap -3] => needs_reduction <=> sum >= p => needs to reduce over P
        // [ap -2] => has_carry_reduced_low
        // [ap -1] => has_carry_reduced_mid

        // Updated comments :
        // [ap -7] => has_carry_d0 or has_borrow_reduced_d0
        // [ap -6] => has_carry_d1 or has_borrow_reduced_d1
        // [ap -5] => has_carry_d2 or has_borrow_reduced_d2
        // [ap -4] => needs_reduction <=> sum >= p => needs to reduce over P
        // [ap -3] => has_carry_reduced_d0
        // [ap -2] => has_carry_reduced_d1
        // [ap -1] => has_carry_reduced_d2

        // Previous code :
        if ([ap - 3] != 0) {
            // Needs reduction over P. So, we first check if the low part of the subtraction has a borrow or a carry or nothing.
            // If it has a borrow, it cannot have a carry. See hint.
            if ([ap - 5] != 0) {
                // First limb (d0) needs to borrow.
                if ([ap - 4] != 0) {
                    // Second limb (d1) needs to borrow.
                    assert res.d0 = (-P0) + a.d0 + b.d0 + BASE;
                    assert res.d1 = (-P1) + a.d1 + b.d1 - 1 + BASE;
                    assert res.d2 = (-P2) + a.d2 + b.d2 - 1;
                } else {
                    // Still undefined second limb, but no borrow.
                    if ([ap - 1] != 0) {
                        // Second limb (d1) needs to carry.
                        assert res.d0 = (-P0) + a.d0 + b.d0 + BASE;
                        assert res.d1 = (-P1) + a.d1 + b.d1 - 1 - BASE;
                        assert res.d2 = (-P2) + a.d2 + b.d2 + 1;
                    } else {
                        // Second limb (d1) needs to do nothing.
                        assert res.d0 = (-P0) + a.d0 + b.d0 + BASE;
                        assert res.d1 = (-P1) + a.d1 + b.d1 - 1;
                        assert res.d2 = (-P2) + a.d2 + b.d2;
                    }
                }
            } else {
                // Undefined first limb, but no borrow.
                if ([ap - 2] != 0) {
                    // First limb (d0) needs to carry.
                    if ([ap - 4] != 0) {
                        // Second limb (d1) needs to borrow.
                        assert res.d0 = (-P0) + a.d0 + b.d0 - BASE;
                        assert res.d1 = (-P1) + a.d1 + b.d1 + 1 + BASE;
                        assert res.d2 = (-P2) + a.d2 + b.d2 - 1;
                    } else {
                        // Still undefined second limb, but no borrow.
                        if ([ap - 1] != 0) {
                            // Second limb (d1) needs to carry.
                            assert res.d0 = (-P0) + a.d0 + b.d0 - BASE;
                            assert res.d1 = (-P1) + a.d1 + b.d1 + 1 - BASE;
                            assert res.d2 = (-P2) + a.d2 + b.d2 + 1;
                        } else {
                            // Second limb (d1) needs to do nothing.
                            assert res.d0 = (-P0) + a.d0 + b.d0 - BASE;
                            assert res.d1 = (-P1) + a.d1 + b.d1 + 1;
                            assert res.d2 = (-P2) + a.d2 + b.d2;
                        }
                    }
                } else {
                    // First limb needs to do nothing.
                    if ([ap - 4] != 0) {
                        // Second limb (d1) needs to borrow.
                        assert res.d0 = (-P0) + a.d0 + b.d0;
                        assert res.d1 = (-P1) + a.d1 + b.d1 + BASE;
                        assert res.d2 = (-P2) + a.d2 + b.d2 - 1;
                    } else {
                        // Still undefined second limb, but no borrow.
                        if ([ap - 1] != 0) {
                            // Second limb (d1) needs to carry.
                            assert res.d0 = (-P0) + a.d0 + b.d0;
                            assert res.d1 = (-P1) + a.d1 + b.d1 - BASE;
                            assert res.d2 = (-P2) + a.d2 + b.d2 + 1;
                        } else {
                            // Second limb (d1) needs to do nothing.
                            assert res.d0 = (-P0) + a.d0 + b.d0;
                            assert res.d1 = (-P1) + a.d1 + b.d1;
                            assert res.d2 = (-P2) + a.d2 + b.d2;
                        }
                    }
                }
            }
        } else {
            // No reduction over P. So, we first check if the low part of the addition has a carry or nothing.
            // if it doesn't have a carry, it has nothing.
            if ([ap - 5] != 0) {
                // First limb (d0) needs to carry.
                if ([ap - 4] != 0) {
                    // Second limb (d1) needs to carry.
                    assert res.d0 = a.d0 + b.d0 - BASE;
                    assert res.d1 = a.d1 + b.d1 + 1 - BASE;
                    assert res.d2 = a.d2 + b.d2 + 1;
                } else {
                    // Second limb (d1) needs to do nothing.
                    assert res.d0 = a.d0 + b.d0 - BASE;
                    assert res.d1 = a.d1 + b.d1 + 1;
                    assert res.d2 = a.d2 + b.d2;
                }
            } else {
                // First limb (d0) needs to do nothing.
                if ([ap - 4] != 0) {
                    // Second limb (d1) needs to carry.
                    assert res.d0 = a.d0 + b.d0;
                    assert res.d1 = a.d1 + b.d1 - BASE;
                    assert res.d2 = a.d2 + b.d2 + 1;
                } else {
                    // Second limb (d1) needs to do nothing.
                    assert res.d0 = a.d0 + b.d0;
                    assert res.d1 = a.d1 + b.d1;
                    assert res.d2 = a.d2 + b.d2;
                }
            }
        }

        // %{
        //     print("\n")
        //     print(f"sub_low {sub_low} sub_mid {sub_mid} sub_high {sub_high}")
        //     print(f"sub_low_r {sub_low_reduced} sub_mid_r {sub_mid_reduced} sub_high_r {sub_high_reduced}")
        //     print(f"Has Borrow Low : {has_borrow_low} Has Borrow Mid: {has_borrow_mid} Has Borrow High {has_borrow_high}")
        //     print(f"case {memory[ap-5]} {memory[ap-4]} {memory[ap-3]} {memory[ap-2]} {memory[ap-1]}")
        //     print(f"res.d0 {ids.res.d0} res.d1 {ids.res.d1} res.d2 {ids.res.d2}")
        //     assert ids.res.d0 + ids.res.d1*2**86 + ids.res.d2*2**172 == (sub_low + sub_mid*2**86 + sub_high*2**172)%p
        // %}

        tempvar range_check_ptr = range_check_ptr + 3;

        assert [range_check_ptr - 3] = res.d0 + (SHIFT_MIN_BASE);
        assert [range_check_ptr - 2] = res.d1 + (SHIFT_MIN_BASE);
        assert [range_check_ptr - 1] = res.d2 + (SHIFT_MIN_P2);
        return &res;
    }

    func sub{range_check_ptr}(a: BigInt4*, b: BigInt4*) -> BigInt4* {
        alloc_locals;
        local res: BigInt4;
        let (__fp__, _) = get_fp_and_pc();
        %{
            P0, P1, P2, BASE = ids.P0, ids.P1, ids.P2, ids.BASE

            sub_low=ids.a.d0 - ids.b.d0
            sub_mid=ids.a.d1 - ids.b.d1
            sub_high=ids.a.d2 - ids.b.d2

            sub_low_reduced =(P0 + sub_low)
            sub_mid_reduced = (P1 + sub_mid)
            sub_high_reduced = (P2 + sub_high)

            has_borrow_low = 1 if sub_low < 0 else 0
            has_borrow_mid = 1 if (sub_mid - has_borrow_low) < 0 else 0
            has_borrow_high = 1 if (sub_high - has_borrow_mid) < 0 else 0

            has_borrow_carry_reduced_low = -1 if sub_low_reduced < 0 else (1 if sub_low_reduced>=ids.BASE else 0)

            has_borrow_reduced_low = 1 if sub_low_reduced < 0 else 0
            has_borrow_reduced_mid = 1 if (sub_mid_reduced + has_borrow_carry_reduced_low) < 0 else 0

            has_carry_reduced_low= 1 if sub_low_reduced>=ids.BASE else 0 
            has_carry_reduced_mid= 1 if (sub_mid_reduced+has_borrow_carry_reduced_low) >= ids.BASE else 0

            memory[ap] = has_borrow_low if has_borrow_high==0 else has_borrow_reduced_low # ap -5
            memory[ap+1] = has_borrow_mid if has_borrow_high==0 else has_borrow_reduced_mid # ap - 4 
            memory[ap+2] = has_borrow_high # != 0 <=> sub < 0 =>  needs to add P # ap - 3
            memory[ap+3] = has_carry_reduced_low # ap-2
            memory[ap+4] = has_carry_reduced_mid # ap-1
        %}

        ap += 5;

        // [ap -5] => has_borrow_low or has_borrow_reduced_low
        // [ap -4] => has_borrow_mid or has_borrow_reduced_mid
        // [ap -3] => has_borrow_high <=> sub < 0 => needs to reduce over P
        // [ap -2] => has_carry_reduced_low
        // [ap -1] => has_carry_reduced_mid

        if ([ap - 3] != 0) {
            // Needs reduction over P. So, we first check if the low part of the subtraction has a borrow or a carry or nothing.
            // If it has a borrow, it cannot have a carry. See hint.
            if ([ap - 5] != 0) {
                // First limb (d0) needs to borrow.
                if ([ap - 4] != 0) {
                    // Second limb (d1) needs to borrow.
                    assert res.d0 = P0 + a.d0 - b.d0 + BASE;
                    assert res.d1 = P1 + a.d1 - b.d1 - 1 + BASE;
                    assert res.d2 = P2 + a.d2 - b.d2 - 1;
                } else {
                    // Still undefined second limb, but no borrow.
                    if ([ap - 1] != 0) {
                        // Second limb (d2) needs to carry.
                        assert res.d0 = P0 + a.d0 - b.d0 + BASE;
                        assert res.d1 = P1 + a.d1 - b.d1 - 1 - BASE;
                        assert res.d2 = P2 + a.d2 - b.d2 + 1;
                    } else {
                        // Second limb (d2) needs to do nothing.
                        assert res.d0 = P0 + a.d0 - b.d0 + BASE;
                        assert res.d1 = P1 + a.d1 - b.d1 - 1;
                        assert res.d2 = P2 + a.d2 - b.d2;
                    }
                }
            } else {
                // Undefined first limb, but no borrow.
                if ([ap - 2] != 0) {
                    // First limb (d0) needs to carry.
                    if ([ap - 4] != 0) {
                        // Second limb (d1) needs to borrow.
                        assert res.d0 = P0 + a.d0 - b.d0 - BASE;
                        assert res.d1 = P1 + a.d1 - b.d1 + 1 + BASE;
                        assert res.d2 = P2 + a.d2 - b.d2 - 1;
                    } else {
                        // Still undefined second limb, but no borrow.
                        if ([ap - 1] != 0) {
                            // Second limb (d1) needs to carry.
                            assert res.d0 = P0 + a.d0 - b.d0 - BASE;
                            assert res.d1 = P1 + a.d1 - b.d1 + 1 - BASE;
                            assert res.d2 = P2 + a.d2 - b.d2 + 1;
                        } else {
                            // Second limb (d1) needs to do nothing.
                            assert res.d0 = P0 + a.d0 - b.d0 - BASE;
                            assert res.d1 = P1 + a.d1 - b.d1 + 1;
                            assert res.d2 = P2 + a.d2 - b.d2;
                        }
                    }
                } else {
                    // First limb needs to do nothing.
                    if ([ap - 4] != 0) {
                        // Second limb (d1) needs to borrow.
                        assert res.d0 = P0 + a.d0 - b.d0;
                        assert res.d1 = P1 + a.d1 - b.d1 + BASE;
                        assert res.d2 = P2 + a.d2 - b.d2 - 1;
                    } else {
                        // Still undefined second limb, but no borrow.
                        if ([ap - 1] != 0) {
                            // Second limb (d1) needs to carry.
                            assert res.d0 = P0 + a.d0 - b.d0;
                            assert res.d1 = P1 + a.d1 - b.d1 - BASE;
                            assert res.d2 = P2 + a.d2 - b.d2 + 1;
                        } else {
                            // Second limb (d1) needs to do nothing.
                            assert res.d0 = P0 + a.d0 - b.d0;
                            assert res.d1 = P1 + a.d1 - b.d1;
                            assert res.d2 = P2 + a.d2 - b.d2;
                        }
                    }
                }
            }
        } else {
            // No reduction over P. So, we first check if the low part of the subtraction has a borrow or nothing.
            // if it doesn't have a borrow, it has nothing.
            if ([ap - 5] != 0) {
                // First limb (d0) needs to borrow.
                if ([ap - 4] != 0) {
                    // Second limb (d1) needs to borrow.
                    assert res.d0 = a.d0 - b.d0 + BASE;
                    assert res.d1 = a.d1 - b.d1 - 1 + BASE;
                    assert res.d2 = a.d2 - b.d2 - 1;
                } else {
                    // Second limb (d1) needs to do nothing.
                    assert res.d0 = a.d0 - b.d0 + BASE;
                    assert res.d1 = a.d1 - b.d1 - 1;
                    assert res.d2 = a.d2 - b.d2;
                }
            } else {
                // First limb (d0) needs to do nothing.
                if ([ap - 4] != 0) {
                    // Second limb (d1) needs to borrow.
                    assert res.d0 = a.d0 - b.d0;
                    assert res.d1 = a.d1 - b.d1 + BASE;
                    assert res.d2 = a.d2 - b.d2 - 1;
                } else {
                    // Second limb (d1) needs to do nothing.
                    assert res.d0 = a.d0 - b.d0;
                    assert res.d1 = a.d1 - b.d1;
                    assert res.d2 = a.d2 - b.d2;
                }
            }
        }

        // %{
        //     print("\n")
        //     print(f"sub_low {sub_low} sub_mid {sub_mid} sub_high {sub_high}")
        //     print(f"sub_low_r {sub_low_reduced} sub_mid_r {sub_mid_reduced} sub_high_r {sub_high_reduced}")
        //     print(f"Has Borrow Low : {has_borrow_low} Has Borrow Mid: {has_borrow_mid} Has Borrow High {has_borrow_high}")
        //     print(f"case {memory[ap-5]} {memory[ap-4]} {memory[ap-3]} {memory[ap-2]} {memory[ap-1]}")
        //     print(f"res.d0 {ids.res.d0} res.d1 {ids.res.d1} res.d2 {ids.res.d2}")
        //     assert ids.res.d0 + ids.res.d1*2**86 + ids.res.d2*2**172 == (sub_low + sub_mid*2**86 + sub_high*2**172)%p
        // %}

        tempvar range_check_ptr = range_check_ptr + 3;

        assert [range_check_ptr - 3] = res.d0 + (SHIFT_MIN_BASE);
        assert [range_check_ptr - 2] = res.d1 + (SHIFT_MIN_BASE);
        assert [range_check_ptr - 1] = res.d2 + (SHIFT_MIN_P2);
        return &res;
    }

    func mul{range_check_ptr}(a: BigInt4*, b: BigInt4*) -> BigInt4* {
        alloc_locals;
        local q: BigInt4;
        local r: BigInt4*;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import split
            BASE = ids.BASE
            def split4(x):
            q3, r = x//BASE**3,x % BASE**3
            q2, r = r//BASE**2, r % BASE**2
            q1, q0 = r//BASE, r % BASE
            return [q0, q1, q2, q3]

            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            mul = (ids.a.d0 + ids.a.d1*2**86 + ids.a.d2*2**172) * (ids.b.d0 + ids.b.d1*2**86 + ids.b.d2*2**172)

            q, r = mul//p, mul%p

            ids.r = segments.gen_arg(split(r))
            q_split = split(q)
            ids.q.d0 = q_split[0]
            ids.q.d1 = q_split[1]
            ids.q.d2 = q_split[2]
        %}

        // mul_sub = val = a * b  - a*b%p
        tempvar val: UnreducedBigInt5 = UnreducedBigInt5(
            d0=a.d0 * b.d0 - r.d0,
            d1=a.d0 * b.d1 + a.d1 * b.d0 - r.d1,
            d2=a.d0 * b.d2 + a.d1 * b.d1 + a.d2 * b.d0 - r.d2,
            d3=a.d1 * b.d2 + a.d2 * b.d1,
            d4=a.d2 * b.d2,
        );

        tempvar q_P: UnreducedBigInt5 = UnreducedBigInt5(
            d0=q.d0 * P0,
            d1=q.d0 * P1 + q.d1 * P0,
            d2=q.d0 * P2 + q.d1 * P1 + q.d2 * P0,
            d3=q.d1 * P2 + q.d2 * P1,
            d4=q.d2 * P2,
        );
        // val mod P = 0, so val = k_P

        tempvar carry1 = (q_P.d0 - val.d0) / BASE;
        assert [range_check_ptr + 0] = carry1 + 2 ** 127;

        tempvar carry2 = (q_P.d1 - val.d1 + carry1) / BASE;
        assert [range_check_ptr + 1] = carry2 + 2 ** 127;

        tempvar carry3 = (q_P.d2 - val.d2 + carry2) / BASE;
        assert [range_check_ptr + 2] = carry3 + 2 ** 127;

        tempvar carry4 = (q_P.d3 - val.d3 + carry3) / BASE;
        assert [range_check_ptr + 3] = carry4 + 2 ** 127;
        assert q_P.d4 - val.d4 + carry4 = 0;
        tempvar range_check_ptr = range_check_ptr + 4;

        // The following assert would ensure sum(carry_i) is in [-2**92, 2**92]
        // If only using it this range check, it would result in 73 steps instead of 77 (5.2% improvement).
        // assert [range_check_ptr] = carry1 + carry2 + carry3 + carry4 + 2 ** 128 - 2 ** 92;
        // tempvar range_check_ptr = range_check_ptr + 1;

        // %{ print(f"carry_1: {ids.carry1}") %}
        // %{ print(f"carry_2: {ids.carry2}") %}
        // %{ print(f"carry_3: {ids.carry3}") %}
        // %{ print(f"carry_4: {ids.carry4}") %}

        return r;
    }

    func mul_by_9{range_check_ptr}(a: BigInt4*) -> BigInt4* {
        alloc_locals;
        local r: BigInt4*;
        local q: felt;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import split
            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            mul = (ids.a.d0 + ids.a.d1*2**86 + ids.a.d2*2**172) * 9
            q, r = mul//p, mul%p

            ids.r = segments.gen_arg(split(r))
            ids.q = q
        %}
        // mul_sub = val = a * b  - result
        tempvar val: UnreducedBigInt7 = UnreducedBigInt7(
            d0=a.d0 * 9 - r.d0, d1=a.d1 * 9 - r.d1, d2=a.d2 * 9 - r.d2
        );

        assert [range_check_ptr] = q + SHIFT_MIN_BASE;

        tempvar carry1 = (q * P0 - val.d0) / BASE;
        assert [range_check_ptr + 1] = carry1 + SHIFT_MIN_BASE;

        tempvar carry2 = (q * P1 - val.d1 + carry1) / BASE;
        assert [range_check_ptr + 2] = carry2 + SHIFT_MIN_BASE;

        // %{ print(f"carry1 = {ids.carry1}") %}
        // %{ print(f"carry2 = {ids.carry2}, {-ids.carry2%PRIME}") %}

        assert q * P2 - val.d2 + carry2 = 0;

        let range_check_ptr = range_check_ptr + 3;
        return r;
    }
    func mul_by_10{range_check_ptr}(a: BigInt4*) -> BigInt4* {
        alloc_locals;
        local r: BigInt4*;
        local q: felt;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import split
            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            mul = (ids.a.d0 + ids.a.d1*2**86 + ids.a.d2*2**172) * 10
            q, r = mul//p, mul%p

            ids.r = segments.gen_arg(split(r))
            ids.q = q
        %}
        // mul_sub = val = a * b  - result
        tempvar val: UnreducedBigInt7 = UnreducedBigInt7(
            d0=a.d0 * 10 - r.d0, d1=a.d1 * 10 - r.d1, d2=a.d2 * 10 - r.d2
        );

        assert [range_check_ptr] = q + SHIFT_MIN_BASE;

        tempvar carry1 = (q * P0 - val.d0) / BASE;
        assert [range_check_ptr + 1] = carry1 + SHIFT_MIN_BASE;

        tempvar carry2 = (q * P1 - val.d1 + carry1) / BASE;
        assert [range_check_ptr + 2] = carry2 + SHIFT_MIN_BASE;

        // %{ print(f"carry1 = {ids.carry1}") %}
        // %{ print(f"carry2 = {ids.carry2}, {-ids.carry2%PRIME}") %}

        assert q * P2 - val.d2 + carry2 = 0;

        let range_check_ptr = range_check_ptr + 3;
        return r;
    }

    func neg{range_check_ptr}(a: BigInt4*) -> BigInt4* {
        alloc_locals;
        tempvar zero: BigInt4* = new BigInt4(0, 0, 0, 0);
        return sub(zero, a);
    }

    func inv{range_check_ptr}(a: BigInt4*) -> BigInt4* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local inv: BigInt4;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import split

            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            value = inv = pow(ids.a.d0 + ids.a.d1*2**86 + ids.a.d2*2**172, -1, p)
            s = split(inv)
            ids.inv.d0 = s[0]
            ids.inv.d1 = s[1]
            ids.inv.d2 = s[2]
        %}
        // let (inv) = nondet_BigInt4();
        let check = mul(a, &inv);
        assert check.d0 = 1;
        assert check.d1 = 0;
        assert check.d2 = 0;

        return &inv;
    }
    func add_unsafe{range_check_ptr}(a: BigInt4*, b: BigInt4*) -> BigInt4* {
        alloc_locals;
        local add_mod_p: BigInt4*;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import pack, split
            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            a = pack(ids.a, p)
            b = pack(ids.b, p)
            add_mod_p = value = (a+b)%p

            ids.add_mod_p = segments.gen_arg(split(value))
        %}
        return add_mod_p;
    }
    func sub_unsafe{range_check_ptr}(a: BigInt4*, b: BigInt4*) -> BigInt4* {
        alloc_locals;
        local sub_mod_p: BigInt4*;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import pack, split
            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            a = pack(ids.a, p)
            b = pack(ids.b, p)
            sub_mod_p = value = (a-b)%p

            ids.sub_mod_p = segments.gen_arg(split(value))
        %}
        return sub_mod_p;
    }
    func mul_unsafe{range_check_ptr}(a: BigInt4*, b: BigInt4*) -> BigInt4* {
        alloc_locals;
        local result: BigInt4*;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import split
            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            mul = (ids.a.d0 + ids.a.d1*2**86 + ids.a.d2*2**172) * (ids.b.d0 + ids.b.d1*2**86 + ids.b.d2*2**172)
            value = mul%p

            ids.result = segments.gen_arg(split(value))
        %}

        return result;
    }
}
func verify_zero3{range_check_ptr}(val: BigInt4) {
    alloc_locals;
    local q;
    %{
        from starkware.cairo.common.cairo_secp.secp_utils import pack
        from starkware.cairo.common.math_utils import as_int

        P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

        v = pack(ids.val, PRIME) 
        q, r = divmod(v, P)
        assert r == 0, f"verify_zero: Invalid input {ids.val.d0, ids.val.d1, ids.val.d2}."
        ids.q = q
    %}

    assert [range_check_ptr] = q + 2 ** 127;

    tempvar carry1 = (q * P0 - val.d0) / BASE;
    assert [range_check_ptr + 1] = carry1 + 2 ** 127;

    tempvar carry2 = (q * P1 - val.d1 + carry1) / BASE;
    assert [range_check_ptr + 2] = carry2 + 2 ** 127;

    assert q * P2 - val.d2 + carry2 = 0;

    let range_check_ptr = range_check_ptr + 3;

    return ();
}

func verify_zero5{range_check_ptr}(val: UnreducedBigInt5) {
    alloc_locals;
    local q: BigInt4;
    %{
        from starkware.cairo.common.math_utils import as_int

        p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
        val = as_int(ids.val.d0, PRIME) + as_int(ids.val.d1, PRIME)*2**86 + as_int(ids.val.d2,PRIME)*2**172 + as_int(ids.val.d3, PRIME)*2**258 + as_int(ids.val.d4, PRIME)*2**344

        q, r = val//p,val%p
        assert r == 0, f"verify_zero: Invalid input {ids.val.d0, ids.val.d1, ids.val.d2, ids.val.d3, ids.val.d4}."

        ids.q.d2 = q//2**172
        ids.q.d1 = (q%2**172)//2**86
        ids.q.d0 = (q%2**172)%2**86
    %}

    tempvar q_P: UnreducedBigInt5 = UnreducedBigInt5(
        d0=q.d0 * P0,
        d1=q.d0 * P1 + q.d1 * P0,
        d2=q.d0 * P2 + q.d1 * P1 + q.d2 * P0,
        d3=q.d1 * P2 + q.d2 * P1,
        d4=q.d2 * P2,
    );
    // val mod P = 0, so val = k_P

    tempvar carry1 = (q_P.d0 - val.d0) / BASE;
    assert [range_check_ptr + 0] = carry1 + 2 ** 127;

    tempvar carry2 = (q_P.d1 - val.d1 + carry1) / BASE;
    assert [range_check_ptr + 1] = carry2 + 2 ** 127;

    tempvar carry3 = (q_P.d2 - val.d2 + carry2) / BASE;
    assert [range_check_ptr + 2] = carry3 + 2 ** 127;

    tempvar carry4 = (q_P.d3 - val.d3 + carry3) / BASE;
    assert [range_check_ptr + 3] = carry4 + 2 ** 127;
    assert q_P.d4 - val.d4 + carry4 = 0;
    tempvar range_check_ptr = range_check_ptr + 4;
    return ();
}

// returns 1 if x ==0 mod alt_bn128 prime
func is_zero{range_check_ptr}(x: BigInt4) -> (res: felt) {
    %{
        from starkware.cairo.common.cairo_secp.secp_utils import pack
        p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
        x = pack(ids.x, PRIME) % p
    %}
    if (nondet %{ x == 0 %} != 0) {
        verify_zero3(x);
        // verify_zero5(UnreducedBigInt5(d0=x.d0, d1=x.d1, d2=x.d2, d3=0, d4=0))
        return (res=1);
    }

    %{
        from starkware.python.math_utils import div_mod
        p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
        value = x_inv = div_mod(1, x, p)
    %}
    let (x_inv) = nd();
    let (x_x_inv) = bigint_mul(x, x_inv);

    // Check that x * x_inv = 1 to verify that x != 0.
    verify_zero5(
        UnreducedBigInt5(
            d0=x_x_inv.d0 - 1, d1=x_x_inv.d1, d2=x_x_inv.d2, d3=x_x_inv.d3, d4=x_x_inv.d4
        ),
    );
    return (res=0);
}
