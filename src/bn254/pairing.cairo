from starkware.cairo.common.registers import get_label_location
from src.bn254.g1 import G1Point
from src.bn254.g2 import G2Point, g2, E4
from src.bn254.towers.e12 import E12, e12
from src.bn254.towers.e2 import E2, e2
from src.bn254.towers.e6 import E6, e6
from src.bn254.fq import BigInt3, fq_bigint3

const ate_loop_count = 29793968203157093288;
const log_ate_loop_count = 63;
const naf_count = 66;

func pair{range_check_ptr}(P: G1Point*, Q: G2Point*) -> E12* {
    alloc_locals;
    let f = miller_loop(P, Q);
    let f = final_exponentiation(f);
    return f;
}

func miller_loop{range_check_ptr}(P: G1Point*, Q: G2Point*) -> E12* {
    alloc_locals;
    // todo : Assert P, Q not 0 (point at infinity)
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
    local Q_original: G2Point* = Q;
    let Q_neg = g2.neg(Q);
    let result = e12.one();
    let xp_bar = fq_bigint3.neg(P.x);
    let yp_prime = fq_bigint3.inv(P.y);
    let xp_prime = fq_bigint3.mul(xp_bar, yp_prime);

    let (Q: G2Point*, local fline_eval: E4*) = g2.double_step(Q);
    let l1r0 = e2.mul_by_element(xp_prime, fline_eval.r0);
    let l1r1 = e2.mul_by_element(yp_prime, fline_eval.r1);
    let result = e12.mul_by_034(result, l1r0, l1r1);

    with Q_original, Q_neg, xp_prime, yp_prime {
        let (local final_Q: G2Point*, local result: E12*) = miller_loop_inner(
            Q=Q, result=result, index=63
        );
    }

    let q1x = e2.conjugate(Q_original.x);
    let q1y = e2.conjugate(Q_original.y);
    let q1x = e2.mul_by_non_residue_1_power_2(q1x);
    let q1y = e2.mul_by_non_residue_1_power_3(q1y);
    tempvar Q1: G2Point* = new G2Point(q1x, q1y);
    %{
        print("Q1:")
        print_G2(ids.Q1)
    %}
    let q2x = e2.mul_by_non_residue_2_power_2(Q_original.x);
    let q2y = e2.mul_by_non_residue_2_power_3(Q_original.y);
    let q2y = e2.neg(q2y);
    tempvar Q2: G2Point* = new G2Point(q2x, q2y);
    %{
        print("Q2:")
        print_G2(ids.Q2)
    %}
    let (final_Q2: G2Point*, l0: E4*) = g2.add_step(final_Q, Q1);
    let l0r0 = e2.mul_by_element(xp_prime, l0.r0);
    let l0r1 = e2.mul_by_element(yp_prime, l0.r1);

    let (Q: G2Point*, local l: E4*) = g2.add_step(final_Q2, Q2);
    let lr0 = e2.mul_by_element(xp_prime, l.r0);
    let lr1 = e2.mul_by_element(yp_prime, l.r1);
    let tmp = e12.mul_034_by_034(lr0, lr1, l0r0, l0r1);
    let result = e12.mul(result, tmp);
    %{
        print("RESFINALMILLERLOOP:")
        print_e12(ids.result)
    %}
    return result;
}
func miller_loop_inner{
    range_check_ptr, Q_original: G2Point*, Q_neg: G2Point*, xp_prime: BigInt3*, yp_prime: BigInt3*
}(Q: G2Point*, result: E12*, index: felt) -> (point: G2Point*, res: E12*) {
    alloc_locals;
    %{
        import numpy as np
        print(ids.index, ' :')
        def print_G2(id):
            x0 = id.x.a0.d0 + id.x.a0.d1 * 2**86 + id.x.a0.d2 * 2**172
            x1 = id.x.a1.d0 + id.x.a1.d1 * 2**86 + id.x.a1.d2 * 2**172
            y0 = id.y.a0.d0 + id.y.a0.d1 * 2**86 + id.y.a0.d2 * 2**172
            y1 = id.y.a1.d0 + id.y.a1.d1 * 2**86 + id.y.a1.d2 * 2**172

            print(f"X={np.base_repr(x0,36).lower()} + {np.base_repr(x1,36).lower()}*u")
            print(f"Y={np.base_repr(y0,36).lower()} + {np.base_repr(y1,36).lower()}*u")
    %}
    if (index == 0) {
        // we know bit[0] = 0
        let bit = get_NAF_digit(index);
        assert bit = 0;
        let result_sq = e12.square(result);
        let (double_Q: G2Point*, l: E4*) = g2.double_step(Q);
        let lr0 = e2.mul_by_element(xp_prime, l.r0);
        let lr1 = e2.mul_by_element(yp_prime, l.r1);
        let res_final = e12.mul_by_034(result_sq, lr0, lr1);

        // %{ print_G2(ids.double_Q) %}

        return (double_Q, res_final);
    } else {
        let result_sq = e12.square(result);
        let (double_Q: G2Point*, l: E4*) = g2.double_step(Q);
        let lr0 = e2.mul_by_element(xp_prime, l.r0);
        let lr1 = e2.mul_by_element(yp_prime, l.r1);
        let bit = get_NAF_digit(index);

        if (bit == 0) {
            let res_0 = e12.mul_by_034(result_sq, lr0, lr1);
            // %{ print_G2(ids.double_Q) %}
            return miller_loop_inner(double_Q, res_0, index - 1);
        } else {
            if (bit == 1) {
                let (new_Q_1: G2Point*, l0_1: E4*) = g2.add_step(double_Q, Q_original);
                let l0_1r0 = e2.mul_by_element(xp_prime, l0_1.r0);
                let l0_1r1 = e2.mul_by_element(yp_prime, l0_1.r1);
                let tmp_1 = e12.mul_034_by_034(lr0, lr1, l0_1r0, l0_1r1);
                let res_1 = e12.mul(result_sq, tmp_1);
                // %{ print_G2(ids.new_Q_1) %}

                return miller_loop_inner(new_Q_1, res_1, index - 1);
            } else {
                // (bit == 2)
                let (new_Q_2: G2Point*, l0_2: E4*) = g2.add_step(double_Q, Q_neg);
                let l0_2r0 = e2.mul_by_element(xp_prime, l0_2.r0);
                let l0_2r1 = e2.mul_by_element(yp_prime, l0_2.r1);
                let tmp_2 = e12.mul_034_by_034(lr0, lr1, l0_2r0, l0_2r1);
                let res_2 = e12.mul(result_sq, tmp_2);
                // %{ print_G2(ids.new_Q_2) %}

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
