import dataclasses

import pytest

from starkware.cairo.lang.builtins.builtin_runner_test_utils import compile_and_run
from starkware.cairo.lang.builtins.modulo.instance_def import AddModInstanceDef, MulModInstanceDef
from starkware.cairo.lang.instances import all_cairo_instance
from starkware.cairo.lang.vm.vm_exceptions import SecurityError, VmException


def test_add_mod_builtin_runner():
    CODE_FORMAT = """
%builtins range_check add_mod mul_mod
from starkware.cairo.common.cairo_builtins import ModBuiltin, UInt384
from starkware.cairo.common.registers import get_label_location
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.modulo import run_mod_p_circuit

func main{{range_check_ptr, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*}}() {{
    alloc_locals;

    let p = UInt384(d0={p[0]}, d1={p[1]}, d2={p[2]}, d3={p[3]});
    let x1 = UInt384(d0={x1[0]}, d1={x1[1]}, d2={x1[2]}, d3={x1[3]});
    let x2 = UInt384(d0={x2[0]}, d1={x2[1]}, d2={x2[2]}, d3={x2[3]});
    let x3 = UInt384(d0={x3[0]}, d1={x3[1]}, d2={x3[2]}, d3={x3[3]});
    let res = UInt384(d0={res[0]}, d1={res[1]}, d2={res[2]}, d3={res[3]});

    let (local values_arr: UInt384*) = alloc();
    assert values_arr[0] = x1;
    assert values_arr[1] = x2;
    assert values_arr[2] = x3;
    assert values_arr[7] = res;

    let (local add_mod_offsets_arr: felt*) = alloc();
    assert add_mod_offsets_arr[0] = 0;   // x1
    assert add_mod_offsets_arr[1] = 12;  // x2 - x1
    assert add_mod_offsets_arr[2] = 4;   // x2
    assert add_mod_offsets_arr[3] = 16;  // (x2 - x1) * x3
    assert add_mod_offsets_arr[4] = 20;  // x1 * x3
    assert add_mod_offsets_arr[5] = 24;  // (x2 - x1) * x3 + x1 * x3

    let (local mul_mod_offsets_arr: felt*) = alloc();
    assert mul_mod_offsets_arr[0] = 12;  // x2 - x1
    assert mul_mod_offsets_arr[1] = 8;   // x3
    assert mul_mod_offsets_arr[2] = 16;  // (x2 - x1) * x3
    assert mul_mod_offsets_arr[3] = 0;   // x1
    assert mul_mod_offsets_arr[4] = 8;   // x3
    assert mul_mod_offsets_arr[5] = 20;  // x1 * x3
    assert mul_mod_offsets_arr[6] = 8;   // x3
    assert mul_mod_offsets_arr[7] = 28;  // ((x2 - x1) * x3 + x1 * x3) / x3 = x2 mod p
    assert mul_mod_offsets_arr[8] = 24;  // (x2 - x1) * x3 + x1 * x3

    run_mod_p_circuit(
        p=p,
        values_ptr=values_arr,
        add_mod_offsets_ptr=add_mod_offsets_arr,
        add_mod_n=2,
        mul_mod_offsets_ptr=mul_mod_offsets_arr,
        mul_mod_n=3,
    );
    
    return ();
}}
"""

    # Create a dummy layout.
    layout = dataclasses.replace(
        all_cairo_instance,
        builtins={
            **all_cairo_instance.builtins,
            "add_mod": AddModInstanceDef(ratio=1, word_bit_len=3, n_words=4, batch_size=8),
            "mul_mod": MulModInstanceDef(
                ratio=1, word_bit_len=3, n_words=4, batch_size=8, bits_per_part=1
            ),
        },
    )

    # A valid computation.
    compile_and_run(
        CODE_FORMAT.format(
            p=[1, 1, 0, 0],
            x1=[1, 0, 0, 0],
            x2=[2, 1, 0, 0],
            x3=[2, 0, 0, 0],
            res=[1, 0, 0, 0],
        ),
        layout=layout,
        secure_run=True,
    )

    # Test that the runner fails when a0 is too big.
    with pytest.raises(VmException, match="Expected integer at address .* to be smaller"):
        compile_and_run(
            CODE_FORMAT.format(
                p=[1, 1, 0, 0],
                x1=[8, 0, 0, 0],
                x2=[2, 1, 0, 0],
                x3=[2, 0, 0, 0],
                res=[1, 0, 0, 0],
            ),
            layout=layout,
            secure_run=True,
        )

    # Test that the runner fails when an incorrect result is given.
    with pytest.raises(SecurityError, match="Expected a .* b == c \(mod p\)"):
        compile_and_run(
            CODE_FORMAT.format(
                p=[1, 1, 0, 0],
                x1=[1, 0, 0, 0],
                x2=[2, 1, 0, 0],
                x3=[2, 0, 0, 0],
                res=[2, 0, 0, 0],
            ),
            layout=layout,
            secure_run=True,
        )
