import copy
from src.modulo_circuit import WriteOps
from src.extension_field_modulo_circuit import (
    ExtensionFieldModuloCircuit,
    EuclideanPolyAccumulator,
    ModuloCircuitElement,
    PyFelt,
    Polynomial,
)
from src.definitions import CURVES, STARK, CurveID, BN254_ID, Curve
from src.hints.extf_mul import (
    nondeterministic_square_torus,
    nondeterministic_extension_field_mul_divmod,
)


class FinalExpCircuit(ExtensionFieldModuloCircuit):
    def __init__(self, name: str, curve_id: int, extension_degree: int):
        super().__init__(
            name=name, curve_id=curve_id, extension_degree=extension_degree
        )

    def square_torus(
        self: ExtensionFieldModuloCircuit, X: list[ModuloCircuitElement]
    ) -> list[ModuloCircuitElement]:
        """
        Computes the square of an element X in Torus Based Arithmetic
        SQ = 1/2(X+ v/X) <=> v = X (2SQ - X)
        Use hint to avoid v/X inversion.
        From SQ and X, compute v = X (2SQ - X).
        """
        SQ: list[PyFelt] = nondeterministic_square_torus(
            X, self.curve_id, biject_from_direct=True
        )
        SQ, continuable_hash, s1 = self.write_commitments(SQ)
        s1 = self.write_cairo_native_felt(self.field(s1))
        two_SQ = self.extf_add(SQ, SQ)
        two_SQ_min_X = self.extf_sub(two_SQ, X)

        # %{
        Q, V = nondeterministic_extension_field_mul_divmod(
            X, two_SQ_min_X, self.curve_id, self.extension_degree
        )
        Q = Polynomial(Q)
        # Sanity check : ensure V is indeed V(x) = 1*x.
        assert all([v.value == 0 for i, v in enumerate(V) if i != 1])
        assert V[1].value == 1, f"V(x) = {V[1].value}"
        Q_acc = self.acc.nondeterministic_Q + s1 * Q
        # %}
        X_of_z = self.eval_poly_in_precomputed_Z(X)
        Y_of_z = self.eval_poly_in_precomputed_Z(two_SQ_min_X)
        XY_of_z = self.mul(X_of_z, Y_of_z)
        ci_XY_of_z = self.mul(s1, XY_of_z)
        XY_acc = self.add(self.acc.xy, ci_XY_of_z)

        # Only add s1 to v coefficient. Keep the rest of the R accumulator unchanged.
        R_acc = self.acc.R.copy()
        R_acc[1] = self.add(self.acc.R[1], s1)

        self.acc = EuclideanPolyAccumulator(
            xy=XY_acc,
            nondeterministic_Q=Q_acc,
            R=R_acc,
        )

        return SQ

    def mul_torus(
        self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]
    ) -> list[ModuloCircuitElement]:
        """
        Computes Mul(X,Y) = (X*Y + v)/(X+Y)
        """
        xy = self.extf_mul(X, Y, self.extension_degree)

        num = copy.deepcopy(xy)
        num[1] = self.add(xy[1], self.constants["ONE"])

        den = self.extf_add(X, Y)
        return self.extf_div(num, den, self.extension_degree)

    def inverse_torus(self, X: list[ModuloCircuitElement]):
        return [self.neg(x) for x in X]

    def decompress_torus(
        self, X: list[ModuloCircuitElement]
    ) -> list[ModuloCircuitElement]:
        """
        Returns (X + w) / (X - w). Size is doubled.
        """
        zero = self.get_constant("ZERO")
        num = [
            X[0],
            self.get_constant("ONE"),
            X[1],
            zero,
            X[2],
            zero,
            X[3],
            zero,
            X[4],
            zero,
            X[5],
            zero,
        ]
        den = num.copy()
        den[1] = self.get_constant("MINUS_ONE")

        return self.extf_div(num, den, 2 * self.extension_degree)


class GaragaBN254FinalExp(FinalExpCircuit):
    def __init__(self):
        super().__init__(
            name="GaragaBN254FinalExp", curve_id=BN254_ID, extension_degree=6
        )

    def final_exp_part1(
        self, X: list[PyFelt], unsafe: bool
    ) -> list[ModuloCircuitElement]:
        self.write_elements(X, operation=WriteOps.INPUT)
        # Hash input.
        self.transcript.hash_limbs_multi(X)

        MIN_ONE = self.get_constant("MINUS_ONE")
        MIN_9 = circuit.add_constant("MIN_9", self.field(-9))

        num = circuit.write_elements(X[0:6])

        num_full = [
            circuit.mul(MIN_ONE, circuit.add(num[0], circuit.mul(MIN_9, num[1]))),
            circuit.mul(MIN_ONE, circuit.add(num[2], circuit.mul(MIN_9, num[3]))),
            circuit.mul(MIN_ONE, circuit.add(num[4], circuit.mul(MIN_9, num[5]))),
            circuit.mul(MIN_ONE, num[1]),
            circuit.mul(MIN_ONE, num[3]),
            circuit.mul(MIN_ONE, num[5]),
        ]

        if unsafe:
            den = circuit.write_elements(X[6:12], operation=WriteOps.INPUT)
        else:
            if [x.value for x in X[6:12]] == [0, 0, 0, 0, 0, 0]:
                selector1 = 1
                den = circuit.write_elements(
                    [
                        self.field.one(),
                        self.field.zero(),
                        self.field.zero(),
                        self.field.zero(),
                        self.field.zero(),
                        self.field.zero(),
                    ]
                )
            else:
                selector1 = 0
                den = circuit.write_elements(self.raw_input[6:12])

        den_full = [
            circuit.add(den[0], circuit.mul(MIN_9, den[1])),
            circuit.add(den[2], circuit.mul(MIN_9, den[3])),
            circuit.add(den[4], circuit.mul(MIN_9, den[5])),
            den[1],
            den[3],
            den[5],
        ]

        c = self.extf_div(num_full, den_full, self.extension_degree)
        t0 = self.frobenius_square_torus(c)
        c = self.mul_torus(t0, c)
        # 2. Hard part (up to permutation)
        # 2x₀(6x₀²+3x₀+1)(p⁴-p²+1)/r
        # Duquesne and Ghammam
        # https://eprint.iacr.org/2015/192.pdf
        # Fuentes et al. (alg. 6)
        # performed in torus compressed form
        t0 = self.expt_torus(c)
        t0 = self.inverse_torus(c)
        t0 = self.square_torus(t0)
        t1 = self.square_torus(t0)
        t1 = self.mul_torus(t0, t1)
        t2 = self.expt_torus(t1)
        t2 = self.inverse_torus(t2)
        t3 = self.inverse_torus(t1)
        t1 = self.mul_torus(t2, t3)
        t3 = self.square_torus(t3)
        t4 = self.expt_torus(t3)
        t4 = self.mul_torus(t1, t4)
        t3 = self.mul_torus(t0, t4)
        t0 = self.mul_torus(c, t0)
        t2 = self.frobenius_torus(t3)
        t0 = self.mul_torus(t2, t0)
        t2 = self.frobenius_square_torus(t4)
        t0 = self.mul_torus(t0, t2)
        t2 = self.inverse_torus(c)
        t2 = self.mul_torus(t2, t3)
        t2 = self.frobenius_cube_torus(t2)
        # MulTorus(t0, t2) = (t0*t2 + v)/(t0 + t2).
        # (T0+T2 = 0) ==> MulTorus(t0, t2) is one in the Torus.
        _sum = self.extf_add(t0, t2)
        # From this case we can conclude the result is 1 or !=1 without decompression.
        # In case we want to decompress to get the result in GT,
        # we might need to decompress with another circuit, if the result is not 1 (_sum!=0).

        pass

    def final_exp_finalize(self, t0: list[PyFelt], t2: list[PyFelt]):
        # Computes Decompress Torus(MulTorus(t0, t2)).
        # Only valid if (t0 + t2) != 0.
        t0 = self.write_elements(t0, WriteOps.INPUT)
        t2 = self.write_elements(t2, WriteOps.INPUT)
        self.transcript.hash_limbs_multi(t0)
        self.transcript.hash_limbs_multi(t2)

        mul = self.mul_torus(t0, t2)
        return self.decompress_torus(mul)


if __name__ == "__main__":
    from random import randint, seed

    seed(0)
    curve: Curve = CURVES[BN254_ID]
    p = curve.p
    X = [PyFelt(randint(0, p - 1), p) for _ in range(12)]

    circuit = GaragaBN254FinalExp()
    circuit.create_powers_of_Z(PyFelt(11, STARK))

    M = circuit.write_elements(X[0:6])

    sqt = circuit.square_torus(M)
    mtt = circuit.mul_torus(M, M)
    circuit.print_value_segment()
    print(circuit.compile_circuit())
    fiat = circuit.values_segment.non_interactive_transform()
    fiat.print()

    print([x.value for x in sqt] == [x.value for x in mtt])
