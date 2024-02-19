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
            xy=None,
            nondeterministic_Q=Polynomial([self.field.zero()]),
            R=[None] * self.extension_degree,
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

    def create_powers_of_Z(
        self, Z: PyFelt, mock: bool = False, max_degree: int = None
    ) -> list[ModuloCircuitElement]:
        if max_degree is None:
            max_degree = self.extension_degree
        powers = [self.write_cairo_native_felt(Z)]
        if not mock:
            for _ in range(2, max_degree + 1):
                powers.append(self.mul(powers[-1], powers[0]))
        else:
            powers = powers + [
                self.write_cairo_native_felt(self.field(Z.value**i))
                for i in range(2, max_degree + 1)
            ]
        self.z_powers = powers
        return powers

    def eval_poly_in_precomputed_Z(
        self, X: list[ModuloCircuitElement], sparse: bool = False
    ) -> ModuloCircuitElement:
        """
        Evaluates a polynomial with coefficients `X` at precomputed powers of z.
        X(z) = X_0 + X_1 * z + X_2 * z^2 + ... + X_n * z^n
        """
        assert len(X) <= len(
            self.z_powers
        ), f"{len(X)} > Zpowlen = {len(self.z_powers)}"
        sparsity = [1 if elmt != self.field.zero() else 0 for elmt in X]

        if not sparse:
            X_of_z = X[0]
            for i in range(1, len(X)):
                X_of_z = self.add(X_of_z, self.mul(X[i], self.z_powers[i - 1]))
        else:
            first_non_zero_idx = sparsity.index(1)
            if first_non_zero_idx == 0:
                X_of_z = X[0]
            else:
                X_of_z = self.mul(
                    X[first_non_zero_idx], self.z_powers[first_non_zero_idx - 1]
                )
            for i in range(first_non_zero_idx + 1, len(X)):
                if sparsity[i] == 1:
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
        return [self.sub(x, y) for x, y in zip(X, Y)]

    def extf_mul(
        self,
        X: list[ModuloCircuitElement],
        Y: list[ModuloCircuitElement],
        extension_degree: int,
        x_is_sparse: bool = False,
        y_is_sparse: bool = False,
    ) -> list[ModuloCircuitElement]:
        """
        Multiply in the extension field X * Y mod irreducible_poly
        Commit to R and accumulates Q.
        """
        Q, R = nondeterministic_extension_field_mul_divmod(
            X, Y, self.curve_id, extension_degree
        )
        R, _, _ = self.write_commitments(R)
        s1 = self.transcript.RLC_coeff
        Q = Polynomial(Q)
        s1 = self.field(s1)
        return self.accumulate_poly(s1, X, Y, Q, R, x_is_sparse, y_is_sparse)

    def accumulate_poly(
        self,
        s1: PyFelt,
        X: list[ModuloCircuitElement],
        Y: list[ModuloCircuitElement],
        Q: Polynomial,
        R: list[ModuloCircuitElement],
        x_is_sparse: bool = False,
        y_is_sparse: bool = False,
        square: bool = False,
    ):
        Q_acc: Polynomial = self.acc.nondeterministic_Q + s1 * Q
        s1 = self.write_cairo_native_felt(s1)

        # Evaluate polynomials X(z), Y(z) inside circuit.
        X_of_z = self.eval_poly_in_precomputed_Z(X, x_is_sparse)
        if square:
            Y_of_z = X_of_z
        else:
            Y_of_z = self.eval_poly_in_precomputed_Z(Y, y_is_sparse)
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
        R, _, _ = self.write_commitments(R)
        s1 = self.transcript.RLC_coeff
        s1 = self.field(s1)
        Q = Polynomial(Q)

        return self.accumulate_poly(s1, X, X, Q, R, square=True)

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
        x_over_y, _, _ = self.write_commitments(x_over_y)
        s1 = self.transcript.RLC_coeff
        s1 = self.field(s1)
        Q, R = nondeterministic_extension_field_mul_divmod(
            x_over_y, Y, self.curve_id, extension_degree
        )
        # R should be X
        Q = Polynomial(Q)
        self.accumulate_poly(s1, X=x_over_y, Y=Y, Q=Q, R=X)
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
        return True

    def summarize(self):
        add_count, mul_count = self.values_segment.summarize()
        summary = {
            "circuit": self.name,
            "MULMOD": mul_count,
            "ADDMOD": add_count,
            "POSEIDON": self.transcript.permutations_count,
        }

        return summary

    def compile_circuit(
        self,
        returns: dict[str] = {
            "ptr": [
                "constants_ptr",
                "add_offsets_ptr",
                "mul_offsets_ptr",
                "left_assert_eq_offsets_ptr",
                "right_assert_eq_offsets_ptr",
                "poseidon_indexes_ptr",
            ],
            "len": [
                "constants_ptr_len",
                "add_mod_n",
                "mul_mod_n",
                "commitments_len",
                "assert_eq_len",
                "N_Euclidean_equations",
            ],
        },
    ) -> str:
        values_segment_non_interactive = self.values_segment.non_interactive_transform()
        dw_arrays = values_segment_non_interactive.get_dw_lookups()
        dw_arrays["poseidon_indexes_ptr"] = self.transcript.poseidon_ptr_indexes
        name = values_segment_non_interactive.name
        len_returns = ":felt, ".join(returns["len"]) + ":felt,"
        ptr_returns = ":felt*, ".join(returns["ptr"]) + ":felt*,"
        code = f"func get_{name}_circuit()->({ptr_returns} {len_returns})" + "{" + "\n"

        code += "alloc_locals;\n"

        code += f"let constants_ptr_len = {len(dw_arrays['constants_ptr'])};\n"
        code += f"let add_mod_n = {len(dw_arrays['add_offsets_ptr'])};\n"
        code += f"let mul_mod_n = {len(dw_arrays['mul_offsets_ptr'])};\n"
        code += f"let commitments_len = {len(self.commitments)};\n"
        code += f"let assert_eq_len = {len(dw_arrays['left_assert_eq_offsets_ptr'])};\n"
        code += (
            f"let N_Euclidean_equations = {len(dw_arrays['poseidon_indexes_ptr'])};\n"
        )

        assert len(dw_arrays["left_assert_eq_offsets_ptr"]) == len(
            dw_arrays["right_assert_eq_offsets_ptr"]
        )

        for dw_array_name in returns["ptr"]:
            code += f"let ({dw_array_name}:felt*) = get_label_location({dw_array_name}_loc);\n"

        return_vals = 0
        code += f"return ({', '.join(returns['ptr'])}, {', '.join(returns['len'])});\n"

        for dw_array_name in returns["ptr"]:
            dw_values = dw_arrays[dw_array_name]
            code += f"\t {dw_array_name}_loc:\n"
            if dw_array_name == "constants_ptr":
                for bigint in dw_values:
                    for limb in bigint:
                        code += f"\t dw {limb};\n"
                code += "\n"

            elif dw_array_name in ["add_offsets_ptr", "mul_offsets_ptr"]:
                for left, right, result in dw_values:
                    code += (
                        f"\t dw {left};\n" + f"\t dw {right};\n" + f"\t dw {result};\n"
                    )
                    code += "\n"
            elif dw_array_name in [
                "left_assert_eq_offsets_ptr",
                "right_assert_eq_offsets_ptr",
                "poseidon_indexes_ptr",
            ]:
                for val in dw_values:
                    code += f"\t dw {val};\n"

        code += "\n"
        code += "}\n"
        return code


if __name__ == "__main__":
    from src.definitions import CURVES, CurveID

    def init_z_circuit(z: int = 2):
        c = ExtensionFieldModuloCircuit("test", CurveID.BN254.value, 6)
        c.create_powers_of_Z(c.field(z), mock=True)
        return c

    def test_eval():
        c = init_z_circuit()
        X = c.write_elements([PyFelt(1, c.field.p) for _ in range(6)])
        print("X(z)", [x.value for x in X])
        X = c.eval_poly_in_precomputed_Z(X)
        print("X(z)", X.value)
        c.print_value_segment()
        print([hex(x.value) for x in c.z_powers], len(c.z_powers))

    test_eval()

    def test_eval_sparse():
        c = init_z_circuit()
        X = c.write_elements([c.field.one(), c.field.zero(), c.field.one()])
        X = c.eval_poly_in_precomputed_Z(X, sparse=True)
        print("X(z)", X.value)
        c.print_value_segment()
        print([hex(x.value) for x in c.z_powers], len(c.z_powers))

    test_eval_sparse()
