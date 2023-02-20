%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from src.bn254.towers.e12 import E12, e12
from src.bn254.towers.e6 import E6, e6
from src.bn254.towers.e2 import E2, e2

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

        def fill_e12(e2:str, *args):
            structs = ['c0.b0.a0','c0.b0.a1','c0.b1.a0','c0.b1.a1','c0.b2.a0','c0.b2.a1',
            'c1.b0.a0','c1.b0.a1','c1.b1.a0','c1.b1.a1','c1.b2.a0','c1.b2.a1']
            for i, s in enumerate(structs):
                splitted = split(args[i])
                for j in range(3):
                    rsetattr(ids,e2+'.'+s+'.d'+str(j),splitted[j])
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

    local x: E12;
    local y: E12;
    local z_gnark: E12;
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])
        fill_e12('y', *inputs[12:24])

        cmd = ['./tools/parser_go/main', 'e12', 'add'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z_gnark', *fp_elements)
    %}
    let res = e12.add(x, y);
    assert res = z_gnark;
    return ();
}
@external
func test_sub{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E12;
    local y: E12;
    local z_gnark: E12;
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])
        fill_e12('y', *inputs[12:24])

        cmd = ['./tools/parser_go/main', 'e12', 'sub'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z_gnark', *fp_elements)
    %}
    let res = e12.sub(x, y);

    assert res = z_gnark;
    return ();
}
@external
func test_mul{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E12;
    local y: E12;
    local z_gnark: E12;
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])
        fill_e12('y', *inputs[12:24])

        cmd = ['./tools/parser_go/main', 'e12', 'mul'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z_gnark', *fp_elements)
    %}
    let res = e12.mul(x, y);

    assert res = z_gnark;
    return ();
}
@external
func test_double{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E12;
    local z_gnark: E12;
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = ['./tools/parser_go/main', 'e12', 'double'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z_gnark', *fp_elements)
    %}
    let res = e12.double(x);

    assert res = z_gnark;
    return ();
}

@external
func test_square{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E12;
    local z_gnark: E12;
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = ['./tools/parser_go/main', 'e12', 'square'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z_gnark', *fp_elements)
    %}
    let res = e12.square(x);

    assert res = z_gnark;
    return ();
}

@external
func test_inv{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E12;
    local z_gnark: E12;
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = ['./tools/parser_go/main', 'e12', 'inv'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z_gnark', *fp_elements)
    %}
    let res = e12.inverse(x);

    assert res = z_gnark;
    return ();
}

@external
func test_conjugate{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E12;
    local z_gnark: E12;
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = ['./tools/parser_go/main', 'e12', 'conjugate'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z_gnark', *fp_elements)
    %}
    let res = e12.conjugate(x);

    assert res = z_gnark;
    return ();
}

@external
func test_cyclotomic_square{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E12;
    local z_gnark: E12;
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = ['./tools/parser_go/main', 'e12', 'cyclotomic_square'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z_gnark', *fp_elements)
    %}
    let res = e12.cyclotomic_square(x);

    assert res = z_gnark;
    return ();
}

@external
func test_expt{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E12;
    local z_gnark: E12;
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = ['./tools/parser_go/main', 'e12', 'expt'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z_gnark', *fp_elements)
    %}
    let res = e12.expt(x);

    assert res = z_gnark;
    return ();
}

@external
func test_frobenius_square{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E12;
    local z_gnark: E12;
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = ['./tools/parser_go/main', 'e12', 'frobenius_square'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z_gnark', *fp_elements)
    %}
    let res = e12.frobenius_square(x);

    assert res = z_gnark;
    return ();
}

@external
func test_frobenius_cube{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E12;
    local z_gnark: E12;
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = ['./tools/parser_go/main', 'e12', 'frobenius_cube'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z_gnark', *fp_elements)
    %}
    let res = e12.frobenius_cube(x);

    assert res = z_gnark;
    return ();
}

@external
func test_frobenius{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();

    local x: E12;
    local z_gnark: E12;
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = ['./tools/parser_go/main', 'e12', 'frobenius'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z_gnark', *fp_elements)
    %}
    let res = e12.frobenius(x);

    assert res = z_gnark;
    return ();
}
