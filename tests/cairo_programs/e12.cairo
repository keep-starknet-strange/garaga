%builtins range_check bitwise poseidon

from src.bn254.towers.e12 import (
    E12,
    E11DU,
    E12D,
    E7full,
    E12full034,
    PolyAcc034034,
    e12,
    gnark_to_w,
    w_to_gnark_reduced,
    mul01234_trick,
    E12full01234,
    PolyAcc12,
    get_powers_of_z11,
    mul034_034_trick,
)
from starkware.cairo.common.uint256 import Uint256

from src.bn254.towers.e6 import E6, e6
from src.bn254.towers.e2 import E2, e2
from starkware.cairo.common.registers import get_fp_and_pc
from src.bn254.fq import BigInt3, UnreducedBigInt3
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, BitwiseBuiltin

func main{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, poseidon_ptr: PoseidonBuiltin*}() {
    alloc_locals;
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

        def fill_e12(e2:str, *args):
            for i in range(12):
                splitted = split(args[i])
                for j in range(3):
                    rsetattr(ids,e2+str(i)+'.d'+str(j),splitted[j])
            return None

        def parse_fp_elements(input_string:str):
            pattern = re.compile(r'\[([^\[\]]+)\]')
            substrings = pattern.findall(input_string)
            sublists = [substring.split(' ') for substring in substrings]
            sublists = [[int(x) for x in sublist] for sublist in sublists]
            fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 for x in sublists]
            return fp_elements
    %}
    let (__fp__, _) = get_fp_and_pc();

    local x0: BigInt3;
    local x1: BigInt3;
    local x2: BigInt3;
    local x3: BigInt3;
    local x4: BigInt3;
    local x5: BigInt3;
    local x6: BigInt3;
    local x7: BigInt3;
    local x8: BigInt3;
    local x9: BigInt3;
    local x10: BigInt3;
    local x11: BigInt3;

    local y0: BigInt3;
    local y1: BigInt3;
    local y2: BigInt3;
    local y3: BigInt3;
    local y4: BigInt3;
    local y5: BigInt3;
    local y6: BigInt3;
    local y7: BigInt3;
    local y8: BigInt3;
    local y9: BigInt3;
    local y10: BigInt3;
    local y11: BigInt3;

    local z0: BigInt3;
    local z1: BigInt3;
    local z2: BigInt3;
    local z3: BigInt3;
    local z4: BigInt3;
    local z5: BigInt3;
    local z6: BigInt3;
    local z7: BigInt3;
    local z8: BigInt3;
    local z9: BigInt3;
    local z10: BigInt3;
    local z11: BigInt3;
    tempvar x = new E12(
        new E6(new E2(&x0, &x1), new E2(&x2, &x3), new E2(&x4, &x5)),
        new E6(new E2(&x6, &x7), new E2(&x8, &x9), new E2(&x10, &x11)),
    );
    tempvar y = new E12(
        new E6(new E2(&y0, &y1), new E2(&y2, &y3), new E2(&y4, &y5)),
        new E6(new E2(&y6, &y7), new E2(&y8, &y9), new E2(&y10, &y11)),
    );
    tempvar z = new E12(
        new E6(new E2(&z0, &z1), new E2(&z2, &z3), new E2(&z4, &z5)),
        new E6(new E2(&z6, &z7), new E2(&z8, &z9), new E2(&z10, &z11)),
    );
    %{
        random.seed(42)
        inputs=[random.randint(0, P-1) for i in range(24)]

        fill_e12('x', *inputs[0:12])
        fill_e12('y', *inputs[12:24])

        cmd = ['./tools/gnark/main', 'e12', 'mul'] + [str(x) for x in inputs]
        out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
        print('out', out)
        fp_elements = parse_fp_elements(out)

        assert len(fp_elements) == 12
        fill_e12('z', *fp_elements)
        reduce_counter=0
    %}
    let res = e12.mul(x, y);
    let (x_full) = gnark_to_w(x);
    let (y_full) = gnark_to_w(y);
    let res_full = e12.mul_trick_pure(x_full, y_full);
    let resb = w_to_gnark_reduced([res_full]);
    let z_pow = get_powers_of_z11(BigInt3(4, 5, 6));
    local poly_acc_f: PolyAcc12 = PolyAcc12(
        xy=UnreducedBigInt3(0, 0, 0),
        q=E11DU(
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
        ),
        r=E12D(
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
        ),
    );

    local poly_acc_034034_f: PolyAcc034034 = PolyAcc034034(
        xy=UnreducedBigInt3(0, 0, 0),
        q=E7full(
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
            Uint256(0, 0),
        ),
        r=E12full01234(
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
            BigInt3(0, 0, 0),
        ),
    );

    let poly_acc034034 = &poly_acc_034034_f;
    let poly_acc = &poly_acc_f;
    let ch = 0;
    let respp = mul01234_trick{z_pow1_11_ptr=z_pow, continuable_hash=ch, poly_acc_01234=poly_acc}(
        x_full, cast(y_full, E12full01234*)
    );

    e12.assert_E12(res, z);
    e12.assert_E12(resb, z);

    e12.mul_034_by_034(new E2(&x0, &x1), new E2(&x0, &x1), new E2(&x0, &x1), new E2(&x0, &x1));
    local x034: E12full034 = E12full034(z0, z0, z0, z0);

    mul034_034_trick{z_pow1_11_ptr=z_pow, continuable_hash=ch, poly_acc_034034=poly_acc034034}(
        &x034, &x034
    );

    return ();
}
