from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin, UInt384
from starkware.cairo.common.math import assert_nn_le
from starkware.cairo.common.math_cmp import is_in_range
from definitions import E12D, E6D, is_zero_E6D, one_E6D, zero_E12D, one_E12D, G1G2Pair
from starkware.cairo.common.alloc import alloc
from precompiled_circuits.final_exp import (
    get_FINAL_EXP_PART_1_circuit,
    get_FINAL_EXP_PART_2_circuit,
)
from ec_ops import is_on_curve_g1_g2

from precompiled_circuits.multi_miller_loop import get_MULTI_MILLER_LOOP_circuit

const TRUE = 1;
const FALSE = 0;

from modulo_circuit import (
    run_extension_field_modulo_circuit,
    run_extension_field_modulo_circuit_continuation,
)

func all_g1_g2_pairs_are_on_curve{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(input: felt*, n: felt, curve_id: felt) -> (res: felt) {
    alloc_locals;
    if (n == 0) {
        return (res=TRUE);
    } else {
        let (check) = is_on_curve_g1_g2(curve_id, input);
        if (check == TRUE) {
            return all_g1_g2_pairs_are_on_curve(input + G1G2Pair.SIZE, n - 1, curve_id);
        } else {
            return (res=FALSE);
        }
    }
}

func multi_pairing{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(input: G1G2Pair*, n: felt, curve_id: felt) -> (res: E12D) {
    alloc_locals;
    let is_n_pair_supported = is_in_range(n, 1, 4);
    if (is_n_pair_supported == FALSE) {
        let (local res: E12D) = zero_E12D();
        return (res=res);
    }
    let (all_on_curve) = all_g1_g2_pairs_are_on_curve(input, n, curve_id);
    if (all_on_curve == FALSE) {
        let (res) = zero_E12D();
        return (res=res);
    }
    let (m) = multi_miller_loop(cast(input, felt*), n, curve_id);

    let (f) = final_exponentiation(m, curve_id);

    return (res=f);
}

func multi_miller_loop{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(input: felt*, n: felt, curve_id: felt) -> (res: E12D*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (circuit) = get_MULTI_MILLER_LOOP_circuit(curve_id=curve_id, n_pairs=n);
    let (output: felt*, _) = run_extension_field_modulo_circuit(circuit, input);
    return (res=cast(output, E12D*));
}

func final_exponentiation{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(input: E12D*, curve_id: felt) -> (res: E12D) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();

    local num: E6D = E6D(
        v0=input.w0, v1=input.w2, v2=input.w4, v3=input.w6, v4=input.w8, v5=input.w10
    );
    local den: E6D = E6D(
        v0=input.w1, v1=input.w3, v2=input.w5, v3=input.w7, v4=input.w9, v5=input.w11
    );
    let (local circuit_input: felt*) = alloc();
    memcpy(dst=circuit_input, src=cast(&num, felt*), len=24);

    let (den_is_zero) = is_zero_E6D(den, curve_id);
    if (den_is_zero == TRUE) {
        let (local one_E6: E6D) = one_E6D();
        memcpy(dst=circuit_input + 24, src=cast(&one_E6, felt*), len=24);
    } else {
        memcpy(dst=circuit_input + 24, src=cast(&den, felt*), len=24);
    }

    let (local circuit) = get_FINAL_EXP_PART_1_circuit(curve_id);
    let (output: felt*, Z: felt) = run_extension_field_modulo_circuit(circuit, circuit_input);
    // %{
    //     part1 = pack_bigint_ptr(memory, ids.output, 4, 2**96, ids.circuit.output_len//4)
    //     for x in part1:
    //         print(f"T0/T2/_SUM = {hex(x)}")
    // %}
    let _sum = [cast(output + 2 * E6D.SIZE, E6D*)];
    let (_sum_is_zero) = is_zero_E6D(_sum, curve_id);

    if (_sum_is_zero == TRUE) {
        let (one_E12: E12D) = one_E12D();
        return (res=one_E12);
    } else {
        let (circuit) = get_FINAL_EXP_PART_2_circuit(curve_id);
        let (output: felt*, _: felt) = run_extension_field_modulo_circuit_continuation(
            circuit, output, Z
        );
        return (res=[cast(output, E12D*)]);
    }
}
