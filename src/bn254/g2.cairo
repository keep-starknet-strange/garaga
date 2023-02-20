from src.bn254.towers.e2 import e2, E2
from src.bn254.towers.e6 import e6, E6
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_secp.bigint import (
    BigInt3,
    UnreducedBigInt3,
    nondet_bigint3,
    UnreducedBigInt5,
    bigint_mul,
    bigint_to_uint256,
    uint256_to_bigint,
)
from src.bn254.fq import fq_bigint3, is_zero, verify_zero5
from src.bn254.g1 import G1Point
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

// A G2 element (elliptic curve point) as two Fq2 coordinates with uint256 Fq elements.
struct G2Point {
    x: E2,
    y: E2,
}

namespace g2 {
    func assert_on_curve{range_check_ptr}(pt: G2Point) -> () {
        alloc_locals;
        let left: E2 = e2.mul(pt.y, pt.y);
        let x_sq = e2.square(pt.x);
        let x_cube = e2.mul(x_sq, pt.x);
        local b2: E2;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import split
            def rgetattr(obj, attr, *args):
                def _getattr(obj, attr):
                    return getattr(obj, attr, *args)
                return functools.reduce(_getattr, [obj] + attr.split('.'))

            def rsetattr(obj, attr, val):
                pre, _, post = attr.rpartition('.')
                return setattr(rgetattr(obj, pre) if pre else obj, post, val)

            def fill_e2(e2:str, a0:int, a1:int):
                sa0 = split(a0)
                sa1 = split(a1)
                for i in range(3): rsetattr(ids,e2+'.a0.d'+str(i),sa0[i])
                for i in range(3): rsetattr(ids,e2+'.a1.d'+str(i),sa1[i])

            fill_e2('b2',19485874751759354771024239261021720505790618469301721065564631296452457478373 , 266929791119991161246907387137283842545076965332900288569378510910307636690)
        %}

        let right: E2 = e2.add(x_cube, b2);

        assert left = right;
        return ();
    }
    func neg{range_check_ptr}(pt: G2Point) -> G2Point {
        alloc_locals;
        let x = pt.x;
        let y = e2.neg(pt.y);
        let res = G2Point(x, y);
        return res;
    }
    func compute_doubling_slope{range_check_ptr}(pt: G2Point) -> E2 {
        // Returns the slope of the elliptic curve at the given point.
        // The slope is used to compute pt + pt.
        // Assumption: pt != 0.
        // Note that y cannot be zero: assume that it is, then pt = -pt, so 2 * pt = 0, which
        // contradicts the fact that the size of the curve is odd.
        alloc_locals;
        local slope: E2;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import pack
            from bn254 import Fp2, Fp

            P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            def rgetattr(obj, attr, *args):
                def _getattr(obj, attr):
                    return getattr(obj, attr, *args)
                return functools.reduce(_getattr, [obj] + attr.split('.'))

            def rsetattr(obj, attr, val):
                pre, _, post = attr.rpartition('.')
                return setattr(rgetattr(obj, pre) if pre else obj, post, val)

            def fill_e2(e2:str, a0:int, a1:int):
                sa0 = split(a0)
                sa1 = split(a1)
                for i in range(3): rsetattr(ids,e2+'.a0.d'+str(i),sa0[i])
                for i in range(3): rsetattr(ids,e2+'.a1.d'+str(i),sa1[i])
            def parse_e2(x):
                return [pack(x.a0, PRIME), pack(x.a1, PRIME)]

            x = parse_e2(ids.pt.x)
            y = parse_e2(ids.pt.y)

            x=Fp2(Fp(x[0]), Fp(x[1]))
            y=Fp2(Fp(y[0]), Fp(y[1]))

            num=Fp2(Fp(3))*x*x
            sub=Fp2(Fp(2))*y
            sub_inv= sub.inverse()
            value = num * sub_inv

            fill_e2('slope', value.a.x, value.b.x)


            # value = div_mod(3 * x ** 2, 2 * y, P)
        %}

        let a0_a1: UnreducedBigInt5 = bigint_mul(pt.x.a0, pt.x.a1);
        let a0_sqr: UnreducedBigInt5 = bigint_mul(pt.x.a0, pt.x.a0);
        let a1_sqr: UnreducedBigInt5 = bigint_mul(pt.x.a1, pt.x.a1);

        let slope_y_imag_first_term: UnreducedBigInt5 = bigint_mul(slope.a0, pt.y.a1);
        let slope_y_imag_second_term: UnreducedBigInt5 = bigint_mul(slope.a1, pt.y.a0);

        let slope_y_real_first_term: UnreducedBigInt5 = bigint_mul(slope.a0, pt.y.a0);
        let slope_y_real_second_term: UnreducedBigInt5 = bigint_mul(slope.a1, pt.y.a1);

        verify_zero5(
            UnreducedBigInt5(
                d0=2 * (3 * a0_a1.d0 - slope_y_imag_first_term.d0 - slope_y_imag_second_term.d0),
                d1=2 * (3 * a0_a1.d1 - slope_y_imag_first_term.d1 - slope_y_imag_second_term.d1),
                d2=2 * (3 * a0_a1.d2 - slope_y_imag_first_term.d2 - slope_y_imag_second_term.d2),
                d3=2 * (3 * a0_a1.d3 - slope_y_imag_first_term.d3 - slope_y_imag_second_term.d3),
                d4=2 * (3 * a0_a1.d4 - slope_y_imag_first_term.d4 - slope_y_imag_second_term.d4),
            ),
        );

        verify_zero5(
            UnreducedBigInt5(
                d0=3 * (a0_sqr.d0 - a1_sqr.d0) - 2 * (
                    slope_y_real_first_term.d0 - slope_y_real_second_term.d0
                ),
                d1=3 * (a0_sqr.d1 - a1_sqr.d1) - 2 * (
                    slope_y_real_first_term.d1 - slope_y_real_second_term.d1
                ),
                d2=3 * (a0_sqr.d2 - a1_sqr.d2) - 2 * (
                    slope_y_real_first_term.d2 - slope_y_real_second_term.d2
                ),
                d3=3 * (a0_sqr.d3 - a1_sqr.d3) - 2 * (
                    slope_y_real_first_term.d3 - slope_y_real_second_term.d3
                ),
                d4=3 * (a0_sqr.d4 - a1_sqr.d4) - 2 * (
                    slope_y_real_first_term.d4 - slope_y_real_second_term.d4
                ),
            ),
        );
        return slope;
    }

    // Returns the slope of the line connecting the two given points.
    // The slope is used to compute pt0 + pt1.
    // Assumption: pt0.x != pt1.x (mod field prime).
    func compute_slope{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
        pt0: G2Point, pt1: G2Point
    ) -> E2 {
        alloc_locals;
        local slope: E2;
        local x_diff: E2;
        %{
            from starkware.python.math_utils import div_mod
            from starkware.cairo.common.math_utils import as_int
            from starkware.cairo.common.cairo_secp.secp_utils import pack

            BASE=2**86
            P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            # Compute the slope.
            def rgetattr(obj, attr, *args):
                def _getattr(obj, attr):
                    return getattr(obj, attr, *args)
                return functools.reduce(_getattr, [obj] + attr.split('.'))
            def rsetattr(obj, attr, val):
                pre, _, post = attr.rpartition('.')
                return setattr(rgetattr(obj, pre) if pre else obj, post, val)

            def fill_e2(e2:str, a0:int, a1:int):
                sa0 = split(a0)
                sa1 = split(a1)
                for i in range(3): rsetattr(ids,e2+'.a0.d'+str(i),sa0[i])
                for i in range(3): rsetattr(ids,e2+'.a1.d'+str(i),sa1[i])
            def parse_e2(x):
                return [pack(x.a0, PRIME), pack(x.a1, PRIME)]


            x0 = parse_e2(ids.pt0.x)
            y0 = parse_e2(ids.pt0.y)

            x1 = parse_e2(ids.pt1.x)
            y1 = parse_e2(ids.pt1.y)

            from bn254 import Fp2, Fp

            y0=Fp2(Fp(y0[0]), Fp(y0[1]))
            y1=Fp2(Fp(y1[0]), Fp(y1[1]))
            x0=Fp2(Fp(x0[0]), Fp(x0[1]))
            x1=Fp2(Fp(x1[0]), Fp(x1[1]))

            sub = x0-x1
            sub_inv = sub.inverse()
            numerator = y0-y1
            value=numerator*sub_inv
            fill_e2('slope', value.a.x, value.b.x)
            print(value)

            # value = slope = div_mod(y0 - y1, x0 - x1, P)
        %}

        let x_diff_real = BigInt3(
            d0=pt0.x.a0.d0 - pt1.x.a0.d0, d1=pt0.x.a0.d1 - pt1.x.a0.d1, d2=pt0.x.a0.d2 - pt1.x.a0.d2
        );
        let x_diff_imag = BigInt3(
            d0=pt0.x.a1.d0 - pt1.x.a1.d0, d1=pt0.x.a1.d1 - pt1.x.a1.d1, d2=pt0.x.a1.d2 - pt1.x.a1.d2
        );

        assert x_diff.a0 = x_diff_real;
        assert x_diff.a1 = x_diff_imag;

        let x_diff_slope_imag_first_term: UnreducedBigInt5 = bigint_mul(x_diff.a0, slope.a1);
        let x_diff_slope_imag_second_term: UnreducedBigInt5 = bigint_mul(x_diff.a1, slope.a0);

        let x_diff_real_first_term: UnreducedBigInt5 = bigint_mul(x_diff.a0, slope.a0);
        let x_diff_real_second_term: UnreducedBigInt5 = bigint_mul(x_diff.a1, slope.a1);

        verify_zero5(
            UnreducedBigInt5(
                d0=x_diff_slope_imag_first_term.d0 + x_diff_slope_imag_second_term.d0 -
                pt0.y.a1.d0 + pt1.y.a1.d0,
                d1=x_diff_slope_imag_first_term.d1 + x_diff_slope_imag_second_term.d1 -
                pt0.y.a1.d1 + pt1.y.a1.d1,
                d2=x_diff_slope_imag_first_term.d2 + x_diff_slope_imag_second_term.d2 -
                pt0.y.a1.d2 + pt1.y.a1.d2,
                d3=x_diff_slope_imag_first_term.d3 + x_diff_slope_imag_second_term.d3,
                d4=x_diff_slope_imag_first_term.d4 + x_diff_slope_imag_second_term.d4,
            ),
        );

        verify_zero5(
            UnreducedBigInt5(
                d0=x_diff_real_first_term.d0 - x_diff_real_second_term.d0 - pt0.y.a0.d0 +
                pt1.y.a0.d0,
                d1=x_diff_real_first_term.d1 - x_diff_real_second_term.d1 - pt0.y.a0.d1 +
                pt1.y.a0.d1,
                d2=x_diff_real_first_term.d2 - x_diff_real_second_term.d2 - pt0.y.a0.d2 +
                pt1.y.a0.d2,
                d3=x_diff_real_first_term.d3 - x_diff_real_second_term.d3,
                d4=x_diff_real_first_term.d4 - x_diff_real_second_term.d4,
            ),
        );

        return slope;
    }

    // Given a point 'pt' on the elliptic curve, computes pt + pt.
    func double{range_check_ptr}(pt: G2Point) -> (res: G2Point) {
        if (pt.x.d0 == 0) {
            if (pt.x.d1 == 0) {
                if (pt.x.d2 == 0) {
                    return (pt,);
                }
            }
        }

        let (slope: FQ2_) = compute_doubling_slope(pt);
        let (slope_sqr: UnreducedBigInt5) = bigint_mul(slope, slope);

        %{
            from starkware.cairo.common.cairo_secp.secp_utils import pack

            P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            slope = pack(ids.slope, PRIME)
            x = pack(ids.pt.x, PRIME)
            y = pack(ids.pt.y, PRIME)

            value = new_x = (pow(slope, 2, P) - 2 * x) % P
        %}
        let (new_x: BigInt3) = nondet_bigint3();

        %{ value = new_y = (slope * (x - new_x) - y) % P %}
        let (new_y: BigInt3) = nondet_bigint3();

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

        return (G2Point(new_x, new_y),);
    }
    // DoubleStep doubles a point in affine coordinates, and evaluates the line in Miller loop
    // https://eprint.iacr.org/2013/722.pdf (Section 4.3)
    func double_step{range_check_ptr}(pt: G2Point, p: G1Point) -> (res: G2Point, line_eval: E6) {
        alloc_locals;
        // if (pt.x.d0 == 0) {
        //     if (pt.x.d1 == 0) {
        //         if (pt.x.d2 == 0) {
        //             let zero_6 = E6.zero();
        //             return (pt, zero_6);
        //         }
        //     }
        // }
        // precomputations in p :
        let xp_bar = fq_bigint3.neg(p.x);
        let yp_prime = fq_bigint3.inv(p.y);
        let xp_prime = fq_bigint3.mul(p.x, yp_prime);
        // paper algo:
        let two_y = e2.double(pt.y);
        let A = e2.inv(two_y);
        let x_sq = e2.square(pt.x);

        let B = e2.mul_by_element(BigInt3(3, 0, 0), x_sq);
        let C = e2.mul(A, B);
        let D = e2.double(pt.x);
        let nx = e2.square(C);
        let nx = e2.sub(nx, D);
        let E = e2.mul(C, pt.x);
        let E = e2.sub(E, pt.y);
        let ny = e2.mul(C, nx);
        let ny = e2.sub(E, ny);
        let res = G2Point(nx, ny);

        let F = e2.mul_by_element(xp_prime, C);
        let G = e2.mul_by_element(yp_prime, E);
        let one_e2 = e2.one();
        let line_eval: E6 = E6(one_e2, F, G);

        return (res, line_eval);
    }
    func add_step{range_check_ptr}(pt0: G2Point, pt1: G2Point, p: G1Point) -> (
        res: G2Point, line_eval: E6
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
        // precomputations in p :
        let xp_bar = fq_bigint3.neg(p.x);
        let yp_prime = fq_bigint3.inv(p.y);
        let xp_prime = fq_bigint3.mul(p.x, yp_prime);
        // paper algo:
        let x_diff = e2.sub(pt1.x, pt0.x);
        let A = e2.inv(x_diff);
        let B = e2.sub(pt1.y, pt0.y);
        let C = e2.mul(A, B);
        let D = e2.add(pt0.x, pt1.x);
        let nx = e2.square(C);
        let nx = e2.sub(nx, D);
        let E = e2.mul(C, pt0.x);
        let E = e2.sub(E, pt0.y);
        let ny = e2.mul(C, nx);
        let ny = e2.sub(E, ny);
        let res = G2Point(nx, ny);
        let F = e2.mul_by_element(xp_prime, C);
        let G = e2.mul_by_element(yp_prime, E);
        let one_e2 = e2.one();
        let line_eval: E6 = E6(one_e2, F, G);
        return (res, line_eval);
    }

    // Adds two points on the elliptic curve.
    // Assumption: pt0.x != pt1.x (however, pt0 = pt1 = 0 is allowed).
    // Note that this means that the function cannot be used if pt0 = pt1
    // (use ec_double() in this case) or pt0 = -pt1 (the result is 0 in this case).
    func fast_ec_add{range_check_ptr}(pt0: G2Point, pt1: G2Point) -> (res: G2Point) {
        let (slope: BigInt3) = compute_slope(pt0, pt1);
        let (slope_sqr: UnreducedBigInt5) = bigint_mul(slope, slope);

        %{
            from starkware.cairo.common.cairo_secp.secp_utils import pack

            P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            slope = pack(ids.slope, PRIME)
            x0 = pack(ids.pt0.x, PRIME)
            x1 = pack(ids.pt1.x, PRIME)
            y0 = pack(ids.pt0.y, PRIME)

            value = new_x = (pow(slope, 2, P) - x0 - x1) % P
        %}
        let (new_x: BigInt3) = nondet_bigint3();

        %{ value = new_y = (slope * (x0 - new_x) - y0) % P %}
        let (new_y: BigInt3) = nondet_bigint3();

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

        return (G2Point(new_x, new_y),);
    }
    // Same as fast_ec_add, except that the cases pt0 = ±pt1 are supported.
    func add{range_check_ptr}(pt0: G2Point, pt1: G2Point) -> (res: G2Point) {
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
            let ZERO_POINT = G2Point(BigInt3(0, 0, 0), BigInt3(0, 0, 0));
            return (ZERO_POINT,);
        } else {
            // pt0.y = pt1.y.
            return double(pt0);
        }
    }

    // Given 0 <= m < 250, a scalar and a point on the elliptic curve, pt,
    // verifies that 0 <= scalar < 2**m and returns (2**m * pt, scalar * pt).
    func ec_mul_inner{range_check_ptr}(pt: G2Point, scalar: felt, m: felt) -> (
        pow2: G2Point, res: G2Point
    ) {
        if (m == 0) {
            assert scalar = 0;
            let ZERO_POINT = G2Point(BigInt3(0, 0, 0), BigInt3(0, 0, 0));
            return (pow2=pt, res=ZERO_POINT);
        }

        alloc_locals;
        let (double_pt: G2Point) = double(pt);
        %{ memory[ap] = (ids.scalar % PRIME) % 2 %}
        jmp odd if [ap] != 0, ap++;
        return ec_mul_inner(pt=double_pt, scalar=scalar / 2, m=m - 1);

        odd:
        let (local inner_pow2: G2Point, inner_res: G2Point) = ec_mul_inner(
            pt=double_pt, scalar=(scalar - 1) / 2, m=m - 1
        );
        // Here inner_res = (scalar - 1) / 2 * double_pt = (scalar - 1) * pt.
        // Assume pt != 0 and that inner_res = ±pt. We obtain (scalar - 1) * pt = ±pt =>
        // scalar - 1 = ±1 (mod N) => scalar = 0 or 2.
        // In both cases (scalar - 1) / 2 cannot be in the range [0, 2**(m-1)), so we get a
        // contradiction.
        let (res: G2Point) = fast_ec_add(pt0=pt, pt1=inner_res);
        return (pow2=inner_pow2, res=res);
    }

    func scalar_mul{range_check_ptr}(pt: G2Point, scalar: BigInt3) -> (res: G2Point) {
        alloc_locals;
        let (pow2_0: G2Point, local res0: G2Point) = ec_mul_inner(pt, scalar.d0, 86);
        let (pow2_1: G2Point, local res1: G2Point) = ec_mul_inner(pow2_0, scalar.d1, 86);
        let (_, local res2: G2Point) = ec_mul_inner(pow2_1, scalar.d2, 84);
        let (res: G2Point) = add(res0, res1);
        let (res: G2Point) = add(res, res2);
        return (res,);
    }
}

// Returns the generator point of G2
func get_g2_generator{range_check_ptr}() -> G2Point {
    alloc_locals;
    local x: E2;
    local y: E2;
    %{
        import subprocess
        import functools
        import re
        from starkware.cairo.common.cairo_secp.secp_utils import split

        def rgetattr(obj, attr, *args):
            def _getattr(obj, attr):
                return getattr(obj, attr, *args)
            return functools.reduce(_getattr, [obj] + attr.split('.'))
        def rsetattr(obj, attr, val):
            pre, _, post = attr.rpartition('.')
            return setattr(rgetattr(obj, pre) if pre else obj, post, val)
        def fill_e2(e2:str, a0:int, a1:int):
            sa0 = split(a0)
            sa1 = split(a1)
            for i in range(3): rsetattr(ids,e2+'.a0.d'+str(i),sa0[i])
            for i in range(3): rsetattr(ids,e2+'.a1.d'+str(i),sa1[i])

        fill_e2('x', 10857046999023057135944570762232829481370756359578518086990519993285655852781, 11559732032986387107991004021392285783925812861821192530917403151452391805634)
        fill_e2('y', 8495653923123431417604973247489272438418190587263600148770280649306958101930, 4082367875863433681332203403145435568316851327593401208105741076214120093531)
    %}
    let res = G2Point(x, y);
    return res;
}

// Returns two times the generator point of G2 with uint256 complex coordinates
func get_n_g2_generator{range_check_ptr}(n: felt) -> G2Point {
    alloc_locals;
    local x: E2;
    local y: E2;
    %{
        from starkware.cairo.common.cairo_secp.secp_utils import split
        import subprocess
        import functools
        import re
        def rgetattr(obj, attr, *args):
            def _getattr(obj, attr):
                return getattr(obj, attr, *args)
            return functools.reduce(_getattr, [obj] + attr.split('.'))
        def rsetattr(obj, attr, val):
            pre, _, post = attr.rpartition('.')
            return setattr(rgetattr(obj, pre) if pre else obj, post, val)
        def parse_fp_elements(input_string:str):
            pattern = re.compile(r'\[([^\[\]]+)\]')
            substrings = pattern.findall(input_string)
            sublists = [substring.split(' ') for substring in substrings]
            print(sublists)
            sublists = [[int(x) for x in sublist] for sublist in sublists]
            fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 for x in sublists]
            return fp_elements
        def fill_e2(e2:str, a0:int, a1:int):
            sa0 = split(a0)
            sa1 = split(a1)
            for i in range(3): rsetattr(ids,e2+'.a0.d'+str(i),sa0[i])
            for i in range(3): rsetattr(ids,e2+'.a1.d'+str(i),sa1[i])

        cmd = ['./tools/parser_go/main', 'nG1nG2', '1', str(ids.n)]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 6

        fill_e2('x', fp_elements[2], fp_elements[3])
        fill_e2('y', fp_elements[4], fp_elements[5])
    %}
    let res = G2Point(x, y);
    return res;
}

// Returns the generator point of G2 with bigint3 complex coordinates.
func G2() -> (res: G2Point) {
    return (
        res=G2Point(
            x=E2(
                a0=BigInt3(
                    0x1edadd46debd5cd992f6ed, 0x199797111e59d0c8b53dd, 0x1800deef121f1e76426a0
                ),
                a1=BigInt3(
                    0x29e71297e485b7aef312c2, 0x3edcc7ed7497c6a924ccd6, 0x198e9393920d483a7260b
                ),
            ),
            y=E2(
                a0=BigInt3(
                    0x3d37b4ce6cc0166fa7daa, 0x602372d023f8f479da431, 0x12c85ea5db8c6deb4aab7
                ),
                a1=BigInt3(
                    0x338ef355acdadcd122975b, 0x26b5a430ce56f12cc4cdc2, 0x90689d0585ff075ec9e9
                ),
            ),
        ),
    );
}
