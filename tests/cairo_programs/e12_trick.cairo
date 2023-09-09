%builtins range_check poseidon

from src.bn254.towers.e12 import E12, e12
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
from src.bn254.towers.e12 import E12full, E11full, poseidon_hash_e11, poseidon_hash_e12

from starkware.cairo.common.builtin_poseidon.poseidon import poseidon_hash, poseidon_hash_many
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin
from starkware.cairo.common.poseidon_state import PoseidonBuiltinState
from starkware.cairo.common.math import split_felt
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.alloc import alloc

func main{range_check_ptr, poseidon_ptr: PoseidonBuiltin*}() {
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
    tempvar x = new E12(
        new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5)),
        new E6(new E2(&x6, &x7), new E2(&x8, &x9), new E2(&x10, &x11)),
    );
    tempvar y = new E12(
        new E6(new E2(&y0, &y1), new E2(&y2, &y3), new E2(&y4, &y5)),
        new E6(new E2(&y6, &y7), new E2(&y8, &y9), new E2(&y10, &y11)),
    );
    tempvar z = new E12(
        new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
        new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
    );
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
    let res = e12.mul(x, y);

    e12.assert_E12(res, z);

    let res2 = mul_e12_trick(x, y);

    e12.assert_E12(res2, z);
    return ();
}

func mul_e12_trick{range_check_ptr, poseidon_ptr: PoseidonBuiltin*}(x: E12*, y: E12*) -> E12* {
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
        x_gnark,y_gnark=12*[0],12*[0]
        x_refs=[ids.x.c0.b0.a0, ids.x.c0.b0.a1, ids.x.c0.b1.a0, ids.x.c0.b1.a1, ids.x.c0.b2.a0, ids.x.c0.b2.a1, ids.x.c1.b0.a0, ids.x.c1.b0.a1, ids.x.c1.b1.a0, ids.x.c1.b1.a1, ids.x.c1.b2.a0, ids.x.c1.b2.a1]
        y_refs=[ids.y.c0.b0.a0, ids.y.c0.b0.a1, ids.y.c0.b1.a0, ids.y.c0.b1.a1, ids.y.c0.b2.a0, ids.y.c0.b2.a1, ids.y.c1.b0.a0, ids.y.c1.b0.a1, ids.y.c1.b1.a0, ids.y.c1.b1.a1, ids.y.c1.b2.a0, ids.y.c1.b2.a1]
        for i in range(ids.N_LIMBS):
            for k in range(12):
                x_gnark[k]+=as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
                y_gnark[k]+=as_int(getattr(y_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i

        x=gnark_to_w(x_gnark)
        y=gnark_to_w(y_gnark)
        x_poly=Polynomial([BaseFieldElement(x[i], field) for i in range(12)])
        y_poly=Polynomial([BaseFieldElement(y[i], field) for i in range(12)])
        z_poly=x_poly*y_poly
        print(f"Z_Poly: {z_poly.get_coeffs()}")
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

        expected = flatten(mul_e12_gnark(pack_e12(x_gnark), pack_e12(y_gnark)))
        assert expected==w_to_gnark(z_polyr_coeffs)
        print(f"Z_PolyR: {z_polyr_coeffs}")
        print(f"Z_PolyR_to_gnark: {w_to_gnark(z_polyr_coeffs)}")
        for i in range(12):
            for k in range(3):
                rsetattr(ids.r_w, 'w'+str(i)+'.d'+str(k), split(z_polyr_coeffs[i]%p)[k])
        for i in range(11):
            for k in range(3):
                rsetattr(ids.q_w, 'w'+str(i)+'.d'+str(k), split(z_polyq_coeffs[i]%p)[k])
    %}
    let (local x_w: E12full*) = gnark_to_w(x);
    let (local y_w: E12full*) = gnark_to_w(y);
    // let (random_point_0) = poseidon_hash_many(n=12 * 3, elements=cast(x_w, felt*));
    // let (random_point_1) = poseidon_hash_many(n=12 * 3, elements=cast(y_w, felt*));
    // let (random_point_2) = poseidon_hash_many(n=12 * 3, elements=cast(&r_w, felt*));
    // let (random_point_3) = poseidon_hash_many(n=11 * 3, elements=cast(&q_w, felt*));
    let random_point_0 = poseidon_hash_e12(x_w);
    let random_point_1 = poseidon_hash_e12(y_w);
    let random_point_2 = poseidon_hash_e12(&r_w);
    let random_point_3 = poseidon_hash_e11(&q_w);
    // x(rnd) * y(rnd) === q(rnd) * P(rnd) + r(rnd)
    let random_point_I: felt = poseidon_hash(random_point_0, random_point_1);
    let random_point_II: felt = poseidon_hash(random_point_2, random_point_3);

    let random_point: felt = poseidon_hash(random_point_I, random_point_II);

    let (local rnd: BigInt3) = felt_to_bigint3(random_point);
    let z_pow1_11 = get_powers_of_z(&rnd);
    let x_of_rnd: BigInt3* = eval_E12(x_w, z_pow1_11);
    let y_of_rnd = eval_E12(y_w, z_pow1_11);
    let q_of_rnd = eval_E11(&q_w, z_pow1_11);
    let p_of_rnd = eval_unreduced_poly(z_pow1_11);
    let r_of_rnd = eval_E12_unreduced(&r_w, z_pow1_11);
    let (left) = bigint_mul([x_of_rnd], [y_of_rnd]);
    let (right) = bigint_mul([q_of_rnd], [p_of_rnd]);

    // Check x(rnd) * y(rnd) === q(rnd) * P(rnd) + r(rnd):

    verify_zero5(
        UnreducedBigInt5(
            d0=left.d0 - right.d0 - r_of_rnd.d0,
            d1=left.d1 - right.d1 - r_of_rnd.d1,
            d2=left.d2 - right.d2 - r_of_rnd.d2,
            d3=left.d3 - right.d3 - r_of_rnd.d3,
            d4=left.d4 - right.d4 - r_of_rnd.d4,
        ),
    );

    let res = w_to_gnark_reduced(r_w);
    %{ print_e12('res') %}
    return res;
}

func eval_unreduced_poly{range_check_ptr}(powers: BigInt3**) -> BigInt3* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
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
    let (__fp__, _) = get_fp_and_pc();
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
func felt_to_bigint3{range_check_ptr}(x: felt) -> (res: BigInt3) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (high, low) = split_felt(x);
    let (res) = uint256_to_bigint(Uint256(low, high));
    return (res,);
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
