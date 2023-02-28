%builtins output range_check

from starkware.cairo.common.cairo_secp.constants import BASE
from starkware.cairo.common.uint256 import SHIFT
from starkware.cairo.common.cairo_secp.bigint import BigInt3, UnreducedBigInt5
from starkware.cairo.common.registers import get_fp_and_pc
from src.bn254.fq import nondet_bigint3, add_bigint3, fq_bigint3, sub_P, add_P
from src.bn254.curve import P0, P1, P2

func main{output_ptr: felt*, range_check_ptr}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local Xb: BigInt3 = BigInt3(BASE - 2, BASE - 2, 12);
    local Yb: BigInt3 = BigInt3(9, 10, 11);
    local larger_than_P: BigInt3 = BigInt3(P0, P1, P2 + 1);
    let res0 = add_bigint3(Xb, Yb);
    let xxu = fq_bigint3.add(&Xb, &Yb);
    let xxx = fq_bigint3.sub(&Xb, &Yb);
    let xxxx = fq_bigint3.subs(&Xb, &Yb);
    let res = fq_bigint3.mul(&Xb, &Yb);
    let res1 = sub_P(&larger_than_P);
    let res2 = add_P(Xb);
    %{ value = 456 + 456*2**86 + 15*2**(86*2) %}
    let value = nondet_bigint3();
    let (__fp__, _) = get_fp_and_pc();
    tempvar y = fp + 1;
    return ();
}
