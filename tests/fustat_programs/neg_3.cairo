%builtins range_check poseidon range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin
from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from starkware.cairo.common.alloc import alloc

from definitions import bn, bls, UInt384, one_E12D, N_LIMBS, BASE, G1Point
from utils import scalar_to_base_neg3_le, neg_3_pow_alloc_80
from modulo_circuit import ExtensionFieldModuloCircuit

func main{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}() {
    alloc_locals;
    let (neg_3_pow) = neg_3_pow_alloc_80();
    let (p, n, ps, ns) = scalar_to_base_neg3_le(123, neg_3_pow);
    let (p, n, ps, ns) = scalar_to_base_neg3_le(2 ** 127, neg_3_pow);

    %{ print(ids.p, ids.n) %}
    return ();
}
