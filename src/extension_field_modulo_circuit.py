from src.modulo_circuit import ModuloCircuit, ModuloCircuitElement, WriteOps
from src.algebra import BaseField, PyFelt, Polynomial
from src.poseidon_transcript import CairoPoseidonTranscript
from src.hints.extf_mul import (
    nondeterministic_extension_field_mul_divmod,
    nondeterministic_extension_field_div,
)
from dataclasses import dataclass
from src.definitions import get_irreducible_poly, CurveID, STARK, CURVES, Curve
from pprint import pprint
from random import randint


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
        self.z_powers: list[ModuloCircuitElement] = []

    def _init_accumulator(self):
        return EuclideanPolyAccumulator(
            xy=self.constants["ZERO"],
            nondeterministic_Q=Polynomial([self.field.zero()]),
            R=[self.constants["ZERO"]] * self.extension_degree,
        )

    def write_commitment(
        self, elmt: PyFelt, add_to_transcript: bool = True
    ) -> ModuloCircuitElement:
        """
        1) Add the commitment to the list of commitments
        2) Add to transcript to precompute Z
        3) Write the commitment to the values segment and return the ModuloElement
        """
        self.commitments.append(elmt)
        if add_to_transcript:
            self.transcript.hash_limbs(elmt)
        return self.write_element(elmt, WriteOps.COMMIT)

    def write_commitments(
        self, elmts: list[PyFelt], add_to_transcript: bool = True
    ) -> (list[ModuloCircuitElement], PyFelt, PyFelt):
        vals = [self.write_commitment(elmt, add_to_transcript) for elmt in elmts]
        return vals, self.transcript.continuable_hash, self.transcript.s1

    def create_powers_of_Z(
        self, Z: PyFelt, mock: bool = False
    ) -> list[ModuloCircuitElement]:
        powers = [self.write_cairo_native_felt(Z)]
        if not mock:
            for _ in range(1, self.extension_degree + 1):
                powers.append(self.mul(powers[-1], powers[0]))
        else:
            powers = powers + [
                self.write_cairo_native_felt(self.field(Z.value**i))
                for i in range(1, self.extension_degree + 1)
            ]
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
            X_of_z = self.add(X_of_z, self.mul(X[i], self.z_powers[i - 1]))
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

    def extf_neg(self, X: list[ModuloCircuitElement]) -> list[ModuloCircuitElement]:
        """
        Negates a polynomial with coefficients `X`.
        Returns R = [-x0, -x1, -x2, ... -xn-1] mod p
        """
        return [self.neg(x_i) for x_i in X]

    def extf_sub(
        self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]
    ) -> list[ModuloCircuitElement]:
        return self.extf_add(X, self.extf_neg(Y))

    def extf_mul(
        self,
        X: list[ModuloCircuitElement],
        Y: list[ModuloCircuitElement],
        extension_degree: int,
    ) -> list[ModuloCircuitElement]:
        """
        Multiply in the extension field X * Y mod irreducible_poly
        Commit to R and accumulates Q.
        """
        assert len(X) == len(Y) == extension_degree
        Q, R = nondeterministic_extension_field_mul_divmod(
            X, Y, self.curve_id, self.extension_degree
        )
        R, s0, s1 = self.write_commitments(R)

        Q = Polynomial(Q)
        s1 = self.field(s1)
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

    def extf_square(
        self,
        X: list[ModuloCircuitElement],
        extension_degree: int,
    ) -> list[ModuloCircuitElement]:
        """
        Multiply in the extension field X * Y mod irreducible_poly
        Commit to R and accumulates Q.
        """
        assert len(X) == extension_degree
        Q, R = nondeterministic_extension_field_mul_divmod(
            X, X, self.curve_id, self.extension_degree
        )
        R, s0, s1 = self.write_commitments(R)

        Q = Polynomial(Q)
        s1 = self.field(s1)
        Q_acc: Polynomial = self.acc.nondeterministic_Q + s1 * Q
        s1 = self.write_cairo_native_felt(s1)

        # Evaluate polynomials X(z), Y(z) inside circuit.
        X_of_z = self.eval_poly_in_precomputed_Z(X)
        XY_of_z = self.mul(X_of_z, X_of_z)
        ci_XY_of_z = self.mul(s1, XY_of_z)
        XY_acc = self.add(self.acc.xy, ci_XY_of_z)

        # Computes R_acc = R_acc + s1 * R as a Polynomial inside circuit
        R_acc = [self.add(r_acc, self.mul(s1, r)) for r_acc, r in zip(self.acc.R, R)]

        self.acc = EuclideanPolyAccumulator(
            xy=XY_acc, nondeterministic_Q=Q_acc, R=R_acc
        )
        return R

    def extf_div(
        self,
        X: list[ModuloCircuitElement],
        Y: list[ModuloCircuitElement],
        extension_degree: int,
    ) -> list[ModuloCircuitElement]:
        assert len(X) == len(Y) == extension_degree
        x_over_y = nondeterministic_extension_field_div(
            X, Y, self.curve_id, extension_degree
        )
        add_to_transcript = True
        x_over_y, _, _ = self.write_commitments(
            x_over_y, add_to_transcript
        )  # Is it really necessary to hash this in addition to what is hashed in extf_mul right after ?
        should_be_X = self.extf_mul(x_over_y, Y, extension_degree)
        self.extf_assert_eq(should_be_X, X)

        return x_over_y

    def extf_assert_eq(
        self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]
    ):
        assert len(X) == len(Y)
        for x, y in zip(X, Y):
            self.assert_eq(x, y)

    def finalize_circuit(self):
        # print("\n Finalize Circuit")
        Q = self.acc.nondeterministic_Q.get_coeffs()
        Q = Q + [self.field.zero()] * (self.extension_degree - 1 - len(Q))
        Q, s0, s1 = self.write_commitments(Q)
        Q_of_Z = self.eval_poly_in_precomputed_Z(Q)
        P, sparsity = self.write_sparse_elements(
            get_irreducible_poly(self.curve_id, self.extension_degree).get_coeffs(),
            WriteOps.CONSTANT,
        )
        P_of_z = P[0]
        sparse_p_index = 1
        for i in range(1, len(sparsity)):
            if sparsity[i] == 1:
                P_of_z = self.add(
                    P_of_z, self.mul(P[sparse_p_index], self.z_powers[i - 1])
                )
                sparse_p_index += 1

        R_of_Z = self.eval_poly_in_precomputed_Z(self.acc.R)

        lhs = self.acc.xy
        rhs = self.add(self.mul(Q_of_Z, P_of_z), R_of_Z)
        assert lhs.value == rhs.value, f"{lhs.value} != {rhs.value}"
        return rhs

    def summarize(self):
        add_count, mul_count = self.values_segment.summarize()
        summary = {
            "circuit": self.name,
            "MULMOD": mul_count,
            "ADDMOD": add_count,
            "POSEIDON": self.transcript.permutations_count,
        }
        # TODO : add Number of poseidon.

        # pprint(summary, )
        return summary
