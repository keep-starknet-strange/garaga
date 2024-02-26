from src.extension_field_modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuitElement,
    PyFelt,
    WriteOps,
)
from src.poseidon_transcript import CairoPoseidonTranscript
from src.definitions import (
    CURVES,
    STARK,
    CurveID,
    BN254_ID,
    BLS12_381_ID,
    precompute_lineline_sparsity,
)
import numpy as np
from dataclasses import dataclass


@dataclass(slots=True, init=False)
class Line:
    line_sparse: list[ModuloCircuitElement]

    def __init__(
        self,
        R0: tuple[ModuloCircuitElement, ModuloCircuitElement],
        R1: tuple[ModuloCircuitElement, ModuloCircuitElement],
        curve_id: int,
    ) -> None:
        # R0: lambda (to mul by -x/y)
        # R1: lambda * x - y (to mul by 1/y)
        # First step: map R0, R1 in FP2 to a sparse FP12 element.
        if curve_id == BN254_ID:
            self.line_sparse = []


class MultiMillerLoopCircuit(ExtensionFieldModuloCircuit):
    def __init__(
        self,
        name: str,
        curve_id: int,
        P: list[
            tuple[
                PyFelt,
                PyFelt,
            ]
        ],
        Q: list[
            tuple[
                list[PyFelt],
                list[PyFelt],
            ]
        ],
        n_pairs: int,
    ):
        super().__init__(name, curve_id, 12)
        self.curve = CURVES[curve_id]
        self.line_sparsity: list[int] = self.curve.line_function_sparsity
        self.line_line_sparsity: list[int] = precompute_lineline_sparsity(curve_id)
        self.n_pairs = n_pairs
        self.add_constant(self.field(3))
        self.add_constant(self.field(6))
        self.add_constant(self.field(-9))
        self.P = [
            (self.write_element(P[i][0]), self.write_element(P[i][1]))
            for i in range(self.n_pairs)
        ]
        self.Q = [
            (
                [self.write_element(Q[i][0][0]), self.write_element(Q[i][0][1])],
                [self.write_element(Q[i][1][0]), self.write_element(Q[i][1][1])],
            )
            for i in range(self.n_pairs)
        ]
        self.yInv = [self.inv(self.P[i][1]) for i in range(self.n_pairs)]
        self.xNegOverY = [
            self.neg(
                self.div(self.P[i][0], self.P[i][1]),
            )
            for i in range(self.n_pairs)
        ]
        self.Qneg = [
            (self.Q[i][0], self.extf_neg(self.Q[i][1])) for i in range(self.n_pairs)
        ]
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
            self.mul(self.add(x0, x1), self.sub(x0, x1)),
            self.mul(x0, x1),
        ]
        num = [
            self.mul(num_tmp[0], self.get_constant(3)),
            self.mul(num_tmp[1], self.get_constant(6)),
        ]
        den = self.extf_add(Q[1], Q[1])
        return self.extf_div(num, den, 2)

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
    ) -> list[ModuloCircuitElement, ModuloCircuitElement]:
        # num = ya - yb
        # den = xa - xb
        num = self.extf_sub(Qa[1], Qb[1])
        den = self.extf_sub(Qa[0], Qb[0])
        return self.extf_div(num, den, 2)

    def build_sparse_line(
        self,
        R0: tuple[ModuloCircuitElement, ModuloCircuitElement],
        R1: tuple[ModuloCircuitElement, ModuloCircuitElement],
        yInv: ModuloCircuitElement,
        xNegOverY: ModuloCircuitElement,
    ) -> list[ModuloCircuitElement]:
        ZERO, ONE = self.get_constant(0), self.get_constant(1)

        if self.curve_id == BN254_ID:
            return [
                ONE,
                self.mul(
                    self.add(R0[0], self.mul(self.get_constant(-9), R0[1])), xNegOverY
                ),
                ZERO,
                self.mul(self.add(R1[0], self.mul(self.get_constant(-9), R1[1])), yInv),
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
        xr = self.extf_sub(
            X=self.extf_square(X=λ, extension_degree=2), Y=self.extf_add(Qa[0], Qb[0])
        )
        yr = self.extf_sub(
            X=self.extf_mul(X=λ, Y=self.extf_sub(Qa[0], xr), extension_degree=2),
            Y=Qa[1],
        )
        p = (xr, yr)
        line = self.build_sparse_line(
            R0=λ,  # Directly store λ as R0
            R1=self.extf_sub(self.extf_mul(λ, Qa[0], extension_degree=2), Qa[1]),
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
            R1=self.extf_sub(self.extf_mul(λ, Qa[0], extension_degree=2), Qa[1]),
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
        xr = self.extf_sub(
            X=self.extf_square(X=λ, extension_degree=2), Y=self.extf_add(Q[0], Q[0])
        )

        # Compute yr = λ(x - xr) - y
        yr = self.extf_sub(
            X=self.extf_mul(X=λ, Y=self.extf_sub(Q[0], xr), extension_degree=2), Y=Q[1]
        )

        p = (xr, yr)

        # Store the line evaluation for this doubling step
        line = self.build_sparse_line(
            R0=λ,  # Directly store λ as R0
            R1=self.extf_sub(
                self.extf_mul(λ, Q[0], extension_degree=2), Q[1]
            ),  # Compute R1 as λ*x - y
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

        x3 = self.extf_sub(
            X=self.extf_square(X=λ1, extension_degree=2), Y=self.extf_add(Qa[0], Qb[0])
        )

        # omit y3 computation

        line1 = self.build_sparse_line(
            R0=λ1,
            R1=self.extf_sub(
                self.extf_mul(λ1, Qa[0], extension_degree=2), Qa[1]
            ),  # Compute R1 as λ1*x1 - y1
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )
        # compute λ2 = -λ1-2y1/(x3-x1)

        num = self.extf_add(Qa[1], Qa[1])
        den = self.extf_sub(x3, Qa[0])
        λ2 = self.extf_neg(self.extf_add(λ1, self.extf_div(num, den, 2)))

        # compute xr = λ2²-x1-x3
        x4 = self.extf_sub(
            self.extf_sub(self.extf_square(λ2, extension_degree=2), Qa[0]), x3
        )

        # compute y4 = λ2(x1 - x4)-y1
        y4 = self.extf_sub(
            self.extf_mul(λ2, self.extf_sub(Qa[0], x4), extension_degree=2), Qa[1]
        )

        line2 = self.build_sparse_line(
            R0=λ2,
            R1=self.extf_sub(
                self.extf_mul(λ2, Qa[0], extension_degree=2), Qa[1]
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
            self.mul(num_tmp[0], self.get_constant(3)),
            self.mul(num_tmp[1], self.get_constant(6)),
        ]
        den = self.extf_add(Q[1], Q[1])
        λ1 = self.extf_div(num, den, 2)

        line1 = self.build_sparse_line(
            R0=λ1,  # Directly store λ as R0
            R1=self.extf_sub(
                self.extf_mul(λ1, Q[0], extension_degree=2), Q[1]
            ),  # Compute R1 as λ*x - y
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )
        # x2 = λ1^2 - 2x
        x2 = self.extf_sub(
            self.extf_square(λ1, extension_degree=2), self.extf_add(Q[0], Q[0])
        )
        # ommit yr computation, and

        # compute λ2 = 2y/(x2 − x) − λ1.
        # However in https://github.com/Consensys/gnark/blob/7cfcd5a723b0726dcfe75a5fc7249a23d690b00b/std/algebra/emulated/sw_bls12381/pairing.go#L548
        # It's coded as x - x2.
        λ2 = self.extf_sub(self.extf_div(den, self.extf_sub(Q[0], x2), 2), λ1)

        line2 = self.build_sparse_line(
            R0=λ2,
            R1=self.extf_sub(
                self.extf_mul(λ2, Q[0], extension_degree=2), Q[1]
            ),  # Compute R1 as λ2*x1 - y1
            yInv=self.yInv[k],
            xNegOverY=self.xNegOverY[k],
        )

        # // xr = λ²-p.x-x2

        xr = self.extf_sub(
            self.extf_square(λ2, extension_degree=2), self.extf_add(Q[0], x2)
        )

        # // yr = λ(p.x-xr) - p.y
        yr = self.extf_sub(
            self.extf_mul(λ2, self.extf_sub(Q[0], xr), extension_degree=2), Q[1]
        )

        return (xr, yr), line1, line2

    def compute_line_functions(
        self,
        k: int,
    ) -> list[list[ModuloCircuitElement]]:
        """
        Algorithm 2 from https://eprint.iacr.org/2019/077.pdf
        Input : P in G1, Q in G2
        Output : An array g of line functions in Fp12
        """
        T = self.Q[k]
        line_functions = [None] * (len(CURVES[self.curve_id].loop_counter) - 1)
        if self.curve_id == BN254_ID:
            line_functions.append(None)
            assert len(line_functions) == len(CURVES[self.curve_id].loop_counter)

        # Handle case when first bit is 1, need to triple point instead of double and add.
        start_index = len(self.loop_counter) - 2
        if self.loop_counter[start_index] == 1:
            T, l1, l2 = self.triple_step(T, k)

            l = self.extf_mul(
                l1,
                l2,
                12,
                x_sparsity=self.line_sparsity,
                y_sparsity=self.line_sparsity,
                r_sparsity=self.line_line_sparsity,
            )
            self.ops_counter["MUL_L_BY_L"] += 1
            line_functions[start_index] = l
        elif self.loop_counter[start_index] == 0:
            T, l1 = self.double_step(T, k)
            line_functions[start_index] = l1

        # Rest of miller loop.
        for i in range(start_index - 1, -1, -1):
            if self.loop_counter[i] == 0:
                T, l1 = self.double_step(T, k)
                line_functions[i] = l1
            elif self.loop_counter[i] == 1 or self.loop_counter[i] == -1:
                Q_select = self.Q[k] if self.loop_counter[i] == 1 else self.Qneg[k]
                T, l1, l2 = self.double_and_add_step(T, Q_select, k)

                l = self.extf_mul(
                    l1,
                    l2,
                    12,
                    x_sparsity=self.line_sparsity,
                    y_sparsity=self.line_sparsity,
                    r_sparsity=self.line_line_sparsity,
                )
                self.ops_counter["MUL_L_BY_L"] += 1

                line_functions[i] = l
            else:
                raise NotImplementedError

        if self.curve_id == CurveID.BN254.value:
            q1x = [self.Q[k][0][0], self.neg(self.Q[k][0][1])]
            q1y = [self.Q[k][1][0], self.neg(self.Q[k][1][1])]
            q1x = self.extf_mul(
                q1x,
                self.write_elements(
                    [
                        self.field(
                            21575463638280843010398324269430826099269044274347216827212613867836435027261
                        ),
                        self.field(
                            10307601595873709700152284273816112264069230130616436755625194854815875713954
                        ),
                    ],  # Non residue 1 power 2
                    WriteOps.CONSTANT,
                ),
                extension_degree=2,
            )
            q1y = self.extf_mul(
                q1y,
                self.write_elements(
                    [
                        self.field(
                            2821565182194536844548159561693502659359617185244120367078079554186484126554
                        ),
                        self.field(
                            3505843767911556378687030309984248845540243509899259641013678093033130930403
                        ),
                    ],  # Non residue 1 power 3
                    WriteOps.CONSTANT,
                ),
                extension_degree=2,
            )
            q2x = self.extf_scalar_mul(
                self.Q[k][0],
                self.write_element(
                    self.field(
                        21888242871839275220042445260109153167277707414472061641714758635765020556616
                    ),
                    WriteOps.CONSTANT,  # mul_by_non_residue_2_power_2
                ),
            )
            q2y = self.extf_neg(
                self.extf_scalar_mul(
                    self.Q[k][1],
                    self.write_element(
                        self.field(
                            21888242871839275222246405745257275088696311157297823662689037894645226208582
                        ),
                        WriteOps.CONSTANT,  # mul_by_non_residue_2_power_3
                    ),
                )
            )

            T, l1 = self.add_step(T, (q1x, q1y), k)
            l2 = self.line_compute(T, (q2x, q2y), k)
            l = self.extf_mul(
                l1,
                l2,
                12,
                x_sparsity=self.line_sparsity,
                y_sparsity=self.line_sparsity,
                r_sparsity=self.line_line_sparsity,
            )
            self.ops_counter["MUL_L_BY_L"] += 1
            line_functions[-1] = l

        return line_functions

    def compute_double_pair_lines(
        self, j: int, k: int
    ) -> list[list[ModuloCircuitElement]]:
        """
        Returns lines that have either line_line sparsity (bit =0)
        or lines that are fully dense (bit = 1)
        """
        line_functions = [None] * (len(CURVES[self.curve_id].loop_counter) - 1)
        if self.curve_id == BN254_ID:
            line_functions = line_functions + [None]

        lines_j = self.compute_line_functions(j)
        lines_k = self.compute_line_functions(k)

        # Rest of miller loop.
        for i in range(len(self.loop_counter) - 2, -1, -1):
            if self.loop_counter[i] == 0:
                l = self.extf_mul(
                    lines_j[i],
                    lines_k[i],
                    12,
                    x_sparsity=self.line_sparsity,
                    y_sparsity=self.line_sparsity,
                    r_sparsity=self.line_line_sparsity,
                )
                self.ops_counter["MUL_L_BY_L"] += 1
                line_functions[i] = l
            elif self.loop_counter[i] == 1 or self.loop_counter[i] == -1:
                l = self.extf_mul(
                    lines_j[i],
                    lines_k[i],
                    12,
                    x_sparsity=self.line_line_sparsity,
                    y_sparsity=self.line_line_sparsity,
                )
                self.ops_counter["MUL_LL_BY_LL"] += 1
                line_functions[i] = l
            else:
                raise NotImplementedError
        if self.curve_id == BN254_ID:
            line_functions[-1] = self.extf_mul(
                lines_j[-1],
                lines_k[-1],
                12,
                x_sparsity=self.line_line_sparsity,
                y_sparsity=self.line_line_sparsity,
            )
            self.ops_counter["MUL_LL_BY_LL"] += 1

        return line_functions

    def accumulate_single_pair_lines(
        self, lines: list[list[ModuloCircuitElement]], k: int
    ) -> list[ModuloCircuitElement]:
        """
        /!\ Assumes lines came from a double pair of points. Must come from compute_double_pair_lines.
        """
        acc_lines = self.compute_line_functions(k)
        for i in range(len(self.loop_counter) - 2, -1, -1):
            if self.loop_counter[i] == 0:
                lines[i] = self.extf_mul(
                    lines[i],
                    acc_lines[i],
                    12,
                    x_sparsity=self.line_line_sparsity,
                    y_sparsity=self.line_sparsity,
                )
                self.ops_counter["MUL_LL_BY_L"] += 1

            elif self.loop_counter[i] == 1 or self.loop_counter[i] == -1:
                lines[i] = self.extf_mul(
                    lines[i],
                    acc_lines[i],
                    12,
                    x_sparsity=None,
                    y_sparsity=self.line_line_sparsity,
                )
                self.ops_counter["MUL_BY_LL"] += 1
            else:
                raise NotImplementedError
        if self.curve_id == BN254_ID:
            lines[-1] = self.extf_mul(
                lines[-1],
                acc_lines[-1],
                12,
                x_sparsity=None,
                y_sparsity=self.line_line_sparsity,
            )
            self.ops_counter["MUL_LL_BY_LL"] += 1

        return lines

    def accumulate_double_pair_lines(
        self, lines: list[list[ModuloCircuitElement]], j: int, k: int
    ) -> list[ModuloCircuitElement]:
        acc_lines = self.compute_double_pair_lines(j, k)
        for i in range(len(self.loop_counter) - 2, -1, -1):
            if self.loop_counter[i] == 0:
                lines[i] = self.extf_mul(
                    lines[i],
                    acc_lines[i],
                    12,
                    x_sparsity=None,
                    y_sparsity=self.line_line_sparsity,
                )
                self.ops_counter["MUL_BY_LL"] += 1
            elif self.loop_counter[i] == 1 or self.loop_counter[i] == -1:
                lines[i] = self.extf_mul(
                    lines[i],
                    acc_lines[i],
                    12,
                    x_sparsity=None,
                    y_sparsity=None,
                )

            else:
                raise NotImplementedError
        return lines

    def miller_loop(
        self, k: int, lines: list[list[ModuloCircuitElement]] = None
    ) -> list[ModuloCircuitElement]:
        """
        if lines come from k = 1, they are either sparse as line, or sparse as line*line (when bit was 1)
        if lines come from k = 2, they are either sparse as line*line, or fully dense (when bit was 1)
        if lines come from k = 3+, they are always fully dense.
        """
        f = [self.get_constant(1)] + [self.get_constant(0)] * 11
        if k == 1:
            # k==1 done as a single circuit.
            bit_0_sparsity = self.line_sparsity
            bit_1_sparsity = self.line_line_sparsity
            lines = self.compute_line_functions(0)
            OPS_0 = "MUL_BY_L"
            OPS_1 = "MUL_BY_LL"
        if k == 2:
            bit_0_sparsity = self.line_line_sparsity
            bit_1_sparsity = None
            OPS_0 = "MUL_BY_LL"
            OPS_1 = None
        if k >= 3:
            bit_0_sparsity = None
            bit_1_sparsity = None
            OPS_0 = None
            OPS_1 = None

        for i in range(len(self.loop_counter) - 2, -1, -1):

            f = self.extf_square(f, 12)
            if self.loop_counter[i] == 0:
                f = self.extf_mul(f, lines[i], 12, y_sparsity=bit_0_sparsity)
                if OPS_0 is not None:
                    self.ops_counter[OPS_0] += 1
            elif self.loop_counter[i] == 1 or self.loop_counter[i] == -1:
                f = self.extf_mul(f, lines[i], 12, y_sparsity=bit_1_sparsity)
                if OPS_1 is not None:
                    self.ops_counter[OPS_1] += 1

        if self.curve_id == CurveID.BLS12_381.value:
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
        elif self.curve_id == BN254_ID:
            f = self.extf_mul(
                f,
                lines[-1],
                12,
                x_sparsity=None,
                y_sparsity=bit_1_sparsity,
            )
            if OPS_1 is not None:
                self.ops_counter[OPS_1] += 1
        return f
