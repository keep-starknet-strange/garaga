from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin
from starkware.cairo.common.poseidon_state import PoseidonBuiltinState
from starkware.cairo.common.uint256 import Uint256
from definitions import STARK_MIN_ONE_D2, N_LIMBS, BASE, bls, UInt384, get_min_one
from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from starkware.cairo.common.math import assert_le_felt

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
    if (curve_id == bls.CURVE_ID) {
        return hash_full_transcript_and_get_Z_4_LIMBS(limbs_ptr, n, init_hash);
    } else {
        return hash_full_transcript_and_get_Z_3_LIMBS(limbs_ptr, n, init_hash);
    }
}
func hash_full_transcript_and_get_Z_3_LIMBS{poseidon_ptr: PoseidonBuiltin*}(
    limbs_ptr: felt*, n: felt, init_hash: felt
) -> (Z: felt) {
    alloc_locals;
    local BASE = 2 ** 96;
    // %{
    //     from garaga.hints.io import pack_bigint_ptr
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
        //     from garaga.hints.io import pack_bigint_ptr
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
        //     from garaga.hints.io import pack_bigint_ptr
        //     to_hash=pack_bigint_ptr(memory, ids.elements, ids.N_LIMBS, ids.BASE, 1)
        //     for e in to_hash:
        //         print(f"\t\t Will Hash {e}")
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
    //     from garaga.hints.io import pack_bigint_ptr
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
        //     from garaga.hints.io import pack_bigint_ptr
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
        //     from garaga.hints.io import pack_bigint_ptr
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
    // %{ print(f"res {hex(ids.res)}") %}
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
    //     from garaga.hints.io import pack_bigint_ptr
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
        from garaga.hints.io import bigint_split
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
        assert d0 = 0;
        assert d1 = 0;
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
        from garaga.hints.io import bigint_split
        limbs = bigint_split(ids.x, ids.N_LIMBS, ids.BASE)
        assert limbs[3] == 0
        ids.d0, ids.d1, ids.d2 = limbs[0], limbs[1], limbs[2]
    %}
    assert [range_check96_ptr + 3] = STARK_MIN_ONE_D2 - d2;
    assert x = d0 + d1 * BASE + d2 * BASE ** 2;
    if (d2 == STARK_MIN_ONE_D2) {
        // Take advantage of Cairo prime structure. STARK_MIN_ONE = 0 + 0 * BASE + stark_min_1_d2 * (BASE)**2.
        assert d0 = 0;
        assert d1 = 0;
        tempvar range_check96_ptr = range_check96_ptr + 4;
        return (res=UInt384(d0, d1, d2, 0));
    } else {
        tempvar range_check96_ptr = range_check96_ptr + 4;
        return (res=UInt384(d0, d1, d2, 0));
    }
}

func sign_to_UInt384(sign: felt, curve_id: felt) -> (res: UInt384) {
    if (sign == -1) {
        return get_min_one(curve_id);
    } else {
        return (res=UInt384(1, 0, 0, 0));
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

func scalars_to_epns_low_high{range_check_ptr}(scalars: Uint256*, n: felt, neg_3_pow: felt*) -> (
    epns_low: felt*, epns_high: felt*
) {
    alloc_locals;
    let (local epns_low: felt*) = alloc();
    let (local epns_high: felt*) = alloc();

    scalars_to_epns_low_high_inner(scalars, 0, n, neg_3_pow, epns_low, epns_high);
    return (epns_low, epns_high);
}

func scalars_to_epns_low_high_inner{range_check_ptr}(
    scalars: Uint256*, index: felt, n: felt, neg_3_pow: felt*, epns_low: felt*, epns_high: felt*
) {
    alloc_locals;

    if (index == n) {
        return ();
    } else {
        let (epi_low, eni_low, p_sign_low, n_sign_low) = scalar_to_base_neg3_le(
            scalars[index].low, neg_3_pow
        );
        let (epi_high, eni_high, p_sign_high, n_sign_high) = scalar_to_base_neg3_le(
            scalars[index].high, neg_3_pow
        );
        assert [epns_low] = epi_low;
        assert [epns_low + 1] = eni_low;
        assert [epns_low + 2] = p_sign_low;
        assert [epns_low + 3] = n_sign_low;
        assert [epns_high] = epi_high;
        assert [epns_high + 1] = eni_high;
        assert [epns_high + 2] = p_sign_high;
        assert [epns_high + 3] = n_sign_high;
        return scalars_to_epns_low_high_inner(
            scalars, index + 1, n, neg_3_pow, epns_low + 4, epns_high + 4
        );
    }
}

// Returns the sign of value: -1 if value < 0, 1 if value > 0.
// value is considered positive if it is in [0, STARK//2[
// value is considered negative if it is in ]STARK//2, STARK[
// If value == 0, returned value can be either 0 or 1 (undetermined).
func sign{range_check_ptr}(value) -> felt {
    const STARK_DIV_2_PLUS_ONE = (-1) / 2 + 1;  // == prime//2 + 1
    const STARK_DIV_2_MIN_ONE = (-1) / 2 - 1;  // == prime//2 - 1
    tempvar is_positive: felt;
    %{
        from starkware.cairo.common.math_utils import as_int
        ids.is_positive = 1 if as_int(ids.value, PRIME) >= 0 else 0
    %}
    if (is_positive != 0) {
        assert_le_felt(value, STARK_DIV_2_MIN_ONE);
        return 1;
    } else {
        assert_le_felt(STARK_DIV_2_PLUS_ONE, value);
        return -1;
    }
}

// From a 128 bit scalar, decomposes it into base (-3) such that
// scalar = sum(digits[i] * (-3)^i for i in [0, 81])
// scalar = sum_p - sum_n
// Where sum_p = sum(digits[i] * (-3)^i for i in [0, 81] if digits[i]==1)
// And sum_n = sum(digits[i] * (-3)^i for i in [0, 81] if digits[i]==-1)
// Returns (abs(sum_p), abs(sum_n), p_sign, n_sign)
func scalar_to_base_neg3_le{range_check_ptr}(scalar: felt, neg_3_pow: felt*) -> (
    sum_p: felt, sum_n: felt, p_sign: felt, n_sign: felt
) {
    alloc_locals;
    local one = 1;
    let (local digits: felt*) = alloc();
    %{
        from garaga.hints.neg_3 import neg_3_base_le, positive_negative_multiplicities

        digits = neg_3_base_le(ids.scalar)
        digits = digits + [0] * (82-len(digits))
        segments.write_arg(ids.digits, digits)
        pos, neg = positive_negative_multiplicities(digits)
        assert pos - neg == ids.scalar
    %}
    let sum_p = 0;
    let sum_n = 0;
    if (digits[0] != 0) {
        if (digits[0] == 1) {
            tempvar sum_p = 1;
            tempvar sum_n = sum_n;
            tempvar i = 1;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = 1;
            tempvar i = 1;
        }
    } else {
        tempvar sum_p = sum_p;
        tempvar sum_n = sum_n;
        tempvar i = 1;
    }

    loop:
    let i = [ap - 1];
    let sum_n = [ap - 2];
    let sum_p = [ap - 3];
    %{ memory[ap] = 1 if ids.i == 82 else 0 %}
    jmp end if [ap] != 0, ap++;
    // %{
    //     print(f"{memory[ids.digits+ids.i]=}")
    //     print(f"\t {ids.sum_p=}")
    //     print(f"\t {ids.sum_n=}")
    // %}
    if (digits[i] != 0) {
        tempvar pow = neg_3_pow[i];
        if (digits[i] == 1) {
            tempvar sum_p = sum_p + pow;
            tempvar sum_n = sum_n;
            tempvar i = i + 1;
            jmp loop;
        } else {
            tempvar sum_p = sum_p;
            tempvar sum_n = sum_n + pow;
            tempvar i = i + 1;
            jmp loop;
        }
    } else {
        tempvar sum_p = sum_p;
        tempvar sum_n = sum_n;
        tempvar i = i + 1;
        jmp loop;
    }

    end:
    let i = [ap - 2];
    let sum_n = [ap - 3];
    let sum_p = [ap - 4];
    assert i = 82;

    // %{
    //     from starkware.cairo.common.math_utils import as_int
    //     print(f"{as_int(ids.sum_p, PRIME)=}")
    //     print(f"{as_int(ids.sum_n, PRIME)=}")
    // %}
    assert scalar = sum_p - sum_n;

    let p_sign = sign(sum_p);
    let n_sign = sign(sum_n);

    return (p_sign * sum_p, n_sign * sum_n, p_sign, n_sign);
}

// Utility to get a pointer on an array of (-3)^i for i in [0, 81].
func neg_3_pow_alloc_80() -> (array: felt*) {
    let (data_address) = get_label_location(data);
    return (data_address,);

    data:
    dw 1;
    dw (-3) ** 1;
    dw (-3) ** 2;
    dw (-3) ** 3;
    dw (-3) ** 4;
    dw (-3) ** 5;
    dw (-3) ** 6;
    dw (-3) ** 7;
    dw (-3) ** 8;
    dw (-3) ** 9;
    dw (-3) ** 10;
    dw (-3) ** 11;
    dw (-3) ** 12;
    dw (-3) ** 13;
    dw (-3) ** 14;
    dw (-3) ** 15;
    dw (-3) ** 16;
    dw (-3) ** 17;
    dw (-3) ** 18;
    dw (-3) ** 19;
    dw (-3) ** 20;
    dw (-3) ** 21;
    dw (-3) ** 22;
    dw (-3) ** 23;
    dw (-3) ** 24;
    dw (-3) ** 25;
    dw (-3) ** 26;
    dw (-3) ** 27;
    dw (-3) ** 28;
    dw (-3) ** 29;
    dw (-3) ** 30;
    dw (-3) ** 31;
    dw (-3) ** 32;
    dw (-3) ** 33;
    dw (-3) ** 34;
    dw (-3) ** 35;
    dw (-3) ** 36;
    dw (-3) ** 37;
    dw (-3) ** 38;
    dw (-3) ** 39;
    dw (-3) ** 40;
    dw (-3) ** 41;
    dw (-3) ** 42;
    dw (-3) ** 43;
    dw (-3) ** 44;
    dw (-3) ** 45;
    dw (-3) ** 46;
    dw (-3) ** 47;
    dw (-3) ** 48;
    dw (-3) ** 49;
    dw (-3) ** 50;
    dw (-3) ** 51;
    dw (-3) ** 52;
    dw (-3) ** 53;
    dw (-3) ** 54;
    dw (-3) ** 55;
    dw (-3) ** 56;
    dw (-3) ** 57;
    dw (-3) ** 58;
    dw (-3) ** 59;
    dw (-3) ** 60;
    dw (-3) ** 61;
    dw (-3) ** 62;
    dw (-3) ** 63;
    dw (-3) ** 64;
    dw (-3) ** 65;
    dw (-3) ** 66;
    dw (-3) ** 67;
    dw (-3) ** 68;
    dw (-3) ** 69;
    dw (-3) ** 70;
    dw (-3) ** 71;
    dw (-3) ** 72;
    dw (-3) ** 73;
    dw (-3) ** 74;
    dw (-3) ** 75;
    dw (-3) ** 76;
    dw (-3) ** 77;
    dw (-3) ** 78;
    dw (-3) ** 79;
    dw (-3) ** 80;
    dw (-3) ** 81;
}
