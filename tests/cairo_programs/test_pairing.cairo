%builtins range_check poseidon range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.alloc import alloc

from src.definitions import bn, bls, UInt384, one_E12D, N_LIMBS, BASE, E12D

from src.pairing import multi_pairing, G1G2Pair
from src.modulo_circuit import ExtensionFieldModuloCircuit

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
        from tools.gnark_cli import GnarkCLI
        from src.definitions import CURVES, PyFelt, CurveID, get_base_field, tower_to_direct
        from src.hints.io import bigint_split, flatten, pack_e12d

        ids.n_pairs = program_input['n_pairs']
        ids.curve_id=program_input['curve_id']
        n1s, n2s = program_input['n1s'], program_input['n2s']

        def prepare_inputs_and_expected_outputs(cli, n_pairs):
            order = CURVES[cli.curve_id.value].n
            field = get_base_field(cli.curve_id.value)
            pairs = []
            for i in range(n_pairs):
                n1, n2 = n1s[i], n2s[i]
                pairs.extend(cli.nG1nG2_operation(n1, n2, raw=True))

            inputs = flatten([bigint_split(x, ids.N_LIMBS, ids.BASE) for x in pairs])
            ET = cli.pair(input=pairs, n_pairs=n_pairs)
            ET = [field(x) for x in ET]
            ED = tower_to_direct(ET, cli.curve_id.value, 12)

            expected_outputs=[x.value for x in ED]
            return inputs, expected_outputs

        cli = GnarkCLI(CurveID(ids.curve_id))
        inputs, expected_outputs = prepare_inputs_and_expected_outputs(cli, ids.n_pairs)

        segments.write_arg(ids.inputs, inputs)
    %}

    let (local res: E12D) = multi_pairing(cast(inputs, G1G2Pair*), n_pairs, curve_id);
    %{
        res = pack_e12d(ids.res, 4, 2**96)
        #print(f"res: {[hex(x) for x in res]}")
        #print(f"expected: {[hex(x) for x in expected_outputs]}\n")
        assert res == expected_outputs, f"res: {res}, expected: {expected_outputs}"
    %}

    %{ print(f"Test Passed\n") %}
    return ();
}
