from src.extension_field_modulo_circuit import (
    ExtensionFieldModuloCircuit,
    EuclideanPolyAccumulator,
    ModuloCircuitElement,
    PyFelt,
    Polynomial,
)
from src.definitions import CURVES, BN254_ID, Curve
from src.hints.extf_mul import (
    nondeterministic_square_torus,
    nondeterministic_extension_field_mul_divmod,
)


class FinalExpCircuit(ExtensionFieldModuloCircuit):
    def __init__(self, name: str, curve_id: int, extension_degree: int):
        super().__init__(
            name=name, curve_id=curve_id, extension_degree=extension_degree
        )
        self.add_constant("MINUS_ONE", self.field(-1))

    def square_torus(
        self: ExtensionFieldModuloCircuit, X: list[ModuloCircuitElement]
    ) -> list[ModuloCircuitElement]:
        SQ: list[PyFelt] = nondeterministic_square_torus(
            X, self.curve_id, biject_from_direct=True
        )
        SQ, continuable_hash, s1 = self.write_commitments(SQ)
        s1 = self.write_cairo_native_felt(s1)
        # SQ = 1/2(x+ v/x) <=> v = x (2SQ - x)
        two_SQ = self.extf_add(SQ, SQ)
        min_X = self.extf_scalar_mul(X, self.get_constant("MINUS_ONE"))
        two_SQ_min_X = self.extf_add(two_SQ, min_X)

        # %{
        Q, V = nondeterministic_extension_field_mul_divmod(
            X, two_SQ_min_X, self.curve_id, self.extension_degree
        )
        Q = Polynomial(Q)
        # Sanity check : ensure V is indeed V(x) = 1*x.
        assert V[1].value == 1, f"V(x) = {V[1].value}"
        assert all([v.value == 0 for i, v in enumerate(V) if i != 1])
        Q_acc = self.acc.nondeterministic_Q + s1 * Q
        # %}

        X_of_z = self.eval_poly_in_precomputed_Z(X)
        Y_of_z = self.eval_poly_in_precomputed_Z(two_SQ_min_X)
        XY_of_z = self.mul(X_of_z, Y_of_z)
        ci_XY_of_z = self.mul(s1, XY_of_z)
        XY_acc = self.add(self.acc.xy, ci_XY_of_z)

        # Only add 1*ci * v
        R_acc = self.acc.R.copy()
        R_acc[1] = self.add(self.acc.R[1], s1)

        self.acc = EuclideanPolyAccumulator(
            xy=XY_acc,
            nondeterministic_Q=Q_acc,
            R=R_acc,
        )

        return SQ


class GaragaBN254FinalExp(FinalExpCircuit):
    def __init__(self, X: list[PyFelt]):
        super().__init__(
            name="GaragaBN254FinalExp", curve_id=BN254_ID, extension_degree=6
        )
        assert len(X) == 12, f"FinalExp input must be 12 elements, got {len(X)}"
        self.raw_input = X

    def final_exp(self, unsafe: bool) -> list[ModuloCircuitElement]:
        self.write_elements(X)
        # Hash input.
        self.transcript.hash_limbs_multi(X)

        MIN_9 = circuit.write_element(field(-9 % p))
        MIN_ONE = circuit.write_element(field(-1 % p))

        c_num = circuit.write_elements(X[0:6])

        c_num_full = [
            circuit.mul(MIN_ONE, circuit.add(c_num[0], circuit.mul(MIN_9, c_num[1]))),
            circuit.mul(MIN_ONE, circuit.add(c_num[2], circuit.mul(MIN_9, c_num[3]))),
            circuit.mul(MIN_ONE, circuit.add(c_num[4], circuit.mul(MIN_9, c_num[5]))),
            circuit.mul(MIN_ONE, c_num[1]),
            circuit.mul(MIN_ONE, c_num[3]),
            circuit.mul(MIN_ONE, c_num[5]),
        ]

        if unsafe:
            z_c1 = circuit.write_elements(
                [PyFelt(z[1][i][j], field) for i in range(3) for j in range(2)]
            )
        else:
            if z[1] == ((0, 0), (0, 0), (0, 0)):
                selector1 = 1
                z_c1 = circuit.write_elements(
                    [
                        field.one(),
                        field.zero(),
                        field.zero(),
                        field.zero(),
                        field.zero(),
                        field.zero(),
                    ]
                )
            else:
                selector1 = 0
                z_c1 = circuit.write_elements(
                    [PyFelt(z[1][i][j], field) for i in range(3) for j in range(2)]
                )

        z_c1_full = [
            circuit.add(z_c1[0], circuit.mul(MIN_9, z_c1[1])),
            circuit.add(z_c1[2], circuit.mul(MIN_9, z_c1[3])),
            circuit.add(z_c1[4], circuit.mul(MIN_9, z_c1[5])),
            z_c1[1],
            z_c1[3],
            z_c1[5],
        ]

        pass


if __name__ == "__main__":
    from random import randint, seed

    seed(0)
    curve: Curve = CURVES[BN254_ID]
    p = curve.p
    X = [PyFelt(randint(0, curve.p - 1), curve.p) for _ in range(12)]

    circuit = GaragaBN254FinalExp(X)
    circuit.create_powers_of_Z(PyFelt(11, p))

    M = circuit.write_elements(X[0:6])

    circuit.square_torus(M)

    print(circuit.compile_offsets())
    circuit.print_value_segment()
    fiat = circuit.values_segment.fiat_shamir()
    fiat.print()
