from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import unsigned_div_rem as felt_divmod
from starkware.cairo.common.math_cmp import is_le, is_nn
from starkware.cairo.common.cairo_secp.constants import BASE
from starkware.cairo.common.uint256 import SHIFT
from starkware.cairo.common.cairo_secp.bigint import (
    BigInt3,
    UnreducedBigInt5,
    bigint_mul,
    nondet_bigint3,
)

from src.bn254.curve import P0, P1, P2

const SHIFT_MIN_BASE = SHIFT - BASE;
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

func add_bigint3{range_check_ptr}(a: BigInt3, b: BigInt3) -> BigInt3 {
    alloc_locals;
    local has_carry_low: felt;
    local has_carry_mid: felt;
    local needs_reduction: felt;
    local sum: BigInt3;

    let sum_low = a.d0 + b.d0;
    let sum_mid = a.d1 + b.d1;
    let sum_high = a.d2 + b.d2;

    %{
        has_carry_low = 1 if ids.sum_low >= ids.BASE else 0
        ids.has_carry_low = has_carry_low
        ids.has_carry_mid = 1 if (ids.sum_mid + has_carry_low) >= ids.BASE else 0
    %}

    if (has_carry_low != 0) {
        if (has_carry_mid != 0) {
            assert sum.d0 = sum_low - BASE;
            assert sum.d1 = sum_mid + 1 - BASE;
            assert sum.d2 = sum_high + 1;
            assert [range_check_ptr] = sum.d0 + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = sum.d1 + (SHIFT_MIN_BASE);
            let range_check_ptr = range_check_ptr + 2;
            return sum;
        } else {
            assert sum.d0 = sum_low - BASE;
            assert sum.d1 = sum_mid + 1;
            assert sum.d2 = sum_high;
            assert [range_check_ptr] = sum.d0 + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = sum.d1 + (SHIFT_MIN_BASE);
            let range_check_ptr = range_check_ptr + 2;
            return sum;
        }
    } else {
        if (has_carry_mid != 0) {
            assert sum.d0 = sum_low;
            assert sum.d1 = sum_mid - BASE;
            assert sum.d2 = sum_high + 1;
            assert [range_check_ptr] = sum.d1 + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = sum.d2 + (SHIFT_MIN_BASE);
            let range_check_ptr = range_check_ptr + 2;
            return sum;
        } else {
            assert sum.d0 = sum_low;
            assert sum.d1 = sum_mid;
            assert sum.d2 = sum_high;
            assert [range_check_ptr] = sum.d0 + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = sum.d1 + (SHIFT_MIN_BASE);
            let range_check_ptr = range_check_ptr + 2;
            return sum;
        }
    }
}
func sub_bigint3{range_check_ptr}(a: BigInt3, b: BigInt3) -> BigInt3 {
    alloc_locals;
    %{
        p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

        sub_mod_p = value = (ids.a.d0 + ids.a.d1*2**86 + ids.a.d2*2**172 - ids.b.d0 - ids.b.d1*2**86 - ids.b.d2*2**172)%p
    %}
    let (sub_mod_p) = nondet_bigint3();
    let check = add_bigint3(b, sub_mod_p);
    assert check.d0 = a.d0;
    assert check.d1 = a.d1;
    assert check.d2 = a.d2;

    return sub_mod_p;
}
namespace fq_bigint3 {
    func add{range_check_ptr}(a: BigInt3, b: BigInt3) -> BigInt3 {
        alloc_locals;
        local needs_reduction: felt;
        let P = BigInt3(P0, P1, P2);
        let sum = add_bigint3(a, b);
        %{
            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            sum = ids.sum.d0 + ids.sum.d1*2**86 + ids.sum.d2*2**172
            ids.needs_reduction = 1 if sum>=p else 0
        %}

        if (sum.d2 == P2) {
            if (sum.d1 == P1) {
                if (needs_reduction != 0) {
                    assert [range_check_ptr] = sum.d0 - P0;
                    let range_check_ptr = range_check_ptr + 1;
                    let res = sub_bigint3(sum, P);
                    return res;
                } else {
                    assert [range_check_ptr] = P0 - sum.d0 - 1;
                    let range_check_ptr = range_check_ptr + 1;
                    return sum;
                }
            } else {
                if (needs_reduction != 0) {
                    assert [range_check_ptr] = sum.d1 - P1;
                    let range_check_ptr = range_check_ptr + 1;
                    let res = sub_bigint3(sum, P);
                    return res;
                } else {
                    %{ print('case 3') %}
                    assert [range_check_ptr] = P1 - sum.d1 - 1;
                    let range_check_ptr = range_check_ptr + 1;
                    return sum;
                }
            }
        } else {
            if (needs_reduction != 0) {
                assert [range_check_ptr] = sum.d2 - P2;
                let range_check_ptr = range_check_ptr + 1;

                let res = sub_bigint3(sum, P);
                return res;
            } else {
                assert [range_check_ptr] = P2 - sum.d2 - 1;
                let range_check_ptr = range_check_ptr + 1;

                return sum;
            }
        }
    }
    func neg{range_check_ptr}(a: BigInt3) -> BigInt3 {
        alloc_locals;
        %{
            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            value = neg = -1*(ids.a.d0 + ids.a.d1*2**86 + ids.a.d2*2**172)%p
        %}
        let (neg) = nondet_bigint3();
        let check = add_bigint3(neg, a);
        assert check.d0 = P0;
        assert check.d1 = P1;
        assert check.d2 = P2;

        return neg;
    }
    func sub{range_check_ptr}(a: BigInt3, b: BigInt3) -> BigInt3 {
        alloc_locals;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import pack
            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            assert PRIME == 2**251 + 17*2**192 + 1
            a = pack(ids.a, p)
            b = pack(ids.b, p)
            #print('a =', a)
            #print ('a-b =', (a-b)%p)
            sub_mod_p = value = (a-b)%p
        %}
        let (sub_mod_p) = nondet_bigint3();
        let check = add(b, sub_mod_p);
        assert check.d0 = a.d0;
        assert check.d1 = a.d1;
        assert check.d2 = a.d2;

        return sub_mod_p;
    }
    func mul{range_check_ptr}(a: BigInt3, b: BigInt3) -> BigInt3 {
        alloc_locals;
        let mul: UnreducedBigInt5 = bigint_mul(a, b);
        %{
            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            mul = ids.mul.d0 + ids.mul.d1*2**86 + ids.mul.d2*2**172 + ids.mul.d3*2**258 + ids.mul.d4*2**344
            value = mul%p
        %}
        let (result: BigInt3) = nondet_bigint3();
        verify_zero5(
            UnreducedBigInt5(
                d0=mul.d0 - result.d0,
                d1=mul.d1 - result.d1,
                d2=mul.d2 - result.d2,
                d3=mul.d3,
                d4=mul.d4,
            ),
        );
        return result;
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
    let (k) = nondet_bigint3();
    let fullk = BigInt3(q1 * P0 + k.d0, q1 * P1 + k.d1, q1 * P2 + k.d2);
    let P = BigInt3(P0, P1, P2);
    let (k_n) = bigint_mul(fullk, P);

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
    let (x_inv) = nondet_bigint3();
    let (x_x_inv) = bigint_mul(x, x_inv);

    // Check that x * x_inv = 1 to verify that x != 0.
    verify_zero5(
        UnreducedBigInt5(
            d0=x_x_inv.d0 - 1, d1=x_x_inv.d1, d2=x_x_inv.d2, d3=x_x_inv.d3, d4=x_x_inv.d4
        ),
    );
    return (res=0);
}
