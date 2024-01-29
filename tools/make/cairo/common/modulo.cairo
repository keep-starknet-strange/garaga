from starkware.cairo.common.cairo_builtins import ModBuiltin, UInt384
from starkware.cairo.common.math import safe_div, unsigned_div_rem
from starkware.cairo.common.registers import get_label_location

const BATCH_SIZE = 8;

func div_ceil{range_check_ptr}(x: felt, y: felt) -> felt {
    let (q, r) = unsigned_div_rem(x, y);
    if (r != 0) {
        return q + 1;
    } else {
        return q;
    }
}

// Fills the first instance of the add_mod and mul_mod builtins and calls the fill_memory hint to
// fill the rest of the instances and the missing values in the values table.
//
// This function works only for batch_size=8. If you are using a mod builtin with a different
// batch_size, you should fill the first instances and use the fill_memory hint directly.
func run_mod_p_circuit{range_check_ptr, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*}(
    p: UInt384,
    values_ptr: UInt384*,
    add_mod_offsets_ptr: felt*,
    add_mod_n: felt,
    mul_mod_offsets_ptr: felt*,
    mul_mod_n: felt,
) {
    let add_mod_n_instances = div_ceil(add_mod_n, BATCH_SIZE);
    assert add_mod_ptr.p = p;
    assert add_mod_ptr.values_ptr = values_ptr;
    assert add_mod_ptr.offsets_ptr = add_mod_offsets_ptr;
    assert add_mod_ptr.n = add_mod_n_instances * BATCH_SIZE;

    let mul_mod_n_instances = div_ceil(mul_mod_n, BATCH_SIZE);
    assert mul_mod_ptr.p = p;
    assert mul_mod_ptr.values_ptr = values_ptr;
    assert mul_mod_ptr.offsets_ptr = mul_mod_offsets_ptr;
    assert mul_mod_ptr.n = mul_mod_n_instances * BATCH_SIZE;

    %{
        from starkware.cairo.lang.builtins.modulo.mod_builtin_runner import ModBuiltinRunner

        ModBuiltinRunner.fill_memory(
            memory=memory,
            add_mod=(ids.add_mod_ptr.address_, builtin_runners["add_mod_builtin"], ids.add_mod_n),
            mul_mod=(ids.mul_mod_ptr.address_, builtin_runners["mul_mod_builtin"], ids.mul_mod_n),
        )
    %}

    let add_mod_ptr = add_mod_ptr + ModBuiltin.SIZE * add_mod_n_instances;
    let mul_mod_ptr = mul_mod_ptr + ModBuiltin.SIZE * mul_mod_n_instances;
    return ();
}
