from garaga.algebra import BaseField, Polynomial, PyFelt
from garaga.definitions import BN254_ID, BLS12_381_ID, CURVES, CurveID, G1G2Pair, G1Point, G2Point, PairingCurve, get_base_field, get_sparsity
from garaga.hints.tower_backup import E6, E12
from garaga.poseidon_transcript import CairoPoseidonTranscript
from garaga.hints.frobenius import generate_frobenius_maps
from garaga.hints.multi_miller_witness import get_final_exp_witness
from garaga.hints.extf_mul import nondeterministic_extension_field_mul_divmod
from garaga.hints.io import bigint_split_array
from garaga.hints.tower_backup import get_tower_object

# ext_mul.py

def nondeterministic_extension_field_div(A: list[PyFelt], B: list[PyFelt], curve_id: int, extension_degree: int = 6) -> tuple[list[PyFelt], list[PyFelt]]:
    A = direct_to_tower(A, curve_id, extension_degree)
    B = direct_to_tower(B, curve_id, extension_degree)
    DIV = tower_div(curve_id, A, B, extension_degree)
    return tower_to_direct(DIV, curve_id, extension_degree)

def tower_div(curve_id: int, A: list[PyFelt], B: list[PyFelt], extension_degree: int) -> list[PyFelt]:
    A = get_tower_object(A, curve_id, extension_degree)
    B = get_tower_object(B, curve_id, extension_degree)
    DIV = A.div(B).felt_coeffs
    return DIV

def tower_to_direct(X: list[PyFelt], curve_id: int, extension_degree: int) -> list[PyFelt]:
    assert len(X) == extension_degree and isinstance(X[0], PyFelt), f"len(X)={len(X)}, type(X[0])={type(X[0])}"
    if extension_degree == 2:
        return X
    if extension_degree == 6:
        return TD6(X, curve_id)
    elif extension_degree == 12:
        return TD12(X, curve_id)
    else:
        raise ValueError(f"Unsupported extension degree {extension_degree}")

def direct_to_tower(X: list[PyFelt], curve_id: int, extension_degree: int) -> list[PyFelt]:
    assert len(X) == extension_degree and isinstance(X[0], (PyFelt)), f"{type(X[0])}, len(X)={len(X)}"
    if extension_degree == 2:
        return X
    if extension_degree == 6:
        return DT6(X, curve_id)
    elif extension_degree == 12:
        return DT12(X, curve_id)
    else:
        raise ValueError(f"Unsupported extension degree {extension_degree}")

def TD6(X: list[PyFelt], curve_id: int) -> list[PyFelt]:
    curve = CURVES[curve_id]
    assert isinstance(curve, PairingCurve)
    nr_a0 = curve.nr_a0
    return [
        X[0] - nr_a0 * X[1],
        X[2] - nr_a0 * X[3],
        X[4] - nr_a0 * X[5],
        X[1],
        X[3],
        X[5],
    ]

def DT6(X: list[PyFelt], curve_id: int) -> list[PyFelt]:
    curve = CURVES[curve_id]
    assert isinstance(curve, PairingCurve)
    nr_a0 = curve.nr_a0
    return [
        X[0] + nr_a0 * X[3],
        X[3],
        X[1] + nr_a0 * X[4],
        X[4],
        X[2] + nr_a0 * X[5],
        X[5],
    ]

def TD12(X: list[PyFelt], curve_id: int) -> list[PyFelt]:
    curve = CURVES[curve_id]
    assert isinstance(curve, PairingCurve)
    nr_a0 = curve.nr_a0
    return [
        X[0] - nr_a0 * X[1],
        X[6] - nr_a0 * X[7],
        X[2] - nr_a0 * X[3],
        X[8] - nr_a0 * X[9],
        X[4] - nr_a0 * X[5],
        X[10] - nr_a0 * X[11],
        X[1],
        X[7],
        X[3],
        X[9],
        X[5],
        X[11],
    ]

def DT12(X: list[PyFelt], curve_id: int) -> list[PyFelt]:
    X += (12 - len(X)) * [0]
    curve = CURVES[curve_id]
    assert isinstance(curve, PairingCurve)
    nr_a0 = curve.nr_a0
    return [
        X[0] + nr_a0 * X[6],
        X[6],
        X[2] + nr_a0 * X[8],
        X[8],
        X[4] + nr_a0 * X[10],
        X[10],
        X[1] + nr_a0 * X[7],
        X[7],
        X[3] + nr_a0 * X[9],
        X[9],
        X[5] + nr_a0 * X[11],
        X[11],
    ]

# modulo_circuit_structs.py

class Cairo1SerializableStruct:
    def __init__(self, elmts):
        self.elmts = elmts

    @property
    def bits(self) -> int:
        return self.elmts[0].p.bit_length()

    def serialize_to_calldata(self, *args, **kwargs) -> list[int]:
        return self._serialize_to_calldata(*args, **kwargs)

class Struct(Cairo1SerializableStruct):
    def _serialize_to_calldata(self) -> list[int]:
        cd = []
        for elmt in self.elmts:
            cd.extend(elmt.serialize_to_calldata())
        return cd

class StructSpan(Cairo1SerializableStruct):
    def _serialize_to_calldata(self) -> list[int]:
        cd = []
        cd.append(len(self.elmts))
        for elmt in self.elmts:
            cd.extend(elmt._serialize_to_calldata())
        return cd

class E12D(Cairo1SerializableStruct):
    def _serialize_to_calldata(self) -> list[int]:
        bits: int = self.bits
        if bits <= 288:
            return bigint_split_array(self.elmts, n_limbs=3, prepend_length=False)
        elif bits <= 384:
            return bigint_split_array(self.elmts, n_limbs=4, prepend_length=False)

class E12DMulQuotient(Cairo1SerializableStruct):
    def _serialize_to_calldata(self) -> list[int]:
        bits: int = self.bits
        if bits <= 288:
            return bigint_split_array(self.elmts, n_limbs=3, prepend_length=False)
        elif bits <= 384:
            return bigint_split_array(self.elmts, n_limbs=4, prepend_length=False)

class MillerLoopResultScalingFactor(Cairo1SerializableStruct):
    def _serialize_to_calldata(self) -> list[int]:
        bits = self.bits
        if bits <= 288:
            return bigint_split_array(self.elmts, n_limbs=3, prepend_length=False)
        else:
            return bigint_split_array(self.elmts, n_limbs=4, prepend_length=False)

class u384Array(Cairo1SerializableStruct):
    def _serialize_to_calldata(self) -> list[int]:
        if len(self.elmts) == 0:
            return [0]
        bits = self.bits
        if bits <= 288:
            return bigint_split_array(self.elmts, n_limbs=3, prepend_length=True)
        else:
            return bigint_split_array(self.elmts, n_limbs=4, prepend_length=True)

# modulo_circuit.py

def filter_elements(elmts: list[PyFelt], sparsity: list[int]) -> list[PyFelt]:
    assert len(sparsity) == len(elmts)
    if len(elmts) == 0:
        return []
    field = BaseField(elmts[0].p)
    return [(elmt if sparsity[i] != 0 else field(0)) for i, elmt in enumerate(elmts)]

def add(a: PyFelt, b: PyFelt) -> PyFelt:
    return a + b

def double(a: PyFelt) -> PyFelt:
    return a + a

def mul(a: PyFelt, b: PyFelt) -> PyFelt:
    return a * b

def neg(a: PyFelt) -> PyFelt:
    return -a

def sub(a: PyFelt, b: PyFelt):
    return a - b

def inv(a: PyFelt):
    return a.__inv__()

def div(a: PyFelt, b: PyFelt):
    return a * b.__inv__()

def fp2_mul(X: list[PyFelt], Y: list[PyFelt]):
    # Assumes the irreducible poly is X^2 + 1.
    assert len(X) == len(Y) == 2
    # xy = (x0 + i*x1) * (y0 + i*y1) = (x0*y0 - x1*y1) + i * (x0*y1 + x1*y0)
    return [
        sub(mul(X[0], Y[0]), mul(X[1], Y[1])),
        add(mul(X[0], Y[1]), mul(X[1], Y[0])),
    ]

def fp2_square(X: list[PyFelt]):
    # Assumes the irreducible poly is X^2 + 1.
    # x² = (x0 + i x1)² = (x0² - x1²) + 2 * i * x0 * x1 = (x0+x1)(x0-x1) + i * 2 * x0 * x1.
    # (x0+x1)*(x0-x1) is cheaper than x0² - x1². (2 ADD + 1 MUL) vs (1 ADD + 2 MUL) (16 vs 20 steps)
    assert len(X) == 2
    return [
        mul(add(X[0], X[1]), sub(X[0], X[1])),
        double(mul(X[0], X[1])),
    ]

def fp2_div(curve_id: int, X: list[PyFelt], Y: list[PyFelt]):
    assert len(X) == len(Y) == 2
    return nondeterministic_extension_field_div(X, Y, curve_id, 2)

# extension_fiel_modulo_circuit.py

def extf_add(X: list[PyFelt], Y: list[PyFelt]) -> list[PyFelt]:
    """
    Adds two polynomials with coefficients `X` and `Y`.
    Returns R = [x0 + y0, x1 + y1, x2 + y2, ... + xn-1 + yn-1] mod p
    """
    assert len(X) == len(Y)
    return [add(x_i, y_i) for (x_i, y_i) in zip(X, Y)]

def extf_scalar_mul(X: list[PyFelt], c: PyFelt) -> list[PyFelt]:
    """
    Multiplies a polynomial with coefficients `X` by a scalar `c`.
    Input : I(x) = i0 + i1*x + i2*x^2 + ... + in-1*x^n-1
    Output : O(x) = ci0 + ci1*x + ci2*x^2 + ... + cin-1*x^n-1.
    This is done in the circuit.
    """
    return [mul(x_i, c) for x_i in X]

def extf_neg(X: list[PyFelt]) -> list[PyFelt]:
    """
    Negates a polynomial with coefficients `X`.
    Returns R = [-x0, -x1, -x2, ... -xn-1] mod p
    """
    return [neg(x_i) for x_i in X]

def extf_sub(X: list[PyFelt], Y: list[PyFelt]) -> list[PyFelt]:
    return [sub(x, y) for x, y in zip(X, Y)]

def extf_mul(curve_id: int, Qis, Ris, Ps: list[list[PyFelt]], extension_degree: int, r_sparsity: list[int] = None) -> list[PyFelt]:
    """
    Multiply in the extension field X * Y mod irreducible_poly
    Commit to R and add an EvalPolyInstruction to the accumulator.
    """
    assert extension_degree > 2, f"extension_degree={extension_degree} <= 2. Use self.mul or self.fp2_square instead."
    Q, R = nondeterministic_extension_field_mul_divmod(Ps, curve_id, extension_degree)
    if r_sparsity is not None:
        R = filter_elements(R, r_sparsity)
    if Qis is not None: Qis.append(Polynomial(Q))
    if Ris is not None: Ris.append(R)
    return R

def extf_inv(curve_id: int, Qis, Ris, Y: list[PyFelt], extension_degree: int) -> list[PyFelt]:
    field = BaseField(CURVES[curve_id].p)
    one = [field(1)] + [field(0)] * (extension_degree - 1)
    y_inv = nondeterministic_extension_field_div(one, Y, curve_id, extension_degree)
    Q, R = nondeterministic_extension_field_mul_divmod([y_inv, Y], curve_id, extension_degree)
    # R should be One. Passed at mocked modulo circuits element since fully determined by its sparsity.
    assert R == one
    if Qis is not None: Qis.append(Polynomial(Q))
    if Ris is not None: Ris.append(R)
    return y_inv

def conjugate_e12d(e12d: list[PyFelt]) -> list[PyFelt]:
    assert len(e12d) == 12
    return [
        e12d[0],
        neg(e12d[1]),
        e12d[2],
        neg(e12d[3]),
        e12d[4],
        neg(e12d[5]),
        e12d[6],
        neg(e12d[7]),
        e12d[8],
        neg(e12d[9]),
        e12d[10],
        neg(e12d[11]),
    ]

# multi_miller_loop.py

def precompute_consts(P: list[tuple[PyFelt, PyFelt]]):
    yInv = [inv(p[1]) for p in P]
    xNegOverY = [neg(div(p[0], p[1])) for p in P]
    return yInv, xNegOverY

def compute_doubling_slope(curve_id: int, Q: tuple[list[PyFelt], list[PyFelt]]) -> list[PyFelt, PyFelt]:
    field = BaseField(CURVES[curve_id].p)
    # num = 3 * x^2
    # den = 2 * y
    x0, x1 = Q[0][0], Q[0][1]
    # x² = (x0 + i x1)² = (x0² - x1²) + 2 * i * x0 * x1 = (x0+x1)(x0-x1) + i * 2 * x0 * x1.
    # (x0+x1)*(x0-x1) is cheaper than x0² - x1². (2 ADD + 1 MUL) vs (1 ADD + 2 MUL) (16 vs 20 steps)
    # Omits mul by 2x for imaginary part to multiply once by 6 instead of doubling and multiplying by 3.
    num = [
        mul(mul(add(x0, x1), sub(x0, x1)), field(3)),
        mul(mul(x0, x1), field(6)),
    ]
    den = extf_add(Q[1], Q[1])
    return fp2_div(curve_id, num, den)

def compute_adding_slope(curve_id: int, Qa: tuple[list[PyFelt], list[PyFelt]], Qb: tuple[list[PyFelt], list[PyFelt]]) -> list[PyFelt]:
    # num = ya - yb
    # den = xa - xb
    num = extf_sub(Qa[1], Qb[1])
    den = extf_sub(Qa[0], Qb[0])
    return fp2_div(curve_id, num, den)

def build_sparse_line_eval(curve_id: int, R0: tuple[PyFelt, PyFelt], R1: tuple[PyFelt, PyFelt], yInv: PyFelt, xNegOverY: PyFelt) -> list[PyFelt]:
    field = BaseField(CURVES[curve_id].p)
    # Mocked PyFelt for ZERO and ONE.
    # They are not part of the circuit because only the non-zero or non-ones will be used due do the
    # known-in-advance sparsity
    ZERO, ONE = field(0), field(1)
    if curve_id == BN254_ID:
        return [
            ONE,
            mul(add(R0[0], mul(field(-9), R0[1])), xNegOverY),
            ZERO,
            mul(add(R1[0], mul(field(-9), R1[1])), yInv),
            ZERO,
            ZERO,
            ZERO,
            mul(R0[1], xNegOverY),
            ZERO,
            mul(R1[1], yInv),
            ZERO,
            ZERO,
        ]
    elif curve_id == BLS12_381_ID:
        return [
            mul(sub(R1[0], R1[1]), yInv),  # nr=1
            ZERO,
            mul(sub(R0[0], R0[1]), xNegOverY),  # nr=1
            ONE,
            ZERO,
            ZERO,
            mul(R1[1], yInv),
            ZERO,
            mul(R0[1], xNegOverY),
            ZERO,
            ZERO,
            ZERO,
        ]
    else:
        raise NotImplementedError

def _add(curve_id: int, Qa: tuple[list[PyFelt], list[PyFelt]], Qb: tuple[list[PyFelt], list[PyFelt]], k: int):
    λ = compute_adding_slope(curve_id, Qa, Qb)
    xr = extf_sub(fp2_square(λ), extf_add(Qa[0], Qb[0]))
    yr = extf_sub(fp2_mul(λ, extf_sub(Qa[0], xr)), Qa[1])
    p = (xr, yr)
    lineR0 = λ
    lineR1 = extf_sub(fp2_mul(λ, Qa[0]), Qa[1])
    return p, (lineR0, lineR1)

def _line_compute(curve_id: int, Qa: tuple[list[PyFelt], list[PyFelt]], Qb: tuple[list[PyFelt], list[PyFelt]], k: int):
    λ = compute_adding_slope(curve_id, Qa, Qb)
    lineR0 = λ
    lineR1 = extf_sub(fp2_mul(λ, Qa[0]), Qa[1])
    return lineR0, lineR1

def _double(curve_id: int, Q: tuple[list[PyFelt], list[PyFelt]], k: int):
    """
    Perform a single doubling of a point on an elliptic curve and store the line evaluation,
    including computations that involve the y coordinate.

    :param p1: A tuple representing the point on the curve (x, y) in the extension field.
    :return: A tuple containing the doubled point and the line evaluation.
    """
    λ = compute_doubling_slope(curve_id, Q)  # Compute λ = 3x² / 2y
    # Compute xr = λ² - 2x
    xr = extf_sub(fp2_square(λ), extf_add(Q[0], Q[0]))
    # Compute yr = λ(x - xr) - y
    yr = extf_sub(fp2_mul(λ, extf_sub(Q[0], xr)), Q[1])
    p = (xr, yr)
    lineR0 = λ
    lineR1 = extf_sub(fp2_mul(λ, Q[0]), Q[1])
    return p, (lineR0, lineR1)

def double_step(curve_id: int, Q: tuple[list[PyFelt], list[PyFelt]], k: int, yInv: PyFelt, xNegOverY: PyFelt):
    p, (lineR0, lineR1) = _double(curve_id, Q, k)
    line = build_sparse_line_eval(curve_id, lineR0, lineR1, yInv, xNegOverY)
    return p, line

def _double_and_add(curve_id: int, Qa: tuple[list[PyFelt], list[PyFelt]], Qb: tuple[list[PyFelt], list[PyFelt]], k: int) -> list[PyFelt]:
    # Computes 2Qa+Qb as (Qa+Qb)+Qa
    # https://arxiv.org/pdf/math/0208038.pdf 3.1
    λ1 = compute_adding_slope(curve_id, Qa, Qb)
    # compute x3 = λ1²-x1-x2
    x3 = extf_sub(fp2_square(λ1), extf_add(Qa[0], Qb[0]))
    # omit y3 computation
    line1R0 = λ1
    line1R1 = extf_sub(fp2_mul(λ1, Qa[0]), Qa[1])
    # compute λ2 = -λ1-2y1/(x3-x1)
    num = extf_add(Qa[1], Qa[1])
    den = extf_sub(x3, Qa[0])
    λ2 = extf_neg(extf_add(λ1, fp2_div(curve_id, num, den)))
    # compute xr = λ2²-x1-x3
    x4 = extf_sub(extf_sub(fp2_square(λ2), Qa[0]), x3)
    # compute y4 = λ2(x1 - x4)-y1
    y4 = extf_sub(fp2_mul(λ2, extf_sub(Qa[0], x4)), Qa[1])
    line2R0 = λ2
    line2R1 = extf_sub(fp2_mul(λ2, Qa[0]), Qa[1])
    return (x4, y4), (line1R0, line1R1), (line2R0, line2R1)

def double_and_add_step(curve_id: int, Qa: tuple[list[PyFelt], list[PyFelt]], Qb: tuple[list[PyFelt], list[PyFelt]], k: int, yInv: PyFelt, xNegOverY: PyFelt):
    (new_x, new_y), (line1R0, line1R1), (line2R0, line2R1) = _double_and_add(curve_id, Qa, Qb, k)
    line1 = build_sparse_line_eval(curve_id, line1R0, line1R1, yInv, xNegOverY)
    line2 = build_sparse_line_eval(curve_id, line2R0, line2R1, yInv, xNegOverY)
    return (new_x, new_y), line1, line2

def _triple(curve_id: int, Q: tuple[list[PyFelt], list[PyFelt]], k: int):
    field = BaseField(CURVES[curve_id].p)
    # Compute λ = 3x² / 2y. Manually to keep den = 2y to be re-used for λ2.
    x0, x1 = Q[0][0], Q[0][1]
    num = [
        mul(mul(add(x0, x1), sub(x0, x1)), field(3)),
        mul(mul(x0, x1), field(6)),
    ]
    den = extf_add(Q[1], Q[1])
    λ1 = fp2_div(curve_id, num, den)
    line1R0 = λ1
    line1R1 = extf_sub(fp2_mul(λ1, Q[0]), Q[1])
    # x2 = λ1^2 - 2x
    x2 = extf_sub(fp2_square(λ1), extf_add(Q[0], Q[0]))
    # ommit yr computation, and
    # compute λ2 = 2y/(x2 − x) − λ1.
    # However in https://github.com/Consensys/gnark/blob/7cfcd5a723b0726dcfe75a5fc7249a23d690b00b/std/algebra/emulated/sw_bls12381/pairing.go#L548
    # It's coded as x - x2.
    λ2 = extf_sub(fp2_div(curve_id, den, extf_sub(Q[0], x2)), λ1)
    line2R0 = λ2
    line2R1 = extf_sub(fp2_mul(λ2, Q[0]), Q[1])
    # // xr = λ²-p.x-x2
    xr = extf_sub(fp2_square(λ2), extf_add(Q[0], x2))
    # // yr = λ(p.x-xr) - p.y
    yr = extf_sub(fp2_mul(λ2, extf_sub(Q[0], xr)), Q[1])
    return (xr, yr), (line1R0, line1R1), (line2R0, line2R1)

def triple_step(curve_id: int, Q: tuple[list[PyFelt], list[PyFelt]], k: int, yInv: PyFelt, xNegOverY: PyFelt):
    (new_x, new_y), (line1R0, line1R1), (line2R0, line2R1) = _triple(curve_id, Q, k)
    line1 = build_sparse_line_eval(curve_id, line1R0, line1R1, yInv, xNegOverY)
    line2 = build_sparse_line_eval(curve_id, line2R0, line2R1, yInv, xNegOverY)
    return (new_x, new_y), line1, line2

def __bit_0_case(curve_id: int, f: list[PyFelt], points: list[tuple[list[PyFelt], list[PyFelt]]], n_pairs: int, yInv: list[PyFelt], xNegOverY: list[PyFelt]):
    """
    Compute the bit 0 case of the Miller loop.
    params : f : the current miller loop FP12 element
            points : the list of points to double
            n_pairs : the number of pairs to double
    returns : the new miller loop FP12 element and the new points
    """
    assert len(points) == n_pairs
    new_lines = [f, f]
    new_points = []
    for k in range(n_pairs):
        T, l1 = double_step(curve_id, points[k], k, yInv[k], xNegOverY[k])
        new_lines.append(l1)
        new_points.append(T)
    # Square f and multiply by lines for all pairs
    new_f = extf_mul(curve_id, None, None, new_lines, 12)
    return new_f, new_points

def __bit_1_init_case(curve_id: int, f: list[PyFelt], points: list[tuple[list[PyFelt], list[PyFelt]]], n_pairs: int, yInv: list[PyFelt], xNegOverY: list[PyFelt]):
    """
    Compute the bit 1 case of the Miller loop when it is the first bit.
    Uses triple step instead of double and add.
    """
    assert len(points) == n_pairs
    new_lines = [f, f]
    new_points = []
    for k in range(n_pairs):
        T, l1, l2 = triple_step(curve_id, points[k], k, yInv[k], xNegOverY[k])
        new_lines.append(l1)
        new_lines.append(l2)
        new_points.append(T)
    # Square f and multiply by lines for all pairs
    new_f = extf_mul(curve_id, None, None, new_lines, 12)
    return new_f, new_points

def __bit_1_case(curve_id: int, f: list[PyFelt], points: list[tuple[list[PyFelt], list[PyFelt]]], Q_select: list[tuple[list[PyFelt], list[PyFelt]]], n_pairs: int, yInv: list[PyFelt], xNegOverY: list[PyFelt]):
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
    new_lines = [f, f]
    new_points = []
    for k in range(n_pairs):
        T, l1, l2 = double_and_add_step(curve_id, points[k], Q_select[k], k, yInv[k], xNegOverY[k])
        new_lines.append(l1)
        new_lines.append(l2)
        new_points.append(T)
    # Square f and multiply by lines for all pairs
    new_f = extf_mul(curve_id, None, None, new_lines, 12)
    return new_f, new_points

def _bn254_finalize_step(curve_id: int, Qs: list[tuple[list[PyFelt], list[PyFelt]]], Q: list[tuple[tuple[PyFelt, PyFelt], tuple[PyFelt, PyFelt]]]):
    def set_or_get_constants():
        field = BaseField(CURVES[curve_id].p)
        nr1p2 = [
            field(21575463638280843010398324269430826099269044274347216827212613867836435027261),
            field(10307601595873709700152284273816112264069230130616436755625194854815875713954),
        ]  # Non residue 1 power 2
        nr1p3 = [
            field(2821565182194536844548159561693502659359617185244120367078079554186484126554),
            field(3505843767911556378687030309984248845540243509899259641013678093033130930403),
        ]  # Non residue 1 power 3
        nr2p2 = field(21888242871839275220042445260109153167277707414472061641714758635765020556616)  # non_residue_2_power_2
        nr2p3 = field(-21888242871839275222246405745257275088696311157297823662689037894645226208582)  # (-1) * non_residue_2_power_3
        return nr1p2, nr1p3, nr2p2, nr2p3

    new_lines = []
    for k in range(len(Q)):
        nr1p2, nr1p3, nr2p2, nr2p3 = set_or_get_constants()
        q1x = [Q[k][0][0], neg(Q[k][0][1])]
        q1y = [Q[k][1][0], neg(Q[k][1][1])]
        q1x = fp2_mul(q1x, nr1p2)
        q1y = fp2_mul(q1y, nr1p3)
        q2x = extf_scalar_mul(Q[k][0], nr2p2)
        q2y = extf_scalar_mul(Q[k][1], nr2p3)
        T, (l1R0, l1R1) = _add(curve_id, Qs[k], (q1x, q1y), k)
        l2R0, l2R1 = _line_compute(curve_id, T, (q2x, q2y), k)
        new_lines.append(((l1R0, l1R1), (l2R0, l2R1)))
    return new_lines

def bn254_finalize_step(curve_id: int, Qs: list[tuple[list[PyFelt], list[PyFelt]]], Q: list[tuple[tuple[PyFelt, PyFelt], tuple[PyFelt, PyFelt]]], yInv: list[PyFelt], xNegOverY: list[PyFelt]):
    lines = _bn254_finalize_step(curve_id, Qs, Q)
    lines_evaluated = []
    for k, (l1, l2) in enumerate(lines):
        line_eval1 = build_sparse_line_eval(curve_id, l1[0], l1[1], yInv[k], xNegOverY[k])
        line_eval2 = build_sparse_line_eval(curve_id, l2[0], l2[1], yInv[k], xNegOverY[k])
        lines_evaluated.append(line_eval1)
        lines_evaluated.append(line_eval2)
    return lines_evaluated

def miller_loop(curve_id: int, P: list[tuple[PyFelt, PyFelt]], Q: list[tuple[tuple[PyFelt, PyFelt], tuple[PyFelt, PyFelt]]]) -> list[PyFelt]:
    assert len(P) == len(Q)
    n_pairs = len(P)

    yInv, xNegOverY = precompute_consts(P)

    field = BaseField(CURVES[curve_id].p)
    loop_counter = CURVES[curve_id].loop_counter
    f = [field(1)] + [field(0)] * 11

    if -1 in loop_counter:
        Qneg = [(Q[i][0], extf_neg(Q[i][1])) for i in range(n_pairs)]

    start_index = len(loop_counter) - 2

    if loop_counter[start_index] == 1:
        # Handle case when first bit is +1, need to triple point instead of double and add.
        f, Qs = __bit_1_init_case(curve_id, f, Q, n_pairs, yInv, xNegOverY)
    elif loop_counter[start_index] == 0:
        f, Qs = __bit_0_case(curve_id, f, Q, n_pairs, yInv, xNegOverY)
    else:
        raise NotImplementedError(f"Init bit {loop_counter[start_index]} not implemented")

    # Rest of miller loop.
    for i in range(start_index - 1, -1, -1):
        if loop_counter[i] == 0:
            f, Qs = __bit_0_case(curve_id, f, Qs, n_pairs, yInv, xNegOverY)
        elif loop_counter[i] == 1 or loop_counter[i] == -1:
            # Choose Q or -Q depending on the bit for the addition.
            Q_selects = [(Q[k] if loop_counter[i] == 1 else Qneg[k]) for k in range(n_pairs)]
            f, Qs = __bit_1_case(curve_id, f, Qs, Q_selects, n_pairs, yInv, xNegOverY)
        else:
            raise NotImplementedError(f"Bit {loop_counter[i]} not implemented")

    if curve_id == CurveID.BN254.value:
        lines = bn254_finalize_step(curve_id, Qs, Q, yInv, xNegOverY)
        f = extf_mul(curve_id, None, None, [f, *lines], 12)
    elif curve_id == CurveID.BLS12_381.value:
        f = conjugate_e12d(f)
    else:
        raise NotImplementedError(f"Curve {curve_id} not implemented")

    return f

# multi_pairing_check.py

def frobenius(curve_id: int, frobenius_maps, X: list[PyFelt], frob_power: int, extension_degree: int) -> list[PyFelt]:
    field = BaseField(CURVES[curve_id].p)
    frob = [None] * extension_degree
    for i, list_op in enumerate(frobenius_maps[frob_power]):
        list_op_result = []
        for index, constant in list_op:
            if constant == 1:
                list_op_result.append(X[index])
            else:
                list_op_result.append(mul(X[index], field(constant)))
        frob[i] = list_op_result[0]
        for op_res in list_op_result[1:]:
            frob[i] = add(frob[i], op_res)
    return frob

def bit_0_case(curve_id: int, f: list[PyFelt], points: list[tuple[list[PyFelt], list[PyFelt]]], n_pairs: int, yInv: list[PyFelt], xNegOverY: list[PyFelt], Qis, Ris):
    """
    Compute the bit 0 case of the Miller loop.
    params : f : the current miller loop FP12 element
            points : the list of points to double
            n_pairs : the number of pairs to double
    returns : the new miller loop FP12 element and the new points
    """
    assert len(points) == n_pairs
    new_lines = [f, f]
    new_points = []
    for k in range(n_pairs):
        T, l1 = double_step(curve_id, points[k], k, yInv[k], xNegOverY[k])
        new_lines.append(l1)
        new_points.append(T)
    # Square f and multiply by lines for all pairs
    new_f = extf_mul(curve_id, Qis, Ris, new_lines, 12)
    return new_f, new_points

def bit_00_case(curve_id: int, f: list[PyFelt], points: list[tuple[list[PyFelt], list[PyFelt]]], n_pairs: int, yInv: list[PyFelt], xNegOverY: list[PyFelt], Qis, Ris):
    """
    Compute the bit 00 case of the Miller loop.
    params : f : the current miller loop FP12 element
            points : the list of points to double
            n_pairs : the number of pairs to double
    returns : the new miller loop FP12 element and the new points
    """
    assert len(points) == n_pairs
    new_lines = [f, f, f, f]
    new_points = []
    for k in range(n_pairs):
        T, l1 = double_step(curve_id, points[k], k, yInv[k], xNegOverY[k])
        new_lines.append(l1)
        new_lines.append(l1)  # Double since it's going to be squared
        new_points.append(T)
    new_new_points = []
    for k in range(n_pairs):
        T, l1 = double_step(curve_id, new_points[k], k, yInv[k], xNegOverY[k])
        new_lines.append(l1)
        new_new_points.append(T)
    # (f^2 * Π_(new_lines))^2 * Π_new_new_lines = f^4 * Π_new_lines^2 * Π_new_new_lines
    new_f = extf_mul(curve_id, Qis, Ris, new_lines, 12)
    return new_f, new_new_points

def bit_1_init_case(curve_id: int, f: list[PyFelt], points: list[tuple[list[PyFelt], list[PyFelt]]], n_pairs: int, yInv: list[PyFelt], xNegOverY: list[PyFelt], c: list[PyFelt], Qis, Ris):
    """
    Compute the bit 1 case of the Miller loop when it is the first bit (positive).
    Uses triple step instead of double and add.
    """
    assert len(points) == n_pairs
    new_lines = [f, f, c]
    new_points = []
    for k in range(n_pairs):
        T, l1, l2 = triple_step(curve_id, points[k], k, yInv[k], xNegOverY[k])
        new_lines.append(l1)
        new_lines.append(l2)
        new_points.append(T)
    # Square f and multiply by lines for all pairs
    new_f = extf_mul(curve_id, Qis, Ris, new_lines, 12)
    return new_f, new_points

def bit_1_case(curve_id: int, f: list[PyFelt], points: list[tuple[list[PyFelt], list[PyFelt]]], Q_select: list[tuple[list[PyFelt], list[PyFelt]]], n_pairs: int, yInv: list[PyFelt], xNegOverY: list[PyFelt], c_or_c_inv: list[PyFelt], Qis, Ris):
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
    new_lines = [f, f, c_or_c_inv]
    new_points = []
    for k in range(n_pairs):
        T, l1, l2 = double_and_add_step(curve_id, points[k], Q_select[k], k, yInv[k], xNegOverY[k])
        new_lines.append(l1)
        new_lines.append(l2)
        new_points.append(T)
    # Square f and multiply by lines for all pairs
    new_f = extf_mul(curve_id, Qis, Ris, new_lines, 12)
    return new_f, new_points

def multi_pairing_check(curve_id: int, P: list[tuple[PyFelt, PyFelt]], Q: list[tuple[tuple[PyFelt, PyFelt], tuple[PyFelt, PyFelt]]], n_fixed_g2: int, m: list[PyFelt] | None):
    assert len(P) == len(Q)
    n_pairs = len(P)

    Qis, Ris = [], []

    c_or_c_inv, scaling_factor, scaling_factor_sparsity = get_root_and_scaling_factor(curve_id, P, Q, m)
    w = filter_elements(scaling_factor, scaling_factor_sparsity)
    compact_scaling_factor = [wi for wi, si in zip(scaling_factor, scaling_factor_sparsity) if si != 0]

    if curve_id == CurveID.BLS12_381.value:
        # Conjugate c so that the final conjugate in BLS loop gives indeed f/c^(-x), as conjugate(f/conjugate(c^(-x))) = conjugate(f)/c^(-x)
        lambda_root = None
        lambda_root_inverse = c_or_c_inv
        c_inv = conjugate_e12d(lambda_root_inverse)
    elif curve_id == CurveID.BN254.value:
        lambda_root = c = c_or_c_inv
        lambda_root_inverse = c_inv = extf_inv(curve_id, Qis, Ris, c_or_c_inv, 12)

    # Init f as 1/c = 1 / (λ-th √(f_output*scaling_factor)), where:
    # λ = 6 * x + 2 + q - q**2 + q**3 for BN
    # λ = -x + q for BLS
    # Miller loop will compute f_output/c^(6*x2) if BN, or f_output/c^(-x) if BLS

    f = c_inv

    loop_counter = CURVES[curve_id].loop_counter

    start_index = len(loop_counter) - 2

    yInv, xNegOverY = precompute_consts(P)

    if loop_counter[start_index] == 1:
        # Handle case when first bit is +1, need to triple point instead of double and add.
        f, Qs = bit_1_init_case(curve_id, f, Q, n_pairs, yInv, xNegOverY, c_inv, Qis, Ris)
    elif loop_counter[start_index] == 0:
        f, Qs = bit_0_case(curve_id, f, Q, n_pairs, yInv, xNegOverY, Qis, Ris)
    else:
        raise NotImplementedError(f"Init bit {loop_counter[start_index]} not implemented")

    if -1 in loop_counter:
        Qneg = [(Q[i][0], extf_neg(Q[i][1])) for i in range(n_pairs)]

    i = start_index - 1
    while i >= 0:
        if loop_counter[i] == 0:
            if i > 0 and loop_counter[i - 1] == 0:
                # Two consecutive bits are 0, call bit_00_case
                f, Qs = bit_00_case(curve_id, f, Qs, n_pairs, yInv, xNegOverY, Qis, Ris)
                i -= 1  # Skip the next bit since it's already processed
            else:
                # Single bit 0, call bit_0_case
                f, Qs = bit_0_case(curve_id, f, Qs, n_pairs, yInv, xNegOverY, Qis, Ris)
        elif loop_counter[i] == 1 or loop_counter[i] == -1:
            # Choose Q or -Q depending on the bit for the addition.
            Q_selects = [(Q[k] if loop_counter[i] == 1 else Qneg[k]) for k in range(n_pairs)]
            # Want to multiply by 1/c if bit is positive, by c if bit is negative.
            c_or_c_inv = c_inv if loop_counter[i] == 1 else c
            f, Qs = bit_1_case(curve_id, f, Qs, Q_selects, n_pairs, yInv, xNegOverY, c_or_c_inv, Qis, Ris)
        else:
            raise NotImplementedError(f"Bit {loop_counter[i]} not implemented")
        i -= 1

    if m is not None and len(m) == 12:
        final_r_sparsity = None
    else:
        final_r_sparsity = [1] + [0] * 11

    frobenius_maps = {}
    for i in ([1, 2, 3] if curve_id == CurveID.BN254.value else [1]):
        _, frobenius_maps[i] = generate_frobenius_maps(curve_id=curve_id, extension_degree=12, frob_power=i)

    #print('curve_id=' + str(curve_id))
    #print('HashMap::from([')
    #for frob_power in ([1, 2, 3] if curve_id == CurveID.BN254.value else [1]):
    #    print('    (' + str(frob_power) + ', vec![')
    #    for i, list_op in enumerate(frobenius_maps[frob_power]):
    #        print('        vec![ // ' + str(i))
    #        for index, constant in list_op:
    #            print('            (' + str(index) + ', FieldElement::<F>::from_hex("' +  ('%x' % constant) + '").unwrap()),')
    #        print('        ],')
    #    print('    ]),')
    #print('])')

    if curve_id == CurveID.BN254.value:
        lines = bn254_finalize_step(curve_id, Qs, Q, yInv, xNegOverY)
        f = extf_mul(curve_id, Qis, Ris, [f, *lines], 12)
        # λ = 6 * x + 2 + q - q**2 + q**3
        c_inv_frob_1 = frobenius(curve_id, frobenius_maps, c_inv, 1, extension_degree=12)
        c_frob_2 = frobenius(curve_id, frobenius_maps, c, 2, extension_degree=12)
        c_inv_frob_3 = frobenius(curve_id, frobenius_maps, c_inv, 3, extension_degree=12)
        f = extf_mul(curve_id, Qis, Ris, [f, w, c_inv_frob_1, c_frob_2, c_inv_frob_3], 12, final_r_sparsity)
    elif curve_id == CurveID.BLS12_381.value:
        # λ = -x + q for BLS
        c_inv_frob_1 = frobenius(curve_id, frobenius_maps, c_inv, 1, extension_degree=12)
        f = extf_mul(curve_id, Qis, Ris, [f, w, c_inv_frob_1], 12, final_r_sparsity)
        if m is not None and len(m) == 12:
            f = conjugate_e12d(f)
    else:
        raise NotImplementedError(f"Curve {curve_id} not implemented")

    if m is not None and len(m) == 12:
        f = extf_mul(curve_id, Qis, Ris, [f, m], 12, [1] + [0] * 11)

    assert [fi.value for fi in f] == [1] + [0] * 11, f"f: {f}"

    return lambda_root, lambda_root_inverse, compact_scaling_factor, Qis, Ris

def get_root_and_scaling_factor(curve_id: int, P: list[tuple[PyFelt, PyFelt]], Q: list[tuple[tuple[PyFelt, PyFelt], tuple[PyFelt, PyFelt]]], m: list[PyFelt] = None) -> tuple[list[PyFelt], list[PyFelt], list[int]]:
    assert (len(P) == len(Q) >= 2), f"P and Q must have the same length and >= 2, got {len(P)} and {len(Q)}"

    f = E12.from_direct(miller_loop(curve_id, P, Q), curve_id)
    if m is not None:
        M = E12.from_direct(m, curve_id)
        f = f * M
    # h = (CURVES[curve_id].p ** 12 - 1) // CURVES[curve_id].n
    # assert f**h == E12.one(curve_id)
    lambda_root_e12, scaling_factor_e12 = get_final_exp_witness(curve_id, f)

    lambda_root: list[PyFelt] = lambda_root_e12.__inv__().to_direct() if curve_id == CurveID.BLS12_381.value else lambda_root_e12.to_direct() # Pass lambda_root inverse directly for BLS.
    scaling_factor: list[PyFelt] = scaling_factor_e12.to_direct()

    # replace random by [2, 3, 4, 5, 6, 7]
    e6_subfield = E12([E6([2, 3, 4, 5, 6, 7], curve_id), E6.zero(curve_id)], curve_id)
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
    v = public_pair.to_pyfelt_list()
    P = [(v[0], v[1])]
    Q = [((v[2], v[3]), (v[4], v[5]))]
    return miller_loop(curve_id.value, P, Q)

def multi_pairing_check_result(curve_id: CurveID, pairs: list[G1G2Pair], n_fixed_g2: int, public_pair: G1G2Pair | None, m: list[PyFelt] | None):
    assert len(pairs) >= 2, "n_pairs must be >= 2 for pairing checks"
    P = []
    Q = []
    for pair in pairs:
        v = pair.to_pyfelt_list()
        P.append((v[0], v[1]))
        Q.append(((v[2], v[3]), (v[4], v[5])))
    lambda_root, lambda_root_inverse, scaling_factor, Qis, Ris = multi_pairing_check(curve_id.value, P, Q, n_fixed_g2, m)
    # Skip first Ri for BN254 as it known to be one (lambda_root*lambda_root_inverse) result
    Ris = (Ris if curve_id == CurveID.BLS12_381 else Ris[1:])  
    if public_pair is not None:
        # Skip last Ri as it is known to be 1 and we use FP12Mul_AssertOne circuit
        Ris = Ris[:-1]
    return lambda_root, lambda_root_inverse, scaling_factor, Qis, Ris

def hash_hints_and_get_base_random_rlc_coeff(curve_id: CurveID, pairs: list[G1G2Pair], n_fixed_g2: int, lambda_root: list[PyFelt], lambda_root_inverse: list[PyFelt], scaling_factor: list[PyFelt], Ris: list[list[PyFelt]]):
    field = get_base_field(curve_id)
    init_hash = f"MPCHECK_{curve_id.name}_{len(pairs)}P_{n_fixed_g2}F"
    transcript = CairoPoseidonTranscript(init_hash=int.from_bytes(init_hash.encode(), byteorder="big"))
    for pair in pairs:
        transcript.hash_limbs_multi(pair.to_pyfelt_list())
    if curve_id == CurveID.BN254:
        transcript.hash_limbs_multi(lambda_root)
    transcript.hash_limbs_multi(lambda_root_inverse)
    transcript.hash_limbs_multi(scaling_factor)
    for Ri in Ris:
        assert len(Ri) == 12
        transcript.hash_limbs_multi(Ri)
    return field(transcript.s1)

def compute_big_Q_coeffs(curve_id: CurveID, n_pairs, Qis, Ris, c0: PyFelt):
    field = get_base_field(curve_id)
    n_relations_with_ci = len(Ris) + (1 if curve_id == CurveID.BN254 else 0)
    ci, big_Q = c0, Polynomial.zero(field.p)
    for i in range(n_relations_with_ci):
        big_Q += Qis[i] * ci
        ci *= ci
    big_Q_expected_len = get_max_Q_degree(curve_id.value, n_pairs) + 1
    big_Q_coeffs = big_Q.get_coeffs()
    big_Q_coeffs.extend([field.zero()] * (big_Q_expected_len - len(big_Q_coeffs)))
    return big_Q_coeffs

"""
Return MPCheckHint struct and small_Q struct if extra_miller_loop_result is True
"""
def build_mpcheck_hint(curve_id: CurveID, pairs: list[G1G2Pair], n_fixed_g2: int, public_pair: G1G2Pair | None) -> tuple[Cairo1SerializableStruct, Cairo1SerializableStruct | None]:
    # Validate input
    n_pairs = len(pairs)
    assert n_pairs >= 2
    assert 0 <= n_fixed_g2 <= n_pairs

    m = extra_miller_loop_result(curve_id, public_pair) if public_pair is not None else None
    lambda_root, lambda_root_inverse, scaling_factor, Qis, Ris = multi_pairing_check_result(curve_id, pairs, n_fixed_g2, public_pair, m)
    c0 = hash_hints_and_get_base_random_rlc_coeff(curve_id, pairs, n_fixed_g2, lambda_root, lambda_root_inverse, scaling_factor, Ris)
    big_Q_coeffs = compute_big_Q_coeffs(curve_id, n_pairs, Qis, Ris, c0)

    small_Q = None
    if public_pair is not None:
        field = get_base_field(curve_id)
        small_Q = Qis[-1].get_coeffs()
        small_Q = small_Q + [field.zero()] * (11 - len(small_Q))

    return lambda_root, lambda_root_inverse, scaling_factor, Ris, big_Q_coeffs, small_Q

def mpc_serialize_to_calldata(curve_id: CurveID, pairs: list[G1G2Pair], n_fixed_g2: int, public_pair: G1G2Pair | None) -> list[int]:
    lambda_root, lambda_root_inverse, scaling_factor, Ris, big_Q_coeffs, small_Q = build_mpcheck_hint(curve_id, pairs, n_fixed_g2, public_pair)

    if curve_id == CurveID.BN254:
        hint_struct_list_init = [E12D(lambda_root)]
    else:
        hint_struct_list_init = []
    hint_struct_list_init.append(E12D(lambda_root_inverse))
    hint_struct_list_init.append(MillerLoopResultScalingFactor(scaling_factor))
    hint_struct_list_init.append(StructSpan([E12D(Ri) for Ri in Ris]))
    hint_struct_list_init.append(u384Array(big_Q_coeffs))
    mpcheck_hint_struct = Struct(hint_struct_list_init)

    call_data: list[int] = []
    call_data.extend(mpcheck_hint_struct.serialize_to_calldata())
    if small_Q is not None:
        small_Q_struct = E12DMulQuotient(small_Q)
        call_data.extend(small_Q_struct.serialize_to_calldata())
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
