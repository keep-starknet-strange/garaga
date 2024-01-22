%builtins range_check

from src.bn254.towers.e2 import E2, e2
from starkware.cairo.common.registers import get_fp_and_pc
from src.bn254.fq import BigInt3, BASE, reduce_5, fq_bigint3

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
    tempvar x: E2* = new E2(xa0, xa1);
    tempvar y: E2* = new E2(ya0, ya1);
    local z_gnark_a0: BigInt3;
    local z_gnark_a1: BigInt3;
    tempvar z_gnark: E2* = new E2(z_gnark_a0, z_gnark_a1);
    %{
        inputs=[random.randint(0, P-1) for i in range(4)]

        fill_element('xa0', inputs[0])
        fill_element('xa1', inputs[1])
        fill_element('ya0', inputs[2])
        fill_element('ya1', inputs[3])

        cmd = ['./tools/gnark/main', 'e2', 'mul'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')

        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 2

        fill_element('z_gnark_a0', fp_elements[0]) 
        fill_element('z_gnark_a1', fp_elements[1])
    %}
    let res: E2* = mul_full_mod(x, y);
    e2.assert_E2(res, z_gnark);

    let res_unred = e2.mul(x, y);

    e2.assert_E2(res, res_unred);

    let k = e2.mul_by_non_residue(x);
    return ();
}

func mul_full_mod{range_check_ptr}(x: E2*, y: E2*) -> E2* {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    let a0 = fq_bigint3.add(x.a0, x.a1);
    let b0 = fq_bigint3.add(y.a0, y.a1);

    let a = fq_bigint3.mul(a0, b0);
    let b = fq_bigint3.mul(x.a0, y.a0);
    let c = fq_bigint3.mul(x.a1, y.a1);
    let z_a1 = fq_bigint3.sub(a, b);
    let z_a1 = fq_bigint3.sub(z_a1, c);
    let z_a0 = fq_bigint3.sub(b, c);

    local res: E2 = E2(z_a0, z_a1);
    return &res;
}
