from src.bn254.towers.e6 import e6, E6
from src.bn254.towers.e2 import e2, E2
from src.bn254.fq import fq_bigint3, BigInt3
from starkware.cairo.common.registers import get_fp_and_pc
from src.bn254.curve import N_LIMBS, DEGREE, BASE, P0, P1, P2, NON_RESIDUE_E2_a0, NON_RESIDUE_E2_a1

struct E12 {
    c0: E6*,
    c1: E6*,
}

namespace e12 {
    func conjugate{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let c1 = e6.neg(x.c1);
        local res: E12 = E12(x.c0, c1);
        return &res;
    }
    // Adds two E12 elements
    func add{range_check_ptr}(x: E12*, y: E12*) -> E12* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let c0 = e6.add(x.c0, y.c0);
        let c1 = e6.add(x.c1, y.c1);
        local res: E12 = E12(c0, c1);
        return &res;
    }

    // Subtracts two E12 elements
    func sub{range_check_ptr}(x: E12*, y: E12*) -> E12* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let c0 = e6.sub(x.c0, y.c0);
        let c1 = e6.sub(x.c1, y.c1);
        local res: E12 = E12(c0, c1);
        return &res;
    }

    // Returns 2*x in E12
    func double{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let c0 = e6.double(x.c0);
        let c1 = e6.double(x.c1);
        local res: E12 = E12(c0, c1);
        return &res;
    }
    func mul{range_check_ptr}(x: E12*, y: E12*) -> E12* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let a = e6.add(x.c0, x.c1);
        let b = e6.add(y.c0, y.c1);
        let a = e6.mul(a, b);
        let b = e6.mul(x.c0, y.c0);
        let c = e6.mul(x.c1, y.c1);
        let zC1 = e6.sub(a, b);
        let zC1 = e6.sub(zC1, c);
        let zC0 = e6.mul_by_non_residue(c);
        let zC0 = e6.add(zC0, b);
        local res: E12 = E12(zC0, zC1);
        return &res;
    }
    func square{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // let c3 = e6.mul_by_non_residue(x.c1);
        // let c3 = e6.neg(c3);
        // let c3 = e6.add(x.c0, c3);

        let c3 = e6.mulnr_neg_add(x.c1, x.c0);

        let c2t = e6.mul(x.c0, x.c1);
        let c2 = e6.mul_by_non_residue(c2t);

        let c0 = e6.sub(x.c0, x.c1);
        let c0 = e6.mul(c0, c3);
        let c0 = e6.add(c0, c2t);
        let c0 = e6.add(c0, c2);

        let c1 = e6.double(c2t);
        local res: E12 = E12(c0, c1);
        return &res;
    }
    func mul_by_034{range_check_ptr}(z: E12*, c3: E2*, c4: E2*) -> E12* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let b = e6.mul_by_01(z.c1, c3, c4);

        // let c3_a0 = fq_bigint3.add(new BigInt3(1, 0, 0), c3.a0);
        // tempvar c3_plus_one = new E2(c3_a0, c3.a1);
        // let d = e6.add(z.c0, z.c1);
        // let d = e6.mul_by_01(d, c3_plus_one, c4);

        let d = e6.add_mul_by_0_plus_one_1(z.c0, z.c1, c3, c4);
        // let zC1 = e6.add(z.c0, b);
        // let zC1 = e6.neg(zC1);
        // let zC1 = e6.add(zC1, d);

        let zC1 = e6.add_neg_add(z.c0, b, d);

        let zC0 = e6.mul_by_non_residue(b);
        let zC0 = e6.add(zC0, z.c0);
        local res: E12 = E12(zC0, zC1);
        return &res;
    }
    // multiplies two E12 sparse element of the form:
    //
    // 	E12{
    // 		C0: E6{B0: 1, B1: 0, B2: 0},
    // 		C1: E6{B0: c3, B1: c4, B2: 0},
    // 	}
    //
    // and
    //
    // 	E12{
    // 		C0: E6{B0: 1, B1: 0, B2: 0},
    // 		C1: E6{B0: d3, B1: d4, B2: 0},
    // 	}
    func mul_034_by_034{range_check_ptr}(d3: E2*, d4: E2*, c3: E2*, c4: E2*) -> E12* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let one = e2.one();
        let x3 = e2.mul(c3, d3);
        let x4 = e2.mul(c4, d4);

        let x04 = e2.add(c4, d4);
        let x03 = e2.add(c3, d3);
        let tmp = e2.add(c3, c4);
        let x34 = e2.add(d3, d4);
        let x34 = e2.mul(x34, tmp);
        let x34 = e2.sub(x34, x3);
        let x34 = e2.sub(x34, x4);

        let zC0B0 = e2.mul_by_non_residue(x4);
        let zC0B0 = e2.add(zC0B0, one);
        let zC0B1 = x3;
        let zC0B2 = x34;
        let zC1B0 = x03;
        let zC1B1 = x04;
        let zC1B2 = e2.zero();

        local c0: E6 = E6(zC0B0, zC0B1, zC0B2);
        local c1: E6 = E6(zC1B0, zC1B1, zC1B2);
        local res: E12 = E12(&c0, &c1);
        return &res;
    }
    // MulBy01234 multiplies z by an E12 sparse element of the form
    //
    // 	E12{
    // 		C0: E6{B0: c0, B1: c1, B2: c2},
    // 		C1: E6{B0: c3, B1: c4, B2: 0},
    // 	}
    func mul_by_01234{range_check_ptr}(z: E12*, x: E12*) -> E12* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let a = e6.add(z.c0, z.c1);
        let b = e6.add(x.c0, x.c1);
        let a = e6.mul(a, b);
        let b = e6.mul(z.c0, x.c0);
        let c = e6.mul_by_01(z.c1, x.c1.b0, x.c1.b1);
        let z1 = e6.sub(a, b);
        let z1 = e6.sub(z1, c);
        let z0 = e6.mul_by_non_residue(c);
        let z0 = e6.add(z0, b);
        local res: E12 = E12(z0, z1);
        return &res;
    }

    func inverse{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local inv0: BigInt3;
        local inv1: BigInt3;
        local inv2: BigInt3;
        local inv3: BigInt3;
        local inv4: BigInt3;
        local inv5: BigInt3;
        local inv6: BigInt3;
        local inv7: BigInt3;
        local inv8: BigInt3;
        local inv9: BigInt3;
        local inv10: BigInt3;
        local inv11: BigInt3;

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
        local c0b0: E2 = E2(&inv0, &inv1);
        local c0b1: E2 = E2(&inv2, &inv3);
        local c0b2: E2 = E2(&inv4, &inv5);
        local c0: E6 = E6(&c0b0, &c0b1, &c0b2);
        local c1b0: E2 = E2(&inv6, &inv7);
        local c1b1: E2 = E2(&inv8, &inv9);
        local c1b2: E2 = E2(&inv10, &inv11);
        local c1: E6 = E6(&c1b0, &c1b1, &c1b2);
        local x_inv: E12 = E12(&c0, &c1);
        let check = e12.mul(x, &x_inv);
        let one = e12.one();
        let check = e12.sub(check, one);
        let check_is_zero: felt = e12.is_zero(check);
        assert check_is_zero = 1;
        return &x_inv;
    }

    func is_zero{range_check_ptr}(x: E12*) -> felt {
        let c0_is_zero = e6.is_zero(x.c0);
        if (c0_is_zero == 0) {
            return 0;
        }

        let c1_is_zero = e6.is_zero(x.c1);
        return c1_is_zero;
    }
    func zero{}() -> E12* {
        let c0 = e6.zero();
        let c1 = e6.zero();
        tempvar res = new E12(c0, c1);
        return res;
    }
    func one{}() -> E12* {
        let c0 = e6.one();
        let c1 = e6.zero();
        tempvar res = new E12(c0, c1);
        return res;
    }
    func assert_E12(x: E12*, z: E12*) {
        e6.assert_E6(x.c0, z.c0);
        e6.assert_E6(x.c1, z.c1);
        return ();
    }
}
