%builtins output range_check bitwise

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256
from tests.cairo_programs.libs.fq12 import FQ12, fq12_lib, get_e_G1G2
from tests.cairo_programs.libs.u255 import Uint512

func main{output_ptr: felt*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}() {
    // __setup__();
    %{
        PRIME = 2**255-19

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
        def _inverse(x):
            x=x.low + (x.high<<128)
            print("to inverse:", x)
            PRIME = 2**255-19
            return pow(x, PRIME - 2, PRIME)
        def print_from_extended(p):
            x = p.x.low + (p.x.high<<128)
            y = p.y.low + (p.y.high<<128)
            z = p.z.low + (p.z.high<<128)
            PRIME = 2**255-19

            invZ = _inverse(p.z)
            print("invz", invZ)
            assert invZ * z % PRIME == 1

            print(f"x={x*invZ%PRIME}")
            print(f"y={y*invZ%PRIME}")

        def print_u_256_info(u, un):
            u = u.low + (u.high << 128) 
            print(f" {un}_{u.bit_length()}bits = {bin_c(u)}")
            print(f" {un} = {u}")
        def print_affine_info(p, pn):
            print(f"Affine Point {pn}")
            print_u_256_info(p.x, 'X')
            print_u_256_info(p.y, 'Y')

        def print_felt_info(u, un):
            print(f" {un}_{u.bit_length()}bits = {bin_8(u)}")
            print(f" {un} = {u}")
            print(f" {un} = {int.to_bytes(u, 8, 'little')}")
        def print_felt_info_little(u, un):
            print(f" {un}_{u.bit_length()}bits = {u.to_bytes(32, 'little')}")
            print(f" {un}_{u.bit_length()}bits = {bin_8(u)}")
            print(f" {un} = {u}")
            print('\n')
        def print_u_512_info(u, un):
            u = u.d0 + (u.d1 << 128) + (u.d2<<256) + (u.d3<<384) 
            print(f" {un}_{u.bit_length()}bits = {bin_64(u)}")
            print(f" {un} = {u}")
        def print_u_512_info_u(l, h, un):
            u = l.low + (l.high << 128) + (h.low<<256) + (h.high<<384) 
            print(f" {un}_{u.bit_length()}bits = {bin_64(u)}")
            print(f" {un} = {u}")

        def print_u_256_neg(u, un):
            u = 2**256 - (u.low + (u.high << 128))
            print(f"-{un}_{u.bit_length()}bits = {bin_c(u)}")
            print(f"-{un} = {u}")

        def print_sub(a, an, b, bn, res, resn):
            print (f"----------------Subbing {resn} = {an} - {bn}------------------")
            print_u_256_info(a, an)
            print('\n')

            print_u_256_info(b, bn)
            print_u_256_neg(b, bn)
            print('\n')

            print_u_256_info(res, resn)
            print ('---------------------------------------------------------')

        def print_u256_array_little(address, len):
            for i in range(0, len):
                print_felt_info_little(memory[address+2*i] + (memory[address + 2*i+1] << 128), str(i))
    %}

    let e_G1G2: FQ12 = get_e_G1G2();
    let res = fq12_lib.pow(e_G1G2, Uint512(5, 0, 0, 0));

    return ();
}
