from starkware.cairo.common.cairo_secp.bigint import (
    BigInt3,
    UnreducedBigInt3,
    nondet_bigint3,
    UnreducedBigInt5,
    bigint_mul,
)
from starkware.cairo.common.cairo_secp.constants import BASE
from src.bn254.fq import is_zero, verify_zero5, fq_bigint3
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
// Returns the slope of the elliptic curve at the given point.
// The slope is used to compute pt + pt.
// Assumption: pt != 0.
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
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import pack
            from starkware.python.math_utils import div_mod

            P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

            # Compute the slope.
            x = pack(ids.pt.x, PRIME)
            y = pack(ids.pt.y, PRIME)
            value = slope = div_mod(3 * x ** 2, 2 * y, P)
        %}
        let (slope: BigInt3) = nondet_bigint3();

        let (x_sqr: UnreducedBigInt5) = bigint_mul(pt.x, pt.x);
        let (slope_y: UnreducedBigInt5) = bigint_mul(slope, pt.y);

        tempvar val: UnreducedBigInt5 = UnreducedBigInt5(
            d0=3 * x_sqr.d0 - 2 * slope_y.d0,
            d1=3 * x_sqr.d1 - 2 * slope_y.d1,
            d2=3 * x_sqr.d2 - 2 * slope_y.d2,
            d3=3 * x_sqr.d3 - 2 * slope_y.d3,
            d4=3 * x_sqr.d4 - 2 * slope_y.d4,
        );
        local flag;
        local q1;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import pack
            from starkware.cairo.common.math_utils import as_int

            P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

            v3 = as_int(ids.val.d3, PRIME)
            v4 = as_int(ids.val.d4, PRIME)
            v = pack(ids.val, PRIME) + v3*2**258 + v4*2**344

            q, r = divmod(v, P)
            assert r == 0, f"verify_zero: Invalid input {ids.val.d0, ids.val.d1, ids.val.d2, ids.val.d3, ids.val.d4}."

            # Since q usually doesn't fit BigInt3, divide it again
            ids.flag = 1 if q > 0 else 0
            q = q if q > 0 else 0-q
            q1, q2 = divmod(q, P)
            ids.q1 = q1
            value = k = q2
        %}
        let (k) = nondet_bigint3();
        tempvar fullk: BigInt3 = BigInt3(q1 * P0 + k.d0, q1 * P1 + k.d1, q1 * P2 + k.d2);
        tempvar k_n: UnreducedBigInt5 = UnreducedBigInt5(
            d0=fullk.d0 * P0,
            d1=fullk.d0 * P1 + fullk.d1 * P0,
            d2=fullk.d0 * P2 + fullk.d1 * P1 + fullk.d2 * P0,
            d3=fullk.d1 * P2 + fullk.d2 * P1,
            d4=fullk.d2 * P2,
        );
        // val mod n = 0, so val = k_n
        tempvar carry1 = ((2 * flag - 1) * k_n.d0 - val.d0) / BASE;
        assert [range_check_ptr + 0] = carry1 + 2 ** 127;

        tempvar carry2 = ((2 * flag - 1) * k_n.d1 - val.d1 + carry1) / BASE;
        assert [range_check_ptr + 1] = carry2 + 2 ** 127;

        tempvar carry3 = ((2 * flag - 1) * k_n.d2 - val.d2 + carry2) / BASE;
        assert [range_check_ptr + 2] = carry3 + 2 ** 127;

        tempvar carry4 = ((2 * flag - 1) * k_n.d3 - val.d3 + carry3) / BASE;
        assert [range_check_ptr + 3] = carry4 + 2 ** 127;

        assert (2 * flag - 1) * k_n.d4 - val.d4 + carry4 = 0;

        let range_check_ptr = range_check_ptr + 4;

        return (slope=slope);
    }

    // Returns the slope of the line connecting the two given points.
    // The slope is used to compute pt0 + pt1.
    // Assumption: pt0.x != pt1.x (mod field prime).
    func compute_slope{range_check_ptr}(pt0: G1PointFull, pt1: G1PointFull) -> (slope: BigInt3) {
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import pack
            from starkware.python.math_utils import div_mod

            P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            # Compute the slope.
            x0 = pack(ids.pt0.x, PRIME)
            y0 = pack(ids.pt0.y, PRIME)
            x1 = pack(ids.pt1.x, PRIME)
            y1 = pack(ids.pt1.y, PRIME)
            value = slope = div_mod(y0 - y1, x0 - x1, P)
        %}
        let (slope) = nondet_bigint3();

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
        let (__fp__, _) = get_fp_and_pc();
        if (pt.x.d0 == 0) {
            if (pt.x.d1 == 0) {
                if (pt.x.d2 == 0) {
                    return (pt,);
                }
            }
        }

        let (slope: BigInt3) = compute_doubling_slope(pt);
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

        return (G1PointFull(new_x, new_y),);
    }

    // Adds two points on the elliptic curve.
    // Assumption: pt0.x != pt1.x (however, pt0 = pt1 = 0 is allowed).
    // Note that this means that the function cannot be used if pt0 = pt1
    // (use ec_double() in this case) or pt0 = -pt1 (the result is 0 in this case).
    func fast_ec_add{range_check_ptr}(pt0: G1PointFull, pt1: G1PointFull) -> (res: G1PointFull) {
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
        let (_, local res2: G1PointFull) = ec_mul_inner(pow2_1, scalar.d2, 84);
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
func G1() -> (res: G1Point) {
    return (res=G1Point(BigInt3(1, 0, 0), BigInt3(2, 0, 0)));
}

func g1_two() -> (res: G1Point) {
    return (
        G1Point(
            BigInt3(0x71ca8d3c208c16d87cfd3, 0x116da060561765e05aa45a, 0x30644e72e131a029b850),
            BigInt3(0x138fc7ff3ebf7a5a18a2c4, 0x3e5acaba7029a29a91278d, 0x15ed738c0e0a7c92e7845),
        ),
    );
}

func g1_three() -> (res: G1Point) {
    return (
        G1Point(
            BigInt3(0x38e679f2d355961915abf0, 0xaf2c6daf4564c57611c56, 0x769bf9ac56bea3ff4023),
            BigInt3(0x1c5b57cdf1ff3dd9fe2261, 0x2df2342191d4c6798ed02e, 0x2ab799bee0489429554fd),
        ),
    );
}

func g1_negone() -> (res: G1Point) {
    return (
        G1Point(
            BigInt3(0x1, 0x0, 0x0),
            BigInt3(0x31ca8d3c208c16d87cfd45, 0x16da060561765e05aa45a1, 0x30644e72e131a029b8504),
        ),
    );
}

func g1_negtwo() -> (res: G1Point) {
    return (
        G1Point(
            BigInt3(0x71ca8d3c208c16d87cfd3, 0x116da060561765e05aa45a, 0x30644e72e131a029b850),
            BigInt3(0x1e3ac53ce1cc9c7e645a83, 0x187f3b4af14cbb6b191e14, 0x1a76dae6d3272396d0cbe),
        ),
    );
}

func g1_negthree() -> (res: G1Point) {
    return (
        G1Point(
            BigInt3(0x38e679f2d355961915abf0, 0xaf2c6daf4564c57611c56, 0x769bf9ac56bea3ff4023),
            BigInt3(0x156f356e2e8cd8fe7edae6, 0x28e7d1e3cfa1978c1b7573, 0x5acb4b400e90c0063006),
        ),
    );
}
