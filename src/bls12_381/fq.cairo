from starkware.cairo.common.math import unsigned_div_rem as felt_divmod
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math_cmp import is_le, is_nn

from starkware.cairo.common.uint256 import SHIFT

from starkware.cairo.common.registers import get_fp_and_pc
from src.bls12_381.curve import P0, P1, P2, P3, BASE, DEGREE, N_LIMBS

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
        } else {
            assert res.d0 = a.d0 + b.d0 - cb_d0 * BASE;
            assert res.d1 = a.d1 + b.d1 + cb_d0 - cb_d1 * BASE;
            assert res.d2 = a.d2 + b.d2 + cb_d1 - cb_d2 * BASE;
            assert res.d3 = a.d3 + b.d3 + cb_d2;
        }

        tempvar range_check_ptr = range_check_ptr + 4;

        assert [range_check_ptr - 4] = res.d3 + (SHIFT_MIN_BASE);
        assert [range_check_ptr - 3] = res.d0 + (SHIFT_MIN_BASE);
        assert [range_check_ptr - 2] = res.d1 + (SHIFT_MIN_BASE);
        assert [range_check_ptr - 1] = res.d2 + (SHIFT_MIN_BASE);
        return &res;
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
            // Needs reduction over P. So, we first check if the low part of the subtraction has a borrow or a carry or nothing.
            // If it has a borrow, it cannot have a carry. See hint.
            assert res.d0 = (P0) + a.d0 - b.d0 - cb_d0 * BASE;
            assert res.d1 = (P1) + a.d1 - b.d1 + cb_d0 - cb_d1 * BASE;
            assert res.d2 = (P2) + a.d2 - b.d2 + cb_d1 - cb_d2 * BASE;
            assert res.d3 = (P3) + a.d3 - b.d3 + cb_d2;
        } else {
            // No reduction over P. So, we first check if the low part of the subtraction has a borrow or nothing.
            // if it doesn't have a borrow, it has nothing.
            assert res.d0 = a.d0 - b.d0 - cb_d0 * BASE;
            assert res.d1 = a.d1 - b.d1 + cb_d0 - cb_d1 * BASE;
            assert res.d2 = a.d2 - b.d2 + cb_d1 - cb_d2 * BASE;
            assert res.d3 = a.d3 - b.d3 + cb_d2;
        }

        tempvar range_check_ptr = range_check_ptr + 4;

        assert [range_check_ptr - 4] = res.d3 + (SHIFT_MIN_P3);
        assert [range_check_ptr - 3] = res.d0 + (SHIFT_MIN_BASE);
        assert [range_check_ptr - 2] = res.d1 + (SHIFT_MIN_BASE);
        assert [range_check_ptr - 1] = res.d2 + (SHIFT_MIN_BASE);
        return &res;
    }

    func mul{range_check_ptr}(a: BigInt4*, b: BigInt4*) -> BigInt4* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local q: BigInt4;
        local r: BigInt4;
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
                a+=as_int(getattr(getattr(ids, 'a'), 'd'+str(i)),PRIME) * ids.BASE**i
                b+=as_int(getattr(getattr(ids, 'b'), 'd'+str(i)),PRIME) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
            mul = a*b
            q, r = divmod(mul, p)
            qs, rs = split(q), split(r)
            for i in range(ids.N_LIMBS):
                setattr(getattr(ids, 'r'), 'd'+str(i), rs[i])
                setattr(getattr(ids, 'q'), 'd'+str(i), qs[i])
        %}

        // mul_sub = val = a * b  - a*b%p

        tempvar val: UnreducedBigInt7 = UnreducedBigInt7(
            d0=a.d0 * b.d0 - r.d0,
            d1=a.d0 * b.d1 + a.d1 * b.d0 - r.d1,
            d2=a.d0 * b.d2 + a.d1 * b.d1 + a.d2 * b.d0 - r.d2,
            d3=a.d0 * b.d3 + a.d1 * b.d2 + a.d2 * b.d1 + a.d3 * b.d0 - r.d3,
            d4=a.d1 * b.d3 + a.d2 * b.d2 + a.d3 * b.d1,
            d5=a.d2 * b.d3 + a.d3 * b.d2,
            d6=a.d3 * b.d3,
        );

        tempvar q_P: UnreducedBigInt7 = UnreducedBigInt7(
            d0=q.d0 * P0,
            d1=q.d0 * P1 + q.d1 * P0,
            d2=q.d0 * P2 + q.d1 * P1 + q.d2 * P0,
            d3=q.d0 * P3 + q.d1 * P2 + q.d2 * P1 + q.d3 * P0,
            d4=q.d1 * P3 + q.d2 * P2 + q.d3 * P1,
            d5=q.d2 * P3 + q.d3 * P2,
            d6=q.d3 * P3,
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

        tempvar carry5 = (q_P.d4 - val.d4 + carry4) / BASE;
        assert [range_check_ptr + 4] = carry5 + 2 ** 127;

        tempvar carry6 = (q_P.d5 - val.d5 + carry5) / BASE;
        assert [range_check_ptr + 5] = carry6 + 2 ** 127;

        assert q_P.d6 - val.d6 + carry6 = 0;

        tempvar range_check_ptr = range_check_ptr + 6;
        // The following assert would ensure sum(carry_i) is in [-2**92, 2**92]
        // If only using it this range check, it would result in a ~ 10% improvement.
        // assert [range_check_ptr] = carry1 + carry2 + carry3 + carry4 + carry5 + carry6 + 2 ** 128 - 2 ** 92;
        // tempvar range_check_ptr = range_check_ptr + 1;

        return &r;
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
func verify_zero4{range_check_ptr}(val: BigInt4) {
    alloc_locals;
    local q;
    %{
        from starkware.cairo.common.math_utils import as_int
        assert 1 < ids.N_LIMBS <= 12
        a,p=0,0

        for i in range(ids.N_LIMBS):
            a+=as_int(getattr(getattr(ids, 'val'), 'd'+str(i)), PRIME) * ids.BASE**i
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

func verify_zero7{range_check_ptr}(val: UnreducedBigInt7) {
    alloc_locals;
    local q: BigInt4;
    %{
        from starkware.cairo.common.math_utils import as_int    
        assert 1 < ids.N_LIMBS <= 12
        assert ids.DEGREE == ids.N_LIMBS - 1
        N_LIMBS_UNREDUCED=ids.DEGREE**2+1
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
            a+=as_int(getattr(getattr(ids, 'val'), 'd'+str(i)), PRIME) * ids.BASE**i

        q, r = divmod(a, p)
        assert r == 0, f"verify_zero: Invalid input {a}, {a.bit_length()}."
        q_split = split(q)
        for i in range(ids.N_LIMBS):
            setattr(getattr(ids, 'q'), 'd'+str(i), q_split[i])
    %}

    tempvar q_P: UnreducedBigInt7 = UnreducedBigInt7(
        d0=q.d0 * P0,
        d1=q.d0 * P1 + q.d1 * P0,
        d2=q.d0 * P2 + q.d1 * P1 + q.d2 * P0,
        d3=q.d0 * P3 + q.d1 * P2 + q.d2 * P1 + q.d3 * P0,
        d4=q.d1 * P3 + q.d2 * P2 + q.d3 * P1,
        d5=q.d2 * P3 + q.d3 * P2,
        d6=q.d3 * P3,
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

    tempvar carry5 = (q_P.d4 - val.d4 + carry4) / BASE;
    assert [range_check_ptr + 4] = carry5 + 2 ** 127;

    tempvar carry6 = (q_P.d5 - val.d5 + carry5) / BASE;
    assert [range_check_ptr + 5] = carry6 + 2 ** 127;

    assert q_P.d6 - val.d6 + carry6 = 0;

    tempvar range_check_ptr = range_check_ptr + 6;
    return ();
}

// returns 1 if x ==0 mod alt_bn128 prime
func is_zero{range_check_ptr}(x: BigInt4) -> (res: felt) {
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
        // verify_zero5(UnreducedBigInt7(d0=x.d0, d1=x.d1, d2=x.d2, d3=0, d4=0))
        return (res=1);
    }

    // %{
    //     from starkware.python.math_utils import div_mod
    //     p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    //     value = x_inv = div_mod(1, x, p)
    // %}
    // let (x_inv) = nd();
    // let (x_x_inv) = bigint_mul(x, x_inv);

    // // Check that x * x_inv = 1 to verify that x != 0.
    // verify_zero7(
    //     UnreducedBigInt7(
    //         d0=x_x_inv.d0 - 1, d1=x_x_inv.d1, d2=x_x_inv.d2, d3=x_x_inv.d3, d4=x_x_inv.d4
    //     ),
    // );
    let x_invc = fq_bigint4.inv(&x);

    return (res=0);
}
