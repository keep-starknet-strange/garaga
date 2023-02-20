from starkware.cairo.common.registers import get_label_location
from src.bn254.g1 import G1Point
from src.bn254.g2 import G2Point, g2
from src.bn254.towers.e12 import E12, e12
from src.bn254.towers.e2 import E2, e2
from src.bn254.towers.e6 import E6, e6

const ate_loop_count = 29793968203157093288;
const log_ate_loop_count = 63;

func pair{range_check_ptr}(P: G1Point, Q: G2Point) -> E12 {
    alloc_locals;
    let f = miller_loop(P, Q);
    let f = final_exponentiation(f);
    return f;
}

func miller_loop{range_check_ptr}(P: G1Point, Q: G2Point) -> E12 {
    alloc_locals;
    // todo : Assert P, Q not 0 (point at infinity)
    let Q_original = Q;
    let Q_neg = g2.neg(Q);
    let result = e12.one();
    let (Q: G2Point, line_eval: E6) = g2.double_step(Q, P);
    let l_b0 = e2.mul_by_element(P.y, line_eval.b0);
    let l_b1 = e2.mul_by_element(P.x, line_eval.b1);
    let result = e12.mul_by_034(result, l_b0, l_b1, line_eval.b2);

    with P, Q_original, Q_neg {
        let result = miller_loop_inner(Q=Q, result=result, index=65);
    }

    let q1x = e2.conjugate(Q.x);
    let q1y = e2.conjugate(Q.y);
    let q1x = e2.mul_by_non_residue_1_power_2(q1x);
    let q1y = e2.mul_by_non_residue_1_power_3(q1y);
    let Q1 = G2Point(q1x, q1y);

    let q2x = e2.mul_by_non_residue_2_power_2(Q.x);
    let q2y = e2.mul_by_non_residue_2_power_3(Q.y);
    let q2y = e2.neg(q2y);
    let Q2 = G2Point(q2x, q2y);

    let (Q: G2Point, l0: E6) = g2.add_step(Q, Q1, P);
    let l0b0 = e2.mul_by_element(P.y, l0.b0);
    let l0b1 = e2.mul_by_element(P.x, l0.b1);

    let (Q: G2Point, l: E6) = g2.add_step(Q, Q2, P);
    let lb0 = e2.mul_by_element(P.y, l.b0);
    let lb1 = e2.mul_by_element(P.x, l.b1);

    let tmp = e12.mul_034_by_034(lb0, lb1, l.b2, l0b0, l0b1, l0.b2);
    let result = e12.mul(result, tmp);
    return result;
}
func miller_loop_inner{range_check_ptr, P: G1Point, Q_original: G2Point, Q_neg: G2Point}(
    Q: G2Point, result: E12, index: felt
) -> E12 {
    alloc_locals;

    if (index == 0) {
        return result;
    } else {
        let result_sq: E12 = e12.square(result);
        let (double_Q: G2Point, l: E6) = g2.double_step(Q, P);

        let lb0: E2 = e2.mul_by_element(P.y, l.b0);
        let lb1: E2 = e2.mul_by_element(P.x, l.b1);

        let bit = get_NAF_digit(index);
        if (bit == 0) {
            let res_0: E12 = e12.mul_by_034(result_sq, lb0, lb1, l.b2);
            return miller_loop_inner(double_Q, res_0, index - 1);
        } else {
            if (bit == 1) {
                let (new_Q_1: G2Point, l0_1: E6) = g2.add_step(double_Q, Q_original, P);
                let l0b0_1 = e2.mul_by_element(P.y, l0_1.b0);
                let l0b1_1 = e2.mul_by_element(P.x, l0_1.b1);
                let tmp_1 = e12.mul_034_by_034(l.b0, l.b1, l.b2, l0b0_1, l0b1_1, l0_1.b2);
                let res_1 = e12.mul(result_sq, tmp_1);
                return miller_loop_inner(new_Q_1, res_1, index - 1);
            } else {
                // (bit == 2)
                let (new_Q_2: G2Point, l0_2: E6) = g2.add_step(double_Q, Q_neg, P);
                let l0b0_2 = e2.mul_by_element(P.y, l0_2.b0);
                let l0b1_2 = e2.mul_by_element(P.x, l0_2.b1);
                let tmp_2 = e12.mul_034_by_034(l.b0, l.b1, l.b2, l0b0_2, l0b1_2, l0_2.b2);
                let res_2 = e12.mul(result_sq, tmp_2);
                return miller_loop_inner(new_Q_2, res_2, index - 1);
            }
        }
    }
}
func final_exponentiation{range_check_ptr}(z: E12) -> E12 {
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
