import copy
from src.modulo_circuit import WriteOps
from src.extension_field_modulo_circuit import (
    ExtensionFieldModuloCircuit,
    EuclideanPolyAccumulator,
    ModuloCircuitElement,
    PyFelt,
    Polynomial,
)
from src.poseidon_transcript import CairoPoseidonTranscript
from src.definitions import (
    CURVES,
    STARK,
    CurveID,
    BN254_ID,
    BLS12_381_ID,
    Curve,
    generate_frobenius_maps,
    get_V_torus_powers,
)
from src.hints.extf_mul import (
    nondeterministic_square_torus,
    nondeterministic_extension_field_mul_divmod,
)
import random
from enum import Enum


class FinalExpTorusCircuit(ExtensionFieldModuloCircuit):
    def __init__(self, name: str, curve_id: int, extension_degree: int):
        super().__init__(
            name=name, curve_id=curve_id, extension_degree=extension_degree
        )
        self.frobenius_maps = {}
        self.v_torus_powers_inv = {}
        for i in [1, 2, 3]:
            _, self.frobenius_maps[i] = generate_frobenius_maps(
                curve_id=curve_id, extension_degree=extension_degree, frob_power=i
            )
            self.v_torus_powers_inv[i] = get_V_torus_powers(
                curve_id, extension_degree, i
            ).get_coeffs()

            # Write to circuit. Note : add_constant will return existing circuit constant if it already exists.
            self.v_torus_powers_inv[i] = [
                self.add_constant(v) for v in self.v_torus_powers_inv[i]
            ]

    def final_exp_part1(
        self, X: list[PyFelt], unsafe: bool
    ) -> list[ModuloCircuitElement]:
        return NotImplementedError

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
        SQ, _, _ = self.write_commitments(SQ)
        s1 = self.transcript.RLC_coeff
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

    def n_square_torus(self, X: list[PyFelt], n: int) -> list[PyFelt]:
        result = self.square_torus(X)
        for _ in range(n - 1):
            result = self.square_torus(result)
        return result

    def mul_torus(
        self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]
    ) -> list[ModuloCircuitElement]:
        """
        Computes Mul(X,Y) = (X*Y + v)/(X+Y)
        """
        xy = self.extf_mul(X, Y, self.extension_degree)

        num = copy.deepcopy(xy)
        num[1] = self.add(xy[1], self.constants[1])

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
        zero = self.get_constant(0)
        num = [
            X[0],
            self.get_constant(1),
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
        den[1] = self.get_constant(-1)

        return self.extf_div(num, den, 2 * self.extension_degree)

    def frobenius_torus(
        self, X: list[ModuloCircuitElement], frob_power: int
    ) -> list[ModuloCircuitElement]:
        frob = [None] * self.extension_degree
        for i, list_op in enumerate(self.frobenius_maps[frob_power]):
            list_op_result = []
            for index, constant in list_op:
                if constant == 1:
                    list_op_result.append(X[index])
                else:
                    # print(constant)
                    list_op_result.append(
                        self.mul(X[index], self.add_constant(self.field(constant)))
                    )
            frob[i] = list_op_result[0]
            for op_res in list_op_result[1:]:
                frob[i] = self.add(frob[i], op_res)

        if len(self.v_torus_powers_inv[frob_power]) == 1:
            return self.extf_scalar_mul(frob, self.v_torus_powers_inv[frob_power][0])
        else:
            return self.extf_mul(
                X=frob,
                Y=[self.add_constant(v) for v in self.v_torus_powers_inv[frob_power]],
                extension_degree=self.extension_degree,
                y_is_sparse=True,
            )

    def easy_part(
        self, X: list[ModuloCircuitElement], unsafe: bool
    ) -> list[ModuloCircuitElement]:
        """
        Computes the easy part of the final exponentiation.
        """
        self.write_elements(X, operation=WriteOps.INPUT)
        # Hash input.
        self.transcript.hash_limbs_multi(X)

        num_indexes = [0, 2, 4, 6, 8, 10]
        den_indexes = [1, 3, 5, 7, 9, 11]

        num = self.write_elements([X[i] for i in num_indexes], operation=WriteOps.INPUT)
        num = self.extf_neg(num)

        if unsafe:
            den = self.write_elements(
                [X[i] for i in den_indexes], operation=WriteOps.INPUT
            )
        else:
            if [x.value for x in [X[i] for i in den_indexes]] == [0, 0, 0, 0, 0, 0]:
                selector1 = 1
                den = self.write_elements(
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
                den = self.write_elements(
                    [X[i] for i in den_indexes], operation=WriteOps.INPUT
                )

        c = self.extf_div(num, den, self.extension_degree)
        t0 = self.frobenius_torus(c, 2)
        c = self.mul_torus(t0, c)
        return c

    def final_exp_finalize(self, t0: list[PyFelt], t2: list[PyFelt]):
        # Computes Decompress Torus(MulTorus(t0, t2)).
        # Only valid if (t0 + t2) != 0.
        t0 = self.write_elements(t0, WriteOps.INPUT)
        t2 = self.write_elements(t2, WriteOps.INPUT)

        mul = self.mul_torus(t0, t2)
        return self.decompress_torus(mul)


class GaragaBLS12_381FinalExp(FinalExpTorusCircuit):
    def __init__(self, init_hash: int = None):
        super().__init__(
            name="GaragaBLS12_381FinalExp", curve_id=BLS12_381_ID, extension_degree=6
        )
        if init_hash is not None:
            self.transcript = CairoPoseidonTranscript(init_hash)

    def expt_half_torus(self, X: list[ModuloCircuitElement]):
        z = self.square_torus(X)
        z = self.mul_torus(X, z)
        z = self.square_torus(z)
        z = self.square_torus(z)
        z = self.mul_torus(X, z)
        z = self.n_square_torus(z, 3)
        z = self.mul_torus(X, z)
        z = self.n_square_torus(z, 9)
        z = self.mul_torus(X, z)
        z = self.n_square_torus(z, 32)
        z = self.mul_torus(X, z)
        z = self.n_square_torus(z, 15)
        z = self.inverse_torus(z)
        return z

    def expt_torus(self, X):
        z = self.expt_half_torus(X)
        return self.square_torus(z)

    def final_exp_part1(self, X: list[PyFelt], unsafe: bool) -> list[PyFelt]:
        """
        X is a list of 12 elements in the tower of extension fields.
        """
        c = self.easy_part(X, unsafe)

        # 2. Hard part (up to permutation)
        # 3(p⁴-p²+1)/r
        # Daiki Hayashida, Kenichiro Hayasaka and Tadanori Teruya
        # https://eprint.iacr.org/2020/875.pdf
        # performed in torus compressed form
        t0 = self.square_torus(c)
        t1 = self.expt_half_torus(t0)
        t2 = self.inverse_torus(c)
        t1 = self.mul_torus(t1, t2)
        t2 = self.expt_torus(t1)
        t1 = self.inverse_torus(t1)
        t1 = self.mul_torus(t1, t2)
        t2 = self.expt_torus(t1)
        t1 = self.frobenius_torus(t1, 1)
        t1 = self.mul_torus(t1, t2)
        c = self.mul_torus(c, t0)
        t0 = self.expt_torus(t1)
        t2 = self.expt_torus(t0)
        t0 = self.frobenius_torus(t1, 2)
        t1 = self.inverse_torus(t1)
        t1 = self.mul_torus(t1, t2)
        t1 = self.mul_torus(t1, t0)

        # The final exp result is DecompressTorus(MulTorus(c, t1)
        # MulTorus(c, t1) = (c*t1 + v)/(c + t1).
        # (c+t1 = 0) ==> MulTorus(c, t1) is one in the Torus.
        _sum = self.extf_add(c, t1)
        # From this case we can conclude the result is 1 or !=1 without decompression.
        # In case we want to decompress to get the result in GT,
        # we might need to decompress with another circuit, if the result is not 1 (_sum!=0).
        return _sum, c, t1


class GaragaBN254FinalExp(FinalExpTorusCircuit):
    def __init__(self, init_hash: int = None):
        super().__init__(
            name="GaragaBN254FinalExp", curve_id=BN254_ID, extension_degree=6
        )
        if init_hash is not None:
            self.transcript = CairoPoseidonTranscript(init_hash)

    def expt_torus(self, X: list[PyFelt]):
        t3 = self.square_torus(X)
        t5 = self.square_torus(t3)
        result = self.square_torus(t5)
        t0 = self.square_torus(result)
        t2 = self.mul_torus(X, t0)
        t0 = self.mul_torus(t3, t2)
        t1 = self.mul_torus(X, t0)
        t4 = self.mul_torus(result, t2)
        t6 = self.square_torus(t2)
        t1 = self.mul_torus(t0, t1)
        t0 = self.mul_torus(t3, t1)
        t6 = self.n_square_torus(t6, 6)
        t5 = self.mul_torus(t5, t6)
        t5 = self.mul_torus(t4, t5)
        t5 = self.n_square_torus(t5, 7)
        t4 = self.mul_torus(t4, t5)
        t4 = self.n_square_torus(t4, 8)
        t4 = self.mul_torus(t0, t4)
        t3 = self.mul_torus(t3, t4)
        t3 = self.n_square_torus(t3, 6)
        t2 = self.mul_torus(t2, t3)
        t2 = self.n_square_torus(t2, 8)
        t2 = self.mul_torus(t0, t2)
        t2 = self.n_square_torus(t2, 6)
        t2 = self.mul_torus(t0, t2)
        t2 = self.n_square_torus(t2, 10)
        t1 = self.mul_torus(t1, t2)
        t1 = self.n_square_torus(t1, 6)
        t0 = self.mul_torus(t0, t1)
        z = self.mul_torus(result, t0)
        return z

    def final_exp_part1(
        self, X: list[PyFelt], unsafe: bool
    ) -> list[ModuloCircuitElement]:
        """
        single pairing -> unsafe = False
        double pairing -> unsafe = True
        """
        c = self.easy_part(X, unsafe)

        # 2. Hard part (up to permutation)
        # 2x₀(6x₀²+3x₀+1)(p⁴-p²+1)/r
        # Duquesne and Ghammam
        # https://eprint.iacr.org/2015/192.pdf
        # Fuentes et al. (alg. 6)
        # performed in torus compressed form
        t0 = self.expt_torus(c)
        t0 = self.inverse_torus(t0)
        t0 = self.square_torus(t0)
        t1 = self.square_torus(t0)
        t1 = self.mul_torus(t0, t1)
        t2 = self.expt_torus(t1)
        t2 = self.inverse_torus(t2)
        t3 = self.inverse_torus(t1)
        t1 = self.mul_torus(t2, t3)
        t3 = self.square_torus(t2)
        t4 = self.expt_torus(t3)
        t4 = self.mul_torus(t1, t4)
        t3 = self.mul_torus(t0, t4)
        t0 = self.mul_torus(t2, t4)
        t0 = self.mul_torus(c, t0)
        t2 = self.frobenius_torus(t3, 1)
        t0 = self.mul_torus(t2, t0)
        t2 = self.frobenius_torus(t4, 2)
        t0 = self.mul_torus(t0, t2)
        t2 = self.inverse_torus(c)
        t2 = self.mul_torus(t2, t3)
        t2 = self.frobenius_torus(t2, 3)
        # The final exp result is DecompressTorus(MulTorus(t0, t2)).
        # MulTorus(t0, t2) = (t0*t2 + v)/(t0 + t2).
        # (T0+T2 = 0) ==> MulTorus(t0, t2) is one in the Torus.
        _sum = self.extf_add(t0, t2)
        # From this case we can conclude the result is 1 or !=1 without decompression.
        # In case we want to decompress to get the result in GT,
        # we might need to decompress with another circuit, if the result is not 1 (_sum!=0).

        return _sum, t0, t2


class GaragaFinalExp(Enum):
    BN254 = GaragaBN254FinalExp
    BLS12_381 = GaragaBLS12_381FinalExp


def test_final_exp(curve_id: CurveID):
    from tools.gnark import GnarkCLI
    from src.definitions import tower_to_direct

    cli = GnarkCLI(curve_id)
    n = CURVES[curve_id.value].n
    a, b = cli.nG1nG2_operation(random.randint(0, n - 1), random.randint(0, n - 1))
    a, b = cli.nG1nG2_operation(1, 1)

    base_class = GaragaFinalExp[curve_id.name].value
    part1 = base_class()

    XT = cli.miller([a], [b])
    ET = cli.pair([a], [b])

    XT = [part1.field(x) for x in XT]
    ET = [part1.field(x) for x in ET]

    XD = tower_to_direct(XT, curve_id.value, 12)
    ED = tower_to_direct(ET, curve_id.value, 12)

    part1.create_powers_of_Z(part1.field(2))
    _sum, t0, t2 = part1.final_exp_part1(XD, unsafe=False)
    part1.finalize_circuit()
    _sum = [x.value for x in _sum]
    t0 = [x.felt for x in t0]
    t2 = [x.felt for x in t2]

    part2 = base_class(init_hash=part1.transcript.s1)
    part2.create_powers_of_Z(part2.field(2), max_degree=12)
    if _sum == [0, 0, 0, 0, 0, 0]:
        f = [part1.field.one()]
    else:
        f = part2.final_exp_finalize(t0, t2)
        f = [f.value for f in f]

    assert f == [
        e.value for e in ED
    ], f"Final exp in circuit and in Gnark do not match f={f}\ne={[e.value for e in ED]}"
    print(f"{curve_id} Final Exp random test pass")
    return part1, part2


if __name__ == "__main__":
    from src.definitions import (
        CurveID,
        get_base_field,
        Polynomial,
        get_irreducible_poly,
    )
    import random

    def test_frobenius_torus():
        from archive_tmp.bn254.pairing_final_exp import frobenius_torus

        field = get_base_field(CurveID.BN254.value)
        X = [field(random.randint(0, field.p - 1)) for _ in range(6)]
        t = FinalExpTorusCircuit("test", CurveID.BN254.value, 6)
        t.create_powers_of_Z(field(2))
        X = t.write_elements(X)
        XF = t.frobenius_torus(X, 1)
        # Xpoly = Polynomial([x.felt for x in X])
        # XFpoly = Xpoly.pow(field.p, get_irreducible_poly(CurveID.BN254.value, ))
        # assert t.finalize_circuit()
        # t.values_segment = t.values_segment.non_interactive_transform()

        TT = frobenius_torus([x.value for x in X])
        assert all(x.value == y for x, y in zip(XF, TT))

        t.print_value_segment()

    test_final_exp(CurveID.BN254)
    test_final_exp(CurveID.BLS12_381)
