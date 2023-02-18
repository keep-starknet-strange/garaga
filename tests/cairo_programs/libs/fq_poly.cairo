from starkware.cairo.common.bitwise import bitwise_and, bitwise_or, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import (
    assert_in_range,
    assert_le,
    assert_nn_le,
    assert_not_zero,
    assert_le_felt,
    assert_lt_felt,
)
from starkware.cairo.common.math import unsigned_div_rem as felt_divmod
from starkware.cairo.common.math_cmp import is_le, is_nn
from starkware.cairo.common.registers import get_ap, get_fp_and_pc
from starkware.cairo.common.cairo_secp.constants import BASE
from tests.cairo_programs.libs.u255 import u255, Uint256, Uint512, Uint768
from src.bn254.curve import (
    P_low,
    P_high,
    P2_low,
    P2_high,
    P3_low,
    P3_high,
    M_low,
    M_high,
    mu,
    t,
    P0,
    P1,
    P2,
)
from tests.cairo_programs.libs.uint384 import uint384_lib, Uint384
from starkware.cairo.common.uint256 import SHIFT, uint256_le, uint256_lt, assert_uint256_le
from tests.cairo_programs.libs.uint256_improvements import uint256_unsigned_div_rem
from src.utils import get_felt_bitlength, pow2, felt_divmod_no_input_check
from starkware.cairo.common.cairo_secp.bigint import (
    BigInt3,
    uint256_to_bigint,
    bigint_to_uint256,
    UnreducedBigInt5,
    bigint_mul,
    nondet_bigint3,
)

struct Polyfelt {
    p00: felt,
    p10: felt,
    p20: felt,
    p30: felt,
    p40: felt,
}
struct Polyfelt3 {
    low: felt,
    mid: felt,
    high: felt,
}

namespace fq_poly {
    func to_polyfelt{range_check_ptr}(a: Uint256) -> Polyfelt {
        alloc_locals;
        let (a4, r) = uint256_unsigned_div_rem(
            a,
            Uint256(272204382041124684987214825571503402433, 1786771239255088250803009499627505898),
        );
        assert a4.high = 0;
        let (a3, r) = uint256_unsigned_div_rem(
            r, Uint256(331349846221318139915745154521890902225, 359825430517661861)
        );
        // May use felt_divmod here for the last two:
        let (a2, r) = uint256_unsigned_div_rem(
            r, Uint256(24657792813631553165138951344902952161, 0)
        );
        let (a1, a0) = uint256_unsigned_div_rem(r, Uint256(4965661367192848881, 0));

        assert a3.high = 0;
        assert a2.high = 0;
        assert a1.high = 0;
        assert a0.high = 0;

        let a00 = a0.low;
        let a10 = a1.low;
        let a20 = a2.low;
        let a30 = a3.low;
        let a40 = a4.low;

        let res = Polyfelt(a00, a10, a20, a30, a40);
        return res;
    }
    // Returns 1 if a >= 0 (or more precisely 0 <= a < RANGE_CHECK_BOUND).
    // Returns 0 otherwise.
    // @known_ap_change
    // func is_nn{range_check_ptr}(a) -> felt {
    //     %{ memory[ap] = 0 if 0 <= (ids.a % PRIME) < range_check_builtin.bound else 1 %}
    //     jmp out_of_range if [ap] != 0, ap++;
    //     [range_check_ptr] = a;
    //     ap += 20;
    //     let range_check_ptr = range_check_ptr + 1;
    //     return 1;

    // out_of_range:
    //     %{ memory[ap] = 0 if 0 <= ((-ids.a - 1) % PRIME) < range_check_builtin.bound else 1 %}
    //     jmp need_felt_comparison if [ap] != 0, ap++;
    //     assert [range_check_ptr] = (-a) - 1;
    //     ap += 17;
    //     let range_check_ptr = range_check_ptr + 1;
    //     return 0;

    // need_felt_comparison:
    //     assert_le_felt(RC_BOUND, a);
    //     return 0;
    // }

    // Checks if the unsigned integer lift (as a number in the range [0, PRIME)) of a is lower than
    // or equal to that of b.
    // See split_felt() for more details.
    // Returns 1 if true, 0 otherwise.
    @known_ap_change
    func is_le_felt{range_check_ptr}(a, b) -> felt {
        %{ memory[ap] = 0 if (ids.a % PRIME) <= (ids.b % PRIME) else 1 %}
        jmp not_le if [ap] != 0, ap++;
        ap += 6;
        assert_le_felt(a, b);
        return 1;

        not_le:
        assert_lt_felt(b, a);
        return 0;
    }

    @known_ap_change
    func assert_le_felt{range_check_ptr}(a, b) {
        // ceil(PRIME / 3 / 2 ** 128).
        const PRIME_OVER_3_HIGH = 0x2aaaaaaaaaaaab05555555555555556;
        // ceil(PRIME / 2 / 2 ** 128).
        const PRIME_OVER_2_HIGH = 0x4000000000000088000000000000001;
        // The numbers [0, a, b, PRIME - 1] should be ordered. To prove that, we show that two of the
        // 3 arcs {0 -> a, a -> b, b -> PRIME - 1} are small:
        //   One is less than PRIME / 3 + 2 ** 129.
        //   Another is less than PRIME / 2 + 2 ** 129.
        // Since the sum of the lengths of these two arcs is less than PRIME, there is no wrap-around.
        %{
                        import itertools

            from starkware.cairo.common.math_utils import assert_integer
                        assert_integer(4407920970296243842837207485651524041978352485963568397222)
                        assert_integer(ids.b)
                        a = 4407920970296243842837207485651524041978352485963568397222
                        b = ids.b % PRIME
                        assert a <= b, f'a = {a} is not less than or equal to b = {b}.'

            # Find an arc less than PRIME / 3, and another less than PRIME / 2.
                        lengths_and_indices = [(a, 0), (b - a, 1), (PRIME - 1 - b, 2)]
                        lengths_and_indices.sort()
                        assert lengths_and_indices[0][0] <= PRIME // 3 and lengths_and_indices[1][0] <= PRIME // 2
                        excluded = lengths_and_indices[2][1]

            memory[ids.range_check_ptr + 1], memory[ids.range_check_ptr + 0] = (
                            divmod(lengths_and_indices[0][0], ids.PRIME_OVER_3_HIGH))
                        memory[ids.range_check_ptr + 3], memory[ids.range_check_ptr + 2] = (
                            divmod(lengths_and_indices[1][0], ids.PRIME_OVER_2_HIGH))
        %}
        // Guess two arc lengths.
        tempvar arc_short = [range_check_ptr] + [range_check_ptr + 1] * PRIME_OVER_3_HIGH;
        tempvar arc_long = [range_check_ptr + 2] + [range_check_ptr + 3] * PRIME_OVER_2_HIGH;
        let range_check_ptr = range_check_ptr + 4;

        // First, choose which arc to exclude from {0 -> a, a -> b, b -> PRIME - 1}.
        // Then, to compare the set of two arc lengths, compare their sum and product.
        let arc_sum = arc_short + arc_long;
        let arc_prod = arc_short * arc_long;

        // Exclude "0 -> a".
        %{ memory[ap] = 1 if excluded != 0 else 0 %}
        jmp skip_exclude_a if [ap] != 0, ap++;
        assert arc_sum = (-1) - 4407920970296243842837207485651524041978352485963568397222;
        assert arc_prod = (a - b) * (1 + b);
        return ();

        // Exclude "a -> b".
        skip_exclude_a:
        %{ memory[ap] = 1 if excluded != 1 else 0 %}
        jmp skip_exclude_b_minus_a if [ap] != 0, ap++;
        tempvar m1mb = (-1) - b;
        assert arc_sum = a + m1mb;
        assert arc_prod = a * m1mb;
        return ();

        // Exclude "b -> PRIME - 1".
        skip_exclude_b_minus_a:
        %{ assert excluded == 2 %}
        assert arc_sum = b;
        assert arc_prod = a * (b - a);
        ap += 2;
        return ();
    }
    func polyadd{range_check_ptr}(a: Polyfelt, b: Polyfelt) -> Polyfelt {
        alloc_locals;
        const P_of_t_high = 178763809218942559752;  // = 36 + 36*t
        const P_of_t_middle = 119175872812628373150;  // 6 + 24*t
        let c00 = a.p00 + b.p00;
        let c10 = a.p10 + b.p10;
        let c20 = a.p20 + b.p20;
        let c30 = a.p30 + b.p30;
        let c40 = a.p40 + b.p40;
        let C_of_t_middle = c10 + c20 * t;
        let C_of_t_high = c30 + c40 * t;
        local reduction_needed: felt;
        %{
            C=ids.c00 + ids.c10*ids.t + ids.c20*ids.t**2 + ids.c30*ids.t**3 + ids.c40*ids.t**4
            ids.reduction_needed = 1 if C>= 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 else 0
            print(f"Reduction needed : C(t) >= P(t)")
        %}
        if (C_of_t_high == P_of_t_high) {
            if (C_of_t_middle == P_of_t_middle) {
                if (reduction_needed == 1) {
                    assert [range_check_ptr] = c00 - 1;
                    let range_check_ptr = range_check_ptr + 1;
                    let res = Polyfelt(c00 - 1, c10 - 6, c20 - 24, c30 - 36, c40 - 36);
                    return res;
                } else {
                    assert [range_check_ptr] = 1 - c00;
                    let range_check_ptr = range_check_ptr + 1;
                    let res = Polyfelt(c00, c10, c20, c30, c40);
                    return res;
                }
            } else {
                if (reduction_needed == 1) {
                    assert [range_check_ptr] = C_of_t_middle - P_of_t_middle;
                    let range_check_ptr = range_check_ptr + 1;
                    let res = Polyfelt(c00 - 1, c10 - 6, c20 - 24, c30 - 36, c40 - 36);
                    return res;
                } else {
                    assert [range_check_ptr] = P_of_t_middle - C_of_t_middle;
                    let range_check_ptr = range_check_ptr + 1;
                    let res = Polyfelt(c00, c10, c20, c30, c40);
                    return res;
                }
            }
        } else {
            if (reduction_needed == 1) {
                assert [range_check_ptr] = C_of_t_high - P_of_t_high;
                let range_check_ptr = range_check_ptr + 1;
                let res = Polyfelt(c00 - 1, c10 - 6, c20 - 24, c30 - 36, c40 - 36);
                return res;
            } else {
                assert [range_check_ptr] = P_of_t_high - C_of_t_high;
                let range_check_ptr = range_check_ptr + 1;
                let res = Polyfelt(c00, c10, c20, c30, c40);
                return res;
            }
        }
    }

    func polyadd_3{range_check_ptr}(a: Polyfelt3, b: Polyfelt3) -> Polyfelt3 {
        alloc_locals;
        const P_of_t_high = 178763809218942559752;  // = 36 + 36*t
        const P_of_t_middle = 119175872812628373150;  // 6 + 24*t
        let low = a.low + b.low;
        let mid = a.mid + b.mid;
        let high = a.high + b.high;

        local reduction_needed: felt;
        %{
            C=ids.low + ids.mid*ids.t + ids.high*ids.t**3
            ids.reduction_needed = 1 if C>= 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 else 0
            print(f"Reduction needed : C(t) >= P(t)")
        %}
        if (high == P_of_t_high) {
            if (mid == P_of_t_middle) {
                if (reduction_needed == 1) {
                    assert [range_check_ptr] = low - 1;
                    let range_check_ptr = range_check_ptr + 1;
                    let res = Polyfelt3(low - 1, mid - P_of_t_middle, high - P_of_t_high);
                    return res;
                } else {
                    assert [range_check_ptr] = 1 - low;
                    let range_check_ptr = range_check_ptr + 1;
                    let res = Polyfelt3(low, mid, high);
                    return res;
                }
            } else {
                if (reduction_needed == 1) {
                    assert [range_check_ptr] = mid - P_of_t_middle;
                    let range_check_ptr = range_check_ptr + 1;
                    let res = Polyfelt3(low - 1, mid - P_of_t_middle, high - P_of_t_high);
                    return res;
                } else {
                    assert [range_check_ptr] = P_of_t_middle - mid;
                    let range_check_ptr = range_check_ptr + 1;
                    let res = Polyfelt3(low, mid, high);
                    return res;
                }
            }
        } else {
            if (reduction_needed == 1) {
                assert [range_check_ptr] = high - P_of_t_high;
                let range_check_ptr = range_check_ptr + 1;
                let res = Polyfelt3(low - 1, mid - P_of_t_middle, high - P_of_t_high);
                return res;
            } else {
                assert [range_check_ptr] = P_of_t_high - high;
                let range_check_ptr = range_check_ptr + 1;
                let res = Polyfelt3(low, mid, high);
                return res;
            }
        }
    }
    func add_reduce_coeffs{range_check_ptr}(a: Polyfelt, b: Polyfelt) -> (
        c0: felt, c1: felt, c2: felt, c3: felt, c4: felt
    ) {
        let c0 = ap;
        [c0] = a.p00 + b.p00, ap++;

        let c1 = ap;
        [c1] = a.p10 + b.p10, ap++;

        let c2 = ap;
        [c2] = a.p20 + b.p20, ap++;

        let c3 = ap;
        [c3] = a.p30 + b.p30, ap++;

        let c4 = ap;
        [c4] = a.p40 + b.p40, ap++;

        let c0_t = ap;
        [c0_t] = [c0] - t, ap++;

        let c1_t = ap;
        [c1_t] = [c1] - t, ap++;

        let c2_t = ap;
        [c2_t] = [c2] - t, ap++;

        let c3_t = ap;
        [c3_t] = [c3] - t, ap++;

        tempvar degree_0_superior_to_t = is_nn([c0_t]);  // if 1, c0>=t, if 0, c0<t
        jmp degree_0xxxx_needs_reduction if degree_0_superior_to_t != 0;
        tempvar degree_1_superior_to_t = is_nn([c1_t]);
        jmp degree_n1xxx_needs_reduction if degree_1_superior_to_t != 0;  // ALL ok
        tempvar degree_2_superior_to_t = is_nn([c2_t]);
        jmp degree_nn2xx_needs_reduction if degree_2_superior_to_t != 0;  // All ok
        tempvar degree_3_superior_to_t = is_nn([c3_t]);
        jmp degree_nnn3x_needs_reduction if degree_3_superior_to_t != 0;  // ALL ok
        return ([c0], [c1], [c2], [c3], [c4]);

        degree_0xxxx_needs_reduction:
        // (c0 - t) already in c0_t
        let c1_plus_one = ap;
        [c1_plus_one] = [c1] + 1, ap++;
        let c1_plus_one_min_t = ap;
        [c1_plus_one_min_t] = [c1_t] + 1, ap++;
        tempvar degree_1_superior_to_t = is_nn([c1_plus_one_min_t]);  // if 1, c1>=t, if 0, c1<t
        jmp degree_01xxx_needs_reduction if degree_1_superior_to_t != 0;

        tempvar degree_2_superior_to_t = is_nn([c2_t]);
        jmp degree_0n2xx_needs_reduction if degree_2_superior_to_t != 0;
        tempvar degree_3_superior_to_t = is_nn([c3_t]);
        jmp degree_0nn3x_needs_reduction if degree_3_superior_to_t != 0;
        return ([c0_t], [c1_plus_one], [c2], [c3], [c4]);

        degree_01xxx_needs_reduction:
        let c2_plus_one = ap;
        [c2_plus_one] = [c2] + 1, ap++;
        let c2_plus_one_min_t = ap;
        [c2_plus_one_min_t] = [c2_t] + 1, ap++;
        let degree_2_superior_to_t = ap;
        tempvar degree_2_superior_to_t = is_nn([c2_plus_one_min_t]);
        jmp degree_012xx_needs_reduction if degree_2_superior_to_t != 0;
        tempvar degree_3_superior_to_t = is_nn([c3_t]);
        jmp degree_01n3x_needs_reduction if degree_3_superior_to_t != 0;
        return ([c0_t], [c1_plus_one_min_t], [c2_plus_one], [c3], [c4]);

        degree_nnn3x_needs_reduction:
        return ([c0], [c1], [c2], [c3_t], [c4] + 1);

        degree_nn2xx_needs_reduction:
        tempvar c3_plus_one = [c3] + 1;
        let c3_plus_one_min_t = ap;
        [c3_plus_one_min_t] = [c3_t] + 1, ap++;
        tempvar degree_3_superior_to_t = is_nn([c3_plus_one_min_t]);
        jmp degree_nn23x_needs_reduction if degree_3_superior_to_t != 0;
        return ([c0], [c1], [c2_t], [c3_plus_one], [c4]);

        degree_nn23x_needs_reduction:
        return ([c0], [c1], [c2_t], [c3_plus_one_min_t], [c4]);

        degree_n1xxx_needs_reduction:
        // (c1 - t) already in c0_t
        let c2_plus_one = ap;
        [c2_plus_one] = [c2] + 1, ap++;
        let c2_plus_one_min_t = ap;
        [c2_plus_one_min_t] = [c2_t] + 1, ap++;
        tempvar degree_2_superior_to_t = is_nn([c2_plus_one_min_t]);
        jmp degree_n12xx_needs_reduction if degree_2_superior_to_t != 0;  // all ok
        tempvar degree_3_superior_to_t = is_nn([c3_t]);
        jmp degree_n1n3x_needs_reduction if degree_3_superior_to_t != 0;  // all ok
        return ([c0], [c1_t], [c2_plus_one], [c3], [c4]);

        degree_n1n3x_needs_reduction:
        return ([c0], [c1_t], [c2_plus_one], [c3_t], [c4] + 1);

        degree_n12xx_needs_reduction:
        // (c2_plus_one_min_t) already in degree_n1xxx_needs_reduction
        let c3_plus_one = ap;
        [c3_plus_one] = [c3] + 1, ap++;
        let c3_plus_one_min_t = ap;
        [c3_plus_one_min_t] = [c3_t] + 1, ap++;
        tempvar degree_3_superior_to_t = is_nn([c3_plus_one_min_t]);
        jmp degree_n123x_needs_reduction if degree_3_superior_to_t != 0;
        return ([c0], [c1_t], [c2_plus_one_min_t], [c3_plus_one], [c4]);

        degree_n123x_needs_reduction:
        // (c3_plus_one_min_t) already in degree_n12xx_needs_reduction
        return ([c0], [c1_t], [c2_plus_one_min_t], [c3_plus_one_min_t], [c4] + 1);

        degree_0nn3x_needs_reduction:
        return ([c0_t], [c1_plus_one], [c2], [c3_t], [c4] + 1);

        degree_01n3x_needs_reduction:
        return ([c0_t], [c1_plus_one_min_t], [c2_plus_one], [c3_t], [c4] + 1);

        degree_0n2xx_needs_reduction:
        let c3_plus_one = ap;
        [c3_plus_one] = [c3] + 1, ap++;
        let c3_plus_one_min_t = ap;
        [c3_plus_one_min_t] = [c3_t] + 1, ap++;
        tempvar degree_3_superior_to_t = is_nn([c3_plus_one_min_t]);
        jmp degree_0n23x_needs_reduction if degree_3_superior_to_t != 0;
        return ([c0_t], [c1_plus_one], [c2_t], [c3_plus_one], [c4]);

        degree_0n23x_needs_reduction:
        return ([c0_t], [c1_plus_one], [c2_t], [c3_plus_one_min_t], [c4] + 1);

        degree_012xx_needs_reduction:
        let c3_plus_one = ap;
        [c3_plus_one] = [c3] + 1, ap++;
        let c3_plus_one_min_t = ap;
        [c3_plus_one_min_t] = [c3_t] + 1, ap++;
        tempvar degree_3_superior_to_t = is_nn([c3_plus_one_min_t]);
        jmp degree_0123x_needs_reduction if degree_3_superior_to_t != 0;
        return ([c0_t], [c1_plus_one_min_t], [c2_plus_one_min_t], [c3_plus_one], [c4]);

        degree_0123x_needs_reduction:
        return ([c0_t], [c1_plus_one_min_t], [c2_plus_one_min_t], [c3_plus_one_min_t], [c4] + 1);
    }
    // Adds two polynomials of the form a(t) = a0 + a1*t + a2*t^2 + a3*t³ + a4*t⁴ with prelimnimary coefficient reduction
    // If c_i = a_i + b_i >= t for i = 0, 1, 2, 3, do c_i=c_i - t; c_i+1 = c_i+1 + 1;
    // This version tries to play with the prover for efficiency. However soundness is not guaranteed. See Todo.
    func add_a{range_check_ptr}(a: Polyfelt, b: Polyfelt) -> Polyfelt {
        alloc_locals;
        // BEGIN0
        // 3. c(t) = c(t) + a(t)bj
        local c00;
        local c10;
        local c20;
        local c30;
        local c40;
        local is_nn0;
        local is_nn1;
        local is_nn2;
        local is_nn3;
        // local is_nn0_inv;
        // local is_nn1_inv;
        // local is_nn2_inv;
        // local is_nn3_inv;

        let c0 = a.p00 + b.p00;
        let c1 = a.p10 + b.p10;
        let c2 = a.p20 + b.p20;
        let c3 = a.p30 + b.p30;
        let c4 = a.p40 + b.p40;

        %{
            is_superior_to_t=1 if (ids.c0) >= ids.t else 0
            ids.is_nn0 = is_superior_to_t
            ids.c00 = (ids.c0) - is_superior_to_t*ids.t
        %}
        %{
            is_superior_to_t=1 if (ids.c1) >= ids.t else 0
            ids.is_nn1 = is_superior_to_t
            ids.c10 = (ids.c1) - is_superior_to_t*ids.t
        %}
        %{
            is_superior_to_t=1 if (ids.c2) >= ids.t else 0
            ids.is_nn2 = is_superior_to_t
            ids.c20 = (ids.c2) - is_superior_to_t*ids.t
        %}
        %{
            is_superior_to_t=1 if (ids.a.p30+ids.b.p30) >= ids.t else 0
            ids.is_nn3 = is_superior_to_t
            ids.c30 = (ids.c3) - is_superior_to_t*ids.t
        %}

        // assert is_nn0 * (1 - is_nn0) + is_nn1 * (1 - is_nn1) + is_nn2 * (1 - is_nn2) + is_nn3 * (1 - is_nn3) = 0;
        // assert all values are either 0 or 1
        assert is_nn0 * is_nn0 = is_nn0;
        assert is_nn1 * is_nn1 = is_nn1;
        assert is_nn2 * is_nn2 = is_nn2;
        assert is_nn3 * is_nn3 = is_nn3;

        // If is_nnx = 1, the prover cannot cheat as cx - t would be < 0,
        // so if the assert cx0 = cx - is_nnx*t passes,
        // the assert 4*t - c00 - c10 - c20 - c30 would be < 0 and program fails.
        // If is_nnx = 0, the prover cannot cheat by setting cx0 = cx when cx>t as cx - t would be > 0
        // so if the assert cx0 = cx passes,
        // the assert 4*t - c00 - c10 - c20 - c30 would be < 0 and program fails.

        // however, prover could cheat by setting is_nn = 0 and cx0 = cx, when cx is not a reduced value.
        // We need to prove the value is indeed not needed to be reduced.
        // If the prover cheat by setting is_nnx = 0 when the value is >=t, then t - cx0 < 0
        assert c00 = c0 - is_nn0 * t;
        let c00_inv = c0 - (1 - is_nn0) * t;
        assert c10 = c1 - is_nn1 * t;
        let c10_inv = c1 - (1 - is_nn1) * t;
        assert c20 = c2 - is_nn2 * t;
        let c20_inv = c2 - (1 - is_nn2) * t;
        assert c30 = c3 - is_nn3 * t;
        let c30_inv = c3 - (1 - is_nn3) * t;
        assert c40 = c4 + is_nn3;

        // sum only coefficients that are supposed to be reduced and check non negative
        // any wrongly reduced value would be < 0 (as is ~64 bits and prime 252 bits, any
        // wrongly reduced value would be would make this sum higher than range check bound
        assert [range_check_ptr] = c00 + c10 + c20 + c30;
        let range_check_ptr = range_check_ptr + 1;
        // TODO :
        // sum only coefficients that are supposed to not be reduced, reduce them and check non negative
        // tempvar sum_inferior_to_4t = is_nn(is_nn0 * c00 + is_nn1 * c10 + is_nn2 * c20 + is_nn3 * c30);
        // assert sum_inferior_to_4t = 1;
        return reduce_if_superior_to_P(c00, c10, c20, c30, c40);
    }

    // Adds two polynomials of the form a(t) = a0 + a1*t + a2*t^2 + a3*t³ + a4*t⁴ with prelimnimary coefficient reduction
    // If c_i = a_i + b_i >= t for i = 0, 1, 2, 3, do c_i=c_i - t; c_i+1 = c_i+1 + 1;
    func add_b{range_check_ptr}(a: Polyfelt, b: Polyfelt) -> Polyfelt {
        alloc_locals;
        local c00;
        local c10;
        local c20;
        local c30;
        local c40;
        local is_nn0;
        local is_nn1;
        local is_nn2;
        local is_nn3;
        let c0 = a.p00 + b.p00;
        let c1 = a.p10 + b.p10;
        let c2 = a.p20 + b.p20;
        let c3 = a.p30 + b.p30;
        let c4 = a.p40 + b.p40;
        assert is_nn0 = is_nn(c0 - t);
        assert c00 = c0 - is_nn0 * t;
        let c1 = c1 + is_nn0;
        assert is_nn1 = is_nn(c1 - t);
        assert c10 = c1 - is_nn1 * t;
        let c2 = c2 + is_nn1;
        assert is_nn2 = is_nn(c2 - t);
        assert c20 = c2 - is_nn2 * t;
        let c3 = c3 + is_nn2;
        assert is_nn3 = is_nn(c3 - t);
        assert c30 = c3 - is_nn3 * t;
        assert c40 = c4 + is_nn3;

        return reduce_if_superior_to_P(c00, c10, c20, c30, c40);
    }

    func add_c{range_check_ptr}(a: Polyfelt, b: Polyfelt) -> Polyfelt {
        alloc_locals;
        let (c00, c10, c20, c30, c40) = add_reduce_coeffs(a, b);
        return reduce_if_superior_to_P(c00, c10, c20, c30, c40);
    }
    // Substract P(t) coefficients to c(t) coefficients if c(t) >= P(t).
    // Assumes c00, ... c30 are reduced to < t.
    // Could be slightly optimized by a one or two low level steps.
    func reduce_if_superior_to_P{range_check_ptr}(c00, c10, c20, c30, c40) -> Polyfelt {
        if (c40 == 36) {
            if (c30 == 36) {
                if (c20 == 24) {
                    if (c10 == 6) {
                        if (c00 == 1) {
                            let res = Polyfelt(c00, c10, c20, c30, c40);
                            return res;
                        } else {
                            // Differs to P only on C00
                            if (c00 == 0) {
                                let res = Polyfelt(c00, c10, c20, c30, c40);
                                return res;
                            } else {
                                // It's higher than P
                                let res = Polyfelt(c00 - 1, c10 - 6, c20 - 24, c30 - 36, c40 - 36);
                                return res;
                            }
                        }
                    } else {
                        let is_c1_le_6 = is_nn(6 - c10);
                        if (is_c1_le_6 == 1) {
                            let res = Polyfelt(c00, c10, c20, c30, c40);
                            return res;
                        } else {
                            let res = Polyfelt(c00 - 1, c10 - 6, c20 - 24, c30 - 36, c40 - 36);
                            return res;
                        }
                    }
                } else {
                    let is_c2_le_24 = is_nn(24 - c20);
                    if (is_c2_le_24 == 1) {
                        let res = Polyfelt(c00, c10, c20, c30, c40);
                        return res;
                    } else {
                        let res = Polyfelt(c00 - 1, c10 - 6, c20 - 24, c30 - 36, c40 - 36);
                        return res;
                    }
                }
            } else {
                let is_c3_le_35 = is_nn(35 - c30);
                if (is_c3_le_35 == 1) {
                    let res = Polyfelt(c00, c10, c20, c30, c40);
                    return res;
                } else {
                    let res = Polyfelt(c00 - 1, c10 - 6, c20 - 24, c30 - 36, c40 - 36);
                    return res;
                }
            }
        } else {
            let is_c4_le_35 = is_nn(35 - c40);
            if (is_c4_le_35 == 1) {
                let res = Polyfelt(c00, c10, c20, c30, c40);
                return res;
            } else {
                // Handle special case a+b=2*p = 0 mod p
                if (c40 == 72) {
                    if (c30 == 72) {
                        if (c20 == 48) {
                            if (c10 == 12) {
                                if (c00 == 2) {
                                    let res = Polyfelt(0, 0, 0, 0, 0);
                                    return res;
                                } else {
                                    let res = Polyfelt(
                                        c00 - 1, c10 - 6, c20 - 24, c30 - 36, c40 - 36
                                    );

                                    return res;
                                }
                            } else {
                                let res = Polyfelt(c00 - 1, c10 - 6, c20 - 24, c30 - 36, c40 - 36);
                                return res;
                            }
                        } else {
                            let res = Polyfelt(c00 - 1, c10 - 6, c20 - 24, c30 - 36, c40 - 36);
                            return res;
                        }
                    } else {
                        let res = Polyfelt(c00 - 1, c10 - 6, c20 - 24, c30 - 36, c40 - 36);
                        return res;
                    }
                } else {
                    let res = Polyfelt(c00 - 1, c10 - 6, c20 - 24, c30 - 36, c40 - 36);
                    return res;
                }
            }
        }
    }

    // [DEAD] Tries to guess if c(t)>=P(t) and reduce c(t) by P(t) coefficients if so.
    // [DEAD] However, the implication c(x) > p(x) => c(t) >= P(t) is not true.
    func reduce_if_superior_to_P_blasted{range_check_ptr}(c00, c10, c20, c30, c40) -> Polyfelt {
        alloc_locals;
        let c_of_2_reduced = c00 + c10 * 2 + c20 * 4 + c30 * 8 + c40 * 16 - 973;
        // let c_reduced = c_of_2 - 973;
        let is_superior_to_p_of_2 = is_nn(c_of_2_reduced);
        if (is_superior_to_p_of_2 == 1) {
            let res = Polyfelt(c00 - 1, c10 - 6, c20 - 24, c30 - 36, c40 - 36);
            return res;
        } else {
            let res = Polyfelt(c00, c10, c20, c30, c40);
            return res;
        }
    }
    func mul{range_check_ptr}(a: Polyfelt, b: Polyfelt) -> Polyfelt {
        alloc_locals;
        // BEGIN0
        %{ print('BEGIN0 \n') %}

        // 3. c(t) = c(t) + a(t)bj
        let c00 = a.p00 * b.p00;
        // %{ print_felt_info(ids.c00, "c00") %}
        // 4. mu = c00 // 2**m, gamma = c00%2**m - s*mu
        // let (mu, gamma) = felt_divmod(c00, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c00, 2 ** 63);

        const s = 857;
        let gamma = gamma - s * mu;

        // 5. g(t) = p(t) * gamma
        let (qc00, rc00) = felt_divmod_no_input_check(c00 - gamma, 4965661367192848881);
        let c00 = qc00 + mu;
        // %{ print_felt_info(ids.c00, "c00") %}
        let c1000 = a.p10 * b.p00 - 6 * gamma + c00;
        let c2010 = a.p20 * b.p00 - 24 * gamma;
        let c3020 = a.p30 * b.p00 - 36 * gamma;
        let c4030 = a.p40 * b.p00;

        %{ print_felt_info(ids.c1000, "c1000") %}

        %{ print_felt_info(ids.c2010, "c2010") %}
        %{ print_felt_info(ids.c3020, "c3020") %}
        %{ print_felt_info(ids.c4030, "c4030") %}

        // BEGIN1
        %{ print('BEGIN1 \n') %}

        // 3. c(t) = c(t) + a(t)bj

        let c00 = c1000 + a.p00 * b.p10;
        // %{ print_felt_info(ids.c00, "c00") %}
        // 4. mu = c00 // 2**m, gamma = c00%2**m - s*mu
        // let (mu, gamma) = felt_divmod(c00, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c00, 2 ** 63);

        let gamma = gamma - s * mu;

        // 5. g(t) = p(t) * gamma
        let (qc00, rc00) = felt_divmod_no_input_check(c00 - gamma, 4965661367192848881);
        let c00 = qc00 + mu;
        // %{ print_felt_info(ids.c00, "c00") %}
        let c1000 = c2010 + a.p10 * b.p10 - 6 * gamma + qc00 + mu;
        let c2010 = c3020 + a.p20 * b.p10 - 24 * gamma;
        let c3020 = c4030 + a.p30 * b.p10 - 36 * gamma;
        let c4030 = a.p40 * b.p10;

        // let is_nnk = is_nn(c4030t);
        // local c4030;
        // if (is_nnk == 0) {
        //     assert c4030 = (-1) * c4030t;
        // } else {
        //     assert c4030 = c4030t;
        // }
        // %{ print_felt_info(ids.c1000, "c1000") %}
        // %{ print_felt_info(ids.c2010, "c2010") %}
        // %{ print_felt_info(ids.c3020, "c3020") %}
        %{ print_felt_info(ids.c4030, "c4030") %}

        // BEGIN2
        %{ print('BEGIN2 \n') %}

        // 3. c(t) = c(t) + a(t)bj

        let c00 = c1000 + a.p00 * b.p20;
        // %{ print_felt_info(ids.c00, "c00") %}
        // 4. mu = c00 // 2**m, gamma = c00%2**m - s*mu
        // let (mu, gamma) = felt_divmod(c00, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c00, 2 ** 63);
        let gamma = gamma - s * mu;

        // 5. g(t) = p(t) * gamma
        let (qc00, rc00) = felt_divmod_no_input_check(c00 - gamma, 4965661367192848881);
        let c00 = qc00 + mu;
        // %{ print_felt_info(ids.c00, "c00") %}
        let c1000 = c2010 + a.p10 * b.p20 - 6 * gamma + qc00 + mu;
        let c2010 = c3020 + a.p20 * b.p20 - 24 * gamma;
        let c3020 = c4030 + a.p30 * b.p20 - 36 * gamma;
        let c4030 = a.p40 * b.p20;
        // let is_nnk = is_nn(c4030t);
        // local c4030;
        // if (is_nnk == 0) {
        //     assert c4030 = (-1) * c4030t;
        // } else {
        //     assert c4030 = c4030t;
        // }

        // %{ print_felt_info(ids.c1000, "c1000") %}

        // %{ print_felt_info(ids.c2010, "c2010") %}
        // %{ print_felt_info(ids.c3020, "c3020") %}
        %{ print_felt_info(ids.c4030, "c4030") %}

        // BEGIN3
        %{ print('\n BEGIN3 \n') %}
        // 3. c(t) = c(t) + a(t)bj

        let c00 = c1000 + a.p00 * b.p30;
        // %{ print_felt_info(ids.c00, "c00") %}

        let (mu, gamma) = felt_divmod_no_input_check(c00, 2 ** 63);

        let gamma = gamma - s * mu;

        // 5. g(t) = p(t) * gamma
        let (qc00, rc00) = felt_divmod_no_input_check(c00 - gamma, 4965661367192848881);
        let c00 = qc00 + mu;
        // %{ print_felt_info(ids.c00, "c00") %}
        let c1000 = c2010 + a.p10 * b.p30 - 6 * gamma + qc00 + mu;
        let c2010 = c3020 + a.p20 * b.p30 - 24 * gamma;
        let c3020 = c4030 + a.p30 * b.p30 - 36 * gamma;
        let c4030 = a.p40 * b.p30;
        // let is_nnk = is_nn(c4030t);
        // local c4030;
        // if (is_nnk == 0) {
        //     assert c4030 = (-1) * c4030t;
        // } else {
        //     assert c4030 = c4030t;
        // }

        // %{ print_felt_info(ids.c1000, "c1000") %}

        // %{ print_felt_info(ids.c2010, "c2010") %}
        // %{ print_felt_info(ids.c3020, "c3020") %}
        %{ print_felt_info(ids.c4030, "c4030") %}

        // BEGIN4

        %{ print('\n BEGIN4\n ') %}

        // 3. c(t) = c(t) + a(t)bj

        let c00 = c1000 + a.p00 * b.p40;
        // %{ print_felt_info(ids.c00, "c00") %}
        // 4. mu = c00 // 2**m, gamma = c00%2**m - s*mu
        // let (mu, gamma) = felt_divmod(c00, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c00, 2 ** 63);

        let gamma = gamma - s * mu;

        // 5. g(t) = p(t) * gamma
        let (qc00, rc00) = felt_divmod_no_input_check(c00 - gamma, 4965661367192848881);

        let c00 = qc00 + mu;
        // %{ print_felt_info(ids.c00, "c00") %}
        let c1000 = c2010 + a.p10 * b.p40 - 6 * gamma + qc00 + mu;
        let c2010 = c3020 + a.p20 * b.p40 - 24 * gamma;
        let c3020 = c4030 + a.p30 * b.p40 - 36 * gamma;

        let c4030 = a.p40 * b.p40;
        // let is_nnk = is_nn(c4030t);
        // local c4030;
        // if (is_nnk == 0) {
        //     assert c4030 = (-1) * c4030t;
        // } else {
        //     assert c4030 = c4030t;
        // }

        // %{ print_felt_info(ids.c1000, "c1000") %}
        // %{ print_felt_info(ids.c2010, "c2010") %}
        // %{ print_felt_info(ids.c3020, "c3020") %}
        %{ print_felt_info(ids.c4030, "c4030") %}

        // BEGIN 0
        // let (mu, gamma) = felt_divmod(c1000, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c1000, 2 ** 63);

        let c00 = gamma - s * mu;
        let c10 = c2010 + mu;
        // BEGIN 1
        // let (mu, gamma) = felt_divmod(c10, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c10, 2 ** 63);

        let c10 = gamma - s * mu;
        let c20 = c3020 + mu;
        // BEGIN 2
        // let (mu, gamma) = felt_divmod(c20, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c20, 2 ** 63);

        let c20 = gamma - s * mu;
        let c30 = c4030 + mu;
        // BEGIN 3
        // let (mu, gamma) = felt_divmod(c30, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c30, 2 ** 63);

        let c30 = gamma - s * mu;
        let c40 = mu;

        // BEGIN 0
        // let (mu, gamma) = felt_divmod(c1000, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c00, 2 ** 63);
        let c00 = gamma - s * mu;
        let c10 = c10 + mu;

        // BEGIN 1
        // let (mu, gamma) = felt_divmod(c10, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c10, 2 ** 63);
        let c10 = gamma - s * mu;
        let c20 = c20 + mu;
        // BEGIN 2
        // let (mu, gamma) = felt_divmod(c20, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c20, 2 ** 63);
        let c20 = gamma - s * mu;
        let c30 = c30 + mu;
        // BEGIN 3
        // let (mu, gamma) = felt_divmod(c30, 2 ** 63);
        let (mu, gamma) = felt_divmod_no_input_check(c30, 2 ** 63);
        let c30 = gamma - s * mu;
        let c40 = c40 + mu;

        %{
        %}
        let res = Polyfelt(c00, c10, c20, c30, c40);
        return res;
    }
}
