%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from src.towers.e12 import E12, e12
from src.towers.e6 import E6, e6
from src.towers.e2 import E2, e2
from src.g1 import G1Point, g1_weierstrass_arithmetics
from src.g2 import G2Point, g2_weierstrass_arithmetics
from src.pair import pairing
@external
func __setup__() {
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

            return None
        def fill_g2_point(g2:str, a0:int, a1:int, a2, a3):
            sa0 = split(a0)
            sa1 = split(a1)
            sa2 = split(a2)
            sa3 = split(a3)


            for i in range(3): rsetattr(ids,g2+'.x.a0.d'+str(i),sa0[i])
            for i in range(3): rsetattr(ids,g2+'.x.a1.d'+str(i),sa1[i])
            for i in range(3): rsetattr(ids,g2+'.y.a0.d'+str(i),sa2[i])
            for i in range(3): rsetattr(ids,g2+'.y.a1.d'+str(i),sa3[i])
            

            return None
        def fill_e12(e2:str, a0:int, a1:int, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11):
            sa0 = split(a0)
            sa1 = split(a1)
            sa2 = split(a2)
            sa3 = split(a3)
            sa4 = split(a4)
            sa5 = split(a5)
            sa6 = split(a6)
            sa7 = split(a7)
            sa8 = split(a8)
            sa9 = split(a9)
            sa10 = split(a10)
            sa11 = split(a11)

            for i in range(3): rsetattr(ids,e2+'.c0.b0.a0.d'+str(i),sa0[i])
            for i in range(3): rsetattr(ids,e2+'.c0.b0.a1.d'+str(i),sa1[i])
            for i in range(3): rsetattr(ids,e2+'.c0.b1.a0.d'+str(i),sa2[i])
            for i in range(3): rsetattr(ids,e2+'.c0.b1.a1.d'+str(i),sa3[i])
            for i in range(3): rsetattr(ids,e2+'.c0.b2.a0.d'+str(i),sa4[i])
            for i in range(3): rsetattr(ids,e2+'.c0.b2.a1.d'+str(i),sa5[i])
            
            for i in range(3): rsetattr(ids,e2+'.c1.b0.a0.d'+str(i),sa6[i]) 
            for i in range(3): rsetattr(ids,e2+'.c1.b0.a1.d'+str(i),sa7[i])
            for i in range(3): rsetattr(ids,e2+'.c1.b1.a0.d'+str(i),sa8[i])
            for i in range(3): rsetattr(ids,e2+'.c1.b1.a1.d'+str(i),sa9[i])
            for i in range(3): rsetattr(ids,e2+'.c1.b2.a0.d'+str(i),sa10[i])
            for i in range(3): rsetattr(ids,e2+'.c1.b2.a1.d'+str(i),sa11[i])
            return None
        def parse_fp_elements(input_string:str):
            pattern = re.compile(r'\[([^\[\]]+)\]')
            substrings = pattern.findall(input_string)
            sublists = [substring.split(' ') for substring in substrings]
            sublists = [[int(x) for x in sublist] for sublist in sublists]
            fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 for x in sublists]
            return fp_elements
    %}
    return ();
}

@external
func test_pair_gen{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: G1Point;
    local y: G2Point;
    local z_gnark: E12;
    %{
        cmd = ['./tools/parser_go/main', 'nG1nG2', '1', '1']
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        print(fp_elements, len(fp_elements))
        # assert len(fp_elements) == 6

        fill_g1_point('x', fp_elements[0], fp_elements[1])
        fill_g2_point('y', fp_elements[2], fp_elements[3], fp_elements[4], fp_elements[5])

        cmd = ['./tools/parser_go/main', 'pair'] + [str(x) for x in fp_elements]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        print(fp_elements, len(fp_elements))
        assert len(fp_elements) == 12

        fill_e12('z_gnark', fp_elements[0], fp_elements[1], fp_elements[2], fp_elements[3], fp_elements[4], fp_elements[5], fp_elements[6], fp_elements[7], fp_elements[8], fp_elements[9], fp_elements[10], fp_elements[11])
    %}
    g1_weierstrass_arithmetics.assert_on_curve(x);
    g2_weierstrass_arithmetics.assert_on_curve(y);
    let res = pairing(y, x);

    assert res = z_gnark;
    return ();
}

@external
func test_pair_random{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: G1Point;
    local y: G2Point;
    local z_gnark: E12;
    %{
        inputs=[random.randint(0, BN254_ORDER) for i in range(2)]
        cmd = ['./tools/parser_go/main', 'nG1nG2']+[str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        print(fp_elements, len(fp_elements))
        # assert len(fp_elements) == 6

        fill_g1_point('x', fp_elements[0], fp_elements[1])
        fill_g2_point('y', fp_elements[2], fp_elements[3], fp_elements[4], fp_elements[5])

        cmd = ['./tools/parser_go/main', 'pair'] + [str(x) for x in fp_elements]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        print(fp_elements, len(fp_elements))
        assert len(fp_elements) == 12

        fill_e12('z_gnark', fp_elements[0], fp_elements[1], fp_elements[2], fp_elements[3], fp_elements[4], fp_elements[5], fp_elements[6], fp_elements[7], fp_elements[8], fp_elements[9], fp_elements[10], fp_elements[11])
    %}
    g1_weierstrass_arithmetics.assert_on_curve(x);
    g2_weierstrass_arithmetics.assert_on_curve(y);
    let res = pairing(y, x);

    // assert res = z_gnark;
    return ();
}
