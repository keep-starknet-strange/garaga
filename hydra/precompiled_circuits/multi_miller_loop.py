from hydra.definitions import (
    BLS12_381_ID,
    BN254_ID,
    CURVES,
    CurveID,
    precompute_lineline_sparsity,
)
from hydra.extension_field_modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuitElement,
    PyFelt,
)


class MultiMillerLoopCircuit(ExtensionFieldModuloCircuit):
    def __init__(
        self,
        name: str,
        curve_id: int,
        n_pairs: int,
        hash_input: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            name=name,
            curve_id=curve_id,
            extension_degree=12,
            hash_input=hash_input,
            init_hash=init_hash,
            compilation_mode=compilation_mode,
        )
        self.curve = CURVES[curve_id]
        self.line_sparsity: list[int] = self.curve.line_function_sparsity
        self.line_line_sparsity: list[int] = precompute_lineline_sparsity(curve_id)
        self.n_pairs = n_pairs
        self.P = []
        self.Q = []
        self.yInv = []
        self.xNegOverY = []
        self.loop_counter = CURVES[self.curve_id].loop_counter
        self.ops_counter.update(
            {
                "Double Step": 0,
                "Double-and-Add Step": 0,
                "Triple Step": 0,
                "MUL_L_BY_L": 0,
                "MUL_LL_BY_LL": 0,
                "MUL_LL_BY_L": 0,
                "MUL_BY_L": 0,
                "MUL_BY_LL": 0,
            }
        )
        self.output_lines_sparsities = []

    def write_p_and_q(self, input: list[PyFelt], precompute_consts: bool = True):
        assert (
            len(input) == 6 * self.n_pairs
        ), f"Expected {6 * self.n_pairs} inputs, got {len(input)}"

        for i in range(self.n_pairs):
            self.P.append(
                (
                    self.write_element(input[6 * i]),
                    self.write_element(input[6 * i + 1]),
                )
            )
            self.Q.append(
                (
                    [
                        self.write_element(input[6 * i + 2]),
                        self.write_element(input[6 * i + 3]),
                    ],
                    [
                        self.write_element(input[6 * i + 4]),
                        self.write_element(input[6 * i + 5]),
                    ],
                )
            )
        if precompute_consts:
            self.precompute_consts()
        return None

    def precompute_consts(self, n_pairs: int = None):
        n_pairs = n_pairs or self.n_pairs
        self.yInv = [self.inv(self.P[i][1]) for i in range(n_pairs)]
        self.xNegOverY = [
            self.neg(self.div(self.P[i][0], self.P[i][1])) for i in range(n_pairs)
        ]
        if -1 in self.loop_counter:
            self.Qneg = [
                (self.Q[i][0], self.extf_neg(self.Q[i][1])) for i in range(n_pairs)
            ]
        else:
            self.Qneg = None

        return None

    def compute_doubling_slope(
        self,
        Q: tuple[
            list[ModuloCircuitElement],
            list[ModuloCircuitElement],
        ],
    ) -> list[ModuloCircuitElement, ModuloCircuitElement]:
        # num = 3 * x^2
        # den = 2 * y
        x0, x1 = Q[0][0], Q[0][1]
        # x² = (x0 + i x1)² = (x0² - x1²) + 2 * i * x0 * x1 = (x0+x1)(x0-x1) + i * 2 * x0 * x1.
        # (x0+x1)*(x0-x1) is cheaper than x0² - x1². (2 ADD + 1 MUL) vs (1 ADD + 2 MUL) (16 vs 20 steps)
        # Omits mul by 2x for imaginary part to multiply once by 6 instead of doubling and multiplying by 3.
        num_tmp = [
            self.mul(
                self.add(x0, x1, comment="Doubling slope numerator start"),
                self.sub(x0, x1),
            ),
            self.mul(x0, x1),
        ]
        num = [
            self.mul(num_tmp[0], self.set_or_get_constant(3)),
            self.mul(
                num_tmp[1],
                self.set_or_get_constant(6),
                comment="Doubling slope numerator end",
            ),
        ]
        den = self.extf_add(Q[1], Q[1])
        return self.fp2_div(num, den)

    def compute_adding_slope(
        self,
        Qa: tuple[
            list[ModuloCircuitElement],
            list[ModuloCircuitElement],
        ],
        Qb: tuple[
            list[ModuloCircuitElement],
            list[ModuloCircuitElement],
        ],
    ) -> list[ModuloCircuitElement]:
        # num = ya - yb
        # den = xa - xb
        num = self.extf_sub(Qa[1], Qb[1])
        den = self.extf_sub(Qa[0], Qb[0])
        return self.fp2_div(num, den)

    def build_sparse_line(
        self,
        R0: tuple[ModuloCircuitElement, ModuloCircuitElement],
        R1: tuple[ModuloCircuitElement, ModuloCircuitElement],
        yInv: ModuloCircuitElement,
        xNegOverY: ModuloCircuitElement,
    ) -> list[ModuloCircuitElement]:
        # Mocked ModuloCircuitElement for ZERO and ONE.
        # They are not part of the circuit because only the non-zero or non-ones will be used due do the
        # known-in-advance sparsity
        ZERO, ONE = ModuloCircuitElement(self.field(0), -1), ModuloCircuitElement(
            self.field(1), -1
        )

        if self.curve_id == BN254_ID:
            return [
                ONE,
                self.mul(
                    self.add(R0[0], self.mul(self.set_or_get_constant(-9), R0[1])),
                    xNegOverY,
                ),
                ZERO,
                self.mul(
                    self.add(R1[0], self.mul(self.set_or_get_constant(-9), R1[1])), yInv
                ),
                ZERO,
                ZERO,
                ZERO,
                self.mul(R0[1], xNegOverY),
                ZERO,
                self.mul(R1[1], yInv),
                ZERO,
                ZERO,
            ]
        elif self.curve_id == BLS12_381_ID:
            return [
                self.mul(self.sub(R1[0], R1[1]), yInv),  # nr=1
                ZERO,
                self.mul(self.sub(R0[0], R0[1]), xNegOverY),  # nr=1
                ONE,
                ZERO,
                ZERO,
                self.mul(R1[1], yInv),
                ZERO,
                self.mul(R0[1], xNegOverY),
                ZERO,
                ZERO,
                ZERO,
            ]
        else:
            raise NotImplementedError

    def add_step(
        self,
        Qa: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        Qb: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        k: int,
    ):
        λ = self.compute_adding_slope(Qa, Qb)
        xr = self.extf_sub(X=self.fp2_square(X=λ), Y=self.extf_add(Qa[0], Qb[0]))
        yr = self.extf_sub(
            X=self.fp2_mul(X=λ, Y=self.extf_sub(Qa[0], xr)),
            Y=Qa[1],
        )
        p = (xr, yr)
        line = self.build_sparse_line(
            R0=λ,  # Directly store λ as R0
            R1=self.extf_sub(self.fp2_mul(λ, Qa[0]), Qa[1]),
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )
        return p, line

    def line_compute(
        self,
        Qa: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        Qb: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        k: int,
    ):
        λ = self.compute_adding_slope(Qa, Qb)
        line = self.build_sparse_line(
            R0=λ,  # Directly store λ as R0
            R1=self.extf_sub(self.fp2_mul(λ, Qa[0]), Qa[1]),
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )
        return line

    def double_step(
        self, Q: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]], k: int
    ):
        """
        Perform a single doubling of a point on an elliptic curve and store the line evaluation,
        including computations that involve the y coordinate.

        :param p1: A tuple representing the point on the curve (x, y) in the extension field.
        :return: A tuple containing the doubled point and the line evaluation.
        """
        self.ops_counter["Double Step"] += 1
        λ = self.compute_doubling_slope(Q)  # Compute λ = 3x² / 2y

        # Compute xr = λ² - 2x
        xr = self.extf_sub(X=self.fp2_square(X=λ), Y=self.extf_add(Q[0], Q[0]))

        # Compute yr = λ(x - xr) - y
        yr = self.extf_sub(X=self.fp2_mul(λ, self.extf_sub(Q[0], xr)), Y=Q[1])

        p = (xr, yr)

        # Store the line evaluation for this doubling step
        line = self.build_sparse_line(
            R0=λ,  # Directly store λ as R0
            R1=self.extf_sub(self.fp2_mul(λ, Q[0]), Q[1]),  # Compute R1 as λ*x - y
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )

        return p, line

    def double_and_add_step(
        self,
        Qa: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        Qb: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        k: int,
    ) -> list[ModuloCircuitElement]:
        self.ops_counter["Double-and-Add Step"] += 1
        # Computes 2Qa+Qb as (Qa+Qb)+Qa
        # https://arxiv.org/pdf/math/0208038.pdf 3.1
        λ1 = self.compute_adding_slope(Qa, Qb)

        # compute x3 = λ1²-x1-x2

        x3 = self.extf_sub(X=self.fp2_square(X=λ1), Y=self.extf_add(Qa[0], Qb[0]))

        # omit y3 computation

        line1 = self.build_sparse_line(
            R0=λ1,
            R1=self.extf_sub(
                self.fp2_mul(λ1, Qa[0]), Qa[1]
            ),  # Compute R1 as λ1*x1 - y1
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )
        # compute λ2 = -λ1-2y1/(x3-x1)

        num = self.extf_add(Qa[1], Qa[1])
        den = self.extf_sub(x3, Qa[0])
        λ2 = self.extf_neg(self.extf_add(λ1, self.fp2_div(num, den)))

        # compute xr = λ2²-x1-x3
        x4 = self.extf_sub(self.extf_sub(self.fp2_square(λ2), Qa[0]), x3)

        # compute y4 = λ2(x1 - x4)-y1
        y4 = self.extf_sub(self.fp2_mul(λ2, self.extf_sub(Qa[0], x4)), Qa[1])

        line2 = self.build_sparse_line(
            R0=λ2,
            R1=self.extf_sub(
                self.fp2_mul(λ2, Qa[0]), Qa[1]
            ),  # Compute R1 as λ2*x1 - y1
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )

        return (x4, y4), line1, line2

    def triple_step(
        self, Q: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]], k: int
    ):
        self.ops_counter["Triple Step"] += 1
        # Compute λ = 3x² / 2y. Manually to keep den = 2y to be re-used for λ2.
        x0, x1 = Q[0][0], Q[0][1]
        num_tmp = [
            self.mul(self.add(x0, x1), self.sub(x0, x1)),
            self.mul(x0, x1),
        ]
        num = [
            self.mul(num_tmp[0], self.set_or_get_constant(3)),
            self.mul(num_tmp[1], self.set_or_get_constant(6)),
        ]
        den = self.extf_add(Q[1], Q[1])
        λ1 = self.fp2_div(num, den)

        line1 = self.build_sparse_line(
            R0=λ1,  # Directly store λ as R0
            R1=self.extf_sub(self.fp2_mul(λ1, Q[0]), Q[1]),  # Compute R1 as λ*x - y
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )
        # x2 = λ1^2 - 2x
        x2 = self.extf_sub(self.fp2_square(λ1), self.extf_add(Q[0], Q[0]))
        # ommit yr computation, and

        # compute λ2 = 2y/(x2 − x) − λ1.
        # However in https://github.com/Consensys/gnark/blob/7cfcd5a723b0726dcfe75a5fc7249a23d690b00b/std/algebra/emulated/sw_bls12381/pairing.go#L548
        # It's coded as x - x2.
        λ2 = self.extf_sub(self.fp2_div(den, self.extf_sub(Q[0], x2)), λ1)

        line2 = self.build_sparse_line(
            R0=λ2,
            R1=self.extf_sub(self.fp2_mul(λ2, Q[0]), Q[1]),  # Compute R1 as λ2*x1 - y1
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )

        # // xr = λ²-p.x-x2

        xr = self.extf_sub(self.fp2_square(λ2), self.extf_add(Q[0], x2))

        # // yr = λ(p.x-xr) - p.y
        yr = self.extf_sub(self.fp2_mul(λ2, self.extf_sub(Q[0], xr)), Q[1])

        return (xr, yr), line1, line2

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
    ):
        """
        Compute the bit 1 case of the Miller loop when it is the first bit.
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
            [f, f, *new_lines],
            12,
            Ps_sparsities=[None, None] + [self.line_sparsity] * n_pairs * 2,
        )
        return new_f, new_points

    def bit_1_case(
        self,
        f: list[ModuloCircuitElement],
        points: list[tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]],
        Q_select: list[tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]],
        n_pairs: int,
    ):
        """
        Compute the bit 1 case of the Miller loop.
        params : f : the current miller loop FP12 element
                points : the list of points to double
                Q_select : the list of points to add.
                Q_select[k] is the point to add if the k-th bit is 1, and the negation of the point if the k-th bit is -1.
                n_pairs : the number of pairs to double
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
            [f, f, *new_lines],
            12,
            Ps_sparsities=[None, None] + [self.line_sparsity] * n_pairs * 2,
        )
        return new_f, new_points

    def bn254_finalize_step(
        self,
        Qs: list[tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]],
    ):
        q1s = []
        q2s = []
        nr1p2 = [
            self.set_or_get_constant(
                self.field(
                    21575463638280843010398324269430826099269044274347216827212613867836435027261
                )
            ),
            self.set_or_get_constant(
                self.field(
                    10307601595873709700152284273816112264069230130616436755625194854815875713954
                )
            ),
        ]  # Non residue 1 power 2

        nr1p3 = [
            self.set_or_get_constant(
                self.field(
                    2821565182194536844548159561693502659359617185244120367078079554186484126554
                ),
            ),
            self.set_or_get_constant(
                self.field(
                    3505843767911556378687030309984248845540243509899259641013678093033130930403
                ),
            ),
        ]  # Non residue 1 power 3

        nr2p2 = self.set_or_get_constant(
            self.field(
                21888242871839275220042445260109153167277707414472061641714758635765020556616
            )  # non_residue_2_power_2
        )
        nr2p3 = self.set_or_get_constant(
            self.field(
                -21888242871839275222246405745257275088696311157297823662689037894645226208582
            )
        )  # (-1) * non_residue_2_power_3

        new_lines = []
        for k in range(self.n_pairs):
            q1x = [self.Q[k][0][0], self.neg(self.Q[k][0][1])]
            q1y = [self.Q[k][1][0], self.neg(self.Q[k][1][1])]
            q1x = self.fp2_mul(
                q1x,
                nr1p2,
            )
            q1y = self.fp2_mul(
                q1y,
                nr1p3,
            )
            q2x = self.extf_scalar_mul(
                self.Q[k][0],
                nr2p2,
            )
            q2y = self.extf_scalar_mul(
                self.Q[k][1],
                nr2p3,
            )

            T, l1 = self.add_step(Qs[k], (q1x, q1y), k)
            l2 = self.line_compute(T, (q2x, q2y), k)
            new_lines.append(l1)
            new_lines.append(l2)

        return new_lines

    def miller_loop(self, n_pairs: int) -> list[ModuloCircuitElement]:
        f = [self.set_or_get_constant(1)] + [self.set_or_get_constant(0)] * 11

        start_index = len(self.loop_counter) - 2

        if self.loop_counter[start_index] == 1:
            # Handle case when first bit is +1, need to triple point instead of double and add.
            f, Qs = self.bit_1_init_case(f, self.Q, n_pairs)
        elif self.loop_counter[start_index] == 0:
            f, Qs = self.bit_0_case(f, self.Q, n_pairs)
        else:
            raise NotImplementedError(
                f"Init bit {self.loop_counter[start_index]} not implemented"
            )

        # Rest of miller loop.
        for i in range(start_index - 1, -1, -1):
            if self.loop_counter[i] == 0:
                f, Qs = self.bit_0_case(f, Qs, n_pairs)
            elif self.loop_counter[i] == 1 or self.loop_counter[i] == -1:
                # Choose Q or -Q depending on the bit for the addition.
                Q_selects = [
                    self.Q[k] if self.loop_counter[i] == 1 else self.Qneg[k]
                    for k in range(n_pairs)
                ]
                f, Qs = self.bit_1_case(f, Qs, Q_selects, n_pairs)
            else:
                raise NotImplementedError(f"Bit {self.loop_counter[i]} not implemented")

        if self.curve_id == CurveID.BN254.value:
            lines = self.bn254_finalize_step(Qs)
            f = self.extf_mul(
                [f, *lines],
                12,
                Ps_sparsities=[None] + [self.line_sparsity] * self.n_pairs * 2,
            )
        elif self.curve_id == CurveID.BLS12_381.value:
            f = [
                f[0],
                self.neg(f[1]),
                f[2],
                self.neg(f[3]),
                f[4],
                self.neg(f[5]),
                f[6],
                self.neg(f[7]),
                f[8],
                self.neg(f[9]),
                f[10],
                self.neg(f[11]),
            ]
        else:
            raise NotImplementedError(f"Curve {self.curve_id} not implemented")

        return f
