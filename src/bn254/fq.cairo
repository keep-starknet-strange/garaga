from starkware.cairo.common.uint256 import SHIFT, Uint256
from starkware.cairo.common.cairo_secp.bigint import (
    BigInt3,
    bigint_mul,
    UnreducedBigInt5,
    UnreducedBigInt3,
    uint256_to_bigint,
)
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.math import abs_value, split_felt

from src.bn254.curve import (
    P0,
    P1,
    P2,
    N_LIMBS,
    N_LIMBS_UNREDUCED,
    DEGREE,
    BASE,
    P0_256,
    P1_256,
    BASE_MIN_1,
)

func unrededucedUint256_to_BigInt3{range_check_ptr}(x: Uint256) -> (res: BigInt3) {
    alloc_locals;
    let (low_bigint3) = felt_to_bigint3(x.low);
    let (high_bigint3) = felt_to_bigint3(x.high);
    let res = reduce_3(
        UnreducedBigInt3(
            d0=low_bigint3.d0 + SHIFT * high_bigint3.d0,
            d1=low_bigint3.d1 + SHIFT * high_bigint3.d1,
            d2=low_bigint3.d2 + SHIFT * high_bigint3.d2,
        ),
    );
    return (res,);
}

func felt_to_bigint3{range_check_ptr}(x: felt) -> (res: BigInt3) {
    let (high, low) = split_felt(x);
    let (res) = uint256_to_bigint(Uint256(low, high));
    return (res,);
}
func fq_zero() -> BigInt3 {
    let res = BigInt3(0, 0, 0);
    return res;
}
func fq_eq_zero(x: BigInt3) -> felt {
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

func assert_fq_eq(x: BigInt3*, y: BigInt3*) {
    assert 0 = x.d0 - y.d0;
    assert 0 = x.d1 - y.d1;
    assert 0 = x.d2 - y.d2;
    return ();
}

func bigint_sqr(x: BigInt3) -> (res: UnreducedBigInt5) {
    tempvar two = 2;
    return (
        UnreducedBigInt5(
            d0=x.d0 * x.d0,
            d1=two * x.d0 * x.d1,
            d2=two * x.d0 * x.d2 + x.d1 * x.d1,
            d3=two * x.d1 * x.d2,
            d4=x.d2 * x.d2,
        ),
    );
}
// Asserts that x0, x1, x2 are positive and < B and 0 <= x < P
func assert_reduced_felt{range_check_ptr}(x: BigInt3) {
    assert [range_check_ptr] = x.d0;
    assert [range_check_ptr + 1] = x.d1;
    assert [range_check_ptr + 2] = x.d2;
    assert [range_check_ptr + 3] = BASE_MIN_1 - x.d0;
    assert [range_check_ptr + 4] = BASE_MIN_1 - x.d1;
    assert [range_check_ptr + 5] = P2 - x.d2;

    if (x.d2 == P2) {
        if (x.d1 == P1) {
            assert [range_check_ptr + 6] = P0 - 1 - x.d0;
            tempvar range_check_ptr = range_check_ptr + 7;
            return ();
        } else {
            assert [range_check_ptr + 6] = P1 - 1 - x.d1;
            tempvar range_check_ptr = range_check_ptr + 7;
            return ();
        }
    } else {
        tempvar range_check_ptr = range_check_ptr + 6;
        return ();
    }
}

// Asserts that x.low, x.high are positive and < 2**128 and 0 <= x < P
func assert_reduced_felt256{range_check_ptr}(x: Uint256) {
    assert [range_check_ptr] = x.low;
    assert [range_check_ptr + 1] = x.high;
    assert [range_check_ptr + 2] = P1_256 - x.high;

    if (x.high == P1_256) {
        assert [range_check_ptr + 3] = P0_256 - 1 - x.low;
        tempvar range_check_ptr = range_check_ptr + 4;
        return ();
    } else {
        tempvar range_check_ptr = range_check_ptr + 3;
        return ();
    }
}
namespace fq_bigint3 {
    func add{range_check_ptr}(a: BigInt3, b: BigInt3) -> BigInt3 {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        %{
            from src.hints.fq import get_p, bigint_split, get_p_limbs
            BASE = ids.BASE
            p = get_p(ids)
            p_limbs = get_p_limbs(ids)

            sum_limbs = [getattr(getattr(ids, 'a'), 'd'+str(i)) + getattr(getattr(ids, 'b'), 'd'+str(i)) for i in range(ids.N_LIMBS)]
            sum_unreduced = sum([sum_limbs[i] * BASE**i for i in range(ids.N_LIMBS)])
            sum_reduced = [sum_limbs[i] - p_limbs[i] for i in range(ids.N_LIMBS)]
            has_carry = [1 if sum_limbs[0] >= BASE else 0]
            for i in range(1,ids.N_LIMBS):
                if sum_limbs[i] + has_carry[i-1] >= BASE:
                    has_carry.append(1)
                else:
                    has_carry.append(0)
            needs_reduction = 1 if sum_unreduced >= p else 0
            has_borrow_carry_reduced = [-1 if sum_reduced[0] < 0 else (1 if sum_reduced[0]>=BASE else 0)]
            for i in range(1,ids.N_LIMBS):
                if (sum_reduced[i] + has_borrow_carry_reduced[i-1]) < 0:
                    has_borrow_carry_reduced.append(-1)
                elif (sum_reduced[i] + has_borrow_carry_reduced[i-1]) >= BASE:
                    has_borrow_carry_reduced.append(1)
                else:
                    has_borrow_carry_reduced.append(0)

            memory[ap] = needs_reduction
            for i in range(ids.N_LIMBS-1):
                if needs_reduction:
                    memory[ap+1+i] = has_borrow_carry_reduced[i]
                else:
                    memory[ap+1+i] = has_carry[i]
        %}

        ap += N_LIMBS;

        let needs_reduction = [ap - 3];
        let cb_d0 = [ap - 2];
        let cb_d1 = [ap - 1];

        if (needs_reduction != 0) {
            // Needs reduction over P.

            local res: BigInt3 = BigInt3(
                (-P0) + a.d0 + b.d0 - cb_d0 * BASE,
                (-P1) + a.d1 + b.d1 + cb_d0 - cb_d1 * BASE,
                (-P2) + a.d2 + b.d2 + cb_d1,
            );

            assert [range_check_ptr] = BASE_MIN_1 - res.d0;
            assert [range_check_ptr + 1] = BASE_MIN_1 - res.d1;
            assert [range_check_ptr + 2] = P2 - res.d2;

            if (res.d2 == P2) {
                if (res.d1 == P1) {
                    assert [range_check_ptr + 3] = P0 - 1 - res.d0;
                    tempvar range_check_ptr = range_check_ptr + 4;
                    return res;
                } else {
                    assert [range_check_ptr + 3] = P1 - 1 - res.d1;
                    tempvar range_check_ptr = range_check_ptr + 4;
                    return res;
                }
            } else {
                tempvar range_check_ptr = range_check_ptr + 3;
                return res;
            }
        } else {
            // No reduction over P.

            local res: BigInt3 = BigInt3(
                a.d0 + b.d0 - cb_d0 * BASE, a.d1 + b.d1 + cb_d0 - cb_d1 * BASE, a.d2 + b.d2 + cb_d1
            );
            assert [range_check_ptr] = BASE_MIN_1 - res.d0;
            assert [range_check_ptr + 1] = BASE_MIN_1 - res.d1;
            assert [range_check_ptr + 2] = P2 - res.d2;

            if (res.d2 == P2) {
                if (res.d1 == P1) {
                    assert [range_check_ptr + 3] = P0 - 1 - res.d0;
                    tempvar range_check_ptr = range_check_ptr + 4;
                    return res;
                } else {
                    assert [range_check_ptr + 3] = P1 - 1 - res.d1;
                    tempvar range_check_ptr = range_check_ptr + 4;
                    return res;
                }
            } else {
                tempvar range_check_ptr = range_check_ptr + 3;
                return res;
            }
        }
    }

    func sub{range_check_ptr}(a: BigInt3, b: BigInt3) -> BigInt3 {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        %{
            from src.hints.fq import get_p, bigint_split, get_p_limbs
            BASE = ids.BASE
            p = get_p(ids)
            p_limbs = get_p_limbs(ids)

            sub_limbs = [getattr(getattr(ids, 'a'), 'd'+str(i)) - getattr(getattr(ids, 'b'), 'd'+str(i)) for i in range(ids.N_LIMBS)]
            sub_unreduced = sum([sub_limbs[i] * BASE**i for i in range(ids.N_LIMBS)])
            sub_reduced = [sub_limbs[i] + p_limbs[i] for i in range(ids.N_LIMBS)]
            has_borrow = [-1 if sub_limbs[0] < 0 else 0]
            for i in range(1,ids.N_LIMBS):
                if sub_limbs[i] + has_borrow[i-1] < 0:
                    has_borrow.append(-1)
                else:
                    has_borrow.append(0)
            needs_reduction = 1 if sub_unreduced < 0 else 0
            has_borrow_carry_reduced = [-1 if sub_reduced[0] < 0 else (1 if sub_reduced[0]>=BASE else 0)]
            for i in range(1,ids.N_LIMBS):
                if (sub_reduced[i] + has_borrow_carry_reduced[i-1]) < 0:
                    has_borrow_carry_reduced.append(-1)
                elif (sub_reduced[i] + has_borrow_carry_reduced[i-1]) >= BASE:
                    has_borrow_carry_reduced.append(1)
                else:
                    has_borrow_carry_reduced.append(0)
                    
            memory[ap] = needs_reduction
            for i in range(ids.N_LIMBS-1):
                if needs_reduction:
                    memory[ap+1+i] = has_borrow_carry_reduced[i]
                else:
                    memory[ap+1+i] = has_borrow[i]
        %}

        ap += N_LIMBS;

        let needs_reduction = [ap - 3];
        let cb_d0 = [ap - 2];
        let cb_d1 = [ap - 1];

        if (needs_reduction != 0) {
            // Needs reduction over P.
            local res: BigInt3 = BigInt3(
                P0 + a.d0 - b.d0 - cb_d0 * BASE,
                P1 + a.d1 - b.d1 + cb_d0 - cb_d1 * BASE,
                P2 + a.d2 - b.d2 + cb_d1,
            );

            assert [range_check_ptr] = BASE_MIN_1 - res.d0;
            assert [range_check_ptr + 1] = BASE_MIN_1 - res.d1;
            assert [range_check_ptr + 2] = P2 - res.d2;
            if (res.d2 == P2) {
                if (res.d1 == P1) {
                    assert [range_check_ptr + 3] = P0 - 1 - res.d0;
                    tempvar range_check_ptr = range_check_ptr + 4;
                    return res;
                } else {
                    assert [range_check_ptr + 3] = P1 - 1 - res.d1;
                    tempvar range_check_ptr = range_check_ptr + 4;
                    return res;
                }
            } else {
                tempvar range_check_ptr = range_check_ptr + 3;
                return res;
            }
        } else {
            // No reduction over P.
            local res: BigInt3 = BigInt3(
                a.d0 - b.d0 - cb_d0 * BASE, a.d1 - b.d1 + cb_d0 - cb_d1 * BASE, a.d2 - b.d2 + cb_d1
            );

            assert [range_check_ptr] = BASE_MIN_1 - res.d0;
            assert [range_check_ptr + 1] = BASE_MIN_1 - res.d1;
            assert [range_check_ptr + 2] = P2 - res.d2;
            if (res.d2 == P2) {
                if (res.d1 == P1) {
                    assert [range_check_ptr + 3] = P0 - 1 - res.d0;
                    tempvar range_check_ptr = range_check_ptr + 4;
                    return res;
                } else {
                    assert [range_check_ptr + 3] = P1 - 1 - res.d1;
                    tempvar range_check_ptr = range_check_ptr + 4;
                    return res;
                }
            } else {
                tempvar range_check_ptr = range_check_ptr + 3;
                return res;
            }
        }
    }
    func mul{range_check_ptr}(a: BigInt3, b: BigInt3) -> BigInt3 {
        // a and b must be reduced mod P and in their unique representation
        // a = a0 + a1*B + a2*B², with 0 <= a0, a1, a2 < B and 0 < a < P
        alloc_locals;
        local q: BigInt3;
        local r: BigInt3;
        %{
            from src.hints.fq import bigint_pack, bigint_fill, get_p
            assert 1 < ids.N_LIMBS <= 12
            a=bigint_pack(ids.a, ids.N_LIMBS, ids.BASE)
            b=bigint_pack(ids.b, ids.N_LIMBS, ids.BASE)
            p = get_p(ids)
            q, r = divmod(a*b, p)
            bigint_fill(q, ids.q, ids.N_LIMBS, ids.BASE)
            bigint_fill(r, ids.r, ids.N_LIMBS, ids.BASE)
        %}
        tempvar pow127 = 2 ** 127;

        tempvar c0 = (q.d0 * P0 + r.d0 - a.d0 * b.d0) / BASE;
        tempvar c1 = (q.d0 * P1 + q.d1 * P0 + r.d1 - a.d0 * b.d1 - a.d1 * b.d0 + c0) / BASE;
        tempvar c2 = (
            q.d0 * P2 + q.d1 * P1 + q.d2 * P0 + r.d2 - a.d0 * b.d2 - a.d1 * b.d1 - a.d2 * b.d0 + c1
        ) / BASE;
        tempvar c3 = (q.d1 * P2 + q.d2 * P1 - a.d1 * b.d2 - a.d2 * b.d1 + c2) / BASE;
        tempvar c4 = (q.d2 * P2 - a.d2 * b.d2 + c3);

        // This ensure all (q*P +r) limbs don't overlfow by restricting q limbs in [-2**127, 2**127).
        assert [range_check_ptr] = pow127 + q.d0;
        assert [range_check_ptr + 1] = pow127 + q.d1;
        assert [range_check_ptr + 2] = pow127 + q.d2;

        // This ensure the carries are small enough so that following carries don't overflow.
        assert [range_check_ptr + 3] = pow127 + c0;
        assert [range_check_ptr + 4] = pow127 + c1;
        assert [range_check_ptr + 5] = pow127 + c2;
        assert [range_check_ptr + 6] = pow127 + c3;

        // This ensure q*P + r = val
        assert c4 = 0;

        // This ensure r is a reduced field element (r < P).
        assert [range_check_ptr + 7] = r.d0;
        assert [range_check_ptr + 8] = r.d1;
        assert [range_check_ptr + 9] = r.d2;
        assert [range_check_ptr + 10] = BASE_MIN_1 - r.d0;
        assert [range_check_ptr + 11] = BASE_MIN_1 - r.d1;
        assert [range_check_ptr + 12] = P2 - r.d2;

        if (r.d2 == P2) {
            if (r.d1 == P1) {
                assert [range_check_ptr + 13] = P0 - 1 - r.d0;
                tempvar range_check_ptr = range_check_ptr + 14;
                return r;
            } else {
                assert [range_check_ptr + 13] = P1 - 1 - r.d1;
                tempvar range_check_ptr = range_check_ptr + 14;
                return r;
            }
        } else {
            tempvar range_check_ptr = range_check_ptr + 13;
            return r;
        }
    }
    func neg{range_check_ptr}(a: BigInt3) -> BigInt3 {
        return sub(BigInt3(0, 0, 0), a);
    }

    func inv{range_check_ptr}(a: BigInt3) -> BigInt3 {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local inv: BigInt3;
        %{
            from src.hints.fq import bigint_fill, bigint_pack, get_p
            assert 1 < ids.N_LIMBS <= 12

            a = bigint_pack(ids.a, ids.N_LIMBS, ids.BASE)
            p = get_p(ids)

            inv = pow(a, -1, p)
            bigint_fill(inv, ids.inv, ids.N_LIMBS, ids.BASE)
        %}

        let x_x_inv = mul(a, inv);

        assert x_x_inv.d0 = 1;
        assert x_x_inv.d1 = 0;
        assert x_x_inv.d2 = 0;

        assert [range_check_ptr] = inv.d0;
        assert [range_check_ptr + 1] = inv.d1;
        assert [range_check_ptr + 2] = inv.d2;
        assert [range_check_ptr + 3] = BASE_MIN_1 - inv.d0;
        assert [range_check_ptr + 4] = BASE_MIN_1 - inv.d1;
        assert [range_check_ptr + 5] = P2 - inv.d2;

        if (inv.d2 == P2) {
            if (inv.d1 == P1) {
                assert [range_check_ptr + 6] = P0 - 1 - inv.d0;
                tempvar range_check_ptr = range_check_ptr + 7;
                return inv;
            } else {
                assert [range_check_ptr + 6] = P1 - 1 - inv.d1;
                tempvar range_check_ptr = range_check_ptr + 7;
                return inv;
            }
        } else {
            tempvar range_check_ptr = range_check_ptr + 6;
            return inv;
        }
    }
}

func verify_zero5{range_check_ptr}(val: UnreducedBigInt5) {
    alloc_locals;
    local q: BigInt3;
    %{
        from src.hints.fq import bigint_pack, bigint_fill, get_p
        val = bigint_pack(ids.val, ids.N_LIMBS_UNREDUCED, ids.BASE)
        p = get_p(ids)
        q, r = divmod(val, p)
        assert r == 0, f"val is not a multiple of p: {val} % {p} = {r}"
        bigint_fill(q, ids.q, ids.N_LIMBS, ids.BASE)
    %}

    tempvar pow127 = 2 ** 127;

    tempvar c0 = (q.d0 * P0 - val.d0) / BASE;
    tempvar c1 = (q.d0 * P1 + q.d1 * P0 - val.d1 + c0) / BASE;
    tempvar c2 = (q.d0 * P2 + q.d1 * P1 + q.d2 * P0 - val.d2 + c1) / BASE;
    tempvar c3 = (q.d1 * P2 + q.d2 * P1 - val.d3 + c2) / BASE;
    tempvar c4 = (q.d2 * P2 - val.d4 + c3);

    // This ensure all (q*P) limbs don't overlfow by restricting q limbs in [-2**127, 2**127).
    assert [range_check_ptr] = pow127 + q.d0;
    assert [range_check_ptr + 1] = pow127 + q.d1;
    assert [range_check_ptr + 2] = pow127 + q.d2;

    // This ensure the carries are small enough so that following carries don't overflow.
    assert [range_check_ptr + 3] = pow127 + c0;
    assert [range_check_ptr + 4] = pow127 + c1;
    assert [range_check_ptr + 5] = pow127 + c2;
    assert [range_check_ptr + 6] = pow127 + c3;

    // This ensure q*P  = val
    assert c4 = 0;
    tempvar range_check_ptr = range_check_ptr + 7;
    return ();
}

// returns 1 if x ==0 mod alt_bn128 prime
func is_zero{range_check_ptr}(x: UnreducedBigInt3) -> (res: felt) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    let red = reduce_3(x);
    let is_zero = fq_eq_zero(red);
    if (is_zero != 0) {
        return (res=1);
    } else {
        return (res=0);
    }
}

func reduce_5{range_check_ptr}(val: UnreducedBigInt5) -> BigInt3 {
    alloc_locals;
    local q: BigInt3;
    local r: BigInt3;

    %{
        from src.hints.fq import bigint_pack, bigint_fill, get_p
        val = bigint_pack(ids.val, ids.N_LIMBS_UNREDUCED, ids.BASE)
        p = get_p(ids)
        q, r = divmod(val, p)
        bigint_fill(q, ids.q, ids.N_LIMBS, ids.BASE)
        bigint_fill(r, ids.r, ids.N_LIMBS, ids.BASE)
    %}
    tempvar pow127 = 2 ** 127;

    tempvar c0 = (q.d0 * P0 + r.d0 - val.d0) / BASE;
    tempvar c1 = (q.d0 * P1 + q.d1 * P0 + r.d1 - val.d1 + c0) / BASE;
    tempvar c2 = (q.d0 * P2 + q.d1 * P1 + q.d2 * P0 + r.d2 - val.d2 + c1) / BASE;
    tempvar c3 = (q.d1 * P2 + q.d2 * P1 - val.d3 + c2) / BASE;
    tempvar c4 = (q.d2 * P2 - val.d4 + c3);

    // This ensure all (q*P +r) limbs don't overlfow by restricting q limbs in [-2**127, 2**127).
    assert [range_check_ptr] = pow127 + q.d0;
    assert [range_check_ptr + 1] = pow127 + q.d1;
    assert [range_check_ptr + 2] = pow127 + q.d2;

    // This ensure the carries are small enough so that following carries don't overflow.
    assert [range_check_ptr + 3] = pow127 + c0;
    assert [range_check_ptr + 4] = pow127 + c1;
    assert [range_check_ptr + 5] = pow127 + c2;
    assert [range_check_ptr + 6] = pow127 + c3;

    // This ensure q*P + r = val
    assert c4 = 0;

    // This ensure r is a reduced field element (0 < r < P).
    assert [range_check_ptr + 7] = BASE_MIN_1 - r.d0;
    assert [range_check_ptr + 8] = BASE_MIN_1 - r.d1;
    assert [range_check_ptr + 9] = P2 - r.d2;
    assert [range_check_ptr + 10] = r.d0;
    assert [range_check_ptr + 11] = r.d1;
    assert [range_check_ptr + 12] = r.d2;

    if (r.d2 == P2) {
        if (r.d1 == P1) {
            assert [range_check_ptr + 13] = P0 - 1 - r.d0;
            tempvar range_check_ptr = range_check_ptr + 14;
            return r;
        } else {
            assert [range_check_ptr + 13] = P1 - 1 - r.d1;
            tempvar range_check_ptr = range_check_ptr + 14;
            return r;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr + 13;
        return r;
    }
}

func reduce_3{range_check_ptr}(val: UnreducedBigInt3) -> BigInt3 {
    alloc_locals;
    local q: felt;
    local r: BigInt3;
    local flag0: felt;
    local flag1: felt;
    local q0: felt;
    local q1: felt;

    %{
        from src.hints.fq import bigint_limbs, bigint_pack, bigint_split, get_p, get_p_limbs, fill_limbs

        val_limbs = bigint_limbs(ids.val, ids.N_LIMBS)
        val = bigint_pack(ids.val, ids.N_LIMBS, ids.BASE)
        p = get_p(ids)
        p_limbs = get_p_limbs(ids)

        def reduce_zero_poly(x:list):
            x = x.copy()
            carries = [0] * (len(x)-1)
            for i in range(0, len(x)-1):
                carries[i] = x[i] // ids.BASE
                x[i] = x[i] % ids.BASE
                assert x[i] == 0
                x[i+1] += carries[i]
            assert x[-1] == 0
            return carries

        q, r = divmod(val, p)
        r_limbs = bigint_split(r, ids.N_LIMBS, ids.BASE)
        q_P_plus_r_limbs = [q*Pi + ri for Pi, ri in zip(p_limbs, r_limbs)]
        diff_limbs = [q_P_plus_r_limbs[i] - val_limbs[i] for i in range(ids.N_LIMBS)]
        carries = reduce_zero_poly(diff_limbs)
        carries = [abs(x) for x in carries]
        flags = [1 if diff_limbs[i] >= 0 else 0 for i in range(len(diff_limbs) - 1)]

        ids.q = q
        fill_limbs(r_limbs, ids.r)
        for i in range(ids.N_LIMBS-1):
            setattr(ids, 'flag'+str(i), flags[i])
            setattr(ids, 'q'+str(i), carries[i])
    %}

    // This ensure q_i * BASE or -q_i * BASE doesn't overlfow PRIME.
    // It is very important as we can assert diff_i has the form diff_i = k * BASE + 0.
    // Since the euclidean division gives uniqueness and RC_BOUND * BASE = 2**214 < PRIME, it is enough.
    // See https://github.com/starkware-libs/cairo-lang/blob/40404870166edc1e1fc5778fe39a29f981121ef9/src/starkware/cairo/common/math.cairo#L289-L312
    // let q_abs = abs_value(q);

    assert [range_check_ptr + 0] = q0;
    assert [range_check_ptr + 1] = q1;

    // This ensure all (q*P +r) limbs don't overlfow by restricting q in [-2**127, 2**127).

    assert [range_check_ptr + 2] = 2 ** 127 + q;

    // diff = q*p + r - val
    // diff(base) = 0

    // tempvar diff_d0 = q * P0 + r.d0 - val.d0;
    // tempvar diff_d1 = q * P1 + r.d1 - val.d1;
    // tempvar diff_d2 = q * P2 + r.d2 - val.d2;

    // Since diff(base) = 0, diff_i has the form diff_i = k * BASE + 0
    // When we reduce each limb % BASE and propagate the carries k=(limb//BASE), all coefficients should be 0.
    // So for each i diff_i%BASE is 0 and we propagate the carry k to diff_(i+1), until the end,
    // ensuring diff(base) is indeed 0.

    if (flag0 != 0) {
        assert q * P0 + r.d0 - val.d0 = q0 * BASE;
        if (flag1 != 0) {
            assert q * P1 + r.d1 - val.d1 + q0 = q1 * BASE;
            assert q * P2 + r.d2 = val.d2 - q1;
        } else {
            assert q * P1 + r.d1 + q0 + q1 * BASE = val.d1;
            assert q * P2 + r.d2 = val.d2 + q1;
        }
    } else {
        assert q * P0 + r.d0 + q0 * BASE = val.d0;
        if (flag1 != 0) {
            assert q * P1 + r.d1 - val.d1 - q0 = q1 * BASE;
            assert q * P2 + r.d2 = val.d2 - q1;
        } else {
            assert q * P1 + r.d1 - q0 + q1 * BASE = val.d1;
            assert q * P2 + r.d2 = val.d2 + q1;
        }
    }

    // ensure r is a reduced field element
    assert [range_check_ptr + 3] = BASE_MIN_1 - r.d0;
    assert [range_check_ptr + 4] = BASE_MIN_1 - r.d1;
    assert [range_check_ptr + 5] = P2 - r.d2;
    assert [range_check_ptr + 6] = r.d0;
    assert [range_check_ptr + 7] = r.d1;
    assert [range_check_ptr + 8] = r.d2;

    if (r.d2 == P2) {
        if (r.d1 == P1) {
            assert [range_check_ptr + 9] = P0 - 1 - r.d0;
            tempvar range_check_ptr = range_check_ptr + 10;
            return r;
        } else {
            assert [range_check_ptr + 9] = P1 - 1 - r.d1;
            tempvar range_check_ptr = range_check_ptr + 10;
            return r;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr + 9;
        return r;
    }
}
