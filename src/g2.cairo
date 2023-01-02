from src.fq2 import fq2, FQ2
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
from src.field import is_zero, verify_zero5
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

struct FQ2_ {
    e0: BigInt3,
    e1: BigInt3,
}

struct G2Point {
    x: FQ2,
    y: FQ2,
}

struct G2Point_ {
    x: FQ2_,
    y: FQ2_,
}

struct G2JacobPoint {
    x: FQ2,
    y: FQ2,
    z: FQ2,
}

// func ec_point_to_affine{range_check_ptr}(p: EcPoint) -> AffinePoint {
//     alloc_locals;
//     let (x_256) = bigint_to_uint256(p.x);
//     let (y_256) = bigint_to_uint256(p.y);
//     let res = AffinePoint(x_256, y_256);
//     return res;
// }

func FQ2_to_FQ2_{range_check_ptr}(p: FQ2) -> FQ2_ {
    alloc_locals;
    let (e0_Bigint) = uint256_to_bigint(p.e0);
    let (e1_Bigint) = uint256_to_bigint(p.e1);
    let res = FQ2_(e0_Bigint, e1_Bigint);
    return res;
}

func affine_to_ec_point{range_check_ptr}(p: G2Point) -> G2Point_ {
    alloc_locals;
    let x_Bigint = FQ2_to_FQ2_(p.x);
    let y_Bigint = FQ2_to_FQ2_(p.y);
    let res = G2Point_(x_Bigint, y_Bigint);
    return res;
}
// Returns the slope of the elliptic curve at the given point.
// The slope is used to compute pt + pt.
// Assumption: pt != 0.
namespace g2_weierstrass_arithmetics {
    func compute_doubling_slope{range_check_ptr}(pt: G2Point) -> FQ2_ {
        // Note that y cannot be zero: assume that it is, then pt = -pt, so 2 * pt = 0, which
        // contradicts the fact that the size of the curve is odd.
        alloc_locals;
        local slope: FQ2_;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import pack
            from starkware.python.math_utils import div_mod
            from bn254 import Fp2, Fp

            P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            def pack_fq2_uint256(z):
                return (z.e0.low + (z.e0.high << 128), z.e1.low + (z.e1.high << 128))

            def pack_fq2_bigint3(z):
                """
                Takes an UnreducedBigInt3 struct which represents a triple of limbs (d0, d1, d2) of field
                elements and reconstructs the corresponding 256-bit integer (see split()).
                Note that the limbs do not have to be in the range [0, BASE).
                prime should be the Cairo field, and it is used to handle negative values of the limbs.
                """
                limbs_real = z.e0.d0, z.e0.d1, z.e0.d2
                limbs_imag = z.e1.d0, z.e1.d1, z.e1.d2
                print(limbs_real)
                print(limbs_imag)
                return (sum(as_int(limb, prime) * (BASE**i) for i, limb in enumerate(limbs_real)), 
                sum(as_int(limb, prime) * (BASE**i) for i, limb in enumerate(limbs_imag)))
            def split_128(a):
                return (a & ((1 << 128) - 1), a >> 128)
            def to_bigint(a):

                RC_BOUND = 2 ** 128
                BASE = 2**86
                low, high = split_128(a)
                D1_HIGH_BOUND = BASE ** 2 // RC_BOUND
                D1_LOW_BOUND = RC_BOUND // BASE
                d1_low, d0 = divmod(low, BASE)
                d2, d1_high = divmod(high, D1_HIGH_BOUND)
                d1 = d1_high * D1_LOW_BOUND + d1_low

                return (d0, d1, d2)

            x = pack_fq2_uint256(ids.pt.x)
            y = pack_fq2_uint256(ids.pt.y)

            x=Fp2(Fp(x[0]), Fp(x[1]))
            y=Fp2(Fp(y[0]), Fp(y[1]))

            num=Fp2(Fp(3))*x*x
            sub=Fp2(Fp(2))*y
            sub_inv= sub.inverse()
            value = num * sub_inv

            e0=to_bigint(value.a.x)
            e1=to_bigint(value.b.x)
            ids.slope.e0.d0 = e0[0]
            ids.slope.e0.d1 = e0[1]
            ids.slope.e0.d2 = e0[2]
            ids.slope.e1.d0 = e1[0]
            ids.slope.e1.d1 = e1[1]
            ids.slope.e1.d2 = e1[2]

            # value = div_mod(3 * x ** 2, 2 * y, P)
        %}
        let pt_ = affine_to_ec_point(pt);
        let a0_a1: UnreducedBigInt5 = bigint_mul(pt_.x.e0, pt_.x.e1);
        let a0_sqr: UnreducedBigInt5 = bigint_mul(pt_.x.e0, pt_.x.e0);
        let a1_sqr: UnreducedBigInt5 = bigint_mul(pt_.x.e1, pt_.x.e1);

        let slope_y_imag_first_term: UnreducedBigInt5 = bigint_mul(slope.e0, pt_.y.e1);
        let slope_y_imag_second_term: UnreducedBigInt5 = bigint_mul(slope.e1, pt_.y.e0);

        let slope_y_real_first_term: UnreducedBigInt5 = bigint_mul(slope.e0, pt_.y.e0);
        let slope_y_real_second_term: UnreducedBigInt5 = bigint_mul(slope.e1, pt_.y.e1);

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
    ) -> FQ2_ {
        alloc_locals;
        local slope: FQ2;
        local slope_: FQ2_;
        local x_diff__: FQ2_;
        local x_diff_: FQ2_;
        %{
            from starkware.python.math_utils import div_mod
            from starkware.cairo.common.math_utils import as_int
            BASE=2**86
            prime = 2**251 + 17*2**192 + 1
            P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            # Compute the slope.
            def pack_fq2_uint256(z):
                return (z.e0.low + (z.e0.high << 128), z.e1.low + (z.e1.high << 128))

            def pack_fq2_bigint3(z):
                """
                Takes an UnreducedBigInt3 struct which represents a triple of limbs (d0, d1, d2) of field
                elements and reconstructs the corresponding 256-bit integer (see split()).
                Note that the limbs do not have to be in the range [0, BASE).
                prime should be the Cairo field, and it is used to handle negative values of the limbs.
                """
                limbs_real = z.e0.d0, z.e0.d1, z.e0.d2
                limbs_imag = z.e1.d0, z.e1.d1, z.e1.d2
                print(limbs_real)
                print(limbs_imag)
                return (sum(as_int(limb, prime) * (BASE**i) for i, limb in enumerate(limbs_real)), 
                sum(as_int(limb, prime) * (BASE**i) for i, limb in enumerate(limbs_imag)))

            def split_128(a):
                return (a & ((1 << 128) - 1), a >> 128)

            x0 = pack_fq2_uint256(ids.pt0.x)
            y0 = pack_fq2_uint256(ids.pt0.y)

            x1 = pack_fq2_uint256(ids.pt1.x)
            y1 = pack_fq2_uint256(ids.pt1.y)

            from bn254 import Fp2, Fp

            y0=Fp2(Fp(y0[0]), Fp(y0[1]))
            y1=Fp2(Fp(y1[0]), Fp(y1[1]))
            x0=Fp2(Fp(x0[0]), Fp(x0[1]))
            x1=Fp2(Fp(x1[0]), Fp(x1[1]))

            sub = x0-x1
            sub_inv = sub.inverse()
            numerator = y0-y1
            value=numerator*sub_inv
            e0=split_128(value.a.x)
            e1=split_128(value.b.x)
            ids.slope.e0.low = e0[0]
            ids.slope.e0.high = e0[1]
            ids.slope.e1.low = e1[0]
            ids.slope.e1.high = e1[1]

            print(value)

            # value = slope = div_mod(y0 - y1, x0 - x1, P)
        %}

        let pt0_ = affine_to_ec_point(pt0);
        let pt1_ = affine_to_ec_point(pt1);

        let x_diff_real = BigInt3(
            d0=pt0_.x.e0.d0 - pt1_.x.e0.d0,
            d1=pt0_.x.e0.d1 - pt1_.x.e0.d1,
            d2=pt0_.x.e0.d2 - pt1_.x.e0.d2,
        );
        let x_diff_imag = BigInt3(
            d0=pt0_.x.e1.d0 - pt1_.x.e1.d0,
            d1=pt0_.x.e1.d1 - pt1_.x.e1.d1,
            d2=pt0_.x.e1.d2 - pt1_.x.e1.d2,
        );

        assert x_diff__.e0 = x_diff_real;
        assert x_diff__.e1 = x_diff_imag;

        let x_diff_ = x_diff__;
        %{
            # print('X_DIFF_256',pack_fq2_uint256(ids.x_diff))
            print('X_DIFF_BIGINT3',pack_fq2_bigint3(ids.x_diff_))
            print('X_DIFF__BIGINT3',pack_fq2_bigint3(ids.x_diff__))
        %}

        // assert x_diff_ = x_diff__;

        let slope_ = FQ2_to_FQ2_(slope);
        let x_diff_slope_imag_first_term: UnreducedBigInt5 = bigint_mul(x_diff_.e0, slope_.e1);
        let x_diff_slope_imag_second_term: UnreducedBigInt5 = bigint_mul(x_diff_.e1, slope_.e0);

        let x_diff_real_first_term: UnreducedBigInt5 = bigint_mul(x_diff_.e0, slope_.e0);
        let x_diff_real_second_term: UnreducedBigInt5 = bigint_mul(x_diff_.e1, slope_.e1);

        verify_zero5(
            UnreducedBigInt5(
                d0=x_diff_slope_imag_first_term.d0 + x_diff_slope_imag_second_term.d0 -
                pt0_.y.e1.d0 + pt1_.y.e1.d0,
                d1=x_diff_slope_imag_first_term.d1 + x_diff_slope_imag_second_term.d1 -
                pt0_.y.e1.d1 + pt1_.y.e1.d1,
                d2=x_diff_slope_imag_first_term.d2 + x_diff_slope_imag_second_term.d2 -
                pt0_.y.e1.d2 + pt1_.y.e1.d2,
                d3=x_diff_slope_imag_first_term.d3 + x_diff_slope_imag_second_term.d3,
                d4=x_diff_slope_imag_first_term.d4 + x_diff_slope_imag_second_term.d4,
            ),
        );

        verify_zero5(
            UnreducedBigInt5(
                d0=x_diff_real_first_term.d0 - x_diff_real_second_term.d0 - pt0_.y.e0.d0 +
                pt1_.y.e0.d0,
                d1=x_diff_real_first_term.d1 - x_diff_real_second_term.d1 - pt0_.y.e0.d1 +
                pt1_.y.e0.d1,
                d2=x_diff_real_first_term.d2 - x_diff_real_second_term.d2 - pt0_.y.e0.d2 +
                pt1_.y.e0.d2,
                d3=x_diff_real_first_term.d3 - x_diff_real_second_term.d3,
                d4=x_diff_real_first_term.d4 - x_diff_real_second_term.d4,
            ),
        );

        return slope_;
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

    // Adds two points on the elliptic curve.
    // Assumption: pt0.x != pt1.x (however, pt0 = pt1 = 0 is allowed).
    // Note that this means that the function cannot be used if pt0 = pt1
    // (use ec_double() in this case) or pt0 = -pt1 (the result is 0 in this case).
    func fast_ec_add{range_check_ptr}(pt0: G2Point, pt1: G2Point) -> (res: G2Point) {
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

namespace g2_arithmetics {
    // formula sources : https://eprint.iacr.org/2010/526

    func to_jacobian{range_check_ptr}(x: G2Point) -> G2JacobPoint {
        let one: FQ2 = FQ2(Uint256(1, 0), Uint256(1, 0));
        let res = G2JacobPoint(x.x, x.y, one);
        return res;
    }
    func add{range_check_ptr}(x: G2JacobPoint, y: G2JacobPoint) -> G2JacobPoint {
    }

    // Algorithm 9 in paper
    func double{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a: G2JacobPoint) -> G2JacobPoint {
        alloc_locals;
        // 1.
        let t0: FQ2 = fq2.mul(a.x, a.x);
        let t2: FQ2 = fq2.mul(a.z, a.z);

        // 2.
        let t1: FQ2 = fq2.add(t0, t0);
        let z3: FQ2 = fq2.mul(a.y, a.z);

        // 3.
        let t0: FQ2 = fq2.add(t0, t1);
        let t3: FQ2 = fq2.mul(a.y, a.y);

        // 4.
        let t0: FQ2 = fq2.div_by_2(t0);

        // 5.
        let t1: FQ2 = fq2.mul(t0, t2);
        let t4: FQ2 = fq2.mul(t0, a.x);

        // 6.

        // 7.
        let t1: FQ2 = fq2.mul(t3, a.x);
        // 8.

        // 9.
        let x3: FQ2 = fq2.sub(a.x, a.y);

        // 10.
        let t1: FQ2 = fq2.sub(t1, x3);

        // 11.
        // let T0 =
        // 12.
        // let
        // 13.

        let res: G2JacobPoint = G2JacobPoint(x3, x3, z3);
        return res;
    }
}

func get_g2_generator{range_check_ptr}() -> G2Point {
    let x = FQ2(
        Uint256(218515455087648563322737050728444197675, 8110707052511605779620841176848002486),
        Uint256(41608236018284495765567131547784793331, 6763838304961238332460416379184654939),
    );

    let y = FQ2(
        Uint256(55479913038740456759913453209233730458, 2786146469857974797679343085057507875),
        Uint256(234691959970022408550800722922068168347, 19581024744886348996498086599748455735),
    );
    let res = G2Point(x, y);
    return res;
}

func get_g22_generator{range_check_ptr}() -> G2Point {
    let x = FQ2(
        Uint256(46344346277279308074009000194278404194, 25856512562768315768423600672569433988),
        Uint256(4165063340428603154518109726088615467, 39063382636863391037133041588177058805),
    );

    let y = FQ2(
        Uint256(4391078196960140543607055349826281753, 43049116670170115887379490826650322562),
        Uint256(107844093954851005883367869616599674084, 45019267700447526043207488615448057433),
    );
    let res = G2Point(x, y);
    return res;
}
func g2() -> (res: G2Point) {
    return (
        res=G2Point(
            x=FQ2(
                e0=BigInt3(
                    0x1edadd46debd5cd992f6ed, 0x199797111e59d0c8b53dd, 0x1800deef121f1e76426a0
                ),
                e1=BigInt3(
                    0x29e71297e485b7aef312c2, 0x3edcc7ed7497c6a924ccd6, 0x198e9393920d483a7260b
                ),
            ),
            y=FQ2(
                e0=BigInt3(
                    0x3d37b4ce6cc0166fa7daa, 0x602372d023f8f479da431, 0x12c85ea5db8c6deb4aab7
                ),
                e1=BigInt3(
                    0x338ef355acdadcd122975b, 0x26b5a430ce56f12cc4cdc2, 0x90689d0585ff075ec9e9
                ),
            ),
        ),
    );
}
