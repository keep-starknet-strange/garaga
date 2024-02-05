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
from starkware.cairo.common.registers import get_fp_and_pc

from starkware.cairo.common.alloc import alloc
from src.extension_field_tricks.fp6 import mul_trick_e6, PolyAcc66
from src.bn254.towers.e6 import (
    mul_trick_e6 as mt6,
    E6full,
    BigInt3,
    ZPowers5,
    PolyAcc6,
    E6DirectUnreduced,
    E5full,
    UnreducedBigInt3,
    Uint256,
)
from starkware.cairo.common.math import unsigned_div_rem

const P0 = 32324006162389411176778628423;
const P1 = 57042285082623239461879769745;
const P2 = 3486998266802970665;
const P3 = 0;

const N_LIMBS = 4;
const BASE = 2 ** 96;

func div_ceil{range_check_ptr}(x: felt, y: felt) -> felt {
    let (q, r) = unsigned_div_rem(x, y);
    if (r != 0) {
        return q + 1;
    } else {
        return q;
    }
}

// FINAL EXP INITIALIZATION OFFSETS STRUCTURE:
// 0: xy_init
// 4: r0
// 8: r1
// 12: r2
// 16: r3
// 20: r4
// 24: r5

func main{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    %{
        import functools
        def rgetattr(obj, attr, *args):
            def _getattr(obj, attr):
                return getattr(obj, attr, *args)
            return functools.reduce(_getattr, [obj] + attr.split('.'))
        def rsetattr(obj, attr, val):
            pre, _, post = attr.rpartition('.')
            return setattr(rgetattr(obj, pre) if pre else obj, post, val)
    %}
    tempvar x_ptr = new E6full(
        BigInt3(1, 2, 3),
        BigInt3(4, 5, 6),
        BigInt3(7, 8, 9),
        BigInt3(10, 11, 12),
        BigInt3(13, 14, 15),
        BigInt3(16, 17, 18),
    );
    tempvar z_pow1_5_ptr = cast(x_ptr, ZPowers5*);
    local zero_e6full: E6DirectUnreduced = E6DirectUnreduced(
        UnreducedBigInt3(0, 0, 0),
        UnreducedBigInt3(0, 0, 0),
        UnreducedBigInt3(0, 0, 0),
        UnreducedBigInt3(0, 0, 0),
        UnreducedBigInt3(0, 0, 0),
        UnreducedBigInt3(0, 0, 0),
    );

    local zero_e5full: E5full = E5full(
        Uint256(0, 0), Uint256(0, 0), Uint256(0, 0), Uint256(0, 0), Uint256(0, 0)
    );

    local zero_bigint3: UnreducedBigInt3 = UnreducedBigInt3(0, 0, 0);
    local poly_acc_f: PolyAcc6 = PolyAcc6(xy=zero_bigint3, q=zero_e5full, r=zero_e6full);
    let poly_acc = &poly_acc_f;

    let continuable_hash = 0;
    with x_ptr, z_pow1_5_ptr, continuable_hash, poly_acc {
        let HHH = mt6(x_ptr, x_ptr);
    }

    tempvar p = UInt384(d0=P0, d1=P1, d2=P2, d3=P3);

    // test_z_powers();
    tempvar values_ptr_start: UInt384* = cast(range_check96_ptr, UInt384*);
    let values_ptr = values_ptr_start;
    let (add_offsets_ptr: felt*) = alloc();
    let (mul_offsets_ptr: felt*) = alloc();
    tempvar mul_offsets_ptr_start = mul_offsets_ptr;
    tempvar add_offsets_ptr_start = add_offsets_ptr;

    let Z = UInt384(d0=2, d1=0, d2=0, d3=0);

    // Build Z, ... , Z**6.
    assert values_ptr[0] = Z;
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

    // Initialize Σ (c_i * X_i(z) * Y_i(z)) to 0. (As UInt384)
    assert values_ptr[6] = UInt384(d0=0, d1=0, d2=0, d3=0);
    // Initialize Σ (c_i * Ri) to 0. (As degree 5 polynomial)
    assert values_ptr[7] = UInt384(d0=0, d1=0, d2=0, d3=0);  // r0
    assert values_ptr[8] = UInt384(d0=0, d1=0, d2=0, d3=0);  // r1
    assert values_ptr[9] = UInt384(d0=0, d1=0, d2=0, d3=0);  // r2
    assert values_ptr[10] = UInt384(d0=0, d1=0, d2=0, d3=0);  // r3
    assert values_ptr[11] = UInt384(d0=0, d1=0, d2=0, d3=0);  // r4
    assert values_ptr[12] = UInt384(d0=0, d1=0, d2=0, d3=0);  // r5

    %{
        from src.hints.fq import fill_bigint_array
        x=[1, 2, 3, 4, 5, 6]
        y=[7, 8, 9, 10, 11, 12]
        fill_bigint_array(x, ids.values_ptr, ids.N_LIMBS, ids.BASE, 13)
        fill_bigint_array(y, ids.values_ptr, ids.N_LIMBS, ids.BASE, 13+6)
    %}
    let n_u384 = 6 + 7 + 6 + 6;
    let continuable_hash = 0;
    tempvar poly_acc6 = new PolyAcc66(xy_offset=0, R_offset=1);
    tempvar range_check96_ptr = range_check96_ptr + n_u384 * UInt384.SIZE;

    // let mul_mod_n = 5;
    // assert mul_mod_ptr[0] = ModBuiltin(
    //     p=p, values_ptr=values_ptr_start, offsets_ptr=mul_offsets_ptr_start, n=8
    // );

    // %{
    //     from starkware.cairo.lang.builtins.modulo.mod_builtin_runner import ModBuiltinRunner

    // ModBuiltinRunner.fill_memory(
    //         memory=memory,
    //         add_mod=None,
    //         mul_mod=(ids.mul_mod_ptr.address_, builtin_runners["mul_mod_builtin"], ids.mul_mod_n),
    //     )
    // %}

    tempvar mul_offsets_ptr = mul_offsets_ptr_start + 15;
    let mul_mod_n = 5;
    let add_mod_n = 0;

    with values_ptr, mul_mod_n, add_mod_n, n_u384, continuable_hash, poly_acc6, mul_offsets_ptr, add_offsets_ptr {
        mul_trick_e6(x_offset=13, y_offset=13 + 6);
    }

    let add_mod_n_instances = div_ceil(add_mod_n, 8);
    assert add_mod_ptr[0] = ModBuiltin(
        p=p,
        values_ptr=values_ptr_start,
        offsets_ptr=add_offsets_ptr_start,
        n=add_mod_n_instances * 8,
    );
    let mul_mod_n_instances = div_ceil(mul_mod_n, 8);
    assert mul_mod_ptr[0] = ModBuiltin(
        p=p,
        values_ptr=values_ptr_start,
        offsets_ptr=mul_offsets_ptr_start,
        n=mul_mod_n_instances * 8,
    );

    // assert add_offsets_ptr[0] = 0;
    // assert add_offsets_ptr[1] = 0;
    // assert add_offsets_ptr[2] = 0;
    // assert add_offsets_ptr[3] = 0;
    // assert add_offsets_ptr[4] = 0;
    // assert add_offsets_ptr[5] = 0;
    // assert add_offsets_ptr[6] = 0;
    // assert add_offsets_ptr[7] = 0;

    %{
        from starkware.cairo.lang.builtins.modulo.mod_builtin_runner import ModBuiltinRunner
        print(f"Add_mod_n : {ids.add_mod_n}, Mul_mod_n : {ids.mul_mod_n}")
        ModBuiltinRunner.fill_memory(
            memory=memory,
            add_mod=(ids.add_mod_ptr.address_, builtin_runners["add_mod_builtin"], ids.add_mod_n),
            mul_mod=(ids.mul_mod_ptr.address_, builtin_runners["mul_mod_builtin"], ids.mul_mod_n),
        )
    %}

    let mul_mod_ptr = mul_mod_ptr + ModBuiltin.SIZE * mul_mod_n_instances;
    let add_mod_ptr = add_mod_ptr + ModBuiltin.SIZE * add_mod_n_instances;

    return ();
}

func test_z_powers{
    range_check_ptr,
    bitwise_ptr: BitwiseBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}() {
    alloc_locals;

    tempvar p = UInt384(d0=P0, d1=P1, d2=P2, d3=P3);
    tempvar z = UInt384(d0=12345, d1=0, d2=0, d3=0);
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

    // assert mul_offsets_ptr[21] = 0;
    // assert mul_offsets_ptr[22] = 0;
    // assert mul_offsets_ptr[23] = 32;

    assert mul_mod_ptr[0] = ModBuiltin(
        p=p, values_ptr=values_ptr, offsets_ptr=mul_offsets_ptr, n=8
    );

    let mul_mod_n = 7;

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
        from src.hints.fq import bigint_pack, get_p, pack_bigint_array
        arr = pack_bigint_array(ids.values_ptr, 4, 2**96, 9)
        print(f'arr = {arr}')
        p = get_p(ids)
        print(f'p = {p}')
        z = bigint_pack(ids.z, 4, 2**96)

        z2 = bigint_pack(ids.z2, 4, 2**96)
        z3 = bigint_pack(ids.z3, 4, 2**96)
        z4 = bigint_pack(ids.z4, 4, 2**96)
        z5 = bigint_pack(ids.z5, 4, 2**96)

        print(f'z = {z}')
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
