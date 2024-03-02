from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from src.modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuit,
    get_void_modulo_circuit,
    get_void_extension_field_modulo_circuit,
)
from src.definitions import bn, bls

func get_IS_ON_CURVE_G1_G2_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    if (curve_id == bn.CURVE_ID) {
        return get_BN254_IS_ON_CURVE_G1_G2_circuit();
    }
    if (curve_id == bls.CURVE_ID) {
        return get_BLS12_381_IS_ON_CURVE_G1_G2_circuit();
    }
    return get_void_modulo_circuit();
}
func get_BN254_IS_ON_CURVE_G1_G2_circuit() -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 6;
    let input_len = 24;
    let witnesses_len = 24;
    let output_len = 12;
    let continuous_output = 1;
    let add_mod_n = 8;
    let mul_mod_n = 11;
    let n_assert_eq = 0;
    let name = 'is_on_curve_g1_g2';
    let curve_id = 422755579188;
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
    dw 1;
    dw 0;
    dw 0;
    dw 0;
    dw 32324006162389411176778628422;
    dw 57042285082623239461879769745;
    dw 3486998266802970665;
    dw 0;
    dw 3;
    dw 0;
    dw 0;
    dw 0;
    dw 27810052284636130223308486885;
    dw 40153378333836448380344387045;
    dw 3104278944836790958;
    dw 0;
    dw 70926583776874220189091304914;
    dw 63498449372070794915149226116;
    dw 42524369107353300;
    dw 0;

    add_offsets_ptr_loc:
    dw 80;
    dw 12;
    dw 84;
    dw 40;
    dw 44;
    dw 88;
    dw 96;
    dw 96;
    dw 100;
    dw 32;
    dw 36;
    dw 104;
    dw 112;
    dw 112;
    dw 116;
    dw 128;
    dw 132;
    dw 136;
    dw 56;
    dw 16;
    dw 140;
    dw 136;
    dw 20;
    dw 144;

    mul_offsets_ptr_loc:
    dw 28;
    dw 28;
    dw 72;
    dw 24;
    dw 24;
    dw 76;
    dw 24;
    dw 76;
    dw 80;
    dw 88;
    dw 48;
    dw 92;
    dw 40;
    dw 44;
    dw 96;
    dw 104;
    dw 52;
    dw 108;
    dw 32;
    dw 36;
    dw 112;
    dw 32;
    dw 108;
    dw 120;
    dw 36;
    dw 116;
    dw 124;
    dw 32;
    dw 116;
    dw 128;
    dw 36;
    dw 108;
    dw 132;
    dw 28;
    dw 28;
    dw 72;
    dw 28;
    dw 28;
    dw 72;
    dw 28;
    dw 28;
    dw 72;
    dw 28;
    dw 28;
    dw 72;
    dw 28;
    dw 28;
    dw 72;

    output_offsets_ptr_loc:
    dw 60;
}

func get_BLS12_381_IS_ON_CURVE_G1_G2_circuit() -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 4;
    let input_len = 24;
    let witnesses_len = 24;
    let output_len = 12;
    let continuous_output = 1;
    let add_mod_n = 8;
    let mul_mod_n = 11;
    let n_assert_eq = 0;
    let name = 'is_on_curve_g1_g2';
    let curve_id = 1815595563094369318961;
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
    dw 1;
    dw 0;
    dw 0;
    dw 0;
    dw 54880396502181392957329877674;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;
    dw 4;
    dw 0;
    dw 0;
    dw 0;

    add_offsets_ptr_loc:
    dw 72;
    dw 12;
    dw 76;
    dw 32;
    dw 36;
    dw 80;
    dw 88;
    dw 88;
    dw 92;
    dw 24;
    dw 28;
    dw 96;
    dw 104;
    dw 104;
    dw 108;
    dw 120;
    dw 124;
    dw 128;
    dw 48;
    dw 12;
    dw 132;
    dw 128;
    dw 12;
    dw 136;

    mul_offsets_ptr_loc:
    dw 20;
    dw 20;
    dw 64;
    dw 16;
    dw 16;
    dw 68;
    dw 16;
    dw 68;
    dw 72;
    dw 80;
    dw 40;
    dw 84;
    dw 32;
    dw 36;
    dw 88;
    dw 96;
    dw 44;
    dw 100;
    dw 24;
    dw 28;
    dw 104;
    dw 24;
    dw 100;
    dw 112;
    dw 28;
    dw 108;
    dw 116;
    dw 24;
    dw 108;
    dw 120;
    dw 28;
    dw 100;
    dw 124;
    dw 20;
    dw 20;
    dw 64;
    dw 20;
    dw 20;
    dw 64;
    dw 20;
    dw 20;
    dw 64;
    dw 20;
    dw 20;
    dw 64;
    dw 20;
    dw 20;
    dw 64;

    output_offsets_ptr_loc:
    dw 52;
}
