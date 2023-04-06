from src.bls12_381.towers.e6 import e6, E6
from src.bls12_381.towers.e2 import e2, E2
from src.bls12_381.fq import fq_bigint4, BigInt4
from starkware.cairo.common.registers import get_fp_and_pc
from src.bls12_381.curve import (
    N_LIMBS,
    DEGREE,
    BASE,
    P0,
    P1,
    P2,
    P3,
    NON_RESIDUE_E2_a0,
    NON_RESIDUE_E2_a1,
)

struct E12 {
    c0: E6*,
    c1: E6*,
}

namespace e12 {
    // Returns the conjugate of x in E12
    func conjugate{range_check_ptr}(x: E12*) -> E12* {
        let c1 = e6.neg(x.c1);
        tempvar res = new E12(x.c0, c1);
        return res;
    }  // OK

    // Adds two E12 elements
    func add{range_check_ptr}(x: E12*, y: E12*) -> E12* {
        alloc_locals;
        let c0 = e6.add(x.c0, y.c0);
        let c1 = e6.add(x.c1, y.c1);
        tempvar res = new E12(c0, c1);
        return res;
    }  // OK

    // Subtracts two E12 elements
    func sub{range_check_ptr}(x: E12*, y: E12*) -> E12* {
        alloc_locals;
        let c0 = e6.sub(x.c0, y.c0);
        let c1 = e6.sub(x.c1, y.c1);
        tempvar res = new E12(c0, c1);
        return res;
    }  // OK

    // Returns 2*x in E12
    func double{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let c0 = e6.double(x.c0);
        let c1 = e6.double(x.c1);
        tempvar res = new E12(c0, c1);
        return res;
    }  // OK

    func mul{range_check_ptr}(x: E12*, y: E12*) -> E12* {
        alloc_locals;
        let a = e6.add(x.c0, x.c1);
        let b = e6.add(y.c0, y.c1);
        let a = e6.mul(a, b);
        let b = e6.mul(x.c0, y.c0);
        let c = e6.mul(x.c1, y.c1);
        let zC1 = e6.sub(a, b);
        let zC1 = e6.sub(zC1, c);
        let zC0 = e6.mul_by_non_residue(c);
        let zC0 = e6.add(zC0, b);
        tempvar res = new E12(zC0, zC1);
        return res;
    }  // OK

    // Multiplication by sparse element (c0, c1, 0, 0, c4)
    func mul_by_014{range_check_ptr}(z: E12*, c0: E2*, c1: E2*, c4: E2*) -> E12* {
        alloc_locals;
        let a = e6.mul_by_01(z.c0, c0, c1);
        let b = e6.mul_by_1(z.c1, c4);
        let d = e2.add(c1, c4);
        let zC1 = e6.add(z.c1, z.c0);
        let zC1 = e6.mul_by_01(zC1, c0, d);
        let zC1 = e6.sub(zC1, a);
        let zC1 = e6.sub(zC1, b);
        let zC0 = e6.mul_by_non_residue(b);
        let zC0 = e6.add(zC0, a);
        tempvar res = new E12(zC0, zC1);
        return res;
    }  // OK

    // Mul014By014 multiplication of sparse element (c0,c1,0,0,c4,0) by sparse element (d0,d1,0,0,d4,0)
    func mul_014_by_014{range_check_ptr}(
        c0: E2*, c1: E2*, c4: E2*, d0: E2*, d1: E2*, d4: E2*
    ) -> E12* {
        alloc_locals;
        let x0 = e2.mul(c0, d0);
        let x1 = e2.mul(c1, d1);
        let x4 = e2.mul(c4, d4);
        let tmp = e2.add(c0, c4);
        let x04 = e2.add(d0, d4);
        let x04 = e2.mul(x04, tmp);
        let x04 = e2.sub(x04, x0);
        let x04 = e2.sub(x04, x4);
        let tmp = e2.add(c0, c1);
        let x01 = e2.add(d0, d1);
        let x01 = e2.mul(x01, tmp);
        let x01 = e2.sub(x01, x0);
        let x01 = e2.sub(x01, x1);
        let tmp = e2.add(c1, c4);
        let x14 = e2.add(d1, d4);
        let x14 = e2.mul(x14, tmp);
        let x14 = e2.sub(x14, x1);
        let x14 = e2.sub(x14, x4);
        let c0B0 = e2.mul_by_non_residue(x4);
        let c0B0 = e2.add(c0B0, x0);
        let c0B1 = x01;
        let c0B2 = x1;
        let c1B0 = e2.zero();
        let c1B1 = x04;
        let c1B2 = x14;
        tempvar res = new E12(new E6(c0B0, c0B1, c0B2), new E6(c1B0, c1B1, c1B2));
        return res;
    }  // OK

    func square{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let c0 = e6.sub(x.c0, x.c1);
        let c3 = e6.mul_by_non_residue(x.c1);
        let c3 = e6.neg(c3);
        let c3 = e6.add(x.c0, c3);
        let c2 = e6.mul(x.c0, x.c1);
        let c0 = e6.mul(c0, c3);
        let c0 = e6.add(c0, c2);
        let c1 = e6.double(c2);
        let c2 = e6.mul_by_non_residue(c2);
        let c0 = e6.add(c0, c2);
        tempvar res = new E12(c0, c1);
        return res;
    }  // OK

    func inverse{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local inv0: BigInt4;
        local inv1: BigInt4;
        local inv2: BigInt4;
        local inv3: BigInt4;
        local inv4: BigInt4;
        local inv5: BigInt4;
        local inv6: BigInt4;
        local inv7: BigInt4;
        local inv8: BigInt4;
        local inv9: BigInt4;
        local inv10: BigInt4;
        local inv11: BigInt4;
        tempvar inv = new E12(
            new E6(new E2(&inv0, &inv1), new E2(&inv2, &inv3), new E2(&inv4, &inv5)),
            new E6(new E2(&inv6, &inv7), new E2(&inv8, &inv9), new E2(&inv10, &inv11)),
        );
        %{
            from starkware.cairo.common.math_utils import as_int
            assert 1 < ids.N_LIMBS <= 12
            p, c0, c1=0, 6*[0], 6*[0]
            c0_refs =[ids.x.c0.b0.a0, ids.x.c0.b0.a1, ids.x.c0.b1.a0, ids.x.c0.b1.a1, ids.x.c0.b2.a0, ids.x.c0.b2.a1]
            c1_refs =[ids.x.c1.b0.a0, ids.x.c1.b0.a1, ids.x.c1.b1.a0, ids.x.c1.b1.a1, ids.x.c1.b2.a0, ids.x.c1.b2.a1]

            # E2 Tower:
            def mul_e2(x:(int,int), y:(int,int)):
                a = (x[0] + x[1]) * (y[0] + y[1]) % p
                b, c  = x[0]*y[0] % p, x[1]*y[1] % p
                return (b - c) % p, (a - b - c) % p
            def square_e2(x:(int,int)):
                return mul_e2(x,x)
            def double_e2(x:(int,int)):
                return 2*x[0]%p, 2*x[1]%p
            def sub_e2(x:(int,int), y:(int,int)):
                return (x[0]-y[0]) % p, (x[1]-y[1]) % p
            def neg_e2(x:(int,int)):
                return -x[0] % p, -x[1] % p
            def mul_by_non_residue_e2(x:(int, int)):
                return mul_e2(x, (ids.NON_RESIDUE_E2_a0, ids.NON_RESIDUE_E2_a1))
            def add_e2(x:(int,int), y:(int,int)):
                return (x[0]+y[0]) % p, (x[1]+y[1]) % p
            def inv_e2(a:(int, int)):
                t0, t1 = (a[0] * a[0] % p, a[1] * a[1] % p)
                t0 = (t0 + t1) % p
                t1 = pow(t0, -1, p)
                return a[0] * t1 % p, -(a[1] * t1) % p

            # E6 Tower:
            def mul_by_non_residue_e6(x:((int,int),(int,int),(int,int))):
                return mul_by_non_residue_e2(x[2]), x[0], x[1]
            def sub_e6(x:((int,int), (int,int), (int,int)),y:((int,int), (int,int), (int,int))):
                return (sub_e2(x[0], y[0]), sub_e2(x[1], y[1]), sub_e2(x[2], y[2]))
            def neg_e6(x:((int,int), (int,int), (int,int))):
                return neg_e2(x[0]), neg_e2(x[1]), neg_e2(x[2])
            def inv_e6(x:((int,int),(int,int),(int,int))):
                t0, t1, t2 = square_e2(x[0]), square_e2(x[1]), square_e2(x[2])
                t3, t4, t5 = mul_e2(x[0], x[1]), mul_e2(x[0], x[2]), mul_e2(x[1], x[2]) 
                c0 = add_e2(neg_e2(mul_by_non_residue_e2(t5)), t0)
                c1 = sub_e2(mul_by_non_residue_e2(t2), t3)
                c2 = sub_e2(t1, t4)
                t6 = mul_e2(x[0], c0)
                d1 = mul_e2(x[2], c1)
                d2 = mul_e2(x[1], c2)
                d1 = mul_by_non_residue_e2(add_e2(d1, d2))
                t6 = add_e2(t6, d1)
                t6 = inv_e2(t6)
                return mul_e2(c0, t6), mul_e2(c1, t6), mul_e2(c2, t6)


            def mul_e6(x:((int,int),(int,int),(int,int)), y:((int,int),(int,int),(int,int))):
                assert len(x) == 3 and len(y) == 3 and len(x[0]) == 2 and len(x[1]) == 2 and len(x[2]) == 2 and len(y[0]) == 2 and len(y[1]) == 2 and len(y[2]) == 2
                t0, t1, t2 = mul_e2(x[0], y[0]), mul_e2(x[1], y[1]), mul_e2(x[2], y[2])
                c0 = add_e2(x[1], x[2])
                tmp = add_e2(y[1], y[2])
                c0 = mul_e2(c0, tmp)
                c0 = sub_e2(c0, t1)
                c0 = sub_e2(c0, t2)
                c0 = mul_by_non_residue_e2(c0)
                c0 = add_e2(c0, t0)
                c1 = add_e2(x[0], x[1])
                tmp = add_e2(y[0], y[1])
                c1 = mul_e2(c1, tmp)
                c1 = sub_e2(c1, t0)
                c1 = sub_e2(c1, t1)
                tmp = mul_by_non_residue_e2(t2)
                c1 = add_e2(c1, tmp)
                tmp = add_e2(x[0], x[2])
                c2 = add_e2(y[0], y[2])
                c2 = mul_e2(c2, tmp)
                c2 = sub_e2(c2, t0)
                c2 = sub_e2(c2, t2)
                c2 = add_e2(c2, t1)
                return c0, c1, c2
            def square_e6(x:((int,int),(int,int),(int,int))):
                return mul_e6(x,x)

            def inv_e12(c0:((int,int),(int,int),(int,int)), c1:((int,int),(int,int),(int,int))):
                t0, t1 = square_e6(c0), square_e6(c1)
                tmp = mul_by_non_residue_e6(t1)
                t0 = sub_e6(t0, tmp)
                t1 = inv_e6(t0)
                c0 = mul_e6(c0, t1)
                c1 = mul_e6(c1, t1)
                c1 = neg_e6(c1)
                return [c0[0][0], c0[0][1], c0[1][0], c0[1][1], c0[2][0], c0[2][1], c1[0][0], c1[0][1], c1[1][0], c1[1][1], c1[2][0], c1[2][1]]
            for i in range(ids.N_LIMBS):
                for k in range(6):
                    c0[k]+=as_int(getattr(c0_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
                    c1[k]+=as_int(getattr(c1_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
            c0 = ((c0[0],c0[1]),(c0[2],c0[3]),(c0[4],c0[5]))
            c1 = ((c1[0],c1[1]),(c1[2],c1[3]),(c1[4],c1[5]))
            x_inv = inv_e12(c0,c1)
            e = [split(x) for x in x_inv]
            for i in range(12):
                for l in range(ids.N_LIMBS):
                    setattr(getattr(ids,f"inv{i}"),f"d{l}",e[i][l])
        %}
        let check = e12.mul(x, inv);
        let one = e12.one();
        let check = e12.sub(check, one);
        let check_is_zero: felt = e12.is_zero(check);
        assert check_is_zero = 1;
        return inv;
    }

    func inverse_go{range_check_ptr}(x: E12*) -> E12* {
        let t0 = e6.square(x.c0);
        let t1 = e6.square(x.c1);
        let tmp = e6.mul_by_non_residue(t1);
        let t0 = e6.sub(t0, tmp);
        let t1 = e6.inverse(t0);
        let c0 = e6.mul(x.c0, t1);
        let c1 = e6.mul(x.c1, t1);
        let c1 = e6.neg(c1);
        tempvar res = new E12(c0, c1);
        return res;
    }  // OK

    func is_zero{range_check_ptr}(x: E12*) -> felt {
        let c0_is_zero = e6.is_zero(x.c0);
        if (c0_is_zero == 0) {
            return 0;
        }

        let c1_is_zero = e6.is_zero(x.c1);
        return c1_is_zero;
    }  // OK

    func zero{}() -> E12* {
        let c0 = e6.zero();
        let c1 = e6.zero();
        tempvar res = new E12(c0, c1);
        return res;
    }  // OK

    func one{}() -> E12* {
        let c0 = e6.one();
        let c1 = e6.zero();
        tempvar res = new E12(c0, c1);
        return res;
    }  // OK

    func frobenius{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let c0B0 = e2.conjugate(x.c0.b0);
        let c0B1 = e2.conjugate(x.c0.b1);
        let c0B2 = e2.conjugate(x.c0.b2);
        let c1B0 = e2.conjugate(x.c1.b0);
        let c1B1 = e2.conjugate(x.c1.b1);
        let c1B2 = e2.conjugate(x.c1.b2);

        let c0B1 = e2.mul_by_non_residue_1_power_2(c0B1);
        let c0B2 = e2.mul_by_non_residue_1_power_4(c0B2);
        let c1B0 = e2.mul_by_non_residue_1_power_1(c1B0);
        let c1B1 = e2.mul_by_non_residue_1_power_3(c1B1);
        let c1B2 = e2.mul_by_non_residue_1_power_5(c1B2);

        tempvar res = new E12(new E6(c0B0, c0B1, c0B2), new E6(c1B0, c1B1, c1B2));
        return res;
    }

    func frobenius_square{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let c0B0 = x.c0.b0;
        let c0B1 = e2.mul_by_non_residue_2_power_2(x.c0.b1);
        let c0B2 = e2.mul_by_non_residue_2_power_4(x.c0.b2);
        let c1B0 = e2.mul_by_non_residue_2_power_1(x.c1.b0);
        let c1B1 = e2.mul_by_non_residue_2_power_3(x.c1.b1);
        let c1B2 = e2.mul_by_non_residue_2_power_5(x.c1.b2);
        tempvar res = new E12(new E6(c0B0, c0B1, c0B2), new E6(c1B0, c1B1, c1B2));
        return res;
    }

    func cyclotomic_square{range_check_ptr}(x: E12*) -> E12* {
        // // x=(x0,x1,x2,x3,x4,x5,x6,x7) in E2^6
        // // cyclosquare(x)=(3*x4^2*u + 3*x0^2 - 2*x0,
        // //					3*x2^2*u + 3*x3^2 - 2*x1,
        // //					3*x5^2*u + 3*x1^2 - 2*x2,
        // //					6*x1*x5*u + 2*x3,
        // //					6*x0*x4 + 2*x4,
        // //					6*x2*x3 + 2*x5)

        alloc_locals;
        let t0 = e2.square(x.c1.b1);
        let t1 = e2.square(x.c0.b0);
        let t6 = e2.add(x.c1.b1, x.c0.b0);
        let t6 = e2.square(t6);
        let t6 = e2.sub(t6, t0);
        let t6 = e2.sub(t6, t1);  // 2*x4*x0
        let t2 = e2.square(x.c0.b2);
        let t3 = e2.square(x.c1.b0);
        let t7 = e2.add(x.c0.b2, x.c1.b0);
        let t7 = e2.square(t7);
        let t7 = e2.sub(t7, t2);
        let t7 = e2.sub(t7, t3);  // 2*x2*x3

        let t4 = e2.square(x.c1.b2);
        let t5 = e2.square(x.c0.b1);

        let t8 = e2.add(x.c1.b2, x.c0.b1);
        let t8 = e2.square(t8);
        let t8 = e2.sub(t8, t4);
        let t8 = e2.sub(t8, t5);
        let t8 = e2.mul_by_non_residue(t8);  // 2*x5*x1*u

        let t0 = e2.mul_by_non_residue(t0);
        let t0 = e2.add(t0, t1);  // x4^2*u + x0^2
        let t2 = e2.mul_by_non_residue(t2);
        let t2 = e2.add(t2, t3);  // x2^2*u + x3^2
        let t4 = e2.mul_by_non_residue(t4);
        let t4 = e2.add(t4, t5);  // x5^2*u + x1^2

        let zc0b0 = e2.sub(t0, x.c0.b0);
        let zc0b0 = e2.double(zc0b0);
        let zc0b0 = e2.add(zc0b0, t0);

        let zc0b1 = e2.sub(t2, x.c0.b1);
        let zc0b1 = e2.double(zc0b1);
        let zc0b1 = e2.add(zc0b1, t2);

        let zc0b2 = e2.sub(t4, x.c0.b2);
        let zc0b2 = e2.double(zc0b2);
        let zc0b2 = e2.add(zc0b2, t4);

        let zc1b0 = e2.add(t8, x.c1.b0);
        let zc1b0 = e2.double(zc1b0);
        let zc1b0 = e2.add(zc1b0, t8);

        let zc1b1 = e2.add(t6, x.c1.b1);
        let zc1b1 = e2.double(zc1b1);
        let zc1b1 = e2.add(zc1b1, t6);

        let zc1b2 = e2.add(t7, x.c1.b2);
        let zc1b2 = e2.double(zc1b2);
        let zc1b2 = e2.add(zc1b2, t7);

        tempvar res = new E12(new E6(zc0b0, zc0b1, zc0b2), new E6(zc1b0, zc1b1, zc1b2));
        return res;
    }  // OK

    func n_square{range_check_ptr}(x: E12*, n: felt) -> E12* {
        if (n == 0) {
            return x;
        } else {
            let res = cyclotomic_square(x);
            return n_square(res, n - 1);
        }
    }  // OK

    // Returns x^(t/2) in E12 where
    // t/2 = 7566188111470821376 // negative
    func expt_half{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let t0 = n_square(x, 15);
        let t1 = n_square(t0, 32);

        let Karabina_0: E12* = decompress_Karabina(t0);
        let Karabina_1: E12* = decompress_Karabina(t1);
        let res = e12.mul(Karabina_0, Karabina_1);

        let Karabina_1 = n_square(Karabina_1, 9);
        let res = e12.mul(res, Karabina_1);

        let Karabina_1 = n_square(Karabina_1, 3);
        let res = e12.mul(res, Karabina_1);

        let Karabina_1 = n_square(Karabina_1, 2);
        let res = e12.mul(res, Karabina_1);

        let Karabina_1 = cyclotomic_square(Karabina_1);
        let res = e12.mul(res, Karabina_1);

        return conjugate(res);
    }  // OK?
    func decompress_Karabina{range_check_ptr}(x0: E12*) -> E12* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        %{
            import numpy as np
            def print_e2(x, n):    
                t0_a0 = x.a0.d0 + x.a0.d1 * ids.BASE + x.a0.d2 * ids.BASE**2 + x.a0.d3 * ids.BASE**3
                t0_a1 = x.a1.d0 + x.a1.d1 * ids.BASE + x.a1.d2 * ids.BASE**2 + x.a1.d3 * ids.BASE**3
                print(f"{n} = {np.base_repr(t0_a0,36)} + {np.base_repr(t0_a1,36)} * i")
        %}
        // x0
        local t0: E2*;
        local t1: E2*;
        let one = e2.one();
        let is_zero = e2.is_zero(x0.c1.b2);
        if (is_zero == 1) {
            let t0t = e2.mul(x0.c0.b1, x0.c1.b2);
            let t0t = e2.double(t0t);
            // let t1 = x0.c0.b2;
            assert t0 = t0t;
            assert t1 = x0.c0.b2;
            tempvar range_check_ptr = range_check_ptr;
        } else {
            let t0t = e2.square(x0.c0.b1);
            let t1t = e2.sub(t0t, x0.c0.b2);

            let t1t = e2.double(t1t);
            let t1t = e2.add(t1t, t0t);

            let t20 = e2.square(x0.c1.b2);
            let t0t = e2.mul_by_non_residue(t20);
            let t0t = e2.add(t0t, t1t);
            let t1t = e2.double(x0.c1.b0);
            let t1t = e2.double(t1t);
            assert t0 = t0t;

            assert t1 = t1t;

            tempvar range_check_ptr = range_check_ptr;
        }
        let t1t = e2.inv(t1);
        let x0c1b1 = e2.mul(t0, t1t);

        let t1t = e2.mul(x0.c0.b2, x0.c0.b1);
        let t20 = e2.square(x0c1b1);
        let t20 = e2.sub(t20, t1t);
        let t20 = e2.double(t20);
        let t20 = e2.sub(t20, t1t);

        let t1 = e2.mul(x0.c1.b0, x0.c1.b2);

        let t20 = e2.add(t20, t1);
        let x0c0b0 = e2.mul_by_non_residue(t20);
        let x0c0b0 = e2.add(x0c0b0, one);

        local res0c0: E6 = E6(x0c0b0, x0.c0.b1, x0.c0.b2);
        local res0c1: E6 = E6(x0.c1.b0, x0c1b1, x0.c1.b2);
        local res0: E12 = E12(&res0c0, &res0c1);

        return &res0;
    }
    // Returns x^t
    // where t is = 15132376222941642752 // negative
    func expt{range_check_ptr}(x: E12*) -> E12* {
        let res = expt_half(x);
        return cyclotomic_square(res);
    }  // OK

    func assert_E12(x: E12*, z: E12*) {
        e6.assert_E6(x.c0, z.c0);
        e6.assert_E6(x.c1, z.c1);
        return ();
    }  // OK
}
