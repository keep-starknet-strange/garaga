from starkware.cairo.common.registers import get_fp_and_pc

from src.bn254.towers.e2 import e2, E2, E2UnreducedFull
from src.bn254.fq import BigInt3, reduce_3, UnreducedBigInt3, assert_reduced_felt
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
        let t0: E2UnreducedFull = e2.mul_unreduced(x.b0, y.b0);
        let t1: E2UnreducedFull = e2.mul_unreduced(x.b1, y.b1);
        let t2: E2UnreducedFull = e2.mul_unreduced(x.b2, y.b2);

        let c0 = e2.add_add_mul_sub_sub_mulnr_add(y.b1, y.b2, x.b1, x.b2, t1, t2, t0);
        let c1 = e2.add_add_mul_sub_sub_addmulnr(x.b0, x.b1, y.b0, y.b1, t0, t1, t2);
        let c2 = e2.add_add_mul_sub_sub_add(x.b0, x.b2, y.b0, y.b2, t0, t2, t1);

        local res: E6 = E6(c0, c1, c2);
        return &res;
    }

    func mul_plus_one_b1{range_check_ptr}(x: E6*, y: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let t0 = e2.mul_unreduced(x.b0, y.b0);
        let t1 = e2.mul_unreduced(x.b1, y.b1);
        let t2 = e2.mul_unreduced(x.b2, y.b2);

        let c0 = e2.add_add_mul_sub_sub_mulnr_add(y.b1, y.b2, x.b1, x.b2, t1, t2, t0);
        let c1 = e2.add_add_mul_sub_sub_addmulnr_plus_one(x.b0, x.b1, y.b0, y.b1, t0, t1, t2);
        let c2 = e2.add_add_mul_sub_sub_add(x.b0, x.b2, y.b0, y.b2, t0, t2, t1);

        local res: E6 = E6(c0, c1, c2);
        return &res;
    }

    // func sub_mul_add_add{range_check_ptr}(
    //     sub_left: E6*, sub_right: E6*, mul_right: E6*, add1_right: E6*, add2_right: E6*
    // ) {
    //     alloc_locals;
    //     let (__fp__, _) = get_fp_and_pc();
    //     let mul_left_b0_a0 = BigInt3(
    //         sub_left.b0.a0.d0 - sub_right.b0.a0.d0,
    //         sub_left.b0.a0.d1 - sub_right.b0.a0.d1,
    //         sub_left.b0.a0.d2 - sub_right.b0.a0.d2,
    //     );
    //     let mul_left_b0_a1 = BigInt3(
    //         sub_left.b0.a1.d0 - sub_right.b0.a1.d0,
    //         sub_left.b0.a1.d1 - sub_right.b0.a1.d1,
    //         sub_left.b0.a1.d2 - sub_right.b0.a1.d2,
    //     );
    //     let mul_left_b1_a0 = BigInt3(
    //         sub_left.b1.a0.d0 - sub_right.b1.a0.d0,
    //         sub_left.b1.a0.d1 - sub_right.b1.a0.d1,
    //         sub_left.b1.a0.d2 - sub_right.b1.a0.d2,
    //     );
    //     let mul_left_b1_a1 = BigInt3(
    //         sub_left.b1.a1.d0 - sub_right.b1.a1.d0,
    //         sub_left.b1.a1.d1 - sub_right.b1.a1.d1,
    //         sub_left.b1.a1.d2 - sub_right.b1.a1.d2,
    //     );
    //     let mul_left_b2_a0 = BigInt3(
    //         sub_left.b2.a0.d0 - sub_right.b2.a0.d0,
    //         sub_left.b2.a0.d1 - sub_right.b2.a0.d1,
    //         sub_left.b2.a0.d2 - sub_right.b2.a0.d2,
    //     );
    //     let mul_left_b2_a1 = BigInt3(
    //         sub_left.b2.a1.d0 - sub_right.b2.a1.d0,
    //         sub_left.b2.a1.d1 - sub_right.b2.a1.d1,
    //         sub_left.b2.a1.d2 - sub_right.b2.a1.d2,
    //     );

    // let t0 = e2.mul(x.b0, y.b0);
    //     let t1 = e2.mul(x.b1, y.b1);
    //     let t2 = e2.mul(x.b2, y.b2);

    // let c0 = e2.add_add_mul_sub_sub_mulnr_add(y.b1, y.b2, x.b1, x.b2, t1, t2, t0);
    //     let c1 = e2.add_add_mul_sub_sub_addmulnr(x.b0, x.b1, y.b0, y.b1, t0, t1, t2);
    //     let c2 = e2.add_add_mul_sub_sub_add(x.b0, x.b2, y.b0, y.b2, t0, t2, t1);
    // }

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
        assert_reduced_felt(inv0);
        assert_reduced_felt(inv1);
        assert_reduced_felt(inv2);
        assert_reduced_felt(inv3);
        assert_reduced_felt(inv4);
        assert_reduced_felt(inv5);

        local b0: E2 = E2(&inv0, &inv1);
        local b1: E2 = E2(&inv2, &inv3);
        local b2: E2 = E2(&inv4, &inv5);

        local x_inv: E6 = E6(&b0, &b1, &b2);

        let one_e6 = one();
        let check = mul(x, &x_inv);

        assert_E6(check, one_e6);

        return &x_inv;
    }

    func div{range_check_ptr}(x: E6*, y: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local div0: BigInt3;
        local div1: BigInt3;
        local div2: BigInt3;
        local div3: BigInt3;
        local div4: BigInt3;
        local div5: BigInt3;

        %{
            from starkware.cairo.common.math_utils import as_int
            assert 1 < ids.N_LIMBS <= 12
            p, x, y=0, 6*[0], 6*[0]
            x_refs =[ids.x.b0.a0, ids.x.b0.a1, ids.x.b1.a0, ids.x.b1.a1, ids.x.b2.a0, ids.x.b2.a1]
            y_refs =[ids.y.b0.a0, ids.y.b0.a1, ids.y.b1.a0, ids.y.b1.a1, ids.y.b2.a0, ids.y.b2.a1]


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
                return [*c0, *c1, *c2]

            for i in range(ids.N_LIMBS):
                for k in range(6):
                    x[k]+=as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
                    y[k]+=as_int(getattr(y_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
            x = ((x[0],x[1]),(x[2],x[3]),(x[4],x[5]))
            y = ((y[0],y[1]),(y[2],y[3]),(y[4],y[5]))
            y_inv = inv_e6(y)
            e = mul_e6(x, y_inv)
            e = [split(x) for x in e]
            for i in range(6):
                for l in range(ids.N_LIMBS):
                    setattr(getattr(ids,f"div{i}"),f"d{l}",e[i][l])
        %}

        assert_reduced_felt(div0);
        assert_reduced_felt(div1);
        assert_reduced_felt(div2);
        assert_reduced_felt(div3);
        assert_reduced_felt(div4);
        assert_reduced_felt(div5);

        local b0: E2 = E2(&div0, &div1);
        local b1: E2 = E2(&div2, &div3);
        local b2: E2 = E2(&div4, &div5);

        local div: E6 = E6(&b0, &b1, &b2);

        let check = mul(y, &div);

        assert_E6(x, check);

        return &div;
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
    // Computes :
    // res = - (mul_nr_neg.mul_by_non_residue()) + add_right
    func mulnr_neg_add{range_check_ptr}(mul_nr_neg: E6*, add_right: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let b1a0 = reduce_3(
            UnreducedBigInt3(
                (-mul_nr_neg.b0.a0.d0) + add_right.b1.a0.d0,
                (-mul_nr_neg.b0.a0.d1) + add_right.b1.a0.d1,
                (-mul_nr_neg.b0.a0.d2) + add_right.b1.a0.d2,
            ),
        );
        let b1a1 = reduce_3(
            UnreducedBigInt3(
                (-mul_nr_neg.b0.a1.d0) + add_right.b1.a1.d0,
                (-mul_nr_neg.b0.a1.d1) + add_right.b1.a1.d1,
                (-mul_nr_neg.b0.a1.d2) + add_right.b1.a1.d2,
            ),
        );

        let b2a0 = reduce_3(
            UnreducedBigInt3(
                (-mul_nr_neg.b1.a0.d0) + add_right.b2.a0.d0,
                (-mul_nr_neg.b1.a0.d1) + add_right.b2.a0.d1,
                (-mul_nr_neg.b1.a0.d2) + add_right.b2.a0.d2,
            ),
        );

        let b2a1 = reduce_3(
            UnreducedBigInt3(
                (-mul_nr_neg.b1.a1.d0) + add_right.b2.a1.d0,
                (-mul_nr_neg.b1.a1.d1) + add_right.b2.a1.d1,
                (-mul_nr_neg.b1.a1.d2) + add_right.b2.a1.d2,
            ),
        );

        let b0 = mul_nr_neg.b2;

        tempvar b = BigInt3(b0.a0.d0 * 9, b0.a0.d1 * 9, b0.a0.d2 * 9);

        let b0a0 = reduce_3(
            UnreducedBigInt3(
                -(b.d0 - b0.a1.d0) + add_right.b0.a0.d0,
                -(b.d1 - b0.a1.d1) + add_right.b0.a0.d1,
                -(b.d2 - b0.a1.d2) + add_right.b0.a0.d2,
            ),
        );

        let b0a1 = reduce_3(
            UnreducedBigInt3(
                -((b0.a0.d0 + b0.a1.d0) * 10 - b.d0 - b0.a1.d0) + add_right.b0.a1.d0,
                -((b0.a0.d1 + b0.a1.d1) * 10 - b.d1 - b0.a1.d1) + add_right.b0.a1.d1,
                -((b0.a0.d2 + b0.a1.d2) * 10 - b.d2 - b0.a1.d2) + add_right.b0.a1.d2,
            ),
        );

        local res_b0: E2 = E2(b0a0, b0a1);
        local res_b1: E2 = E2(b1a0, b1a1);
        local res_b2: E2 = E2(b2a0, b2a1);

        local res: E6 = E6(&res_b0, &res_b1, &res_b2);
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

    func add_mul_by_0_plus_one_1{range_check_ptr}(
        add_left: E6*, add_right: E6*, b0_minus_one: E2*, b1: E2*
    ) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local x_b0a0: BigInt3 = BigInt3(
            add_left.b0.a0.d0 + add_right.b0.a0.d0,
            add_left.b0.a0.d1 + add_right.b0.a0.d1,
            add_left.b0.a0.d2 + add_right.b0.a0.d2,
        );
        local x_b0a1: BigInt3 = BigInt3(
            add_left.b0.a1.d0 + add_right.b0.a1.d0,
            add_left.b0.a1.d1 + add_right.b0.a1.d1,
            add_left.b0.a1.d2 + add_right.b0.a1.d2,
        );

        local x_b1a0: BigInt3 = BigInt3(
            add_left.b1.a0.d0 + add_right.b1.a0.d0,
            add_left.b1.a0.d1 + add_right.b1.a0.d1,
            add_left.b1.a0.d2 + add_right.b1.a0.d2,
        );

        local x_b1a1: BigInt3 = BigInt3(
            add_left.b1.a1.d0 + add_right.b1.a1.d0,
            add_left.b1.a1.d1 + add_right.b1.a1.d1,
            add_left.b1.a1.d2 + add_right.b1.a1.d2,
        );

        local x_b2a0: BigInt3 = BigInt3(
            add_left.b2.a0.d0 + add_right.b2.a0.d0,
            add_left.b2.a0.d1 + add_right.b2.a0.d1,
            add_left.b2.a0.d2 + add_right.b2.a0.d2,
        );

        local x_b2a1: BigInt3 = BigInt3(
            add_left.b2.a1.d0 + add_right.b2.a1.d0,
            add_left.b2.a1.d1 + add_right.b2.a1.d1,
            add_left.b2.a1.d2 + add_right.b2.a1.d2,
        );

        local x_b0: E2 = E2(&x_b0a0, &x_b0a1);
        local x_b1: E2 = E2(&x_b1a0, &x_b1a1);
        local x_b2: E2 = E2(&x_b2a0, &x_b2a1);

        local b0_a0: BigInt3 = BigInt3(
            b0_minus_one.a0.d0 + 1, b0_minus_one.a0.d1, b0_minus_one.a0.d2
        );
        local b0: E2 = E2(&b0_a0, b0_minus_one.a1);

        let a = e2.mul_unreduced(&x_b0, &b0);

        let b = e2.mul_unreduced(&x_b1, b1);

        let t0 = e2.add_mul_sub_mulnr_add(&x_b1, &x_b2, b1, b, a);
        let t2 = e2.add_mul_sub_add(&x_b0, &x_b2, &b0, a, b);
        let t1 = e2.add_add_mul_sub_sub(&x_b0, &x_b1, &b0, b1, a, b);

        local res: E6 = E6(t0, t1, t2);
        return &res;
    }
    func add_neg_add{range_check_ptr}(x: E6*, y: E6*, z: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let res_b0_a0 = reduce_3(
            UnreducedBigInt3(
                -(x.b0.a0.d0 + y.b0.a0.d0) + z.b0.a0.d0,
                -(x.b0.a0.d1 + y.b0.a0.d1) + z.b0.a0.d1,
                -(x.b0.a0.d2 + y.b0.a0.d2) + z.b0.a0.d2,
            ),
        );

        let res_b0_a1 = reduce_3(
            UnreducedBigInt3(
                -(x.b0.a1.d0 + y.b0.a1.d0) + z.b0.a1.d0,
                -(x.b0.a1.d1 + y.b0.a1.d1) + z.b0.a1.d1,
                -(x.b0.a1.d2 + y.b0.a1.d2) + z.b0.a1.d2,
            ),
        );

        let res_b1_a0 = reduce_3(
            UnreducedBigInt3(
                -(x.b1.a0.d0 + y.b1.a0.d0) + z.b1.a0.d0,
                -(x.b1.a0.d1 + y.b1.a0.d1) + z.b1.a0.d1,
                -(x.b1.a0.d2 + y.b1.a0.d2) + z.b1.a0.d2,
            ),
        );

        let res_b1_a1 = reduce_3(
            UnreducedBigInt3(
                -(x.b1.a1.d0 + y.b1.a1.d0) + z.b1.a1.d0,
                -(x.b1.a1.d1 + y.b1.a1.d1) + z.b1.a1.d1,
                -(x.b1.a1.d2 + y.b1.a1.d2) + z.b1.a1.d2,
            ),
        );

        let res_b2_a0 = reduce_3(
            UnreducedBigInt3(
                -(x.b2.a0.d0 + y.b2.a0.d0) + z.b2.a0.d0,
                -(x.b2.a0.d1 + y.b2.a0.d1) + z.b2.a0.d1,
                -(x.b2.a0.d2 + y.b2.a0.d2) + z.b2.a0.d2,
            ),
        );

        let res_b2_a1 = reduce_3(
            UnreducedBigInt3(
                -(x.b2.a1.d0 + y.b2.a1.d0) + z.b2.a1.d0,
                -(x.b2.a1.d1 + y.b2.a1.d1) + z.b2.a1.d1,
                -(x.b2.a1.d2 + y.b2.a1.d2) + z.b2.a1.d2,
            ),
        );

        local res_b0: E2 = E2(res_b0_a0, res_b0_a1);
        local res_b1: E2 = E2(res_b1_a0, res_b1_a1);
        local res_b2: E2 = E2(res_b2_a0, res_b2_a1);

        local res: E6 = E6(&res_b0, &res_b1, &res_b2);
        return &res;
    }
    func mul_by_01{range_check_ptr}(x: E6*, b0: E2*, b1: E2*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let a = e2.mul_unreduced(x.b0, b0);
        let b = e2.mul_unreduced(x.b1, b1);
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

    func mul_by_0{range_check_ptr}(x: E6*, b0: E2*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let a = e2.mul(x.b0, b0);

        let tmp = e2.add(x.b0, x.b1);
        let t1 = e2.mul(b0, tmp);
        let t1 = e2.sub(t1, a);

        let tmp = e2.add(x.b0, x.b2);
        let t2 = e2.mul(b0, tmp);
        let t2 = e2.sub(t2, a);

        local res: E6 = E6(a, t1, t2);
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
    // FrobeniusTorus raises a compressed elements x ∈ E6 to the modulus p
    // and returns x^p / v^((p-1)/2)
    func frobenius_torus{range_check_ptr}(x: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        let t0 = e2.conjugate(x.b0);
        let t1 = e2.conjugate(x.b1);
        let t2 = e2.conjugate(x.b2);

        let t1 = e2.mul_by_non_residue_1_power_2(t1);
        let t2 = e2.mul_by_non_residue_1_power_4(t2);

        local v0_a0: BigInt3 = BigInt3(
            13419658832840509084547896, 24313674309344809517854541, 3101566081603796213633544
        );
        local v0_a1: BigInt3 = BigInt3(
            28091364253695942324804508, 36789956481330324667102661, 955892070833573926637211
        );
        local v0: E2 = E2(&v0_a0, &v0_a1);

        local res_tmp: E6 = E6(t0, t1, t2);
        let res = mul_by_0(&res_tmp, &v0);

        return res;
    }
    // FrobeniusSquareTorus raises a compressed elements x ∈ E6 to the square modulus p^2
    // and returns x^(p^2) / v^((p^2-1)/2)
    func frobenius_square_torus{range_check_ptr}(x: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local v0: BigInt3 = BigInt3(33076918435755799917625343, 57095833223235399068927667, 368166);
        let t0 = e2.mul_by_element(&v0, x.b0);
        let t1 = e2.mul_by_non_residue_2_power_2(x.b1);
        let t1 = e2.mul_by_element(&v0, t1);
        let t2 = e2.mul_by_non_residue_2_power_4(x.b2);
        let t2 = e2.mul_by_element(&v0, t2);

        local res: E6 = E6(t0, t1, t2);
        return &res;
    }

    // FrobeniusCubeTorus raises a compressed elements y ∈ E6 to the cube modulus p^3
    // and returns y^(p^3) / v^((p^3-1)/2)

    func frobenius_cube_torus{range_check_ptr}(x: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        let t0 = e2.conjugate(x.b0);
        let t1 = e2.conjugate(x.b1);
        let t2 = e2.conjugate(x.b2);

        let t1 = e2.mul_by_non_residue_3_power_2(t1);
        let t2 = e2.mul_by_non_residue_3_power_4(t2);

        local v0_a0: BigInt3 = BigInt3(
            33813367533073246051653320, 24966032303833368470752936, 1702353899606858027271790
        );

        local v0_a1: BigInt3 = BigInt3(
            24452053258059047520747777, 71991699407877657584963167, 50757036183365933362366
        );

        local v0: E2 = E2(&v0_a0, &v0_a1);

        local res_tmp: E6 = E6(t0, t1, t2);
        let res = mul_by_0(&res_tmp, &v0);

        return res;
    }

    func mul_torus{range_check_ptr}(y1: E6*, y2: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let num = mul_plus_one_b1(y1, y2);
        let den = add(y1, y2);
        let res = div(num, den);

        return res;
    }

    func expt_torus{range_check_ptr}(x: E6*) -> E6* {
        alloc_locals;
        let t3 = square_torus(x);
        let t5 = square_torus(t3);
        let result = square_torus(t5);
        let t0 = square_torus(result);
        let t2 = mul_torus(x, t0);
        let t0 = mul_torus(t3, t2);
        let t1 = mul_torus(x, t0);
        let t4 = mul_torus(result, t2);
        let t6 = square_torus(t2);
        let t1 = mul_torus(t0, t1);
        let t0 = mul_torus(t3, t1);
        let t6 = n_square_torus(t6, 6);
        let t5 = mul_torus(t5, t6);
        let t5 = mul_torus(t4, t5);
        let t5 = n_square_torus(t5, 7);
        let t4 = mul_torus(t4, t5);
        let t4 = n_square_torus(t4, 8);
        let t4 = mul_torus(t0, t4);
        let t3 = mul_torus(t3, t4);
        let t3 = n_square_torus(t3, 6);
        let t2 = mul_torus(t2, t3);
        let t2 = n_square_torus(t2, 8);
        let t2 = mul_torus(t0, t2);
        let t2 = n_square_torus(t2, 6);
        let t2 = mul_torus(t0, t2);
        let t2 = n_square_torus(t2, 10);
        let t1 = mul_torus(t1, t2);
        let t1 = n_square_torus(t1, 6);
        let t0 = mul_torus(t0, t1);
        let z = mul_torus(result, t0);
        return z;
    }

    func inverse_torus{range_check_ptr}(x: E6*) -> E6* {
        return neg(x);
    }

    func double_sub_mul{range_check_ptr}(x: E6*, y: E6*) -> E6* {
        return x;
    }

    func square_torus{range_check_ptr}(x: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local sq0: BigInt3;
        local sq1: BigInt3;
        local sq2: BigInt3;
        local sq3: BigInt3;
        local sq4: BigInt3;
        local sq5: BigInt3;

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

            # E6 Tower:
            def mul_by_non_residue_e6(x:((int,int),(int,int),(int,int))):
                return mul_by_non_residue_e2(x[2]), x[0], x[1]
            def sub_e6(x:((int,int), (int,int), (int,int)),y:((int,int), (int,int), (int,int))):
                return (sub_e2(x[0], y[0]), sub_e2(x[1], y[1]), sub_e2(x[2], y[2]))
            def add_e6(x:((int,int), (int,int), (int,int)),y:((int,int), (int,int), (int,int))):
                return (add_e2(x[0], y[0]), add_e2(x[1], y[1]), add_e2(x[2], y[2]))
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

            for i in range(ids.N_LIMBS):
                for k in range(6):
                    c0[k]+=as_int(getattr(c0_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
            c0 = ((c0[0],c0[1]),(c0[2],c0[3]),(c0[4],c0[5]))

            true_v = ((0,0),(1,0),(0,0))

            one_over_2_e6 = inv_e6(((2,0),(0,0),(0,0)))
            z = mul_e6(add_e6(c0, mul_e6(true_v, inv_e6(c0))), one_over_2_e6)


            e = [split(z[0][0]), split(z[0][1]), split(z[1][0]), split(z[1][1]), split(z[2][0]), split(z[2][1])]

            for i in range(6):
                for l in range(ids.N_LIMBS):
                    setattr(getattr(ids,f"sq{i}"),f"d{l}",e[i][l])
        %}
        assert_reduced_felt(sq0);
        assert_reduced_felt(sq1);
        assert_reduced_felt(sq2);
        assert_reduced_felt(sq3);
        assert_reduced_felt(sq4);
        assert_reduced_felt(sq5);

        local b0: E2 = E2(&sq0, &sq1);
        local b1: E2 = E2(&sq2, &sq3);
        local b2: E2 = E2(&sq4, &sq5);

        local sq: E6 = E6(&b0, &b1, &b2);

        // let v = double(&sq);
        // let v = sub(v, x);
        local v_b0a0: BigInt3 = BigInt3(
            2 * sq0.d0 - x.b0.a0.d0, 2 * sq0.d1 - x.b0.a0.d1, 2 * sq0.d2 - x.b0.a0.d2
        );
        local v_b0a1: BigInt3 = BigInt3(
            2 * sq1.d0 - x.b0.a1.d0, 2 * sq1.d1 - x.b0.a1.d1, 2 * sq1.d2 - x.b0.a1.d2
        );
        local v_b1a0: BigInt3 = BigInt3(
            2 * sq2.d0 - x.b1.a0.d0, 2 * sq2.d1 - x.b1.a0.d1, 2 * sq2.d2 - x.b1.a0.d2
        );
        local v_b1a1: BigInt3 = BigInt3(
            2 * sq3.d0 - x.b1.a1.d0, 2 * sq3.d1 - x.b1.a1.d1, 2 * sq3.d2 - x.b1.a1.d2
        );
        local v_b2a0: BigInt3 = BigInt3(
            2 * sq4.d0 - x.b2.a0.d0, 2 * sq4.d1 - x.b2.a0.d1, 2 * sq4.d2 - x.b2.a0.d2
        );
        local v_b2a1: BigInt3 = BigInt3(
            2 * sq5.d0 - x.b2.a1.d0, 2 * sq5.d1 - x.b2.a1.d1, 2 * sq5.d2 - x.b2.a1.d2
        );
        local v_b0: E2 = E2(&v_b0a0, &v_b0a1);
        local v_b1: E2 = E2(&v_b1a0, &v_b1a1);
        local v_b2: E2 = E2(&v_b2a0, &v_b2a1);
        local v_tmp: E6 = E6(&v_b0, &v_b1, &v_b2);
        let v = mul(&v_tmp, x);

        assert v.b0.a0.d0 = 0;
        assert v.b0.a0.d1 = 0;
        assert v.b0.a0.d2 = 0;
        assert v.b0.a1.d0 = 0;
        assert v.b0.a1.d1 = 0;
        assert v.b0.a1.d2 = 0;

        assert v.b1.a0.d0 = 1;
        assert v.b1.a0.d1 = 0;
        assert v.b1.a0.d2 = 0;
        assert v.b1.a1.d0 = 0;
        assert v.b1.a1.d1 = 0;
        assert v.b1.a1.d2 = 0;

        assert v.b2.a0.d0 = 0;
        assert v.b2.a0.d1 = 0;
        assert v.b2.a0.d2 = 0;
        assert v.b2.a1.d0 = 0;
        assert v.b2.a1.d1 = 0;
        assert v.b2.a1.d2 = 0;

        return &sq;
    }

    func n_square_torus{range_check_ptr}(x: E6*, n: felt) -> E6* {
        if (n == 0) {
            return x;
        } else {
            let res = square_torus(x);
            return n_square_torus(res, n - 1);
        }
    }
}
