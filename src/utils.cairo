from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin
from starkware.cairo.common.poseidon_state import PoseidonBuiltinState
from src.definitions import STARK_MIN_ONE_D2, N_LIMBS, BASE, bn, UInt384

func get_Z_and_RLC_from_transcript{poseidon_ptr: PoseidonBuiltin*, range_check96_ptr: felt*}(
    transcript_start: felt*,
    poseidon_indexes_ptr: felt*,
    n_elements_in_transcript: felt,
    n_equations: felt,
    init_hash: felt,
    curve_id: felt,
) -> (Z: felt, random_linear_combination_coefficients: felt*) {
    alloc_locals;
    tempvar poseidon_start = poseidon_ptr;
    let (Z: felt) = hash_full_transcript_and_get_Z(
        limbs_ptr=transcript_start,
        n=n_elements_in_transcript,
        init_hash=init_hash,
        curve_id=curve_id,
    );

    let (RLC_coeffs: felt*) = retrieve_random_coefficients(
        poseidon_start=poseidon_start, poseidon_indexes_ptr=poseidon_indexes_ptr, n=n_equations
    );

    return (Z=Z, random_linear_combination_coefficients=RLC_coeffs);
}

func hash_full_transcript_and_get_Z{poseidon_ptr: PoseidonBuiltin*}(
    limbs_ptr: felt*, n: felt, init_hash: felt, curve_id: felt
) -> (Z: felt) {
    if (curve_id == bn.CURVE_ID) {
        return hash_full_transcript_and_get_Z_3_LIMBS(limbs_ptr, n, init_hash);
    } else {
        return hash_full_transcript_and_get_Z_4_LIMBS(limbs_ptr, n, init_hash);
    }
}
func hash_full_transcript_and_get_Z_3_LIMBS{poseidon_ptr: PoseidonBuiltin*}(
    limbs_ptr: felt*, n: felt, init_hash: felt
) -> (Z: felt) {
    alloc_locals;
    local BASE = 2 ** 96;
    // %{
    //     from src.hints.io import pack_bigint_ptr
    //     to_hash=pack_bigint_ptr(memory, ids.limbs_ptr, ids.N_LIMBS, ids.BASE, ids.n)
    //     for e in to_hash:
    //         print(f"Will Hash {hex(e)}")
    // %}
    let elements_end = &limbs_ptr[n * N_LIMBS];

    assert poseidon_ptr[0].input.s0 = init_hash;
    assert poseidon_ptr[0].input.s1 = 0;
    assert poseidon_ptr[0].input.s2 = 1;
    tempvar elements = limbs_ptr;
    tempvar pos_ptr = cast(poseidon_ptr + PoseidonBuiltin.SIZE, felt*);

    loop:
    if (nondet %{ ids.elements_end - ids.elements >= 6*ids.N_LIMBS %} != 0) {
        assert poseidon_ptr[0].output.s0 = poseidon_ptr[0].output.s0;
        // %{
        //     from src.hints.io import pack_bigint_ptr
        //     to_hash=pack_bigint_ptr(memory, ids.elements, ids.N_LIMBS, ids.BASE, 6)
        //     for e in to_hash:
        //         print(f"\t Will Hash {hex(e)}")
        // %}

        assert [pos_ptr + 0] = [pos_ptr - 3] + elements[0] + (BASE) * elements[1];
        assert [pos_ptr + 1] = [pos_ptr - 2] + elements[2];
        assert [pos_ptr + 2] = [pos_ptr - 1];

        assert [pos_ptr + 6] = [pos_ptr + 3] + elements[4] + (BASE) * elements[5];
        assert [pos_ptr + 7] = [pos_ptr + 4] + elements[6];
        assert [pos_ptr + 8] = [pos_ptr + 5];

        assert [pos_ptr + 12] = [pos_ptr + 9] + elements[8] + (BASE) * elements[9];
        assert [pos_ptr + 13] = [pos_ptr + 10] + elements[10];
        assert [pos_ptr + 14] = [pos_ptr + 11];

        assert [pos_ptr + 18] = [pos_ptr + 15] + elements[12] + (BASE) * elements[13];
        assert [pos_ptr + 19] = [pos_ptr + 16] + elements[14];
        assert [pos_ptr + 20] = [pos_ptr + 17];

        assert [pos_ptr + 24] = [pos_ptr + 21] + elements[16] + (BASE) * elements[17];
        assert [pos_ptr + 25] = [pos_ptr + 22] + elements[18];
        assert [pos_ptr + 26] = [pos_ptr + 23];

        assert [pos_ptr + 30] = [pos_ptr + 27] + elements[20] + (BASE) * elements[21];
        assert [pos_ptr + 31] = [pos_ptr + 28] + elements[22];
        assert [pos_ptr + 32] = [pos_ptr + 29];

        let pos_ptr = pos_ptr + 6 * PoseidonBuiltin.SIZE;
        tempvar elements = &elements[6 * N_LIMBS];
        tempvar pos_ptr = pos_ptr;
        jmp loop;
    }

    if (nondet %{ ids.elements_end - ids.elements >= ids.N_LIMBS %} != 0) {
        // %{
        //     from src.hints.io import pack_bigint_ptr
        //     to_hash=pack_bigint_ptr(memory, ids.elements, ids.N_LIMBS, ids.BASE, 1)
        //     for e in to_hash:
        //         print(f"\t\t Will Hash {hex(e)}")
        // %}
        assert [pos_ptr + 0] = [pos_ptr - 3] + elements[0] + (BASE) * elements[1];
        assert [pos_ptr + 1] = [pos_ptr - 2] + elements[2];
        assert [pos_ptr + 2] = [pos_ptr - 1];

        let pos_ptr = pos_ptr + PoseidonBuiltin.SIZE;

        tempvar elements = &elements[N_LIMBS];
        tempvar pos_ptr = pos_ptr;
        jmp loop;
    }

    assert cast(elements_end, felt) = cast(elements, felt);

    tempvar poseidon_ptr = poseidon_ptr + (n + 1) * PoseidonBuiltin.SIZE;
    tempvar res = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s0;
    return (Z=res);
}

func hash_full_transcript_and_get_Z_4_LIMBS{poseidon_ptr: PoseidonBuiltin*}(
    limbs_ptr: felt*, n: felt, init_hash: felt
) -> (Z: felt) {
    alloc_locals;
    local BASE = 2 ** 96;
    // %{
    //     from src.hints.io import pack_bigint_ptr
    //     to_hash=pack_bigint_ptr(memory, ids.limbs_ptr, ids.N_LIMBS, ids.BASE, ids.n)
    //     for e in to_hash:
    //         print(f"Will Hash {hex(e)}")
    // %}
    let elements_end = &limbs_ptr[n * N_LIMBS];

    assert poseidon_ptr[0].input.s0 = init_hash;
    assert poseidon_ptr[0].input.s1 = 0;
    assert poseidon_ptr[0].input.s2 = 1;
    tempvar elements = limbs_ptr;
    tempvar pos_ptr = cast(poseidon_ptr + PoseidonBuiltin.SIZE, felt*);

    loop:
    if (nondet %{ ids.elements_end - ids.elements >= 6*ids.N_LIMBS %} != 0) {
        assert poseidon_ptr[0].output.s0 = poseidon_ptr[0].output.s0;
        // %{
        //     from src.hints.io import pack_bigint_ptr
        //     to_hash=pack_bigint_ptr(memory, ids.elements, ids.N_LIMBS, ids.BASE, 6)
        //     for e in to_hash:
        //         print(f"\t Will Hash {hex(e)}")
        // %}

        assert [pos_ptr + 0] = [pos_ptr - 3] + elements[0] + (BASE) * elements[1];
        assert [pos_ptr + 1] = [pos_ptr - 2] + elements[2] + (BASE) * elements[3];
        assert [pos_ptr + 2] = [pos_ptr - 1];

        assert [pos_ptr + 6] = [pos_ptr + 3] + elements[4] + (BASE) * elements[5];
        assert [pos_ptr + 7] = [pos_ptr + 4] + elements[6] + (BASE) * elements[7];
        assert [pos_ptr + 8] = [pos_ptr + 5];

        assert [pos_ptr + 12] = [pos_ptr + 9] + elements[8] + (BASE) * elements[9];
        assert [pos_ptr + 13] = [pos_ptr + 10] + elements[10] + (BASE) * elements[11];
        assert [pos_ptr + 14] = [pos_ptr + 11];

        assert [pos_ptr + 18] = [pos_ptr + 15] + elements[12] + (BASE) * elements[13];
        assert [pos_ptr + 19] = [pos_ptr + 16] + elements[14] + (BASE) * elements[15];
        assert [pos_ptr + 20] = [pos_ptr + 17];

        assert [pos_ptr + 24] = [pos_ptr + 21] + elements[16] + (BASE) * elements[17];
        assert [pos_ptr + 25] = [pos_ptr + 22] + elements[18] + (BASE) * elements[19];
        assert [pos_ptr + 26] = [pos_ptr + 23];

        assert [pos_ptr + 30] = [pos_ptr + 27] + elements[20] + (BASE) * elements[21];
        assert [pos_ptr + 31] = [pos_ptr + 28] + elements[22] + (BASE) * elements[23];
        assert [pos_ptr + 32] = [pos_ptr + 29];

        let pos_ptr = pos_ptr + 6 * PoseidonBuiltin.SIZE;
        tempvar elements = &elements[6 * N_LIMBS];
        tempvar pos_ptr = pos_ptr;
        jmp loop;
    }

    if (nondet %{ ids.elements_end - ids.elements >= ids.N_LIMBS %} != 0) {
        // %{
        //     from src.hints.io import pack_bigint_ptr
        //     to_hash=pack_bigint_ptr(memory, ids.elements, ids.N_LIMBS, ids.BASE, 1)
        //     for e in to_hash:
        //         print(f"\t\t Will Hash {hex(e)}")
        // %}
        assert [pos_ptr + 0] = [pos_ptr - 3] + elements[0] + (BASE) * elements[1];
        assert [pos_ptr + 1] = [pos_ptr - 2] + elements[2] + (BASE) * elements[3];
        assert [pos_ptr + 2] = [pos_ptr - 1];

        let pos_ptr = pos_ptr + PoseidonBuiltin.SIZE;

        tempvar elements = &elements[N_LIMBS];
        tempvar pos_ptr = pos_ptr;
        jmp loop;
    }

    assert cast(elements_end, felt) = cast(elements, felt);

    tempvar poseidon_ptr = poseidon_ptr + (n + 1) * PoseidonBuiltin.SIZE;
    tempvar res = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s0;
    %{ print(f"res {hex(ids.res)}") %}
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

func felt_to_UInt384{range_check96_ptr: felt*}(x: felt) -> (res: UInt384) {
    let d0 = [range_check96_ptr];
    let d1 = [range_check96_ptr + 1];
    let d2 = [range_check96_ptr + 2];
    %{
        from src.hints.io import bigint_split 
        limbs = bigint_split(ids.x, ids.N_LIMBS, ids.BASE)
        assert limbs[3] == 0
        ids.d0, ids.d1, ids.d2 = limbs[0], limbs[1], limbs[2]
    %}
    assert [range_check96_ptr + 3] = STARK_MIN_ONE_D2 - d2;
    assert x = d0 + d1 * BASE + d2 * BASE ** 2;
    if (d2 == STARK_MIN_ONE_D2) {
        // Take advantage of Cairo prime structure. STARK_MIN_ONE = 0 + 0 * BASE + stark_min_1_d2 * (BASE)**2.
        assert d1 = 0;
        assert d2 = 0;
        tempvar range_check96_ptr = range_check96_ptr + 4;
        return (res=UInt384(d0, d1, d2, 0));
    } else {
        tempvar range_check96_ptr = range_check96_ptr + 4;
        return (res=UInt384(d0, d1, d2, 0));
    }
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
