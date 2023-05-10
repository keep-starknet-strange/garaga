%builtins output range_check bitwise

from starkware.cairo.common.cairo_secp.constants import BASE
from starkware.cairo.common.uint256 import SHIFT
from starkware.cairo.common.cairo_secp.bigint import BigInt3, UnreducedBigInt5
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from src.bn254.fq import nd, fq_bigint3
from src.bn254.curve import P0, P1, P2, N_LIMBS, DEGREE

func main{output_ptr: felt*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local zero: BigInt3 = BigInt3(0, 0, 0);
    local Xb: BigInt3;
    local Yb: BigInt3;
    %{
        import random, functools
        def rgetattr(obj, attr, *args):
            def _getattr(obj, attr):
                return getattr(obj, attr, *args)
            return functools.reduce(_getattr, [obj] + attr.split('.'))
        def rsetattr(obj, attr, val):
            pre, _, post = attr.rpartition('.')
            return setattr(rgetattr(obj, pre) if pre else obj, post, val)
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
        def fill_element(element:str, value:int):
            s = split(value)
            for i in range(ids.N_LIMBS): rsetattr(ids,element+'.d'+str(i),s[i])

        inputs=[random.randint(0, P) for i in range(2)]
        fill_element('Xb', inputs[0])
        fill_element('Yb', inputs[1])
    %}
    local larger_than_P: BigInt3 = BigInt3(P0, P1, P2 + 1);
    // let res0 = add_bigint3(Xb, Yb);
    let xxu = fq_bigint3.add(&Xb, &Yb);
    let xxx = fq_bigint3.sub(&Xb, &Yb);
    let res = fq_bigint3.mul_bitwise(&Xb, &Yb);
    let res = fq_bigint3.mul_casting(&Xb, &Yb);

    // let res = fq_bigint3.mul(&Xb, &zero);
    // let res = fq_bigint3.mulo(&Xb, &Yb);

    %{ value = 456 + 456*2**86 + 15*2**(86*2) %}
    let value = nd();
    let (__fp__, _) = get_fp_and_pc();
    tempvar y = fp + 1;
    return ();
}
