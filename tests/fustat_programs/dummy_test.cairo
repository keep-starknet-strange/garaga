%builtins range_check poseidon range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.alloc import alloc

from definitions import bn, bls, UInt384, one_E12D, N_LIMBS, BASE, G1Point

from precompiled_circuits.dummy import get_DUMMY_circuit
from modulo_circuit import run_modulo_circuit

func main{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (circuit) = get_DUMMY_circuit(bn.CURVE_ID);
    let (input: UInt384*) = alloc();

    assert input[0] = UInt384(44, 0, 0, 0);
    assert input[1] = UInt384(4, 0, 0, 0);

    let (ouput) = run_modulo_circuit(circuit, cast(input, felt*));
    return ();
}
