from starkware.cairo.common.cairo_secp.bigint import (
    BigInt3,
    nondet_bigint3,
    bigint_mul,
    UnreducedBigInt5,
)
from src.curve import P0, P1, P2
from starkware.cairo.common.uint256 import Uint256

from src.g1 import G1Point
from src.g2 import G2Point, g2
from src.gt import GTPoint, gt
from src.fq12 import FQ12
from src.towers.e12 import E12, e12
from src.utils import get_loop_count_bits
const ate_loop_count = 29793968203157093288;
const log_ate_loop_count = 63;

from starkware.cairo.common.registers import get_label_location

func get_e_G1G2{range_check_ptr}() -> FQ12 {
    let x = FQ12(
        Uint256(313205626473664474612784707453944545669, 10568129925290606224207438139355451966),
        Uint256(206089031425980057520408673003100580252, 27180593257198016641183635431684468012),
        Uint256(18670876835414276146540009568809199949, 27519218868226716778508897875217970709),
        Uint256(107945741425515968639913278005022779464, 41321154687214521402729015872319788506),
        Uint256(40951358733114449862035778745898569893, 20716792684355736116284993419322145065),
        Uint256(284722584183539521101698036996060630147, 22121149317350596136866357165659918636),
        Uint256(209747075035546139493679608734063548326, 2008991448319574615979884973954103588),
        Uint256(283129152775986099375637448140272887800, 39590676107019344486481077129160149135),
        Uint256(337495080866542154267531911293736885635, 35147234632504762905145016295828337181),
        Uint256(320895337134861026956144347512349456633, 38496285428247005505300094910271779922),
        Uint256(85211557142103361261947413600566799030, 47703442607091358559122169671249995919),
        Uint256(216719693230098916451104466715354089054, 38433299005405230594680588169706830723),
    );

    return x;
}
func gt_linehelp{range_check_ptr}(pt0: GTPoint, pt1: GTPoint, t: GTPoint, slope: E12) -> E12 {
    alloc_locals;
    %{
        # import sys, os 
        # cwd = os.getcwd()
        # sys.path.append(cwd)

        # from utils.bn128_field import FQ, FQ12
        # from utils.bn128_utils import parse_fq12

        # x1 = FQ12(list(map(FQ, parse_fq12(ids.pt1.x))))
        # y1 = FQ12(list(map(FQ, parse_fq12(ids.pt1.y))))
        # xt = FQ12(list(map(FQ, parse_fq12(ids.t.x))))
        # yt = FQ12(list(map(FQ, parse_fq12(ids.t.y))))

        # res = (slope * (xt - x1) - (yt - y1))
        # value = list(map(lambda x: x.n, res.coeffs))
    %}
    // let (res: FQ12) = nondet_fq12();

    let x_diff = e12.sub(t.x, pt1.x);
    let x_diff_slope = e12.mul(slope, x_diff);
    let y_diff = e12.sub(t.y, pt1.y);

    return e12.sub(x_diff_slope, y_diff);
}

func gt_linefunc{range_check_ptr}(pt0: GTPoint, pt1: GTPoint, t: GTPoint) -> E12 {
    alloc_locals;
    let x_diff: E12 = e12.sub(pt0.x, pt1.x);

    let same_x: felt = e12.is_zero(x_diff);
    if (same_x == 0) {
        let slope: E12 = gt.slope(pt0, pt1);
        return gt_linehelp(pt0, pt1, t, slope);
    } else {
        let y_diff: E12 = e12.sub(pt0.y, pt1.y);
        let same_y: felt = e12.is_zero(y_diff);
        if (same_y == 1) {
            let slope: E12 = gt.doubling_slope(pt0);
            return gt_linehelp(pt0, pt1, t, slope);
        } else {
            return e12.sub(t.x, pt0.x);
        }
    }
}

func pairing{range_check_ptr}(Q: G2Point, P: G1Point) -> E12 {
    alloc_locals;
    let twisted_Q: GTPoint = gt.twist(Q);
    let f: E12 = e12.one();
    let cast_P: GTPoint = gt.g1_to_gt(P);
    return miller_loop(Q=twisted_Q, P=cast_P, R=twisted_Q, n=log_ate_loop_count + 1, f=f);
}

func miller_loop{range_check_ptr}(Q: GTPoint, P: GTPoint, R: GTPoint, n: felt, f: E12) -> E12 {
    alloc_locals;
    %{ print("MILLER LOOP ", ids.n) %}
    // END OF LOOP
    if (n == 0) {
        let zero: E12 = e12.zero();

        let q1x = e12.pow3(Q.x);
        let q1y = e12.pow3(Q.y);
        let Q1 = GTPoint(q1x, q1y);

        let lfRQ1P: E12 = gt_linefunc(R, Q1, P);
        let newR: GTPoint = gt.add(R, Q1);

        let nq2x: E12 = e12.pow3(q1x);
        let q2y: E12 = e12.pow3(q1y);

        let nq2y: E12 = e12.sub(zero, q2y);
        let nQ2: GTPoint = GTPoint(nq2x, nq2y);

        let lfnQ2P: E12 = gt_linefunc(newR, nQ2, P);
        let f_1: E12 = e12.mul(f, lfRQ1P);
        let f_2: E12 = e12.mul(f_1, lfnQ2P);
        // final exponentiation
        return final_exponentiation(f_2);
    }

    // inner loop
    let (bit) = get_loop_count_bits(n - 1);

    let f_sqr: E12 = e12.square(f);
    let lfRRP: E12 = gt_linefunc(R, R, P);
    let f_sqr_l: E12 = e12.mul(f_sqr, lfRRP);
    let twoR: GTPoint = gt.double(R);
    if (bit == 0) {
        return miller_loop(Q=Q, P=P, R=twoR, n=n - 1, f=f_sqr_l);
    } else {
        let lfRQP: E12 = gt_linefunc(twoR, Q, P);
        let new_f: E12 = e12.mul(f_sqr_l, lfRQP);
        let twoRpQ: GTPoint = gt.add(twoR, Q);
        return miller_loop(Q=Q, P=P, R=twoRpQ, n=n - 1, f=new_f);
    }
}

func final_exponentiation{range_check_ptr}(z: E12) -> E12 {
    alloc_locals;

    // Easy part
    // (p⁶-1)(p²+1)

    let result = z;
    let t0 = e12.conjugate(z);
    let result = e12.inverse(result);
    let t0 = e12.mul(t0, result);
    let result = e12.frobenius_square(t0);
    let result = e12.mul(result, t0);

    // Hard part (up to permutation)
    // 2x₀(6x₀²+3x₀+1)(p⁴-p²+1)/r
    // Duquesne and Ghammam
    // https://eprint.iacr.org/2015/192.pdf
    // Fuentes et al. variant (alg. 10)

    let t0 = e12.expt(result);
    let t0 = e12.conjugate(t0);
    let t0 = e12.cyclotomic_square(t0);
    let t2 = e12.expt(t0);
    let t2 = e12.conjugate(t2);
    let t1 = e12.cyclotomic_square(t2);
    let t2 = e12.mul(t2, t1);
    let t2 = e12.mul(t2, result);
    let t1 = e12.expt(t2);
    let t1 = e12.cyclotomic_square(t1);
    let t1 = e12.mul(t1, t2);
    let t1 = e12.conjugate(t1);
    let t3 = e12.conjugate(t1);
    let t1 = e12.cyclotomic_square(t0);
    let t1 = e12.mul(t1, result);
    let t1 = e12.conjugate(t1);
    let t1 = e12.mul(t1, t3);
    let t0 = e12.mul(t0, t1);
    let t2 = e12.mul(t2, t1);
    let t3 = e12.frobenius_square(t1);
    let t2 = e12.mul(t2, t3);
    let t3 = e12.conjugate(result);
    let t3 = e12.mul(t3, t0);
    let t1 = e12.frobenius_cube(t3);
    let t2 = e12.mul(t2, t1);
    let t1 = e12.frobenius(t0);
    let t1 = e12.mul(t1, t2);

    return t1;
}
