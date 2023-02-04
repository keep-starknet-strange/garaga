%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from src.towers.e12 import E12, e12
from src.towers.e6 import E6, e6
from src.towers.e2 import E2, e2

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

@view
func test_add{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    local res;
    %{
        import subprocess
        command = "./tools/parser_go/main"
        op = "add"
        x = [1,2]
        y = [3,4]
        query = f'{command} {op} {x[0]} {x[1]} {y[0]} {y[1]}'
        result = subprocess.check_output(command, shell=True)
        [a,b]= result[2:-2].split('] [')
        e0 = map(int,a.split(' '))
        e0 = e0[0] + e0[1]*2**64 e0[2]*2**(64*2) + e0[3]*2**(64*3)
        e1 = map(int,a.split(' '))
        e1 = e1[0] + e1[1]*2**64 e1[2]*2**(64*2) + e1[3]*2**(64*3)
        memory[ids.res.address_ + 0] = e0
        memory[ids.res.address_ + 1] = e1
        print(e1, e2)
    %}
    assert 1 = 1;
    return ();
}
