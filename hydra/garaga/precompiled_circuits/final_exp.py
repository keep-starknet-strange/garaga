"""
Deprecated Final Exp Circuits since we now use the final exp witness.
Kept for reference/in case we need it in the future.
"""

import copy
from random import randint

from garaga.definitions import BLS12_381_ID, BN254_ID, CURVES, CurveID, get_sparsity
from garaga.extension_field_modulo_circuit import (
    AccPolyInstructionType,
    ExtensionFieldModuloCircuit,
    ModuloCircuitElement,
    Polynomial,
    PyFelt,
)
from garaga.hints.extf_mul import (
    nondeterministic_extension_field_mul_divmod,
    nondeterministic_square_torus,
)
from garaga.hints.frobenius import get_frobenius_maps, get_V_torus_powers
from garaga.modulo_circuit import WriteOps
from garaga.poseidon_transcript import CairoPoseidonTranscript


class FinalExpTorusCircuit(ExtensionFieldModuloCircuit):
    def __init__(
        self, name: str, curve_id: int, extension_degree: int, hash_input: bool = True
    ):
        super().__init__(
            name=name,
            curve_id=curve_id,
            extension_degree=extension_degree,
            hash_input=hash_input,
        )
        self.frobenius_maps = {}
        self.v_torus_powers_inv = {}
        for i in [1, 2, 3]:
            _, self.frobenius_maps[i] = get_frobenius_maps(
                curve_id=curve_id, extension_degree=extension_degree, frob_power=i
            )
            self.v_torus_powers_inv[i] = get_V_torus_powers(
                curve_id, extension_degree, i
            ).get_coeffs()

            # Write to circuit. Note : add_constant will return existing circuit constant if it already exists.
            self.v_torus_powers_inv[i] = [
                self.set_or_get_constant(v) for v in self.v_torus_powers_inv[i]
            ]
        self.ops_counter.update({"MUL_TORUS": 0, "SQUARE_TORUS": 0})
        self.set_or_get_constant(self.field(-1))

    def final_exp_part1(self, X: list[PyFelt]) -> list[ModuloCircuitElement]:
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
        self.ops_counter["SQUARE_TORUS"] += 1
        SQ: list[PyFelt] = nondeterministic_square_torus(
            X, self.curve_id, biject_from_direct=True
        )
        SQ = self.write_elements(SQ, WriteOps.COMMIT)
        two_SQ = self.vector_add(SQ, SQ)
        two_SQ_min_X = self.vector_sub(two_SQ, X)

        # %{
        Q, V = nondeterministic_extension_field_mul_divmod(
            [X, two_SQ_min_X], self.curve_id, self.extension_degree
        )
        Q = Polynomial(Q)
        # Sanity check : ensure V is indeed V(x) = 1*x.
        assert all([v.value == 0 for i, v in enumerate(V) if i != 1])
        assert V[1].value == 1, f"V(x) = {V[1].value}"
        # %}

        # Hacky way to pass SQ as R so that it is hashed.
        # Result is known in advance to be V, and not SQ.
        # R_sparsity encoded as this bypasses the usage of R coefficients.
        # Essentially, r_sparsity encodes R=V direcly by its static sparsity.

        self.accumulate_poly_instructions[0].append(
            AccPolyInstructionType.SQUARE_TORUS,
            Pis=[X, two_SQ_min_X],
            Q=Q,
            R=SQ,
            r_sparsity=[0, 2] + [0] * (self.extension_degree - 2),
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
        self.ops_counter["MUL_TORUS"] += 1
        xy = self.extf_mul([X, Y], self.extension_degree)

        num = copy.deepcopy(xy)
        num[1] = self.add(xy[1], self.set_or_get_constant(1))

        den = self.vector_add(X, Y)
        return self.extf_div(num, den, self.extension_degree)

    def inverse_torus(self, X: list[ModuloCircuitElement]):
        return [self.neg(x) for x in X]

    def decompress_torus(
        self, X: list[ModuloCircuitElement]
    ) -> list[ModuloCircuitElement]:
        """
        Returns (X + w) / (X - w). Size is doubled.
        """
        zero = self.set_or_get_constant(0)
        num = [
            X[0],
            self.set_or_get_constant(1),
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
        den[1] = self.set_or_get_constant(-1)

        return self.extf_div(num, den, 2 * self.extension_degree, acc_index=1)

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
                    list_op_result.append(
                        self.mul(
                            X[index], self.set_or_get_constant(self.field(constant))
                        )
                    )
            frob[i] = list_op_result[0]
            for op_res in list_op_result[1:]:
                frob[i] = self.add(frob[i], op_res)

        if len(self.v_torus_powers_inv[frob_power]) == 1:
            return self.vector_scale(frob, self.v_torus_powers_inv[frob_power][0])
        else:
            Y = [
                self.set_or_get_constant(v) for v in self.v_torus_powers_inv[frob_power]
            ]
            return self.extf_mul(
                Ps=[frob, Y],
                extension_degree=self.extension_degree,
                Ps_sparsities=[None, get_sparsity(Y)],
            )

    def easy_part(
        self, num: list[PyFelt], den: list[PyFelt]
    ) -> list[ModuloCircuitElement]:
        """
        Computes the easy part of the final exponentiation.
        """

        assert len(num) == 6, f"Expected 6 elements in num, got {len(num)}"
        assert len(den) == 6, f"Expected 6 elements in den, got {len(den)}"

        num = self.write_elements(num, operation=WriteOps.INPUT)
        num = self.vector_neg(num)
        den = self.write_elements(den, WriteOps.INPUT)

        c = self.extf_div(num, den, self.extension_degree)
        t0 = self.frobenius_torus(c, 2)
        c = self.mul_torus(t0, c)
        return c

    def final_exp_finalize(self, t0: list[PyFelt], t2: list[PyFelt]):
        # Computes Decompress Torus(MulTorus(t0, t2)).
        # Only valid if (t0 + t2) != 0.
        t0 = self.write_elements(t0, WriteOps.INPUT)
        t2 = self.write_elements(t2, WriteOps.INPUT)

        # for x in t0:
        #     print(f"T0 input {hex(x.value)}")
        # for x in t2:
        #     print(f"T2 input {hex(x.value)}")

        mul = self.mul_torus(t0, t2)

        res = self.decompress_torus(mul)
        self.finalize_circuit()
        return res


class GaragaBLS12_381FinalExp(FinalExpTorusCircuit):
    def __init__(
        self, name: str = None, hash_input: bool = True, init_hash: int = None
    ):
        super().__init__(
            name=name or "Final Exp BLS12_381",
            curve_id=BLS12_381_ID,
            extension_degree=6,
            hash_input=hash_input,
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

    def final_exp_part1(self, num: list[PyFelt], den: list[PyFelt]) -> list[PyFelt]:
        """
        X is a list of 12 elements in the tower of extension fields.
        """
        c = self.easy_part(num, den)

        # 2. Hard part (up to permutation)
        # 3(p⁴-p²+1)/r
        # Daiki Hayashida, Kenichiro Hayasaka and Tadanori Teruya
        # https://eprint.iacr.org/2020/875.pdf
        # performed in torus compressed form
        t0_0 = self.square_torus(c)
        t1 = self.expt_half_torus(t0_0)
        t2 = self.inverse_torus(c)
        t1 = self.mul_torus(t1, t2)
        t2 = self.expt_torus(t1)
        t1 = self.inverse_torus(t1)
        t1 = self.mul_torus(t1, t2)
        t2 = self.expt_torus(t1)
        t1 = self.frobenius_torus(t1, 1)
        t1 = self.mul_torus(t1, t2)
        t0 = self.expt_torus(t1)
        t2 = self.expt_torus(t0)
        t0 = self.frobenius_torus(t1, 2)
        t1 = self.inverse_torus(t1)
        t1 = self.mul_torus(t1, t2)

        # Output in fixed order (t0, c, _sum):
        t1 = self.mul_torus(t1, t0)
        self.extend_output(t1)
        c = self.mul_torus(c, t0_0)
        self.extend_output(c)
        # The final exp result is DecompressTorus(MulTorus(c, t1)
        # MulTorus(t1, c) = (t1*c + v)/(t1 + c).
        # (t1+c = 0) ==> MulTorus(t1, c) is E12.One() in the Torus.
        _sum = self.vector_add(t1, c)
        self.extend_output(_sum)
        # From this case we can conclude the result is 1 or !=1 without decompression.
        # In case we want to decompress to get the result in GT,
        # we might need to decompress with another circuit, if the result is not 1 (_sum!=0).
        return t1, c, _sum


class GaragaBN254FinalExp(FinalExpTorusCircuit):
    def __init__(
        self, name: str = None, hash_input: bool = True, init_hash: int = None
    ):
        super().__init__(
            name=name or "Final Exp BN254",
            curve_id=BN254_ID,
            extension_degree=6,
            hash_input=hash_input,
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
        self, num: list[PyFelt], den: list[PyFelt]
    ) -> list[ModuloCircuitElement]:
        """
        single pairing -> unsafe = True = 1
        double pairing -> unsafe = False = 0
        """
        c = self.easy_part(num, den)

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
        t2_tmp = self.frobenius_torus(t4, 2)
        t2 = self.inverse_torus(c)
        t2 = self.mul_torus(t2, t3)

        # Output in fixed order (t0, t2, _sum):
        t0 = self.mul_torus(t0, t2_tmp)
        self.extend_output(t0)
        t2 = self.frobenius_torus(t2, 3)
        self.extend_output(t2)
        # The final exp result is DecompressTorus(MulTorus(t0, t2)).
        # MulTorus(t0, t2) = (t0*t2 + v)/(t0 + t2).
        # (T0+T2 = 0) ==> MulTorus(t0, t2) is one in the Torus.
        _sum = self.vector_add(t0, t2)
        self.extend_output(_sum)
        # From this case we can conclude the result is 1 or !=1 without decompression.
        # In case we want to decompress to get the result in GT,
        # we might need to decompress with another circuit, if the result is not 1 (_sum!=0).

        return t0, t2, _sum


GaragaFinalExp = {
    CurveID.BN254: GaragaBN254FinalExp,
    CurveID.BLS12_381: GaragaBLS12_381FinalExp,
}


def test_final_exp(curve_id: CurveID):
    from garaga.definitions import G1G2Pair, G1Point, G2Point, tower_to_direct

    order = CURVES[curve_id.value].n
    pairs = []
    n_pairs = 1
    unsafe = True if n_pairs == 1 else False
    for _ in range(n_pairs):
        n1, n2 = randint(1, order), randint(1, order)
        p1, p2 = G1Point.get_nG(curve_id, n1), G2Point.get_nG(curve_id, n2)
        pairs.append(G1G2Pair(p1, p2))

    base_class = GaragaFinalExp[curve_id]
    part1 = base_class(hash_input=False)
    field = part1.field

    XT: list[int] = G1G2Pair.miller(pairs).value_coeffs
    ET: list[int] = G1G2Pair.pair(pairs).value_coeffs

    XT = [part1.field(x) for x in XT]
    ET = [part1.field(x) for x in ET]

    XD = tower_to_direct(XT, curve_id.value, 12)
    ED = tower_to_direct(ET, curve_id.value, 12)

    num_indexes = [0, 2, 4, 6, 8, 10]
    den_indexes = [1, 3, 5, 7, 9, 11]
    num = [XD[i] for i in num_indexes]

    if unsafe:
        den = [XD[i] for i in den_indexes]
    else:
        if [x.value for x in [XD[i] for i in den_indexes]] == [0, 0, 0, 0, 0, 0]:
            den = [
                field.one(),
                field.zero(),
                field.zero(),
                field.zero(),
                field.zero(),
                field.zero(),
            ]

        else:
            den = [XD[i] for i in den_indexes]

    t0, t2, _sum = part1.final_exp_part1(num, den)
    part1.finalize_circuit()
    _sum = [x.value for x in _sum]

    part2 = base_class(hash_input=False)
    if _sum == [0, 0, 0, 0, 0, 0]:
        f = [field.one()] + [field.zero] * 11
    else:
        t0 = [x.felt for x in t0]
        t2 = [x.felt for x in t2]
        f = part2.final_exp_finalize(t0, t2)

    assert [f.value for f in f] == [
        e.value for e in ED
    ], f"Final exp in circuit and internal do not match f={[f.value for f in f]}\ne={[e.value for e in ED]}"
    # print(f"{curve_id} Final Exp random test pass")
    return part1, part2


if __name__ == "__main__":
    pass

    from garaga.definitions import CurveID, Polynomial

    # def test_frobenius_torus():
    #     from archive_tmp.bn254.pairing_final_exp import frobenius_torus
    #     field = get_base_field(CurveID.BN254.value)
    #     X = [field(random.randint(0, field.p - 1)) for _ in range(6)]
    #     t = FinalExpTorusCircuit("test", CurveID.BN254.value, 6)
    #     t.create_powers_of_Z(field(2))
    #     X = t.write_elements(X)
    #     XF = t.frobenius_torus(X, 1)
    #     # Xpoly = Polynomial([x.felt for x in X])
    #     # XFpoly = Xpoly.pow(field.p, get_irreducible_poly(CurveID.BN254.value, ))
    #     # assert t.finalize_circuit()
    #     # t.values_segment = t.values_segment.non_interactive_transform()
    #     TT = frobenius_torus([x.value for x in X])
    #     assert all(x.value == y for x, y in zip(XF, TT))
    #     t.print_value_segment()
    # test_final_exp(CurveID.BN254)
    # test_final_exp(CurveID.BLS12_381)
