%builtins output range_check

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.uint256 import Uint256
from src.bn254.fq import fq_bigint3, add_bigint3
from tests.cairo_programs.libs.fq_uint256 import fq
from starkware.cairo.common.cairo_secp.bigint import (
    BigInt3,
    uint256_to_bigint,
    bigint_to_uint256,
    UnreducedBigInt5,
    bigint_mul,
    nondet_bigint3,
)

func main{output_ptr: felt*, range_check_ptr}() {
    // __setup__();
    %{
        def bin_c(u):
            b=bin(u)
            f = b[0:10] + ' ' + b[10:19] + '...' + b[-16:-8] + ' ' + b[-8:]
            return f

        def bin_64(u):
            b=bin(u)
            little = '0b'+b[2:][::-1]
            f='0b'+' '.join([b[2:][i:i+64] for i in range(0, len(b[2:]), 64)])
            return f
        def bin_8(u):
            b=bin(u)
            little = '0b'+b[2:][::-1]
            f="0b"+' '.join([little[2:][i:i+8] for i in range(0, len(little[2:]), 8)])
            return f

        def print_u_256_info(u, un):
            u = u.low + (u.high << 128) 
            print(f" {un}_{u.bit_length()}bits = {bin_c(u)}")
            print(f" {un} = {u}")

        def print_felt_info(u, un):
            print(f" {un}_{u.bit_length()}bits = {bin_8(u)}")
            print(f" {un} = {u}")
            #print(f" {un} = {int.to_bytes(u, 8, 'little')}")

        def evaluate(p, un):
            t=4965661367192848881
            stark=3618502788666131213697322783095070105623107215331596699973092056135872020481
            return print_felt_info(p.p00 + p.p10*t+ p.p20*t**2+p.p30*t**3 + p.p40*t**4, un)
    %}
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let X = Uint256(
        201385395114098847380338600778089168076, 64323764613183177041862057485226039389
    );
    let Y = Uint256(75392519548959451050754627114999798041, 55134655382728437464453192130193748048);
    // let res: Uint256 = fq.slow_add(X, Y);
    // let res0: Uint256 = fq.add(X, Y);
    // let res1: Uint256 = fq.add_fast(X, Y);
    // let res2 = fq.add_blasted(X, Y);
    let (X_bigint: BigInt3) = uint256_to_bigint(X);
    let (Y_bigint: BigInt3) = uint256_to_bigint(Y);
    local Xb: BigInt3 = BigInt3(X_bigint.d0, X_bigint.d1, X_bigint.d2);
    local Yb: BigInt3 = BigInt3(Y_bigint.d0, Y_bigint.d1, Y_bigint.d2);
    // tempvar arr: felt* = new (
    //     X_bigint.d0, X_bigint.d1, X_bigint.d2, Y_bigint.d0, Y_bigint.d1, Y_bigint.d2
    // );
    // let res3 = fq_bigint3.add(Xb, Yb);
    let res4 = add_bigint3(&Xb, &Yb);
    // assert [ap - 4] = 19; // d2
    // assert [ap - 5] = 18; // d1
    // assert [ap - 6] = 17; // d0
    return ();
}
