%builtins output range_check bitwise

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_add
from tests.cairo_programs.libs.u255 import uint256_fast_add, uint256_fastest_add

func main{output_ptr: felt*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
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
            prina(f" {un} = {u}")

        def print_felt_info(u, un):
            print(f" {un}_{u.bit_length()}bits = {bin_8(u)}")
            print(f" {un} = {u}")
            #print(f" {un} = {int.to_bytes(u, 8, 'little')}")
    %}
    alloc_locals;
    let X = Uint256(
        201385395114098847380338600778089168076, 64323764613183177041862057485226039389
    );
    let Y = Uint256(75392519548959451050754627114999798041, 55134655382728437464453192130193748048);
    let (res: Uint256, carry: felt) = uint256_add(X, Y);

    // Case 3
    let (res1: Uint256, carry1: felt) = uint256_fast_add(X, Y);
    let (res1: Uint256, carry1: felt) = uint256_fastest_add(X, Y);
    // // Case 2
    // let X = Uint256(1, 2 ** 128 - 1);
    // let (res1: Uint256, carry1: felt) = uint256_fast_add(X, X);

    // // Case 1
    // let X = Uint256(2 ** 128 - 1, 2 ** 65);
    // let (res1: Uint256, carry1: felt) = uint256_fast_add(X, X);

    // // Case 0
    // let X = Uint256(2 ** 128 - 1, 2 ** 128 - 1);
    // let (res1: Uint256, carry1: felt) = uint256_fast_add(X, X);
    return ();
}
