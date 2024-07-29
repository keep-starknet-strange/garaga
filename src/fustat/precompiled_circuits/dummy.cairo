from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuit,
    get_void_modulo_circuit,
    get_void_extension_field_modulo_circuit,
)
from definitions import bn, bls
func get_DUMMY_circuit(curve_id: felt) -> (circuit: ModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let constants_ptr_len = 0;
    let input_len = 8;
    let witnesses_len = 0;
    let output_len = 24;
    let continuous_output = 1;
    let add_mod_n = 3;
    let mul_mod_n = 3;
    let n_assert_eq = 0;
    let name = 'dummy';
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
    dw 4;  // None
    dw 8;
    dw 0;
    dw 8;  // None
    dw 12;
    dw 16;
    dw 12;  // None
    dw 20;
    dw 8;

    mul_offsets_ptr_loc:
    dw 4;  // None
    dw 12;
    dw 0;
    dw 8;  // None
    dw 12;
    dw 24;
    dw 12;  // None
    dw 28;
    dw 8;

    output_offsets_ptr_loc:
    dw 8;
}
