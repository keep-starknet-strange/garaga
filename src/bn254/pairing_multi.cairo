from starkware.cairo.common.registers import get_label_location
from starkware.cairo.common.alloc import alloc
from src.bn254.g1 import G1Point
from src.bn254.g2 import G2Point, g2
from src.bn254.towers.e12 import E12, e12
from src.bn254.towers.e2 import E2, e2
from src.bn254.towers.e6 import E6, e6
from src.bn254.fq import fq_bigint3

const ate_loop_count = 29793968203157093288;
const log_ate_loop_count = 63;
const naf_count = 66;

func pair{range_check_ptr}(P: G1Point**, Q: G2Point**, n: felt) -> E12* {
    alloc_locals;
    let f = miller_loop(P, Q, n);
    let f = final_exponentiation(f);
    return f;
}

struct E4 {
    R0: E2*,
    R1: E2*,
}
// precompute y[i] = 1/P[i].y, xoy[i] = P[i].x/P[i].y
// populates in BigInt3 arrays
func precompute_line_coeffs{range_check_ptr}(
    P: G1Point**, y_inv: BigInt3**, x_over_y: BigInt3**, final_index: felt, index: felt
) {
    alloc_locals;
    if (index == final_index) {
        let yinv_val = fq_bigint3.inv(P[index].y);
        let x_over_y_val = fq_bigint3.mul(P[index].x, yinv_val);
        assert y_inv[index] = yinv_val;
        assert x_over_y[index] = x_over_y_val;
        return ();
    } else {
        let yinv_val = fq_bigint3.inv(P[index].y);
        let x_over_y_val = fq_bigint3.mul(P[index].x, yinv_val);
        assert y_inv[index] = yinv_val;
        assert x_over_y[index] = x_over_y_val;
        return precompute_line_coeffs(P, y_inv, x_over_y, final_index, index + 1);
    }
}

func accumulate_extra_Q{
    range_check_ptr, y_inv: BigInt3**, x_over_y: BigInt3**, n: felt, miller_loop_index: felt
}(res: E12*, q_acc: G2Point**, k: felt) -> E12* {
    alloc_locals;
    if (k == n) {
        return res;
    } else {
        let (l1: E4*) = double_step(q_acc, index=k);
        let l1_r0 = e2.mul_by_element(x_over_y[k], l1.r0);
        let l1_r1 = e2.mul_by_element(y_inv[k], l1.r1);
        let update_res = e12.mul_by_034(res, l1_r0, l1_r1);
        return accumulate_extra_Q(update_res, q_acc, k + 1);
    }
}
// Q is an array of G2Point*, of size n. Q[n] = double_step(Q[0]), etc...
func miller_loop{range_check_ptr}(P: G1Point**, Q: G2Point**, n: felt) -> E12* {
    alloc_locals;
    // todo : Assert P, Q not 0 (point at infinity)
    %{
        import numpy as np
        def print_e6(id):
            le=[]
            le+=[id.b0.a0.d0 + id.b0.a0.d1 * 2**86 + id.b0.a0.d2 * 2**172]
            le+=[id.b0.a1.d0 + id.b0.a1.d1 * 2**86 + id.b0.a1.d2 * 2**172]
            le+=[id.b1.a0.d0 + id.b1.a0.d1 * 2**86 + id.b1.a0.d2 * 2**172]
            le+=[id.b1.a1.d0 + id.b1.a1.d1 * 2**86 + id.b1.a1.d2 * 2**172]
            le+=[id.b2.a0.d0 + id.b2.a0.d1 * 2**86 + id.b2.a0.d2 * 2**172]
            le+=[id.b2.a1.d0 + id.b2.a1.d1 * 2**86 + id.b2.a1.d2 * 2**172]
            [print('e'+str(i), np.base_repr(le[i],36)) for i in range(6)]
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
    // local Q_original: G2Point = Q;
    // let Q_neg = g2.neg(Q);
    let result = e12.one();
    let miller_loop_index = 0;
    // We will store n*64 G2 points inside.
    // let (q_acc: G2Point**) = alloc();  // should already be in inputs as array.Need to keep n tracked.

    // These two will remain constant and of size n.
    let (local y_inv: BigInt3**) = alloc();
    let (local x_over_y: BigInt3**) = alloc();
    precompute_line_coeffs(P, y_inv, x_over_y, n - 1, 0);

    // First point (k=0)
    let (l1: E4*) = double_step(pt=Q, index=0, n=n);
    let res_c1b0 = e2.mul_by_element(x_over_y[0], l1.r0);
    let res_c1b1 = e2.mul_by_element(y_inv[0], l1.r1);

    let is_n_sup_eq_2 = is_le(2, n);
    if (is_n_sup_eq_2 == 1) {
        // Second point (k=1)
        let (l1: E4*) = double_step(pt=Q, index=1, n=n);

        let l1_r0 = e2.mul_by_element(x_over_y[1], l1.r0);
        let l1_r1 = e2.mul_by_element(y_inv[1], l1.r1);

        let res = e12.mul_034_by_034(l1_r0, l1_r1, res_c1b0, res_c1b1);

        let is_n_sup_eq_3 = is_le(3, n);
        if (is_n_sup_eq_3 == 1) {
            // Third till n point (k=2..(n-1))
            with y_inv, x_over_y, n {
                let res = accumulate_extra_Q(res=res, q_acc=Q, k=2);
            }
        }
    }

    %{
        print("LINE0")
        print_e6(ids.fline_eval)
        print("RES0:")
        print_e12(ids.result)
    %}
    with P, Q_original, Q_neg {
        let (local final_Q: G2Point, local result: E12*) = miller_loop_inner(
            Q=Q, result=result, index=63
        );
    }

    let q1x = e2.conjugate(Q_original.x);
    let q1y = e2.conjugate(Q_original.y);
    let q1x = e2.mul_by_non_residue_1_power_2(q1x);
    let q1y = e2.mul_by_non_residue_1_power_3(q1y);
    local Q1: G2Point = G2Point(q1x, q1y);

    let q2x = e2.mul_by_non_residue_2_power_2(Q_original.x);
    let q2y = e2.mul_by_non_residue_2_power_3(Q_original.y);
    let q2y = e2.neg(q2y);
    local Q2: G2Point = G2Point(q2x, q2y);

    let (final_Q2: G2Point, l0: E6) = g2.add_step(final_Q, Q1, P);

    let (Q: G2Point, local l: E6) = g2.add_step(final_Q2, Q2, P);

    let tmp = e12.mul_034_by_034(l.b0, l.b1, l.b2, l0.b0, l0.b1, l0.b2);
    let result = e12.mul(result, tmp);
    %{
        print("LINEFINAL1")
        print_e6(ids.l)
        print("LINEFINAL2")
        print_e6(ids.l0)
        print("RESFINALMILLERLOOP:")
        print_e12(ids.result)
    %}
    return result;
}

func double_step{range_check_ptr}(pt: G2Point**, index: felt, n: felt) -> (line: E4*) {
    alloc_locals;
    let lambda: E2* = g2.compute_doubling_slope_with_hints([p[index]]);
    let D = e2.double(pt[index].x);
    let nx = e2.square(lambda);
    let nx = e2.sub(nx, D);
    let E = e2.mul(lambda, pt[index].x);
    let E = e2.sub(E, pt[index].y);
    let ny = e2.mul(lambda, nx);
    let ny = e2.sub(E, ny);

    let l_r0 = e2.neg(lambda);
    let l_r1 = e2.mul(lambda, p[index].x);
    let l_r1 = e2.sub(l_r1, p[index].y);

    tempvar res: G2Point* = new G2Point(nx, ny);
    assert pt[index + n] = res;
    tempvar line = new E4(l_r0, l_r1);
    return (line,);
}

func double_and_add_step{range_check_ptr}(p1: G2Point*, p2: G2Point*) -> (
    pt: G2Point, line_1: E4*, line_2: E4*
) {
    alloc_locals;
    let lambda_1: E2* = g2.compute_slope([p1], [p2]);
    let x3 = e2.square(lambda_1);
    let x3 = e2.sub(nx, pt1.x);
    let x3 = e2.sub(nx, pt2.x);

    let l1_r0 = e2.neg(lambda_1);
    let l1_r1 = e2.mul(lambda_1, p1.x);
    let l1_r1 = e2.sub(l1_r1, p1.y);

    let n = e2.double(p1.y);
    let d = e2.sub(x3, p1.x);
    let d_inv = e2.inv(d);
    let lambda_2 = e2.mul(n, d_inv);
    let lambda_2 = e2.add(lambda_2, lambda_1);
    let lambda_2 = e2.neg(lambda_2);

    let x4 = e2.square(lambda_2);
    let x4 = e2.sub(x4, p1.x);
    let x4 = e2.sub(x4, x3);

    let y4 = e2.sub(p1.x, x4);
    let y4 = e2.mul(lambda_2, y4);
    let y4 = e2.sub(y4, p1.y);

    let l2_r0 = e2.neg(lambda_2);
    let l2_r1 = e2.mul(lambda_2, p1.x);
    let l2_r1 = e2.sub(l2_r1, p1.y);

    tempvar res: G2Point* = new G2Point(x4, y4);
    tempvar line_1: E4* = new E4(l1_r0, l1_r1);
    tempvar line_2: E4* = new E4(l2_r0, l2_r1);
    return (res, line_1, line_2);
}

func miller_loop_inner{range_check_ptr, y_inv: BigInt3**, x_over_y: BigInt3**}(
    Q: G2Point, result: E12*, index: felt
) -> (point: G2Point, res: E12*) {
    alloc_locals;
    if (index == 0) {
        // we know bit[0] = 0
        let bit = get_NAF_digit(index);
        assert bit = 0;
        let result_sq = e12.square(result);
        let (double_Q: G2Point, l: E6) = g2.double_step(Q, P);
        let res_final = e12.mul_by_034(result_sq, l.b0, l.b1, l.b2);

        %{ print_G2(ids.double_Q) %}

        return (double_Q, res_final);
    } else {
        let result_sq = e12.square(result);
        let (double_Q: G2Point, l: E6) = g2.double_step(Q, P);
        let bit = get_NAF_digit(index);
        %{ print('Mill Bit :', ids.bit) %}
        if (bit == 0) {
            let res_0 = e12.mul_by_034(result_sq, l.b0, l.b1, l.b2);
            %{ print_G2(ids.double_Q) %}
            return miller_loop_inner(double_Q, res_0, index - 1);
        } else {
            if (bit == 1) {
                let (new_Q_1: G2Point, l0_1: E6) = g2.add_step(double_Q, Q_original, P);
                let tmp_1 = e12.mul_034_by_034(l.b0, l.b1, l.b2, l0_1.b0, l0_1.b1, l0_1.b2);
                let res_1 = e12.mul(result_sq, tmp_1);
                %{ print_G2(ids.new_Q_1) %}

                return miller_loop_inner(new_Q_1, res_1, index - 1);
            } else {
                // (bit == 2)
                let (new_Q_2: G2Point, l0_2: E6) = g2.add_step(double_Q, Q_neg, P);
                let tmp_2 = e12.mul_034_by_034(l.b0, l.b1, l.b2, l0_2.b0, l0_2.b1, l0_2.b2);
                let res_2 = e12.mul(result_sq, tmp_2);
                %{ print_G2(ids.new_Q_2) %}

                return miller_loop_inner(new_Q_2, res_2, index - 1);
            }
        }
    }
}
func final_exponentiation{range_check_ptr}(z: E12*) -> E12* {
    alloc_locals;

    // Easy part
    // (p⁶-1)(p²+1)

    let result = z;
    let t0 = e12.conjugate(z);
    let result = e12.inverse(result);
    let t0 = e12.mul(t0, result);
    let result = e12.frobenius_square(t0);
    let result = e12.mul(result, t0);

    // Hard part (up to permutation)
    // 2x₀(6x₀²+3x₀+1)(p⁴-p²+1)/r
    // Duquesne and Ghammam
    // https://eprint.iacr.org/2015/192.pdf
    // Fuentes et al. variant (alg. 10)

    let t0 = e12.expt(result);
    let t0 = e12.conjugate(t0);
    let t0 = e12.cyclotomic_square(t0);
    let t2 = e12.expt(t0);
    let t2 = e12.conjugate(t2);
    let t1 = e12.cyclotomic_square(t2);
    let t2 = e12.mul(t2, t1);
    let t2 = e12.mul(t2, result);
    let t1 = e12.expt(t2);
    let t1 = e12.cyclotomic_square(t1);
    let t1 = e12.mul(t1, t2);
    let t1 = e12.conjugate(t1);
    let t3 = e12.conjugate(t1);
    let t1 = e12.cyclotomic_square(t0);
    let t1 = e12.mul(t1, result);
    let t1 = e12.conjugate(t1);
    let t1 = e12.mul(t1, t3);
    let t0 = e12.mul(t0, t1);
    let t2 = e12.mul(t2, t1);
    let t3 = e12.frobenius_square(t1);
    let t2 = e12.mul(t2, t3);
    let t3 = e12.conjugate(result);
    let t3 = e12.mul(t3, t0);
    let t1 = e12.frobenius_cube(t3);
    let t2 = e12.mul(t2, t1);
    let t1 = e12.frobenius(t0);
    let t1 = e12.mul(t1, t2);

    return t1;
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
    dw 1;
}
