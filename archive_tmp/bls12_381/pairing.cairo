from starkware.cairo.common.registers import get_label_location
from src.bls12_381.g1 import G1Point
from src.bls12_381.g2 import G2Point, g2, E4
from src.bls12_381.towers.e12 import E12, e12
from src.bls12_381.towers.e2 import E2, e2
from src.bls12_381.towers.e6 import E6, e6
from src.bls12_381.nG2_lines import get_nQ_lines
from src.bls12_381.fq import BigInt4, fq_bigint4

const ate_loop_count = 15132376222941642752;
const log_ate_loop_count = 63;

func pair{range_check_ptr}(P: G1Point*, Q: G2Point*) -> E12* {
    alloc_locals;
    let f = miller_loop(P, Q);
    let f = final_exponentiation(f);
    return f;
}

func pair_fixed_G2{range_check_ptr}(P: G1Point*) -> E12* {
    alloc_locals;
    let f = miller_loop_fixed_G2(P);
    let f = final_exponentiation(f);
    return f;
}
func miller_loop{range_check_ptr}(P: G1Point*, Q: G2Point*) -> E12* {
    alloc_locals;
    // todo : Assert P, Q not 0 (point at infinity)
    %{
        import numpy as np
        def print_G2(id, index, bit):
            x0 = id.x.a0.d0 + id.x.a0.d1 * 2**96 + id.x.a0.d2 * 2**192 + id.x.a0.d3 * 2**288
            x1 = id.x.a1.d0 + id.x.a1.d1 * 2**96 + id.x.a1.d2 * 2**192 + id.x.a1.d3 * 2**288
            y0 = id.y.a0.d0 + id.y.a0.d1 * 2**96 + id.y.a0.d2 * 2**192 + id.y.a0.d3 * 2**288 
            y1 = id.y.a1.d0 + id.y.a1.d1 * 2**96 + id.y.a1.d2 * 2**192 + id.y.a1.d3 * 2**288 
            print(f"{index} || {bit} X={np.base_repr(x0,36).lower()} + {np.base_repr(x1,36).lower()}*u ")
            # print(f"Y={np.base_repr(y0,36).lower()} + {np.base_repr(y1,36).lower()}*u")
    %}

    local Q_original: G2Point* = Q;

    let result = e12.one();
    let xp_bar = fq_bigint4.neg(P.x);
    let yp_prime = fq_bigint4.inv(P.y);
    let xp_prime = fq_bigint4.mul(xp_bar, yp_prime);
    let (Q: G2Point*, l1: E4*) = g2.double_step(Q);
    let l1r0 = e2.mul_by_element(yp_prime, l1.r0);
    let l1r1 = e2.mul_by_element(xp_prime, l1.r1);

    let (Q: G2Point*, l2: E4*) = g2.add_step(Q, Q_original);
    let l2r0 = e2.mul_by_element(yp_prime, l2.r0);
    let l2r1 = e2.mul_by_element(xp_prime, l2.r1);

    let lines = e12.mul_014_by_014(l1r0, l1r1, l2r0, l2r1);
    let result = e12.mul(result, lines);

    with Q_original, xp_prime, yp_prime {
        let (local final_Q: G2Point*, local result: E12*) = miller_loop_inner(
            Q=Q, result=result, index=61
        );
    }

    return result;
}
func miller_loop_inner{
    range_check_ptr, Q_original: G2Point*, xp_prime: BigInt4*, yp_prime: BigInt4*
}(Q: G2Point*, result: E12*, index: felt) -> (point: G2Point*, res: E12*) {
    alloc_locals;
    if (index == -1) {
        // negative x₀
        let result = e12.conjugate(result);
        return (Q, result);
    }

    let result = e12.square(result);
    let (Q: G2Point*, l1: E4*) = g2.double_step(Q);
    let l1r0 = e2.mul_by_element(yp_prime, l1.r0);
    let l1r1 = e2.mul_by_element(xp_prime, l1.r1);
    let (local bit: felt) = get_loop_digit(index);
    if (bit == 0) {
        let result = e12.mul_by_014(result, l1r0, l1r1);
        %{ print_G2(ids.Q, ids.index, ids.bit) %}
        return miller_loop_inner(Q, result, index - 1);
    } else {
        let (Q: G2Point*, l2: E4*) = g2.add_step(Q, Q_original);
        let l2r0 = e2.mul_by_element(yp_prime, l2.r0);
        let l2r1 = e2.mul_by_element(xp_prime, l2.r1);
        let lines = e12.mul_014_by_014(l1r0, l1r1, l2r0, l2r1);
        let result = e12.mul(result, lines);
        %{ print_G2(ids.Q, ids.index, ids.bit) %}

        return miller_loop_inner(Q, result, index - 1);
    }
}
func miller_loop_fixed_G2{range_check_ptr}(P: G1Point*) -> E12* {
    alloc_locals;
    // todo : Assert P, Q not 0 (point at infinity)
    %{
        import numpy as np
        def print_G2(id, index, bit):
            x0 = id.x.a0.d0 + id.x.a0.d1 * 2**96 + id.x.a0.d2 * 2**192 + id.x.a0.d3 * 2**288
            x1 = id.x.a1.d0 + id.x.a1.d1 * 2**96 + id.x.a1.d2 * 2**192 + id.x.a1.d3 * 2**288
            y0 = id.y.a0.d0 + id.y.a0.d1 * 2**96 + id.y.a0.d2 * 2**192 + id.y.a0.d3 * 2**288 
            y1 = id.y.a1.d0 + id.y.a1.d1 * 2**96 + id.y.a1.d2 * 2**192 + id.y.a1.d3 * 2**288 
            print(f"{index} || {bit} X={np.base_repr(x0,36).lower()} + {np.base_repr(x1,36).lower()}*u ")
            # print(f"Y={np.base_repr(y0,36).lower()} + {np.base_repr(y1,36).lower()}*u")
    %}

    // local Q_original: G2Point* = Q;

    let result = e12.one();
    let xp_bar = fq_bigint4.neg(P.x);
    let yp_prime = fq_bigint4.inv(P.y);
    let xp_prime = fq_bigint4.mul(xp_bar, yp_prime);
    let (Q: G2Point*, local l1: E4*) = get_nQ_lines(0);
    let l1r0 = e2.mul_by_element(yp_prime, l1.r0);
    let l1r1 = e2.mul_by_element(xp_prime, l1.r1);

    let (Q: G2Point*, local l2: E4*) = get_nQ_lines(1);
    let l2r0 = e2.mul_by_element(yp_prime, l2.r0);
    let l2r1 = e2.mul_by_element(xp_prime, l2.r1);

    let lines = e12.mul_014_by_014(l1r0, l1r1, l2r0, l2r1);
    let result = e12.mul(result, lines);
    let n = 2;
    with n, xp_prime, yp_prime {
        let (local final_Q: G2Point*, local result: E12*) = miller_loop_fixed_G2_inner(
            Q=Q, result=result, index=61
        );
    }

    return result;
}
func miller_loop_fixed_G2_inner{range_check_ptr, n: felt, xp_prime: BigInt4*, yp_prime: BigInt4*}(
    Q: G2Point*, result: E12*, index: felt
) -> (point: G2Point*, res: E12*) {
    alloc_locals;
    if (index == -1) {
        let result = e12.conjugate(result);
        return (Q, result);
    }

    let result = e12.square(result);
    let (Q: G2Point*, l1: E4*) = get_nQ_lines(n);
    let l1r0 = e2.mul_by_element(yp_prime, l1.r0);
    let l1r1 = e2.mul_by_element(xp_prime, l1.r1);
    let n = n + 1;
    let (local bit: felt) = get_loop_digit(index);
    if (bit == 0) {
        let result = e12.mul_by_014(result, l1r0, l1r1);
        // %{ print_G2(ids.Q, ids.index, ids.bit) %}
        return miller_loop_fixed_G2_inner(Q, result, index - 1);
    } else {
        let (Q: G2Point*, l2: E4*) = get_nQ_lines(n);
        let l2r0 = e2.mul_by_element(yp_prime, l2.r0);
        let l2r1 = e2.mul_by_element(xp_prime, l2.r1);
        let n = n + 1;
        let lines = e12.mul_014_by_014(l1r0, l1r1, l2r0, l2r1);
        let result = e12.mul(result, lines);
        return miller_loop_fixed_G2_inner(Q, result, index - 1);
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
    let is_one = e12.is_one(result);
    if (is_one != 0) {
        %{ print(f"Easy part of the final exponentiation is 1, avoid computing the hard part.") %}
        let r = e12.one();
        return r;
    }
    // Hard part (up to permutation)
    // Daiki Hayashida, Kenichiro Hayasaka and Tadanori Teruya
    // https://eprint.iacr.org/2020/875.pdf
    let t0 = e12.cyclotomic_square(result);
    let t1 = e12.expt_half(t0);
    let t2 = e12.conjugate(result);
    let t1 = e12.mul(t1, t2);
    let t2 = e12.expt(t1);
    let t1 = e12.conjugate(t1);
    let t1 = e12.mul(t1, t2);
    let t2 = e12.expt(t1);
    let t1 = e12.frobenius(t1);
    let t1 = e12.mul(t1, t2);
    let result = e12.mul(result, t0);
    let t0 = e12.expt(t1);
    let t2 = e12.expt(t0);
    let t0 = e12.frobenius_square(t1);
    let t1 = e12.conjugate(t1);
    let t1 = e12.mul(t1, t2);
    let t1 = e12.mul(t1, t0);
    let result = e12.mul(result, t1);
    return result;
}

// Binary decomposition of -x₀ = 29793968203157093288  little endian
func get_loop_digit(index: felt) -> (b: felt) {
    let (data) = get_label_location(bits);
    let bit_array = cast(data, felt*);
    return (bit_array[index],);

    bits:
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 1;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 1;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 1;
    dw 0;
    dw 0;
    dw 1;
    dw 0;
    dw 1;
    dw 1;
}
