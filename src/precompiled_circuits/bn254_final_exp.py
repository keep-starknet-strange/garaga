from src.extension_field_modulo_circuit import (
    ExtensionFieldModuloCircuit,
    EuclideanPolyAccumulator,
    ModuloElement,
    FieldElement,
)

from src.definitions import CURVES, BN254_ID, Curve

from src.hints.extf_mul import (
    nondeterministic_square_torus,
    nondeterministic_extension_field_mul_divmod,
)


class GaragaBn254FinalExp(ExtensionFieldModuloCircuit):
    def __init__(self, X: list[FieldElement]):
        super().__init__(
            name="GaragaBN254FinalExp", curve_id=BN254_ID, extension_degree=6
        )
        assert len(X) == 12
        self.input = self.write_elements(X)

        def square_torus(
            self: ExtensionFieldModuloCircuit, X: list[ModuloElement]
        ) -> list[ModuloElement]:
            SQ = nondeterministic_square_torus(X, self.curve_id, self.extension_degree)
            SQ = self.write_elements(SQ)
            _, s1 = self.transcript.write_limbs(SQ)
            s1 = self.write_cairo_native_felt(s1)
            # SQ = 1/2(x+ v/x) <=> v = x (2SQ - x)
            two_SQ = self.extf_add(SQ, SQ)
            min_X = self.extf_mul_by_constant(X, self.get_constant("MINUS_ONE"))
            two_SQ_min_X = self.extf_add(two_SQ, min_X)
            Q, V = nondeterministic_extension_field_mul_divmod(
                X, two_SQ_min_X, self.curve_id, self.extension_degree
            )
            # Sanity check : ensure V is indeed V(x) = 1*x.
            assert V[1].value == 1
            assert all([v.value == 0 for i, v in enumerate(V) if i != 1])

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
                nondeterministic_Q=self.acc.nondeterministic_Q + s1 * Q,
                R=R_acc,
            )

            return SQ


if __name__ == "__main__":
    from random import randint

    curve: Curve = CURVES[BN254_ID]
    X = [curve.base_field(randint(0, curve.p - 1)) for _ in range(12)]

    circuit = GaragaBn254FinalExp(X)
