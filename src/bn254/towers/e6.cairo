from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import SHIFT, Uint256

from src.bn254.towers.e2 import e2, E2
from src.bn254.fq import (
    BigInt3,
    reduce_3,
    UnreducedBigInt3,
    assert_reduced_felt,
    reduce_5,
    UnreducedBigInt5,
    BASE_MIN_1,
    fq_bigint3,
    unrededucedUint256_to_BigInt3,
    bigint_mul,
    verify_zero5,
    P1_256,
    P0_256,
)
from src.bn254.curve import N_LIMBS, DEGREE, BASE, P0, P1, P2, NON_RESIDUE_E2_a0, NON_RESIDUE_E2_a1
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.poseidon_state import PoseidonBuiltinState
from starkware.cairo.common.builtin_poseidon.poseidon import poseidon_hash

struct E6 {
    b0: E2*,
    b1: E2*,
    b2: E2*,
}

struct E6DirectUnreduced {
    v0: UnreducedBigInt3,
    v1: UnreducedBigInt3,
    v2: UnreducedBigInt3,
    v3: UnreducedBigInt3,
    v4: UnreducedBigInt3,
    v5: UnreducedBigInt3,
}

struct E5full {
    v0: Uint256,
    v1: Uint256,
    v2: Uint256,
    v3: Uint256,
    v4: Uint256,
}

struct E6full {
    v0: BigInt3,
    v1: BigInt3,
    v2: BigInt3,
    v3: BigInt3,
    v4: BigInt3,
    v5: BigInt3,
}

struct PolyAcc6 {
    xy: UnreducedBigInt3,
    q: E5full,
    r: E6DirectUnreduced,
}

// r is known in advance to be 1* v
struct PolyAccSquare6 {
    xy: UnreducedBigInt3,
    q: E5full,
    r: felt,
}

struct ZPowers5 {
    z_1: BigInt3,
    z_2: BigInt3,
    z_3: BigInt3,
    z_4: BigInt3,
    z_5: BigInt3,
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

func mul_trick_e6{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    z_pow1_5_ptr: ZPowers5*,
    continuable_hash: felt,
    poly_acc: PolyAcc6*,
}(x_ptr: E6full*, y_ptr: E6full*) -> E6full* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local x: E6full = [x_ptr];
    local y: E6full = [y_ptr];
    local z_pow1_5: ZPowers5 = [z_pow1_5_ptr];
    local r_v: E6full;
    local q_v: E5full;

    %{
        from tools.py.polynomial import Polynomial
        from tools.py.field import BaseFieldElement
        from src.bn254.curve import IRREDUCIBLE_POLY_6, field
        from src.hints.fq import pack_e6d
        from starkware.cairo.common.cairo_secp.secp_utils import split
        from tools.make.utils import split_128
        from tools.py.extension_trick import flatten, v_to_gnark, gnark_to_v, mul_e6, pack_e6

        x=pack_e6d(ids.x, ids.N_LIMBS, ids.BASE)
        y=pack_e6d(ids.y, ids.N_LIMBS, ids.BASE)
        x_poly = Polynomial([BaseFieldElement(xi, field) for xi in x])
        y_poly = Polynomial([BaseFieldElement(yi, field) for yi in y])
        z_poly = x_poly * y_poly
        z_polyr=z_poly % IRREDUCIBLE_POLY_6
        z_polyq=z_poly // IRREDUCIBLE_POLY_6
        z_polyr_coeffs = z_polyr.get_coeffs()
        z_polyq_coeffs = z_polyq.get_coeffs()
        assert len(z_polyq_coeffs) <= 5, f"len z_polyq_coeffs={len(z_polyq_coeffs)}, degree: {z_polyq.degree()}"
        assert len(z_polyr_coeffs) <= 6, f"len z_polyr_coeffs={len(z_polyr_coeffs)}, degree: {z_polyr.degree()}"
        z_polyq_coeffs = z_polyq_coeffs + [0] * (5 - len(z_polyq_coeffs))
        z_polyr_coeffs = z_polyr_coeffs + [0] * (6 - len(z_polyr_coeffs))

        for i in range(6):
            val = split(z_polyr_coeffs[i]%p)
            for k in range(ids.N_LIMBS):
                rsetattr(ids.r_v, f'v{i}.d{k}', val[k])
        for i in range(5):
            val = split_128(z_polyq_coeffs[i]%p)
            rsetattr(ids.q_v, f'v{i}.low', val[0])
            rsetattr(ids.q_v, f'v{i}.high', val[1])
    %}

    assert [range_check_ptr + 0] = r_v.v0.d0;
    assert [range_check_ptr + 1] = r_v.v0.d1;
    assert [range_check_ptr + 2] = r_v.v0.d2;
    assert [range_check_ptr + 3] = r_v.v1.d0;
    assert [range_check_ptr + 4] = r_v.v1.d1;
    assert [range_check_ptr + 5] = r_v.v1.d2;
    assert [range_check_ptr + 6] = r_v.v2.d0;
    assert [range_check_ptr + 7] = r_v.v2.d1;
    assert [range_check_ptr + 8] = r_v.v2.d2;
    assert [range_check_ptr + 9] = r_v.v3.d0;
    assert [range_check_ptr + 10] = r_v.v3.d1;
    assert [range_check_ptr + 11] = r_v.v3.d2;
    assert [range_check_ptr + 12] = r_v.v4.d0;
    assert [range_check_ptr + 13] = r_v.v4.d1;
    assert [range_check_ptr + 14] = r_v.v4.d2;
    assert [range_check_ptr + 15] = r_v.v5.d0;
    assert [range_check_ptr + 16] = r_v.v5.d1;
    assert [range_check_ptr + 17] = r_v.v5.d2;
    assert [range_check_ptr + 18] = q_v.v0.low;
    assert [range_check_ptr + 19] = q_v.v0.high;
    assert [range_check_ptr + 20] = q_v.v1.low;
    assert [range_check_ptr + 21] = q_v.v1.high;
    assert [range_check_ptr + 22] = q_v.v2.low;
    assert [range_check_ptr + 23] = q_v.v2.high;
    assert [range_check_ptr + 24] = q_v.v3.low;
    assert [range_check_ptr + 25] = q_v.v3.high;
    assert [range_check_ptr + 26] = q_v.v4.low;
    assert [range_check_ptr + 27] = q_v.v4.high;
    assert [range_check_ptr + 28] = 6 * 3 * BASE_MIN_1 - (
        r_v.v0.d0 +
        r_v.v0.d1 +
        r_v.v0.d2 +
        r_v.v1.d0 +
        r_v.v1.d1 +
        r_v.v1.d2 +
        r_v.v2.d0 +
        r_v.v2.d1 +
        r_v.v2.d2 +
        r_v.v3.d0 +
        r_v.v3.d1 +
        r_v.v3.d2 +
        r_v.v4.d0 +
        r_v.v4.d1 +
        r_v.v4.d2 +
        r_v.v5.d0 +
        r_v.v5.d1 +
        r_v.v5.d2
    );

    tempvar range_check_ptr = range_check_ptr + 29;

    tempvar two = 2;
    assert poseidon_ptr.input = PoseidonBuiltinState(
        s0=x.v0.d0 * x.v0.d1, s1=continuable_hash, s2=two
    );
    assert poseidon_ptr[1].input = PoseidonBuiltinState(
        s0=x.v0.d2 * x.v1.d0, s1=poseidon_ptr[0].output.s0, s2=two
    );
    assert poseidon_ptr[2].input = PoseidonBuiltinState(
        s0=x.v1.d1 * x.v1.d2, s1=poseidon_ptr[1].output.s0, s2=two
    );
    assert poseidon_ptr[3].input = PoseidonBuiltinState(
        s0=x.v2.d0 * x.v2.d1, s1=poseidon_ptr[2].output.s0, s2=two
    );
    assert poseidon_ptr[4].input = PoseidonBuiltinState(
        s0=x.v2.d2 * x.v3.d0, s1=poseidon_ptr[3].output.s0, s2=two
    );
    assert poseidon_ptr[5].input = PoseidonBuiltinState(
        s0=x.v3.d1 * x.v3.d2, s1=poseidon_ptr[4].output.s0, s2=two
    );
    assert poseidon_ptr[6].input = PoseidonBuiltinState(
        s0=x.v4.d0 * x.v4.d1, s1=poseidon_ptr[5].output.s0, s2=two
    );
    assert poseidon_ptr[7].input = PoseidonBuiltinState(
        s0=x.v4.d2 * x.v5.d0, s1=poseidon_ptr[6].output.s0, s2=two
    );
    assert poseidon_ptr[8].input = PoseidonBuiltinState(
        s0=x.v5.d1 * x.v5.d2, s1=poseidon_ptr[7].output.s0, s2=two
    );
    assert poseidon_ptr[9].input = PoseidonBuiltinState(
        s0=y.v0.d0 * y.v0.d1, s1=poseidon_ptr[8].output.s0, s2=two
    );
    assert poseidon_ptr[10].input = PoseidonBuiltinState(
        s0=y.v0.d2 * y.v1.d0, s1=poseidon_ptr[9].output.s0, s2=two
    );
    assert poseidon_ptr[11].input = PoseidonBuiltinState(
        s0=y.v1.d1 * y.v1.d2, s1=poseidon_ptr[10].output.s0, s2=two
    );
    assert poseidon_ptr[12].input = PoseidonBuiltinState(
        s0=y.v2.d0 * y.v2.d1, s1=poseidon_ptr[11].output.s0, s2=two
    );
    assert poseidon_ptr[13].input = PoseidonBuiltinState(
        s0=y.v2.d2 * y.v3.d0, s1=poseidon_ptr[12].output.s0, s2=two
    );
    assert poseidon_ptr[14].input = PoseidonBuiltinState(
        s0=y.v3.d1 * y.v3.d2, s1=poseidon_ptr[13].output.s0, s2=two
    );
    assert poseidon_ptr[15].input = PoseidonBuiltinState(
        s0=y.v4.d0 * y.v4.d1, s1=poseidon_ptr[14].output.s0, s2=two
    );
    assert poseidon_ptr[16].input = PoseidonBuiltinState(
        s0=y.v4.d2 * y.v5.d0, s1=poseidon_ptr[15].output.s0, s2=two
    );
    assert poseidon_ptr[17].input = PoseidonBuiltinState(
        s0=y.v5.d1 * y.v5.d2, s1=poseidon_ptr[16].output.s0, s2=two
    );
    assert poseidon_ptr[18].input = PoseidonBuiltinState(
        s0=q_v.v0.low * r_v.v0.d0, s1=poseidon_ptr[17].output.s0, s2=two
    );
    assert poseidon_ptr[19].input = PoseidonBuiltinState(
        s0=q_v.v0.high * r_v.v0.d1, s1=poseidon_ptr[18].output.s0, s2=two
    );
    assert poseidon_ptr[20].input = PoseidonBuiltinState(
        s0=q_v.v1.low * r_v.v0.d2, s1=poseidon_ptr[19].output.s0, s2=two
    );
    assert poseidon_ptr[21].input = PoseidonBuiltinState(
        s0=q_v.v1.high * r_v.v1.d0, s1=poseidon_ptr[20].output.s0, s2=two
    );
    assert poseidon_ptr[22].input = PoseidonBuiltinState(
        s0=q_v.v2.low * r_v.v1.d1, s1=poseidon_ptr[21].output.s0, s2=two
    );
    assert poseidon_ptr[23].input = PoseidonBuiltinState(
        s0=q_v.v2.high * r_v.v1.d2, s1=poseidon_ptr[22].output.s0, s2=two
    );
    assert poseidon_ptr[24].input = PoseidonBuiltinState(
        s0=q_v.v3.low * r_v.v2.d0, s1=poseidon_ptr[23].output.s0, s2=two
    );
    assert poseidon_ptr[25].input = PoseidonBuiltinState(
        s0=q_v.v3.high * r_v.v2.d1, s1=poseidon_ptr[24].output.s0, s2=two
    );
    assert poseidon_ptr[26].input = PoseidonBuiltinState(
        s0=q_v.v4.low * r_v.v2.d2, s1=poseidon_ptr[25].output.s0, s2=two
    );
    assert poseidon_ptr[27].input = PoseidonBuiltinState(
        s0=q_v.v4.high * r_v.v3.d0, s1=poseidon_ptr[26].output.s0, s2=two
    );
    assert poseidon_ptr[28].input = PoseidonBuiltinState(
        s0=r_v.v3.d1 * r_v.v3.d2, s1=poseidon_ptr[27].output.s0, s2=two
    );
    assert poseidon_ptr[29].input = PoseidonBuiltinState(
        s0=r_v.v4.d0 * r_v.v4.d1, s1=poseidon_ptr[28].output.s0, s2=two
    );
    assert poseidon_ptr[30].input = PoseidonBuiltinState(
        s0=r_v.v4.d2 * r_v.v5.d0, s1=poseidon_ptr[29].output.s0, s2=two
    );
    assert poseidon_ptr[31].input = PoseidonBuiltinState(
        s0=r_v.v5.d1 * r_v.v5.d2, s1=poseidon_ptr[30].output.s0, s2=two
    );

    tempvar x_of_z_v1: UnreducedBigInt5 = UnreducedBigInt5(
        x.v1.d0 * z_pow1_5.z_1.d0,
        x.v1.d0 * z_pow1_5.z_1.d1 + x.v1.d1 * z_pow1_5.z_1.d0,
        x.v1.d0 * z_pow1_5.z_1.d2 + x.v1.d1 * z_pow1_5.z_1.d1 + x.v1.d2 * z_pow1_5.z_1.d0,
        x.v1.d1 * z_pow1_5.z_1.d2 + x.v1.d2 * z_pow1_5.z_1.d1,
        x.v1.d2 * z_pow1_5.z_1.d2,
    );
    tempvar x_of_z_v2: UnreducedBigInt5 = UnreducedBigInt5(
        x.v2.d0 * z_pow1_5.z_2.d0,
        x.v2.d0 * z_pow1_5.z_2.d1 + x.v2.d1 * z_pow1_5.z_2.d0,
        x.v2.d0 * z_pow1_5.z_2.d2 + x.v2.d1 * z_pow1_5.z_2.d1 + x.v2.d2 * z_pow1_5.z_2.d0,
        x.v2.d1 * z_pow1_5.z_2.d2 + x.v2.d2 * z_pow1_5.z_2.d1,
        x.v2.d2 * z_pow1_5.z_2.d2,
    );
    tempvar x_of_z_v3: UnreducedBigInt5 = UnreducedBigInt5(
        x.v3.d0 * z_pow1_5.z_3.d0,
        x.v3.d0 * z_pow1_5.z_3.d1 + x.v3.d1 * z_pow1_5.z_3.d0,
        x.v3.d0 * z_pow1_5.z_3.d2 + x.v3.d1 * z_pow1_5.z_3.d1 + x.v3.d2 * z_pow1_5.z_3.d0,
        x.v3.d1 * z_pow1_5.z_3.d2 + x.v3.d2 * z_pow1_5.z_3.d1,
        x.v3.d2 * z_pow1_5.z_3.d2,
    );

    tempvar x_of_z_v4: UnreducedBigInt5 = UnreducedBigInt5(
        x.v4.d0 * z_pow1_5.z_4.d0,
        x.v4.d0 * z_pow1_5.z_4.d1 + x.v4.d1 * z_pow1_5.z_4.d0,
        x.v4.d0 * z_pow1_5.z_4.d2 + x.v4.d1 * z_pow1_5.z_4.d1 + x.v4.d2 * z_pow1_5.z_4.d0,
        x.v4.d1 * z_pow1_5.z_4.d2 + x.v4.d2 * z_pow1_5.z_4.d1,
        x.v4.d2 * z_pow1_5.z_4.d2,
    );
    tempvar x_of_z_v5: UnreducedBigInt5 = UnreducedBigInt5(
        x.v5.d0 * z_pow1_5.z_5.d0,
        x.v5.d0 * z_pow1_5.z_5.d1 + x.v5.d1 * z_pow1_5.z_5.d0,
        x.v5.d0 * z_pow1_5.z_5.d2 + x.v5.d1 * z_pow1_5.z_5.d1 + x.v5.d2 * z_pow1_5.z_5.d0,
        x.v5.d1 * z_pow1_5.z_5.d2 + x.v5.d2 * z_pow1_5.z_5.d1,
        x.v5.d2 * z_pow1_5.z_5.d2,
    );

    let x_of_z = reduce_5(
        UnreducedBigInt5(
            d0=x.v0.d0 + x_of_z_v1.d0 + x_of_z_v2.d0 + x_of_z_v3.d0 + x_of_z_v4.d0 + x_of_z_v5.d0,
            d1=x.v0.d1 + x_of_z_v1.d1 + x_of_z_v2.d1 + x_of_z_v3.d1 + x_of_z_v4.d1 + x_of_z_v5.d1,
            d2=x.v0.d2 + x_of_z_v1.d2 + x_of_z_v2.d2 + x_of_z_v3.d2 + x_of_z_v4.d2 + x_of_z_v5.d2,
            d3=x_of_z_v1.d3 + x_of_z_v2.d3 + x_of_z_v3.d3 + x_of_z_v4.d3 + x_of_z_v5.d3,
            d4=x_of_z_v1.d4 + x_of_z_v2.d4 + x_of_z_v3.d4 + x_of_z_v4.d4 + x_of_z_v5.d4,
        ),
    );

    tempvar y_of_z_v1: UnreducedBigInt5 = UnreducedBigInt5(
        y.v1.d0 * z_pow1_5.z_1.d0,
        y.v1.d0 * z_pow1_5.z_1.d1 + y.v1.d1 * z_pow1_5.z_1.d0,
        y.v1.d0 * z_pow1_5.z_1.d2 + y.v1.d1 * z_pow1_5.z_1.d1 + y.v1.d2 * z_pow1_5.z_1.d0,
        y.v1.d1 * z_pow1_5.z_1.d2 + y.v1.d2 * z_pow1_5.z_1.d1,
        y.v1.d2 * z_pow1_5.z_1.d2,
    );

    tempvar y_of_z_v2: UnreducedBigInt5 = UnreducedBigInt5(
        y.v2.d0 * z_pow1_5.z_2.d0,
        y.v2.d0 * z_pow1_5.z_2.d1 + y.v2.d1 * z_pow1_5.z_2.d0,
        y.v2.d0 * z_pow1_5.z_2.d2 + y.v2.d1 * z_pow1_5.z_2.d1 + y.v2.d2 * z_pow1_5.z_2.d0,
        y.v2.d1 * z_pow1_5.z_2.d2 + y.v2.d2 * z_pow1_5.z_2.d1,
        y.v2.d2 * z_pow1_5.z_2.d2,
    );

    tempvar y_of_z_v3: UnreducedBigInt5 = UnreducedBigInt5(
        y.v3.d0 * z_pow1_5.z_3.d0,
        y.v3.d0 * z_pow1_5.z_3.d1 + y.v3.d1 * z_pow1_5.z_3.d0,
        y.v3.d0 * z_pow1_5.z_3.d2 + y.v3.d1 * z_pow1_5.z_3.d1 + y.v3.d2 * z_pow1_5.z_3.d0,
        y.v3.d1 * z_pow1_5.z_3.d2 + y.v3.d2 * z_pow1_5.z_3.d1,
        y.v3.d2 * z_pow1_5.z_3.d2,
    );

    tempvar y_of_z_v4: UnreducedBigInt5 = UnreducedBigInt5(
        y.v4.d0 * z_pow1_5.z_4.d0,
        y.v4.d0 * z_pow1_5.z_4.d1 + y.v4.d1 * z_pow1_5.z_4.d0,
        y.v4.d0 * z_pow1_5.z_4.d2 + y.v4.d1 * z_pow1_5.z_4.d1 + y.v4.d2 * z_pow1_5.z_4.d0,
        y.v4.d1 * z_pow1_5.z_4.d2 + y.v4.d2 * z_pow1_5.z_4.d1,
        y.v4.d2 * z_pow1_5.z_4.d2,
    );

    tempvar y_of_z_v5: UnreducedBigInt5 = UnreducedBigInt5(
        y.v5.d0 * z_pow1_5.z_5.d0,
        y.v5.d0 * z_pow1_5.z_5.d1 + y.v5.d1 * z_pow1_5.z_5.d0,
        y.v5.d0 * z_pow1_5.z_5.d2 + y.v5.d1 * z_pow1_5.z_5.d1 + y.v5.d2 * z_pow1_5.z_5.d0,
        y.v5.d1 * z_pow1_5.z_5.d2 + y.v5.d2 * z_pow1_5.z_5.d1,
        y.v5.d2 * z_pow1_5.z_5.d2,
    );

    tempvar y_of_z_v5: UnreducedBigInt5 = UnreducedBigInt5(
        y.v5.d0 * z_pow1_5.z_5.d0,
        y.v5.d0 * z_pow1_5.z_5.d1 + y.v5.d1 * z_pow1_5.z_5.d0,
        y.v5.d0 * z_pow1_5.z_5.d2 + y.v5.d1 * z_pow1_5.z_5.d1 + y.v5.d2 * z_pow1_5.z_5.d0,
        y.v5.d1 * z_pow1_5.z_5.d2 + y.v5.d2 * z_pow1_5.z_5.d1,
        y.v5.d2 * z_pow1_5.z_5.d2,
    );

    let y_of_z = reduce_5(
        UnreducedBigInt5(
            d0=y.v0.d0 + y_of_z_v1.d0 + y_of_z_v2.d0 + y_of_z_v3.d0 + y_of_z_v4.d0 + y_of_z_v5.d0,
            d1=y.v0.d1 + y_of_z_v1.d1 + y_of_z_v2.d1 + y_of_z_v3.d1 + y_of_z_v4.d1 + y_of_z_v5.d1,
            d2=y.v0.d2 + y_of_z_v1.d2 + y_of_z_v2.d2 + y_of_z_v3.d2 + y_of_z_v4.d2 + y_of_z_v5.d2,
            d3=y_of_z_v1.d3 + y_of_z_v2.d3 + y_of_z_v3.d3 + y_of_z_v4.d3 + y_of_z_v5.d3,
            d4=y_of_z_v1.d4 + y_of_z_v2.d4 + y_of_z_v3.d4 + y_of_z_v4.d4 + y_of_z_v5.d4,
        ),
    );

    // let (xy_acc) = bigint_mul(x_of_z, y_of_z);
    let xy_acc = reduce_5(
        UnreducedBigInt5(
            d0=x_of_z.d0 * y_of_z.d0,
            d1=x_of_z.d0 * y_of_z.d1 + x_of_z.d1 * y_of_z.d0,
            d2=x_of_z.d0 * y_of_z.d2 + x_of_z.d1 * y_of_z.d1 + x_of_z.d2 * y_of_z.d0,
            d3=x_of_z.d1 * y_of_z.d2 + x_of_z.d2 * y_of_z.d1,
            d4=x_of_z.d2 * y_of_z.d2,
        ),
    );

    let poseidon_ptr = poseidon_ptr + 32 * PoseidonBuiltin.SIZE;
    let continuable_hash = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s0;
    let random_linear_combination_coeff = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s1;

    assert bitwise_ptr.x = random_linear_combination_coeff;
    assert bitwise_ptr.y = BASE_MIN_1;
    tempvar c_i = bitwise_ptr.x_and_y;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;

    local poly_acc_f: PolyAcc6 = PolyAcc6(
        xy=UnreducedBigInt3(
            d0=poly_acc.xy.d0 + c_i * xy_acc.d0,
            d1=poly_acc.xy.d1 + c_i * xy_acc.d1,
            d2=poly_acc.xy.d2 + c_i * xy_acc.d2,
        ),
        q=E5full(
            Uint256(c_i * q_v.v0.low + poly_acc.q.v0.low, c_i * q_v.v0.high + poly_acc.q.v0.high),
            Uint256(c_i * q_v.v1.low + poly_acc.q.v1.low, c_i * q_v.v1.high + poly_acc.q.v1.high),
            Uint256(c_i * q_v.v2.low + poly_acc.q.v2.low, c_i * q_v.v2.high + poly_acc.q.v2.high),
            Uint256(c_i * q_v.v3.low + poly_acc.q.v3.low, c_i * q_v.v3.high + poly_acc.q.v3.high),
            Uint256(c_i * q_v.v4.low + poly_acc.q.v4.low, c_i * q_v.v4.high + poly_acc.q.v4.high),
        ),
        r=E6DirectUnreduced(
            UnreducedBigInt3(
                c_i * r_v.v0.d0 + poly_acc.r.v0.d0,
                c_i * r_v.v0.d1 + poly_acc.r.v0.d1,
                c_i * r_v.v0.d2 + poly_acc.r.v0.d2,
            ),
            UnreducedBigInt3(
                c_i * r_v.v1.d0 + poly_acc.r.v1.d0,
                c_i * r_v.v1.d1 + poly_acc.r.v1.d1,
                c_i * r_v.v1.d2 + poly_acc.r.v1.d2,
            ),
            UnreducedBigInt3(
                c_i * r_v.v2.d0 + poly_acc.r.v2.d0,
                c_i * r_v.v2.d1 + poly_acc.r.v2.d1,
                c_i * r_v.v2.d2 + poly_acc.r.v2.d2,
            ),
            UnreducedBigInt3(
                c_i * r_v.v3.d0 + poly_acc.r.v3.d0,
                c_i * r_v.v3.d1 + poly_acc.r.v3.d1,
                c_i * r_v.v3.d2 + poly_acc.r.v3.d2,
            ),
            UnreducedBigInt3(
                c_i * r_v.v4.d0 + poly_acc.r.v4.d0,
                c_i * r_v.v4.d1 + poly_acc.r.v4.d1,
                c_i * r_v.v4.d2 + poly_acc.r.v4.d2,
            ),
            UnreducedBigInt3(
                c_i * r_v.v5.d0 + poly_acc.r.v5.d0,
                c_i * r_v.v5.d1 + poly_acc.r.v5.d1,
                c_i * r_v.v5.d2 + poly_acc.r.v5.d2,
            ),
        ),
    );
    let poly_acc = &poly_acc_f;
    return &r_v;
}

func div_trick_e6{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    z_pow1_5_ptr: ZPowers5*,
    continuable_hash: felt,
    poly_acc: PolyAcc6*,
}(x: E6full*, y: E6full*) -> E6full* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    // local div: E6full;
    tempvar div_start = range_check_ptr;
    let div_v0d0 = [range_check_ptr];
    let div_v0d1 = [range_check_ptr + 1];
    let div_v0d2 = [range_check_ptr + 2];
    let div_v1d0 = [range_check_ptr + 3];
    let div_v1d1 = [range_check_ptr + 4];
    let div_v1d2 = [range_check_ptr + 5];
    let div_v2d0 = [range_check_ptr + 6];
    let div_v2d1 = [range_check_ptr + 7];
    let div_v2d2 = [range_check_ptr + 8];
    let div_v3d0 = [range_check_ptr + 9];
    let div_v3d1 = [range_check_ptr + 10];
    let div_v3d2 = [range_check_ptr + 11];
    let div_v4d0 = [range_check_ptr + 12];
    let div_v4d1 = [range_check_ptr + 13];
    let div_v4d2 = [range_check_ptr + 14];
    let div_v5d0 = [range_check_ptr + 15];
    let div_v5d1 = [range_check_ptr + 16];
    let div_v5d2 = [range_check_ptr + 17];

    %{
        from starkware.cairo.common.math_utils import as_int
        from src.hints.fq import bigint_split, bigint_pack
        from tools.py.extension_trick import flatten, v_to_gnark, gnark_to_v, div_e6, pack_e6

        x, y = [], []
        for i in range(6):
            x.append(bigint_pack(getattr(ids.x, 'v'+str(i)), ids.N_LIMBS, ids.BASE))
            y.append(bigint_pack(getattr(ids.y, 'v'+str(i)), ids.N_LIMBS, ids.BASE))

        x_gnark, y_gnark = pack_e6(v_to_gnark(x)), pack_e6(v_to_gnark(y))
        z = flatten(div_e6(x_gnark, y_gnark))
        z = gnark_to_v(z)
        e = [bigint_split(x, ids.N_LIMBS, ids.BASE) for x in z]
                                                      
        for i in range(6):
            for k in range(ids.N_LIMBS):
                setattr(ids, f'div_v{i}d{k}', e[i][k])
    %}

    // assert_reduced_e6full(div);
    let div: E6full* = cast(div_start, E6full*);
    assert [range_check_ptr + 18] = BASE_MIN_1 - div_v0d0;
    assert [range_check_ptr + 19] = BASE_MIN_1 - div_v0d1;
    assert [range_check_ptr + 20] = P2 - div_v0d2;
    assert [range_check_ptr + 21] = BASE_MIN_1 - div_v1d0;
    assert [range_check_ptr + 22] = BASE_MIN_1 - div_v1d1;
    assert [range_check_ptr + 23] = P2 - div_v1d2;
    assert [range_check_ptr + 24] = BASE_MIN_1 - div_v2d0;
    assert [range_check_ptr + 25] = BASE_MIN_1 - div_v2d1;
    assert [range_check_ptr + 26] = P2 - div_v2d2;
    assert [range_check_ptr + 27] = BASE_MIN_1 - div_v3d0;
    assert [range_check_ptr + 28] = BASE_MIN_1 - div_v3d1;
    assert [range_check_ptr + 29] = P2 - div_v3d2;
    assert [range_check_ptr + 30] = BASE_MIN_1 - div_v4d0;
    assert [range_check_ptr + 31] = BASE_MIN_1 - div_v4d1;
    assert [range_check_ptr + 32] = P2 - div_v4d2;
    assert [range_check_ptr + 33] = BASE_MIN_1 - div_v5d0;
    assert [range_check_ptr + 34] = BASE_MIN_1 - div_v5d1;
    assert [range_check_ptr + 35] = P2 - div_v5d2;

    if (div_v0d2 == P2) {
        if (div_v0d1 == P1) {
            assert [range_check_ptr + 36] = P0 - 1 - div_v0d0;
            tempvar range_check_ptr = range_check_ptr + 37;
        } else {
            assert [range_check_ptr + 36] = P1 - 1 - div_v0d1;
            tempvar range_check_ptr = range_check_ptr + 37;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr + 36;
    }

    if (div_v1d2 == P2) {
        if (div_v1d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - div_v1d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - div_v1d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (div_v2d2 == P2) {
        if (div_v2d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - div_v2d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - div_v2d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (div_v3d2 == P2) {
        if (div_v3d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - div_v3d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - div_v3d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (div_v4d2 == P2) {
        if (div_v4d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - div_v4d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - div_v4d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (div_v5d2 == P2) {
        if (div_v5d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - div_v5d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - div_v5d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    let check = mul_trick_e6(y, div);

    assert_E6full(x, check);

    return div;
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
        let v0 = fq_bigint3.add(x.v0, y.v0);
        let v1 = fq_bigint3.add(x.v1, y.v1);
        let v2 = fq_bigint3.add(x.v2, y.v2);
        let v3 = fq_bigint3.add(x.v3, y.v3);
        let v4 = fq_bigint3.add(x.v4, y.v4);
        let v5 = fq_bigint3.add(x.v5, y.v5);
        local res: E6full = E6full(v0, v1, v2, v3, v4, v5);
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
        let v0 = fq_bigint3.neg(x.v0);
        let v1 = fq_bigint3.neg(x.v1);
        let v2 = fq_bigint3.neg(x.v2);
        let v3 = fq_bigint3.neg(x.v3);
        let v4 = fq_bigint3.neg(x.v4);
        let v5 = fq_bigint3.neg(x.v5);
        local res: E6full = E6full(v0, v1, v2, v3, v4, v5);
        return &res;
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
        local v0: E2 = E2(v0_a0, v0_a1);

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
    // func frobenius_square_torus{range_check_ptr}(x: E6*) -> E6* {
    //     alloc_locals;
    //     let (__fp__, _) = get_fp_and_pc();

    // local v0: BigInt3 = BigInt3(33076918435755799917625343, 57095833223235399068927667, 368166);
    //     let t0 = e2.mul_by_element(&v0, x.b0);
    //     let t1 = e2.mul_by_non_residue_2_power_2(x.b1);
    //     let t1 = e2.mul_by_element(&v0, t1);
    //     let t2 = e2.mul_by_non_residue_2_power_4(x.b2);
    //     let t2 = e2.mul_by_element(&v0, t2);

    // local res: E6 = E6(t0, t1, t2);
    //     return &res;
    // }

    // FrobeniusSquareTorus raises a compressed elements x ∈ E6 to the square modulus p^2
    // and returns x^(p^2) / v^((p^2-1)/2)
    func frobenius_square_torus_full{range_check_ptr}(x: E6full*) -> E6full* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        // v0 = 2203960485148121921418603742825762020974279258880205651967
        // v0*nr2p2 = 21888242871839275220042445260109153167277707414472061641714758635765020556617
        // v0*nr2p4 = 21888242871839275222246405745257275088696311157297823662689037894645226208582

        let v0 = fq_bigint3.mul(
            x.v0, BigInt3(33076918435755799917625343, 57095833223235399068927667, 368166)
        );
        let v1 = fq_bigint3.mul(
            x.v1,
            BigInt3(
                27116970078431962302577993, 47901374225073923994320622, 3656382694611191768409821
            ),
        );  // * nr2p2 / v^((p^2-1)/2)
        let v2 = fq_bigint3.mul(
            x.v2,
            BigInt3(
                60193888514187762220203334, 27625954992973055882053025, 3656382694611191768777988
            ),
        );  // * nr2p4 / v^((p^2-1)/2)

        let v3 = fq_bigint3.mul(
            x.v3, BigInt3(33076918435755799917625343, 57095833223235399068927667, 368166)
        );  // * 1 / v^((p^2-1)/2)

        let v4 = fq_bigint3.mul(
            x.v4,
            BigInt3(
                27116970078431962302577993, 47901374225073923994320622, 3656382694611191768409821
            ),
        );  // * nr2p2 / v^((p^2-1)/2)

        let v5 = fq_bigint3.mul(
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

        local v0: E2 = E2(v0_a0, v0_a1);

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

    func mul_torus{
        range_check_ptr,
        bitwise_ptr: BitwiseBuiltin*,
        poseidon_ptr: PoseidonBuiltin*,
        z_pow1_5_ptr: ZPowers5*,
        continuable_hash: felt,
        poly_acc: PolyAcc6*,
    }(y1: E6full*, y2: E6full*) -> E6full* {
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

    func expt_torus{
        range_check_ptr,
        bitwise_ptr: BitwiseBuiltin*,
        poseidon_ptr: PoseidonBuiltin*,
        z_pow1_5_ptr: ZPowers5*,
        continuable_hash: felt,
        poly_acc_sq: PolyAccSquare6*,
        poly_acc: PolyAcc6*,
    }(x: E6full*) -> E6full* {
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

    func square_torus{
        range_check_ptr,
        bitwise_ptr: BitwiseBuiltin*,
        poseidon_ptr: PoseidonBuiltin*,
        z_pow1_5_ptr: ZPowers5*,
        continuable_hash: felt,
        poly_acc_sq: PolyAccSquare6*,
    }(x_ptr: E6full*) -> E6full* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local x: E6full = [x_ptr];
        local z_pow1_5: ZPowers5 = [z_pow1_5_ptr];
        local sq: E6full;
        local q_v: E5full;
        tempvar two = 2;

        %{
            from starkware.cairo.common.math_utils import as_int
            from tools.py.extension_trick import flatten, v_to_gnark, gnark_to_v, square_torus_e6
            x=6*[0]
            x_refs = [ids.x.v0, ids.x.v1, ids.x.v2, ids.x.v3, ids.x.v4, ids.x.v5]
            for i in range(ids.N_LIMBS):
                for k in range(6):
                    x[k] += as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
            x_gnark = pack_e6(v_to_gnark(x))

            z = gnark_to_v(flatten(square_torus_e6(x_gnark)))
            for i, e in enumerate(z):
                bigint_fill(e, getattr(ids.sq, 'v'+str(i)), ids.N_LIMBS, ids.BASE)
        %}
        tempvar v_tmp: E6full = E6full(
            BigInt3(two * sq.v0.d0 - x.v0.d0, two * sq.v0.d1 - x.v0.d1, two * sq.v0.d2 - x.v0.d2),
            BigInt3(two * sq.v1.d0 - x.v1.d0, two * sq.v1.d1 - x.v1.d1, two * sq.v1.d2 - x.v1.d2),
            BigInt3(two * sq.v2.d0 - x.v2.d0, two * sq.v2.d1 - x.v2.d1, two * sq.v2.d2 - x.v2.d2),
            BigInt3(two * sq.v3.d0 - x.v3.d0, two * sq.v3.d1 - x.v3.d1, two * sq.v3.d2 - x.v3.d2),
            BigInt3(two * sq.v4.d0 - x.v4.d0, two * sq.v4.d1 - x.v4.d1, two * sq.v4.d2 - x.v4.d2),
            BigInt3(two * sq.v5.d0 - x.v5.d0, two * sq.v5.d1 - x.v5.d1, two * sq.v5.d2 - x.v5.d2),
        );
        %{
            from tools.py.polynomial import Polynomial
            from src.bn254.curve import IRREDUCIBLE_POLY_6, field
            from tools.py.field import BaseFieldElement, BaseField
            from starkware.cairo.common.cairo_secp.secp_utils import split
            from tools.make.utils import split_128

            x=[0]*6
            y=[0]*6
            x_refs = [ids.v_tmp.v0, ids.v_tmp.v1, ids.v_tmp.v2, ids.v_tmp.v3, ids.v_tmp.v4, ids.v_tmp.v5]
            y_refs = [ids.x.v0, ids.x.v1, ids.x.v2, ids.x.v3, ids.x.v4, ids.x.v5]
            for i in range(ids.N_LIMBS):
                for k in range(6):
                    x[k] += as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
                    y[k] += as_int(getattr(y_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
            x_poly = Polynomial([BaseFieldElement(x[i], field) for i in range(6)])
            y_poly = Polynomial([BaseFieldElement(y[i], field) for i in range(6)])
            z_poly = x_poly * y_poly
            # v^6 - 18v^3 + 82 
            z_polyr=z_poly % IRREDUCIBLE_POLY_6
            z_polyq=z_poly // IRREDUCIBLE_POLY_6
            z_polyr_coeffs = z_polyr.get_coeffs()
            z_polyq_coeffs = z_polyq.get_coeffs()
            assert len(z_polyq_coeffs) <= 5, f"len z_polyq_coeffs={len(z_polyq_coeffs)}, degree: {z_polyq.degree()}"
            assert len(z_polyr_coeffs) <= 6, f"len z_polyr_coeffs={len(z_polyr_coeffs)}, degree: {z_polyr.degree()}"
            z_polyq_coeffs = z_polyq_coeffs + [0] * (5 - len(z_polyq_coeffs))
            z_polyr_coeffs = z_polyr_coeffs + [0] * (6 - len(z_polyr_coeffs))
            for i in range(5):
                val = split_128(z_polyq_coeffs[i]%p)
                rsetattr(ids.q_v, f'v{i}.low', val[0])
                rsetattr(ids.q_v, f'v{i}.high', val[1])
        %}
        assert [range_check_ptr + 0] = sq.v0.d0;
        assert [range_check_ptr + 1] = sq.v0.d1;
        assert [range_check_ptr + 2] = sq.v0.d2;
        assert [range_check_ptr + 3] = sq.v1.d0;
        assert [range_check_ptr + 4] = sq.v1.d1;
        assert [range_check_ptr + 5] = sq.v1.d2;
        assert [range_check_ptr + 6] = sq.v2.d0;
        assert [range_check_ptr + 7] = sq.v2.d1;
        assert [range_check_ptr + 8] = sq.v2.d2;
        assert [range_check_ptr + 9] = sq.v3.d0;
        assert [range_check_ptr + 10] = sq.v3.d1;
        assert [range_check_ptr + 11] = sq.v3.d2;
        assert [range_check_ptr + 12] = sq.v4.d0;
        assert [range_check_ptr + 13] = sq.v4.d1;
        assert [range_check_ptr + 14] = sq.v4.d2;
        assert [range_check_ptr + 15] = sq.v5.d0;
        assert [range_check_ptr + 16] = sq.v5.d1;
        assert [range_check_ptr + 17] = sq.v5.d2;
        assert [range_check_ptr + 18] = q_v.v0.low;
        assert [range_check_ptr + 19] = q_v.v0.high;
        assert [range_check_ptr + 20] = q_v.v1.low;
        assert [range_check_ptr + 21] = q_v.v1.high;
        assert [range_check_ptr + 22] = q_v.v2.low;
        assert [range_check_ptr + 23] = q_v.v2.high;
        assert [range_check_ptr + 24] = q_v.v3.low;
        assert [range_check_ptr + 25] = q_v.v3.high;
        assert [range_check_ptr + 26] = q_v.v4.low;
        assert [range_check_ptr + 27] = q_v.v4.high;
        assert [range_check_ptr + 28] = 6 * 3 * BASE_MIN_1 - (
            sq.v0.d0 +
            sq.v0.d1 +
            sq.v0.d2 +
            sq.v1.d0 +
            sq.v1.d1 +
            sq.v1.d2 +
            sq.v2.d0 +
            sq.v2.d1 +
            sq.v2.d2 +
            sq.v3.d0 +
            sq.v3.d1 +
            sq.v3.d2 +
            sq.v4.d0 +
            sq.v4.d1 +
            sq.v4.d2 +
            sq.v5.d0 +
            sq.v5.d1 +
            sq.v5.d2
        );

        tempvar range_check_ptr = range_check_ptr + 29;

        assert poseidon_ptr.input = PoseidonBuiltinState(
            s0=v_tmp.v0.d0 * v_tmp.v0.d1, s1=continuable_hash, s2=two
        );
        assert poseidon_ptr[1].input = PoseidonBuiltinState(
            s0=v_tmp.v0.d2 * v_tmp.v1.d0, s1=poseidon_ptr[0].output.s0, s2=two
        );
        assert poseidon_ptr[2].input = PoseidonBuiltinState(
            s0=v_tmp.v1.d1 * v_tmp.v1.d2, s1=poseidon_ptr[1].output.s0, s2=two
        );

        assert poseidon_ptr[3].input = PoseidonBuiltinState(
            s0=v_tmp.v2.d0 * v_tmp.v2.d1, s1=poseidon_ptr[2].output.s0, s2=two
        );

        assert poseidon_ptr[4].input = PoseidonBuiltinState(
            s0=v_tmp.v2.d2 * v_tmp.v3.d0, s1=poseidon_ptr[3].output.s0, s2=two
        );

        assert poseidon_ptr[5].input = PoseidonBuiltinState(
            s0=v_tmp.v3.d1 * v_tmp.v3.d2, s1=poseidon_ptr[4].output.s0, s2=two
        );

        assert poseidon_ptr[6].input = PoseidonBuiltinState(
            s0=v_tmp.v4.d0 * v_tmp.v4.d1, s1=poseidon_ptr[5].output.s0, s2=two
        );

        assert poseidon_ptr[7].input = PoseidonBuiltinState(
            s0=v_tmp.v4.d2 * v_tmp.v5.d0, s1=poseidon_ptr[6].output.s0, s2=two
        );

        assert poseidon_ptr[8].input = PoseidonBuiltinState(
            s0=v_tmp.v5.d1 * v_tmp.v5.d2, s1=poseidon_ptr[7].output.s0, s2=two
        );
        assert poseidon_ptr[9].input = PoseidonBuiltinState(
            s0=x.v0.d0 * q_v.v0.low, s1=poseidon_ptr[8].output.s0, s2=two
        );

        assert poseidon_ptr[10].input = PoseidonBuiltinState(
            s0=x.v0.d1 * q_v.v0.high, s1=poseidon_ptr[9].output.s0, s2=two
        );

        assert poseidon_ptr[11].input = PoseidonBuiltinState(
            s0=x.v0.d2 * q_v.v1.low, s1=poseidon_ptr[10].output.s0, s2=two
        );

        assert poseidon_ptr[12].input = PoseidonBuiltinState(
            s0=x.v1.d0 * q_v.v1.high, s1=poseidon_ptr[11].output.s0, s2=two
        );

        assert poseidon_ptr[13].input = PoseidonBuiltinState(
            s0=x.v1.d1 * q_v.v2.low, s1=poseidon_ptr[12].output.s0, s2=two
        );

        assert poseidon_ptr[14].input = PoseidonBuiltinState(
            s0=x.v1.d2 * q_v.v2.high, s1=poseidon_ptr[13].output.s0, s2=two
        );

        assert poseidon_ptr[15].input = PoseidonBuiltinState(
            s0=x.v2.d0 * q_v.v3.low, s1=poseidon_ptr[14].output.s0, s2=two
        );

        assert poseidon_ptr[16].input = PoseidonBuiltinState(
            s0=x.v2.d1 * q_v.v3.high, s1=poseidon_ptr[15].output.s0, s2=two
        );

        assert poseidon_ptr[17].input = PoseidonBuiltinState(
            s0=x.v2.d2 * q_v.v4.low, s1=poseidon_ptr[16].output.s0, s2=two
        );
        assert poseidon_ptr[18].input = PoseidonBuiltinState(
            s0=x.v3.d0 * q_v.v4.high, s1=poseidon_ptr[17].output.s0, s2=two
        );
        assert poseidon_ptr[19].input = PoseidonBuiltinState(
            s0=x.v3.d1 * x.v3.d2, s1=poseidon_ptr[18].output.s0, s2=two
        );
        assert poseidon_ptr[20].input = PoseidonBuiltinState(
            s0=x.v4.d0 * x.v4.d1, s1=poseidon_ptr[19].output.s0, s2=two
        );
        assert poseidon_ptr[21].input = PoseidonBuiltinState(
            s0=x.v4.d2 * x.v5.d0, s1=poseidon_ptr[20].output.s0, s2=two
        );
        assert poseidon_ptr[22].input = PoseidonBuiltinState(
            s0=x.v5.d1 * x.v5.d2, s1=poseidon_ptr[21].output.s0, s2=two
        );

        tempvar x_of_z_v1 = UnreducedBigInt5(
            d0=x.v1.d0 * z_pow1_5.z_1.d0,
            d1=x.v1.d0 * z_pow1_5.z_1.d1 + x.v1.d1 * z_pow1_5.z_1.d0,
            d2=x.v1.d0 * z_pow1_5.z_1.d2 + x.v1.d1 * z_pow1_5.z_1.d1 + x.v1.d2 * z_pow1_5.z_1.d0,
            d3=x.v1.d1 * z_pow1_5.z_1.d2 + x.v1.d2 * z_pow1_5.z_1.d1,
            d4=x.v1.d2 * z_pow1_5.z_1.d2,
        );

        tempvar x_of_z_v2 = UnreducedBigInt5(
            d0=x.v2.d0 * z_pow1_5.z_2.d0,
            d1=x.v2.d0 * z_pow1_5.z_2.d1 + x.v2.d1 * z_pow1_5.z_2.d0,
            d2=x.v2.d0 * z_pow1_5.z_2.d2 + x.v2.d1 * z_pow1_5.z_2.d1 + x.v2.d2 * z_pow1_5.z_2.d0,
            d3=x.v2.d1 * z_pow1_5.z_2.d2 + x.v2.d2 * z_pow1_5.z_2.d1,
            d4=x.v2.d2 * z_pow1_5.z_2.d2,
        );

        tempvar x_of_z_v3 = UnreducedBigInt5(
            d0=x.v3.d0 * z_pow1_5.z_3.d0,
            d1=x.v3.d0 * z_pow1_5.z_3.d1 + x.v3.d1 * z_pow1_5.z_3.d0,
            d2=x.v3.d0 * z_pow1_5.z_3.d2 + x.v3.d1 * z_pow1_5.z_3.d1 + x.v3.d2 * z_pow1_5.z_3.d0,
            d3=x.v3.d1 * z_pow1_5.z_3.d2 + x.v3.d2 * z_pow1_5.z_3.d1,
            d4=x.v3.d2 * z_pow1_5.z_3.d2,
        );

        tempvar x_of_z_v4 = UnreducedBigInt5(
            d0=x.v4.d0 * z_pow1_5.z_4.d0,
            d1=x.v4.d0 * z_pow1_5.z_4.d1 + x.v4.d1 * z_pow1_5.z_4.d0,
            d2=x.v4.d0 * z_pow1_5.z_4.d2 + x.v4.d1 * z_pow1_5.z_4.d1 + x.v4.d2 * z_pow1_5.z_4.d0,
            d3=x.v4.d1 * z_pow1_5.z_4.d2 + x.v4.d2 * z_pow1_5.z_4.d1,
            d4=x.v4.d2 * z_pow1_5.z_4.d2,
        );

        tempvar x_of_z_v5 = UnreducedBigInt5(
            d0=x.v5.d0 * z_pow1_5.z_5.d0,
            d1=x.v5.d0 * z_pow1_5.z_5.d1 + x.v5.d1 * z_pow1_5.z_5.d0,
            d2=x.v5.d0 * z_pow1_5.z_5.d2 + x.v5.d1 * z_pow1_5.z_5.d1 + x.v5.d2 * z_pow1_5.z_5.d0,
            d3=x.v5.d1 * z_pow1_5.z_5.d2 + x.v5.d2 * z_pow1_5.z_5.d1,
            d4=x.v5.d2 * z_pow1_5.z_5.d2,
        );

        let x_of_z = reduce_5(
            UnreducedBigInt5(
                d0=x.v0.d0 + x_of_z_v1.d0 + x_of_z_v2.d0 + x_of_z_v3.d0 + x_of_z_v4.d0 +
                x_of_z_v5.d0,
                d1=x.v0.d1 + x_of_z_v1.d1 + x_of_z_v2.d1 + x_of_z_v3.d1 + x_of_z_v4.d1 +
                x_of_z_v5.d1,
                d2=x.v0.d2 + x_of_z_v1.d2 + x_of_z_v2.d2 + x_of_z_v3.d2 + x_of_z_v4.d2 +
                x_of_z_v5.d2,
                d3=x_of_z_v1.d3 + x_of_z_v2.d3 + x_of_z_v3.d3 + x_of_z_v4.d3 + x_of_z_v5.d3,
                d4=x_of_z_v1.d4 + x_of_z_v2.d4 + x_of_z_v3.d4 + x_of_z_v4.d4 + x_of_z_v5.d4,
            ),
        );

        tempvar y_of_z_v1 = UnreducedBigInt5(
            d0=v_tmp.v1.d0 * z_pow1_5.z_1.d0,
            d1=v_tmp.v1.d0 * z_pow1_5.z_1.d1 + v_tmp.v1.d1 * z_pow1_5.z_1.d0,
            d2=v_tmp.v1.d0 * z_pow1_5.z_1.d2 + v_tmp.v1.d1 * z_pow1_5.z_1.d1 + v_tmp.v1.d2 *
            z_pow1_5.z_1.d0,
            d3=v_tmp.v1.d1 * z_pow1_5.z_1.d2 + v_tmp.v1.d2 * z_pow1_5.z_1.d1,
            d4=v_tmp.v1.d2 * z_pow1_5.z_1.d2,
        );

        tempvar y_of_z_v2 = UnreducedBigInt5(
            d0=v_tmp.v2.d0 * z_pow1_5.z_2.d0,
            d1=v_tmp.v2.d0 * z_pow1_5.z_2.d1 + v_tmp.v2.d1 * z_pow1_5.z_2.d0,
            d2=v_tmp.v2.d0 * z_pow1_5.z_2.d2 + v_tmp.v2.d1 * z_pow1_5.z_2.d1 + v_tmp.v2.d2 *
            z_pow1_5.z_2.d0,
            d3=v_tmp.v2.d1 * z_pow1_5.z_2.d2 + v_tmp.v2.d2 * z_pow1_5.z_2.d1,
            d4=v_tmp.v2.d2 * z_pow1_5.z_2.d2,
        );

        tempvar y_of_z_v3 = UnreducedBigInt5(
            d0=v_tmp.v3.d0 * z_pow1_5.z_3.d0,
            d1=v_tmp.v3.d0 * z_pow1_5.z_3.d1 + v_tmp.v3.d1 * z_pow1_5.z_3.d0,
            d2=v_tmp.v3.d0 * z_pow1_5.z_3.d2 + v_tmp.v3.d1 * z_pow1_5.z_3.d1 + v_tmp.v3.d2 *
            z_pow1_5.z_3.d0,
            d3=v_tmp.v3.d1 * z_pow1_5.z_3.d2 + v_tmp.v3.d2 * z_pow1_5.z_3.d1,
            d4=v_tmp.v3.d2 * z_pow1_5.z_3.d2,
        );

        tempvar y_of_z_v4 = UnreducedBigInt5(
            d0=v_tmp.v4.d0 * z_pow1_5.z_4.d0,
            d1=v_tmp.v4.d0 * z_pow1_5.z_4.d1 + v_tmp.v4.d1 * z_pow1_5.z_4.d0,
            d2=v_tmp.v4.d0 * z_pow1_5.z_4.d2 + v_tmp.v4.d1 * z_pow1_5.z_4.d1 + v_tmp.v4.d2 *
            z_pow1_5.z_4.d0,
            d3=v_tmp.v4.d1 * z_pow1_5.z_4.d2 + v_tmp.v4.d2 * z_pow1_5.z_4.d1,
            d4=v_tmp.v4.d2 * z_pow1_5.z_4.d2,
        );

        tempvar y_of_z_v5 = UnreducedBigInt5(
            d0=v_tmp.v5.d0 * z_pow1_5.z_5.d0,
            d1=v_tmp.v5.d0 * z_pow1_5.z_5.d1 + v_tmp.v5.d1 * z_pow1_5.z_5.d0,
            d2=v_tmp.v5.d0 * z_pow1_5.z_5.d2 + v_tmp.v5.d1 * z_pow1_5.z_5.d1 + v_tmp.v5.d2 *
            z_pow1_5.z_5.d0,
            d3=v_tmp.v5.d1 * z_pow1_5.z_5.d2 + v_tmp.v5.d2 * z_pow1_5.z_5.d1,
            d4=v_tmp.v5.d2 * z_pow1_5.z_5.d2,
        );

        let y_of_z = reduce_5(
            UnreducedBigInt5(
                d0=v_tmp.v0.d0 + y_of_z_v1.d0 + y_of_z_v2.d0 + y_of_z_v3.d0 + y_of_z_v4.d0 +
                y_of_z_v5.d0,
                d1=v_tmp.v0.d1 + y_of_z_v1.d1 + y_of_z_v2.d1 + y_of_z_v3.d1 + y_of_z_v4.d1 +
                y_of_z_v5.d1,
                d2=v_tmp.v0.d2 + y_of_z_v1.d2 + y_of_z_v2.d2 + y_of_z_v3.d2 + y_of_z_v4.d2 +
                y_of_z_v5.d2,
                d3=y_of_z_v1.d3 + y_of_z_v2.d3 + y_of_z_v3.d3 + y_of_z_v4.d3 + y_of_z_v5.d3,
                d4=y_of_z_v1.d4 + y_of_z_v2.d4 + y_of_z_v3.d4 + y_of_z_v4.d4 + y_of_z_v5.d4,
            ),
        );
        let xy_acc = reduce_5(
            UnreducedBigInt5(
                d0=x_of_z.d0 * y_of_z.d0,
                d1=x_of_z.d0 * y_of_z.d1 + x_of_z.d1 * y_of_z.d0,
                d2=x_of_z.d0 * y_of_z.d2 + x_of_z.d1 * y_of_z.d1 + x_of_z.d2 * y_of_z.d0,
                d3=x_of_z.d1 * y_of_z.d2 + x_of_z.d2 * y_of_z.d1,
                d4=x_of_z.d2 * y_of_z.d2,
            ),
        );

        tempvar poseidon_ptr = poseidon_ptr + PoseidonBuiltin.SIZE * 23;
        let continuable_hash = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s0;
        let random_linear_combination_coeff = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s1;

        assert bitwise_ptr.x = random_linear_combination_coeff;
        assert bitwise_ptr.y = BASE_MIN_1;
        tempvar c_i = bitwise_ptr.x_and_y;
        let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;

        local poly_acc_sqf: PolyAccSquare6 = PolyAccSquare6(
            xy=UnreducedBigInt3(
                d0=poly_acc_sq.xy.d0 + c_i * xy_acc.d0,
                d1=poly_acc_sq.xy.d1 + c_i * xy_acc.d1,
                d2=poly_acc_sq.xy.d2 + c_i * xy_acc.d2,
            ),
            q=E5full(
                Uint256(
                    c_i * q_v.v0.low + poly_acc_sq.q.v0.low,
                    c_i * q_v.v0.high + poly_acc_sq.q.v0.high,
                ),
                Uint256(
                    c_i * q_v.v1.low + poly_acc_sq.q.v1.low,
                    c_i * q_v.v1.high + poly_acc_sq.q.v1.high,
                ),
                Uint256(
                    c_i * q_v.v2.low + poly_acc_sq.q.v2.low,
                    c_i * q_v.v2.high + poly_acc_sq.q.v2.high,
                ),
                Uint256(
                    c_i * q_v.v3.low + poly_acc_sq.q.v3.low,
                    c_i * q_v.v3.high + poly_acc_sq.q.v3.high,
                ),
                Uint256(
                    c_i * q_v.v4.low + poly_acc_sq.q.v4.low,
                    c_i * q_v.v4.high + poly_acc_sq.q.v4.high,
                ),
            ),
            r=poly_acc_sq.r + c_i,
        );
        let poly_acc_sq = &poly_acc_sqf;

        return &sq;
    }

    func n_square_torus{
        range_check_ptr,
        bitwise_ptr: BitwiseBuiltin*,
        poseidon_ptr: PoseidonBuiltin*,
        z_pow1_5_ptr: ZPowers5*,
        continuable_hash: felt,
        poly_acc_sq: PolyAccSquare6*,
    }(x: E6full*, n: felt) -> E6full* {
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

    local res: E6full = E6full(v0, v1, v2, x.b0.a1, x.b1.a1, x.b2.a1);
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

    local b0: E2 = E2(b0a0, x.v3);
    local b1: E2 = E2(b1a0, x.v4);
    local b2: E2 = E2(b2a0, x.v5);

    local res: E6 = E6(&b0, &b1, &b2);
    return &res;
}

func eval_E6_plus_v_unreduced{range_check_ptr}(
    e6: E6DirectUnreduced, v: felt, powers: ZPowers5*
) -> UnreducedBigInt5 {
    alloc_locals;
    let e0 = e6.v0;
    let v1 = reduce_3(e6.v1);
    let v2 = reduce_3(e6.v2);
    let v3 = reduce_3(e6.v3);
    let v4 = reduce_3(e6.v4);
    let v5 = reduce_3(e6.v5);

    let (e1) = bigint_mul(BigInt3(v1.d0 + v, v1.d1, v1.d2), powers.z_1);
    let (e2) = bigint_mul(v2, powers.z_2);
    let (e3) = bigint_mul(v3, powers.z_3);
    let (e4) = bigint_mul(v4, powers.z_4);
    let (e5) = bigint_mul(v5, powers.z_5);

    let res = UnreducedBigInt5(
        d0=e0.d0 + e1.d0 + e2.d0 + e3.d0 + e4.d0 + e5.d0,
        d1=e0.d1 + e1.d1 + e2.d1 + e3.d1 + e4.d1 + e5.d1,
        d2=e0.d2 + e1.d2 + e2.d2 + e3.d2 + e4.d2 + e5.d2,
        d3=e1.d3 + e2.d3 + e3.d3 + e4.d3 + e5.d3,
        d4=e1.d4 + e2.d4 + e3.d4 + e4.d4 + e5.d4,
    );
    return res;
}

func eval_E5{range_check_ptr}(e5: E5full, powers: ZPowers5*) -> BigInt3 {
    alloc_locals;
    let (v0) = unrededucedUint256_to_BigInt3(e5.v0);
    let (v1) = unrededucedUint256_to_BigInt3(e5.v1);
    let (v2) = unrededucedUint256_to_BigInt3(e5.v2);
    let (v3) = unrededucedUint256_to_BigInt3(e5.v3);
    let (v4) = unrededucedUint256_to_BigInt3(e5.v4);

    let e0 = v0;
    let (e1) = bigint_mul(v1, powers.z_1);
    let (e2) = bigint_mul(v2, powers.z_2);
    let (e3) = bigint_mul(v3, powers.z_3);
    let (e4) = bigint_mul(v4, powers.z_4);

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

func get_powers_of_z5{range_check_ptr}(z: BigInt3) -> ZPowers5* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let z_2 = fq_bigint3.mul(z, z);
    let z_3 = fq_bigint3.mul(z_2, z);
    let z_4 = fq_bigint3.mul(z_3, z);
    let z_5 = fq_bigint3.mul(z_4, z);

    local res: ZPowers5 = ZPowers5(z_1=z, z_2=z_2, z_3=z_3, z_4=z_4, z_5=z_5);
    return &res;
}

func eval_unreduced_poly6{range_check_ptr}(z_3: BigInt3, z_6: BigInt3) -> BigInt3 {
    alloc_locals;
    local v3: BigInt3 = BigInt3(
        60193888514187762220203317, 27625954992973055882053025, 3656382694611191768777988
    );  // -18 % p
    let (e3) = bigint_mul(v3, z_3);

    let v6 = z_6;

    let res = reduce_5(
        UnreducedBigInt5(
            d0=82 + e3.d0 + v6.d0, d1=e3.d1 + v6.d1, d2=e3.d2 + v6.d2, d3=e3.d3, d4=e3.d4
        ),
    );
    return res;
}
