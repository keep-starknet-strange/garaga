from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import unsigned_div_rem as felt_divmod
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math_cmp import is_le, is_nn
from starkware.cairo.common.cairo_secp.constants import BASE
from starkware.cairo.common.uint256 import SHIFT
from starkware.cairo.common.cairo_secp.bigint import (
    BigInt3,
    bigint_mul,
    UnreducedBigInt5,
    UnreducedBigInt3,
    nondet_bigint3 as nd,
)
from starkware.cairo.common.registers import get_fp_and_pc
from src.bn254.curve import P0, P1, P2

const SHIFT_MIN_BASE = SHIFT - BASE;
const SHIFT_MIN_P2 = SHIFT - P2 - 1;
func fq_zero() -> BigInt3 {
    let res = BigInt3(0, 0, 0);
    return res;
}
func fq_eq_zero(x: BigInt3*) -> felt {
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

func add_bigint3{range_check_ptr}(a: BigInt3, b: BigInt3) -> felt {
    let (__fp__, _) = get_fp_and_pc();
    [fp + 2] = a.d0 + b.d0, ap++;
    [fp + 3] = a.d1 + b.d1, ap++;
    [fp + 4] = a.d2 + b.d2, ap++;

    %{
        has_carry_low = 1 if memory[fp+2] >= ids.BASE else 0
        memory[fp+5] = has_carry_low
        memory[fp+6] = 1 if (memory[fp+3] + has_carry_low) >= ids.BASE else 0
    %}
    ap += 2;
    if ([fp + 5] != 0) {
        if ([fp + 6] != 0) {
            [fp + 7] = [fp + 2] - BASE, ap++;
            [fp + 8] = [fp + 3] + 1 - BASE, ap++;
            [fp + 9] = [fp + 4] + 1, ap++;
            assert [range_check_ptr + 0] = [fp + 7] + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = [fp + 8] + (SHIFT_MIN_BASE);
            tempvar range_check_ptr = range_check_ptr + 2;

            return fp + 7;
        } else {
            [fp + 7] = [fp + 2] - BASE, ap++;
            [fp + 8] = [fp + 3] + 1, ap++;
            [fp + 9] = [fp + 4], ap++;
            assert [range_check_ptr + 0] = [fp + 7] + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = [fp + 8] + (SHIFT_MIN_BASE);
            tempvar range_check_ptr = range_check_ptr + 2;

            return fp + 7;
        }
    } else {
        if ([fp + 6] != 0) {
            [fp + 7] = [fp + 2], ap++;
            [fp + 8] = [fp + 3] - BASE, ap++;
            [fp + 9] = [fp + 4] + 1, ap++;
            assert [range_check_ptr + 0] = [fp + 7] + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = [fp + 8] + (SHIFT_MIN_BASE);
            tempvar range_check_ptr = range_check_ptr + 2;

            return fp + 7;
        } else {
            [fp + 7] = [fp + 2], ap++;
            [fp + 8] = [fp + 3], ap++;
            [fp + 9] = [fp + 4], ap++;
            assert [range_check_ptr + 0] = [fp + 7] + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = [fp + 8] + (SHIFT_MIN_BASE);
            tempvar range_check_ptr = range_check_ptr + 2;

            return fp + 7;
        }
    }
}
func sub_bigint3{range_check_ptr}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    local sub_mod_p: BigInt3;
    %{
        from starkware.cairo.common.cairo_secp.secp_utils import pack, split

        p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

        sub_mod_p = value = (ids.a.d0 + ids.a.d1*2**86 + ids.a.d2*2**172 - ids.b.d0 - ids.b.d1*2**86 - ids.b.d2*2**172)%p
        s = split(sub_mod_p)
        ids.sub_mod_p.d0 = s[0]
        ids.sub_mod_p.d1 = s[1]
        ids.sub_mod_p.d2 = s[2]
    %}
    // let (sub_mod_p) = nondet_bigint3();
    let ptr = add_bigint3([b], sub_mod_p);
    let check = cast(ptr, BigInt3*);
    assert check.d0 = a.d0;
    assert check.d1 = a.d1;
    assert check.d2 = a.d2;

    return &sub_mod_p;
}
func add_P{range_check_ptr}(a: BigInt3) -> felt {
    let (__fp__, _) = get_fp_and_pc();

    [fp + 2] = a.d0 + P0, ap++;
    [fp + 3] = a.d1 + P1, ap++;
    [fp + 4] = a.d2 + P2, ap++;

    %{
        has_carry_low = 1 if memory[fp+2] >= ids.BASE else 0
        memory[fp+5] = has_carry_low
        memory[fp+6] = 1 if (memory[fp+3] + has_carry_low) >= ids.BASE else 0
    %}
    ap += 2;
    if ([fp + 5] != 0) {
        if ([fp + 6] != 0) {
            [fp + 7] = [fp + 2] - BASE, ap++;
            [fp + 8] = [fp + 3] + 1 - BASE, ap++;
            [fp + 9] = [fp + 4] + 1, ap++;
            assert [range_check_ptr + 0] = [fp + 7] + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = [fp + 8] + (SHIFT_MIN_BASE);
            tempvar range_check_ptr = range_check_ptr + 2;

            return fp + 7;
        } else {
            [fp + 7] = [fp + 2] - BASE, ap++;
            [fp + 8] = [fp + 3] + 1, ap++;
            [fp + 9] = [fp + 4], ap++;
            assert [range_check_ptr + 0] = [fp + 7] + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = [fp + 8] + (SHIFT_MIN_BASE);
            tempvar range_check_ptr = range_check_ptr + 2;

            return fp + 7;
        }
    } else {
        if ([fp + 6] != 0) {
            [fp + 7] = [fp + 2], ap++;
            [fp + 8] = [fp + 3] - BASE, ap++;
            [fp + 9] = [fp + 4] + 1, ap++;
            assert [range_check_ptr + 0] = [fp + 7] + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = [fp + 8] + (SHIFT_MIN_BASE);
            tempvar range_check_ptr = range_check_ptr + 2;

            return fp + 7;
        } else {
            [fp + 7] = [fp + 2], ap++;
            [fp + 8] = [fp + 3], ap++;
            [fp + 9] = [fp + 4], ap++;
            assert [range_check_ptr + 0] = [fp + 7] + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = [fp + 8] + (SHIFT_MIN_BASE);
            tempvar range_check_ptr = range_check_ptr + 2;

            return fp + 7;
        }
    }
}

func sub_P{range_check_ptr}(a: BigInt3*) -> BigInt3* {
    alloc_locals;
    // local sub_mod_p: BigInt3;
    // let sub_p: BigInt3* = cast([fp], BigInt3*);
    local sub_p: BigInt3*;

    %{
        from starkware.cairo.common.cairo_secp.secp_utils import pack, split

        p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

        a=(memory[ids.a.address_] + memory[ids.a.address_+1]*2**86 + memory[ids.a.address_+2]*2**172)
        sub_p = a-p
        s = split(sub_p)

        ids.sub_p=segments.gen_arg(s)
    %}
    let ptr = add_P([sub_p]);
    let check = cast(ptr, BigInt3*);
    assert check.d0 = a.d0;
    assert check.d1 = a.d1;
    assert check.d2 = a.d2;

    return sub_p;
}

namespace fq_bigint3 {
    func add{range_check_ptr}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
        alloc_locals;
        local res: BigInt3;
        let (__fp__, _) = get_fp_and_pc();
        %{
            P0, P1, P2, BASE = ids.P0, ids.P1, ids.P2, ids.BASE
            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

            sum_low=ids.a.d0 + ids.b.d0
            sum_mid=ids.a.d1 + ids.b.d1
            sum_high=ids.a.d2 + ids.b.d2

            sum_low_reduced =(sum_low-P0)
            sum_mid_reduced = (sum_mid-P1)
            sum_high_reduced = (sum_high-P2)

            has_carry_low = 1 if sum_low >= BASE else 0
            has_carry_mid = 1 if (sum_mid + has_carry_low) >= BASE else 0
            needs_reduction = 1 if (sum_low + sum_mid*2**86+sum_high*2**172) >= p else 0

            has_borrow_carry_reduced_low = -1 if sum_low_reduced < 0 else (1 if sum_low_reduced>=BASE else 0)

            has_borrow_reduced_low = 1 if sum_low_reduced < 0 else 0
            has_borrow_reduced_mid = 1 if (sum_mid_reduced + has_borrow_carry_reduced_low) < 0 else 0

            has_carry_reduced_low= 1 if sum_low_reduced>=BASE else 0 
            has_carry_reduced_mid= 1 if (sum_mid_reduced+has_borrow_carry_reduced_low) >= BASE else 0

            memory[ap] = has_carry_low if needs_reduction==0 else has_borrow_reduced_low # ap -5
            memory[ap+1] = has_carry_mid if needs_reduction==0 else has_borrow_reduced_mid # ap - 4 
            memory[ap+2] = needs_reduction # != 0 <=> sum >= P =>  needs to remove P # ap - 3
            memory[ap+3] = has_carry_reduced_low # ap-2
            memory[ap+4] = has_carry_reduced_mid # ap-1
        %}

        ap += 5;

        // [ap -5] => has_carry_low or has_borrow_reduced_low
        // [ap -4] => has_carry_mid or has_borrow_reduced_mid
        // [ap -3] => needs_reduction <=> sum >= p => needs to reduce over P
        // [ap -2] => has_carry_reduced_low
        // [ap -1] => has_carry_reduced_mid

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
                        // Second limb (d2) needs to carry.
                        assert res.d0 = (-P0) + a.d0 + b.d0 + BASE;
                        assert res.d1 = (-P1) + a.d1 + b.d1 - 1 - BASE;
                        assert res.d2 = (-P2) + a.d2 + b.d2 + 1;
                    } else {
                        // Second limb (d2) needs to do nothing.
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
    func addc{range_check_ptr}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
        alloc_locals;
        local add_mod_p: BigInt3*;
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

    func neg{range_check_ptr}(a: BigInt3*) -> BigInt3* {
        alloc_locals;
        tempvar zero: BigInt3* = new BigInt3(0, 0, 0);
        return sub(zero, a);
    }

    func subc{range_check_ptr}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
        alloc_locals;
        local sub_mod_p: BigInt3*;
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

    func sub{range_check_ptr}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
        alloc_locals;
        local res: BigInt3;
        let (__fp__, _) = get_fp_and_pc();
        %{
            P0, P1, P2 = ids.P0, ids.P1, ids.P2
            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

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

    func mul{range_check_ptr}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
        alloc_locals;
        local result: BigInt3*;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import split
            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            mul = (ids.a.d0 + ids.a.d1*2**86 + ids.a.d2*2**172) * (ids.b.d0 + ids.b.d1*2**86 + ids.b.d2*2**172)
            value = mul%p

            ids.result = segments.gen_arg(split(value))
        %}
        // mul_sub = val = a * b  - result
        tempvar val: UnreducedBigInt5 = UnreducedBigInt5(
            d0=a.d0 * b.d0 - result.d0,
            d1=a.d0 * b.d1 + a.d1 * b.d0 - result.d1,
            d2=a.d0 * b.d2 + a.d1 * b.d1 + a.d2 * b.d0 - result.d2,
            d3=a.d1 * b.d2 + a.d2 * b.d1,
            d4=a.d2 * b.d2,
        );
        // verify_zero5(mul_sub);

        local flag;
        local q1;
        local fullk: BigInt3;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import pack, split
            from starkware.cairo.common.math_utils import as_int
            P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            v3 = as_int(ids.val.d3, PRIME)
            v4 = as_int(ids.val.d4, PRIME)
            v = pack(ids.val, PRIME) + v3*2**258 + v4*2**344
            q, r = divmod(v, P)
            assert r == 0, f"verify_zero: Invalid input {ids.val.d0, ids.val.d1, ids.val.d2, ids.val.d3, ids.val.d4}."
            # Since q usually doesn't fit BigInt3, divide it again
            ids.flag = 1 if q > 0 else 0
            q = q if q > 0 else 0-q
            q1, q2 = divmod(q, P)
            ids.q1 = q1
            # value = k = q2
            s = split(q)
            ids.fullk.d0 = s[0]
            ids.fullk.d1 = s[1]
            ids.fullk.d2 = s[2]
        %}
        // let (k) = nd();
        // tempvar fullk: BigInt3 = BigInt3(q1 * P0 + k.d0, q1 * P1 + k.d1, q1 * P2 + k.d2);
        // tempvar P: BigInt3* = new BigInt3(P0, P1, P2);
        // let (k_n) = bigint_mul_P(fullk);
        tempvar k_n: UnreducedBigInt5 = UnreducedBigInt5(
            d0=fullk.d0 * P0,
            d1=fullk.d0 * P1 + fullk.d1 * P0,
            d2=fullk.d0 * P2 + fullk.d1 * P1 + fullk.d2 * P0,
            d3=fullk.d1 * P2 + fullk.d2 * P1,
            d4=fullk.d2 * P2,
        );
        // val mod n = 0, so val = k_n
        tempvar carry1 = ((2 * flag - 1) * k_n.d0 - val.d0) / BASE;
        assert [range_check_ptr + 0] = carry1 + 2 ** 127;

        tempvar carry2 = ((2 * flag - 1) * k_n.d1 - val.d1 + carry1) / BASE;
        assert [range_check_ptr + 1] = carry2 + 2 ** 127;

        tempvar carry3 = ((2 * flag - 1) * k_n.d2 - val.d2 + carry2) / BASE;
        assert [range_check_ptr + 2] = carry3 + 2 ** 127;

        tempvar carry4 = ((2 * flag - 1) * k_n.d3 - val.d3 + carry3) / BASE;
        assert [range_check_ptr + 3] = carry4 + 2 ** 127;

        assert (2 * flag - 1) * k_n.d4 - val.d4 + carry4 = 0;

        let range_check_ptr = range_check_ptr + 4;
        return result;
    }

    func mul_by_9{range_check_ptr}(a: BigInt3*) -> BigInt3* {
        alloc_locals;
        local result: BigInt3*;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import split
            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            mul = (ids.a.d0 + ids.a.d1*2**86 + ids.a.d2*2**172) * 9
            value = mul%p

            ids.result = segments.gen_arg(split(value))
        %}
        // mul_sub = val = a * b  - result
        tempvar val: UnreducedBigInt3 = UnreducedBigInt3(
            d0=a.d0 * 9 - result.d0, d1=a.d1 * 9 - result.d1, d2=a.d2 * 9 - result.d2
        );

        local flag;
        local q;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import pack
            from starkware.cairo.common.math_utils import as_int

            P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

            v = pack(ids.val, PRIME) 
            q, r = divmod(v, P)
            assert r == 0, f"verify_zero: Invalid input {ids.val.d0, ids.val.d1, ids.val.d2}."

            ids.flag = 1 if q > 0 else 0
            q = q if q > 0 else 0-q
            ids.q = q % PRIME
        %}
        assert [range_check_ptr] = q + 2 ** 127;

        tempvar carry1 = ((2 * flag - 1) * q * P0 - val.d0) / BASE;
        assert [range_check_ptr + 1] = carry1 + 2 ** 127;

        tempvar carry2 = ((2 * flag - 1) * q * P1 - val.d1 + carry1) / BASE;
        assert [range_check_ptr + 2] = carry2 + 2 ** 127;

        assert (2 * flag - 1) * q * P2 - val.d2 + carry2 = 0;

        let range_check_ptr = range_check_ptr + 3;
        return result;
    }

    func mulc{range_check_ptr}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
        alloc_locals;
        local result: BigInt3*;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import split
            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            mul = (ids.a.d0 + ids.a.d1*2**86 + ids.a.d2*2**172) * (ids.b.d0 + ids.b.d1*2**86 + ids.b.d2*2**172)
            value = mul%p

            ids.result = segments.gen_arg(split(value))
        %}

        return result;
    }

    func inv{range_check_ptr}(a: BigInt3*) -> BigInt3* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local inv: BigInt3;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import split

            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            value = inv = pow(ids.a.d0 + ids.a.d1*2**86 + ids.a.d2*2**172, -1, p)
            s = split(inv)
            ids.inv.d0 = s[0]
            ids.inv.d1 = s[1]
            ids.inv.d2 = s[2]
        %}
        // let (inv) = nondet_bigint3();
        let check = mul(a, &inv);
        assert check.d0 = 1;
        assert check.d1 = 0;
        assert check.d2 = 0;

        return &inv;
    }
}
func verify_zero3{range_check_ptr}(val: BigInt3) {
    alloc_locals;
    local flag;
    local q;
    %{
        from starkware.cairo.common.cairo_secp.secp_utils import pack
        from starkware.cairo.common.math_utils import as_int

        P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

        v = pack(ids.val, PRIME) 
        q, r = divmod(v, P)
        assert r == 0, f"verify_zero: Invalid input {ids.val.d0, ids.val.d1, ids.val.d2}."

        ids.flag = 1 if q > 0 else 0
        q = q if q > 0 else 0-q
        ids.q = q % PRIME
    %}
    assert [range_check_ptr] = q + 2 ** 127;

    tempvar carry1 = ((2 * flag - 1) * q * P0 - val.d0) / BASE;
    assert [range_check_ptr + 1] = carry1 + 2 ** 127;

    tempvar carry2 = ((2 * flag - 1) * q * P1 - val.d1 + carry1) / BASE;
    assert [range_check_ptr + 2] = carry2 + 2 ** 127;

    assert (2 * flag - 1) * q * P2 - val.d2 + carry2 = 0;

    let range_check_ptr = range_check_ptr + 3;

    return ();
}

func verify_zero5{range_check_ptr}(val: UnreducedBigInt5) {
    alloc_locals;
    local flag;
    local q1;
    %{
        from starkware.cairo.common.cairo_secp.secp_utils import pack
        from starkware.cairo.common.math_utils import as_int

        P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

        v3 = as_int(ids.val.d3, PRIME)
        v4 = as_int(ids.val.d4, PRIME)
        v = pack(ids.val, PRIME) + v3*2**258 + v4*2**344

        q, r = divmod(v, P)
        assert r == 0, f"verify_zero: Invalid input {ids.val.d0, ids.val.d1, ids.val.d2, ids.val.d3, ids.val.d4}."

        # Since q usually doesn't fit BigInt3, divide it again
        ids.flag = 1 if q > 0 else 0
        q = q if q > 0 else 0-q
        q1, q2 = divmod(q, P)
        ids.q1 = q1
        value = k = q2
    %}
    let (k) = nd();
    tempvar fullk: BigInt3 = BigInt3(q1 * P0 + k.d0, q1 * P1 + k.d1, q1 * P2 + k.d2);
    // tempvar P: BigInt3* = new BigInt3(P0, P1, P2);
    // let (k_n) = bigint_mul_P(fullk);
    tempvar k_n: UnreducedBigInt5 = UnreducedBigInt5(
        d0=fullk.d0 * P0,
        d1=fullk.d0 * P1 + fullk.d1 * P0,
        d2=fullk.d0 * P2 + fullk.d1 * P1 + fullk.d2 * P0,
        d3=fullk.d1 * P2 + fullk.d2 * P1,
        d4=fullk.d2 * P2,
    );
    // val mod n = 0, so val = k_n
    tempvar carry1 = ((2 * flag - 1) * k_n.d0 - val.d0) / BASE;
    assert [range_check_ptr + 0] = carry1 + 2 ** 127;

    tempvar carry2 = ((2 * flag - 1) * k_n.d1 - val.d1 + carry1) / BASE;
    assert [range_check_ptr + 1] = carry2 + 2 ** 127;

    tempvar carry3 = ((2 * flag - 1) * k_n.d2 - val.d2 + carry2) / BASE;
    assert [range_check_ptr + 2] = carry3 + 2 ** 127;

    tempvar carry4 = ((2 * flag - 1) * k_n.d3 - val.d3 + carry3) / BASE;
    assert [range_check_ptr + 3] = carry4 + 2 ** 127;

    assert (2 * flag - 1) * k_n.d4 - val.d4 + carry4 = 0;

    let range_check_ptr = range_check_ptr + 4;

    return ();
}

// returns 1 if x ==0 mod alt_bn128 prime
func is_zero{range_check_ptr}(x: BigInt3) -> (res: felt) {
    %{
        from starkware.cairo.common.cairo_secp.secp_utils import pack
        P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
        x = pack(ids.x, PRIME) % P
    %}
    if (nondet %{ x == 0 %} != 0) {
        verify_zero3(x);
        // verify_zero5(UnreducedBigInt5(d0=x.d0, d1=x.d1, d2=x.d2, d3=0, d4=0))
        return (res=1);
    }

    %{
        from starkware.python.math_utils import div_mod
        value = x_inv = div_mod(1, x, P)
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
