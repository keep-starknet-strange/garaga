%builtins output range_check bitwise

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from tests.cairo_programs.libs.fq_poly import fq_poly, Polyfelt

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

    // P - 123
    let X = Polyfelt(4965661367192848759, 5, 24, 36, 36);
    // P - P//7
    let Y = Polyfelt(2837520781253056505, 2837520781253056508, 20, 4256281171879584786, 30);
    let res: Polyfelt = fq_poly.mul(X, Y);

    %{ print_felt_info(ids.res.p00,'p00') %}
    %{ print_felt_info(ids.res.p10,'p10') %}

    %{ print_felt_info(ids.res.p20,'p20') %}

    %{ print_felt_info(ids.res.p30,'p30') %}

    %{ print_felt_info(ids.res.p40,'p40') %}

    %{ evaluate(ids.res, 'respoly') %}
    return ();
}
