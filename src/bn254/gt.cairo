from starkware.cairo.common.cairo_secp.bigint import BigInt3, nondet_bigint3, bigint_mul
from src.bn254.g1 import G1Point
from src.bn254.g2 import g2, G2Point, G2
from src.bn254.fq import fq_zero, fq_bigint3, is_zero
from src.bn254.towers.e12 import E12, e12, nondet_E12
from src.bn254.towers.e6 import e6, E6
from src.bn254.towers.e2 import e2, E2

struct GTPoint {
    x: E12,
    y: E12,
}

// ### ADDITION, MULTIPLICATION

namespace gt {
    func assert_on_curve{range_check_ptr}(pt: GTPoint) -> () {
        alloc_locals;
        let left = e12.square(pt.y);
        let x_sq = e12.square(pt.x);
        let x_cube = e12.mul(x_sq, pt.x);
        let zero_6 = e6.zero();
        let zero_2 = e2.zero();

        let b12 = E12(E6(E2(BigInt3(3, 0, 0), BigInt3(0, 0, 0)), zero_2, zero_2), zero_6);

        let right = e12.add(x_cube, b12);
        assert left = right;
        return ();
    }
    // ### CASTING G1 INTO GT
    func g1_to_gt{range_check_ptr}(pt: G1Point) -> GTPoint {
        // Point should not be zero
        alloc_locals;
        let (x_iszero) = is_zero(pt.x);
        let (y_iszero) = is_zero(pt.y);
        assert x_iszero + y_iszero = 0;
        let zero: BigInt3 = fq_zero();
        let zero_6: E6 = e6.zero();
        let zero_2: E2 = e2.zero();
        let xb0 = E2(pt.x, zero);

        let xc0 = E6(xb0, zero_2, zero_2);

        let yb0 = E2(pt.y, zero);
        let yc0 = E6(yb0, zero_2, zero_2);
        let res = GTPoint(x=E12(xc0, zero_6), y=E12(yc0, zero_6));
        return res;
    }

    // ### TWISTING G2 INTO GT
    func twist{range_check_ptr}(P: G2Point) -> GTPoint {
        alloc_locals;
        let zero: BigInt3 = fq_zero();
        let zero_2 = e2.zero();
        let zero_6 = e6.zero();

        tempvar x0 = P.x.a0;
        tempvar x1 = P.x.a1;

        let nine = BigInt3(d0=9, d1=0, d2=0);
        let nine_x1 = fq_bigint3.mul(nine, x1);
        let xx = fq_bigint3.sub(x0, nine_x1);
        let xc0b0 = E2(xx, zero);
        let xc1b0 = E2(x1, zero);
        let xc0 = E6(xc0b0, zero_2, zero_2);
        let xc1 = E6(xc1b0, zero_2, zero_2);

        let nx = E12(xc0, xc1);

        tempvar y0 = P.y.a0;
        tempvar y1 = P.y.a1;

        let nine_y1 = fq_bigint3.mul(nine, y1);
        let yy = fq_bigint3.sub(y0, nine_y1);
        let yc0b0 = E2(yy, zero);
        let yc1b0 = E2(y1, zero);
        let yc0 = E6(yc0b0, zero_2, zero_2);
        let yc1 = E6(yc1b0, zero_2, zero_2);
        let ny = E12(yc0, yc1);

        let W = E12(E6(E2(zero, BigInt3(1, 0, 0)), zero_2, zero_2), zero_6);
        let W2 = e12.square(W);
        let W2 = E12(E6(zero_2, E2(BigInt3(1, 0, 0), zero), zero_2), zero_6);
        let W3 = e12.mul(W, W2);
        let W3 = E12(E6(zero_2, E2(zero, BigInt3(1, 0, 0)), zero_2), zero_6);
        local res_p: GTPoint;
        %{
            from tools.py.bn128_field import FQ12, FQ, FQ2
            from tools.py.bn128_curve import twist, w
            def parse_e2(x):
                return [pack(x.a0, PRIME), pack(x.a1, PRIME)]
            def rgetattr(obj, attr, *args):
                def _getattr(obj, attr):
                    return getattr(obj, attr, *args)
                return functools.reduce(_getattr, [obj] + attr.split('.'))

            def rsetattr(obj, attr, val):
                pre, _, post = attr.rpartition('.')
                return setattr(rgetattr(obj, pre) if pre else obj, post, val)

            def fill_e12(e2:str, *args):
                structs = ['c0.b0.a0','c0.b0.a1','c0.b1.a0','c0.b1.a1','c0.b2.a0','c0.b2.a1',
                'c1.b0.a0','c1.b0.a1','c1.b1.a0','c1.b1.a1','c1.b2.a0','c1.b2.a1']
                for i, s in enumerate(structs):
                    splitted = split(args[i])
                    for j in range(3):
                        rsetattr(ids,e2+'.'+s+'.d'+str(j),splitted[j])
                return None

            x = FQ2(list(map(FQ, parse_e2(ids.P.x))))
            y= FQ2(list(map(FQ, parse_e2(ids.P.y))))
            nx, ny= twist((x, y))
            fill_e12('res_p.x', *[x.n for x in nx.coeffs])
            fill_e12('res_p.y', *[x.n for x in ny.coeffs])
        %}
        let nxw2 = e12.mul(nx, W2);
        let nyw3 = e12.mul(ny, W3);

        let res = GTPoint(x=nxw2, y=nyw3);
        assert res = res_p;
        return res_p;
    }
    func doubling_slope{range_check_ptr}(pt: GTPoint) -> (res: E12) {
        alloc_locals;
        %{
            from tools.py.bn128_field import FQ, FQ12
            from starkware.cairo.common.cairo_secp.secp_utils import pack

            def parse_e12(x):
                return [pack(x.c0.b0.a0, PRIME), pack(x.c0.b0.a1, PRIME), pack(x.c0.b1.a0, PRIME), pack(x.c0.b1.a1, PRIME), 
                pack(x.c0.b2.a0, PRIME), pack(x.c0.b2.a1, PRIME), pack(x.c1.b0.a0, PRIME), pack(x.c1.b0.a1, PRIME),
                pack(x.c1.b1.a0, PRIME), pack(x.c1.b1.a1, PRIME), pack(x.c1.b2.a0, PRIME), pack(x.c1.b2.a1, PRIME)]
            # Compute the slope.
            x = FQ12(list(map(FQ, parse_e12(ids.pt.x))))
            y = FQ12(list(map(FQ, parse_e12(ids.pt.y))))

            slope = (3 * x ** 2) / (2 * y)
            value = list(map(lambda x: x.n, slope.coeffs))
        %}
        let (slope: E12) = nondet_E12();
        // TODO VERIFY
        return (res=slope);
    }

    func slope{range_check_ptr}(pt0: GTPoint, pt1: GTPoint) -> (res: E12) {
        %{
            from tools.py.bn128_field import FQ, FQ12
            from starkware.cairo.common.cairo_secp.secp_utils import pack

            def parse_e12(x):
                return [pack(x.c0.b0.a0, PRIME), pack(x.c0.b0.a1, PRIME), pack(x.c0.b1.a0, PRIME), pack(x.c0.b1.a1, PRIME), 
                pack(x.c0.b2.a0, PRIME), pack(x.c0.b2.a1, PRIME), pack(x.c1.b0.a0, PRIME), pack(x.c1.b0.a1, PRIME),
                pack(x.c1.b1.a0, PRIME), pack(x.c1.b1.a1, PRIME), pack(x.c1.b2.a0, PRIME), pack(x.c1.b2.a1, PRIME)]

            # Compute the slope.
            x0 = FQ12(list(map(FQ, parse_e12(ids.pt0.x))))
            y0 = FQ12(list(map(FQ, parse_e12(ids.pt0.y))))
            x1 = FQ12(list(map(FQ, parse_e12(ids.pt1.x))))
            y1 = FQ12(list(map(FQ, parse_e12(ids.pt1.y))))

            slope = (y0 - y1) / (x0 - x1)
            value = list(map(lambda x: x.n, slope.coeffs))
        %}
        alloc_locals;
        let (slope: E12) = nondet_E12();

        // TODO verify
        return (slope,);
    }

    // Given a point 'pt' on the elliptic curve, computes pt + pt.
    func double{range_check_ptr}(pt: GTPoint) -> GTPoint {
        alloc_locals;
        let x_is_zero = e12.is_zero(pt.x);
        if (x_is_zero == 1) {
            return pt;
        }

        let (local double_slope: E12) = gt.doubling_slope(pt);
        let slope_sqr: E12 = e12.square(double_slope);
        %{
            from tools.py.bn128_field import FQ, FQ12
            from starkware.cairo.common.cairo_secp.secp_utils import pack

            def parse_e12(x):
                return [pack(x.c0.b0.a0, PRIME), pack(x.c0.b0.a1, PRIME), pack(x.c0.b1.a0, PRIME), pack(x.c0.b1.a1, PRIME), 
                pack(x.c0.b2.a0, PRIME), pack(x.c0.b2.a1, PRIME), pack(x.c1.b0.a0, PRIME), pack(x.c1.b0.a1, PRIME),
                pack(x.c1.b1.a0, PRIME), pack(x.c1.b1.a1, PRIME), pack(x.c1.b2.a0, PRIME), pack(x.c1.b2.a1, PRIME)]

            # Compute the slope.
            x = FQ12(list(map(FQ, parse_e12(ids.pt.x))))
            y = FQ12(list(map(FQ, parse_e12(ids.pt.y))))
            slope = FQ12(list(map(FQ, parse_e12(ids.double_slope))))
            res = slope ** 2 - x * 2
            value = new_x = list(map(lambda x: x.n, res.coeffs))
        %}
        let (new_x: E12) = nondet_E12();

        %{
            new_x = FQ12(list(map(FQ, parse_e12(ids.new_x))))
            res = slope * (x - new_x) - y
            value = new_x = list(map(lambda x: x.n, res.coeffs))
        %}
        let (new_y: E12) = nondet_E12();

        // VERIFY
        // verify_zero5(
        //     UnreducedBigInt5(
        //     d0=slope_sqr.d0 - new_x.d0 - 2 * pt.x.d0,
        //     d1=slope_sqr.d1 - new_x.d1 - 2 * pt.x.d1,
        //     d2=slope_sqr.d2 - new_x.d2 - 2 * pt.x.d2,
        //     d3=slope_sqr.d3,
        //     d4=slope_sqr.d4))
        let verify_zero_e12 = e12.sub(slope_sqr, new_x);
        let verify_zero_e12 = e12.sub(verify_zero_e12, pt.x);
        let verify_zero_e12 = e12.sub(verify_zero_e12, pt.x);
        let verify_zero_e12_is_zero: felt = e12.is_zero(verify_zero_e12);
        assert verify_zero_e12_is_zero = 1;

        // let (x_diff_slope : UnreducedBigInt5) = bigint_mul(
        //     BigInt3(d0=pt.x.d0 - new_x.d0, d1=pt.x.d1 - new_x.d1, d2=pt.x.d2 - new_x.d2), slope)

        // verify_zero5(
        //     UnreducedBigInt5(
        //     d0=x_diff_slope.d0 - pt.y.d0 - new_y.d0,
        //     d1=x_diff_slope.d1 - pt.y.d1 - new_y.d1,
        //     d2=x_diff_slope.d2 - pt.y.d2 - new_y.d2,
        //     d3=x_diff_slope.d3,
        //     d4=x_diff_slope.d4))

        let x_diff_slope = e12.sub(pt.x, new_x);
        let verify_zero_e12_2 = e12.sub(x_diff_slope, pt.y);
        let verify_zero_e12_2 = e12.sub(verify_zero_e12_2, new_y);
        let verify_zero_e12_2_is_zero = e12.is_zero(verify_zero_e12_2);
        assert verify_zero_e12_2_is_zero = 1;
        let res = GTPoint(new_x, new_y);
        return res;
    }

    func fast_gt_add{range_check_ptr}(pt0: GTPoint, pt1: GTPoint) -> GTPoint {
        alloc_locals;
        let pt0_x_is_zero = e12.is_zero(pt0.x);
        if (pt0_x_is_zero == 1) {
            return pt1;
        }
        let pt1_x_is_zero = e12.is_zero(pt1.x);
        if (pt1_x_is_zero == 1) {
            return pt1;
        }

        let (local slope: E12) = gt.slope(pt0, pt1);
        let slope_sqr: E12 = e12.mul(slope, slope);

        %{
            from tools.py.bn128_field import FQ, FQ12

            def parse_e12(x):
                return [pack(x.c0.b0.a0, PRIME), pack(x.c0.b0.a1, PRIME), pack(x.c0.b1.a0, PRIME), pack(x.c0.b1.a1, PRIME), 
                pack(x.c0.b2.a0, PRIME), pack(x.c0.b2.a1, PRIME), pack(x.c1.b0.a0, PRIME), pack(x.c1.b0.a1, PRIME),
                pack(x.c1.b1.a0, PRIME), pack(x.c1.b1.a1, PRIME), pack(x.c1.b2.a0, PRIME), pack(x.c1.b2.a1, PRIME)]


            # Compute the slope.
            x0 = FQ12(list(map(FQ, parse_e12(ids.pt0.x))))
            x1 = FQ12(list(map(FQ, parse_e12(ids.pt1.x))))
            y0 = FQ12(list(map(FQ, parse_e12(ids.pt0.y))))
            slope = FQ12(list(map(FQ, parse_e12(ids.slope))))

            res = slope ** 2 - x0 - x1
            value = new_x = list(map(lambda x: x.n, res.coeffs))
        %}
        let (new_x: E12) = nondet_E12();

        %{
            new_x = res
            res = slope * (x0 - new_x) - y0
            value = new_x = list(map(lambda x: x.n, res.coeffs))
        %}
        let (new_y: E12) = nondet_E12();

        // verify_zero5(
        //     UnreducedBigInt5(
        //     d0=slope_sqr.d0 - new_x.d0 - pt0.x.d0 - pt1.x.d0,
        //     d1=slope_sqr.d1 - new_x.d1 - pt0.x.d1 - pt1.x.d1,
        //     d2=slope_sqr.d2 - new_x.d2 - pt0.x.d2 - pt1.x.d2,
        //     d3=slope_sqr.d3,
        //     d4=slope_sqr.d4))
        let verify_zero_e12 = e12.sub(slope_sqr, new_x);
        let verify_zero_e12 = e12.sub(verify_zero_e12, pt0.x);
        let verify_zero_e12 = e12.sub(verify_zero_e12, pt1.x);
        let verify_zero_e12_is_zero = e12.is_zero(verify_zero_e12);
        assert verify_zero_e12_is_zero = 1;
        // let (x_diff_slope : UnreducedBigInt5) = bigint_mul(
        //     BigInt3(d0=pt0.x.d0 - new_x.d0, d1=pt0.x.d1 - new_x.d1, d2=pt0.x.d2 - new_x.d2), slope)

        // verify_zero5(
        //     UnreducedBigInt5(
        //     d0=x_diff_slope.d0 - pt0.y.d0 - new_y.d0,
        //     d1=x_diff_slope.d1 - pt0.y.d1 - new_y.d1,
        //     d2=x_diff_slope.d2 - pt0.y.d2 - new_y.d2,
        //     d3=x_diff_slope.d3,
        //     d4=x_diff_slope.d4))

        let x_diff_slope = e12.sub(pt0.x, new_x);
        let verify_zero_e12_2 = e12.sub(x_diff_slope, pt0.y);
        let verify_zero_e12_2 = e12.sub(verify_zero_e12_2, new_y);
        let verify_zero_e12_2_is_zero = e12.is_zero(verify_zero_e12_2);
        assert verify_zero_e12_2_is_zero = 1;

        let res = GTPoint(new_x, new_y);
        return res;
    }

    func add{range_check_ptr}(pt0: GTPoint, pt1: GTPoint) -> GTPoint {
        let x_diff = e12.sub(pt0.x, pt1.x);
        let same_x: felt = e12.is_zero(x_diff);
        if (same_x == 0) {
            return fast_gt_add(pt0, pt1);
        }

        // We have pt0.x = pt1.x. This implies pt0.y = ±pt1.y.
        // Check whether pt0.y = -pt1.y.
        let y_sum = e12.add(pt0.x, pt0.y);
        let opposite_y: felt = e12.is_zero(y_sum);
        if (opposite_y != 0) {
            // pt0.y = -pt1.y.
            // Note that the case pt0 = pt1 = 0 falls into this branch as well.
            let zero_12 = e12.zero();
            let ZERO_POINT = GTPoint(zero_12, zero_12);
            return ZERO_POINT;
        } else {
            // pt0.y = pt1.y.
            return double(pt0);
        }
    }
}

// CONSTANTS
func g12{range_check_ptr}() -> GTPoint {
    let g2_tmp: G2Point = G2();
    let res: GTPoint = gt.twist(g2_tmp);
    return res;
}

func gt_two() -> GTPoint {
    let zero = fq_zero();
    let zero_2 = e2.zero();
    let xc0 = E6(
        zero_2,
        E2(
            BigInt3(
                d0=66531434795446507742202402,
                d1=57810563030407162761699450,
                d2=3024423940099633003033660,
            ),
            zero,
        ),
        zero_2,
    );
    let xc1 = E6(
        zero_2,
        E2(
            BigInt3(
                d0=29266951114122318337060217,
                d1=8315677858884295077185307,
                d2=2436188124856487536975890,
            ),
            zero,
        ),
        zero_2,
    );

    let yc0 = E6(
        zero_2,
        E2(
            zero,
            BigInt3(
                d0=20729108619955071395783599,
                d1=33713532092400076519474348,
                d2=1387780998518836325215322,
            ),
        ),
        zero_2,
    );

    let yc1 = E6(
        zero_2,
        E2(
            zero,
            BigInt3(
                d0=37820632520797176012333394,
                d1=58429338205645183884307771,
                d2=1916850345724626333016760,
            ),
        ),
        zero_2,
    );

    let res = GTPoint(E12(xc0, xc1), E12(yc0, yc1));
    return res;
}
