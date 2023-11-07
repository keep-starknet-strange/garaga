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
    BASE_MIN_1,
    unrededucedUint256_to_BigInt3,
    reduce_5_full,
    reduce_3_full,
    assert_reduced_felt,
)
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.registers import get_fp_and_pc
from src.bn254.curve import (
    N_LIMBS,
    DEGREE,
    BASE,
    P0,
    P1,
    P2,
    NON_RESIDUE_E2_a0,
    NON_RESIDUE_E2_a1,
    THREE_BASE_MIN_1,
)
from starkware.cairo.common.builtin_poseidon.poseidon import poseidon_hash, poseidon_hash_many
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, BitwiseBuiltin
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
    w0: Uint256,
    w1: Uint256,
    w2: Uint256,
    w3: Uint256,
    w4: Uint256,
    w5: Uint256,
    w6: Uint256,
    w7: Uint256,
    w8: Uint256,
    w9: Uint256,
    w10: Uint256,
}

struct E9full {
    w0: Uint256,
    w1: Uint256,
    w2: Uint256,
    w3: Uint256,
    w4: Uint256,
    w5: Uint256,
    w6: Uint256,
    w7: Uint256,
    w8: Uint256,
}

struct E7full {
    w0: Uint256,
    w1: Uint256,
    w2: Uint256,
    w3: Uint256,
    w4: Uint256,
    w5: Uint256,
    w6: Uint256,
}

struct VerifyPolySquare {
    x: E12full*,
    q: E11full*,
    r: E12full*,
}

// // 034 Gnark element converted to Fp12/Fp representation
// // w0: BigInt3, // 1
// w1: BigInt3,
// // w2: BigInt3, // 0
// w3: BigInt3,
// // w4: BigInt3, // 0
// // w5: BigInt3, // 0
// // w6: BigInt3, // 0
// w7: BigInt3,
// // w8: BigInt3, // 0
// w9: BigInt3,
// // w10: BigInt3, // 0
// // w11: BigInt3, // 0
struct E12full034 {
    w1: BigInt3,
    w3: BigInt3,
    w7: BigInt3,
    w9: BigInt3,
}

struct E12full01234 {
    w0: BigInt3,
    w1: BigInt3,
    w2: BigInt3,
    w3: BigInt3,
    w4: BigInt3,
    w6: BigInt3,
    w7: BigInt3,
    w8: BigInt3,
    w9: BigInt3,
    w10: BigInt3,
    w11: BigInt3,
}

struct ZPowers11 {
    z_1: BigInt3,
    z_2: BigInt3,
    z_3: BigInt3,
    z_4: BigInt3,
    z_5: BigInt3,
    z_6: BigInt3,
    z_7: BigInt3,
    z_8: BigInt3,
    z_9: BigInt3,
    z_10: BigInt3,
    z_11: BigInt3,
}

struct PolyAcc12 {
    xy: UnreducedBigInt3,
    q: E11full,
    r: E12full,
}

struct PolyAcc034 {
    xy: UnreducedBigInt3,
    q: E9full,
    r: E12full,
}

struct PolyAcc034034 {
    xy: UnreducedBigInt3,
    q: E7full,
    r: E12full01234,
}
func square_trick{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    z_pow1_11_ptr: ZPowers11*,
    continuable_hash: felt,
    poly_acc_sq: PolyAcc12*,
}(x_ptr: E12full*) -> E12full* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local x: E12full = [x_ptr];
    local z_pow1_11: ZPowers11 = [z_pow1_11_ptr];
    local r_w: E12full;
    local q_w: E11full;
    %{
        from tools.py.polynomial import Polynomial
        from tools.py.field import BaseFieldElement, BaseField
        #from tools.py.extension_trick import w_to_gnark, gnark_to_w, flatten, pack_e12, mul_e12_gnark
        #from src.bn254.hints import split
        from starkware.cairo.common.cairo_secp.secp_utils import split
        from tools.make.utils import split_128
        p=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
        field = BaseField(p)
        x=12*[0]
        x_refs=[ids.x.w0, ids.x.w1, ids.x.w2, ids.x.w3, ids.x.w4, ids.x.w5, ids.x.w6, ids.x.w7, ids.x.w8, ids.x.w9, ids.x.w10, ids.x.w11]
        for i in range(ids.N_LIMBS):
            for k in range(12):
                x[k]+=as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
        #x_gnark=w_to_gnark(x)
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
        # extend z_polyr with 0 to make it len 12:
        z_polyr_coeffs = z_polyr_coeffs + (12-len(z_polyr_coeffs))*[0]
        #expected = flatten(mul_e12_gnark(pack_e12(x_gnark), pack_e12(x_gnark)))
        #assert expected==w_to_gnark(z_polyr_coeffs)
        #print(f"Z_PolyR: {z_polyr_coeffs}")
        #print(f"Z_PolyR_to_gnark: {w_to_gnark(z_polyr_coeffs)}")
        for i in range(12):
            val = split(z_polyr_coeffs[i]%p)
            for k in range(ids.N_LIMBS):
                rsetattr(ids.r_w, f'w{i}.d{k}', val[k])
        for i in range(11):
            val = split_128(z_polyq_coeffs[i]%p)
            rsetattr(ids.q_w, f'w{i}.low', val[0])
            rsetattr(ids.q_w, f'w{i}.high', val[1])
    %}
    assert [range_check_ptr + 0] = r_w.w0.d0;
    assert [range_check_ptr + 1] = r_w.w0.d1;
    assert [range_check_ptr + 2] = r_w.w0.d2;
    assert [range_check_ptr + 3] = r_w.w1.d0;
    assert [range_check_ptr + 4] = r_w.w1.d1;
    assert [range_check_ptr + 5] = r_w.w1.d2;
    assert [range_check_ptr + 6] = r_w.w2.d0;
    assert [range_check_ptr + 7] = r_w.w2.d1;
    assert [range_check_ptr + 8] = r_w.w2.d2;
    assert [range_check_ptr + 9] = r_w.w3.d0;
    assert [range_check_ptr + 10] = r_w.w3.d1;
    assert [range_check_ptr + 11] = r_w.w3.d2;
    assert [range_check_ptr + 12] = r_w.w4.d0;
    assert [range_check_ptr + 13] = r_w.w4.d1;
    assert [range_check_ptr + 14] = r_w.w4.d2;
    assert [range_check_ptr + 15] = r_w.w5.d0;
    assert [range_check_ptr + 16] = r_w.w5.d1;
    assert [range_check_ptr + 17] = r_w.w5.d2;
    assert [range_check_ptr + 18] = r_w.w6.d0;
    assert [range_check_ptr + 19] = r_w.w6.d1;
    assert [range_check_ptr + 20] = r_w.w6.d2;
    assert [range_check_ptr + 21] = r_w.w7.d0;
    assert [range_check_ptr + 22] = r_w.w7.d1;
    assert [range_check_ptr + 23] = r_w.w7.d2;
    assert [range_check_ptr + 24] = r_w.w8.d0;
    assert [range_check_ptr + 25] = r_w.w8.d1;
    assert [range_check_ptr + 26] = r_w.w8.d2;
    assert [range_check_ptr + 27] = r_w.w9.d0;
    assert [range_check_ptr + 28] = r_w.w9.d1;
    assert [range_check_ptr + 29] = r_w.w9.d2;
    assert [range_check_ptr + 30] = r_w.w10.d0;
    assert [range_check_ptr + 31] = r_w.w10.d1;
    assert [range_check_ptr + 32] = r_w.w10.d2;
    assert [range_check_ptr + 33] = r_w.w11.d0;
    assert [range_check_ptr + 34] = r_w.w11.d1;
    assert [range_check_ptr + 35] = r_w.w11.d2;
    assert [range_check_ptr + 36] = q_w.w0.low;
    assert [range_check_ptr + 37] = q_w.w0.high;
    assert [range_check_ptr + 38] = q_w.w1.low;
    assert [range_check_ptr + 39] = q_w.w1.high;
    assert [range_check_ptr + 40] = q_w.w2.low;
    assert [range_check_ptr + 41] = q_w.w2.high;
    assert [range_check_ptr + 42] = q_w.w3.low;
    assert [range_check_ptr + 43] = q_w.w3.high;
    assert [range_check_ptr + 44] = q_w.w4.low;
    assert [range_check_ptr + 45] = q_w.w4.high;
    assert [range_check_ptr + 46] = q_w.w5.low;
    assert [range_check_ptr + 47] = q_w.w5.high;
    assert [range_check_ptr + 48] = q_w.w6.low;
    assert [range_check_ptr + 49] = q_w.w6.high;
    assert [range_check_ptr + 50] = q_w.w7.low;
    assert [range_check_ptr + 51] = q_w.w7.high;
    assert [range_check_ptr + 52] = q_w.w8.low;
    assert [range_check_ptr + 53] = q_w.w8.high;
    assert [range_check_ptr + 54] = q_w.w9.low;
    assert [range_check_ptr + 55] = q_w.w9.high;
    assert [range_check_ptr + 56] = q_w.w10.low;
    assert [range_check_ptr + 57] = q_w.w10.high;
    assert [range_check_ptr + 58] = THREE_BASE_MIN_1 - (r_w.w0.d0 + r_w.w0.d1 + r_w.w0.d2);
    assert [range_check_ptr + 59] = THREE_BASE_MIN_1 - (r_w.w1.d0 + r_w.w1.d1 + r_w.w1.d2);
    assert [range_check_ptr + 60] = THREE_BASE_MIN_1 - (r_w.w2.d0 + r_w.w2.d1 + r_w.w2.d2);
    assert [range_check_ptr + 61] = THREE_BASE_MIN_1 - (r_w.w3.d0 + r_w.w3.d1 + r_w.w3.d2);
    assert [range_check_ptr + 62] = THREE_BASE_MIN_1 - (r_w.w4.d0 + r_w.w4.d1 + r_w.w4.d2);
    assert [range_check_ptr + 63] = THREE_BASE_MIN_1 - (r_w.w5.d0 + r_w.w5.d1 + r_w.w5.d2);
    assert [range_check_ptr + 64] = THREE_BASE_MIN_1 - (r_w.w6.d0 + r_w.w6.d1 + r_w.w6.d2);
    assert [range_check_ptr + 65] = THREE_BASE_MIN_1 - (r_w.w7.d0 + r_w.w7.d1 + r_w.w7.d2);
    assert [range_check_ptr + 66] = THREE_BASE_MIN_1 - (r_w.w8.d0 + r_w.w8.d1 + r_w.w8.d2);
    assert [range_check_ptr + 67] = THREE_BASE_MIN_1 - (r_w.w9.d0 + r_w.w9.d1 + r_w.w9.d2);
    assert [range_check_ptr + 68] = THREE_BASE_MIN_1 - (r_w.w10.d0 + r_w.w10.d1 + r_w.w10.d2);
    assert [range_check_ptr + 69] = THREE_BASE_MIN_1 - (r_w.w11.d0 + r_w.w11.d1 + r_w.w11.d2);

    tempvar range_check_ptr = range_check_ptr + 70;

    assert poseidon_ptr.input = PoseidonBuiltinState(
        s0=x.w0.d0 * x.w0.d1, s1=continuable_hash, s2=2
    );
    assert poseidon_ptr[1].input = PoseidonBuiltinState(
        s0=x.w0.d2 * x.w1.d0, s1=poseidon_ptr[0].output.s0, s2=2
    );
    assert poseidon_ptr[2].input = PoseidonBuiltinState(
        s0=x.w1.d1 * x.w1.d2, s1=poseidon_ptr[1].output.s0, s2=2
    );
    assert poseidon_ptr[3].input = PoseidonBuiltinState(
        s0=x.w2.d0 * x.w2.d1, s1=poseidon_ptr[2].output.s0, s2=2
    );
    assert poseidon_ptr[4].input = PoseidonBuiltinState(
        s0=x.w2.d2 * x.w3.d0, s1=poseidon_ptr[3].output.s0, s2=2
    );
    assert poseidon_ptr[5].input = PoseidonBuiltinState(
        s0=x.w3.d1 * x.w3.d2, s1=poseidon_ptr[4].output.s0, s2=2
    );
    assert poseidon_ptr[6].input = PoseidonBuiltinState(
        s0=x.w4.d0 * x.w4.d1, s1=poseidon_ptr[5].output.s0, s2=2
    );
    assert poseidon_ptr[7].input = PoseidonBuiltinState(
        s0=x.w4.d2 * x.w5.d0, s1=poseidon_ptr[6].output.s0, s2=2
    );
    assert poseidon_ptr[8].input = PoseidonBuiltinState(
        s0=x.w5.d1 * x.w5.d2, s1=poseidon_ptr[7].output.s0, s2=2
    );
    assert poseidon_ptr[9].input = PoseidonBuiltinState(
        s0=x.w6.d0 * x.w6.d1, s1=poseidon_ptr[8].output.s0, s2=2
    );
    assert poseidon_ptr[10].input = PoseidonBuiltinState(
        s0=x.w6.d2 * x.w7.d0, s1=poseidon_ptr[9].output.s0, s2=2
    );
    assert poseidon_ptr[11].input = PoseidonBuiltinState(
        s0=x.w7.d1 * x.w7.d2, s1=poseidon_ptr[10].output.s0, s2=2
    );
    assert poseidon_ptr[12].input = PoseidonBuiltinState(
        s0=x.w8.d0 * x.w8.d1, s1=poseidon_ptr[11].output.s0, s2=2
    );
    assert poseidon_ptr[13].input = PoseidonBuiltinState(
        s0=x.w8.d2 * x.w9.d0, s1=poseidon_ptr[12].output.s0, s2=2
    );
    assert poseidon_ptr[14].input = PoseidonBuiltinState(
        s0=x.w9.d1 * x.w9.d2, s1=poseidon_ptr[13].output.s0, s2=2
    );
    assert poseidon_ptr[15].input = PoseidonBuiltinState(
        s0=x.w10.d0 * x.w10.d1, s1=poseidon_ptr[14].output.s0, s2=2
    );
    assert poseidon_ptr[16].input = PoseidonBuiltinState(
        s0=x.w10.d2 * x.w11.d0, s1=poseidon_ptr[15].output.s0, s2=2
    );
    assert poseidon_ptr[17].input = PoseidonBuiltinState(
        s0=x.w11.d1 * x.w11.d2, s1=poseidon_ptr[16].output.s0, s2=2
    );
    assert poseidon_ptr[18].input = PoseidonBuiltinState(
        s0=q_w.w0.low, s1=poseidon_ptr[17].output.s0, s2=2
    );
    assert poseidon_ptr[19].input = PoseidonBuiltinState(
        s0=q_w.w0.high, s1=poseidon_ptr[18].output.s0, s2=2
    );
    assert poseidon_ptr[20].input = PoseidonBuiltinState(
        s0=q_w.w1.low, s1=poseidon_ptr[19].output.s0, s2=2
    );
    assert poseidon_ptr[21].input = PoseidonBuiltinState(
        s0=q_w.w1.high, s1=poseidon_ptr[20].output.s0, s2=2
    );
    assert poseidon_ptr[22].input = PoseidonBuiltinState(
        s0=q_w.w2.low, s1=poseidon_ptr[21].output.s0, s2=2
    );
    assert poseidon_ptr[23].input = PoseidonBuiltinState(
        s0=q_w.w2.high, s1=poseidon_ptr[22].output.s0, s2=2
    );
    assert poseidon_ptr[24].input = PoseidonBuiltinState(
        s0=q_w.w3.low, s1=poseidon_ptr[23].output.s0, s2=2
    );
    assert poseidon_ptr[25].input = PoseidonBuiltinState(
        s0=q_w.w3.high, s1=poseidon_ptr[24].output.s0, s2=2
    );
    assert poseidon_ptr[26].input = PoseidonBuiltinState(
        s0=q_w.w4.low, s1=poseidon_ptr[25].output.s0, s2=2
    );
    assert poseidon_ptr[27].input = PoseidonBuiltinState(
        s0=q_w.w4.high, s1=poseidon_ptr[26].output.s0, s2=2
    );
    assert poseidon_ptr[28].input = PoseidonBuiltinState(
        s0=q_w.w5.low, s1=poseidon_ptr[27].output.s0, s2=2
    );
    assert poseidon_ptr[29].input = PoseidonBuiltinState(
        s0=q_w.w5.high, s1=poseidon_ptr[28].output.s0, s2=2
    );
    assert poseidon_ptr[30].input = PoseidonBuiltinState(
        s0=q_w.w6.low, s1=poseidon_ptr[29].output.s0, s2=2
    );
    assert poseidon_ptr[31].input = PoseidonBuiltinState(
        s0=q_w.w6.high, s1=poseidon_ptr[30].output.s0, s2=2
    );
    assert poseidon_ptr[32].input = PoseidonBuiltinState(
        s0=q_w.w7.low, s1=poseidon_ptr[31].output.s0, s2=2
    );
    assert poseidon_ptr[33].input = PoseidonBuiltinState(
        s0=q_w.w7.high, s1=poseidon_ptr[32].output.s0, s2=2
    );
    assert poseidon_ptr[34].input = PoseidonBuiltinState(
        s0=q_w.w8.low, s1=poseidon_ptr[33].output.s0, s2=2
    );
    assert poseidon_ptr[35].input = PoseidonBuiltinState(
        s0=q_w.w8.high, s1=poseidon_ptr[34].output.s0, s2=2
    );
    assert poseidon_ptr[36].input = PoseidonBuiltinState(
        s0=q_w.w9.low, s1=poseidon_ptr[35].output.s0, s2=2
    );
    assert poseidon_ptr[37].input = PoseidonBuiltinState(
        s0=q_w.w9.high, s1=poseidon_ptr[36].output.s0, s2=2
    );
    assert poseidon_ptr[38].input = PoseidonBuiltinState(
        s0=q_w.w10.low, s1=poseidon_ptr[37].output.s0, s2=2
    );
    assert poseidon_ptr[39].input = PoseidonBuiltinState(
        s0=q_w.w10.high, s1=poseidon_ptr[38].output.s0, s2=2
    );
    assert poseidon_ptr[40].input = PoseidonBuiltinState(
        s0=r_w.w0.d0 * r_w.w0.d1, s1=poseidon_ptr[39].output.s0, s2=2
    );
    assert poseidon_ptr[41].input = PoseidonBuiltinState(
        s0=r_w.w0.d2 * r_w.w1.d0, s1=poseidon_ptr[40].output.s0, s2=2
    );
    assert poseidon_ptr[42].input = PoseidonBuiltinState(
        s0=r_w.w1.d1 * r_w.w1.d2, s1=poseidon_ptr[41].output.s0, s2=2
    );
    assert poseidon_ptr[43].input = PoseidonBuiltinState(
        s0=r_w.w2.d0 * r_w.w2.d1, s1=poseidon_ptr[42].output.s0, s2=2
    );
    assert poseidon_ptr[44].input = PoseidonBuiltinState(
        s0=r_w.w2.d2 * r_w.w3.d0, s1=poseidon_ptr[43].output.s0, s2=2
    );
    assert poseidon_ptr[45].input = PoseidonBuiltinState(
        s0=r_w.w3.d1 * r_w.w3.d2, s1=poseidon_ptr[44].output.s0, s2=2
    );
    assert poseidon_ptr[46].input = PoseidonBuiltinState(
        s0=r_w.w4.d0 * r_w.w4.d1, s1=poseidon_ptr[45].output.s0, s2=2
    );
    assert poseidon_ptr[47].input = PoseidonBuiltinState(
        s0=r_w.w4.d2 * r_w.w5.d0, s1=poseidon_ptr[46].output.s0, s2=2
    );
    assert poseidon_ptr[48].input = PoseidonBuiltinState(
        s0=r_w.w5.d1 * r_w.w5.d2, s1=poseidon_ptr[47].output.s0, s2=2
    );
    assert poseidon_ptr[49].input = PoseidonBuiltinState(
        s0=r_w.w6.d0 * r_w.w6.d1, s1=poseidon_ptr[48].output.s0, s2=2
    );
    assert poseidon_ptr[50].input = PoseidonBuiltinState(
        s0=r_w.w6.d2 * r_w.w7.d0, s1=poseidon_ptr[49].output.s0, s2=2
    );
    assert poseidon_ptr[51].input = PoseidonBuiltinState(
        s0=r_w.w7.d1 * r_w.w7.d2, s1=poseidon_ptr[50].output.s0, s2=2
    );
    assert poseidon_ptr[52].input = PoseidonBuiltinState(
        s0=r_w.w8.d0 * r_w.w8.d1, s1=poseidon_ptr[51].output.s0, s2=2
    );
    assert poseidon_ptr[53].input = PoseidonBuiltinState(
        s0=r_w.w8.d2 * r_w.w9.d0, s1=poseidon_ptr[52].output.s0, s2=2
    );
    assert poseidon_ptr[54].input = PoseidonBuiltinState(
        s0=r_w.w9.d1 * r_w.w9.d2, s1=poseidon_ptr[53].output.s0, s2=2
    );
    assert poseidon_ptr[55].input = PoseidonBuiltinState(
        s0=r_w.w10.d0 * r_w.w10.d1, s1=poseidon_ptr[54].output.s0, s2=2
    );
    assert poseidon_ptr[56].input = PoseidonBuiltinState(
        s0=r_w.w10.d2 * r_w.w11.d0, s1=poseidon_ptr[55].output.s0, s2=2
    );
    assert poseidon_ptr[57].input = PoseidonBuiltinState(
        s0=r_w.w11.d1 * r_w.w11.d2, s1=poseidon_ptr[56].output.s0, s2=2
    );

    tempvar x_of_z_w1 = UnreducedBigInt5(
        d0=x.w1.d0 * z_pow1_11.z_1.d0,
        d1=x.w1.d0 * z_pow1_11.z_1.d1 + x.w1.d1 * z_pow1_11.z_1.d0,
        d2=x.w1.d0 * z_pow1_11.z_1.d2 + x.w1.d1 * z_pow1_11.z_1.d1 + x.w1.d2 * z_pow1_11.z_1.d0,
        d3=x.w1.d1 * z_pow1_11.z_1.d2 + x.w1.d2 * z_pow1_11.z_1.d1,
        d4=x.w1.d2 * z_pow1_11.z_1.d2,
    );
    tempvar x_of_z_w2 = UnreducedBigInt5(
        d0=x.w2.d0 * z_pow1_11.z_2.d0,
        d1=x.w2.d0 * z_pow1_11.z_2.d1 + x.w2.d1 * z_pow1_11.z_2.d0,
        d2=x.w2.d0 * z_pow1_11.z_2.d2 + x.w2.d1 * z_pow1_11.z_2.d1 + x.w2.d2 * z_pow1_11.z_2.d0,
        d3=x.w2.d1 * z_pow1_11.z_2.d2 + x.w2.d2 * z_pow1_11.z_2.d1,
        d4=x.w2.d2 * z_pow1_11.z_2.d2,
    );

    tempvar x_of_z_w3 = UnreducedBigInt5(
        d0=x.w3.d0 * z_pow1_11.z_3.d0,
        d1=x.w3.d0 * z_pow1_11.z_3.d1 + x.w3.d1 * z_pow1_11.z_3.d0,
        d2=x.w3.d0 * z_pow1_11.z_3.d2 + x.w3.d1 * z_pow1_11.z_3.d1 + x.w3.d2 * z_pow1_11.z_3.d0,
        d3=x.w3.d1 * z_pow1_11.z_3.d2 + x.w3.d2 * z_pow1_11.z_3.d1,
        d4=x.w3.d2 * z_pow1_11.z_3.d2,
    );

    tempvar x_of_z_w4 = UnreducedBigInt5(
        d0=x.w4.d0 * z_pow1_11.z_4.d0,
        d1=x.w4.d0 * z_pow1_11.z_4.d1 + x.w4.d1 * z_pow1_11.z_4.d0,
        d2=x.w4.d0 * z_pow1_11.z_4.d2 + x.w4.d1 * z_pow1_11.z_4.d1 + x.w4.d2 * z_pow1_11.z_4.d0,
        d3=x.w4.d1 * z_pow1_11.z_4.d2 + x.w4.d2 * z_pow1_11.z_4.d1,
        d4=x.w4.d2 * z_pow1_11.z_4.d2,
    );

    tempvar x_of_z_w5 = UnreducedBigInt5(
        d0=x.w5.d0 * z_pow1_11.z_5.d0,
        d1=x.w5.d0 * z_pow1_11.z_5.d1 + x.w5.d1 * z_pow1_11.z_5.d0,
        d2=x.w5.d0 * z_pow1_11.z_5.d2 + x.w5.d1 * z_pow1_11.z_5.d1 + x.w5.d2 * z_pow1_11.z_5.d0,
        d3=x.w5.d1 * z_pow1_11.z_5.d2 + x.w5.d2 * z_pow1_11.z_5.d1,
        d4=x.w5.d2 * z_pow1_11.z_5.d2,
    );

    tempvar x_of_z_w6 = UnreducedBigInt5(
        d0=x.w6.d0 * z_pow1_11.z_6.d0,
        d1=x.w6.d0 * z_pow1_11.z_6.d1 + x.w6.d1 * z_pow1_11.z_6.d0,
        d2=x.w6.d0 * z_pow1_11.z_6.d2 + x.w6.d1 * z_pow1_11.z_6.d1 + x.w6.d2 * z_pow1_11.z_6.d0,
        d3=x.w6.d1 * z_pow1_11.z_6.d2 + x.w6.d2 * z_pow1_11.z_6.d1,
        d4=x.w6.d2 * z_pow1_11.z_6.d2,
    );

    tempvar x_of_z_w7 = UnreducedBigInt5(
        d0=x.w7.d0 * z_pow1_11.z_7.d0,
        d1=x.w7.d0 * z_pow1_11.z_7.d1 + x.w7.d1 * z_pow1_11.z_7.d0,
        d2=x.w7.d0 * z_pow1_11.z_7.d2 + x.w7.d1 * z_pow1_11.z_7.d1 + x.w7.d2 * z_pow1_11.z_7.d0,
        d3=x.w7.d1 * z_pow1_11.z_7.d2 + x.w7.d2 * z_pow1_11.z_7.d1,
        d4=x.w7.d2 * z_pow1_11.z_7.d2,
    );

    tempvar x_of_z_w8 = UnreducedBigInt5(
        d0=x.w8.d0 * z_pow1_11.z_8.d0,
        d1=x.w8.d0 * z_pow1_11.z_8.d1 + x.w8.d1 * z_pow1_11.z_8.d0,
        d2=x.w8.d0 * z_pow1_11.z_8.d2 + x.w8.d1 * z_pow1_11.z_8.d1 + x.w8.d2 * z_pow1_11.z_8.d0,
        d3=x.w8.d1 * z_pow1_11.z_8.d2 + x.w8.d2 * z_pow1_11.z_8.d1,
        d4=x.w8.d2 * z_pow1_11.z_8.d2,
    );

    tempvar x_of_z_w9 = UnreducedBigInt5(
        d0=x.w9.d0 * z_pow1_11.z_9.d0,
        d1=x.w9.d0 * z_pow1_11.z_9.d1 + x.w9.d1 * z_pow1_11.z_9.d0,
        d2=x.w9.d0 * z_pow1_11.z_9.d2 + x.w9.d1 * z_pow1_11.z_9.d1 + x.w9.d2 * z_pow1_11.z_9.d0,
        d3=x.w9.d1 * z_pow1_11.z_9.d2 + x.w9.d2 * z_pow1_11.z_9.d1,
        d4=x.w9.d2 * z_pow1_11.z_9.d2,
    );

    tempvar x_of_z_w10 = UnreducedBigInt5(
        d0=x.w10.d0 * z_pow1_11.z_10.d0,
        d1=x.w10.d0 * z_pow1_11.z_10.d1 + x.w10.d1 * z_pow1_11.z_10.d0,
        d2=x.w10.d0 * z_pow1_11.z_10.d2 + x.w10.d1 * z_pow1_11.z_10.d1 + x.w10.d2 *
        z_pow1_11.z_10.d0,
        d3=x.w10.d1 * z_pow1_11.z_10.d2 + x.w10.d2 * z_pow1_11.z_10.d1,
        d4=x.w10.d2 * z_pow1_11.z_10.d2,
    );

    tempvar x_of_z_w11 = UnreducedBigInt5(
        d0=x.w11.d0 * z_pow1_11.z_11.d0,
        d1=x.w11.d0 * z_pow1_11.z_11.d1 + x.w11.d1 * z_pow1_11.z_11.d0,
        d2=x.w11.d0 * z_pow1_11.z_11.d2 + x.w11.d1 * z_pow1_11.z_11.d1 + x.w11.d2 *
        z_pow1_11.z_11.d0,
        d3=x.w11.d1 * z_pow1_11.z_11.d2 + x.w11.d2 * z_pow1_11.z_11.d1,
        d4=x.w11.d2 * z_pow1_11.z_11.d2,
    );

    let x_of_z = reduce_5_full(
        UnreducedBigInt5(
            d0=x.w0.d0 + x_of_z_w1.d0 + x_of_z_w2.d0 + x_of_z_w3.d0 + x_of_z_w4.d0 + x_of_z_w5.d0 +
            x_of_z_w6.d0 + x_of_z_w7.d0 + x_of_z_w8.d0 + x_of_z_w9.d0 + x_of_z_w10.d0 +
            x_of_z_w11.d0,
            d1=x.w0.d1 + x_of_z_w1.d1 + x_of_z_w2.d1 + x_of_z_w3.d1 + x_of_z_w4.d1 + x_of_z_w5.d1 +
            x_of_z_w6.d1 + x_of_z_w7.d1 + x_of_z_w8.d1 + x_of_z_w9.d1 + x_of_z_w10.d1 +
            x_of_z_w11.d1,
            d2=x.w0.d2 + x_of_z_w1.d2 + x_of_z_w2.d2 + x_of_z_w3.d2 + x_of_z_w4.d2 + x_of_z_w5.d2 +
            x_of_z_w6.d2 + x_of_z_w7.d2 + x_of_z_w8.d2 + x_of_z_w9.d2 + x_of_z_w10.d2 +
            x_of_z_w11.d2,
            d3=x_of_z_w1.d3 + x_of_z_w2.d3 + x_of_z_w3.d3 + x_of_z_w4.d3 + x_of_z_w5.d3 +
            x_of_z_w6.d3 + x_of_z_w7.d3 + x_of_z_w8.d3 + x_of_z_w9.d3 + x_of_z_w10.d3 +
            x_of_z_w11.d3,
            d4=x_of_z_w1.d4 + x_of_z_w2.d4 + x_of_z_w3.d4 + x_of_z_w4.d4 + x_of_z_w5.d4 +
            x_of_z_w6.d4 + x_of_z_w7.d4 + x_of_z_w8.d4 + x_of_z_w9.d4 + x_of_z_w10.d4 +
            x_of_z_w11.d4,
        ),
    );

    let xy_acc = reduce_5_full(
        UnreducedBigInt5(
            d0=x_of_z.d0 * x_of_z.d0,
            d1=2 * x_of_z.d0 * x_of_z.d1,
            d2=2 * x_of_z.d0 * x_of_z.d2 + x_of_z.d1 * x_of_z.d1,
            d3=2 * x_of_z.d1 * x_of_z.d2,
            d4=x_of_z.d2 * x_of_z.d2,
        ),
    );

    let poseidon_ptr = poseidon_ptr + 58 * PoseidonBuiltin.SIZE;
    let continuable_hash = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s0;
    let random_linear_combination_coeff = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s1;

    assert bitwise_ptr.x = random_linear_combination_coeff;
    assert bitwise_ptr.y = BASE_MIN_1;
    let c_i = bitwise_ptr.x_and_y;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;

    local poly_acc_sq_f: PolyAcc12 = PolyAcc12(
        xy=UnreducedBigInt3(
            d0=poly_acc_sq.xy.d0 + c_i * xy_acc.d0,
            d1=poly_acc_sq.xy.d1 + c_i * xy_acc.d1,
            d2=poly_acc_sq.xy.d2 + c_i * xy_acc.d2,
        ),
        q=E11full(
            Uint256(
                c_i * q_w.w0.low + poly_acc_sq.q.w0.low, c_i * q_w.w0.high + poly_acc_sq.q.w0.high
            ),
            Uint256(
                c_i * q_w.w1.low + poly_acc_sq.q.w1.low, c_i * q_w.w1.high + poly_acc_sq.q.w1.high
            ),
            Uint256(
                c_i * q_w.w2.low + poly_acc_sq.q.w2.low, c_i * q_w.w2.high + poly_acc_sq.q.w2.high
            ),
            Uint256(
                c_i * q_w.w3.low + poly_acc_sq.q.w3.low, c_i * q_w.w3.high + poly_acc_sq.q.w3.high
            ),
            Uint256(
                c_i * q_w.w4.low + poly_acc_sq.q.w4.low, c_i * q_w.w4.high + poly_acc_sq.q.w4.high
            ),
            Uint256(
                c_i * q_w.w5.low + poly_acc_sq.q.w5.low, c_i * q_w.w5.high + poly_acc_sq.q.w5.high
            ),
            Uint256(
                c_i * q_w.w6.low + poly_acc_sq.q.w6.low, c_i * q_w.w6.high + poly_acc_sq.q.w6.high
            ),
            Uint256(
                c_i * q_w.w7.low + poly_acc_sq.q.w7.low, c_i * q_w.w7.high + poly_acc_sq.q.w7.high
            ),
            Uint256(
                c_i * q_w.w8.low + poly_acc_sq.q.w8.low, c_i * q_w.w8.high + poly_acc_sq.q.w8.high
            ),
            Uint256(
                c_i * q_w.w9.low + poly_acc_sq.q.w9.low, c_i * q_w.w9.high + poly_acc_sq.q.w9.high
            ),
            Uint256(
                c_i * q_w.w10.low + poly_acc_sq.q.w10.low,
                c_i * q_w.w10.high + poly_acc_sq.q.w10.high,
            ),
        ),
        r=E12full(
            BigInt3(
                d0=c_i * r_w.w0.d0 + poly_acc_sq.r.w0.d0,
                d1=c_i * r_w.w0.d1 + poly_acc_sq.r.w0.d1,
                d2=c_i * r_w.w0.d2 + poly_acc_sq.r.w0.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w1.d0 + poly_acc_sq.r.w1.d0,
                d1=c_i * r_w.w1.d1 + poly_acc_sq.r.w1.d1,
                d2=c_i * r_w.w1.d2 + poly_acc_sq.r.w1.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w2.d0 + poly_acc_sq.r.w2.d0,
                d1=c_i * r_w.w2.d1 + poly_acc_sq.r.w2.d1,
                d2=c_i * r_w.w2.d2 + poly_acc_sq.r.w2.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w3.d0 + poly_acc_sq.r.w3.d0,
                d1=c_i * r_w.w3.d1 + poly_acc_sq.r.w3.d1,
                d2=c_i * r_w.w3.d2 + poly_acc_sq.r.w3.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w4.d0 + poly_acc_sq.r.w4.d0,
                d1=c_i * r_w.w4.d1 + poly_acc_sq.r.w4.d1,
                d2=c_i * r_w.w4.d2 + poly_acc_sq.r.w4.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w5.d0 + poly_acc_sq.r.w5.d0,
                d1=c_i * r_w.w5.d1 + poly_acc_sq.r.w5.d1,
                d2=c_i * r_w.w5.d2 + poly_acc_sq.r.w5.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w6.d0 + poly_acc_sq.r.w6.d0,
                d1=c_i * r_w.w6.d1 + poly_acc_sq.r.w6.d1,
                d2=c_i * r_w.w6.d2 + poly_acc_sq.r.w6.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w7.d0 + poly_acc_sq.r.w7.d0,
                d1=c_i * r_w.w7.d1 + poly_acc_sq.r.w7.d1,
                d2=c_i * r_w.w7.d2 + poly_acc_sq.r.w7.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w8.d0 + poly_acc_sq.r.w8.d0,
                d1=c_i * r_w.w8.d1 + poly_acc_sq.r.w8.d1,
                d2=c_i * r_w.w8.d2 + poly_acc_sq.r.w8.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w9.d0 + poly_acc_sq.r.w9.d0,
                d1=c_i * r_w.w9.d1 + poly_acc_sq.r.w9.d1,
                d2=c_i * r_w.w9.d2 + poly_acc_sq.r.w9.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w10.d0 + poly_acc_sq.r.w10.d0,
                d1=c_i * r_w.w10.d1 + poly_acc_sq.r.w10.d1,
                d2=c_i * r_w.w10.d2 + poly_acc_sq.r.w10.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w11.d0 + poly_acc_sq.r.w11.d0,
                d1=c_i * r_w.w11.d1 + poly_acc_sq.r.w11.d1,
                d2=c_i * r_w.w11.d2 + poly_acc_sq.r.w11.d2,
            ),
        ),
    );
    let poly_acc_sq = &poly_acc_sq_f;
    return &r_w;
}

func mul034_trick{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    z_pow1_11_ptr: ZPowers11*,
    continuable_hash: felt,
    poly_acc_034: PolyAcc034*,
}(x_ptr: E12full*, y_ptr: E12full034*) -> E12full* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local x: E12full = [x_ptr];
    local y: E12full034 = [y_ptr];
    local z_pow1_11: ZPowers11 = [z_pow1_11_ptr];
    local r_w: E12full;
    local q_w: E9full;

    %{
        from tools.py.polynomial import Polynomial
        from tools.py.field import BaseFieldElement, BaseField
        #from tools.py.extension_trick import w_to_gnark, gnark_to_w, flatten, pack_e12, mul_e12_gnark
        from starkware.cairo.common.cairo_secp.secp_utils import split
        from tools.make.utils import split_128

        p=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
        field = BaseField(p)
        x=12*[0]
        y=[1]+11*[0]
        x_refs=[ids.x.w0, ids.x.w1, ids.x.w2, ids.x.w3, ids.x.w4, ids.x.w5, ids.x.w6, ids.x.w7, ids.x.w8, ids.x.w9, ids.x.w10, ids.x.w11]
        y_refs=[(1,ids.y.w1), (3,ids.y.w3), (7,ids.y.w7), (9,ids.y.w9)]
        for i in range(ids.N_LIMBS):
            for index, ref in y_refs:
                y[index]+=as_int(getattr(ref, 'd'+str(i)), PRIME) * ids.BASE**i
            for k in range(12):
                x[k]+=as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
        #x_gnark=w_to_gnark(x)
        #y_gnark=w_to_gnark(y)
        #print(f"Y_Gnark: {y_gnark}")
        #print(f"Y_034: {y}")
        x_poly=Polynomial([BaseFieldElement(x[i], field) for i in range(12)])
        y_poly=Polynomial([BaseFieldElement(y[i], field) for i in range(12)])
        z_poly=x_poly*y_poly
        #print(f"mul034 res degree : {z_poly.degree()}")
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
        assert len(z_polyq_coeffs)<=9, f"len z_polyq_coeffs: {len(z_polyq_coeffs)}, degree: {z_polyq.degree()}"
        assert len(z_polyr_coeffs)<=12, f"len z_polyr_coeffs: {z_polyr_coeffs}, degree: {z_polyr.degree()}"
        # extend z_polyq with 0 to make it len 9:
        z_polyq_coeffs = z_polyq_coeffs + (9-len(z_polyq_coeffs))*[0]
        # extend z_polyr with 0 to make it len 12:
        z_polyr_coeffs = z_polyr_coeffs + (12-len(z_polyr_coeffs))*[0]
        #expected = flatten(mul_e12_gnark(pack_e12(x_gnark), pack_e12(y_gnark)))
        #assert expected==w_to_gnark(z_polyr_coeffs)
        #print(f"Z_PolyR: {z_polyr_coeffs}")
        #print(f"Z_PolyR_to_gnark: {w_to_gnark(z_polyr_coeffs)}")
        for i in range(12):
            val = split(z_polyr_coeffs[i]%p)
            for k in range(ids.N_LIMBS):
                rsetattr(ids.r_w, f'w{i}.d{k}', val[k])
        for i in range(9):
            val = split_128(z_polyq_coeffs[i]%p)
            rsetattr(ids.q_w, f'w{i}.low', val[0])
            rsetattr(ids.q_w, f'w{i}.high', val[1])
    %}
    assert [range_check_ptr + 0] = r_w.w0.d0;
    assert [range_check_ptr + 1] = r_w.w0.d1;
    assert [range_check_ptr + 2] = r_w.w0.d2;
    assert [range_check_ptr + 3] = r_w.w1.d0;
    assert [range_check_ptr + 4] = r_w.w1.d1;
    assert [range_check_ptr + 5] = r_w.w1.d2;
    assert [range_check_ptr + 6] = r_w.w2.d0;
    assert [range_check_ptr + 7] = r_w.w2.d1;
    assert [range_check_ptr + 8] = r_w.w2.d2;
    assert [range_check_ptr + 9] = r_w.w3.d0;
    assert [range_check_ptr + 10] = r_w.w3.d1;
    assert [range_check_ptr + 11] = r_w.w3.d2;
    assert [range_check_ptr + 12] = r_w.w4.d0;
    assert [range_check_ptr + 13] = r_w.w4.d1;
    assert [range_check_ptr + 14] = r_w.w4.d2;
    assert [range_check_ptr + 15] = r_w.w5.d0;
    assert [range_check_ptr + 16] = r_w.w5.d1;
    assert [range_check_ptr + 17] = r_w.w5.d2;
    assert [range_check_ptr + 18] = r_w.w6.d0;
    assert [range_check_ptr + 19] = r_w.w6.d1;
    assert [range_check_ptr + 20] = r_w.w6.d2;
    assert [range_check_ptr + 21] = r_w.w7.d0;
    assert [range_check_ptr + 22] = r_w.w7.d1;
    assert [range_check_ptr + 23] = r_w.w7.d2;
    assert [range_check_ptr + 24] = r_w.w8.d0;
    assert [range_check_ptr + 25] = r_w.w8.d1;
    assert [range_check_ptr + 26] = r_w.w8.d2;
    assert [range_check_ptr + 27] = r_w.w9.d0;
    assert [range_check_ptr + 28] = r_w.w9.d1;
    assert [range_check_ptr + 29] = r_w.w9.d2;
    assert [range_check_ptr + 30] = r_w.w10.d0;
    assert [range_check_ptr + 31] = r_w.w10.d1;
    assert [range_check_ptr + 32] = r_w.w10.d2;
    assert [range_check_ptr + 33] = r_w.w11.d0;
    assert [range_check_ptr + 34] = r_w.w11.d1;
    assert [range_check_ptr + 35] = r_w.w11.d2;
    assert [range_check_ptr + 36] = q_w.w0.low;
    assert [range_check_ptr + 37] = q_w.w0.high;
    assert [range_check_ptr + 38] = q_w.w1.low;
    assert [range_check_ptr + 39] = q_w.w1.high;
    assert [range_check_ptr + 40] = q_w.w2.low;
    assert [range_check_ptr + 41] = q_w.w2.high;
    assert [range_check_ptr + 42] = q_w.w3.low;
    assert [range_check_ptr + 43] = q_w.w3.high;
    assert [range_check_ptr + 44] = q_w.w4.low;
    assert [range_check_ptr + 45] = q_w.w4.high;
    assert [range_check_ptr + 46] = q_w.w5.low;
    assert [range_check_ptr + 47] = q_w.w5.high;
    assert [range_check_ptr + 48] = q_w.w6.low;
    assert [range_check_ptr + 49] = q_w.w6.high;
    assert [range_check_ptr + 50] = q_w.w7.low;
    assert [range_check_ptr + 51] = q_w.w7.high;
    assert [range_check_ptr + 52] = q_w.w8.low;
    assert [range_check_ptr + 53] = q_w.w8.high;
    assert [range_check_ptr + 54] = THREE_BASE_MIN_1 - (r_w.w0.d0 + r_w.w0.d1 + r_w.w0.d2);
    assert [range_check_ptr + 55] = THREE_BASE_MIN_1 - (r_w.w1.d0 + r_w.w1.d1 + r_w.w1.d2);
    assert [range_check_ptr + 56] = THREE_BASE_MIN_1 - (r_w.w2.d0 + r_w.w2.d1 + r_w.w2.d2);
    assert [range_check_ptr + 57] = THREE_BASE_MIN_1 - (r_w.w3.d0 + r_w.w3.d1 + r_w.w3.d2);
    assert [range_check_ptr + 58] = THREE_BASE_MIN_1 - (r_w.w4.d0 + r_w.w4.d1 + r_w.w4.d2);
    assert [range_check_ptr + 59] = THREE_BASE_MIN_1 - (r_w.w5.d0 + r_w.w5.d1 + r_w.w5.d2);
    assert [range_check_ptr + 60] = THREE_BASE_MIN_1 - (r_w.w6.d0 + r_w.w6.d1 + r_w.w6.d2);
    assert [range_check_ptr + 61] = THREE_BASE_MIN_1 - (r_w.w7.d0 + r_w.w7.d1 + r_w.w7.d2);
    assert [range_check_ptr + 62] = THREE_BASE_MIN_1 - (r_w.w8.d0 + r_w.w8.d1 + r_w.w8.d2);
    assert [range_check_ptr + 63] = THREE_BASE_MIN_1 - (r_w.w9.d0 + r_w.w9.d1 + r_w.w9.d2);
    assert [range_check_ptr + 64] = THREE_BASE_MIN_1 - (r_w.w10.d0 + r_w.w10.d1 + r_w.w10.d2);
    assert [range_check_ptr + 65] = THREE_BASE_MIN_1 - (r_w.w11.d0 + r_w.w11.d1 + r_w.w11.d2);

    tempvar range_check_ptr = range_check_ptr + 66;

    assert poseidon_ptr.input = PoseidonBuiltinState(
        s0=x.w0.d0 * x.w0.d1, s1=continuable_hash, s2=2
    );
    assert poseidon_ptr[1].input = PoseidonBuiltinState(
        s0=x.w0.d2 * x.w1.d0, s1=poseidon_ptr[0].output.s0, s2=2
    );
    assert poseidon_ptr[2].input = PoseidonBuiltinState(
        s0=x.w1.d1 * x.w1.d2, s1=poseidon_ptr[1].output.s0, s2=2
    );
    assert poseidon_ptr[3].input = PoseidonBuiltinState(
        s0=x.w2.d0 * x.w2.d1, s1=poseidon_ptr[2].output.s0, s2=2
    );
    assert poseidon_ptr[4].input = PoseidonBuiltinState(
        s0=x.w2.d2 * x.w3.d0, s1=poseidon_ptr[3].output.s0, s2=2
    );
    assert poseidon_ptr[5].input = PoseidonBuiltinState(
        s0=x.w3.d1 * x.w3.d2, s1=poseidon_ptr[4].output.s0, s2=2
    );
    assert poseidon_ptr[6].input = PoseidonBuiltinState(
        s0=x.w4.d0 * x.w4.d1, s1=poseidon_ptr[5].output.s0, s2=2
    );
    assert poseidon_ptr[7].input = PoseidonBuiltinState(
        s0=x.w4.d2 * x.w5.d0, s1=poseidon_ptr[6].output.s0, s2=2
    );
    assert poseidon_ptr[8].input = PoseidonBuiltinState(
        s0=x.w5.d1 * x.w5.d2, s1=poseidon_ptr[7].output.s0, s2=2
    );
    assert poseidon_ptr[9].input = PoseidonBuiltinState(
        s0=x.w6.d0 * x.w6.d1, s1=poseidon_ptr[8].output.s0, s2=2
    );
    assert poseidon_ptr[10].input = PoseidonBuiltinState(
        s0=x.w6.d2 * x.w7.d0, s1=poseidon_ptr[9].output.s0, s2=2
    );
    assert poseidon_ptr[11].input = PoseidonBuiltinState(
        s0=x.w7.d1 * x.w7.d2, s1=poseidon_ptr[10].output.s0, s2=2
    );
    assert poseidon_ptr[12].input = PoseidonBuiltinState(
        s0=x.w8.d0 * x.w8.d1, s1=poseidon_ptr[11].output.s0, s2=2
    );
    assert poseidon_ptr[13].input = PoseidonBuiltinState(
        s0=x.w8.d2 * x.w9.d0, s1=poseidon_ptr[12].output.s0, s2=2
    );
    assert poseidon_ptr[14].input = PoseidonBuiltinState(
        s0=x.w9.d1 * x.w9.d2, s1=poseidon_ptr[13].output.s0, s2=2
    );
    assert poseidon_ptr[15].input = PoseidonBuiltinState(
        s0=x.w10.d0 * x.w10.d1, s1=poseidon_ptr[14].output.s0, s2=2
    );
    assert poseidon_ptr[16].input = PoseidonBuiltinState(
        s0=x.w10.d2 * x.w11.d0, s1=poseidon_ptr[15].output.s0, s2=2
    );
    assert poseidon_ptr[17].input = PoseidonBuiltinState(
        s0=x.w11.d1 * x.w11.d2, s1=poseidon_ptr[16].output.s0, s2=2
    );
    assert poseidon_ptr[18].input = PoseidonBuiltinState(
        s0=y.w1.d0 * y.w1.d1, s1=poseidon_ptr[17].output.s0, s2=2
    );
    assert poseidon_ptr[19].input = PoseidonBuiltinState(
        s0=y.w1.d2 * y.w3.d0, s1=poseidon_ptr[18].output.s0, s2=2
    );
    assert poseidon_ptr[20].input = PoseidonBuiltinState(
        s0=y.w3.d1 * y.w3.d2, s1=poseidon_ptr[19].output.s0, s2=2
    );
    assert poseidon_ptr[21].input = PoseidonBuiltinState(
        s0=y.w7.d0 * y.w7.d1, s1=poseidon_ptr[20].output.s0, s2=2
    );
    assert poseidon_ptr[22].input = PoseidonBuiltinState(
        s0=y.w7.d2 * y.w9.d0, s1=poseidon_ptr[21].output.s0, s2=2
    );
    assert poseidon_ptr[23].input = PoseidonBuiltinState(
        s0=y.w9.d1 * y.w9.d2, s1=poseidon_ptr[22].output.s0, s2=2
    );
    assert poseidon_ptr[24].input = PoseidonBuiltinState(
        s0=q_w.w0.low, s1=poseidon_ptr[23].output.s0, s2=2
    );
    assert poseidon_ptr[25].input = PoseidonBuiltinState(
        s0=q_w.w0.high, s1=poseidon_ptr[24].output.s0, s2=2
    );
    assert poseidon_ptr[26].input = PoseidonBuiltinState(
        s0=q_w.w1.low, s1=poseidon_ptr[25].output.s0, s2=2
    );
    assert poseidon_ptr[27].input = PoseidonBuiltinState(
        s0=q_w.w1.high, s1=poseidon_ptr[26].output.s0, s2=2
    );
    assert poseidon_ptr[28].input = PoseidonBuiltinState(
        s0=q_w.w2.low, s1=poseidon_ptr[27].output.s0, s2=2
    );
    assert poseidon_ptr[29].input = PoseidonBuiltinState(
        s0=q_w.w2.high, s1=poseidon_ptr[28].output.s0, s2=2
    );
    assert poseidon_ptr[30].input = PoseidonBuiltinState(
        s0=q_w.w3.low, s1=poseidon_ptr[29].output.s0, s2=2
    );
    assert poseidon_ptr[31].input = PoseidonBuiltinState(
        s0=q_w.w3.high, s1=poseidon_ptr[30].output.s0, s2=2
    );
    assert poseidon_ptr[32].input = PoseidonBuiltinState(
        s0=q_w.w4.low, s1=poseidon_ptr[31].output.s0, s2=2
    );
    assert poseidon_ptr[33].input = PoseidonBuiltinState(
        s0=q_w.w4.high, s1=poseidon_ptr[32].output.s0, s2=2
    );
    assert poseidon_ptr[34].input = PoseidonBuiltinState(
        s0=q_w.w5.low, s1=poseidon_ptr[33].output.s0, s2=2
    );
    assert poseidon_ptr[35].input = PoseidonBuiltinState(
        s0=q_w.w5.high, s1=poseidon_ptr[34].output.s0, s2=2
    );
    assert poseidon_ptr[36].input = PoseidonBuiltinState(
        s0=q_w.w6.low, s1=poseidon_ptr[35].output.s0, s2=2
    );
    assert poseidon_ptr[37].input = PoseidonBuiltinState(
        s0=q_w.w6.high, s1=poseidon_ptr[36].output.s0, s2=2
    );
    assert poseidon_ptr[38].input = PoseidonBuiltinState(
        s0=q_w.w7.low, s1=poseidon_ptr[37].output.s0, s2=2
    );
    assert poseidon_ptr[39].input = PoseidonBuiltinState(
        s0=q_w.w7.high, s1=poseidon_ptr[38].output.s0, s2=2
    );
    assert poseidon_ptr[40].input = PoseidonBuiltinState(
        s0=q_w.w8.low, s1=poseidon_ptr[39].output.s0, s2=2
    );
    assert poseidon_ptr[41].input = PoseidonBuiltinState(
        s0=q_w.w8.high, s1=poseidon_ptr[40].output.s0, s2=2
    );
    assert poseidon_ptr[42].input = PoseidonBuiltinState(
        s0=r_w.w0.d0 * r_w.w0.d1, s1=poseidon_ptr[41].output.s0, s2=2
    );
    assert poseidon_ptr[43].input = PoseidonBuiltinState(
        s0=r_w.w0.d2 * r_w.w1.d0, s1=poseidon_ptr[42].output.s0, s2=2
    );
    assert poseidon_ptr[44].input = PoseidonBuiltinState(
        s0=r_w.w1.d1 * r_w.w1.d2, s1=poseidon_ptr[43].output.s0, s2=2
    );
    assert poseidon_ptr[45].input = PoseidonBuiltinState(
        s0=r_w.w2.d0 * r_w.w2.d1, s1=poseidon_ptr[44].output.s0, s2=2
    );
    assert poseidon_ptr[46].input = PoseidonBuiltinState(
        s0=r_w.w2.d2 * r_w.w3.d0, s1=poseidon_ptr[45].output.s0, s2=2
    );
    assert poseidon_ptr[47].input = PoseidonBuiltinState(
        s0=r_w.w3.d1 * r_w.w3.d2, s1=poseidon_ptr[46].output.s0, s2=2
    );
    assert poseidon_ptr[48].input = PoseidonBuiltinState(
        s0=r_w.w4.d0 * r_w.w4.d1, s1=poseidon_ptr[47].output.s0, s2=2
    );
    assert poseidon_ptr[49].input = PoseidonBuiltinState(
        s0=r_w.w4.d2 * r_w.w5.d0, s1=poseidon_ptr[48].output.s0, s2=2
    );
    assert poseidon_ptr[50].input = PoseidonBuiltinState(
        s0=r_w.w5.d1 * r_w.w5.d2, s1=poseidon_ptr[49].output.s0, s2=2
    );
    assert poseidon_ptr[51].input = PoseidonBuiltinState(
        s0=r_w.w6.d0 * r_w.w6.d1, s1=poseidon_ptr[50].output.s0, s2=2
    );
    assert poseidon_ptr[52].input = PoseidonBuiltinState(
        s0=r_w.w6.d2 * r_w.w7.d0, s1=poseidon_ptr[51].output.s0, s2=2
    );
    assert poseidon_ptr[53].input = PoseidonBuiltinState(
        s0=r_w.w7.d1 * r_w.w7.d2, s1=poseidon_ptr[52].output.s0, s2=2
    );
    assert poseidon_ptr[54].input = PoseidonBuiltinState(
        s0=r_w.w8.d0 * r_w.w8.d1, s1=poseidon_ptr[53].output.s0, s2=2
    );
    assert poseidon_ptr[55].input = PoseidonBuiltinState(
        s0=r_w.w8.d2 * r_w.w9.d0, s1=poseidon_ptr[54].output.s0, s2=2
    );
    assert poseidon_ptr[56].input = PoseidonBuiltinState(
        s0=r_w.w9.d1 * r_w.w9.d2, s1=poseidon_ptr[55].output.s0, s2=2
    );
    assert poseidon_ptr[57].input = PoseidonBuiltinState(
        s0=r_w.w10.d0 * r_w.w10.d1, s1=poseidon_ptr[56].output.s0, s2=2
    );
    assert poseidon_ptr[58].input = PoseidonBuiltinState(
        s0=r_w.w10.d2 * r_w.w11.d0, s1=poseidon_ptr[57].output.s0, s2=2
    );
    assert poseidon_ptr[59].input = PoseidonBuiltinState(
        s0=r_w.w11.d1 * r_w.w11.d2, s1=poseidon_ptr[58].output.s0, s2=2
    );

    tempvar x_of_z_w1 = UnreducedBigInt5(
        d0=x.w1.d0 * z_pow1_11.z_1.d0,
        d1=x.w1.d0 * z_pow1_11.z_1.d1 + x.w1.d1 * z_pow1_11.z_1.d0,
        d2=x.w1.d0 * z_pow1_11.z_1.d2 + x.w1.d1 * z_pow1_11.z_1.d1 + x.w1.d2 * z_pow1_11.z_1.d0,
        d3=x.w1.d1 * z_pow1_11.z_1.d2 + x.w1.d2 * z_pow1_11.z_1.d1,
        d4=x.w1.d2 * z_pow1_11.z_1.d2,
    );
    tempvar x_of_z_w2 = UnreducedBigInt5(
        d0=x.w2.d0 * z_pow1_11.z_2.d0,
        d1=x.w2.d0 * z_pow1_11.z_2.d1 + x.w2.d1 * z_pow1_11.z_2.d0,
        d2=x.w2.d0 * z_pow1_11.z_2.d2 + x.w2.d1 * z_pow1_11.z_2.d1 + x.w2.d2 * z_pow1_11.z_2.d0,
        d3=x.w2.d1 * z_pow1_11.z_2.d2 + x.w2.d2 * z_pow1_11.z_2.d1,
        d4=x.w2.d2 * z_pow1_11.z_2.d2,
    );

    tempvar x_of_z_w3 = UnreducedBigInt5(
        d0=x.w3.d0 * z_pow1_11.z_3.d0,
        d1=x.w3.d0 * z_pow1_11.z_3.d1 + x.w3.d1 * z_pow1_11.z_3.d0,
        d2=x.w3.d0 * z_pow1_11.z_3.d2 + x.w3.d1 * z_pow1_11.z_3.d1 + x.w3.d2 * z_pow1_11.z_3.d0,
        d3=x.w3.d1 * z_pow1_11.z_3.d2 + x.w3.d2 * z_pow1_11.z_3.d1,
        d4=x.w3.d2 * z_pow1_11.z_3.d2,
    );

    tempvar x_of_z_w4 = UnreducedBigInt5(
        d0=x.w4.d0 * z_pow1_11.z_4.d0,
        d1=x.w4.d0 * z_pow1_11.z_4.d1 + x.w4.d1 * z_pow1_11.z_4.d0,
        d2=x.w4.d0 * z_pow1_11.z_4.d2 + x.w4.d1 * z_pow1_11.z_4.d1 + x.w4.d2 * z_pow1_11.z_4.d0,
        d3=x.w4.d1 * z_pow1_11.z_4.d2 + x.w4.d2 * z_pow1_11.z_4.d1,
        d4=x.w4.d2 * z_pow1_11.z_4.d2,
    );

    tempvar x_of_z_w5 = UnreducedBigInt5(
        d0=x.w5.d0 * z_pow1_11.z_5.d0,
        d1=x.w5.d0 * z_pow1_11.z_5.d1 + x.w5.d1 * z_pow1_11.z_5.d0,
        d2=x.w5.d0 * z_pow1_11.z_5.d2 + x.w5.d1 * z_pow1_11.z_5.d1 + x.w5.d2 * z_pow1_11.z_5.d0,
        d3=x.w5.d1 * z_pow1_11.z_5.d2 + x.w5.d2 * z_pow1_11.z_5.d1,
        d4=x.w5.d2 * z_pow1_11.z_5.d2,
    );

    tempvar x_of_z_w6 = UnreducedBigInt5(
        d0=x.w6.d0 * z_pow1_11.z_6.d0,
        d1=x.w6.d0 * z_pow1_11.z_6.d1 + x.w6.d1 * z_pow1_11.z_6.d0,
        d2=x.w6.d0 * z_pow1_11.z_6.d2 + x.w6.d1 * z_pow1_11.z_6.d1 + x.w6.d2 * z_pow1_11.z_6.d0,
        d3=x.w6.d1 * z_pow1_11.z_6.d2 + x.w6.d2 * z_pow1_11.z_6.d1,
        d4=x.w6.d2 * z_pow1_11.z_6.d2,
    );

    tempvar x_of_z_w7 = UnreducedBigInt5(
        d0=x.w7.d0 * z_pow1_11.z_7.d0,
        d1=x.w7.d0 * z_pow1_11.z_7.d1 + x.w7.d1 * z_pow1_11.z_7.d0,
        d2=x.w7.d0 * z_pow1_11.z_7.d2 + x.w7.d1 * z_pow1_11.z_7.d1 + x.w7.d2 * z_pow1_11.z_7.d0,
        d3=x.w7.d1 * z_pow1_11.z_7.d2 + x.w7.d2 * z_pow1_11.z_7.d1,
        d4=x.w7.d2 * z_pow1_11.z_7.d2,
    );

    tempvar x_of_z_w8 = UnreducedBigInt5(
        d0=x.w8.d0 * z_pow1_11.z_8.d0,
        d1=x.w8.d0 * z_pow1_11.z_8.d1 + x.w8.d1 * z_pow1_11.z_8.d0,
        d2=x.w8.d0 * z_pow1_11.z_8.d2 + x.w8.d1 * z_pow1_11.z_8.d1 + x.w8.d2 * z_pow1_11.z_8.d0,
        d3=x.w8.d1 * z_pow1_11.z_8.d2 + x.w8.d2 * z_pow1_11.z_8.d1,
        d4=x.w8.d2 * z_pow1_11.z_8.d2,
    );

    tempvar x_of_z_w9 = UnreducedBigInt5(
        d0=x.w9.d0 * z_pow1_11.z_9.d0,
        d1=x.w9.d0 * z_pow1_11.z_9.d1 + x.w9.d1 * z_pow1_11.z_9.d0,
        d2=x.w9.d0 * z_pow1_11.z_9.d2 + x.w9.d1 * z_pow1_11.z_9.d1 + x.w9.d2 * z_pow1_11.z_9.d0,
        d3=x.w9.d1 * z_pow1_11.z_9.d2 + x.w9.d2 * z_pow1_11.z_9.d1,
        d4=x.w9.d2 * z_pow1_11.z_9.d2,
    );

    tempvar x_of_z_w10 = UnreducedBigInt5(
        d0=x.w10.d0 * z_pow1_11.z_10.d0,
        d1=x.w10.d0 * z_pow1_11.z_10.d1 + x.w10.d1 * z_pow1_11.z_10.d0,
        d2=x.w10.d0 * z_pow1_11.z_10.d2 + x.w10.d1 * z_pow1_11.z_10.d1 + x.w10.d2 *
        z_pow1_11.z_10.d0,
        d3=x.w10.d1 * z_pow1_11.z_10.d2 + x.w10.d2 * z_pow1_11.z_10.d1,
        d4=x.w10.d2 * z_pow1_11.z_10.d2,
    );

    tempvar x_of_z_w11 = UnreducedBigInt5(
        d0=x.w11.d0 * z_pow1_11.z_11.d0,
        d1=x.w11.d0 * z_pow1_11.z_11.d1 + x.w11.d1 * z_pow1_11.z_11.d0,
        d2=x.w11.d0 * z_pow1_11.z_11.d2 + x.w11.d1 * z_pow1_11.z_11.d1 + x.w11.d2 *
        z_pow1_11.z_11.d0,
        d3=x.w11.d1 * z_pow1_11.z_11.d2 + x.w11.d2 * z_pow1_11.z_11.d1,
        d4=x.w11.d2 * z_pow1_11.z_11.d2,
    );

    let x_of_z = reduce_5_full(
        UnreducedBigInt5(
            d0=x.w0.d0 + x_of_z_w1.d0 + x_of_z_w2.d0 + x_of_z_w3.d0 + x_of_z_w4.d0 + x_of_z_w5.d0 +
            x_of_z_w6.d0 + x_of_z_w7.d0 + x_of_z_w8.d0 + x_of_z_w9.d0 + x_of_z_w10.d0 +
            x_of_z_w11.d0,
            d1=x.w0.d1 + x_of_z_w1.d1 + x_of_z_w2.d1 + x_of_z_w3.d1 + x_of_z_w4.d1 + x_of_z_w5.d1 +
            x_of_z_w6.d1 + x_of_z_w7.d1 + x_of_z_w8.d1 + x_of_z_w9.d1 + x_of_z_w10.d1 +
            x_of_z_w11.d1,
            d2=x.w0.d2 + x_of_z_w1.d2 + x_of_z_w2.d2 + x_of_z_w3.d2 + x_of_z_w4.d2 + x_of_z_w5.d2 +
            x_of_z_w6.d2 + x_of_z_w7.d2 + x_of_z_w8.d2 + x_of_z_w9.d2 + x_of_z_w10.d2 +
            x_of_z_w11.d2,
            d3=x_of_z_w1.d3 + x_of_z_w2.d3 + x_of_z_w3.d3 + x_of_z_w4.d3 + x_of_z_w5.d3 +
            x_of_z_w6.d3 + x_of_z_w7.d3 + x_of_z_w8.d3 + x_of_z_w9.d3 + x_of_z_w10.d3 +
            x_of_z_w11.d3,
            d4=x_of_z_w1.d4 + x_of_z_w2.d4 + x_of_z_w3.d4 + x_of_z_w4.d4 + x_of_z_w5.d4 +
            x_of_z_w6.d4 + x_of_z_w7.d4 + x_of_z_w8.d4 + x_of_z_w9.d4 + x_of_z_w10.d4 +
            x_of_z_w11.d4,
        ),
    );

    tempvar y_of_z_w1 = UnreducedBigInt5(
        d0=y.w1.d0 * z_pow1_11.z_1.d0,
        d1=y.w1.d0 * z_pow1_11.z_1.d1 + y.w1.d1 * z_pow1_11.z_1.d0,
        d2=y.w1.d0 * z_pow1_11.z_1.d2 + y.w1.d1 * z_pow1_11.z_1.d1 + y.w1.d2 * z_pow1_11.z_1.d0,
        d3=y.w1.d1 * z_pow1_11.z_1.d2 + y.w1.d2 * z_pow1_11.z_1.d1,
        d4=y.w1.d2 * z_pow1_11.z_1.d2,
    );

    tempvar y_of_z_w3 = UnreducedBigInt5(
        d0=y.w3.d0 * z_pow1_11.z_3.d0,
        d1=y.w3.d0 * z_pow1_11.z_3.d1 + y.w3.d1 * z_pow1_11.z_3.d0,
        d2=y.w3.d0 * z_pow1_11.z_3.d2 + y.w3.d1 * z_pow1_11.z_3.d1 + y.w3.d2 * z_pow1_11.z_3.d0,
        d3=y.w3.d1 * z_pow1_11.z_3.d2 + y.w3.d2 * z_pow1_11.z_3.d1,
        d4=y.w3.d2 * z_pow1_11.z_3.d2,
    );

    tempvar y_of_z_w7 = UnreducedBigInt5(
        d0=y.w7.d0 * z_pow1_11.z_7.d0,
        d1=y.w7.d0 * z_pow1_11.z_7.d1 + y.w7.d1 * z_pow1_11.z_7.d0,
        d2=y.w7.d0 * z_pow1_11.z_7.d2 + y.w7.d1 * z_pow1_11.z_7.d1 + y.w7.d2 * z_pow1_11.z_7.d0,
        d3=y.w7.d1 * z_pow1_11.z_7.d2 + y.w7.d2 * z_pow1_11.z_7.d1,
        d4=y.w7.d2 * z_pow1_11.z_7.d2,
    );

    tempvar y_of_z_w9 = UnreducedBigInt5(
        d0=y.w9.d0 * z_pow1_11.z_9.d0,
        d1=y.w9.d0 * z_pow1_11.z_9.d1 + y.w9.d1 * z_pow1_11.z_9.d0,
        d2=y.w9.d0 * z_pow1_11.z_9.d2 + y.w9.d1 * z_pow1_11.z_9.d1 + y.w9.d2 * z_pow1_11.z_9.d0,
        d3=y.w9.d1 * z_pow1_11.z_9.d2 + y.w9.d2 * z_pow1_11.z_9.d1,
        d4=y.w9.d2 * z_pow1_11.z_9.d2,
    );

    let y_of_z = reduce_5_full(
        UnreducedBigInt5(
            d0=1 + y_of_z_w1.d0 + y_of_z_w3.d0 + y_of_z_w7.d0 + y_of_z_w9.d0,
            d1=y_of_z_w1.d1 + y_of_z_w3.d1 + y_of_z_w7.d1 + y_of_z_w9.d1,
            d2=y_of_z_w1.d2 + y_of_z_w3.d2 + y_of_z_w7.d2 + y_of_z_w9.d2,
            d3=y_of_z_w1.d3 + y_of_z_w3.d3 + y_of_z_w7.d3 + y_of_z_w9.d3,
            d4=y_of_z_w1.d4 + y_of_z_w3.d4 + y_of_z_w7.d4 + y_of_z_w9.d4,
        ),
    );

    let xy_acc = reduce_5_full(
        UnreducedBigInt5(
            d0=x_of_z.d0 * y_of_z.d0,
            d1=x_of_z.d0 * y_of_z.d1 + x_of_z.d1 * y_of_z.d0,
            d2=x_of_z.d0 * y_of_z.d2 + x_of_z.d1 * y_of_z.d1 + x_of_z.d2 * y_of_z.d0,
            d3=x_of_z.d1 * y_of_z.d2 + x_of_z.d2 * y_of_z.d1,
            d4=x_of_z.d2 * y_of_z.d2,
        ),
    );

    let poseidon_ptr = poseidon_ptr + 60 * PoseidonBuiltin.SIZE;
    let continuable_hash = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s0;
    let random_linear_combination_coeff = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s1;
    assert bitwise_ptr.x = random_linear_combination_coeff;
    assert bitwise_ptr.y = BASE_MIN_1;
    let c_i = bitwise_ptr.x_and_y;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;

    local poly_acc_034_f: PolyAcc034 = PolyAcc034(
        xy=UnreducedBigInt3(
            d0=poly_acc_034.xy.d0 + c_i * xy_acc.d0,
            d1=poly_acc_034.xy.d1 + c_i * xy_acc.d1,
            d2=poly_acc_034.xy.d2 + c_i * xy_acc.d2,
        ),
        q=E9full(
            Uint256(
                c_i * q_w.w0.low + poly_acc_034.q.w0.low, c_i * q_w.w0.high + poly_acc_034.q.w0.high
            ),
            Uint256(
                c_i * q_w.w1.low + poly_acc_034.q.w1.low, c_i * q_w.w1.high + poly_acc_034.q.w1.high
            ),
            Uint256(
                c_i * q_w.w2.low + poly_acc_034.q.w2.low, c_i * q_w.w2.high + poly_acc_034.q.w2.high
            ),
            Uint256(
                c_i * q_w.w3.low + poly_acc_034.q.w3.low, c_i * q_w.w3.high + poly_acc_034.q.w3.high
            ),
            Uint256(
                c_i * q_w.w4.low + poly_acc_034.q.w4.low, c_i * q_w.w4.high + poly_acc_034.q.w4.high
            ),
            Uint256(
                c_i * q_w.w5.low + poly_acc_034.q.w5.low, c_i * q_w.w5.high + poly_acc_034.q.w5.high
            ),
            Uint256(
                c_i * q_w.w6.low + poly_acc_034.q.w6.low, c_i * q_w.w6.high + poly_acc_034.q.w6.high
            ),
            Uint256(
                c_i * q_w.w7.low + poly_acc_034.q.w7.low, c_i * q_w.w7.high + poly_acc_034.q.w7.high
            ),
            Uint256(
                c_i * q_w.w8.low + poly_acc_034.q.w8.low, c_i * q_w.w8.high + poly_acc_034.q.w8.high
            ),
        ),
        r=E12full(
            BigInt3(
                d0=c_i * r_w.w0.d0 + poly_acc_034.r.w0.d0,
                d1=c_i * r_w.w0.d1 + poly_acc_034.r.w0.d1,
                d2=c_i * r_w.w0.d2 + poly_acc_034.r.w0.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w1.d0 + poly_acc_034.r.w1.d0,
                d1=c_i * r_w.w1.d1 + poly_acc_034.r.w1.d1,
                d2=c_i * r_w.w1.d2 + poly_acc_034.r.w1.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w2.d0 + poly_acc_034.r.w2.d0,
                d1=c_i * r_w.w2.d1 + poly_acc_034.r.w2.d1,
                d2=c_i * r_w.w2.d2 + poly_acc_034.r.w2.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w3.d0 + poly_acc_034.r.w3.d0,
                d1=c_i * r_w.w3.d1 + poly_acc_034.r.w3.d1,
                d2=c_i * r_w.w3.d2 + poly_acc_034.r.w3.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w4.d0 + poly_acc_034.r.w4.d0,
                d1=c_i * r_w.w4.d1 + poly_acc_034.r.w4.d1,
                d2=c_i * r_w.w4.d2 + poly_acc_034.r.w4.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w5.d0 + poly_acc_034.r.w5.d0,
                d1=c_i * r_w.w5.d1 + poly_acc_034.r.w5.d1,
                d2=c_i * r_w.w5.d2 + poly_acc_034.r.w5.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w6.d0 + poly_acc_034.r.w6.d0,
                d1=c_i * r_w.w6.d1 + poly_acc_034.r.w6.d1,
                d2=c_i * r_w.w6.d2 + poly_acc_034.r.w6.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w7.d0 + poly_acc_034.r.w7.d0,
                d1=c_i * r_w.w7.d1 + poly_acc_034.r.w7.d1,
                d2=c_i * r_w.w7.d2 + poly_acc_034.r.w7.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w8.d0 + poly_acc_034.r.w8.d0,
                d1=c_i * r_w.w8.d1 + poly_acc_034.r.w8.d1,
                d2=c_i * r_w.w8.d2 + poly_acc_034.r.w8.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w9.d0 + poly_acc_034.r.w9.d0,
                d1=c_i * r_w.w9.d1 + poly_acc_034.r.w9.d1,
                d2=c_i * r_w.w9.d2 + poly_acc_034.r.w9.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w10.d0 + poly_acc_034.r.w10.d0,
                d1=c_i * r_w.w10.d1 + poly_acc_034.r.w10.d1,
                d2=c_i * r_w.w10.d2 + poly_acc_034.r.w10.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w11.d0 + poly_acc_034.r.w11.d0,
                d1=c_i * r_w.w11.d1 + poly_acc_034.r.w11.d1,
                d2=c_i * r_w.w11.d2 + poly_acc_034.r.w11.d2,
            ),
        ),
    );
    let poly_acc_034 = &poly_acc_034_f;
    return &r_w;
}

func mul034_034_trick{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    z_pow1_11_ptr: ZPowers11*,
    continuable_hash: felt,
    poly_acc_034034: PolyAcc034034*,
}(x_ptr: E12full034*, y_ptr: E12full034*) -> E12full01234* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local x: E12full034 = [x_ptr];
    local y: E12full034 = [y_ptr];
    local z_pow1_11: ZPowers11 = [z_pow1_11_ptr];
    local r_w: E12full01234;
    local q_w: E7full;

    // w5 = 0

    %{
        from tools.py.polynomial import Polynomial
        from tools.py.field import BaseFieldElement, BaseField
        from tools.py.extension_trick import w_to_gnark, gnark_to_w, flatten, pack_e12, mul_e12_gnark
        from starkware.cairo.common.cairo_secp.secp_utils import split
        from tools.make.utils import split_128

        p=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
        field = BaseField(p)
        x=[1]+11*[0]
        y=[1]+11*[0]
        x_refs=[(1,ids.x.w1), (3,ids.x.w3), (7,ids.x.w7), (9,ids.x.w9)]
        y_refs=[(1,ids.y.w1), (3,ids.y.w3), (7,ids.y.w7), (9,ids.y.w9)]
        for i in range(ids.N_LIMBS):
            for index, ref in y_refs:
                y[index]+=as_int(getattr(ref, 'd'+str(i)), PRIME) * ids.BASE**i
            for index, ref in x_refs:
                x[index]+=as_int(getattr(ref, 'd'+str(i)), PRIME) * ids.BASE**i
        x_gnark=w_to_gnark(x)
        y_gnark=w_to_gnark(y)
        #print(f"Y_Gnark: {y_gnark}")
        #print(f"Y_034034: {y}")
        x_poly=Polynomial([BaseFieldElement(x[i], field) for i in range(12)])
        y_poly=Polynomial([BaseFieldElement(y[i], field) for i in range(12)])
        z_poly=x_poly*y_poly
        #print(f"mul034034 res degree : {z_poly.degree()}")
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
        assert len(z_polyq_coeffs)<=7, f"len z_polyq_coeffs: {len(z_polyq_coeffs)}, degree: {z_polyq.degree()}"
        assert len(z_polyr_coeffs)<=12, f"len z_polyr_coeffs: {z_polyr_coeffs}, degree: {z_polyr.degree()}"
        assert z_polyr_coeffs[5]==0, f"Not a 01234"
        # extend z_polyq with 0 to make it len 9:
        z_polyq_coeffs = z_polyq_coeffs + (7-len(z_polyq_coeffs))*[0]
        # extend z_polyr with 0 to make it len 12:
        z_polyr_coeffs = z_polyr_coeffs + (12-len(z_polyr_coeffs))*[0]
        expected = flatten(mul_e12_gnark(pack_e12(x_gnark), pack_e12(y_gnark)))
        assert expected==w_to_gnark(z_polyr_coeffs), f"expected: {expected}, got: {w_to_gnark(z_polyr_coeffs)}"
        #print(f"Z_PolyR: {z_polyr_coeffs}")
        #print(f"Z_PolyR_to_gnark: {w_to_gnark(z_polyr_coeffs)}")
        for i in range(12):
            if i==5:
                continue
            val = split(z_polyr_coeffs[i]%p)
            for k in range(3):
                rsetattr(ids.r_w, f'w{i}.d{k}', val[k])
        for i in range(7):
            val = split_128(z_polyq_coeffs[i]%p)
            rsetattr(ids.q_w, f'w{i}.low', val[0])
            rsetattr(ids.q_w, f'w{i}.high', val[1])
    %}
    assert [range_check_ptr + 0] = r_w.w0.d0;
    assert [range_check_ptr + 1] = r_w.w0.d1;
    assert [range_check_ptr + 2] = r_w.w0.d2;
    assert [range_check_ptr + 3] = r_w.w1.d0;
    assert [range_check_ptr + 4] = r_w.w1.d1;
    assert [range_check_ptr + 5] = r_w.w1.d2;
    assert [range_check_ptr + 6] = r_w.w2.d0;
    assert [range_check_ptr + 7] = r_w.w2.d1;
    assert [range_check_ptr + 8] = r_w.w2.d2;
    assert [range_check_ptr + 9] = r_w.w3.d0;
    assert [range_check_ptr + 10] = r_w.w3.d1;
    assert [range_check_ptr + 11] = r_w.w3.d2;
    assert [range_check_ptr + 12] = r_w.w4.d0;
    assert [range_check_ptr + 13] = r_w.w4.d1;
    assert [range_check_ptr + 14] = r_w.w4.d2;
    assert [range_check_ptr + 15] = r_w.w6.d0;
    assert [range_check_ptr + 16] = r_w.w6.d1;
    assert [range_check_ptr + 17] = r_w.w6.d2;
    assert [range_check_ptr + 18] = r_w.w7.d0;
    assert [range_check_ptr + 19] = r_w.w7.d1;
    assert [range_check_ptr + 20] = r_w.w7.d2;
    assert [range_check_ptr + 21] = r_w.w8.d0;
    assert [range_check_ptr + 22] = r_w.w8.d1;
    assert [range_check_ptr + 23] = r_w.w8.d2;
    assert [range_check_ptr + 24] = r_w.w9.d0;
    assert [range_check_ptr + 25] = r_w.w9.d1;
    assert [range_check_ptr + 26] = r_w.w9.d2;
    assert [range_check_ptr + 27] = r_w.w10.d0;
    assert [range_check_ptr + 28] = r_w.w10.d1;
    assert [range_check_ptr + 29] = r_w.w10.d2;
    assert [range_check_ptr + 30] = r_w.w11.d0;
    assert [range_check_ptr + 31] = r_w.w11.d1;
    assert [range_check_ptr + 32] = r_w.w11.d2;
    assert [range_check_ptr + 33] = q_w.w0.low;
    assert [range_check_ptr + 34] = q_w.w0.high;
    assert [range_check_ptr + 35] = q_w.w1.low;
    assert [range_check_ptr + 36] = q_w.w1.high;
    assert [range_check_ptr + 37] = q_w.w2.low;
    assert [range_check_ptr + 38] = q_w.w2.high;
    assert [range_check_ptr + 39] = q_w.w3.low;
    assert [range_check_ptr + 40] = q_w.w3.high;
    assert [range_check_ptr + 41] = q_w.w4.low;
    assert [range_check_ptr + 42] = q_w.w4.high;
    assert [range_check_ptr + 43] = q_w.w5.low;
    assert [range_check_ptr + 44] = q_w.w5.high;
    assert [range_check_ptr + 45] = q_w.w6.low;
    assert [range_check_ptr + 46] = q_w.w6.high;
    assert [range_check_ptr + 47] = THREE_BASE_MIN_1 - (r_w.w0.d0 + r_w.w0.d1 + r_w.w0.d2);
    assert [range_check_ptr + 48] = THREE_BASE_MIN_1 - (r_w.w1.d0 + r_w.w1.d1 + r_w.w1.d2);
    assert [range_check_ptr + 49] = THREE_BASE_MIN_1 - (r_w.w2.d0 + r_w.w2.d1 + r_w.w2.d2);
    assert [range_check_ptr + 50] = THREE_BASE_MIN_1 - (r_w.w3.d0 + r_w.w3.d1 + r_w.w3.d2);
    assert [range_check_ptr + 51] = THREE_BASE_MIN_1 - (r_w.w4.d0 + r_w.w4.d1 + r_w.w4.d2);
    assert [range_check_ptr + 52] = THREE_BASE_MIN_1 - (r_w.w6.d0 + r_w.w6.d1 + r_w.w6.d2);
    assert [range_check_ptr + 53] = THREE_BASE_MIN_1 - (r_w.w7.d0 + r_w.w7.d1 + r_w.w7.d2);
    assert [range_check_ptr + 54] = THREE_BASE_MIN_1 - (r_w.w8.d0 + r_w.w8.d1 + r_w.w8.d2);
    assert [range_check_ptr + 55] = THREE_BASE_MIN_1 - (r_w.w9.d0 + r_w.w9.d1 + r_w.w9.d2);
    assert [range_check_ptr + 56] = THREE_BASE_MIN_1 - (r_w.w10.d0 + r_w.w10.d1 + r_w.w10.d2);
    assert [range_check_ptr + 57] = THREE_BASE_MIN_1 - (r_w.w11.d0 + r_w.w11.d1 + r_w.w11.d2);

    tempvar range_check_ptr = range_check_ptr + 58;

    assert poseidon_ptr.input = PoseidonBuiltinState(
        s0=x.w1.d0 * x.w1.d1, s1=continuable_hash, s2=2
    );
    assert poseidon_ptr[1].input = PoseidonBuiltinState(
        s0=x.w1.d2 * x.w3.d0, s1=poseidon_ptr[0].output.s0, s2=2
    );
    assert poseidon_ptr[2].input = PoseidonBuiltinState(
        s0=x.w3.d1 * x.w3.d2, s1=poseidon_ptr[1].output.s0, s2=2
    );
    assert poseidon_ptr[3].input = PoseidonBuiltinState(
        s0=x.w7.d0 * x.w7.d1, s1=poseidon_ptr[2].output.s0, s2=2
    );
    assert poseidon_ptr[4].input = PoseidonBuiltinState(
        s0=x.w7.d2 * x.w9.d0, s1=poseidon_ptr[3].output.s0, s2=2
    );
    assert poseidon_ptr[5].input = PoseidonBuiltinState(
        s0=x.w9.d1 * x.w9.d2, s1=poseidon_ptr[4].output.s0, s2=2
    );
    assert poseidon_ptr[6].input = PoseidonBuiltinState(
        s0=y.w1.d0 * y.w1.d1, s1=poseidon_ptr[5].output.s0, s2=2
    );
    assert poseidon_ptr[7].input = PoseidonBuiltinState(
        s0=y.w1.d2 * y.w3.d0, s1=poseidon_ptr[6].output.s0, s2=2
    );
    assert poseidon_ptr[8].input = PoseidonBuiltinState(
        s0=y.w3.d1 * y.w3.d2, s1=poseidon_ptr[7].output.s0, s2=2
    );
    assert poseidon_ptr[9].input = PoseidonBuiltinState(
        s0=y.w7.d0 * y.w7.d1, s1=poseidon_ptr[8].output.s0, s2=2
    );
    assert poseidon_ptr[10].input = PoseidonBuiltinState(
        s0=y.w7.d2 * y.w9.d0, s1=poseidon_ptr[9].output.s0, s2=2
    );
    assert poseidon_ptr[11].input = PoseidonBuiltinState(
        s0=y.w9.d1 * y.w9.d2, s1=poseidon_ptr[10].output.s0, s2=2
    );
    assert poseidon_ptr[12].input = PoseidonBuiltinState(
        s0=q_w.w0.low, s1=poseidon_ptr[11].output.s0, s2=2
    );
    assert poseidon_ptr[13].input = PoseidonBuiltinState(
        s0=q_w.w0.high, s1=poseidon_ptr[12].output.s0, s2=2
    );
    assert poseidon_ptr[14].input = PoseidonBuiltinState(
        s0=q_w.w1.low, s1=poseidon_ptr[13].output.s0, s2=2
    );
    assert poseidon_ptr[15].input = PoseidonBuiltinState(
        s0=q_w.w1.high, s1=poseidon_ptr[14].output.s0, s2=2
    );
    assert poseidon_ptr[16].input = PoseidonBuiltinState(
        s0=q_w.w2.low, s1=poseidon_ptr[15].output.s0, s2=2
    );
    assert poseidon_ptr[17].input = PoseidonBuiltinState(
        s0=q_w.w2.high, s1=poseidon_ptr[16].output.s0, s2=2
    );
    assert poseidon_ptr[18].input = PoseidonBuiltinState(
        s0=q_w.w3.low, s1=poseidon_ptr[17].output.s0, s2=2
    );
    assert poseidon_ptr[19].input = PoseidonBuiltinState(
        s0=q_w.w3.high, s1=poseidon_ptr[18].output.s0, s2=2
    );
    assert poseidon_ptr[20].input = PoseidonBuiltinState(
        s0=q_w.w4.low, s1=poseidon_ptr[19].output.s0, s2=2
    );
    assert poseidon_ptr[21].input = PoseidonBuiltinState(
        s0=q_w.w4.high, s1=poseidon_ptr[20].output.s0, s2=2
    );
    assert poseidon_ptr[22].input = PoseidonBuiltinState(
        s0=q_w.w5.low, s1=poseidon_ptr[21].output.s0, s2=2
    );
    assert poseidon_ptr[23].input = PoseidonBuiltinState(
        s0=q_w.w5.high, s1=poseidon_ptr[22].output.s0, s2=2
    );
    assert poseidon_ptr[24].input = PoseidonBuiltinState(
        s0=q_w.w6.low, s1=poseidon_ptr[23].output.s0, s2=2
    );
    assert poseidon_ptr[25].input = PoseidonBuiltinState(
        s0=q_w.w6.high, s1=poseidon_ptr[24].output.s0, s2=2
    );
    assert poseidon_ptr[26].input = PoseidonBuiltinState(
        s0=r_w.w0.d0 * r_w.w0.d1, s1=poseidon_ptr[25].output.s0, s2=2
    );
    assert poseidon_ptr[27].input = PoseidonBuiltinState(
        s0=r_w.w0.d2 * r_w.w1.d0, s1=poseidon_ptr[26].output.s0, s2=2
    );
    assert poseidon_ptr[28].input = PoseidonBuiltinState(
        s0=r_w.w1.d1 * r_w.w1.d2, s1=poseidon_ptr[27].output.s0, s2=2
    );
    assert poseidon_ptr[29].input = PoseidonBuiltinState(
        s0=r_w.w2.d0 * r_w.w2.d1, s1=poseidon_ptr[28].output.s0, s2=2
    );
    assert poseidon_ptr[30].input = PoseidonBuiltinState(
        s0=r_w.w2.d2 * r_w.w3.d0, s1=poseidon_ptr[29].output.s0, s2=2
    );
    assert poseidon_ptr[31].input = PoseidonBuiltinState(
        s0=r_w.w3.d1 * r_w.w3.d2, s1=poseidon_ptr[30].output.s0, s2=2
    );
    assert poseidon_ptr[32].input = PoseidonBuiltinState(
        s0=r_w.w4.d0 * r_w.w4.d1, s1=poseidon_ptr[31].output.s0, s2=2
    );
    assert poseidon_ptr[33].input = PoseidonBuiltinState(
        s0=r_w.w4.d2 * r_w.w6.d0, s1=poseidon_ptr[32].output.s0, s2=2
    );
    assert poseidon_ptr[34].input = PoseidonBuiltinState(
        s0=r_w.w6.d1 * r_w.w6.d2, s1=poseidon_ptr[33].output.s0, s2=2
    );
    assert poseidon_ptr[35].input = PoseidonBuiltinState(
        s0=r_w.w7.d0 * r_w.w7.d1, s1=poseidon_ptr[34].output.s0, s2=2
    );
    assert poseidon_ptr[36].input = PoseidonBuiltinState(
        s0=r_w.w7.d2 * r_w.w8.d0, s1=poseidon_ptr[35].output.s0, s2=2
    );
    assert poseidon_ptr[37].input = PoseidonBuiltinState(
        s0=r_w.w8.d1 * r_w.w8.d2, s1=poseidon_ptr[36].output.s0, s2=2
    );
    assert poseidon_ptr[38].input = PoseidonBuiltinState(
        s0=r_w.w9.d0 * r_w.w9.d1, s1=poseidon_ptr[37].output.s0, s2=2
    );
    assert poseidon_ptr[39].input = PoseidonBuiltinState(
        s0=r_w.w9.d2 * r_w.w10.d0, s1=poseidon_ptr[38].output.s0, s2=2
    );
    assert poseidon_ptr[40].input = PoseidonBuiltinState(
        s0=r_w.w10.d1 * r_w.w10.d2, s1=poseidon_ptr[39].output.s0, s2=2
    );
    assert poseidon_ptr[41].input = PoseidonBuiltinState(
        s0=r_w.w11.d0 * r_w.w11.d1, s1=poseidon_ptr[40].output.s0, s2=2
    );
    assert poseidon_ptr[42].input = PoseidonBuiltinState(
        s0=r_w.w11.d2, s1=poseidon_ptr[41].output.s0, s2=2
    );

    tempvar x_of_z_w1 = UnreducedBigInt5(
        d0=x.w1.d0 * z_pow1_11.z_1.d0,
        d1=x.w1.d0 * z_pow1_11.z_1.d1 + x.w1.d1 * z_pow1_11.z_1.d0,
        d2=x.w1.d0 * z_pow1_11.z_1.d2 + x.w1.d1 * z_pow1_11.z_1.d1 + x.w1.d2 * z_pow1_11.z_1.d0,
        d3=x.w1.d1 * z_pow1_11.z_1.d2 + x.w1.d2 * z_pow1_11.z_1.d1,
        d4=x.w1.d2 * z_pow1_11.z_1.d2,
    );

    tempvar x_of_z_w3 = UnreducedBigInt5(
        d0=x.w3.d0 * z_pow1_11.z_3.d0,
        d1=x.w3.d0 * z_pow1_11.z_3.d1 + x.w3.d1 * z_pow1_11.z_3.d0,
        d2=x.w3.d0 * z_pow1_11.z_3.d2 + x.w3.d1 * z_pow1_11.z_3.d1 + x.w3.d2 * z_pow1_11.z_3.d0,
        d3=x.w3.d1 * z_pow1_11.z_3.d2 + x.w3.d2 * z_pow1_11.z_3.d1,
        d4=x.w3.d2 * z_pow1_11.z_3.d2,
    );
    tempvar x_of_z_w7 = UnreducedBigInt5(
        d0=x.w7.d0 * z_pow1_11.z_7.d0,
        d1=x.w7.d0 * z_pow1_11.z_7.d1 + x.w7.d1 * z_pow1_11.z_7.d0,
        d2=x.w7.d0 * z_pow1_11.z_7.d2 + x.w7.d1 * z_pow1_11.z_7.d1 + x.w7.d2 * z_pow1_11.z_7.d0,
        d3=x.w7.d1 * z_pow1_11.z_7.d2 + x.w7.d2 * z_pow1_11.z_7.d1,
        d4=x.w7.d2 * z_pow1_11.z_7.d2,
    );
    tempvar x_of_z_w9 = UnreducedBigInt5(
        d0=x.w9.d0 * z_pow1_11.z_9.d0,
        d1=x.w9.d0 * z_pow1_11.z_9.d1 + x.w9.d1 * z_pow1_11.z_9.d0,
        d2=x.w9.d0 * z_pow1_11.z_9.d2 + x.w9.d1 * z_pow1_11.z_9.d1 + x.w9.d2 * z_pow1_11.z_9.d0,
        d3=x.w9.d1 * z_pow1_11.z_9.d2 + x.w9.d2 * z_pow1_11.z_9.d1,
        d4=x.w9.d2 * z_pow1_11.z_9.d2,
    );
    let x_of_z = reduce_5_full(
        UnreducedBigInt5(
            d0=1 + x_of_z_w1.d0 + x_of_z_w3.d0 + x_of_z_w7.d0 + x_of_z_w9.d0,
            d1=x_of_z_w1.d1 + x_of_z_w3.d1 + x_of_z_w7.d1 + x_of_z_w9.d1,
            d2=x_of_z_w1.d2 + x_of_z_w3.d2 + x_of_z_w7.d2 + x_of_z_w9.d2,
            d3=x_of_z_w1.d3 + x_of_z_w3.d3 + x_of_z_w7.d3 + x_of_z_w9.d3,
            d4=x_of_z_w1.d4 + x_of_z_w3.d4 + x_of_z_w7.d4 + x_of_z_w9.d4,
        ),
    );

    tempvar y_of_z_w1 = UnreducedBigInt5(
        d0=y.w1.d0 * z_pow1_11.z_1.d0,
        d1=y.w1.d0 * z_pow1_11.z_1.d1 + y.w1.d1 * z_pow1_11.z_1.d0,
        d2=y.w1.d0 * z_pow1_11.z_1.d2 + y.w1.d1 * z_pow1_11.z_1.d1 + y.w1.d2 * z_pow1_11.z_1.d0,
        d3=y.w1.d1 * z_pow1_11.z_1.d2 + y.w1.d2 * z_pow1_11.z_1.d1,
        d4=y.w1.d2 * z_pow1_11.z_1.d2,
    );

    tempvar y_of_z_w3 = UnreducedBigInt5(
        d0=y.w3.d0 * z_pow1_11.z_3.d0,
        d1=y.w3.d0 * z_pow1_11.z_3.d1 + y.w3.d1 * z_pow1_11.z_3.d0,
        d2=y.w3.d0 * z_pow1_11.z_3.d2 + y.w3.d1 * z_pow1_11.z_3.d1 + y.w3.d2 * z_pow1_11.z_3.d0,
        d3=y.w3.d1 * z_pow1_11.z_3.d2 + y.w3.d2 * z_pow1_11.z_3.d1,
        d4=y.w3.d2 * z_pow1_11.z_3.d2,
    );

    tempvar y_of_z_w7 = UnreducedBigInt5(
        d0=y.w7.d0 * z_pow1_11.z_7.d0,
        d1=y.w7.d0 * z_pow1_11.z_7.d1 + y.w7.d1 * z_pow1_11.z_7.d0,
        d2=y.w7.d0 * z_pow1_11.z_7.d2 + y.w7.d1 * z_pow1_11.z_7.d1 + y.w7.d2 * z_pow1_11.z_7.d0,
        d3=y.w7.d1 * z_pow1_11.z_7.d2 + y.w7.d2 * z_pow1_11.z_7.d1,
        d4=y.w7.d2 * z_pow1_11.z_7.d2,
    );

    tempvar y_of_z_w9 = UnreducedBigInt5(
        d0=y.w9.d0 * z_pow1_11.z_9.d0,
        d1=y.w9.d0 * z_pow1_11.z_9.d1 + y.w9.d1 * z_pow1_11.z_9.d0,
        d2=y.w9.d0 * z_pow1_11.z_9.d2 + y.w9.d1 * z_pow1_11.z_9.d1 + y.w9.d2 * z_pow1_11.z_9.d0,
        d3=y.w9.d1 * z_pow1_11.z_9.d2 + y.w9.d2 * z_pow1_11.z_9.d1,
        d4=y.w9.d2 * z_pow1_11.z_9.d2,
    );

    let y_of_z = reduce_5_full(
        UnreducedBigInt5(
            d0=1 + y_of_z_w1.d0 + y_of_z_w3.d0 + y_of_z_w7.d0 + y_of_z_w9.d0,
            d1=y_of_z_w1.d1 + y_of_z_w3.d1 + y_of_z_w7.d1 + y_of_z_w9.d1,
            d2=y_of_z_w1.d2 + y_of_z_w3.d2 + y_of_z_w7.d2 + y_of_z_w9.d2,
            d3=y_of_z_w1.d3 + y_of_z_w3.d3 + y_of_z_w7.d3 + y_of_z_w9.d3,
            d4=y_of_z_w1.d4 + y_of_z_w3.d4 + y_of_z_w7.d4 + y_of_z_w9.d4,
        ),
    );

    let xy_acc = reduce_5_full(
        UnreducedBigInt5(
            d0=x_of_z.d0 * y_of_z.d0,
            d1=x_of_z.d0 * y_of_z.d1 + x_of_z.d1 * y_of_z.d0,
            d2=x_of_z.d0 * y_of_z.d2 + x_of_z.d1 * y_of_z.d1 + x_of_z.d2 * y_of_z.d0,
            d3=x_of_z.d1 * y_of_z.d2 + x_of_z.d2 * y_of_z.d1,
            d4=x_of_z.d2 * y_of_z.d2,
        ),
    );

    let poseidon_ptr = poseidon_ptr + 43 * PoseidonBuiltin.SIZE;
    let continuable_hash = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s0;
    let random_linear_combination_coeff = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s1;

    assert bitwise_ptr.x = random_linear_combination_coeff;
    assert bitwise_ptr.y = BASE_MIN_1;
    let c_i = bitwise_ptr.x_and_y;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;

    local poly_acc_034034_f: PolyAcc034034 = PolyAcc034034(
        xy=UnreducedBigInt3(
            d0=poly_acc_034034.xy.d0 + c_i * xy_acc.d0,
            d1=poly_acc_034034.xy.d1 + c_i * xy_acc.d1,
            d2=poly_acc_034034.xy.d2 + c_i * xy_acc.d2,
        ),
        q=E7full(
            Uint256(
                c_i * q_w.w0.low + poly_acc_034034.q.w0.low,
                c_i * q_w.w0.high + poly_acc_034034.q.w0.high,
            ),
            Uint256(
                c_i * q_w.w1.low + poly_acc_034034.q.w1.low,
                c_i * q_w.w1.high + poly_acc_034034.q.w1.high,
            ),
            Uint256(
                c_i * q_w.w2.low + poly_acc_034034.q.w2.low,
                c_i * q_w.w2.high + poly_acc_034034.q.w2.high,
            ),
            Uint256(
                c_i * q_w.w3.low + poly_acc_034034.q.w3.low,
                c_i * q_w.w3.high + poly_acc_034034.q.w3.high,
            ),
            Uint256(
                c_i * q_w.w4.low + poly_acc_034034.q.w4.low,
                c_i * q_w.w4.high + poly_acc_034034.q.w4.high,
            ),
            Uint256(
                c_i * q_w.w5.low + poly_acc_034034.q.w5.low,
                c_i * q_w.w5.high + poly_acc_034034.q.w5.high,
            ),
            Uint256(
                c_i * q_w.w6.low + poly_acc_034034.q.w6.low,
                c_i * q_w.w6.high + poly_acc_034034.q.w6.high,
            ),
        ),
        r=E12full01234(
            w0=BigInt3(
                d0=c_i * r_w.w0.d0 + poly_acc_034034.r.w0.d0,
                d1=c_i * r_w.w0.d1 + poly_acc_034034.r.w0.d1,
                d2=c_i * r_w.w0.d2 + poly_acc_034034.r.w0.d2,
            ),
            w1=BigInt3(
                d0=c_i * r_w.w1.d0 + poly_acc_034034.r.w1.d0,
                d1=c_i * r_w.w1.d1 + poly_acc_034034.r.w1.d1,
                d2=c_i * r_w.w1.d2 + poly_acc_034034.r.w1.d2,
            ),
            w2=BigInt3(
                d0=c_i * r_w.w2.d0 + poly_acc_034034.r.w2.d0,
                d1=c_i * r_w.w2.d1 + poly_acc_034034.r.w2.d1,
                d2=c_i * r_w.w2.d2 + poly_acc_034034.r.w2.d2,
            ),
            w3=BigInt3(
                d0=c_i * r_w.w3.d0 + poly_acc_034034.r.w3.d0,
                d1=c_i * r_w.w3.d1 + poly_acc_034034.r.w3.d1,
                d2=c_i * r_w.w3.d2 + poly_acc_034034.r.w3.d2,
            ),
            w4=BigInt3(
                d0=c_i * r_w.w4.d0 + poly_acc_034034.r.w4.d0,
                d1=c_i * r_w.w4.d1 + poly_acc_034034.r.w4.d1,
                d2=c_i * r_w.w4.d2 + poly_acc_034034.r.w4.d2,
            ),
            w6=BigInt3(
                d0=c_i * r_w.w6.d0 + poly_acc_034034.r.w6.d0,
                d1=c_i * r_w.w6.d1 + poly_acc_034034.r.w6.d1,
                d2=c_i * r_w.w6.d2 + poly_acc_034034.r.w6.d2,
            ),
            w7=BigInt3(
                d0=c_i * r_w.w7.d0 + poly_acc_034034.r.w7.d0,
                d1=c_i * r_w.w7.d1 + poly_acc_034034.r.w7.d1,
                d2=c_i * r_w.w7.d2 + poly_acc_034034.r.w7.d2,
            ),
            w8=BigInt3(
                d0=c_i * r_w.w8.d0 + poly_acc_034034.r.w8.d0,
                d1=c_i * r_w.w8.d1 + poly_acc_034034.r.w8.d1,
                d2=c_i * r_w.w8.d2 + poly_acc_034034.r.w8.d2,
            ),
            w9=BigInt3(
                d0=c_i * r_w.w9.d0 + poly_acc_034034.r.w9.d0,
                d1=c_i * r_w.w9.d1 + poly_acc_034034.r.w9.d1,
                d2=c_i * r_w.w9.d2 + poly_acc_034034.r.w9.d2,
            ),
            w10=BigInt3(
                d0=c_i * r_w.w10.d0 + poly_acc_034034.r.w10.d0,
                d1=c_i * r_w.w10.d1 + poly_acc_034034.r.w10.d1,
                d2=c_i * r_w.w10.d2 + poly_acc_034034.r.w10.d2,
            ),
            w11=BigInt3(
                d0=c_i * r_w.w11.d0 + poly_acc_034034.r.w11.d0,
                d1=c_i * r_w.w11.d1 + poly_acc_034034.r.w11.d1,
                d2=c_i * r_w.w11.d2 + poly_acc_034034.r.w11.d2,
            ),
        ),
    );

    let poly_acc_034034 = &poly_acc_034034_f;

    return &r_w;
}

func mul01234_trick{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    z_pow1_11_ptr: ZPowers11*,
    continuable_hash: felt,
    poly_acc_01234: PolyAcc12*,
}(x_ptr: E12full*, y_ptr: E12full01234*) -> E12full* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local x: E12full = [x_ptr];
    local y: E12full01234 = [y_ptr];
    local z_pow1_11: ZPowers11 = [z_pow1_11_ptr];
    local r_w: E12full;
    local q_w: E11full;

    %{
        from tools.py.polynomial import Polynomial
        from tools.py.field import BaseFieldElement, BaseField
        #from tools.py.extension_trick import w_to_gnark, gnark_to_w, flatten, pack_e12, mul_e12_gnark
        from starkware.cairo.common.cairo_secp.secp_utils import split
        from tools.make.utils import split_128

        p=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
        field = BaseField(p)
        x=12*[0]
        y=12*[0]
        x_refs = [ids.x.w0, ids.x.w1, ids.x.w2, ids.x.w3, ids.x.w4, ids.x.w5, ids.x.w6, ids.x.w7, ids.x.w8, ids.x.w9, ids.x.w10, ids.x.w11]
        y_refs = [ids.y.w0, ids.y.w1, ids.y.w2, ids.y.w3, ids.y.w4, None, ids.y.w6, ids.y.w7, ids.y.w8, ids.y.w9, ids.y.w10, ids.y.w11]
        for i in range(ids.N_LIMBS):
            for k in range(12):
                x[k]+=as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
            for k in range(12):
                if k==5:
                    continue
                y[k]+=as_int(getattr(y_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
        #x_gnark=w_to_gnark(x)
        #y_gnark=w_to_gnark(y)
        #print(f"Y_Gnark: {y_gnark}")
        #print(f"Y_01234: {y}")
        x_poly=Polynomial([BaseFieldElement(x[i], field) for i in range(12)])
        y_poly=Polynomial([BaseFieldElement(y[i], field) for i in range(12)])
        z_poly=x_poly*y_poly
        #print(f"mul01234 res degree : {z_poly.degree()}")
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
        assert len(z_polyq_coeffs)<=11, f"len z_polyq_coeffs: {len(z_polyq_coeffs)}, degree: {z_polyq.degree()}"
        assert len(z_polyr_coeffs)<=12, f"len z_polyr_coeffs: {z_polyr_coeffs}, degree: {z_polyr.degree()}"
        #print(f"Z_PolyR034034: {z_polyr_coeffs}")
        # extend z_polyq with 0 to make it len 9:
        z_polyq_coeffs = z_polyq_coeffs + (11-len(z_polyq_coeffs))*[0]
        # extend z_polyr with 0 to make it len 12:
        z_polyr_coeffs = z_polyr_coeffs + (12-len(z_polyr_coeffs))*[0]
        #expected = flatten(mul_e12_gnark(pack_e12(x_gnark), pack_e12(y_gnark)))
        #assert expected==w_to_gnark(z_polyr_coeffs)
        #print(f"Z_PolyR: {z_polyr_coeffs}")
        #print(f"Z_PolyR_to_gnark: {w_to_gnark(z_polyr_coeffs)}")
        for i in range(12):
            val = split(z_polyr_coeffs[i]%p)
            for k in range(3):
                rsetattr(ids.r_w, f'w{i}.d{k}', val[k])
        for i in range(11):
            val = split_128(z_polyq_coeffs[i]%p)
            rsetattr(ids.q_w, f'w{i}.low', val[0])
            rsetattr(ids.q_w, f'w{i}.high', val[1])
    %}
    assert [range_check_ptr + 0] = r_w.w0.d0;
    assert [range_check_ptr + 1] = r_w.w0.d1;
    assert [range_check_ptr + 2] = r_w.w0.d2;
    assert [range_check_ptr + 3] = r_w.w1.d0;
    assert [range_check_ptr + 4] = r_w.w1.d1;
    assert [range_check_ptr + 5] = r_w.w1.d2;
    assert [range_check_ptr + 6] = r_w.w2.d0;
    assert [range_check_ptr + 7] = r_w.w2.d1;
    assert [range_check_ptr + 8] = r_w.w2.d2;
    assert [range_check_ptr + 9] = r_w.w3.d0;
    assert [range_check_ptr + 10] = r_w.w3.d1;
    assert [range_check_ptr + 11] = r_w.w3.d2;
    assert [range_check_ptr + 12] = r_w.w4.d0;
    assert [range_check_ptr + 13] = r_w.w4.d1;
    assert [range_check_ptr + 14] = r_w.w4.d2;
    assert [range_check_ptr + 15] = r_w.w5.d0;
    assert [range_check_ptr + 16] = r_w.w5.d1;
    assert [range_check_ptr + 17] = r_w.w5.d2;
    assert [range_check_ptr + 18] = r_w.w6.d0;
    assert [range_check_ptr + 19] = r_w.w6.d1;
    assert [range_check_ptr + 20] = r_w.w6.d2;
    assert [range_check_ptr + 21] = r_w.w7.d0;
    assert [range_check_ptr + 22] = r_w.w7.d1;
    assert [range_check_ptr + 23] = r_w.w7.d2;
    assert [range_check_ptr + 24] = r_w.w8.d0;
    assert [range_check_ptr + 25] = r_w.w8.d1;
    assert [range_check_ptr + 26] = r_w.w8.d2;
    assert [range_check_ptr + 27] = r_w.w9.d0;
    assert [range_check_ptr + 28] = r_w.w9.d1;
    assert [range_check_ptr + 29] = r_w.w9.d2;
    assert [range_check_ptr + 30] = r_w.w10.d0;
    assert [range_check_ptr + 31] = r_w.w10.d1;
    assert [range_check_ptr + 32] = r_w.w10.d2;
    assert [range_check_ptr + 33] = r_w.w11.d0;
    assert [range_check_ptr + 34] = r_w.w11.d1;
    assert [range_check_ptr + 35] = r_w.w11.d2;
    assert [range_check_ptr + 36] = q_w.w0.low;
    assert [range_check_ptr + 37] = q_w.w0.high;
    assert [range_check_ptr + 38] = q_w.w1.low;
    assert [range_check_ptr + 39] = q_w.w1.high;
    assert [range_check_ptr + 40] = q_w.w2.low;
    assert [range_check_ptr + 41] = q_w.w2.high;
    assert [range_check_ptr + 42] = q_w.w3.low;
    assert [range_check_ptr + 43] = q_w.w3.high;
    assert [range_check_ptr + 44] = q_w.w4.low;
    assert [range_check_ptr + 45] = q_w.w4.high;
    assert [range_check_ptr + 46] = q_w.w5.low;
    assert [range_check_ptr + 47] = q_w.w5.high;
    assert [range_check_ptr + 48] = q_w.w6.low;
    assert [range_check_ptr + 49] = q_w.w6.high;
    assert [range_check_ptr + 50] = q_w.w7.low;
    assert [range_check_ptr + 51] = q_w.w7.high;
    assert [range_check_ptr + 52] = q_w.w8.low;
    assert [range_check_ptr + 53] = q_w.w8.high;
    assert [range_check_ptr + 54] = q_w.w9.low;
    assert [range_check_ptr + 55] = q_w.w9.high;
    assert [range_check_ptr + 56] = q_w.w10.low;
    assert [range_check_ptr + 57] = q_w.w10.high;
    assert [range_check_ptr + 58] = THREE_BASE_MIN_1 - (r_w.w0.d0 + r_w.w0.d1 + r_w.w0.d2);
    assert [range_check_ptr + 59] = THREE_BASE_MIN_1 - (r_w.w1.d0 + r_w.w1.d1 + r_w.w1.d2);
    assert [range_check_ptr + 60] = THREE_BASE_MIN_1 - (r_w.w2.d0 + r_w.w2.d1 + r_w.w2.d2);
    assert [range_check_ptr + 61] = THREE_BASE_MIN_1 - (r_w.w3.d0 + r_w.w3.d1 + r_w.w3.d2);
    assert [range_check_ptr + 62] = THREE_BASE_MIN_1 - (r_w.w4.d0 + r_w.w4.d1 + r_w.w4.d2);
    assert [range_check_ptr + 63] = THREE_BASE_MIN_1 - (r_w.w5.d0 + r_w.w5.d1 + r_w.w5.d2);
    assert [range_check_ptr + 64] = THREE_BASE_MIN_1 - (r_w.w6.d0 + r_w.w6.d1 + r_w.w6.d2);
    assert [range_check_ptr + 65] = THREE_BASE_MIN_1 - (r_w.w7.d0 + r_w.w7.d1 + r_w.w7.d2);
    assert [range_check_ptr + 66] = THREE_BASE_MIN_1 - (r_w.w8.d0 + r_w.w8.d1 + r_w.w8.d2);
    assert [range_check_ptr + 67] = THREE_BASE_MIN_1 - (r_w.w9.d0 + r_w.w9.d1 + r_w.w9.d2);
    assert [range_check_ptr + 68] = THREE_BASE_MIN_1 - (r_w.w10.d0 + r_w.w10.d1 + r_w.w10.d2);
    assert [range_check_ptr + 69] = THREE_BASE_MIN_1 - (r_w.w11.d0 + r_w.w11.d1 + r_w.w11.d2);

    tempvar range_check_ptr = range_check_ptr + 70;

    assert poseidon_ptr.input = PoseidonBuiltinState(
        s0=x.w0.d0 * x.w0.d1, s1=continuable_hash, s2=2
    );
    assert poseidon_ptr[1].input = PoseidonBuiltinState(
        s0=x.w0.d2 * x.w1.d0, s1=poseidon_ptr[0].output.s0, s2=2
    );
    assert poseidon_ptr[2].input = PoseidonBuiltinState(
        s0=x.w1.d1 * x.w1.d2, s1=poseidon_ptr[1].output.s0, s2=2
    );
    assert poseidon_ptr[3].input = PoseidonBuiltinState(
        s0=x.w2.d0 * x.w2.d1, s1=poseidon_ptr[2].output.s0, s2=2
    );
    assert poseidon_ptr[4].input = PoseidonBuiltinState(
        s0=x.w2.d2 * x.w3.d0, s1=poseidon_ptr[3].output.s0, s2=2
    );
    assert poseidon_ptr[5].input = PoseidonBuiltinState(
        s0=x.w3.d1 * x.w3.d2, s1=poseidon_ptr[4].output.s0, s2=2
    );
    assert poseidon_ptr[6].input = PoseidonBuiltinState(
        s0=x.w4.d0 * x.w4.d1, s1=poseidon_ptr[5].output.s0, s2=2
    );
    assert poseidon_ptr[7].input = PoseidonBuiltinState(
        s0=x.w4.d2 * x.w5.d0, s1=poseidon_ptr[6].output.s0, s2=2
    );
    assert poseidon_ptr[8].input = PoseidonBuiltinState(
        s0=x.w5.d1 * x.w5.d2, s1=poseidon_ptr[7].output.s0, s2=2
    );
    assert poseidon_ptr[9].input = PoseidonBuiltinState(
        s0=x.w6.d0 * x.w6.d1, s1=poseidon_ptr[8].output.s0, s2=2
    );
    assert poseidon_ptr[10].input = PoseidonBuiltinState(
        s0=x.w6.d2 * x.w7.d0, s1=poseidon_ptr[9].output.s0, s2=2
    );
    assert poseidon_ptr[11].input = PoseidonBuiltinState(
        s0=x.w7.d1 * x.w7.d2, s1=poseidon_ptr[10].output.s0, s2=2
    );
    assert poseidon_ptr[12].input = PoseidonBuiltinState(
        s0=x.w8.d0 * x.w8.d1, s1=poseidon_ptr[11].output.s0, s2=2
    );
    assert poseidon_ptr[13].input = PoseidonBuiltinState(
        s0=x.w8.d2 * x.w9.d0, s1=poseidon_ptr[12].output.s0, s2=2
    );
    assert poseidon_ptr[14].input = PoseidonBuiltinState(
        s0=x.w9.d1 * x.w9.d2, s1=poseidon_ptr[13].output.s0, s2=2
    );
    assert poseidon_ptr[15].input = PoseidonBuiltinState(
        s0=x.w10.d0 * x.w10.d1, s1=poseidon_ptr[14].output.s0, s2=2
    );
    assert poseidon_ptr[16].input = PoseidonBuiltinState(
        s0=x.w10.d2 * x.w11.d0, s1=poseidon_ptr[15].output.s0, s2=2
    );
    assert poseidon_ptr[17].input = PoseidonBuiltinState(
        s0=x.w11.d1 * x.w11.d2, s1=poseidon_ptr[16].output.s0, s2=2
    );
    assert poseidon_ptr[18].input = PoseidonBuiltinState(
        s0=y.w0.d0 * y.w0.d1, s1=poseidon_ptr[17].output.s0, s2=2
    );
    assert poseidon_ptr[19].input = PoseidonBuiltinState(
        s0=y.w0.d2 * y.w1.d0, s1=poseidon_ptr[18].output.s0, s2=2
    );
    assert poseidon_ptr[20].input = PoseidonBuiltinState(
        s0=y.w1.d1 * y.w1.d2, s1=poseidon_ptr[19].output.s0, s2=2
    );
    assert poseidon_ptr[21].input = PoseidonBuiltinState(
        s0=y.w2.d0 * y.w2.d1, s1=poseidon_ptr[20].output.s0, s2=2
    );
    assert poseidon_ptr[22].input = PoseidonBuiltinState(
        s0=y.w2.d2 * y.w3.d0, s1=poseidon_ptr[21].output.s0, s2=2
    );
    assert poseidon_ptr[23].input = PoseidonBuiltinState(
        s0=y.w3.d1 * y.w3.d2, s1=poseidon_ptr[22].output.s0, s2=2
    );
    assert poseidon_ptr[24].input = PoseidonBuiltinState(
        s0=y.w4.d0 * y.w4.d1, s1=poseidon_ptr[23].output.s0, s2=2
    );
    assert poseidon_ptr[25].input = PoseidonBuiltinState(
        s0=y.w4.d2 * y.w6.d0, s1=poseidon_ptr[24].output.s0, s2=2
    );
    assert poseidon_ptr[26].input = PoseidonBuiltinState(
        s0=y.w6.d1 * y.w6.d2, s1=poseidon_ptr[25].output.s0, s2=2
    );
    assert poseidon_ptr[27].input = PoseidonBuiltinState(
        s0=y.w7.d0 * y.w7.d1, s1=poseidon_ptr[26].output.s0, s2=2
    );
    assert poseidon_ptr[28].input = PoseidonBuiltinState(
        s0=y.w7.d2 * y.w8.d0, s1=poseidon_ptr[27].output.s0, s2=2
    );
    assert poseidon_ptr[29].input = PoseidonBuiltinState(
        s0=y.w8.d1 * y.w8.d2, s1=poseidon_ptr[28].output.s0, s2=2
    );
    assert poseidon_ptr[30].input = PoseidonBuiltinState(
        s0=y.w9.d0 * y.w9.d1, s1=poseidon_ptr[29].output.s0, s2=2
    );
    assert poseidon_ptr[31].input = PoseidonBuiltinState(
        s0=y.w9.d2 * y.w10.d0, s1=poseidon_ptr[30].output.s0, s2=2
    );
    assert poseidon_ptr[32].input = PoseidonBuiltinState(
        s0=y.w10.d1 * y.w10.d2, s1=poseidon_ptr[31].output.s0, s2=2
    );
    assert poseidon_ptr[33].input = PoseidonBuiltinState(
        s0=y.w11.d0 * y.w11.d1, s1=poseidon_ptr[32].output.s0, s2=2
    );
    assert poseidon_ptr[34].input = PoseidonBuiltinState(
        s0=y.w11.d2 * q_w.w0.low, s1=poseidon_ptr[33].output.s0, s2=2
    );
    assert poseidon_ptr[35].input = PoseidonBuiltinState(
        s0=q_w.w0.high, s1=poseidon_ptr[34].output.s0, s2=2
    );
    assert poseidon_ptr[36].input = PoseidonBuiltinState(
        s0=q_w.w1.low, s1=poseidon_ptr[35].output.s0, s2=2
    );
    assert poseidon_ptr[37].input = PoseidonBuiltinState(
        s0=q_w.w1.high, s1=poseidon_ptr[36].output.s0, s2=2
    );
    assert poseidon_ptr[38].input = PoseidonBuiltinState(
        s0=q_w.w2.low, s1=poseidon_ptr[37].output.s0, s2=2
    );
    assert poseidon_ptr[39].input = PoseidonBuiltinState(
        s0=q_w.w2.high, s1=poseidon_ptr[38].output.s0, s2=2
    );
    assert poseidon_ptr[40].input = PoseidonBuiltinState(
        s0=q_w.w3.low, s1=poseidon_ptr[39].output.s0, s2=2
    );
    assert poseidon_ptr[41].input = PoseidonBuiltinState(
        s0=q_w.w3.high, s1=poseidon_ptr[40].output.s0, s2=2
    );
    assert poseidon_ptr[42].input = PoseidonBuiltinState(
        s0=q_w.w4.low, s1=poseidon_ptr[41].output.s0, s2=2
    );
    assert poseidon_ptr[43].input = PoseidonBuiltinState(
        s0=q_w.w4.high, s1=poseidon_ptr[42].output.s0, s2=2
    );
    assert poseidon_ptr[44].input = PoseidonBuiltinState(
        s0=q_w.w5.low, s1=poseidon_ptr[43].output.s0, s2=2
    );
    assert poseidon_ptr[45].input = PoseidonBuiltinState(
        s0=q_w.w5.high, s1=poseidon_ptr[44].output.s0, s2=2
    );
    assert poseidon_ptr[46].input = PoseidonBuiltinState(
        s0=q_w.w6.low, s1=poseidon_ptr[45].output.s0, s2=2
    );
    assert poseidon_ptr[47].input = PoseidonBuiltinState(
        s0=q_w.w6.high, s1=poseidon_ptr[46].output.s0, s2=2
    );
    assert poseidon_ptr[48].input = PoseidonBuiltinState(
        s0=q_w.w7.low, s1=poseidon_ptr[47].output.s0, s2=2
    );
    assert poseidon_ptr[49].input = PoseidonBuiltinState(
        s0=q_w.w7.high, s1=poseidon_ptr[48].output.s0, s2=2
    );
    assert poseidon_ptr[50].input = PoseidonBuiltinState(
        s0=q_w.w8.low, s1=poseidon_ptr[49].output.s0, s2=2
    );
    assert poseidon_ptr[51].input = PoseidonBuiltinState(
        s0=q_w.w8.high, s1=poseidon_ptr[50].output.s0, s2=2
    );
    assert poseidon_ptr[52].input = PoseidonBuiltinState(
        s0=q_w.w9.low, s1=poseidon_ptr[51].output.s0, s2=2
    );
    assert poseidon_ptr[53].input = PoseidonBuiltinState(
        s0=q_w.w9.high, s1=poseidon_ptr[52].output.s0, s2=2
    );
    assert poseidon_ptr[54].input = PoseidonBuiltinState(
        s0=q_w.w10.low, s1=poseidon_ptr[53].output.s0, s2=2
    );
    assert poseidon_ptr[55].input = PoseidonBuiltinState(
        s0=q_w.w10.high, s1=poseidon_ptr[54].output.s0, s2=2
    );

    tempvar x_of_z_w1 = UnreducedBigInt5(
        d0=x.w1.d0 * z_pow1_11.z_1.d0,
        d1=x.w1.d0 * z_pow1_11.z_1.d1 + x.w1.d1 * z_pow1_11.z_1.d0,
        d2=x.w1.d0 * z_pow1_11.z_1.d2 + x.w1.d1 * z_pow1_11.z_1.d1 + x.w1.d2 * z_pow1_11.z_1.d0,
        d3=x.w1.d1 * z_pow1_11.z_1.d2 + x.w1.d2 * z_pow1_11.z_1.d1,
        d4=x.w1.d2 * z_pow1_11.z_1.d2,
    );
    tempvar x_of_z_w2 = UnreducedBigInt5(
        d0=x.w2.d0 * z_pow1_11.z_2.d0,
        d1=x.w2.d0 * z_pow1_11.z_2.d1 + x.w2.d1 * z_pow1_11.z_2.d0,
        d2=x.w2.d0 * z_pow1_11.z_2.d2 + x.w2.d1 * z_pow1_11.z_2.d1 + x.w2.d2 * z_pow1_11.z_2.d0,
        d3=x.w2.d1 * z_pow1_11.z_2.d2 + x.w2.d2 * z_pow1_11.z_2.d1,
        d4=x.w2.d2 * z_pow1_11.z_2.d2,
    );

    tempvar x_of_z_w3 = UnreducedBigInt5(
        d0=x.w3.d0 * z_pow1_11.z_3.d0,
        d1=x.w3.d0 * z_pow1_11.z_3.d1 + x.w3.d1 * z_pow1_11.z_3.d0,
        d2=x.w3.d0 * z_pow1_11.z_3.d2 + x.w3.d1 * z_pow1_11.z_3.d1 + x.w3.d2 * z_pow1_11.z_3.d0,
        d3=x.w3.d1 * z_pow1_11.z_3.d2 + x.w3.d2 * z_pow1_11.z_3.d1,
        d4=x.w3.d2 * z_pow1_11.z_3.d2,
    );

    tempvar x_of_z_w4 = UnreducedBigInt5(
        d0=x.w4.d0 * z_pow1_11.z_4.d0,
        d1=x.w4.d0 * z_pow1_11.z_4.d1 + x.w4.d1 * z_pow1_11.z_4.d0,
        d2=x.w4.d0 * z_pow1_11.z_4.d2 + x.w4.d1 * z_pow1_11.z_4.d1 + x.w4.d2 * z_pow1_11.z_4.d0,
        d3=x.w4.d1 * z_pow1_11.z_4.d2 + x.w4.d2 * z_pow1_11.z_4.d1,
        d4=x.w4.d2 * z_pow1_11.z_4.d2,
    );

    tempvar x_of_z_w5 = UnreducedBigInt5(
        d0=x.w5.d0 * z_pow1_11.z_5.d0,
        d1=x.w5.d0 * z_pow1_11.z_5.d1 + x.w5.d1 * z_pow1_11.z_5.d0,
        d2=x.w5.d0 * z_pow1_11.z_5.d2 + x.w5.d1 * z_pow1_11.z_5.d1 + x.w5.d2 * z_pow1_11.z_5.d0,
        d3=x.w5.d1 * z_pow1_11.z_5.d2 + x.w5.d2 * z_pow1_11.z_5.d1,
        d4=x.w5.d2 * z_pow1_11.z_5.d2,
    );

    tempvar x_of_z_w6 = UnreducedBigInt5(
        d0=x.w6.d0 * z_pow1_11.z_6.d0,
        d1=x.w6.d0 * z_pow1_11.z_6.d1 + x.w6.d1 * z_pow1_11.z_6.d0,
        d2=x.w6.d0 * z_pow1_11.z_6.d2 + x.w6.d1 * z_pow1_11.z_6.d1 + x.w6.d2 * z_pow1_11.z_6.d0,
        d3=x.w6.d1 * z_pow1_11.z_6.d2 + x.w6.d2 * z_pow1_11.z_6.d1,
        d4=x.w6.d2 * z_pow1_11.z_6.d2,
    );

    tempvar x_of_z_w7 = UnreducedBigInt5(
        d0=x.w7.d0 * z_pow1_11.z_7.d0,
        d1=x.w7.d0 * z_pow1_11.z_7.d1 + x.w7.d1 * z_pow1_11.z_7.d0,
        d2=x.w7.d0 * z_pow1_11.z_7.d2 + x.w7.d1 * z_pow1_11.z_7.d1 + x.w7.d2 * z_pow1_11.z_7.d0,
        d3=x.w7.d1 * z_pow1_11.z_7.d2 + x.w7.d2 * z_pow1_11.z_7.d1,
        d4=x.w7.d2 * z_pow1_11.z_7.d2,
    );

    tempvar x_of_z_w8 = UnreducedBigInt5(
        d0=x.w8.d0 * z_pow1_11.z_8.d0,
        d1=x.w8.d0 * z_pow1_11.z_8.d1 + x.w8.d1 * z_pow1_11.z_8.d0,
        d2=x.w8.d0 * z_pow1_11.z_8.d2 + x.w8.d1 * z_pow1_11.z_8.d1 + x.w8.d2 * z_pow1_11.z_8.d0,
        d3=x.w8.d1 * z_pow1_11.z_8.d2 + x.w8.d2 * z_pow1_11.z_8.d1,
        d4=x.w8.d2 * z_pow1_11.z_8.d2,
    );

    tempvar x_of_z_w9 = UnreducedBigInt5(
        d0=x.w9.d0 * z_pow1_11.z_9.d0,
        d1=x.w9.d0 * z_pow1_11.z_9.d1 + x.w9.d1 * z_pow1_11.z_9.d0,
        d2=x.w9.d0 * z_pow1_11.z_9.d2 + x.w9.d1 * z_pow1_11.z_9.d1 + x.w9.d2 * z_pow1_11.z_9.d0,
        d3=x.w9.d1 * z_pow1_11.z_9.d2 + x.w9.d2 * z_pow1_11.z_9.d1,
        d4=x.w9.d2 * z_pow1_11.z_9.d2,
    );

    tempvar x_of_z_w10 = UnreducedBigInt5(
        d0=x.w10.d0 * z_pow1_11.z_10.d0,
        d1=x.w10.d0 * z_pow1_11.z_10.d1 + x.w10.d1 * z_pow1_11.z_10.d0,
        d2=x.w10.d0 * z_pow1_11.z_10.d2 + x.w10.d1 * z_pow1_11.z_10.d1 + x.w10.d2 *
        z_pow1_11.z_10.d0,
        d3=x.w10.d1 * z_pow1_11.z_10.d2 + x.w10.d2 * z_pow1_11.z_10.d1,
        d4=x.w10.d2 * z_pow1_11.z_10.d2,
    );

    tempvar x_of_z_w11 = UnreducedBigInt5(
        d0=x.w11.d0 * z_pow1_11.z_11.d0,
        d1=x.w11.d0 * z_pow1_11.z_11.d1 + x.w11.d1 * z_pow1_11.z_11.d0,
        d2=x.w11.d0 * z_pow1_11.z_11.d2 + x.w11.d1 * z_pow1_11.z_11.d1 + x.w11.d2 *
        z_pow1_11.z_11.d0,
        d3=x.w11.d1 * z_pow1_11.z_11.d2 + x.w11.d2 * z_pow1_11.z_11.d1,
        d4=x.w11.d2 * z_pow1_11.z_11.d2,
    );

    let x_of_z = reduce_5_full(
        UnreducedBigInt5(
            d0=x.w0.d0 + x_of_z_w1.d0 + x_of_z_w2.d0 + x_of_z_w3.d0 + x_of_z_w4.d0 + x_of_z_w5.d0 +
            x_of_z_w6.d0 + x_of_z_w7.d0 + x_of_z_w8.d0 + x_of_z_w9.d0 + x_of_z_w10.d0 +
            x_of_z_w11.d0,
            d1=x.w0.d1 + x_of_z_w1.d1 + x_of_z_w2.d1 + x_of_z_w3.d1 + x_of_z_w4.d1 + x_of_z_w5.d1 +
            x_of_z_w6.d1 + x_of_z_w7.d1 + x_of_z_w8.d1 + x_of_z_w9.d1 + x_of_z_w10.d1 +
            x_of_z_w11.d1,
            d2=x.w0.d2 + x_of_z_w1.d2 + x_of_z_w2.d2 + x_of_z_w3.d2 + x_of_z_w4.d2 + x_of_z_w5.d2 +
            x_of_z_w6.d2 + x_of_z_w7.d2 + x_of_z_w8.d2 + x_of_z_w9.d2 + x_of_z_w10.d2 +
            x_of_z_w11.d2,
            d3=x_of_z_w1.d3 + x_of_z_w2.d3 + x_of_z_w3.d3 + x_of_z_w4.d3 + x_of_z_w5.d3 +
            x_of_z_w6.d3 + x_of_z_w7.d3 + x_of_z_w8.d3 + x_of_z_w9.d3 + x_of_z_w10.d3 +
            x_of_z_w11.d3,
            d4=x_of_z_w1.d4 + x_of_z_w2.d4 + x_of_z_w3.d4 + x_of_z_w4.d4 + x_of_z_w5.d4 +
            x_of_z_w6.d4 + x_of_z_w7.d4 + x_of_z_w8.d4 + x_of_z_w9.d4 + x_of_z_w10.d4 +
            x_of_z_w11.d4,
        ),
    );

    tempvar y_of_z_w1 = UnreducedBigInt5(
        d0=y.w1.d0 * z_pow1_11.z_1.d0,
        d1=y.w1.d0 * z_pow1_11.z_1.d1 + y.w1.d1 * z_pow1_11.z_1.d0,
        d2=y.w1.d0 * z_pow1_11.z_1.d2 + y.w1.d1 * z_pow1_11.z_1.d1 + y.w1.d2 * z_pow1_11.z_1.d0,
        d3=y.w1.d1 * z_pow1_11.z_1.d2 + y.w1.d2 * z_pow1_11.z_1.d1,
        d4=y.w1.d2 * z_pow1_11.z_1.d2,
    );
    tempvar y_of_z_w2 = UnreducedBigInt5(
        d0=y.w2.d0 * z_pow1_11.z_2.d0,
        d1=y.w2.d0 * z_pow1_11.z_2.d1 + y.w2.d1 * z_pow1_11.z_2.d0,
        d2=y.w2.d0 * z_pow1_11.z_2.d2 + y.w2.d1 * z_pow1_11.z_2.d1 + y.w2.d2 * z_pow1_11.z_2.d0,
        d3=y.w2.d1 * z_pow1_11.z_2.d2 + y.w2.d2 * z_pow1_11.z_2.d1,
        d4=y.w2.d2 * z_pow1_11.z_2.d2,
    );
    tempvar y_of_z_w3 = UnreducedBigInt5(
        d0=y.w3.d0 * z_pow1_11.z_3.d0,
        d1=y.w3.d0 * z_pow1_11.z_3.d1 + y.w3.d1 * z_pow1_11.z_3.d0,
        d2=y.w3.d0 * z_pow1_11.z_3.d2 + y.w3.d1 * z_pow1_11.z_3.d1 + y.w3.d2 * z_pow1_11.z_3.d0,
        d3=y.w3.d1 * z_pow1_11.z_3.d2 + y.w3.d2 * z_pow1_11.z_3.d1,
        d4=y.w3.d2 * z_pow1_11.z_3.d2,
    );
    tempvar y_of_z_w4 = UnreducedBigInt5(
        d0=y.w4.d0 * z_pow1_11.z_4.d0,
        d1=y.w4.d0 * z_pow1_11.z_4.d1 + y.w4.d1 * z_pow1_11.z_4.d0,
        d2=y.w4.d0 * z_pow1_11.z_4.d2 + y.w4.d1 * z_pow1_11.z_4.d1 + y.w4.d2 * z_pow1_11.z_4.d0,
        d3=y.w4.d1 * z_pow1_11.z_4.d2 + y.w4.d2 * z_pow1_11.z_4.d1,
        d4=y.w4.d2 * z_pow1_11.z_4.d2,
    );

    tempvar y_of_z_w6 = UnreducedBigInt5(
        d0=y.w6.d0 * z_pow1_11.z_6.d0,
        d1=y.w6.d0 * z_pow1_11.z_6.d1 + y.w6.d1 * z_pow1_11.z_6.d0,
        d2=y.w6.d0 * z_pow1_11.z_6.d2 + y.w6.d1 * z_pow1_11.z_6.d1 + y.w6.d2 * z_pow1_11.z_6.d0,
        d3=y.w6.d1 * z_pow1_11.z_6.d2 + y.w6.d2 * z_pow1_11.z_6.d1,
        d4=y.w6.d2 * z_pow1_11.z_6.d2,
    );

    tempvar y_of_z_w7 = UnreducedBigInt5(
        d0=y.w7.d0 * z_pow1_11.z_7.d0,
        d1=y.w7.d0 * z_pow1_11.z_7.d1 + y.w7.d1 * z_pow1_11.z_7.d0,
        d2=y.w7.d0 * z_pow1_11.z_7.d2 + y.w7.d1 * z_pow1_11.z_7.d1 + y.w7.d2 * z_pow1_11.z_7.d0,
        d3=y.w7.d1 * z_pow1_11.z_7.d2 + y.w7.d2 * z_pow1_11.z_7.d1,
        d4=y.w7.d2 * z_pow1_11.z_7.d2,
    );
    tempvar y_of_z_w8 = UnreducedBigInt5(
        d0=y.w8.d0 * z_pow1_11.z_8.d0,
        d1=y.w8.d0 * z_pow1_11.z_8.d1 + y.w8.d1 * z_pow1_11.z_8.d0,
        d2=y.w8.d0 * z_pow1_11.z_8.d2 + y.w8.d1 * z_pow1_11.z_8.d1 + y.w8.d2 * z_pow1_11.z_8.d0,
        d3=y.w8.d1 * z_pow1_11.z_8.d2 + y.w8.d2 * z_pow1_11.z_8.d1,
        d4=y.w8.d2 * z_pow1_11.z_8.d2,
    );
    tempvar y_of_z_w9 = UnreducedBigInt5(
        d0=y.w9.d0 * z_pow1_11.z_9.d0,
        d1=y.w9.d0 * z_pow1_11.z_9.d1 + y.w9.d1 * z_pow1_11.z_9.d0,
        d2=y.w9.d0 * z_pow1_11.z_9.d2 + y.w9.d1 * z_pow1_11.z_9.d1 + y.w9.d2 * z_pow1_11.z_9.d0,
        d3=y.w9.d1 * z_pow1_11.z_9.d2 + y.w9.d2 * z_pow1_11.z_9.d1,
        d4=y.w9.d2 * z_pow1_11.z_9.d2,
    );
    tempvar y_of_z_w10 = UnreducedBigInt5(
        d0=y.w10.d0 * z_pow1_11.z_10.d0,
        d1=y.w10.d0 * z_pow1_11.z_10.d1 + y.w10.d1 * z_pow1_11.z_10.d0,
        d2=y.w10.d0 * z_pow1_11.z_10.d2 + y.w10.d1 * z_pow1_11.z_10.d1 + y.w10.d2 *
        z_pow1_11.z_10.d0,
        d3=y.w10.d1 * z_pow1_11.z_10.d2 + y.w10.d2 * z_pow1_11.z_10.d1,
        d4=y.w10.d2 * z_pow1_11.z_10.d2,
    );
    tempvar y_of_z_w11 = UnreducedBigInt5(
        d0=y.w11.d0 * z_pow1_11.z_11.d0,
        d1=y.w11.d0 * z_pow1_11.z_11.d1 + y.w11.d1 * z_pow1_11.z_11.d0,
        d2=y.w11.d0 * z_pow1_11.z_11.d2 + y.w11.d1 * z_pow1_11.z_11.d1 + y.w11.d2 *
        z_pow1_11.z_11.d0,
        d3=y.w11.d1 * z_pow1_11.z_11.d2 + y.w11.d2 * z_pow1_11.z_11.d1,
        d4=y.w11.d2 * z_pow1_11.z_11.d2,
    );
    let y_of_z = reduce_5_full(
        UnreducedBigInt5(
            d0=y.w0.d0 + y_of_z_w1.d0 + y_of_z_w2.d0 + y_of_z_w3.d0 + y_of_z_w4.d0 + y_of_z_w6.d0 +
            y_of_z_w7.d0 + y_of_z_w8.d0 + y_of_z_w9.d0 + y_of_z_w10.d0 + y_of_z_w11.d0,
            d1=y.w0.d1 + y_of_z_w1.d1 + y_of_z_w2.d1 + y_of_z_w3.d1 + y_of_z_w4.d1 + y_of_z_w6.d1 +
            y_of_z_w7.d1 + y_of_z_w8.d1 + y_of_z_w9.d1 + y_of_z_w10.d1 + y_of_z_w11.d1,
            d2=y.w0.d2 + y_of_z_w1.d2 + y_of_z_w2.d2 + y_of_z_w3.d2 + y_of_z_w4.d2 + y_of_z_w6.d2 +
            y_of_z_w7.d2 + y_of_z_w8.d2 + y_of_z_w9.d2 + y_of_z_w10.d2 + y_of_z_w11.d2,
            d3=y_of_z_w1.d3 + y_of_z_w2.d3 + y_of_z_w3.d3 + y_of_z_w4.d3 + y_of_z_w6.d3 +
            y_of_z_w7.d3 + y_of_z_w8.d3 + y_of_z_w9.d3 + y_of_z_w10.d3 + y_of_z_w11.d3,
            d4=y_of_z_w1.d4 + y_of_z_w2.d4 + y_of_z_w3.d4 + y_of_z_w4.d4 + y_of_z_w6.d4 +
            y_of_z_w7.d4 + y_of_z_w8.d4 + y_of_z_w9.d4 + y_of_z_w10.d4 + y_of_z_w11.d4,
        ),
    );

    let xy_acc = reduce_5_full(
        UnreducedBigInt5(
            d0=x_of_z.d0 * y_of_z.d0,
            d1=x_of_z.d0 * y_of_z.d1 + x_of_z.d1 * y_of_z.d0,
            d2=x_of_z.d0 * y_of_z.d2 + x_of_z.d1 * y_of_z.d1 + x_of_z.d2 * y_of_z.d0,
            d3=x_of_z.d1 * y_of_z.d2 + x_of_z.d2 * y_of_z.d1,
            d4=x_of_z.d2 * y_of_z.d2,
        ),
    );

    let poseidon_ptr = poseidon_ptr + 56 * PoseidonBuiltin.SIZE;
    let continuable_hash = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s0;
    let random_linear_combination_coeff = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s1;
    assert bitwise_ptr.x = random_linear_combination_coeff;
    assert bitwise_ptr.y = BASE_MIN_1;
    let c_i = bitwise_ptr.x_and_y;
    let bitwise_ptr = bitwise_ptr + BitwiseBuiltin.SIZE;

    local poly_acc_01234_f: PolyAcc12 = PolyAcc12(
        xy=UnreducedBigInt3(
            d0=poly_acc_01234.xy.d0 + c_i * xy_acc.d0,
            d1=poly_acc_01234.xy.d1 + c_i * xy_acc.d1,
            d2=poly_acc_01234.xy.d2 + c_i * xy_acc.d2,
        ),
        q=E11full(
            Uint256(
                c_i * q_w.w0.low + poly_acc_01234.q.w0.low,
                c_i * q_w.w0.high + poly_acc_01234.q.w0.high,
            ),
            Uint256(
                c_i * q_w.w1.low + poly_acc_01234.q.w1.low,
                c_i * q_w.w1.high + poly_acc_01234.q.w1.high,
            ),
            Uint256(
                c_i * q_w.w2.low + poly_acc_01234.q.w2.low,
                c_i * q_w.w2.high + poly_acc_01234.q.w2.high,
            ),
            Uint256(
                c_i * q_w.w3.low + poly_acc_01234.q.w3.low,
                c_i * q_w.w3.high + poly_acc_01234.q.w3.high,
            ),
            Uint256(
                c_i * q_w.w4.low + poly_acc_01234.q.w4.low,
                c_i * q_w.w4.high + poly_acc_01234.q.w4.high,
            ),
            Uint256(
                c_i * q_w.w5.low + poly_acc_01234.q.w5.low,
                c_i * q_w.w5.high + poly_acc_01234.q.w5.high,
            ),
            Uint256(
                c_i * q_w.w6.low + poly_acc_01234.q.w6.low,
                c_i * q_w.w6.high + poly_acc_01234.q.w6.high,
            ),
            Uint256(
                c_i * q_w.w7.low + poly_acc_01234.q.w7.low,
                c_i * q_w.w7.high + poly_acc_01234.q.w7.high,
            ),
            Uint256(
                c_i * q_w.w8.low + poly_acc_01234.q.w8.low,
                c_i * q_w.w8.high + poly_acc_01234.q.w8.high,
            ),
            Uint256(
                c_i * q_w.w9.low + poly_acc_01234.q.w9.low,
                c_i * q_w.w9.high + poly_acc_01234.q.w9.high,
            ),
            Uint256(
                c_i * q_w.w10.low + poly_acc_01234.q.w10.low,
                c_i * q_w.w10.high + poly_acc_01234.q.w10.high,
            ),
        ),
        r=E12full(
            BigInt3(
                d0=c_i * r_w.w0.d0 + poly_acc_01234.r.w0.d0,
                d1=c_i * r_w.w0.d1 + poly_acc_01234.r.w0.d1,
                d2=c_i * r_w.w0.d2 + poly_acc_01234.r.w0.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w1.d0 + poly_acc_01234.r.w1.d0,
                d1=c_i * r_w.w1.d1 + poly_acc_01234.r.w1.d1,
                d2=c_i * r_w.w1.d2 + poly_acc_01234.r.w1.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w2.d0 + poly_acc_01234.r.w2.d0,
                d1=c_i * r_w.w2.d1 + poly_acc_01234.r.w2.d1,
                d2=c_i * r_w.w2.d2 + poly_acc_01234.r.w2.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w3.d0 + poly_acc_01234.r.w3.d0,
                d1=c_i * r_w.w3.d1 + poly_acc_01234.r.w3.d1,
                d2=c_i * r_w.w3.d2 + poly_acc_01234.r.w3.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w4.d0 + poly_acc_01234.r.w4.d0,
                d1=c_i * r_w.w4.d1 + poly_acc_01234.r.w4.d1,
                d2=c_i * r_w.w4.d2 + poly_acc_01234.r.w4.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w5.d0 + poly_acc_01234.r.w5.d0,
                d1=c_i * r_w.w5.d1 + poly_acc_01234.r.w5.d1,
                d2=c_i * r_w.w5.d2 + poly_acc_01234.r.w5.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w6.d0 + poly_acc_01234.r.w6.d0,
                d1=c_i * r_w.w6.d1 + poly_acc_01234.r.w6.d1,
                d2=c_i * r_w.w6.d2 + poly_acc_01234.r.w6.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w7.d0 + poly_acc_01234.r.w7.d0,
                d1=c_i * r_w.w7.d1 + poly_acc_01234.r.w7.d1,
                d2=c_i * r_w.w7.d2 + poly_acc_01234.r.w7.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w8.d0 + poly_acc_01234.r.w8.d0,
                d1=c_i * r_w.w8.d1 + poly_acc_01234.r.w8.d1,
                d2=c_i * r_w.w8.d2 + poly_acc_01234.r.w8.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w9.d0 + poly_acc_01234.r.w9.d0,
                d1=c_i * r_w.w9.d1 + poly_acc_01234.r.w9.d1,
                d2=c_i * r_w.w9.d2 + poly_acc_01234.r.w9.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w10.d0 + poly_acc_01234.r.w10.d0,
                d1=c_i * r_w.w10.d1 + poly_acc_01234.r.w10.d1,
                d2=c_i * r_w.w10.d2 + poly_acc_01234.r.w10.d2,
            ),
            BigInt3(
                d0=c_i * r_w.w11.d0 + poly_acc_01234.r.w11.d0,
                d1=c_i * r_w.w11.d1 + poly_acc_01234.r.w11.d1,
                d2=c_i * r_w.w11.d2 + poly_acc_01234.r.w11.d2,
            ),
        ),
    );
    let poly_acc_01234 = &poly_acc_01234_f;

    return &r_w;
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
    // MulBy034 multiplies z by an E12 sparse element of the form
    //
    // 	E12{
    // 		C0: E6{B0: 1, B1: 0, B2: 0},
    // 		C1: E6{B0: c3, B1: c4, B2: 0},
    // 	}
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
        assert_reduced_felt(inv0);
        assert_reduced_felt(inv1);
        assert_reduced_felt(inv2);
        assert_reduced_felt(inv3);
        assert_reduced_felt(inv4);
        assert_reduced_felt(inv5);
        assert_reduced_felt(inv6);
        assert_reduced_felt(inv7);
        assert_reduced_felt(inv8);
        assert_reduced_felt(inv9);
        assert_reduced_felt(inv10);
        assert_reduced_felt(inv11);
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

    func div{range_check_ptr}(x: E12*, y: E12*) -> E12* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local div0: BigInt3;
        local div1: BigInt3;
        local div2: BigInt3;
        local div3: BigInt3;
        local div4: BigInt3;
        local div5: BigInt3;
        local div6: BigInt3;
        local div7: BigInt3;
        local div8: BigInt3;
        local div9: BigInt3;
        local div10: BigInt3;
        local div11: BigInt3;

        %{
            from starkware.cairo.common.math_utils import as_int
            from tools.py.extension_trick import inv_e12, mul_e12, pack_e12, flatten
            assert 1 < ids.N_LIMBS <= 12
            p, x_c0, x_c1, y_c0, y_c1=0, 6*[0], 6*[0], 6*[0], 6*[0] 
            c0_refs =[ids.x.c0.b0.a0, ids.x.c0.b0.a1, ids.x.c0.b1.a0, ids.x.c0.b1.a1, ids.x.c0.b2.a0, ids.x.c0.b2.a1]
            c1_refs =[ids.x.c1.b0.a0, ids.x.c1.b0.a1, ids.x.c1.b1.a0, ids.x.c1.b1.a1, ids.x.c1.b2.a0, ids.x.c1.b2.a1]
            y_c0_refs = [ids.y.c0.b0.a0 , ids.y.c0.b0.a1 , ids.y.c0.b1.a0 , ids.y.c0.b1.a1 , ids.y.c0.b2.a0 , ids.y.c0.b2.a1]
            y_c1_refs = [ids.y.c1.b0.a0 , ids.y.c1.b0.a1 , ids.y.c1.b1.a0 , ids.y.c1.b1.a1 , ids.y.c1.b2.a0 , ids.y.c1.b2.a1]
            for i in range(ids.N_LIMBS):
                for k in range(6):
                    x_c0[k]+=as_int(getattr(c0_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
                    x_c1[k]+=as_int(getattr(c1_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
                    y_c0[k]+=as_int(getattr(y_c0_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
                    y_c1[k]+=as_int(getattr(y_c1_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i

                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
            xc0 = ((x_c0[0],x_c0[1]),(x_c0[2],x_c0[3]),(x_c0[4],x_c0[5]))
            xc1 = ((x_c1[0],x_c1[1]),(x_c1[2],x_c1[3]),(x_c1[4],x_c1[5]))
            yc0 = ((y_c0[0],y_c0[1]),(y_c0[2],y_c0[3]),(y_c0[4],y_c0[5]))
            yc1 = ((y_c1[0],y_c1[1]),(y_c1[2],y_c1[3]),(y_c1[4],y_c1[5]))
            y_inv = inv_e12(yc0,yc1)
            x_over_y = mul_e12((xc0, xc1), pack_e12(y_inv))


            e = [split(x) for x in flatten(x_over_y)]
            for i in range(12):
                for l in range(ids.N_LIMBS):
                    setattr(getattr(ids,f"div{i}"),f"d{l}",e[i][l])
        %}
        assert_reduced_felt(div0);
        assert_reduced_felt(div1);
        assert_reduced_felt(div2);
        assert_reduced_felt(div3);
        assert_reduced_felt(div4);
        assert_reduced_felt(div5);
        assert_reduced_felt(div6);
        assert_reduced_felt(div7);
        assert_reduced_felt(div8);
        assert_reduced_felt(div9);
        assert_reduced_felt(div10);
        assert_reduced_felt(div11);

        local c0b0: E2 = E2(&div0, &div1);
        local c0b1: E2 = E2(&div2, &div3);
        local c0b2: E2 = E2(&div4, &div5);
        local c0: E6 = E6(&c0b0, &c0b1, &c0b2);
        local c1b0: E2 = E2(&div6, &div7);
        local c1b1: E2 = E2(&div8, &div9);
        local c1b2: E2 = E2(&div10, &div11);
        local c1: E6 = E6(&c1b0, &c1b1, &c1b2);
        local div: E12 = E12(&c0, &c1);
        let check = e12.mul(y, &div);
        assert_E12(x, check);
        return &div;
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

// func verify_extension_tricks{
//     range_check_ptr, poseidon_ptr: PoseidonBuiltin*, verify_square_array: VerifyPolySquare**
// }(n_squares: felt, z: BigInt3*) {
//     alloc_locals;
//     let (__fp__, _) = get_fp_and_pc();

// let z_pow1_11: ZPowers* = get_powers_of_z(z);
//     let p_of_z: BigInt3* = eval_unreduced_poly(z_pow1_11);
//     local zero_e12full: E12full = E12full(
//         BigInt3(0, 0, 0),
//         BigInt3(0, 0, 0),
//         BigInt3(0, 0, 0),
//         BigInt3(0, 0, 0),
//         BigInt3(0, 0, 0),
//         BigInt3(0, 0, 0),
//         BigInt3(0, 0, 0),
//         BigInt3(0, 0, 0),
//         BigInt3(0, 0, 0),
//         BigInt3(0, 0, 0),
//         BigInt3(0, 0, 0),
//         BigInt3(0, 0, 0),
//     );

// local zero_e11full: E11full = E11full(
//         Uint256(0, 0),
//         Uint256(0, 0),
//         Uint256(0, 0),
//         Uint256(0, 0),
//         Uint256(0, 0),
//         Uint256(0, 0),
//         Uint256(0, 0),
//         Uint256(0, 0),
//         Uint256(0, 0),
//         Uint256(0, 0),
//         Uint256(0, 0),
//     );

// local zero_bigint5: UnreducedBigInt5 = UnreducedBigInt5(0, 0, 0, 0, 0);
//     local equation_init: PolyAcc = PolyAcc(xy=zero_bigint5, q=zero_e11full, r=zero_e12full);
//     %{ print(f"accumulating {ids.n_squares} squares equations") %}

// let equation_acc = accumulate_polynomial_equations(n_squares - 1, &equation_init, z_pow1_11);

// let sum_r_of_z = eval_E12_unreduced(&equation_acc.r, z_pow1_11);

// // Check Σ(x(rnd) * y(rnd)) === Σ(q(rnd) * P(rnd)) + Σ(r(rnd)):
//     let sum_q_of_z = eval_E11(&equation_acc.q, z_pow1_11);
//     let (sum_qP_of_z) = bigint_mul([sum_q_of_z], [p_of_z]);
//     verify_zero5(
//         UnreducedBigInt5(
//             d0=equation_acc.xy.d0 - sum_qP_of_z.d0 - sum_r_of_z.d0,
//             d1=equation_acc.xy.d1 - sum_qP_of_z.d1 - sum_r_of_z.d1,
//             d2=equation_acc.xy.d2 - sum_qP_of_z.d2 - sum_r_of_z.d2,
//             d3=equation_acc.xy.d3 - sum_qP_of_z.d3 - sum_r_of_z.d3,
//             d4=equation_acc.xy.d4 - sum_qP_of_z.d4 - sum_r_of_z.d4,
//         ),
//     );
//     return ();
// }

// Accmulate relevant Σ terms in Σ(x(z) * y(z)) == Σ(q(z) * P(z)) + Σ(r(z))
// Since Σ(x*y) != Σ(x) * Σ(y), we need to accumulate the product of polynomials evaluated at z.
// For r, we can accumulate the polynomial coefficient directly and evaluate later.
// Since P(z) is constant, we can factor it out of the sum and accumulate q coefficients.:
// Σ(q(z) * P(z)) = P(z) * Σ(q(z))
// The equation becomes :
// Σ(x(z) * y(z)) = P(z) * Σ(q(z)) + Σ(r(z))
// func accumulate_polynomial_equations{range_check_ptr, verify_square_array: VerifyPolySquare**}(
//     index: felt, equation_acc: PolyAcc*, z_pow1_11: ZPowers*
// ) -> PolyAcc* {
//     alloc_locals;
//     let (__fp__, _) = get_fp_and_pc();
//     if (index == -1) {
//         return equation_acc;
//     } else {
//         let x_of_z = eval_E12(verify_square_array[index].x, z_pow1_11);
//         let (xy_acc) = bigint_sqr([x_of_z]);

// local equation_acc_new: PolyAcc = PolyAcc(
//             xy=UnreducedBigInt5(
//                 d0=equation_acc.xy.d0 + xy_acc.d0,
//                 d1=equation_acc.xy.d1 + xy_acc.d1,
//                 d2=equation_acc.xy.d2 + xy_acc.d2,
//                 d3=equation_acc.xy.d3 + xy_acc.d3,
//                 d4=equation_acc.xy.d4 + xy_acc.d4,
//             ),
//             q=E11full(
//                 Uint256(
//                     verify_square_array[index].q.w0.low + equation_acc.q.w0.low,
//                     verify_square_array[index].q.w0.high + equation_acc.q.w0.high,
//                 ),
//                 Uint256(
//                     verify_square_array[index].q.w1.low + equation_acc.q.w1.low,
//                     verify_square_array[index].q.w1.high + equation_acc.q.w1.high,
//                 ),
//                 Uint256(
//                     verify_square_array[index].q.w2.low + equation_acc.q.w2.low,
//                     verify_square_array[index].q.w2.high + equation_acc.q.w2.high,
//                 ),
//                 Uint256(
//                     verify_square_array[index].q.w3.low + equation_acc.q.w3.low,
//                     verify_square_array[index].q.w3.high + equation_acc.q.w3.high,
//                 ),
//                 Uint256(
//                     verify_square_array[index].q.w4.low + equation_acc.q.w4.low,
//                     verify_square_array[index].q.w4.high + equation_acc.q.w4.high,
//                 ),
//                 Uint256(
//                     verify_square_array[index].q.w5.low + equation_acc.q.w5.low,
//                     verify_square_array[index].q.w5.high + equation_acc.q.w5.high,
//                 ),
//                 Uint256(
//                     verify_square_array[index].q.w6.low + equation_acc.q.w6.low,
//                     verify_square_array[index].q.w6.high + equation_acc.q.w6.high,
//                 ),
//                 Uint256(
//                     verify_square_array[index].q.w7.low + equation_acc.q.w7.low,
//                     verify_square_array[index].q.w7.high + equation_acc.q.w7.high,
//                 ),
//                 Uint256(
//                     verify_square_array[index].q.w8.low + equation_acc.q.w8.low,
//                     verify_square_array[index].q.w8.high + equation_acc.q.w8.high,
//                 ),
//                 Uint256(
//                     verify_square_array[index].q.w9.low + equation_acc.q.w9.low,
//                     verify_square_array[index].q.w9.high + equation_acc.q.w9.high,
//                 ),
//                 Uint256(
//                     verify_square_array[index].q.w10.low + equation_acc.q.w10.low,
//                     verify_square_array[index].q.w10.high + equation_acc.q.w10.high,
//                 ),
//             ),
//             r=E12full(
//                 BigInt3(
//                     verify_square_array[index].r.w0.d0 + equation_acc.r.w0.d0,
//                     verify_square_array[index].r.w0.d1 + equation_acc.r.w0.d1,
//                     verify_square_array[index].r.w0.d2 + equation_acc.r.w0.d2,
//                 ),
//                 BigInt3(
//                     verify_square_array[index].r.w1.d0 + equation_acc.r.w1.d0,
//                     verify_square_array[index].r.w1.d1 + equation_acc.r.w1.d1,
//                     verify_square_array[index].r.w1.d2 + equation_acc.r.w1.d2,
//                 ),
//                 BigInt3(
//                     verify_square_array[index].r.w2.d0 + equation_acc.r.w2.d0,
//                     verify_square_array[index].r.w2.d1 + equation_acc.r.w2.d1,
//                     verify_square_array[index].r.w2.d2 + equation_acc.r.w2.d2,
//                 ),
//                 BigInt3(
//                     verify_square_array[index].r.w3.d0 + equation_acc.r.w3.d0,
//                     verify_square_array[index].r.w3.d1 + equation_acc.r.w3.d1,
//                     verify_square_array[index].r.w3.d2 + equation_acc.r.w3.d2,
//                 ),
//                 BigInt3(
//                     verify_square_array[index].r.w4.d0 + equation_acc.r.w4.d0,
//                     verify_square_array[index].r.w4.d1 + equation_acc.r.w4.d1,
//                     verify_square_array[index].r.w4.d2 + equation_acc.r.w4.d2,
//                 ),
//                 BigInt3(
//                     verify_square_array[index].r.w5.d0 + equation_acc.r.w5.d0,
//                     verify_square_array[index].r.w5.d1 + equation_acc.r.w5.d1,
//                     verify_square_array[index].r.w5.d2 + equation_acc.r.w5.d2,
//                 ),
//                 BigInt3(
//                     verify_square_array[index].r.w6.d0 + equation_acc.r.w6.d0,
//                     verify_square_array[index].r.w6.d1 + equation_acc.r.w6.d1,
//                     verify_square_array[index].r.w6.d2 + equation_acc.r.w6.d2,
//                 ),
//                 BigInt3(
//                     verify_square_array[index].r.w7.d0 + equation_acc.r.w7.d0,
//                     verify_square_array[index].r.w7.d1 + equation_acc.r.w7.d1,
//                     verify_square_array[index].r.w7.d2 + equation_acc.r.w7.d2,
//                 ),
//                 BigInt3(
//                     verify_square_array[index].r.w8.d0 + equation_acc.r.w8.d0,
//                     verify_square_array[index].r.w8.d1 + equation_acc.r.w8.d1,
//                     verify_square_array[index].r.w8.d2 + equation_acc.r.w8.d2,
//                 ),
//                 BigInt3(
//                     verify_square_array[index].r.w9.d0 + equation_acc.r.w9.d0,
//                     verify_square_array[index].r.w9.d1 + equation_acc.r.w9.d1,
//                     verify_square_array[index].r.w9.d2 + equation_acc.r.w9.d2,
//                 ),
//                 BigInt3(
//                     verify_square_array[index].r.w10.d0 + equation_acc.r.w10.d0,
//                     verify_square_array[index].r.w10.d1 + equation_acc.r.w10.d1,
//                     verify_square_array[index].r.w10.d2 + equation_acc.r.w10.d2,
//                 ),
//                 BigInt3(
//                     verify_square_array[index].r.w11.d0 + equation_acc.r.w11.d0,
//                     verify_square_array[index].r.w11.d1 + equation_acc.r.w11.d1,
//                     verify_square_array[index].r.w11.d2 + equation_acc.r.w11.d2,
//                 ),
//             ),
//         );
//         return accumulate_polynomial_equations(index - 1, &equation_acc_new, z_pow1_11);
//     }
// }

func eval_unreduced_poly12{range_check_ptr}(z_6: BigInt3, z_12: BigInt3) -> BigInt3 {
    alloc_locals;
    local w6: BigInt3 = BigInt3(
        60193888514187762220203317, 27625954992973055882053025, 3656382694611191768777988
    );  // -18 % p
    let (e6) = bigint_mul(w6, z_6);

    let res = reduce_5_full(
        UnreducedBigInt5(
            d0=82 + e6.d0 + z_12.d0, d1=e6.d1 + z_12.d1, d2=e6.d2 + z_12.d2, d3=e6.d3, d4=e6.d4
        ),
    );
    return res;
}
func eval_E11{range_check_ptr}(e12: E11full, powers: ZPowers11*) -> BigInt3 {
    alloc_locals;
    let (w0) = unrededucedUint256_to_BigInt3(e12.w0);
    let (w1) = unrededucedUint256_to_BigInt3(e12.w1);
    let (w2) = unrededucedUint256_to_BigInt3(e12.w2);
    let (w3) = unrededucedUint256_to_BigInt3(e12.w3);
    let (w4) = unrededucedUint256_to_BigInt3(e12.w4);
    let (w5) = unrededucedUint256_to_BigInt3(e12.w5);
    let (w6) = unrededucedUint256_to_BigInt3(e12.w6);
    let (w7) = unrededucedUint256_to_BigInt3(e12.w7);
    let (w8) = unrededucedUint256_to_BigInt3(e12.w8);
    let (w9) = unrededucedUint256_to_BigInt3(e12.w9);
    let (w10) = unrededucedUint256_to_BigInt3(e12.w10);

    let e0 = w0;
    let (e1) = bigint_mul([w1], powers.z_1);
    let (e2) = bigint_mul([w2], powers.z_2);
    let (e3) = bigint_mul([w3], powers.z_3);
    let (e4) = bigint_mul([w4], powers.z_4);
    let (e5) = bigint_mul([w5], powers.z_5);
    let (e6) = bigint_mul([w6], powers.z_6);
    let (e7) = bigint_mul([w7], powers.z_7);
    let (e8) = bigint_mul([w8], powers.z_8);
    let (e9) = bigint_mul([w9], powers.z_9);
    let (e10) = bigint_mul([w10], powers.z_10);
    let res = reduce_5_full(
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

func eval_E12{range_check_ptr}(e12: E12full*, powers: ZPowers11*) -> BigInt3* {
    alloc_locals;
    let e0 = e12.w0;
    let (e1) = bigint_mul(e12.w1, powers.z_1);
    let (e2) = bigint_mul(e12.w2, powers.z_2);
    let (e3) = bigint_mul(e12.w3, powers.z_3);
    let (e4) = bigint_mul(e12.w4, powers.z_4);
    let (e5) = bigint_mul(e12.w5, powers.z_5);
    let (e6) = bigint_mul(e12.w6, powers.z_6);
    let (e7) = bigint_mul(e12.w7, powers.z_7);
    let (e8) = bigint_mul(e12.w8, powers.z_8);
    let (e9) = bigint_mul(e12.w9, powers.z_9);
    let (e10) = bigint_mul(e12.w10, powers.z_10);
    let (e11) = bigint_mul(e12.w11, powers.z_11);
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

func eval_E12_unreduced{range_check_ptr}(e12: E12full, powers: ZPowers11*) -> UnreducedBigInt5 {
    alloc_locals;
    let w1 = reduce_3_full(e12.w1);
    let w2 = reduce_3_full(e12.w2);
    let w3 = reduce_3_full(e12.w3);
    let w4 = reduce_3_full(e12.w4);
    let w5 = reduce_3_full(e12.w5);
    let w6 = reduce_3_full(e12.w6);
    let w7 = reduce_3_full(e12.w7);
    let w8 = reduce_3_full(e12.w8);
    let w9 = reduce_3_full(e12.w9);
    let w10 = reduce_3_full(e12.w10);
    let w11 = reduce_3_full(e12.w11);

    let e0 = e12.w0;
    let (e1) = bigint_mul(w1, powers.z_1);
    let (e2) = bigint_mul(w2, powers.z_2);
    let (e3) = bigint_mul(w3, powers.z_3);
    let (e4) = bigint_mul(w4, powers.z_4);
    let (e5) = bigint_mul(w5, powers.z_5);
    let (e6) = bigint_mul(w6, powers.z_6);
    let (e7) = bigint_mul(w7, powers.z_7);
    let (e8) = bigint_mul(w8, powers.z_8);
    let (e9) = bigint_mul(w9, powers.z_9);
    let (e10) = bigint_mul(w10, powers.z_10);
    let (e11) = bigint_mul(w11, powers.z_11);
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

func get_powers_of_z11{range_check_ptr}(z: BigInt3) -> ZPowers11* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let z_2 = fq_bigint3.mulf(z, z);
    let z_3 = fq_bigint3.mulf(z_2, z);
    let z_4 = fq_bigint3.mulf(z_3, z);
    let z_5 = fq_bigint3.mulf(z_4, z);
    let z_6 = fq_bigint3.mulf(z_5, z);
    let z_7 = fq_bigint3.mulf(z_6, z);
    let z_8 = fq_bigint3.mulf(z_7, z);
    let z_9 = fq_bigint3.mulf(z_8, z);
    let z_10 = fq_bigint3.mulf(z_9, z);
    let z_11 = fq_bigint3.mulf(z_10, z);

    local res: ZPowers11 = ZPowers11(
        z_1=z,
        z_2=z_2,
        z_3=z_3,
        z_4=z_4,
        z_5=z_5,
        z_6=z_6,
        z_7=z_7,
        z_8=z_8,
        z_9=z_9,
        z_10=z_10,
        z_11=z_11,
    );
    return &res;
}

// Convert tower representations Fp12/Fp6/Fp2/Fp to Fp12/Fp
func gnark_to_w{range_check_ptr}(x: E12*) -> (res: E12full*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local res: E12full = E12full(
        w0=BigInt3(
            x.c0.b0.a0.d0 - 9 * x.c0.b0.a1.d0,
            x.c0.b0.a0.d1 - 9 * x.c0.b0.a1.d1,
            x.c0.b0.a0.d2 - 9 * x.c0.b0.a1.d2,
        ),
        w1=BigInt3(
            x.c1.b0.a0.d0 - 9 * x.c1.b0.a1.d0,
            x.c1.b0.a0.d1 - 9 * x.c1.b0.a1.d1,
            x.c1.b0.a0.d2 - 9 * x.c1.b0.a1.d2,
        ),
        w2=BigInt3(
            x.c0.b1.a0.d0 - 9 * x.c0.b1.a1.d0,
            x.c0.b1.a0.d1 - 9 * x.c0.b1.a1.d1,
            x.c0.b1.a0.d2 - 9 * x.c0.b1.a1.d2,
        ),
        w3=BigInt3(
            x.c1.b1.a0.d0 - 9 * x.c1.b1.a1.d0,
            x.c1.b1.a0.d1 - 9 * x.c1.b1.a1.d1,
            x.c1.b1.a0.d2 - 9 * x.c1.b1.a1.d2,
        ),
        w4=BigInt3(
            x.c0.b2.a0.d0 - 9 * x.c0.b2.a1.d0,
            x.c0.b2.a0.d1 - 9 * x.c0.b2.a1.d1,
            x.c0.b2.a0.d2 - 9 * x.c0.b2.a1.d2,
        ),
        w5=BigInt3(
            x.c1.b2.a0.d0 - 9 * x.c1.b2.a1.d0,
            x.c1.b2.a0.d1 - 9 * x.c1.b2.a1.d1,
            x.c1.b2.a0.d2 - 9 * x.c1.b2.a1.d2,
        ),
        w6=[x.c0.b0.a1],
        w7=[x.c1.b0.a1],
        w8=[x.c0.b1.a1],
        w9=[x.c1.b1.a1],
        w10=[x.c0.b2.a1],
        w11=[x.c1.b2.a1],
    );
    return (&res,);
}

// E12_034{
// 		C0: E6{B0: 1, B1: 0, B2: 0},
// 		C1: E6{B0: c3, B1: c4, B2: 0},
// 	}
// c3 <=> x.c1.b0
// c4 <=> x.c1.b1

func gnark034_to_w{range_check_ptr}(c3: E2*, c4: E2*) -> (res: E12full034*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local res: E12full034 = E12full034(
        w1=BigInt3(c3.a0.d0 - 9 * c3.a1.d0, c3.a0.d1 - 9 * c3.a1.d1, c3.a0.d2 - 9 * c3.a1.d2),
        w3=BigInt3(c4.a0.d0 - 9 * c4.a1.d0, c4.a0.d1 - 9 * c4.a1.d1, c4.a0.d2 - 9 * c4.a1.d2),
        w7=[c3.a1],
        w9=[c4.a1],
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

func assert_reduced_e12full{range_check_ptr}(x: E12full) {
    assert [range_check_ptr] = x.w0.d0;
    assert [range_check_ptr + 1] = x.w0.d1;
    assert [range_check_ptr + 2] = x.w0.d2;
    assert [range_check_ptr + 3] = BASE_MIN_1 - x.w0.d0;
    assert [range_check_ptr + 4] = BASE_MIN_1 - x.w0.d1;
    assert [range_check_ptr + 5] = P2 - x.w0.d2;
    assert [range_check_ptr + 6] = x.w1.d0;
    assert [range_check_ptr + 7] = x.w1.d1;
    assert [range_check_ptr + 8] = x.w1.d2;
    assert [range_check_ptr + 9] = BASE_MIN_1 - x.w1.d0;
    assert [range_check_ptr + 10] = BASE_MIN_1 - x.w1.d1;
    assert [range_check_ptr + 11] = P2 - x.w1.d2;
    assert [range_check_ptr + 12] = x.w2.d0;
    assert [range_check_ptr + 13] = x.w2.d1;
    assert [range_check_ptr + 14] = x.w2.d2;
    assert [range_check_ptr + 15] = BASE_MIN_1 - x.w2.d0;
    assert [range_check_ptr + 16] = BASE_MIN_1 - x.w2.d1;
    assert [range_check_ptr + 17] = P2 - x.w2.d2;
    assert [range_check_ptr + 18] = x.w3.d0;
    assert [range_check_ptr + 19] = x.w3.d1;
    assert [range_check_ptr + 20] = x.w3.d2;
    assert [range_check_ptr + 21] = BASE_MIN_1 - x.w3.d0;
    assert [range_check_ptr + 22] = BASE_MIN_1 - x.w3.d1;
    assert [range_check_ptr + 23] = P2 - x.w3.d2;
    assert [range_check_ptr + 24] = x.w4.d0;
    assert [range_check_ptr + 25] = x.w4.d1;
    assert [range_check_ptr + 26] = x.w4.d2;
    assert [range_check_ptr + 27] = BASE_MIN_1 - x.w4.d0;
    assert [range_check_ptr + 28] = BASE_MIN_1 - x.w4.d1;
    assert [range_check_ptr + 29] = P2 - x.w4.d2;
    assert [range_check_ptr + 30] = x.w5.d0;
    assert [range_check_ptr + 31] = x.w5.d1;
    assert [range_check_ptr + 32] = x.w5.d2;
    assert [range_check_ptr + 33] = BASE_MIN_1 - x.w5.d0;
    assert [range_check_ptr + 34] = BASE_MIN_1 - x.w5.d1;
    assert [range_check_ptr + 35] = P2 - x.w5.d2;
    assert [range_check_ptr + 36] = x.w6.d0;
    assert [range_check_ptr + 37] = x.w6.d1;
    assert [range_check_ptr + 38] = x.w6.d2;
    assert [range_check_ptr + 39] = BASE_MIN_1 - x.w6.d0;
    assert [range_check_ptr + 40] = BASE_MIN_1 - x.w6.d1;
    assert [range_check_ptr + 41] = P2 - x.w6.d2;
    assert [range_check_ptr + 42] = x.w7.d0;
    assert [range_check_ptr + 43] = x.w7.d1;
    assert [range_check_ptr + 44] = x.w7.d2;
    assert [range_check_ptr + 45] = BASE_MIN_1 - x.w7.d0;
    assert [range_check_ptr + 46] = BASE_MIN_1 - x.w7.d1;
    assert [range_check_ptr + 47] = P2 - x.w7.d2;
    assert [range_check_ptr + 48] = x.w8.d0;
    assert [range_check_ptr + 49] = x.w8.d1;
    assert [range_check_ptr + 50] = x.w8.d2;
    assert [range_check_ptr + 51] = BASE_MIN_1 - x.w8.d0;
    assert [range_check_ptr + 52] = BASE_MIN_1 - x.w8.d1;
    assert [range_check_ptr + 53] = P2 - x.w8.d2;
    assert [range_check_ptr + 54] = x.w9.d0;
    assert [range_check_ptr + 55] = x.w9.d1;
    assert [range_check_ptr + 56] = x.w9.d2;
    assert [range_check_ptr + 57] = BASE_MIN_1 - x.w9.d0;
    assert [range_check_ptr + 58] = BASE_MIN_1 - x.w9.d1;
    assert [range_check_ptr + 59] = P2 - x.w9.d2;
    assert [range_check_ptr + 60] = x.w10.d0;
    assert [range_check_ptr + 61] = x.w10.d1;
    assert [range_check_ptr + 62] = x.w10.d2;
    assert [range_check_ptr + 63] = BASE_MIN_1 - x.w10.d0;
    assert [range_check_ptr + 64] = BASE_MIN_1 - x.w10.d1;
    assert [range_check_ptr + 65] = P2 - x.w10.d2;
    assert [range_check_ptr + 66] = x.w11.d0;
    assert [range_check_ptr + 67] = x.w11.d1;
    assert [range_check_ptr + 68] = x.w11.d2;
    assert [range_check_ptr + 69] = BASE_MIN_1 - x.w11.d0;
    assert [range_check_ptr + 70] = BASE_MIN_1 - x.w11.d1;
    assert [range_check_ptr + 71] = P2 - x.w11.d2;

    if (x.w0.d2 == P2) {
        if (x.w0.d1 == P1) {
            assert [range_check_ptr + 72] = P0 - 1 - x.w0.d0;
            tempvar range_check_ptr = range_check_ptr + 73;
        } else {
            assert [range_check_ptr + 72] = P1 - 1 - x.w0.d1;
            tempvar range_check_ptr = range_check_ptr + 73;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr + 72;
    }

    if (x.w1.d2 == P2) {
        if (x.w1.d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - x.w1.d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - x.w1.d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (x.w2.d2 == P2) {
        if (x.w2.d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - x.w2.d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - x.w2.d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (x.w3.d2 == P2) {
        if (x.w3.d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - x.w3.d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - x.w3.d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (x.w4.d2 == P2) {
        if (x.w4.d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - x.w4.d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - x.w4.d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (x.w5.d2 == P2) {
        if (x.w5.d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - x.w5.d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - x.w5.d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (x.w6.d2 == P2) {
        if (x.w6.d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - x.w6.d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - x.w6.d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (x.w7.d2 == P2) {
        if (x.w7.d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - x.w7.d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - x.w7.d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (x.w8.d2 == P2) {
        if (x.w8.d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - x.w8.d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - x.w8.d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (x.w9.d2 == P2) {
        if (x.w9.d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - x.w9.d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - x.w9.d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (x.w10.d2 == P2) {
        if (x.w10.d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - x.w10.d0;
            tempvar range_check_ptr = range_check_ptr + 1;
        } else {
            assert [range_check_ptr] = P1 - 1 - x.w10.d1;
            tempvar range_check_ptr = range_check_ptr + 1;
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
    }

    if (x.w11.d2 == P2) {
        if (x.w11.d1 == P1) {
            assert [range_check_ptr] = P0 - 1 - x.w11.d0;
            tempvar range_check_ptr = range_check_ptr + 1;
            return ();
        } else {
            assert [range_check_ptr] = P1 - 1 - x.w11.d1;
            tempvar range_check_ptr = range_check_ptr + 1;
            return ();
        }
    } else {
        tempvar range_check_ptr = range_check_ptr;
        return ();
    }
}
