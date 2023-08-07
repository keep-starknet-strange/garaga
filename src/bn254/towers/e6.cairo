from starkware.cairo.common.registers import get_fp_and_pc

from src.bn254.towers.e2 import e2, E2
from src.bn254.fq import BigInt3
from src.bn254.curve import N_LIMBS, DEGREE, BASE, P0, P1, P2, NON_RESIDUE_E2_a0, NON_RESIDUE_E2_a1

struct E6 {
    b0: E2*,
    b1: E2*,
    b2: E2*,
}

namespace e6 {
    func add{range_check_ptr}(x: E6*, y: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let b0 = e2.add(x.b0, y.b0);
        let b1 = e2.add(x.b1, y.b1);
        let b2 = e2.add(x.b2, y.b2);
        local res: E6 = E6(b0, b1, b2);
        return &res;
    }

    func sub{range_check_ptr}(x: E6*, y: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let b0 = e2.sub(x.b0, y.b0);
        let b1 = e2.sub(x.b1, y.b1);
        let b2 = e2.sub(x.b2, y.b2);
        local res: E6 = E6(b0, b1, b2);
        return &res;
    }

    func double{range_check_ptr}(x: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let b0 = e2.double(x.b0);
        let b1 = e2.double(x.b1);
        let b2 = e2.double(x.b2);
        local res: E6 = E6(b0, b1, b2);
        return &res;
    }

    func neg{range_check_ptr}(x: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let b0 = e2.neg(x.b0);
        let b1 = e2.neg(x.b1);
        let b2 = e2.neg(x.b2);
        local res: E6 = E6(b0, b1, b2);
        return &res;
    }

    func mul{range_check_ptr}(x: E6*, y: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let t0 = e2.mul(x.b0, y.b0);
        let t1 = e2.mul(x.b1, y.b1);
        let t2 = e2.mul(x.b2, y.b2);
        // let tmp = e2.add(y.b1, y.b2);
        // let c0 = e2.add(x.b1, x.b2);
        // let c0 = e2.mul(c0, tmp);
        // let c0 = e2.sub(c0, t1);
        // let c0 = e2.sub(c0, t2);
        // let c0 = e2.mul_by_non_residue(c0);
        // let c0 = e2.add(c0, t0);

        let c0 = e2.add_add_mul_sub_sub_mulnr_add(y.b1, y.b2, x.b1, x.b2, t1, t2, t0);

        // let c1 = e2.add(x.b0, x.b1);
        // let tmp = e2.add(y.b0, y.b1);
        // let c1 = e2.mul(c1, tmp);
        // let c1 = e2.sub(c1, t0);
        // let c1 = e2.sub(c1, t1);
        // let tmp = e2.mul_by_non_residue(t2);
        // let c1 = e2.add(c1, tmp);

        let c1 = e2.add_add_mul_sub_sub_addmulnr(x.b0, x.b1, y.b0, y.b1, t0, t1, t2);

        // let tmp = e2.add(x.b0, x.b2);
        // let c2 = e2.add(y.b0, y.b2);
        // let c2 = e2.mul(c2, tmp);
        // let c2 = e2.sub(c2, t0);
        // let c2 = e2.sub(c2, t2);
        // let c2 = e2.add(c2, t1);
        let c2 = e2.add_add_mul_sub_sub_add(x.b0, x.b2, y.b0, y.b2, t0, t2, t1);

        local res: E6 = E6(c0, c1, c2);
        return &res;
    }

    func inv{range_check_ptr}(x: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local inv0: BigInt3;
        local inv1: BigInt3;
        local inv2: BigInt3;
        local inv3: BigInt3;
        local inv4: BigInt3;
        local inv5: BigInt3;

        %{
            from starkware.cairo.common.math_utils import as_int
            assert 1 < ids.N_LIMBS <= 12
            p, c0=0, 6*[0]
            c0_refs =[ids.x.b0.a0, ids.x.b0.a1, ids.x.b1.a0, ids.x.b1.a1, ids.x.b2.a0, ids.x.b2.a1]

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
                return [*mul_e2(c0, t6), *mul_e2(c1, t6), *mul_e2(c2, t6)]


            for i in range(ids.N_LIMBS):
                for k in range(6):
                    c0[k]+=as_int(getattr(c0_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
            c0 = ((c0[0],c0[1]),(c0[2],c0[3]),(c0[4],c0[5]))
            x_inv = inv_e6(c0)
            e = [split(x) for x in x_inv]
            for i in range(6):
                for l in range(ids.N_LIMBS):
                    setattr(getattr(ids,f"inv{i}"),f"d{l}",e[i][l])
        %}

        local b0: E2 = E2(&inv0, &inv1);
        local b1: E2 = E2(&inv2, &inv3);
        local b2: E2 = E2(&inv4, &inv5);

        local x_inv: E6 = E6(&b0, &b1, &b2);

        let one_e6 = one();
        let check = mul(x, &x_inv);

        assert_E6(check, one_e6);

        return &x_inv;
    }

    func mul_by_non_residue{range_check_ptr}(x: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let b0 = x.b2;
        let b1 = x.b0;
        let b2 = x.b1;
        let b0 = e2.mul_by_non_residue(b0);
        local res: E6 = E6(b0, b1, b2);
        return &res;
    }

    func mul_by_E2{range_check_ptr}(x: E6*, y: E2*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let b0 = e2.mul(x.b0, y);
        let b1 = e2.mul(x.b1, y);
        let b2 = e2.mul(x.b2, y);
        local res: E6 = E6(b0, b1, b2);
        return &res;
    }

    func mul_by_01{range_check_ptr}(x: E6*, b0: E2*, b1: E2*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let a = e2.mul(x.b0, b0);
        let b = e2.mul(x.b1, b1);
        // let tmp = e2.add(x.b1, x.b2);
        // let t0 = e2.mul(b1, tmp);
        // let t0 = e2.sub(t0, b);
        // let t0 = e2.mul_by_non_residue(t0);
        // let t0 = e2.add(t0, a);

        let t0 = e2.add_mul_sub_mulnr_add(x.b1, x.b2, b1, b, a);

        // let tmp = e2.add(x.b0, x.b2);
        // let t2 = e2.mul(b0, tmp);
        // let t2 = e2.sub(t2, a);
        // let t2 = e2.add(t2, b);

        let t2 = e2.add_mul_sub_add(x.b0, x.b2, b0, a, b);

        // let tmp = e2.add(x.b0, x.b1);
        // let t1 = e2.add(b0, b1);

        // let t1 = e2.mul(t1, tmp);
        // let t1 = e2.sub(t1, a);
        // let t1 = e2.sub(t1, b);

        let t1 = e2.add_add_mul_sub_sub(x.b0, x.b1, b0, b1, a, b);

        local res: E6 = E6(t0, t1, t2);
        return &res;
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
