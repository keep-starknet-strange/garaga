from starkware.cairo.common.cairo_secp.bigint import BigInt3, nondet_bigint3, bigint_mul
from src.fq12 import FQ12_, fq12_eq_zero, fq12_sum, fq12_diff, fq12_is_zero, fq12_zero, fq12_mul
from src.g1 import G1Point
from src.g2 import g2, G2Point, G2
from src.fq import fq_zero, fq_bigint3
from src.utils import is_zero
from src.towers.e12 import E12, e12, nondet_E12
from src.towers.e6 import e6, E6
from src.towers.e2 import e2, E2

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
        let c0b0 = E2(BigInt3(3, 0, 0), BigInt3(0, 0, 0));
        let c0 = E6(c0b0, zero_2, zero_2);
        let b12 = E12(c0, zero_6);
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
        let zero_2 = E2(zero, zero);
        tempvar x0 = P.x.a0;
        tempvar x1 = P.x.a1;
        let nine = BigInt3(d0=9, d1=0, d2=0);
        let nine_x1 = fq_bigint3.mul(nine, x1);
        let xx = fq_bigint3.sub(x0, nine_x1);
        let xc0b1 = E2(xx, zero);
        let xc1b1 = E2(x1, zero);
        let xc0 = E6(zero_2, xc0b1, zero_2);
        let xc1 = E6(zero_2, xc1b1, zero_2);

        let nxw2 = E12(xc0, xc1);

        tempvar y0 = P.y.a0;
        tempvar y1 = P.y.a1;
        let nine_y1 = fq_bigint3.mul(nine, y1);
        let yy = fq_bigint3.sub(y0, nine_y1);
        let yc0b1 = E2(zero, yy);
        let yc1b1 = E2(zero, y1);
        let yc0 = E6(zero_2, yc0b1, zero_2);
        let yc1 = E6(zero_2, yc1b1, zero_2);
        let nyw3 = E12(yc0, yc1);

        let res = GTPoint(x=nxw2, y=nyw3);

        return res;
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
func g12{range_check_ptr}() -> (res: GTPoint) {
    let g2_tmp: G2Point_ = G2();
    let res: GTPoint = gt.twist(g2_tmp);
    return (res=res);
}

func gt_two() -> (res: GTPoint) {
    return (
        GTPoint(
            E12(
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=66531434795446507742202402,
                    d1=57810563030407162761699450,
                    d2=3024423940099633003033660,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=29266951114122318337060217,
                    d1=8315677858884295077185307,
                    d2=2436188124856487536975890,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
            ),
            E12(
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=20729108619955071395783599,
                    d1=33713532092400076519474348,
                    d2=1387780998518836325215322,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=37820632520797176012333394,
                    d1=58429338205645183884307771,
                    d2=1916850345724626333016760,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
            ),
        ),
    );
}

func gt_three() -> (res: GTPoint) {
    return (
        GTPoint(
            E12(
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=60558478434004798536211741,
                    d1=43863242049195550535444726,
                    d2=489660925987493189701501,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=68458519662193915565862533,
                    d1=8714965904636858911272353,
                    d2=1214966188589858263872793,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
            ),
            E12(
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=62542305924506548566602652,
                    d1=11947492361179029427546200,
                    d2=2636020001628383667142327,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=64470951246555278864748978,
                    d1=61710966665510361729249574,
                    d2=160010759829214388101887,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
            ),
        ),
    );
}

func gt_negone() -> (res: GTPoint) {
    return (
        GTPoint(
            E12(
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=37098765567079062928113790,
                    d1=75069397608736819304955002,
                    d2=2716309570043849407818057,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=50657168248156029357068994,
                    d1=75996009454876762764004566,
                    d2=1931027739743020521039371,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
            ),
            E12(
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=31925659635663368785745730,
                    d1=76797642075525941605650950,
                    d2=1061992001333544670783866,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=75234859396250709295523308,
                    d1=58200249186681967413131230,
                    d2=2974432145097327839591194,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
            ),
        ),
    );
}

func gt_negtwo() -> (res: GTPoint) {
    return (
        GTPoint(
            E12(
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=66531434795446507742202402,
                    d1=57810563030407162761699450,
                    d2=3024423940099633003033660,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=29266951114122318337060217,
                    d1=8315677858884295077185307,
                    d2=2436188124856487536975890,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
            ),
            E12(
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=39464779894232690824419736,
                    d1=71283675355909246543773941,
                    d2=2268601696092355443562665,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=22373255993390586207869941,
                    d1=46567869242664139178940518,
                    d2=1739532348886565435761227,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
            ),
        ),
    );
}

func gt_negthree() -> (res: GTPoint) {
    return (
        GTPoint(
            E12(
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=60558478434004798536211741,
                    d1=43863242049195550535444726,
                    d2=489660925987493189701501,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=68458519662193915565862533,
                    d1=8714965904636858911272353,
                    d2=1214966188589858263872793,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
            ),
            E12(
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=75022835045017480834795947,
                    d1=15678462631794026454506824,
                    d2=1020362692982808101635661,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(
                    d0=73094189722968750536649621,
                    d1=43286240782798961333998714,
                    d2=3496371934781977380676100,
                ),
                BigInt3(d0=0, d1=0, d2=0),
                BigInt3(d0=0, d1=0, d2=0),
            ),
        ),
    );
}
