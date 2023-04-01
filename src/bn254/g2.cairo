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
from starkware.cairo.common.registers import get_fp_and_pc

// A G2 element (elliptic curve point) as two Fq2 coordinates with uint256 Fq elements.
struct G2Point {
    x: E2*,
    y: E2*,
}

struct E4 {
    r0: E2*,
    r1: E2*,
}
namespace g2 {
    func assert_on_curve{range_check_ptr}(pt: G2Point*) -> () {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        let left = e2.mul(pt.y, pt.y);
        let x_sq = e2.square(pt.x);
        let x_cube = e2.mul(x_sq, pt.x);
        local b20: BigInt3;
        local b21: BigInt3;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import split
            def rgetattr(obj, attr, *args):
                def _getattr(obj, attr):
                    return getattr(obj, attr, *args)
                return functools.reduce(_getattr, [obj] + attr.split('.'))

            def rsetattr(obj, attr, val):
                pre, _, post = attr.rpartition('.')
                return setattr(rgetattr(obj, pre) if pre else obj, post, val)
            def fill_element(element:str, value:int):
                s = split(value)
                for i in range(3): rsetattr(ids,element+'.d'+str(i),s[i])

            fill_element('b20',19485874751759354771024239261021720505790618469301721065564631296452457478373)
            fill_element('b21',266929791119991161246907387137283842545076965332900288569378510910307636690)
        %}
        tempvar b2: E2* = new E2(&b20, &b21);
        let right = e2.add(x_cube, b2);

        e2.assert_E2(left, right);
        return ();
    }
    func neg{range_check_ptr}(pt: G2Point*) -> G2Point* {
        alloc_locals;
        let x = pt.x;
        let y = e2.neg(pt.y);
        tempvar res = new G2Point(x, y);
        return res;
    }
    func compute_doubling_slope_with_hints{range_check_ptr}(pt: G2Point*) -> E2* {
        // Returns the slope of the elliptic curve at the given point.
        // The slope is used to compute pt + pt.
        // Assumption: pt != 0.
        // Note that y cannot be zero: assume that it is, then pt = -pt, so 2 * pt = 0, which
        // contradicts the fact that the size of the curve is odd.
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local slope_a0: BigInt3;
        local slope_a1: BigInt3;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import pack, split
            from tools.py.bn128_field import FQ2

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
            def fill_element(element:str, value:int):
                s = split(value)
                for i in range(3): rsetattr(ids,element+'.d'+str(i),s[i])
            def parse_e2(x):
                return [pack(x.a0, PRIME), pack(x.a1, PRIME)]

            x = parse_e2(ids.pt.x)
            y = parse_e2(ids.pt.y)
            x=FQ2(x)
            y=FQ2(y)
            num=3*x*x
            sub=2*y
            sub_inv= sub.inv()
            value = num * sub_inv
            # print("value",value.coeffs[0].n, value.coeffs[1].n)
            fill_element('slope_a0', value.coeffs[0].n)
            fill_element('slope_a1', value.coeffs[1].n)
            # value = div_mod(3 * x ** 2, 2 * y, P)
        %}

        let x0_x1: UnreducedBigInt5 = bigint_mul([pt.x.a0], [pt.x.a1]);
        let x0_sqr: UnreducedBigInt5 = bigint_mul([pt.x.a0], [pt.x.a0]);
        let x1_sqr: UnreducedBigInt5 = bigint_mul([pt.x.a1], [pt.x.a1]);

        let s0_y0: UnreducedBigInt5 = bigint_mul(slope_a0, [pt.y.a0]);
        let s1_y1: UnreducedBigInt5 = bigint_mul(slope_a1, [pt.y.a1]);

        let s0_y1: UnreducedBigInt5 = bigint_mul(slope_a0, [pt.y.a1]);
        let s1_y0: UnreducedBigInt5 = bigint_mul(slope_a1, [pt.y.a0]);

        // Verify real
        verify_zero5(
            UnreducedBigInt5(
                d0=3 * (x0_sqr.d0 - x1_sqr.d0) - 2 * (s0_y0.d0 - s1_y1.d0),
                d1=3 * (x0_sqr.d1 - x1_sqr.d1) - 2 * (s0_y0.d1 - s1_y1.d1),
                d2=3 * (x0_sqr.d2 - x1_sqr.d2) - 2 * (s0_y0.d2 - s1_y1.d2),
                d3=3 * (x0_sqr.d3 - x1_sqr.d3) - 2 * (s0_y0.d3 - s1_y1.d3),
                d4=3 * (x0_sqr.d4 - x1_sqr.d4) - 2 * (s0_y0.d4 - s1_y1.d4),
            ),
        );
        // Verify imaginary
        verify_zero5(
            UnreducedBigInt5(
                d0=2 * (3 * x0_x1.d0 - s0_y1.d0 - s1_y0.d0),
                d1=2 * (3 * x0_x1.d1 - s0_y1.d1 - s1_y0.d1),
                d2=2 * (3 * x0_x1.d2 - s0_y1.d2 - s1_y0.d2),
                d3=2 * (3 * x0_x1.d3 - s0_y1.d3 - s1_y0.d3),
                d4=2 * (3 * x0_x1.d4 - s0_y1.d4 - s1_y0.d4),
            ),
        );

        tempvar slope: E2* = new E2(a0=&slope_a0, a1=&slope_a1);
        return slope;
    }
    func compute_doubling_slope_pure_cairo_towers{range_check_ptr}(pt: G2Point) -> E2 {
        alloc_locals;
        let two_y = e2.double(pt.y);
        let A = e2.inv(two_y);
        let x_sq = e2.square(pt.x);
        tempvar three = new BigInt3(3, 0, 0);
        let B = e2.mul_by_element(three, x_sq);
        let C = e2.mul(A, B);  // lamba : slope
        return [C];
    }
    // Returns the slope of the line connecting the two given points.
    // The slope is used to compute pt0 + pt1.
    // Assumption: pt0.x != pt1.x (mod field prime).
    func compute_slope{range_check_ptr}(pt0: G2Point*, pt1: G2Point*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local slope_a0: BigInt3;
        local slope_a1: BigInt3;
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
            def fill_element(element:str, value:int):
                s = split(value)
                for i in range(3): rsetattr(ids,element+'.d'+str(i),s[i])
            def fill_e2(e2:str, a0:int, a1:int):
                sa0 = split(a0)
                sa1 = split(a1)
                for i in range(3): rsetattr(ids,e2+'.a0.d'+str(i),sa0[i])
                for i in range(3): rsetattr(ids,e2+'.a1.d'+str(i),sa1[i])
            def parse_e2(x):
                return [pack(x.a0, PRIME), pack(x.a1, PRIME)]

            from tools.py.bn128_field import FQ2
            x0 = FQ2(parse_e2(ids.pt0.x))
            x1 = FQ2(parse_e2(ids.pt1.x))

            y0 = FQ2(parse_e2(ids.pt0.y))
            y1 = FQ2(parse_e2(ids.pt1.y))

            sub = x0-x1
            sub_inv = sub.inv()
            numerator = y0-y1
            value=numerator*sub_inv
            fill_element('slope_a0', value.coeffs[0].n)
            fill_element('slope_a1', value.coeffs[1].n)

            # value = slope = div_mod(y0 - y1, x0 - x1, P)
        %}

        tempvar x_diff_real: BigInt3 = BigInt3(
            d0=pt0.x.a0.d0 - pt1.x.a0.d0, d1=pt0.x.a0.d1 - pt1.x.a0.d1, d2=pt0.x.a0.d2 - pt1.x.a0.d2
        );
        tempvar x_diff_imag: BigInt3 = BigInt3(
            d0=pt0.x.a1.d0 - pt1.x.a1.d0, d1=pt0.x.a1.d1 - pt1.x.a1.d1, d2=pt0.x.a1.d2 - pt1.x.a1.d2
        );

        let x_diff_slope_imag_first_term: UnreducedBigInt5 = bigint_mul(x_diff_real, slope_a1);
        let x_diff_slope_imag_second_term: UnreducedBigInt5 = bigint_mul(x_diff_imag, slope_a0);

        let x_diff_real_first_term: UnreducedBigInt5 = bigint_mul(x_diff_real, slope_a0);
        let x_diff_real_second_term: UnreducedBigInt5 = bigint_mul(x_diff_imag, slope_a1);

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
        tempvar slope = new E2(a0=&slope_a0, a1=&slope_a1);

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

        let (slope: FQ2_) = compute_doubling_slope_with_hints(pt);
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
    func double_step{range_check_ptr}(pt: G2Point*, p: G1Point*) -> (
        res: G2Point*, line_eval: E4*
    ) {
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

        let xp_bar = fq_bigint3.neg(p.x);
        let yp_prime = fq_bigint3.inv(p.y);
        let xp_prime = fq_bigint3.mul(xp_bar, yp_prime);
        // paper algo:
        // let two_y = e2.double(pt.y);
        // let A = e2.inv(two_y);
        // let x_sq = e2.square(pt.x);
        // tempvar three = new BigInt3(3, 0, 0);
        // let B = e2.mul_by_element(three, x_sq);
        // let C = e2.mul(A, B);  // lamba : slope
        let C = compute_doubling_slope_with_hints(pt);

        let D = e2.double(pt.x);
        let nx = e2.square(C);
        let nx = e2.sub(nx, D);
        let E = e2.mul(C, pt.x);
        let E = e2.sub(E, pt.y);
        let ny = e2.mul(C, nx);
        let ny = e2.sub(E, ny);

        // assert_on_curve(res);

        let F = e2.mul_by_element(xp_prime, C);
        let G = e2.mul_by_element(yp_prime, E);
        tempvar res: G2Point* = new G2Point(nx, ny);
        tempvar line_eval: E4* = new E4(F, G);

        return (res, line_eval);
    }
    func add_step{range_check_ptr}(pt0: G2Point*, pt1: G2Point*, p: G1Point*) -> (
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
        let xp_bar = fq_bigint3.neg(p.x);
        let yp_prime = fq_bigint3.inv(p.y);
        let xp_prime = fq_bigint3.mul(xp_bar, yp_prime);
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

        let F = e2.mul_by_element(xp_prime, C);
        let G = e2.mul_by_element(yp_prime, E);
        // let one_e2 = e2.one();
        tempvar res: G2Point* = new G2Point(nx, ny);
        tempvar line_eval: E4* = new E4(F, G);
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
func get_g2_generator{range_check_ptr}() -> G2Point* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    local g2x0: BigInt3;
    local g2x1: BigInt3;
    local g2y0: BigInt3;
    local g2y1: BigInt3;
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
        def fill_element(element:str, value:int):
            s = split(value)
            for i in range(3): rsetattr(ids,element+'.d'+str(i),s[i])

        fill_element('g2x0', 10857046999023057135944570762232829481370756359578518086990519993285655852781)
        fill_element('g2x1', 11559732032986387107991004021392285783925812861821192530917403151452391805634)
        fill_element('g2y0', 8495653923123431417604973247489272438418190587263600148770280649306958101930)
        fill_element('g2y1', 4082367875863433681332203403145435568316851327593401208105741076214120093531)
    %}
    tempvar res: G2Point* = new G2Point(new E2(&g2x0, &g2x1), new E2(&g2y0, &g2y1));
    return res;
}

// Returns two times the generator point of G2 with uint256 complex coordinates
func get_n_g2_generator{range_check_ptr}(n: felt) -> G2Point* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local g2x0: BigInt3;
    local g2x1: BigInt3;
    local g2y0: BigInt3;
    local g2y1: BigInt3;
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
            sublists = [[int(x) for x in sublist] for sublist in sublists]
            fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 for x in sublists]
            return fp_elements
        def fill_element(element:str, value:int):
            s = split(value)
            for i in range(3): rsetattr(ids,element+'.d'+str(i),s[i])

        cmd = ['./tools/parser_go/main', 'nG1nG2', '1', str(ids.n)]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 6

        fill_element('g2x0', fp_elements[2])
        fill_element('g2x1', fp_elements[3])
        fill_element('g2y0', fp_elements[4])
        fill_element('g2y1', fp_elements[5])
    %}
    tempvar res: G2Point* = new G2Point(new E2(&g2x0, &g2x1), new E2(&g2y0, &g2y1));
    return res;
}
