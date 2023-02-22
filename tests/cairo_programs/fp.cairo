%builtins output range_check

from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.cairo_secp.constants import BASE
from starkware.cairo.common.uint256 import SHIFT

const SHIFT_MIN_BASE = SHIFT - BASE;

func add_bigint3{range_check_ptr}(a: felt*, b: felt*) -> felt {
    let (__fp__, _) = get_fp_and_pc();
    tempvar sum_low = [a] + [b];
    tempvar sum_mid = a[1] + b[1];
    tempvar sum_high = a[2] + b[2];

    %{
        has_carry_low = 1 if ids.sum_low >= ids.BASE else 0
        memory[fp+11] = has_carry_low
        memory[fp+12] = 1 if (ids.sum_mid + has_carry_low) >= ids.BASE else 0
    %}
    ap += 2;
    if ([fp + 11] != 0) {
        if ([fp + 12] != 0) {
            [fp + 13] = sum_low - BASE, ap++;
            [fp + 14] = sum_mid + 1 - BASE, ap++;
            [fp + 15] = sum_high + 1, ap++;
            assert [range_check_ptr + 0] = [fp + 13] + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = [fp + 14] + (SHIFT_MIN_BASE);
            tempvar range_check_ptr = range_check_ptr + 2;

            return fp + 13;
        } else {
            [fp + 13] = sum_low - BASE, ap++;
            [fp + 14] = sum_mid + 1, ap++;
            [fp + 15] = sum_high, ap++;
            assert [range_check_ptr + 0] = [fp + 13] + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = [fp + 14] + (SHIFT_MIN_BASE);
            tempvar range_check_ptr = range_check_ptr + 2;

            return fp + 13;
        }
    } else {
        if ([fp + 12] != 0) {
            [fp + 13] = sum_low, ap++;
            [fp + 14] = sum_mid - BASE, ap++;
            [fp + 15] = sum_high + 1, ap++;
            assert [range_check_ptr + 0] = [fp + 13] + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = [fp + 14] + (SHIFT_MIN_BASE);
            tempvar range_check_ptr = range_check_ptr + 2;

            return fp + 13;
        } else {
            [fp + 13] = sum_low, ap++;
            [fp + 14] = sum_mid, ap++;
            [fp + 15] = sum_high, ap++;
            assert [range_check_ptr + 0] = [fp + 13] + (SHIFT_MIN_BASE);
            assert [range_check_ptr + 1] = [fp + 14] + (SHIFT_MIN_BASE);
            tempvar range_check_ptr = range_check_ptr + 2;

            return fp + 13;
        }
    }
}
func main{output_ptr: felt*, range_check_ptr}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local Xb: (felt, felt, felt) = (BASE, BASE, 12);
    local Yb: (felt, felt, felt) = (9, 10, 11);
    let res = add_bigint3(&Xb, &Yb);
    let (__fp__, _) = get_fp_and_pc();
    tempvar y = fp + 1;
    return ();
}
