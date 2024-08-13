from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin, UInt384
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.modulo import run_mod_p_circuit

from definitions import get_P, BASE, N_LIMBS, is_curve_id_supported, SUPPORTED_CURVE_ID
from utils import get_Z_and_RLC_from_transcript, write_felts_to_value_segment, retrieve_output

struct ExtensionFieldModuloCircuit {
    constants_ptr: felt*,
    add_offsets_ptr: felt*,
    mul_offsets_ptr: felt*,
    output_offsets_ptr: felt*,
    poseidon_indexes_ptr: felt*,
    constants_ptr_len: felt,
    input_len: felt,
    commitments_len: felt,
    witnesses_len: felt,
    output_len: felt,
    continuous_output: felt,
    add_mod_n: felt,
    mul_mod_n: felt,
    n_assert_eq: felt,
    N_Euclidean_equations: felt,
    name: felt,
    curve_id: felt,
}

struct ModuloCircuit {
    constants_ptr: felt*,
    add_offsets_ptr: felt*,
    mul_offsets_ptr: felt*,
    output_offsets_ptr: felt*,
    constants_ptr_len: felt,
    input_len: felt,
    witnesses_len: felt,
    output_len: felt,
    continuous_output: felt,
    add_mod_n: felt,
    mul_mod_n: felt,
    n_assert_eq: felt,
    name: felt,
    curve_id: felt,
}

func get_void_modulo_circuit() -> (circuit: ModuloCircuit*) {
    return (cast(-1, ModuloCircuit*),);
}
func get_void_extension_field_modulo_circuit() -> (circuit: ExtensionFieldModuloCircuit*) {
    return (cast(-1, ExtensionFieldModuloCircuit*),);
}

func run_modulo_circuit{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(circuit: ModuloCircuit*, input: felt*) -> (output: felt*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let p: UInt384 = get_P(circuit.curve_id);
    local values_ptr: UInt384* = cast(range_check96_ptr, UInt384*);
    memcpy(
        dst=range_check96_ptr, src=circuit.constants_ptr, len=circuit.constants_ptr_len * N_LIMBS
    );  // write(Constants)
    memcpy(
        dst=range_check96_ptr + circuit.constants_ptr_len * N_LIMBS,
        src=input,
        len=circuit.input_len,
    );  // write(Input)

    %{
        from garaga.precompiled_circuits.all_circuits import ALL_FUSTAT_CIRCUITS, CircuitID
        from garaga.hints.io import pack_bigint_ptr, fill_felt_ptr, flatten, bigint_split
        from garaga.definitions import CURVES, PyFelt
        p = CURVES[ids.circuit.curve_id].p
        circuit_input = pack_bigint_ptr(memory, ids.input, ids.N_LIMBS, ids.BASE, ids.circuit.input_len//ids.N_LIMBS)
        MOD_CIRCUIT = ALL_FUSTAT_CIRCUITS[CircuitID(ids.circuit.name)]['class'](ids.circuit.curve_id, auto_run=False)
        MOD_CIRCUIT = MOD_CIRCUIT.run_circuit(circuit_input)

        witnesses = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in MOD_CIRCUIT.witnesses])

        fill_felt_ptr(x=witnesses, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len)
        #MOD_CIRCUIT.print_value_segment()
    %}

    run_mod_p_circuit(
        p=p,
        values_ptr=values_ptr,
        add_mod_offsets_ptr=circuit.add_offsets_ptr,
        add_mod_n=circuit.add_mod_n,
        mul_mod_offsets_ptr=circuit.mul_offsets_ptr,
        mul_mod_n=circuit.mul_mod_n,
    );

    tempvar range_check96_ptr = range_check96_ptr + circuit.input_len + circuit.witnesses_len + (
        circuit.constants_ptr_len + circuit.add_mod_n + circuit.mul_mod_n - circuit.n_assert_eq
    ) * N_LIMBS;

    let (output: felt*) = retrieve_output(
        values_segment=values_ptr,
        output_offsets_ptr=circuit.output_offsets_ptr,
        n=circuit.output_len,
        continuous_output=circuit.continuous_output,
    );
    return (output=output);
}

func run_extension_field_modulo_circuit{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(circuit: ExtensionFieldModuloCircuit*, input: felt*) -> (output: felt*, Z: felt) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (status) = is_curve_id_supported(circuit.curve_id);
    if (status != SUPPORTED_CURVE_ID) {
        return (cast(-1, felt*), 0);
    }
    let p: UInt384 = get_P(circuit.curve_id);

    local values_ptr: UInt384* = cast(range_check96_ptr, UInt384*);
    memcpy(
        dst=range_check96_ptr, src=circuit.constants_ptr, len=circuit.constants_ptr_len * N_LIMBS
    );  // write(Constants)

    memcpy(
        dst=range_check96_ptr + circuit.constants_ptr_len * N_LIMBS,
        src=input,
        len=circuit.input_len,
    );  // write(Input)

    %{
        from garaga.precompiled_circuits.all_circuits import ALL_FUSTAT_CIRCUITS, CircuitID
        from garaga.hints.io import bigint_split, pack_bigint_ptr, fill_felt_ptr, flatten
        circuit_input = pack_bigint_ptr(memory, ids.input, ids.N_LIMBS, ids.BASE, ids.circuit.input_len//ids.N_LIMBS)
        EXTF_MOD_CIRCUIT = ALL_FUSTAT_CIRCUITS[CircuitID(ids.circuit.name)]['class'](ids.circuit.curve_id, auto_run=False)

        EXTF_MOD_CIRCUIT = EXTF_MOD_CIRCUIT.run_circuit(circuit_input)
        print(f"\t{ids.circuit.constants_ptr_len} Constants and {ids.circuit.input_len//4} Inputs copied to RC_96 memory segment at position {ids.range_check96_ptr}")

        commitments = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in EXTF_MOD_CIRCUIT.commitments])
        witnesses = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in EXTF_MOD_CIRCUIT.witnesses])
        fill_felt_ptr(x=commitments, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len)
        fill_felt_ptr(x=witnesses, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len + ids.circuit.commitments_len)
        print(f"\t{len(commitments)//4} Commitments & {len(witnesses)//4} witnesses computed and filled in RC_96 memory segment at positions {ids.range_check96_ptr+ids.circuit.constants_ptr_len * ids.N_LIMBS+ids.circuit.input_len} and {ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len + ids.circuit.commitments_len}")

        #EXTF_MOD_CIRCUIT.print_value_segment()
    %}

    let (local Z: felt, local RLC_coeffs: felt*) = get_Z_and_RLC_from_transcript(
        transcript_start=cast(values_ptr, felt*) + circuit.constants_ptr_len * N_LIMBS,
        poseidon_indexes_ptr=circuit.poseidon_indexes_ptr,
        n_elements_in_transcript=(circuit.commitments_len + circuit.input_len) / N_LIMBS,
        n_equations=circuit.N_Euclidean_equations,
        init_hash=circuit.name,
        curve_id=circuit.curve_id,
    );
    %{ print(f"\tZ = Hash(Input|Commitments) = Poseidon({(ids.circuit.input_len+ids.circuit.commitments_len)//ids.N_LIMBS} * [Uint384]) computed") %}
    %{ print(f"\tN={ids.circuit.N_Euclidean_equations} felt252 from Poseidon transcript retrieved.") %}

    %{
        # Sanity Check :
        assert ids.Z == EXTF_MOD_CIRCUIT.transcript.continuable_hash, f"Z for circuit {EXTF_MOD_CIRCUIT.name} does not match {hex(ids.Z)} {hex(EXTF_MOD_CIRCUIT.transcript.continuable_hash)}"
    %}

    tempvar range_check96_ptr = range_check96_ptr + circuit.constants_ptr_len * N_LIMBS +
        circuit.input_len + circuit.commitments_len + circuit.witnesses_len;

    write_felts_to_value_segment(values_start=RLC_coeffs, n=circuit.N_Euclidean_equations);
    write_felts_to_value_segment(values_start=&Z, n=1);
    %{ print(f"\tZ and felt252 written to value segment") %}
    %{ print(f"\tRunning ModuloBuiltin circuit...") %}
    run_mod_p_circuit(
        p=p,
        values_ptr=values_ptr,
        add_mod_offsets_ptr=circuit.add_offsets_ptr,
        add_mod_n=circuit.add_mod_n,
        mul_mod_offsets_ptr=circuit.mul_offsets_ptr,
        mul_mod_n=circuit.mul_mod_n,
    );

    tempvar range_check96_ptr = range_check96_ptr + (
        circuit.add_mod_n + circuit.mul_mod_n - circuit.n_assert_eq
    ) * N_LIMBS;

    let (output: felt*) = retrieve_output(
        values_segment=values_ptr,
        output_offsets_ptr=circuit.output_offsets_ptr,
        n=circuit.output_len,
        continuous_output=circuit.continuous_output,
    );
    return (output=output, Z=Z);
}

// Same as run_modulo_circuit, but doesen't hash the inputs and starts with
// an initial hash.
func run_extension_field_modulo_circuit_continuation{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(circuit: ExtensionFieldModuloCircuit*, input: felt*, init_hash: felt) -> (
    output: felt*, Z: felt
) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (status) = is_curve_id_supported(circuit.curve_id);
    if (status != SUPPORTED_CURVE_ID) {
        return (cast(-1, felt*), 0);
    }
    let p: UInt384 = get_P(circuit.curve_id);

    local values_ptr: UInt384* = cast(range_check96_ptr, UInt384*);
    memcpy(
        dst=range_check96_ptr, src=circuit.constants_ptr, len=circuit.constants_ptr_len * N_LIMBS
    );  // write(Constants)

    memcpy(
        dst=range_check96_ptr + circuit.constants_ptr_len * N_LIMBS,
        src=input,
        len=circuit.input_len,
    );  // write(Input)

    %{
        from garaga.precompiled_circuits.all_circuits import ALL_FUSTAT_CIRCUITS, CircuitID
        from garaga.hints.io import bigint_split, pack_bigint_ptr, fill_felt_ptr, flatten
        circuit_input = pack_bigint_ptr(memory, ids.input, ids.N_LIMBS, ids.BASE, ids.circuit.input_len//ids.N_LIMBS)
        EXTF_MOD_CIRCUIT = ALL_FUSTAT_CIRCUITS[CircuitID(ids.circuit.name)]['class'](ids.circuit.curve_id, auto_run=False, init_hash=ids.init_hash)

        EXTF_MOD_CIRCUIT = EXTF_MOD_CIRCUIT.run_circuit(input=circuit_input)
        print(f"\t{ids.circuit.constants_ptr_len} Constants and {ids.circuit.input_len//4} Inputs copied to RC_96 memory segment at position {ids.range_check96_ptr}")

        commitments = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in EXTF_MOD_CIRCUIT.commitments])
        witnesses = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in EXTF_MOD_CIRCUIT.witnesses])
        fill_felt_ptr(x=commitments, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len)
        fill_felt_ptr(x=witnesses, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len + ids.circuit.commitments_len)
        # print(f"continuation segment:, init_hash={hex(ids.init_hash)}")
        #EXTF_MOD_CIRCUIT.print_value_segment()
        print(f"\t{len(commitments)//4} Commitments & {len(witnesses)//4} witnesses computed and filled in RC_96 memory segment at positions {ids.range_check96_ptr+ids.circuit.constants_ptr_len * ids.N_LIMBS+ids.circuit.input_len} and {ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len + ids.circuit.commitments_len}")
    %}

    %{ print(f"\tZ = Hash(Init_Hash|Commitments) = Poseidon(Init_Hash, Poseidon({(ids.circuit.commitments_len)//ids.N_LIMBS} * [Uint384])) computed") %}

    let (local Z: felt, local RLC_coeffs: felt*) = get_Z_and_RLC_from_transcript(
        transcript_start=cast(values_ptr, felt*) + circuit.constants_ptr_len * N_LIMBS +
        circuit.input_len,
        poseidon_indexes_ptr=circuit.poseidon_indexes_ptr,
        n_elements_in_transcript=circuit.commitments_len / N_LIMBS,
        n_equations=circuit.N_Euclidean_equations,
        init_hash=init_hash,
        curve_id=circuit.curve_id,
    );

    %{
        # Sanity Check :
        assert ids.Z == EXTF_MOD_CIRCUIT.transcript.continuable_hash, f"Z for circuit {EXTF_MOD_CIRCUIT.name} does not match {hex(ids.Z)} {hex(EXTF_MOD_CIRCUIT.transcript.continuable_hash)}"
    %}

    tempvar range_check96_ptr = range_check96_ptr + circuit.constants_ptr_len * N_LIMBS +
        circuit.input_len + circuit.commitments_len + circuit.witnesses_len;

    write_felts_to_value_segment(values_start=RLC_coeffs, n=circuit.N_Euclidean_equations);
    write_felts_to_value_segment(values_start=&Z, n=1);
    %{ print(f"\tZ and felt252 written to value segment") %}
    %{ print(f"\tRunning ModuloBuiltin circuit...") %}
    run_mod_p_circuit(
        p=p,
        values_ptr=values_ptr,
        add_mod_offsets_ptr=circuit.add_offsets_ptr,
        add_mod_n=circuit.add_mod_n,
        mul_mod_offsets_ptr=circuit.mul_offsets_ptr,
        mul_mod_n=circuit.mul_mod_n,
    );
    tempvar range_check96_ptr = range_check96_ptr + (
        circuit.add_mod_n + circuit.mul_mod_n - circuit.n_assert_eq
    ) * N_LIMBS;

    let (output: felt*) = retrieve_output(
        values_segment=values_ptr,
        output_offsets_ptr=circuit.output_offsets_ptr,
        n=circuit.output_len,
        continuous_output=circuit.continuous_output,
    );
    return (output=output, Z=Z);
}
