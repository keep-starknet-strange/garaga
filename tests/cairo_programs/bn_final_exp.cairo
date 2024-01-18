%builtins range_check bitwise poseidon

from src.bn254.towers.e12 import E12, e12, w_to_gnark_reduced
from src.bn254.towers.e6 import E6, e6
from src.bn254.towers.e2 import E2, e2
from src.bn254.fq import BigInt3
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, BitwiseBuiltin
from src.bn254.curve import N_LIMBS, DEGREE, BASE, P0, P1, P2

// from src.bn254.g1 import G1Point, g1
// from src.bn254.g2 import G2Point, g2
from src.bn254.pairing import final_exponentiation

func main{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, poseidon_ptr: PoseidonBuiltin*}() {
    alloc_locals;
    %{
        import subprocess
        import random
        import functools
        import re
        from starkware.cairo.common.cairo_secp.secp_utils import split

        P=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
        BN254_ORDER = 21888242871839275222246405745257275088548364400416034343698204186575808495617
        def rgetattr(obj, attr, *args):
            def _getattr(obj, attr):
                return getattr(obj, attr, *args)
            return functools.reduce(_getattr, [obj] + attr.split('.'))

        def rsetattr(obj, attr, val):
            pre, _, post = attr.rpartition('.')
            return setattr(rgetattr(obj, pre) if pre else obj, post, val)

        def fill_g1_point(g1:str, a0:int, a1:int):
            sa0 = split(a0)
            sa1 = split(a1)
            for i in range(3): rsetattr(ids,g1+'.x.d'+str(i),sa0[i])
            for i in range(3): rsetattr(ids,g1+'.y.d'+str(i),sa1[i])
        def fill_g2_point(g2:str, a0:int, a1:int, a2, a3):
            sa0 = split(a0)
            sa1 = split(a1)
            sa2 = split(a2)
            sa3 = split(a3)

            for i in range(3): rsetattr(ids,g2+'.x.a0.d'+str(i),sa0[i])
            for i in range(3): rsetattr(ids,g2+'.x.a1.d'+str(i),sa1[i])
            for i in range(3): rsetattr(ids,g2+'.y.a0.d'+str(i),sa2[i])
            for i in range(3): rsetattr(ids,g2+'.y.a1.d'+str(i),sa3[i])
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
        cmd = ['./tools/gnark/main', 'nG1nG2', '1', '1']
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements_0 = parse_fp_elements(out)
        assert len(fp_elements_0) == 6

        cmd = ['./tools/gnark/main', 'pair', 'miller_loop'] + [str(x) for x in fp_elements_0]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 12
        fill_e12('x', *fp_elements)
        #print(f"x: {fp_elements}")

        cmd = ['./tools/gnark/main', 'pair', 'pair'] + [str(x) for x in fp_elements_0]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 12
        fill_e12('z', *fp_elements)
        #print(f"z: {fp_elements}")
        n_squares_torus=0
    %}
    // tempvar x = new E12(
    //     new E6(new E2(x0, x1), new E2(x2, x3), new E2(x4, x5)),
    //     new E6(new E2(x6, x7), new E2(x8, x9), new E2(x10, x11)),
    // );
    local xc0b0: E2 = E2(x0, x1);
    local xc0b1: E2 = E2(x2, x3);
    local xc0b2: E2 = E2(x4, x5);
    local xc1b0: E2 = E2(x6, x7);
    local xc1b1: E2 = E2(x8, x9);
    local xc1b2: E2 = E2(x10, x11);
    local xc0: E6 = E6(&xc0b0, &xc0b1, &xc0b2);
    local xc1: E6 = E6(&xc1b0, &xc1b1, &xc1b2);
    local x: E12 = E12(&xc0, &xc1);

    local zc0b0: E2 = E2(z0, z1);
    local zc0b1: E2 = E2(z2, z3);
    local zc0b2: E2 = E2(z4, z5);
    local zc1b0: E2 = E2(z6, z7);
    local zc1b1: E2 = E2(z8, z9);
    local zc1b2: E2 = E2(z10, z11);
    local zc0: E6 = E6(&zc0b0, &zc0b1, &zc0b2);
    local zc1: E6 = E6(&zc1b0, &zc1b1, &zc1b2);
    local z: E12 = E12(&zc0, &zc1);


    // local t: E2 = E2(x0, x1);
    // tempvar tp = &t;
    // %{
    //     print(memory[ids.x.c0.b0._reference_value])
    //     print(memory[ids.x.c0.b0._reference_value+1])
    //     print(memory[ids.x.c0.b0._reference_value+2])
    //     print(ids.x0.d0)
    //     print(ids.x0.d1)
    //     print(ids.x0.d2)
    //     print(ids.x1.d0)
    //     print("t")
    //     print(ids.t.a0.d0)
    //     print(ids.t.a0.d1)
    //     print(ids.t.a0.d2)
    //     print(ids.t.a1.d0)
    // %}

    tempvar ppp = 0;
    let res = final_exponentiation(&x, 1);
    %{
        from starkware.cairo.common.math_utils import as_int
        from tools.py.extension_trick import inv_e12, mul_e12, pack_e12, flatten, w_to_gnark, gnark_to_w
        def pack_e12full(ref):
            x = 12*[0]
            for i in range(ids.N_LIMBS):
                for k in range(12):
                    x[k]+=as_int(getattr(getattr(ref, f'w{k}'), f'd{i}'), PRIME) * ids.BASE**i
            return x
        print("res_gnark", fp_elements)
        print("res_gnarkf", gnark_to_w(fp_elements))
        res=pack_e12full(ids.res)
        print(f"res_full: {res}")
        print(f"res_full2gnark", w_to_gnark(res))
    %}
    let res_tower = w_to_gnark_reduced([res]);
    e12.assert_E12(res_tower, &z);
    %{ print(f"n_square_torus : {n_squares_torus}") %}

    return ();
}
