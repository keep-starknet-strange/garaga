%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from src.towers.e12 import E12, e12
from src.towers.e6 import E6, e6
from src.towers.e2 import E2, e2

@external
func __setup__() {
    %{
        import subprocess
        import random
        import functools
        import re
        from starkware.cairo.common.cairo_secp.secp_utils import split

        P=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
        def rgetattr(obj, attr, *args):
            def _getattr(obj, attr):
                return getattr(obj, attr, *args)
            return functools.reduce(_getattr, [obj] + attr.split('.'))

        def rsetattr(obj, attr, val):
            pre, _, post = attr.rpartition('.')
            return setattr(rgetattr(obj, pre) if pre else obj, post, val)

        def fill_e6(e2:str, a0:int, a1:int, a2, a3, a4, a5):
            sa0 = split(a0)
            sa1 = split(a1)
            sa2 = split(a2)
            sa3 = split(a3)
            sa4 = split(a4)
            sa5 = split(a5)

            for i in range(3): rsetattr(ids,e2+'.b0.a0.d'+str(i),sa0[i])
            for i in range(3): rsetattr(ids,e2+'.b0.a1.d'+str(i),sa1[i])

            for i in range(3): rsetattr(ids,e2+'.b1.a0.d'+str(i),sa2[i])
            for i in range(3): rsetattr(ids,e2+'.b1.a1.d'+str(i),sa3[i])

            for i in range(3): rsetattr(ids,e2+'.b2.a0.d'+str(i),sa4[i])
            for i in range(3): rsetattr(ids,e2+'.b2.a1.d'+str(i),sa5[i])

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
func test_add{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E6;
    local y: E6;
    local z_gnark: E6;
    %{
        inputs=[random.randint(0, P-1) for i in range(12)]

        fill_e6('x', inputs[0], inputs[1], inputs[2], inputs[3], inputs[4], inputs[5])
        fill_e6('y', inputs[6], inputs[7], inputs[8], inputs[9], inputs[10], inputs[11])
        cmd = ['./tools/parser_go/main', 'e6', 'add'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        print('out', out)
        fp_elements = parse_fp_elements(out)

        print('fp_elements', fp_elements, len(fp_elements))
        fill_e6('z_gnark', fp_elements[0], fp_elements[1], fp_elements[2], 
                fp_elements[3], fp_elements[4], fp_elements[5])
    %}
    let res = e6.add(x, y);
    assert res.b0.a0 = z_gnark.b0.a0;
    assert res.b0.a1 = z_gnark.b0.a1;
    assert res.b1.a0 = z_gnark.b1.a0;
    assert res.b1.a1 = z_gnark.b1.a1;
    assert res.b2.a0 = z_gnark.b2.a0;
    assert res.b2.a1 = z_gnark.b2.a1;

    assert res = z_gnark;
    return ();
}
