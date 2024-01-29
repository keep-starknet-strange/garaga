%builtins range_check bitwise poseidon range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import (
    ModBuiltin,
    UInt384,
    PoseidonBuiltin,
    BitwiseBuiltin,
)
from starkware.cairo.common.registers import get_label_location
from starkware.cairo.common.modulo import run_mod_p_circuit
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.alloc import alloc

const P0 = 32324006162389411176778628423;
const P1 = 57042285082623239461879769745;
const P2 = 3486998266802970665;
const P3 = 0;

const N_LIMBS = 4;
const BASE = 2 ** 96;

func main{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}() {
    alloc_locals;

    tempvar p = UInt384(d0=P0, d1=P1, d2=P2, d3=P3);
    tempvar z = UInt384(d0=1, d1=1, d2=1, d3=1);
    let values_ptr = cast(range_check96_ptr, UInt384*);
    let (add_offsets_ptr: felt*) = alloc();
    let (mul_offsets_ptr: felt*) = alloc();
    assert values_ptr[0] = z;

    // Z**2
    assert mul_offsets_ptr[0] = 0;
    assert mul_offsets_ptr[1] = 0;
    assert mul_offsets_ptr[2] = 4;
    // Z**3
    assert mul_offsets_ptr[3] = 0;
    assert mul_offsets_ptr[4] = 4;
    assert mul_offsets_ptr[5] = 8;
    // Z**4
    assert mul_offsets_ptr[6] = 0;
    assert mul_offsets_ptr[7] = 8;
    assert mul_offsets_ptr[8] = 12;
    // Z**5
    assert mul_offsets_ptr[9] = 0;
    assert mul_offsets_ptr[10] = 12;
    assert mul_offsets_ptr[11] = 16;
    // Z**6
    assert mul_offsets_ptr[12] = 0;
    assert mul_offsets_ptr[13] = 16;
    assert mul_offsets_ptr[14] = 20;

    // Dummy until 24
    assert mul_offsets_ptr[15] = 0;
    assert mul_offsets_ptr[16] = 0;
    assert mul_offsets_ptr[17] = 24;

    assert mul_offsets_ptr[18] = 0;
    assert mul_offsets_ptr[19] = 0;
    assert mul_offsets_ptr[20] = 28;

    assert mul_offsets_ptr[21] = 0;
    assert mul_offsets_ptr[22] = 0;
    assert mul_offsets_ptr[23] = 32;

    // assert add_mod_ptr[0] = ModBuiltin(
    //     p=p, values_ptr=values_ptr, offsets_ptr=add_offsets_ptr, n=3
    // );
    assert mul_mod_ptr[0] = ModBuiltin(
        p=p, values_ptr=values_ptr, offsets_ptr=mul_offsets_ptr, n=8
    );

    let mul_mod_n = 8;

    %{
        from starkware.cairo.lang.builtins.modulo.mod_builtin_runner import ModBuiltinRunner
        ModBuiltinRunner.fill_memory(memory=memory, add_mod=None, mul_mod=(ids.mul_mod_ptr.address_, builtin_runners['mul_mod_builtin'], ids.mul_mod_n))
    %}

    let mul_mod_ptr = mul_mod_ptr + ModBuiltin.SIZE;
    let range_check96_ptr = range_check96_ptr + mul_mod_n * UInt384.SIZE + 4;

    tempvar z2 = [cast(values_ptr + 4, UInt384*)];
    tempvar z3 = [cast(values_ptr + 8, UInt384*)];
    tempvar z4 = [cast(values_ptr + 12, UInt384*)];
    tempvar z5 = [cast(values_ptr + 16, UInt384*)];

    %{
        from src.hints.fq import bigint_pack, get_p
        p = get_p(ids)
        print(f'p = {p}')
        z = bigint_pack(ids.z, 4, 2**96)
        z2 = bigint_pack(ids.z2, 4, 2**96)
        z3 = bigint_pack(ids.z3, 4, 2**96)
        z4 = bigint_pack(ids.z4, 4, 2**96)
        z5 = bigint_pack(ids.z5, 4, 2**96)

        print(f'z2 = {z2}')
        print(f'z3 = {z3}')
        print(f'z4 = {z4}')
        print(f'z5 = {z5}')

        assert z**2 % p == z2
        assert z**3 % p == z3
        assert z**4 % p == z4
        assert z**5 % p == z5
    %}

    return ();
}
