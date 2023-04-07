%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from src.bls12_381.fq import BigInt4

from src.bls12_381.towers.e12 import E12, e12
from src.bls12_381.towers.e6 import E6, e6
from src.bls12_381.towers.e2 import E2, e2
from src.bls12_381.g2 import G2Point, g2
from src.bls12_381.pairing import final_exponentiation
from src.bls12_381.curve import CURVE, BASE, DEGREE, N_LIMBS, P0, P1, P2, P3

func __setup__() {
    %{
        import subprocess, random, functools, re
        CURVE_STR = bytes.fromhex(f'{ids.CURVE:x}').decode('ascii')
        MAIN_FILE = './tools/parser_go/' + CURVE_STR + '/cairo_test/main'
        BASE_GNARK=2**64
        DEGREE_GNARK=5
        CURVE_ORDER = 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001
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
        def parse_fp_elements(input_string:str):
            pattern = re.compile(r'\[([^\[\]]+)\]')
            substrings = pattern.findall(input_string)
            sublists = [substring.split(' ') for substring in substrings]
            sublists = [[int(x) for x in sublist] for sublist in sublists]
            fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 + x[4] * 2**256 + x[5] * 2**320 for x in sublists]
            return fp_elements

                
        import numpy as np
        def print_G2(id):
            x0 = id.x.a0.d0 + id.x.a0.d1 * 2**96 + id.x.a0.d2 * 2**192 + id.x.a0.d3 * 2**288
            x1 = id.x.a1.d0 + id.x.a1.d1 * 2**96 + id.x.a1.d2 * 2**192 + id.x.a1.d3 * 2**288
            y0 = id.y.a0.d0 + id.y.a0.d1 * 2**96 + id.y.a0.d2 * 2**192 + id.y.a0.d3 * 2**288 
            y1 = id.y.a1.d0 + id.y.a1.d1 * 2**96 + id.y.a1.d2 * 2**192 + id.y.a1.d3 * 2**288 

            print(f"X={np.base_repr(x0,36).lower()} + {np.base_repr(x1,36).lower()}*u")
            print(f"Y={np.base_repr(y0,36).lower()} + {np.base_repr(y1,36).lower()}*u")
    %}
    return ();
}

@external
func test_nG2_random{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local g2x0: BigInt4;
    local g2x1: BigInt4;
    local g2y0: BigInt4;
    local g2y1: BigInt4;

    local ng2x0: BigInt4;
    local ng2x1: BigInt4;
    local ng2y0: BigInt4;
    local ng2y1: BigInt4;

    local n: BigInt4;

    %{
        cmd = [MAIN_FILE, 'nG1nG2']+["1", "1"]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 6
        fill_element('g2x0', fp_elements[2])
        fill_element('g2x1', fp_elements[3])
        fill_element('g2y0', fp_elements[4])
        fill_element('g2y1', fp_elements[5])

        inputs=[random.randint(0, CURVE_ORDER) for i in range(2)]
        cmd = [MAIN_FILE, 'nG1nG2']+[str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 6
        fill_element('ng2x0', fp_elements[2])
        fill_element('ng2x1', fp_elements[3])
        fill_element('ng2y0', fp_elements[4])
        fill_element('ng2y1', fp_elements[5])
        fill_element('n', inputs[1])
        print(split(inputs[1]))
    %}
    local g2x: E2 = E2(&g2x0, &g2x1);
    local g2y: E2 = E2(&g2y0, &g2y1);
    local G: G2Point = G2Point(&g2x, &g2y);

    local ngx: E2 = E2(&ng2x0, &ng2x1);
    local ngy: E2 = E2(&ng2y0, &ng2y1);
    local nG: G2Point = G2Point(&ngx, &ngy);

    g2.assert_on_curve(G);

    let (res) = g2.scalar_mul(&G, &n);

    g2.assert_equal(res, &nG);
    return ();
}

@external
func test_double{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local g2x0: BigInt4;
    local g2x1: BigInt4;
    local g2y0: BigInt4;
    local g2y1: BigInt4;

    local ng2x0: BigInt4;
    local ng2x1: BigInt4;
    local ng2y0: BigInt4;
    local ng2y1: BigInt4;

    local n: BigInt4;

    %{
        cmd = [MAIN_FILE, 'nG1nG2']+["1", "1"]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 6
        fill_element('g2x0', fp_elements[2])
        fill_element('g2x1', fp_elements[3])
        fill_element('g2y0', fp_elements[4])
        fill_element('g2y1', fp_elements[5])

        inputs=[2,2]
        cmd = [MAIN_FILE, 'nG1nG2']+[str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 6
        fill_element('ng2x0', fp_elements[2])
        fill_element('ng2x1', fp_elements[3])
        fill_element('ng2y0', fp_elements[4])
        fill_element('ng2y1', fp_elements[5])
        fill_element('n', inputs[1])
    %}
    local g2x: E2 = E2(&g2x0, &g2x1);
    local g2y: E2 = E2(&g2y0, &g2y1);
    local G: G2Point = G2Point(&g2x, &g2y);
    local ngx: E2 = E2(&ng2x0, &ng2x1);
    local ngy: E2 = E2(&ng2y0, &ng2y1);
    local nG: G2Point = G2Point(&ngx, &ngy);
    g2.assert_on_curve(G);

    let res = g2.add(&G, &G);

    g2.assert_equal(res, &nG);
    return ();
}

@external
func test_double_slope{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local g2x0: BigInt4;
    local g2x1: BigInt4;
    local g2y0: BigInt4;
    local g2y1: BigInt4;

    local ng2x0: BigInt4;
    local ng2x1: BigInt4;
    local ng2y0: BigInt4;
    local ng2y1: BigInt4;

    local n: BigInt4;

    %{
        cmd = [MAIN_FILE, 'nG1nG2']+["3", "3"]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 6
        fill_element('g2x0', fp_elements[2])
        fill_element('g2x1', fp_elements[3])
        fill_element('g2y0', fp_elements[4])
        fill_element('g2y1', fp_elements[5])

        inputs=[6,6]
        cmd = [MAIN_FILE, 'nG1nG2']+[str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 6
        fill_element('ng2x0', fp_elements[2])
        fill_element('ng2x1', fp_elements[3])
        fill_element('ng2y0', fp_elements[4])
        fill_element('ng2y1', fp_elements[5])
        fill_element('n', inputs[1])
    %}
    local g2x: E2 = E2(&g2x0, &g2x1);
    local g2y: E2 = E2(&g2y0, &g2y1);
    local G: G2Point = G2Point(&g2x, &g2y);
    local ngx: E2 = E2(&ng2x0, &ng2x1);
    local ngy: E2 = E2(&ng2y0, &ng2y1);
    local nG: G2Point = G2Point(&ngx, &ngy);
    g2.assert_on_curve(G);

    let res = g2.double(&G);

    g2.assert_equal(res, &nG);
    return ();
}
@external
func test_add{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local g2x0: BigInt4;
    local g2x1: BigInt4;
    local g2y0: BigInt4;
    local g2y1: BigInt4;

    local ng2x0: BigInt4;
    local ng2x1: BigInt4;
    local ng2y0: BigInt4;
    local ng2y1: BigInt4;

    local n: BigInt4;

    %{
        cmd = [MAIN_FILE, 'nG1nG2']+["1", "1"]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 6
        fill_element('g2x0', fp_elements[2])
        fill_element('g2x1', fp_elements[3])
        fill_element('g2y0', fp_elements[4])
        fill_element('g2y1', fp_elements[5])

        inputs=[3,3]
        cmd = [MAIN_FILE, 'nG1nG2']+[str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 6
        fill_element('ng2x0', fp_elements[2])
        fill_element('ng2x1', fp_elements[3])
        fill_element('ng2y0', fp_elements[4])
        fill_element('ng2y1', fp_elements[5])
        fill_element('n', inputs[1])
    %}
    local g2x: E2 = E2(&g2x0, &g2x1);
    local g2y: E2 = E2(&g2y0, &g2y1);
    local G: G2Point = G2Point(&g2x, &g2y);
    local ngx: E2 = E2(&ng2x0, &ng2x1);
    local ngy: E2 = E2(&ng2y0, &ng2y1);
    local nG: G2Point = G2Point(&ngx, &ngy);
    g2.assert_on_curve(G);

    let res = g2.add(&G, &G);
    let res = g2.add(res, &G);

    g2.assert_equal(res, &nG);
    return ();
}
