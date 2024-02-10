from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin, UInt384
from starkware.cairo.common.modulo import run_mod_p_circuit
from src.definitions import get_P, E12D, ExtFCircuitInfo, get_final_exp_circuit
from src.utils import (
    get_Z_and_RLC_from_transcript,
    write_felts_to_value_segment,
    assert_limbs_at_index_are_equal,
)

func multi_miller_loop{
    range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}() -> E12D {
}

func final_exponentiation{
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(input: E12D, curve_id: felt) -> felt {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let p: UInt384 = get_P(curve_id);
    let (
        constants_ptr: felt*,
        constants_ptr_len: felt,
        add_offsets: felt*,
        mul_offsets: felt*,
        commitments_len: felt,
        transcript_indexes: felt*,
        N_Euclidean_equations: felt,
    ) = get_final_exp_circuit(curve_id);

    let values_ptr = cast(range_check96_ptr, UInt384*);
    memcpy(dst=range_check96_ptr, src=constants_ptr, len=constants_ptr_len);  // write(Constants)
    memcpy(dst=range_check96_ptr + constants_ptr_len, src=&input, len=E12D.SIZE);  // write(Input)

    local commitments: felt*;
    %{
        from src.precompiled_circuits.final_exp import get_final_exp_circuit
        FinalExpCircuit = get_final_exp_circuit(ids.curve_id)
        FinalExpCircuit.run(
            range_check96_ptr=range_check96_ptr,
            add_mod_ptr=add_mod_ptr,
            mul_mod_ptr=mul_mod_ptr
        )
        ids.commitments = segments.gen_arg(commitments)
    %}

    memcpy(
        dst=range_check96_ptr + constants_ptr_len + E12D.SIZE, src=commitments, len=commitments_len
    );  // write(Commitments)

    let (local Z: felt, local RLC_coeffs: felt*) = get_Z_and_RLC_from_transcript(
        transcript_start=cast(values_ptr, felt*) + constants_ptr_len,
        poseidon_ptr_indexes=transcript_indexes,
        n_elements_in_transcript=E12D.SIZE + commitments_len,
        n_equations=N_Euclidean_equations,
    );

    tempvar range_check96_ptr = range_check96_ptr + constants_ptr_len + E12D.SIZE + commitments_len;
    write_felts_to_value_segment(felts=&Z, n=1);
    write_felts_to_value_segment(felts=RLC_coeffs, n=N_Euclidean_equations);

    run_mod_p_circuit(
        p=p,
        values_ptr=values_ptr,
        add_mod_offsets_ptr=add_offsets,
        add_mod_n=2,
        mul_mod_offsets_ptr=mul_offsets,
        mul_mod_n=2,
    );
}
