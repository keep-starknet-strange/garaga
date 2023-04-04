from src.bls12_381.fq import fq_bigint4, BigInt4, fq_eq_zero
from starkware.cairo.common.registers import get_fp_and_pc

struct E2 {
    a0: BigInt4*,
    a1: BigInt4*,
}

namespace e2 {
    func zero{}() -> E2* {
        tempvar zero_bigint4: BigInt4* = new BigInt4(0, 0, 0, 0);
        tempvar zero: E2* = new E2(zero_bigint4, zero_bigint4);
        return zero;
    }
    func one{}() -> E2* {
        tempvar one = new E2(new BigInt4(1, 0, 0, 0), new BigInt4(0, 0, 0, 0));
        return one;
    }
    func is_zero{}(x: E2*) -> felt {
        let a0_is_zero = fq_eq_zero(x.a0);
        if (a0_is_zero == 0) {
            return 0;
        }

        let a1_is_zero = fq_eq_zero(x.a1);
        return a1_is_zero;
    }
    func conjugate{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let a1 = fq_bigint4.neg(x.a1);
        // let res = E2(x.a0, a1);
        tempvar res: E2* = new E2(x.a0, a1);
        return res;
    }

    func inv{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        local inv0: BigInt4*;
        local inv1: BigInt4*;
        %{
            from starkware.cairo.common.cairo_secp.secp_utils import pack, split
            p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
            def inv_e2(a0:int, a1:int):
                t0, t1 = (a0 * a0 % p, a1 * a1 % p)
                t0 = (t0 + t1) % p
                t1 = pow(t0, -1, p)
                return (a0 * t1 % p, -(a1 * t1) % p)
            inverse0, inverse1 = inv_e2(pack(ids.x.a0, PRIME), pack(ids.x.a1, PRIME))
            inv0=split(inverse0)
            inv1=split(inverse1)
            ids.inv0 = segments.gen_arg(inv0)
            ids.inv1 = segments.gen_arg(inv1)
        %}
        tempvar inverse: E2* = new E2(inv0, inv1);

        let check = e2.mul(x, inverse);
        let one = e2.one();
        let check = e2.sub(check, one);
        let check_is_zero: felt = e2.is_zero(check);
        assert check_is_zero = 1;
        return inverse;
    }
    func add{range_check_ptr}(x: E2*, y: E2*) -> E2* {
        alloc_locals;
        let a0 = fq_bigint4.add(x.a0, y.a0);
        let a1 = fq_bigint4.add(x.a1, y.a1);
        // let res = E2(a0, a1);
        tempvar res = new E2(a0, a1);
        return res;
    }

    func double{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let a0 = fq_bigint4.add(x.a0, x.a0);
        let a1 = fq_bigint4.add(x.a1, x.a1);
        tempvar res = new E2(a0, a1);
        return res;
    }
    func neg{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let zero_2 = e2.zero();
        let res = sub(zero_2, x);
        return res;
    }
    func sub{range_check_ptr}(x: E2*, y: E2*) -> E2* {
        alloc_locals;
        let a0 = fq_bigint4.sub(x.a0, y.a0);
        let a1 = fq_bigint4.sub(x.a1, y.a1);
        tempvar res = new E2(a0, a1);
        return res;
    }
    func mul_by_element{range_check_ptr}(n: BigInt4*, x: E2*) -> E2* {
        alloc_locals;
        let a0 = fq_bigint4.mul(x.a0, n);
        let a1 = fq_bigint4.mul(x.a1, n);
        tempvar res = new E2(a0, a1);
        return res;
    }
    func mul{range_check_ptr}(x: E2*, y: E2*) -> E2* {
        alloc_locals;

        // Unreduced addition
        tempvar a = new BigInt4(
            x.a0.d0 + x.a1.d0, x.a0.d1 + x.a1.d1, x.a0.d2 + x.a1.d2, x.a0.d3 + x.a1.d3
        );
        tempvar b = new BigInt4(
            y.a0.d0 + y.a1.d0, y.a0.d1 + y.a1.d1, y.a0.d2 + y.a1.d2, y.a0.d3 + y.a1.d3
        );

        let a = fq_bigint4.mul(a, b);
        let b = fq_bigint4.mul(x.a0, y.a0);
        let c = fq_bigint4.mul(x.a1, y.a1);
        let z_a1 = fq_bigint4.sub(a, b);
        let z_a1 = fq_bigint4.sub(z_a1, c);
        let z_a0 = fq_bigint4.sub(b, c);

        tempvar res = new E2(z_a0, z_a1);
        return res;
    }
    func square{range_check_ptr}(x: E2*) -> E2* {
        // z.A0 = (x.A0 + x.A1) * (x.A0 - x.A1)
        // z.A1 = 2 * x.A0 * x.A1
        alloc_locals;
        let sum = fq_bigint4.add(x.a0, x.a1);
        let diff = fq_bigint4.sub(x.a0, x.a1);
        let a0 = fq_bigint4.mul(sum, diff);

        let mul = fq_bigint4.mul(x.a0, x.a1);
        let a1 = fq_bigint4.add(mul, mul);
        tempvar res = new E2(a0, a1);
        return res;
    }
    func mul2{range_check_ptr}(x: E2*, y: E2*) -> E2* {
        alloc_locals;

        let t1 = fq_bigint4.mul(x.a0, y.a0);
        let t2 = fq_bigint4.mul(x.a1, y.a1);
        let t3 = fq_bigint4.add(y.a0, y.a1);

        let imag = fq_bigint4.add(x.a1, x.a0);
        let imag = fq_bigint4.mul(imag, t3);
        let imag = fq_bigint4.sub(imag, t1);
        let imag = fq_bigint4.sub(imag, t2);

        let real = fq_bigint4.sub(t1, t2);

        tempvar res = new E2(real, imag);
        return res;
    }

    // MulByNonResidue multiplies a E2 by (9,1)
    func mul_by_non_residue{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;

        // Unreduced addition
        tempvar a = new BigInt4(
            x.a0.d0 + x.a1.d0, x.a0.d1 + x.a1.d1, x.a0.d2 + x.a1.d2, x.a0.d3 + x.a1.d3
        );
        let a = fq_bigint4.mul_by_10(a);
        let b = fq_bigint4.mul_by_9(x.a0);
        let z_a1 = fq_bigint4.sub(a, b);
        let z_a1 = fq_bigint4.sub(z_a1, x.a1);
        let z_a0 = fq_bigint4.sub(b, x.a1);

        tempvar res = new E2(z_a0, z_a1);
        return res;
    }

    func assert_E2(x: E2*, z: E2*) {
        assert x.a0.d0 = z.a0.d0;
        assert x.a0.d1 = z.a0.d1;
        assert x.a0.d2 = z.a0.d2;
        assert x.a0.d3 = z.a0.d3;
        assert x.a1.d0 = z.a1.d0;
        assert x.a1.d1 = z.a1.d1;
        assert x.a1.d2 = z.a1.d2;
        assert x.a1.d3 = z.a1.d3;
        return ();
    }
}
