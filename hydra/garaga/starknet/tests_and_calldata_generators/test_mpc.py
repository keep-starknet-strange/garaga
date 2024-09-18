from dataclasses import dataclass, field
from enum import Enum
from typing import Iterator, Tuple

from garaga.algebra import BaseField, ModuloCircuitElement, Polynomial, PyFelt
from garaga.definitions import BN254_ID, BLS12_381_ID, CURVES, N_LIMBS, CurveID, G1G2Pair, G1Point, G2Point, get_base_field, get_sparsity
from garaga.hints.tower_backup import E6, E12
from garaga.modulo_circuit import WriteOps
from garaga.poseidon_transcript import CairoPoseidonTranscript
from garaga.hints.frobenius import generate_frobenius_maps
from garaga.hints.multi_miller_witness import get_final_exp_witness
from garaga.hints.extf_mul import nondeterministic_extension_field_div, nondeterministic_extension_field_mul_divmod
from garaga.modulo_circuit_structs import Cairo1SerializableStruct, E12D, E12DMulQuotient, MillerLoopResultScalingFactor, Struct, StructSpan, u384Array

# io.py

def flatten(t):
    result = []
    for item in t:
        if isinstance(item, (tuple, list)):
            result.extend(flatten(item))
        else:
            result.append(item)
    return result

# modulo_circuit.py

@dataclass(slots=True, init=False)
class ValueSegment:
    offset: int

    def __init__(self):
        self.offset = 0

    def write_to_segment(self, write_source: WriteOps) -> int:
        offset = self.offset
        self.offset += N_LIMBS
        if write_source == WriteOps.FELT:
            self.offset += 1
        return offset

class ModuloCircuit:
    """
    Represents a modulo circuit capable of performing arithmetic operations on base field elements,
    storing constants, and caching powers of base field elements.

    Attributes:
        circuit_name (str): The name of the circuit.
        last_offset (int): The last used offset in the circuit's memory.
        N_LIMBS (int): The number of limbs used in the circuit.
        values_segment (dict[int, BaseFieldElement]): A dictionary mapping offsets to base field elements.
        add_offsets (list[tuple]): A list of tuples representing the offsets involved in addition operations.
        mul_offsets (list[tuple]): A list of tuples representing the offsets involved in multiplication operations.
        constants (dict[str, ModuloElement]): A dictionary mapping constant names to their ModuloElement representations.
    """

    def __init__(self, curve_id: int) -> None:
        self.curve_id = curve_id
        self.field = BaseField(CURVES[curve_id].p)
        self.values_segment: ValueSegment = ValueSegment()
        self.constants: dict[int, ModuloCircuitElement] = dict()

    def write_element(self, elmt: PyFelt, write_source: WriteOps = WriteOps.INPUT) -> ModuloCircuitElement:
        """
        Register an emulated field element to the circuit given its value and the write source.
        Returns a ModuloCircuitElement representing the written element with its offset as identifier.
        """
        assert isinstance(elmt, PyFelt), f"Expected PyFelt, got {type(elmt)}"
        value_offset = self.values_segment.write_to_segment(write_source)
        return ModuloCircuitElement(elmt, value_offset)

    def write_elements(self, elmts: list[PyFelt], operation: WriteOps, sparsity: list[int] = None) -> list[ModuloCircuitElement]:
        if sparsity is not None:
            assert len(sparsity) == len(elmts), f"Expected sparsity of length {len(elmts)}, got {len(sparsity)}"
            vals = [
                (
                    self.write_element(elmt, operation)
                    if sparsity[i] != 0
                    else self.set_or_get_constant(0)
                )
                for i, elmt in enumerate(elmts)
            ]
        else:
            vals = [self.write_element(elmt, operation) for elmt in elmts]
        return vals

    def set_or_get_constant(self, val: PyFelt | int) -> ModuloCircuitElement:
        if isinstance(val, int):
            val = self.field(val)
        if val.value in self.constants:
            return self.constants[val.value]
        self.constants[val.value] = self.write_element(val, WriteOps.CONSTANT)
        return self.constants[val.value]

    def add(self, a: ModuloCircuitElement, b: ModuloCircuitElement) -> ModuloCircuitElement:
        if a is None and isinstance(b, ModuloCircuitElement):
            return b
        elif b is None and isinstance(a, ModuloCircuitElement):
            return a
        else:
            assert isinstance(a, ModuloCircuitElement) and isinstance(b, ModuloCircuitElement), f"Expected ModuloElement, got {type(a)}, {a} and {type(b)}, {b}"
            return self.write_element(a.emulated_felt + b.emulated_felt, WriteOps.BUILTIN)

    def double(self, a: ModuloCircuitElement) -> ModuloCircuitElement:
        return self.add(a, a)

    def mul(self, a: ModuloCircuitElement, b: ModuloCircuitElement) -> ModuloCircuitElement:
        if a is None and isinstance(b, ModuloCircuitElement):
            return self.set_or_get_constant(0)
        elif b is None and isinstance(a, ModuloCircuitElement):
            return self.set_or_get_constant(0)
        assert isinstance(a, ModuloCircuitElement) and isinstance(b, ModuloCircuitElement), f"Expected ModuloElement, got {type(a)}, {a} and {type(b)}, {b}"
        return self.write_element(a.emulated_felt * b.emulated_felt, WriteOps.BUILTIN)

    def neg(self, a: ModuloCircuitElement) -> ModuloCircuitElement:
        assert (type(a) == ModuloCircuitElement), f"Expected ModuloElement, got {type(a)}, {a}"
        return self.sub(self.set_or_get_constant(self.field.zero()), a)

    def sub(self, a: ModuloCircuitElement, b: ModuloCircuitElement):
        assert isinstance(a, ModuloCircuitElement) and isinstance(b, ModuloCircuitElement), f"Expected ModuloElement, got {type(a)}, {a} and {type(b)}, {b}"
        return self.write_element(a.felt - b.felt, WriteOps.BUILTIN)

    def inv(self, a: ModuloCircuitElement):
        assert isinstance(a, ModuloCircuitElement), f"Expected ModuloElement, got {type(a)}, {a}"
        # Write one before accessing its offset so self.values_offset is correctly updated.
        one = self.set_or_get_constant(1)
        return self.write_element(a.felt.__inv__(), WriteOps.BUILTIN)

    def div(self, a: ModuloCircuitElement, b: ModuloCircuitElement):
        assert isinstance(a, ModuloCircuitElement) and isinstance(b, ModuloCircuitElement), f"Expected ModuloElement, got {type(a)}, {a} and {type(b)}, {b}"
        return self.write_element(a.felt * b.felt.__inv__(), WriteOps.BUILTIN)

    def fp2_mul(self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]):
        # Assumes the irreducible poly is X^2 + 1.
        assert len(X) == len(Y) == 2 and all(
            isinstance(x, ModuloCircuitElement) and isinstance(y, ModuloCircuitElement)
            for x, y in zip(X, Y)
        )
        # xy = (x0 + i*x1) * (y0 + i*y1) = (x0*y0 - x1*y1) + i * (x0*y1 + x1*y0)
        return [
            self.sub(
                self.mul(X[0], Y[0]),
                self.mul(X[1], Y[1]),
            ),
            self.add(
                self.mul(X[0], Y[1]),
                self.mul(X[1], Y[0]),
            ),
        ]

    def fp2_square(self, X: list[ModuloCircuitElement]):
        # Assumes the irreducible poly is X^2 + 1.
        # x² = (x0 + i x1)² = (x0² - x1²) + 2 * i * x0 * x1 = (x0+x1)(x0-x1) + i * 2 * x0 * x1.
        # (x0+x1)*(x0-x1) is cheaper than x0² - x1². (2 ADD + 1 MUL) vs (1 ADD + 2 MUL) (16 vs 20 steps)
        assert len(X) == 2 and all(isinstance(x, ModuloCircuitElement) for x in X)
        return [
            self.mul(self.add(X[0], X[1]), self.sub(X[0], X[1])),
            self.double(self.mul(X[0], X[1])),
        ]

    def fp2_div(self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]):
        assert len(X) == len(Y) == 2 and all(
            isinstance(x, ModuloCircuitElement) and isinstance(y, ModuloCircuitElement)
            for x, y in zip(X, Y)
        )

        x_over_y = nondeterministic_extension_field_div(X, Y, self.curve_id, 2)
        x_over_y = self.write_elements(x_over_y, WriteOps.WITNESS)
        # x_over_y = d0 + i * d1
        # y = y0 + i * y1
        # x = x_over_y*y = d0*y0 - d1*y1 + i * (d0*y1 + d1*y0)
        self.sub_and_assert(
            a=self.mul(x_over_y[0], Y[0]), b=self.mul(x_over_y[1], Y[1]), c=X[0]
        )
        self.add_and_assert(
            a=self.mul(x_over_y[0], Y[1]), b=self.mul(x_over_y[1], Y[0]), c=X[1]
        )
        return x_over_y

    def sub_and_assert(self, a: ModuloCircuitElement, b: ModuloCircuitElement, c: ModuloCircuitElement):
        """
        Subtracts b from a and asserts that the result is equal to c.
        In practice, it checks that c + b = a [mod p].
        All three values are expected to be already in the value segment, no new value is created.
        Costs 2 Steps.
        """
        return c

    def add_and_assert(self, a: ModuloCircuitElement, b: ModuloCircuitElement, c: ModuloCircuitElement):
        """
        Adds a and b and asserts that the result is equal to c.
        In practice, it only checks that a + b = c [mod p].
        All three values are expected to be already in the value segment, no new value is created.
        Costs 2 Steps.
        """
        return c

# extension_fiel_modulo_circuit.py

@dataclass(slots=True)
class AccumulatePolyInstructions:
    Qis: list[Polynomial] = field(default_factory=list)
    Ris: list[list[ModuloCircuitElement]] = field(default_factory=list)

    def append(self, Q: Polynomial, R: list[ModuloCircuitElement]):
        self.Qis.append(Q)
        self.Ris.append(R)

class ExtensionFieldModuloCircuit(ModuloCircuit):
    def __init__(self, curve_id: int, extension_degree: int) -> None:
        super().__init__(curve_id=curve_id)
        self.extension_degree = extension_degree
        self.accumulate_poly_instructions: AccumulatePolyInstructions = AccumulatePolyInstructions()

    def extf_add(self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]) -> list[ModuloCircuitElement]:
        """
        Adds two polynomials with coefficients `X` and `Y`.
        Returns R = [x0 + y0, x1 + y1, x2 + y2, ... + xn-1 + yn-1] mod p
        """
        assert len(X) == len(Y), f"len(X)={len(X)} != len(Y)={len(Y)}"
        return [self.add(x_i, y_i) for i, (x_i, y_i) in enumerate(zip(X, Y))]

    def extf_scalar_mul(self, X: list[ModuloCircuitElement], c: ModuloCircuitElement) -> list[ModuloCircuitElement]:
        """
        Multiplies a polynomial with coefficients `X` by a scalar `c`.
        Input : I(x) = i0 + i1*x + i2*x^2 + ... + in-1*x^n-1
        Output : O(x) = ci0 + ci1*x + ci2*x^2 + ... + cin-1*x^n-1.
        This is done in the circuit.
        """
        assert isinstance(c, ModuloCircuitElement), "c must be a ModuloCircuitElement"
        return [self.mul(x_i, c) for i, x_i in enumerate(X)]

    def extf_neg(self, X: list[ModuloCircuitElement]) -> list[ModuloCircuitElement]:
        """
        Negates a polynomial with coefficients `X`.
        Returns R = [-x0, -x1, -x2, ... -xn-1] mod p
        """
        return [self.neg(x_i) for i, x_i in enumerate(X)]

    def extf_sub(self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]) -> list[ModuloCircuitElement]:
        return [self.sub(x, y) for i, (x, y) in enumerate(zip(X, Y))]

    def extf_mul(
        self,
        Ps: list[list[ModuloCircuitElement]],
        extension_degree: int,
        r_sparsity: list[int] = None,
    ) -> list[ModuloCircuitElement]:
        """
        Multiply in the extension field X * Y mod irreducible_poly
        Commit to R and add an EvalPolyInstruction to the accumulator.
        """
        assert (extension_degree > 2), f"extension_degree={extension_degree} <= 2. Use self.mul or self.fp2_square instead."
        Q, R = nondeterministic_extension_field_mul_divmod(Ps, self.curve_id, extension_degree)
        R = self.write_elements(R, WriteOps.COMMIT, r_sparsity)
        self.accumulate_poly_instructions.append(Polynomial(Q), R)
        return R

    def extf_inv(self, Y: list[ModuloCircuitElement], extension_degree: int) -> list[ModuloCircuitElement]:
        one = [ModuloCircuitElement(self.field(1), -1)] + [ModuloCircuitElement(self.field(0), -1)] * (extension_degree - 1)
        y_inv = nondeterministic_extension_field_div(one, Y, self.curve_id, extension_degree)
        y_inv = self.write_elements(y_inv, WriteOps.COMMIT)
        Q, _ = nondeterministic_extension_field_mul_divmod([y_inv, Y], self.curve_id, extension_degree)
        # R should be One. Passed at mocked modulo circuits element since fully determined by its sparsity.
        Q = Polynomial(Q)
        self.accumulate_poly_instructions.append(Q, one)
        return y_inv

    def conjugate_e12d(self, e12d: list[ModuloCircuitElement]) -> list[ModuloCircuitElement]:
        assert len(e12d) == 12
        return [
            e12d[0],
            self.neg(e12d[1]),
            e12d[2],
            self.neg(e12d[3]),
            e12d[4],
            self.neg(e12d[5]),
            e12d[6],
            self.neg(e12d[7]),
            e12d[8],
            self.neg(e12d[9]),
            e12d[10],
            self.neg(e12d[11]),
        ]

# multi_miller_loop.py

class MultiMillerLoopCircuit(ExtensionFieldModuloCircuit):
    def __init__(self, curve_id: int, n_pairs: int, precompute_lines: bool = False, n_points_precomputed_lines: int = None):
        super().__init__(curve_id=curve_id, extension_degree=12)
        self.curve = CURVES[curve_id]
        self.n_pairs = n_pairs
        self.precompute_lines: bool = precompute_lines
        self.n_points_precomputed_lines = n_points_precomputed_lines
        self.P = []
        self.Q = []
        self.yInv = []
        self.xNegOverY = []
        self.loop_counter = CURVES[self.curve_id].loop_counter
        self.precomputed_lines: list[ModuloCircuitElement] = []
        self._precomputed_lines_generator = None

    def _create_precomputed_lines_generator(self) -> Iterator[
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

    def get_next_precomputed_line(self) -> Tuple[Tuple[PyFelt, PyFelt], Tuple[PyFelt, PyFelt]]:
        return next(self._precomputed_lines_generator)

    def write_p_and_q(self, P: list[G1Point], Q: list[G2Point]):
        assert len(P) == len(Q) == self.n_pairs
        assert set([P[i].curve_id for i in range(len(P))]) == set([Q[i].curve_id for i in range(len(Q))])
        raw = []
        for P, Q in zip(P, Q):
            raw.extend([self.field(P.x), self.field(P.y)])
            raw.extend([self.field(Q.x[0]), self.field(Q.x[1])])
            raw.extend([self.field(Q.y[0]), self.field(Q.y[1])])
        self.write_p_and_q_raw(raw)

    def write_p_and_q_raw(self, input: list[PyFelt]):
        assert (len(input) == 6 * self.n_pairs), f"Expected {6 * self.n_pairs} inputs, got {len(input)}"
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
        self.precompute_consts()

    def precompute_consts(self, skip_P_precompute: bool = False):
        n_pairs = self.n_pairs
        if not skip_P_precompute:
            self.yInv = [self.inv(self.P[i][1]) for i in range(n_pairs)]
            self.xNegOverY = [self.neg(self.div(self.P[i][0], self.P[i][1])) for i in range(n_pairs)]
        if -1 in self.loop_counter:
            self.Qneg = [(self.Q[i][0], self.extf_neg(self.Q[i][1])) for i in range(n_pairs)]
        else:
            self.Qneg = None

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
                self.add(x0, x1),
                self.sub(x0, x1),
            ),
            self.mul(x0, x1),
        ]
        num = [
            self.mul(num_tmp[0], self.set_or_get_constant(3)),
            self.mul(
                num_tmp[1],
                self.set_or_get_constant(6),
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
        ZERO, ONE = ModuloCircuitElement(self.field(0), -1), ModuloCircuitElement(self.field(1), -1)

        if self.curve_id == BN254_ID:
            return [
                ONE,
                self.mul(
                    self.add(R0[0], self.mul(self.set_or_get_constant(-9), R0[1])),
                    xNegOverY,
                ),
                ZERO,
                self.mul(
                    self.add(R1[0], self.mul(self.set_or_get_constant(-9), R1[1])),
                    yInv,
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
                self.mul(
                    self.sub(R1[0], R1[1]), yInv
                ),  # nr=1
                ZERO,
                self.mul(
                    self.sub(R0[0], R0[1]),
                    xNegOverY,
                ),  # nr=1
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

    def _add(
        self,
        Qa: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        Qb: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        k: int,
    ):
        if self.precompute_lines and (k + 1) <= self.n_points_precomputed_lines:
            return (None, None), self.get_next_precomputed_line()
        λ = self.compute_adding_slope(Qa, Qb)
        xr = self.extf_sub(X=self.fp2_square(X=λ), Y=self.extf_add(Qa[0], Qb[0]))
        yr = self.extf_sub(
            X=self.fp2_mul(X=λ, Y=self.extf_sub(Qa[0], xr)),
            Y=Qa[1],
        )
        p = (xr, yr)
        lineR0 = λ
        lineR1 = self.extf_sub(self.fp2_mul(λ, Qa[0]), Qa[1])

        return p, (lineR0, lineR1)

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
        lineR1 = self.extf_sub(self.fp2_mul(λ, Qa[0]), Qa[1])
        return lineR0, lineR1

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
        λ = self.compute_doubling_slope(Q)  # Compute λ = 3x² / 2y

        # Compute xr = λ² - 2x
        xr = self.extf_sub(X=self.fp2_square(X=λ), Y=self.extf_add(Q[0], Q[0]))

        # Compute yr = λ(x - xr) - y
        yr = self.extf_sub(X=self.fp2_mul(λ, self.extf_sub(Q[0], xr)), Y=Q[1])

        p = (xr, yr)

        lineR0 = λ
        lineR1 = self.extf_sub(self.fp2_mul(λ, Q[0]), Q[1])

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
        # Computes 2Qa+Qb as (Qa+Qb)+Qa
        # https://arxiv.org/pdf/math/0208038.pdf 3.1
        λ1 = self.compute_adding_slope(Qa, Qb)

        # compute x3 = λ1²-x1-x2

        x3 = self.extf_sub(X=self.fp2_square(X=λ1), Y=self.extf_add(Qa[0], Qb[0]))

        # omit y3 computation
        line1R0 = λ1
        line1R1 = self.extf_sub(self.fp2_mul(λ1, Qa[0]), Qa[1])

        # compute λ2 = -λ1-2y1/(x3-x1)

        num = self.extf_add(Qa[1], Qa[1])
        den = self.extf_sub(x3, Qa[0])
        λ2 = self.extf_neg(self.extf_add(λ1, self.fp2_div(num, den)))

        # compute xr = λ2²-x1-x3
        x4 = self.extf_sub(self.extf_sub(self.fp2_square(λ2), Qa[0]), x3)

        # compute y4 = λ2(x1 - x4)-y1
        y4 = self.extf_sub(self.fp2_mul(λ2, self.extf_sub(Qa[0], x4)), Qa[1])

        line2R0 = λ2
        line2R1 = self.extf_sub(self.fp2_mul(λ2, Qa[0]), Qa[1])

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

        line1R0 = λ1
        line1R1 = self.extf_sub(self.fp2_mul(λ1, Q[0]), Q[1])

        # x2 = λ1^2 - 2x
        x2 = self.extf_sub(self.fp2_square(λ1), self.extf_add(Q[0], Q[0]))
        # ommit yr computation, and

        # compute λ2 = 2y/(x2 − x) − λ1.
        # However in https://github.com/Consensys/gnark/blob/7cfcd5a723b0726dcfe75a5fc7249a23d690b00b/std/algebra/emulated/sw_bls12381/pairing.go#L548
        # It's coded as x - x2.
        λ2 = self.extf_sub(self.fp2_div(den, self.extf_sub(Q[0], x2)), λ1)

        line2R0 = λ2
        line2R1 = self.extf_sub(self.fp2_mul(λ2, Q[0]), Q[1])

        # // xr = λ²-p.x-x2

        xr = self.extf_sub(self.fp2_square(λ2), self.extf_add(Q[0], x2))

        # // yr = λ(p.x-xr) - p.y
        yr = self.extf_sub(self.fp2_mul(λ2, self.extf_sub(Q[0], xr)), Q[1])

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
                q2x = self.extf_scalar_mul(
                    self.Q[k][0],
                    nr2p2,
                )
                q2y = self.extf_scalar_mul(
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
        curve_id=curve_id,
        n_pairs=n_pairs,
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

# multi_pairing_check.py

class MultiPairingCheckCircuit(MultiMillerLoopCircuit):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int,
        precompute_lines: bool = False,
        n_points_precomputed_lines: int = None,
    ):
        assert n_pairs >= 2, "n_pairs must be >= 2 for pairing checks"
        super().__init__(
            curve_id=curve_id,
            n_pairs=n_pairs,
            precompute_lines=precompute_lines,
            n_points_precomputed_lines=n_points_precomputed_lines,
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
        )
        return new_f, new_points

    def multi_pairing_check(self, n_pairs: int, m: list[ModuloCircuitElement] | None) -> tuple[list[ModuloCircuitElement], list[ModuloCircuitElement], list[ModuloCircuitElement]]:

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
            if self.loop_counter[i] == 0:
                if i > 0 and self.loop_counter[i - 1] == 0:
                    # Two consecutive bits are 0, call bit_00_case
                    f, Qs = self.bit_00_case(f, Qs, n_pairs)
                    i -= 1  # Skip the next bit since it's already processed
                else:
                    # Single bit 0, call bit_0_case
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
            )
            # λ = 6 * x + 2 + q - q**2 + q**3
            c_inv_frob_1 = self.frobenius(c_inv, 1)
            c_frob_2 = self.frobenius(c, 2)
            c_inv_frob_3 = self.frobenius(c_inv, 3)

            f = self.extf_mul(
                ([f, w, c_inv_frob_1, c_frob_2, c_inv_frob_3]),
                12,
                r_sparsity=final_r_sparsity,
            )

        elif self.curve_id == CurveID.BLS12_381.value:
            # λ = -x + q for BLS
            c_inv_frob_1 = self.frobenius(c_inv, 1)
            f = self.extf_mul(
                Ps=[f, w, c_inv_frob_1],
                extension_degree=12,
                r_sparsity=final_r_sparsity,
            )
            if m is not None and len(m) == 12:
                f = self.conjugate_e12d(f)

        else:
            raise NotImplementedError(f"Curve {self.curve_id} not implemented")

        if m is not None and len(m) == 12:
            f = self.extf_mul([f, m], 12, r_sparsity=[1] + [0] * 11)

        assert [fi.value for fi in f] == [1] + [0] * 11, f"f: {f}"
        return (
            f,
            lambda_root,
            lambda_root_inverse,
            scaling_factor,
            scaling_factor_sparsity,
        )

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
        curve_id=curve_id, n_pairs=len(P)
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
    lamda_root_degree = 11
    # Largest Q happens in bit_00 case where we do (f*f* Π_n_pairs(line)^2 * Π_n_pairs(line)
    max_q_degree = 4 * f_degree + 2 * line_degree * n_pairs + line_degree * n_pairs - 12
    return max_q_degree

# mpcheck.py

def extra_miller_loop_result(curve_id: CurveID, public_pair: G1G2Pair) -> list[PyFelt]:
    circuit = MultiMillerLoopCircuit(curve_id=curve_id.value, n_pairs=1)
    circuit.write_p_and_q_raw(public_pair.to_pyfelt_list())
    M = circuit.miller_loop(n_pairs=1)
    return [mi.felt for mi in M]

def multi_pairing_check_result(curve_id: CurveID, pairs: list[G1G2Pair], n_fixed_g2: int, public_pair: G1G2Pair | None, m: list[PyFelt] | None):
    mpcheck_circuit = MultiPairingCheckCircuit(
        curve_id=curve_id.value,
        n_pairs=len(pairs),
        precompute_lines=bool(n_fixed_g2),
        n_points_precomputed_lines=n_fixed_g2,
    )
    lines = precompute_lines([pair.q for pair in pairs[0:n_fixed_g2]])
    assert len(lines) % 4 == 0, f"Lines must be a multiple of 4, got {len(lines)}"
    mpcheck_circuit.precomputed_lines = mpcheck_circuit.write_elements(lines, WriteOps.INPUT)
    mpcheck_circuit._precomputed_lines_generator = mpcheck_circuit._create_precomputed_lines_generator()
    p_q_input = []
    for pair in pairs:
        p_q_input.extend(pair.to_pyfelt_list())
    mpcheck_circuit.write_p_and_q_raw(p_q_input)
    _, lambda_root, lambda_root_inverse, scaling_factor, scaling_factor_sparsity = mpcheck_circuit.multi_pairing_check(len(pairs), m)
    relations = mpcheck_circuit.accumulate_poly_instructions
    Qis, Ris = relations.Qis, relations.Ris
    # Skip first Ri for BN254 as it known to be one (lambda_root*lambda_root_inverse) result
    passed_Ris = (Ris if curve_id == CurveID.BLS12_381 else Ris[1:])  
    if public_pair is not None:
        # Skip last Ri as it is known to be 1 and we use FP12Mul_AssertOne circuit
        passed_Ris = passed_Ris[:-1]  
    return lambda_root, lambda_root_inverse, scaling_factor, scaling_factor_sparsity, Qis, passed_Ris

def hash_hints_and_get_base_random_rlc_coeff(curve_id: CurveID, pairs: list[G1G2Pair], n_fixed_g2: int, lambda_root: list[PyFelt], lambda_root_inverse: list[PyFelt], scaling_factor: list[PyFelt], scaling_factor_sparsity: list[PyFelt], Ris: list[list[PyFelt]]):
    field = get_base_field(curve_id)
    init_hash = f"MPCHECK_{curve_id.name}_{len(pairs)}P_{n_fixed_g2}F"
    transcript = CairoPoseidonTranscript(init_hash=int.from_bytes(init_hash.encode(), byteorder="big"))
    for pair in pairs:
        transcript.hash_limbs_multi(pair.to_pyfelt_list())
    if curve_id == CurveID.BN254:
        transcript.hash_limbs_multi(lambda_root)
    transcript.hash_limbs_multi(lambda_root_inverse)
    transcript.hash_limbs_multi(scaling_factor, sparsity=scaling_factor_sparsity)
    for Ri in Ris:
        assert len(Ri) == 12
        transcript.hash_limbs_multi(Ri)
    return field(transcript.s1)

def compute_big_Q_coeffs(curve_id, Qis, passed_Ris, c0):
    field = get_base_field(curve_id)
    n_relations_with_ci = len(passed_Ris) + (1 if curve_id == CurveID.BN254 else 0)
    ci, big_Q = c0, Polynomial.zero(field.p)
    for i in range(n_relations_with_ci):
        big_Q += Qis[i] * ci
        ci *= ci
    big_Q_expected_len = get_max_Q_degree(curve_id.value, len(pairs)) + 1
    big_Q_coeffs = big_Q.get_coeffs()
    big_Q_coeffs.extend([field.zero()] * (big_Q_expected_len - len(big_Q_coeffs)))
    return big_Q_coeffs

"""
Return MPCheckHint struct and small_Q struct if extra_miller_loop_result is True
"""
def build_mpcheck_hint(curve_id: CurveID, pairs: list[G1G2Pair], n_fixed_g2: int, public_pair: G1G2Pair | None) -> tuple[Cairo1SerializableStruct, Cairo1SerializableStruct | None]:
    # Validate input
    assert isinstance(pairs, (list, tuple))
    assert all(isinstance(pair, G1G2Pair) for pair in pairs), f"All pairs must be G1G2Pair, got {[type(pair) for pair in pairs]}"
    assert all(curve_id == pair.curve_id == pairs[0].curve_id for pair in pairs), f"All pairs must be on the same curve, got {[pair.curve_id for pair in pairs]}"
    assert (isinstance(public_pair, G1G2Pair) or public_pair is None), f"Extra pair must be G1G2Pair or None, got {public_pair}"
    assert len(pairs) >= 2
    assert 0 <= n_fixed_g2 <= len(pairs)

    m = extra_miller_loop_result(curve_id, public_pair) if public_pair is not None else None
    lambda_root, lambda_root_inverse, scaling_factor, scaling_factor_sparsity, Qis, passed_Ris = multi_pairing_check_result(curve_id, pairs, n_fixed_g2, public_pair, m)
    c0 = hash_hints_and_get_base_random_rlc_coeff(curve_id, pairs, n_fixed_g2, lambda_root, lambda_root_inverse, scaling_factor, scaling_factor_sparsity, passed_Ris)
    big_Q_coeffs = compute_big_Q_coeffs(curve_id, Qis, passed_Ris, c0)

    if curve_id == CurveID.BN254:
        hint_struct_list_init = [E12D(name="lambda_root", elmts=lambda_root)]
    else:
        hint_struct_list_init = []
    hint_struct_list_init.append(E12D(name="lambda_root_inverse", elmts=lambda_root_inverse))
    hint_struct_list_init.append(MillerLoopResultScalingFactor(name="w", elmts=[wi for wi, si in zip(scaling_factor, scaling_factor_sparsity) if si != 0]))
    hint_struct_list_init.append(StructSpan(name="Ris", elmts=[E12D(name=f"R{i}", elmts=[ri.felt for ri in Ri]) for i, Ri in enumerate(passed_Ris)]))
    hint_struct_list_init.append(u384Array(name="big_Q", elmts=big_Q_coeffs))
    mpcheck_hint_struct = Struct(struct_name=f"MPCheckHint{curve_id.name}", name="hint", elmts=hint_struct_list_init)

    if public_pair is not None:
        field = get_base_field(curve_id)
        small_Q = Qis[-1].get_coeffs()
        small_Q = small_Q + [field.zero()] * (11 - len(small_Q))
        small_Q_struct = E12DMulQuotient(name="small_Q", elmts=small_Q)
    else:
        small_Q_struct = None

    return mpcheck_hint_struct, small_Q_struct

def mpc_serialize_to_calldata(curve_id: CurveID, pairs: list[G1G2Pair], n_fixed_g2: int, public_pair: G1G2Pair | None) -> list[int]:
    mpcheck_hint, small_Q = build_mpcheck_hint(curve_id, pairs, n_fixed_g2, public_pair)
    call_data: list[int] = []
    call_data.extend(mpcheck_hint.serialize_to_calldata())
    if small_Q is not None:
        call_data.extend(small_Q.serialize_to_calldata())
    return call_data

# tests

if __name__ == "__main__":
    from garaga.starknet.tests_and_calldata_generators.mpcheck import MPCheckCalldataBuilder

    def g1g2pair(c: CurveID, x1: int, y1: int, x2: int, x3: int, y2: int, y3: int) -> G1G2Pair:
        return G1G2Pair(p=G1Point(x=x1, y=y1, curve_id=c), q=G2Point(x=(x2, x3), y=(y2, y3), curve_id=c), curve_id=c)

    pairs1 = [
        g1g2pair(
            CurveID.BN254,
            13128039158878578405311101440433196197030750671434609739599152813953777597656,
            16631698573870232878372968498141532512853508045651172429828485171181737347448,
            10857046999023057135944570762232829481370756359578518086990519993285655852781,
            11559732032986387107991004021392285783925812861821192530917403151452391805634,
            8495653923123431417604973247489272438418190587263600148770280649306958101930,
            4082367875863433681332203403145435568316851327593401208105741076214120093531,
        ),
        g1g2pair(
            CurveID.BN254,
            16972146358605338978832925186803183426611046226825606566434356706141393838202,
            13196854042874744296847103784920665732531458138601311807468784567343458201148,
            8630460879186894947848746851564051176975823064935525955379247650715829661361,
            9389668753221064628742664410943220866829007376428958982009035349098161661555,
            101507912060041238383964462637314541762953824224282578232200414402984982761,
            11031616073657490505344868059178485237553945591986939457256393364699871632182,
        ),
    ]
    public_pair1 = None

    pairs2 = [
        g1g2pair(
            CurveID.BN254,
            3249498908318273722312450266561342384744351408145152472888574144128159241614,
            18326965304442076244056364783642758184171133965386785868619945604645667798645,
            6810322487272704684756846727684393468621070322625759305702914229660436807870,
            659340959365535995846878029322462398780992604972635422373414064580963856167,
            4753110947822659997230336129016503773479834620252828350963402604279211100876,
            513277914363735126912695057642473103134316971932897950349518725870890255169
        ),
        g1g2pair(
            CurveID.BN254,
            3249498908318273722312450266561342384744351408145152472888574144128159241614,
            18326965304442076244056364783642758184171133965386785868619945604645667798645,
            6810322487272704684756846727684393468621070322625759305702914229660436807870,
            659340959365535995846878029322462398780992604972635422373414064580963856167, 
            4753110947822659997230336129016503773479834620252828350963402604279211100876,
            513277914363735126912695057642473103134316971932897950349518725870890255169,
        ),
        g1g2pair(
            CurveID.BN254,
            3249498908318273722312450266561342384744351408145152472888574144128159241614,
            18326965304442076244056364783642758184171133965386785868619945604645667798645,
            6810322487272704684756846727684393468621070322625759305702914229660436807870,
            659340959365535995846878029322462398780992604972635422373414064580963856167,
            4753110947822659997230336129016503773479834620252828350963402604279211100876,
            513277914363735126912695057642473103134316971932897950349518725870890255169,
        ),
    ]
    public_pair2 = g1g2pair(
        CurveID.BN254,
        5035166447272886279885233439320848476728293829349840313987248323970429023730,
        9145874345871415217695572387681529432130338804607494663711237906768538072795, 
        6810322487272704684756846727684393468621070322625759305702914229660436807870,
        659340959365535995846878029322462398780992604972635422373414064580963856167,
        4753110947822659997230336129016503773479834620252828350963402604279211100876,
        513277914363735126912695057642473103134316971932897950349518725870890255169,
    )

    pairs3 = [
        g1g2pair(
            CurveID.BLS12_381,
            54003925790512728529734636557978809665494174139666588559721696027818618841955410766936796549298246037061238557741,
            442070654644991189413420335442826859288657263005211651211465782750858927963217288344089708201407132823820816254377,
            352701069587466618187139116011060144890029952792775240219908644239793785735715026873347600343865175952761926303160,
            3059144344244213709971259814753781636986470325476647558659373206291635324768958432433509563104347017837885763365758,
            1985150602287291935568054521177171638300868978215655730859378665066344726373823718423869104263333984641494340347905,
            927553665492332455747201965776037880757740193453592970025027978793976877002675564980949289727957565575433344219582,
        ),
        g1g2pair(
            CurveID.BLS12_381,
            2519019305560024360348177065589339011121876012630404576125613689972669081700673957096424545789913828791674380155859,
            3662327302685666861417936839242640980855694319377399897002405525453047489734053757539205056345650283566843020165967,
            1258840156485142658461631936837188333931786745480976768055292190021560297444321508204201439522693725173379471166217,
            2126870762633422554730623947755814554495198949002678337997105982104545108633224520310857958409200781392926644002400,
            714503968597760893023853746464499533517790482713985264043773683610663338124112103921472991399418413015930145798576,
            3934317683619246201431803132687663067086081304030769485888408342863757437021952308047494783760053819602684039818256,
        ),
    ]
    public_pair3 = None

    pairs4 = [
        g1g2pair(
            CurveID.BLS12_381,
            3706731792363101107042463949212802329423106373243880227920212798685091194919869452764077810695156795704434503385948,
            169774197169282120473054426880424937876705011602365201846104000533295103889617213746120968768572894783105711740759,
            2776774723596415229842346335056985786333423411046299117648446872771923878144524835135998122930215439000378027481685,
            3310071061263468266022734421683880917934071100706816007998135747373307960012136085415120225145325870977286945138997,
            421579814991759445734865663688297954274726228850537489624876471288545264773224903102410800560756298916876945983803,
            1231064076993223546112860073897212458718138720533546584775364663937008591369223624135784578147603546497729161224272,
        ),
        g1g2pair(
            CurveID.BLS12_381,
            3706731792363101107042463949212802329423106373243880227920212798685091194919869452764077810695156795704434503385948,
            169774197169282120473054426880424937876705011602365201846104000533295103889617213746120968768572894783105711740759,
            2776774723596415229842346335056985786333423411046299117648446872771923878144524835135998122930215439000378027481685,
            3310071061263468266022734421683880917934071100706816007998135747373307960012136085415120225145325870977286945138997,
            421579814991759445734865663688297954274726228850537489624876471288545264773224903102410800560756298916876945983803,
            1231064076993223546112860073897212458718138720533546584775364663937008591369223624135784578147603546497729161224272,
        ),
        g1g2pair(
            CurveID.BLS12_381,
            3706731792363101107042463949212802329423106373243880227920212798685091194919869452764077810695156795704434503385948,
            169774197169282120473054426880424937876705011602365201846104000533295103889617213746120968768572894783105711740759,
            2776774723596415229842346335056985786333423411046299117648446872771923878144524835135998122930215439000378027481685,
            3310071061263468266022734421683880917934071100706816007998135747373307960012136085415120225145325870977286945138997,
            421579814991759445734865663688297954274726228850537489624876471288545264773224903102410800560756298916876945983803,
            1231064076993223546112860073897212458718138720533546584775364663937008591369223624135784578147603546497729161224272,
        ),
    ]
    public_pair4 = g1g2pair(
        CurveID.BLS12_381,
        2493235149414937090342598732346340953140426744071698812750048518316696168502607876745343502496461355407793011430276,
        2377594448062446884751299027564636333966837548202129162398968229684427910690340765575360547995602251195058548909247,
        2776774723596415229842346335056985786333423411046299117648446872771923878144524835135998122930215439000378027481685,
        3310071061263468266022734421683880917934071100706816007998135747373307960012136085415120225145325870977286945138997,
        421579814991759445734865663688297954274726228850537489624876471288545264773224903102410800560756298916876945983803,
        1231064076993223546112860073897212458718138720533546584775364663937008591369223624135784578147603546497729161224272,
    )

    params = [
        (CurveID.BN254, pairs1, 2, public_pair1),
        (CurveID.BN254, pairs2, 2, public_pair2),
        (CurveID.BLS12_381, pairs3, 2, public_pair3),
        (CurveID.BLS12_381, pairs4, 2, public_pair4),
    ]

    for curve_id, pairs, n_fixed_g2, public_pair in params:
        call_data = mpc_serialize_to_calldata(curve_id, pairs, n_fixed_g2, public_pair)

        call_data_expected = MPCheckCalldataBuilder(
            curve_id=curve_id,
            pairs=pairs,
            n_fixed_g2=n_fixed_g2,
            public_pair=public_pair,
        ).serialize_to_calldata()

        assert call_data == call_data_expected

    print('Done!')
