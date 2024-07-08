%builtins range_check range_check96 add_mod mul_mod
from starkware.cairo.common.cairo_builtins import ModBuiltin

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, BitwiseBuiltin, UInt384
from starkware.cairo.common.registers import get_label_location
from starkware.cairo.common.modulo import run_mod_p_circuit
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.alloc import alloc

// Computes the polynomial f(x) = x^8 + 5*x^2 + 1.
func apply_poly{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(x: UInt384*, p: UInt384) -> (res: UInt384*) {
    // Copy inputs and constants into the values_ptr segment.
    memcpy(dst=range_check96_ptr, src=x, len=UInt384.SIZE);
    let (constants_ptr) = get_label_location(constants);
    memcpy(dst=range_check96_ptr + UInt384.SIZE, src=constants_ptr, len=2 * UInt384.SIZE);
    let values_ptr = cast(range_check96_ptr, UInt384*);
    let range_check96_ptr = range_check96_ptr + 36;

    let (add_mod_offsets_ptr) = get_label_location(add_offsets);
    let (mul_mod_offsets_ptr) = get_label_location(mul_offsets);
    run_mod_p_circuit(
        p=p,
        values_ptr=values_ptr,
        add_mod_offsets_ptr=add_mod_offsets_ptr,
        add_mod_n=2,
        mul_mod_offsets_ptr=mul_mod_offsets_ptr,
        mul_mod_n=4,
    );

    return (res=values_ptr + 32);

    // values_ptr points to a segment within the range_check96_ptr segment that looks like this:
    //
    // offset    value
    // 0         x
    // 4         1
    // 8         5
    // 12        x^2
    // 16        x^4
    // 20        x^8
    // 24        5*x^2
    // 28        x^8 + 5*x^2
    // 32        x^8 + 5*x^2 + 1

    constants:
    dw 1;
    dw 0;
    dw 0;
    dw 0;

    dw 5;
    dw 0;
    dw 0;
    dw 0;

    add_offsets:
    dw 20;  // x^8
    dw 24;  // 5*x^2
    dw 28;  // x^8 + 5*x^2

    dw 4;  // 1
    dw 28;  // x^8 + 5*x^2
    dw 32;  // x^8 + 5*x^2 + 1

    // // Placeholders (copies of the first 3 offsets):
    dw 20;
    dw 24;
    dw 28;
    dw 20;
    dw 24;
    dw 28;
    dw 20;
    dw 24;
    dw 28;
    dw 20;
    dw 24;
    dw 28;
    dw 20;
    dw 24;
    dw 28;
    dw 20;
    dw 24;
    dw 28;

    mul_offsets:
    dw 0;  // x
    dw 0;  // x
    dw 12;  // x^2

    dw 12;  // x^2
    dw 12;  // x^2
    dw 16;  // x^4

    dw 16;  // x^4
    dw 16;  // x^4
    dw 20;  // x^8

    dw 8;  // 5
    dw 12;  // x^2
    dw 24;  // 5*x^2

    // Placeholders (copies of the first 3 offsets):
    dw 0;
    dw 0;
    dw 12;
    dw 0;
    dw 0;
    dw 12;
    dw 0;
    dw 0;
    dw 12;
    dw 0;
    dw 0;
    dw 12;
}

func main{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}() {
    alloc_locals;

    let p = UInt384(d0=0xffff, d1=0xffff, d2=0xffff, d3=0xffff);
    let (local inputs: UInt384*) = alloc();
    assert inputs[0] = UInt384(d0=0xbbbb, d1=0xaaaa, d2=0x6666, d3=0xffff);

    let res: UInt384* = apply_poly(inputs, p);
    %{ print("The result: ", hex(ids.res[0].d0), hex(ids.res[0].d1), hex(ids.res[0].d2), hex(ids.res[0].d3)) %}
    return ();
}
