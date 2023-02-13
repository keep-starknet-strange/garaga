from src.fq import fq_bigint3, BigInt3
from starkware.cairo.common.math_cmp import is_not_zero

struct E2 {
    a0: BigInt3,
    a1: BigInt3,
}

namespace e2 {
    func add{range_check_ptr}(x: E2, y: E2) -> E2 {
        alloc_locals;
        let a0 = fq_bigint3.add(x.a0, y.a0);
        let a1 = fq_bigint3.add(x.a1, y.a1);
        let res = E2(a0, a1);
        return res;
    }
    func double{range_check_ptr}(x: E2) -> E2 {
        alloc_locals;
        let a0 = fq_bigint3.add(x.a0, x.a0);
        let a1 = fq_bigint3.add(x.a1, x.a1);
        let res = E2(a0, a1);
        return res;
    }
    func neg{range_check_ptr}(x: E2) -> E2 {
        alloc_locals;
        let zero_bigint3 = BigInt3(0, 0, 0);
        let zero = E2(zero_bigint3, zero_bigint3);
        // let a0 = fq_bigint3.neg(x.a0);
        // let a1 = fq_bigint3.neg(x.a1);
        let res = sub(zero, x);
        return res;
    }
    func sub{range_check_ptr}(x: E2, y: E2) -> E2 {
        alloc_locals;
        let a0 = fq_bigint3.sub(x.a0, y.a0);
        let a1 = fq_bigint3.sub(x.a1, y.a1);
        let res = E2(a0, a1);
        return res;
    }
    func mul{range_check_ptr}(x: E2, y: E2) -> E2 {
        alloc_locals;
        // var a, b, c fp.Element
        // a.Add(&x.A0, &x.A1)
        // b.Add(&y.A0, &y.A1)
        // a.Mul(&a, &b)
        // b.Mul(&x.A0, &y.A0)
        // c.Mul(&x.A1, &y.A1)
        // z.A1.Sub(&a, &b).Sub(&z.A1, &c)
        // z.A0.Sub(&b, &c)
        let a = fq_bigint3.add(x.a0, x.a1);
        let b = fq_bigint3.add(y.a0, y.a1);
        let a = fq_bigint3.mul(a, b);
        let b = fq_bigint3.mul(x.a0, y.a0);
        let c = fq_bigint3.mul(x.a1, y.a1);
        let z_a1 = fq_bigint3.sub(a, b);
        let z_a1 = fq_bigint3.sub(z_a1, c);
        let z_a0 = fq_bigint3.sub(b, c);
        let res = E2(z_a0, z_a1);
        return res;
    }
    func mul2{range_check_ptr}(x: E2, y: E2) -> E2 {
        alloc_locals;

        let t1 = fq_bigint3.mul(x.a0, y.a0);
        let t2 = fq_bigint3.mul(x.a1, y.a1);
        let t3 = fq_bigint3.add(y.a0, y.a1);

        let imag = fq_bigint3.add(x.a1, x.a0);
        let imag = fq_bigint3.mul(imag, t3);
        let imag = fq_bigint3.sub(imag, t1);
        let imag = fq_bigint3.sub(imag, t2);

        let real = fq_bigint3.sub(t1, t2);

        let res: E2 = E2(real, imag);
        return res;
    }

    // MulByNonResidue multiplies a E2 by (9,1)
    func mul_non_residue{range_check_ptr}(x: E2) -> E2 {
        // TODO : optimize
        let y = E2(BigInt3(9, 0, 0), BigInt3(1, 0, 0));
        let res = mul(x, y);
        return res;
    }
    func is_zero{range_check_ptr}(x: E2) -> felt {
        let a0_is_zero = is_not_zero(x.a0);
        if (a0_is_zero == 0) {
            return 0;
        }

        let a1_is_zero = is_not_zero(x.a1);
        return a1_is_zero;
    }
    func zero{}() -> E2 {
        let zero_bigint3 = BigInt3(0, 0, 0);
        let zero = E2(zero_bigint3, zero_bigint3);
        return zero;
    }

}
