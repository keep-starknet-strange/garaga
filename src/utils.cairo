from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin
from starkware.cairo.common.poseidon_state import PoseidonBuiltinState
from src.definitions import STARK_MIN_ONE_D2, N_LIMBS

func get_Z_and_RLC_from_transcript{poseidon_ptr: PoseidonBuiltin*, range_check96_ptr: felt*}(
    transcript_start: felt*,
    poseidon_ptr_indexes: felt*,
    n_elements_in_transcript: felt,
    n_equations: felt,
) -> (Z: felt, random_linear_combination_coefficients: felt*) {
    tempvar poseidon_start = poseidon_ptr;
    let (Z: felt) = hash_full_transcript_and_get_Z(
        limbs_ptr=transcript_start, n=n_elements_in_transcript
    );
    let (RLC_coeffs: felt*) = retrieve_random_coefficients(
        poseidon_start, poseidon_ptr_indexes=poseidon_ptr_indexes, n=n_equations
    );
    return (Z=Z, random_linear_combination_coefficients=RLC_coeffs);
}
func hash_full_transcript_and_get_Z{poseidon_ptr: PoseidonBuiltin*}(limbs_ptr: felt*, n: felt) -> (
    Z: felt
) {
    alloc_locals;

    tempvar limbs_ptr = limb_ptr;
    tempvar i = 0;

    hash_limbs_2_by_2:
    let limb_ptr = [ap - 2];
    let i = [ap - 1];
    %{ memory[ap] = 1 if ids.i == ids.n else 0 %}
    jmp end_loop if [ap] != 0, ap++;

    assert poseidon_ptr[i].input = PoseidonBuiltinState(
        limbs_ptr[0] * limbs_ptr[1], poseidon_ptr[i - 1].output.s0, two
    );
    assert poseidon_ptr[i + 1].input = PoseidonBuiltinState(
        limbs_ptr[2] * limbs_ptr[3], poseidon_ptr[i].output.s0, two
    );

    [ap] = limbs_ptr + 4;
    [ap] = i + 1, ap++;

    end_loop:
    assert i = n;
    tempvar poseidon_ptr = poseidon_ptr + PoseidonBuiltin.SZIE * n * 2;
    tempvar res = poseidon_ptr[0].output.s0;
    return (Z=res);
}

func retrieve_random_coefficients(
    poseidon_ptr: PoseidonBuiltin*, poseidon_ptr_indexes: felt*, n: felt
) -> (coefficients: felt*) {
    alloc_locals;
    let (local coefficients: felt*) = alloc();

    tempvar i = 0;

    get_s1_loop:
    let i = [ap - 1];
    %{ memory[ap] = 1 if ids.i == ids.n else 0 %}
    jmp end if [ap] != 0, ap++;
    assert coefficients[i] = poseidon_ptr[poseidon_ptr_indexes[i]].output.s1;
    [ap] = i + 1, ap++;
    jmp get_s1_loop;

    end:
    assert i = n;
    return (coefficients=coefficients);
}

func write_felts_to_value_segment{range_check96_ptr: felt*}(values: felt*, n: felt) -> () {
    alloc_locals;
    local stark_min_1_d2 = STARK_MIN_ONE_D2;
    local n_rc_per_felt = N_LIMBS + 1;

    tempvar i = 0;

    loop:
    let i = [ap - 1];
    %{ memory[ap] = 1 if ids.i == ids.n else 0 %}
    jmp end if [ap] != 0, ap++;

    tempvar offset = i * n_rc_per_felt;

    let d0 = [range_check96_ptr + offset];
    let d1 = [range_check96_ptr + offset + 1];
    let d2 = [range_check96_ptr + offset + 2];
    %{
        from src.hints.io import bigint_split 
        limbs = bigint_split(ids.values[ids.i], ids.N_LIMBS, ids.BASE)
        assert limbs[3] == 0
        ids.d0, ids.d1, ids.d2 = limbs[0], limbs[1], limbs[2]
    %}
    assert [range_check96_ptr + offset + 3] = 0;
    assert [range_check96_ptr + offset + 4] = stark_min_1_d2 - d2;
    assert 0 = values[i] - (d0 + d1 * 2 ** 96 + d2 * (2 ** 96) ** 2);
    if (d2 == stark_min_1_d2) {
        assert d1 = 0;
        assert d2 = 0;
    }
    [ap] = i + 1, ap++;
    jmp loop;

    end:
    assert i = n;
    tempvar range_check96_ptr = range_check96_ptr + n * n_rc_per_felt;
    return ();
}

func assert_limbs_at_index_are_equal{}(
    values_segment: felt*, left_assert_eq_offsets: felt*, right_assert_eq_offsets: felt*, n: felt
) -> () {
    alloc_locals;
    local one = 1;
    local two = 2;
    local three = 3;

    tempvar i = 0;

    loop:
    let i = [ap - 1];
    %{ memory[ap] = 1 if ids.i == ids.n else 0 %}
    jmp end if [ap] != 0, ap++;

    tempvar i_plus_one = i + one;
    tempvar i_plus_two = i + two;
    tempvar i_plus_three = i + three;

    assert values_segment[left_assert_eq_offsets[i]] - values_segment[
        right_assert_eq_offsets[i]
    ] = 0;
    assert values_segment[left_assert_eq_offsets[i_plus_one]] - values_segment[
        right_assert_eq_offsets[i_plus_one]
    ] = 0;
    assert values_segment[left_assert_eq_offsets[i_plus_two]] - values_segment[
        right_assert_eq_offsets[i_plus_two]
    ] = 0;
    assert values_segment[left_assert_eq_offsets[i_plus_three]] - values_segment[
        right_assert_eq_offsets[i_plus_three]
    ] = 0;

    [ap] = i + 1, ap++;
    jmp loop;

    end:
    assert i = n;
    return ();
}
