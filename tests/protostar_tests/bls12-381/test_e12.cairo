%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.registers import get_fp_and_pc

from src.bls12_381.towers.e12 import E12, e12
from src.bls12_381.towers.e6 import E6, e6
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
        MAIN_FILE = './tools/parser_go/' + CURVE_STR + '/cairo_test/main'
        BASE_GNARK=2**64
        DEGREE_GNARK=5

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

        def fill_e12(e2:str, *args):
            for i in range(12):
                splitted = split(args[i])
                for j in range(ids.N_LIMBS):
                    rsetattr(ids,e2+str(i)+'.d'+str(j),splitted[j])
            return None

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
func test_add{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt4;
    local x1: BigInt4;
    local x2: BigInt4;
    local x3: BigInt4;
    local x4: BigInt4;
    local x5: BigInt4;
    local x6: BigInt4;
    local x7: BigInt4;
    local x8: BigInt4;
    local x9: BigInt4;
    local x10: BigInt4;
    local x11: BigInt4;

    local z0: BigInt4;
    local z1: BigInt4;
    local z2: BigInt4;
    local z3: BigInt4;
    local z4: BigInt4;
    local z5: BigInt4;
    local z6: BigInt4;
    local z7: BigInt4;
    local z8: BigInt4;
    local z9: BigInt4;
    local z10: BigInt4;
    local z11: BigInt4;
    tempvar x = new E12(
        new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5)),
        new E6(new E2(&x6, &x7), new E2(&x8, &x9), new E2(&x10, &x11)),
    );
    tempvar z = new E12(
        new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
        new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
    );

    local y0: BigInt4;
    local y1: BigInt4;
    local y2: BigInt4;
    local y3: BigInt4;
    local y4: BigInt4;
    local y5: BigInt4;
    local y6: BigInt4;
    local y7: BigInt4;
    local y8: BigInt4;
    local y9: BigInt4;
    local y10: BigInt4;
    local y11: BigInt4;
    tempvar y = new E12(
        new E6(new E2(&y0, &y1), new E2(&y2, &y3), new E2(&y4, &y5)),
        new E6(new E2(&y6, &y7), new E2(&y8, &y9), new E2(&y10, &y11)),
    );

    %{
        print(f"P={P}")
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])
        fill_e12('y', *inputs[12:24])

        cmd = [MAIN_FILE, 'e12', 'add'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        print(fp_elements)

        assert len(fp_elements) == 12
        fill_e12('z', *fp_elements)
    %}
    let res = e12.add(x, y);
    e12.assert_E12(res, z);
    return ();
}
@external
func test_sub{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt4;
    local x1: BigInt4;
    local x2: BigInt4;
    local x3: BigInt4;
    local x4: BigInt4;
    local x5: BigInt4;
    local x6: BigInt4;
    local x7: BigInt4;
    local x8: BigInt4;
    local x9: BigInt4;
    local x10: BigInt4;
    local x11: BigInt4;

    local z0: BigInt4;
    local z1: BigInt4;
    local z2: BigInt4;
    local z3: BigInt4;
    local z4: BigInt4;
    local z5: BigInt4;
    local z6: BigInt4;
    local z7: BigInt4;
    local z8: BigInt4;
    local z9: BigInt4;
    local z10: BigInt4;
    local z11: BigInt4;
    tempvar x = new E12(
        new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5)),
        new E6(new E2(&x6, &x7), new E2(&x8, &x9), new E2(&x10, &x11)),
    );
    tempvar z = new E12(
        new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
        new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
    );

    local y0: BigInt4;
    local y1: BigInt4;
    local y2: BigInt4;
    local y3: BigInt4;
    local y4: BigInt4;
    local y5: BigInt4;
    local y6: BigInt4;
    local y7: BigInt4;
    local y8: BigInt4;
    local y9: BigInt4;
    local y10: BigInt4;
    local y11: BigInt4;
    tempvar y = new E12(
        new E6(new E2(&y0, &y1), new E2(&y2, &y3), new E2(&y4, &y5)),
        new E6(new E2(&y6, &y7), new E2(&y8, &y9), new E2(&y10, &y11)),
    );
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])
        fill_e12('y', *inputs[12:24])

        cmd = [MAIN_FILE, 'e12', 'sub'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z', *fp_elements)
    %}
    let res = e12.sub(x, y);

    e12.assert_E12(res, z);
    return ();
}
@external
func test_mul{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt4;
    local x1: BigInt4;
    local x2: BigInt4;
    local x3: BigInt4;
    local x4: BigInt4;
    local x5: BigInt4;
    local x6: BigInt4;
    local x7: BigInt4;
    local x8: BigInt4;
    local x9: BigInt4;
    local x10: BigInt4;
    local x11: BigInt4;

    local z0: BigInt4;
    local z1: BigInt4;
    local z2: BigInt4;
    local z3: BigInt4;
    local z4: BigInt4;
    local z5: BigInt4;
    local z6: BigInt4;
    local z7: BigInt4;
    local z8: BigInt4;
    local z9: BigInt4;
    local z10: BigInt4;
    local z11: BigInt4;
    tempvar x = new E12(
        new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5)),
        new E6(new E2(&x6, &x7), new E2(&x8, &x9), new E2(&x10, &x11)),
    );
    tempvar z = new E12(
        new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
        new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
    );

    local y0: BigInt4;
    local y1: BigInt4;
    local y2: BigInt4;
    local y3: BigInt4;
    local y4: BigInt4;
    local y5: BigInt4;
    local y6: BigInt4;
    local y7: BigInt4;
    local y8: BigInt4;
    local y9: BigInt4;
    local y10: BigInt4;
    local y11: BigInt4;
    tempvar y = new E12(
        new E6(new E2(&y0, &y1), new E2(&y2, &y3), new E2(&y4, &y5)),
        new E6(new E2(&y6, &y7), new E2(&y8, &y9), new E2(&y10, &y11)),
    );
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])
        fill_e12('y', *inputs[12:24])

        cmd = [MAIN_FILE, 'e12', 'mul'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z', *fp_elements)
    %}
    let res = e12.mul(x, y);

    e12.assert_E12(res, z);
    return ();
}
@external
func test_double{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt4;
    local x1: BigInt4;
    local x2: BigInt4;
    local x3: BigInt4;
    local x4: BigInt4;
    local x5: BigInt4;
    local x6: BigInt4;
    local x7: BigInt4;
    local x8: BigInt4;
    local x9: BigInt4;
    local x10: BigInt4;
    local x11: BigInt4;

    local z0: BigInt4;
    local z1: BigInt4;
    local z2: BigInt4;
    local z3: BigInt4;
    local z4: BigInt4;
    local z5: BigInt4;
    local z6: BigInt4;
    local z7: BigInt4;
    local z8: BigInt4;
    local z9: BigInt4;
    local z10: BigInt4;
    local z11: BigInt4;
    tempvar x = new E12(
        new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5)),
        new E6(new E2(&x6, &x7), new E2(&x8, &x9), new E2(&x10, &x11)),
    );
    tempvar z = new E12(
        new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
        new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
    );
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = [MAIN_FILE, 'e12', 'double'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z', *fp_elements)
    %}
    let res = e12.double(x);

    e12.assert_E12(res, z);
    return ();
}

@external
func test_square{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt4;
    local x1: BigInt4;
    local x2: BigInt4;
    local x3: BigInt4;
    local x4: BigInt4;
    local x5: BigInt4;
    local x6: BigInt4;
    local x7: BigInt4;
    local x8: BigInt4;
    local x9: BigInt4;
    local x10: BigInt4;
    local x11: BigInt4;

    local z0: BigInt4;
    local z1: BigInt4;
    local z2: BigInt4;
    local z3: BigInt4;
    local z4: BigInt4;
    local z5: BigInt4;
    local z6: BigInt4;
    local z7: BigInt4;
    local z8: BigInt4;
    local z9: BigInt4;
    local z10: BigInt4;
    local z11: BigInt4;
    tempvar x = new E12(
        new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5)),
        new E6(new E2(&x6, &x7), new E2(&x8, &x9), new E2(&x10, &x11)),
    );
    tempvar z = new E12(
        new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
        new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
    );
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = [MAIN_FILE, 'e12', 'square'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z', *fp_elements)
    %}
    let res = e12.square(x);

    e12.assert_E12(res, z);
    return ();
}

@external
func test_inv{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt4;
    local x1: BigInt4;
    local x2: BigInt4;
    local x3: BigInt4;
    local x4: BigInt4;
    local x5: BigInt4;
    local x6: BigInt4;
    local x7: BigInt4;
    local x8: BigInt4;
    local x9: BigInt4;
    local x10: BigInt4;
    local x11: BigInt4;

    local z0: BigInt4;
    local z1: BigInt4;
    local z2: BigInt4;
    local z3: BigInt4;
    local z4: BigInt4;
    local z5: BigInt4;
    local z6: BigInt4;
    local z7: BigInt4;
    local z8: BigInt4;
    local z9: BigInt4;
    local z10: BigInt4;
    local z11: BigInt4;
    tempvar x = new E12(
        new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5)),
        new E6(new E2(&x6, &x7), new E2(&x8, &x9), new E2(&x10, &x11)),
    );
    tempvar z = new E12(
        new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
        new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
    );
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = [MAIN_FILE, 'e12', 'inv'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z', *fp_elements)
    %}
    let res = e12.inverse(x);

    e12.assert_E12(res, z);
    return ();
}

@external
func test_conjugate{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt4;
    local x1: BigInt4;
    local x2: BigInt4;
    local x3: BigInt4;
    local x4: BigInt4;
    local x5: BigInt4;
    local x6: BigInt4;
    local x7: BigInt4;
    local x8: BigInt4;
    local x9: BigInt4;
    local x10: BigInt4;
    local x11: BigInt4;

    local z0: BigInt4;
    local z1: BigInt4;
    local z2: BigInt4;
    local z3: BigInt4;
    local z4: BigInt4;
    local z5: BigInt4;
    local z6: BigInt4;
    local z7: BigInt4;
    local z8: BigInt4;
    local z9: BigInt4;
    local z10: BigInt4;
    local z11: BigInt4;
    tempvar x = new E12(
        new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5)),
        new E6(new E2(&x6, &x7), new E2(&x8, &x9), new E2(&x10, &x11)),
    );
    tempvar z = new E12(
        new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
        new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
    );
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = [MAIN_FILE, 'e12', 'conjugate'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z', *fp_elements)
    %}
    let res = e12.conjugate(x);

    e12.assert_E12(res, z);
    return ();
}

@external
func test_cyclotomic_square{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt4;
    local x1: BigInt4;
    local x2: BigInt4;
    local x3: BigInt4;
    local x4: BigInt4;
    local x5: BigInt4;
    local x6: BigInt4;
    local x7: BigInt4;
    local x8: BigInt4;
    local x9: BigInt4;
    local x10: BigInt4;
    local x11: BigInt4;

    local z0: BigInt4;
    local z1: BigInt4;
    local z2: BigInt4;
    local z3: BigInt4;
    local z4: BigInt4;
    local z5: BigInt4;
    local z6: BigInt4;
    local z7: BigInt4;
    local z8: BigInt4;
    local z9: BigInt4;
    local z10: BigInt4;
    local z11: BigInt4;
    tempvar x = new E12(
        new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5)),
        new E6(new E2(&x6, &x7), new E2(&x8, &x9), new E2(&x10, &x11)),
    );
    tempvar z = new E12(
        new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
        new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
    );
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = [MAIN_FILE, 'e12', 'cyclotomic_square'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z', *fp_elements)
    %}
    let res = e12.cyclotomic_square(x);

    e12.assert_E12(res, z);
    return ();
}

@external
func test_expt{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt4;
    local x1: BigInt4;
    local x2: BigInt4;
    local x3: BigInt4;
    local x4: BigInt4;
    local x5: BigInt4;
    local x6: BigInt4;
    local x7: BigInt4;
    local x8: BigInt4;
    local x9: BigInt4;
    local x10: BigInt4;
    local x11: BigInt4;

    local z0: BigInt4;
    local z1: BigInt4;
    local z2: BigInt4;
    local z3: BigInt4;
    local z4: BigInt4;
    local z5: BigInt4;
    local z6: BigInt4;
    local z7: BigInt4;
    local z8: BigInt4;
    local z9: BigInt4;
    local z10: BigInt4;
    local z11: BigInt4;
    tempvar x = new E12(
        new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5)),
        new E6(new E2(&x6, &x7), new E2(&x8, &x9), new E2(&x10, &x11)),
    );
    tempvar z = new E12(
        new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
        new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
    );
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = [MAIN_FILE, 'e12', 'expt'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z', *fp_elements)
    %}
    let res = e12.expt(x);

    e12.assert_E12(res, z);
    return ();
}

@external
func test_frobenius_square{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt4;
    local x1: BigInt4;
    local x2: BigInt4;
    local x3: BigInt4;
    local x4: BigInt4;
    local x5: BigInt4;
    local x6: BigInt4;
    local x7: BigInt4;
    local x8: BigInt4;
    local x9: BigInt4;
    local x10: BigInt4;
    local x11: BigInt4;

    local z0: BigInt4;
    local z1: BigInt4;
    local z2: BigInt4;
    local z3: BigInt4;
    local z4: BigInt4;
    local z5: BigInt4;
    local z6: BigInt4;
    local z7: BigInt4;
    local z8: BigInt4;
    local z9: BigInt4;
    local z10: BigInt4;
    local z11: BigInt4;
    tempvar x = new E12(
        new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5)),
        new E6(new E2(&x6, &x7), new E2(&x8, &x9), new E2(&x10, &x11)),
    );
    tempvar z = new E12(
        new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
        new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
    );
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = [MAIN_FILE, 'e12', 'frobenius_square'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z', *fp_elements)
    %}
    let res = e12.frobenius_square(x);

    e12.assert_E12(res, z);
    return ();
}

@external
func test_frobenius{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt4;
    local x1: BigInt4;
    local x2: BigInt4;
    local x3: BigInt4;
    local x4: BigInt4;
    local x5: BigInt4;
    local x6: BigInt4;
    local x7: BigInt4;
    local x8: BigInt4;
    local x9: BigInt4;
    local x10: BigInt4;
    local x11: BigInt4;

    local z0: BigInt4;
    local z1: BigInt4;
    local z2: BigInt4;
    local z3: BigInt4;
    local z4: BigInt4;
    local z5: BigInt4;
    local z6: BigInt4;
    local z7: BigInt4;
    local z8: BigInt4;
    local z9: BigInt4;
    local z10: BigInt4;
    local z11: BigInt4;
    tempvar x = new E12(
        new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5)),
        new E6(new E2(&x6, &x7), new E2(&x8, &x9), new E2(&x10, &x11)),
    );
    tempvar z = new E12(
        new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
        new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
    );
    %{
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])

        cmd = [MAIN_FILE, 'e12', 'frobenius'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z', *fp_elements)
    %}
    let res = e12.frobenius(x);

    e12.assert_E12(res, z);
    return ();
}
