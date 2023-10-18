from starkware.cairo.common.registers import get_label_location, get_fp_and_pc
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_nn, unsigned_div_rem as felt_divmod, assert_nn_le
from src.bn254.g1 import G1Point, g1
from src.bn254.g2 import G2Point, g2, E4
from src.bn254.towers.e12 import (
    E12,
    e12,
    E12full,
    E11full,
    E9full,
    E7full,
    E12full034,
    E12full01234,
    square_trick,
    mul034_trick,
    mul034_034_trick,
    mul01234_trick,
    w_to_gnark_reduced,
    PolyAcc12,
    PolyAcc034,
    PolyAcc034034,
    get_powers_of_z11,
    ZPowers11,
)
from src.bn254.towers.e2 import E2, e2
from src.bn254.towers.e6 import (
    E6,
    E6full,
    E5full,
    e6,
    div_trick_e6,
    gnark_to_v,
    v_to_gnark_reduced as v_to_gnark,
    gnark_to_v_reduced,
    PolyAcc6,
    PolyAccSquare6,
    get_powers_of_z5,
    eval_E6_plus_v_unreduced,
    eval_E5,
    eval_unreduced_poly6,
)
from src.bn254.fq import (
    BigInt3,
    fq_bigint3,
    felt_to_bigint3,
    fq_zero,
    BASE,
    N_LIMBS,
    assert_reduced_felt,
    Uint256,
    UnreducedBigInt5,
    UnreducedBigInt3,
    bigint_mul,
    verify_zero5,
)

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, BitwiseBuiltin
from starkware.cairo.common.builtin_poseidon.poseidon import poseidon_hash

const ate_loop_count = 29793968203157093288;
const log_ate_loop_count = 63;
const naf_count = 66;

func pair{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, poseidon_ptr: PoseidonBuiltin*}(
    P: G1Point*, Q: G2Point*
) -> E12* {
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

func pair_multi{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, poseidon_ptr: PoseidonBuiltin*}(
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
func multi_miller_loop{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, poseidon_ptr: PoseidonBuiltin*
}(P: G1Point**, Q: G2Point**, n_points: felt) -> E12* {
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
        from tools.py.extension_trick import w_to_gnark
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
        def print_e12f_to_gnark(id, name):
            val = 12*[0]
            refs=[id.w0, id.w1, id.w2, id.w3, id.w4, id.w5, id.w6, id.w7, id.w8, id.w9, id.w10, id.w11]

            for i in range(ids.N_LIMBS):
                for k in range(12):
                    val[k]+=as_int(getattr(refs[k], 'd'+str(i)), PRIME) * ids.BASE**i

            print(name, w_to_gnark(val))
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
    let (new_Q0: G2Point*, l1: E12full034*) = g2.double_step(Qacc[0]);
    assert Qacc[offset + 0] = new_Q0;
    let res_w1 = fq_bigint3.mulf([xOverY[0]], l1.w1);
    let res_w3 = fq_bigint3.mulf([yInv[0]], l1.w3);
    let res_w7 = fq_bigint3.mulf([xOverY[0]], l1.w7);
    let res_w9 = fq_bigint3.mulf([yInv[0]], l1.w9);

    local res_init: E12full034 = E12full034(res_w1, res_w3, res_w7, res_w9);
    let zero_fq: BigInt3 = fq_zero();

    local poly_acc_sq_f: PolyAcc12 = PolyAcc12(
        xy=UnreducedBigInt3(0, 0, 0),
        q=E11full(
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
        ),
        r=E12full(
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
        ),
    );
    local poly_acc_034_f: PolyAcc034 = PolyAcc034(
        xy=UnreducedBigInt3(0, 0, 0),
        q=E9full(
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
        ),
        r=E12full(
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
        ),
    );
    local poly_acc_034034_f: PolyAcc034034 = PolyAcc034034(
        xy=UnreducedBigInt3(0, 0, 0),
        q=E7full(
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
        ),
        r=E12full01234(
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
        ),
    );
    local poly_acc_01234_f: PolyAcc12 = PolyAcc12(
        xy=UnreducedBigInt3(0, 0, 0),
        q=E11full(
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
        ),
        r=E12full(
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
        ),
    );
    let poly_acc_sq = &poly_acc_sq_f;
    let poly_acc_034 = &poly_acc_034_f;
    let poly_acc_034034 = &poly_acc_034034_f;
    let poly_acc_01234 = &poly_acc_01234_f;
    let continuable_hash = 'GaragaBN254MillerLoop';
    local Z: BigInt3;
    %{ ids.Z.d0, ids.Z.d1, ids.Z.d2 = 0x1, 0x2, 0x3 %}
    let z_pow1_11_ptr: ZPowers11* = get_powers_of_z11(Z);
    with Qacc, Q_neg, xOverY, yInv, continuable_hash, z_pow1_11_ptr, poly_acc_sq, poly_acc_034, poly_acc_034034, poly_acc_01234 {
        local res: E12full*;

        if (is_n_sup_eq_2 != 0) {
            assert [range_check_ptr] = n_points - 2;
            tempvar range_check_ptr = range_check_ptr + 1;
            // k = 1, separately to avoid MulBy034 (res × ℓ)
            // (res is also a line at this point, so we use Mul034By034 ℓ × ℓ)

            let (new_Q1: G2Point*, l1: E12full034*) = g2.double_step(Qacc[1]);
            assert Qacc[offset + 1] = new_Q1;
            let l1w1 = fq_bigint3.mulf([xOverY[1]], l1.w1);
            let l1w3 = fq_bigint3.mulf([yInv[1]], l1.w3);
            let l1w7 = fq_bigint3.mulf([xOverY[1]], l1.w7);
            let l1w9 = fq_bigint3.mulf([yInv[1]], l1.w9);
            local l1f: E12full034 = E12full034(l1w1, l1w3, l1w7, l1w9);
            let res_t01234 = mul034_034_trick(&l1f, &res_init);
            local res_t: E12full = E12full(
                res_t01234.w0,
                res_t01234.w1,
                res_t01234.w2,
                res_t01234.w3,
                res_t01234.w4,
                zero_fq,
                res_t01234.w6,
                res_t01234.w7,
                res_t01234.w8,
                res_t01234.w9,
                res_t01234.w10,
                res_t01234.w11,
            );

            assert res = &res_t;
            tempvar range_check_ptr = range_check_ptr;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar poseidon_ptr = poseidon_ptr;
            tempvar z_pow1_11_ptr = z_pow1_11_ptr;
            tempvar continuable_hash = continuable_hash;
            tempvar poly_acc_034034 = poly_acc_034034;
        } else {
            %{ print("Single miller loop!") %}
            // local res_C1: E6 = E6(res_C1B0, res_C1B1, zero_E2);
            // local rest: E12 = E12(one_E6, &res_C1);
            local rest: E12full = E12full(
                BigInt3(1, 0, 0),
                res_init.w1,
                zero_fq,
                res_init.w3,
                zero_fq,
                zero_fq,
                zero_fq,
                res_init.w7,
                zero_fq,
                res_init.w9,
                zero_fq,
                zero_fq,
            );
            assert res = &rest;
            tempvar range_check_ptr = range_check_ptr;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar poseidon_ptr = poseidon_ptr;
            tempvar z_pow1_11_ptr = z_pow1_11_ptr;
            tempvar continuable_hash = continuable_hash;
            tempvar poly_acc_034034 = poly_acc_034034;
        }
        let poly_acc_034034 = poly_acc_034034;
        let bitwise_ptr = bitwise_ptr;
        let poseidon_ptr = poseidon_ptr;
        let z_pow1_11_ptr = z_pow1_11_ptr;
        let continuable_hash = continuable_hash;

        %{ print_e12f_to_gnark(ids.res, "resInit") %}
        local res2: E12full*;

        if (is_n_sup_eq_3 != 0) {
            assert [range_check_ptr] = n_points - 3;
            tempvar range_check_ptr = range_check_ptr + 1;
            // k = 2, separately to avoid MulBy034 (res × ℓ)
            // (res has a zero E2 element, so we use Mul01234By034)
            let (new_Q2: G2Point*, l1: E12full034*) = g2.double_step(Qacc[2]);
            assert Qacc[offset + 2] = new_Q2;

            // line evaluation at P[2]
            let l1w1 = fq_bigint3.mulf([xOverY[2]], l1.w1);
            let l1w3 = fq_bigint3.mulf([yInv[2]], l1.w3);
            let l1w7 = fq_bigint3.mulf([xOverY[2]], l1.w7);
            let l1w9 = fq_bigint3.mulf([yInv[2]], l1.w9);
            local l1f: E12full034 = E12full034(l1w1, l1w3, l1w7, l1w9);
            let res = mul034_trick(res, &l1f);
            let res = n_sup_3_loop(n_points - 1, offset, res);

            assert res2 = res;
            tempvar range_check_ptr = range_check_ptr;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar poseidon_ptr = poseidon_ptr;
            tempvar z_pow1_11_ptr = z_pow1_11_ptr;
            tempvar continuable_hash = continuable_hash;

            tempvar Qacc = Qacc;
            tempvar xOverY = xOverY;
            tempvar yInv = yInv;
            tempvar poly_acc_034 = poly_acc_034;
            tempvar poly_acc_034034 = poly_acc_034034;
        } else {
            assert res2 = res;
            tempvar range_check_ptr = range_check_ptr;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar poseidon_ptr = poseidon_ptr;
            tempvar z_pow1_11_ptr = z_pow1_11_ptr;
            tempvar continuable_hash = continuable_hash;

            tempvar Qacc = Qacc;
            tempvar xOverY = xOverY;
            tempvar yInv = yInv;
            tempvar poly_acc_034 = poly_acc_034;
            tempvar poly_acc_034034 = poly_acc_034034;
        }
        let poly_acc_034 = poly_acc_034;
        let poly_acc_034034 = poly_acc_034034;
        let z_pow1_11_ptr = z_pow1_11_ptr;
        let Qacc = Qacc;
        let xOverY = xOverY;
        let yInv = yInv;

        // i = 63, separately to avoid a doubleStep
        // (at this point Qacc = 2Q, so 2Qacc-Q=3Q is equivalent to Qacc+Q=3Q
        // this means doubleAndAddStep is equivalent to addStep here)

        // Todo : use Square034 instead of Square if n_points==1
        let res_i63 = square_trick(res2);

        let (_, n_is_odd) = felt_divmod(n_points, 2);

        let res = i63_loop(0, n_points, offset, res_i63);
    }
    let offset = offset + n_points;
    %{ print_e12f_to_gnark(ids.res, "resBefMulti") %}

    with Qacc, Q_neg, xOverY, yInv, n_is_odd, continuable_hash, z_pow1_11_ptr, poly_acc_sq, poly_acc_034, poly_acc_034034, poly_acc_01234 {
        let (res, offset) = multi_miller_loop_inner(n_points, 62, offset, res);

        let res = final_loop(0, n_points, offset, res);
        %{ print("Computing random point ... ") %}

        let (local Z: BigInt3) = felt_to_bigint3(continuable_hash);
        %{ print("Verifying commitment ... ") %}
        tempvar xyuz = 0;
    }

    let res_gnark = w_to_gnark_reduced([res]);
    %{
        print("RESFINALMILLERLOOP:")
        print_e12(ids.res_gnark)
    %}
    return res_gnark;
}
func final_loop{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    Qacc: G2Point**,
    xOverY: BigInt3**,
    yInv: BigInt3**,
    poly_acc_034034: PolyAcc034034*,
    poly_acc_01234: PolyAcc12*,
    continuable_hash: felt,
    z_pow1_11_ptr: ZPowers11*,
}(k: felt, n_points: felt, offset: felt, res: E12full*) -> E12full* {
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

        let (new_Q: G2Point*, l1: E12full034*) = g2.add_step(Qacc[offset + k], &Q1);
        assert Qacc[offset + n_points + k] = new_Q;

        let l1w1 = fq_bigint3.mulf([xOverY[k]], l1.w1);
        let l1w3 = fq_bigint3.mulf([yInv[k]], l1.w3);
        let l1w7 = fq_bigint3.mulf([xOverY[k]], l1.w7);
        let l1w9 = fq_bigint3.mulf([yInv[k]], l1.w9);
        local l1f: E12full034 = E12full034(l1w1, l1w3, l1w7, l1w9);

        let l2 = g2.line_compute(Qacc[offset + n_points + k], &Q2);
        let l2w1 = fq_bigint3.mulf([xOverY[k]], l2.w1);
        let l2w3 = fq_bigint3.mulf([yInv[k]], l2.w3);
        let l2w7 = fq_bigint3.mulf([xOverY[k]], l2.w7);
        let l2w9 = fq_bigint3.mulf([yInv[k]], l2.w9);
        local l2f: E12full034 = E12full034(l2w1, l2w3, l2w7, l2w9);

        let prod_lines = mul034_034_trick(&l1f, &l2f);
        let res = mul01234_trick(res, prod_lines);

        return final_loop(k + 1, n_points, offset, res);
    }
}
func n_sup_3_loop{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    Qacc: G2Point**,
    xOverY: BigInt3**,
    yInv: BigInt3**,
    poly_acc_034: PolyAcc034*,
    continuable_hash: felt,
    z_pow1_11_ptr: ZPowers11*,
}(k: felt, offset: felt, res: E12full*) -> E12full* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    // %{ print(f"init_loop {ids.k}") %}
    if (k == 2) {
        return res;
    } else {
        let (new_Q: G2Point*, l1: E12full034*) = g2.double_step(Qacc[k]);
        assert Qacc[offset + k] = new_Q;
        let l1w1 = fq_bigint3.mulf([xOverY[k]], l1.w1);
        let l1w3 = fq_bigint3.mulf([yInv[k]], l1.w3);
        let l1w7 = fq_bigint3.mulf([xOverY[k]], l1.w7);
        let l1w9 = fq_bigint3.mulf([yInv[k]], l1.w9);
        local l1f: E12full034 = E12full034(l1w1, l1w3, l1w7, l1w9);
        let res = mul034_trick(res, &l1f);
        return n_sup_3_loop(k - 1, offset, res);
    }
}

func multi_miller_loop_inner{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    Qacc: G2Point**,
    Q_neg: G2Point**,
    xOverY: BigInt3**,
    yInv: BigInt3**,
    n_is_odd: felt,
    poly_acc_sq: PolyAcc12*,
    poly_acc_034: PolyAcc034*,
    poly_acc_034034: PolyAcc034034*,
    poly_acc_01234: PolyAcc12*,
    continuable_hash: felt,
    z_pow1_11_ptr: ZPowers11*,
}(n_points: felt, bit_index: felt, offset: felt, res: E12full*) -> (res: E12full*, offset: felt) {
    alloc_locals;
    let res = square_trick(res);

    if (bit_index == 0) {
        // we know get_NAF_digit(0) = 0
        let (lines: E12full034**) = alloc();
        %{ print(f"index = {ids.bit_index}, bit = {ids.bit_index}, offset = {ids.offset}") %}

        double_step_loop(0, n_points, offset, lines);
        tempvar offset = offset + n_points;
        if (n_is_odd != 0) {
            let res = mul034_trick(res, lines[n_points - 1]);
            let res = mul_lines_two_by_two(1, n_points, lines, res);
            return (res, offset);
        } else {
            let res = mul_lines_two_by_two(1, n_points, lines, res);
            return (res, offset);
        }
    } else {
        let bit = get_NAF_digit(bit_index);
        %{ print(f"index = {ids.bit_index}, bit = {ids.bit}, offset = {ids.offset}") %}
        if (bit == 0) {
            let (lines: E12full034**) = alloc();

            double_step_loop(0, n_points, offset, lines);
            tempvar offset = offset + n_points;

            if (n_is_odd != 0) {
                let res = mul034_trick(res, lines[n_points - 1]);
                let res = mul_lines_two_by_two(1, n_points, lines, res);
                return multi_miller_loop_inner(n_points, bit_index - 1, offset, res);
            } else {
                let res = mul_lines_two_by_two(1, n_points, lines, res);
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
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    Qacc: G2Point**,
    xOverY: BigInt3**,
    yInv: BigInt3**,
    poly_acc_034034: PolyAcc034034*,
    poly_acc_01234: PolyAcc12*,
    continuable_hash: felt,
    z_pow1_11_ptr: ZPowers11*,
}(k: felt, n_points: felt, offset: felt, res: E12full*) -> E12full* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    if (k == n_points) {
        return res;
    } else {
        let (new_Q: G2Point*, l1: E12full034*, l2: E12full034*) = g2.double_and_add_step(
            Qacc[offset + k], Qacc[k]
        );
        assert Qacc[offset + n_points + k] = new_Q;
        // let l1r0 = e2.mul_by_element(xOverY[k], l1.r0);
        // let l1r1 = e2.mul_by_element(yInv[k], l1.r1);
        let l1w1 = fq_bigint3.mulf([xOverY[k]], l1.w1);
        let l1w3 = fq_bigint3.mulf([yInv[k]], l1.w3);
        let l1w7 = fq_bigint3.mulf([xOverY[k]], l1.w7);
        let l1w9 = fq_bigint3.mulf([yInv[k]], l1.w9);
        local l1f: E12full034 = E12full034(l1w1, l1w3, l1w7, l1w9);

        // let l2r0 = e2.mul_by_element(xOverY[k], l2.r0);
        // let l2r1 = e2.mul_by_element(yInv[k], l2.r1);
        let l2w1 = fq_bigint3.mulf([xOverY[k]], l2.w1);
        let l2w3 = fq_bigint3.mulf([yInv[k]], l2.w3);
        let l2w7 = fq_bigint3.mulf([xOverY[k]], l2.w7);
        let l2w9 = fq_bigint3.mulf([yInv[k]], l2.w9);
        local l2f: E12full034 = E12full034(l2w1, l2w3, l2w7, l2w9);
        let prod_lines = mul034_034_trick(&l1f, &l2f);

        let res = mul01234_trick(res, prod_lines);
        let res = bit_1_loop(k + 1, n_points, offset, res);
        return res;
    }
}

func bit_2_loop{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    Qacc: G2Point**,
    Q_neg: G2Point**,
    xOverY: BigInt3**,
    yInv: BigInt3**,
    poly_acc_034034: PolyAcc034034*,
    poly_acc_01234: PolyAcc12*,
    continuable_hash: felt,
    z_pow1_11_ptr: ZPowers11*,
}(k: felt, n_points: felt, offset: felt, res: E12full*) -> E12full* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    if (k == n_points) {
        return res;
    } else {
        let (new_Q: G2Point*, l1: E12full034*, l2: E12full034*) = g2.double_and_add_step(
            Qacc[offset + k], Q_neg[k]
        );
        assert Qacc[offset + n_points + k] = new_Q;
        // let l1r0 = e2.mul_by_element(xOverY[k], l1.r0);
        // let l1r1 = e2.mul_by_element(yInv[k], l1.r1);
        let l1w1 = fq_bigint3.mulf([xOverY[k]], l1.w1);
        let l1w3 = fq_bigint3.mulf([yInv[k]], l1.w3);
        let l1w7 = fq_bigint3.mulf([xOverY[k]], l1.w7);
        let l1w9 = fq_bigint3.mulf([yInv[k]], l1.w9);
        local l1f: E12full034 = E12full034(l1w1, l1w3, l1w7, l1w9);

        // let l2r0 = e2.mul_by_element(xOverY[k], l2.r0);
        // let l2r1 = e2.mul_by_element(yInv[k], l2.r1);
        let l2w1 = fq_bigint3.mulf([xOverY[k]], l2.w1);
        let l2w3 = fq_bigint3.mulf([yInv[k]], l2.w3);
        let l2w7 = fq_bigint3.mulf([xOverY[k]], l2.w7);
        let l2w9 = fq_bigint3.mulf([yInv[k]], l2.w9);
        local l2f: E12full034 = E12full034(l2w1, l2w3, l2w7, l2w9);
        let prod_lines = mul034_034_trick(&l1f, &l2f);

        let res = mul01234_trick(res, prod_lines);
        let res = bit_2_loop(k + 1, n_points, offset, res);
        return res;
    }
}
func i63_loop{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    Qacc: G2Point**,
    Q_neg: G2Point**,
    xOverY: BigInt3**,
    yInv: BigInt3**,
    poly_acc_034034: PolyAcc034034*,
    poly_acc_01234: PolyAcc12*,
    continuable_hash: felt,
    z_pow1_11_ptr: ZPowers11*,
}(k: felt, n_points: felt, offset: felt, res: E12full*) -> E12full* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    if (k == n_points) {
        return res;
    } else {
        // l2 the line passing Qacc[k] and -Q
        let l2: E12full034* = g2.line_compute(Qacc[offset + k], Q_neg[k]);
        // line evaluation at P[k]

        // let l2_r0 = e2.mul_by_element(xOverY[k], l2.r0);
        // let l2_r1 = e2.mul_by_element(yInv[k], l2.r1);
        let l2w1 = fq_bigint3.mulf([xOverY[k]], l2.w1);
        let l2w3 = fq_bigint3.mulf([yInv[k]], l2.w3);
        let l2w7 = fq_bigint3.mulf([xOverY[k]], l2.w7);
        let l2w9 = fq_bigint3.mulf([yInv[k]], l2.w9);
        local l2f: E12full034 = E12full034(l2w1, l2w3, l2w7, l2w9);
        // Qacc[k] ← Qacc[k]+Q[k] and
        // l1 the line ℓ passing Qacc[k] and Q[k]

        let (new_Q: G2Point*, l1: E12full034*) = g2.add_step(Qacc[offset + k], Qacc[k]);
        assert Qacc[offset + n_points + k] = new_Q;

        // line evaluation at P[k]
        let l1w1 = fq_bigint3.mulf([xOverY[k]], l1.w1);
        let l1w3 = fq_bigint3.mulf([yInv[k]], l1.w3);
        let l1w7 = fq_bigint3.mulf([xOverY[k]], l1.w7);
        let l1w9 = fq_bigint3.mulf([yInv[k]], l1.w9);
        local l1f: E12full034 = E12full034(l1w1, l1w3, l1w7, l1w9);

        // l*l
        let prod_lines = mul034_034_trick(&l1f, &l2f);

        // res = res * l*l
        let res = mul01234_trick(res, prod_lines);

        return i63_loop(k + 1, n_points, offset, res);
    }
}
// Double step Qacc[offset+k] for k in [0, n_points)
// Store the doubled point in Qacc[offset+n_points+k]
// Store the line evaluation at P[k] in lines_r0[k] and lines_r1[k]
func double_step_loop{range_check_ptr, Qacc: G2Point**, xOverY: BigInt3**, yInv: BigInt3**}(
    k: felt, n_points: felt, offset: felt, lines: E12full034**
) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    if (k == n_points) {
        return ();
    } else {
        let (new_Q: G2Point*, l1: E12full034*) = g2.double_step(Qacc[offset + k]);
        assert Qacc[offset + n_points + k] = new_Q;
        // let l1r0 = e2.mul_by_element(xOverY[k], l1.r0);
        // let l1r1 = e2.mul_by_element(yInv[k], l1.r1);
        // assert lines_r0[k] = l1r0;
        // assert lines_r1[k] = l1r1;

        let l1w1 = fq_bigint3.mulf([xOverY[k]], l1.w1);
        let l1w3 = fq_bigint3.mulf([yInv[k]], l1.w3);
        let l1w7 = fq_bigint3.mulf([xOverY[k]], l1.w7);
        let l1w9 = fq_bigint3.mulf([yInv[k]], l1.w9);
        local l1f: E12full034 = E12full034(l1w1, l1w3, l1w7, l1w9);
        assert lines[k] = &l1f;
        return double_step_loop(k + 1, n_points, offset, lines);
    }
}

func mul_lines_two_by_two{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    poly_acc_034034: PolyAcc034034*,
    poly_acc_01234: PolyAcc12*,
    continuable_hash: felt,
    z_pow1_11_ptr: ZPowers11*,
}(k: felt, n: felt, lines: E12full034**, res: E12full*) -> E12full* {
    alloc_locals;
    // %{ print(f"Mul2b2: k={ids.k}, n={ids.n}") %}
    if (k == n) {
        return res;
    } else {
        if (k == n + 1) {
            return res;
        } else {
            let prod_lines = mul034_034_trick(lines[k], lines[k - 1]);
            let res = mul01234_trick(res, prod_lines);
            return mul_lines_two_by_two(k + 2, n, lines, res);
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

func final_exponentiation{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, poseidon_ptr: PoseidonBuiltin*
}(z: E12*, unsafe: felt) -> E12* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let one: E6* = e6.one();
    local one_full: E6full = E6full(
        BigInt3(1, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
    );
    local z_c1: E6*;
    local selector1: felt;

    // let (verify_mul6_array: VerifyMul6*) = alloc();
    // let n_mul6 = 0;
    // let (verify_mul6_from_square_torus_array: VerifyMul6FromSquareT*) = alloc();
    // let n_torus_squares = 0;

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

    local Z: BigInt3;
    %{
        #from tools.py.pairing_curves.bn254.final_exp import get_Z
        #Z = get_Z(ids.final_exp_input)
        #Z_bigint3 = split(Z)
        #ids.Z.d0, ids.Z.d1, ids.Z.d2 = Z_bigint3[0], Z_bigint3[1], Z_bigint3[2]
        ids.Z.d0, ids.Z.d1, ids.Z.d2 = 0x1, 0x1, 0x1
    %}
    assert_reduced_felt(Z);
    let continuable_hash = 'GaragaBN254FinalExp';
    local zero_e6full: E6full = E6full(
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
    );

    local zero_e5full: E5full = E5full(
        Uint256(0, 0), Uint256(0, 0), Uint256(0, 0), Uint256(0, 0), Uint256(0, 0)
    );

    // local zero_bigint5: UnreducedBigInt5 = UnreducedBigInt5(0, 0, 0, 0, 0);
    local zero_bigint3: UnreducedBigInt3 = UnreducedBigInt3(0, 0, 0);
    local poly_acc_f: PolyAcc6 = PolyAcc6(xy=zero_bigint3, q=zero_e5full, r=zero_e6full);
    local poly_acc_sq_f: PolyAccSquare6 = PolyAccSquare6(xy=zero_bigint3, q=zero_e5full, r=0);
    let poly_acc_sq = &poly_acc_sq_f;
    let poly_acc = &poly_acc_f;
    let z_pow1_5_ptr = get_powers_of_z5(Z);
    with continuable_hash, poly_acc, poly_acc_sq, z_pow1_5_ptr {
        // Torus compression absorbed:
        // Raising e to (p⁶-1) is
        // e^(p⁶) / e = (e.C0 - w*e.C1) / (e.C0 + w*e.C1)
        //            = (-e.C0/e.C1 + w) / (-e.C0/e.C1 - w)
        // So the fraction -e.C0/e.C1 is already in the torus.
        // This absorbs the torus compression in the easy part.

        // let c_den = e6.inv(z_c1);
        let c_num_full = gnark_to_v_reduced(z.c0);
        let c_num_full = e6.neg_full(c_num_full);
        // let c_num = e6.neg(z.c0);

        let z_c1_full = gnark_to_v(z_c1);
        // let c_num_full = gnark_to_v(c_num);

        let c = div_trick_e6(c_num_full, z_c1_full);

        let t0 = e6.frobenius_square_torus_full(c);
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
        let t2 = e6.frobenius_torus_full(t3);
        let t0 = e6.mul_torus(t2, t0);
        let t2 = e6.frobenius_square_torus_full(t4);
        let t0 = e6.mul_torus(t2, t0);
        let t2 = e6.inverse_torus(c);
        let t2 = e6.mul_torus(t2, t3);
        let t2 = e6.frobenius_cube_torus_full(t2);

        local final_res: E12*;
        if (unsafe != 0) {
            let rest = e6.mul_torus(t2, t0);
            let rest_gnark = v_to_gnark([rest]);
            let res = decompress_torus(rest_gnark);
            assert final_res = res;
            tempvar range_check_ptr = range_check_ptr;
            tempvar bitwise_ptr = bitwise_ptr;
            tempvar poseidon_ptr = poseidon_ptr;
            tempvar continuable_hash = continuable_hash;
            tempvar poly_acc = poly_acc;
            tempvar poly_acc_sq = poly_acc_sq;
            tempvar z_pow1_5_ptr = z_pow1_5_ptr;
        } else {
            let _sum = e6.add_full(t0, t2);
            let is_zero = e6.is_zero_full(_sum);
            local t0t: E6full*;
            if (is_zero != 0) {
                assert t0t = &one_full;
            } else {
                assert t0t = t0;
            }

            if (selector1 == 0) {
                if (is_zero == 0) {
                    let rest = e6.mul_torus(t2, t0t);
                    let rest_gnark = v_to_gnark([rest]);
                    let res = decompress_torus(rest_gnark);
                    assert final_res = res;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar poseidon_ptr = poseidon_ptr;
                    tempvar continuable_hash = continuable_hash;
                    tempvar poly_acc = poly_acc;
                    tempvar poly_acc_sq = poly_acc_sq;
                    tempvar z_pow1_5_ptr = z_pow1_5_ptr;
                } else {
                    let res = e12.one();
                    assert final_res = res;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar poseidon_ptr = poseidon_ptr;
                    tempvar continuable_hash = continuable_hash;
                    tempvar poly_acc = poly_acc;
                    tempvar poly_acc_sq = poly_acc_sq;
                    tempvar z_pow1_5_ptr = z_pow1_5_ptr;
                }
            } else {
                let res = e12.one();
                assert final_res = res;
                tempvar range_check_ptr = range_check_ptr;
                tempvar bitwise_ptr = bitwise_ptr;
                tempvar poseidon_ptr = poseidon_ptr;
                tempvar continuable_hash = continuable_hash;
                tempvar poly_acc = poly_acc;
                tempvar poly_acc_sq = poly_acc_sq;
                tempvar z_pow1_5_ptr = z_pow1_5_ptr;
            }
        }
        let range_check_ptr = range_check_ptr;
        let bitwise_ptr = bitwise_ptr;
        let poseidon_ptr = poseidon_ptr;
        let continuable_hash = continuable_hash;
        let poly_acc = poly_acc;
        let poly_acc_sq = poly_acc_sq;
        let z_pow1_5_ptr = z_pow1_5_ptr;

        // %{ print(f"N torus squares : {n_squares_torus}") %}

        let (local Z: BigInt3) = felt_to_bigint3(continuable_hash);
        // assert Z.d0 - z_pow1_5.z_1.d0 = 0;
        // assert Z.d1 - z_pow1_5.z_1.d1 = 0;
        // assert Z.d2 - z_pow1_5.z_1.d2 = 0;

        let sum_r_of_z = eval_E6_plus_v_unreduced(poly_acc.r, poly_acc_sq.r, z_pow1_5_ptr);
        let sum_q_of_z = eval_E5(
            E5full(
                Uint256(
                    poly_acc.q.v0.low + poly_acc_sq.q.v0.low,
                    poly_acc.q.v0.high + poly_acc_sq.q.v0.high,
                ),
                Uint256(
                    poly_acc.q.v1.low + poly_acc_sq.q.v1.low,
                    poly_acc.q.v1.high + poly_acc_sq.q.v1.high,
                ),
                Uint256(
                    poly_acc.q.v2.low + poly_acc_sq.q.v2.low,
                    poly_acc.q.v2.high + poly_acc_sq.q.v2.high,
                ),
                Uint256(
                    poly_acc.q.v3.low + poly_acc_sq.q.v3.low,
                    poly_acc.q.v3.high + poly_acc_sq.q.v3.high,
                ),
                Uint256(
                    poly_acc.q.v4.low + poly_acc_sq.q.v4.low,
                    poly_acc.q.v4.high + poly_acc_sq.q.v4.high,
                ),
            ),
            z_pow1_5_ptr,
        );
        let z_6 = fq_bigint3.mulf(z_pow1_5_ptr.z_1, z_pow1_5_ptr.z_5);
        let p_of_z: BigInt3 = eval_unreduced_poly6(z_pow1_5_ptr.z_3, z_6);
        let (sum_qP_of_z) = bigint_mul(sum_q_of_z, p_of_z);

        verify_zero5(
            UnreducedBigInt5(
                d0=poly_acc.xy.d0 + poly_acc_sq.xy.d0 - sum_qP_of_z.d0 - sum_r_of_z.d0,
                d1=poly_acc.xy.d1 + poly_acc_sq.xy.d1 - sum_qP_of_z.d1 - sum_r_of_z.d1,
                d2=poly_acc.xy.d2 + poly_acc_sq.xy.d2 - sum_qP_of_z.d2 - sum_r_of_z.d2,
                d3=-sum_qP_of_z.d3 - sum_r_of_z.d3,
                d4=-sum_qP_of_z.d4 - sum_r_of_z.d4,
            ),
        );

        return final_res;
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
