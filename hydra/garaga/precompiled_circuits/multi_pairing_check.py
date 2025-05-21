from garaga.definitions import (
    CURVES,
    CurveID,
    G1G2Pair,
    G1Point,
    G2Point,
    get_base_field,
    get_sparsity,
)
from garaga.hints.frobenius import get_frobenius_maps
from garaga.hints.multi_miller_witness import get_final_exp_witness
from garaga.hints.tower_backup import E6, E12
from garaga.modulo_circuit import ModuloCircuitElement, PyFelt, WriteOps
from garaga.precompiled_circuits.multi_miller_loop import MultiMillerLoopCircuit


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

    c: MultiMillerLoopCircuit = MultiMillerLoopCircuit(
        name="mock", curve_id=curve_id, n_pairs=len(P)
    )
    if isinstance(P[0], G1Point):
        c.write_p_and_q(P, Q)
    elif isinstance(P[0], tuple) and isinstance(P[0][0], ModuloCircuitElement):
        for p, q in zip(P, Q):
            c_input.append(p[0].felt)
            c_input.append(p[1].felt)
            c_input.append(q[0][0].felt)
            c_input.append(q[0][1].felt)
            c_input.append(q[1][0].felt)
            c_input.append(q[1][1].felt)
        c.write_p_and_q_raw(c_input)

    f = E12.from_direct(c.miller_loop(len(P)), curve_id)
    if m is not None:
        M = E12.from_direct(m, curve_id)
        f = f * M
    # h = (CURVES[curve_id].p ** 12 - 1) // CURVES[curve_id].n
    # assert f**h == E12.one(curve_id)
    lambda_root_e12, scaling_factor_e12 = get_final_exp_witness(curve_id, f)

    lambda_root: list[PyFelt]
    scaling_factor: list[PyFelt]

    lambda_root, scaling_factor = (
        (
            lambda_root_e12.__inv__().to_direct()
            if curve_id == CurveID.BLS12_381.value
            else lambda_root_e12.to_direct()
        ),  # Pass lambda_root inverse directly for BLS.
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


def get_max_Q_degree(curve_id: int, n_pairs: int) -> int:
    if curve_id == CurveID.BN254.value:
        line_degree = 9
    elif curve_id == CurveID.BLS12_381.value:
        line_degree = 8
    else:
        raise NotImplementedError(f"Curve {curve_id} not implemented")

    f_degree = 11
    lambda_root_degree = 11

    if curve_id == CurveID.BN254.value:
        # Largest degree happen in bit_10 case where we do (f*f*C * Π_n_pairs(line)^2 * Π_n_pairs(line))
        max_q_degree = (
            4 * f_degree
            + 2 * lambda_root_degree
            + 4 * line_degree * n_pairs
            + line_degree * n_pairs
            - 12
        )
    else:
        # Largest Q happens in bit_00 case where we do (f*f* Π_n_pairs(line)^2 * Π_n_pairs(line)
        max_q_degree = (
            4 * f_degree + 2 * line_degree * n_pairs + line_degree * n_pairs - 12
        )

    return max_q_degree


class MultiPairingCheckCircuit(MultiMillerLoopCircuit):
    def __init__(
        self,
        name: str,
        curve_id: int,
        n_pairs: int,
        hash_input: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
        precompute_lines: bool = False,
        n_points_precomputed_lines: int = None,
    ):
        assert n_pairs >= 2, "n_pairs must be >= 2 for pairing checks"
        super().__init__(
            name=name,
            curve_id=curve_id,
            n_pairs=n_pairs,
            hash_input=hash_input,
            init_hash=init_hash,
            compilation_mode=compilation_mode,
            precompute_lines=precompute_lines,
            n_points_precomputed_lines=n_points_precomputed_lines,
        )
        self.frobenius_maps = {}
        for i in [1, 2, 3]:
            _, self.frobenius_maps[i] = get_frobenius_maps(
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

    def bit_00_case(
        self,
        f: list[ModuloCircuitElement],
        points: list[tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]],
        n_pairs: int,
    ):
        """
        Compute the bit 00 case of the Miller loop.
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
            new_lines.append(l1)  # Double since it's going to be squared
            new_points.append(T)

        new_new_points = []
        new_new_lines = []

        for k in range(n_pairs):
            T, l1 = self.double_step(new_points[k], k)
            new_new_lines.append(l1)
            new_new_points.append(T)

        # (f^2 * Π_(new_lines))^2 * Π_new_new_lines = f^4 * Π_new_lines^2 * Π_new_new_lines

        new_f = self.extf_mul(
            [f, f, f, f, *new_lines, *new_new_lines],
            12,
            Ps_sparsities=[None, None, None, None]
            + [self.line_sparsity] * n_pairs * 2
            + [self.line_sparsity] * n_pairs,
        )
        return new_f, new_new_points

    def bit_01_case(
        self,
        f: list[ModuloCircuitElement],
        points: list[tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]],
        Q_selects: list[tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]],
        c_or_c_inv: list[ModuloCircuitElement],
        n_pairs: int,
    ):

        assert len(points) == n_pairs
        new_lines = []
        new_points = []
        for k in range(n_pairs):
            T, l1 = self.double_step(points[k], k)
            new_lines.append(l1)
            new_lines.append(l1)  # Double since it's going to be squared
            new_points.append(T)

        new_new_points = []
        new_new_lines = []

        for k in range(n_pairs):
            T, l1, l2 = self.double_and_add_step(new_points[k], Q_selects[k], k)
            new_new_lines.append(l1)
            new_new_lines.append(l2)
            new_new_points.append(T)

        # (f^2 * Π_(new_lines))^2 * Π_new_new_lines = f^4 * Π_new_lines^2 * Π_new_new_lines
        new_f = self.extf_mul(
            [f, f, f, f, *new_lines, *new_new_lines, c_or_c_inv],
            12,
            Ps_sparsities=[None] * 4
            + [self.line_sparsity] * n_pairs * 2
            + [self.line_sparsity] * n_pairs * 2
            + [None],
        )
        return new_f, new_new_points

    def bit_10_case(
        self,
        f: list[ModuloCircuitElement],
        points: list[tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]],
        Q_selects: list[tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]],
        c_or_c_inv: list[ModuloCircuitElement],
        n_pairs: int,
    ):
        assert len(points) == n_pairs
        new_lines = []
        new_points = []
        for k in range(n_pairs):
            T, l1, l2 = self.double_and_add_step(points[k], Q_selects[k], k)
            new_lines.append(l1)
            new_lines.append(l1)  # Double since it's going to be squared
            new_lines.append(l2)
            new_lines.append(l2)  # Double since it's going to be squared
            new_points.append(T)

        new_new_points = []
        new_new_lines = []

        for k in range(n_pairs):
            T, l1 = self.double_step(new_points[k], k)
            new_new_lines.append(l1)
            new_new_points.append(T)

        new_f = self.extf_mul(
            [f, f, f, f, c_or_c_inv, c_or_c_inv, *new_lines, *new_new_lines],
            12,
            Ps_sparsities=[None] * 4
            + [None, None]
            + [self.line_sparsity] * n_pairs * 4
            + [self.line_sparsity] * n_pairs,
        )
        return new_f, new_new_points

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
        self, n_pairs: int, m: list[ModuloCircuitElement] | None = None
    ) -> tuple[
        list[ModuloCircuitElement],
        list[ModuloCircuitElement],
        list[ModuloCircuitElement],
    ]:

        lambda_root, scaling_factor, scaling_factor_sparsity = (
            get_root_and_scaling_factor(self.curve_id, self.P, self.Q, m)
        )

        c_or_c_inv = self.write_elements(lambda_root, WriteOps.COMMIT)

        w = self.write_elements(
            scaling_factor, WriteOps.COMMIT, scaling_factor_sparsity
        )

        if self.curve_id == CurveID.BLS12_381.value:
            # Conjugate c so that the final conjugate in BLS loop gives indeed f/c^(-x), as conjugate(f/conjugate(c^(-x))) = conjugate(f)/c^(-x)
            lambda_root = None
            lambda_root_inverse = c_or_c_inv
            c_inv = self.conjugate_e12d(lambda_root_inverse)
        elif self.curve_id == CurveID.BN254.value:
            lambda_root = c = c_or_c_inv
            lambda_root_inverse = c_inv = self.extf_inv(c_or_c_inv, 12)

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

        i = start_index - 1
        while i >= 0:
            if self.loop_counter[i] == 0:  # First bit is 0
                if i > 0:  # Check next bit if it exists
                    next_bit = self.loop_counter[i - 1]
                    if next_bit == 0:
                        # 00 case
                        f, Qs = self.bit_00_case(f, Qs, n_pairs)
                        i -= 1  # Skip next bit
                    elif next_bit in (1, -1) and self.curve_id == CurveID.BN254.value:
                        # 01 or 0(-1) case
                        Q_selects = [
                            self.Q[k] if next_bit == 1 else self.Qneg[k]
                            for k in range(n_pairs)
                        ]
                        c_or_c_inv = c_inv if next_bit == 1 else c
                        f, Qs = self.bit_01_case(f, Qs, Q_selects, c_or_c_inv, n_pairs)
                        i -= 1  # Skip next bit
                    else:
                        # Single 0 (BLS only)
                        f, Qs = self.bit_0_case(f, Qs, n_pairs)
                else:
                    # Single 0 at the end
                    f, Qs = self.bit_0_case(f, Qs, n_pairs)

            elif self.loop_counter[i] in (1, -1):  # First bit is ±1
                # Calculate Q_selects and c_or_c_inv based on the si
                Q_selects = [
                    self.Q[k] if self.loop_counter[i] == 1 else self.Qneg[k]
                    for k in range(n_pairs)
                ]
                c_or_c_inv = c_inv if self.loop_counter[i] == 1 else c

                if (
                    i > 0
                    and self.loop_counter[i - 1] == 0
                    and self.curve_id == CurveID.BN254.value
                ):
                    # 10 or (-1)0 case
                    f, Qs = self.bit_10_case(f, Qs, Q_selects, c_or_c_inv, n_pairs)
                    i -= 1  # Skip next bit
                elif i == 0 or self.curve_id == CurveID.BLS12_381.value:
                    # Single ±1 at the end
                    f, Qs = self.bit_1_case(f, Qs, Q_selects, n_pairs, c_or_c_inv)
                else:
                    raise NotImplementedError(
                        f"Bit {self.loop_counter[i]} not implemented"
                    )
            else:
                raise NotImplementedError(f"Bit {self.loop_counter[i]} not implemented")
            i -= 1

        if m is not None and len(m) == 12:
            final_r_sparsity = None
        else:
            final_r_sparsity = [1] + [0] * 11

        if self.curve_id == CurveID.BN254.value:
            lines = self.bn254_finalize_step(Qs)
            f = self.extf_mul(
                [f, *lines],
                12,
                Ps_sparsities=[None] + [self.line_sparsity] * self.n_pairs * 2,
            )
            # λ = 6 * x + 2 + q - q**2 + q**3
            c_inv_frob_1 = self.frobenius(c_inv, 1)
            c_frob_2 = self.frobenius(c, 2)
            c_inv_frob_3 = self.frobenius(c_inv, 3)

            f = self.extf_mul(
                ([f, w, c_inv_frob_1, c_frob_2, c_inv_frob_3]),
                12,
                Ps_sparsities=([None, scaling_factor_sparsity, None, None, None]),
                r_sparsity=final_r_sparsity,
            )

        elif self.curve_id == CurveID.BLS12_381.value:
            # λ = -x + q for BLS
            c_inv_frob_1 = self.frobenius(c_inv, 1)
            f = self.extf_mul(
                Ps=[f, w, c_inv_frob_1],
                extension_degree=12,
                Ps_sparsities=[None, scaling_factor_sparsity, None],
                r_sparsity=final_r_sparsity,
            )
            if m is not None and len(m) == 12:
                f = self.conjugate_e12d(f)

        else:
            raise NotImplementedError(f"Curve {self.curve_id} not implemented")

        if m is not None and len(m) == 12:
            f = self.extf_mul([f, m], 12, r_sparsity=[1] + [0] * 11)

        assert [fi.value for fi in f] == [1] + [
            0
        ] * 11, f"Pairing check failed: {[fi.value for fi in f]}"
        return (
            f,
            lambda_root,
            lambda_root_inverse,
            scaling_factor,
            scaling_factor_sparsity,
        )


def get_pairing_check_input(
    curve_id: CurveID, n_pairs: int, include_m: bool = False, return_pairs: bool = False
) -> tuple[list[PyFelt | G1G2Pair], list[PyFelt] | G1G2Pair | None]:
    """
    Returns a list of G1G2Pairs and the extra public pair if include_m is True
    """
    n_pairs = n_pairs + include_m

    assert n_pairs >= 2, "n_pairs must be >= 2 for pairing checks"
    field = get_base_field(curve_id.value)
    if n_pairs == 2:
        # Generate inputs resembling BLS signature verification
        curve = CURVES[curve_id.value]
        secret_key = field.random(curve.n).value
        public_key = G2Point.get_nG(curve_id, secret_key)
        message_hash = G1Point.gen_random_point(curve_id)
        signature = message_hash.scalar_mul(secret_key)

        P = [signature, message_hash]
        Q = [G2Point.get_nG(curve_id, 1), -public_key]
    else:
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

    if return_pairs:
        if include_m:
            return [G1G2Pair(p, q) for p, q in zip(P[:-1], Q[:-1])], G1G2Pair(
                P[-1], Q[-1]
            )
        else:
            return [G1G2Pair(p, q) for p, q in zip(P, Q)], None
    else:
        if include_m:
            mloop_circuit = MultiMillerLoopCircuit(
                name="mock", curve_id=curve_id.value, n_pairs=1
            )
            mloop_circuit.write_p_and_q_raw(c_input[-6:])
            M = mloop_circuit.miller_loop(n_pairs=1)
            M = [mi.felt for mi in M]
            return c_input[:-6], M
        else:
            return c_input, None
