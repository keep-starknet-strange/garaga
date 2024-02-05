from starkware.cairo.common.cairo_secp.bigint import (
    BigInt3,
    UnreducedBigInt3,
    nondet_bigint3,
    UnreducedBigInt5,
    bigint_mul,
)
from starkware.cairo.common.cairo_secp.constants import BASE
from src.bn254.fq import (
    is_zero,
    verify_zero5,
    fq_bigint3,
    N_LIMBS,
    DEGREE,
    assert_reduced_felt,
    bigint_sqr,
)
from src.bn254.curve import P0, P1, P2
from starkware.cairo.common.registers import get_fp_and_pc

// Represents a point on the elliptic curve.
struct G1Point {
    x: BigInt3,
    y: BigInt3,
}

namespace g1 {
    func assert_on_curve{range_check_ptr}(pt: G1Point*) -> () {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        assert_reduced_felt(pt.x);
        assert_reduced_felt(pt.y);

        let left = fq_bigint3.mul(pt.y, pt.y);
        let x_sq = fq_bigint3.mul(pt.x, pt.x);
        let x_cube = fq_bigint3.mul(x_sq, pt.x);

        assert left.d0 = x_cube.d0 + 3;
        assert left.d1 = x_cube.d1;
        assert left.d2 = x_cube.d2;

        return ();
    }
    func assert_equal(pt1: G1Point*, pt2: G1Point*) -> () {
        assert 0 = pt1.x.d0 - pt2.x.d0;
        assert 0 = pt1.x.d1 - pt2.x.d1;
        assert 0 = pt1.x.d2 - pt2.x.d2;
        assert 0 = pt1.y.d0 - pt2.y.d0;
        assert 0 = pt1.y.d1 - pt2.y.d1;
        assert 0 = pt1.y.d2 - pt2.y.d2;
        return ();
    }
    func compute_doubling_slope{range_check_ptr}(pt: G1Point) -> (slope: BigInt3) {
        // Note that y cannot be zero: assume that it is, then pt = -pt, so 2 * pt = 0, which
        // contradicts the fact that the size of the curve is odd.
        alloc_locals;
        local slope: BigInt3;
        %{
            from starkware.python.math_utils import div_mod
            from src.hints.fq import bigint_pack, bigint_fill, get_p
            assert 1 < ids.N_LIMBS <= 12
            assert ids.DEGREE == ids.N_LIMBS-1

            x = bigint_pack(ids.pt.x, ids.N_LIMBS, ids.BASE)
            y = bigint_pack(ids.pt.y, ids.N_LIMBS, ids.BASE)
            p = get_p(ids)

            slope = div_mod(3 * x ** 2, 2 * y, p)

            bigint_fill(slope, ids.slope, ids.N_LIMBS, ids.BASE)
        %}
        assert_reduced_felt(slope);

        let (x_sqr: UnreducedBigInt5) = bigint_sqr(pt.x);
        let (slope_y: UnreducedBigInt5) = bigint_mul(slope, pt.y);
        verify_zero5(
            UnreducedBigInt5(
                d0=3 * x_sqr.d0 - 2 * slope_y.d0,
                d1=3 * x_sqr.d1 - 2 * slope_y.d1,
                d2=3 * x_sqr.d2 - 2 * slope_y.d2,
                d3=3 * x_sqr.d3 - 2 * slope_y.d3,
                d4=3 * x_sqr.d4 - 2 * slope_y.d4,
            ),
        );

        return (slope=slope);
    }

    // Returns the slope of the line connecting the two given points.
    // The slope is used to compute pt0 + pt1.
    // Assumption: pt0.x != pt1.x (mod field prime).
    func compute_slope{range_check_ptr}(pt0: G1Point, pt1: G1Point) -> (slope: BigInt3) {
        alloc_locals;
        local slope: BigInt3;
        %{
            from starkware.python.math_utils import div_mod
            from src.hints.fq import bigint_pack, bigint_fill, get_p
            assert 1 < ids.N_LIMBS <= 12
            p = get_p(ids)
            x0 = bigint_pack(ids.pt0.x, ids.N_LIMBS, ids.BASE)
            y0 = bigint_pack(ids.pt0.y, ids.N_LIMBS, ids.BASE)
            x1 = bigint_pack(ids.pt1.x, ids.N_LIMBS, ids.BASE)
            y1 = bigint_pack(ids.pt1.y, ids.N_LIMBS, ids.BASE)

            slope = div_mod(y0 - y1, x0 - x1, p)

            bigint_fill(slope, ids.slope, ids.N_LIMBS, ids.BASE)
        %}
        assert_reduced_felt(slope);

        let x_diff = BigInt3(
            d0=pt0.x.d0 - pt1.x.d0, d1=pt0.x.d1 - pt1.x.d1, d2=pt0.x.d2 - pt1.x.d2
        );
        let (x_diff_slope: UnreducedBigInt5) = bigint_mul(x_diff, slope);

        verify_zero5(
            UnreducedBigInt5(
                d0=x_diff_slope.d0 - pt0.y.d0 + pt1.y.d0,
                d1=x_diff_slope.d1 - pt0.y.d1 + pt1.y.d1,
                d2=x_diff_slope.d2 - pt0.y.d2 + pt1.y.d2,
                d3=x_diff_slope.d3,
                d4=x_diff_slope.d4,
            ),
        );

        return (slope,);
    }

    // Given a point 'pt' on the elliptic curve, computes pt + pt.
    func double{range_check_ptr}(pt: G1Point) -> (res: G1Point) {
        alloc_locals;
        if (pt.x.d0 == 0) {
            if (pt.x.d1 == 0) {
                if (pt.x.d2 == 0) {
                    return (pt,);
                }
            }
        }

        let (slope: BigInt3) = compute_doubling_slope(pt);
        let (slope_sqr: UnreducedBigInt5) = bigint_sqr(slope);

        local new_x: BigInt3;
        local new_y: BigInt3;
        %{
            from src.hints.fq import bigint_pack, bigint_fill, get_p
            assert 1 < ids.N_LIMBS <= 12

            p = get_p(ids)
            x = bigint_pack(ids.pt.x, ids.N_LIMBS, ids.BASE)
            y = bigint_pack(ids.pt.y, ids.N_LIMBS, ids.BASE)
            slope = bigint_pack(ids.slope, ids.N_LIMBS, ids.BASE)

            new_x = (pow(slope, 2, p) - 2 * x) % p
            new_y = (slope * (x - new_x) - y) % p

            bigint_fill(new_x, ids.new_x, ids.N_LIMBS, ids.BASE)
            bigint_fill(new_y, ids.new_y, ids.N_LIMBS, ids.BASE)
        %}
        assert_reduced_felt(new_x);
        assert_reduced_felt(new_y);

        verify_zero5(
            UnreducedBigInt5(
                d0=slope_sqr.d0 - new_x.d0 - 2 * pt.x.d0,
                d1=slope_sqr.d1 - new_x.d1 - 2 * pt.x.d1,
                d2=slope_sqr.d2 - new_x.d2 - 2 * pt.x.d2,
                d3=slope_sqr.d3,
                d4=slope_sqr.d4,
            ),
        );

        let (x_diff_slope: UnreducedBigInt5) = bigint_mul(
            BigInt3(d0=pt.x.d0 - new_x.d0, d1=pt.x.d1 - new_x.d1, d2=pt.x.d2 - new_x.d2), slope
        );

        verify_zero5(
            UnreducedBigInt5(
                d0=x_diff_slope.d0 - pt.y.d0 - new_y.d0,
                d1=x_diff_slope.d1 - pt.y.d1 - new_y.d1,
                d2=x_diff_slope.d2 - pt.y.d2 - new_y.d2,
                d3=x_diff_slope.d3,
                d4=x_diff_slope.d4,
            ),
        );

        return (G1Point(new_x, new_y),);
    }

    // Adds two points on the elliptic curve.
    // Assumption: pt0.x != pt1.x (however, pt0 = pt1 = 0 is allowed).
    // Note that this means that the function cannot be used if pt0 = pt1
    // (use ec_double() in this case) or pt0 = -pt1 (the result is 0 in this case).
    func fast_ec_add{range_check_ptr}(pt0: G1Point, pt1: G1Point) -> (res: G1Point) {
        alloc_locals;
        if (pt0.x.d0 == 0) {
            if (pt0.x.d1 == 0) {
                if (pt0.x.d2 == 0) {
                    return (pt1,);
                }
            }
        }
        if (pt1.x.d0 == 0) {
            if (pt1.x.d1 == 0) {
                if (pt1.x.d2 == 0) {
                    return (pt0,);
                }
            }
        }

        let (slope: BigInt3) = compute_slope(pt0, pt1);
        let (slope_sqr: UnreducedBigInt5) = bigint_mul(slope, slope);
        local new_x: BigInt3;
        local new_y: BigInt3;
        %{
            from src.hints.fq import bigint_pack, bigint_fill, get_p
            assert 1 < ids.N_LIMBS <= 12
            p = get_p(ids)
            x0 = bigint_pack(ids.pt0.x, ids.N_LIMBS, ids.BASE)
            y0 = bigint_pack(ids.pt0.y, ids.N_LIMBS, ids.BASE)
            x1 = bigint_pack(ids.pt1.x, ids.N_LIMBS, ids.BASE)
            slope = bigint_pack(ids.slope, ids.N_LIMBS, ids.BASE)


            new_x = (pow(slope, 2, p) - x0 - x1) % p
            new_y = (slope * (x0 - new_x) - y0) % p

            bigint_fill(new_x, ids.new_x, ids.N_LIMBS, ids.BASE)
            bigint_fill(new_y, ids.new_y, ids.N_LIMBS, ids.BASE)
        %}
        assert_reduced_felt(new_x);
        assert_reduced_felt(new_y);

        verify_zero5(
            UnreducedBigInt5(
                d0=slope_sqr.d0 - new_x.d0 - pt0.x.d0 - pt1.x.d0,
                d1=slope_sqr.d1 - new_x.d1 - pt0.x.d1 - pt1.x.d1,
                d2=slope_sqr.d2 - new_x.d2 - pt0.x.d2 - pt1.x.d2,
                d3=slope_sqr.d3,
                d4=slope_sqr.d4,
            ),
        );

        let (x_diff_slope: UnreducedBigInt5) = bigint_mul(
            BigInt3(d0=pt0.x.d0 - new_x.d0, d1=pt0.x.d1 - new_x.d1, d2=pt0.x.d2 - new_x.d2), slope
        );

        verify_zero5(
            UnreducedBigInt5(
                d0=x_diff_slope.d0 - pt0.y.d0 - new_y.d0,
                d1=x_diff_slope.d1 - pt0.y.d1 - new_y.d1,
                d2=x_diff_slope.d2 - pt0.y.d2 - new_y.d2,
                d3=x_diff_slope.d3,
                d4=x_diff_slope.d4,
            ),
        );

        return (G1Point(new_x, new_y),);
    }

    // Same as fast_ec_add, except that the cases pt0 = ±pt1 are supported.
    func add{range_check_ptr}(pt0: G1Point, pt1: G1Point) -> (res: G1Point) {
        let x_diff = UnreducedBigInt3(
            d0=pt0.x.d0 - pt1.x.d0, d1=pt0.x.d1 - pt1.x.d1, d2=pt0.x.d2 - pt1.x.d2
        );
        let (same_x: felt) = is_zero(x_diff);
        if (same_x == 0) {
            // pt0.x != pt1.x so we can use fast_ec_add.
            return fast_ec_add(pt0, pt1);
        }

        // We have pt0.x = pt1.x. This implies pt0.y = ±pt1.y.
        // Check whether pt0.y = -pt1.y.
        let y_sum = UnreducedBigInt3(
            d0=pt0.y.d0 + pt1.y.d0, d1=pt0.y.d1 + pt1.y.d1, d2=pt0.y.d2 + pt1.y.d2
        );
        let (opposite_y: felt) = is_zero(y_sum);
        if (opposite_y != 0) {
            // pt0.y = -pt1.y.
            // Note that the case pt0 = pt1 = 0 falls into this branch as well.
            let ZERO_POINT = G1Point(BigInt3(0, 0, 0), BigInt3(0, 0, 0));
            return (ZERO_POINT,);
        } else {
            // pt0.y = pt1.y.
            return double(pt0);
        }
    }

    // Given 0 <= m < 250, a scalar and a point on the elliptic curve, pt,
    // verifies that 0 <= scalar < 2**m and returns (2**m * pt, scalar * pt).
    func ec_mul_inner{range_check_ptr}(pt: G1Point, scalar: felt, m: felt) -> (
        pow2: G1Point, res: G1Point
    ) {
        if (m == 0) {
            assert scalar = 0;
            let ZERO_POINT = G1Point(BigInt3(0, 0, 0), BigInt3(0, 0, 0));
            return (pow2=pt, res=ZERO_POINT);
        }

        alloc_locals;
        let (double_pt: G1Point) = double(pt);
        %{ memory[ap] = (ids.scalar % PRIME) % 2 %}
        jmp odd if [ap] != 0, ap++;
        return ec_mul_inner(pt=double_pt, scalar=scalar / 2, m=m - 1);

        odd:
        let (local inner_pow2: G1Point, inner_res: G1Point) = ec_mul_inner(
            pt=double_pt, scalar=(scalar - 1) / 2, m=m - 1
        );
        // Here inner_res = (scalar - 1) / 2 * double_pt = (scalar - 1) * pt.
        // Assume pt != 0 and that inner_res = ±pt. We obtain (scalar - 1) * pt = ±pt =>
        // scalar - 1 = ±1 (mod N) => scalar = 0 or 2.
        // In both cases (scalar - 1) / 2 cannot be in the range [0, 2**(m-1)), so we get a
        // contradiction.
        let (res: G1Point) = fast_ec_add(pt0=pt, pt1=inner_res);
        return (pow2=inner_pow2, res=res);
    }

    func scalar_mul{range_check_ptr}(pt: G1Point, scalar: BigInt3) -> (res: G1Point) {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        let (pow2_0: G1Point, local res0: G1Point) = ec_mul_inner(pt, scalar.d0, 86);
        let (pow2_1: G1Point, local res1: G1Point) = ec_mul_inner(pow2_0, scalar.d1, 86);
        let (_, local res2: G1Point) = ec_mul_inner(pow2_1, scalar.d2, 82);
        let (res: G1Point) = add(res0, res1);
        let (res: G1Point) = add(res, res2);

        return (res,);
    }
    func neg{range_check_ptr}(pt: G1Point) -> (res: G1Point) {
        alloc_locals;
        let y = fq_bigint3.neg(pt.y);
        let res: G1Point = G1Point(pt.x, y);
        return (res,);
    }
}

// CONSTANTS
func G1() -> (res: G1Point) {
    return (res=G1Point(BigInt3(1, 0, 0), BigInt3(2, 0, 0)));
}
