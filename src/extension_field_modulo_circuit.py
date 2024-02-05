from src.modulo_circuit import ModuloCircuit, ModuloElement
from src.algebra import BaseField, FieldElement, Polynomial
from src.poseidon_transcript import CairoPoseidonTranscript
from src.hints.extf_mul import (
    nondeterministic_extension_field_mul_divmod,
)
from dataclasses import dataclass
from src.definitions import get_irreducible_poly, CURVES


# Accumulates equations of the form c_i * X_i(Z)*Y_i(z)
@dataclass(slots=True)
class EuclideanPolyAccumulator:
    xy: ModuloElement
    nondeterministic_Q: Polynomial
    R: list[ModuloElement]


class ExtensionFieldModuloCircuit(ModuloCircuit):
    def __init__(
        self,
        name: str,
        curve_id: int,
        extension_degree: int,
    ) -> None:
        super().__init__(name)
        self.curve_id = curve_id
        self.field = CURVES[curve_id].base_field
        self.add_constant("MINUS_ONE", self.field(-1))
        self.extension_degree = extension_degree
        self.z_powers: list[ModuloElement] = []
        self.acc: EuclideanPolyAccumulator = self._init_accumulator()
        self.transcript: CairoPoseidonTranscript = (
            CairoPoseidonTranscript(init_hash=int.from_bytes(name.encode(), "big")),
        )

    def _init_accumulator(self):
        return EuclideanPolyAccumulator(
            xy=self.write_element(self.field.zero()),
            nondeterministic_Q=Polynomial([self.field.zero()]),
            R=[
                self.write_element(self.field.zero())
                for _ in range(self.extension_degree)
            ],
        )

    def create_powers_of_Z(self, Z: FieldElement) -> list[ModuloElement]:
        powers = [self.write_element(Z)]
        for _ in range(1, self.extension_degree):
            powers.append(self.mul(powers[-1], powers[0]))
        self.z_powers = powers
        return powers

    def eval_poly_in_precomputed_Z(self, X: list[ModuloElement]) -> ModuloElement:
        """
        Evaluates a polynomial with coefficients `X` at precomputed powers of z.
        X(z) = X_0 + X_1 * z + X_2 * z^2 + ... + X_n * z^n
        """
        assert len(X) <= len(
            self.z_powers
        ), "Length of X cannot be greater than length of z_powers."

        X_of_z = X[0]
        for i in range(1, len(X)):
            X_of_z = self.add(X_of_z, self.mul(X[i], self.z_powers[i]))
        return X_of_z

    def extf_add(
        self, X: list[ModuloElement], Y: list[ModuloElement]
    ) -> list[ModuloElement]:
        return [self.add(x_i, y_i) for x_i, y_i in zip(X, Y)]

    def extf_mul_by_constant(
        self, X: list[ModuloElement], c: ModuloElement
    ) -> list[ModuloElement]:
        assert type(c) == ModuloElement
        return [self.mul(x_i, c) for x_i in X]

    def extf_mul(
        self,
        X: list[ModuloElement],
        Y: list[ModuloElement],
    ) -> list[ModuloElement]:
        Q, R = nondeterministic_extension_field_mul_divmod(
            X, Y, self.curve_id, self.extension_degree
        )

        R = self.write_elements(R)
        (_, s1) = self.transcript.write_limbs(R)
        s1 = FieldElement(s1, self.field)
        Q_acc: Polynomial = self.acc.nondeterministic_Q + s1 * Q
        s1 = self.write_cairo_native_felt(s1)

        # Evaluate polynomials X(z), Y(z) inside circuit.
        X_of_z = self.eval_poly_in_precomputed_Z(X)
        Y_of_z = self.eval_poly_in_precomputed_Z(Y)
        XY_of_z = self.mul(X_of_z, Y_of_z)
        ci_XY_of_z = self.mul(s1, XY_of_z)
        XY_acc = self.add(self.acc.xy, ci_XY_of_z)

        # Computes R_acc = R_acc + s1 * R as a Polynomial inside circuit
        R_acc = [self.add(r_acc, self.mul(s1, r)) for r_acc, r in zip(self.acc.R, R)]

        self.acc = EuclideanPolyAccumulator(
            xy=XY_acc, nondeterministic_Q=Q_acc, R=R_acc
        )
        return R

    def finalize_circuit(self):
        Q = self.acc.nondeterministic_Q.get_coeffs()
        Q = Q + [self.field.zero()] * (self.extension_degree - 1 - len(Q))
        Q = self.write_elements(Q)
        Q_of_Z = self.eval_poly_in_precomputed_Z(Q)
        P, sparsity = self.write_sparse_elements(
            get_irreducible_poly(self.curve_id, self.extension_degree).get_coeffs()
        )

        P_of_z = P[0]
        for i in range(1, len(P)):
            if sparsity[i] == 1:
                P_of_z = self.add(P_of_z, self.mul(P[i], self.z_powers[i]))

        R_of_Z = self.eval_poly_in_precomputed_Z(self.acc.R)

        lhs = self.acc.xy
        rhs = self.add(Q_of_Z, self.mul(P_of_z, R_of_Z))
        assert lhs.elmt == rhs.elmt
        return rhs
