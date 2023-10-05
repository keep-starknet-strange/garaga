from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import SHIFT, Uint256

from src.bn254.towers.e2 import e2, E2, E2UnreducedFull, E2Unreduced
from src.bn254.fq import (
    BigInt3,
    reduce_3,
    UnreducedBigInt3,
    assert_reduced_felt,
    reduce_5,
    UnreducedBigInt5,
    assert_reduced_felt256,
    BASE_MIN_1,
    fq_bigint3,
    unrededucedUint256_to_BigInt3,
    bigint_mul,
    verify_zero5,
)
from src.bn254.curve import N_LIMBS, DEGREE, BASE, P0, P1, P2, NON_RESIDUE_E2_a0, NON_RESIDUE_E2_a1
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin
from starkware.cairo.common.poseidon_state import PoseidonBuiltinState
from starkware.cairo.common.builtin_poseidon.poseidon import poseidon_hash

struct E6 {
    b0: E2*,
    b1: E2*,
    b2: E2*,
}

struct E6Unreduced {
    b0: E2Unreduced*,
    b1: E2Unreduced*,
    b2: E2Unreduced*,
}

struct E6full {
    v0: BigInt3,
    v1: BigInt3,
    v2: BigInt3,
    v3: BigInt3,
    v4: BigInt3,
    v5: BigInt3,
}
struct E5full {
    v0: Uint256,
    v1: Uint256,
    v2: Uint256,
    v3: Uint256,
    v4: Uint256,
}

struct VerifyMul6 {
    x: E6full*,
    y: E6full*,
    q: E5full*,
    r: E6full*,
}

func assert_E6full(x: E6full*, y: E6full*) {
    assert 0 = x.v0.d0 - y.v0.d0;
    assert 0 = x.v0.d1 - y.v0.d1;
    assert 0 = x.v0.d2 - y.v0.d2;
    assert 0 = x.v1.d0 - y.v1.d0;
    assert 0 = x.v1.d1 - y.v1.d1;
    assert 0 = x.v1.d2 - y.v1.d2;
    assert 0 = x.v2.d0 - y.v2.d0;
    assert 0 = x.v2.d1 - y.v2.d1;
    assert 0 = x.v2.d2 - y.v2.d2;
    assert 0 = x.v3.d0 - y.v3.d0;
    assert 0 = x.v3.d1 - y.v3.d1;
    assert 0 = x.v3.d2 - y.v3.d2;
    assert 0 = x.v4.d0 - y.v4.d0;
    assert 0 = x.v4.d1 - y.v4.d1;
    assert 0 = x.v4.d2 - y.v4.d2;
    assert 0 = x.v5.d0 - y.v5.d0;
    assert 0 = x.v5.d1 - y.v5.d1;
    assert 0 = x.v5.d2 - y.v5.d2;
    return ();
}

func mul_trick_e6{range_check_ptr, verify_mul6_array: VerifyMul6*, n_mul6: felt}(
    x: E6full*, y: E6full*
) -> E6full* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local q_w: E5full;
    local r_w: E6full;

    %{
        from tools.py.polynomial import Polynomial
        from tools.py.field import BaseFieldElement, BaseField
        from starkware.cairo.common.cairo_secp.secp_utils import split
        from tools.make.utils import split_128
        from tools.py.extension_trick import flatten, v_to_gnark, gnark_to_v, mul_e6, pack_e6
        p=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
        field = BaseField(p)
        x=[0]*6
        y=[0]*6
        x_refs = [ids.x.v0, ids.x.v1, ids.x.v2, ids.x.v3, ids.x.v4, ids.x.v5]
        y_refs = [ids.y.v0, ids.y.v1, ids.y.v2, ids.y.v3, ids.y.v4, ids.y.v5]
        for i in range(ids.N_LIMBS):
            for k in range(6):
                x[k] += as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
                y[k] += as_int(getattr(y_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
        x_poly = Polynomial([BaseFieldElement(x[i], field) for i in range(6)])
        y_poly = Polynomial([BaseFieldElement(y[i], field) for i in range(6)])
        z_poly = x_poly * y_poly
        # v^6 - 18v^3 + 82 
        coeffs = [BaseFieldElement(82, field), field.zero(), field.zero(), BaseFieldElement(-18%p, field), field.zero(), field.zero(), field.one()]
        unreducible_poly=Polynomial(coeffs)
        z_polyr=z_poly % unreducible_poly
        z_polyq=z_poly // unreducible_poly
        z_polyr_coeffs = z_polyr.get_coeffs()
        z_polyq_coeffs = z_polyq.get_coeffs()
        assert len(z_polyq_coeffs) <= 5, f"len z_polyq_coeffs={len(z_polyq_coeffs)}, degree: {z_polyq.degree()}"
        assert len(z_polyr_coeffs) <= 6, f"len z_polyr_coeffs={len(z_polyr_coeffs)}, degree: {z_polyr.degree()}"
        z_polyq_coeffs = z_polyq_coeffs + [0] * (5 - len(z_polyq_coeffs))
        z_polyr_coeffs = z_polyr_coeffs + [0] * (6 - len(z_polyr_coeffs))
        x_gnark = pack_e6(v_to_gnark(x))
        y_gnark = pack_e6(v_to_gnark(y))
        xy_gnark = flatten(mul_e6(x_gnark, y_gnark))
        assert z_polyr_coeffs == gnark_to_v(xy_gnark), f"z_polyr_coeffs: {z_polyr_coeffs}, xy_gnark: {xy_gnark}"
        for i in range(6):
            val = split(z_polyr_coeffs[i]%p)
            for k in range(ids.N_LIMBS):
                rsetattr(ids.r_w, f'v{i}.d{k}', val[k])
        for i in range(5):
            val = split_128(z_polyq_coeffs[i]%p)
            rsetattr(ids.q_w, f'v{i}.low', val[0])
            rsetattr(ids.q_w, f'v{i}.high', val[1])
    %}
    assert_reduced_e6full(r_w);
    assert_reduced_felt256(q_w.v0);
    assert_reduced_felt256(q_w.v1);
    assert_reduced_felt256(q_w.v2);
    assert_reduced_felt256(q_w.v3);
    assert_reduced_felt256(q_w.v4);

    local to_check_later: VerifyMul6 = VerifyMul6(x, y, &q_w, &r_w);
    assert verify_mul6_array[n_mul6] = to_check_later;
    let n_mul6 = n_mul6 + 1;
    return &r_w;
}

func div_trick_e6{range_check_ptr, verify_mul6_array: VerifyMul6*, n_mul6: felt}(
    x: E6full*, y: E6full*
) -> E6full* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    local div: E6full;

    %{
        from starkware.cairo.common.math_utils import as_int
        from src.bn254.hints import split
        from tools.py.extension_trick import flatten, v_to_gnark, gnark_to_v, div_e6, pack_e6

        x, y=6*[0], 6*[0]
        x_refs = [ids.x.v0, ids.x.v1, ids.x.v2, ids.x.v3, ids.x.v4, ids.x.v5]
        y_refs = [ids.y.v0, ids.y.v1, ids.y.v2, ids.y.v3, ids.y.v4, ids.y.v5]
        for i in range(ids.N_LIMBS):
            for k in range(6):
                x[k] += as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
                y[k] += as_int(getattr(y_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
        x_gnark, y_gnark = pack_e6(v_to_gnark(x)), pack_e6(v_to_gnark(y))
        z = flatten(div_e6(x_gnark, y_gnark))
        z = gnark_to_v(z)
        e = [split(x) for x in z]
                                                      
        for i in range(6):
            for k in range(ids.N_LIMBS):
                rsetattr(ids.div, f'v{i}.d{k}', e[i][k])
    %}

    assert_reduced_e6full(div);

    let check = mul_trick_e6(y, &div);

    assert_E6full(x, check);

    return &div;
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
    func add_full{range_check_ptr}(x: E6full*, y: E6full*) -> E6full* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let v0 = fq_bigint3.add(&x.v0, &y.v0);
        let v1 = fq_bigint3.add(&x.v1, &y.v1);
        let v2 = fq_bigint3.add(&x.v2, &y.v2);
        let v3 = fq_bigint3.add(&x.v3, &y.v3);
        let v4 = fq_bigint3.add(&x.v4, &y.v4);
        let v5 = fq_bigint3.add(&x.v5, &y.v5);
        local res: E6full = E6full([v0], [v1], [v2], [v3], [v4], [v5]);
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
    func neg_full{range_check_ptr}(x: E6full*) -> E6full* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let v0 = fq_bigint3.neg_full(x.v0);
        let v1 = fq_bigint3.neg_full(x.v1);
        let v2 = fq_bigint3.neg_full(x.v2);
        let v3 = fq_bigint3.neg_full(x.v3);
        let v4 = fq_bigint3.neg_full(x.v4);
        let v5 = fq_bigint3.neg_full(x.v5);
        local res: E6full = E6full(v0, v1, v2, v3, v4, v5);
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
    // func mul_unreduced{range_check_ptr}(x: E6*, y: E6*) -> E6Unreduced* {
    //     alloc_locals;
    //     let (__fp__, _) = get_fp_and_pc();
    //     let t0: E2UnreducedFull = e2.mul_unreduced(x.b0, y.b0);
    //     let t1: E2UnreducedFull = e2.mul_unreduced(x.b1, y.b1);
    //     let t2: E2UnreducedFull = e2.mul_unreduced(x.b2, y.b2);

    // let c0 = e2.add_add_mul_sub_sub_mulnr_add_unreduced(y.b1, y.b2, x.b1, x.b2, t1, t2, t0);
    //     let c1 = e2.add_add_mul_sub_sub_addmulnr_unreduced(x.b0, x.b1, y.b0, y.b1, t0, t1, t2);
    //     let c2 = e2.add_add_mul_sub_sub_add_unreduced(x.b0, x.b2, y.b0, y.b2, t0, t2, t1);

    // local res: E6Unreduced = E6Unreduced(c0, c1, c2);
    //     return &res;
    // }

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
    // Computes (sub_left - sub_right) * mul_right + add1_right + add2_right
    func sub_mul_add_add{range_check_ptr}(
        sub_left: E6*, sub_right: E6*, mul_right: E6*, add1_right: E6*, add2_right: E6*
    ) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local mul_left_b0_a0: BigInt3 = BigInt3(
            sub_left.b0.a0.d0 - sub_right.b0.a0.d0,
            sub_left.b0.a0.d1 - sub_right.b0.a0.d1,
            sub_left.b0.a0.d2 - sub_right.b0.a0.d2,
        );
        local mul_left_b0_a1: BigInt3 = BigInt3(
            sub_left.b0.a1.d0 - sub_right.b0.a1.d0,
            sub_left.b0.a1.d1 - sub_right.b0.a1.d1,
            sub_left.b0.a1.d2 - sub_right.b0.a1.d2,
        );
        local mul_left_b1_a0: BigInt3 = BigInt3(
            sub_left.b1.a0.d0 - sub_right.b1.a0.d0,
            sub_left.b1.a0.d1 - sub_right.b1.a0.d1,
            sub_left.b1.a0.d2 - sub_right.b1.a0.d2,
        );
        local mul_left_b1_a1: BigInt3 = BigInt3(
            sub_left.b1.a1.d0 - sub_right.b1.a1.d0,
            sub_left.b1.a1.d1 - sub_right.b1.a1.d1,
            sub_left.b1.a1.d2 - sub_right.b1.a1.d2,
        );
        local mul_left_b2_a0: BigInt3 = BigInt3(
            sub_left.b2.a0.d0 - sub_right.b2.a0.d0,
            sub_left.b2.a0.d1 - sub_right.b2.a0.d1,
            sub_left.b2.a0.d2 - sub_right.b2.a0.d2,
        );
        local mul_left_b2_a1: BigInt3 = BigInt3(
            sub_left.b2.a1.d0 - sub_right.b2.a1.d0,
            sub_left.b2.a1.d1 - sub_right.b2.a1.d1,
            sub_left.b2.a1.d2 - sub_right.b2.a1.d2,
        );
        local mul_left_b0: E2 = E2(&mul_left_b0_a0, &mul_left_b0_a1);
        local mul_left_b1: E2 = E2(&mul_left_b1_a0, &mul_left_b1_a1);
        local mul_left_b2: E2 = E2(&mul_left_b2_a0, &mul_left_b2_a1);

        let t0 = e2.mul_unreduced(&mul_left_b0, mul_right.b0);
        let t1 = e2.mul_unreduced(&mul_left_b1, mul_right.b1);
        let t2 = e2.mul_unreduced(&mul_left_b2, mul_right.b2);

        let c0 = e2.add_add_mul_sub_sub_mulnr_add_unreduced(
            mul_right.b1, mul_right.b2, &mul_left_b1, &mul_left_b2, t1, t2, t0
        );
        let c1 = e2.add_add_mul_sub_sub_addmulnr_unreduced(
            &mul_left_b0, &mul_left_b1, mul_right.b0, mul_right.b1, t0, t1, t2
        );
        let c2 = e2.add_add_mul_sub_sub_add_unreduced(
            &mul_left_b0, &mul_left_b2, mul_right.b0, mul_right.b2, t0, t2, t1
        );

        let res_b0_a0 = reduce_5(
            UnreducedBigInt5(
                d0=c0.a0.d0 + add1_right.b0.a0.d0 + add2_right.b0.a0.d0,
                d1=c0.a0.d1 + add1_right.b0.a0.d1 + add2_right.b0.a0.d1,
                d2=c0.a0.d2 + add1_right.b0.a0.d2 + add2_right.b0.a0.d2,
                d3=c0.a0.d3,
                d4=c0.a0.d4,
            ),
        );

        let res_b0_a1 = reduce_5(
            UnreducedBigInt5(
                d0=c0.a1.d0 + add1_right.b0.a1.d0 + add2_right.b0.a1.d0,
                d1=c0.a1.d1 + add1_right.b0.a1.d1 + add2_right.b0.a1.d1,
                d2=c0.a1.d2 + add1_right.b0.a1.d2 + add2_right.b0.a1.d2,
                d3=c0.a1.d3,
                d4=c0.a1.d4,
            ),
        );

        let res_b1_a0 = reduce_5(
            UnreducedBigInt5(
                d0=c1.a0.d0 + add1_right.b1.a0.d0 + add2_right.b1.a0.d0,
                d1=c1.a0.d1 + add1_right.b1.a0.d1 + add2_right.b1.a0.d1,
                d2=c1.a0.d2 + add1_right.b1.a0.d2 + add2_right.b1.a0.d2,
                d3=c1.a0.d3,
                d4=c1.a0.d4,
            ),
        );

        let res_b1_a1 = reduce_5(
            UnreducedBigInt5(
                d0=c1.a1.d0 + add1_right.b1.a1.d0 + add2_right.b1.a1.d0,
                d1=c1.a1.d1 + add1_right.b1.a1.d1 + add2_right.b1.a1.d1,
                d2=c1.a1.d2 + add1_right.b1.a1.d2 + add2_right.b1.a1.d2,
                d3=c1.a1.d3,
                d4=c1.a1.d4,
            ),
        );

        let res_b2_a0 = reduce_5(
            UnreducedBigInt5(
                d0=c2.a0.d0 + add1_right.b2.a0.d0 + add2_right.b2.a0.d0,
                d1=c2.a0.d1 + add1_right.b2.a0.d1 + add2_right.b2.a0.d1,
                d2=c2.a0.d2 + add1_right.b2.a0.d2 + add2_right.b2.a0.d2,
                d3=c2.a0.d3,
                d4=c2.a0.d4,
            ),
        );

        let res_b2_a1 = reduce_5(
            UnreducedBigInt5(
                d0=c2.a1.d0 + add1_right.b2.a1.d0 + add2_right.b2.a1.d0,
                d1=c2.a1.d1 + add1_right.b2.a1.d1 + add2_right.b2.a1.d1,
                d2=c2.a1.d2 + add1_right.b2.a1.d2 + add2_right.b2.a1.d2,
                d3=c2.a1.d3,
                d4=c2.a1.d4,
            ),
        );

        // End :
        local res_b0: E2 = E2(res_b0_a0, res_b0_a1);
        local res_b1: E2 = E2(res_b1_a0, res_b1_a1);
        local res_b2: E2 = E2(res_b2_a0, res_b2_a1);
        local res: E6 = E6(&res_b0, &res_b1, &res_b2);
        return &res;
    }

    // Computes (add0_left + add0_right) * (add1_left + add1_right) - sub1_right - sub2_right
    func add_add_mul_sub_sub{range_check_ptr}(
        add0_left: E6*,
        add0_right: E6*,
        add1_left: E6*,
        add1_right: E6*,
        sub1_right: E6*,
        sub2_right: E6*,
    ) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local mul_left_b0_a0: BigInt3 = BigInt3(
            add0_left.b0.a0.d0 + add0_right.b0.a0.d0,
            add0_left.b0.a0.d1 + add0_right.b0.a0.d1,
            add0_left.b0.a0.d2 + add0_right.b0.a0.d2,
        );
        local mul_left_b0_a1: BigInt3 = BigInt3(
            add0_left.b0.a1.d0 + add0_right.b0.a1.d0,
            add0_left.b0.a1.d1 + add0_right.b0.a1.d1,
            add0_left.b0.a1.d2 + add0_right.b0.a1.d2,
        );
        local mul_left_b1_a0: BigInt3 = BigInt3(
            add0_left.b1.a0.d0 + add0_right.b1.a0.d0,
            add0_left.b1.a0.d1 + add0_right.b1.a0.d1,
            add0_left.b1.a0.d2 + add0_right.b1.a0.d2,
        );
        local mul_left_b1_a1: BigInt3 = BigInt3(
            add0_left.b1.a1.d0 + add0_right.b1.a1.d0,
            add0_left.b1.a1.d1 + add0_right.b1.a1.d1,
            add0_left.b1.a1.d2 + add0_right.b1.a1.d2,
        );
        local mul_left_b2_a0: BigInt3 = BigInt3(
            add0_left.b2.a0.d0 + add0_right.b2.a0.d0,
            add0_left.b2.a0.d1 + add0_right.b2.a0.d1,
            add0_left.b2.a0.d2 + add0_right.b2.a0.d2,
        );
        local mul_left_b2_a1: BigInt3 = BigInt3(
            add0_left.b2.a1.d0 + add0_right.b2.a1.d0,
            add0_left.b2.a1.d1 + add0_right.b2.a1.d1,
            add0_left.b2.a1.d2 + add0_right.b2.a1.d2,
        );
        local mul_left_b0: E2 = E2(&mul_left_b0_a0, &mul_left_b0_a1);
        local mul_left_b1: E2 = E2(&mul_left_b1_a0, &mul_left_b1_a1);
        local mul_left_b2: E2 = E2(&mul_left_b2_a0, &mul_left_b2_a1);

        local mul_right_b0_a0: BigInt3 = BigInt3(
            add1_left.b0.a0.d0 + add1_right.b0.a0.d0,
            add1_left.b0.a0.d1 + add1_right.b0.a0.d1,
            add1_left.b0.a0.d2 + add1_right.b0.a0.d2,
        );
        local mul_right_b0_a1: BigInt3 = BigInt3(
            add1_left.b0.a1.d0 + add1_right.b0.a1.d0,
            add1_left.b0.a1.d1 + add1_right.b0.a1.d1,
            add1_left.b0.a1.d2 + add1_right.b0.a1.d2,
        );
        local mul_right_b1_a0: BigInt3 = BigInt3(
            add1_left.b1.a0.d0 + add1_right.b1.a0.d0,
            add1_left.b1.a0.d1 + add1_right.b1.a0.d1,
            add1_left.b1.a0.d2 + add1_right.b1.a0.d2,
        );
        local mul_right_b1_a1: BigInt3 = BigInt3(
            add1_left.b1.a1.d0 + add1_right.b1.a1.d0,
            add1_left.b1.a1.d1 + add1_right.b1.a1.d1,
            add1_left.b1.a1.d2 + add1_right.b1.a1.d2,
        );
        local mul_right_b2_a0: BigInt3 = BigInt3(
            add1_left.b2.a0.d0 + add1_right.b2.a0.d0,
            add1_left.b2.a0.d1 + add1_right.b2.a0.d1,
            add1_left.b2.a0.d2 + add1_right.b2.a0.d2,
        );
        local mul_right_b2_a1: BigInt3 = BigInt3(
            add1_left.b2.a1.d0 + add1_right.b2.a1.d0,
            add1_left.b2.a1.d1 + add1_right.b2.a1.d1,
            add1_left.b2.a1.d2 + add1_right.b2.a1.d2,
        );
        local mul_right_b0: E2 = E2(&mul_right_b0_a0, &mul_right_b0_a1);
        local mul_right_b1: E2 = E2(&mul_right_b1_a0, &mul_right_b1_a1);
        local mul_right_b2: E2 = E2(&mul_right_b2_a0, &mul_right_b2_a1);

        let t0 = e2.mul_unreduced(&mul_left_b0, &mul_right_b0);
        let t1 = e2.mul_unreduced(&mul_left_b1, &mul_right_b1);
        let t2 = e2.mul_unreduced(&mul_left_b2, &mul_right_b2);

        let c0 = e2.add_add_mul_sub_sub_mulnr_add_unreduced(
            &mul_right_b1, &mul_right_b2, &mul_left_b1, &mul_left_b2, t1, t2, t0
        );
        let c1 = e2.add_add_mul_sub_sub_addmulnr_unreduced(
            &mul_left_b0, &mul_left_b1, &mul_right_b0, &mul_right_b1, t0, t1, t2
        );
        let c2 = e2.add_add_mul_sub_sub_add_unreduced(
            &mul_left_b0, &mul_left_b2, &mul_right_b0, &mul_right_b2, t0, t2, t1
        );

        let res_b0_a0 = reduce_5(
            UnreducedBigInt5(
                d0=c0.a0.d0 - sub1_right.b0.a0.d0 - sub2_right.b0.a0.d0,
                d1=c0.a0.d1 - sub1_right.b0.a0.d1 - sub2_right.b0.a0.d1,
                d2=c0.a0.d2 - sub1_right.b0.a0.d2 - sub2_right.b0.a0.d2,
                d3=c0.a0.d3,
                d4=c0.a0.d4,
            ),
        );

        let res_b0_a1 = reduce_5(
            UnreducedBigInt5(
                d0=c0.a1.d0 - sub1_right.b0.a1.d0 - sub2_right.b0.a1.d0,
                d1=c0.a1.d1 - sub1_right.b0.a1.d1 - sub2_right.b0.a1.d1,
                d2=c0.a1.d2 - sub1_right.b0.a1.d2 - sub2_right.b0.a1.d2,
                d3=c0.a1.d3,
                d4=c0.a1.d4,
            ),
        );

        let res_b1_a0 = reduce_5(
            UnreducedBigInt5(
                d0=c1.a0.d0 - sub1_right.b1.a0.d0 - sub2_right.b1.a0.d0,
                d1=c1.a0.d1 - sub1_right.b1.a0.d1 - sub2_right.b1.a0.d1,
                d2=c1.a0.d2 - sub1_right.b1.a0.d2 - sub2_right.b1.a0.d2,
                d3=c1.a0.d3,
                d4=c1.a0.d4,
            ),
        );

        let res_b1_a1 = reduce_5(
            UnreducedBigInt5(
                d0=c1.a1.d0 - sub1_right.b1.a1.d0 - sub2_right.b1.a1.d0,
                d1=c1.a1.d1 - sub1_right.b1.a1.d1 - sub2_right.b1.a1.d1,
                d2=c1.a1.d2 - sub1_right.b1.a1.d2 - sub2_right.b1.a1.d2,
                d3=c1.a1.d3,
                d4=c1.a1.d4,
            ),
        );

        let res_b2_a0 = reduce_5(
            UnreducedBigInt5(
                d0=c2.a0.d0 - sub1_right.b2.a0.d0 - sub2_right.b2.a0.d0,
                d1=c2.a0.d1 - sub1_right.b2.a0.d1 - sub2_right.b2.a0.d1,
                d2=c2.a0.d2 - sub1_right.b2.a0.d2 - sub2_right.b2.a0.d2,
                d3=c2.a0.d3,
                d4=c2.a0.d4,
            ),
        );

        let res_b2_a1 = reduce_5(
            UnreducedBigInt5(
                d0=c2.a1.d0 - sub1_right.b2.a1.d0 - sub2_right.b2.a1.d0,
                d1=c2.a1.d1 - sub1_right.b2.a1.d1 - sub2_right.b2.a1.d1,
                d2=c2.a1.d2 - sub1_right.b2.a1.d2 - sub2_right.b2.a1.d2,
                d3=c2.a1.d3,
                d4=c2.a1.d4,
            ),
        );

        // End :
        local res_b0: E2 = E2(res_b0_a0, res_b0_a1);
        local res_b1: E2 = E2(res_b1_a0, res_b1_a1);
        local res_b2: E2 = E2(res_b2_a0, res_b2_a1);
        local res: E6 = E6(&res_b0, &res_b1, &res_b2);
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
            from src.bn254.hints import div_e6, split

            x, y=6*[0], 6*[0]
            x_refs =[ids.x.b0.a0, ids.x.b0.a1, ids.x.b1.a0, ids.x.b1.a1, ids.x.b2.a0, ids.x.b2.a1]
            y_refs =[ids.y.b0.a0, ids.y.b0.a1, ids.y.b1.a0, ids.y.b1.a1, ids.y.b2.a0, ids.y.b2.a1]


            for i in range(ids.N_LIMBS):
                for k in range(6):
                    x[k]+=as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
                    y[k]+=as_int(getattr(y_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i

            z = div_e6(x, y)
            e = [split(z[0][0]), split(z[0][1]), split(z[1][0]), split(z[1][1]), split(z[2][0]), split(z[2][1])]

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

    // func mul_by_non_residue_unreduced{range_check_ptr}(x: E6*) -> E6* {
    //     alloc_locals;
    //     let (__fp__, _) = get_fp_and_pc();
    //     let b0 = x.b2;
    //     let b1 = x.b0;
    //     let b2 = x.b1;
    //     let b0 = e2.mul_by_non_residue_unreduced(b0);
    //     local res: E6 = E6(b0, b1, b2);
    //     return &res;
    // }

    // Computes :
    // res = - (mul_nr_neg.mul_by_non_residue()) + add_right (unreduced)
    func mulnr_neg_add_unreduced{range_check_ptr}(mul_nr_neg: E6*, add_right: E6*) -> E6* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local b1a0: BigInt3 = BigInt3(
            (-mul_nr_neg.b0.a0.d0) + add_right.b1.a0.d0,
            (-mul_nr_neg.b0.a0.d1) + add_right.b1.a0.d1,
            (-mul_nr_neg.b0.a0.d2) + add_right.b1.a0.d2,
        );
        local b1a1: BigInt3 = BigInt3(
            (-mul_nr_neg.b0.a1.d0) + add_right.b1.a1.d0,
            (-mul_nr_neg.b0.a1.d1) + add_right.b1.a1.d1,
            (-mul_nr_neg.b0.a1.d2) + add_right.b1.a1.d2,
        );

        local b2a0: BigInt3 = BigInt3(
            (-mul_nr_neg.b1.a0.d0) + add_right.b2.a0.d0,
            (-mul_nr_neg.b1.a0.d1) + add_right.b2.a0.d1,
            (-mul_nr_neg.b1.a0.d2) + add_right.b2.a0.d2,
        );

        local b2a1: BigInt3 = BigInt3(
            (-mul_nr_neg.b1.a1.d0) + add_right.b2.a1.d0,
            (-mul_nr_neg.b1.a1.d1) + add_right.b2.a1.d1,
            (-mul_nr_neg.b1.a1.d2) + add_right.b2.a1.d2,
        );

        let b0 = mul_nr_neg.b2;

        tempvar b = BigInt3(b0.a0.d0 * 9, b0.a0.d1 * 9, b0.a0.d2 * 9);

        local b0a0: BigInt3 = BigInt3(
            (-(b.d0 - b0.a1.d0)) + add_right.b0.a0.d0,
            (-(b.d1 - b0.a1.d1)) + add_right.b0.a0.d1,
            (-(b.d2 - b0.a1.d2)) + add_right.b0.a0.d2,
        );

        local b0a1: BigInt3 = BigInt3(
            (-((b0.a0.d0 + b0.a1.d0) * 10 - b.d0 - b0.a1.d0)) + add_right.b0.a1.d0,
            (-((b0.a0.d1 + b0.a1.d1) * 10 - b.d1 - b0.a1.d1)) + add_right.b0.a1.d1,
            (-((b0.a0.d2 + b0.a1.d2) * 10 - b.d2 - b0.a1.d2)) + add_right.b0.a1.d2,
        );

        local res_b0: E2 = E2(&b0a0, &b0a1);
        local res_b1: E2 = E2(&b1a0, &b1a1);
        local res_b2: E2 = E2(&b2a0, &b2a1);

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

    // compute mul_by_01((add_left + add_right), b0_minus_one + 1, b1)
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
        let t1 = e2.add_add_mul_sub5_sub5(&x_b0, &x_b1, &b0, b1, a, b);

        local res: E6 = E6(t0, t1, t2);
        return &res;
    }
    // Compute -(x+y) + z
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

        let t1 = e2.add_add_mul_sub5_sub5(x.b0, x.b1, b0, b1, a, b);

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
    func is_zero_full{}(x: E6full*) -> felt {
        if (x.v0.d0 != 0) {
            return 0;
        }
        if (x.v0.d1 != 0) {
            return 0;
        }
        if (x.v0.d2 != 0) {
            return 0;
        }
        if (x.v1.d0 != 0) {
            return 0;
        }
        if (x.v1.d1 != 0) {
            return 0;
        }
        if (x.v1.d2 != 0) {
            return 0;
        }
        if (x.v2.d0 != 0) {
            return 0;
        }
        if (x.v2.d1 != 0) {
            return 0;
        }
        if (x.v2.d2 != 0) {
            return 0;
        }
        if (x.v3.d0 != 0) {
            return 0;
        }
        if (x.v3.d1 != 0) {
            return 0;
        }
        if (x.v3.d2 != 0) {
            return 0;
        }
        if (x.v4.d0 != 0) {
            return 0;
        }
        if (x.v4.d1 != 0) {
            return 0;
        }
        if (x.v4.d2 != 0) {
            return 0;
        }
        if (x.v5.d0 != 0) {
            return 0;
        }
        if (x.v5.d1 != 0) {
            return 0;
        }
        if (x.v5.d2 != 0) {
            return 0;
        }
        return 1;
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
    // Todo : Try to derive complete formulas and avoid conversion
    func frobenius_torus_full{range_check_ptr}(x: E6full*) -> E6full* {
        alloc_locals;
        let x_gnark = v_to_gnark_reduced([x]);
        let frobenius = frobenius_torus(x_gnark);
        let res = gnark_to_v(frobenius);
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

    // FrobeniusSquareTorus raises a compressed elements x ∈ E6 to the square modulus p^2
    // and returns x^(p^2) / v^((p^2-1)/2)
    func frobenius_square_torus_full{range_check_ptr}(x: E6full*) -> E6full* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        // v0 = 2203960485148121921418603742825762020974279258880205651967
        // v0*nr2p2 = 21888242871839275220042445260109153167277707414472061641714758635765020556617
        // v0*nr2p4 = 21888242871839275222246405745257275088696311157297823662689037894645226208582

        let v0 = fq_bigint3.mulf(
            x.v0, BigInt3(33076918435755799917625343, 57095833223235399068927667, 368166)
        );
        let v1 = fq_bigint3.mulf(
            x.v1,
            BigInt3(
                27116970078431962302577993, 47901374225073923994320622, 3656382694611191768409821
            ),
        );  // * nr2p2 / v^((p^2-1)/2)
        let v2 = fq_bigint3.mulf(
            x.v2,
            BigInt3(
                60193888514187762220203334, 27625954992973055882053025, 3656382694611191768777988
            ),
        );  // * nr2p4 / v^((p^2-1)/2)

        let v3 = fq_bigint3.mulf(
            x.v3, BigInt3(33076918435755799917625343, 57095833223235399068927667, 368166)
        );  // * 1 / v^((p^2-1)/2)

        let v4 = fq_bigint3.mulf(
            x.v4,
            BigInt3(
                27116970078431962302577993, 47901374225073923994320622, 3656382694611191768409821
            ),
        );  // * nr2p2 / v^((p^2-1)/2)

        let v5 = fq_bigint3.mulf(
            x.v5,
            BigInt3(
                60193888514187762220203334, 27625954992973055882053025, 3656382694611191768777988
            ),
        );  // * nr2p4 / v^((p^2-1)/2)

        local res: E6full = E6full(v0, v1, v2, v3, v4, v5);
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
    // Todo : Try to derive complete formulas and avoid conversion
    func frobenius_cube_torus_full{range_check_ptr}(x: E6full*) -> E6full* {
        alloc_locals;
        let x_gnark = v_to_gnark_reduced([x]);
        let frobenius = frobenius_cube_torus(x_gnark);
        let res = gnark_to_v(frobenius);
        return res;
    }

    func mul_torus{range_check_ptr, verify_mul6_array: VerifyMul6*, n_mul6: felt}(
        y1: E6full*, y2: E6full*
    ) -> E6full* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        // let num = mul_plus_one_b1(y1, y2);
        let num_min_v = mul_trick_e6(y1, y2);
        local num: E6full = E6full(
            num_min_v.v0,
            BigInt3(num_min_v.v1.d0 + 1, num_min_v.v1.d1, num_min_v.v1.d2),
            num_min_v.v2,
            num_min_v.v3,
            num_min_v.v4,
            num_min_v.v5,
        );
        // let den = add(y1, y2);
        local den: E6full = E6full(
            BigInt3(y1.v0.d0 + y2.v0.d0, y1.v0.d1 + y2.v0.d1, y1.v0.d2 + y2.v0.d2),
            BigInt3(y1.v1.d0 + y2.v1.d0, y1.v1.d1 + y2.v1.d1, y1.v1.d2 + y2.v1.d2),
            BigInt3(y1.v2.d0 + y2.v2.d0, y1.v2.d1 + y2.v2.d1, y1.v2.d2 + y2.v2.d2),
            BigInt3(y1.v3.d0 + y2.v3.d0, y1.v3.d1 + y2.v3.d1, y1.v3.d2 + y2.v3.d2),
            BigInt3(y1.v4.d0 + y2.v4.d0, y1.v4.d1 + y2.v4.d1, y1.v4.d2 + y2.v4.d2),
            BigInt3(y1.v5.d0 + y2.v5.d0, y1.v5.d1 + y2.v5.d1, y1.v5.d2 + y2.v5.d2),
        );
        let res = div_trick_e6(&num, &den);

        return res;
    }

    func expt_torus{range_check_ptr, verify_mul6_array: VerifyMul6*, n_mul6: felt}(
        x: E6full*
    ) -> E6full* {
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

    func inverse_torus{range_check_ptr}(x: E6full*) -> E6full* {
        return neg_full(x);
    }

    func square_torus{range_check_ptr, verify_mul6_array: VerifyMul6*, n_mul6: felt}(
        x: E6full*
    ) -> E6full* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local sq: E6full;

        %{
            from starkware.cairo.common.math_utils import as_int
            from src.bn254.hints import square_torus_e6, split
            from tools.py.extension_trick import flatten, v_to_gnark, gnark_to_v
            x=6*[0]
            x_refs = [ids.x.v0, ids.x.v1, ids.x.v2, ids.x.v3, ids.x.v4, ids.x.v5]
            for i in range(ids.N_LIMBS):
                for k in range(6):
                    x[k] += as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
            x_gnark = v_to_gnark(x)
            z = flatten(square_torus_e6(x_gnark))
            e = [split(x) for x in gnark_to_v(z)]

            for i in range(6):
                for k in range(ids.N_LIMBS):
                    rsetattr(ids.sq, f'v{i}.d{k}', e[i][k])
        %}
        assert_reduced_e6full(sq);

        // let v = double(&sq);
        // let v = sub(v, x);
        // local v_b0a0: BigInt3 = BigInt3(
        //     2 * sq0.d0 - x.b0.a0.d0, 2 * sq0.d1 - x.b0.a0.d1, 2 * sq0.d2 - x.b0.a0.d2
        // );
        // local v_b0a1: BigInt3 = BigInt3(
        //     2 * sq1.d0 - x.b0.a1.d0, 2 * sq1.d1 - x.b0.a1.d1, 2 * sq1.d2 - x.b0.a1.d2
        // );
        // local v_b1a0: BigInt3 = BigInt3(
        //     2 * sq2.d0 - x.b1.a0.d0, 2 * sq2.d1 - x.b1.a0.d1, 2 * sq2.d2 - x.b1.a0.d2
        // );
        // local v_b1a1: BigInt3 = BigInt3(
        //     2 * sq3.d0 - x.b1.a1.d0, 2 * sq3.d1 - x.b1.a1.d1, 2 * sq3.d2 - x.b1.a1.d2
        // );
        // local v_b2a0: BigInt3 = BigInt3(
        //     2 * sq4.d0 - x.b2.a0.d0, 2 * sq4.d1 - x.b2.a0.d1, 2 * sq4.d2 - x.b2.a0.d2
        // );
        // local v_b2a1: BigInt3 = BigInt3(
        //     2 * sq5.d0 - x.b2.a1.d0, 2 * sq5.d1 - x.b2.a1.d1, 2 * sq5.d2 - x.b2.a1.d2
        // );
        // local v_b0: E2 = E2(&v_b0a0, &v_b0a1);
        // local v_b1: E2 = E2(&v_b1a0, &v_b1a1);
        // local v_b2: E2 = E2(&v_b2a0, &v_b2a1);
        // local v_tmp: E6 = E6(&v_b0, &v_b1, &v_b2);

        local v_tmp: E6full = E6full(
            BigInt3(2 * sq.v0.d0 - x.v0.d0, 2 * sq.v0.d1 - x.v0.d1, 2 * sq.v0.d2 - x.v0.d2),
            BigInt3(2 * sq.v1.d0 - x.v1.d0, 2 * sq.v1.d1 - x.v1.d1, 2 * sq.v1.d2 - x.v1.d2),
            BigInt3(2 * sq.v2.d0 - x.v2.d0, 2 * sq.v2.d1 - x.v2.d1, 2 * sq.v2.d2 - x.v2.d2),
            BigInt3(2 * sq.v3.d0 - x.v3.d0, 2 * sq.v3.d1 - x.v3.d1, 2 * sq.v3.d2 - x.v3.d2),
            BigInt3(2 * sq.v4.d0 - x.v4.d0, 2 * sq.v4.d1 - x.v4.d1, 2 * sq.v4.d2 - x.v4.d2),
            BigInt3(2 * sq.v5.d0 - x.v5.d0, 2 * sq.v5.d1 - x.v5.d1, 2 * sq.v5.d2 - x.v5.d2),
        );

        let v = mul_trick_e6(&v_tmp, x);

        assert v.v0.d0 = 0;
        assert v.v0.d1 = 0;
        assert v.v0.d2 = 0;
        assert v.v1.d0 = 1;
        assert v.v1.d1 = 0;
        assert v.v1.d2 = 0;

        assert v.v2.d0 = 0;
        assert v.v2.d1 = 0;
        assert v.v2.d2 = 0;
        assert v.v3.d0 = 0;
        assert v.v3.d1 = 0;
        assert v.v3.d2 = 0;

        assert v.v4.d0 = 0;
        assert v.v4.d1 = 0;
        assert v.v4.d2 = 0;
        assert v.v5.d0 = 0;
        assert v.v5.d1 = 0;
        assert v.v5.d2 = 0;

        return &sq;
    }

    func n_square_torus{range_check_ptr, verify_mul6_array: VerifyMul6*, n_mul6: felt}(
        x: E6full*, n: felt
    ) -> E6full* {
        if (n == 0) {
            return x;
        } else {
            let res = square_torus(x);
            return n_square_torus(res, n - 1);
        }
    }
}

func gnark_to_v{range_check_ptr}(x: E6*) -> E6full* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    local res: E6full = E6full(
        BigInt3(
            x.b0.a0.d0 - 9 * x.b0.a1.d0, x.b0.a0.d1 - 9 * x.b0.a1.d1, x.b0.a0.d2 - 9 * x.b0.a1.d2
        ),
        BigInt3(
            x.b1.a0.d0 - 9 * x.b1.a1.d0, x.b1.a0.d1 - 9 * x.b1.a1.d1, x.b1.a0.d2 - 9 * x.b1.a1.d2
        ),
        BigInt3(
            x.b2.a0.d0 - 9 * x.b2.a1.d0, x.b2.a0.d1 - 9 * x.b2.a1.d1, x.b2.a0.d2 - 9 * x.b2.a1.d2
        ),
        BigInt3(x.b0.a1.d0, x.b0.a1.d1, x.b0.a1.d2),
        BigInt3(x.b1.a1.d0, x.b1.a1.d1, x.b1.a1.d2),
        BigInt3(x.b2.a1.d0, x.b2.a1.d1, x.b2.a1.d2),
    );
    return &res;
}
func gnark_to_v_reduced{range_check_ptr}(x: E6*) -> E6full* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    let v0 = reduce_3(
        UnreducedBigInt3(
            x.b0.a0.d0 - 9 * x.b0.a1.d0, x.b0.a0.d1 - 9 * x.b0.a1.d1, x.b0.a0.d2 - 9 * x.b0.a1.d2
        ),
    );

    let v1 = reduce_3(
        UnreducedBigInt3(
            x.b1.a0.d0 - 9 * x.b1.a1.d0, x.b1.a0.d1 - 9 * x.b1.a1.d1, x.b1.a0.d2 - 9 * x.b1.a1.d2
        ),
    );

    let v2 = reduce_3(
        UnreducedBigInt3(
            x.b2.a0.d0 - 9 * x.b2.a1.d0, x.b2.a0.d1 - 9 * x.b2.a1.d1, x.b2.a0.d2 - 9 * x.b2.a1.d2
        ),
    );

    local res: E6full = E6full([v0], [v1], [v2], [x.b0.a1], [x.b1.a1], [x.b2.a1]);
    return &res;
}

func v_to_gnark_reduced{range_check_ptr}(x: E6full) -> E6* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    let b0a0 = reduce_3(
        UnreducedBigInt3(x.v0.d0 + 9 * x.v3.d0, x.v0.d1 + 9 * x.v3.d1, x.v0.d2 + 9 * x.v3.d2)
    );

    let b1a0 = reduce_3(
        UnreducedBigInt3(x.v1.d0 + 9 * x.v4.d0, x.v1.d1 + 9 * x.v4.d1, x.v1.d2 + 9 * x.v4.d2)
    );

    let b2a0 = reduce_3(
        UnreducedBigInt3(x.v2.d0 + 9 * x.v5.d0, x.v2.d1 + 9 * x.v5.d1, x.v2.d2 + 9 * x.v5.d2)
    );

    local b0: E2 = E2(b0a0, &x.v3);
    local b1: E2 = E2(b1a0, &x.v4);
    local b2: E2 = E2(b2a0, &x.v5);

    local res: E6 = E6(&b0, &b1, &b2);
    return &res;
}

func poseidon_hash_e6{poseidon_ptr: PoseidonBuiltin*}(e6: E6full*) -> felt {
    assert poseidon_ptr.input = PoseidonBuiltinState(
        s0=e6.v0.d0 * e6.v0.d1, s1=e6.v0.d2 * e6.v1.d0, s2=2
    );
    assert poseidon_ptr[1].input = PoseidonBuiltinState(
        s0=e6.v1.d1 * e6.v1.d2, s1=poseidon_ptr[0].output.s0, s2=2
    );
    assert poseidon_ptr[2].input = PoseidonBuiltinState(
        s0=e6.v2.d0 * e6.v2.d1, s1=poseidon_ptr[1].output.s0, s2=2
    );
    assert poseidon_ptr[3].input = PoseidonBuiltinState(
        s0=e6.v2.d2 * e6.v3.d0, s1=poseidon_ptr[2].output.s0, s2=2
    );
    assert poseidon_ptr[4].input = PoseidonBuiltinState(
        s0=e6.v3.d1 * e6.v3.d2, s1=poseidon_ptr[3].output.s0, s2=2
    );
    assert poseidon_ptr[5].input = PoseidonBuiltinState(
        s0=e6.v4.d0 * e6.v4.d1, s1=poseidon_ptr[4].output.s0, s2=2
    );
    assert poseidon_ptr[6].input = PoseidonBuiltinState(
        s0=e6.v4.d2 * e6.v5.d0, s1=poseidon_ptr[5].output.s0, s2=2
    );
    assert poseidon_ptr[7].input = PoseidonBuiltinState(
        s0=e6.v5.d1 * e6.v5.d2, s1=poseidon_ptr[6].output.s0, s2=2
    );

    let res = poseidon_ptr[7].output.s0;
    let poseidon_ptr = poseidon_ptr + PoseidonBuiltin.SIZE * 8;

    return res;
}

func poseidon_hash_e5{poseidon_ptr: PoseidonBuiltin*}(e5: E5full*) -> felt {
    assert poseidon_ptr.input = PoseidonBuiltinState(s0=e5.v0.low, s1=e5.v0.high, s2=2);
    assert poseidon_ptr[1].input = PoseidonBuiltinState(
        s0=e5.v1.low, s1=poseidon_ptr[0].output.s0, s2=2
    );
    assert poseidon_ptr[2].input = PoseidonBuiltinState(
        s0=e5.v1.high, s1=poseidon_ptr[1].output.s0, s2=2
    );
    assert poseidon_ptr[3].input = PoseidonBuiltinState(
        s0=e5.v2.low, s1=poseidon_ptr[2].output.s0, s2=2
    );
    assert poseidon_ptr[4].input = PoseidonBuiltinState(
        s0=e5.v2.high, s1=poseidon_ptr[3].output.s0, s2=2
    );
    assert poseidon_ptr[5].input = PoseidonBuiltinState(
        s0=e5.v3.low, s1=poseidon_ptr[4].output.s0, s2=2
    );

    assert poseidon_ptr[6].input = PoseidonBuiltinState(
        s0=e5.v3.high, s1=poseidon_ptr[5].output.s0, s2=2
    );

    assert poseidon_ptr[7].input = PoseidonBuiltinState(
        s0=e5.v4.low, s1=poseidon_ptr[6].output.s0, s2=2
    );

    assert poseidon_ptr[8].input = PoseidonBuiltinState(
        s0=e5.v4.high, s1=poseidon_ptr[7].output.s0, s2=2
    );

    let res = poseidon_ptr[8].output.s0;
    let poseidon_ptr = poseidon_ptr + PoseidonBuiltin.SIZE * 9;

    return res;
}
func get_random_point_from_mul_e6_ops{
    poseidon_ptr: PoseidonBuiltin*, verify_mul6_array: VerifyMul6*
}(index: felt, res: felt) -> felt {
    alloc_locals;
    if (index == 0) {
        let random_point_0 = poseidon_hash_e6(verify_mul6_array[index].x);
        let random_point_1 = poseidon_hash_e6(verify_mul6_array[index].y);
        let random_point_2 = poseidon_hash_e5(verify_mul6_array[index].q);
        let random_point_3 = poseidon_hash_e6(verify_mul6_array[index].r);
        let (random_point_I) = poseidon_hash(random_point_0, random_point_1);
        let (random_point_II) = poseidon_hash(random_point_2, random_point_3);
        let (random_point) = poseidon_hash(random_point_I, random_point_II);
        let (random_point) = poseidon_hash(random_point, res);
        return random_point;
    } else {
        let random_point_0 = poseidon_hash_e6(verify_mul6_array[index].x);
        let random_point_1 = poseidon_hash_e6(verify_mul6_array[index].y);
        let random_point_2 = poseidon_hash_e5(verify_mul6_array[index].q);
        let random_point_3 = poseidon_hash_e6(verify_mul6_array[index].r);
        let (random_point_I) = poseidon_hash(random_point_0, random_point_1);
        let (random_point_II) = poseidon_hash(random_point_2, random_point_3);
        let (random_point) = poseidon_hash(random_point_I, random_point_II);
        let (random_point) = poseidon_hash(random_point, res);
        return get_random_point_from_mul_e6_ops(index=index - 1, res=random_point);
    }
}

func verify_e6_extension_tricks{
    range_check_ptr, poseidon_ptr: PoseidonBuiltin*, verify_mul6_array: VerifyMul6*
}(n_mul6: felt, z: BigInt3*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    let z_pow1_6: ZPowers6* = get_powers_of_z6(z);
    let p_of_z: BigInt3* = eval_unreduced_poly6(z_pow1_6);
    local zero_e6full: E6full = E6full(
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
        BigInt3(0, 0, 0),
    );

    local zero_e5full: E5full = E5full(
        Uint256(0, 0), Uint256(0, 0), Uint256(0, 0), Uint256(0, 0), Uint256(0, 0)
    );

    local zero_bigint5: UnreducedBigInt5 = UnreducedBigInt5(0, 0, 0, 0, 0);
    local equation_init: PolyAcc6 = PolyAcc6(xy=zero_bigint5, q=zero_e5full, r=zero_e6full);
    %{ print(f"accumulating {ids.n_mul6} Fp6 mul equations") %}

    let equation_acc = accumulate_polynomial_equations(n_mul6 - 1, &equation_init, z_pow1_6);

    let sum_r_of_z = eval_E6_unreduced(&equation_acc.r, z_pow1_6);

    // Check Σ(x(rnd) * y(rnd)) === Σ(q(rnd) * P(rnd)) + Σ(r(rnd)):
    let sum_q_of_z = eval_E5(&equation_acc.q, z_pow1_6);
    let (sum_qP_of_z) = bigint_mul([sum_q_of_z], [p_of_z]);
    verify_zero5(
        UnreducedBigInt5(
            d0=equation_acc.xy.d0 - sum_qP_of_z.d0 - sum_r_of_z.d0,
            d1=equation_acc.xy.d1 - sum_qP_of_z.d1 - sum_r_of_z.d1,
            d2=equation_acc.xy.d2 - sum_qP_of_z.d2 - sum_r_of_z.d2,
            d3=equation_acc.xy.d3 - sum_qP_of_z.d3 - sum_r_of_z.d3,
            d4=equation_acc.xy.d4 - sum_qP_of_z.d4 - sum_r_of_z.d4,
        ),
    );
    return ();
}
func eval_E6_unreduced{range_check_ptr}(e6: E6full*, powers: ZPowers6*) -> UnreducedBigInt5 {
    alloc_locals;
    let e0 = e6.v0;
    let (e1) = bigint_mul(e6.v1, powers.z_1);
    let (e2) = bigint_mul(e6.v2, powers.z_2);
    let (e3) = bigint_mul(e6.v3, powers.z_3);
    let (e4) = bigint_mul(e6.v4, powers.z_4);
    let (e5) = bigint_mul(e6.v5, powers.z_5);

    let res = UnreducedBigInt5(
        d0=e0.d0 + e1.d0 + e2.d0 + e3.d0 + e4.d0 + e5.d0,
        d1=e0.d1 + e1.d1 + e2.d1 + e3.d1 + e4.d1 + e5.d1,
        d2=e0.d2 + e1.d2 + e2.d2 + e3.d2 + e4.d2 + e5.d2,
        d3=e1.d3 + e2.d3 + e3.d3 + e4.d3 + e5.d3,
        d4=e1.d4 + e2.d4 + e3.d4 + e4.d4 + e5.d4,
    );
    return res;
}

func eval_E6{range_check_ptr}(e6: E6full*, powers: ZPowers6*) -> BigInt3* {
    alloc_locals;
    let e0 = e6.v0;
    let (e1) = bigint_mul(e6.v1, powers.z_1);
    let (e2) = bigint_mul(e6.v2, powers.z_2);
    let (e3) = bigint_mul(e6.v3, powers.z_3);
    let (e4) = bigint_mul(e6.v4, powers.z_4);
    let (e5) = bigint_mul(e6.v5, powers.z_5);

    let res = reduce_5(
        UnreducedBigInt5(
            d0=e0.d0 + e1.d0 + e2.d0 + e3.d0 + e4.d0 + e5.d0,
            d1=e0.d1 + e1.d1 + e2.d1 + e3.d1 + e4.d1 + e5.d1,
            d2=e0.d2 + e1.d2 + e2.d2 + e3.d2 + e4.d2 + e5.d2,
            d3=e1.d3 + e2.d3 + e3.d3 + e4.d3 + e5.d3,
            d4=e1.d4 + e2.d4 + e3.d4 + e4.d4 + e5.d4,
        ),
    );
    return res;
}

func eval_E5{range_check_ptr}(e5: E5full*, powers: ZPowers6*) -> BigInt3* {
    alloc_locals;
    let (v0) = unrededucedUint256_to_BigInt3(e5.v0);
    let (v1) = unrededucedUint256_to_BigInt3(e5.v1);
    let (v2) = unrededucedUint256_to_BigInt3(e5.v2);
    let (v3) = unrededucedUint256_to_BigInt3(e5.v3);
    let (v4) = unrededucedUint256_to_BigInt3(e5.v4);

    let e0 = v0;
    let (e1) = bigint_mul([v1], powers.z_1);
    let (e2) = bigint_mul([v2], powers.z_2);
    let (e3) = bigint_mul([v3], powers.z_3);
    let (e4) = bigint_mul([v4], powers.z_4);

    let res = reduce_5(
        UnreducedBigInt5(
            d0=e0.d0 + e1.d0 + e2.d0 + e3.d0 + e4.d0,
            d1=e0.d1 + e1.d1 + e2.d1 + e3.d1 + e4.d1,
            d2=e0.d2 + e1.d2 + e2.d2 + e3.d2 + e4.d2,
            d3=e1.d3 + e2.d3 + e3.d3 + e4.d3,
            d4=e1.d4 + e2.d4 + e3.d4 + e4.d4,
        ),
    );
    return res;
}
struct PolyAcc6 {
    xy: UnreducedBigInt5,
    q: E5full,
    r: E6full,
}
struct ZPowers6 {
    z_1: BigInt3,
    z_2: BigInt3,
    z_3: BigInt3,
    z_4: BigInt3,
    z_5: BigInt3,
    z_6: BigInt3,
}
func get_powers_of_z6{range_check_ptr}(z: BigInt3*) -> ZPowers6* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let z_2 = fq_bigint3.mul(z, z);
    let z_3 = fq_bigint3.mul(z_2, z);
    let z_4 = fq_bigint3.mul(z_3, z);
    let z_5 = fq_bigint3.mul(z_4, z);
    let z_6 = fq_bigint3.mul(z_5, z);

    local z_powers: ZPowers6 = ZPowers6(
        z_1=[z], z_2=[z_2], z_3=[z_3], z_4=[z_4], z_5=[z_5], z_6=[z_6]
    );
    return &z_powers;
}
// Accmulate relevant Σ terms in Σ(x(z) * y(z)) == Σ(q(z) * P(z)) + Σ(r(z))
// Since Σ(x*y) != Σ(x) * Σ(y), we need to accumulate the product of polynomials evaluated at z.
// For r, we can accumulate the polynomial coefficient directly and evaluate later.
// Since P(z) is constant, we can factor it out of the sum and accumulate q coefficients.:
// Σ(q(z) * P(z)) = P(z) * Σ(q(z))
// The equation becomes :
// Σ(x(z) * y(z)) = P(z) * Σ(q(z)) + Σ(r(z))
func accumulate_polynomial_equations{range_check_ptr, verify_mul6_array: VerifyMul6*}(
    index: felt, equation_acc: PolyAcc6*, z_pow1_6: ZPowers6*
) -> PolyAcc6* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    if (index == -1) {
        return equation_acc;
    } else {
        let x_of_z = eval_E6(verify_mul6_array[index].x, z_pow1_6);
        let y_of_z = eval_E6(verify_mul6_array[index].y, z_pow1_6);
        let (xy_acc) = bigint_mul([x_of_z], [y_of_z]);

        local equation_acc_new: PolyAcc6 = PolyAcc6(
            xy=UnreducedBigInt5(
                d0=equation_acc.xy.d0 + xy_acc.d0,
                d1=equation_acc.xy.d1 + xy_acc.d1,
                d2=equation_acc.xy.d2 + xy_acc.d2,
                d3=equation_acc.xy.d3 + xy_acc.d3,
                d4=equation_acc.xy.d4 + xy_acc.d4,
            ),
            q=E5full(
                Uint256(
                    verify_mul6_array[index].q.v0.low + equation_acc.q.v0.low,
                    verify_mul6_array[index].q.v0.high + equation_acc.q.v0.high,
                ),
                Uint256(
                    verify_mul6_array[index].q.v1.low + equation_acc.q.v1.low,
                    verify_mul6_array[index].q.v1.high + equation_acc.q.v1.high,
                ),
                Uint256(
                    verify_mul6_array[index].q.v2.low + equation_acc.q.v2.low,
                    verify_mul6_array[index].q.v2.high + equation_acc.q.v2.high,
                ),
                Uint256(
                    verify_mul6_array[index].q.v3.low + equation_acc.q.v3.low,
                    verify_mul6_array[index].q.v3.high + equation_acc.q.v3.high,
                ),
                Uint256(
                    verify_mul6_array[index].q.v4.low + equation_acc.q.v4.low,
                    verify_mul6_array[index].q.v4.high + equation_acc.q.v4.high,
                ),
            ),
            r=E6full(
                BigInt3(
                    verify_mul6_array[index].r.v0.d0 + equation_acc.r.v0.d0,
                    verify_mul6_array[index].r.v0.d1 + equation_acc.r.v0.d1,
                    verify_mul6_array[index].r.v0.d2 + equation_acc.r.v0.d2,
                ),
                BigInt3(
                    verify_mul6_array[index].r.v1.d0 + equation_acc.r.v1.d0,
                    verify_mul6_array[index].r.v1.d1 + equation_acc.r.v1.d1,
                    verify_mul6_array[index].r.v1.d2 + equation_acc.r.v1.d2,
                ),
                BigInt3(
                    verify_mul6_array[index].r.v2.d0 + equation_acc.r.v2.d0,
                    verify_mul6_array[index].r.v2.d1 + equation_acc.r.v2.d1,
                    verify_mul6_array[index].r.v2.d2 + equation_acc.r.v2.d2,
                ),
                BigInt3(
                    verify_mul6_array[index].r.v3.d0 + equation_acc.r.v3.d0,
                    verify_mul6_array[index].r.v3.d1 + equation_acc.r.v3.d1,
                    verify_mul6_array[index].r.v3.d2 + equation_acc.r.v3.d2,
                ),
                BigInt3(
                    verify_mul6_array[index].r.v4.d0 + equation_acc.r.v4.d0,
                    verify_mul6_array[index].r.v4.d1 + equation_acc.r.v4.d1,
                    verify_mul6_array[index].r.v4.d2 + equation_acc.r.v4.d2,
                ),
                BigInt3(
                    verify_mul6_array[index].r.v5.d0 + equation_acc.r.v5.d0,
                    verify_mul6_array[index].r.v5.d1 + equation_acc.r.v5.d1,
                    verify_mul6_array[index].r.v5.d2 + equation_acc.r.v5.d2,
                ),
            ),
        );
        return accumulate_polynomial_equations(index - 1, &equation_acc_new, z_pow1_6);
    }
}

func eval_unreduced_poly6{range_check_ptr}(powers: ZPowers6*) -> BigInt3* {
    alloc_locals;
    local v3: BigInt3 = BigInt3(
        60193888514187762220203317, 27625954992973055882053025, 3656382694611191768777988
    );  // -18 % p
    let (e3) = bigint_mul(v3, powers.z_3);

    let v6 = powers.z_6;

    let res = reduce_5(
        UnreducedBigInt5(
            d0=82 + e3.d0 + v6.d0, d1=e3.d1 + v6.d1, d2=e3.d2 + v6.d2, d3=e3.d3, d4=e3.d4
        ),
    );
    return res;
}

func assert_reduced_e6full{range_check_ptr}(x: E6full) {
    assert [range_check_ptr] = x.v0.d0;
    assert [range_check_ptr + 1] = x.v0.d1;
    assert [range_check_ptr + 2] = x.v0.d2;
    assert [range_check_ptr + 3] = BASE_MIN_1 - x.v0.d0;
    assert [range_check_ptr + 4] = BASE_MIN_1 - x.v0.d1;
    assert [range_check_ptr + 5] = P2 - x.v0.d2;
    assert [range_check_ptr + 6] = x.v1.d0;
    assert [range_check_ptr + 7] = x.v1.d1;
    assert [range_check_ptr + 8] = x.v1.d2;
    assert [range_check_ptr + 9] = BASE_MIN_1 - x.v1.d0;
    assert [range_check_ptr + 10] = BASE_MIN_1 - x.v1.d1;
    assert [range_check_ptr + 11] = P2 - x.v1.d2;
    assert [range_check_ptr + 12] = x.v2.d0;
    assert [range_check_ptr + 13] = x.v2.d1;
    assert [range_check_ptr + 14] = x.v2.d2;
    assert [range_check_ptr + 15] = BASE_MIN_1 - x.v2.d0;
    assert [range_check_ptr + 16] = BASE_MIN_1 - x.v2.d1;
    assert [range_check_ptr + 17] = P2 - x.v2.d2;
    assert [range_check_ptr + 18] = x.v3.d0;
    assert [range_check_ptr + 19] = x.v3.d1;
    assert [range_check_ptr + 20] = x.v3.d2;
    assert [range_check_ptr + 21] = BASE_MIN_1 - x.v3.d0;
    assert [range_check_ptr + 22] = BASE_MIN_1 - x.v3.d1;
    assert [range_check_ptr + 23] = P2 - x.v3.d2;
    assert [range_check_ptr + 24] = x.v4.d0;
    assert [range_check_ptr + 25] = x.v4.d1;
    assert [range_check_ptr + 26] = x.v4.d2;
    assert [range_check_ptr + 27] = BASE_MIN_1 - x.v4.d0;
    assert [range_check_ptr + 28] = BASE_MIN_1 - x.v4.d1;
    assert [range_check_ptr + 29] = P2 - x.v4.d2;
    assert [range_check_ptr + 30] = x.v5.d0;
    assert [range_check_ptr + 31] = x.v5.d1;
    assert [range_check_ptr + 32] = x.v5.d2;
    assert [range_check_ptr + 33] = BASE_MIN_1 - x.v5.d0;
    assert [range_check_ptr + 34] = BASE_MIN_1 - x.v5.d1;
    assert [range_check_ptr + 35] = P2 - x.v5.d2;

    if (x.v0.d2 == P2) {
        if (x.v0.d1 == P1) {
            assert [range_check_ptr + 36] = P0 - 1 - x.v0.d0;
            tempvar range_check_ptr = range_check_ptr + 37;
        } else {
            assert [range_check_ptr + 36] = P1 - 1 - x.v0.d1;
            tempvar range_check_ptr = range_check_ptr + 37;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr + 36;
    }

    if (x.v1.d2 == P2) {
        if (x.v1.d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - x.v1.d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - x.v1.d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (x.v2.d2 == P2) {
        if (x.v2.d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - x.v2.d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - x.v2.d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (x.v3.d2 == P2) {
        if (x.v3.d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - x.v3.d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - x.v3.d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (x.v4.d2 == P2) {
        if (x.v4.d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - x.v4.d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - x.v4.d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (x.v5.d2 == P2) {
        if (x.v5.d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - x.v5.d0;
            tempvar range_check_ptr = range_check_ptr + 1;
            return ();
        } else {
            assert [range_check_ptr] = P1 - 1 - x.v5.d1;
            tempvar range_check_ptr = range_check_ptr + 1;
            return ();
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
        return ();
    }
}
