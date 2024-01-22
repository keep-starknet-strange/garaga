%builtins range_check bitwise poseidon

from src.bn254.towers.e12 import (
    E12,
    e12,
    E12D,
    E12full034,
    E9full,
    get_powers_of_z11,
    PolyAcc034,
    ZPowers11,
    BASE_MIN_1,
)
from src.bn254.towers.e6 import E6, e6
from src.bn254.towers.e2 import E2, e2
from starkware.cairo.common.registers import get_fp_and_pc
from src.bn254.fq import (
    BigInt3,
    N_LIMBS,
    BASE,
    uint256_to_bigint,
    bigint_mul,
    fq_bigint3,
    reduce_5,
    reduce_3,
    verify_zero5,
    UnreducedBigInt3,
    UnreducedBigInt5,
)

from starkware.cairo.common.builtin_poseidon.poseidon import poseidon_hash, poseidon_hash_many
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, BitwiseBuiltin
from starkware.cairo.common.poseidon_state import PoseidonBuiltinState
from starkware.cairo.common.math import split_felt
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.alloc import alloc
const TWO = 2;
const THREE_BASE_MIN_1 = 3 * BASE_MIN_1;
func main{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, poseidon_ptr: PoseidonBuiltin*}() {
    alloc_locals;
    %{
        import subprocess
        import random
        import functools
        import re
        from starkware.cairo.common.cairo_secp.secp_utils import split

        P=p=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
        def rgetattr(obj, attr, *args):
            def _getattr(obj, attr):
                return getattr(obj, attr, *args)
            return functools.reduce(_getattr, [obj] + attr.split('.'))

        def rsetattr(obj, attr, val):
            pre, _, post = attr.rpartition('.')
            return setattr(rgetattr(obj, pre) if pre else obj, post, val)

        def fill_e12(e2:str, *args):
            for i in range(12):
                splitted = split(args[i])
                for j in range(3):
                    rsetattr(ids,e2+str(i)+'.d'+str(j),splitted[j])
            return None
        def parse_fp_elements(input_string:str):
            pattern = re.compile(r'\[([^\[\]]+)\]')
            substrings = pattern.findall(input_string)
            sublists = [substring.split(' ') for substring in substrings]
            sublists = [[int(x) for x in sublist] for sublist in sublists]
            fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 for x in sublists]
            return fp_elements
        def print_e12(e12:str):
            refs = [rgetattr(ids, e12+'.c0.b0.a0'), rgetattr(ids, e12+'.c0.b0.a1'), rgetattr(ids, e12+'.c0.b1.a0'), rgetattr(ids, e12+'.c0.b1.a1'), rgetattr(ids, e12+'.c0.b2.a0'), rgetattr(ids, e12+'.c0.b2.a1'), rgetattr(ids, e12+'.c1.b0.a0'), rgetattr(ids, e12+'.c1.b0.a1'), rgetattr(ids, e12+'.c1.b1.a0'), rgetattr(ids, e12+'.c1.b1.a1'), rgetattr(ids, e12+'.c1.b2.a0'), rgetattr(ids, e12+'.c1.b2.a1')]
            value = 12*[0]
            for i in range(12):
                for j in range(3):
                    value[i]+=as_int(getattr(refs[i], 'd'+str(j)), PRIME) * ids.BASE**j
            print(e12, value)
    %}
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt3;
    local x1: BigInt3;
    local x2: BigInt3;
    local x3: BigInt3;
    local x4: BigInt3;
    local x5: BigInt3;
    local x6: BigInt3;
    local x7: BigInt3;
    local x8: BigInt3;
    local x9: BigInt3;
    local x10: BigInt3;
    local x11: BigInt3;

    local y0: BigInt3;
    local y1: BigInt3;
    local y2: BigInt3;
    local y3: BigInt3;
    local y4: BigInt3;
    local y5: BigInt3;
    local y6: BigInt3;
    local y7: BigInt3;
    local y8: BigInt3;
    local y9: BigInt3;
    local y10: BigInt3;
    local y11: BigInt3;

    local z0: BigInt3;
    local z1: BigInt3;
    local z2: BigInt3;
    local z3: BigInt3;
    local z4: BigInt3;
    local z5: BigInt3;
    local z6: BigInt3;
    local z7: BigInt3;
    local z8: BigInt3;
    local z9: BigInt3;
    local z10: BigInt3;
    local z11: BigInt3;

    %{
        random.seed(42)
        inputs=[random.randint(0, P-1) for i in range(24)]
        inputs=[10, 1, 10, 1, 10, 1, 10, 1, 10, 1, 10, 1] * 2
        fill_e12('x', *inputs[0:12])
        fill_e12('y', *inputs[12:24])

        cmd = ['./tools/gnark/main', 'e12', 'mul'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        print('out', out)
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z', *fp_elements)
    %}
    local zero_bigint3: UnreducedBigInt3 = UnreducedBigInt3(0, 0, 0);
    local zero_e12full: E12D = E12D(
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

    local zero_e9full: E9full = E9full(
        Uint256(0, 0),
        Uint256(0, 0),
        Uint256(0, 0),
        Uint256(0, 0),
        Uint256(0, 0),
        Uint256(0, 0),
        Uint256(0, 0),
        Uint256(0, 0),
        Uint256(0, 0),
    );

    local poly_acc_034_f: PolyAcc034 = PolyAcc034(xy=zero_bigint3, q=zero_e9full, r=zero_e12full);
    let poly_acc_034 = &poly_acc_034_f;

    let continuable_hash = 'GaragaBN254MillerLoop';
    local x: E12D = E12D(x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11);
    local y: E12full034 = E12full034(y0, y1, y2, y3);
    let z_pow1_11_ptr = get_powers_of_z11(BigInt3(1, 1, 1));
    with z_pow1_11_ptr, poly_acc_034, continuable_hash {
        let res2 = mul034_trick(&x, &y);
    }
    return ();
}

func mul034_trick{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    z_pow1_11_ptr: ZPowers11*,
    continuable_hash: felt,
    poly_acc_034: PolyAcc034*,
}(x_ptr: E12D*, y_ptr: E12full034*) -> E12D* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local x: E12D = [x_ptr];
    local y: E12full034 = [y_ptr];
    local z_pow1_11: ZPowers11 = [z_pow1_11_ptr];
    local r_w: E12full;
    local q_w: E9full;

    %{
        from tools.py.polynomial import Polynomial
        from tools.py.field import BaseFieldElement, BaseField
        from tools.py.extension_trick import w_to_gnark, gnark_to_w, flatten, pack_e12, mul_e12_gnark
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
        x_gnark=w_to_gnark(x)
        y_gnark=w_to_gnark(y)
        print(f"Y_Gnark: {y_gnark}")
        print(f"Y_034: {y}")
        x_poly=Polynomial([BaseFieldElement(x[i], field) for i in range(12)])
        y_poly=Polynomial([BaseFieldElement(y[i], field) for i in range(12)])
        z_poly=x_poly*y_poly
        print(f"mul034 res degree : {z_poly.degree()}")
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
        # z_polyr_coeffs = z_polyr_coeffs + (12-len(z_polyr_coeffs))*[0]
        expected = flatten(mul_e12_gnark(pack_e12(x_gnark), pack_e12(y_gnark)))
        assert expected==w_to_gnark(z_polyr_coeffs)
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

    // tempvar z_1d0 = z_pow1_11.z_1.d0;
    // tempvar z_1d1 = z_pow1_11.z_1.d1;
    // tempvar z_1d2 = z_pow1_11.z_1.d2;
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

    // let (x_of_z_w1) = bigint_mul(x.w1, z_pow1_11.z_1);

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

    // let (x_of_z_w2) = bigint_mul(x.w2, z_pow1_11.z_2);
    // let (x_of_z_w3) = bigint_mul(x.w3, z_pow1_11.z_3);
    // let (x_of_z_w4) = bigint_mul(x.w4, z_pow1_11.z_4);
    // let (x_of_z_w5) = bigint_mul(x.w5, z_pow1_11.z_5);
    // let (x_of_z_w6) = bigint_mul(x.w6, z_pow1_11.z_6);
    // let (x_of_z_w7) = bigint_mul(x.w7, z_pow1_11.z_7);
    // let (x_of_z_w8) = bigint_mul(x.w8, z_pow1_11.z_8);
    // let (x_of_z_w9) = bigint_mul(x.w9, z_pow1_11.z_9);
    // let (x_of_z_w10) = bigint_mul(x.w10, z_pow1_11.z_10);
    // let (x_of_z_w11) = bigint_mul(x.w11, z_pow1_11.z_11);

    let x_of_z = reduce_5(
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

    // let (y_of_z_w1) = bigint_mul(y.w1, z_pow1_11.z_1);
    // let (y_of_z_w3) = bigint_mul(y.w3, z_pow1_11.z_3);
    // let (y_of_z_w7) = bigint_mul(y.w7, z_pow1_11.z_7);
    // let (y_of_z_w9) = bigint_mul(y.w9, z_pow1_11.z_9);

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

    let y_of_z = reduce_5(
        UnreducedBigInt5(
            d0=1 + y_of_z_w1.d0 + y_of_z_w3.d0 + y_of_z_w7.d0 + y_of_z_w9.d0,
            d1=y_of_z_w1.d1 + y_of_z_w3.d1 + y_of_z_w7.d1 + y_of_z_w9.d1,
            d2=y_of_z_w1.d2 + y_of_z_w3.d2 + y_of_z_w7.d2 + y_of_z_w9.d2,
            d3=y_of_z_w1.d3 + y_of_z_w3.d3 + y_of_z_w7.d3 + y_of_z_w9.d3,
            d4=y_of_z_w1.d4 + y_of_z_w3.d4 + y_of_z_w7.d4 + y_of_z_w9.d4,
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
        r=E12D(
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
