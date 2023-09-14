from starkware.cairo.common.registers import get_label_location, get_fp_and_pc
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_nn, unsigned_div_rem as felt_divmod, assert_nn_le
from src.bn254.g1 import G1Point, g1
from src.bn254.g2 import G2Point, g2, E4
from src.bn254.towers.e12 import (
    E12,
    e12,
    square_trick,
    mul034_trick,
    mul034_034_trick,
    VerifyMul034,
    VerifyPolySquare,
    VerifyMul034034,
    verify_extension_tricks,
    get_random_point_from_square_ops,
    get_random_point_from_mul034_ops,
    get_random_point_from_mul034034_ops,
)
from src.bn254.towers.e2 import E2, e2
from src.bn254.towers.e6 import E6, e6
from src.bn254.fq import BigInt3, fq_bigint3, felt_to_bigint3

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin
from starkware.cairo.common.builtin_poseidon.poseidon import poseidon_hash

const ate_loop_count = 29793968203157093288;
const log_ate_loop_count = 63;
const naf_count = 66;

func pair{range_check_ptr, poseidon_ptr: PoseidonBuiltin*}(P: G1Point*, Q: G2Point*) -> E12* {
    alloc_locals;
    g1.assert_on_curve(P);
    g2.assert_on_curve(Q);
    let (P_arr: G1Point**) = alloc();
    let (Q_arr: G2Point**) = alloc();
    assert P_arr[0] = P;
    assert Q_arr[0] = Q;
    let f = multi_miller_loop(P_arr, Q_arr, 1);
    let f = final_exponentiation(f, 1);
    return f;
}

func pair_multi{range_check_ptr, poseidon_ptr: PoseidonBuiltin*}(
    P_arr: G1Point**, Q_arr: G2Point**, n: felt
) -> E12* {
    alloc_locals;
    assert_nn_le(2, n);
    multi_assert_on_curve(P_arr, Q_arr, n - 1);
    let f = multi_miller_loop(P_arr, Q_arr, n);
    let f = final_exponentiation(f, 0);
    return f;
}

func multi_assert_on_curve{range_check_ptr}(P_arr: G1Point**, Q_arr: G2Point**, index: felt) {
    if (index == 0) {
        g1.assert_on_curve(P_arr[index]);
        g2.assert_on_curve(Q_arr[index]);
        return ();
    } else {
        g1.assert_on_curve(P_arr[index]);
        g2.assert_on_curve(Q_arr[index]);
        return multi_assert_on_curve(P_arr, Q_arr, index - 1);
    }
}

// ref : https://eprint.iacr.org/2022/1162 by @yelhousni
func multi_miller_loop{range_check_ptr, poseidon_ptr: PoseidonBuiltin*}(
    P: G1Point**, Q: G2Point**, n_points: felt
) -> E12* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    assert_nn(n_points);
    local is_n_sup_eq_2;
    local is_n_sup_eq_3;

    %{
        ids.is_n_sup_eq_2 = 1 if ids.n_points >= 2 else 0
        ids.is_n_sup_eq_3 = 1 if ids.n_points >= 3 else 0
    %}

    %{
        import numpy as np
        def print_e4(id):
            le=[]
            le+=[id.r0.a0.d0 + id.r0.a0.d1 * 2**86 + id.r0.a0.d2 * 2**172]
            le+=[id.r0.a1.d0 + id.r0.a1.d1 * 2**86 + id.r0.a1.d2 * 2**172]
            le+=[id.r1.a0.d0 + id.r1.a0.d1 * 2**86 + id.r1.a0.d2 * 2**172]
            le+=[id.r1.a1.d0 + id.r1.a1.d1 * 2**86 + id.r1.a1.d2 * 2**172]
            [print('e'+str(i), np.base_repr(le[i],36)) for i in range(4)]
        def print_e12(id):
            le=[]
            le+=[id.c0.b0.a0.d0 + id.c0.b0.a0.d1 * 2**86 + id.c0.b0.a0.d2 * 2**172]
            le+=[id.c0.b0.a1.d0 + id.c0.b0.a1.d1 * 2**86 + id.c0.b0.a1.d2 * 2**172]
            le+=[id.c0.b1.a0.d0 + id.c0.b1.a0.d1 * 2**86 + id.c0.b1.a0.d2 * 2**172]
            le+=[id.c0.b1.a1.d0 + id.c0.b1.a1.d1 * 2**86 + id.c0.b1.a1.d2 * 2**172]
            le+=[id.c0.b2.a0.d0 + id.c0.b2.a0.d1 * 2**86 + id.c0.b2.a0.d2 * 2**172]
            le+=[id.c0.b2.a1.d0 + id.c0.b2.a1.d1 * 2**86 + id.c0.b2.a1.d2 * 2**172]
            le+=[id.c1.b0.a0.d0 + id.c1.b0.a0.d1 * 2**86 + id.c1.b0.a0.d2 * 2**172]
            le+=[id.c1.b0.a1.d0 + id.c1.b0.a1.d1 * 2**86 + id.c1.b0.a1.d2 * 2**172]
            le+=[id.c1.b1.a0.d0 + id.c1.b1.a0.d1 * 2**86 + id.c1.b1.a0.d2 * 2**172]
            le+=[id.c1.b1.a1.d0 + id.c1.b1.a1.d1 * 2**86 + id.c1.b1.a1.d2 * 2**172]
            le+=[id.c1.b2.a0.d0 + id.c1.b2.a0.d1 * 2**86 + id.c1.b2.a0.d2 * 2**172]
            le+=[id.c1.b2.a1.d0 + id.c1.b2.a1.d1 * 2**86 + id.c1.b2.a1.d2 * 2**172]
            [print('e'+str(i), np.base_repr(le[i],36)) for i in range(12)]
        def print_G2(id):
            x0 = id.x.a0.d0 + id.x.a0.d1 * 2**86 + id.x.a0.d2 * 2**172
            x1 = id.x.a1.d0 + id.x.a1.d1 * 2**86 + id.x.a1.d2 * 2**172
            y0 = id.y.a0.d0 + id.y.a0.d1 * 2**86 + id.y.a0.d2 * 2**172
            y1 = id.y.a1.d0 + id.y.a1.d1 * 2**86 + id.y.a1.d2 * 2**172
            print(f"X={np.base_repr(x0,36).lower()} + {np.base_repr(x1,36).lower()}*u")
            print(f"Y={np.base_repr(y0,36).lower()} + {np.base_repr(y1,36).lower()}*u")
    %}

    let (local Qacc: G2Point**) = alloc();
    let (local Q_neg: G2Point**) = alloc();
    let (local yInv: BigInt3**) = alloc();
    let (local xOverY: BigInt3**) = alloc();

    with Qacc, Q_neg, yInv, xOverY {
        initialize_arrays_and_constants(P, Q, n_points - 1);
    }

    let offset = n_points;
    // Compute ∏ᵢ { fᵢ_{6x₀+2,Q}(P) }
    // i = 64, separately to avoid an E12 Square
    // (Square(res) = 1² = 1)

    // k = 0, separately to avoid MulBy034 (res × ℓ)
    // (assign line to res)
    let (new_Q0: G2Point*, l1: E4*) = g2.double_step(Qacc[0]);
    assert Qacc[offset + 0] = new_Q0;
    let res_C1B0 = e2.mul_by_element(xOverY[0], l1.r0);
    let res_C1B1 = e2.mul_by_element(yInv[0], l1.r1);
    let zero_E2 = e2.zero();
    let one_E6 = e6.one();
    // Init square trick :
    let n_squares = 0;
    let (verify_square_array: VerifyPolySquare**) = alloc();
    // Init 034 trick :
    let n_034 = 0;
    let (verify_034_array: VerifyMul034**) = alloc();
    let n_034034 = 0;
    let (verify_034034_array: VerifyMul034034**) = alloc();

    with Qacc, Q_neg, xOverY, yInv, n_squares, verify_square_array, n_034, verify_034_array, n_034034, verify_034034_array {
        local res: E12*;

        if (is_n_sup_eq_2 != 0) {
            assert [range_check_ptr] = n_points - 2;
            tempvar range_check_ptr = range_check_ptr + 1;
            // k = 1, separately to avoid MulBy034 (res × ℓ)
            // (res is also a line at this point, so we use Mul034By034 ℓ × ℓ)

            let (new_Q1: G2Point*, l1: E4*) = g2.double_step(Qacc[1]);
            assert Qacc[offset + 1] = new_Q1;

            let l1r0 = e2.mul_by_element(xOverY[1], l1.r0);
            let l1r1 = e2.mul_by_element(yInv[1], l1.r1);
            let res_t = mul034_034_trick(l1r0, l1r1, res_C1B0, res_C1B1);
            assert res = res_t;
            tempvar range_check_ptr = range_check_ptr;
            tempvar verify_034034_array = verify_034034_array;
            tempvar n_034034 = n_034034;
        } else {
            local res_C1: E6 = E6(res_C1B0, res_C1B1, zero_E2);
            local rest: E12 = E12(one_E6, &res_C1);
            assert res = &rest;
            tempvar range_check_ptr = range_check_ptr;
            tempvar verify_034034_array = verify_034034_array;
            tempvar n_034034 = n_034034;
        }
        let verify_034034_array = verify_034034_array;
        let n_034034 = n_034034;

        local res2: E12*;

        if (is_n_sup_eq_3 != 0) {
            assert [range_check_ptr] = n_points - 3;
            tempvar range_check_ptr = range_check_ptr + 1;
            // k = 2, separately to avoid MulBy034 (res × ℓ)
            // (res has a zero E2 element, so we use Mul01234By034)
            let (new_Q2: G2Point*, l1: E4*) = g2.double_step(Qacc[2]);
            assert Qacc[offset + 2] = new_Q2;

            // line evaluation at P[2]
            let l1r0 = e2.mul_by_element(xOverY[2], l1.r0);
            let l1r1 = e2.mul_by_element(yInv[2], l1.r1);
            // TODO : use Mul01234By034 instead of MulBy034
            let res = mul034_trick(res, l1r0, l1r1);
            let res = n_sup_3_loop(n_points - 1, offset, res);
            // }
            assert res2 = res;
            tempvar range_check_ptr = range_check_ptr;
            tempvar Qacc = Qacc;
            tempvar xOverY = xOverY;
            tempvar yInv = yInv;
            tempvar verify_034_array = verify_034_array;
            tempvar n_034 = n_034;
            tempvar verify_034034_array = verify_034034_array;
            tempvar n_034034 = n_034034;
        } else {
            assert res2 = res;
            tempvar range_check_ptr = range_check_ptr;
            tempvar Qacc = Qacc;
            tempvar xOverY = xOverY;
            tempvar yInv = yInv;
            tempvar verify_034_array = verify_034_array;
            tempvar n_034 = n_034;
            tempvar verify_034034_array = verify_034034_array;
            tempvar n_034034 = n_034034;
        }
        let Qacc = Qacc;
        let xOverY = xOverY;
        let yInv = yInv;
        let verify_034_array = verify_034_array;
        let n_034 = n_034;
        let verify_034034_array = verify_034034_array;
        let n_034034 = n_034034;

        // i = 63, separately to avoid a doubleStep
        // (at this point Qacc = 2Q, so 2Qacc-Q=3Q is equivalent to Qacc+Q=3Q
        // this means doubleAndAddStep is equivalent to addStep here)

        local res_i63: E12*;
        if (n_points == 1) {
            // Todo : use Square034 instead of Square
            let res = square_trick(res2);
            assert res_i63 = res;
            tempvar range_check_ptr = range_check_ptr;
            tempvar verify_square_array = verify_square_array;
            tempvar n_squares = n_squares;
            tempvar verify_034_array = verify_034_array;
            tempvar n_034 = n_034;
            tempvar verify_034034_array = verify_034034_array;
            tempvar n_034034 = n_034034;
        } else {
            let res = square_trick(res2);
            assert res_i63 = res;
            tempvar range_check_ptr = range_check_ptr;
            tempvar verify_square_array = verify_square_array;
            tempvar n_squares = n_squares;
            tempvar verify_034_array = verify_034_array;
            tempvar n_034 = n_034;
            tempvar verify_034034_array = verify_034034_array;
            tempvar n_034034 = n_034034;
        }
        let verify_square_array = verify_square_array;
        let n_squares = n_squares;
        let verify_034_array = verify_034_array;
        let n_034 = n_034;
        let verify_034034_array = verify_034034_array;
        let n_034034 = n_034034;
        let (_, n_is_odd) = felt_divmod(n_points, 2);

        let res = i63_loop(0, n_points, offset, res_i63);
    }
    let offset = offset + n_points;

    with Qacc, Q_neg, xOverY, yInv, n_is_odd, verify_square_array, n_squares, verify_034_array, n_034, verify_034034_array, n_034034 {
        let (res, offset) = multi_miller_loop_inner(n_points, 62, offset, res);

        let res = final_loop(0, n_points, offset, res);
        %{ print("Computing random point ... ") %}
        let z_squares = get_random_point_from_square_ops(n_squares - 1, 0);
        let z_034 = get_random_point_from_mul034_ops(n_034 - 1, 0);
        let z_034034 = get_random_point_from_mul034034_ops(n_034034 - 1, 0);
        let (z_felt) = poseidon_hash(z_squares, z_034);
        let (z_felt) = poseidon_hash(z_felt, z_034034);
        let (local z: BigInt3) = felt_to_bigint3(z_felt);
        %{ print("Verifying commitment ... ") %}
        verify_extension_tricks(n_squares - 1, &z);
    }
    %{
        print("RESFINALMILLERLOOP:")
        print_e12(ids.res)
    %}
    return res;
}
func final_loop{
    range_check_ptr,
    Qacc: G2Point**,
    xOverY: BigInt3**,
    yInv: BigInt3**,
    verify_034034_array: VerifyMul034034**,
    n_034034: felt,
}(k: felt, n_points: felt, offset: felt, res: E12*) -> E12* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    if (k == n_points) {
        return res;
    } else {
        let q1x = e2.conjugate(Qacc[k].x);
        let q1y = e2.conjugate(Qacc[k].y);
        let q1x = e2.mul_by_non_residue_1_power_2(q1x);
        let q1y = e2.mul_by_non_residue_1_power_3(q1y);
        local Q1: G2Point = G2Point(q1x, q1y);

        let q2x = e2.mul_by_non_residue_2_power_2(Qacc[k].x);
        let q2y = e2.mul_by_non_residue_2_power_3(Qacc[k].y);
        let q2y = e2.neg(q2y);
        local Q2: G2Point = G2Point(q2x, q2y);

        let (new_Q: G2Point*, l1: E4*) = g2.add_step(Qacc[offset + k], &Q1);
        assert Qacc[offset + n_points + k] = new_Q;

        let l1r0 = e2.mul_by_element(xOverY[k], l1.r0);
        let l1r1 = e2.mul_by_element(yInv[k], l1.r1);

        let l2 = g2.line_compute(Qacc[offset + n_points + k], &Q2);
        let l2r0 = e2.mul_by_element(xOverY[k], l2.r0);
        let l2r1 = e2.mul_by_element(yInv[k], l2.r1);

        let prod_lines = mul034_034_trick(l1r0, l1r1, l2r0, l2r1);
        let res = e12.mul_by_01234(res, prod_lines);

        return final_loop(k + 1, n_points, offset, res);
    }
}
func n_sup_3_loop{
    range_check_ptr,
    Qacc: G2Point**,
    xOverY: BigInt3**,
    yInv: BigInt3**,
    verify_034_array: VerifyMul034**,
    n_034: felt,
}(k: felt, offset: felt, res: E12*) -> E12* {
    alloc_locals;
    // %{ print(f"init_loop {ids.k}") %}
    if (k == 2) {
        return res;
    } else {
        let (new_Q: G2Point*, l1: E4*) = g2.double_step(Qacc[k]);
        assert Qacc[offset + k] = new_Q;
        let l1r0 = e2.mul_by_element(xOverY[k], l1.r0);
        let l1r1 = e2.mul_by_element(yInv[k], l1.r1);
        let res = mul034_trick(res, l1r0, l1r1);
        return n_sup_3_loop(k - 1, offset, res);
    }
}

func multi_miller_loop_inner{
    range_check_ptr,
    Qacc: G2Point**,
    Q_neg: G2Point**,
    xOverY: BigInt3**,
    yInv: BigInt3**,
    n_is_odd: felt,
    verify_square_array: VerifyPolySquare**,
    n_squares: felt,
    verify_034_array: VerifyMul034**,
    n_034: felt,
    verify_034034_array: VerifyMul034034**,
    n_034034: felt,
}(n_points: felt, bit_index: felt, offset: felt, res: E12*) -> (res: E12*, offset: felt) {
    alloc_locals;
    let res = square_trick(res);

    if (bit_index == 0) {
        // we know get_NAF_digit(0) = 0
        let (lines_r0: E2**) = alloc();
        let (lines_r1: E2**) = alloc();
        %{ print(f"index = {ids.bit_index}, bit = {ids.bit_index}, offset = {ids.offset}") %}

        double_step_loop(0, n_points, offset, lines_r0, lines_r1);
        tempvar offset = offset + n_points;
        if (n_is_odd != 0) {
            let res = mul034_trick(res, lines_r0[n_points - 1], lines_r1[n_points - 1]);
            let res = mul_lines_two_by_two(1, n_points, lines_r0, lines_r1, res);
            return (res, offset);
        } else {
            let res = mul_lines_two_by_two(1, n_points, lines_r0, lines_r1, res);
            return (res, offset);
        }
    } else {
        let bit = get_NAF_digit(bit_index);
        %{ print(f"index = {ids.bit_index}, bit = {ids.bit}, offset = {ids.offset}") %}
        if (bit == 0) {
            let (lines_r0: E2**) = alloc();
            let (lines_r1: E2**) = alloc();

            double_step_loop(0, n_points, offset, lines_r0, lines_r1);
            tempvar offset = offset + n_points;

            if (n_is_odd != 0) {
                let res = mul034_trick(res, lines_r0[n_points - 1], lines_r1[n_points - 1]);
                let res = mul_lines_two_by_two(1, n_points, lines_r0, lines_r1, res);
                return multi_miller_loop_inner(n_points, bit_index - 1, offset, res);
            } else {
                let res = mul_lines_two_by_two(1, n_points, lines_r0, lines_r1, res);
                return multi_miller_loop_inner(n_points, bit_index - 1, offset, res);
            }
        } else {
            if (bit == 1) {
                let res = bit_1_loop(0, n_points, offset, res);
                tempvar offset = offset + n_points;
                return multi_miller_loop_inner(n_points, bit_index - 1, offset, res);
            } else {
                // (bit == 2)
                let res = bit_2_loop(0, n_points, offset, res);
                let offset = offset + n_points;
                return multi_miller_loop_inner(n_points, bit_index - 1, offset, res);
            }
        }
    }
}

func bit_1_loop{
    range_check_ptr,
    Qacc: G2Point**,
    xOverY: BigInt3**,
    yInv: BigInt3**,
    verify_034034_array: VerifyMul034034**,
    n_034034: felt,
}(k: felt, n_points: felt, offset: felt, res: E12*) -> E12* {
    alloc_locals;
    if (k == n_points) {
        return res;
    } else {
        let (new_Q: G2Point*, l1: E4*, l2: E4*) = g2.double_and_add_step(Qacc[offset + k], Qacc[k]);
        assert Qacc[offset + n_points + k] = new_Q;
        let l1r0 = e2.mul_by_element(xOverY[k], l1.r0);
        let l1r1 = e2.mul_by_element(yInv[k], l1.r1);

        let l2r0 = e2.mul_by_element(xOverY[k], l2.r0);
        let l2r1 = e2.mul_by_element(yInv[k], l2.r1);

        let prod_lines = mul034_034_trick(l1r0, l1r1, l2r0, l2r1);

        let res = e12.mul_by_01234(res, prod_lines);
        let res = bit_1_loop(k + 1, n_points, offset, res);
        return res;
    }
}

func bit_2_loop{
    range_check_ptr,
    Qacc: G2Point**,
    Q_neg: G2Point**,
    xOverY: BigInt3**,
    yInv: BigInt3**,
    verify_034034_array: VerifyMul034034**,
    n_034034: felt,
}(k: felt, n_points: felt, offset: felt, res: E12*) -> E12* {
    alloc_locals;
    if (k == n_points) {
        return res;
    } else {
        let (new_Q: G2Point*, l1: E4*, l2: E4*) = g2.double_and_add_step(
            Qacc[offset + k], Q_neg[k]
        );
        assert Qacc[offset + n_points + k] = new_Q;
        let l1r0 = e2.mul_by_element(xOverY[k], l1.r0);
        let l1r1 = e2.mul_by_element(yInv[k], l1.r1);

        let l2r0 = e2.mul_by_element(xOverY[k], l2.r0);
        let l2r1 = e2.mul_by_element(yInv[k], l2.r1);

        let prod_lines = mul034_034_trick(l1r0, l1r1, l2r0, l2r1);

        let res = e12.mul_by_01234(res, prod_lines);
        let res = bit_2_loop(k + 1, n_points, offset, res);
        return res;
    }
}
func i63_loop{
    range_check_ptr,
    Qacc: G2Point**,
    Q_neg: G2Point**,
    xOverY: BigInt3**,
    yInv: BigInt3**,
    verify_034034_array: VerifyMul034034**,
    n_034034: felt,
}(k: felt, n_points: felt, offset: felt, res: E12*) -> E12* {
    alloc_locals;
    if (k == n_points) {
        return res;
    } else {
        // l2 the line passing Qacc[k] and -Q
        let l2: E4* = g2.line_compute(Qacc[offset + k], Q_neg[k]);
        // line evaluation at P[k]

        let l2_r0 = e2.mul_by_element(xOverY[k], l2.r0);
        let l2_r1 = e2.mul_by_element(yInv[k], l2.r1);
        // Qacc[k] ← Qacc[k]+Q[k] and
        // l1 the line ℓ passing Qacc[k] and Q[k]

        let (new_Q: G2Point*, l1: E4*) = g2.add_step(Qacc[offset + k], Qacc[k]);
        assert Qacc[offset + n_points + k] = new_Q;

        // line evaluation at P[k]
        let l1_r0 = e2.mul_by_element(xOverY[k], l1.r0);
        let l1_r1 = e2.mul_by_element(yInv[k], l1.r1);

        // l*l
        let prod_lines = mul034_034_trick(l1_r0, l1_r1, l2_r0, l2_r1);

        // res = res * l*l
        let res = e12.mul_by_01234(res, prod_lines);

        return i63_loop(k + 1, n_points, offset, res);
    }
}
// Double step Qacc[offset+k] for k in [0, n_points)
// Store the doubled point in Qacc[offset+n_points+k]
// Store the line evaluation at P[k] in lines_r0[k] and lines_r1[k]
func double_step_loop{range_check_ptr, Qacc: G2Point**, xOverY: BigInt3**, yInv: BigInt3**}(
    k: felt, n_points: felt, offset: felt, lines_r0: E2**, lines_r1: E2**
) {
    alloc_locals;
    if (k == n_points) {
        return ();
    } else {
        let (new_Q: G2Point*, l1: E4*) = g2.double_step(Qacc[offset + k]);
        assert Qacc[offset + n_points + k] = new_Q;
        let l1r0 = e2.mul_by_element(xOverY[k], l1.r0);
        let l1r1 = e2.mul_by_element(yInv[k], l1.r1);
        assert lines_r0[k] = l1r0;
        assert lines_r1[k] = l1r1;
        return double_step_loop(k + 1, n_points, offset, lines_r0, lines_r1);
    }
}

func mul_lines_two_by_two{range_check_ptr, verify_034034_array: VerifyMul034034**, n_034034: felt}(
    k: felt, n: felt, lines_r0: E2**, lines_r1: E2**, res: E12*
) -> E12* {
    alloc_locals;
    // %{ print(f"Mul2b2: k={ids.k}, n={ids.n}") %}
    if (k == n) {
        return res;
    } else {
        if (k == n + 1) {
            return res;
        } else {
            let prod_lines = mul034_034_trick(
                lines_r0[k], lines_r1[k], lines_r0[k - 1], lines_r1[k - 1]
            );
            let res = e12.mul_by_01234(res, prod_lines);
            return mul_lines_two_by_two(k + 2, n, lines_r0, lines_r1, res);
        }
    }
}
func initialize_arrays_and_constants{
    range_check_ptr, Qacc: G2Point**, Q_neg: G2Point**, yInv: BigInt3**, xOverY: BigInt3**
}(P: G1Point**, Q: G2Point**, n: felt) {
    alloc_locals;
    if (n == 0) {
        let neg_Q = g2.neg(Q[n]);
        let y_inv = fq_bigint3.inv(P[n].y);
        let x_over_y = fq_bigint3.mul(P[n].x, y_inv);
        let x_over_y = fq_bigint3.neg(x_over_y);
        assert Qacc[n] = Q[n];
        assert Q_neg[n] = neg_Q;
        assert yInv[n] = y_inv;
        assert xOverY[n] = x_over_y;
        return ();
    } else {
        let neg_Q = g2.neg(Q[n]);
        let y_inv = fq_bigint3.inv(P[n].y);
        let x_over_y = fq_bigint3.mul(P[n].x, y_inv);
        let x_over_y = fq_bigint3.neg(x_over_y);
        assert Qacc[n] = Q[n];
        assert Q_neg[n] = neg_Q;
        assert yInv[n] = y_inv;
        assert xOverY[n] = x_over_y;
        return initialize_arrays_and_constants(P, Q, n - 1);
    }
}

func final_exponentiation{range_check_ptr}(z: E12*, unsafe: felt) -> E12* {
    alloc_locals;
    let one: E6* = e6.one();

    local z_c1: E6*;
    local selector1: felt;

    if (unsafe != 0) {
        assert z_c1 = z.c1;
    } else {
        let z_c1_is_zero = e6.is_zero(z.c1);
        assert selector1 = z_c1_is_zero;
        if (z_c1_is_zero != 0) {
            assert z_c1 = one;
        } else {
            assert z_c1 = z.c1;
        }
    }
    // Torus compression absorbed:
    // Raising e to (p⁶-1) is
    // e^(p⁶) / e = (e.C0 - w*e.C1) / (e.C0 + w*e.C1)
    //            = (-e.C0/e.C1 + w) / (-e.C0/e.C1 - w)
    // So the fraction -e.C0/e.C1 is already in the torus.
    // This absorbs the torus compression in the easy part.

    // let c_den = e6.inv(z_c1);
    let c_num = e6.neg(z.c0);
    let c = e6.div(c_num, z_c1);

    let t0 = e6.frobenius_square_torus(c);
    let c = e6.mul_torus(t0, c);

    // 2. Hard part (up to permutation)
    // 2x₀(6x₀²+3x₀+1)(p⁴-p²+1)/r
    // Duquesne and Ghammam
    // https://eprint.iacr.org/2015/192.pdf
    // Fuentes et al. (alg. 6)
    // performed in torus compressed form

    let t0 = e6.expt_torus(c);
    let t0 = e6.inverse_torus(t0);
    let t0 = e6.square_torus(t0);
    let t1 = e6.square_torus(t0);
    let t1 = e6.mul_torus(t0, t1);
    let t2 = e6.expt_torus(t1);
    let t2 = e6.inverse_torus(t2);
    let t3 = e6.inverse_torus(t1);
    let t1 = e6.mul_torus(t2, t3);
    let t3 = e6.square_torus(t2);
    let t4 = e6.expt_torus(t3);
    let t4 = e6.mul_torus(t1, t4);
    let t3 = e6.mul_torus(t0, t4);
    let t0 = e6.mul_torus(t2, t4);
    let t0 = e6.mul_torus(c, t0);
    let t2 = e6.frobenius_torus(t3);
    let t0 = e6.mul_torus(t2, t0);
    let t2 = e6.frobenius_square_torus(t4);
    let t0 = e6.mul_torus(t2, t0);
    let t2 = e6.inverse_torus(c);
    let t2 = e6.mul_torus(t2, t3);
    let t2 = e6.frobenius_cube_torus(t2);

    if (unsafe != 0) {
        let rest = e6.mul_torus(t2, t0);
        let res = decompress_torus(rest);
        return res;
    } else {
        let _sum = e6.add(t0, t2);
        let is_zero = e6.is_zero(_sum);
        local t0t: E6*;
        if (is_zero != 0) {
            assert t0t = one;
        } else {
            assert t0t = t0;
        }

        if (selector1 == 0) {
            if (is_zero == 0) {
                let rest = e6.mul_torus(t2, t0t);
                let res = decompress_torus(rest);
                return res;
            } else {
                let res = e12.one();
                return res;
            }
        } else {
            let res = e12.one();
            return res;
        }
    }
}

func decompress_torus{range_check_ptr}(x: E6*) -> E12* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let one_e6 = e6.one();
    let minus_one_e6 = e6.neg(one_e6);
    local num: E12 = E12(x, one_e6);
    local den: E12 = E12(x, minus_one_e6);

    let res = e12.inverse(&den);
    let res = e12.mul(&num, res);
    return res;
}

// Canonical signed digit decomposition (Non-Adjacent form) of 6x₀+2 = 29793968203157093288  little endian
func get_NAF_digit(index: felt) -> felt {
    let (data) = get_label_location(bits);
    let bit_array = cast(data, felt*);
    return bit_array[index];

    bits:
    dw 0;
    dw 0;
    dw 0;
    dw 1;
    dw 0;
    dw 1;
    dw 0;
    dw 2;
    dw 0;
    dw 0;
    dw 2;
    dw 0;
    dw 0;
    dw 0;
    dw 1;
    dw 0;
    dw 0;
    dw 2;
    dw 0;
    dw 2;
    dw 0;
    dw 0;
    dw 0;
    dw 1;
    dw 0;
    dw 2;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 2;
    dw 0;
    dw 0;
    dw 1;
    dw 0;
    dw 2;
    dw 0;
    dw 0;
    dw 1;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 2;
    dw 0;
    dw 0;
    dw 2;
    dw 0;
    dw 1;
    dw 0;
    dw 2;
    dw 0;
    dw 0;
    dw 0;
    dw 2;  // i = 55
    dw 0;  // i = 56
    dw 2;  // i = 57
    dw 0;  // i = 58
    dw 0;  // i = 59
    dw 0;  // i = 60
    dw 1;  // i = 61
    dw 0;  // i = 62
    dw 2;  // i = 63
    dw 0;  // i = 64
    dw 1;  // i = 65
}
