%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.registers import get_fp_and_pc

from src.bn254.towers.e12 import E12, e12
from src.bn254.towers.e6 import E6, e6
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

        def fill_e6(e2:str, a0:int, a1:int, a2, a3, a4, a5):
            sa0 = split(a0)
            sa1 = split(a1)
            sa2 = split(a2)
            sa3 = split(a3)
            sa4 = split(a4)
            sa5 = split(a5)

            for i in range(3): rsetattr(ids,e2+'0.d'+str(i),sa0[i])
            for i in range(3): rsetattr(ids,e2+'1.d'+str(i),sa1[i])

            for i in range(3): rsetattr(ids,e2+'2.d'+str(i),sa2[i])
            for i in range(3): rsetattr(ids,e2+'3.d'+str(i),sa3[i])

            for i in range(3): rsetattr(ids,e2+'4.d'+str(i),sa4[i])
            for i in range(3): rsetattr(ids,e2+'5.d'+str(i),sa5[i])

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
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt3;
    local x1: BigInt3;
    local x2: BigInt3;
    local x3: BigInt3;
    local x4: BigInt3;
    local x5: BigInt3;

    local y0: BigInt3;
    local y1: BigInt3;
    local y2: BigInt3;
    local y3: BigInt3;
    local y4: BigInt3;
    local y5: BigInt3;

    local z0: BigInt3;
    local z1: BigInt3;
    local z2: BigInt3;
    local z3: BigInt3;
    local z4: BigInt3;
    local z5: BigInt3;
    tempvar x: E6* = new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5));
    tempvar y: E6* = new E6(new E2(&y0, &y1), new E2(&y2, &y3), new E2(&y4, &y5));
    tempvar z: E6* = new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5));
    %{
        inputs=[random.randint(0, P-1) for i in range(12)]

        fill_e6('x', *inputs[0:6])
        fill_e6('y', *inputs[6:12])
        cmd = ['./tools/parser_go/main', 'e6', 'add'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 6
        fill_e6('z', *fp_elements)
    %}
    let res = e6.add(x, y);

    e6.assert_E6(res, z);

    return ();
}

@external
func test_sub{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt3;
    local x1: BigInt3;
    local x2: BigInt3;
    local x3: BigInt3;
    local x4: BigInt3;
    local x5: BigInt3;

    local y0: BigInt3;
    local y1: BigInt3;
    local y2: BigInt3;
    local y3: BigInt3;
    local y4: BigInt3;
    local y5: BigInt3;

    local z0: BigInt3;
    local z1: BigInt3;
    local z2: BigInt3;
    local z3: BigInt3;
    local z4: BigInt3;
    local z5: BigInt3;
    tempvar x: E6* = new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5));
    tempvar y: E6* = new E6(new E2(&y0, &y1), new E2(&y2, &y3), new E2(&y4, &y5));
    tempvar z: E6* = new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5));
    %{
        inputs=[random.randint(0, P-1) for i in range(12)]

        fill_e6('x', *inputs[0:6])
        fill_e6('y', *inputs[6:12])
        cmd = ['./tools/parser_go/main', 'e6', 'sub'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 6
        fill_e6('z', *fp_elements)
    %}
    let res = e6.sub(x, y);
    e6.assert_E6(res, z);
    return ();
}

@external
func test_double{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt3;
    local x1: BigInt3;
    local x2: BigInt3;
    local x3: BigInt3;
    local x4: BigInt3;
    local x5: BigInt3;

    local z0: BigInt3;
    local z1: BigInt3;
    local z2: BigInt3;
    local z3: BigInt3;
    local z4: BigInt3;
    local z5: BigInt3;
    tempvar x: E6* = new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5));
    tempvar z: E6* = new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5));
    %{
        inputs=[random.randint(0, P-1) for i in range(12)]

        fill_e6('x', *inputs[0:6])
        cmd = ['./tools/parser_go/main', 'e6', 'double'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 6
        fill_e6('z', *fp_elements)
    %}
    let res = e6.double(x);

    e6.assert_E6(res, z);
    return ();
}

@external
func test_mul{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt3;
    local x1: BigInt3;
    local x2: BigInt3;
    local x3: BigInt3;
    local x4: BigInt3;
    local x5: BigInt3;

    local y0: BigInt3;
    local y1: BigInt3;
    local y2: BigInt3;
    local y3: BigInt3;
    local y4: BigInt3;
    local y5: BigInt3;

    local z0: BigInt3;
    local z1: BigInt3;
    local z2: BigInt3;
    local z3: BigInt3;
    local z4: BigInt3;
    local z5: BigInt3;
    tempvar x: E6* = new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5));
    tempvar y: E6* = new E6(new E2(&y0, &y1), new E2(&y2, &y3), new E2(&y4, &y5));
    tempvar z: E6* = new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5));
    %{
        inputs=[random.randint(0, P-1) for i in range(12)]

        fill_e6('x', *inputs[0:6])
        fill_e6('y', *inputs[6:12])
        cmd = ['./tools/parser_go/main', 'e6', 'mul'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 6
        fill_e6('z', *fp_elements)
    %}
    let res = e6.mul(x, y);

    e6.assert_E6(res, z);
    return ();
}

@external
func test_mul_by_non_residue{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt3;
    local x1: BigInt3;
    local x2: BigInt3;
    local x3: BigInt3;
    local x4: BigInt3;
    local x5: BigInt3;

    local z0: BigInt3;
    local z1: BigInt3;
    local z2: BigInt3;
    local z3: BigInt3;
    local z4: BigInt3;
    local z5: BigInt3;
    tempvar x: E6* = new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5));
    tempvar z: E6* = new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5));

    %{
        inputs=[random.randint(0, P-1) for i in range(12)]

        fill_e6('x', *inputs[0:6])
        cmd = ['./tools/parser_go/main', 'e6', 'mul_by_non_residue'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 6
        fill_e6('z', *fp_elements)
    %}
    let res = e6.mul_by_non_residue(x);

    e6.assert_E6(res, z);
    return ();
}

@external
func test_neg{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt3;
    local x1: BigInt3;
    local x2: BigInt3;
    local x3: BigInt3;
    local x4: BigInt3;
    local x5: BigInt3;

    local z0: BigInt3;
    local z1: BigInt3;
    local z2: BigInt3;
    local z3: BigInt3;
    local z4: BigInt3;
    local z5: BigInt3;
    tempvar x: E6* = new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5));
    tempvar z: E6* = new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5));
    %{
        inputs=[random.randint(0, P-1) for i in range(12)]

        fill_e6('x', *inputs[0:6])
        cmd = ['./tools/parser_go/main', 'e6', 'neg'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 6
        fill_e6('z', *fp_elements)
    %}
    let res = e6.neg(x);

    e6.assert_E6(res, z);
    return ();
}
