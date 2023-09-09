from src.bn254.towers.e6 import e6, E6
from src.bn254.towers.e2 import e2, E2
from src.bn254.fq import (
    fq_bigint3,
    BigInt3,
    felt_to_bigint3,
    UnreducedBigInt5,
    UnreducedBigInt3,
    bigint_sqr,
    bigint_mul,
    verify_zero5,
    reduce_5,
    reduce_3,
    assert_reduced_felt,
)
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.registers import get_fp_and_pc
from src.bn254.curve import N_LIMBS, DEGREE, BASE, P0, P1, P2, NON_RESIDUE_E2_a0, NON_RESIDUE_E2_a1
from starkware.cairo.common.builtin_poseidon.poseidon import poseidon_hash, poseidon_hash_many
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin
from starkware.cairo.common.poseidon_state import PoseidonBuiltinState

struct E12 {
    c0: E6*,
    c1: E6*,
}

struct E12full {
    w0: BigInt3,
    w1: BigInt3,
    w2: BigInt3,
    w3: BigInt3,
    w4: BigInt3,
    w5: BigInt3,
    w6: BigInt3,
    w7: BigInt3,
    w8: BigInt3,
    w9: BigInt3,
    w10: BigInt3,
    w11: BigInt3,
}

struct E11full {
    w0: BigInt3,
    w1: BigInt3,
    w2: BigInt3,
    w3: BigInt3,
    w4: BigInt3,
    w5: BigInt3,
    w6: BigInt3,
    w7: BigInt3,
    w8: BigInt3,
    w9: BigInt3,
    w10: BigInt3,
}

struct VerifyPolySquare {
    x: E12full*,
    q: E11full*,
    r: E12full*,
}

func square_trick{range_check_ptr, verify_square_array: VerifyPolySquare**, n_squares: felt}(
    x: E12*
) -> E12* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local r_w: E12full;
    local q_w: E11full;
    %{
        from tools.py.polynomial import Polynomial
        from tools.py.field import BaseFieldElement, BaseField
        from tools.py.extension_trick import w_to_gnark, gnark_to_w, flatten, pack_e12, mul_e12_gnark
        #from src.bn254.hints import split
        from starkware.cairo.common.cairo_secp.secp_utils import split
        p=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
        field = BaseField(p)
        x_gnark=12*[0]
        x_refs=[ids.x.c0.b0.a0, ids.x.c0.b0.a1, ids.x.c0.b1.a0, ids.x.c0.b1.a1, ids.x.c0.b2.a0, ids.x.c0.b2.a1, ids.x.c1.b0.a0, ids.x.c1.b0.a1, ids.x.c1.b1.a0, ids.x.c1.b1.a1, ids.x.c1.b2.a0, ids.x.c1.b2.a1]
        for i in range(ids.N_LIMBS):
            for k in range(12):
                x_gnark[k]+=as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
        x=gnark_to_w(x_gnark)
        x_poly=Polynomial([BaseFieldElement(x[i], field) for i in range(12)])
        z_poly=x_poly*x_poly
        #print(f"Z_Poly: {z_poly.get_coeffs()}")
        coeffs = [
        BaseFieldElement(82, field),
        field.zero(),
        field.zero(),
        field.zero(),
        field.zero(),
        field.zero(),
        BaseFieldElement(-18 % p, field),
        field.zero(),
        field.zero(),
        field.zero(),
        field.zero(),
        field.zero(),
        field.one(),]
        unreducible_poly=Polynomial(coeffs)
        z_polyr=z_poly % unreducible_poly
        z_polyq=z_poly // unreducible_poly
        z_polyr_coeffs = z_polyr.get_coeffs()
        z_polyq_coeffs = z_polyq.get_coeffs()
        assert len(z_polyq_coeffs)<=11
        # extend z_polyq with 0 to make it len 11:
        z_polyq_coeffs = z_polyq_coeffs + (11-len(z_polyq_coeffs))*[0]
        expected = flatten(mul_e12_gnark(pack_e12(x_gnark), pack_e12(x_gnark)))
        assert expected==w_to_gnark(z_polyr_coeffs)
        #print(f"Z_PolyR: {z_polyr_coeffs}")
        #print(f"Z_PolyR_to_gnark: {w_to_gnark(z_polyr_coeffs)}")
        for i in range(12):
            for k in range(3):
                rsetattr(ids.r_w, 'w'+str(i)+'.d'+str(k), split(z_polyr_coeffs[i]%p)[k])
        for i in range(11):
            for k in range(3):
                rsetattr(ids.q_w, 'w'+str(i)+'.d'+str(k), split(z_polyq_coeffs[i]%p)[k])
    %}
    let (local x_w: E12full*) = gnark_to_w(x);
    assert_reduced_felt(r_w.w0);
    assert_reduced_felt(r_w.w1);
    assert_reduced_felt(r_w.w2);
    assert_reduced_felt(r_w.w3);
    assert_reduced_felt(r_w.w4);
    assert_reduced_felt(r_w.w5);
    assert_reduced_felt(r_w.w6);
    assert_reduced_felt(r_w.w7);
    assert_reduced_felt(r_w.w8);
    assert_reduced_felt(r_w.w9);
    assert_reduced_felt(r_w.w10);
    assert_reduced_felt(r_w.w11);
    assert_reduced_felt(q_w.w0);
    assert_reduced_felt(q_w.w1);
    assert_reduced_felt(q_w.w2);
    assert_reduced_felt(q_w.w3);
    assert_reduced_felt(q_w.w4);
    assert_reduced_felt(q_w.w5);
    assert_reduced_felt(q_w.w6);
    assert_reduced_felt(q_w.w7);
    assert_reduced_felt(q_w.w8);
    assert_reduced_felt(q_w.w9);
    assert_reduced_felt(q_w.w10);

    local to_check_later: VerifyPolySquare = VerifyPolySquare(x=x_w, q=&q_w, r=&r_w);

    assert verify_square_array[n_squares] = &to_check_later;

    let n_squares = n_squares + 1;

    let res = w_to_gnark_reduced(r_w);
    return res;
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
        // let a = e6.add(x.c0, x.c1);
        // let b = e6.add(y.c0, y.c1);
        // let a = e6.mul(a, b);
        let b = e6.mul(x.c0, y.c0);
        let c = e6.mul(x.c1, y.c1);
        // let zC1 = e6.sub(a, b);
        // let zC1 = e6.sub(zC1, c);
        let zC1 = e6.add_add_mul_sub_sub(x.c0, x.c1, y.c0, y.c1, b, c);
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

        let c3 = e6.mulnr_neg_add_unreduced(x.c1, x.c0);

        let c2t = e6.mul(x.c0, x.c1);
        let c2 = e6.mul_by_non_residue(c2t);

        // let c0 = e6.sub(x.c0, x.c1);
        // let c0 = e6.mul(c0, c3);
        // let c0 = e6.add(c0, c2t);
        // let c0 = e6.add(c0, c2);

        let c0 = e6.sub_mul_add_add(x.c0, x.c1, c3, c2t, c2);

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

        // let tmp = e2.add(c3, c4);
        // let x34 = e2.add(d3, d4);
        // let x34 = e2.mul(x34, tmp);
        // let x34 = e2.sub(x34, x3);
        // let x34 = e2.sub(x34, x4);

        let x34 = e2.add_add_mul_sub3_sub3(c3, c4, d3, d4, x3, x4);

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
        // let a = e6.add_add_mul(z.c0, z.c1, x.c0, x.c1);
        let b = e6.mul(z.c0, x.c0);
        let c = e6.mul_by_01(z.c1, x.c1.b0, x.c1.b1);
        // let z1 = e6.sub(a, b);
        // let z1 = e6.sub(z1, c);

        let z1 = e6.add_add_mul_sub_sub(z.c0, z.c1, x.c0, x.c1, b, c);
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

func verify_square_trick{
    range_check_ptr, poseidon_ptr: PoseidonBuiltin*, verify_square_array: VerifyPolySquare**
}(n_squares: felt, z: BigInt3*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    let z_pow1_11: BigInt3** = get_powers_of_z(&z);
    let p_of_z: BigInt3* = eval_unreduced_poly(z_pow1_11);
    local zero_e12full: E12full = E12full(
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
    );

    local zero_bigint5: UnreducedBigInt5 = UnreducedBigInt5(0, 0, 0, 0, 0);
    local equation_init: PolyAcc = PolyAcc(xy=&zero_bigint5, qP=&zero_bigint5, r=&zero_e12full);
    %{ print(f"accumulating {ids.n_squares} squares equations") %}
    let equation_acc = accumulate_polynomial_equation(
        n_squares - 1, &equation_init, z_pow1_11, p_of_z
    );

    // let x_of_z: BigInt3* = eval_E12(equation_acc.x, z_pow1_11);
    // let q_of_z = eval_E11(equation_acc.q, z_pow1_11);
    let r_of_z = eval_E12_unreduced(equation_acc.r, z_pow1_11);
    // let (left) = bigint_sqr([x_of_z]);
    // let (right) = bigint_mul([q_of_z], [p_of_z]);

    // Check Σ(x(rnd) * y(rnd)) === Σ(q(rnd) * P(rnd)) + Σ(r(rnd)):

    verify_zero5(
        UnreducedBigInt5(
            d0=equation_acc.xy.d0 - equation_acc.qP.d0 - r_of_z.d0,
            d1=equation_acc.xy.d1 - equation_acc.qP.d1 - r_of_z.d1,
            d2=equation_acc.xy.d2 - equation_acc.qP.d2 - r_of_z.d2,
            d3=equation_acc.xy.d3 - equation_acc.qP.d3 - r_of_z.d3,
            d4=equation_acc.xy.d4 - equation_acc.qP.d4 - r_of_z.d4,
        ),
    );
    return ();
}

struct PolyAcc {
    xy: UnreducedBigInt5*,
    qP: UnreducedBigInt5*,
    r: E12full*,  // Unreduced
}

// Accmulate (Σ(x(z) * y(z)), Σ(q(z) * P(z)), Σ(r(z)))
// Since Σ(x*y) != Σ(x) * Σ(y), we need to accumulate the polynomials evaluated at z and not the polynomials themselves.
// For r, we can accumulate the polynomial itself.
func accumulate_polynomial_equation{range_check_ptr, verify_square_array: VerifyPolySquare**}(
    index: felt, equation_acc: PolyAcc*, z_pow1_11: BigInt3**, p_of_z: BigInt3*
) -> PolyAcc* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    if (index == -1) {
        return equation_acc;
    } else {
        let x_of_z = eval_E12(verify_square_array[index].x, z_pow1_11);
        // let (xy_acc) = bigint_sqr([x_of_z]);
        // left_acc = left_acc + x_of_z ** 2
        local left_acc: UnreducedBigInt5 = UnreducedBigInt5(
            d0=equation_acc.xy.d0 + x_of_z.d0 * x_of_z.d0,
            d1=equation_acc.xy.d1 + 2 * x_of_z.d0 * x_of_z.d1,
            d2=equation_acc.xy.d2 + 2 * x_of_z.d0 * x_of_z.d2 + x_of_z.d1 * x_of_z.d1,
            d3=equation_acc.xy.d3 + 2 * x_of_z.d1 * x_of_z.d2,
            d4=equation_acc.xy.d4 + x_of_z.d2 * x_of_z.d2,
        );
        let q_of_z_unreduced = eval_E11(verify_square_array[index].q, z_pow1_11);
        let (qP_acc) = bigint_mul([q_of_z_unreduced], [p_of_z]);
        local right_acc: UnreducedBigInt5 = UnreducedBigInt5(
            d0=equation_acc.qP.d0 + qP_acc.d0,
            d1=equation_acc.qP.d1 + qP_acc.d1,
            d2=equation_acc.qP.d2 + qP_acc.d2,
            d3=equation_acc.qP.d3 + qP_acc.d3,
            d4=equation_acc.qP.d4 + qP_acc.d4,
        );

        local r_acc: E12full = E12full(
            BigInt3(
                verify_square_array[index].r.w0.d0 + equation_acc.r.w0.d0,
                verify_square_array[index].r.w0.d1 + equation_acc.r.w0.d1,
                verify_square_array[index].r.w0.d2 + equation_acc.r.w0.d2,
            ),
            BigInt3(
                verify_square_array[index].r.w1.d0 + equation_acc.r.w1.d0,
                verify_square_array[index].r.w1.d1 + equation_acc.r.w1.d1,
                verify_square_array[index].r.w1.d2 + equation_acc.r.w1.d2,
            ),
            BigInt3(
                verify_square_array[index].r.w2.d0 + equation_acc.r.w2.d0,
                verify_square_array[index].r.w2.d1 + equation_acc.r.w2.d1,
                verify_square_array[index].r.w2.d2 + equation_acc.r.w2.d2,
            ),
            BigInt3(
                verify_square_array[index].r.w3.d0 + equation_acc.r.w3.d0,
                verify_square_array[index].r.w3.d1 + equation_acc.r.w3.d1,
                verify_square_array[index].r.w3.d2 + equation_acc.r.w3.d2,
            ),
            BigInt3(
                verify_square_array[index].r.w4.d0 + equation_acc.r.w4.d0,
                verify_square_array[index].r.w4.d1 + equation_acc.r.w4.d1,
                verify_square_array[index].r.w4.d2 + equation_acc.r.w4.d2,
            ),
            BigInt3(
                verify_square_array[index].r.w5.d0 + equation_acc.r.w5.d0,
                verify_square_array[index].r.w5.d1 + equation_acc.r.w5.d1,
                verify_square_array[index].r.w5.d2 + equation_acc.r.w5.d2,
            ),
            BigInt3(
                verify_square_array[index].r.w6.d0 + equation_acc.r.w6.d0,
                verify_square_array[index].r.w6.d1 + equation_acc.r.w6.d1,
                verify_square_array[index].r.w6.d2 + equation_acc.r.w6.d2,
            ),
            BigInt3(
                verify_square_array[index].r.w7.d0 + equation_acc.r.w7.d0,
                verify_square_array[index].r.w7.d1 + equation_acc.r.w7.d1,
                verify_square_array[index].r.w7.d2 + equation_acc.r.w7.d2,
            ),
            BigInt3(
                verify_square_array[index].r.w8.d0 + equation_acc.r.w8.d0,
                verify_square_array[index].r.w8.d1 + equation_acc.r.w8.d1,
                verify_square_array[index].r.w8.d2 + equation_acc.r.w8.d2,
            ),
            BigInt3(
                verify_square_array[index].r.w9.d0 + equation_acc.r.w9.d0,
                verify_square_array[index].r.w9.d1 + equation_acc.r.w9.d1,
                verify_square_array[index].r.w9.d2 + equation_acc.r.w9.d2,
            ),
            BigInt3(
                verify_square_array[index].r.w10.d0 + equation_acc.r.w10.d0,
                verify_square_array[index].r.w10.d1 + equation_acc.r.w10.d1,
                verify_square_array[index].r.w10.d2 + equation_acc.r.w10.d2,
            ),
            BigInt3(
                verify_square_array[index].r.w11.d0 + equation_acc.r.w11.d0,
                verify_square_array[index].r.w11.d1 + equation_acc.r.w11.d1,
                verify_square_array[index].r.w11.d2 + equation_acc.r.w11.d2,
            ),
        );
        local equation_acc_new: PolyAcc = PolyAcc(xy=&left_acc, qP=&right_acc, r=&r_acc);
        return accumulate_polynomial_equation(index - 1, &equation_acc_new, z_pow1_11, p_of_z);
    }
}

func eval_unreduced_poly{range_check_ptr}(powers: BigInt3**) -> BigInt3* {
    alloc_locals;
    local w6: BigInt3 = BigInt3(
        60193888514187762220203317, 27625954992973055882053025, 3656382694611191768777988
    );  // -18 % p
    let (e6) = bigint_mul(w6, [powers[5]]);

    let w12 = powers[11];

    let res = reduce_5(
        UnreducedBigInt5(
            d0=82 + e6.d0 + w12.d0, d1=e6.d1 + w12.d1, d2=e6.d2 + w12.d2, d3=e6.d3, d4=e6.d4
        ),
    );
    return res;
}
func eval_E11{range_check_ptr}(e12: E11full*, powers: BigInt3**) -> BigInt3* {
    alloc_locals;
    let e0 = e12.w0;
    let (e1) = bigint_mul(e12.w1, [powers[0]]);
    let (e2) = bigint_mul(e12.w2, [powers[1]]);
    let (e3) = bigint_mul(e12.w3, [powers[2]]);
    let (e4) = bigint_mul(e12.w4, [powers[3]]);
    let (e5) = bigint_mul(e12.w5, [powers[4]]);
    let (e6) = bigint_mul(e12.w6, [powers[5]]);
    let (e7) = bigint_mul(e12.w7, [powers[6]]);
    let (e8) = bigint_mul(e12.w8, [powers[7]]);
    let (e9) = bigint_mul(e12.w9, [powers[8]]);
    let (e10) = bigint_mul(e12.w10, [powers[9]]);
    let res = reduce_5(
        UnreducedBigInt5(
            d0=e0.d0 + e1.d0 + e2.d0 + e3.d0 + e4.d0 + e5.d0 + e6.d0 + e7.d0 + e8.d0 + e9.d0 +
            e10.d0,
            d1=e0.d1 + e1.d1 + e2.d1 + e3.d1 + e4.d1 + e5.d1 + e6.d1 + e7.d1 + e8.d1 + e9.d1 +
            e10.d1,
            d2=e0.d2 + e1.d2 + e2.d2 + e3.d2 + e4.d2 + e5.d2 + e6.d2 + e7.d2 + e8.d2 + e9.d2 +
            e10.d2,
            d3=e1.d3 + e2.d3 + e3.d3 + e4.d3 + e5.d3 + e6.d3 + e7.d3 + e8.d3 + e9.d3 + e10.d3,
            d4=e1.d4 + e2.d4 + e3.d4 + e4.d4 + e5.d4 + e6.d4 + e7.d4 + e8.d4 + e9.d4 + e10.d4,
        ),
    );
    return res;
}

func eval_E11_unreduced{range_check_ptr}(e12: E11full*, powers: BigInt3**) -> UnreducedBigInt5 {
    alloc_locals;
    let e0 = e12.w0;
    let (e1) = bigint_mul(e12.w1, [powers[0]]);
    let (e2) = bigint_mul(e12.w2, [powers[1]]);
    let (e3) = bigint_mul(e12.w3, [powers[2]]);
    let (e4) = bigint_mul(e12.w4, [powers[3]]);
    let (e5) = bigint_mul(e12.w5, [powers[4]]);
    let (e6) = bigint_mul(e12.w6, [powers[5]]);
    let (e7) = bigint_mul(e12.w7, [powers[6]]);
    let (e8) = bigint_mul(e12.w8, [powers[7]]);
    let (e9) = bigint_mul(e12.w9, [powers[8]]);
    let (e10) = bigint_mul(e12.w10, [powers[9]]);
    let res = UnreducedBigInt5(
        d0=e0.d0 + e1.d0 + e2.d0 + e3.d0 + e4.d0 + e5.d0 + e6.d0 + e7.d0 + e8.d0 + e9.d0 + e10.d0,
        d1=e0.d1 + e1.d1 + e2.d1 + e3.d1 + e4.d1 + e5.d1 + e6.d1 + e7.d1 + e8.d1 + e9.d1 + e10.d1,
        d2=e0.d2 + e1.d2 + e2.d2 + e3.d2 + e4.d2 + e5.d2 + e6.d2 + e7.d2 + e8.d2 + e9.d2 + e10.d2,
        d3=e1.d3 + e2.d3 + e3.d3 + e4.d3 + e5.d3 + e6.d3 + e7.d3 + e8.d3 + e9.d3 + e10.d3,
        d4=e1.d4 + e2.d4 + e3.d4 + e4.d4 + e5.d4 + e6.d4 + e7.d4 + e8.d4 + e9.d4 + e10.d4,
    );
    return res;
}

func eval_E12{range_check_ptr}(e12: E12full*, powers: BigInt3**) -> BigInt3* {
    alloc_locals;
    let e0 = e12.w0;
    let (e1) = bigint_mul(e12.w1, [powers[0]]);
    let (e2) = bigint_mul(e12.w2, [powers[1]]);
    let (e3) = bigint_mul(e12.w3, [powers[2]]);
    let (e4) = bigint_mul(e12.w4, [powers[3]]);
    let (e5) = bigint_mul(e12.w5, [powers[4]]);
    let (e6) = bigint_mul(e12.w6, [powers[5]]);
    let (e7) = bigint_mul(e12.w7, [powers[6]]);
    let (e8) = bigint_mul(e12.w8, [powers[7]]);
    let (e9) = bigint_mul(e12.w9, [powers[8]]);
    let (e10) = bigint_mul(e12.w10, [powers[9]]);
    let (e11) = bigint_mul(e12.w11, [powers[10]]);
    let res = reduce_5(
        UnreducedBigInt5(
            d0=e0.d0 + e1.d0 + e2.d0 + e3.d0 + e4.d0 + e5.d0 + e6.d0 + e7.d0 + e8.d0 + e9.d0 +
            e10.d0 + e11.d0,
            d1=e0.d1 + e1.d1 + e2.d1 + e3.d1 + e4.d1 + e5.d1 + e6.d1 + e7.d1 + e8.d1 + e9.d1 +
            e10.d1 + e11.d1,
            d2=e0.d2 + e1.d2 + e2.d2 + e3.d2 + e4.d2 + e5.d2 + e6.d2 + e7.d2 + e8.d2 + e9.d2 +
            e10.d2 + e11.d2,
            d3=e1.d3 + e2.d3 + e3.d3 + e4.d3 + e5.d3 + e6.d3 + e7.d3 + e8.d3 + e9.d3 + e10.d3 +
            e11.d3,
            d4=e1.d4 + e2.d4 + e3.d4 + e4.d4 + e5.d4 + e6.d4 + e7.d4 + e8.d4 + e9.d4 + e10.d4 +
            e11.d4,
        ),
    );
    return res;
}

func eval_E12_unreduced{range_check_ptr}(e12: E12full*, powers: BigInt3**) -> UnreducedBigInt5 {
    alloc_locals;
    let e0 = e12.w0;
    let (e1) = bigint_mul(e12.w1, [powers[0]]);
    let (e2) = bigint_mul(e12.w2, [powers[1]]);
    let (e3) = bigint_mul(e12.w3, [powers[2]]);
    let (e4) = bigint_mul(e12.w4, [powers[3]]);
    let (e5) = bigint_mul(e12.w5, [powers[4]]);
    let (e6) = bigint_mul(e12.w6, [powers[5]]);
    let (e7) = bigint_mul(e12.w7, [powers[6]]);
    let (e8) = bigint_mul(e12.w8, [powers[7]]);
    let (e9) = bigint_mul(e12.w9, [powers[8]]);
    let (e10) = bigint_mul(e12.w10, [powers[9]]);
    let (e11) = bigint_mul(e12.w11, [powers[10]]);
    let res = UnreducedBigInt5(
        d0=e0.d0 + e1.d0 + e2.d0 + e3.d0 + e4.d0 + e5.d0 + e6.d0 + e7.d0 + e8.d0 + e9.d0 + e10.d0 +
        e11.d0,
        d1=e0.d1 + e1.d1 + e2.d1 + e3.d1 + e4.d1 + e5.d1 + e6.d1 + e7.d1 + e8.d1 + e9.d1 + e10.d1 +
        e11.d1,
        d2=e0.d2 + e1.d2 + e2.d2 + e3.d2 + e4.d2 + e5.d2 + e6.d2 + e7.d2 + e8.d2 + e9.d2 + e10.d2 +
        e11.d2,
        d3=e1.d3 + e2.d3 + e3.d3 + e4.d3 + e5.d3 + e6.d3 + e7.d3 + e8.d3 + e9.d3 + e10.d3 + e11.d3,
        d4=e1.d4 + e2.d4 + e3.d4 + e4.d4 + e5.d4 + e6.d4 + e7.d4 + e8.d4 + e9.d4 + e10.d4 + e11.d4,
    );
    return res;
}

func get_powers_of_z{range_check_ptr}(z: BigInt3*) -> BigInt3** {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (z_powers: BigInt3**) = alloc();
    let z_2 = fq_bigint3.mul(z, z);
    let z_3 = fq_bigint3.mul(z_2, z);
    let z_4 = fq_bigint3.mul(z_3, z);
    let z_5 = fq_bigint3.mul(z_4, z);
    let z_6 = fq_bigint3.mul(z_5, z);
    let z_7 = fq_bigint3.mul(z_6, z);
    let z_8 = fq_bigint3.mul(z_7, z);
    let z_9 = fq_bigint3.mul(z_8, z);
    let z_10 = fq_bigint3.mul(z_9, z);
    let z_11 = fq_bigint3.mul(z_10, z);
    let z_12 = fq_bigint3.mul(z_11, z);
    assert z_powers[0] = z;
    assert z_powers[1] = z_2;
    assert z_powers[2] = z_3;
    assert z_powers[3] = z_4;
    assert z_powers[4] = z_5;
    assert z_powers[5] = z_6;
    assert z_powers[6] = z_7;
    assert z_powers[7] = z_8;
    assert z_powers[8] = z_9;
    assert z_powers[9] = z_10;
    assert z_powers[10] = z_11;
    assert z_powers[11] = z_12;
    return z_powers;
}
func get_random_point_from_square_ops{
    poseidon_ptr: PoseidonBuiltin*, verify_square_array: VerifyPolySquare**
}(index: felt, res: felt) -> felt {
    alloc_locals;
    if (index == 0) {
        let random_point_0 = poseidon_hash_e12(verify_square_array[index].x);
        let random_point_1 = poseidon_hash_e12(verify_square_array[index].r);
        let random_point_2 = poseidon_hash_e11(verify_square_array[index].q);
        let random_point_I: felt = poseidon_hash(random_point_0, random_point_1);
        let random_point: felt = poseidon_hash(random_point_I, random_point_2);
        let random_point: felt = poseidon_hash(random_point, res);
        return random_point;
    } else {
        let random_point_0 = poseidon_hash_e12(verify_square_array[index].x);
        let random_point_1 = poseidon_hash_e12(verify_square_array[index].r);
        let random_point_2 = poseidon_hash_e11(verify_square_array[index].q);
        let random_point_I: felt = poseidon_hash(random_point_0, random_point_1);
        let random_point: felt = poseidon_hash(random_point_I, random_point_2);
        let random_point: felt = poseidon_hash(random_point, res);
        return get_random_point_from_square_ops(index=index - 1, res=random_point);
    }
}

func poseidon_hash_e12{poseidon_ptr: PoseidonBuiltin*}(e12: E12full*) -> felt {
    assert poseidon_ptr.input = PoseidonBuiltinState(
        s0=e12.w0.d0 + 2 ** 128 * e12.w0.d1, s1=e12.w0.d2 + 2 ** 128 * e12.w1.d0, s2=2
    );
    assert poseidon_ptr[1].input = PoseidonBuiltinState(
        s0=e12.w1.d1 + 2 ** 128 * e12.w1.d2, s1=poseidon_ptr[0].output.s0, s2=2
    );
    assert poseidon_ptr[2].input = PoseidonBuiltinState(
        s0=e12.w2.d0 + 2 ** 128 * e12.w2.d1, s1=poseidon_ptr[1].output.s0, s2=2
    );
    assert poseidon_ptr[3].input = PoseidonBuiltinState(
        s0=e12.w2.d2 + 2 ** 128 * e12.w3.d0, s1=poseidon_ptr[2].output.s0, s2=2
    );
    assert poseidon_ptr[4].input = PoseidonBuiltinState(
        s0=e12.w3.d1 + 2 ** 128 * e12.w3.d2, s1=poseidon_ptr[3].output.s0, s2=2
    );
    assert poseidon_ptr[5].input = PoseidonBuiltinState(
        s0=e12.w4.d0 + 2 ** 128 * e12.w4.d1, s1=poseidon_ptr[4].output.s0, s2=2
    );
    assert poseidon_ptr[6].input = PoseidonBuiltinState(
        s0=e12.w4.d2 + 2 ** 128 * e12.w5.d0, s1=poseidon_ptr[5].output.s0, s2=2
    );
    assert poseidon_ptr[7].input = PoseidonBuiltinState(
        s0=e12.w5.d1 + 2 ** 128 * e12.w5.d2, s1=poseidon_ptr[6].output.s0, s2=2
    );
    assert poseidon_ptr[8].input = PoseidonBuiltinState(
        s0=e12.w6.d0 + 2 ** 128 * e12.w6.d1, s1=poseidon_ptr[7].output.s0, s2=2
    );
    assert poseidon_ptr[9].input = PoseidonBuiltinState(
        s0=e12.w6.d2 + 2 ** 128 * e12.w7.d0, s1=poseidon_ptr[8].output.s0, s2=2
    );
    assert poseidon_ptr[10].input = PoseidonBuiltinState(
        s0=e12.w7.d1 + 2 ** 128 * e12.w7.d2, s1=poseidon_ptr[9].output.s0, s2=2
    );
    assert poseidon_ptr[11].input = PoseidonBuiltinState(
        s0=e12.w8.d0 + 2 ** 128 * e12.w8.d1, s1=poseidon_ptr[10].output.s0, s2=2
    );
    assert poseidon_ptr[12].input = PoseidonBuiltinState(
        s0=e12.w8.d2 + 2 ** 128 * e12.w9.d0, s1=poseidon_ptr[11].output.s0, s2=2
    );
    assert poseidon_ptr[13].input = PoseidonBuiltinState(
        s0=e12.w9.d1 + 2 ** 128 * e12.w9.d2, s1=poseidon_ptr[12].output.s0, s2=2
    );
    assert poseidon_ptr[14].input = PoseidonBuiltinState(
        s0=e12.w10.d0 + 2 ** 128 * e12.w10.d1, s1=poseidon_ptr[13].output.s0, s2=2
    );
    assert poseidon_ptr[15].input = PoseidonBuiltinState(
        s0=e12.w10.d2 + 2 ** 128 * e12.w11.d0, s1=poseidon_ptr[14].output.s0, s2=2
    );
    assert poseidon_ptr[16].input = PoseidonBuiltinState(
        s0=e12.w11.d1 + 2 ** 128 * e12.w11.d2, s1=poseidon_ptr[15].output.s0, s2=2
    );

    let res = poseidon_ptr[16].output.s0;
    let poseidon_ptr = poseidon_ptr + PoseidonBuiltin.SIZE * 17;

    return res;
}

func poseidon_hash_e11{poseidon_ptr: PoseidonBuiltin*}(e12: E11full*) -> felt {
    assert poseidon_ptr.input = PoseidonBuiltinState(
        s0=e12.w0.d0 + 2 ** 128 * e12.w0.d1, s1=e12.w0.d2 + 2 ** 128 * e12.w1.d0, s2=2
    );
    assert poseidon_ptr[1].input = PoseidonBuiltinState(
        s0=e12.w1.d1 + 2 ** 128 * e12.w1.d2, s1=poseidon_ptr[0].output.s0, s2=2
    );
    assert poseidon_ptr[2].input = PoseidonBuiltinState(
        s0=e12.w2.d0 + 2 ** 128 * e12.w2.d1, s1=poseidon_ptr[1].output.s0, s2=2
    );
    assert poseidon_ptr[3].input = PoseidonBuiltinState(
        s0=e12.w2.d2 + 2 ** 128 * e12.w3.d0, s1=poseidon_ptr[2].output.s0, s2=2
    );
    assert poseidon_ptr[4].input = PoseidonBuiltinState(
        s0=e12.w3.d1 + 2 ** 128 * e12.w3.d2, s1=poseidon_ptr[3].output.s0, s2=2
    );
    assert poseidon_ptr[5].input = PoseidonBuiltinState(
        s0=e12.w4.d0 + 2 ** 128 * e12.w4.d1, s1=poseidon_ptr[4].output.s0, s2=2
    );
    assert poseidon_ptr[6].input = PoseidonBuiltinState(
        s0=e12.w4.d2 + 2 ** 128 * e12.w5.d0, s1=poseidon_ptr[5].output.s0, s2=2
    );
    assert poseidon_ptr[7].input = PoseidonBuiltinState(
        s0=e12.w5.d1 + 2 ** 128 * e12.w5.d2, s1=poseidon_ptr[6].output.s0, s2=2
    );
    assert poseidon_ptr[8].input = PoseidonBuiltinState(
        s0=e12.w6.d0 + 2 ** 128 * e12.w6.d1, s1=poseidon_ptr[7].output.s0, s2=2
    );
    assert poseidon_ptr[9].input = PoseidonBuiltinState(
        s0=e12.w6.d2 + 2 ** 128 * e12.w7.d0, s1=poseidon_ptr[8].output.s0, s2=2
    );
    assert poseidon_ptr[10].input = PoseidonBuiltinState(
        s0=e12.w7.d1 + 2 ** 128 * e12.w7.d2, s1=poseidon_ptr[9].output.s0, s2=2
    );
    assert poseidon_ptr[11].input = PoseidonBuiltinState(
        s0=e12.w8.d0 + 2 ** 128 * e12.w8.d1, s1=poseidon_ptr[10].output.s0, s2=2
    );
    assert poseidon_ptr[12].input = PoseidonBuiltinState(
        s0=e12.w8.d2 + 2 ** 128 * e12.w9.d0, s1=poseidon_ptr[11].output.s0, s2=2
    );
    assert poseidon_ptr[13].input = PoseidonBuiltinState(
        s0=e12.w9.d1 + 2 ** 128 * e12.w9.d2, s1=poseidon_ptr[12].output.s0, s2=2
    );
    assert poseidon_ptr[14].input = PoseidonBuiltinState(
        s0=e12.w10.d0 + 2 ** 128 * e12.w10.d1, s1=poseidon_ptr[13].output.s0, s2=2
    );
    assert poseidon_ptr[15].input = PoseidonBuiltinState(
        s0=e12.w10.d2, s1=poseidon_ptr[14].output.s0, s2=2
    );

    let res = poseidon_ptr[15].output.s0;
    let poseidon_ptr = poseidon_ptr + PoseidonBuiltin.SIZE * 16;

    return res;
}

// Convert tower representations Fp12/Fp6/Fp2/Fp to Fp12/Fp
func gnark_to_w{range_check_ptr}(x: E12*) -> (res: E12full*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    // C0.B0.A0 0
    // let res00 = x.c0.b0.a0;
    // C0.B0.A1 1
    // let res6 = [x.c0.b0.a1];
    // let res0 = BigInt3(
    //     x.c0.b0.a0.d0 - 9 * x.c0.b0.a1.d0,
    //     x.c0.b0.a0.d1 - 9 * x.c0.b0.a1.d1,
    //     x.c0.b0.a0.d2 - 9 * x.c0.b0.a1.d2,
    // );
    // // C0.B1.A0 2
    // // let res2 = x.c0.b1.a0;
    // // C0.B1.A1 3
    // let res8 = [x.c0.b1.a1];
    // let res2 = BigInt3(
    //     x.c0.b1.a0.d0 - 9 * res8.d0, x.c0.b1.a0.d1 - 9 * res8.d1, x.c0.b1.a0.d2 - 9 * res8.d2
    // );
    // // C0.B2.A0 4
    // // let res4 = x.c0.b2.a0;
    // // C0.B2.A1 5
    // let res10 = [x.c0.b2.a1];
    // let res4 = BigInt3(
    //     x.c0.b2.a0.d0 - 9 * res10.d0, x.c0.b2.a0.d1 - 9 * res10.d1, x.c0.b2.a0.d2 - 9 * res10.d2
    // );
    // // C1.B0.A0 6
    // // let res1 = x.c1.b0.a0;
    // // C1.B0.A1 7
    // // let res7 = [x.c1.b0.a1];
    // let res1 = BigInt3(
    //     x.c1.b0.a0.d0 - 9 * x.c1.b0.a1.d0,
    //     x.c1.b0.a0.d1 - 9 * x.c1.b0.a1.d1,
    //     x.c1.b0.a0.d2 - 9 * x.c1.b0.a1.d2,
    // );
    // // C1.B1.A0 8
    // // let res3 = x.c1.b1.a0;
    // // C1.B1.A1 9
    // let res9 = [x.c1.b1.a1];
    // let res3 = BigInt3(
    //     x.c1.b1.a0.d0 - 9 * res9.d0, x.c1.b1.a0.d1 - 9 * res9.d1, x.c1.b1.a0.d2 - 9 * res9.d2
    // );
    // // C1.B2.A0 10
    // // let res5 = x.c1.b2.a0;
    // // C1.B2.A1 11
    // let res11 = [x.c1.b2.a1];
    // let res5 = BigInt3(
    //     x.c1.b2.a0.d0 - 9 * res11.d0, x.c1.b2.a0.d1 - 9 * res11.d1, x.c1.b2.a0.d2 - 9 * res11.d2
    // );
    local res: E12full = E12full(
        BigInt3(
            x.c0.b0.a0.d0 - 9 * x.c0.b0.a1.d0,
            x.c0.b0.a0.d1 - 9 * x.c0.b0.a1.d1,
            x.c0.b0.a0.d2 - 9 * x.c0.b0.a1.d2,
        ),
        BigInt3(
            x.c1.b0.a0.d0 - 9 * x.c1.b0.a1.d0,
            x.c1.b0.a0.d1 - 9 * x.c1.b0.a1.d1,
            x.c1.b0.a0.d2 - 9 * x.c1.b0.a1.d2,
        ),
        BigInt3(
            x.c0.b1.a0.d0 - 9 * x.c0.b1.a1.d0,
            x.c0.b1.a0.d1 - 9 * x.c0.b1.a1.d1,
            x.c0.b1.a0.d2 - 9 * x.c0.b1.a1.d2,
        ),
        BigInt3(
            x.c1.b1.a0.d0 - 9 * x.c1.b1.a1.d0,
            x.c1.b1.a0.d1 - 9 * x.c1.b1.a1.d1,
            x.c1.b1.a0.d2 - 9 * x.c1.b1.a1.d2,
        ),
        BigInt3(
            x.c0.b2.a0.d0 - 9 * x.c0.b2.a1.d0,
            x.c0.b2.a0.d1 - 9 * x.c0.b2.a1.d1,
            x.c0.b2.a0.d2 - 9 * x.c0.b2.a1.d2,
        ),
        BigInt3(
            x.c1.b2.a0.d0 - 9 * x.c1.b2.a1.d0,
            x.c1.b2.a0.d1 - 9 * x.c1.b2.a1.d1,
            x.c1.b2.a0.d2 - 9 * x.c1.b2.a1.d2,
        ),
        [x.c0.b0.a1],
        [x.c1.b0.a1],
        [x.c0.b1.a1],
        [x.c1.b1.a1],
        [x.c0.b2.a1],
        [x.c1.b2.a1],
    );
    return (&res,);
}

// Convert tower representation Fp12/Fp to Fp12/Fp6/Fp2/Fp
func w_to_gnark(x: E12full) -> E12* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    // w^0
    let c0b0a0 = x.w0;
    // w^1
    let c1b0a0 = x.w1;
    // w^2
    let c0b1a0 = x.w2;
    // w^3
    let c1b1a0 = x.w3;
    // w^4
    let c0b2a0 = x.w4;
    // w^5
    let c1b2a0 = x.w5;
    // w^6
    local c0b0a1: BigInt3 = x.w6;
    local c0b0a0: BigInt3 = BigInt3(
        c0b0a0.d0 + 9 * c0b0a1.d0, c0b0a0.d1 + 9 * c0b0a1.d1, c0b0a0.d2 + 9 * c0b0a1.d2
    );
    // w^7
    local c1b0a1: BigInt3 = x.w7;
    local c1b0a0: BigInt3 = BigInt3(
        c1b0a0.d0 + 9 * c1b0a1.d0, c1b0a0.d1 + 9 * c1b0a1.d1, c1b0a0.d2 + 9 * c1b0a1.d2
    );
    // w^8
    local c0b1a1: BigInt3 = x.w8;
    local c0b1a0: BigInt3 = BigInt3(
        c0b1a0.d0 + 9 * c0b1a1.d0, c0b1a0.d1 + 9 * c0b1a1.d1, c0b1a0.d2 + 9 * c0b1a1.d2
    );
    // w^9
    local c1b1a1: BigInt3 = x.w9;
    local c1b1a0: BigInt3 = BigInt3(
        c1b1a0.d0 + 9 * c1b1a1.d0, c1b1a0.d1 + 9 * c1b1a1.d1, c1b1a0.d2 + 9 * c1b1a1.d2
    );
    // w^10
    local c0b2a1: BigInt3 = x.w10;
    local c0b2a0: BigInt3 = BigInt3(
        c0b2a0.d0 + 9 * c0b2a1.d0, c0b2a0.d1 + 9 * c0b2a1.d1, c0b2a0.d2 + 9 * c0b2a1.d2
    );
    // w^11
    local c1b2a1: BigInt3 = x.w11;
    local c1b2a0: BigInt3 = BigInt3(
        c1b2a0.d0 + 9 * c1b2a1.d0, c1b2a0.d1 + 9 * c1b2a1.d1, c1b2a0.d2 + 9 * c1b2a1.d2
    );

    local c0b0: E2 = E2(&c0b0a0, &c0b0a1);
    local c0b1: E2 = E2(&c0b1a0, &c0b1a1);
    local c0b2: E2 = E2(&c0b2a0, &c0b2a1);
    local c1b0: E2 = E2(&c1b0a0, &c1b0a1);
    local c1b1: E2 = E2(&c1b1a0, &c1b1a1);
    local c1b2: E2 = E2(&c1b2a0, &c1b2a1);
    local c0: E6 = E6(&c0b0, &c0b1, &c0b2);
    local c1: E6 = E6(&c1b0, &c1b1, &c1b2);
    local res: E12 = E12(&c0, &c1);
    return &res;
}

func w_to_gnark_reduced{range_check_ptr}(x: E12full) -> E12* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    // w^0
    // let c0b0a0 = x.w0;
    // // w^1
    // let c1b0a0 = x.w1;
    // // w^2
    // let c0b1a0 = x.w2;
    // // w^3
    // let c1b1a0 = x.w3;
    // // w^4
    // let c0b2a0 = x.w4;
    // // w^5
    // let c1b2a0 = x.w5;
    // w^6
    local c0b0a1: BigInt3 = x.w6;
    let c0b0a0 = reduce_3(
        UnreducedBigInt3(x.w0.d0 + 9 * c0b0a1.d0, x.w0.d1 + 9 * c0b0a1.d1, x.w0.d2 + 9 * c0b0a1.d2)
    );
    // w^7
    local c1b0a1: BigInt3 = x.w7;
    let c1b0a0 = reduce_3(
        UnreducedBigInt3(x.w1.d0 + 9 * c1b0a1.d0, x.w1.d1 + 9 * c1b0a1.d1, x.w1.d2 + 9 * c1b0a1.d2)
    );
    // w^8
    local c0b1a1: BigInt3 = x.w8;
    let c0b1a0 = reduce_3(
        UnreducedBigInt3(x.w2.d0 + 9 * c0b1a1.d0, x.w2.d1 + 9 * c0b1a1.d1, x.w2.d2 + 9 * c0b1a1.d2)
    );
    // w^9
    local c1b1a1: BigInt3 = x.w9;
    let c1b1a0 = reduce_3(
        UnreducedBigInt3(x.w3.d0 + 9 * c1b1a1.d0, x.w3.d1 + 9 * c1b1a1.d1, x.w3.d2 + 9 * c1b1a1.d2)
    );
    // w^10
    local c0b2a1: BigInt3 = x.w10;
    let c0b2a0 = reduce_3(
        UnreducedBigInt3(x.w4.d0 + 9 * c0b2a1.d0, x.w4.d1 + 9 * c0b2a1.d1, x.w4.d2 + 9 * c0b2a1.d2)
    );
    // w^11
    local c1b2a1: BigInt3 = x.w11;
    let c1b2a0 = reduce_3(
        UnreducedBigInt3(x.w5.d0 + 9 * c1b2a1.d0, x.w5.d1 + 9 * c1b2a1.d1, x.w5.d2 + 9 * c1b2a1.d2)
    );

    local c0b0: E2 = E2(c0b0a0, &c0b0a1);
    local c0b1: E2 = E2(c0b1a0, &c0b1a1);
    local c0b2: E2 = E2(c0b2a0, &c0b2a1);
    local c1b0: E2 = E2(c1b0a0, &c1b0a1);
    local c1b1: E2 = E2(c1b1a0, &c1b1a1);
    local c1b2: E2 = E2(c1b2a0, &c1b2a1);
    local c0: E6 = E6(&c0b0, &c0b1, &c0b2);
    local c1: E6 = E6(&c1b0, &c1b1, &c1b2);
    local res: E12 = E12(&c0, &c1);
    return &res;
}
