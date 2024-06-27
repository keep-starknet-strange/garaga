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

    circuit_1:
    let curve_id = [fp - 4];
    return get_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(curve_id);

    circuit_2:
    let curve_id = [fp - 4];
    return get_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(curve_id);

    circuit_3:
    let curve_id = [fp - 4];
    return get_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(curve_id);
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
    dw 20;
    dw 44;
    dw 16;
    dw 48;
    dw 12;
    dw 52;
    dw 52;
    dw 56;
    dw 24;
    dw 24;
    dw 60;
    dw 0;
    dw 52;
    dw 64;
    dw 60;
    dw 76;
    dw 88;
    dw 92;
    dw 4;
    dw 92;
    dw 96;
    dw 20;
    dw 44;
    dw 16;

    mul_offsets_ptr_loc:
    dw 8;
    dw 20;
    dw 48;
    dw 36;
    dw 28;
    dw 68;
    dw 56;
    dw 72;
    dw 44;
    dw 68;
    dw 72;
    dw 76;
    dw 40;
    dw 32;
    dw 80;
    dw 64;
    dw 84;
    dw 44;
    dw 80;
    dw 84;
    dw 88;
    dw 8;
    dw 20;
    dw 48;

    output_offsets_ptr_loc:
    dw 96;
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
    dw 48;
    dw 28;
    dw 52;
    dw 16;
    dw 20;
    dw 56;
    dw 20;
    dw 60;
    dw 16;
    dw 68;
    dw 68;
    dw 72;
    dw 8;
    dw 12;
    dw 76;
    dw 12;
    dw 80;
    dw 8;
    dw 88;
    dw 88;
    dw 92;
    dw 100;
    dw 104;
    dw 96;
    dw 108;
    dw 112;
    dw 116;
    dw 120;
    dw 32;
    dw 128;
    dw 124;
    dw 36;
    dw 132;
    dw 104;
    dw 128;
    dw 136;
    dw 116;
    dw 132;
    dw 140;
    dw 52;
    dw 144;
    dw 40;
    dw 136;
    dw 148;
    dw 64;
    dw 140;
    dw 152;
    dw 72;

    mul_offsets_ptr_loc:
    dw 4;
    dw 4;
    dw 40;
    dw 0;
    dw 0;
    dw 44;
    dw 0;
    dw 44;
    dw 48;
    dw 56;
    dw 60;
    dw 64;
    dw 16;
    dw 20;
    dw 68;
    dw 76;
    dw 80;
    dw 84;
    dw 8;
    dw 12;
    dw 88;
    dw 8;
    dw 84;
    dw 96;
    dw 12;
    dw 92;
    dw 100;
    dw 8;
    dw 92;
    dw 108;
    dw 12;
    dw 84;
    dw 112;
    dw 24;
    dw 8;
    dw 120;
    dw 24;
    dw 12;
    dw 124;
    dw 4;
    dw 4;
    dw 40;
    dw 4;
    dw 4;
    dw 40;
    dw 4;
    dw 4;
    dw 40;

    output_offsets_ptr_loc:
    dw 144;
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
    let mul_mod_n = 48;
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
    dw 24;
    dw 144;
    dw 148;
    dw 148;
    dw 152;
    dw 156;
    dw 36;
    dw 160;
    dw 164;
    dw 164;
    dw 168;
    dw 172;
    dw 172;
    dw 176;
    dw 180;
    dw 52;
    dw 188;
    dw 192;
    dw 192;
    dw 196;
    dw 200;
    dw 200;
    dw 204;
    dw 208;
    dw 68;
    dw 212;
    dw 216;
    dw 216;
    dw 220;
    dw 224;
    dw 224;
    dw 228;
    dw 232;
    dw 232;
    dw 236;
    dw 240;
    dw 240;
    dw 244;
    dw 248;
    dw 248;
    dw 252;
    dw 256;
    dw 184;
    dw 264;
    dw 268;
    dw 24;
    dw 272;
    dw 276;
    dw 276;
    dw 280;
    dw 284;
    dw 36;
    dw 288;
    dw 292;
    dw 292;
    dw 296;
    dw 300;
    dw 300;
    dw 304;
    dw 308;
    dw 52;
    dw 316;
    dw 320;
    dw 320;
    dw 324;
    dw 328;
    dw 328;
    dw 332;
    dw 336;
    dw 68;
    dw 340;
    dw 344;
    dw 344;
    dw 348;
    dw 352;
    dw 352;
    dw 356;
    dw 360;
    dw 360;
    dw 364;
    dw 368;
    dw 368;
    dw 372;
    dw 376;
    dw 376;
    dw 380;
    dw 384;
    dw 312;
    dw 392;
    dw 396;
    dw 404;
    dw 408;
    dw 400;
    dw 24;
    dw 144;
    dw 148;

    mul_offsets_ptr_loc:
    dw 0;
    dw 0;
    dw 96;
    dw 8;
    dw 8;
    dw 100;
    dw 96;
    dw 0;
    dw 104;
    dw 100;
    dw 8;
    dw 108;
    dw 104;
    dw 0;
    dw 112;
    dw 108;
    dw 8;
    dw 116;
    dw 112;
    dw 0;
    dw 120;
    dw 116;
    dw 8;
    dw 124;
    dw 120;
    dw 0;
    dw 128;
    dw 124;
    dw 8;
    dw 132;
    dw 128;
    dw 0;
    dw 136;
    dw 132;
    dw 8;
    dw 140;
    dw 28;
    dw 0;
    dw 144;
    dw 32;
    dw 96;
    dw 152;
    dw 40;
    dw 0;
    dw 160;
    dw 44;
    dw 96;
    dw 168;
    dw 48;
    dw 104;
    dw 176;
    dw 180;
    dw 184;
    dw 156;
    dw 56;
    dw 0;
    dw 188;
    dw 60;
    dw 96;
    dw 196;
    dw 64;
    dw 104;
    dw 204;
    dw 72;
    dw 0;
    dw 212;
    dw 76;
    dw 96;
    dw 220;
    dw 80;
    dw 104;
    dw 228;
    dw 84;
    dw 112;
    dw 236;
    dw 88;
    dw 120;
    dw 244;
    dw 92;
    dw 128;
    dw 252;
    dw 256;
    dw 260;
    dw 208;
    dw 4;
    dw 260;
    dw 264;
    dw 28;
    dw 8;
    dw 272;
    dw 32;
    dw 100;
    dw 280;
    dw 40;
    dw 8;
    dw 288;
    dw 44;
    dw 100;
    dw 296;
    dw 48;
    dw 108;
    dw 304;
    dw 308;
    dw 312;
    dw 284;
    dw 56;
    dw 8;
    dw 316;
    dw 60;
    dw 100;
    dw 324;
    dw 64;
    dw 108;
    dw 332;
    dw 72;
    dw 8;
    dw 340;
    dw 76;
    dw 100;
    dw 348;
    dw 80;
    dw 108;
    dw 356;
    dw 84;
    dw 116;
    dw 364;
    dw 88;
    dw 124;
    dw 372;
    dw 92;
    dw 132;
    dw 380;
    dw 384;
    dw 388;
    dw 336;
    dw 12;
    dw 388;
    dw 392;
    dw 16;
    dw 268;
    dw 400;
    dw 20;
    dw 396;
    dw 404;

    output_offsets_ptr_loc:
    dw 408;
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
    let mul_mod_n = 58;
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
    dw 24;
    dw 168;
    dw 172;
    dw 172;
    dw 176;
    dw 180;
    dw 180;
    dw 184;
    dw 188;
    dw 40;
    dw 192;
    dw 196;
    dw 196;
    dw 200;
    dw 204;
    dw 204;
    dw 208;
    dw 212;
    dw 212;
    dw 216;
    dw 220;
    dw 60;
    dw 228;
    dw 232;
    dw 232;
    dw 236;
    dw 240;
    dw 240;
    dw 244;
    dw 248;
    dw 248;
    dw 252;
    dw 256;
    dw 80;
    dw 260;
    dw 264;
    dw 264;
    dw 268;
    dw 272;
    dw 272;
    dw 276;
    dw 280;
    dw 280;
    dw 284;
    dw 288;
    dw 288;
    dw 292;
    dw 296;
    dw 296;
    dw 300;
    dw 304;
    dw 304;
    dw 308;
    dw 312;
    dw 224;
    dw 320;
    dw 324;
    dw 24;
    dw 328;
    dw 332;
    dw 332;
    dw 336;
    dw 340;
    dw 340;
    dw 344;
    dw 348;
    dw 40;
    dw 352;
    dw 356;
    dw 356;
    dw 360;
    dw 364;
    dw 364;
    dw 368;
    dw 372;
    dw 372;
    dw 376;
    dw 380;
    dw 60;
    dw 388;
    dw 392;
    dw 392;
    dw 396;
    dw 400;
    dw 400;
    dw 404;
    dw 408;
    dw 408;
    dw 412;
    dw 416;
    dw 80;
    dw 420;
    dw 424;
    dw 424;
    dw 428;
    dw 432;
    dw 432;
    dw 436;
    dw 440;
    dw 440;
    dw 444;
    dw 448;
    dw 448;
    dw 452;
    dw 456;
    dw 456;
    dw 460;
    dw 464;
    dw 464;
    dw 468;
    dw 472;
    dw 384;
    dw 480;
    dw 484;
    dw 492;
    dw 496;
    dw 488;
    dw 24;
    dw 168;
    dw 172;

    mul_offsets_ptr_loc:
    dw 0;
    dw 0;
    dw 112;
    dw 8;
    dw 8;
    dw 116;
    dw 112;
    dw 0;
    dw 120;
    dw 116;
    dw 8;
    dw 124;
    dw 120;
    dw 0;
    dw 128;
    dw 124;
    dw 8;
    dw 132;
    dw 128;
    dw 0;
    dw 136;
    dw 132;
    dw 8;
    dw 140;
    dw 136;
    dw 0;
    dw 144;
    dw 140;
    dw 8;
    dw 148;
    dw 144;
    dw 0;
    dw 152;
    dw 148;
    dw 8;
    dw 156;
    dw 152;
    dw 0;
    dw 160;
    dw 156;
    dw 8;
    dw 164;
    dw 28;
    dw 0;
    dw 168;
    dw 32;
    dw 112;
    dw 176;
    dw 36;
    dw 120;
    dw 184;
    dw 44;
    dw 0;
    dw 192;
    dw 48;
    dw 112;
    dw 200;
    dw 52;
    dw 120;
    dw 208;
    dw 56;
    dw 128;
    dw 216;
    dw 220;
    dw 224;
    dw 188;
    dw 64;
    dw 0;
    dw 228;
    dw 68;
    dw 112;
    dw 236;
    dw 72;
    dw 120;
    dw 244;
    dw 76;
    dw 128;
    dw 252;
    dw 84;
    dw 0;
    dw 260;
    dw 88;
    dw 112;
    dw 268;
    dw 92;
    dw 120;
    dw 276;
    dw 96;
    dw 128;
    dw 284;
    dw 100;
    dw 136;
    dw 292;
    dw 104;
    dw 144;
    dw 300;
    dw 108;
    dw 152;
    dw 308;
    dw 312;
    dw 316;
    dw 256;
    dw 4;
    dw 316;
    dw 320;
    dw 28;
    dw 8;
    dw 328;
    dw 32;
    dw 116;
    dw 336;
    dw 36;
    dw 124;
    dw 344;
    dw 44;
    dw 8;
    dw 352;
    dw 48;
    dw 116;
    dw 360;
    dw 52;
    dw 124;
    dw 368;
    dw 56;
    dw 132;
    dw 376;
    dw 380;
    dw 384;
    dw 348;
    dw 64;
    dw 8;
    dw 388;
    dw 68;
    dw 116;
    dw 396;
    dw 72;
    dw 124;
    dw 404;
    dw 76;
    dw 132;
    dw 412;
    dw 84;
    dw 8;
    dw 420;
    dw 88;
    dw 116;
    dw 428;
    dw 92;
    dw 124;
    dw 436;
    dw 96;
    dw 132;
    dw 444;
    dw 100;
    dw 140;
    dw 452;
    dw 104;
    dw 148;
    dw 460;
    dw 108;
    dw 156;
    dw 468;
    dw 472;
    dw 476;
    dw 416;
    dw 12;
    dw 476;
    dw 480;
    dw 16;
    dw 324;
    dw 488;
    dw 20;
    dw 484;
    dw 492;
    dw 0;
    dw 0;
    dw 112;
    dw 0;
    dw 0;
    dw 112;
    dw 0;
    dw 0;
    dw 112;
    dw 0;
    dw 0;
    dw 112;
    dw 0;
    dw 0;
    dw 112;
    dw 0;
    dw 0;
    dw 112;

    output_offsets_ptr_loc:
    dw 496;
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
    dw 12;
    dw 16;
    dw 4;
    dw 8;
    dw 20;
    dw 0;
    dw 0;
    dw 32;
    dw 28;
    dw 8;
    dw 36;
    dw 32;
    dw 36;
    dw 40;
    dw 0;
    dw 4;
    dw 48;
    dw 44;
    dw 12;
    dw 16;
    dw 4;
    dw 12;
    dw 16;
    dw 4;

    mul_offsets_ptr_loc:
    dw 20;
    dw 24;
    dw 16;
    dw 24;
    dw 24;
    dw 28;
    dw 24;
    dw 40;
    dw 44;
    dw 20;
    dw 24;
    dw 16;
    dw 20;
    dw 24;
    dw 16;
    dw 20;
    dw 24;
    dw 16;
    dw 20;
    dw 24;
    dw 16;
    dw 20;
    dw 24;
    dw 16;

    output_offsets_ptr_loc:
    dw 36;
    dw 48;
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
    dw 24;
    dw 16;
    dw 28;
    dw 12;
    dw 12;
    dw 32;
    dw 40;
    dw 44;
    dw 12;
    dw 8;
    dw 8;
    dw 52;
    dw 52;
    dw 56;
    dw 48;
    dw 56;
    dw 60;
    dw 8;
    dw 12;
    dw 68;
    dw 64;
    dw 68;
    dw 72;
    dw 4;
    dw 12;
    dw 76;
    dw 72;
    dw 8;
    dw 80;
    dw 56;
    dw 72;
    dw 72;
    dw 92;
    dw 56;
    dw 96;
    dw 8;
    dw 88;
    dw 88;
    dw 112;
    dw 112;
    dw 116;
    dw 16;
    dw 108;
    dw 116;
    dw 120;
    dw 84;
    dw 84;
    dw 128;
    dw 124;
    dw 128;
    dw 132;
    dw 24;
    dw 16;
    dw 28;
    dw 24;
    dw 16;
    dw 28;
    dw 24;
    dw 16;
    dw 28;
    dw 24;
    dw 16;
    dw 28;
    dw 24;
    dw 16;
    dw 28;
    dw 24;
    dw 16;
    dw 28;
    dw 24;
    dw 16;
    dw 28;

    mul_offsets_ptr_loc:
    dw 8;
    dw 8;
    dw 20;
    dw 0;
    dw 20;
    dw 24;
    dw 32;
    dw 36;
    dw 28;
    dw 8;
    dw 36;
    dw 40;
    dw 36;
    dw 36;
    dw 48;
    dw 36;
    dw 60;
    dw 64;
    dw 80;
    dw 84;
    dw 76;
    dw 84;
    dw 72;
    dw 88;
    dw 92;
    dw 96;
    dw 100;
    dw 56;
    dw 56;
    dw 104;
    dw 0;
    dw 104;
    dw 108;
    dw 120;
    dw 124;
    dw 100;
    dw 8;
    dw 8;
    dw 20;
    dw 8;
    dw 8;
    dw 20;
    dw 8;
    dw 8;
    dw 20;
    dw 8;
    dw 8;
    dw 20;

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
    dw 28;
    dw 12;
    dw 32;
    dw 24;
    dw 32;
    dw 36;
    dw 36;
    dw 40;
    dw 16;
    dw 28;
    dw 12;
    dw 32;
    dw 28;
    dw 12;
    dw 32;
    dw 28;
    dw 12;
    dw 32;
    dw 28;
    dw 12;
    dw 32;
    dw 28;
    dw 12;
    dw 32;

    mul_offsets_ptr_loc:
    dw 4;
    dw 4;
    dw 16;
    dw 0;
    dw 0;
    dw 20;
    dw 0;
    dw 20;
    dw 24;
    dw 8;
    dw 0;
    dw 28;
    dw 4;
    dw 4;
    dw 16;
    dw 4;
    dw 4;
    dw 16;
    dw 4;
    dw 4;
    dw 16;
    dw 4;
    dw 4;
    dw 16;

    output_offsets_ptr_loc:
    dw 40;
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
    dw 20;
    dw 12;
    dw 24;
    dw 8;
    dw 8;
    dw 28;
    dw 4;
    dw 40;
    dw 36;
    dw 4;
    dw 44;
    dw 40;
    dw 44;
    dw 48;
    dw 4;
    dw 52;
    dw 56;
    dw 8;
    dw 20;
    dw 12;
    dw 24;
    dw 20;
    dw 12;
    dw 24;

    mul_offsets_ptr_loc:
    dw 4;
    dw 4;
    dw 16;
    dw 0;
    dw 16;
    dw 20;
    dw 28;
    dw 32;
    dw 24;
    dw 32;
    dw 32;
    dw 36;
    dw 32;
    dw 48;
    dw 52;
    dw 4;
    dw 4;
    dw 16;
    dw 4;
    dw 4;
    dw 16;
    dw 4;
    dw 4;
    dw 16;

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
    let mul_mod_n = 38;
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
    dw 24;
    dw 120;
    dw 124;
    dw 32;
    dw 128;
    dw 132;
    dw 132;
    dw 136;
    dw 140;
    dw 44;
    dw 148;
    dw 152;
    dw 152;
    dw 156;
    dw 160;
    dw 56;
    dw 164;
    dw 168;
    dw 168;
    dw 172;
    dw 176;
    dw 176;
    dw 180;
    dw 184;
    dw 184;
    dw 188;
    dw 192;
    dw 192;
    dw 196;
    dw 200;
    dw 144;
    dw 208;
    dw 212;
    dw 24;
    dw 216;
    dw 220;
    dw 32;
    dw 224;
    dw 228;
    dw 228;
    dw 232;
    dw 236;
    dw 44;
    dw 244;
    dw 248;
    dw 248;
    dw 252;
    dw 256;
    dw 56;
    dw 260;
    dw 264;
    dw 264;
    dw 268;
    dw 272;
    dw 272;
    dw 276;
    dw 280;
    dw 280;
    dw 284;
    dw 288;
    dw 288;
    dw 292;
    dw 296;
    dw 240;
    dw 304;
    dw 308;
    dw 316;
    dw 320;
    dw 312;
    dw 24;
    dw 120;
    dw 124;

    mul_offsets_ptr_loc:
    dw 0;
    dw 0;
    dw 80;
    dw 8;
    dw 8;
    dw 84;
    dw 80;
    dw 0;
    dw 88;
    dw 84;
    dw 8;
    dw 92;
    dw 88;
    dw 0;
    dw 96;
    dw 92;
    dw 8;
    dw 100;
    dw 96;
    dw 0;
    dw 104;
    dw 100;
    dw 8;
    dw 108;
    dw 104;
    dw 0;
    dw 112;
    dw 108;
    dw 8;
    dw 116;
    dw 28;
    dw 0;
    dw 120;
    dw 36;
    dw 0;
    dw 128;
    dw 40;
    dw 80;
    dw 136;
    dw 140;
    dw 144;
    dw 124;
    dw 48;
    dw 0;
    dw 148;
    dw 52;
    dw 80;
    dw 156;
    dw 60;
    dw 0;
    dw 164;
    dw 64;
    dw 80;
    dw 172;
    dw 68;
    dw 88;
    dw 180;
    dw 72;
    dw 96;
    dw 188;
    dw 76;
    dw 104;
    dw 196;
    dw 200;
    dw 204;
    dw 160;
    dw 4;
    dw 204;
    dw 208;
    dw 28;
    dw 8;
    dw 216;
    dw 36;
    dw 8;
    dw 224;
    dw 40;
    dw 84;
    dw 232;
    dw 236;
    dw 240;
    dw 220;
    dw 48;
    dw 8;
    dw 244;
    dw 52;
    dw 84;
    dw 252;
    dw 60;
    dw 8;
    dw 260;
    dw 64;
    dw 84;
    dw 268;
    dw 68;
    dw 92;
    dw 276;
    dw 72;
    dw 100;
    dw 284;
    dw 76;
    dw 108;
    dw 292;
    dw 296;
    dw 300;
    dw 256;
    dw 12;
    dw 300;
    dw 304;
    dw 16;
    dw 212;
    dw 312;
    dw 20;
    dw 308;
    dw 316;
    dw 0;
    dw 0;
    dw 80;
    dw 0;
    dw 0;
    dw 80;

    output_offsets_ptr_loc:
    dw 320;
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
    dw 20;
    dw 28;
    dw 16;
    dw 32;
    dw 12;
    dw 36;
    dw 24;
    dw 40;
    dw 0;
    dw 36;
    dw 44;
    dw 40;
    dw 4;
    dw 48;
    dw 52;
    dw 20;
    dw 28;
    dw 16;
    dw 20;
    dw 28;
    dw 16;
    dw 20;
    dw 28;
    dw 16;

    mul_offsets_ptr_loc:
    dw 8;
    dw 20;
    dw 32;
    dw 44;
    dw 48;
    dw 28;
    dw 8;
    dw 20;
    dw 32;
    dw 8;
    dw 20;
    dw 32;
    dw 8;
    dw 20;
    dw 32;
    dw 8;
    dw 20;
    dw 32;
    dw 8;
    dw 20;
    dw 32;
    dw 8;
    dw 20;
    dw 32;

    output_offsets_ptr_loc:
    dw 52;
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
    dw 32;
    dw 8;
    dw 36;
    dw 28;
    dw 36;
    dw 40;
    dw 32;
    dw 8;
    dw 36;
    dw 32;
    dw 8;
    dw 36;
    dw 32;
    dw 8;
    dw 36;
    dw 32;
    dw 8;
    dw 36;
    dw 32;
    dw 8;
    dw 36;
    dw 32;
    dw 8;
    dw 36;

    mul_offsets_ptr_loc:
    dw 0;
    dw 0;
    dw 24;
    dw 0;
    dw 24;
    dw 28;
    dw 4;
    dw 0;
    dw 32;
    dw 12;
    dw 40;
    dw 44;
    dw 16;
    dw 16;
    dw 48;
    dw 20;
    dw 20;
    dw 52;
    dw 0;
    dw 0;
    dw 24;
    dw 0;
    dw 0;
    dw 24;

    output_offsets_ptr_loc:
    dw 40;
    dw 44;
    dw 48;
    dw 52;
    dw 16;
}
