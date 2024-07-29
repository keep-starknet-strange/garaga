from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuit,
    get_void_modulo_circuit,
    get_void_extension_field_modulo_circuit,
)
from definitions import bn, bls

func get_EVAL_FUNCTION_CHALLENGE_DUPL_circuit(curve_id: felt, n_points: felt) -> (
    circuit: ModuloCircuit*
) {
    tempvar offset = 2 * (n_points - 1) + 1;
    jmp rel offset;

    jmp circuit_1;

    jmp circuit_2;

    jmp circuit_3;

    jmp circuit_4;

    circuit_1:
    let curve_id = [fp - 4];
    return get_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(curve_id);

    circuit_2:
    let curve_id = [fp - 4];
    return get_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(curve_id);

    circuit_3:
    let curve_id = [fp - 4];
    return get_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(curve_id);

    circuit_4:
    let curve_id = [fp - 4];
    return get_EVAL_FUNCTION_CHALLENGE_DUPL_4_circuit(curve_id);
}

func get_INIT_FUNCTION_CHALLENGE_DUPL_circuit(curve_id: felt, n_points: felt) -> (
    circuit: ModuloCircuit*
) {
    tempvar offset = 2 * (n_points - 1) + 1;
    jmp rel offset;

    jmp circuit_5;

    circuit_5:
    let curve_id = [fp - 4];
    return get_INIT_FUNCTION_CHALLENGE_DUPL_5_circuit(curve_id);
}
func get_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(curve_id: felt) -> (
    circuit: ModuloCircuit*
) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 1;
    let input_len = 40;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 7;
    let mul_mod_n = 7;
    let n_assert_eq = 0;
    let name = 'acc_eval_point_challenge';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 0;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 20;  // None
    dw 44;
    dw 16;
    dw 48;  // None
    dw 12;
    dw 52;
    dw 52;  // None
    dw 56;
    dw 24;
    dw 24;  // None
    dw 60;
    dw 0;
    dw 52;  // None
    dw 64;
    dw 60;
    dw 76;  // None
    dw 88;
    dw 92;
    dw 4;  // None
    dw 92;
    dw 96;

    mul_offsets_ptr_loc:
    dw 8;  // None
    dw 20;
    dw 48;
    dw 36;  // None
    dw 28;
    dw 68;
    dw 56;  // None
    dw 72;
    dw 44;
    dw 68;  // None
    dw 72;
    dw 76;
    dw 40;  // None
    dw 32;
    dw 80;
    dw 64;  // None
    dw 84;
    dw 44;
    dw 80;  // None
    dw 84;
    dw 88;

    output_offsets_ptr_loc:
    dw 96;
}

func get_ACC_FUNCTION_CHALLENGE_DUPL_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 64;
    let witnesses_len = 0;
    let output_len = 40;
    let continuous_output = 0;
    let add_mod_n = 8;
    let mul_mod_n = 16;
    let n_assert_eq = 0;
    let name = 'acc_function_challenge_dupl';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 0;  // None
    dw 64;
    dw 68;
    dw 4;  // None
    dw 76;
    dw 80;
    dw 8;  // None
    dw 84;
    dw 88;
    dw 12;  // None
    dw 104;
    dw 108;
    dw 16;  // None
    dw 112;
    dw 116;
    dw 20;  // None
    dw 124;
    dw 128;
    dw 24;  // None
    dw 132;
    dw 136;
    dw 28;  // None
    dw 152;
    dw 156;

    mul_offsets_ptr_loc:
    dw 48;  // None
    dw 40;
    dw 64;
    dw 40;  // None
    dw 32;
    dw 72;
    dw 52;  // None
    dw 72;
    dw 76;
    dw 56;  // None
    dw 72;
    dw 84;
    dw 72;  // None
    dw 32;
    dw 92;
    dw 92;  // None
    dw 32;
    dw 96;
    dw 96;  // None
    dw 32;
    dw 100;
    dw 60;  // None
    dw 100;
    dw 104;
    dw 48;  // None
    dw 44;
    dw 112;
    dw 44;  // None
    dw 36;
    dw 120;
    dw 52;  // None
    dw 120;
    dw 124;
    dw 56;  // None
    dw 120;
    dw 132;
    dw 120;  // None
    dw 36;
    dw 140;
    dw 140;  // None
    dw 36;
    dw 144;
    dw 144;  // None
    dw 36;
    dw 148;
    dw 60;  // None
    dw 148;
    dw 152;

    output_offsets_ptr_loc:
    dw 68;
    dw 80;
    dw 88;
    dw 108;
    dw 116;
    dw 128;
    dw 136;
    dw 156;
    dw 72;
    dw 120;
}

func get_ADD_EC_POINT_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 16;
    let witnesses_len = 0;
    let output_len = 8;
    let continuous_output = 0;
    let add_mod_n = 6;
    let mul_mod_n = 3;
    let n_assert_eq = 0;
    let name = 'add_ec_point';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 12;  // None
    dw 16;
    dw 4;
    dw 8;  // None
    dw 20;
    dw 0;
    dw 0;  // None
    dw 32;
    dw 28;
    dw 8;  // None
    dw 36;
    dw 32;
    dw 36;  // None
    dw 40;
    dw 0;
    dw 4;  // None
    dw 48;
    dw 44;

    mul_offsets_ptr_loc:
    dw 20;  // None
    dw 24;
    dw 16;
    dw 24;  // None
    dw 24;
    dw 28;
    dw 24;  // None
    dw 40;
    dw 44;

    output_offsets_ptr_loc:
    dw 36;
    dw 48;
}

func get_DERIVE_POINT_FROM_X_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 16;
    let witnesses_len = 8;
    let output_len = 20;
    let continuous_output = 0;
    let add_mod_n = 2;
    let mul_mod_n = 6;
    let n_assert_eq = 0;
    let name = 'derive_point_from_x';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 32;  // None
    dw 8;
    dw 36;
    dw 28;  // None
    dw 36;
    dw 40;

    mul_offsets_ptr_loc:
    dw 0;  // None
    dw 0;
    dw 24;
    dw 0;  // None
    dw 24;
    dw 28;
    dw 4;  // None
    dw 0;
    dw 32;
    dw 12;  // None
    dw 40;
    dw 44;
    dw 16;  // None
    dw 16;
    dw 48;
    dw 20;  // None
    dw 20;
    dw 52;

    output_offsets_ptr_loc:
    dw 40;
    dw 44;
    dw 48;
    dw 52;
    dw 16;
}

func get_DOUBLE_EC_POINT_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 1;
    let input_len = 12;
    let witnesses_len = 0;
    let output_len = 8;
    let continuous_output = 0;
    let add_mod_n = 6;
    let mul_mod_n = 5;
    let n_assert_eq = 0;
    let name = 'double_ec_point';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 3;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 20;  // None
    dw 12;
    dw 24;
    dw 8;  // None
    dw 8;
    dw 28;
    dw 4;  // None
    dw 40;
    dw 36;
    dw 4;  // None
    dw 44;
    dw 40;
    dw 44;  // None
    dw 48;
    dw 4;
    dw 52;  // None
    dw 56;
    dw 8;

    mul_offsets_ptr_loc:
    dw 4;  // None
    dw 4;
    dw 16;
    dw 0;  // None
    dw 16;
    dw 20;
    dw 28;  // None
    dw 32;
    dw 24;
    dw 32;  // None
    dw 32;
    dw 36;
    dw 32;  // None
    dw 48;
    dw 52;

    output_offsets_ptr_loc:
    dw 44;
    dw 56;
}

func get_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 80;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 23;
    let mul_mod_n = 36;
    let n_assert_eq = 0;
    let name = 'eval_function_challenge_dupl';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 24;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 112;
    dw 116;
    dw 32;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 120;
    dw 124;
    dw 124;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 128;
    dw 132;
    dw 44;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 140;
    dw 144;
    dw 144;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 148;
    dw 152;
    dw 56;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 156;
    dw 160;
    dw 160;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 164;
    dw 168;
    dw 168;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 172;
    dw 176;
    dw 176;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 180;
    dw 184;
    dw 184;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 188;
    dw 192;
    dw 136;  // None
    dw 200;
    dw 204;
    dw 24;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 208;
    dw 212;
    dw 32;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 216;
    dw 220;
    dw 220;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 224;
    dw 228;
    dw 44;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 236;
    dw 240;
    dw 240;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 244;
    dw 248;
    dw 56;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 252;
    dw 256;
    dw 256;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 260;
    dw 264;
    dw 264;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 268;
    dw 272;
    dw 272;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 276;
    dw 280;
    dw 280;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 284;
    dw 288;
    dw 232;  // None
    dw 296;
    dw 300;
    dw 308;  // None
    dw 312;
    dw 304;

    mul_offsets_ptr_loc:
    dw 0;  // None
    dw 0;
    dw 80;
    dw 8;  // None
    dw 8;
    dw 84;
    dw 80;  // None
    dw 0;
    dw 88;
    dw 84;  // None
    dw 8;
    dw 92;
    dw 88;  // None
    dw 0;
    dw 96;
    dw 92;  // None
    dw 8;
    dw 100;
    dw 96;  // None
    dw 0;
    dw 104;
    dw 100;  // None
    dw 8;
    dw 108;
    dw 28;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 112;
    dw 36;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 120;
    dw 40;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 80;
    dw 128;
    dw 132;  // None
    dw 136;
    dw 116;
    dw 48;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 140;
    dw 52;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 80;
    dw 148;
    dw 60;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 156;
    dw 64;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 80;
    dw 164;
    dw 68;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 88;
    dw 172;
    dw 72;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 96;
    dw 180;
    dw 76;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 104;
    dw 188;
    dw 192;  // None
    dw 196;
    dw 152;
    dw 4;  // None
    dw 196;
    dw 200;
    dw 28;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 8;
    dw 208;
    dw 36;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 8;
    dw 216;
    dw 40;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 84;
    dw 224;
    dw 228;  // None
    dw 232;
    dw 212;
    dw 48;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 8;
    dw 236;
    dw 52;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 84;
    dw 244;
    dw 60;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 8;
    dw 252;
    dw 64;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 84;
    dw 260;
    dw 68;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 92;
    dw 268;
    dw 72;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 100;
    dw 276;
    dw 76;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 108;
    dw 284;
    dw 288;  // None
    dw 292;
    dw 248;
    dw 12;  // None
    dw 292;
    dw 296;
    dw 16;  // None
    dw 204;
    dw 304;
    dw 20;  // None
    dw 300;
    dw 308;

    output_offsets_ptr_loc:
    dw 312;
}

func get_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 96;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 31;
    let mul_mod_n = 46;
    let n_assert_eq = 0;
    let name = 'eval_function_challenge_dupl';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 24;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 136;
    dw 140;
    dw 140;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 144;
    dw 148;
    dw 36;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 152;
    dw 156;
    dw 156;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 160;
    dw 164;
    dw 164;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 168;
    dw 172;
    dw 52;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 180;
    dw 184;
    dw 184;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 188;
    dw 192;
    dw 192;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 196;
    dw 200;
    dw 68;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 204;
    dw 208;
    dw 208;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 212;
    dw 216;
    dw 216;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 220;
    dw 224;
    dw 224;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 228;
    dw 232;
    dw 232;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 236;
    dw 240;
    dw 240;  // Eval UnnamedPoly step + (coeff_6 * x^6)
    dw 244;
    dw 248;
    dw 176;  // None
    dw 256;
    dw 260;
    dw 24;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 264;
    dw 268;
    dw 268;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 272;
    dw 276;
    dw 36;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 280;
    dw 284;
    dw 284;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 288;
    dw 292;
    dw 292;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 296;
    dw 300;
    dw 52;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 308;
    dw 312;
    dw 312;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 316;
    dw 320;
    dw 320;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 324;
    dw 328;
    dw 68;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 332;
    dw 336;
    dw 336;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 340;
    dw 344;
    dw 344;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 348;
    dw 352;
    dw 352;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 356;
    dw 360;
    dw 360;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 364;
    dw 368;
    dw 368;  // Eval UnnamedPoly step + (coeff_6 * x^6)
    dw 372;
    dw 376;
    dw 304;  // None
    dw 384;
    dw 388;
    dw 396;  // None
    dw 400;
    dw 392;

    mul_offsets_ptr_loc:
    dw 0;  // None
    dw 0;
    dw 96;
    dw 8;  // None
    dw 8;
    dw 100;
    dw 96;  // None
    dw 0;
    dw 104;
    dw 100;  // None
    dw 8;
    dw 108;
    dw 104;  // None
    dw 0;
    dw 112;
    dw 108;  // None
    dw 8;
    dw 116;
    dw 112;  // None
    dw 0;
    dw 120;
    dw 116;  // None
    dw 8;
    dw 124;
    dw 120;  // None
    dw 0;
    dw 128;
    dw 124;  // None
    dw 8;
    dw 132;
    dw 28;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 136;
    dw 32;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 96;
    dw 144;
    dw 40;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 152;
    dw 44;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 96;
    dw 160;
    dw 48;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 104;
    dw 168;
    dw 172;  // None
    dw 176;
    dw 148;
    dw 56;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 180;
    dw 60;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 96;
    dw 188;
    dw 64;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 104;
    dw 196;
    dw 72;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 204;
    dw 76;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 96;
    dw 212;
    dw 80;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 104;
    dw 220;
    dw 84;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 112;
    dw 228;
    dw 88;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 120;
    dw 236;
    dw 92;  // Eval UnnamedPoly step coeff_6 * x^6
    dw 128;
    dw 244;
    dw 248;  // None
    dw 252;
    dw 200;
    dw 4;  // None
    dw 252;
    dw 256;
    dw 28;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 8;
    dw 264;
    dw 32;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 100;
    dw 272;
    dw 40;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 8;
    dw 280;
    dw 44;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 100;
    dw 288;
    dw 48;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 108;
    dw 296;
    dw 300;  // None
    dw 304;
    dw 276;
    dw 56;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 8;
    dw 308;
    dw 60;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 100;
    dw 316;
    dw 64;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 108;
    dw 324;
    dw 72;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 8;
    dw 332;
    dw 76;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 100;
    dw 340;
    dw 80;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 108;
    dw 348;
    dw 84;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 116;
    dw 356;
    dw 88;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 124;
    dw 364;
    dw 92;  // Eval UnnamedPoly step coeff_6 * x^6
    dw 132;
    dw 372;
    dw 376;  // None
    dw 380;
    dw 328;
    dw 12;  // None
    dw 380;
    dw 384;
    dw 16;  // None
    dw 260;
    dw 392;
    dw 20;  // None
    dw 388;
    dw 396;

    output_offsets_ptr_loc:
    dw 400;
}

func get_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 112;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 39;
    let mul_mod_n = 56;
    let n_assert_eq = 0;
    let name = 'eval_function_challenge_dupl';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 24;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 160;
    dw 164;
    dw 164;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 168;
    dw 172;
    dw 172;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 176;
    dw 180;
    dw 40;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 184;
    dw 188;
    dw 188;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 192;
    dw 196;
    dw 196;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 200;
    dw 204;
    dw 204;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 208;
    dw 212;
    dw 60;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 220;
    dw 224;
    dw 224;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 228;
    dw 232;
    dw 232;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 236;
    dw 240;
    dw 240;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 244;
    dw 248;
    dw 80;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 252;
    dw 256;
    dw 256;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 260;
    dw 264;
    dw 264;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 268;
    dw 272;
    dw 272;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 276;
    dw 280;
    dw 280;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 284;
    dw 288;
    dw 288;  // Eval UnnamedPoly step + (coeff_6 * x^6)
    dw 292;
    dw 296;
    dw 296;  // Eval UnnamedPoly step + (coeff_7 * x^7)
    dw 300;
    dw 304;
    dw 216;  // None
    dw 312;
    dw 316;
    dw 24;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 320;
    dw 324;
    dw 324;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 328;
    dw 332;
    dw 332;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 336;
    dw 340;
    dw 40;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 344;
    dw 348;
    dw 348;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 352;
    dw 356;
    dw 356;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 360;
    dw 364;
    dw 364;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 368;
    dw 372;
    dw 60;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 380;
    dw 384;
    dw 384;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 388;
    dw 392;
    dw 392;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 396;
    dw 400;
    dw 400;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 404;
    dw 408;
    dw 80;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 412;
    dw 416;
    dw 416;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 420;
    dw 424;
    dw 424;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 428;
    dw 432;
    dw 432;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 436;
    dw 440;
    dw 440;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 444;
    dw 448;
    dw 448;  // Eval UnnamedPoly step + (coeff_6 * x^6)
    dw 452;
    dw 456;
    dw 456;  // Eval UnnamedPoly step + (coeff_7 * x^7)
    dw 460;
    dw 464;
    dw 376;  // None
    dw 472;
    dw 476;
    dw 484;  // None
    dw 488;
    dw 480;

    mul_offsets_ptr_loc:
    dw 0;  // None
    dw 0;
    dw 112;
    dw 8;  // None
    dw 8;
    dw 116;
    dw 112;  // None
    dw 0;
    dw 120;
    dw 116;  // None
    dw 8;
    dw 124;
    dw 120;  // None
    dw 0;
    dw 128;
    dw 124;  // None
    dw 8;
    dw 132;
    dw 128;  // None
    dw 0;
    dw 136;
    dw 132;  // None
    dw 8;
    dw 140;
    dw 136;  // None
    dw 0;
    dw 144;
    dw 140;  // None
    dw 8;
    dw 148;
    dw 144;  // None
    dw 0;
    dw 152;
    dw 148;  // None
    dw 8;
    dw 156;
    dw 28;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 160;
    dw 32;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 112;
    dw 168;
    dw 36;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 120;
    dw 176;
    dw 44;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 184;
    dw 48;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 112;
    dw 192;
    dw 52;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 120;
    dw 200;
    dw 56;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 128;
    dw 208;
    dw 212;  // None
    dw 216;
    dw 180;
    dw 64;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 220;
    dw 68;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 112;
    dw 228;
    dw 72;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 120;
    dw 236;
    dw 76;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 128;
    dw 244;
    dw 84;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 252;
    dw 88;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 112;
    dw 260;
    dw 92;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 120;
    dw 268;
    dw 96;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 128;
    dw 276;
    dw 100;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 136;
    dw 284;
    dw 104;  // Eval UnnamedPoly step coeff_6 * x^6
    dw 144;
    dw 292;
    dw 108;  // Eval UnnamedPoly step coeff_7 * x^7
    dw 152;
    dw 300;
    dw 304;  // None
    dw 308;
    dw 248;
    dw 4;  // None
    dw 308;
    dw 312;
    dw 28;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 8;
    dw 320;
    dw 32;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 116;
    dw 328;
    dw 36;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 124;
    dw 336;
    dw 44;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 8;
    dw 344;
    dw 48;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 116;
    dw 352;
    dw 52;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 124;
    dw 360;
    dw 56;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 132;
    dw 368;
    dw 372;  // None
    dw 376;
    dw 340;
    dw 64;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 8;
    dw 380;
    dw 68;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 116;
    dw 388;
    dw 72;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 124;
    dw 396;
    dw 76;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 132;
    dw 404;
    dw 84;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 8;
    dw 412;
    dw 88;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 116;
    dw 420;
    dw 92;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 124;
    dw 428;
    dw 96;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 132;
    dw 436;
    dw 100;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 140;
    dw 444;
    dw 104;  // Eval UnnamedPoly step coeff_6 * x^6
    dw 148;
    dw 452;
    dw 108;  // Eval UnnamedPoly step coeff_7 * x^7
    dw 156;
    dw 460;
    dw 464;  // None
    dw 468;
    dw 408;
    dw 12;  // None
    dw 468;
    dw 472;
    dw 16;  // None
    dw 316;
    dw 480;
    dw 20;  // None
    dw 476;
    dw 484;

    output_offsets_ptr_loc:
    dw 488;
}

func get_EVAL_FUNCTION_CHALLENGE_DUPL_4_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 128;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 47;
    let mul_mod_n = 66;
    let n_assert_eq = 0;
    let name = 'eval_function_challenge_dupl';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 24;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 184;
    dw 188;
    dw 188;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 192;
    dw 196;
    dw 196;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 200;
    dw 204;
    dw 204;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 208;
    dw 212;
    dw 44;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 216;
    dw 220;
    dw 220;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 224;
    dw 228;
    dw 228;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 232;
    dw 236;
    dw 236;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 240;
    dw 244;
    dw 244;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 248;
    dw 252;
    dw 68;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 260;
    dw 264;
    dw 264;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 268;
    dw 272;
    dw 272;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 276;
    dw 280;
    dw 280;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 284;
    dw 288;
    dw 288;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 292;
    dw 296;
    dw 92;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 300;
    dw 304;
    dw 304;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 308;
    dw 312;
    dw 312;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 316;
    dw 320;
    dw 320;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 324;
    dw 328;
    dw 328;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 332;
    dw 336;
    dw 336;  // Eval UnnamedPoly step + (coeff_6 * x^6)
    dw 340;
    dw 344;
    dw 344;  // Eval UnnamedPoly step + (coeff_7 * x^7)
    dw 348;
    dw 352;
    dw 352;  // Eval UnnamedPoly step + (coeff_8 * x^8)
    dw 356;
    dw 360;
    dw 256;  // None
    dw 368;
    dw 372;
    dw 24;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 376;
    dw 380;
    dw 380;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 384;
    dw 388;
    dw 388;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 392;
    dw 396;
    dw 396;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 400;
    dw 404;
    dw 44;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 408;
    dw 412;
    dw 412;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 416;
    dw 420;
    dw 420;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 424;
    dw 428;
    dw 428;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 432;
    dw 436;
    dw 436;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 440;
    dw 444;
    dw 68;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 452;
    dw 456;
    dw 456;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 460;
    dw 464;
    dw 464;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 468;
    dw 472;
    dw 472;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 476;
    dw 480;
    dw 480;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 484;
    dw 488;
    dw 92;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 492;
    dw 496;
    dw 496;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 500;
    dw 504;
    dw 504;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 508;
    dw 512;
    dw 512;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 516;
    dw 520;
    dw 520;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 524;
    dw 528;
    dw 528;  // Eval UnnamedPoly step + (coeff_6 * x^6)
    dw 532;
    dw 536;
    dw 536;  // Eval UnnamedPoly step + (coeff_7 * x^7)
    dw 540;
    dw 544;
    dw 544;  // Eval UnnamedPoly step + (coeff_8 * x^8)
    dw 548;
    dw 552;
    dw 448;  // None
    dw 560;
    dw 564;
    dw 572;  // None
    dw 576;
    dw 568;

    mul_offsets_ptr_loc:
    dw 0;  // None
    dw 0;
    dw 128;
    dw 8;  // None
    dw 8;
    dw 132;
    dw 128;  // None
    dw 0;
    dw 136;
    dw 132;  // None
    dw 8;
    dw 140;
    dw 136;  // None
    dw 0;
    dw 144;
    dw 140;  // None
    dw 8;
    dw 148;
    dw 144;  // None
    dw 0;
    dw 152;
    dw 148;  // None
    dw 8;
    dw 156;
    dw 152;  // None
    dw 0;
    dw 160;
    dw 156;  // None
    dw 8;
    dw 164;
    dw 160;  // None
    dw 0;
    dw 168;
    dw 164;  // None
    dw 8;
    dw 172;
    dw 168;  // None
    dw 0;
    dw 176;
    dw 172;  // None
    dw 8;
    dw 180;
    dw 28;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 184;
    dw 32;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 128;
    dw 192;
    dw 36;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 136;
    dw 200;
    dw 40;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 144;
    dw 208;
    dw 48;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 216;
    dw 52;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 128;
    dw 224;
    dw 56;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 136;
    dw 232;
    dw 60;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 144;
    dw 240;
    dw 64;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 152;
    dw 248;
    dw 252;  // None
    dw 256;
    dw 212;
    dw 72;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 260;
    dw 76;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 128;
    dw 268;
    dw 80;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 136;
    dw 276;
    dw 84;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 144;
    dw 284;
    dw 88;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 152;
    dw 292;
    dw 96;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 300;
    dw 100;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 128;
    dw 308;
    dw 104;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 136;
    dw 316;
    dw 108;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 144;
    dw 324;
    dw 112;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 152;
    dw 332;
    dw 116;  // Eval UnnamedPoly step coeff_6 * x^6
    dw 160;
    dw 340;
    dw 120;  // Eval UnnamedPoly step coeff_7 * x^7
    dw 168;
    dw 348;
    dw 124;  // Eval UnnamedPoly step coeff_8 * x^8
    dw 176;
    dw 356;
    dw 360;  // None
    dw 364;
    dw 296;
    dw 4;  // None
    dw 364;
    dw 368;
    dw 28;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 8;
    dw 376;
    dw 32;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 132;
    dw 384;
    dw 36;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 140;
    dw 392;
    dw 40;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 148;
    dw 400;
    dw 48;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 8;
    dw 408;
    dw 52;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 132;
    dw 416;
    dw 56;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 140;
    dw 424;
    dw 60;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 148;
    dw 432;
    dw 64;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 156;
    dw 440;
    dw 444;  // None
    dw 448;
    dw 404;
    dw 72;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 8;
    dw 452;
    dw 76;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 132;
    dw 460;
    dw 80;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 140;
    dw 468;
    dw 84;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 148;
    dw 476;
    dw 88;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 156;
    dw 484;
    dw 96;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 8;
    dw 492;
    dw 100;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 132;
    dw 500;
    dw 104;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 140;
    dw 508;
    dw 108;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 148;
    dw 516;
    dw 112;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 156;
    dw 524;
    dw 116;  // Eval UnnamedPoly step coeff_6 * x^6
    dw 164;
    dw 532;
    dw 120;  // Eval UnnamedPoly step coeff_7 * x^7
    dw 172;
    dw 540;
    dw 124;  // Eval UnnamedPoly step coeff_8 * x^8
    dw 180;
    dw 548;
    dw 552;  // None
    dw 556;
    dw 488;
    dw 12;  // None
    dw 556;
    dw 560;
    dw 16;  // None
    dw 372;
    dw 568;
    dw 20;  // None
    dw 564;
    dw 572;

    output_offsets_ptr_loc:
    dw 576;
}

func get_FINALIZE_FUNCTION_CHALLENGE_DUPL_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 48;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 3;
    let mul_mod_n = 8;
    let n_assert_eq = 0;
    let name = 'final_function_challenge_dupl';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 48;  // a(x0) + y0 b(x0)
    dw 56;
    dw 60;
    dw 64;  // a(x2) + y2 b(x2)
    dw 72;
    dw 76;
    dw 84;  // None
    dw 88;
    dw 80;

    mul_offsets_ptr_loc:
    dw 4;  // None
    dw 48;
    dw 0;
    dw 12;  // None
    dw 52;
    dw 8;
    dw 32;  // None
    dw 52;
    dw 56;
    dw 20;  // None
    dw 64;
    dw 16;
    dw 28;  // None
    dw 68;
    dw 24;
    dw 36;  // None
    dw 68;
    dw 72;
    dw 40;  // None
    dw 60;
    dw 80;
    dw 44;  // None
    dw 76;
    dw 84;

    output_offsets_ptr_loc:
    dw 88;
}

func get_INIT_FUNCTION_CHALLENGE_DUPL_5_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 128;
    let witnesses_len = 0;
    let output_len = 40;
    let continuous_output = 0;
    let add_mod_n = 52;
    let mul_mod_n = 68;
    let n_assert_eq = 0;
    let name = 'init_function_challenge_dupl';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 8;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 192;
    dw 196;
    dw 196;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 200;
    dw 204;
    dw 204;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 208;
    dw 212;
    dw 212;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 216;
    dw 220;
    dw 220;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 224;
    dw 228;
    dw 32;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 232;
    dw 236;
    dw 236;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 240;
    dw 244;
    dw 244;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 248;
    dw 252;
    dw 252;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 256;
    dw 260;
    dw 260;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 264;
    dw 268;
    dw 268;  // Eval UnnamedPoly step + (coeff_6 * x^6)
    dw 272;
    dw 276;
    dw 60;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 280;
    dw 284;
    dw 284;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 288;
    dw 292;
    dw 292;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 296;
    dw 300;
    dw 300;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 304;
    dw 308;
    dw 308;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 312;
    dw 316;
    dw 316;  // Eval UnnamedPoly step + (coeff_6 * x^6)
    dw 320;
    dw 324;
    dw 88;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 328;
    dw 332;
    dw 332;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 336;
    dw 340;
    dw 340;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 344;
    dw 348;
    dw 348;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 352;
    dw 356;
    dw 356;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 360;
    dw 364;
    dw 364;  // Eval UnnamedPoly step + (coeff_6 * x^6)
    dw 368;
    dw 372;
    dw 372;  // Eval UnnamedPoly step + (coeff_7 * x^7)
    dw 376;
    dw 380;
    dw 380;  // Eval UnnamedPoly step + (coeff_8 * x^8)
    dw 384;
    dw 388;
    dw 388;  // Eval UnnamedPoly step + (coeff_9 * x^9)
    dw 392;
    dw 396;
    dw 8;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 400;
    dw 404;
    dw 404;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 408;
    dw 412;
    dw 412;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 416;
    dw 420;
    dw 420;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 424;
    dw 428;
    dw 428;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 432;
    dw 436;
    dw 32;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 440;
    dw 444;
    dw 444;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 448;
    dw 452;
    dw 452;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 456;
    dw 460;
    dw 460;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 464;
    dw 468;
    dw 468;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 472;
    dw 476;
    dw 476;  // Eval UnnamedPoly step + (coeff_6 * x^6)
    dw 480;
    dw 484;
    dw 60;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 488;
    dw 492;
    dw 492;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 496;
    dw 500;
    dw 500;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 504;
    dw 508;
    dw 508;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 512;
    dw 516;
    dw 516;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 520;
    dw 524;
    dw 524;  // Eval UnnamedPoly step + (coeff_6 * x^6)
    dw 528;
    dw 532;
    dw 88;  // Eval UnnamedPoly step + (coeff_1 * x^1)
    dw 536;
    dw 540;
    dw 540;  // Eval UnnamedPoly step + (coeff_2 * x^2)
    dw 544;
    dw 548;
    dw 548;  // Eval UnnamedPoly step + (coeff_3 * x^3)
    dw 552;
    dw 556;
    dw 556;  // Eval UnnamedPoly step + (coeff_4 * x^4)
    dw 560;
    dw 564;
    dw 564;  // Eval UnnamedPoly step + (coeff_5 * x^5)
    dw 568;
    dw 572;
    dw 572;  // Eval UnnamedPoly step + (coeff_6 * x^6)
    dw 576;
    dw 580;
    dw 580;  // Eval UnnamedPoly step + (coeff_7 * x^7)
    dw 584;
    dw 588;
    dw 588;  // Eval UnnamedPoly step + (coeff_8 * x^8)
    dw 592;
    dw 596;
    dw 596;  // Eval UnnamedPoly step + (coeff_9 * x^9)
    dw 600;
    dw 604;

    mul_offsets_ptr_loc:
    dw 0;  // None
    dw 0;
    dw 128;
    dw 4;  // None
    dw 4;
    dw 132;
    dw 128;  // None
    dw 0;
    dw 136;
    dw 132;  // None
    dw 4;
    dw 140;
    dw 136;  // None
    dw 0;
    dw 144;
    dw 140;  // None
    dw 4;
    dw 148;
    dw 144;  // None
    dw 0;
    dw 152;
    dw 148;  // None
    dw 4;
    dw 156;
    dw 152;  // None
    dw 0;
    dw 160;
    dw 156;  // None
    dw 4;
    dw 164;
    dw 160;  // None
    dw 0;
    dw 168;
    dw 164;  // None
    dw 4;
    dw 172;
    dw 168;  // None
    dw 0;
    dw 176;
    dw 172;  // None
    dw 4;
    dw 180;
    dw 176;  // None
    dw 0;
    dw 184;
    dw 180;  // None
    dw 4;
    dw 188;
    dw 12;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 192;
    dw 16;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 128;
    dw 200;
    dw 20;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 136;
    dw 208;
    dw 24;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 144;
    dw 216;
    dw 28;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 152;
    dw 224;
    dw 36;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 232;
    dw 40;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 128;
    dw 240;
    dw 44;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 136;
    dw 248;
    dw 48;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 144;
    dw 256;
    dw 52;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 152;
    dw 264;
    dw 56;  // Eval UnnamedPoly step coeff_6 * x^6
    dw 160;
    dw 272;
    dw 64;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 280;
    dw 68;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 128;
    dw 288;
    dw 72;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 136;
    dw 296;
    dw 76;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 144;
    dw 304;
    dw 80;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 152;
    dw 312;
    dw 84;  // Eval UnnamedPoly step coeff_6 * x^6
    dw 160;
    dw 320;
    dw 92;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 0;
    dw 328;
    dw 96;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 128;
    dw 336;
    dw 100;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 136;
    dw 344;
    dw 104;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 144;
    dw 352;
    dw 108;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 152;
    dw 360;
    dw 112;  // Eval UnnamedPoly step coeff_6 * x^6
    dw 160;
    dw 368;
    dw 116;  // Eval UnnamedPoly step coeff_7 * x^7
    dw 168;
    dw 376;
    dw 120;  // Eval UnnamedPoly step coeff_8 * x^8
    dw 176;
    dw 384;
    dw 124;  // Eval UnnamedPoly step coeff_9 * x^9
    dw 184;
    dw 392;
    dw 12;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 4;
    dw 400;
    dw 16;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 132;
    dw 408;
    dw 20;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 140;
    dw 416;
    dw 24;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 148;
    dw 424;
    dw 28;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 156;
    dw 432;
    dw 36;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 4;
    dw 440;
    dw 40;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 132;
    dw 448;
    dw 44;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 140;
    dw 456;
    dw 48;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 148;
    dw 464;
    dw 52;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 156;
    dw 472;
    dw 56;  // Eval UnnamedPoly step coeff_6 * x^6
    dw 164;
    dw 480;
    dw 64;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 4;
    dw 488;
    dw 68;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 132;
    dw 496;
    dw 72;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 140;
    dw 504;
    dw 76;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 148;
    dw 512;
    dw 80;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 156;
    dw 520;
    dw 84;  // Eval UnnamedPoly step coeff_6 * x^6
    dw 164;
    dw 528;
    dw 92;  // Eval UnnamedPoly step coeff_1 * x^1
    dw 4;
    dw 536;
    dw 96;  // Eval UnnamedPoly step coeff_2 * x^2
    dw 132;
    dw 544;
    dw 100;  // Eval UnnamedPoly step coeff_3 * x^3
    dw 140;
    dw 552;
    dw 104;  // Eval UnnamedPoly step coeff_4 * x^4
    dw 148;
    dw 560;
    dw 108;  // Eval UnnamedPoly step coeff_5 * x^5
    dw 156;
    dw 568;
    dw 112;  // Eval UnnamedPoly step coeff_6 * x^6
    dw 164;
    dw 576;
    dw 116;  // Eval UnnamedPoly step coeff_7 * x^7
    dw 172;
    dw 584;
    dw 120;  // Eval UnnamedPoly step coeff_8 * x^8
    dw 180;
    dw 592;
    dw 124;  // Eval UnnamedPoly step coeff_9 * x^9
    dw 188;
    dw 600;

    output_offsets_ptr_loc:
    dw 228;
    dw 276;
    dw 324;
    dw 396;
    dw 436;
    dw 484;
    dw 532;
    dw 604;
    dw 168;
    dw 172;
}

func get_IS_ON_CURVE_G1_G2_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 40;
    let witnesses_len = 0;
    let output_len = 12;
    let continuous_output = 1;
    let add_mod_n = 16;
    let mul_mod_n = 13;
    let n_assert_eq = 0;
    let name = 'is_on_curve_g1_g2';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 48;  // None
    dw 28;
    dw 52;
    dw 16;  // None
    dw 20;
    dw 56;
    dw 20;  // None
    dw 60;
    dw 16;
    dw 68;  // None
    dw 68;
    dw 72;
    dw 8;  // None
    dw 12;
    dw 76;
    dw 12;  // None
    dw 80;
    dw 8;
    dw 88;  // None
    dw 88;
    dw 92;
    dw 100;  // Fp2 mul real part end
    dw 104;
    dw 96;
    dw 108;  // Fp2 mul imag part end
    dw 112;
    dw 116;
    dw 120;  // None
    dw 32;
    dw 128;
    dw 124;  // None
    dw 36;
    dw 132;
    dw 104;  // None
    dw 128;
    dw 136;
    dw 116;  // None
    dw 132;
    dw 140;
    dw 52;  // None
    dw 144;
    dw 40;
    dw 136;  // None
    dw 148;
    dw 64;
    dw 140;  // None
    dw 152;
    dw 72;

    mul_offsets_ptr_loc:
    dw 4;  // None
    dw 4;
    dw 40;
    dw 0;  // None
    dw 0;
    dw 44;
    dw 0;  // None
    dw 44;
    dw 48;
    dw 56;  // None
    dw 60;
    dw 64;
    dw 16;  // None
    dw 20;
    dw 68;
    dw 76;  // None
    dw 80;
    dw 84;
    dw 8;  // None
    dw 12;
    dw 88;
    dw 8;  // Fp2 mul start
    dw 84;
    dw 96;
    dw 12;  // None
    dw 92;
    dw 100;
    dw 8;  // None
    dw 92;
    dw 108;
    dw 12;  // None
    dw 84;
    dw 112;
    dw 24;  // None
    dw 8;
    dw 120;
    dw 24;  // None
    dw 12;
    dw 124;

    output_offsets_ptr_loc:
    dw 144;
}

func get_IS_ON_CURVE_G1_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 16;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 3;
    let mul_mod_n = 4;
    let n_assert_eq = 0;
    let name = 'is_on_curve_g1';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:

    add_offsets_ptr_loc:
    dw 28;  // None
    dw 12;
    dw 32;
    dw 24;  // None
    dw 32;
    dw 36;
    dw 36;  // None
    dw 40;
    dw 16;

    mul_offsets_ptr_loc:
    dw 4;  // None
    dw 4;
    dw 16;
    dw 0;  // None
    dw 0;
    dw 20;
    dw 0;  // None
    dw 20;
    dw 24;
    dw 8;  // None
    dw 0;
    dw 28;

    output_offsets_ptr_loc:
    dw 40;
}

func get_RHS_FINALIZE_ACC_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 1;
    let input_len = 24;
    let witnesses_len = 0;
    let output_len = 4;
    let continuous_output = 1;
    let add_mod_n = 5;
    let mul_mod_n = 2;
    let n_assert_eq = 0;
    let name = 'rhs_finalize_acc';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 0;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 20;  // None
    dw 28;
    dw 16;
    dw 32;  // None
    dw 12;
    dw 36;
    dw 24;  // None
    dw 40;
    dw 0;
    dw 36;  // None
    dw 44;
    dw 40;
    dw 4;  // None
    dw 48;
    dw 52;

    mul_offsets_ptr_loc:
    dw 8;  // None
    dw 20;
    dw 32;
    dw 44;  // None
    dw 48;
    dw 28;

    output_offsets_ptr_loc:
    dw 52;
}

func get_SLOPE_INTERCEPT_SAME_POINT_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 2;
    let input_len = 12;
    let witnesses_len = 0;
    let output_len = 32;
    let continuous_output = 0;
    let add_mod_n = 17;
    let mul_mod_n = 12;
    let n_assert_eq = 0;
    let name = 'slope_intercept_same_point';
    let curve_id = curve_id;
    local circuit: ModuloCircuit = ModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        constants_ptr_len,
        input_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 3;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 24;  // None
    dw 16;
    dw 28;
    dw 12;  // None
    dw 12;
    dw 32;
    dw 40;  // None
    dw 44;
    dw 12;
    dw 8;  // None
    dw 8;
    dw 52;
    dw 52;  // None
    dw 56;
    dw 48;
    dw 56;  // None
    dw 60;
    dw 8;
    dw 12;  // None
    dw 68;
    dw 64;
    dw 68;  // None
    dw 72;
    dw 4;
    dw 12;  // None
    dw 76;
    dw 72;
    dw 8;  // None
    dw 80;
    dw 56;
    dw 72;  // None
    dw 72;
    dw 92;
    dw 56;  // None
    dw 96;
    dw 8;
    dw 88;  // None
    dw 88;
    dw 112;
    dw 112;  // None
    dw 116;
    dw 16;
    dw 108;  // None
    dw 116;
    dw 120;
    dw 84;  // None
    dw 84;
    dw 128;
    dw 124;  // None
    dw 128;
    dw 132;

    mul_offsets_ptr_loc:
    dw 8;  // None
    dw 8;
    dw 20;
    dw 0;  // None
    dw 20;
    dw 24;
    dw 32;  // None
    dw 36;
    dw 28;
    dw 8;  // None
    dw 36;
    dw 40;
    dw 36;  // None
    dw 36;
    dw 48;
    dw 36;  // None
    dw 60;
    dw 64;
    dw 80;  // None
    dw 84;
    dw 76;
    dw 84;  // None
    dw 72;
    dw 88;
    dw 92;  // None
    dw 96;
    dw 100;
    dw 56;  // None
    dw 56;
    dw 104;
    dw 0;  // None
    dw 104;
    dw 108;
    dw 120;  // None
    dw 124;
    dw 100;

    output_offsets_ptr_loc:
    dw 36;
    dw 44;
    dw 8;
    dw 12;
    dw 56;
    dw 72;
    dw 132;
    dw 124;
}
