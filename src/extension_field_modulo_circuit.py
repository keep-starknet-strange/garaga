from src.modulo_circuit import ModuloCircuit, ModuloCircuitElement, WriteOps
from src.algebra import BaseField, PyFelt, Polynomial
from src.poseidon_transcript import CairoPoseidonTranscript
from src.hints.extf_mul import (
    nondeterministic_extension_field_mul_divmod,
)
from dataclasses import dataclass
from src.definitions import get_irreducible_poly


# Accumulates equations of the form c_i * X_i(Z)*Y_i(z) = Q_i*P + R_i
@dataclass(slots=True)
class EuclideanPolyAccumulator:
    xy: ModuloCircuitElement
    nondeterministic_Q: Polynomial
    R: list[ModuloCircuitElement]


class ExtensionFieldModuloCircuit(ModuloCircuit):
    def __init__(
        self,
        name: str,
        curve_id: int,
        extension_degree: int,
    ) -> None:
        super().__init__(name, curve_id)
        self.extension_degree = extension_degree
        self.z_powers: list[ModuloCircuitElement] = []
        self.commitments: list[PyFelt] = []
        self.acc: EuclideanPolyAccumulator = self._init_accumulator()
        self.transcript: CairoPoseidonTranscript = CairoPoseidonTranscript(
            init_hash=int.from_bytes(name.encode(), "big")
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

    def write_commitment(self, elmt: PyFelt) -> ModuloCircuitElement:
        """
        1) Add the commitment to the list of commitments
        2) Add to transcript to precompute Z
        3) Write the commitment to the values segment and return the ModuloElement
        """
        self.commitments.append(elmt)
        self.transcript.hash_limbs(elmt)
        return self.write_element(elmt, WriteOps.COMMIT)

    def write_commitments(
        self, elmts: list[PyFelt]
    ) -> (list[ModuloCircuitElement], PyFelt, PyFelt):
        vals = [self.write_commitment(elmt) for elmt in elmts]
        return vals, self.transcript.continuable_hash, self.transcript.s1

    def create_powers_of_Z(self, Z: PyFelt) -> list[ModuloCircuitElement]:
        powers = [self.write_cairo_native_felt(Z.value)]
        for _ in range(1, self.extension_degree):
            powers.append(self.mul(powers[-1], powers[0]))
        self.z_powers = powers
        return powers

    def eval_poly_in_precomputed_Z(
        self, X: list[ModuloCircuitElement]
    ) -> ModuloCircuitElement:
        """
        Evaluates a polynomial with coefficients `X` at precomputed powers of z.
        X(z) = X_0 + X_1 * z + X_2 * z^2 + ... + X_n * z^n
        """
        assert len(X) <= len(self.z_powers), f"{len(X)} > {len(self.z_powers)}"
        X_of_z = X[0]
        for i in range(1, len(X)):
            X_of_z = self.add(X_of_z, self.mul(X[i], self.z_powers[i]))
        return X_of_z

    def extf_add(
        self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]
    ) -> list[ModuloCircuitElement]:
        """
        Adds two polynomials with coefficients `X` and `Y`.
        Returns R = [x0 + y0, x1 + y1, x2 + y2, ... + xn-1 + yn-1] mod p
        """
        assert (
            len(X) == len(Y) == self.extension_degree
        ), f"len(X)={len(X)} != len(Y)={len(Y)} != self.extension_degree={self.extension_degree}"
        return [self.add(x_i, y_i) for x_i, y_i in zip(X, Y)]

    def extf_scalar_mul(
        self, X: list[ModuloCircuitElement], c: ModuloCircuitElement
    ) -> list[ModuloCircuitElement]:
        """
        Multiplies a polynomial with coefficients `X` by a scalar `c`.
        Input : I(x) = i0 + i1*x + i2*x^2 + ... + in-1*x^n-1
        Output : O(x) = ci0 + ci1*x + ci2*x^2 + ... + cin-1*x^n-1.
        This is done in the circuit.
        """
        assert type(c) == ModuloCircuitElement
        return [self.mul(x_i, c) for x_i in X]

    def extf_mul(
        self,
        X: list[ModuloCircuitElement],
        Y: list[ModuloCircuitElement],
    ) -> list[ModuloCircuitElement]:
        """
        Multiply in the extension field X * Y mod irreducible_poly
        Commit to R and accumulates Q.
        """

        def commit_to_R_and_accumulate_Q(X, Y, Q, R):
            Q, R = nondeterministic_extension_field_mul_divmod(
                X, Y, self.curve_id, self.extension_degree
            )
            R = self.write_commitments(R)

        (_, s1) = self.transcript.hash_limbs(R)
        s1 = PyFelt(s1, self.field)
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
        Q = self.write_commitments(Q)
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
        assert lhs.emulated_felt == rhs.emulated_felt
        return rhs
