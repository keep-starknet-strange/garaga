from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq

from src.bn254.towers.e2 import e2, E2

struct E6 {
    b0: E2,
    b1: E2,
    b2: E2,
}

namespace e6 {
    func add{range_check_ptr}(x: E6, y: E6) -> E6 {
        alloc_locals;
        let b0 = e2.add(x.b0, y.b0);
        let b1 = e2.add(x.b1, y.b1);
        let b2 = e2.add(x.b2, y.b2);
        let res = E6(b0, b1, b2);
        return res;
    }

    func sub{range_check_ptr}(x: E6, y: E6) -> E6 {
        alloc_locals;
        let b0 = e2.sub(x.b0, y.b0);
        let b1 = e2.sub(x.b1, y.b1);
        let b2 = e2.sub(x.b2, y.b2);
        let res = E6(b0, b1, b2);
        return res;
    }

    func double{range_check_ptr}(x: E6) -> E6 {
        alloc_locals;
        let b0 = e2.double(x.b0);
        let b1 = e2.double(x.b1);
        let b2 = e2.double(x.b2);
        let res = E6(b0, b1, b2);
        return res;
    }

    func neg{range_check_ptr}(x: E6) -> E6 {
        alloc_locals;
        let b0 = e2.neg(x.b0);
        let b1 = e2.neg(x.b1);
        let b2 = e2.neg(x.b2);
        let res = E6(b0, b1, b2);
        return res;
    }

    func mul{range_check_ptr}(x: E6, y: E6) -> E6 {
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
        let res = E6(c0, c1, c2);
        return res;
    }

    // // MulByNonResidue mul x by (0,1,0)
    // func (z *E6) MulByNonResidue(x *E6) *E6 {
    // 	z.B2, z.B1, z.B0 = x.B1, x.B0, x.B2
    // 	z.B0.MulByNonResidue(&z.B0)
    // 	return z
    // }
    func mul_by_non_residue{range_check_ptr}(x: E6) -> E6 {
        alloc_locals;
        let zB0 = x.b2;
        let zB1 = x.b0;
        let zB2 = x.b1;
        let zB0 = e2.mul_by_non_residue(zB0);
        let res = E6(zB0, zB1, zB2);
        return res;
    }

    func zero{}() -> E6 {
        let b0 = e2.zero();
        let b1 = e2.zero();
        let b2 = e2.zero();
        let res = E6(b0, b1, b2);
        return res;
    }
    func one{}() -> E6 {
        let b0 = e2.one();
        let b1 = e2.zero();
        let b2 = e2.zero();
        let res = E6(b0, b1, b2);
        return res;
    }
    func is_zero{}(x: E6) -> felt {
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
}
