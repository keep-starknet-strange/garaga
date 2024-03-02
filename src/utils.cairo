from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin
from starkware.cairo.common.poseidon_state import PoseidonBuiltinState
from src.definitions import STARK_MIN_ONE_D2, N_LIMBS, BASE

func get_Z_and_RLC_from_transcript{poseidon_ptr: PoseidonBuiltin*, range_check96_ptr: felt*}(
    transcript_start: felt*,
    poseidon_indexes_ptr: felt*,
    n_elements_in_transcript: felt,
    n_equations: felt,
    init_hash: felt,
) -> (Z: felt, random_linear_combination_coefficients: felt*) {
    alloc_locals;
    tempvar poseidon_start = poseidon_ptr;
    let (Z: felt) = hash_full_transcript_and_get_Z(
        limbs_ptr=transcript_start, n=n_elements_in_transcript, init_hash=init_hash
    );

    let (RLC_coeffs: felt*) = retrieve_random_coefficients(
        poseidon_start=poseidon_start, poseidon_indexes_ptr=poseidon_indexes_ptr, n=n_equations
    );

    return (Z=Z, random_linear_combination_coefficients=RLC_coeffs);
}
func hash_full_transcript_and_get_Z{poseidon_ptr: PoseidonBuiltin*}(
    limbs_ptr: felt*, n: felt, init_hash: felt
) -> (Z: felt) {
    alloc_locals;
    // %{ print(f"N elemts in transcript : {ids.n} ") %}
    local ptr: felt* = cast(poseidon_ptr, felt*);
    // %{
    //     from src.hints.io import pack_bigint_ptr
    //     to_hash=pack_bigint_ptr(memory, ids.limbs_ptr, ids.N_LIMBS, ids.BASE, ids.n)
    //     for e in to_hash:
    //         print(f"Will Hash {hex(e)}")
    // %}
    // Initialisation:
    %{
        for i in range(2*ids.n -1):
            memory[ids.ptr + 2 + 6*i] = 2
            memory[ids.ptr + 8 + 6*i] = 2
    %}
    assert ptr[0] = limbs_ptr[0] * limbs_ptr[1];
    assert ptr[1] = init_hash;
    assert ptr[6] = limbs_ptr[2] * limbs_ptr[3];
    assert ptr[7] = ptr[3];

    %{ i=0 %}

    tempvar limbs_ptr: felt* = limbs_ptr + 4;
    tempvar pos_ptr: felt* = ptr + 2 * PoseidonBuiltin.SIZE;

    hash_limbs_2_by_2:
    let limbs_ptr: felt* = cast([ap - 2], felt*);
    let pos_ptr: felt* = cast([ap - 1], felt*);
    %{
        i+=1
        memory[ap] = 1 if i == ids.n else 0
    %}
    jmp end_loop if [ap] != 0, ap++;

    assert [pos_ptr] = limbs_ptr[0] * limbs_ptr[1];
    assert [pos_ptr + 1] = [pos_ptr - 3];
    assert [pos_ptr + 6] = limbs_ptr[2] * limbs_ptr[3];
    assert [pos_ptr + 7] = [pos_ptr + 3];

    [ap] = limbs_ptr + 4, ap++;
    [ap] = pos_ptr + 2 * PoseidonBuiltin.SIZE, ap++;

    jmp hash_limbs_2_by_2;

    end_loop:
    assert 2 * n * PoseidonBuiltin.SIZE = cast(pos_ptr, felt) - cast(ptr, felt);
    tempvar poseidon_ptr = cast(pos_ptr, PoseidonBuiltin*);
    tempvar res = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s0;

    return (Z=res);
}

func retrieve_random_coefficients(
    poseidon_start: PoseidonBuiltin*, poseidon_indexes_ptr: felt*, n: felt
) -> (coefficients: felt*) {
    alloc_locals;
    let (local coefficients_start: felt*) = alloc();
    local ptr: felt* = cast(poseidon_start, felt*);

    %{ i=0 %}
    assert [coefficients_start] = [ptr + [poseidon_indexes_ptr]];
    tempvar coefficients = coefficients_start + 1;
    tempvar poseidon_indexes_ptr = poseidon_indexes_ptr + 1;

    get_s1_loop:
    let coefficients = cast([ap - 2], felt*);
    let poseidon_indexes_ptr = cast([ap - 1], felt*);
    %{
        i+=1
        memory[ap] = 1 if i == ids.n else 0
    %}
    jmp end if [ap] != 0, ap++;
    assert [coefficients] = [ptr + [poseidon_indexes_ptr]];
    [ap] = coefficients + 1, ap++;
    [ap] = poseidon_indexes_ptr + 1, ap++;
    jmp get_s1_loop;

    end:
    assert n = cast(coefficients, felt) - cast(coefficients_start, felt);
    // %{
    //     from src.hints.io import pack_bigint_ptr
    //     array=pack_bigint_ptr(memory, ids.coefficients, 1, ids.BASE, ids.n)
    //     for i,e in enumerate(array):
    //         print(f"CAIRO Using c_{i} = {hex(e)}")
    // %}
    return (coefficients=coefficients_start);
}

func write_felts_to_value_segment{range_check96_ptr: felt*}(values_start: felt*, n: felt) -> () {
    alloc_locals;
    local stark_min_1_d2 = STARK_MIN_ONE_D2;
    local n_rc_per_felt = N_LIMBS + 1;

    %{ i=0 %}
    tempvar values = values_start;
    tempvar rc_96_ptr = range_check96_ptr;

    loop:
    let values = cast([ap - 2], felt*);
    let rc_96_ptr = cast([ap - 1], felt*);
    %{
        memory[ap] = 1 if i == ids.n else 0
        i+=1
    %}
    jmp end if [ap] != 0, ap++;

    let d0 = [rc_96_ptr];
    let d1 = [rc_96_ptr + 1];
    let d2 = [rc_96_ptr + 2];
    %{
        from src.hints.io import bigint_split 
        felt_val = memory[ids.values_start+i-1]
        limbs = bigint_split(felt_val, ids.N_LIMBS, ids.BASE)
        assert limbs[3] == 0
        ids.d0, ids.d1, ids.d2 = limbs[0], limbs[1], limbs[2]
    %}
    assert [rc_96_ptr + 3] = 0;
    assert [rc_96_ptr + 4] = stark_min_1_d2 - d2;
    assert [values] = (d0 + d1 * BASE + d2 * BASE ** 2);
    if (d2 == stark_min_1_d2) {
        // Take advantage of Cairo prime structure. STARK_MIN_ONE = 0 + 0 * BASE + stark_min_1_d2 * (BASE)**2.
        assert d1 = 0;
        assert d2 = 0;
        [ap] = values + 1, ap++;
        [ap] = rc_96_ptr + n_rc_per_felt, ap++;
    } else {
        [ap] = values + 1, ap++;
        [ap] = rc_96_ptr + n_rc_per_felt, ap++;
    }
    jmp loop;

    end:
    assert n = cast(values, felt) - cast(values_start, felt);
    tempvar range_check96_ptr = rc_96_ptr;

    return ();
}

func retrieve_output{}(
    values_segment: felt*, output_offsets_ptr: felt*, n: felt, continuous_output: felt
) -> (output: felt*) {
    if (continuous_output != 0) {
        let offset = output_offsets_ptr[0];
        // %{ print(f"Continuous output! start value : {hex(memory[ids.values_segment + ids.offset])} Size: {ids.n//4} offset:{ids.offset}") %}
        return (cast(values_segment + offset, felt*),);
    }
    alloc_locals;
    let (local output: felt*) = alloc();
    local one = 1;
    local two = 2;
    local three = 3;

    tempvar i = 0;
    tempvar output_offsets = output_offsets_ptr;

    loop:
    let i = [ap - 2];
    let output_offsets = cast([ap - 1], felt*);
    %{
        index = memory[ids.output_offsets_ptr+ids.i]
        # print(f"Output {ids.i}/{ids.n} Index : {index}")
        memory[ap] = 1 if ids.i == ids.n else 0
    %}
    jmp end if [ap] != 0, ap++;

    tempvar i_plus_one = i + one;
    tempvar i_plus_two = i + two;
    tempvar i_plus_three = i + three;

    assert output[i] = values_segment[[output_offsets]];
    assert output[i_plus_one] = values_segment[[output_offsets] + one];
    assert output[i_plus_two] = values_segment[[output_offsets] + two];
    assert output[i_plus_three] = values_segment[[output_offsets] + three];

    [ap] = i + 4, ap++;
    [ap] = output_offsets + 1, ap++;
    jmp loop;

    end:
    assert i = n;
    return (output=output);
}
