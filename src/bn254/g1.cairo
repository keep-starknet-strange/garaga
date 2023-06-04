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
    SHIFT_MIN_BASE,
    SHIFT_MIN_P2,
    N_LIMBS,
    DEGREE,
)
from src.bn254.curve import P0, P1, P2
from starkware.cairo.common.registers import get_fp_and_pc

// Represents a point on the elliptic curve.
// The zero point is represented using pt.x=0, as there is no point on the curve with this x value.
struct G1Point {
    x: BigInt3*,
    y: BigInt3*,
}

struct G1PointFull {
    x: BigInt3,
    y: BigInt3,
}

namespace g1 {
    func assert_on_curve{range_check_ptr}(pt: G1Point*) -> () {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        let left = fq_bigint3.mul(pt.y, pt.y);
        let x_sq = fq_bigint3.mul(pt.x, pt.x);
        let x_cube = fq_bigint3.mul(x_sq, pt.x);

        assert left.d0 = x_cube.d0 + 3;
        assert left.d1 = x_cube.d1;
        assert left.d2 = x_cube.d2;

        return ();
    }
    func assert_equal(pt1: G1Point*, pt2: G1Point*) -> () {
        assert pt1.x.d0 = pt2.x.d0;
        assert pt1.x.d1 = pt2.x.d1;
        assert pt1.x.d2 = pt2.x.d2;
        assert pt1.y.d0 = pt2.y.d0;
        assert pt1.y.d1 = pt2.y.d1;
        assert pt1.y.d2 = pt2.y.d2;
        return ();
    }
    func compute_doubling_slope{range_check_ptr}(pt: G1PointFull) -> (slope: BigInt3) {
        // Note that y cannot be zero: assume that it is, then pt = -pt, so 2 * pt = 0, which
        // contradicts the fact that the size of the curve is odd.
        alloc_locals;
        local slope: BigInt3;
        %{
            from starkware.python.math_utils import div_mod

            assert 1 < ids.N_LIMBS <= 12
            assert ids.DEGREE == ids.N_LIMBS-1
            x,y,p=0,0,0

            def split(x, degree=ids.DEGREE, base=ids.BASE):
                coeffs = []
                for n in range(degree, 0, -1):
                    q, r = divmod(x, base ** n)
                    coeffs.append(q)
                    x = r
                coeffs.append(x)
                return coeffs[::-1]

            for i in range(ids.N_LIMBS):
                x+=getattr(ids.pt.x, 'd'+str(i)) * ids.BASE**i
                y+=getattr(ids.pt.y, 'd'+str(i)) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

            slope = split(div_mod(3 * x ** 2, 2 * y, p))

            for i in range(ids.N_LIMBS):
                setattr(ids.slope, 'd'+str(i), slope[i])
        %}
        assert [range_check_ptr] = slope.d0 + (SHIFT_MIN_BASE);
        assert [range_check_ptr + 1] = slope.d1 + (SHIFT_MIN_BASE);
        assert [range_check_ptr + 2] = slope.d2 + (SHIFT_MIN_P2);

        let (x_sqr: UnreducedBigInt5) = bigint_mul(pt.x, pt.x);
        let (slope_y: UnreducedBigInt5) = bigint_mul(slope, pt.y);
        tempvar range_check_ptr = range_check_ptr + 3;
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
    func compute_slope{range_check_ptr}(pt0: G1PointFull, pt1: G1PointFull) -> (slope: BigInt3) {
        alloc_locals;
        local slope: BigInt3;
        %{
            from starkware.python.math_utils import div_mod

            assert 1 < ids.N_LIMBS <= 12
            assert ids.DEGREE == ids.N_LIMBS-1
            x0,y0,x1,y1,p=0,0,0,0,0

            def split(x, degree=ids.DEGREE, base=ids.BASE):
                coeffs = []
                for n in range(degree, 0, -1):
                    q, r = divmod(x, base ** n)
                    coeffs.append(q)
                    x = r
                coeffs.append(x)
                return coeffs[::-1]

            for i in range(ids.N_LIMBS):
                x0+=getattr(ids.pt0.x, 'd'+str(i)) * ids.BASE**i
                y0+=getattr(ids.pt0.y, 'd'+str(i)) * ids.BASE**i
                x1+=getattr(ids.pt1.x, 'd'+str(i)) * ids.BASE**i
                y1+=getattr(ids.pt1.y, 'd'+str(i)) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

            slope = split(div_mod(y0 - y1, x0 - x1, p))

            for i in range(ids.N_LIMBS):
                setattr(ids.slope, 'd'+str(i), slope[i])
        %}
        assert [range_check_ptr] = slope.d0 + (SHIFT_MIN_BASE);
        assert [range_check_ptr + 1] = slope.d1 + (SHIFT_MIN_BASE);
        assert [range_check_ptr + 2] = slope.d2 + (SHIFT_MIN_P2);
        tempvar range_check_ptr = range_check_ptr + 3;

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
    func double{range_check_ptr}(pt: G1PointFull) -> (res: G1PointFull) {
        alloc_locals;
        if (pt.x.d0 == 0) {
            if (pt.x.d1 == 0) {
                if (pt.x.d2 == 0) {
                    return (pt,);
                }
            }
        }

        let (slope: BigInt3) = compute_doubling_slope(pt);
        let (slope_sqr: UnreducedBigInt5) = bigint_mul(slope, slope);

        local new_x: BigInt3;
        local new_y: BigInt3;
        %{
            from starkware.python.math_utils import div_mod

            assert 1 < ids.N_LIMBS <= 12
            assert ids.DEGREE == ids.N_LIMBS-1
            x,y,slope,p=0,0,0,0

            def split(x, degree=ids.DEGREE, base=ids.BASE):
                coeffs = []
                for n in range(degree, 0, -1):
                    q, r = divmod(x, base ** n)
                    coeffs.append(q)
                    x = r
                coeffs.append(x)
                return coeffs[::-1]

            for i in range(ids.N_LIMBS):
                x+=getattr(ids.pt.x, 'd'+str(i)) * ids.BASE**i
                y+=getattr(ids.pt.y, 'd'+str(i)) * ids.BASE**i
                slope+=getattr(ids.slope, 'd'+str(i)) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

            new_x = (pow(slope, 2, p) - 2 * x) % p
            new_y = (slope * (x - new_x) - y) % p
            new_xs, new_ys = split(new_x), split(new_y)

            for i in range(ids.N_LIMBS):
                setattr(ids.new_x, 'd'+str(i), new_xs[i])
                setattr(ids.new_y, 'd'+str(i), new_ys[i])
        %}
        assert [range_check_ptr] = new_x.d0 + (SHIFT_MIN_BASE);
        assert [range_check_ptr + 1] = new_x.d1 + (SHIFT_MIN_BASE);
        assert [range_check_ptr + 2] = new_x.d2 + (SHIFT_MIN_P2);
        assert [range_check_ptr + 3] = new_y.d0 + (SHIFT_MIN_BASE);
        assert [range_check_ptr + 4] = new_y.d1 + (SHIFT_MIN_BASE);
        assert [range_check_ptr + 5] = new_y.d2 + (SHIFT_MIN_P2);
        tempvar range_check_ptr = range_check_ptr + 6;

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

        return (G1PointFull(new_x, new_y),);
    }

    // Adds two points on the elliptic curve.
    // Assumption: pt0.x != pt1.x (however, pt0 = pt1 = 0 is allowed).
    // Note that this means that the function cannot be used if pt0 = pt1
    // (use ec_double() in this case) or pt0 = -pt1 (the result is 0 in this case).
    func fast_ec_add{range_check_ptr}(pt0: G1PointFull, pt1: G1PointFull) -> (res: G1PointFull) {
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
            assert 1 < ids.N_LIMBS <= 12
            assert ids.DEGREE == ids.N_LIMBS-1
            x0,y0,x1,slope,p=0,0,0,0,0

            def split(x, degree=ids.DEGREE, base=ids.BASE):
                coeffs = []
                for n in range(degree, 0, -1):
                    q, r = divmod(x, base ** n)
                    coeffs.append(q)
                    x = r
                coeffs.append(x)
                return coeffs[::-1]

            for i in range(ids.N_LIMBS):
                x0+=getattr(ids.pt0.x, 'd'+str(i)) * ids.BASE**i
                y0+=getattr(ids.pt0.y, 'd'+str(i)) * ids.BASE**i
                x1+=getattr(ids.pt1.x, 'd'+str(i)) * ids.BASE**i
                slope+=getattr(ids.slope, 'd'+str(i)) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i


            new_x = (pow(slope, 2, p) - x0 - x1) % p
            new_y = (slope * (x0 - new_x) - y0) % p
            new_xs, new_ys = split(new_x), split(new_y)

            for i in range(ids.N_LIMBS):
                setattr(ids.new_x, 'd'+str(i), new_xs[i])
                setattr(ids.new_y, 'd'+str(i), new_ys[i])
        %}
        assert [range_check_ptr] = new_x.d0 + (SHIFT_MIN_BASE);
        assert [range_check_ptr + 1] = new_x.d1 + (SHIFT_MIN_BASE);
        assert [range_check_ptr + 2] = new_x.d2 + (SHIFT_MIN_P2);
        assert [range_check_ptr + 3] = new_y.d0 + (SHIFT_MIN_BASE);
        assert [range_check_ptr + 4] = new_y.d1 + (SHIFT_MIN_BASE);
        assert [range_check_ptr + 5] = new_y.d2 + (SHIFT_MIN_P2);
        tempvar range_check_ptr = range_check_ptr + 6;

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

        return (G1PointFull(new_x, new_y),);
    }

    // Same as fast_ec_add, except that the cases pt0 = ±pt1 are supported.
    func add_full{range_check_ptr}(pt0: G1PointFull, pt1: G1PointFull) -> (res: G1PointFull) {
        let x_diff = BigInt3(
            d0=pt0.x.d0 - pt1.x.d0, d1=pt0.x.d1 - pt1.x.d1, d2=pt0.x.d2 - pt1.x.d2
        );
        let (same_x: felt) = is_zero(x_diff);
        if (same_x == 0) {
            // pt0.x != pt1.x so we can use fast_ec_add.
            return fast_ec_add(pt0, pt1);
        }

        // We have pt0.x = pt1.x. This implies pt0.y = ±pt1.y.
        // Check whether pt0.y = -pt1.y.
        let y_sum = BigInt3(d0=pt0.y.d0 + pt1.y.d0, d1=pt0.y.d1 + pt1.y.d1, d2=pt0.y.d2 + pt1.y.d2);
        let (opposite_y: felt) = is_zero(y_sum);
        if (opposite_y != 0) {
            // pt0.y = -pt1.y.
            // Note that the case pt0 = pt1 = 0 falls into this branch as well.
            let ZERO_POINT = G1PointFull(BigInt3(0, 0, 0), BigInt3(0, 0, 0));
            return (ZERO_POINT,);
        } else {
            // pt0.y = pt1.y.
            return double(pt0);
        }
    }

    func add{range_check_ptr}(pt0_ptr: G1Point*, pt1_ptr: G1Point*) -> (res: G1Point*) {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local pt0: G1PointFull;
        assert pt0.x.d0 = pt0_ptr.x.d0;
        assert pt0.x.d1 = pt0_ptr.x.d1;
        assert pt0.x.d2 = pt0_ptr.x.d2;
        assert pt0.y.d0 = pt0_ptr.y.d0;
        assert pt0.y.d1 = pt0_ptr.y.d1;
        assert pt0.y.d2 = pt0_ptr.y.d2;

        local pt1: G1PointFull;
        assert pt1.x.d0 = pt1_ptr.x.d0;
        assert pt1.x.d1 = pt1_ptr.x.d1;
        assert pt1.x.d2 = pt1_ptr.x.d2;
        assert pt1.y.d0 = pt1_ptr.y.d0;
        assert pt1.y.d1 = pt1_ptr.y.d1;
        assert pt1.y.d2 = pt1_ptr.y.d2;

        let x_diff = BigInt3(
            d0=pt0.x.d0 - pt1.x.d0, d1=pt0.x.d1 - pt1.x.d1, d2=pt0.x.d2 - pt1.x.d2
        );
        let (same_x: felt) = is_zero(x_diff);
        if (same_x == 0) {
            // pt0.x != pt1.x so we can use fast_ec_add.
            let (local res) = fast_ec_add(pt0, pt1);
            tempvar res_ptr = new G1Point(&res.x, &res.y);
            return (res_ptr,);
        }

        // We have pt0.x = pt1.x. This implies pt0.y = ±pt1.y.
        // Check whether pt0.y = -pt1.y.
        let y_sum = BigInt3(d0=pt0.y.d0 + pt1.y.d0, d1=pt0.y.d1 + pt1.y.d1, d2=pt0.y.d2 + pt1.y.d2);
        let (opposite_y: felt) = is_zero(y_sum);
        if (opposite_y != 0) {
            // pt0.y = -pt1.y.
            // Note that the case pt0 = pt1 = 0 falls into this branch as well.
            tempvar ZERO_POINT = new G1Point(new BigInt3(0, 0, 0), new BigInt3(0, 0, 0));
            return (ZERO_POINT,);
        } else {
            // pt0.y = pt1.y.
            let (local res) = double(pt0);
            tempvar res_ptr = new G1Point(&res.x, &res.y);
            return (res_ptr,);
        }
    }

    // Given 0 <= m < 250, a scalar and a point on the elliptic curve, pt,
    // verifies that 0 <= scalar < 2**m and returns (2**m * pt, scalar * pt).
    func ec_mul_inner{range_check_ptr}(pt: G1PointFull, scalar: felt, m: felt) -> (
        pow2: G1PointFull, res: G1PointFull
    ) {
        if (m == 0) {
            assert scalar = 0;
            let ZERO_POINT = G1PointFull(BigInt3(0, 0, 0), BigInt3(0, 0, 0));
            return (pow2=pt, res=ZERO_POINT);
        }

        alloc_locals;
        let (double_pt: G1PointFull) = double(pt);
        %{ memory[ap] = (ids.scalar % PRIME) % 2 %}
        jmp odd if [ap] != 0, ap++;
        return ec_mul_inner(pt=double_pt, scalar=scalar / 2, m=m - 1);

        odd:
        let (local inner_pow2: G1PointFull, inner_res: G1PointFull) = ec_mul_inner(
            pt=double_pt, scalar=(scalar - 1) / 2, m=m - 1
        );
        // Here inner_res = (scalar - 1) / 2 * double_pt = (scalar - 1) * pt.
        // Assume pt != 0 and that inner_res = ±pt. We obtain (scalar - 1) * pt = ±pt =>
        // scalar - 1 = ±1 (mod N) => scalar = 0 or 2.
        // In both cases (scalar - 1) / 2 cannot be in the range [0, 2**(m-1)), so we get a
        // contradiction.
        let (res: G1PointFull) = fast_ec_add(pt0=pt, pt1=inner_res);
        return (pow2=inner_pow2, res=res);
    }

    func scalar_mul{range_check_ptr}(pt: G1Point*, scalar: BigInt3) -> (res: G1Point*) {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local pt_full: G1PointFull;
        assert pt_full.x.d0 = pt.x.d0;
        assert pt_full.x.d1 = pt.x.d1;
        assert pt_full.x.d2 = pt.x.d2;
        assert pt_full.y.d0 = pt.y.d0;
        assert pt_full.y.d1 = pt.y.d1;
        assert pt_full.y.d2 = pt.y.d2;

        let (pow2_0: G1PointFull, local res0: G1PointFull) = ec_mul_inner(pt_full, scalar.d0, 86);
        let (pow2_1: G1PointFull, local res1: G1PointFull) = ec_mul_inner(pow2_0, scalar.d1, 86);
        let (_, local res2: G1PointFull) = ec_mul_inner(pow2_1, scalar.d2, 82);
        let (res: G1PointFull) = add_full(res0, res1);
        let (local res: G1PointFull) = add_full(res, res2);
        tempvar result = new G1Point(&res.x, &res.y);
        return (result,);
    }
    func neg{range_check_ptr}(pt: G1Point*) -> G1Point* {
        alloc_locals;
        let x = pt.x;
        let y = fq_bigint3.neg(pt.y);
        tempvar res: G1Point* = new G1Point(x, y);
        return res;
    }
}

// CONSTANTS
func G1() -> (res: G1PointFull) {
    return (res=G1PointFull(BigInt3(1, 0, 0), BigInt3(2, 0, 0)));
}
