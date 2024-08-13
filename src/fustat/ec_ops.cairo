from definitions import (
    is_zero_mod_P,
    get_P,
    G1Point,
    get_b,
    get_a,
    get_b2,
    get_fp_gen,
    verify_zero4,
    G1Point_eq_zero,
    BASE,
    N_LIMBS,
)
from precompiled_circuits.ec import (
    get_IS_ON_CURVE_G1_G2_circuit,
    get_IS_ON_CURVE_G1_circuit,
    get_DERIVE_POINT_FROM_X_circuit,
    get_SLOPE_INTERCEPT_SAME_POINT_circuit,
    get_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit,
    get_RHS_FINALIZE_ACC_circuit,
    get_EVAL_FUNCTION_CHALLENGE_DUPL_circuit,
    get_ADD_EC_POINT_circuit,
    get_DOUBLE_EC_POINT_circuit,
)
from starkware.cairo.common.uint256 import Uint256

from modulo_circuit import run_modulo_circuit, ModuloCircuit
from starkware.cairo.common.cairo_builtins import ModBuiltin, UInt384, PoseidonBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.builtin_poseidon.poseidon import poseidon_hash, poseidon_hash_many

from utils import (
    felt_to_UInt384,
    sign_to_UInt384,
    neg_3_pow_alloc_80,
    scalars_to_epns_low_high,
    hash_full_transcript_and_get_Z,
)

func is_on_curve_g1{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(curve_id: felt, point: G1Point) -> (res: felt) {
    alloc_locals;
    let (P) = get_P(curve_id);
    let (A) = get_a(curve_id);
    let (B) = get_b(curve_id);
    let (circuit) = get_IS_ON_CURVE_G1_circuit(curve_id);
    let (input: UInt384*) = alloc();
    assert input[0] = point.x;
    assert input[1] = point.y;
    assert input[2] = A;
    assert input[3] = B;
    let (output: felt*) = run_modulo_circuit(circuit, input);
    let (check_g1: felt) = is_zero_mod_P([cast(output, UInt384*)], P);
    return (res=check_g1);
}
func is_on_curve_g1_g2{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(curve_id: felt, input: felt*) -> (res: felt) {
    alloc_locals;
    let (P) = get_P(curve_id);

    let (circuit) = get_IS_ON_CURVE_G1_G2_circuit(curve_id);
    let (input_full: UInt384*) = alloc();
    memcpy(cast(input_full, felt*), input, 6 * N_LIMBS);
    let (a) = get_a(curve_id);
    let (b) = get_b(curve_id);
    let (b20, b21) = get_b2(curve_id);
    assert input_full[6] = a;
    assert input_full[7] = b;
    assert input_full[8] = b20;
    assert input_full[9] = b21;

    let (output: felt*) = run_modulo_circuit(circuit, cast(input_full, felt*));
    let (check_g1: felt) = is_zero_mod_P([cast(output, UInt384*)], P);
    let (check_g20: felt) = is_zero_mod_P([cast(output + UInt384.SIZE, UInt384*)], P);
    let (check_g21: felt) = is_zero_mod_P([cast(output + 2 * UInt384.SIZE, UInt384*)], P);

    if (check_g1 == 0) {
        return (res=0);
    }
    if (check_g20 == 0) {
        return (res=0);
    }
    if (check_g21 == 0) {
        return (res=0);
    }
    return (res=1);
}

// Add two EC points. Doesn't check if the inputs are on curve nor if they are the point at infinity.
func add_ec_points{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(curve_id: felt, P: G1Point, Q: G1Point) -> (res: G1Point) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (local modulus: UInt384) = get_P(curve_id);
    let (same_x) = is_zero_mod_P(
        UInt384(P.x.d0 - Q.x.d0, P.x.d1 - Q.x.d1, P.x.d2 - Q.x.d2, P.x.d3 - Q.x.d3), modulus
    );

    if (same_x != 0) {
        let (opposite_y) = is_zero_mod_P(
            UInt384(P.y.d0 + Q.y.d0, P.y.d1 + Q.y.d1, P.y.d2 + Q.y.d2, P.y.d3 + Q.y.d3), modulus
        );

        if (opposite_y != 0) {
            return (res=G1Point(UInt384(0, 0, 0, 0), UInt384(0, 0, 0, 0)));
        } else {
            let (circuit) = get_DOUBLE_EC_POINT_circuit(curve_id);
            let (A) = get_a(curve_id);
            let (input: UInt384*) = alloc();
            assert input[0] = P.x;
            assert input[1] = P.y;
            assert input[2] = A;
            let (res) = run_modulo_circuit(circuit, cast(input, felt*));
            return (res=[cast(res, G1Point*)]);
        }
    } else {
        let (circuit) = get_ADD_EC_POINT_circuit(curve_id);
        let (input: UInt384*) = alloc();
        assert input[0] = P.x;
        assert input[1] = P.y;
        assert input[2] = Q.x;
        assert input[3] = Q.y;
        let (res) = run_modulo_circuit(circuit, cast(input, felt*));
        return (res=[cast(res, G1Point*)]);
    }
}

struct DerivePointFromXOutput {
    rhs: UInt384,  // x^3 + ax + b
    grhs: UInt384,  // g * (x^3+ax+b)
    should_be_rhs: UInt384,
    should_be_grhs: UInt384,
    y_try: UInt384,
}

func derive_EC_point_from_entropy{
    range_check_ptr,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
}(curve_id: felt, entropy: felt, attempt: felt) -> (res: G1Point) {
    // %{ print(f"Attempt : {ids.attempt}") %}
    if (entropy == 0) {
        // If x coordinate is 0 (extremely unlikely), retry directly.
        assert poseidon_ptr[0].input.s0 = entropy;
        assert poseidon_ptr[0].input.s1 = attempt;
        assert poseidon_ptr[0].input.s2 = 2;
        let new_entropy = poseidon_ptr[0].output.s0;
        let poseidon_ptr = poseidon_ptr + PoseidonBuiltin.SIZE;
        return derive_EC_point_from_entropy(curve_id, new_entropy, attempt + 1);
    }
    alloc_locals;
    local rhs_from_x_is_a_square_residue: felt;
    %{
        from starkware.python.math_utils import is_quad_residue
        from garaga.definitions import CURVES
        a = CURVES[ids.curve_id].a
        b = CURVES[ids.curve_id].b
        p = CURVES[ids.curve_id].p
        rhs = (ids.entropy**3 + a*ids.entropy + b) % p
        ids.rhs_from_x_is_a_square_residue = is_quad_residue(rhs, p)
    %}
    let (x_384: UInt384) = felt_to_UInt384(entropy);
    let (a_weirstrass) = get_a(curve_id);
    let (b_Weirstrass: UInt384) = get_b(curve_id);
    let (fp_generator: UInt384) = get_fp_gen(curve_id);
    let (P: UInt384) = get_P(curve_id);
    let (circuit) = get_DERIVE_POINT_FROM_X_circuit(curve_id);

    let (input: UInt384*) = alloc();
    assert input[0] = x_384;
    assert input[1] = a_weirstrass;
    assert input[2] = b_Weirstrass;
    assert input[3] = fp_generator;

    let (output_array: felt*) = run_modulo_circuit(circuit, cast(input, felt*));
    let output: DerivePointFromXOutput* = cast(output_array, DerivePointFromXOutput*);

    if (rhs_from_x_is_a_square_residue != 0) {
        // Assert should_be_rhs == rhs
        verify_zero4(
            UInt384(
                output.rhs.d0 - output.should_be_rhs.d0,
                output.rhs.d1 - output.should_be_rhs.d1,
                output.rhs.d2 - output.should_be_rhs.d2,
                output.rhs.d3 - output.should_be_rhs.d3,
            ),
            P,
        );
        return (res=G1Point(x_384, output.y_try));
    } else {
        // Assert should_be_grhs == grhs & Retry.
        verify_zero4(
            UInt384(
                output.grhs.d0 - output.should_be_grhs.d0,
                output.grhs.d1 - output.should_be_grhs.d1,
                output.grhs.d2 - output.should_be_grhs.d2,
                output.grhs.d3 - output.should_be_grhs.d3,
            ),
            P,
        );
        assert poseidon_ptr[0].input.s0 = entropy;
        assert poseidon_ptr[0].input.s1 = attempt;
        assert poseidon_ptr[0].input.s2 = 2;
        let new_entropy = poseidon_ptr[0].output.s0;
        let poseidon_ptr = poseidon_ptr + PoseidonBuiltin.SIZE;
        return derive_EC_point_from_entropy(curve_id, new_entropy, attempt + 1);
    }
}

struct SlopeInterceptOutput {
    m_A0: UInt384,
    b_A0: UInt384,
    xA0: UInt384,
    yA0: UInt384,
    xA2: UInt384,
    yA2: UInt384,
    coeff0: UInt384,
    coeff2: UInt384,
}

func compute_slope_intercept_same_point{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(curve_id: felt, point: G1Point) -> (res: SlopeInterceptOutput*) {
    alloc_locals;
    let (circuit) = get_SLOPE_INTERCEPT_SAME_POINT_circuit(curve_id);
    let (A_weirstrass) = get_a(curve_id);
    let (input: UInt384*) = alloc();
    assert input[0] = point.x;
    assert input[1] = point.y;
    assert input[2] = A_weirstrass;
    let (output_array: felt*) = run_modulo_circuit(circuit, cast(input, felt*));
    let output: SlopeInterceptOutput* = cast(output_array, SlopeInterceptOutput*);
    return (res=output);
}

// Compute RHS of eq 3 in https://eprint.iacr.org/2022/596.pdf , without accounting for result point
func compute_RHS_basis_sum{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(
    curve_id: felt,
    acc_circuit: ModuloCircuit*,
    points: G1Point*,
    scalars_epns: felt*,
    index: felt,
    n: felt,
    sum: UInt384,
    constants: SlopeInterceptOutput*,
) -> (res: UInt384) {
    alloc_locals;
    if (index == n) {
        return (res=sum);
    }
    let (local input: UInt384*) = alloc();
    assert input[0] = sum;  // Copy previous sum to accumulate.
    // Copy only m_A0, b_A0, xA0 from SlopeInterceptOutput struct.
    memcpy(input + UInt384.SIZE, cast(constants, felt*), UInt384.SIZE * 3);
    // Copy i-th point.
    memcpy(
        input + UInt384.SIZE + 3 * UInt384.SIZE,
        cast(points + G1Point.SIZE * index, felt*),
        G1Point.SIZE,
    );
    // Copy i-th scalar's positive and negative parts.
    let (ep) = felt_to_UInt384([scalars_epns]);
    let (en) = felt_to_UInt384([scalars_epns + 1]);
    let (sp) = sign_to_UInt384([scalars_epns + 2], curve_id);
    let (sn) = sign_to_UInt384([scalars_epns + 3], curve_id);

    // %{
    //     from garaga.hints.io import bigint_pack
    //     print(f"RHS INDEX : {ids.index}")
    //     print(f"ep: {bigint_pack(ids.ep, 4, 2**96)}")
    //     print(f"en: {bigint_pack(ids.en, 4, 2**96)}")
    //     print(f"sp: {bigint_pack(ids.sp, 4, 2**96)}")
    //     print(f"sn: {bigint_pack(ids.sn, 4, 2**96)}")
    // %}
    assert input[6] = ep;
    assert input[7] = en;
    assert input[8] = sp;
    assert input[9] = sn;

    let (circuit_output: felt*) = run_modulo_circuit(acc_circuit, cast(input, felt*));
    let new_sum = [cast(circuit_output, UInt384*)];
    // %{
    //     from garaga.hints.io import bigint_pack
    //     print(f"rhs_acc_intermediate: {bigint_pack(ids.new_sum, 4, 2**96)}")
    // %}

    return compute_RHS_basis_sum(
        curve_id=curve_id,
        acc_circuit=acc_circuit,
        points=points,
        scalars_epns=scalars_epns + 4,
        index=index + 1,
        n=n,
        sum=new_sum,
        constants=constants,
    );
}

// Finalize RHS computation of eq 3 in https://eprint.iacr.org/2022/596.pdf , accounting for the result point (-Q)
func finalize_RHS{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(acc_circuit: ModuloCircuit*, Q: G1Point, sum: UInt384, constants: SlopeInterceptOutput*) -> (
    res: UInt384
) {
    alloc_locals;
    let (local input: UInt384*) = alloc();
    assert input[0] = sum;  // Copy previous sum to accumulate.
    // Copy only m_A0, b_A0, xA0 from SlopeInterceptOutput struct.
    memcpy(input + UInt384.SIZE, cast(constants, felt*), UInt384.SIZE * 3);
    // Copy Q.
    assert input[4] = Q.x;
    assert input[5] = Q.y;

    let (circuit_output: felt*) = run_modulo_circuit(acc_circuit, cast(input, felt*));
    let RHS = [cast(circuit_output, UInt384*)];

    return (res=RHS);
}

// A function field element of the form :
// F(x,y) = a(x) + y b(x)
// Where a, b are rational functions of x.
// The rational functions are represented as polynomials in x with coefficients in F_p, starting from the constant term.
// No information about the degrees of the polynomials is stored here as they are derived implicitely from the MSM size.
struct FunctionFelt {
    a_num: UInt384*,
    a_den: UInt384*,
    b_num: UInt384*,
    b_den: UInt384*,
}

func hash_sum_dlog_div{poseidon_ptr: PoseidonBuiltin*}(
    f: FunctionFelt, msm_size: felt, init_hash: felt, curve_id: felt
) -> (res: felt) {
    alloc_locals;
    let (Z: felt) = hash_full_transcript_and_get_Z(
        limbs_ptr=cast(f.a_num, felt*), n=msm_size + 1, init_hash=init_hash, curve_id=curve_id
    );
    let (Z: felt) = hash_full_transcript_and_get_Z(
        limbs_ptr=cast(f.a_den, felt*), n=msm_size + 2, init_hash=Z, curve_id=curve_id
    );
    let (Z: felt) = hash_full_transcript_and_get_Z(
        limbs_ptr=cast(f.b_num, felt*), n=msm_size + 2, init_hash=Z, curve_id=curve_id
    );
    let (Z: felt) = hash_full_transcript_and_get_Z(
        limbs_ptr=cast(f.b_den, felt*), n=msm_size + 5, init_hash=Z, curve_id=curve_id
    );

    return (res=Z);
}

func msm{
    range_check_ptr,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
}(curve_id: felt, points: G1Point*, scalars: Uint256*, n: felt) -> (res: G1Point) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    // Prepare epns from scalars.
    let (local neg_3_pows: felt*) = neg_3_pow_alloc_80();
    let (local epns_low: felt*, epns_high: felt*) = scalars_to_epns_low_high(
        scalars, n, neg_3_pows
    );
    let (local epns_shifted: felt*) = alloc();
    // 2**128
    assert epns_shifted[0] = 5279154705627724249993186093248666011;  // negative
    assert epns_shifted[1] = 345561521626566187713367793525016877467;  // negative
    assert epns_shifted[2] = -1;  // sign
    assert epns_shifted[3] = -1;  // sign

    // Final MSM result is Q_low + (2^128 * Q_high) = Q_low + Q_high_shifted.
    local Q_low: G1Point;
    local Q_high: G1Point;
    local Q_high_shifted: G1Point;
    local SumDlogDivLow: FunctionFelt;
    local SumDlogDivHigh: FunctionFelt;
    local SumDlogDivShifted: FunctionFelt;
    %{
        from garaga.hints.ecip import zk_ecip_hint
        from garaga.hints.io import pack_bigint_ptr, pack_felt_ptr, fill_sum_dlog_div, fill_g1_point
        from garaga.hints.neg_3 import construct_digit_vectors
        from garaga.definitions import G1Point
        import time
        curve_id = CurveID(ids.curve_id)
        points = pack_bigint_ptr(memory, ids.points._reference_value, ids.N_LIMBS, ids.BASE, 2*ids.n)
        points = [G1Point(points[i], points[i+1], curve_id) for i in range(0, len(points), 2)]
        scalars = pack_felt_ptr(memory, ids.scalars._reference_value, 2*ids.n)
        scalars_low, scalars_high = scalars[0::2], scalars[1::2]
        print(f"\nComputing MSM with {ids.n} input points!")
        t0=time.time()
        print(f"Deriving the Sums of logarithmic derivatives of elliptic curve Diviors interpolating the {ids.n} input points with multiplicities...")
        Q_low, SumDlogDivLow = zk_ecip_hint(points, scalars_low)
        Q_high, SumDlogDivHigh = zk_ecip_hint(points, scalars_high)
        Q_high_shifted, SumDlogDivShifted = zk_ecip_hint([Q_high], [2**128])

        print(f"Time taken: {time.time() - t0}s")
        print(f"Filling Function Field elements and results point")
        t0=time.time()
        fill_sum_dlog_div(SumDlogDivLow, ids.n, ids.SumDlogDivLow, segments)
        fill_sum_dlog_div(SumDlogDivHigh, ids.n, ids.SumDlogDivHigh, segments)
        fill_sum_dlog_div(SumDlogDivShifted, 1, ids.SumDlogDivShifted, segments)

        fill_g1_point((Q_low.x, Q_low.y), ids.Q_low)
        fill_g1_point((Q_high.x, Q_high.y), ids.Q_high)
        fill_g1_point((Q_high_shifted.x, Q_high_shifted.y), ids.Q_high_shifted)

        print(f"Hashing Z = Poseidon(Input, Commitments) = Hash(Points, scalars, Q_low, Q_high, Q_high_shifted, SumDlogDivLow, SumDlogDivHigh, SumDlogDivShifted)...")
    %}
    let (is_on_curve_low: felt) = is_on_curve_g1(curve_id, Q_low);
    let (is_on_curve_high: felt) = is_on_curve_g1(curve_id, Q_high);
    let (is_on_curve_shifted: felt) = is_on_curve_g1(curve_id, Q_high_shifted);
    assert is_on_curve_low = 1;
    assert is_on_curve_high = 1;
    assert is_on_curve_shifted = 1;

    let (Z: felt) = hash_full_transcript_and_get_Z(
        limbs_ptr=cast(points, felt*), n=n * 2, init_hash='MSM', curve_id=curve_id
    );
    let (Z: felt) = hash_full_transcript_and_get_Z(
        limbs_ptr=cast(&Q_low, felt*), n=2, init_hash=Z, curve_id=curve_id
    );
    let (Z: felt) = hash_full_transcript_and_get_Z(
        limbs_ptr=cast(&Q_high, felt*), n=2, init_hash=Z, curve_id=curve_id
    );
    let (Z: felt) = hash_full_transcript_and_get_Z(
        limbs_ptr=cast(&Q_high_shifted, felt*), n=2, init_hash=Z, curve_id=curve_id
    );
    let (Zt: felt) = poseidon_hash_many(2 * n, cast(scalars, felt*));
    let (Z: felt) = poseidon_hash(Zt, Z);
    let (Z: felt) = hash_sum_dlog_div(f=SumDlogDivLow, msm_size=n, init_hash=Z, curve_id=curve_id);
    let (Z: felt) = hash_sum_dlog_div(f=SumDlogDivHigh, msm_size=n, init_hash=Z, curve_id=curve_id);
    let (Z: felt) = hash_sum_dlog_div(
        f=SumDlogDivShifted, msm_size=1, init_hash=Z, curve_id=curve_id
    );

    %{ print(f"Deriving random EC point for challenge from Z...") %}
    // Sample random EC point for challenge.
    let (random_point: G1Point) = derive_EC_point_from_entropy(curve_id, Z, 0);

    // Get slope, intercept and other constants from random EC point
    let (local mb: SlopeInterceptOutput*) = compute_slope_intercept_same_point(
        curve_id, random_point
    );

    // Load circuits to compute LHS and RHS of ZK-ECIP equation.
    let (
        local acc_eval_pt_challenge_circuit: ModuloCircuit*
    ) = get_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(curve_id);

    let (local rhs_finalize_acc_circuit: ModuloCircuit*) = get_RHS_FINALIZE_ACC_circuit(curve_id);
    let (
        local eval_function_challenge_circuit: ModuloCircuit*
    ) = get_EVAL_FUNCTION_CHALLENGE_DUPL_circuit(curve_id, n);

    let (
        local eval_function_challenge_circuit_shifted: ModuloCircuit*
    ) = get_EVAL_FUNCTION_CHALLENGE_DUPL_circuit(curve_id, 1);

    %{ print(f"Verifying ZK-ECIP equations evaluated at the random point...") %}

    // Verify Q_low = sum(scalar_low * P for scalar_low,P in zip(scalars_low, points))
    let (Q_low_is_zero) = zk_ecip_check(
        curve_id=curve_id,
        points=points,
        epns=epns_low,
        Q=Q_low,
        n=n,
        mb=mb,
        eval_function_challenge_circuit=eval_function_challenge_circuit,
        acc_eval_pt_challenge_circuit=acc_eval_pt_challenge_circuit,
        rhs_finalize_acc_circuit=rhs_finalize_acc_circuit,
        sum_dlog_div=SumDlogDivLow,
    );

    // Verify Q_high = sum(scalar_high * P for scalar_high,P in zip(scalars_high, points))
    let (_) = zk_ecip_check(
        curve_id=curve_id,
        points=points,
        epns=epns_high,
        Q=Q_high,
        n=n,
        mb=mb,
        eval_function_challenge_circuit=eval_function_challenge_circuit,
        acc_eval_pt_challenge_circuit=acc_eval_pt_challenge_circuit,
        rhs_finalize_acc_circuit=rhs_finalize_acc_circuit,
        sum_dlog_div=SumDlogDivHigh,
    );

    // Verify Q_high_shifted = 2^128 * Q_high
    let (Q_high_shifted_is_zero) = zk_ecip_check(
        curve_id=curve_id,
        points=&Q_high,
        epns=epns_shifted,
        Q=Q_high_shifted,
        n=1,
        mb=mb,
        eval_function_challenge_circuit=eval_function_challenge_circuit_shifted,
        acc_eval_pt_challenge_circuit=acc_eval_pt_challenge_circuit,
        rhs_finalize_acc_circuit=rhs_finalize_acc_circuit,
        sum_dlog_div=SumDlogDivShifted,
    );
    %{ print(f"MSM Verification complete!\n Computing result = Q_low + Q_high_shifted") %}

    if (Q_low_is_zero != 0) {
        if (Q_high_shifted_is_zero != 0) {
            // Both are 0. Return 0.
            return (res=Q_low);
        } else {
            // Q_low is 0. Return Q_high_shifted directly.
            return (res=Q_high_shifted);
        }
    } else {
        if (Q_high_shifted_is_zero != 0) {
            // Q_high_shifted is 0. Return Q_low directly.
            return (res=Q_low);
        } else {
            let (res) = add_ec_points(curve_id, Q_low, Q_high_shifted);
            return (res=res);
        }
    }
}

// Compute LHS of eq 3 in https://eprint.iacr.org/2022/596.pdf
// Uses sum_dlog_div = sum((-3)^j * Dlog(Dj) for j in [0, 81]).
func compute_LHS{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(
    eval_function_challenge_circuit: ModuloCircuit*,
    sum_dlog_div: FunctionFelt,
    n: felt,
    constants: SlopeInterceptOutput*,
) -> (res: UInt384) {
    alloc_locals;
    let (local input: felt*) = alloc();
    // Copy xA0, yA0, xA2, yA2, coeff0, coeff2 from SlopeInterceptOutput struct.
    memcpy(input, cast(constants, felt*) + UInt384.SIZE * 2, UInt384.SIZE * 6);

    // Copy a_num, a_den, b_num, b_den from FunctionFelt struct.
    // Number of coefficients is static from msm size.
    memcpy(input + UInt384.SIZE * 6, cast(sum_dlog_div.a_num, felt*), UInt384.SIZE * (n + 1));
    memcpy(
        input + UInt384.SIZE * (6 + 1 + n), cast(sum_dlog_div.a_den, felt*), UInt384.SIZE * (n + 2)
    );
    memcpy(
        input + UInt384.SIZE * (6 + 1 + 2 + 2 * n),
        cast(sum_dlog_div.b_num, felt*),
        UInt384.SIZE * (n + 2),
    );
    memcpy(
        input + UInt384.SIZE * (6 + 1 + 2 + 2 + 3 * n),
        cast(sum_dlog_div.b_den, felt*),
        UInt384.SIZE * (n + 5),
    );

    let (circuit_output: felt*) = run_modulo_circuit(eval_function_challenge_circuit, input);
    let LHS = [cast(circuit_output, UInt384*)];
    return (res=LHS);
}
func zk_ecip_check{
    range_check_ptr,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
}(
    curve_id: felt,
    points: G1Point*,
    epns: felt*,
    Q: G1Point,
    n: felt,
    mb: SlopeInterceptOutput*,
    eval_function_challenge_circuit: ModuloCircuit*,
    acc_eval_pt_challenge_circuit: ModuloCircuit*,
    rhs_finalize_acc_circuit: ModuloCircuit*,
    sum_dlog_div: FunctionFelt,
) -> (Q_is_zero: felt) {
    alloc_locals;
    let (Q_is_zero) = G1Point_eq_zero(Q);
    let (LHS) = compute_LHS(
        eval_function_challenge_circuit=eval_function_challenge_circuit,
        sum_dlog_div=sum_dlog_div,
        n=n,
        constants=mb,
    );
    let (basis_sum: UInt384) = compute_RHS_basis_sum(
        curve_id=curve_id,
        acc_circuit=acc_eval_pt_challenge_circuit,
        points=points,
        scalars_epns=epns,
        index=0,
        n=n,
        sum=UInt384(0, 0, 0, 0),
        constants=mb,
    );
    if (Q_is_zero == 1) {
        assert LHS = basis_sum;
        return (Q_is_zero=Q_is_zero);
    } else {
        let (RHS: UInt384) = finalize_RHS(
            acc_circuit=rhs_finalize_acc_circuit, Q=Q, sum=basis_sum, constants=mb
        );
        // %{
        //     from garaga.hints.io import bigint_pack
        //     print(f"LHS: {bigint_pack(ids.LHS, 4, 2**96)}")
        //     print(f"RHS: {bigint_pack(ids.RHS, 4, 2**96)}")
        // %}
        assert LHS = RHS;

        return (Q_is_zero=Q_is_zero);
    }
}

func msm_size_to_n_coeffs(n_points: felt) -> (
    a_num_coeffs: felt, a_den_coeffs: felt, b_num_coeffs: felt, b_den_coeffs: felt
) {
    return (
        a_num_coeffs=n_points + 1,
        a_den_coeffs=n_points + 2,
        b_num_coeffs=n_points + 2,
        b_den_coeffs=n_points + 5,
    );
}
