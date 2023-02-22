%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from src.bn254.towers.e2 import E2, e2
from src.bn254.fq import BigInt3

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
        def fill_element(element:str, value:int):
            s = split(value)
            for i in range(3): rsetattr(ids,element+'.d'+str(i),s[i])
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
    local xa0: BigInt3;
    local xa1: BigInt3;
    local ya0: BigInt3;
    local ya1: BigInt3;
    tempvar x: E2* = new E2(&xa0, &xa1);
    tempvar y: E2* = new E2(&ya0, &ya1);
    local z_gnark_a0: BigInt3;
    local z_gnark_a1: BigInt3;
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]
        fill_element('xa0', 3)
        fill_element('xa1', 6)
        fill_element('ya0', 1)
        fill_element('ya1', 2)

        cmd = ['./tools/parser_go/main', 'e2', 'add'] + ["3","6", "1", "2"]
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

    local xa0: BigInt3;
    local xa1: BigInt3;
    local ya0: BigInt3;
    local ya1: BigInt3;
    tempvar x: E2* = new E2(&xa0, &xa1);
    tempvar y: E2* = new E2(&ya0, &ya1);
    local z_gnark_a0: BigInt3;
    local z_gnark_a1: BigInt3;
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);
    %{
        from starkware.cairo.common.cairo_secp.secp_utils import split
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])
        fill_element('ya0', inputs[2])
        fill_element('ya1', inputs[3])

        cmd = ['./tools/parser_go/main', 'e2', 'add'] + [str(x) for x in inputs]
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

    local xa0: BigInt3;
    local xa1: BigInt3;
    local ya0: BigInt3;
    local ya1: BigInt3;
    tempvar x: E2* = new E2(&xa0, &xa1);
    tempvar y: E2* = new E2(&ya0, &ya1);
    local z_gnark_a0: BigInt3;
    local z_gnark_a1: BigInt3;
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);
    %{
        from starkware.cairo.common.cairo_secp.secp_utils import split
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])
        fill_element('ya0', inputs[2])
        fill_element('ya1', inputs[3])

        cmd = ['./tools/parser_go/main', 'e2', 'sub'] + [str(x) for x in inputs]
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

    local xa0: BigInt3;
    local xa1: BigInt3;
    local ya0: BigInt3;
    local ya1: BigInt3;
    tempvar x: E2* = new E2(&xa0, &xa1);
    tempvar y: E2* = new E2(&ya0, &ya1);
    local z_gnark_a0: BigInt3;
    local z_gnark_a1: BigInt3;
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])
        fill_element('ya0', inputs[2])
        fill_element('ya1', inputs[3])

        cmd = ['./tools/parser_go/main', 'e2', 'mul'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')

        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 2

        fill_element('z_gnark_a0', fp_elements[0]) 
        fill_element('z_gnark_a1', fp_elements[1])
    %}
    let res: E2* = e2.mul(x, y);
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
    local xa0: BigInt3;
    local xa1: BigInt3;
    tempvar x: E2* = new E2(&xa0, &xa1);
    local z_gnark_a0: BigInt3;
    local z_gnark_a1: BigInt3;
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])

        cmd = ['./tools/parser_go/main', 'e2', 'neg'] + [str(x) for x in inputs]
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

    local xa0: BigInt3;
    local xa1: BigInt3;
    tempvar x: E2* = new E2(&xa0, &xa1);
    local z_gnark_a0: BigInt3;
    local z_gnark_a1: BigInt3;
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])

        cmd = ['./tools/parser_go/main', 'e2', 'conjugate'] + [str(x) for x in inputs]
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

@external
func test_mulbnr1p1{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local xa0: BigInt3;
    local xa1: BigInt3;
    tempvar x: E2* = new E2(&xa0, &xa1);
    local z_gnark_a0: BigInt3;
    local z_gnark_a1: BigInt3;
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])

        cmd = ['./tools/parser_go/main', 'e2', 'mulbnr1p1'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 2
        fill_element('z_gnark_a0', fp_elements[0]) 
        fill_element('z_gnark_a1', fp_elements[1])
    %}
    let res = e2.mul_by_non_residue_1_power_1(x);
    e2.assert_E2(res, z_gnark);
    return ();
}

@external
func test_mulbnr1p2{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local xa0: BigInt3;
    local xa1: BigInt3;
    tempvar x: E2* = new E2(&xa0, &xa1);
    local z_gnark_a0: BigInt3;
    local z_gnark_a1: BigInt3;
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])

        cmd = ['./tools/parser_go/main', 'e2', 'mulbnr1p2'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 2
        fill_element('z_gnark_a0', fp_elements[0]) 
        fill_element('z_gnark_a1', fp_elements[1])
    %}
    let res = e2.mul_by_non_residue_1_power_2(x);
    e2.assert_E2(res, z_gnark);
    return ();
}

@external
func test_mulbnr1p3{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local xa0: BigInt3;
    local xa1: BigInt3;
    tempvar x: E2* = new E2(&xa0, &xa1);
    local z_gnark_a0: BigInt3;
    local z_gnark_a1: BigInt3;
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])

        cmd = ['./tools/parser_go/main', 'e2', 'mulbnr1p3'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 2
        fill_element('z_gnark_a0', fp_elements[0]) 
        fill_element('z_gnark_a1', fp_elements[1])
    %}
    let res = e2.mul_by_non_residue_1_power_3(x);
    e2.assert_E2(res, z_gnark);
    return ();
}

@external
func test_mulbnr1p4{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local xa0: BigInt3;
    local xa1: BigInt3;
    tempvar x: E2* = new E2(&xa0, &xa1);
    local z_gnark_a0: BigInt3;
    local z_gnark_a1: BigInt3;
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])

        cmd = ['./tools/parser_go/main', 'e2', 'mulbnr1p4'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 2
        fill_element('z_gnark_a0', fp_elements[0]) 
        fill_element('z_gnark_a1', fp_elements[1])
    %}
    let res = e2.mul_by_non_residue_1_power_4(x);
    e2.assert_E2(res, z_gnark);
    return ();
}

@external
func test_mulbnr1p5{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local xa0: BigInt3;
    local xa1: BigInt3;
    tempvar x: E2* = new E2(&xa0, &xa1);
    local z_gnark_a0: BigInt3;
    local z_gnark_a1: BigInt3;
    tempvar z_gnark: E2* = new E2(&z_gnark_a0, &z_gnark_a1);
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])

        cmd = ['./tools/parser_go/main', 'e2', 'mulbnr1p5'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 2
        fill_element('z_gnark_a0', fp_elements[0]) 
        fill_element('z_gnark_a1', fp_elements[1])
    %}
    let res = e2.mul_by_non_residue_1_power_5(x);
    e2.assert_E2(res, z_gnark);
    return ();
}
