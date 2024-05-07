from src.definitions import is_zero_mod_P, get_P, G1Point, get_b, get_fp_gen, verify_zero4, BASE
from src.precompiled_circuits.ec import (
    get_IS_ON_CURVE_G1_G2_circuit,
    get_DERIVE_POINT_FROM_X_circuit,
)
from src.modulo_circuit import run_modulo_circuit, ModuloCircuit
from starkware.cairo.common.cairo_builtins import ModBuiltin, UInt384, PoseidonBuiltin
from starkware.cairo.common.alloc import alloc
from src.utils import felt_to_UInt384

func is_on_curve_g1_g2{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(curve_id: felt, input: felt*) -> (res: felt) {
    alloc_locals;
    let (P) = get_P(curve_id);

    let (circuit) = get_IS_ON_CURVE_G1_G2_circuit(curve_id);
    let (output: felt*) = run_modulo_circuit(circuit, input);
    let (check_g1: felt) = is_zero_mod_P([cast(output, UInt384*)], P);
    let (check_g20: felt) = is_zero_mod_P([cast(output + UInt384.SIZE, UInt384*)], P);
    let (check_g21: felt) = is_zero_mod_P([cast(output + 2 * UInt384.SIZE, UInt384*)], P);

    if (check_g1 == 0) {
        return (res=0);
    }
    if (check_g20 == 0) {
        return (res=0);
    }
    if (check_g21 == 0) {
        return (res=0);
    }
    return (res=1);
}

struct DerivePointFromXOutput {
    rhs: UInt384,  // x^3 + ax + b
    grhs: UInt384,  // g * (x^3+ax+b)
    should_be_rhs: UInt384,
    should_be_grhs: UInt384,
    y_try: UInt384,
}

func derive_EC_point_from_entropy{
    range_check_ptr,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
    poseidon_ptr: PoseidonBuiltin*,
}(curve_id: felt, entropy: felt, attempt: felt) -> (res: G1Point) {
    %{ print(f"Attempt : {ids.attempt}") %}
    alloc_locals;
    local rhs_from_x_is_a_square_residue: felt;
    %{
        from starkware.python.math_utils import is_quad_residue
        from src.definitions import CURVES
        a = CURVES[ids.curve_id].a
        b = CURVES[ids.curve_id].b
        p = CURVES[ids.curve_id].p
        rhs = (ids.entropy**3 + a*ids.entropy + b) % p
        ids.rhs_from_x_is_a_square_residue = is_quad_residue(rhs, p)
    %}
    let (x_384: UInt384) = felt_to_UInt384(entropy);
    let (b_Weirstrass: UInt384) = get_b(curve_id);
    let (fp_generator: UInt384) = get_fp_gen(curve_id);
    let (P: UInt384) = get_P(curve_id);
    let (circuit) = get_DERIVE_POINT_FROM_X_circuit(curve_id);

    let (input: UInt384*) = alloc();
    assert input[0] = x_384;
    assert input[1] = b_Weirstrass;
    assert input[2] = fp_generator;

    let (output_array: felt*) = run_modulo_circuit(circuit, cast(input, felt*));
    let output: DerivePointFromXOutput* = cast(output_array, DerivePointFromXOutput*);

    if (rhs_from_x_is_a_square_residue != 0) {
        // Assert should_be_rhs == rhs
        verify_zero4(
            UInt384(
                output.rhs.d0 - output.should_be_rhs.d0,
                output.rhs.d1 - output.should_be_rhs.d1,
                output.rhs.d2 - output.should_be_rhs.d2,
                output.rhs.d3 - output.should_be_rhs.d3,
            ),
            P,
        );
        return (res=G1Point(x_384, output.y_try));
    } else {
        // Assert should_be_grhs == grhs & Retry.
        verify_zero4(
            UInt384(
                output.grhs.d0 - output.should_be_grhs.d0,
                output.grhs.d1 - output.should_be_grhs.d1,
                output.grhs.d2 - output.should_be_grhs.d2,
                output.grhs.d3 - output.should_be_grhs.d3,
            ),
            P,
        );
        assert poseidon_ptr[0].input.s0 = entropy;
        assert poseidon_ptr[0].input.s1 = attempt;
        assert poseidon_ptr[0].input.s2 = 2;
        let new_entropy = poseidon_ptr[0].output.s0;
        let poseidon_ptr = poseidon_ptr + PoseidonBuiltin.SIZE;
        return derive_EC_point_from_entropy(curve_id, new_entropy, attempt + 1);
    }
}
