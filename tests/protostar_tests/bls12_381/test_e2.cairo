%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from src.bls12_381.towers.e2 import E2, e2
from src.bls12_381.fq import BigInt4
from src.bls12_381.curve import CURVE, BASE, DEGREE, N_LIMBS, P0, P1, P2, P3

@external
func __setup__() {
    %{
        import subprocess
        import random
        import functools
        import re
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
        def print_element(element, name):
            print(f'{name}: {rgetattr(ids,element+".d0")} {rgetattr(ids,element+".d1")} {rgetattr(ids,element+".d2")} {rgetattr(ids,element+".d3")}')
        def parse_fp_elements(input_string:str):
            pattern = re.compile(r'\[([^\[\]]+)\]')
            substrings = pattern.findall(input_string)
            sublists = [substring.split(' ') for substring in substrings]
            sublists = [[int(x) for x in sublist] for sublist in sublists]
            fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 + x[4] * 2**256 + x[5] * 2**320 for x in sublists]
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


        cmd = [MAIN_FILE, 'e2', 'add'] + ["3","6", "1", "2"]
        print(f"cmd: {cmd}")
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        print(out, fp_elements)
        assert len(fp_elements) == 2
        print(f"should be {split(fp_elements[0])} {split(fp_elements[1])}")
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
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])
        fill_element('ya0', inputs[2])
        fill_element('ya1', inputs[3])

        curve_str = bytes.fromhex(f'{ids.CURVE:x}').decode('ascii')
        cmd_line = './tools/gnark/' + curve_str + '/cairo_test/main'
        cmd = [cmd_line, 'e2', 'add'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 2
        print(f"should be {split(fp_elements[0])} {split(fp_elements[1])}")
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
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])
        fill_element('ya0', inputs[2])
        fill_element('ya1', inputs[3])

        curve_str = bytes.fromhex(f'{ids.CURVE:x}').decode('ascii')
        cmd_line = './tools/gnark/' + curve_str + '/cairo_test/main'
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
        cmd_line = './tools/gnark/' + curve_str + '/cairo_test/main'

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
        cmd_line = './tools/gnark/' + curve_str + '/cairo_test/main'
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
func test_inv{
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
        cmd_line = './tools/gnark/' + curve_str + '/cairo_test/main'
        cmd = [cmd_line, 'e2', 'inv'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 2
        fill_element('z_gnark_a0', fp_elements[0]) 
        fill_element('z_gnark_a1', fp_elements[1])
    %}
    let res = e2.inv(x);
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
        cmd_line = './tools/gnark/' + curve_str + '/cairo_test/main'
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
