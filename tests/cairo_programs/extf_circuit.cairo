%builtins range_check poseidon range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.alloc import alloc

from src.modulo_circuit import run_extension_field_modulo_circuit
from src.definitions import bn, bls, UInt384, one_E12D, N_LIMBS, BASE
from src.precompiled_circuits.sample import get_sample_circuit
func main{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (local input: felt*) = alloc();
    local input_len: felt;
    local circuit_id = 1;
    %{
        from random import randint
        import random
        from src.definitions import CURVES, PyFelt
        from src.hints.io import bigint_split, flatten
        random.seed(0)
        p = CURVES[ids.bn.CURVE_ID].p
        X=[PyFelt(randint(0, p - 1), p) for _ in range(6)]
        X=flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in X])
        print(X, len(X))
        segments.write_arg(ids.input, X)
        ids.input_len = len(X)
    %}

    let x = run_extension_field_modulo_circuit(input, input_len, bn.CURVE_ID, circuit_id);
    return ();
}
