%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from src.bls12_381.towers.e2 import E2, e2
from src.bls12_381.fq import BigInt4

const CURVE = 'bls12_381';

@external
func __setup__() {
    %{
        import subprocess
        import random
        import functools
        import re
        from starkware.cairo.common.cairo_secp.secp_utils import split

        P= 0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab
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
        b96=2**96
        def split4(x):
            q3 = x//b96**3
            r = x % b96**3
            q2 = r//b96**2
            r = r % b96**2
            q1 = r//b96
            r = r % b96
            q0 = r
            print(f'q0={q0}, q1={q1}, q2={q2}, q3={q3}')
            return (q0,q1,q2,q3)
        def fill_element(element:str, value:int):
            s = split4(value)
            for i in range(4): rsetattr(ids,element+'.d'+str(i),s[i])
        def print_element(element, name):
            print(f'{name}: {rgetattr(ids,element+".d0")} {rgetattr(ids,element+".d1")} {rgetattr(ids,element+".d2")} {rgetattr(ids,element+".d3")}')
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
func test_add_0{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();
    local xa0: BigInt4;
    local xa1: BigInt4;
    local ya0: BigInt4;
    local ya1: BigInt4;
    tempvar x: E2* = new E2(&xa0, &xa1);
    tempvar y: E2* = new E2(&ya0, &ya1);
    local z_gnark_a0: BigInt4;
    local z_gnark_a1: BigInt4;
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]
        fill_element('xa0', 3)
        fill_element('xa1', 6)
        fill_element('ya0', 1)
        fill_element('ya1', 2)

        curve_str = bytes.fromhex(f'{ids.CURVE:x}').decode('ascii')
        cmd_line = './tools/parser_go/' + curve_str + '/cairo_test/main'
        cmd = [cmd_line, 'e2', 'add'] + ["3","6", "1", "2"]
        print(f"cmd: {cmd}")
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 2
        fill_element('z_gnark_a0', fp_elements[0]) 
        fill_element('z_gnark_a1', fp_elements[1])
    %}
    let res = e2.add(x, y);
    e2.assert_E2(res, z_gnark);
    return ();
}

@external
func test_add{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local xa0: BigInt4;
    local xa1: BigInt4;
    local ya0: BigInt4;
    local ya1: BigInt4;
    tempvar x: E2* = new E2(&xa0, &xa1);
    tempvar y: E2* = new E2(&ya0, &ya1);
    local z_gnark_a0: BigInt4;
    local z_gnark_a1: BigInt4;
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);
    %{
        from starkware.cairo.common.cairo_secp.secp_utils import split
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])
        fill_element('ya0', inputs[2])
        fill_element('ya1', inputs[3])

        curve_str = bytes.fromhex(f'{ids.CURVE:x}').decode('ascii')
        cmd_line = './tools/parser_go/' + curve_str + '/cairo_test/main'
        cmd = [cmd_line, 'e2', 'add'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 2
        fill_element('z_gnark_a0', fp_elements[0]) 
        fill_element('z_gnark_a1', fp_elements[1])
    %}
    let res = e2.add(x, y);
    e2.assert_E2(res, z_gnark);
    return ();
}

@external
func test_sub{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local xa0: BigInt4;
    local xa1: BigInt4;
    local ya0: BigInt4;
    local ya1: BigInt4;
    tempvar x: E2* = new E2(&xa0, &xa1);
    tempvar y: E2* = new E2(&ya0, &ya1);
    local z_gnark_a0: BigInt4;
    local z_gnark_a1: BigInt4;
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);
    %{
        from starkware.cairo.common.cairo_secp.secp_utils import split
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])
        fill_element('ya0', inputs[2])
        fill_element('ya1', inputs[3])

        curve_str = bytes.fromhex(f'{ids.CURVE:x}').decode('ascii')
        cmd_line = './tools/parser_go/' + curve_str + '/cairo_test/main'
        cmd = [cmd_line, 'e2', 'sub'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 2
        fill_element('z_gnark_a0', fp_elements[0]) 
        fill_element('z_gnark_a1', fp_elements[1])
    %}
    let res = e2.sub(x, y);
    e2.assert_E2(res, z_gnark);
    return ();
}

@external
func test_mul{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local xa0: BigInt4;
    local xa1: BigInt4;
    local ya0: BigInt4;
    local ya1: BigInt4;
    tempvar x: E2* = new E2(&xa0, &xa1);
    tempvar y: E2* = new E2(&ya0, &ya1);
    local z_gnark_a0: BigInt4;
    local z_gnark_a1: BigInt4;
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])
        fill_element('ya0', inputs[2])
        fill_element('ya1', inputs[3])

        curve_str = bytes.fromhex(f'{ids.CURVE:x}').decode('ascii')
        cmd_line = './tools/parser_go/' + curve_str + '/cairo_test/main'

        cmd = [cmd_line, 'e2', 'mul'] + [str(x) for x in inputs]
        print(f"cmd: {cmd}")

        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')

        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 2
        print(f"fp_elements: {fp_elements}")
        fill_element('z_gnark_a0', fp_elements[0]) 
        fill_element('z_gnark_a1', fp_elements[1])
    %}
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);

    let res = e2.mul(x, y);
    e2.assert_E2(res, z_gnark);

    return ();
}

@external
func test_neg{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();
    local xa0: BigInt4;
    local xa1: BigInt4;
    tempvar x: E2* = new E2(&xa0, &xa1);
    local z_gnark_a0: BigInt4;
    local z_gnark_a1: BigInt4;
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])

        curve_str = bytes.fromhex(f'{ids.CURVE:x}').decode('ascii')
        cmd_line = './tools/parser_go/' + curve_str + '/cairo_test/main'
        cmd = [cmd_line, 'e2', 'neg'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 2
        fill_element('z_gnark_a0', fp_elements[0]) 
        fill_element('z_gnark_a1', fp_elements[1])
    %}
    let res = e2.neg(x);
    e2.assert_E2(res, z_gnark);
    return ();
}

@external
func test_conjugate{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local xa0: BigInt4;
    local xa1: BigInt4;
    tempvar x: E2* = new E2(&xa0, &xa1);
    local z_gnark_a0: BigInt4;
    local z_gnark_a1: BigInt4;
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])

        curve_str = bytes.fromhex(f'{ids.CURVE:x}').decode('ascii')
        cmd_line = './tools/parser_go/' + curve_str + '/cairo_test/main'
        cmd = [cmd_line, 'e2', 'conjugate'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 2
        fill_element('z_gnark_a0', fp_elements[0]) 
        fill_element('z_gnark_a1', fp_elements[1])
    %}
    let res = e2.conjugate(x);
    e2.assert_E2(res, z_gnark);
    return ();
}
