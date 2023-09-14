from starkware.cairo.common.uint256 import SHIFT, Uint256
from starkware.cairo.common.cairo_secp.bigint import (
    BigInt3,
    bigint_mul,
    UnreducedBigInt5,
    UnreducedBigInt3,
    nondet_bigint3 as nd,
    uint256_to_bigint,
)
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.math import abs_value, split_felt

from src.bn254.curve import P0, P1, P2, N_LIMBS, N_LIMBS_UNREDUCED, DEGREE, BASE, P0_256, P1_256

const SHIFT_MIN_BASE = SHIFT - BASE;
const SHIFT_MIN_P2 = SHIFT - P2 - 1;
const BASE_MIN_1 = BASE - 1;

func unrededucedUint256_to_BigInt3{range_check_ptr}(x: Uint256) -> (res: BigInt3*) {
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

func assert_fq_eq(x: BigInt3*, y: BigInt3*) {
    assert 0 = x.d0 - y.d0;
    assert 0 = x.d1 - y.d1;
    assert 0 = x.d2 - y.d2;
    return ();
}

func bigint_sqr(x: BigInt3) -> (res: UnreducedBigInt5) {
    return (
        UnreducedBigInt5(
            d0=x.d0 * x.d0,
            d1=2 * x.d0 * x.d1,
            d2=2 * x.d0 * x.d2 + x.d1 * x.d1,
            d3=2 * x.d1 * x.d2,
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
    func add{range_check_ptr}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        %{
            from src.bn254.hints import p, base as BASE, p_limbs

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
                    return &res;
                } else {
                    assert [range_check_ptr + 3] = P1 - 1 - res.d1;
                    tempvar range_check_ptr = range_check_ptr + 4;
                    return &res;
                }
            } else {
                tempvar range_check_ptr = range_check_ptr + 3;
                return &res;
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
                    return &res;
                } else {
                    assert [range_check_ptr + 3] = P1 - 1 - res.d1;
                    tempvar range_check_ptr = range_check_ptr + 4;
                    return &res;
                }
            } else {
                tempvar range_check_ptr = range_check_ptr + 3;
                return &res;
            }
        }
    }

    func sub{range_check_ptr}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        %{
            from src.bn254.hints import p, base as BASE, p_limbs

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
                    return &res;
                } else {
                    assert [range_check_ptr + 3] = P1 - 1 - res.d1;
                    tempvar range_check_ptr = range_check_ptr + 4;
                    return &res;
                }
            } else {
                tempvar range_check_ptr = range_check_ptr + 3;
                return &res;
            }
        } else {
            // No reduction over P.
            local res: BigInt3 = BigInt3(
                a.d0 - b.d0 - cb_d0 * BASE, a.d1 - b.d1 + cb_d0 - cb_d1 * BASE, a.d2 - b.d2 + cb_d1
            );

            assert [range_check_ptr] = res.d0 + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = res.d1 + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 2] = res.d2 + (SHIFT_MIN_P2);
            if (res.d2 == P2) {
                if (res.d1 == P1) {
                    assert [range_check_ptr + 3] = P0 - 1 - res.d0;
                    tempvar range_check_ptr = range_check_ptr + 4;
                    return &res;
                } else {
                    assert [range_check_ptr + 3] = P1 - 1 - res.d1;
                    tempvar range_check_ptr = range_check_ptr + 4;
                    return &res;
                }
            } else {
                tempvar range_check_ptr = range_check_ptr + 3;
                return &res;
            }
        }
    }
    func mul{range_check_ptr}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
        // a and b must be reduced mod P and in their unique representation
        // a = a0 + a1*B + a2*B², with 0 <= a0, a1, a2 < B and 0 < a < P
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local q: BigInt3;
        local r: BigInt3;
        local flag0: felt;
        local flag1: felt;
        local flag2: felt;
        local flag3: felt;
        local q0: felt;
        local q1: felt;
        local q2: felt;
        local q3: felt;

        %{
            from starkware.cairo.common.math_utils import as_int
            assert 1 < ids.N_LIMBS <= 12
            assert ids.DEGREE == ids.N_LIMBS-1
            a,b,p=0,0,0
            a_limbs, b_limbs, p_limbs = ids.N_LIMBS*[0], ids.N_LIMBS*[0], ids.N_LIMBS*[0]
            def split(x, degree=ids.DEGREE, base=ids.BASE):
                coeffs = []
                for n in range(degree, 0, -1):
                    q, r = divmod(x, base ** n)
                    coeffs.append(q)
                    x = r
                coeffs.append(x)
                return coeffs[::-1]

            def poly_mul(a:list, b:list,n=ids.N_LIMBS) -> list:
                assert len(a) == len(b) == n
                result = [0] * ids.N_LIMBS_UNREDUCED
                for i in range(n):
                    for j in range(n):
                        result[i+j] += a[i]*b[j]
                return result
            def poly_mul_plus_c(a:list, b:list, c:list, n=ids.N_LIMBS) -> list:
                assert len(a) == len(b) == n
                result = [0] * ids.N_LIMBS_UNREDUCED
                for i in range(n):
                    for j in range(n):
                        result[i+j] += a[i]*b[j]
                for i in range(n):
                    result[i] += c[i]
                return result
            def poly_sub(a:list, b:list, n=ids.N_LIMBS_UNREDUCED) -> list:
                assert len(a) == len(b) == n
                result = [0] * n
                for i in range(n):
                    result[i] = a[i] - b[i]
                return result

            def abs_poly(x:list):
                result = [0] * len(x)
                for i in range(len(x)):
                    result[i] = abs(x[i])
                return result

            def reduce_zero_poly(x:list):
                x = x.copy()
                carries = [0] * (len(x)-1)
                for i in range(0, len(x)-1):
                    carries[i] = x[i] // ids.BASE
                    x[i] = x[i] % ids.BASE
                    assert x[i] == 0
                    x[i+1] += carries[i]
                assert x[-1] == 0
                return x, carries

            for i in range(ids.N_LIMBS):
                a+=as_int(getattr(ids.a, 'd'+str(i)),PRIME) * ids.BASE**i
                b+=as_int(getattr(ids.b, 'd'+str(i)),PRIME) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
                a_limbs[i]=as_int(getattr(ids.a, 'd'+str(i)),PRIME)
                b_limbs[i]=as_int(getattr(ids.b, 'd'+str(i)),PRIME)
                p_limbs[i]=getattr(ids, 'P'+str(i))

            mul = a*b
            q, r = divmod(mul, p)
            qs, rs = split(q), split(r)
            for i in range(ids.N_LIMBS):
                setattr(ids.r, 'd'+str(i), rs[i])
                setattr(ids.q, 'd'+str(i), qs[i])

            val_limbs = poly_mul(a_limbs, b_limbs)
            q_P_plus_r_limbs = poly_mul_plus_c(qs, p_limbs, rs)
            diff_limbs = poly_sub(q_P_plus_r_limbs, val_limbs)
            _, carries = reduce_zero_poly(diff_limbs)
            carries = abs_poly(carries)
            for i in range(ids.N_LIMBS_UNREDUCED-1):
                setattr(ids, 'flag'+str(i), 1 if diff_limbs[i] >= 0 else 0)
                setattr(ids, 'q'+str(i), carries[i])
        %}

        // This ensure q_i * BASE or -q_i * BASE doesn't overlfow PRIME.
        // It is very important as we can assert diff_i has the form diff_i = k * BASE + 0.
        // Since the euclidean division gives uniqueness and RC_BOUND * BASE = 2**214 < PRIME, it is enough.
        // See https://github.com/starkware-libs/cairo-lang/blob/40404870166edc1e1fc5778fe39a29f981121ef9/src/starkware/cairo/common/math.cairo#L289-L312

        assert [range_check_ptr + 0] = q0;
        assert [range_check_ptr + 1] = q1;
        assert [range_check_ptr + 2] = q2;
        assert [range_check_ptr + 3] = q3;

        // This ensure all (q*P +r) limbs don't overlfow.

        assert [range_check_ptr + 4] = q.d0;
        assert [range_check_ptr + 5] = q.d1;
        assert [range_check_ptr + 6] = q.d2;
        assert [range_check_ptr + 7] = r.d0;
        assert [range_check_ptr + 8] = r.d1;
        assert [range_check_ptr + 9] = r.d2;

        // diff = q*p + r - a*b
        // diff(base) = 0

        tempvar diff_d0 = q.d0 * P0 + r.d0 - a.d0 * b.d0;
        tempvar diff_d1 = q.d0 * P1 + q.d1 * P0 + r.d1 - a.d0 * b.d1 - a.d1 * b.d0;
        tempvar diff_d2 = q.d0 * P2 + q.d1 * P1 + q.d2 * P0 + r.d2 - a.d0 * b.d2 - a.d1 * b.d1 -
            a.d2 * b.d0;
        tempvar diff_d3 = q.d1 * P2 + q.d2 * P1 - a.d1 * b.d2 - a.d2 * b.d1;
        // tempvar diff_d4 = q.d2 * P2 - a.d2 * b.d2;

        local carry0: felt;
        local carry1: felt;
        local carry2: felt;
        local carry3: felt;

        // Since diff(base) = 0, diff_i has the form diff_i = k * BASE + 0
        // When we reduce each limb % BASE and propagate the carries (limb//BASE), all coefficients should be 0.
        // So for each i diff_i%BASE is 0 and we propagate the carry k to diff_(i+1), until the end,
        // ensuring diff(base) is indeed 0.

        if (flag0 != 0) {
            assert diff_d0 = q0 * BASE;
            assert carry0 = q0;
        } else {
            assert carry0 = (-1) * q0;
            assert diff_d0 = carry0 * BASE;
        }

        if (flag1 != 0) {
            assert diff_d1 + carry0 = q1 * BASE;
            assert carry1 = q1;
        } else {
            assert carry1 = (-1) * q1;
            assert diff_d1 + carry0 = carry1 * BASE;
        }

        if (flag2 != 0) {
            assert diff_d2 + carry1 = q2 * BASE;
            assert carry2 = q2;
        } else {
            assert carry2 = (-1) * q2;
            assert diff_d2 + carry1 = carry2 * BASE;
        }

        if (flag3 != 0) {
            assert diff_d3 + carry2 = q3 * BASE;
            assert carry3 = q3;
        } else {
            assert carry3 = (-1) * q3;
            assert diff_d3 + carry2 = carry3 * BASE;
        }

        assert q.d2 * P2 - a.d2 * b.d2 + carry3 = 0;

        // This ensure r is a reduced field element (r < P).

        assert [range_check_ptr + 10] = BASE_MIN_1 - r.d0;
        assert [range_check_ptr + 11] = BASE_MIN_1 - r.d1;
        assert [range_check_ptr + 12] = P2 - r.d2;

        if (r.d2 == P2) {
            if (r.d1 == P1) {
                assert [range_check_ptr + 13] = P0 - 1 - r.d0;
                tempvar range_check_ptr = range_check_ptr + 14;
                return &r;
            } else {
                assert [range_check_ptr + 13] = P1 - 1 - r.d1;
                tempvar range_check_ptr = range_check_ptr + 14;
                return &r;
            }
        } else {
            tempvar range_check_ptr = range_check_ptr + 13;
            return &r;
        }
    }

    func neg{range_check_ptr}(a: BigInt3*) -> BigInt3* {
        alloc_locals;
        tempvar zero: BigInt3* = new BigInt3(0, 0, 0);
        return sub(zero, a);
    }

    func inv{range_check_ptr}(a: BigInt3*) -> BigInt3* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local inv: BigInt3;
        %{
            from starkware.cairo.common.math_utils import as_int    
            assert 1 < ids.N_LIMBS <= 12
            assert ids.DEGREE == ids.N_LIMBS-1
            a,p=0,0

            def split(x, degree=ids.DEGREE, base=ids.BASE):
                coeffs = []
                for n in range(degree, 0, -1):
                    q, r = divmod(x, base ** n)
                    coeffs.append(q)
                    x = r
                coeffs.append(x)
                return coeffs[::-1]

            for i in range(ids.N_LIMBS):
                a+=as_int(getattr(ids.a, 'd'+str(i)), PRIME) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

            inv = pow(a, -1, p)
            invs = split(inv)
            for i in range(ids.N_LIMBS):
                setattr(ids.inv, 'd'+str(i), invs[i])
        %}
        // let (inv) = nondet_bigint3();

        let x_x_inv = mul(a, &inv);

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
                return &inv;
            } else {
                assert [range_check_ptr + 6] = P1 - 1 - inv.d1;
                tempvar range_check_ptr = range_check_ptr + 7;
                return &inv;
            }
        } else {
            tempvar range_check_ptr = range_check_ptr + 6;
            return &inv;
        }
    }
}

func verify_zero3{range_check_ptr}(val: BigInt3) {
    alloc_locals;
    local q: felt;
    local flag0: felt;
    local flag1: felt;
    local q0: felt;
    local q1: felt;
    %{
        from starkware.cairo.common.math_utils import as_int
        assert 1 < ids.N_LIMBS <= 12
        assert ids.DEGREE == ids.N_LIMBS-1
        val, p=0,0
        val_limbs, p_limbs = ids.N_LIMBS*[0], ids.N_LIMBS*[0]
        def split(x, degree=ids.DEGREE, base=ids.BASE):
            coeffs = []
            for n in range(degree, 0, -1):
                q, r = divmod(x, base ** n)
                coeffs.append(q)
                x = r
            coeffs.append(x)
            return coeffs[::-1]

        def poly_sub(a:list, b:list, n=ids.N_LIMBS) -> list:
            assert len(a) == len(b) == n
            result = [0] * n
            for i in range(n):
                result[i] = a[i] - b[i]
            return result

        def abs_poly(x:list):
            result = [0] * len(x)
            for i in range(len(x)):
                result[i] = abs(x[i])
            return result

        def reduce_zero_poly(x:list):
            x = x.copy()
            carries = [0] * (len(x)-1)
            for i in range(0, len(x)-1):
                carries[i] = x[i] // ids.BASE
                x[i] = x[i] % ids.BASE
                assert x[i] == 0
                x[i+1] += carries[i]
            assert x[-1] == 0
            return x, carries

        for i in range(ids.N_LIMBS):
            p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
            p_limbs[i]=getattr(ids, 'P'+str(i))
            val_limbs[i]+=as_int(getattr(ids.val, 'd'+str(i)), PRIME)
            val+=as_int(getattr(ids.val, 'd'+str(i)), PRIME) * ids.BASE**i

        mul = val
        q, r = divmod(mul, p)

        assert r == 0, f"verify_zero: Invalid input."
        ids.q = q

        q_P_limbs = [q*P for P in p_limbs]
        diff_limbs = poly_sub(q_P_limbs, val_limbs)
        _, carries = reduce_zero_poly(diff_limbs)
        carries = abs_poly(carries)
        for i in range(ids.N_LIMBS-1):
            setattr(ids, 'flag'+str(i), 1 if diff_limbs[i] >= 0 else 0)
            setattr(ids, 'q'+str(i), carries[i])
    %}
    assert [range_check_ptr] = q;
    assert [range_check_ptr + 1] = q0;
    assert [range_check_ptr + 2] = q1;

    if (flag0 != 0) {
        assert q * P0 - val.d0 = q0 * BASE;
        if (flag1 != 0) {
            assert q * P1 - val.d1 + q0 = q1 * BASE;
            assert q * P2 = val.d2 - q1;
        } else {
            assert q * P1 + q0 + q1 * BASE = val.d1;
            assert q * P2 = val.d2 + q1;
        }
    } else {
        assert q * P0 + q0 * BASE = val.d0;
        if (flag1 != 0) {
            assert q * P1 - val.d1 - q0 = q1 * BASE;
            assert q * P2 = val.d2 - q1;
        } else {
            assert q * P1 - q0 + q1 * BASE = val.d1;
            assert q * P2 = val.d2 + q1;
        }
    }
    tempvar range_check_ptr = range_check_ptr + 3;
    return ();
}

func verify_zero5{range_check_ptr}(val: UnreducedBigInt5) {
    alloc_locals;
    local q: BigInt3;
    local flag0: felt;
    local flag1: felt;
    local flag2: felt;
    local flag3: felt;
    local q0: felt;
    local q1: felt;
    local q2: felt;
    local q3: felt;

    %{
        from starkware.cairo.common.math_utils import as_int
        assert 1 < ids.N_LIMBS <= 12
        assert ids.DEGREE == ids.N_LIMBS-1
        val, p=0,0
        val_limbs, p_limbs = ids.N_LIMBS_UNREDUCED*[0], ids.N_LIMBS*[0]
        def split(x, degree=ids.DEGREE, base=ids.BASE):
            coeffs = []
            for n in range(degree, 0, -1):
                q, r = divmod(x, base ** n)
                coeffs.append(q)
                x = r
            coeffs.append(x)
            return coeffs[::-1]

        def poly_mul(a:list, b:list,n=ids.N_LIMBS) -> list:
            assert len(a) == len(b) == n
            result = [0] * ids.N_LIMBS_UNREDUCED
            for i in range(n):
                for j in range(n):
                    result[i+j] += a[i]*b[j]
            return result
        def poly_sub(a:list, b:list, n=ids.N_LIMBS_UNREDUCED) -> list:
            assert len(a) == len(b) == n
            result = [0] * n
            for i in range(n):
                result[i] = a[i] - b[i]
            return result

        def abs_poly(x:list):
            result = [0] * len(x)
            for i in range(len(x)):
                result[i] = abs(x[i])
            return result

        def reduce_zero_poly(x:list):
            x = x.copy()
            carries = [0] * (len(x)-1)
            for i in range(0, len(x)-1):
                carries[i] = x[i] // ids.BASE
                x[i] = x[i] % ids.BASE
                assert x[i] == 0
                x[i+1] += carries[i]
            assert x[-1] == 0
            return x, carries

        for i in range(ids.N_LIMBS_UNREDUCED):
            val_limbs[i]+=as_int(getattr(ids.val, 'd'+str(i)), PRIME)
            val+=as_int(getattr(ids.val, 'd'+str(i)), PRIME) * ids.BASE**i


        for i in range(ids.N_LIMBS):
            p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
            p_limbs[i]=getattr(ids, 'P'+str(i))

        mul = val
        q, r = divmod(mul, p)

        assert r == 0, f"verify_zero: Invalid input."
        qs = split(q)
        for i in range(ids.N_LIMBS):
            setattr(ids.q, 'd'+str(i), qs[i])

        q_P_limbs = poly_mul(qs, p_limbs)
        diff_limbs = poly_sub(q_P_limbs, val_limbs)
        _, carries = reduce_zero_poly(diff_limbs)
        carries = abs_poly(carries)
        for i in range(ids.N_LIMBS_UNREDUCED-1):
            setattr(ids, 'flag'+str(i), 1 if diff_limbs[i] >= 0 else 0)
            setattr(ids, 'q'+str(i), carries[i])
    %}

    // This ensure q_i * BASE or -q_i * BASE doesn't overlfow PRIME.
    assert [range_check_ptr + 0] = q0;
    assert [range_check_ptr + 1] = q1;
    assert [range_check_ptr + 2] = q2;
    assert [range_check_ptr + 3] = q3;

    // This ensure all (q*P +r) limbs don't overlfow by restricting q limbs in [-2**127, 2**127).

    assert [range_check_ptr + 4] = 2 ** 127 + q.d0;
    assert [range_check_ptr + 5] = 2 ** 127 + q.d1;
    assert [range_check_ptr + 6] = 2 ** 127 + q.d2;

    // diff = q*p - val
    // diff(base) = 0

    // tempvar diff_d0 = q.d0 * P0 - val.d0;
    // tempvar diff_d1 = q.d0 * P1 + q.d1 * P0 - val.d1;
    // tempvar diff_d2 = q.d0 * P2 + q.d1 * P1 + q.d2 * P0 - val.d2;
    // tempvar diff_d3 = q.d1 * P2 + q.d2 * P1 - val.d3;
    // tempvar diff_d4 = q.d2 * P2 - val.d4;

    // Checks that diff(base) = 0 depending on q limbs signs
    // Since diff(base) = 0, diff_i has the form diff_i = k * BASE + 0
    // See reduce_5 for more details.
    if (flag0 != 0) {
        assert q.d0 * P0 - val.d0 = q0 * BASE;
        if (flag1 != 0) {
            assert q.d0 * P1 + q.d1 * P0 - val.d1 + q0 = q1 * BASE;
            if (flag2 != 0) {
                assert q.d0 * P2 + q.d1 * P1 + q.d2 * P0 - val.d2 + q1 = q2 * BASE;
                if (flag3 != 0) {
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 + q2 = q3 * BASE;
                    assert q.d2 * P2 = val.d4 - q3;
                } else {
                    // let q3 = (-1) * q3;
                    assert q.d1 * P2 + q.d2 * P1 + q2 + q3 * BASE = val.d3;
                    assert q.d2 * P2 = val.d4 + q3;
                }
            } else {
                assert q.d0 * P2 + q.d1 * P1 + q.d2 * P0 + q1 + q2 * BASE = val.d2;
                if (flag3 != 0) {
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 - q2 = q3 * BASE;
                    assert q.d2 * P2 = val.d4 - q3;
                } else {
                    // let q3 = (-1) * q3;
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 + q3 * BASE = q2;
                    assert q.d2 * P2 = val.d4 + q3;
                }
            }
        } else {
            assert q.d0 * P1 + q.d1 * P0 + q0 + q1 * BASE = val.d1;
            if (flag2 != 0) {
                assert q.d0 * P2 + q.d1 * P1 + q.d2 * P0 - val.d2 - q1 = q2 * BASE;
                if (flag3 != 0) {
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 + q2 = q3 * BASE;
                    assert q.d2 * P2 = val.d4 - q3;
                } else {
                    // let q3 = (-1) * q3;
                    assert q.d1 * P2 + q.d2 * P1 + q2 + q3 * BASE = val.d3;
                    assert q.d2 * P2 = val.d4 + q3;
                }
            } else {
                assert q.d0 * P2 + q.d1 * P1 + q.d2 * P0 - val.d2 + q2 * BASE = q1;
                if (flag3 != 0) {
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 - q2 = q3 * BASE;
                    assert q.d2 * P2 = val.d4 - q3;
                } else {
                    // let q3 = (-1) * q3;
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 + q3 * BASE = q2;
                    assert q.d2 * P2 = val.d4 + q3;
                }
            }
        }
    } else {
        assert q.d0 * P0 + q0 * BASE = val.d0;
        if (flag1 != 0) {
            assert q.d0 * P1 + q.d1 * P0 - val.d1 - q0 = q1 * BASE;
            if (flag2 != 0) {
                assert q.d0 * P2 + q.d1 * P1 + q.d2 * P0 - val.d2 + q1 = q2 * BASE;
                if (flag3 != 0) {
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 + q2 = q3 * BASE;
                    assert q.d2 * P2 = val.d4 - q3;
                } else {
                    // let q3 = (-1) * q3;
                    assert q.d1 * P2 + q.d2 * P1 + q2 + q3 * BASE = val.d3;
                    assert q.d2 * P2 = val.d4 + q3;
                }
            } else {
                assert q.d0 * P2 + q.d1 * P1 + q.d2 * P0 + q1 + q2 * BASE = val.d2;
                if (flag3 != 0) {
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 - q2 = q3 * BASE;
                    assert q.d2 * P2 = val.d4 - q3;
                } else {
                    // let q3 = (-1) * q3;
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 + q3 * BASE = q2;
                    assert q.d2 * P2 = val.d4 + q3;
                }
            }
        } else {
            assert q.d0 * P1 + q.d1 * P0 - q0 + q1 * BASE = val.d1;
            if (flag2 != 0) {
                assert q.d0 * P2 + q.d1 * P1 + q.d2 * P0 - val.d2 - q1 = q2 * BASE;
                if (flag3 != 0) {
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 + q2 = q3 * BASE;
                    assert q.d2 * P2 = val.d4 - q3;
                } else {
                    // let q3 = (-1) * q3;
                    assert q.d1 * P2 + q.d2 * P1 + q2 + q3 * BASE = val.d3;
                    assert q.d2 * P2 = val.d4 + q3;
                }
            } else {
                assert q.d0 * P2 + q.d1 * P1 + q.d2 * P0 - q1 + q2 * BASE = val.d2;
                if (flag3 != 0) {
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 - q2 = q3 * BASE;
                    assert q.d2 * P2 = val.d4 - q3;
                } else {
                    // let q3 = (-1) * q3;
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 + q3 * BASE = q2;
                    assert q.d2 * P2 = val.d4 + q3;
                }
            }
        }
    }

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

func reduce_5{range_check_ptr}(val: UnreducedBigInt5) -> BigInt3* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local q: BigInt3;
    local r: BigInt3;
    local flag0: felt;
    local flag1: felt;
    local flag2: felt;
    local flag3: felt;
    local q0: felt;
    local q1: felt;
    local q2: felt;
    local q3: felt;

    %{
        from starkware.cairo.common.math_utils import as_int
        from src.bn254.hints import reduce_hint

        val_limbs = ids.N_LIMBS_UNREDUCED*[0]

        for i in range(ids.N_LIMBS_UNREDUCED):
            val_limbs[i]=as_int(getattr(ids.val, 'd'+str(i)), PRIME)

        qs, rs, flags, carries = reduce_hint(val_limbs)

        for i in range(ids.N_LIMBS):
            setattr(ids.r, 'd'+str(i), rs[i])
            setattr(ids.q, 'd'+str(i), qs[i])

        for i in range(ids.N_LIMBS_UNREDUCED-1):
            setattr(ids, 'flag'+str(i), flags[i])
            setattr(ids, 'q'+str(i), carries[i])
    %}

    // This ensure q_i * BASE or -q_i * BASE doesn't overlfow PRIME.
    // It is very important as we can assert diff_i has the form diff_i = k * BASE + 0.
    // Since the euclidean division gives uniqueness and RC_BOUND * BASE = 2**214 < PRIME, it is enough.
    // See https://github.com/starkware-libs/cairo-lang/blob/40404870166edc1e1fc5778fe39a29f981121ef9/src/starkware/cairo/common/math.cairo#L289-L312

    assert [range_check_ptr + 0] = q0;
    assert [range_check_ptr + 1] = q1;
    assert [range_check_ptr + 2] = q2;
    assert [range_check_ptr + 3] = q3;

    // This ensure all (q*P +r) limbs don't overlfow by restricting q limbs in [-2**127, 2**127).
    assert [range_check_ptr + 4] = 2 ** 127 + q.d0;
    assert [range_check_ptr + 5] = 2 ** 127 + q.d1;
    assert [range_check_ptr + 6] = 2 ** 127 + q.d2;

    // diff = q*p + r - val
    // diff(base) = 0

    // tempvar diff_d0 = q.d0 * P0 + r.d0 - val.d0;
    // tempvar diff_d1 = q.d0 * P1 + q.d1 * P0 + r.d1 - val.d1;
    // tempvar diff_d2 = q.d0 * P2 + q.d1 * P1 + q.d2 * P0 + r.d2 - val.d2;
    // tempvar diff_d3 = q.d1 * P2 + q.d2 * P1 - val.d3;
    // tempvar diff_d4 = q.d2 * P2 - val.d4;

    // local carry0: felt;
    // local carry1: felt;
    // local carry2: felt;
    // local carry3: felt;

    // Since diff(base) = 0, diff_i has the form diff_i = k * BASE + 0
    // When we reduce each limb % BASE and propagate the carries k=(limb//BASE), all coefficients should be 0.
    // So for each i diff_i%BASE is 0 and we propagate the carry k to diff_(i+1), until the end,
    // ensuring diff(base) is indeed 0.

    if (flag0 != 0) {
        assert q.d0 * P0 + r.d0 - val.d0 = q0 * BASE;
        if (flag1 != 0) {
            assert q.d0 * P1 + q.d1 * P0 + r.d1 - val.d1 + q0 = q1 * BASE;
            if (flag2 != 0) {
                assert q.d0 * P2 + q.d1 * P1 + q.d2 * P0 + r.d2 - val.d2 + q1 = q2 * BASE;
                if (flag3 != 0) {
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 + q2 = q3 * BASE;
                    assert q.d2 * P2 = val.d4 - q3;
                } else {
                    // let q3 = (-1) * q3;
                    assert q.d1 * P2 + q.d2 * P1 + q2 + q3 * BASE = val.d3;
                    assert q.d2 * P2 = val.d4 + q3;
                }
            } else {
                assert q.d0 * P2 + q.d1 * P1 + q.d2 * P0 + r.d2 + q1 + q2 * BASE = val.d2;
                if (flag3 != 0) {
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 - q2 = q3 * BASE;
                    assert q.d2 * P2 = val.d4 - q3;
                } else {
                    // let q3 = (-1) * q3;
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 + q3 * BASE = q2;
                    assert q.d2 * P2 = val.d4 + q3;
                }
            }
        } else {
            assert q.d0 * P1 + q.d1 * P0 + r.d1 + q0 + q1 * BASE = val.d1;
            if (flag2 != 0) {
                assert q.d0 * P2 + q.d1 * P1 + q.d2 * P0 + r.d2 - val.d2 - q1 = q2 * BASE;
                if (flag3 != 0) {
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 + q2 = q3 * BASE;
                    assert q.d2 * P2 = val.d4 - q3;
                } else {
                    // let q3 = (-1) * q3;
                    assert q.d1 * P2 + q.d2 * P1 + q2 + q3 * BASE = val.d3;
                    assert q.d2 * P2 = val.d4 + q3;
                }
            } else {
                assert q.d0 * P2 + q.d1 * P1 + q.d2 * P0 + r.d2 - val.d2 + q2 * BASE = q1;
                if (flag3 != 0) {
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 - q2 = q3 * BASE;
                    assert q.d2 * P2 = val.d4 - q3;
                } else {
                    // let q3 = (-1) * q3;
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 + q3 * BASE = q2;
                    assert q.d2 * P2 = val.d4 + q3;
                }
            }
        }
    } else {
        assert q.d0 * P0 + r.d0 + q0 * BASE = val.d0;
        if (flag1 != 0) {
            assert q.d0 * P1 + q.d1 * P0 + r.d1 - val.d1 - q0 = q1 * BASE;
            if (flag2 != 0) {
                assert q.d0 * P2 + q.d1 * P1 + q.d2 * P0 + r.d2 - val.d2 + q1 = q2 * BASE;
                if (flag3 != 0) {
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 + q2 = q3 * BASE;
                    assert q.d2 * P2 = val.d4 - q3;
                } else {
                    // let q3 = (-1) * q3;
                    assert q.d1 * P2 + q.d2 * P1 + q2 + q3 * BASE = val.d3;
                    assert q.d2 * P2 = val.d4 + q3;
                }
            } else {
                assert q.d0 * P2 + q.d1 * P1 + q.d2 * P0 + r.d2 + q1 + q2 * BASE = val.d2;
                if (flag3 != 0) {
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 - q2 = q3 * BASE;
                    assert q.d2 * P2 = val.d4 - q3;
                } else {
                    // let q3 = (-1) * q3;
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 + q3 * BASE = q2;
                    assert q.d2 * P2 = val.d4 + q3;
                }
            }
        } else {
            assert q.d0 * P1 + q.d1 * P0 + r.d1 - q0 + q1 * BASE = val.d1;
            if (flag2 != 0) {
                assert q.d0 * P2 + q.d1 * P1 + q.d2 * P0 + r.d2 - val.d2 - q1 = q2 * BASE;
                if (flag3 != 0) {
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 + q2 = q3 * BASE;
                    assert q.d2 * P2 = val.d4 - q3;
                } else {
                    // let q3 = (-1) * q3;
                    assert q.d1 * P2 + q.d2 * P1 + q2 + q3 * BASE = val.d3;
                    assert q.d2 * P2 = val.d4 + q3;
                }
            } else {
                assert q.d0 * P2 + q.d1 * P1 + q.d2 * P0 + r.d2 - q1 + q2 * BASE = val.d2;
                if (flag3 != 0) {
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 - q2 = q3 * BASE;
                    assert q.d2 * P2 = val.d4 - q3;
                } else {
                    // let q3 = (-1) * q3;
                    assert q.d1 * P2 + q.d2 * P1 - val.d3 + q3 * BASE = q2;
                    assert q.d2 * P2 = val.d4 + q3;
                }
            }
        }
    }

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
            return &r;
        } else {
            assert [range_check_ptr + 13] = P1 - 1 - r.d1;
            tempvar range_check_ptr = range_check_ptr + 14;
            return &r;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr + 13;
        return &r;
    }
}

func reduce_3{range_check_ptr}(val: UnreducedBigInt3) -> BigInt3* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local q: felt;
    local r: BigInt3;
    local flag0: felt;
    local flag1: felt;
    local q0: felt;
    local q1: felt;

    %{
        from starkware.cairo.common.math_utils import as_int
        from src.bn254.hints import reduce3_hint

        val_limbs = ids.N_LIMBS*[0]

        for i in range(ids.N_LIMBS):
            val_limbs[i]+=as_int(getattr(ids.val, 'd'+str(i)), PRIME)

        q, rs, flags, carries = reduce3_hint(val_limbs)
        ids.q = q

        for i in range(ids.N_LIMBS):
            setattr(ids.r, 'd'+str(i), rs[i])

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
            return &r;
        } else {
            assert [range_check_ptr + 9] = P1 - 1 - r.d1;
            tempvar range_check_ptr = range_check_ptr + 10;
            return &r;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr + 9;
        return &r;
    }
}
