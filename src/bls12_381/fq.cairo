from starkware.cairo.common.uint256 import SHIFT
from starkware.cairo.common.registers import get_fp_and_pc
from src.bls12_381.curve import P0, P1, P2, P3, BASE, DEGREE, N_LIMBS, N_LIMBS_UNREDUCED

const BASE_MIN_1 = BASE - 1;

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
    let res = BigInt4(0, 0, 0, 0);
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
    if (x.d3 != 0) {
        return 0;
    }
    return 1;
}
func fq_eq_one(x: BigInt4*) -> felt {
    if (x.d0 != 1) {
        return 0;
    }
    if (x.d1 != 0) {
        return 0;
    }
    if (x.d2 != 0) {
        return 0;
    }
    if (x.d3 != 0) {
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
func bigint4_sq(x: BigInt4) -> (res: UnreducedBigInt7) {
    return (
        UnreducedBigInt7(
            d0=x.d0 * x.d0,
            d1=2 * x.d0 * x.d1,
            d2=2 * x.d0 * x.d2 + x.d1 * x.d1,
            d3=2 * (x.d0 * x.d3 + x.d1 * x.d2),
            d4=2 * x.d1 * x.d3 + x.d2 * x.d2,
            d5=2 * x.d2 * x.d3,
            d6=x.d3 * x.d3,
        ),
    );
}
namespace fq_bigint4 {
    func add{range_check_ptr}(a: BigInt4*, b: BigInt4*) -> BigInt4* {
        alloc_locals;
        local res: BigInt4;
        let (__fp__, _) = get_fp_and_pc();
        %{
            BASE = ids.BASE
            assert 1 < ids.N_LIMBS <= 12

            p, sub_limbs = 0, []
            for i in range(ids.N_LIMBS):
                p+=getattr(ids, 'P'+str(i)) * BASE**i

            sum_limbs=[]
            p_limbs = [getattr(ids, 'P'+str(i)) for i in range(ids.N_LIMBS)]
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

        let needs_reduction = [ap - 4];
        let cb_d0 = [ap - 3];
        let cb_d1 = [ap - 2];
        let cb_d2 = [ap - 1];
        if (needs_reduction != 0) {
            assert res.d0 = (-P0) + a.d0 + b.d0 - cb_d0 * BASE;
            assert res.d1 = (-P1) + a.d1 + b.d1 + cb_d0 - cb_d1 * BASE;
            assert res.d2 = (-P2) + a.d2 + b.d2 + cb_d1 - cb_d2 * BASE;
            assert res.d3 = (-P3) + a.d3 + b.d3 + cb_d2;

            assert [range_check_ptr] = P3 - res.d3;
            assert [range_check_ptr + 1] = BASE_MIN_1 - res.d0;
            assert [range_check_ptr + 2] = BASE_MIN_1 - res.d1;
            assert [range_check_ptr + 3] = BASE_MIN_1 - res.d2;
            if (res.d3 == P3) {
                if (res.d2 == P2) {
                    if (res.d1 == P1) {
                        assert [range_check_ptr + 4] = P0 - 1 - res.d0;
                        tempvar range_check_ptr = range_check_ptr + 5;
                        return &res;
                    } else {
                        assert [range_check_ptr + 4] = P1 - 1 - res.d1;
                        tempvar range_check_ptr = range_check_ptr + 5;
                        return &res;
                    }
                } else {
                    assert [range_check_ptr + 3] = P2 - 1 - res.d2;
                    tempvar range_check_ptr = range_check_ptr + 5;
                    return &res;
                }
            } else {
                tempvar range_check_ptr = range_check_ptr + 4;
                return &res;
            }
        } else {
            // No reduction
            assert res.d0 = a.d0 + b.d0 - cb_d0 * BASE;
            assert res.d1 = a.d1 + b.d1 + cb_d0 - cb_d1 * BASE;
            assert res.d2 = a.d2 + b.d2 + cb_d1 - cb_d2 * BASE;
            assert res.d3 = a.d3 + b.d3 + cb_d2;

            assert [range_check_ptr] = P3 - res.d3;
            assert [range_check_ptr + 1] = BASE_MIN_1 - res.d0;
            assert [range_check_ptr + 2] = BASE_MIN_1 - res.d1;
            assert [range_check_ptr + 3] = BASE_MIN_1 - res.d2;

            if (res.d3 == P3) {
                if (res.d2 == P2) {
                    if (res.d1 == P1) {
                        assert [range_check_ptr + 4] = P0 - 1 - res.d0;
                        tempvar range_check_ptr = range_check_ptr + 5;
                        return &res;
                    } else {
                        assert [range_check_ptr + 4] = P1 - 1 - res.d1;
                        tempvar range_check_ptr = range_check_ptr + 5;
                        return &res;
                    }
                } else {
                    assert [range_check_ptr + 3] = P2 - 1 - res.d2;
                    tempvar range_check_ptr = range_check_ptr + 5;
                    return &res;
                }
            } else {
                tempvar range_check_ptr = range_check_ptr + 4;
                return &res;
            }
        }
    }

    func sub{range_check_ptr}(a: BigInt4*, b: BigInt4*) -> BigInt4* {
        alloc_locals;
        local res: BigInt4;
        let (__fp__, _) = get_fp_and_pc();
        %{
            BASE = ids.BASE
            assert 1 < ids.N_LIMBS <= 12

            p, sub_limbs = 0, []
            for i in range(ids.N_LIMBS):
                p+=getattr(ids, 'P'+str(i)) * BASE**i

            p_limbs = [getattr(ids, 'P'+str(i)) for i in range(ids.N_LIMBS)]
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

        let needs_reduction = [ap - 4];
        let cb_d0 = [ap - 3];
        let cb_d1 = [ap - 2];
        let cb_d2 = [ap - 1];

        if (needs_reduction != 0) {
            assert res.d0 = (P0) + a.d0 - b.d0 - cb_d0 * BASE;
            assert res.d1 = (P1) + a.d1 - b.d1 + cb_d0 - cb_d1 * BASE;
            assert res.d2 = (P2) + a.d2 - b.d2 + cb_d1 - cb_d2 * BASE;
            assert res.d3 = (P3) + a.d3 - b.d3 + cb_d2;

            assert [range_check_ptr] = P3 - res.d3;
            assert [range_check_ptr + 1] = BASE_MIN_1 - res.d0;
            assert [range_check_ptr + 2] = BASE_MIN_1 - res.d1;
            assert [range_check_ptr + 3] = BASE_MIN_1 - res.d2;
            if (res.d3 == P3) {
                if (res.d2 == P2) {
                    if (res.d1 == P1) {
                        assert [range_check_ptr + 4] = P0 - 1 - res.d0;
                        tempvar range_check_ptr = range_check_ptr + 5;
                        return &res;
                    } else {
                        assert [range_check_ptr + 4] = P1 - 1 - res.d1;
                        tempvar range_check_ptr = range_check_ptr + 5;
                        return &res;
                    }
                } else {
                    assert [range_check_ptr + 3] = P2 - 1 - res.d2;
                    tempvar range_check_ptr = range_check_ptr + 5;
                    return &res;
                }
            } else {
                tempvar range_check_ptr = range_check_ptr + 4;
                return &res;
            }
        } else {
            assert res.d0 = a.d0 - b.d0 - cb_d0 * BASE;
            assert res.d1 = a.d1 - b.d1 + cb_d0 - cb_d1 * BASE;
            assert res.d2 = a.d2 - b.d2 + cb_d1 - cb_d2 * BASE;
            assert res.d3 = a.d3 - b.d3 + cb_d2;

            assert [range_check_ptr] = P3 - res.d3;
            assert [range_check_ptr + 1] = BASE_MIN_1 - res.d0;
            assert [range_check_ptr + 2] = BASE_MIN_1 - res.d1;
            assert [range_check_ptr + 3] = BASE_MIN_1 - res.d2;

            if (res.d3 == P3) {
                if (res.d2 == P2) {
                    if (res.d1 == P1) {
                        assert [range_check_ptr + 4] = P0 - 1 - res.d0;
                        tempvar range_check_ptr = range_check_ptr + 5;
                        return &res;
                    } else {
                        assert [range_check_ptr + 4] = P1 - 1 - res.d1;
                        tempvar range_check_ptr = range_check_ptr + 5;
                        return &res;
                    }
                } else {
                    assert [range_check_ptr + 3] = P2 - 1 - res.d2;
                    tempvar range_check_ptr = range_check_ptr + 5;
                    return &res;
                }
            } else {
                tempvar range_check_ptr = range_check_ptr + 4;
                return &res;
            }
        }
    }

    func mul{range_check_ptr}(a: BigInt4*, b: BigInt4*) -> BigInt4* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local q: BigInt4;
        local r: BigInt4;
        local flag0: felt;
        local flag1: felt;
        local flag2: felt;
        local flag3: felt;
        local flag4: felt;
        local flag5: felt;
        local q0: felt;
        local q1: felt;
        local q2: felt;
        local q3: felt;
        local q4: felt;
        local q5: felt;

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

        assert [range_check_ptr + 0] = q0;
        assert [range_check_ptr + 1] = q1;
        assert [range_check_ptr + 2] = q2;
        assert [range_check_ptr + 3] = q3;
        assert [range_check_ptr + 4] = q4;
        assert [range_check_ptr + 5] = q5;

        assert [range_check_ptr + 6] = r.d0;
        assert [range_check_ptr + 7] = r.d1;
        assert [range_check_ptr + 8] = r.d2;
        assert [range_check_ptr + 9] = r.d3;

        assert [range_check_ptr + 10] = q.d0;
        assert [range_check_ptr + 11] = q.d1;
        assert [range_check_ptr + 12] = q.d2;
        assert [range_check_ptr + 13] = q.d3;

        // diff = q*p + r - a*b
        // diff(base) = 0

        tempvar diff_d0 = q.d0 * P0 + r.d0 - a.d0 * b.d0;
        tempvar diff_d1 = q.d0 * P1 + q.d1 * P0 + r.d1 - a.d0 * b.d1 - a.d1 * b.d0;
        tempvar diff_d2 = q.d0 * P2 + q.d1 * P1 + q.d2 * P0 + r.d2 - a.d0 * b.d2 - a.d1 * b.d1 -
            a.d2 * b.d0;
        tempvar diff_d3 = q.d0 * P3 + q.d1 * P2 + q.d2 * P1 + q.d3 * P0 + r.d3 - a.d0 * b.d3 -
            a.d1 * b.d2 - a.d2 * b.d1 - a.d3 * b.d0;
        tempvar diff_d4 = q.d1 * P3 + q.d2 * P2 + q.d3 * P1 - a.d1 * b.d3 - a.d2 * b.d2 - a.d3 *
            b.d1;
        tempvar diff_d5 = q.d2 * P3 + q.d3 * P2 - a.d2 * b.d3 - a.d3 * b.d2;
        tempvar diff_d6 = q.d3 * P3 - a.d3 * b.d3;

        local carry0: felt;
        local carry1: felt;
        local carry2: felt;
        local carry3: felt;
        local carry4: felt;
        local carry5: felt;

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

        if (flag4 != 0) {
            assert diff_d4 + carry3 = q4 * BASE;
            assert carry4 = q4;
        } else {
            assert carry4 = (-1) * q4;
            assert diff_d4 + carry3 = carry4 * BASE;
        }

        if (flag5 != 0) {
            assert diff_d5 + carry4 = q5 * BASE;
            assert carry5 = q5;
        } else {
            assert carry5 = (-1) * q5;
            assert diff_d5 + carry4 = carry5 * BASE;
        }

        assert diff_d6 + carry5 = 0;

        assert [range_check_ptr + 14] = BASE_MIN_1 - r.d0;
        assert [range_check_ptr + 15] = BASE_MIN_1 - r.d1;
        assert [range_check_ptr + 16] = BASE_MIN_1 - r.d2;
        assert [range_check_ptr + 17] = P3 - r.d3;

        if (r.d3 == P3) {
            if (r.d2 == P2) {
                if (r.d1 == P1) {
                    assert [range_check_ptr + 18] = P0 - 1 - r.d0;
                    tempvar range_check_ptr = range_check_ptr + 19;
                    return &r;
                } else {
                    assert [range_check_ptr + 18] = P1 - 1 - r.d1;
                    tempvar range_check_ptr = range_check_ptr + 19;
                    return &r;
                }
            } else {
                assert [range_check_ptr + 18] = P2 - 1 - r.d2;
                tempvar range_check_ptr = range_check_ptr + 19;
                return &r;
            }
        } else {
            tempvar range_check_ptr = range_check_ptr + 18;
            return &r;
        }
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
                a+=as_int(getattr(getattr(ids, 'a'), 'd'+str(i)), PRIME) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

            inv = pow(a, -1, p)
            invs = split(inv)
            for i in range(ids.N_LIMBS):
                setattr(getattr(ids, 'inv'), 'd'+str(i), invs[i])
        %}
        // let (inv) = nondet_BigInt4();
        let check = mul(a, &inv);
        assert check.d0 = 1;
        assert check.d1 = 0;
        assert check.d2 = 0;
        assert check.d3 = 0;

        return &inv;
    }
    func add_cheat{range_check_ptr}(a: BigInt4*, b: BigInt4*) -> BigInt4* {
        alloc_locals;
        local add_mod_p: BigInt4*;
        %{
            from starkware.cairo.common.math_utils import as_int    

            a,b,p=0,0,0
            for i in range(ids.N_LIMBS):
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
                a+=as_int(getattr(getattr(ids, 'a'), 'd'+str(i)), PRIME) * ids.BASE**i
                b+=as_int(getattr(getattr(ids, 'b'), 'd'+str(i)), PRIME) * ids.BASE**i

            add_mod_p = value = (a+b)%p

            ids.add_mod_p = segments.gen_arg(split(value))
        %}
        return add_mod_p;
    }
    func sub_cheat{range_check_ptr}(a: BigInt4*, b: BigInt4*) -> BigInt4* {
        alloc_locals;
        local sub_mod_p: BigInt4*;
        %{
            from starkware.cairo.common.math_utils import as_int    

            a,b,p=0,0,0
            for i in range(ids.N_LIMBS):
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
                a+=as_int(getattr(getattr(ids, 'a'), 'd'+str(i)), PRIME) * ids.BASE**i
                b+=as_int(getattr(getattr(ids, 'b'), 'd'+str(i)), PRIME) * ids.BASE**i

            sub_mod_p = value = (a-b)%p

            ids.sub_mod_p = segments.gen_arg(split(value))
        %}
        return sub_mod_p;
    }
    func mul_cheat{range_check_ptr}(a: BigInt4*, b: BigInt4*) -> BigInt4* {
        alloc_locals;
        local result: BigInt4*;
        %{
            from starkware.cairo.common.math_utils import as_int
            a,b,p= 0,0,0
            for i in range(ids.N_LIMBS):
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
                a+=as_int(getattr(getattr(ids, 'a'), 'd'+str(i)), PRIME) * ids.BASE**i
                b+=as_int(getattr(getattr(ids, 'b'), 'd'+str(i)), PRIME) * ids.BASE**i
            mul = value = (a*b)%p

            ids.result = segments.gen_arg(split(value))
        %}

        return result;
    }
}
func verify_zero4{range_check_ptr}(val: BigInt4) {
    alloc_locals;
    local q: felt;
    local flag0: felt;
    local flag1: felt;
    local flag2: felt;
    local q0: felt;
    local q1: felt;
    local q2: felt;
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
            p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
            p_limbs[i]=getattr(ids, 'P'+str(i))
            val_limbs[i]+=as_int(getattr(ids.val, 'd'+str(i)), PRIME)
            val+=as_int(getattr(ids.val, 'd'+str(i)), PRIME) * ids.BASE**i

        mul = val
        q, r = divmod(mul, p)

        assert r == 0, f"verify_zero: Invalid input."
        qs = split(q)
        for i in range(ids.N_LIMBS):
            setattr(ids.q, 'd'+str(i), qs[i])

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
    assert [range_check_ptr + 3] = q2;

    tempvar diff_d0 = q * P0 - val.d0;
    tempvar diff_d1 = q * P1 - val.d1;
    tempvar diff_d2 = q * P2 - val.d2;
    tempvar diff_d3 = q * P3 - val.d3;

    local carry0: felt;
    local carry1: felt;
    local carry2: felt;

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

    assert diff_d3 + carry2 = 0;
    tempvar range_check_ptr = range_check_ptr + 4;
    return ();
}

func verify_zero7{range_check_ptr}(val: UnreducedBigInt7) {
    alloc_locals;
    local q: BigInt4;
    local flag0: felt;
    local flag1: felt;
    local flag2: felt;
    local flag3: felt;
    local flag4: felt;
    local flag5: felt;
    local q0: felt;
    local q1: felt;
    local q2: felt;
    local q3: felt;
    local q4: felt;
    local q5: felt;

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

    assert [range_check_ptr + 0] = q0;
    assert [range_check_ptr + 1] = q1;
    assert [range_check_ptr + 2] = q2;
    assert [range_check_ptr + 3] = q3;
    assert [range_check_ptr + 4] = q4;
    assert [range_check_ptr + 5] = q5;
    assert [range_check_ptr + 6] = q.d0;
    assert [range_check_ptr + 7] = q.d1;
    assert [range_check_ptr + 8] = q.d2;
    assert [range_check_ptr + 9] = q.d3;

    // diff = q*p - val
    // diff(base) = 0

    tempvar diff_d0 = q.d0 * P0 - val.d0;
    tempvar diff_d1 = q.d0 * P1 + q.d1 * P0 - val.d1;
    tempvar diff_d2 = q.d0 * P2 + q.d1 * P1 + q.d2 * P0 - val.d2;
    tempvar diff_d3 = q.d1 * P2 + q.d2 * P1 - val.d3;
    // tempvar diff_d4 = q.d2 * P2 - val.d4;

    tempvar diff_d0 = q.d0 * P0 - val.d0;
    tempvar diff_d1 = q.d0 * P1 + q.d1 * P0 - val.d1;
    tempvar diff_d2 = q.d0 * P2 + q.d1 * P1 + q.d2 * P0 - val.d2;
    tempvar diff_d3 = q.d0 * P3 + q.d1 * P2 + q.d2 * P1 + q.d3 * P0 - val.d3;
    tempvar diff_d4 = q.d1 * P3 + q.d2 * P2 + q.d3 * P1 - val.d4;
    tempvar diff_d5 = q.d2 * P3 + q.d3 * P2 - val.d5;
    tempvar diff_d6 = q.d3 * P3 - val.d6;

    local carry0: felt;
    local carry1: felt;
    local carry2: felt;
    local carry3: felt;
    local carry4: felt;
    local carry5: felt;

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

    if (flag4 != 0) {
        assert diff_d4 + carry3 = q4 * BASE;
        assert carry4 = q4;
    } else {
        assert carry4 = (-1) * q4;
        assert diff_d4 + carry3 = carry4 * BASE;
    }

    if (flag5 != 0) {
        assert diff_d5 + carry4 = q5 * BASE;
        assert carry5 = q5;
    } else {
        assert carry5 = (-1) * q5;
        assert diff_d5 + carry4 = carry5 * BASE;
    }

    assert diff_d6 + carry5 = 0;

    tempvar range_check_ptr = range_check_ptr + 10;
    return ();
}

// returns 1 if x ==0 mod alt_bn128 prime
func is_zero{range_check_ptr}(x: BigInt4) -> (res: felt) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    local is_zero: felt;
    %{
        from starkware.cairo.common.math_utils import as_int
        assert 1 < ids.N_LIMBS <= 12
        x,p=0,0
        for i in range(ids.N_LIMBS):
            x+=as_int(getattr(getattr(ids, 'x'), 'd'+str(i)), PRIME) * ids.BASE**i
            p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
        ids.is_zero = 1 if x%p == 0 else 0
    %}
    if (is_zero != 0) {
        verify_zero4(x);
        return (res=1);
    }

    let x_invc = fq_bigint4.inv(&x);

    return (res=0);
}
