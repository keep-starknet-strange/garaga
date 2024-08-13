%builtins range_check poseidon range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.alloc import alloc

from definitions import bn, bls, UInt384, one_E12D, N_LIMBS, BASE, G1Point

from ec_ops import derive_EC_point_from_entropy
from modulo_circuit import ExtensionFieldModuloCircuit

func main{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local entropy0: felt;
    local entropy1: felt;
    local entropy2: felt;
    local entropy3: felt;
    local entropy4: felt;
    local entropy5: felt;
    local entropy6: felt;
    local entropy7: felt;
    local entropy8: felt;
    local entropy9: felt;
    %{
        from random import randint
        from garaga.definitions import STARK
        entropies = [randint(0, STARK-1) for _ in range(10)]
        for i in range(10):
            setattr(ids, f"entropy{i}", entropies[i])
    %}

    let (random_point: G1Point) = derive_EC_point_from_entropy(bn.CURVE_ID, entropy0, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bn.CURVE_ID, entropy1, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bn.CURVE_ID, entropy2, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bn.CURVE_ID, entropy3, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bn.CURVE_ID, entropy4, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bn.CURVE_ID, entropy5, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bn.CURVE_ID, entropy6, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bn.CURVE_ID, entropy7, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bn.CURVE_ID, entropy8, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bn.CURVE_ID, entropy9, 0);

    let (random_point: G1Point) = derive_EC_point_from_entropy(bls.CURVE_ID, entropy0, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bls.CURVE_ID, entropy1, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bls.CURVE_ID, entropy2, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bls.CURVE_ID, entropy3, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bls.CURVE_ID, entropy4, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bls.CURVE_ID, entropy5, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bls.CURVE_ID, entropy6, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bls.CURVE_ID, entropy7, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bls.CURVE_ID, entropy8, 0);
    let (random_point: G1Point) = derive_EC_point_from_entropy(bls.CURVE_ID, entropy9, 0);

    return ();
}
