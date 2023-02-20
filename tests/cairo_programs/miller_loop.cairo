%builtins range_check

from src.bn254.towers.e12 import E12, e12
from src.bn254.towers.e6 import E6, e6
from src.bn254.towers.e2 import E2, e2
from src.bn254.g1 import G1Point, g1
from src.bn254.g2 import G2Point, g2
from src.bn254.pairing import pair, miller_loop

func main{range_check_ptr}() {
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
            structs = ['c0.b0.a0','c0.b0.a1','c0.b1.a0','c0.b1.a1','c0.b2.a0','c0.b2.a1',
            'c1.b0.a0','c1.b0.a1','c1.b1.a0','c1.b1.a1','c1.b2.a0','c1.b2.a1']
            for i, s in enumerate(structs):
                splitted = split(args[i])
                for j in range(3):
                    rsetattr(ids,e2+'.'+s+'.d'+str(j),splitted[j])
        def parse_fp_elements(input_string:str):
            pattern = re.compile(r'\[([^\[\]]+)\]')
            substrings = pattern.findall(input_string)
            sublists = [substring.split(' ') for substring in substrings]
            sublists = [[int(x) for x in sublist] for sublist in sublists]
            fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 for x in sublists]
            return fp_elements
    %}
    local x: G1Point;
    local y: G2Point;
    local z_gnark: E12;
    %{
        cmd = ['./tools/parser_go/main', 'nG1nG2', '1', '1']
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        print(fp_elements, len(fp_elements))
        assert len(fp_elements) == 6

        fill_g1_point('x', fp_elements[0], fp_elements[1])
        fill_g2_point('y', fp_elements[2], fp_elements[3], fp_elements[4], fp_elements[5])

        cmd = ['./tools/parser_go/main', 'pair'] + [str(x) for x in fp_elements]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        print(out)
        fp_elements_2 = parse_fp_elements(out)
        print(fp_elements_2, len(fp_elements_2))
        assert len(fp_elements_2) == 12

        fill_e12('z_gnark', *fp_elements_2)
    %}
    g1.assert_on_curve(x);
    g2.assert_on_curve(y);
    let res = miller_loop(x, y);
    return ();
}
