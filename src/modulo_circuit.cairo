from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin, UInt384
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.modulo import run_mod_p_circuit

from src.definitions import get_P, BASE, N_LIMBS
from src.precompiled_circuits.sample import get_sample_circuit
from src.utils import (
    get_Z_and_RLC_from_transcript,
    write_felts_to_value_segment,
    assert_limbs_at_index_are_equal,
)
func run_extension_field_modulo_circuit{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(input: felt*, input_len: felt, curve_id: felt, circuit_id: felt) -> felt {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let p: UInt384 = get_P(curve_id);
    let (
        constants_ptr: felt*,
        add_offsets_ptr: felt*,
        mul_offsets_ptr: felt*,
        left_assert_eq_offsets_ptr: felt*,
        right_assert_eq_offsets_ptr: felt*,
        poseidon_indexes_ptr: felt*,
        constants_ptr_len: felt,
        add_mod_n: felt,
        mul_mod_n: felt,
        commitments_len: felt,
        assert_eq_len: felt,
        N_Euclidean_equations: felt,
    ) = get_sample_circuit(circuit_id);

    local values_ptr: UInt384* = cast(range_check96_ptr, UInt384*);
    memcpy(dst=range_check96_ptr, src=constants_ptr, len=constants_ptr_len * N_LIMBS);  // write(Constants)
    memcpy(dst=range_check96_ptr + constants_ptr_len * N_LIMBS, src=input, len=input_len);  // write(Input)

    local commitments: felt*;
    %{
        from src.precompiled_circuits.sample import get_sample_circuit
        from src.hints.io import pack_bigint_ptr, flatten
        from src.definitions import CURVES, PyFelt
        p = CURVES[ids.curve_id].p
        circuit_input = pack_bigint_ptr(memory, ids.input, ids.N_LIMBS, ids.BASE, ids.input_len//ids.N_LIMBS)
        circuit_input = [PyFelt(x, p) for x in circuit_input]
        EXTF_MOD_CIRCUIT = get_sample_circuit(ids.circuit_id, circuit_input)
        commitments = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in EXTF_MOD_CIRCUIT.commitments])
        ids.commitments = segments.gen_arg(commitments)
        print(len(commitments), len(commitments)//4)
    %}

    memcpy(
        dst=range_check96_ptr + constants_ptr_len * N_LIMBS + input_len,
        src=commitments,
        len=commitments_len * N_LIMBS,
    );  // write(Commitments)

    let (local Z: felt, local RLC_coeffs: felt*) = get_Z_and_RLC_from_transcript(
        transcript_start=cast(values_ptr, felt*) + constants_ptr_len,
        poseidon_indexes_ptr=poseidon_indexes_ptr,
        n_elements_in_transcript=commitments_len,
        n_equations=N_Euclidean_equations,
    );

    tempvar range_check96_ptr = range_check96_ptr + constants_ptr_len * N_LIMBS + input_len +
        commitments_len * N_LIMBS;
    write_felts_to_value_segment(values=&Z, n=1);
    write_felts_to_value_segment(values=RLC_coeffs, n=N_Euclidean_equations);

    run_mod_p_circuit(
        p=p,
        values_ptr=values_ptr,
        add_mod_offsets_ptr=add_offsets_ptr,
        add_mod_n=add_mod_n,
        mul_mod_offsets_ptr=mul_offsets_ptr,
        mul_mod_n=mul_mod_n,
    );

    // assert_limbs_at_index_are_equal(
    //     values_ptr, left_assert_eq_offsets_ptr, right_assert_eq_offsets_ptr, assert_eq_len
    // );

    return 0;
}
