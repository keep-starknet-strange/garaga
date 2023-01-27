%lang starknet

from src.pair import get_e_G1G2
from src.fq12 import FQ12, fq12_lib
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from starkware.cairo.common.uint256 import Uint256
from src.u255 import Uint512

@external
func __setup__() {
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
        def print_affine_info(p, pn):
            print(f"Affine Point {pn}")
            print_u_256_info(p.x, 'X')
            print_u_256_info(p.y, 'Y')

        def print_felt_info(u, un):
            print(f" {un}_{u.bit_length()}bits = {bin_8(u)}")
            print(f" {un} = {u}")
            # print(f" {un} = {int.to_bytes(u, 12, 'big')}")

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
    %}
    assert 1 = 1;
    return ();
}

@external
func test_fq12_mul{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    __setup__();
    let e_G1G2: FQ12 = get_e_G1G2();
    let res: FQ12 = fq12_lib.mul(e_G1G2, e_G1G2);

    %{ print_u_256_info(ids.res.e0, "e0") %}
    %{ print_u_256_info(ids.res.e1, "e1") %}
    %{ print_u_256_info(ids.res.e2, "e2") %}

    return ();
}

@external
func test_fq12_mul_tower{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let e_G1G2: FQ12 = get_e_G1G2();
    let res: FQ12 = fq12_lib.mul_tower(e_G1G2, e_G1G2);
    
    %{ print(" ") %}
    %{ print("vars ") %}
    %{ print_u_256_info(ids.res.e0, "e0") %}
    %{ print_u_256_info(ids.res.e1, "e1") %}
    %{ print_u_256_info(ids.res.e2, "e2") %}
    %{ print_u_256_info(ids.res.e3, "e3") %}
    %{ print_u_256_info(ids.res.e4, "e4") %}
    %{ print_u_256_info(ids.res.e5, "e5") %}
    %{ print_u_256_info(ids.res.e6, "e6") %}
    %{ print_u_256_info(ids.res.e7, "e7") %}
    %{ print_u_256_info(ids.res.e8, "e8") %}
    %{ print_u_256_info(ids.res.e9, "e9") %}
    %{ print_u_256_info(ids.res.e10, "e10") %}
    %{ print_u_256_info(ids.res.e11, "e11") %}

    %{ print("\n ") %}

    let e_G1G2_2: FQ12 = get_e_G1G2();
    let res_normal: FQ12 = fq12_lib.mul(e_G1G2_2, e_G1G2_2);

    %{ print("\n normal ") %}
    
    %{ print_u_256_info(ids.res_normal.e0, "e0") %}
    %{ print_u_256_info(ids.res_normal.e1, "e1") %}
    %{ print_u_256_info(ids.res_normal.e2, "e2") %}
    %{ print_u_256_info(ids.res_normal.e3, "e3") %}
    %{ print_u_256_info(ids.res_normal.e4, "e4") %}
    %{ print_u_256_info(ids.res_normal.e5, "e5") %}
    %{ print_u_256_info(ids.res_normal.e6, "e6") %}
    %{ print_u_256_info(ids.res_normal.e7, "e7") %}
    %{ print_u_256_info(ids.res_normal.e8, "e8") %}
    %{ print_u_256_info(ids.res_normal.e9, "e9") %}
    %{ print_u_256_info(ids.res_normal.e10, "e10") %}
    %{ print_u_256_info(ids.res_normal.e11, "e11") %}
    %{ print(" ") %}
    %{ print("vars complete ") %}
    %{ print(" ") %}
    //assert res.e0 = res_normal.e0;
    return ();
}

@external
func test_fq12_add{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    __setup__();
    let e_G1G2: FQ12 = get_e_G1G2();
    let res: FQ12 = fq12_lib.add(e_G1G2, e_G1G2);

    %{ print_u_256_info(ids.res.e0,"e0") %}
    %{ print_u_256_info(ids.res.e1,"e0") %}
    %{ print_u_256_info(ids.res.e2,"e0") %}

    return ();
}

@external
func test_exponentiation{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    __setup__();
    let e_G1G2: FQ12 = get_e_G1G2();
    let res = fq12_lib.pow(e_G1G2, Uint512(7, 0, 0, 0));

    return ();
}
