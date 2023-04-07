%builtins output range_check bitwise

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256
from tests.cairo_programs.libs.fq_poly import fq_poly, Polyfelt, Polyfelt3
from tests.cairo_programs.libs.fq_uint256 import fq

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
    alloc_locals;
    const t = 4965661367192848881;
    // P - 123
    tempvar X: Polyfelt = Polyfelt(4965661367192848759, 5, 24, 36, 36);
    let a_low = X.p00;
    let a_mid = X.p10 + X.p20 * t;
    let a_high = X.p30 + X.p40 * t;
    // P - P//7
    tempvar Y = Polyfelt(2837520781253056505, 2837520781253056508, 20, 4256281171879584786, 36);
    let res: Polyfelt = fq_poly.add_a(X, Y);
    let res: Polyfelt = fq_poly.add_b(X, Y);
    let res: Polyfelt = fq_poly.add_c(X, Y);

    let res: Polyfelt = fq_poly.polyadd(X, Y);

    let b_low = Y.p00;
    let b_mid = Y.p10 + Y.p20 * t;
    let b_high = Y.p30 + Y.p40 * t;

    let a = Polyfelt3(a_low, a_mid, a_high);
    let b = Polyfelt3(b_low, b_mid, b_high);
    let res3: Polyfelt3 = fq_poly.polyadd_3(a, b);
    return ();
}
