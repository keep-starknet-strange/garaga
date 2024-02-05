from src.bn254.towers.e6 import (
    eval_E6_plus_v_unreduced,
    eval_E5,
    eval_irreducible_poly6,
    ZPowers5,
    E5full,
    E6DirectUnreduced,
    PolyAcc6,
)
from src.bn254.fq import (
    fq_bigint3,
    BigInt3,
    bigint_mul,
    UnreducedBigInt3,
    UnreducedBigInt5,
    Uint256,
    verify_zero5,
    felt_to_uint384,
)
from starkware.cairo.common.registers import get_fp_and_pc

from starkware.cairo.common.cairo_builtins import (
    ModBuiltin,
    UInt384,
    PoseidonBuiltin,
    BitwiseBuiltin,
)
from starkware.cairo.common.poseidon_state import PoseidonBuiltinState

const N_LIMBS = 4;
const BASE = 2 ** 96;
const CURVE = 'bn254';
const STARK_MIN_ONE_D2 = 576460752303423505;

struct E6full {
    v0: BigInt3,
    v1: BigInt3,
    v2: BigInt3,
    v3: BigInt3,
    v4: BigInt3,
    v5: BigInt3,
}

// xy_offset : offset in the range_check_96 ptr. Represents the start of an UInt384
// R_offset : offset in the range_check_96 ptr. Represents the start of 6 * UInt384
struct PolyAcc66 {
    xy_offset: felt,
    R_offset: felt,
}

// r is known in advance to be 1* v
struct PolyAccSquare6 {
    xy: UnreducedBigInt3,
    q: E5full,
    r: felt,
}

func verify_6th_extension_tricks{
    range_check_ptr, poly_acc: PolyAcc6*, poly_acc_sq: PolyAccSquare6*, z_pow1_5_ptr: ZPowers5*
}() {
    alloc_locals;
    let sum_r_of_z = eval_E6_plus_v_unreduced(poly_acc.r, poly_acc_sq.r, z_pow1_5_ptr);
    let sum_q_of_z = eval_E5(
        E5full(
            Uint256(
                poly_acc.q.v0.low + poly_acc_sq.q.v0.low, poly_acc.q.v0.high + poly_acc_sq.q.v0.high
            ),
            Uint256(
                poly_acc.q.v1.low + poly_acc_sq.q.v1.low, poly_acc.q.v1.high + poly_acc_sq.q.v1.high
            ),
            Uint256(
                poly_acc.q.v2.low + poly_acc_sq.q.v2.low, poly_acc.q.v2.high + poly_acc_sq.q.v2.high
            ),
            Uint256(
                poly_acc.q.v3.low + poly_acc_sq.q.v3.low, poly_acc.q.v3.high + poly_acc_sq.q.v3.high
            ),
            Uint256(
                poly_acc.q.v4.low + poly_acc_sq.q.v4.low, poly_acc.q.v4.high + poly_acc_sq.q.v4.high
            ),
        ),
        z_pow1_5_ptr,
    );
    let z_6 = fq_bigint3.mul(z_pow1_5_ptr.z_1, z_pow1_5_ptr.z_5);
    let p_of_z = eval_irreducible_poly6(z_pow1_5_ptr.z_3, z_6);
    let (sum_qP_of_z) = bigint_mul(sum_q_of_z, p_of_z);

    verify_zero5(
        UnreducedBigInt5(
            d0=poly_acc.xy.d0 + poly_acc_sq.xy.d0 - sum_qP_of_z.d0 - sum_r_of_z.d0,
            d1=poly_acc.xy.d1 + poly_acc_sq.xy.d1 - sum_qP_of_z.d1 - sum_r_of_z.d1,
            d2=poly_acc.xy.d2 + poly_acc_sq.xy.d2 - sum_qP_of_z.d2 - sum_r_of_z.d2,
            d3=-sum_qP_of_z.d3 - sum_r_of_z.d3,
            d4=-sum_qP_of_z.d4 - sum_r_of_z.d4,
        ),
    );
    return ();
}

from starkware.cairo.common.alloc import alloc

// x_offset: offset in the range_check_96 ptr. x 6*4 limbs are between x_offset and x_offset + 24
// y_offset: offset in the range_check_96 ptr. y 6*4 limbs are between y_offset and y_offset + 24
func mul_trick_e6{
    range_check96_ptr: felt*,
    values_ptr: UInt384*,
    n_u384: felt,
    poseidon_ptr: PoseidonBuiltin*,
    continuable_hash: felt,
    poly_acc6: PolyAcc66*,
    mul_offsets_ptr: felt*,
    add_offsets_ptr: felt*,
    mul_mod_n: felt,
    add_mod_n: felt,
}(x_offset: felt, y_offset: felt) -> (res_offset: felt) {
    alloc_locals;
    tempvar two = 2;
    tempvar four = 4;

    let r_start: UInt384* = cast(range_check96_ptr, UInt384*);
    tempvar res_offset = n_u384 * four;
    %{
        from src.hints.e6 import mul_trick
        from src.hints.fq import pack_bigint_array, fill_bigint_array

        x = pack_bigint_array(ids.values_ptr, ids.N_LIMBS, ids.BASE, 6, ids.x_offset)
        y = pack_bigint_array(ids.values_ptr, ids.N_LIMBS, ids.BASE, 6, ids.y_offset)
        q, r = mul_trick(x, y, ids.CURVE)

        fill_bigint_array(r, ids.r_start, ids.N_LIMBS, ids.BASE, 0)
    %}

    assert poseidon_ptr.input = PoseidonBuiltinState(
        s0=range_check96_ptr[0] * range_check96_ptr[1], s1=continuable_hash, s2=two
    );
    assert poseidon_ptr[1].input = PoseidonBuiltinState(
        s0=range_check96_ptr[2] * range_check96_ptr[3], s1=poseidon_ptr.output.s0, s2=two
    );

    assert poseidon_ptr[2].input = PoseidonBuiltinState(
        s0=range_check96_ptr[4] * range_check96_ptr[5], s1=poseidon_ptr[1].output.s0, s2=two
    );
    assert poseidon_ptr[3].input = PoseidonBuiltinState(
        s0=range_check96_ptr[6] * range_check96_ptr[7], s1=poseidon_ptr[2].output.s0, s2=two
    );
    assert poseidon_ptr[4].input = PoseidonBuiltinState(
        s0=range_check96_ptr[8] * range_check96_ptr[9], s1=poseidon_ptr[3].output.s0, s2=two
    );
    assert poseidon_ptr[5].input = PoseidonBuiltinState(
        s0=range_check96_ptr[10] * range_check96_ptr[11], s1=poseidon_ptr[4].output.s0, s2=two
    );
    assert poseidon_ptr[6].input = PoseidonBuiltinState(
        s0=range_check96_ptr[12] * range_check96_ptr[13], s1=poseidon_ptr[5].output.s0, s2=two
    );
    assert poseidon_ptr[7].input = PoseidonBuiltinState(
        s0=range_check96_ptr[14] * range_check96_ptr[15], s1=poseidon_ptr[6].output.s0, s2=two
    );
    assert poseidon_ptr[8].input = PoseidonBuiltinState(
        s0=range_check96_ptr[16] * range_check96_ptr[17], s1=poseidon_ptr[7].output.s0, s2=two
    );
    assert poseidon_ptr[9].input = PoseidonBuiltinState(
        s0=range_check96_ptr[18] * range_check96_ptr[19], s1=poseidon_ptr[8].output.s0, s2=two
    );
    assert poseidon_ptr[10].input = PoseidonBuiltinState(
        s0=range_check96_ptr[20] * range_check96_ptr[21], s1=poseidon_ptr[9].output.s0, s2=two
    );
    assert poseidon_ptr[11].input = PoseidonBuiltinState(
        s0=range_check96_ptr[22] * range_check96_ptr[23], s1=poseidon_ptr[10].output.s0, s2=two
    );

    // tempvar random_linear_combination_coeff: felt = poseidon_ptr[11].output.s1;
    tempvar random_linear_combination_coeff = 1;
    local c_d0;
    local c_d1;
    local c_d2;
    %{
        from src.hints.fq import bigint_split 
        limbs = bigint_split(ids.random_linear_combination_coeff, ids.N_LIMBS, ids.BASE)
        assert limbs[3] == 0
        ids.c_d0, ids.c_d1, ids.c_d2 = limbs[0], limbs[1], limbs[2]
    %}

    assert random_linear_combination_coeff = c_d0 + c_d1 * 2 ** 96 + c_d2 * (2 ** 96) ** 2;

    if (c_d2 == STARK_MIN_ONE_D2) {
        assert c_d0 = 0;
        assert c_d1 = 0;
    }
    assert values_ptr[n_u384 + 6].d0 = c_d0;
    assert values_ptr[n_u384 + 6].d1 = c_d1;
    assert values_ptr[n_u384 + 6].d2 = c_d2;
    assert values_ptr[n_u384 + 6].d3 = 0;

    tempvar c_i_offset = four * (n_u384 + 6);
    tempvar x_offset = four * x_offset;
    tempvar y_offset = four * y_offset;
    tempvar last_offset = c_i_offset + four;

    // Compute X(Z)
    tempvar zero = 0;  // Z
    tempvar eight = 8;  // Z^3
    tempvar twelve = 12;  // Z^4
    tempvar sixt = 16;  // Z^5

    // x1*Z
    assert mul_offsets_ptr[0] = x_offset + four;
    assert mul_offsets_ptr[1] = zero;
    assert mul_offsets_ptr[2] = last_offset;
    // x2*Z^2
    tempvar x2z2 = last_offset + four;
    assert mul_offsets_ptr[3] = x_offset + 8;
    assert mul_offsets_ptr[4] = four;
    assert mul_offsets_ptr[5] = x2z2;
    // x3*Z^3
    tempvar x3z3 = last_offset + 8;
    assert mul_offsets_ptr[6] = x_offset + 12;
    assert mul_offsets_ptr[7] = eight;
    assert mul_offsets_ptr[8] = x3z3;
    // x4*Z^4
    tempvar x4z4 = last_offset + 12;
    assert mul_offsets_ptr[9] = x_offset + 16;
    assert mul_offsets_ptr[10] = twelve;
    assert mul_offsets_ptr[11] = x4z4;
    // x5*Z^5
    tempvar x5z5 = last_offset + 16;
    assert mul_offsets_ptr[12] = x_offset + 20;
    assert mul_offsets_ptr[13] = sixt;
    assert mul_offsets_ptr[14] = x5z5;

    // x0 + x1*Z
    tempvar x0x1z = last_offset + 20;
    assert add_offsets_ptr[0] = x_offset;
    assert add_offsets_ptr[1] = last_offset;
    assert add_offsets_ptr[2] = x0x1z;
    // ( x0 + x1*Z) + x2*Z^2
    tempvar x0x1zx2z2 = last_offset + 24;
    assert add_offsets_ptr[3] = x0x1z;
    assert add_offsets_ptr[4] = x2z2;
    assert add_offsets_ptr[5] = x0x1zx2z2;
    // (x0 + x1*Z + x2*Z^2) + x3*Z^3
    tempvar x0x1zx2z2x3z3 = last_offset + 28;
    assert add_offsets_ptr[6] = x0x1zx2z2;
    assert add_offsets_ptr[7] = x3z3;
    assert add_offsets_ptr[8] = x0x1zx2z2x3z3;
    // (x0 + x1*Z + x2*Z^2 + x3*Z^3) + x4*Z^4
    tempvar x01234z1234 = last_offset + 32;
    assert add_offsets_ptr[9] = x0x1zx2z2x3z3;
    assert add_offsets_ptr[10] = x4z4;
    assert add_offsets_ptr[11] = x01234z1234;
    // (x0 + x1*Z + x2*Z^2 + x3*Z^3 + x4*Z^4) + x5*Z^5
    tempvar x_of_z = x01234z1234 + four;
    assert add_offsets_ptr[12] = x01234z1234;
    assert add_offsets_ptr[13] = x5z5;
    assert add_offsets_ptr[14] = x_of_z;

    // Compute Y(Z)
    // y1*Z
    tempvar y1z = last_offset + 40;
    assert mul_offsets_ptr[15] = y_offset + four;
    assert mul_offsets_ptr[16] = zero;
    assert mul_offsets_ptr[17] = y1z;
    // y2*Z^2
    tempvar y2z2 = last_offset + 44;
    assert mul_offsets_ptr[18] = y_offset + 8;
    assert mul_offsets_ptr[19] = four;
    assert mul_offsets_ptr[20] = y2z2;
    // y3*Z^3
    tempvar y3z3 = last_offset + 48;
    assert mul_offsets_ptr[21] = y_offset + 12;
    assert mul_offsets_ptr[22] = eight;
    assert mul_offsets_ptr[23] = y3z3;
    // y4*Z^4
    tempvar y4z4 = last_offset + 52;
    assert mul_offsets_ptr[24] = y_offset + 16;
    assert mul_offsets_ptr[25] = twelve;
    assert mul_offsets_ptr[26] = y4z4;
    // y5*Z^5
    tempvar y5z5 = last_offset + 56;
    assert mul_offsets_ptr[27] = y_offset + 20;
    assert mul_offsets_ptr[28] = sixt;
    assert mul_offsets_ptr[29] = y5z5;

    // y0 + y1*Z
    tempvar y01z1 = last_offset + 60;
    assert add_offsets_ptr[15] = y_offset;
    assert add_offsets_ptr[16] = y1z;
    assert add_offsets_ptr[17] = y01z1;
    // (y0 + y1*Z) + y2*Z^2
    tempvar y012z12 = last_offset + 64;
    assert add_offsets_ptr[18] = y01z1;
    assert add_offsets_ptr[19] = y2z2;
    assert add_offsets_ptr[20] = y012z12;
    // (y0 + y1*Z + y2*Z^2) + y3*Z^3
    tempvar y0123z123 = last_offset + 68;
    assert add_offsets_ptr[21] = y012z12;
    assert add_offsets_ptr[22] = y3z3;
    assert add_offsets_ptr[23] = y0123z123;
    // (y0 + y1*Z + y2*Z^2 + y3*Z^3) + y4*Z^4
    tempvar y01234z1234 = last_offset + 72;
    assert add_offsets_ptr[24] = y0123z123;
    assert add_offsets_ptr[25] = y4z4;
    assert add_offsets_ptr[26] = y01234z1234;
    // (y0 + y1*Z + y2*Z^2 + y3*Z^3 + y4*Z^4) + y5*Z^5
    tempvar y_of_z = last_offset + 76;
    assert add_offsets_ptr[27] = y01234z1234;
    assert add_offsets_ptr[28] = y5z5;
    assert add_offsets_ptr[29] = y_of_z;

    // Compute X(Z) * Y(Z)
    tempvar xy_of_z = last_offset + 80;
    assert mul_offsets_ptr[30] = x_of_z;
    assert mul_offsets_ptr[31] = y_of_z;
    assert mul_offsets_ptr[32] = xy_of_z;

    // Compute (X(Z) * Y(Z)) * c_i
    tempvar ci_xy_of_z = last_offset + 84;
    assert mul_offsets_ptr[33] = xy_of_z;
    assert mul_offsets_ptr[34] = c_i_offset;
    assert mul_offsets_ptr[35] = ci_xy_of_z;

    // Compute (X(Z) * Y(Z)) * c_i + PolyAcc6.xy
    assert add_offsets_ptr[30] = ci_xy_of_z;
    assert add_offsets_ptr[31] = poly_acc6.xy_offset;
    assert add_offsets_ptr[32] = last_offset + 88;

    // Compute c_i * R + PolyAcc6.R

    // Compute c_i * r0
    tempvar ci_r0 = last_offset + 92;
    assert mul_offsets_ptr[36] = c_i_offset;
    assert mul_offsets_ptr[37] = res_offset;
    assert mul_offsets_ptr[38] = ci_r0;
    // Compute c_i * r1
    tempvar ci_r1 = last_offset + 96;
    assert mul_offsets_ptr[39] = c_i_offset;
    assert mul_offsets_ptr[40] = res_offset + 4;
    assert mul_offsets_ptr[41] = ci_r1;
    // Compute c_i * r2
    tempvar ci_r2 = last_offset + 100;
    assert mul_offsets_ptr[42] = c_i_offset;
    assert mul_offsets_ptr[43] = res_offset + 8;
    assert mul_offsets_ptr[44] = ci_r2;
    // Compute c_i * r3
    tempvar ci_r3 = last_offset + 104;
    assert mul_offsets_ptr[45] = c_i_offset;
    assert mul_offsets_ptr[46] = res_offset + 12;
    assert mul_offsets_ptr[47] = ci_r3;
    // Compute c_i * r4
    tempvar ci_r4 = last_offset + 108;
    assert mul_offsets_ptr[48] = c_i_offset;
    assert mul_offsets_ptr[49] = res_offset + 16;
    assert mul_offsets_ptr[50] = ci_r4;
    // Compute c_i * r5
    tempvar ci_r5 = last_offset + 112;
    assert mul_offsets_ptr[51] = c_i_offset;
    assert mul_offsets_ptr[52] = res_offset + 20;
    assert mul_offsets_ptr[53] = ci_r5;

    // (c_i * r0) + PolyAcc6.R.r0
    assert add_offsets_ptr[33] = ci_r0;
    assert add_offsets_ptr[34] = poly_acc6.R_offset;
    assert add_offsets_ptr[35] = last_offset + 116;
    // (c_i * r1) + PolyAcc6.R.r1
    assert add_offsets_ptr[36] = ci_r1;
    assert add_offsets_ptr[37] = poly_acc6.R_offset + four;
    assert add_offsets_ptr[38] = last_offset + 120;
    // (c_i * r2) + PolyAcc6.R.r2
    assert add_offsets_ptr[39] = ci_r2;
    assert add_offsets_ptr[40] = poly_acc6.R_offset + 8;
    assert add_offsets_ptr[41] = last_offset + 124;
    // (c_i * r3) + PolyAcc6.R.r3
    assert add_offsets_ptr[42] = ci_r3;
    assert add_offsets_ptr[43] = poly_acc6.R_offset + 12;
    assert add_offsets_ptr[44] = last_offset + 128;
    // (c_i * r4) + PolyAcc6.R.r4
    assert add_offsets_ptr[45] = ci_r4;
    assert add_offsets_ptr[46] = poly_acc6.R_offset + 16;
    assert add_offsets_ptr[47] = last_offset + 132;
    // (c_i * r5) + PolyAcc6.R.r5
    assert add_offsets_ptr[48] = ci_r5;
    assert add_offsets_ptr[49] = poly_acc6.R_offset + 20;
    assert add_offsets_ptr[50] = last_offset + 136;

    assert [range_check96_ptr + 6 * UInt384.SIZE + 36 * UInt384.SIZE] = STARK_MIN_ONE_D2 - c_d2;
    tempvar range_check96_ptr = range_check96_ptr + 6 * UInt384.SIZE + 36 * UInt384.SIZE + 1;
    // tempvar poseidon_ptr = poseidon_ptr + 12 * PoseidonBuiltin.SIZE;  // 12 Poseidon
    // let continuable_hash = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s0;
    let continuable_hash = 0;

    tempvar poly_acc6 = new PolyAcc66(xy_offset=last_offset + 88, R_offset=last_offset + 112);
    tempvar mul_offsets_ptr = mul_offsets_ptr + 18 * 3;  // 18 MULs
    tempvar add_offsets_ptr = add_offsets_ptr + 17 * 3;  // 17 ADDs
    tempvar mul_mod_n = mul_mod_n + 18;
    tempvar add_mod_n = add_mod_n + 17;

    return (res_offset,);
}

// Copies len field elements from src to dst.
func memcpy(dst: felt*, src: felt*, len) {
    struct LoopFrame {
        dst: felt*,
        src: felt*,
    }

    if (len == 0) {
        return ();
    }

    %{ vm_enter_scope({'n': ids.len}) %}
    tempvar frame = LoopFrame(dst=dst, src=src);

    loop:
    let frame = [cast(ap - LoopFrame.SIZE, LoopFrame*)];
    assert [frame.dst] = [frame.src];

    let continue_copying = [ap];
    // Reserve space for continue_copying.
    let next_frame = cast(ap + 1, LoopFrame*);
    next_frame.dst = frame.dst + 1, ap++;
    next_frame.src = frame.src + 1, ap++;
    %{
        n -= 1
        ids.continue_copying = 1 if n > 0 else 0
    %}
    static_assert next_frame + LoopFrame.SIZE == ap + 1;
    jmp loop if continue_copying != 0, ap++;
    // Assert that the loop executed len times.
    len = cast(next_frame.src, felt) - cast(src, felt);

    %{ vm_exit_scope() %}
    return ();
}
