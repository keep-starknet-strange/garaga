%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from starkware.cairo.common.uint256 import Uint256

from starkware.cairo.common.cairo_secp.bigint import BigInt3, uint256_to_bigint, bigint_to_uint256
from src.g2 import get_g2_generator, get_g22_generator, g2_weierstrass_arithmetics, G2Point

from src.u255 import u255, Uint512
from src.fbn254 import fbn254, Polyfelt
from src.pair import get_e_G1G2
from src.fq12 import FQ12, fq12_lib
from src.uint384_extension import Uint768
from src.curve import P_low, P_high

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
func test_compute_slope{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    __setup__();
    let G2: G2Point = get_g2_generator();
    let G22: G2Point = get_g22_generator();
    let res = g2_weierstrass_arithmetics.compute_slope(G22, G2);

    return ();
}

@external
func test_doubling_slope{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    __setup__();
    let G2: G2Point = get_g2_generator();
    let res = g2_weierstrass_arithmetics.compute_doubling_slope(G2);

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
func test_fast_mod512{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    __setup__();
    let N = Uint512(
        212472832437159906265623935117356739399,
        134648828315525022475464726549943582870,
        51090196246095967089934224945482105880,
        9727325530149537115738878268149062474,
    );
    let res: Uint256 = fbn254.fast_u512_modulo_bn254p(N);

    %{ print_u_256_info(ids.res,"e0") %}

    return ();
}

@external
func test_slow_mod512{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    __setup__();
    let N = Uint512(
        212472832437159906265623935117356739399,
        134648828315525022475464726549943582870,
        51090196246095967089934224945482105880,
        9727325530149537115738878268149062474,
    );
    let res: Uint256 = fbn254.u512_modulo_bn254p(N);

    %{ print_u_256_info(ids.res,"e0") %}

    return ();
}

@external
func test_slow_mod256{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    __setup__();
    let N = Uint256(P_low - 123098, P_high - 132089);

    let res: Uint256 = fbn254.slow_add(N, N);

    %{ print_u_256_info(ids.res,"e0") %}

    return ();
}
@external
func test_fast_mod256{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    __setup__();
    let N = Uint256(P_low - 123098, P_high - 132089);

    let res: Uint256 = fbn254.add(N, N);

    %{ print_u_256_info(ids.res,"e0") %}

    return ();
}

@external
func test_mod_mul_classic{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    __setup__();
    let X = Uint256(
        201385395114098847380338600778089168076, 64323764613183177041862057485226039389
    );
    let Y = Uint256(75392519548959451050754627114999798041, 55134655382728437464453192130193748048);
    let res: Uint256 = fbn254.mul(X, Y);

    return ();
}

@external
func test_mul_classic{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    __setup__();
    let X = Uint256(
        201385395114098847380338600778089168076, 64323764613183177041862057485226039389
    );
    let Y = Uint256(75392519548959451050754627114999798041, 55134655382728437464453192130193748048);
    let res = u255.mul(X, Y);

    return ();
}

@external
func test_mul_poly{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    __setup__();
    // P - 123
    let X = Polyfelt(4965661367192848759, 5, 24, 36, 36);
    // P - P//7
    let Y = Polyfelt(2837520781253056505, 2837520781253056508, 20, 4256281171879584786, 30);
    let res: Polyfelt = fbn254.mul_polyfelt(X, Y);

    return ();
}
