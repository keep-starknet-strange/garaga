%builtins range_check poseidon range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.alloc import alloc

from definitions import bn, bls, UInt384, one_E12D, N_LIMBS, BASE, E12D

from pairing import multi_pairing, G1G2Pair
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
    let (local inputs: felt*) = alloc();

    local n_pairs: felt;
    local curve_id: felt;
    %{
        from garaga.definitions import CURVES, PyFelt, CurveID, get_base_field, tower_to_direct, G1Point, G2Point, G1G2Pair
        from garaga.hints.io import bigint_split, flatten, pack_e12d

        ids.n_pairs = program_input['n_pairs']
        ids.curve_id=program_input['curve_id']
        n1s, n2s = program_input['n1s'], program_input['n2s']
        curve_id = CurveID(ids.curve_id)

        def prepare_inputs_and_expected_outputs(curve_id, n_pairs):
            order = CURVES[curve_id.value].n
            field = get_base_field(curve_id.value)
            pair_list = []
            pairs = []
            for i in range(n_pairs):
                n1, n2 = n1s[i], n2s[i]
                p1, p2 = G1Point.get_nG(curve_id, n1), G2Point.get_nG(curve_id, n2)
                pair_list.append(G1G2Pair(p1, p2))
                pairs.extend([p1.x, p1.y, p2.x[0], p2.x[1], p2.y[0], p2.y[1]])

            inputs = flatten([bigint_split(x, ids.N_LIMBS, ids.BASE) for x in pairs])
            ET = G1G2Pair.pair(pair_list).value_coeffs
            ET = [field(x) for x in ET]
            ED = tower_to_direct(ET, curve_id.value, 12)

            expected_outputs=[x.value for x in ED]
            return inputs, expected_outputs

        inputs, expected_outputs = prepare_inputs_and_expected_outputs(curve_id, ids.n_pairs)

        segments.write_arg(ids.inputs, inputs)
    %}

    let (local res: E12D) = multi_pairing(cast(inputs, G1G2Pair*), n_pairs, curve_id);
    %{
        res = pack_e12d(ids.res, 4, 2**96)
        #print(f"res: {[hex(x) for x in res]}")
        #print(f"expected: {[hex(x) for x in expected_outputs]}\n")
        assert res == expected_outputs, f"res: {res}, expected: {expected_outputs}"
    %}

    %{ print(f"Test MultiPairing for {CurveID(ids.curve_id).name} and {ids.n_pairs} pairs Passed\n") %}
    return ();
}
