%builtins output range_check bitwise

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import split_felt

from starkware.cairo.common.cairo_secp.bigint import nondet_bigint3, BigInt3, BASE, UnreducedBigInt5

struct BigInt6 {
    d0: felt,
    d1: felt,
    d2: felt,
    d3: felt,
    d4: felt,
    d5: felt,
}

const BASE_SQ = 2 ** 172;
const TWO_127 = 2 ** 127;
const P3 = 0x80000000000001100000;

func bigint_mul_pstark(x: BigInt3) -> (res: UnreducedBigInt5) {
    let res = UnreducedBigInt5(
        d0=x.d0,
        d1=x.d1,
        d2=x.d0 * 0x80000000000001100000 + x.d2,
        d3=x.d1 * 0x80000000000001100000,
        d4=x.d2 * 0x80000000000001100000,
    );
    return (res=res);
}

func full_mul{range_check_ptr}(a, b) -> (ab_low: felt, ab_high: felt) {
    alloc_locals;
    local ab_full: BigInt6;
    %{
        PRIME = 2 ** 251 + 17 * 2 ** 192 + 1
        ab= ids.a*ids.b 
        def split(num: int, num_bits_shift: int, length: int):
            a = []
            for _ in range(length):
                a.append( num & ((1 << num_bits_shift) - 1) )
                num = num >> num_bits_shift
            return tuple(a)
        ab_split = split(ab, 86, 6)

        ids.ab_full.d0=ab_split[0]
        ids.ab_full.d1=ab_split[1]
        ids.ab_full.d2=ab_split[2]
        ids.ab_full.d3=ab_split[3]
        ids.ab_full.d4=ab_split[4]
        ids.ab_full.d5=ab_split[5]

        ab_high = value = ab // PRIME
    %}
    let (ab_high) = nondet_bigint3();
    %{ ab_mod_P = value = ab % PRIME %}
    let (ab_mod_P) = nondet_bigint3();
    assert a * b = ab_mod_P.d0 + ab_mod_P.d1 * BASE + ab_mod_P.d2 * BASE_SQ;

    // Verify ab_full - ab_mod_P = ab_high * P_STARK.

    tempvar carry1 = (ab_full.d0 - ab_mod_P.d0 - ab_high.d0) / BASE;
    assert [range_check_ptr] = carry1 + TWO_127;

    tempvar carry2 = (ab_full.d1 - ab_mod_P.d1 - ab_high.d1 + carry1) / BASE;
    assert [range_check_ptr + 1] = carry2 + TWO_127;

    tempvar carry3 = (ab_full.d2 - ab_mod_P.d2 - ab_high.d0 * P3 - ab_high.d2 + carry2) / BASE;
    assert [range_check_ptr + 2] = carry3 + TWO_127;

    tempvar carry4 = (ab_full.d3 - ab_high.d1 * P3 + carry3) / BASE;
    assert [range_check_ptr + 3] = carry4 + TWO_127;

    tempvar carry5 = (ab_full.d4 - ab_high.d2 * P3 + carry4) / BASE;
    assert [range_check_ptr + 4] = carry5 + TWO_127;
    assert ab_full.d5 + carry5 = 0;

    let range_check_ptr = range_check_ptr + 5;

    return (a * b, ab_high.d0 + ab_high.d1 * BASE + ab_high.d2 * BASE_SQ);
}

func _full_mul{range_check_ptr}(a, b) -> (ab_low: felt, ab_high: felt) {
    alloc_locals;
    local ab_full: BigInt6;
    %{
        PRIME = 2 ** 251 + 17 * 2 ** 192 + 1
        ab= ids.a*ids.b 
        def split(num: int, num_bits_shift: int, length: int):
            a = []
            for _ in range(length):
                a.append( num & ((1 << num_bits_shift) - 1) )
                num = num >> num_bits_shift
            return tuple(a)
        ab_split = split(ab, 86, 6)
        ids.ab_full.d0=ab_split[0]
        ids.ab_full.d1=ab_split[1]
        ids.ab_full.d2=ab_split[2]
        ids.ab_full.d3=ab_split[3]
        ids.ab_full.d4=ab_split[4]
        ids.ab_full.d5=ab_split[5]

        ab_high = value = ab // PRIME
    %}
    let (ab_high) = nondet_bigint3();
    %{ ab_mod_P = value = ab % PRIME %}
    let (ab_mod_P) = nondet_bigint3();
    assert a * b = ab_mod_P.d0 + ab_mod_P.d1 * BASE + ab_mod_P.d2 * BASE_SQ;

    local ab_high_P_STARK: UnreducedBigInt5 = UnreducedBigInt5(
        d0=ab_high.d0,
        d1=ab_high.d1,
        d2=ab_high.d0 * 0x80000000000001100000 + ab_high.d2,
        d3=ab_high.d1 * 0x80000000000001100000,
        d4=ab_high.d2 * 0x80000000000001100000,
    );

    // Verify ab_full - ab_mod_P = ab_high * P_STARK.

    tempvar carry1 = (ab_full.d0 - ab_mod_P.d0 - ab_high_P_STARK.d0) / BASE;
    assert [range_check_ptr] = carry1 + TWO_127;

    tempvar carry2 = (ab_full.d1 - ab_mod_P.d1 - ab_high_P_STARK.d1 + carry1) / BASE;
    assert [range_check_ptr + 1] = carry2 + TWO_127;

    tempvar carry3 = (ab_full.d2 - ab_mod_P.d2 - ab_high_P_STARK.d2 + carry2) / BASE;
    assert [range_check_ptr + 2] = carry3 + TWO_127;

    tempvar carry4 = (ab_full.d3 - ab_high_P_STARK.d3 + carry3) / BASE;
    assert [range_check_ptr + 3] = carry4 + TWO_127;

    tempvar carry5 = (ab_full.d4 - ab_high_P_STARK.d4 + carry4) / BASE;
    assert [range_check_ptr + 4] = carry5 + TWO_127;
    assert ab_full.d5 + carry5 = 0;

    let range_check_ptr = range_check_ptr + 5;

    return (a * b, ab_high.d0 + ab_high.d1 * BASE + ab_high.d2 * BASE_SQ);
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
