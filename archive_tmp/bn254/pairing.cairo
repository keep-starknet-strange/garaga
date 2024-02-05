from starkware.cairo.common.registers import get_label_location, get_fp_and_pc
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_nn, unsigned_div_rem as felt_divmod, assert_nn_le
from src.bn254.g1 import G1Point, g1
from src.bn254.g2 import G2Point, g2, E4
from src.bn254.curve import P0, P1, P2
from src.bn254.towers.e12 import (
    E12,
    e12,
    E12D,
    E12DU,
    E11DU,
    E9full,
    E7full,
    E12full034,
    E12full01234,
    e12_tricks,
    w_to_gnark_reduced,
    PolyAcc12,
    PolyAcc034,
    PolyAcc034034,
    get_powers_of_z11,
    ZPowers11,
    eval_irreducible_poly12,
    eval_E11,
    eval_E12_unreduced,
)
from src.bn254.towers.e2 import E2, e2
from src.bn254.towers.e6 import (
    E6,
    E6full,
    E6DirectUnreduced,
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
    eval_irreducible_poly6,
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

from src.extension_field_tricks.fp12 import verify_12th_extension_tricks
from src.extension_field_tricks.fp6 import verify_6th_extension_tricks

const ate_loop_count = 29793968203157093288;
const log_ate_loop_count = 63;
const naf_count = 66;

func pair{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, poseidon_ptr: PoseidonBuiltin*}(
    P: G1Point, Q: G2Point
) -> E12D* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    g1.assert_on_curve(&P);
    g2.assert_on_curve(&Q);
    let (P_arr: G1Point**) = alloc();
    let (Q_arr: G2Point**) = alloc();
    assert P_arr[0] = &P;
    assert Q_arr[0] = &Q;
    let f = multi_miller_loop(P_arr, Q_arr, 1);
    let ff = final_exponentiation(f, 1);
    return ff;
}

func pair_multi{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, poseidon_ptr: PoseidonBuiltin*}(
    P_arr: G1Point**, Q_arr: G2Point**, mul_by_GT: E12D, n: felt
) -> E12D* {
    alloc_locals;
    assert_nn_le(2, n);
    multi_assert_on_curve(P_arr, Q_arr, n - 1);
    let f = multi_miller_loop(P_arr, Q_arr, n);
    let ff = final_exponentiation(f, 0);
    return ff;
}

func multi_assert_on_curve{range_check_ptr}(P_arr: G1Point**, Q_arr: G2Point**, index: felt) {
    if (index == -1) {
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

    let (local Qacc: G2Point**) = alloc();
    let (local Q_neg: G2Point**) = alloc();
    let (local yInv: BigInt3*) = alloc();
    let (local xOverY: BigInt3*) = alloc();

    with Qacc, Q_neg, yInv, xOverY {
        initialize_arrays_and_constants(P, Q, n_points, 0);
    }

    tempvar offset = n_points;

    let zero_fq: BigInt3 = fq_zero();
    let zero_fq12: E12D = e12.zero_full();

    local poly_acc_12_f: PolyAcc12 = PolyAcc12(
        xy=UnreducedBigInt3(0, 0, 0), q=[cast(&zero_fq12, E11DU*)], r=[cast(&zero_fq12, E12DU*)]
    );
    local poly_acc_034_f: PolyAcc034 = PolyAcc034(
        xy=UnreducedBigInt3(0, 0, 0), q=[cast(&zero_fq12, E9full*)], r=[cast(&zero_fq12, E12DU*)]
    );
    local poly_acc_034034_f: PolyAcc034034 = PolyAcc034034(
        xy=UnreducedBigInt3(0, 0, 0),
        q=[cast(&zero_fq12, E7full*)],
        r=[cast(&zero_fq12, E12full01234*)],
    );
    let poly_acc_12 = &poly_acc_12_f;
    let poly_acc_034 = &poly_acc_034_f;
    let poly_acc_034034 = &poly_acc_034034_f;
    let continuable_hash = 'GaragaBN254MillerLoop';
    local Z: BigInt3;
    %{
        from src.bn254.pairing_multi_miller import multi_miller_loop, G1Point, G2Point, E2
        from starkware.cairo.common.math_utils import as_int
        from src.hints.fq import get_p
        n_points = ids.n_points
        P_arr = [[0, 0] for _ in range(n_points)]
        Q_arr = [([0, 0], [0, 0]) for _ in range(n_points)]
        p = get_p(ids)
        for i in range(n_points):
            P_pt_ptr = memory[ids.P+i]
            Q_pt_ptr = memory[ids.Q+i]
            Q_x_ptr = memory[Q_pt_ptr]
            Q_y_ptr = memory[Q_pt_ptr+1]

            for k in range(ids.N_LIMBS):
                P_arr[i][0] = P_arr[i][0] + as_int(memory[P_pt_ptr+k], PRIME) * ids.BASE**k
                P_arr[i][1] = P_arr[i][1] + as_int(memory[P_pt_ptr+ids.N_LIMBS+k], PRIME) * ids.BASE**k
                Q_arr[i][0][0] = Q_arr[i][0][0] + as_int(memory[Q_x_ptr+k], PRIME) * ids.BASE**k
                Q_arr[i][0][1] = Q_arr[i][0][1] + as_int(memory[Q_x_ptr+ids.N_LIMBS+k], PRIME) * ids.BASE**k
                Q_arr[i][1][0] = Q_arr[i][1][0] + as_int(memory[Q_y_ptr+k], PRIME) * ids.BASE**k
                Q_arr[i][1][1] = Q_arr[i][1][1] + as_int(memory[Q_y_ptr+ids.N_LIMBS+k], PRIME) * ids.BASE**k
        P_arr = [G1Point(*P) for P in P_arr]
        Q_arr = [G2Point(E2(*Q[0], p), E2(*Q[1], p)) for Q in Q_arr]

        print("Pre-computing miller loop hash commitment Z = poseidon('GaragaBN254MillerLoop', [(A1, B1, Q1, R1), ..., (An, Bn, Qn, Rn)])")
        x, Z = multi_miller_loop(P_arr, Q_arr, ids.n_points, ids.continuable_hash)
        Z_bigint3 = split(Z)
        ids.Z.d0, ids.Z.d1, ids.Z.d2 = Z_bigint3[0], Z_bigint3[1], Z_bigint3[2]
    %}
    let z_pow1_11_ptr: ZPowers11* = get_powers_of_z11(Z);
    let (_, n_is_odd) = felt_divmod(n_points, 2);

    // Compute ∏ᵢ { fᵢ_{6x₀+2,Q}(P) }
    // i = 64, separately to avoid an E12 Square
    // (Square(res) = 1² = 1)

    // k = 0, separately to avoid MulBy034 (res × ℓ)
    // (assign line to res)
    let (new_Q0: G2Point*, l1: E12full034*) = g2.double_step(Qacc[0]);
    assert Qacc[offset + 0] = new_Q0;
    let res_w1 = fq_bigint3.mul(xOverY[0], l1.w1);
    let res_w3 = fq_bigint3.mul(yInv[0], l1.w3);
    let res_w7 = fq_bigint3.mul(xOverY[0], l1.w7);
    let res_w9 = fq_bigint3.mul(yInv[0], l1.w9);

    local res_init: E12full034 = E12full034(res_w1, res_w3, res_w7, res_w9);
    with Qacc, Q_neg, xOverY, yInv, n_is_odd, continuable_hash, z_pow1_11_ptr, poly_acc_12, poly_acc_034, poly_acc_034034 {
        let res = i64_loop(1, offset, n_points, cast(&res_init, E12D*));
        let res = e12_tricks.square(res);
        // i = 63, separately to avoid a doubleStep
        // (at this point Qacc = 2Q, so 2Qacc-Q=3Q is equivalent to Qacc+Q=3Q
        // this means doubleAndAddStep is equivalent to addStep here)
        let res = i63_loop(0, n_points, offset, res);
        let offset = offset + n_points;
        let (res, offset) = multi_miller_loop_inner(n_points, 62, offset, res);

        let res = final_loop(0, n_points, offset, res);
        // %{ print(f"HASH : {ids.continuable_hash}") %}
        let (local Z: BigInt3) = felt_to_bigint3(continuable_hash);
        %{ print("Verifying Miller Loop hash commitment Z = continuable_hash ... ") %}
        assert Z.d0 - z_pow1_11_ptr.z_1.d0 = 0;
        assert Z.d1 - z_pow1_11_ptr.z_1.d1 = 0;
        assert Z.d2 - z_pow1_11_ptr.z_1.d2 = 0;
        %{ print("Verifying Σc_i*A_i(z)*B_i(z) == P(z)Σc_i*Q_i(z) + Σc_i*R_i(z)") %}
        verify_12th_extension_tricks();
    }
    %{ print("Ok! \n") %}

    let res_gnark = w_to_gnark_reduced([res]);
    // %{
    //     print("RESFINALMILLERLOOP:")
    //     print_e12(ids.res_gnark)
    // %}
    return res_gnark;
}
func final_loop{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    Qacc: G2Point**,
    xOverY: BigInt3*,
    yInv: BigInt3*,
    poly_acc_034034: PolyAcc034034*,
    poly_acc_12: PolyAcc12*,
    continuable_hash: felt,
    z_pow1_11_ptr: ZPowers11*,
}(k: felt, n_points: felt, offset: felt, res: E12D*) -> E12D* {
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

        let l1w1 = fq_bigint3.mul(xOverY[k], l1.w1);
        let l1w3 = fq_bigint3.mul(yInv[k], l1.w3);
        let l1w7 = fq_bigint3.mul(xOverY[k], l1.w7);
        let l1w9 = fq_bigint3.mul(yInv[k], l1.w9);
        local l1f: E12full034 = E12full034(l1w1, l1w3, l1w7, l1w9);

        let l2 = g2.line_compute(Qacc[offset + n_points + k], &Q2);
        let l2w1 = fq_bigint3.mul(xOverY[k], l2.w1);
        let l2w3 = fq_bigint3.mul(yInv[k], l2.w3);
        let l2w7 = fq_bigint3.mul(xOverY[k], l2.w7);
        let l2w9 = fq_bigint3.mul(yInv[k], l2.w9);
        local l2f: E12full034 = E12full034(l2w1, l2w3, l2w7, l2w9);

        let prod_lines = e12_tricks.mul034_034(&l1f, &l2f);
        let res = e12_tricks.mul01234(res, prod_lines);

        return final_loop(k + 1, n_points, offset, res);
    }
}

func multi_miller_loop_inner{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    Qacc: G2Point**,
    Q_neg: G2Point**,
    xOverY: BigInt3*,
    yInv: BigInt3*,
    n_is_odd: felt,
    poly_acc_12: PolyAcc12*,
    poly_acc_034: PolyAcc034*,
    poly_acc_034034: PolyAcc034034*,
    continuable_hash: felt,
    z_pow1_11_ptr: ZPowers11*,
}(n_points: felt, bit_index: felt, offset: felt, res: E12D*) -> (res: E12D*, offset: felt) {
    alloc_locals;
    let res = e12_tricks.square(res);

    if (bit_index == 0) {
        // get_NAF_digit(0) = 0
        let (lines: E12full034**) = alloc();
        // %{ print(f"index = {ids.bit_index}, bit = {ids.bit_index}, offset = {ids.offset}") %}

        double_step_loop(0, n_points, offset, lines);
        tempvar offset = offset + n_points;
        if (n_is_odd != 0) {
            let res = e12_tricks.mul034(res, lines[n_points - 1]);
            let res = mul_lines_two_by_two(1, n_points, lines, res);
            return (res, offset);
        } else {
            let res = mul_lines_two_by_two(1, n_points, lines, res);
            return (res, offset);
        }
    } else {
        let bit = get_NAF_digit(bit_index);
        // %{ print(f"index = {ids.bit_index}, bit = {ids.bit}, offset = {ids.offset}") %}
        if (bit == 0) {
            let (lines: E12full034**) = alloc();

            double_step_loop(0, n_points, offset, lines);
            tempvar offset = offset + n_points;

            if (n_is_odd != 0) {
                let res = e12_tricks.mul034(res, lines[n_points - 1]);
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
    xOverY: BigInt3*,
    yInv: BigInt3*,
    poly_acc_034034: PolyAcc034034*,
    poly_acc_12: PolyAcc12*,
    continuable_hash: felt,
    z_pow1_11_ptr: ZPowers11*,
}(k: felt, n_points: felt, offset: felt, res: E12D*) -> E12D* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    if (k == n_points) {
        return res;
    } else {
        let (new_Q: G2Point*, l1: E12full034*, l2: E12full034*) = g2.double_and_add_step(
            Qacc[offset + k], Qacc[k]
        );
        assert Qacc[offset + n_points + k] = new_Q;

        let l1w1 = fq_bigint3.mul(xOverY[k], l1.w1);
        let l1w3 = fq_bigint3.mul(yInv[k], l1.w3);
        let l1w7 = fq_bigint3.mul(xOverY[k], l1.w7);
        let l1w9 = fq_bigint3.mul(yInv[k], l1.w9);
        local l1f: E12full034 = E12full034(l1w1, l1w3, l1w7, l1w9);

        let l2w1 = fq_bigint3.mul(xOverY[k], l2.w1);
        let l2w3 = fq_bigint3.mul(yInv[k], l2.w3);
        let l2w7 = fq_bigint3.mul(xOverY[k], l2.w7);
        let l2w9 = fq_bigint3.mul(yInv[k], l2.w9);
        local l2f: E12full034 = E12full034(l2w1, l2w3, l2w7, l2w9);
        let prod_lines = e12_tricks.mul034_034(&l1f, &l2f);

        let res = e12_tricks.mul01234(res, prod_lines);
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
    xOverY: BigInt3*,
    yInv: BigInt3*,
    poly_acc_034034: PolyAcc034034*,
    poly_acc_12: PolyAcc12*,
    continuable_hash: felt,
    z_pow1_11_ptr: ZPowers11*,
}(k: felt, n_points: felt, offset: felt, res: E12D*) -> E12D* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    if (k == n_points) {
        return res;
    } else {
        let (new_Q: G2Point*, l1: E12full034*, l2: E12full034*) = g2.double_and_add_step(
            Qacc[offset + k], Q_neg[k]
        );
        assert Qacc[offset + n_points + k] = new_Q;

        let l1w1 = fq_bigint3.mul(xOverY[k], l1.w1);
        let l1w3 = fq_bigint3.mul(yInv[k], l1.w3);
        let l1w7 = fq_bigint3.mul(xOverY[k], l1.w7);
        let l1w9 = fq_bigint3.mul(yInv[k], l1.w9);
        local l1f: E12full034 = E12full034(l1w1, l1w3, l1w7, l1w9);

        let l2w1 = fq_bigint3.mul(xOverY[k], l2.w1);
        let l2w3 = fq_bigint3.mul(yInv[k], l2.w3);
        let l2w7 = fq_bigint3.mul(xOverY[k], l2.w7);
        let l2w9 = fq_bigint3.mul(yInv[k], l2.w9);
        local l2f: E12full034 = E12full034(l2w1, l2w3, l2w7, l2w9);
        let prod_lines = e12_tricks.mul034_034(&l1f, &l2f);

        let res = e12_tricks.mul01234(res, prod_lines);
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
    xOverY: BigInt3*,
    yInv: BigInt3*,
    poly_acc_034034: PolyAcc034034*,
    poly_acc_12: PolyAcc12*,
    continuable_hash: felt,
    z_pow1_11_ptr: ZPowers11*,
}(k: felt, n_points: felt, offset: felt, res: E12D*) -> E12D* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    if (k == n_points) {
        return res;
    } else {
        // l2 the line passing Qacc[k] and -Q
        let l2: E12full034* = g2.line_compute(Qacc[offset + k], Q_neg[k]);
        // line evaluation at P[k]

        let l2w1 = fq_bigint3.mul(xOverY[k], l2.w1);
        let l2w3 = fq_bigint3.mul(yInv[k], l2.w3);
        let l2w7 = fq_bigint3.mul(xOverY[k], l2.w7);
        let l2w9 = fq_bigint3.mul(yInv[k], l2.w9);
        local l2f: E12full034 = E12full034(l2w1, l2w3, l2w7, l2w9);
        // Qacc[k] ← Qacc[k]+Q[k] and
        // l1 the line ℓ passing Qacc[k] and Q[k]

        let (new_Q: G2Point*, l1: E12full034*) = g2.add_step(Qacc[offset + k], Qacc[k]);
        assert Qacc[offset + n_points + k] = new_Q;

        // line evaluation at P[k]
        let l1w1 = fq_bigint3.mul(xOverY[k], l1.w1);
        let l1w3 = fq_bigint3.mul(yInv[k], l1.w3);
        let l1w7 = fq_bigint3.mul(xOverY[k], l1.w7);
        let l1w9 = fq_bigint3.mul(yInv[k], l1.w9);
        local l1f: E12full034 = E12full034(l1w1, l1w3, l1w7, l1w9);

        // l*l
        let prod_lines = e12_tricks.mul034_034(&l1f, &l2f);

        // res = res * l*l
        let res = e12_tricks.mul01234(res, prod_lines);

        return i63_loop(k + 1, n_points, offset, res);
    }
}

// Double step Qacc[offset+k] for k in [0, n_points)
// Store the doubled point in Qacc[offset+n_points+k]
// Store the line evaluation at P[k] in lines_r0[k] and lines_r1[k]
func double_step_loop{range_check_ptr, Qacc: G2Point**, xOverY: BigInt3*, yInv: BigInt3*}(
    k: felt, n_points: felt, offset: felt, lines: E12full034**
) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    if (k == n_points) {
        return ();
    } else {
        let (new_Q: G2Point*, l1: E12full034*) = g2.double_step(Qacc[offset + k]);
        assert Qacc[offset + n_points + k] = new_Q;

        let l1w1 = fq_bigint3.mul(xOverY[k], l1.w1);
        let l1w3 = fq_bigint3.mul(yInv[k], l1.w3);
        let l1w7 = fq_bigint3.mul(xOverY[k], l1.w7);
        let l1w9 = fq_bigint3.mul(yInv[k], l1.w9);
        local l1f: E12full034 = E12full034(l1w1, l1w3, l1w7, l1w9);
        assert lines[k] = &l1f;
        return double_step_loop(k + 1, n_points, offset, lines);
    }
}

func i64_loop{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    Qacc: G2Point**,
    xOverY: BigInt3*,
    yInv: BigInt3*,
    poly_acc_034: PolyAcc034*,
    poly_acc_034034: PolyAcc034034*,
    continuable_hash: felt,
    z_pow1_11_ptr: ZPowers11*,
}(k: felt, offset: felt, n_points: felt, res: E12D*) -> E12D* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    if (k == n_points) {
        if (n_points == 1) {
            local rest: E12D = E12D(
                BigInt3(1, 0, 0),
                res.w0,
                BigInt3(0, 0, 0),
                res.w1,
                BigInt3(0, 0, 0),
                BigInt3(0, 0, 0),
                BigInt3(0, 0, 0),
                res.w2,
                BigInt3(0, 0, 0),
                res.w3,
                BigInt3(0, 0, 0),
                BigInt3(0, 0, 0),
            );
            return &rest;
        } else {
            return res;
        }
    } else {
        let (new_Q: G2Point*, l1: E12full034*) = g2.double_step(Qacc[k]);
        assert Qacc[offset + k] = new_Q;
        let l1w1 = fq_bigint3.mul(xOverY[k], l1.w1);
        let l1w3 = fq_bigint3.mul(yInv[k], l1.w3);
        let l1w7 = fq_bigint3.mul(xOverY[k], l1.w7);
        let l1w9 = fq_bigint3.mul(yInv[k], l1.w9);
        local l1f: E12full034 = E12full034(l1w1, l1w3, l1w7, l1w9);
        if (k == 1) {
            // k = 1, separately to avoid MulBy034 (res × ℓ)
            // (res is also a line at this point, so we use Mul034By034 ℓ × ℓ)

            let res_t01234 = e12_tricks.mul034_034(&l1f, cast(res, E12full034*));
            local rest: E12D = E12D(
                res_t01234.w0,
                res_t01234.w1,
                res_t01234.w2,
                res_t01234.w3,
                res_t01234.w4,
                BigInt3(0, 0, 0),
                res_t01234.w6,
                res_t01234.w7,
                res_t01234.w8,
                res_t01234.w9,
                res_t01234.w10,
                res_t01234.w11,
            );
            return i64_loop(k + 1, offset, n_points, &rest);
        } else {
            let res = e12_tricks.mul034(res, &l1f);
            return i64_loop(k + 1, offset, n_points, res);
        }
    }
}

func mul_lines_two_by_two{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    poly_acc_034034: PolyAcc034034*,
    poly_acc_12: PolyAcc12*,
    continuable_hash: felt,
    z_pow1_11_ptr: ZPowers11*,
}(k: felt, n: felt, lines: E12full034**, res: E12D*) -> E12D* {
    alloc_locals;
    if (k == n) {
        return res;
    } else {
        if (k == n + 1) {
            return res;
        } else {
            let prod_lines = e12_tricks.mul034_034(lines[k], lines[k - 1]);
            let res = e12_tricks.mul01234(res, prod_lines);
            return mul_lines_two_by_two(k + 2, n, lines, res);
        }
    }
}
func initialize_arrays_and_constants{
    range_check_ptr, Qacc: G2Point**, Q_neg: G2Point**, yInv: BigInt3*, xOverY: BigInt3*
}(P: G1Point**, Q: G2Point**, n_points: felt, k: felt) {
    alloc_locals;
    if (k == n_points) {
        return ();
    } else {
        let neg_Q = g2.neg(Q[k]);
        let y_inv = fq_bigint3.inv(P[k].y);
        let x_over_y = fq_bigint3.mul(P[k].x, y_inv);
        let x_over_y = fq_bigint3.neg(x_over_y);
        assert Qacc[k] = Q[k];
        assert Q_neg[k] = neg_Q;
        assert yInv[k] = y_inv;
        assert xOverY[k] = x_over_y;
        return initialize_arrays_and_constants(P, Q, n_points, k + 1);
    }
}

func final_exponentiation{
    range_check_ptr, bitwise_ptr: BitwiseBuiltin*, poseidon_ptr: PoseidonBuiltin*
}(z: E12*, unsafe: felt) -> E12D* {
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
    tempvar continuable_hash = 'GaragaBN254FinalExp';
    local Z: BigInt3;
    %{
        from src.bn254.pairing_final_exp import final_exponentiation
        from starkware.cairo.common.math_utils import as_int
        from tools.py.extension_trick import pack_e12
        f_input = 12*[0]
        input_refs =[ids.z.c0.b0.a0, ids.z.c0.b0.a1, ids.z.c0.b1.a0, ids.z.c0.b1.a1, ids.z.c0.b2.a0, ids.z.c0.b2.a1,
        ids.z.c1.b0.a0, ids.z.c1.b0.a1, ids.z.c1.b1.a0, ids.z.c1.b1.a1, ids.z.c1.b2.a0, ids.z.c1.b2.a1]

        for i in range(ids.N_LIMBS):
            for k in range(12):
                f_input[k] += as_int(getattr(input_refs[k], "d" + str(i)), PRIME) * ids.BASE**i
        f_input = pack_e12(f_input)
        print("Pre-computing final exp hash commitment Z = poseidon('GaragaBN254FinalExp', [(A1, B1, Q1, R1), ..., (An, Bn, Qn, Rn)])")
        _, Z = final_exponentiation(f_input, unsafe=ids.unsafe, continuable_hash=ids.continuable_hash)
        Z_bigint3 = split(Z)
        ids.Z.d0, ids.Z.d1, ids.Z.d2 = Z_bigint3[0], Z_bigint3[1], Z_bigint3[2]
    %}
    assert_reduced_felt(Z);
    local zero_e6full: E6DirectUnreduced = E6DirectUnreduced(
        UnreducedBigInt3(0, 0, 0),
        UnreducedBigInt3(0, 0, 0),
        UnreducedBigInt3(0, 0, 0),
        UnreducedBigInt3(0, 0, 0),
        UnreducedBigInt3(0, 0, 0),
        UnreducedBigInt3(0, 0, 0),
    );

    local zero_e5full: E5full = E5full(
        Uint256(0, 0), Uint256(0, 0), Uint256(0, 0), Uint256(0, 0), Uint256(0, 0)
    );

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

        let c_num_full = gnark_to_v_reduced(z.c0);
        let c_num_full = e6.neg_full(c_num_full);
        let z_c1_full = gnark_to_v_reduced(z_c1);

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

        local final_res: E12D*;
        if (unsafe != 0) {
            let rest = e6.mul_torus(t2, t0);
            let res = decompress_torus_full(rest);
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
                    let res = decompress_torus_full(rest);
                    assert final_res = res;
                    tempvar range_check_ptr = range_check_ptr;
                    tempvar bitwise_ptr = bitwise_ptr;
                    tempvar poseidon_ptr = poseidon_ptr;
                    tempvar continuable_hash = continuable_hash;
                    tempvar poly_acc = poly_acc;
                    tempvar poly_acc_sq = poly_acc_sq;
                    tempvar z_pow1_5_ptr = z_pow1_5_ptr;
                } else {
                    let res = e12.one_full();
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
                let res = e12.one_full();
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

        // %{ print(f"hash={ids.continuable_hash}") %}

        let (local Z: BigInt3) = felt_to_bigint3(continuable_hash);
        %{ print(f"Verifying final exponentiation hash commitment Z = continuable_hash") %}
        assert Z.d0 - z_pow1_5_ptr.z_1.d0 = 0;
        assert Z.d1 - z_pow1_5_ptr.z_1.d1 = 0;
        assert Z.d2 - z_pow1_5_ptr.z_1.d2 = 0;
        %{ print(f"Verifying Σc_i*A_i(z)*B_i(z) == P(z)Σc_i*Q_i(z) + Σc_i*R_i(z)") %}
        verify_6th_extension_tricks();
        %{ print(f"Ok!") %}

        return final_res;
    }
}

// decompresses x ∈ E6 to (y+w)/(y-w) ∈ E12
func decompress_torus_full{range_check_ptr, poseidon_ptr: PoseidonBuiltin*}(x: E6full*) -> E12D* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local num: E12D = E12D(
        w0=x.v0,
        w1=BigInt3(1, 0, 0),
        w2=x.v1,
        w3=BigInt3(0, 0, 0),
        w4=x.v2,
        w5=BigInt3(0, 0, 0),
        w6=x.v3,
        w7=BigInt3(0, 0, 0),
        w8=x.v4,
        w9=BigInt3(0, 0, 0),
        w10=x.v5,
        w11=BigInt3(0, 0, 0),
    );

    local den: E12D = E12D(
        w0=num.w0,
        w1=BigInt3(-1, 0, 0),
        w2=num.w2,
        w3=num.w3,
        w4=num.w4,
        w5=num.w5,
        w6=num.w6,
        w7=num.w7,
        w8=num.w8,
        w9=num.w9,
        w10=num.w10,
        w11=num.w11,
    );

    let res = e12.div_full(&num, &den);
    return res;
}

// Canonical signed digit decomposition (Non-Adjacent form) of 6x₀+2 = 29793968203157093288  little endian
func get_NAF_digit(index: felt) -> felt {
    let (_, pc) = get_fp_and_pc();

    pc_label:
    let data = pc + (bits - pc_label);
    let res = [data + index];

    return res;

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
