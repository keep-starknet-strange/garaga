%builtins range_check

from src.bn254.towers.e2 import E2, e2
from starkware.cairo.common.registers import get_fp_and_pc
from src.bn254.fq import BigInt3, BASE

func main{range_check_ptr}() {
    alloc_locals;
    %{
        import subprocess
        import random
        import functools
        import re
        from starkware.cairo.common.cairo_secp.secp_utils import split
        from starkware.cairo.common.math_utils import as_int


        P=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
        def rgetattr(obj, attr, *args):
            def _getattr(obj, attr):
                return getattr(obj, attr, *args)
            return functools.reduce(_getattr, [obj] + attr.split('.'))

        def rsetattr(obj, attr, val):
            pre, _, post = attr.rpartition('.')
            return setattr(rgetattr(obj, pre) if pre else obj, post, val)

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

    let (a0, a1) = e2.mul_unreduced(x, y);

    local z0: BigInt3;
    local z1: BigInt3;
    %{
        a0=[ids.a0.d0, ids.a0.d1, ids.a0.d2, ids.a0.d3, ids.a0.d4]
        a1=[ids.a1.d0, ids.a1.d1, ids.a1.d2, ids.a1.d3, ids.a1.d4]


        a0_int = [as_int(x, PRIME) for x in a0]
        a1_int = [as_int(x, PRIME) for x in a1]

        print(f'[{" ".join([str(x) for x in a0_int])}]')
        print(f'[{" ".join([str(x) for x in a1_int])}]')

        def eval_poly(x:list, b=ids.BASE) -> int:
            result = 0
            for i in range(len(x)):
                result += b**i * x[i]
            return result

        (q0, z0) = divmod(eval_poly(a0_int), P)
        (q1, z1) = divmod(eval_poly(a1_int), P)

        fill_element('z0', z0)
        fill_element('z1', z1)

        print(f"q0={q0}_{q0.bit_length()}, z0={z0}_{z0.bit_length()}")
        print(f"q1={q1}_{q1.bit_length()}, z1={z1}_{z1.bit_length()}")
    %}
    e2.assert_E2(res, new E2(&z0, &z1));
    return ();
}
