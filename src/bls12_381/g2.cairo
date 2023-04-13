from starkware.cairo.common.registers import get_fp_and_pc
from src.bls12_381.curve import P0, P1, P2, P3, BASE, N_LIMBS, DEGREE
from src.bls12_381.fq import (
    fq_bigint4,
    is_zero,
    verify_zero7,
    verify_zero4,
    bigint4_mul,
    bigint4_sq,
    BigInt4,
    UnreducedBigInt7,
)
from src.bls12_381.towers.e2 import e2, E2, mul_e2_unreduced, square_e2_unreduced

struct G2Point {
    x: E2*,
    y: E2*,
}

struct E4 {
    r0: E2*,
    r1: E2*,
}
namespace g2 {
    func get_g2_generator() -> G2Point* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local x: E2 = E2(BigInt4(2, 0, 0, 0), BigInt4(0, 0, 0, 0));
        local y: E2 = E2(
            BigInt4(
                44728709121408187237493030515,
                20654017898602309933413727482,
                25864092631118417303118124618,
                380025461438220712204149686,
            ),
            BigInt4(
                43460440767912591844840598863,
                48646658366312408051964110309,
                66805613684353394558484347155,
                873439732259278294538952858,
            ),
        );
        local res = G2Point(&x, &y);
        return &res;
    }
    func assert_on_curve{range_check_ptr}(pt: G2Point) -> () {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        let left = e2.mul(pt.y, pt.y);
        let x_sq = e2.square(pt.x);
        let x_cube = e2.mul(x_sq, pt.x);
        local b20: BigInt4 = BigInt4(d0=4, d1=0, d2=0, d3=0);
        local b21: BigInt4 = BigInt4(d0=4, d1=0, d2=0, d3=0);

        local b2: E2 = E2(&b20, &b21);
        let right = e2.add(x_cube, &b2);

        e2.assert_E2(left, right);
        return ();
    }
    func assert_equal(pt1: G2Point*, pt2: G2Point*) -> () {
        assert pt1.x.a0.d0 = pt2.x.a0.d0;
        assert pt1.x.a0.d1 = pt2.x.a0.d1;
        assert pt1.x.a0.d2 = pt2.x.a0.d2;
        assert pt1.x.a0.d3 = pt2.x.a0.d3;
        assert pt1.x.a1.d0 = pt2.x.a1.d0;
        assert pt1.x.a1.d1 = pt2.x.a1.d1;
        assert pt1.x.a1.d2 = pt2.x.a1.d2;
        assert pt1.x.a1.d3 = pt2.x.a1.d3;
        assert pt1.y.a0.d0 = pt2.y.a0.d0;
        assert pt1.y.a0.d1 = pt2.y.a0.d1;
        assert pt1.y.a0.d2 = pt2.y.a0.d2;
        assert pt1.y.a0.d3 = pt2.y.a0.d3;
        assert pt1.y.a1.d0 = pt2.y.a1.d0;
        assert pt1.y.a1.d1 = pt2.y.a1.d1;
        assert pt1.y.a1.d2 = pt2.y.a1.d2;
        assert pt1.y.a1.d3 = pt2.y.a1.d3;

        return ();
    }
    func neg{range_check_ptr}(pt: G2Point*) -> G2Point* {
        alloc_locals;
        let x = pt.x;
        let y = e2.neg(pt.y);
        tempvar res = new G2Point(x, y);
        return res;
    }
    func compute_doubling_slope{range_check_ptr}(pt: G2Point*) -> E2* {
        // Returns the slope of the elliptic curve at the given point.
        // The slope is used to compute pt + pt.
        // Assumption: pt != 0.
        // Note that y cannot be zero: assume that it is, then pt = -pt, so 2 * pt = 0, which
        // contradicts the fact that the size of the curve is odd.
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local slope_a0: BigInt4;
        local slope_a1: BigInt4;
        %{
            assert 1 < ids.N_LIMBS <= 12
            assert ids.DEGREE == ids.N_LIMBS-1
            x,y,p=[0,0],[0,0],0

            def split(x, degree=ids.DEGREE, base=ids.BASE):
                coeffs = []
                for n in range(degree, 0, -1):
                    q, r = divmod(x, base ** n)
                    coeffs.append(q)
                    x = r
                coeffs.append(x)
                return coeffs[::-1]

            for i in range(ids.N_LIMBS):
                x[0]+=getattr(ids.pt.x.a0, 'd'+str(i)) * ids.BASE**i
                x[1]+=getattr(ids.pt.x.a1, 'd'+str(i)) * ids.BASE**i
                y[0]+=getattr(ids.pt.y.a0, 'd'+str(i)) * ids.BASE**i
                y[1]+=getattr(ids.pt.y.a1, 'd'+str(i)) * ids.BASE**i

                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

            def mul_e2(x:(int,int), y:(int,int)):
                a = (x[0] + x[1]) * (y[0] + y[1]) % p
                b, c  = x[0]*y[0] % p, x[1]*y[1] % p
                return (b - c) % p, (a - b - c) % p
            def scalar_mul_e2(n:int, y:(int, int)):
                a = (y[0] + y[1]) * n % p
                b = y[0]*n % p
                return (b, (a - b) % p)
            def inv_e2(a:(int, int)):
                t0, t1 = (a[0] * a[0] % p, a[1] * a[1] % p)
                t0 = (t0 + t1) % p
                t1 = pow(t0, -1, p)
                return a[0] * t1 % p, -(a[1] * t1) % p
            num=scalar_mul_e2(3, mul_e2(x,x))
            sub=scalar_mul_e2(2,y)
            sub_inv= inv_e2(sub)
            value = mul_e2(num, sub_inv)

            value_split = [split(value[0]), split(value[1])]
            for i in range(ids.N_LIMBS):
                setattr(ids.slope_a0, 'd'+str(i), value_split[0][i])
                setattr(ids.slope_a1, 'd'+str(i), value_split[1][i])
        %}

        let x0_x1: UnreducedBigInt7 = bigint4_mul([pt.x.a0], [pt.x.a1]);
        let x0_sqr: UnreducedBigInt7 = bigint4_sq([pt.x.a0]);
        let x1_sqr: UnreducedBigInt7 = bigint4_sq([pt.x.a1]);

        let s0_y0: UnreducedBigInt7 = bigint4_mul(slope_a0, [pt.y.a0]);
        let s1_y1: UnreducedBigInt7 = bigint4_mul(slope_a1, [pt.y.a1]);

        let s0_y1: UnreducedBigInt7 = bigint4_mul(slope_a0, [pt.y.a1]);
        let s1_y0: UnreducedBigInt7 = bigint4_mul(slope_a1, [pt.y.a0]);

        // Verify real
        verify_zero7(
            UnreducedBigInt7(
                d0=3 * (x0_sqr.d0 - x1_sqr.d0) - 2 * (s0_y0.d0 - s1_y1.d0),
                d1=3 * (x0_sqr.d1 - x1_sqr.d1) - 2 * (s0_y0.d1 - s1_y1.d1),
                d2=3 * (x0_sqr.d2 - x1_sqr.d2) - 2 * (s0_y0.d2 - s1_y1.d2),
                d3=3 * (x0_sqr.d3 - x1_sqr.d3) - 2 * (s0_y0.d3 - s1_y1.d3),
                d4=3 * (x0_sqr.d4 - x1_sqr.d4) - 2 * (s0_y0.d4 - s1_y1.d4),
                d5=3 * (x0_sqr.d5 - x1_sqr.d5) - 2 * (s0_y0.d5 - s1_y1.d5),
                d6=3 * (x0_sqr.d6 - x1_sqr.d6) - 2 * (s0_y0.d6 - s1_y1.d6),
            ),
        );
        // Verify imaginary
        verify_zero7(
            UnreducedBigInt7(
                d0=2 * (3 * x0_x1.d0 - s0_y1.d0 - s1_y0.d0),
                d1=2 * (3 * x0_x1.d1 - s0_y1.d1 - s1_y0.d1),
                d2=2 * (3 * x0_x1.d2 - s0_y1.d2 - s1_y0.d2),
                d3=2 * (3 * x0_x1.d3 - s0_y1.d3 - s1_y0.d3),
                d4=2 * (3 * x0_x1.d4 - s0_y1.d4 - s1_y0.d4),
                d5=2 * (3 * x0_x1.d5 - s0_y1.d5 - s1_y0.d5),
                d6=2 * (3 * x0_x1.d6 - s0_y1.d6 - s1_y0.d6),
            ),
        );

        local slope: E2 = E2(a0=&slope_a0, a1=&slope_a1);
        return &slope;
    }
    // Returns the slope of the line connecting the two given points.
    // The slope is used to compute pt0 + pt1.
    // Assumption: pt0.x != pt1.x (mod field prime).
    func compute_slope{range_check_ptr}(pt0: G2Point*, pt1: G2Point*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local slope_a0: BigInt4;
        local slope_a1: BigInt4;
        %{
            assert 1 < ids.N_LIMBS <= 12
            assert ids.DEGREE == ids.N_LIMBS-1
            x0,y0,x1,y1,p=[0,0],[0,0],[0,0],[0,0],0

            def split(x, degree=ids.DEGREE, base=ids.BASE):
                coeffs = []
                for n in range(degree, 0, -1):
                    q, r = divmod(x, base ** n)
                    coeffs.append(q)
                    x = r
                coeffs.append(x)
                return coeffs[::-1]

            for i in range(ids.N_LIMBS):
                x0[0]+=getattr(ids.pt0.x.a0,'d'+str(i)) * ids.BASE**i
                x0[1]+=getattr(ids.pt0.x.a1,'d'+str(i)) * ids.BASE**i
                y0[0]+=getattr(ids.pt0.y.a0,'d'+str(i)) * ids.BASE**i
                y0[1]+=getattr(ids.pt0.y.a1,'d'+str(i)) * ids.BASE**i
                x1[0]+=getattr(ids.pt1.x.a0,'d'+str(i)) * ids.BASE**i
                x1[1]+=getattr(ids.pt1.x.a1,'d'+str(i)) * ids.BASE**i
                y1[0]+=getattr(ids.pt1.y.a0,'d'+str(i)) * ids.BASE**i
                y1[1]+=getattr(ids.pt1.y.a1,'d'+str(i)) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

            def mul_e2(x:(int,int), y:(int,int)):
                a = (x[0] + x[1]) * (y[0] + y[1]) % p
                b, c  = x[0]*y[0] % p, x[1]*y[1] % p
                return (b - c) % p, (a - b - c) % p
            def sub_e2(x:(int,int), y:(int,int)):
                return (x[0]-y[0]) % p, (x[1]-y[1]) % p
            def inv_e2(a:(int, int)):
                t0, t1 = (a[0] * a[0] % p, a[1] * a[1] % p)
                t0 = (t0 + t1) % p
                t1 = pow(t0, -1, p)
                return a[0] * t1 % p, -(a[1] * t1) % p

            sub = sub_e2(x0,x1)
            sub_inv = inv_e2(sub)
            numerator = sub_e2(y0,y1)
            value=mul_e2(numerator,sub_inv)

            value_split = [split(value[0]), split(value[1])]
            for i in range(ids.N_LIMBS):
                setattr(ids.slope_a0, 'd'+str(i), value_split[0][i])
                setattr(ids.slope_a1, 'd'+str(i), value_split[1][i])
        %}

        tempvar x_diff_real: BigInt4 = BigInt4(
            d0=pt0.x.a0.d0 - pt1.x.a0.d0,
            d1=pt0.x.a0.d1 - pt1.x.a0.d1,
            d2=pt0.x.a0.d2 - pt1.x.a0.d2,
            d3=pt0.x.a0.d3 - pt1.x.a0.d3,
        );
        tempvar x_diff_imag: BigInt4 = BigInt4(
            d0=pt0.x.a1.d0 - pt1.x.a1.d0,
            d1=pt0.x.a1.d1 - pt1.x.a1.d1,
            d2=pt0.x.a1.d2 - pt1.x.a1.d2,
            d3=pt0.x.a1.d3 - pt1.x.a1.d3,
        );

        let x_diff_slope_imag_first_term: UnreducedBigInt7 = bigint4_mul(x_diff_real, slope_a1);
        let x_diff_slope_imag_second_term: UnreducedBigInt7 = bigint4_mul(x_diff_imag, slope_a0);

        let x_diff_real_first_term: UnreducedBigInt7 = bigint4_mul(x_diff_real, slope_a0);
        let x_diff_real_second_term: UnreducedBigInt7 = bigint4_mul(x_diff_imag, slope_a1);

        verify_zero7(
            UnreducedBigInt7(
                d0=x_diff_slope_imag_first_term.d0 + x_diff_slope_imag_second_term.d0 -
                pt0.y.a1.d0 + pt1.y.a1.d0,
                d1=x_diff_slope_imag_first_term.d1 + x_diff_slope_imag_second_term.d1 -
                pt0.y.a1.d1 + pt1.y.a1.d1,
                d2=x_diff_slope_imag_first_term.d2 + x_diff_slope_imag_second_term.d2 -
                pt0.y.a1.d2 + pt1.y.a1.d2,
                d3=x_diff_slope_imag_first_term.d3 + x_diff_slope_imag_second_term.d3 -
                pt0.y.a1.d3 + pt1.y.a1.d3,
                d4=x_diff_slope_imag_first_term.d4 + x_diff_slope_imag_second_term.d4,
                d5=x_diff_slope_imag_first_term.d5 + x_diff_slope_imag_second_term.d5,
                d6=x_diff_slope_imag_first_term.d6 + x_diff_slope_imag_second_term.d6,
            ),
        );

        verify_zero7(
            UnreducedBigInt7(
                d0=x_diff_real_first_term.d0 - x_diff_real_second_term.d0 - pt0.y.a0.d0 +
                pt1.y.a0.d0,
                d1=x_diff_real_first_term.d1 - x_diff_real_second_term.d1 - pt0.y.a0.d1 +
                pt1.y.a0.d1,
                d2=x_diff_real_first_term.d2 - x_diff_real_second_term.d2 - pt0.y.a0.d2 +
                pt1.y.a0.d2,
                d3=x_diff_real_first_term.d3 - x_diff_real_second_term.d3 - pt0.y.a0.d3 +
                pt1.y.a0.d3,
                d4=x_diff_real_first_term.d4 - x_diff_real_second_term.d4,
                d5=x_diff_real_first_term.d5 - x_diff_real_second_term.d5,
                d6=x_diff_real_first_term.d6 - x_diff_real_second_term.d6,
            ),
        );
        local slope: E2 = E2(a0=&slope_a0, a1=&slope_a1);

        return &slope;
    }

    // Given a point 'pt' on the elliptic curve, computes pt + pt.
    func double{range_check_ptr}(pt: G2Point*) -> G2Point* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let is_zero = e2.is_zero(pt.x);
        if (is_zero == 1) {
            return pt;
        }

        let slope: E2* = compute_doubling_slope(pt);
        let (slope_sqr_a0: UnreducedBigInt7, slope_sqr_a1: UnreducedBigInt7) = square_e2_unreduced(
            slope
        );

        local new_x_a0: BigInt4;
        local new_x_a1: BigInt4;
        local new_y_a0: BigInt4;
        local new_y_a1: BigInt4;
        %{
            assert 1 < ids.N_LIMBS <= 12
            assert ids.DEGREE == ids.N_LIMBS-1
            x0,x1,y0,y1,slope,p=0,0,0,0,[0,0],0

            def split(x, degree=ids.DEGREE, base=ids.BASE):
                coeffs = []
                for n in range(degree, 0, -1):
                    q, r = divmod(x, base ** n)
                    coeffs.append(q)
                    x = r
                coeffs.append(x)
                return coeffs[::-1]
            def inv_e2(a0:int, a1:int):
                t0, t1 = (a0 * a0 % p, a1 * a1 % p)
                t0 = (t0 + t1) % p
                t1 = pow(t0, -1, p)
                return (a0 * t1 % p, -(a1 * t1) % p)
            def mul_e2(x:(int,int), y:(int,int)):
                a = (x[0] + x[1]) * (y[0] + y[1]) % p
                b, c  = x[0]*y[0] % p, x[1]*y[1] % p
                return (b - c) % p, (a - b - c) % p
            def sub_e2(x:(int,int), y:(int,int)):
                return (x[0]-y[0]) % p, (x[1]-y[1]) % p

            for i in range(ids.N_LIMBS):
                x0+=getattr(ids.pt.x.a0, 'd'+str(i)) * ids.BASE**i
                x1+=getattr(ids.pt.x.a1, 'd'+str(i)) * ids.BASE**i
                y0+=getattr(ids.pt.y.a0, 'd'+str(i)) * ids.BASE**i
                y1+=getattr(ids.pt.y.a1, 'd'+str(i)) * ids.BASE**i
                slope[0]+=getattr(ids.slope.a0, 'd'+str(i)) * ids.BASE**i
                slope[1]+=getattr(ids.slope.a1, 'd'+str(i)) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

            new_x = sub_e2(mul_e2(slope, slope), mul_e2((2,0), (x0,x1)))
            new_y = sub_e2(mul_e2(slope, sub_e2((x0,x1), new_x)), (y0,y1))
            new_xs, new_ys = [split(new_x[0]), split(new_x[1])], [split(new_y[0]), split(new_y[1])]

            for i in range(ids.N_LIMBS):
                setattr(ids.new_x_a0, 'd'+str(i), new_xs[0][i])
                setattr(ids.new_x_a1, 'd'+str(i), new_xs[1][i])
                setattr(ids.new_y_a0, 'd'+str(i), new_ys[0][i])
                setattr(ids.new_y_a1, 'd'+str(i), new_ys[1][i])
        %}

        verify_zero7(
            UnreducedBigInt7(
                d0=slope_sqr_a0.d0 - new_x_a0.d0 - 2 * pt.x.a0.d0,
                d1=slope_sqr_a0.d1 - new_x_a0.d1 - 2 * pt.x.a0.d1,
                d2=slope_sqr_a0.d2 - new_x_a0.d2 - 2 * pt.x.a0.d2,
                d3=slope_sqr_a0.d3 - new_x_a0.d3 - 2 * pt.x.a0.d3,
                d4=slope_sqr_a0.d4,
                d5=slope_sqr_a0.d5,
                d6=slope_sqr_a0.d6,
            ),
        );

        verify_zero7(
            UnreducedBigInt7(
                d0=slope_sqr_a1.d0 - new_x_a1.d0 - 2 * pt.x.a1.d0,
                d1=slope_sqr_a1.d1 - new_x_a1.d1 - 2 * pt.x.a1.d1,
                d2=slope_sqr_a1.d2 - new_x_a1.d2 - 2 * pt.x.a1.d2,
                d3=slope_sqr_a1.d3 - new_x_a1.d3 - 2 * pt.x.a1.d3,
                d4=slope_sqr_a1.d4,
                d5=slope_sqr_a1.d5,
                d6=slope_sqr_a1.d6,
            ),
        );
        local x_min_new_x_a0: BigInt4 = BigInt4(
            d0=pt.x.a0.d0 - new_x_a0.d0,
            d1=pt.x.a0.d1 - new_x_a0.d1,
            d2=pt.x.a0.d2 - new_x_a0.d2,
            d3=pt.x.a0.d3 - new_x_a0.d3,
        );
        local x_min_new_x_a1: BigInt4 = BigInt4(
            d0=pt.x.a1.d0 - new_x_a1.d0,
            d1=pt.x.a1.d1 - new_x_a1.d1,
            d2=pt.x.a1.d2 - new_x_a1.d2,
            d3=pt.x.a1.d3 - new_x_a1.d3,
        );
        local x_min_new_x: E2 = E2(&x_min_new_x_a0, &x_min_new_x_a1);

        // let x_diff_slope: E2* = e2.mul(&x_min_new_x, slope);
        let (x_diff_slope_a0, x_diff_slope_a1) = mul_e2_unreduced(&x_min_new_x, slope);

        verify_zero7(
            UnreducedBigInt7(
                d0=x_diff_slope_a0.d0 - pt.y.a0.d0 - new_y_a0.d0,
                d1=x_diff_slope_a0.d1 - pt.y.a0.d1 - new_y_a0.d1,
                d2=x_diff_slope_a0.d2 - pt.y.a0.d2 - new_y_a0.d2,
                d3=x_diff_slope_a0.d3 - pt.y.a0.d3 - new_y_a0.d3,
                d4=x_diff_slope_a0.d4,
                d5=x_diff_slope_a0.d5,
                d6=x_diff_slope_a0.d6,
            ),
        );
        verify_zero7(
            UnreducedBigInt7(
                d0=x_diff_slope_a1.d0 - pt.y.a1.d0 - new_y_a1.d0,
                d1=x_diff_slope_a1.d1 - pt.y.a1.d1 - new_y_a1.d1,
                d2=x_diff_slope_a1.d2 - pt.y.a1.d2 - new_y_a1.d2,
                d3=x_diff_slope_a1.d3 - pt.y.a1.d3 - new_y_a1.d3,
                d4=x_diff_slope_a1.d4,
                d5=x_diff_slope_a1.d5,
                d6=x_diff_slope_a1.d6,
            ),
        );
        local new_x: E2 = E2(&new_x_a0, &new_x_a1);
        local new_y: E2 = E2(&new_y_a0, &new_y_a1);
        local res: G2Point = G2Point(&new_x, &new_y);
        return &res;
    }

    // DoubleStep doubles a point in affine coordinates, and evaluates the line in Miller loop
    // https://eprint.iacr.org/2013/722.pdf (Section 4.3)
    func double_step{range_check_ptr}(pt: G2Point*) -> (res: G2Point*, line_eval: E4*) {
        alloc_locals;
        // if (pt.x.d0 == 0) {
        //     if (pt.x.d1 == 0) {
        //         if (pt.x.d2 == 0) {
        //             let zero_6 = E6.zero();
        //             return (pt, zero_6);
        //         }
        //     }
        // }

        let (__fp__, _) = get_fp_and_pc();
        // assert_on_curve(pt);
        // precomputations in p :

        // let xp_bar = fq_bigint4.neg(p.x);
        // let yp_prime = fq_bigint4.inv(p.y);
        // let xp_prime = fq_bigint4.mul(xp_bar, yp_prime);
        // paper algo:
        // let two_y = e2.double(pt.y);
        // let A = e2.inv(two_y);
        // let x_sq = e2.square(pt.x);
        // tempvar three = new BigInt4(3, 0, 0);
        // let B = e2.mul_by_element(three, x_sq);
        // let C = e2.mul(A, B);  // lamba : slope
        let C = compute_doubling_slope(pt);

        let D = e2.double(pt.x);
        let nx = e2.square(C);
        let nx = e2.sub(nx, D);
        let E = e2.mul(C, pt.x);
        let E = e2.sub(E, pt.y);
        let ny = e2.mul(C, nx);
        let ny = e2.sub(E, ny);

        // assert_on_curve(res);

        // let F = e2.mul_by_element(xp_prime, C);
        // let G = e2.mul_by_element(yp_prime, E);
        tempvar res: G2Point* = new G2Point(nx, ny);
        // tempvar line_eval: E4* = new E4(G, F);
        tempvar line_eval: E4* = new E4(E, C);

        return (res, line_eval);
    }
    func add_step{range_check_ptr}(pt0: G2Point*, pt1: G2Point*) -> (
        res: G2Point*, line_eval: E4*
    ) {
        alloc_locals;
        // if (pt0.x.d0 == 0) {
        //     if (pt0.x.d1 == 0) {
        //         if (pt0.x.d2 == 0) {
        //             let zero_6 = E6.zero();
        //             return (pt1, zero_6);
        //         }
        //     }
        // }
        // if (pt1.x.d0 == 0) {
        //     if (pt1.x.d1 == 0) {
        //         if (pt1.x.d2 == 0) {
        //             let zero_6 = E6.zero();
        //             return (pt0, zero_6);
        //         }
        //     }
        // }
        // assert_on_curve(pt0);
        // assert_on_curve(pt1);
        // precomputations in p :
        // let xp_bar = fq_bigint4.neg(p.x);
        // let yp_prime = fq_bigint4.inv(p.y);
        // let xp_prime = fq_bigint4.mul(xp_bar, yp_prime);
        // paper algo:

        let C = compute_slope(pt0, pt1);
        let D = e2.add(pt0.x, pt1.x);
        let nx = e2.square(C);
        let nx = e2.sub(nx, D);
        let E = e2.mul(C, pt0.x);
        let E = e2.sub(E, pt0.y);
        let ny = e2.mul(C, nx);
        let ny = e2.sub(E, ny);
        // assert_on_curve(res);

        // let F = e2.mul_by_element(xp_prime, C);
        // let G = e2.mul_by_element(yp_prime, E);
        // let one_e2 = e2.one();
        tempvar res: G2Point* = new G2Point(nx, ny);
        tempvar line_eval: E4* = new E4(E, C);
        return (res, line_eval);
    }

    // Adds two points on the elliptic curve.
    // Assumption: pt0.x != pt1.x (however, pt0 = pt1 = 0 is allowed).
    // Note that this means that the function cannot be used if pt0 = pt1
    // (use ec_double() in this case) or pt0 = -pt1 (the result is 0 in this case).
    func fast_ec_add{range_check_ptr}(pt0: G2Point*, pt1: G2Point*) -> G2Point* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        let is_zero_pt0_x = e2.is_zero(pt0.x);
        let is_zero_pt1_x = e2.is_zero(pt1.x);
        if (is_zero_pt0_x != 0) {
            return pt1;
        }
        if (is_zero_pt1_x != 0) {
            return pt0;
        }
        let slope: E2* = compute_slope(pt0, pt1);
        let (slope_sqr_a0: UnreducedBigInt7, slope_sqr_a1: UnreducedBigInt7) = square_e2_unreduced(
            slope
        );
        local new_x_a0: BigInt4;
        local new_x_a1: BigInt4;
        local new_y_a0: BigInt4;
        local new_y_a1: BigInt4;
        %{
            from starkware.python.math_utils import div_mod

            assert 1 < ids.N_LIMBS <= 12
            assert ids.DEGREE == ids.N_LIMBS-1
            pt0x0,pt0x1,pt0y0,pt0y1,pt1x0,pt1x1,slope,p=0,0,0,0,0,0,[0,0],0

            def split(x, degree=ids.DEGREE, base=ids.BASE):
                coeffs = []
                for n in range(degree, 0, -1):
                    q, r = divmod(x, base ** n)
                    coeffs.append(q)
                    x = r
                coeffs.append(x)
                return coeffs[::-1]
            def inv_e2(a0:int, a1:int):
                t0, t1 = (a0 * a0 % p, a1 * a1 % p)
                t0 = (t0 + t1) % p
                t1 = pow(t0, -1, p)
                return (a0 * t1 % p, -(a1 * t1) % p)
            def mul_e2(x:(int,int), y:(int,int)):
                a = (x[0] + x[1]) * (y[0] + y[1]) % p
                b, c  = x[0]*y[0] % p, x[1]*y[1] % p
                return (b - c) % p, (a - b - c) % p
            def sub_e2(x:(int,int), y:(int,int)):
                return (x[0]-y[0]) % p, (x[1]-y[1]) % p

            for i in range(ids.N_LIMBS):
                pt0x0+=getattr(ids.pt0.x.a0, 'd'+str(i)) * ids.BASE**i
                pt0x1+=getattr(ids.pt0.x.a1, 'd'+str(i)) * ids.BASE**i
                pt0y0+=getattr(ids.pt0.y.a0, 'd'+str(i)) * ids.BASE**i
                pt0y1+=getattr(ids.pt0.y.a1, 'd'+str(i)) * ids.BASE**i
                pt1x0+=getattr(ids.pt1.x.a0, 'd'+str(i)) * ids.BASE**i
                pt1x1+=getattr(ids.pt1.x.a1, 'd'+str(i)) * ids.BASE**i
                slope[0]+=getattr(ids.slope.a0, 'd'+str(i)) * ids.BASE**i
                slope[1]+=getattr(ids.slope.a1, 'd'+str(i)) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

            new_x = sub_e2(sub_e2(mul_e2(slope, slope), (pt0x0,pt0x1)), (pt1x0,pt1x1))
            new_y = sub_e2(mul_e2(slope, sub_e2((pt0x0,pt0x1), new_x)), (pt0y0,pt0y1))

            new_xs, new_ys = [split(new_x[0]), split(new_x[1])], [split(new_y[0]), split(new_y[1])]

            for i in range(ids.N_LIMBS):
                setattr(ids.new_x_a0, 'd'+str(i), new_xs[0][i])
                setattr(ids.new_x_a1, 'd'+str(i), new_xs[1][i])
                setattr(ids.new_y_a0, 'd'+str(i), new_ys[0][i])
                setattr(ids.new_y_a1, 'd'+str(i), new_ys[1][i])
        %}

        verify_zero7(
            UnreducedBigInt7(
                d0=slope_sqr_a0.d0 - new_x_a0.d0 - pt0.x.a0.d0 - pt1.x.a0.d0,
                d1=slope_sqr_a0.d1 - new_x_a0.d1 - pt0.x.a0.d1 - pt1.x.a0.d1,
                d2=slope_sqr_a0.d2 - new_x_a0.d2 - pt0.x.a0.d2 - pt1.x.a0.d2,
                d3=slope_sqr_a0.d3 - new_x_a0.d3 - pt0.x.a0.d3 - pt1.x.a0.d3,
                d4=slope_sqr_a0.d4,
                d5=slope_sqr_a0.d5,
                d6=slope_sqr_a0.d6,
            ),
        );
        verify_zero7(
            UnreducedBigInt7(
                d0=slope_sqr_a1.d0 - new_x_a1.d0 - pt0.x.a1.d0 - pt1.x.a1.d0,
                d1=slope_sqr_a1.d1 - new_x_a1.d1 - pt0.x.a1.d1 - pt1.x.a1.d1,
                d2=slope_sqr_a1.d2 - new_x_a1.d2 - pt0.x.a1.d2 - pt1.x.a1.d2,
                d3=slope_sqr_a1.d3 - new_x_a1.d3 - pt0.x.a1.d3 - pt1.x.a1.d3,
                d4=slope_sqr_a1.d4,
                d5=slope_sqr_a1.d5,
                d6=slope_sqr_a1.d6,
            ),
        );
        local x_min_new_x_a0: BigInt4 = BigInt4(
            d0=pt0.x.a0.d0 - new_x_a0.d0,
            d1=pt0.x.a0.d1 - new_x_a0.d1,
            d2=pt0.x.a0.d2 - new_x_a0.d2,
            d3=pt0.x.a0.d3 - new_x_a0.d3,
        );
        local x_min_new_x_a1: BigInt4 = BigInt4(
            d0=pt0.x.a1.d0 - new_x_a1.d0,
            d1=pt0.x.a1.d1 - new_x_a1.d1,
            d2=pt0.x.a1.d2 - new_x_a1.d2,
            d3=pt0.x.a1.d3 - new_x_a1.d3,
        );
        local x_min_new_x: E2 = E2(&x_min_new_x_a0, &x_min_new_x_a1);

        let (
            x_diff_slope_a0: UnreducedBigInt7, x_diff_slope_a1: UnreducedBigInt7
        ) = mul_e2_unreduced(&x_min_new_x, slope);

        verify_zero7(
            UnreducedBigInt7(
                d0=x_diff_slope_a0.d0 - pt0.y.a0.d0 - new_y_a0.d0,
                d1=x_diff_slope_a0.d1 - pt0.y.a0.d1 - new_y_a0.d1,
                d2=x_diff_slope_a0.d2 - pt0.y.a0.d2 - new_y_a0.d2,
                d3=x_diff_slope_a0.d3 - pt0.y.a0.d3 - new_y_a0.d3,
                d4=x_diff_slope_a0.d4,
                d5=x_diff_slope_a0.d5,
                d6=x_diff_slope_a0.d6,
            ),
        );
        verify_zero7(
            UnreducedBigInt7(
                d0=x_diff_slope_a1.d0 - pt0.y.a1.d0 - new_y_a1.d0,
                d1=x_diff_slope_a1.d1 - pt0.y.a1.d1 - new_y_a1.d1,
                d2=x_diff_slope_a1.d2 - pt0.y.a1.d2 - new_y_a1.d2,
                d3=x_diff_slope_a1.d3 - pt0.y.a1.d3 - new_y_a1.d3,
                d4=x_diff_slope_a1.d4,
                d5=x_diff_slope_a1.d5,
                d6=x_diff_slope_a1.d6,
            ),
        );
        local new_x: E2 = E2(&new_x_a0, &new_x_a1);
        local new_y: E2 = E2(&new_y_a0, &new_y_a1);
        local res: G2Point = G2Point(&new_x, &new_y);
        return &res;
    }
    // Same as fast_ec_add, except that the cases pt0 = ±pt1 are supported.
    func add{range_check_ptr}(pt0: G2Point*, pt1: G2Point*) -> G2Point* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local x_diff_a0: BigInt4 = BigInt4(
            d0=pt0.x.a0.d0 - pt1.x.a0.d0,
            d1=pt0.x.a0.d1 - pt1.x.a0.d1,
            d2=pt0.x.a0.d2 - pt1.x.a0.d2,
            d3=pt0.x.a0.d3 - pt1.x.a0.d3,
        );
        local x_diff_a1: BigInt4 = BigInt4(
            d0=pt0.x.a1.d0 - pt1.x.a1.d0,
            d1=pt0.x.a1.d1 - pt1.x.a1.d1,
            d2=pt0.x.a1.d2 - pt1.x.a1.d2,
            d3=pt0.x.a1.d3 - pt1.x.a1.d3,
        );
        local x_diff: E2 = E2(&x_diff_a0, &x_diff_a1);

        let same_x: felt = e2.is_zero(&x_diff);
        if (same_x == 0) {
            // pt0.x != pt1.x so we can use fast_ec_add.
            return fast_ec_add(pt0, pt1);
        }

        // We have pt0.x = pt1.x. This implies pt0.y = ±pt1.y.
        // Check whether pt0.y = -pt1.y.
        local y_sum_a0: BigInt4 = BigInt4(
            d0=pt0.y.a0.d0 + pt1.y.a0.d0,
            d1=pt0.y.a0.d1 + pt1.y.a0.d1,
            d2=pt0.y.a0.d2 + pt1.y.a0.d2,
            d3=pt0.y.a0.d3 + pt1.y.a0.d3,
        );
        local y_sum_a1: BigInt4 = BigInt4(
            d0=pt0.y.a1.d0 + pt1.y.a1.d0,
            d1=pt0.y.a1.d1 + pt1.y.a1.d1,
            d2=pt0.y.a1.d2 + pt1.y.a1.d2,
            d3=pt0.y.a1.d3 + pt1.y.a1.d3,
        );

        local y_sum: E2 = E2(&y_sum_a0, &y_sum_a1);

        let opposite_y: felt = e2.is_zero(&y_sum);
        if (opposite_y != 0) {
            // pt0.y = -pt1.y.
            // Note that the case pt0 = pt1 = 0 falls into this branch as well.
            let zero2 = e2.zero();
            local ZERO_POINT: G2Point = G2Point(zero2, zero2);
            return &ZERO_POINT;
        } else {
            // pt0.y = pt1.y.
            return double(pt0);
        }
    }

    // Given 0 <= m < 250, a scalar and a point on the elliptic curve, pt,
    // verifies that 0 <= scalar < 2**m and returns (2**m * pt, scalar * pt).
    func ec_mul_inner{range_check_ptr}(pt: G2Point*, scalar: felt, m: felt) -> (
        pow2: G2Point*, res: G2Point*
    ) {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        // %{ print(f"scalar = {ids.scalar}, m=={ids.m}") %}
        if (m == 0) {
            assert scalar = 0;
            let zero2 = e2.zero();
            local ZERO_POINT: G2Point = G2Point(zero2, zero2);
            return (pow2=pt, res=&ZERO_POINT);
        }

        let double_pt: G2Point* = double(pt);
        // %{ print_G2(ids.double_pt) %}
        %{ memory[ap] = (ids.scalar % PRIME) % 2 %}
        jmp odd if [ap] != 0, ap++;
        return ec_mul_inner(pt=double_pt, scalar=scalar / 2, m=m - 1);

        odd:
        let (local inner_pow2: G2Point*, inner_res: G2Point*) = ec_mul_inner(
            pt=double_pt, scalar=(scalar - 1) / 2, m=m - 1
        );
        // Here inner_res = (scalar - 1) / 2 * double_pt = (scalar - 1) * pt.
        // Assume pt != 0 and that inner_res = ±pt. We obtain (scalar - 1) * pt = ±pt =>
        // scalar - 1 = ±1 (mod N) => scalar = 0 or 2.
        // In both cases (scalar - 1) / 2 cannot be in the range [0, 2**(m-1)), so we get a
        // contradiction.
        let res: G2Point* = fast_ec_add(pt0=pt, pt1=inner_res);
        return (pow2=inner_pow2, res=res);
    }

    func scalar_mul{range_check_ptr}(pt: G2Point*, scalar: BigInt4*) -> (res: G2Point*) {
        alloc_locals;
        let (pow2_0: G2Point*, local res0: G2Point*) = ec_mul_inner(pt, scalar.d0, 96);
        %{
            print('first limb')
            print_G2(ids.pow2_0)
            print_G2(ids.res0)
        %}
        let (pow2_1: G2Point*, local res1: G2Point*) = ec_mul_inner(pow2_0, scalar.d1, 96);
        %{
            print('second limb')
            print_G2(ids.pow2_1)
            print_G2(ids.res1)
        %}

        let (_, local res2: G2Point*) = ec_mul_inner(pow2_1, scalar.d2, 63);
        %{
            print('third limb')
            print_G2(ids.res2)
        %}
        let res: G2Point* = add(res0, res1);
        let res: G2Point* = add(res, res2);
        return (res,);
    }
}

// Returns the generator point of G2
// func get_g2_generator{range_check_ptr}() -> G2Point* {
//     alloc_locals;
//     let (__fp__, _) = get_fp_and_pc();

// local g2x0: BigInt4;
//     local g2x1: BigInt4;
//     local g2y0: BigInt4;
//     local g2y1: BigInt4;
//     %{
//         import subprocess
//         import functools
//         import re
//         from starkware.cairo.common.cairo_secp.secp_utils import split

// def rgetattr(obj, attr, *args):
//             def _getattr(obj, attr):
//                 return getattr(obj, attr, *args)
//             return functools.reduce(_getattr, [obj] + attr.split('.'))
//         def rsetattr(obj, attr, val):
//             pre, _, post = attr.rpartition('.')
//             return setattr(rgetattr(obj, pre) if pre else obj, post, val)
//         def fill_element(element:str, value:int):
//             s = split(value)
//             for i in range(3): rsetattr(ids,element+'.d'+str(i),s[i])

// fill_element('g2x0', 10857046999023057135944570762232829481370756359578518086990519993285655852781)
//         fill_element('g2x1', 11559732032986387107991004021392285783925812861821192530917403151452391805634)
//         fill_element('g2y0', 8495653923123431417604973247489272438418190587263600148770280649306958101930)
//         fill_element('g2y1', 4082367875863433681332203403145435568316851327593401208105741076214120093531)
//     %}
//     tempvar res: G2Point* = new G2Point(new E2(&g2x0, &g2x1), new E2(&g2y0, &g2y1));
//     return res;
// }

// // Returns two times the generator point of G2 with uint256 complex coordinates
// func get_n_g2_generator{range_check_ptr}(n: felt) -> G2Point* {
//     alloc_locals;
//     let (__fp__, _) = get_fp_and_pc();
//     local g2x0: BigInt4;
//     local g2x1: BigInt4;
//     local g2y0: BigInt4;
//     local g2y1: BigInt4;
//     %{
//         from starkware.cairo.common.cairo_secp.secp_utils import split
//         import subprocess
//         import functools
//         import re
//         def rgetattr(obj, attr, *args):
//             def _getattr(obj, attr):
//                 return getattr(obj, attr, *args)
//             return functools.reduce(_getattr, [obj] + attr.split('.'))
//         def rsetattr(obj, attr, val):
//             pre, _, post = attr.rpartition('.')
//             return setattr(rgetattr(obj, pre) if pre else obj, post, val)
//         def parse_fp_elements(input_string:str):
//             pattern = re.compile(r'\[([^\[\]]+)\]')
//             substrings = pattern.findall(input_string)
//             sublists = [substring.split(' ') for substring in substrings]
//             print(sublists)
//             sublists = [[int(x) for x in sublist] for sublist in sublists]
//             fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 for x in sublists]
//             return fp_elements
//         def fill_element(element:str, value:int):
//             s = split(value)
//             for i in range(3): rsetattr(ids,element+'.d'+str(i),s[i])

// cmd = ['./tools/parser_go/main', 'nG1nG2', '1', str(ids.n)]
//         out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
//         fp_elements = parse_fp_elements(out)
//         assert len(fp_elements) == 6

// fill_element('g2x0', fp_elements[2])
//         fill_element('g2x1', fp_elements[3])
//         fill_element('g2y0', fp_elements[4])
//         fill_element('g2y1', fp_elements[5])
//     %}
//     tempvar res: G2Point* = new G2Point(new E2(&g2x0, &g2x1), new E2(&g2y0, &g2y1));
//     return res;
// }
