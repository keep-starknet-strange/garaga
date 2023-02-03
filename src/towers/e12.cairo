from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq

struct E12 {
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
    func mul(x: E12, y: E12) -> () {
        return ();
    }
}
