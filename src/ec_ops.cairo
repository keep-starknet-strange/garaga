from src.definitions import is_zero_mod_P, get_P
from src.precompiled_circuits.ec import get_IS_ON_CURVE_G1_G2_circuit
from src.modulo_circuit import run_modulo_circuit, ModuloCircuit
from starkware.cairo.common.cairo_builtins import ModBuiltin, UInt384

func is_on_curve_g1_g2{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(curve_id: felt, input: felt*) -> (res: felt) {
    alloc_locals;
    let (P) = get_P(curve_id);

    let (circuit) = get_IS_ON_CURVE_G1_G2_circuit(curve_id);
    let (output: felt*) = run_modulo_circuit(circuit, input);
    let (check_g1: felt) = is_zero_mod_P([cast(output, UInt384*)], P);
    let (check_g20: felt) = is_zero_mod_P([cast(output + UInt384.SIZE, UInt384*)], P);
    let (check_g21: felt) = is_zero_mod_P([cast(output + 2 * UInt384.SIZE, UInt384*)], P);

    if (check_g1 == 0) {
        return (res=0);
    }
    if (check_g20 == 0) {
        return (res=0);
    }
    if (check_g21 == 0) {
        return (res=0);
    }
    return (res=1);
}
