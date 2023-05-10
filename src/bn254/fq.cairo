from starkware.cairo.common.uint256 import SHIFT
from starkware.cairo.common.cairo_secp.bigint import (
    BigInt3,
    bigint_mul,
    UnreducedBigInt5,
    UnreducedBigInt3,
    nondet_bigint3 as nd,
)
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from src.bn254.curve import (
    P0,
    P1,
    P2,
    N_LIMBS,
    N_LIMBS_UNREDUCED,
    DEGREE,
    BASE,
    M1,
    M2,
    M3,
    M_LEN,
    B_P1_MOD_Q_M0,
    B_P1_MOD_Q_M1,
    B_P1_MOD_Q_M2,
    B_P1_MOD_Q_M3,
    B_P2_MOD_Q_M0,
    B_P2_MOD_Q_M1,
    B_P2_MOD_Q_M2,
    B_P2_MOD_Q_M3,
    B_P3_MOD_Q_M0,
    B_P3_MOD_Q_M1,
    B_P3_MOD_Q_M2,
    B_P3_MOD_Q_M3,
    B_P4_MOD_Q_M0,
    B_P4_MOD_Q_M1,
    B_P4_MOD_Q_M2,
    B_P4_MOD_Q_M3,
    Q_MOD_M0,
    Q_MOD_M1,
    Q_MOD_M2,
    Q_MOD_M3,
)

const SHIFT_MIN_BASE = SHIFT - BASE;
const SHIFT_MIN_P2 = SHIFT - P2 - 1;
const BASE_MIN_1 = BASE - 1;
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

namespace fq_bigint3 {
    func add{range_check_ptr}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
        alloc_locals;
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

            assert [range_check_ptr] = res.d0 + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = res.d1 + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 2] = res.d2 + (SHIFT_MIN_P2);
            tempvar range_check_ptr = range_check_ptr + 3;

            return &res;
        } else {
            // No reduction over P.

            local res: BigInt3 = BigInt3(
                a.d0 + b.d0 - cb_d0 * BASE, a.d1 + b.d1 + cb_d0 - cb_d1 * BASE, a.d2 + b.d2 + cb_d1
            );
            assert [range_check_ptr] = res.d0 + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = res.d1 + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 2] = res.d2 + (SHIFT_MIN_P2);
            tempvar range_check_ptr = range_check_ptr + 3;
            return &res;
        }
    }

    func sub{range_check_ptr}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
        alloc_locals;
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

            assert [range_check_ptr] = res.d0 + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = res.d1 + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 2] = res.d2 + (SHIFT_MIN_P2);
            tempvar range_check_ptr = range_check_ptr + 3;
            return &res;
        } else {
            // No reduction over P.
            local res: BigInt3 = BigInt3(
                a.d0 - b.d0 - cb_d0 * BASE, a.d1 - b.d1 + cb_d0 - cb_d1 * BASE, a.d2 - b.d2 + cb_d1
            );

            assert [range_check_ptr] = res.d0 + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = res.d1 + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 2] = res.d2 + (SHIFT_MIN_P2);
            tempvar range_check_ptr = range_check_ptr + 3;

            return &res;
        }
    }
    func mul_bitwise{bitwise_ptr: BitwiseBuiltin*}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local q: BigInt3;
        local r: BigInt3;
        %{
            from starkware.cairo.common.math_utils import as_int
            assert 1 < ids.N_LIMBS <= 12
            assert ids.DEGREE == ids.N_LIMBS-1
            a,b,p=0,0,0

            def split(x, degree=ids.DEGREE, base=ids.BASE):
                coeffs = []
                for n in range(degree, 0, -1):
                    q, r = divmod(x, base ** n)
                    coeffs.append(q)
                    x = r
                coeffs.append(x)
                return coeffs[::-1]

            for i in range(ids.N_LIMBS):
                a+=as_int(getattr(ids.a, 'd'+str(i)),PRIME) * ids.BASE**i
                b+=as_int(getattr(ids.b, 'd'+str(i)),PRIME) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
            mul = a*b
            q, r = divmod(mul, p)
            qs, rs = split(q), split(r)
            for i in range(ids.N_LIMBS):
                setattr(ids.r, 'd'+str(i), rs[i])
                setattr(ids.q, 'd'+str(i), qs[i])
        %}

        // mul_sub = val = a * b  - a*b%p
        tempvar val_d0 = a.d0 * b.d0 - r.d0;
        tempvar val_d1 = a.d0 * b.d1 + a.d1 * b.d0 - r.d1;
        tempvar val_d2 = a.d0 * b.d2 + a.d1 * b.d1 + a.d2 * b.d0 - r.d2;
        tempvar val_d3 = a.d1 * b.d2 + a.d2 * b.d1;
        // tempvar val_d4 = a.d2 * b.d2;

        tempvar qP_d0 = q.d0 * P0;
        tempvar qP_d1 = q.d0 * P1 + q.d1 * P0;
        tempvar qP_d2 = q.d0 * P2 + q.d1 * P1 + q.d2 * P0;
        tempvar qP_d3 = q.d1 * P2 + q.d2 * P1;
        // tempvar qP_d4 = q.d2 * P2;

        // // val mod P = 0, so val = k_P

        assert bitwise_ptr[0].x = qP_d0 - val_d0;
        assert bitwise_ptr[0].y = BASE_MIN_1;
        assert bitwise_ptr[0].x_and_y = 0;
        let q0 = bitwise_ptr[0].x / BASE;

        assert bitwise_ptr[1].x = qP_d1 - val_d1 + q0;
        assert bitwise_ptr[1].y = BASE_MIN_1;
        assert bitwise_ptr[1].x_and_y = 0;
        let q1 = (bitwise_ptr[1].x) / BASE;

        assert bitwise_ptr[2].x = qP_d2 - val_d2 + q1;
        assert bitwise_ptr[2].y = BASE_MIN_1;
        assert bitwise_ptr[2].x_and_y = 0;
        let q2 = (bitwise_ptr[2].x) / BASE;

        assert bitwise_ptr[3].x = qP_d3 - val_d3 + q2;
        assert bitwise_ptr[3].y = BASE_MIN_1;
        assert bitwise_ptr[3].x_and_y = 0;
        let q3 = (bitwise_ptr[3].x) / BASE;

        let bitwise_ptr = bitwise_ptr + 4 * BitwiseBuiltin.SIZE;

        assert q.d2 * P2 - a.d2 * b.d2 + q3 = 0;

        return &r;
    }
    func mul_casting{range_check_ptr}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local z: BigInt3;
        local r: felt;
        local s1: felt;
        local s2: felt;
        local s3: felt;
        %{
            from starkware.cairo.common.math_utils import as_int
            assert 1 < ids.N_LIMBS <= 12
            assert ids.DEGREE == ids.N_LIMBS-1
            a_limbs, b_limbs, q = ids.N_LIMBS*[0], ids.N_LIMBS*[0], 0
            M = ids.M_LEN * [0]

            def split(x, base=ids.BASE):
                coeffs, degree = [] , ids.DEGREE
                for n in range(degree, 0, -1):
                    q, r = divmod(x, base ** n)
                    coeffs.append(q)
                    x = r
                coeffs.append(x)
                return coeffs[::-1]
            #evaluate x(b)
            def sigma_b(x:list, b:int = ids.BASE) -> int:
                result = 0
                for i in range(len(x)):
                    assert x[i] < b, f"Error: wrong bounds {x[i]} >= {b}"
                    result += b**i * x[i]
                assert 0 <= result < b**(len(x)) - 1, f"Error: wrong bounds {result} >= {b**(len(x)) - 1}"
                return result
            # evaluate x(b) mod m
            def sigma_b_mod_m(x:list, m:int, b:int=ids.BASE, n=ids.N_LIMBS) -> int:
                result = 0
                assert len(x) == ids.N_LIMBS, "Error: sigma_b_mod_m() requires a list of length N_LIMBS"
                for i in range(n):
                    result += (b**i % m) * x[i]
                return result

            # multiply x(b) and y(b) mod m, returns limbs and x(b)*y(b) mod m
            def pi_b_mod_m(x:list, y:list, m:int, b:int=ids.BASE, n=ids.N_LIMBS) -> int:
                assert len(x) == len(y) == n, "Error: pi_b() requires two lists of length n"
                result = 0
                for i in range(ids.N_LIMBS):
                    for j in range(n):
                        result += x[i]*y[j] * (b**(i+j)%m)
                return result

            def sigma_b_mod_q_mod_m(x:list, q:int, m:int, b:int=ids.BASE) -> int:
                result = 0
                for i in range(len(x)):
                    result += ((b**i % q) % m) * x[i]
                return result

            def pi_b_mod_q_mod_m(x:list, y:list, q:int, m:int, b:int=ids.BASE, n=ids.N_LIMBS) -> int:
                result = 0
                for i in range(n):
                    for j in range(n):
                        result += x[i]*y[j] * ((b**(i+j)%q)%m)
                return result

            def get_witness_z_r_s(x:list, y:list, M:list):
                z:list = split(sigma_b(x) * sigma_b(y) % q)
                pi:int = pi_b_mod_m(x, y, q)
                sigma:int = sigma_b_mod_m(z, q)
                r_q = pi - sigma
                assert r_q % q == 0, "Error: r_q is not divisible by q"
                r = r_q // q
                S = []
                for i in range(len(M)):
                    m = M[i]
                    pi:int = pi_b_mod_q_mod_m(x, y, q, m)
                    sigma:int = sigma_b_mod_q_mod_m(z, q, m)
                    s_m = pi - sigma - r*(q%m)
                    assert s_m % m == 0, "Error: s_m is not divisible by m"
                    s = s_m // m
                    S.append(s)
                return z, r, S

            for i in range(ids.N_LIMBS):
                a_limbs[i]=as_int(getattr(ids.a, 'd'+str(i)),PRIME)
                b_limbs[i]=as_int(getattr(ids.b, 'd'+str(i)),PRIME)
                q+=getattr(ids, 'P'+str(i)) * ids.BASE**i
            M[0] = PRIME
            for i in range(1, ids.M_LEN):
                M[i] = getattr(ids, 'M'+str(i))

            z, r, S = get_witness_z_r_s(a_limbs, b_limbs, M)

            for i in range(ids.N_LIMBS):
                setattr(ids.z, 'd'+str(i), z[i])
            for i in range(1, ids.M_LEN):
                setattr(ids, 's'+str(i), S[i])
            ids.r = r
        %}
        // mul_sub = val = a * b  - result
        tempvar val: UnreducedBigInt5 = UnreducedBigInt5(
            d0=a.d0 * b.d0 - z.d0,
            d1=a.d0 * b.d1 + a.d1 * b.d0 - z.d1,
            d2=a.d0 * b.d2 + a.d1 * b.d1 + a.d2 * b.d0 - z.d2,
            d3=a.d1 * b.d2 + a.d2 * b.d1,
            d4=a.d2 * b.d2,
        );

        assert val.d0 + val.d1 * B_P1_MOD_Q_M0 + val.d2 * B_P2_MOD_Q_M0 + val.d3 * B_P3_MOD_Q_M0 +
            val.d4 * B_P4_MOD_Q_M0 = r * Q_MOD_M0;
        assert val.d0 + val.d1 * B_P1_MOD_Q_M1 + val.d2 * B_P2_MOD_Q_M1 + val.d3 * B_P3_MOD_Q_M1 +
            val.d4 * B_P4_MOD_Q_M1 - r * Q_MOD_M1 = s1 * M1;
        assert val.d0 + val.d1 * B_P1_MOD_Q_M2 + val.d2 * B_P2_MOD_Q_M2 + val.d3 * B_P3_MOD_Q_M2 +
            val.d4 * B_P4_MOD_Q_M2 - r * Q_MOD_M2 = s2 * M2;
        assert val.d0 + val.d1 * B_P1_MOD_Q_M3 + val.d2 * B_P2_MOD_Q_M3 + val.d3 * B_P3_MOD_Q_M3 +
            val.d4 * B_P4_MOD_Q_M3 - r * Q_MOD_M3 = s3 * M3;

        // assert [range_check_ptr + 0] = s1 + 2 ** 127;
        // assert [range_check_ptr + 1] = s1 + 2 ** 127;
        // assert [range_check_ptr + 2] = s2 + 2 ** 127;
        // assert [range_check_ptr + 3] = s3 + 2 ** 127;
        // tempvar range_check_ptr = range_check_ptr + 4;
        return &z;
    }

    func mul_by_9{range_check_ptr}(a: BigInt3*) -> BigInt3* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local r: BigInt3;
        local q: felt;
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

            mul = a*9
            q, r = divmod(mul, p)
            ids.q=q%PRIME
            rs = split(r)
            for i in range(ids.N_LIMBS):
                setattr(ids.r, 'd'+str(i), rs[i])
        %}
        // mul_sub = val = a * b  - result
        tempvar val: UnreducedBigInt3 = UnreducedBigInt3(
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
        return &r;
    }
    func mul_by_10{range_check_ptr}(a: BigInt3*) -> BigInt3* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local r: BigInt3;
        local q: felt;
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

            mul = a*10
            q, r = divmod(mul, p)
            ids.q=q%PRIME
            rs = split(r)
            for i in range(ids.N_LIMBS):
                setattr(ids.r, 'd'+str(i), rs[i])
        %}
        // mul_sub = val = a * b  - result
        tempvar val: UnreducedBigInt3 = UnreducedBigInt3(
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
        return &r;
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
        assert [range_check_ptr] = inv.d0 + (SHIFT_MIN_BASE);
        assert [range_check_ptr + 1] = inv.d1 + (SHIFT_MIN_BASE);
        assert [range_check_ptr + 2] = inv.d2 + (SHIFT_MIN_P2);
        tempvar range_check_ptr = range_check_ptr + 3;
        let x_x_inv = mul(a, &inv);

        assert x_x_inv.d0 = 1;
        assert x_x_inv.d1 = 0;
        assert x_x_inv.d2 = 0;
        return &inv;
    }
    func add_unsafe{range_check_ptr}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
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
    func sub_unsafe{range_check_ptr}(a: BigInt3*, b: BigInt3*) -> BigInt3* {
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

        return result;
    }
}

func verify_zero3{range_check_ptr}(val: BigInt3) {
    alloc_locals;
    local q;
    %{
        from starkware.cairo.common.math_utils import as_int
        assert 1 < ids.N_LIMBS <= 12
        a,p=0,0

        for i in range(ids.N_LIMBS):
            a+=as_int(getattr(ids.val, 'd'+str(i)), PRIME) * ids.BASE**i
            p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

        q, r = divmod(a, p)
        assert r == 0, f"verify_zero: Invalid input."
        ids.q=q%PRIME
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
    local q: BigInt3;
    %{
        from starkware.cairo.common.math_utils import as_int    
        assert 1 < ids.N_LIMBS <= 12
        assert ids.DEGREE == ids.N_LIMBS - 1
        N_LIMBS_UNREDUCED=ids.DEGREE*2+1
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
            p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
        for i in range(N_LIMBS_UNREDUCED):
            a+=as_int(getattr(ids.val, 'd'+str(i)), PRIME) * ids.BASE**i

        q, r = divmod(a, p)
        assert r == 0, f"verify_zero: Invalid input {a}, {a.bit_length()}."
        q_split = split(q)
        for i in range(ids.N_LIMBS):
            setattr(ids.q, 'd'+str(i), q_split[i])
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
func is_zero{range_check_ptr}(x: BigInt3) -> (res: felt) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    local is_zero: felt;
    %{
        from starkware.cairo.common.math_utils import as_int
        assert 1 < ids.N_LIMBS <= 12
        x,p=0,0
        for i in range(ids.N_LIMBS):
            x+=as_int(getattr(ids.x, 'd'+str(i)), PRIME) * ids.BASE**i
            p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
        ids.is_zero = 1 if x%p == 0 else 0
    %}
    if (is_zero != 0) {
        verify_zero3(x);
        // verify_zero5(UnreducedBigInt5(d0=x.d0, d1=x.d1, d2=x.d2, d3=0, d4=0))
        return (res=1);
    }

    // %{
    //     from starkware.cairo.common.math_utils import as_int
    //     assert 1 < ids.N_LIMBS <= 12
    //     assert ids.DEGREE == ids.N_LIMBS - 1
    //     a,p=0,0
    //     def split(x, degree=ids.DEGREE, base=ids.BASE):
    //         coeffs = []
    //         for n in range(degree, 0, -1):
    //             q, r = divmod(x, base ** n)
    //             coeffs.append(q)
    //             x = r
    //         coeffs.append(x)
    //         return coeffs[::-1]
    //     for i in range(ids.N_LIMBS):
    //         p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
    //     value = x_inv = pow(x, -1, p)
    //     print(f"inv from sp {value}, x from sp {x}, xinvmodp {value*x%p}")
    //     from starkware.cairo.common.cairo_secp.secp_utils import split as sp
    //     print(f"inv from sp {sp(value)}")
    // %}
    // let (x_inv) = nd();
    // let (x_x_inv) = bigint_mul(x, x_inv);

    // Check that x * x_inv = 1 to verify that x != 0.
    // verify_zero5(
    //     UnreducedBigInt5(
    //         d0=x_x_inv.d0 - 1, d1=x_x_inv.d1, d2=x_x_inv.d2, d3=x_x_inv.d3, d4=x_x_inv.d4
    //     ),
    // );

    let x_invc = fq_bigint3.inv(&x);
    return (res=0);
}
