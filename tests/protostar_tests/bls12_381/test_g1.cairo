%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from src.bls12_381.fq import BigInt4

from src.bls12_381.towers.e12 import E12, e12
from src.bls12_381.towers.e6 import E6, e6
from src.bls12_381.towers.e2 import E2, e2
from src.bls12_381.g1 import G1Point, g1
from src.bls12_381.pairing import final_exponentiation
from src.bls12_381.curve import CURVE, BASE, DEGREE, N_LIMBS, P0, P1, P2, P3

func __setup__() {
    %{
        import subprocess, random, functools, re, numpy as np
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
        def print_G1(id):
            x0 = id.x.d0 + id.x.d1 * 2**96 + id.x.d2 * 2**192 + id.x.d3 * 2**288
            y0 = id.y.d0 + id.y.d1 * 2**96 + id.y.d2 * 2**192 + id.y.d3 * 2**288 

            print(f"X={np.base_repr(x0,36).lower()}")
            print(f"Y={np.base_repr(y0,36).lower()}")
    %}
    return ();
}

@external
func test_nG1_random{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local g1x: BigInt4;
    local g1y: BigInt4;
    local ng1x: BigInt4;
    local ng1y: BigInt4;

    local n: BigInt4;

    %{
        cmd = [MAIN_FILE, 'nG1nG2']+["1", "1"]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 6
        fill_element('g1x', fp_elements[0])
        fill_element('g1y', fp_elements[1])

        inputs=[random.randint(0, CURVE_ORDER) for i in range(2)]
        cmd = [MAIN_FILE, 'nG1nG2']+[str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 6
        fill_element('ng1x', fp_elements[0])
        fill_element('ng1y', fp_elements[1])
        fill_element('n', inputs[0])
    %}
    local G: G1Point = G1Point(&g1x, &g1y);
    local nG: G1Point = G1Point(&ng1x, &ng1y);
    g1.assert_on_curve(G);

    let (res) = g1.scalar_mul(&G, n);

    g1.assert_equal(res, &nG);
    return ();
}

@external
func test_3{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let (__fp__, _) = get_fp_and_pc();

    local g1x: BigInt4;
    local g1y: BigInt4;
    local ng1x: BigInt4;
    local ng1y: BigInt4;

    local n: BigInt4;

    %{
        cmd = [MAIN_FILE, 'nG1nG2']+["1", "1"]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 6
        fill_element('g1x', fp_elements[0])
        fill_element('g1y', fp_elements[1])

        inputs=[3,3]
        cmd = [MAIN_FILE, 'nG1nG2']+[str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 6
        fill_element('ng1x', fp_elements[0])
        fill_element('ng1y', fp_elements[1])
        fill_element('n', inputs[0])
    %}
    local G: G1Point = G1Point(&g1x, &g1y);
    local nG: G1Point = G1Point(&ng1x, &ng1y);
    g1.assert_on_curve(G);
    %{ print_G1(ids.nG) %}
    let (res) = g1.scalar_mul(&G, n);

    g1.assert_equal(res, &nG);
    return ();
}
