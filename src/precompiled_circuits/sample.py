from src.definitions import Curve, CURVES, BN254_ID, STARK, PyFelt
from src.precompiled_circuits.final_exp import (
    FinalExpTorusCircuit,
    ExtensionFieldModuloCircuit,
)


def get_sample_circuit(id: int, input: list[PyFelt]) -> ExtensionFieldModuloCircuit:
    if id == 1:
        return sample_circuit_1(input)
    else:
        raise ValueError(f"Unknown circuit id: {id}")


def sample_circuit_1(input: list[PyFelt]) -> ExtensionFieldModuloCircuit:
    assert len(input) == 6, f"Expected 6 elements in input, got {len(input)}"
    circuit = FinalExpTorusCircuit("sample_circuit_1", BN254_ID, extension_degree=6)
    circuit.create_powers_of_Z(PyFelt(11, STARK))
    X, _, _ = circuit.write_commitments(input)
    s1 = circuit.transcript.RLC_coeff
    sqt = circuit.extf_mul(X, X, 6)
    # mtt = circuit.mul_torus(X, X)
    circuit.finalize_circuit()
    circuit.values_segment = circuit.values_segment.non_interactive_transform()

    circuit.print_value_segment()

    return circuit


if __name__ == "__main__":
    from random import randint, seed

    seed(0)
    curve: Curve = CURVES[BN254_ID]
    p = curve.p
    input = [PyFelt(randint(0, p - 1), p) for _ in range(6)]

    circuit = sample_circuit_1(input)
    circuit.print_value_segment()

    cairo_code = circuit.compile_circuit()
    with open("src/precompiled_circuits/sample.cairo", "w") as f:
        f.write("from starkware.cairo.common.registers import get_label_location\n\n")
        f.write(
            """
    func get_sample_circuit(id: felt) -> (
    constants_ptr: felt*,
    add_offsets_ptr: felt*,
    mul_offsets_ptr: felt*,
    left_assert_eq_offsets_ptr: felt*,
    right_assert_eq_offsets_ptr: felt*,
    poseidon_indexes_ptr: felt*,
    constants_ptr_len: felt,
    add_mod_n: felt,
    mul_mod_n: felt,
    commitments_len: felt,
    assert_eq_len: felt,
    N_Euclidean_equations: felt,
) {
    if (id == 1) {
        return get_sample_circuit_1_non_interactive_circuit();
    } else {
        return (
            cast(0, felt*),
            cast(0, felt*),
            cast(0, felt*),
            cast(0, felt*),
            cast(0, felt*),
            cast(0, felt*),
            0,
            0,
            0,
            0,
            0,
            0,
        );
    }
}
"""
        )
        f.write(cairo_code)
