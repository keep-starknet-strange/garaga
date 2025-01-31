from typing import Iterator, Tuple

from garaga.definitions import (
    BLS12_381_ID,
    BN254_ID,
    CURVES,
    CurveID,
    G1Point,
    G2Point,
    precompute_lineline_sparsity,
)
from garaga.extension_field_modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuitElement,
    PyFelt,
)
from garaga.hints.io import flatten


class MultiMillerLoopCircuit(ExtensionFieldModuloCircuit):
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
        tower_mode: bool = False,
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
        self.n_points_precomputed_lines = n_points_precomputed_lines
        self.precompute_lines: bool = precompute_lines
        self.precomputed_lines: list[ModuloCircuitElement] = []
        self._precomputed_lines_generator = None

    def _create_precomputed_lines_generator(
        self,
    ) -> Iterator[
        Tuple[
            Tuple[ModuloCircuitElement, ModuloCircuitElement],
            Tuple[ModuloCircuitElement, ModuloCircuitElement],
        ]
    ]:
        if self.precompute_lines:
            if len(self.precomputed_lines) % 4 != 0:
                raise ValueError(
                    "Number of precomputed line elements must be a multiple of 4."
                )
            for i in range(0, len(self.precomputed_lines), 4):
                yield (
                    (self.precomputed_lines[i], self.precomputed_lines[i + 1]),
                    (self.precomputed_lines[i + 2], self.precomputed_lines[i + 3]),
                )
        else:
            while True:
                yield ((None, None), (None, None))

    def get_next_precomputed_line(
        self,
    ) -> Tuple[Tuple[PyFelt, PyFelt], Tuple[PyFelt, PyFelt]]:
        return next(self._precomputed_lines_generator)

    def write_p_and_q(self, P: list[G1Point], Q: list[G2Point]):
        assert len(P) == len(Q) == self.n_pairs
        assert set([P[i].curve_id for i in range(len(P))]) == set(
            [Q[i].curve_id for i in range(len(Q))]
        )
        raw = []
        for P, Q in zip(P, Q):
            raw.extend([self.field(P.x), self.field(P.y)])
            raw.extend([self.field(Q.x[0]), self.field(Q.x[1])])
            raw.extend([self.field(Q.y[0]), self.field(Q.y[1])])
        self.write_p_and_q_raw(raw)
        return None

    def write_p_and_q_raw(self, input: list[PyFelt], precompute_consts: bool = True):
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

    def precompute_consts(self, n_pairs: int = None, skip_P_precompute: bool = False):
        n_pairs = n_pairs or self.n_pairs
        if not skip_P_precompute:
            self.yInv = [self.inv(self.P[i][1]) for i in range(n_pairs)]
            self.xNegOverY = [
                self.neg(self.div(self.P[i][0], self.P[i][1])) for i in range(n_pairs)
            ]

        if -1 in self.loop_counter:
            self.Qneg = [
                (self.Q[i][0], self.vector_neg(self.Q[i][1])) for i in range(n_pairs)
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
        den = self.vector_add(Q[1], Q[1])
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
        num = self.vector_sub(Qa[1], Qb[1])
        den = self.vector_sub(Qa[0], Qb[0])
        return self.fp2_div(num, den)

    def build_sparse_line_eval(
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
                    comment="eval bn line by xNegOverY",
                ),
                ZERO,
                self.mul(
                    self.add(R1[0], self.mul(self.set_or_get_constant(-9), R1[1])),
                    yInv,
                    comment="eval bn line by yInv",
                ),
                ZERO,
                ZERO,
                ZERO,
                self.mul(R0[1], xNegOverY, comment="eval bn line by xNegOverY"),
                ZERO,
                self.mul(R1[1], yInv, comment="eval bn line by yInv"),
                ZERO,
                ZERO,
            ]
        elif self.curve_id == BLS12_381_ID:
            return [
                self.mul(
                    self.sub(R1[0], R1[1]), yInv, comment="eval bls line by yInv"
                ),  # nr=1
                ZERO,
                self.mul(
                    self.sub(R0[0], R0[1]),
                    xNegOverY,
                    comment="eval blsline by xNegOverY",
                ),  # nr=1
                ONE,
                ZERO,
                ZERO,
                self.mul(R1[1], yInv, comment="eval bls line by yInv"),
                ZERO,
                self.mul(R0[1], xNegOverY, comment="eval bls line by xNegOverY"),
                ZERO,
                ZERO,
                ZERO,
            ]
        else:
            raise NotImplementedError

    def _add(
        self,
        Qa: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        Qb: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        k: int,
    ):
        if self.precompute_lines and (k + 1) <= self.n_points_precomputed_lines:
            return (None, None), self.get_next_precomputed_line()
        λ = self.compute_adding_slope(Qa, Qb)
        xr = self.vector_sub(X=self.fp2_square(X=λ), Y=self.vector_add(Qa[0], Qb[0]))
        yr = self.vector_sub(
            X=self.fp2_mul(X=λ, Y=self.vector_sub(Qa[0], xr)),
            Y=Qa[1],
        )
        p = (xr, yr)
        lineR0 = λ
        lineR1 = self.vector_sub(self.fp2_mul(λ, Qa[0]), Qa[1])

        return p, (lineR0, lineR1)

    def add_step(
        self,
        Qa: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        Qb: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        k: int,
    ):
        p, (lineR0, lineR1) = self._add(Qa, Qb, k)
        line = self.build_sparse_line_eval(
            R0=lineR0,
            R1=lineR1,
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )
        return p, line

    def _line_compute(
        self,
        Qa: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        Qb: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        k: int,
    ):
        if self.precompute_lines and (k + 1) <= self.n_points_precomputed_lines:
            return self.get_next_precomputed_line()
        λ = self.compute_adding_slope(Qa, Qb)
        lineR0 = λ
        lineR1 = self.vector_sub(self.fp2_mul(λ, Qa[0]), Qa[1])
        return lineR0, lineR1

    def line_compute(
        self,
        Qa: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        Qb: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        k: int,
    ):
        lineR0, lineR1 = self._line_compute(Qa, Qb, k)
        line = self.build_sparse_line_eval(
            R0=lineR0,
            R1=lineR1,
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )
        return line

    def _double(
        self, Q: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]], k: int
    ):
        """
        Perform a single doubling of a point on an elliptic curve and store the line evaluation,
        including computations that involve the y coordinate.

        :param p1: A tuple representing the point on the curve (x, y) in the extension field.
        :return: A tuple containing the doubled point and the line evaluation.
        """
        if self.precompute_lines and (k + 1) <= self.n_points_precomputed_lines:
            return ((None, None), self.get_next_precomputed_line())
        self.ops_counter["Double Step"] += 1
        λ = self.compute_doubling_slope(Q)  # Compute λ = 3x² / 2y

        # Compute xr = λ² - 2x
        xr = self.vector_sub(X=self.fp2_square(X=λ), Y=self.vector_add(Q[0], Q[0]))

        # Compute yr = λ(x - xr) - y
        yr = self.vector_sub(X=self.fp2_mul(λ, self.vector_sub(Q[0], xr)), Y=Q[1])

        p = (xr, yr)

        lineR0 = λ
        lineR1 = self.vector_sub(self.fp2_mul(λ, Q[0]), Q[1])

        return p, (lineR0, lineR1)

    def double_step(
        self,
        Q: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        k: int,
    ):
        p, (lineR0, lineR1) = self._double(Q, k)
        line = self.build_sparse_line_eval(
            R0=lineR0,
            R1=lineR1,
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )
        return p, line

    def _double_and_add(
        self,
        Qa: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        Qb: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        k: int,
    ) -> list[ModuloCircuitElement]:
        if self.precompute_lines and (k + 1) <= self.n_points_precomputed_lines:
            return (
                (None, None),
                self.get_next_precomputed_line(),
                self.get_next_precomputed_line(),
            )
        self.ops_counter["Double-and-Add Step"] += 1
        # Computes 2Qa+Qb as (Qa+Qb)+Qa
        # https://arxiv.org/pdf/math/0208038.pdf 3.1
        λ1 = self.compute_adding_slope(Qa, Qb)

        # compute x3 = λ1²-x1-x2

        x3 = self.vector_sub(X=self.fp2_square(X=λ1), Y=self.vector_add(Qa[0], Qb[0]))

        # omit y3 computation
        line1R0 = λ1
        line1R1 = self.vector_sub(self.fp2_mul(λ1, Qa[0]), Qa[1])

        # compute λ2 = -λ1-2y1/(x3-x1)

        num = self.vector_add(Qa[1], Qa[1])
        den = self.vector_sub(x3, Qa[0])
        λ2 = self.vector_neg(self.vector_add(λ1, self.fp2_div(num, den)))

        # compute xr = λ2²-x1-x3
        x4 = self.vector_sub(self.vector_sub(self.fp2_square(λ2), Qa[0]), x3)

        # compute y4 = λ2(x1 - x4)-y1
        y4 = self.vector_sub(self.fp2_mul(λ2, self.vector_sub(Qa[0], x4)), Qa[1])

        line2R0 = λ2
        line2R1 = self.vector_sub(self.fp2_mul(λ2, Qa[0]), Qa[1])

        return (x4, y4), (line1R0, line1R1), (line2R0, line2R1)

    def double_and_add_step(
        self,
        Qa: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        Qb: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        k: int,
    ):
        (new_x, new_y), (line1R0, line1R1), (line2R0, line2R1) = self._double_and_add(
            Qa, Qb, k
        )
        line1 = self.build_sparse_line_eval(
            R0=line1R0,
            R1=line1R1,
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )
        line2 = self.build_sparse_line_eval(
            R0=line2R0,
            R1=line2R1,
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )
        return (new_x, new_y), line1, line2

    def _triple(
        self, Q: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]], k: int
    ):
        if self.precompute_lines and (k + 1) <= self.n_points_precomputed_lines:
            return (
                (None, None),
                self.get_next_precomputed_line(),
                self.get_next_precomputed_line(),
            )
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
        den = self.vector_add(Q[1], Q[1])
        λ1 = self.fp2_div(num, den)

        line1R0 = λ1
        line1R1 = self.vector_sub(self.fp2_mul(λ1, Q[0]), Q[1])

        # x2 = λ1^2 - 2x
        x2 = self.vector_sub(self.fp2_square(λ1), self.vector_add(Q[0], Q[0]))
        # ommit yr computation, and

        # compute λ2 = 2y/(x2 − x) − λ1.
        # However in https://github.com/Consensys/gnark/blob/7cfcd5a723b0726dcfe75a5fc7249a23d690b00b/std/algebra/emulated/sw_bls12381/pairing.go#L548
        # It's coded as x - x2.
        λ2 = self.vector_sub(self.fp2_div(den, self.vector_sub(Q[0], x2)), λ1)

        line2R0 = λ2
        line2R1 = self.vector_sub(self.fp2_mul(λ2, Q[0]), Q[1])

        # // xr = λ²-p.x-x2

        xr = self.vector_sub(self.fp2_square(λ2), self.vector_add(Q[0], x2))

        # // yr = λ(p.x-xr) - p.y
        yr = self.vector_sub(self.fp2_mul(λ2, self.vector_sub(Q[0], xr)), Q[1])

        return (xr, yr), (line1R0, line1R1), (line2R0, line2R1)

    def triple_step(
        self, Q: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]], k: int
    ):
        (new_x, new_y), (line1R0, line1R1), (line2R0, line2R1) = self._triple(Q, k)
        line1 = self.build_sparse_line_eval(
            R0=line1R0,  # Directly store λ as R0
            R1=line1R1,  # Compute R1 as λ*x - y
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )
        line2 = self.build_sparse_line_eval(
            R0=line2R0,
            R1=line2R1,
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )

        return (new_x, new_y), line1, line2

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

    def _bn254_finalize_step(
        self,
        Qs: list[tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]],
    ):
        def set_or_get_constants():
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
            return nr1p2, nr1p3, nr2p2, nr2p3

        new_lines = []
        for k in range(self.n_pairs):
            if self.precompute_lines and (k + 1) <= self.n_points_precomputed_lines:
                new_lines.append(
                    (self.get_next_precomputed_line(), self.get_next_precomputed_line())
                )
            else:
                nr1p2, nr1p3, nr2p2, nr2p3 = set_or_get_constants()
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
                q2x = self.vector_scale(
                    self.Q[k][0],
                    nr2p2,
                )
                q2y = self.vector_scale(
                    self.Q[k][1],
                    nr2p3,
                )

                T, (l1R0, l1R1) = self._add(Qs[k], (q1x, q1y), k)
                l2R0, l2R1 = self._line_compute(T, (q2x, q2y), k)
                new_lines.append(((l1R0, l1R1), (l2R0, l2R1)))

        return new_lines

    def bn254_finalize_step(
        self,
        Qs: list[tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]],
    ):
        lines = self._bn254_finalize_step(Qs)
        lines_evaluated = []
        for k, (l1, l2) in enumerate(lines):
            line_eval = self.build_sparse_line_eval(
                R0=l1[0],
                R1=l1[1],
                yInv=self.yInv[k],
                xNegOverY=self.xNegOverY[k],
            )
            line_eval2 = self.build_sparse_line_eval(
                R0=l2[0],
                R1=l2[1],
                yInv=self.yInv[k],
                xNegOverY=self.xNegOverY[k],
            )
            lines_evaluated.append(line_eval)
            lines_evaluated.append(line_eval2)

        return lines_evaluated

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


def precompute_lines(Qs: list[G2Point]) -> list[PyFelt]:
    if len(Qs) == 0:
        return []
    curve_id = Qs[0].curve_id.value
    loop_counter = CURVES[curve_id].loop_counter
    start_index = len(loop_counter) - 2
    n_pairs = len(Qs)
    circuit = MultiMillerLoopCircuit(
        name="precompute_helper",
        curve_id=curve_id,
        n_pairs=n_pairs,
        hash_input=False,
        precompute_lines=False,
    )
    field = circuit.field
    for Q in Qs:
        circuit.Q.append(
            (
                [
                    circuit.write_element(field(Q.x[0])),
                    circuit.write_element(field(Q.x[1])),
                ],
                [
                    circuit.write_element(field(Q.y[0])),
                    circuit.write_element(field(Q.y[1])),
                ],
            )
        )
    circuit.precompute_consts(skip_P_precompute=True)

    lines = []
    if loop_counter[start_index] == 1:
        # Handle case when first bit is +1, need to triple point instead of double and add.
        new_points = []
        new_lines = []
        for k in range(n_pairs):
            T, l1, l2 = circuit._triple(circuit.Q[k], k)
            new_lines.append(l1)
            new_lines.append(l2)
            new_points.append(T)

    elif loop_counter[start_index] == 0:
        new_lines = []
        new_points = []
        for k in range(n_pairs):
            T, l1 = circuit._double(circuit.Q[k], k)
            new_lines.append(l1)
            new_points.append(T)
    else:
        raise NotImplementedError(
            f"Init bit {loop_counter[start_index]} not implemented"
        )

    points = new_points
    lines.append(new_lines)
    # Rest of miller loop.=
    for i in range(start_index - 1, -1, -1):

        new_lines = []
        new_points = []
        if loop_counter[i] == 0:
            for k in range(n_pairs):
                T, l1 = circuit._double(points[k], k)
                new_lines.append(l1)
                new_points.append(T)
        elif loop_counter[i] == 1 or loop_counter[i] == -1:
            # Choose Q or -Q depending on the bit for the addition.
            Q_selects = [
                circuit.Q[k] if loop_counter[i] == 1 else circuit.Qneg[k]
                for k in range(n_pairs)
            ]
            for k in range(n_pairs):
                T, l1, l2 = circuit._double_and_add(points[k], Q_selects[k], k)
                new_lines.append(l1)
                new_lines.append(l2)
                new_points.append(T)
        else:
            raise NotImplementedError(f"Bit {loop_counter[i]} not implemented")
        points = new_points
        lines.append(new_lines)

    if curve_id == CurveID.BN254.value:
        final_lines = circuit._bn254_finalize_step(points)
        for l1, l2 in final_lines:
            lines.append(l1)
            lines.append(l2)

    elif curve_id == CurveID.BLS12_381.value:
        pass
    else:
        raise NotImplementedError(f"Curve {curve_id} not implemented")

    return [x.felt for x in flatten(lines)]
