%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from src.towers.e2 import e2, E2

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

        def fill_e2(e2:str, a0:int, a1:int):
            sa0 = split(a0)
            sa1 = split(a1)
            for i in range(3): rsetattr(ids,e2+'.a0.d'+str(i),sa0[i])
            for i in range(3): rsetattr(ids,e2+'.a1.d'+str(i),sa1[i])
        def parse_fp_elements(input_string:str):
            pattern = re.compile(r'\[([^\[\]]+)\]')
            substrings = pattern.findall(input_string)
            sublists = [substring.split(' ') for substring in substrings]
            print(sublists)
            sublists = [[int(x) for x in sublist] for sublist in sublists]
            fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 for x in sublists]
            return fp_elements
    %}
    return ();
}

@external
func test_add_0{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E2;
    local y: E2;
    local z_gnark: E2;
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]


        fill_e2('x', 3, 6)
        fill_e2('y', 1, 2)

        cmd = ['./tools/parser_go/main', 'e2', 'add'] + ["3","6", "1", "2"]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        print('out', out)
        fp_elements = parse_fp_elements(out)

        print('fp_elements', fp_elements)
        fill_e2('z_gnark', fp_elements[0], fp_elements[1])
    %}
    let res = e2.add(x, y);
    assert res.a0.d0 = z_gnark.a0.d0;
    assert res.a0.d1 = z_gnark.a0.d1;
    assert res.a0.d2 = z_gnark.a0.d2;
    assert res.a1.d0 = z_gnark.a1.d0;
    assert res.a1.d1 = z_gnark.a1.d1;
    assert res.a1.d2 = z_gnark.a1.d2;

    return ();
}

@external
func test_add{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E2;
    local y: E2;
    local z_gnark: E2;
    %{
        from starkware.cairo.common.cairo_secp.secp_utils import split
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_e2('x', inputs[0], inputs[1])
        fill_e2('y', inputs[2], inputs[3])

        cmd = ['./tools/parser_go/main', 'e2', 'add'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        print('out', out)
        fp_elements = parse_fp_elements(out)

        print('fp_elements', fp_elements)
        fill_e2('z_gnark', fp_elements[0], fp_elements[1])
    %}
    let res = e2.add(x, y);
    assert res.a0.d0 = z_gnark.a0.d0;
    assert res.a0.d1 = z_gnark.a0.d1;
    assert res.a0.d2 = z_gnark.a0.d2;
    assert res.a1.d0 = z_gnark.a1.d0;
    assert res.a1.d1 = z_gnark.a1.d1;
    assert res.a1.d2 = z_gnark.a1.d2;
    return ();
}

@external
func test_sub{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E2;
    local y: E2;
    local z_gnark: E2;
    %{
        from starkware.cairo.common.cairo_secp.secp_utils import split
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_e2('x', inputs[0], inputs[1])
        fill_e2('y', inputs[2], inputs[3])

        cmd = ['./tools/parser_go/main', 'e2', 'sub'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        print('out', out)
        fp_elements = parse_fp_elements(out)

        print('fp_elements', fp_elements)
        fill_e2('z_gnark', fp_elements[0], fp_elements[1])
    %}
    let res = e2.sub(x, y);
    assert res.a0.d0 = z_gnark.a0.d0;
    assert res.a0.d1 = z_gnark.a0.d1;
    assert res.a0.d2 = z_gnark.a0.d2;
    assert res.a1.d0 = z_gnark.a1.d0;
    assert res.a1.d1 = z_gnark.a1.d1;
    assert res.a1.d2 = z_gnark.a1.d2;
    return ();
}

@external
func test_mul{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E2;
    local y: E2;
    local z_gnark: E2;
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_e2('x', inputs[0], inputs[1])
        fill_e2('y', inputs[2], inputs[3])

        cmd = ['./tools/parser_go/main', 'e2', 'mul'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        print('out', out)
        fp_elements = parse_fp_elements(out)

        print('fp_elements', fp_elements)
        fill_e2('z_gnark', fp_elements[0], fp_elements[1])
    %}
    let res = e2.mul(x, y);
    assert res = z_gnark;
    return ();
}

@external
func test_neg{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E2;
    local z_gnark: E2;
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_e2('x', inputs[0], inputs[1])

        cmd = ['./tools/parser_go/main', 'e2', 'neg'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        print('out', out)
        fp_elements = parse_fp_elements(out)

        print('fp_elements', fp_elements)
        fill_e2('z_gnark', fp_elements[0], fp_elements[1])
    %}
    let res = e2.neg(x);
    assert res = z_gnark;
    return ();
}
