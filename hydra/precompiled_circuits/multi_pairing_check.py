from hydra.precompiled_circuits.multi_miller_loop import MultiMillerLoopCircuit
from hydra.hints.tower_backup import E6, E12
from hydra.definitions import (
    G1Point,
    G2Point,
    get_base_field,
    get_sparsity,
    CurveID,
    CURVES,
    int_to_u384,
)
from hydra.hints.multi_miller_witness import get_final_exp_witness
from hydra.modulo_circuit import (
    WriteOps,
    ModuloCircuitElement,
    PyFelt,
)
from hydra.hints.frobenius import generate_frobenius_maps


def get_root_and_scaling_factor(
    curve_id: int,
    P: list[G1Point | tuple[ModuloCircuitElement, ModuloCircuitElement]],
    Q: list[
        G2Point
        | tuple[
            tuple[ModuloCircuitElement, ModuloCircuitElement],
            tuple[ModuloCircuitElement, ModuloCircuitElement],
        ]
    ],
    m: list[ModuloCircuitElement] = None,
) -> tuple[list[PyFelt], list[PyFelt], list[int]]:
    assert (
        len(P) == len(Q) >= 2
    ), f"P and Q must have the same length and >= 2, got {len(P)} and {len(Q)}"
    field = get_base_field(curve_id)
    c_input: list[PyFelt] = []

    if isinstance(P[0], G1Point):
        for p, q in zip(P, Q):
            c_input.append(field(p.x))
            c_input.append(field(p.y))
            c_input.append(field(q.x[0]))
            c_input.append(field(q.x[1]))
            c_input.append(field(q.y[0]))
            c_input.append(field(q.y[1]))
    elif isinstance(P[0], tuple) and isinstance(P[0][0], ModuloCircuitElement):
        for p, q in zip(P, Q):
            c_input.append(p[0].felt)
            c_input.append(p[1].felt)
            c_input.append(q[0][0].felt)
            c_input.append(q[0][1].felt)
            c_input.append(q[1][0].felt)
            c_input.append(q[1][1].felt)

    c: MultiMillerLoopCircuit = MultiMillerLoopCircuit(
        name="mock", curve_id=curve_id, n_pairs=len(P)
    )
    c.write_p_and_q(c_input)
    f = E12.from_direct(c.miller_loop(len(P)), curve_id)
    if m is not None:
        M = E12.from_direct(m, curve_id)
        f = f * M
    h = (CURVES[curve_id].p ** 12 - 1) // CURVES[curve_id].n
    assert f**h == E12.one(curve_id)
    lambda_root_e12, scaling_factor_e12 = get_final_exp_witness(curve_id, f)

    lambda_root: list[PyFelt]
    scaling_factor: list[PyFelt]

    lambda_root, scaling_factor = (
        lambda_root_e12.to_direct(),
        scaling_factor_e12.to_direct(),
    )

    e6_subfield = E12([E6.random(curve_id), E6.zero(curve_id)], curve_id)
    scaling_factor_sparsity = get_sparsity(e6_subfield.to_direct())

    # Assert sparsity is correct: for every index where the sparsity is 0, the coefficient must 0 in scaling factor
    for i in range(len(scaling_factor_sparsity)):
        if scaling_factor_sparsity[i] == 0:
            assert scaling_factor[i].value == 0
    # Therefore scaling factor lies in Fp6

    return lambda_root, scaling_factor, scaling_factor_sparsity


class MultiPairingCheckCircuit(MultiMillerLoopCircuit):
    def __init__(
        self,
        name: str,
        curve_id: int,
        n_pairs: int,
        hash_input: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        assert n_pairs >= 2, "n_pairs must be >= 2 for pairing checks"
        super().__init__(
            name=name,
            curve_id=curve_id,
            n_pairs=n_pairs,
            hash_input=hash_input,
            init_hash=init_hash,
            compilation_mode=compilation_mode,
        )
        self.frobenius_maps = {}
        for i in [1, 2, 3]:
            _, self.frobenius_maps[i] = generate_frobenius_maps(
                curve_id=curve_id, extension_degree=self.extension_degree, frob_power=i
            )

    def frobenius(
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

        return frob

    def bit_0_case(
        self,
        f: list[ModuloCircuitElement],
        points: list[tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]],
        n_pairs: int,
    ):
        """
        Compute the bit 0 case of the Miller loop.
        params : f : the current miller loop FP12 element
                points : the list of points to double
                n_pairs : the number of pairs to double
        returns : the new miller loop FP12 element and the new points
        """
        assert len(points) == n_pairs
        new_lines = []
        new_points = []
        for k in range(n_pairs):
            T, l1 = self.double_step(points[k], k)
            new_lines.append(l1)
            new_points.append(T)

        # Square f and multiply by lines for all pairs
        new_f = self.extf_mul(
            [f, f, *new_lines],
            12,
            Ps_sparsities=[None, None] + [self.line_sparsity] * n_pairs,
        )
        return new_f, new_points

    def bit_1_init_case(
        self,
        f: list[ModuloCircuitElement],
        points: list[tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]],
        n_pairs: int,
        c: list[ModuloCircuitElement],
    ):
        """
        Compute the bit 1 case of the Miller loop when it is the first bit (positive).
        Uses triple step instead of double and add.
        """
        assert len(points) == n_pairs
        new_lines = []
        new_points = []
        for k in range(n_pairs):
            T, l1, l2 = self.triple_step(points[k], k)
            new_lines.append(l1)
            new_lines.append(l2)
            new_points.append(T)

        # Square f and multiply by lines for all pairs
        new_f = self.extf_mul(
            [f, f, c, *new_lines],
            12,
            Ps_sparsities=[None, None, None] + [self.line_sparsity] * n_pairs * 2,
        )
        return new_f, new_points

    def bit_1_case(
        self,
        f: list[ModuloCircuitElement],
        points: list[tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]],
        Q_select: list[tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]],
        n_pairs: int,
        c_or_c_inv: list[ModuloCircuitElement],
    ):
        """
        Compute the bit 1 case of the Miller loop.
        params : f : the current miller loop FP12 element
                points : the list of points to double
                Q_select : the list of points to add.
                Q_select[k] is the point to add if the k-th bit is 1, and the negation of the point if the k-th bit is -1.
                n_pairs : the number of pairs to double
                c_or_c_inv : the lambda-th root c or its inverse depending on the bit (c_inv if 1, c if -1)
        returns : the new miller loop FP12 element and the new points
        """
        assert len(points) == n_pairs == len(Q_select)
        new_lines = []
        new_points = []
        for k in range(n_pairs):
            T, l1, l2 = self.double_and_add_step(points[k], Q_select[k], k)
            new_lines.append(l1)
            new_lines.append(l2)
            new_points.append(T)

        # Square f and multiply by lines for all pairs
        new_f = self.extf_mul(
            [f, f, c_or_c_inv, *new_lines],
            12,
            Ps_sparsities=[None, None, None] + [self.line_sparsity] * n_pairs * 2,
        )
        return new_f, new_points

    def multi_pairing_check(
        self, n_pairs: int, m: list[ModuloCircuitElement] = None
    ) -> list[ModuloCircuitElement]:

        lambda_root, scaling_factor, scaling_factor_sparsity = (
            get_root_and_scaling_factor(self.curve_id, self.P, self.Q, m)
        )

        w = self.write_elements(
            scaling_factor, WriteOps.WITNESS, scaling_factor_sparsity
        )

        c = self.write_elements(lambda_root, WriteOps.WITNESS)
        if self.curve_id == CurveID.BLS12_381.value:
            # Conjugate c so that the final conjugate in BLS loop gives indeed f/c^(-x), as conjugate(f/conjugate(c^(-x))) = conjugate(f)/c^(-x)
            c = self.conjugate_e12d(c)
        c_inv = self.extf_inv(c, 12)

        # Init f as 1/c = 1 / (λ-th √(f_output*scaling_factor)), where:
        # λ = 6 * x + 2 + q - q**2 + q**3 for BN
        # λ = -x + q for BLS
        # Miller loop will compute f_output/c^(6*x2) if BN, or f_output/c^(-x) if BLS

        f = c_inv

        start_index = len(self.loop_counter) - 2

        if self.loop_counter[start_index] == 1:
            # Handle case when first bit is +1, need to triple point instead of double and add.
            f, Qs = self.bit_1_init_case(f, self.Q, n_pairs, c_inv)
        elif self.loop_counter[start_index] == 0:
            f, Qs = self.bit_0_case(f, self.Q, n_pairs)
        else:
            raise NotImplementedError(
                f"Init bit {self.loop_counter[start_index]} not implemented"
            )

        # Rest of miller loop.
        for i in range(start_index - 1, -1, -1):
            if self.loop_counter[i] == 0:
                # Free squaring for 1/c in bit 0
                f, Qs = self.bit_0_case(f, Qs, n_pairs)
            elif self.loop_counter[i] == 1 or self.loop_counter[i] == -1:
                # Choose Q or -Q depending on the bit for the addition.
                Q_selects = [
                    self.Q[k] if self.loop_counter[i] == 1 else self.Qneg[k]
                    for k in range(n_pairs)
                ]
                # Want to multiply by 1/c if bit is positive, by c if bit is negative.
                c_or_c_inv = c_inv if self.loop_counter[i] == 1 else c
                f, Qs = self.bit_1_case(f, Qs, Q_selects, n_pairs, c_or_c_inv)
            else:
                raise NotImplementedError(f"Bit {self.loop_counter[i]} not implemented")

        if self.curve_id == CurveID.BN254.value:
            f = self.bn254_finalize_step(f, Qs)
            # λ = 6 * x + 2 + q - q**2 + q**3
            c_inv_frob_1 = self.frobenius(c_inv, 1)
            c_frob_2 = self.frobenius(c, 2)
            c_inv_frob_3 = self.frobenius(c_inv, 3)
            f = self.extf_mul(
                [f, w, c_inv_frob_1, c_frob_2, c_inv_frob_3],
                12,
                Ps_sparsities=[None, scaling_factor_sparsity, None, None, None],
            )

        elif self.curve_id == CurveID.BLS12_381.value:
            # λ = -x + q for BLS
            c_inv_frob_1 = self.frobenius(c_inv, 1)
            f = self.extf_mul(
                [f, w, c_inv_frob_1],
                12,
                Ps_sparsities=[None, scaling_factor_sparsity, None],
            )
            f = self.conjugate_e12d(f)
        else:
            raise NotImplementedError(f"Curve {self.curve_id} not implemented")

        if m is not None and len(m) == 12:
            f = self.extf_mul([f, m], 12)
        assert [fi.value for fi in f] == [1] + [0] * 11, f"f: {f}"
        return f


def get_pairing_check_input(
    curve_id: CurveID, n_pairs: int, include_m: bool = False
) -> tuple[list[PyFelt], list[PyFelt] | None]:
    n_pairs = n_pairs + include_m

    assert n_pairs >= 2, "n_pairs must be >= 2 for pairing checks"
    field = get_base_field(curve_id.value)
    p = G1Point.gen_random_point(curve_id)
    q = G2Point.gen_random_point(curve_id)

    P = [p] * n_pairs
    Q = [q] * n_pairs

    P[-1] = p.scalar_mul(-(n_pairs - 1))
    c_input = []
    for p, q in zip(P, Q):
        c_input.append(field(p.x))
        c_input.append(field(p.y))
        c_input.append(field(q.x[0]))
        c_input.append(field(q.x[1]))
        c_input.append(field(q.y[0]))
        c_input.append(field(q.y[1]))
    if include_m:
        mloop_circuit = MultiMillerLoopCircuit(
            name="mock", curve_id=curve_id.value, n_pairs=1
        )
        mloop_circuit.write_p_and_q(c_input[-6:])
        M = mloop_circuit.miller_loop(n_pairs=1)
        M = [mi.felt for mi in M]
        return c_input[:-6], M
    else:
        return c_input, None


if __name__ == "__main__":

    def test_mpcheck(curve_id: CurveID, n_pairs: int, include_m: bool = False):
        c = MultiPairingCheckCircuit(
            name="mock", curve_id=curve_id.value, n_pairs=n_pairs
        )
        circuit_input, m = get_pairing_check_input(
            curve_id, n_pairs, include_m=include_m
        )
        c.write_p_and_q(circuit_input)
        M = c.write_elements(m, WriteOps.INPUT) if m is not None else None
        c.multi_pairing_check(n_pairs, M)
        c.finalize_circuit()

        def total_cost(c):
            summ = c.summarize()
            summ["total_steps_cost"] = (
                summ["MULMOD"] * 8
                + summ["ADDMOD"] * 4
                + summ["ASSERT_EQ"] * 2
                + summ["POSEIDON"] * 17
                + summ["RLC"] * 28
            )
            return summ

        print(total_cost(c))
        print(
            f"Test {curve_id.name} {n_pairs=} {'with m' if include_m else 'without m'} passed"
        )
        print(f"n_eq: {c.accumulate_poly_instructions[0].n}")

    for curve_id in [CurveID.BN254, CurveID.BLS12_381]:
        for n_pairs in [2, 3, 4]:
            print(f"Testing {curve_id.name} {n_pairs=}")
            test_mpcheck(curve_id, n_pairs)
            test_mpcheck(curve_id, n_pairs, include_m=True)