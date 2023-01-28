%lang starknet

from src.pair import get_e_G1G2
from src.fq6 import FQ6, fq6 as fq6_lib
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

func get_example{range_check_ptr}() -> FQ6 {
    let x = FQ6(
        Uint256(313205626473664474612784707453944545669, 0),
        Uint256(206089031425980057520408673003100580252, 0),
        Uint256(18670876835414276146540009568809199949, 0),
        Uint256(107945741425515968639913278005022779464, 0),
        Uint256(40951358733114449862035778745898569893, 0),
        Uint256(284722584183539521101698036996060630147, 0)
    );

    return x;
}

@external
func test_fq6_mul_tower{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;
    __setup__();
    let e_G1G2: FQ6 = get_example();
    let res: FQ6 = fq6_lib.mul_tower(e_G1G2, e_G1G2);

    %{
        from tools.py.bn128_field import FQ12

        a = FQ12(ids.x.e0.low,ids.x.e1.low, ids.x.e2.low, ids.x.e3.low, ids.x.e4.low, ids.x.e5.low)

        print(a * a) 
    %}
    
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

    return ();
}