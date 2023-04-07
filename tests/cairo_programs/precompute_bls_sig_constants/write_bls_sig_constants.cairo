%builtins range_check
from starkware.cairo.common.registers import get_label_location
from src.bls12_381.g1 import G1Point, g1
from src.bls12_381.g2 import G2Point, g2, E4
from src.bls12_381.towers.e12 import E12, e12
from src.bls12_381.towers.e2 import E2, e2
from src.bls12_381.towers.e6 import E6, e6
from src.bls12_381.curve import CURVE, BASE, DEGREE, N_LIMBS, P0, P1, P2, P3
from src.bls12_381.fq import BigInt4
from src.bls12_381.pairing import get_loop_digit
from starkware.cairo.common.registers import get_fp_and_pc

const ate_loop_count = 15132376222941642752;
const log_ate_loop_count = 63;

func main{range_check_ptr}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    %{
        import functools, re, subprocess
        from starkware.cairo.common.cairo_secp.secp_utils import split
        from tools.py.generate_cairo_code import write
        CURVE_STR = bytes.fromhex(f'{ids.CURVE:x}').decode('ascii')
        MAIN_FILE = './tools/parser_go/' + CURVE_STR + '/cairo_test/main'
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
        def fill_e12(e2:str, *args):
            for i in range(12):
                splitted = split(args[i])
                for j in range(ids.N_LIMBS):
                    rsetattr(ids,e2+str(i)+'.d'+str(j),splitted[j])
            return None
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
        def append_data(Q, l):
            d=[Q.x.a0.d0, Q.x.a0.d1, Q.x.a0.d2, Q.x.a0.d3, Q.x.a1.d0, Q.x.a1.d1, Q.x.a1.d2, Q.x.a1.d3, Q.y.a0.d0, Q.y.a0.d1, Q.y.a0.d2, Q.y.a0.d3, Q.y.a1.d0, Q.y.a1.d1, Q.y.a1.d2, Q.y.a1.d3]
            d+=[l.r0.a0.d0, l.r0.a0.d1, l.r0.a0.d2, l.r0.a0.d3, l.r0.a1.d0, l.r0.a1.d1, l.r0.a1.d2, l.r0.a1.d3, l.r1.a0.d0, l.r1.a0.d1, l.r1.a0.d2, l.r1.a0.d3, l.r1.a1.d0, l.r1.a1.d1, l.r1.a1.d2, l.r1.a1.d3]
            DATA.append(d)
        WRITE_PATH = program_input['path_to_write']
        DATA=[]
    %}
    local px: BigInt4;
    local py: BigInt4;

    local qx0: BigInt4;
    local qx1: BigInt4;
    local qy0: BigInt4;
    local qy1: BigInt4;

    %{
        for var_name in list(program_input.keys()):
            if type(program_input[var_name]) == str : continue
            fill_element(var_name, program_input[var_name])
    %}

    // TODO : complete pre-computations and verification.

    local p: G1Point = G1Point(&px, &py);
    local q: G2Point = G2Point(new E2(&qx0, &qx1), new E2(&qy0, &qy1));

    g1.assert_on_curve(p);
    g2.assert_on_curve(q);

    %{ print(f"All elements on curve!") %}

    let res = miller_loop(&p, &q);
    %{ write(DATA, WRITE_PATH) %}
    return ();
}

func miller_loop{range_check_ptr}(P: G1Point*, Q: G2Point*) -> E12* {
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
    let (Q: G2Point*, local l1: E4*) = g2.double_step(Q, P);
    %{ append_data(ids.Q, ids.l1) %}
    let (Q: G2Point*, local l2: E4*) = g2.add_step(Q, Q_original, P);
    %{ append_data(ids.Q, ids.l2) %}

    let lines = e12.mul_014_by_014(l1.r0, l1.r1, l2.r0, l2.r1);
    let result = e12.mul(result, lines);

    with P, Q_original {
        let (local final_Q: G2Point*, local result: E12*) = miller_loop_inner(
            Q=Q, result=result, index=61
        );
    }

    return result;
}
func miller_loop_inner{range_check_ptr, P: G1Point*, Q_original: G2Point*}(
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
    let (Q: G2Point*, l1: E4*) = g2.double_step(Q, P);
    %{ append_data(ids.Q, ids.l1) %}

    let (local bit: felt) = get_loop_digit(index);
    if (bit == 0) {
        let result = e12.mul_by_014(result, l1.r0, l1.r1);
        %{ print_G2(ids.Q, ids.index, ids.bit) %}
        return miller_loop_inner(Q, result, index - 1);
    } else {
        let (Q: G2Point*, l2: E4*) = g2.add_step(Q, Q_original, P);
        %{ append_data(ids.Q, ids.l2) %}
        let lines = e12.mul_014_by_014(l1.r0, l1.r1, l2.r0, l2.r1);
        let result = e12.mul(result, lines);
        return miller_loop_inner(Q, result, index - 1);
    }
}
