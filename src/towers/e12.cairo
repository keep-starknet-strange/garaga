from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq

from src.towers.e6 import e6, E6

struct E12 {
    c0: E6,
    c1: E6,
}

namespace e12 {
    // Multiplies x and y
    // var a, b, c E6
    // a.Add(&x.C0, &x.C1)
    // b.Add(&y.C0, &y.C1)
    // a.Mul(&a, &b)
    // b.Mul(&x.C0, &y.C0)
    // c.Mul(&x.C1, &y.C1)
    // z.C1.Sub(&a, &b).Sub(&z.C1, &c)
    // z.C0.MulByNonResidue(&c).Add(&z.C0, &b)
    func mul{range_check_ptr}(x: E12, y: E12) -> E12 {
        alloc_locals;
        let a = e6.add(x.C0, x.C1);
        let b = e6.add(y.C0, y.C1);
        let a = e6.mul(a, b);
        let b = e6.mul(x.C0, y.C0);
        let c = e6.mul(x.C1, y.C1);
        let zC1 = e6.sub(a, b);
        let zC1 = e6.sub(zC1, c);
        let zC0 = e6.mul_by_non_residue(c);
        let zC0 = e6.add(zC0, b);
        let res = E12(zC0, zC1);
        return res;
    }

    // Adds two E12 elements
    func add{range_check_ptr}(x: E12, y: E12) -> E12 {
        alloc_locals;
        let C0 = e6.add(x.c0, y.c0);
        let C1 = e6.add(x.c1, y.c1);
        let res = E12(C0, C1);
        return res;
    }

    // Subtracts two E6 elements
    func sub{range_check_ptr}(x: E12, y: E12) -> E12 {
        let C0 = e6.sub(x.C0, y.C0);
        let C1 = e6.sub(x.C1, y.C1);
        let res = E12(C0, C1);
        return res;
    }

    // Returns 2*x in E12
    func double{range_check_ptr}(x: E12) -> E12 {
        let C0 = e6.double(x.C0);
        let C1 = e6.double(x.C1);
        let res = E12(C0, C1);
    }

    // var c0, c2, c3 E6
    // c0.Sub(&x.C0, &x.C1)
    // c3.MulByNonResidue(&x.C1).Neg(&c3).Add(&x.C0, &c3)
    // c2.Mul(&x.C0, &x.C1)
    // c0.Mul(&c0, &c3).Add(&c0, &c2)
    // z.C1.Double(&c2)
    // c2.MulByNonResidue(&c2)
    // z.C0.Add(&c0, &c2)
    func square{range_check_ptr}(x: E12) -> E12 {
        let c0 = e6.sub(x.c0, x.c1);
        let c3 = e6.mul_by_non_residue(x.c1);
        let c3 = e6.neg(c3);
        let c3 = e6.add(x.c0, c3);
        let c2 = e6.mul(x.c0, x.c1);
        let c0 = e6.mul(c0, c3);
        let c0 = e6.add(c0, c2);
        let zC1 = e6.double(c2);
        let c2 = e6.mul_by_non_residue(c2);
        let zC0 = e6.mul(c0, c2);
        let res = E12(zC0, zC1);
        return res;
    }

    func is_zero{range_check_ptr}(x: E12) -> felt {
        let c0_is_zero = e6.is_zero(x.C0);
        if (c0_is_zero == 0) {
            return 0;
        }

        let c1_is_zero = e6.is_zero(x.C1);
        return c1_is_zero;
    }
}
