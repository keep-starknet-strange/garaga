from src.definitions import curves
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin, UInt384

func multi_miller_loop{
    range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}() -> E12D {
}

func final_exponentiation{
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(input: E12D, curve_id: felt) -> felt {
    alloc_locals;
    let p: UInt384 = curves.p(curve_id);
    let (circuit_add_offsets, circuit_mul_offsets) = curves.final_exp_circuits(curve_id);
    let values_ptr = cast(range_check96_ptr, UInt384*);  // Offset 0
    memcpy(dst=range_check96_ptr, src=&input, len=12 * UInt384.SIZE);  // write(Input)

    %{
        # Commit to all Ri's and the sum of Qi's given input and write to rc96 segment
        # Hash to obtain Z.
    %}

    if (check.d0 == 1) {
    }
}
