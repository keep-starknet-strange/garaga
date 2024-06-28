%builtins range_check poseidon range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.alloc import alloc

from definitions import bn, bls, UInt384, one_E12D, N_LIMBS, BASE, E12D

from pairing import final_exponentiation
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
    let (local input_bn: felt*) = alloc();
    let (local input_bls: felt*) = alloc();
    %{
        from random import randint
        import random
        from tools.gnark_cli import GnarkCLI
        from hydra.definitions import CURVES, PyFelt, CurveID, get_base_field, tower_to_direct
        from hydra.hints.io import bigint_split, flatten, pack_e12d
        random.seed(0)

        clis = [GnarkCLI(CurveID(ids.bn.CURVE_ID)), GnarkCLI(CurveID(ids.bls.CURVE_ID))]
        inputs = []
        expected_outputs = []
        for cli in clis:
            order = CURVES[cli.curve_id.value].n
            field = get_base_field(cli.curve_id.value)
            pairs = []
            n_pairs = 1
            for _ in range(n_pairs):
                n1, n2 = randint(1, order), randint(1, order)
                pairs.extend(cli.nG1nG2_operation(n1, n2, raw=True))

            XT = cli.miller(input=pairs, n_pairs=1, raw=True)
            ET = cli.pair(input=pairs, n_pairs=1)
            XT = [field(x) for x in XT]
            ET = [field(x) for x in ET]
            XD = tower_to_direct(XT, cli.curve_id.value, 12)
            ED = tower_to_direct(ET, cli.curve_id.value, 12)
            inputs.append(XD)
            expected_outputs.append([x.value for x in ED])



        segments.write_arg(ids.input_bn, flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in inputs[0]]))
        segments.write_arg(ids.input_bls, flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in inputs[1]]))
    %}

    let (local res_bn: E12D) = final_exponentiation(cast(input_bn, E12D*), bn.CURVE_ID);

    let (local res_bls: E12D) = final_exponentiation(cast(input_bls, E12D*), bls.CURVE_ID);

    %{
        res_bn = pack_e12d(ids.res_bn, 4, 2**96)
        assert res_bn == expected_outputs[0]
        #print(f"res_bn: {res_bn}")
        #print(f"expected_bn: {expected_outputs[0]}\n")
    %}
    %{
        res_bls = pack_e12d(ids.res_bls, 4, 2**96)
        assert res_bls == expected_outputs[1]
        #print(f"res_bls: {res_bls}")
        #print(f"expected_bls: {expected_outputs[1]}")
    %}

    %{ print(f"Test Passed\n") %}
    return ();
}
