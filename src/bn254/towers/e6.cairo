from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq

from src.bn254.towers.e2 import e2, E2

struct E6 {
    b0: E2*,
    b1: E2*,
    b2: E2*,
}

namespace e6 {
    func add{range_check_ptr}(x: E6*, y: E6*) -> E6* {
        alloc_locals;
        let b0 = e2.add(x.b0, y.b0);
        let b1 = e2.add(x.b1, y.b1);
        let b2 = e2.add(x.b2, y.b2);
        tempvar res = new E6(b0, b1, b2);
        return res;
    }

    func sub{range_check_ptr}(x: E6*, y: E6*) -> E6* {
        alloc_locals;
        let b0 = e2.sub(x.b0, y.b0);
        let b1 = e2.sub(x.b1, y.b1);
        let b2 = e2.sub(x.b2, y.b2);
        tempvar res = new E6(b0, b1, b2);
        return res;
    }

    func double{range_check_ptr}(x: E6*) -> E6* {
        alloc_locals;
        let b0 = e2.double(x.b0);
        let b1 = e2.double(x.b1);
        let b2 = e2.double(x.b2);
        tempvar res = new E6(b0, b1, b2);
        return res;
    }

    func neg{range_check_ptr}(x: E6*) -> E6* {
        alloc_locals;
        let b0 = e2.neg(x.b0);
        let b1 = e2.neg(x.b1);
        let b2 = e2.neg(x.b2);
        tempvar res = new E6(b0, b1, b2);
        return res;
    }

    func mul{range_check_ptr}(x: E6*, y: E6*) -> E6* {
        alloc_locals;
        let t0 = e2.mul(x.b0, y.b0);
        let t1 = e2.mul(x.b1, y.b1);
        let t2 = e2.mul(x.b2, y.b2);
        let c0 = e2.add(x.b1, x.b2);
        let tmp = e2.add(y.b1, y.b2);
        let c0 = e2.mul(c0, tmp);
        let c0 = e2.sub(c0, t1);
        let c0 = e2.sub(c0, t2);
        let c0 = e2.mul_by_non_residue(c0);
        let c0 = e2.add(c0, t0);
        let c1 = e2.add(x.b0, x.b1);
        let tmp = e2.add(y.b0, y.b1);
        let c1 = e2.mul(c1, tmp);
        let c1 = e2.sub(c1, t0);
        let c1 = e2.sub(c1, t1);
        let tmp = e2.mul_by_non_residue(t2);
        let c1 = e2.add(c1, tmp);
        let tmp = e2.add(x.b0, x.b2);
        let c2 = e2.add(y.b0, y.b2);
        let c2 = e2.mul(c2, tmp);
        let c2 = e2.sub(c2, t0);
        let c2 = e2.sub(c2, t2);
        let c2 = e2.add(c2, t1);
        tempvar res = new E6(c0, c1, c2);

        return res;
    }

    func mul_by_non_residue{range_check_ptr}(x: E6*) -> E6* {
        alloc_locals;
        let zB0 = x.b2;
        let zB1 = x.b0;
        let zB2 = x.b1;
        let zB0 = e2.mul_by_non_residue(zB0);
        tempvar res = new E6(zB0, zB1, zB2);
        return res;
    }

    func mul_by_E2{range_check_ptr}(x: E6*, y: E2*) -> E6* {
        alloc_locals;
        let b0 = e2.mul(x.b0, y);
        let b1 = e2.mul(x.b1, y);
        let b2 = e2.mul(x.b2, y);
        tempvar res = new E6(b0, b1, b2);
        return res;
    }
    // // MulBy01 multiplication by sparse element (c0,c1,0)
    // func (z *E6) MulBy01(c0, c1 *E2) *E6 {

    // var a, b, tmp, t0, t1, t2 E2

    // a.Mul(&z.B0, c0)
    // 	b.Mul(&z.B1, c1)

    // tmp.Add(&z.B1, &z.B2)
    // 	t0.Mul(c1, &tmp)
    // 	t0.Sub(&t0, &b)
    // 	t0.MulByNonResidue(&t0)
    // 	t0.Add(&t0, &a)

    // tmp.Add(&z.B0, &z.B2)
    // 	t2.Mul(c0, &tmp)
    // 	t2.Sub(&t2, &a)
    // 	t2.Add(&t2, &b)

    // t1.Add(c0, c1)
    // 	tmp.Add(&z.B0, &z.B1)
    // 	t1.Mul(&t1, &tmp)
    // 	t1.Sub(&t1, &a)
    // 	t1.Sub(&t1, &b)

    // z.B0.Set(&t0)
    // 	z.B1.Set(&t1)
    // 	z.B2.Set(&t2)

    // return z
    // }

    func mul_by_01{range_check_ptr}(x: E6*, b0: E2*, b1: E2*) -> E6* {
        alloc_locals;
        let a = e2.mul(x.b0, b0);
        let b = e2.mul(x.b1, b1);
        let tmp = e2.add(x.b1, x.b2);
        let t0 = e2.mul(b1, tmp);
        let t0 = e2.sub(t0, b);
        let t0 = e2.mul_by_non_residue(t0);
        let t0 = e2.add(t0, a);

        let tmp = e2.add(x.b0, x.b2);
        let t2 = e2.mul(b0, tmp);
        let t2 = e2.sub(t2, a);
        let t2 = e2.add(t2, b);

        let t1 = e2.add(b0, b1);
        let tmp = e2.add(x.b0, x.b1);
        let t1 = e2.mul(t1, tmp);
        let t1 = e2.sub(t1, a);
        let t1 = e2.sub(t1, b);

        tempvar res = new E6(t0, t1, t2);
        return res;
    }

    func zero{}() -> E6* {
        let b0 = e2.zero();
        let b1 = e2.zero();
        let b2 = e2.zero();
        tempvar res = new E6(b0, b1, b2);
        return res;
    }
    func one{}() -> E6* {
        let b0 = e2.one();
        let b1 = e2.zero();
        let b2 = e2.zero();
        tempvar res = new E6(b0, b1, b2);
        return res;
    }
    func is_zero{}(x: E6*) -> felt {
        alloc_locals;
        let b0_is_zero = e2.is_zero(x.b0);

        if (b0_is_zero == 0) {
            return 0;
        }
        let b1_is_zero = e2.is_zero(x.b1);

        if (b1_is_zero == 0) {
            return 0;
        }
        let b2_is_zero = e2.is_zero(x.b2);
        return b2_is_zero;
    }
    func assert_E6(x: E6*, z: E6*) {
        e2.assert_E2(x.b0, z.b0);
        e2.assert_E2(x.b1, z.b1);
        e2.assert_E2(x.b2, z.b2);
        return ();
    }
}
