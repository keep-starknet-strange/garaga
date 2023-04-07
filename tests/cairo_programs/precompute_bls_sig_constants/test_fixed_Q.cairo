%builtins range_check
from starkware.cairo.common.registers import get_label_location
from src.bls12_381.g1 import G1Point, g1
from src.bls12_381.g2 import G2Point, g2, E4
from src.bls12_381.towers.e12 import E12, e12
from src.bls12_381.towers.e2 import E2, e2
from src.bls12_381.towers.e6 import E6, e6
from src.bls12_381.curve import CURVE, BASE, DEGREE, N_LIMBS, P0, P1, P2, P3
from src.bls12_381.fq import BigInt4
from starkware.cairo.common.registers import get_fp_and_pc
from src.bls12_381.pairing import get_loop_digit, final_exponentiation

from tests.cairo_programs.precompute_bls_sig_constants.nQ_lines import get_nQ_lines

func main{range_check_ptr}() {
    alloc_locals;
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
    let (__fp__, _) = get_fp_and_pc();
    local px: BigInt4;
    local py: BigInt4;

    local qx0: BigInt4;
    local qx1: BigInt4;
    local qy0: BigInt4;
    local qy1: BigInt4;
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
    tempvar z = new E12(
        new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
        new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
    );
    %{
        for var_name in list(program_input.keys()):
            if type(program_input[var_name]) == str : continue
            fill_element(var_name, program_input[var_name])

        inputs = [program_input['px'], program_input['py'], program_input['qx0'], program_input['qx1'], program_input['qy0'], program_input['qy1']]
        cmd = [MAIN_FILE, 'pair', 'pair'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        print(out)
        fp_elements = parse_fp_elements(out)
        assert len(fp_elements) == 12
        fill_e12('z', *fp_elements)
    %}

    local x: G1Point = G1Point(&px, &py);
    local y: G2Point = G2Point(new E2(&qx0, &qx1), new E2(&qy0, &qy1));
    g1.assert_on_curve(x);
    g2.assert_on_curve(y);
    let res = miller_loop_fixed_Q(&x, &y);
    let res = final_exponentiation(res);
    e12.assert_E12(res, z);
    return ();
}

func miller_loop_fixed_Q{range_check_ptr}(P: G1Point*, Q: G2Point*) -> E12* {
    alloc_locals;
    // todo : Assert P, Q not 0 (point at infinity)
    %{
        def print_G2(id):
            x0 = id.x.a0.d0 + id.x.a0.d1 * 2**96 + id.x.a0.d2 * 2**192 + id.x.a0.d3 * 2**288
            x1 = id.x.a1.d0 + id.x.a1.d1 * 2**96 + id.x.a1.d2 * 2**192 + id.x.a1.d3 * 2**288
            y0 = id.y.a0.d0 + id.y.a0.d1 * 2**96 + id.y.a0.d2 * 2**192 + id.y.a0.d3 * 2**288 
            y1 = id.y.a1.d0 + id.y.a1.d1 * 2**96 + id.y.a1.d2 * 2**192 + id.y.a1.d3 * 2**288 

            print(f"X={np.base_repr(x0,36).lower()} + {np.base_repr(x1,36).lower()}*u")
            # print(f"Y={np.base_repr(y0,36).lower()} + {np.base_repr(y1,36).lower()}*u")
    %}

    local Q_original: G2Point* = Q;

    let result = e12.one();
    let (Q: G2Point*, local l1: E4*) = get_nQ_lines(0);
    let (Q: G2Point*, local l2: E4*) = get_nQ_lines(1);

    let lines = e12.mul_014_by_014(l1.r0, l1.r1, l2.r0, l2.r1);
    let result = e12.mul(result, lines);
    let n = 2;
    with P, Q_original, n {
        let (local final_Q: G2Point*, local result: E12*) = miller_loop_inner(
            Q=Q, result=result, index=61
        );
    }

    return result;
}
func miller_loop_inner{range_check_ptr, P: G1Point*, Q_original: G2Point*, n: felt}(
    Q: G2Point*, result: E12*, index: felt
) -> (point: G2Point*, res: E12*) {
    alloc_locals;
    %{
        import numpy as np
        def print_G2(id, index, bit):
            x0 = id.x.a0.d0 + id.x.a0.d1 * 2**96 + id.x.a0.d2 * 2**192 + id.x.a0.d3 * 2**288
            x1 = id.x.a1.d0 + id.x.a1.d1 * 2**96 + id.x.a1.d2 * 2**192 + id.x.a1.d3 * 2**288
            y0 = id.y.a0.d0 + id.y.a0.d1 * 2**96 + id.y.a0.d2 * 2**192 + id.y.a0.d3 * 2**288 
            y1 = id.y.a1.d0 + id.y.a1.d1 * 2**96 + id.y.a1.d2 * 2**192 + id.y.a1.d3 * 2**288 
            print(f"{index} || {bit} X={np.base_repr(x0,36).lower()} + {np.base_repr(x1,36).lower()}*u ")
            # print(f"Y={np.base_repr(y0,36).lower()} + {np.base_repr(y1,36).lower()}*u")
    %}
    if (index == -1) {
        // negative x₀
        let result = e12.conjugate(result);
        return (Q, result);
    }

    let result = e12.square(result);
    let (Q: G2Point*, l1: E4*) = get_nQ_lines(n);
    let n = n + 1;
    let (local bit: felt) = get_loop_digit(index);
    if (bit == 0) {
        let result = e12.mul_by_014(result, l1.r0, l1.r1);
        %{ print_G2(ids.Q, ids.index, ids.bit) %}
        return miller_loop_inner(Q, result, index - 1);
    } else {
        let (Q: G2Point*, l2: E4*) = get_nQ_lines(n);
        let n = n + 1;
        let lines = e12.mul_014_by_014(l1.r0, l1.r1, l2.r0, l2.r1);
        let result = e12.mul(result, lines);
        return miller_loop_inner(Q, result, index - 1);
    }
}
