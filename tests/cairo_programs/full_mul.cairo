%builtins output range_check bitwise

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import split_felt
from tests.cairo_programs.libs.u255 import Uint512

func full_mul{range_check_ptr}(a, b) -> (ab_low: felt, ab_high: felt) {
    alloc_locals;
    local ab_high_low;  // first 128 bits
    local ab_high_high;  // last 124 bits
    local ab_full: Uint512;
    %{
        PRIME = 2 ** 251 + 17 * 2 ** 192 + 1
        ab= ids.a*ids.b 
        def split(num: int, num_bits_shift: int, length: int):
            a = []
            for _ in range(length):
                a.append( num & ((1 << num_bits_shift) - 1) )
                num = num >> num_bits_shift
            return tuple(a)
        ab_split = split(ab, 128, 4)
        ids.ab_full.d0=ab_split[0]
        ids.ab_full.d1=ab_split[1]
        ids.ab_full.d2=ab_split[2]
        ids.ab_full.d3=ab_split[3]

        ab_high= ab // PRIME
        ab_high_split = (ab_high & ((1 << 128) - 1), ab_high >> 128)
        ids.ab_high_low=ab_high_split[0]
        ids.ab_high_high=ab_high_split[1]
        print("bit", ab_high_split[1].bit_length())
    %}
    assert [range_check_ptr] = ab_high_low;
    assert [range_check_ptr + 1] = ab_high_high - 1 + 2 ** 128 -
        10633823966279327296825105735305134079;
    let range_check_ptr = range_check_ptr + 2;

    let (ab_mod_P_high, ab_mod_P_low) = split_felt(a * b);

    let ab_full_minus_ab_mod_P = Uint512(
        ab_full.d0 - ab_mod_P_low, ab_full.d1 - ab_mod_P_high, ab_full.d2, ab_full.d3
    );

    // TODO : verify that ab_full_congruent_to_P is divisible by ab_high.

    return (a * b, ab_high_low + ab_high_high * 2 ** 128);
}

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
            print(f" {un}_{u.bit_length()}bits = {bin(u)}")
            print(f" {un} = {u}")
            #print(f" {un} = {int.to_bytes(u, 8, 'little')}")
    %}
    alloc_locals;
    let P_STARK = 2 ** 251 + 17 * 2 ** 192 + 1;
    let x = P_STARK - 1;
    let y = 2 ** 136 + 7;
    let y = x;
    let (res_low, res_high) = full_mul(x, y);
    %{
        print_felt_info(ids.x, 'P_STARK - 1')
        print_felt_info(ids.res_low, 'res_low')
        print_felt_info(ids.res_high, 'res_high')

        print_felt_info(ids.x*ids.y, 'x*y full')
        print(ids.x*ids.y==(ids.res_low + ids.res_high*PRIME))
    %}
    return ();
}
