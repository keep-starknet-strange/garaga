%builtins range_check
from starkware.cairo.common.registers import get_label_location
from src.bls12_381.g1 import G1Point, g1
from src.bls12_381.g2 import G2Point, g2, E4
from src.bls12_381.towers.e12 import E12, e12
from src.bls12_381.towers.e2 import E2, e2
from src.bls12_381.towers.e6 import E6, e6
from src.bls12_381.curve import CURVE, BASE, DEGREE, N_LIMBS, P0, P1, P2, P3
from src.bls12_381.fq import BigInt4, fq_bigint4
from starkware.cairo.common.registers import get_fp_and_pc
from src.bls12_381.pairing import get_loop_digit, final_exponentiation, miller_loop

func main{range_check_ptr} (){
    alloc_locals;
    %{
        import subprocess, random, functools, re
        import numpy as np
        CURVE_STR = bytes.fromhex(f'{ids.CURVE:x}').decode('ascii')
        MAIN_FILE = './tools/gnark/' + CURVE_STR + '/cairo_test/main'
        def get_p(n_limbs:int=ids.N_LIMBS):
            p=0
            for i in range(n_limbs):
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
            return p
        P=p=get_p()
        def split(x, degree=ids.DEGREE, base=ids.BASE):
            coeffs = []
            for n in range(degree, 0, -1):
                q, r = divmod(x, base ** n)
                coeffs.append(q)
                x = r
            coeffs.append(x)
            return coeffs[::-1]
        def rgetattr(obj, attr, *args):
            def _getattr(obj, attr):
                return getattr(obj, attr, *args)
            return functools.reduce(_getattr, [obj] + attr.split('.'))
        def rsetattr(obj, attr, val):
            pre, _, post = attr.rpartition('.')
            return setattr(rgetattr(obj, pre) if pre else obj, post, val)

        def fill_element(element:str, value:int):
            s = split(value)
            for i in range(ids.N_LIMBS): rsetattr(ids,element+'.d'+str(i),s[i])

        def print_e12(param):
            z0 = param.c0.b0.a0.d0 + param.c0.b0.a0.d1 * 2**96 + param.c0.b0.a0.d2 * 2**192 + param.c0.b0.a0.d3 * 2**288
            z1 = param.c0.b0.a1.d0 + param.c0.b0.a1.d1 * 2**96 + param.c0.b0.a1.d2 * 2**192 + param.c0.b0.a1.d3 * 2**288
            z2 = param.c0.b1.a0.d0 + param.c0.b1.a0.d1 * 2**96 + param.c0.b1.a0.d2 * 2**192 + param.c0.b1.a0.d3 * 2**288
            z3 = param.c0.b1.a1.d0 + param.c0.b1.a1.d1 * 2**96 + param.c0.b1.a1.d2 * 2**192 + param.c0.b1.a1.d3 * 2**288
            z4 = param.c0.b2.a0.d0 + param.c0.b2.a0.d1 * 2**96 + param.c0.b2.a0.d2 * 2**192 + param.c0.b2.a0.d3 * 2**288
            z5 = param.c0.b2.a1.d0 + param.c0.b2.a1.d1 * 2**96 + param.c0.b2.a1.d2 * 2**192 + param.c0.b2.a1.d3 * 2**288
            z6 = param.c1.b0.a0.d0 + param.c1.b0.a0.d1 * 2**96 + param.c1.b0.a0.d2 * 2**192 + param.c1.b0.a0.d3 * 2**288
            z7 = param.c1.b0.a1.d0 + param.c1.b0.a1.d1 * 2**96 + param.c1.b0.a1.d2 * 2**192 + param.c1.b0.a1.d3 * 2**288
            z8 = param.c1.b1.a0.d0 + param.c1.b1.a0.d1 * 2**96 + param.c1.b1.a0.d2 * 2**192 + param.c1.b1.a0.d3 * 2**288
            z9 = param.c1.b1.a1.d0 + param.c1.b1.a1.d1 * 2**96 + param.c1.b1.a1.d2 * 2**192 + param.c1.b1.a1.d3 * 2**288
            z10 = param.c1.b2.a0.d0 + param.c1.b2.a0.d1 * 2**96 + param.c1.b2.a0.d2 * 2**192 + param.c1.b2.a0.d3 * 2**288
            z11 = param.c1.b2.a1.d0 + param.c1.b2.a1.d1 * 2**96 + param.c1.b2.a1.d2 * 2**192 + param.c1.b2.a1.d3 * 2**288
           
            res = [z0,z1,z2,z3,z4,z5,z6,z7,z8,z9,z10,z11]

            for i in range(12):
                print(f"z{i} = {np.base_repr(res[i],16)}")

        
    %}
    let (__fp__, _) = get_fp_and_pc();
    local g2x0: BigInt4;
    local g2x1: BigInt4;
    local g2y0: BigInt4;
    local g2y1: BigInt4;

    local g1x: BigInt4;
    local g1y: BigInt4;

    %{
        for var_name in list(program_input.keys()):
            if type(program_input[var_name]) == str : continue
            fill_element(var_name, program_input[var_name])
    %}

    // Construct G1
    local pg1: G1Point = G1Point(&g1x, &g1y);
    g1.assert_on_curve(pg1);
    
    // Construct G2
    local g2_x: E2 = E2(&g2x0, &g2x1);
    local g2_y: E2 = E2(&g2y0, &g2y1);
    local pg2: G2Point = G2Point(&g2_x, &g2_y);
    g2.assert_on_curve(pg2);
   
    let pg1_neg = g1.neg(&pg1);

    let c1 = miller_loop(&pg1, &pg2);
    let c2 = miller_loop(pg1_neg, &pg2);

    %{
        print("e(G1, G2)")
        print_e12(ids.c1)

        print("e(-G1, G2)")
        print_e12(ids.c2)

    %}

    let m = e12.mul(c1, c2);
    let res = final_exponentiation(m);
    let one = e12.one();

    e12.assert_E12(res, one);

    %{ print(f"Mock Pairing Verified!") %}
    return ();
}
