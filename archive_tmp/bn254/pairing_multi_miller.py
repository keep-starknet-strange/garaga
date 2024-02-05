from algebra import Polynomial
from algebra import FieldElement, BaseField
from starkware.cairo.common.poseidon_hash import poseidon_hash
from hints.io import bigint_split, split_128
from hints.tower_backup import E2
from definitions import IRREDUCIBLE_POLY_12
from dataclasses import dataclass
from tools.extension_trick import w_to_gnark

import numpy as np

p = 0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47
STARK = 3618502788666131213697322783095070105623107215331596699973092056135872020481
field = BaseField(p)
N_LIMBS = 3
BASE = 2**86


def NAF(x):
    if x == 0:
        return []
    z = 0 if x % 2 == 0 else 2 - (x % 4)
    return NAF((x - z) // 2) + [z]


BITS = NAF(29793968203157093288)[::-1]


def mul_by_non_residue_k_pow_j(x: E2, k: int, j: int):
    if (k, j) == (1, 2):
        tmp = E2(
            21575463638280843010398324269430826099269044274347216827212613867836435027261,
            10307601595873709700152284273816112264069230130616436755625194854815875713954,
            x.p,
        )
        return x * tmp
    if (k, j) == (1, 3):
        tmp = E2(
            2821565182194536844548159561693502659359617185244120367078079554186484126554,
            3505843767911556378687030309984248845540243509899259641013678093033130930403,
            x.p,
        )
        return x * tmp
    if (k, j) == (2, 2):
        tmp = 21888242871839275220042445260109153167277707414472061641714758635765020556616
        return E2(x.a0 * tmp % x.p, x.a1 * tmp % x.p, x.p)
    if (k, j) == (2, 3):
        tmp = 21888242871839275222246405745257275088696311157297823662689037894645226208582
        return E2(x.a0 * tmp % x.p, x.a1 * tmp % x.p, x.p)
    else:
        raise NotImplementedError


@dataclass
class BigInt3:
    d0: int
    d1: int
    d2: int


@dataclass
class E12_034:
    w1: int
    w3: int
    w7: int
    w9: int

    def to_E12(self):
        return E12(
            1,
            self.w1,
            0,
            self.w3,
            0,
            0,
            0,
            self.w7,
            0,
            self.w9,
            0,
            0,
        )

    def to_poly(self):
        return Polynomial(
            [
                field.one(),
                FieldElement(self.w1, field),
                field.zero(),
                FieldElement(self.w3, field),
                field.zero(),
                field.zero(),
                field.zero(),
                FieldElement(self.w7, field),
                field.zero(),
                FieldElement(self.w9, field),
                field.zero(),
                field.zero(),
            ]
        )

    def to_bigint3(self):
        pow_idw = ["1", "3", "7", "9"]
        coeffs = [getattr(self, f"w{i}") for i in pow_idw]
        return [bigint_split(x, N_LIMBS, BASE) for x in coeffs]

    def hash(self, continuable_hash: int):
        x3 = self.to_bigint3()
        h = poseidon_hash(x3[0][0] * x3[0][1], continuable_hash)
        h = poseidon_hash(x3[0][2] * x3[1][0], h)
        h = poseidon_hash(x3[1][1] * x3[1][2], h)
        h = poseidon_hash(x3[2][0] * x3[2][1], h)
        h = poseidon_hash(x3[2][2] * x3[3][0], h)
        h = poseidon_hash(x3[3][1] * x3[3][2], h)
        return h


@dataclass
class E12_01234:
    w0: int
    w1: int
    w2: int
    w3: int
    w4: int
    w6: int
    w7: int
    w8: int
    w9: int
    w10: int
    w11: int

    def to_E12(self):
        return E12(
            self.w0,
            self.w1,
            self.w2,
            self.w3,
            self.w4,
            0,
            self.w6,
            self.w7,
            self.w8,
            self.w9,
            self.w10,
            self.w11,
        )

    def to_poly(self):
        return Polynomial(
            [
                FieldElement(self.w0, field),
                FieldElement(self.w1, field),
                FieldElement(self.w2, field),
                FieldElement(self.w3, field),
                FieldElement(self.w4, field),
                field.zero(),
                FieldElement(self.w6, field),
                FieldElement(self.w7, field),
                FieldElement(self.w8, field),
                FieldElement(self.w9, field),
                FieldElement(self.w10, field),
                FieldElement(self.w11, field),
            ]
        )

    def to_bigint3(self):
        pow_idx = ["0", "1", "2", "3", "4", "6", "7", "8", "9", "10", "11"]
        coeffs = [getattr(self, f"w{i}") for i in pow_idx]
        return [bigint_split(x, N_LIMBS, BASE) for x in coeffs]

    def hash(self, continuable_hash: int, cut=False):
        x3 = self.to_bigint3()
        if cut == False:
            h = poseidon_hash(x3[0][0] * x3[0][1], continuable_hash)
            h = poseidon_hash(x3[0][2] * x3[1][0], h)
            h = poseidon_hash(x3[1][1] * x3[1][2], h)
            h = poseidon_hash(x3[2][0] * x3[2][1], h)
            h = poseidon_hash(x3[2][2] * x3[3][0], h)
            h = poseidon_hash(x3[3][1] * x3[3][2], h)
            h = poseidon_hash(x3[4][0] * x3[4][1], h)
        else:
            h = continuable_hash
        h = poseidon_hash(x3[4][2] * x3[5][0], h)
        h = poseidon_hash(x3[5][1] * x3[5][2], h)
        h = poseidon_hash(x3[6][0] * x3[6][1], h)
        h = poseidon_hash(x3[6][2] * x3[7][0], h)
        h = poseidon_hash(x3[7][1] * x3[7][2], h)
        h = poseidon_hash(x3[8][0] * x3[8][1], h)
        h = poseidon_hash(x3[8][2] * x3[9][0], h)
        h = poseidon_hash(x3[9][1] * x3[9][2], h)
        h = poseidon_hash(x3[10][0] * x3[10][1], h)
        h = poseidon_hash(x3[10][2], h)
        return h


@dataclass
class E12:
    w0: int
    w1: int
    w2: int
    w3: int
    w4: int
    w5: int
    w6: int
    w7: int
    w8: int
    w9: int
    w10: int
    w11: int

    def __str__(self) -> str:
        coeffs = [getattr(self, f"w{i}") for i in range(12)]
        coeffs_gnark = w_to_gnark(coeffs)
        str = ""
        for i in range(12):
            str += f"w{i} {np.base_repr(coeffs_gnark[i], 36)}\n"
        return str

    def to_gnark(self):
        coeffs = [getattr(self, f"w{i}") for i in range(12)]
        coeffs_gnark = w_to_gnark(coeffs)
        return coeffs_gnark

    def to_poly(self):
        return Polynomial(
            [
                FieldElement(self.w0, field),
                FieldElement(self.w1, field),
                FieldElement(self.w2, field),
                FieldElement(self.w3, field),
                FieldElement(self.w4, field),
                FieldElement(self.w5, field),
                FieldElement(self.w6, field),
                FieldElement(self.w7, field),
                FieldElement(self.w8, field),
                FieldElement(self.w9, field),
                FieldElement(self.w10, field),
                FieldElement(self.w11, field),
            ]
        )

    def to_bigint3(self):
        coeffs = [getattr(self, f"w{i}") for i in range(12)]

        return [bigint_split(x, N_LIMBS, BASE) for x in coeffs]

    def hash(self, continuable_hash: int, cut=False):
        x3 = self.to_bigint3()
        if cut == False:
            h = poseidon_hash(x3[0][0] * x3[0][1], continuable_hash)
            h = poseidon_hash(x3[0][2] * x3[1][0], h)
            h = poseidon_hash(x3[1][1] * x3[1][2], h)
            h = poseidon_hash(x3[2][0] * x3[2][1], h)
            h = poseidon_hash(x3[2][2] * x3[3][0], h)
            h = poseidon_hash(x3[3][1] * x3[3][2], h)
            h = poseidon_hash(x3[4][0] * x3[4][1], h)
            h = poseidon_hash(x3[4][2] * x3[5][0], h)
            h = poseidon_hash(x3[5][1] * x3[5][2], h)
            h = poseidon_hash(x3[6][0] * x3[6][1], h)
            h = poseidon_hash(x3[6][2] * x3[7][0], h)
        elif cut == "w5_d2":
            h = poseidon_hash(x3[6][0] * x3[6][1], continuable_hash)
            h = poseidon_hash(x3[6][2] * x3[7][0], h)
        elif cut == "w7_d0":
            h = continuable_hash
        h = poseidon_hash(x3[7][1] * x3[7][2], h)
        h = poseidon_hash(x3[8][0] * x3[8][1], h)
        h = poseidon_hash(x3[8][2] * x3[9][0], h)
        h = poseidon_hash(x3[9][1] * x3[9][2], h)
        h = poseidon_hash(x3[10][0] * x3[10][1], h)
        h = poseidon_hash(x3[10][2] * x3[11][0], h)
        h = poseidon_hash(x3[11][1] * x3[11][2], h)
        return h


@dataclass
class G2Point:
    x: E2
    y: E2

    def __str__(self) -> str:
        return f"X: {self.x}\nY: {self.y}"

    def __neg__(self):
        return G2Point(self.x, -self.y)

    @classmethod
    def compute_slope(cls, pt1, pt2) -> E2:
        return (pt1.y - pt2.y) / (pt1.x - pt2.x)

    @classmethod
    def line_compute(cls, pt1: "G2Point", pt2: "G2Point") -> E12_034:
        C = cls.compute_slope(pt1, pt2)
        l1r1 = C * pt1.x - pt1.y
        return E12_034(
            w1=C.a0 - 9 * C.a1, w3=l1r1.a0 - 9 * l1r1.a1, w7=C.a1, w9=l1r1.a1
        )

    def double_step(self) -> ("G2Point", E12_034):
        C = (3 * self.x * self.x) / (2 * self.y)
        nx = C * C - 2 * self.x
        E = C * self.x - self.y
        ny = E - C * nx
        line = E12_034(w1=C.a0 - 9 * C.a1, w3=E.a0 - 9 * E.a1, w7=C.a1, w9=E.a1)

        return G2Point(nx, ny), line

    def add_step(self, pt: "G2Point") -> ("G2Point", E12_034):
        C = self.compute_slope(self, pt)
        nx = C * C - self.x - pt.x
        E = C * self.x - self.y
        ny = E - C * nx
        line = E12_034(w1=C.a0 - 9 * C.a1, w3=E.a0 - 9 * E.a1, w7=C.a1, w9=E.a1)
        return G2Point(nx, ny), line

    def double_and_add_step(self, pt: "G2Point") -> ("G2Point", E12_034, E12_034):
        lambda1 = self.compute_slope(self, pt)
        x3 = lambda1 * lambda1 - self.x - pt.x
        lambda2 = -lambda1 - ((2 * self.y) / (x3 - self.x))
        x4 = lambda2 * lambda2 - self.x - x3
        y4 = lambda2 * (self.x - x4) - self.y

        l1r1 = lambda1 * self.x - self.y
        l2r1 = lambda2 * self.x - self.y

        l1034 = E12_034(
            lambda1.a0 - 9 * lambda1.a1, l1r1.a0 - 9 * l1r1.a1, lambda1.a1, l1r1.a1
        )
        l2034 = E12_034(
            lambda2.a0 - 9 * lambda2.a1, l2r1.a0 - 9 * l2r1.a1, lambda2.a1, l2r1.a1
        )
        return G2Point(x4, y4), l1034, l2034


@dataclass
class G1Point:
    x: int
    y: int


def multi_miller_loop(
    P_arr,
    Q_arr,
    n_points,
    continuable_hash=int.from_bytes(b"GaragaBN254MillerLoop", "big"),
):
    assert len(P_arr) == len(Q_arr) == n_points
    Q_acc = Q_arr.copy()
    Q_neg = [Q_arr[i].__neg__() for i in range(n_points)]
    yInv = [pow(P_arr[i].y, -1, p) for i in range(n_points)]
    xOverY = [-P_arr[i].x * yInv[i] % p for i in range(n_points)]

    # // Compute ∏ᵢ { fᵢ_{6x₀+2,Q}(P) }
    # // i = 64, separately to avoid an E12 Square
    # // (Square(res) = 1² = 1)

    # // k = 0, separately to avoid MulBy034 (res × ℓ)
    # // (assign line to res)
    # print("Q_acc[0]", Q_acc[0])

    new_Q0, l1 = Q_acc[0].double_step()
    Q_acc[0] = new_Q0
    # print("Q_acc[0]", Q_acc[0])
    res_init = E12_034(
        xOverY[0] * l1.w1 % p,
        yInv[0] * l1.w3 % p,
        xOverY[0] * l1.w7 % p,
        yInv[0] * l1.w9 % p,
    )

    if n_points >= 2:
        new_Q1, l1 = Q_acc[1].double_step()
        Q_acc[1] = new_Q1
        l1f = E12_034(
            xOverY[1] * l1.w1 % p,
            yInv[1] * l1.w3 % p,
            xOverY[1] * l1.w7 % p,
            yInv[1] * l1.w9 % p,
        )
        res_t01234, continuable_hash = mul034_034_trick(l1f, res_init, continuable_hash)
        res = res_t01234.to_E12()
    else:
        res = res_init.to_E12()
    # print("resInit", res.to_gnark())
    # print("hashInit", continuable_hash)
    if n_points >= 3:
        new_Q2, l1 = Q_acc[2].double_step()
        Q_acc[2] = new_Q2
        l1f = E12_034(
            xOverY[2] * l1.w1 % p,
            yInv[2] * l1.w3 % p,
            xOverY[2] * l1.w7 % p,
            yInv[2] * l1.w9 % p,
        )
        res, continuable_hash = mul034_trick(res, l1f, continuable_hash)
        # n > 3
        for k in range(n_points - 1, 2, -1):
            new_Q, l1 = Q_acc[k].double_step()
            Q_acc[k] = new_Q
            l1f = E12_034(
                xOverY[k] * l1.w1 % p,
                yInv[k] * l1.w3 % p,
                xOverY[k] * l1.w7 % p,
                yInv[k] * l1.w9 % p,
            )
            res, continuable_hash = mul034_trick(res, l1f, continuable_hash)
    # i63
    res, continuable_hash = square_trick(res, continuable_hash)
    # print("HASH63", continuable_hash)
    for k in range(0, n_points):
        l2 = G2Point.line_compute(Q_acc[k], Q_neg[k])
        l2f = E12_034(
            xOverY[k] * l2.w1 % p,
            yInv[k] * l2.w3 % p,
            xOverY[k] * l2.w7 % p,
            yInv[k] * l2.w9 % p,
        )
        (new_Q, l1) = Q_acc[k].add_step(Q_arr[k])
        Q_acc[k] = new_Q
        l1f = E12_034(
            xOverY[k] * l1.w1 % p,
            yInv[k] * l1.w3 % p,
            xOverY[k] * l1.w7 % p,
            yInv[k] * l1.w9 % p,
        )
        prod_lines, continuable_hash = mul034_034_trick(l1f, l2f, continuable_hash)
        # print("HASH034034_63", continuable_hash)
        res, continuable_hash = mul01234_trick(res, prod_lines, continuable_hash)
        # print("HASH01234_63", continuable_hash)
    lines = n_points * [None]
    # print("resBefMulti", res.to_gnark())
    # print("hashBefMulti", continuable_hash)

    for i in range(62, -1, -1):
        res, continuable_hash = square_trick(res, continuable_hash)
        bit = BITS[i]
        if bit == 0:
            for k in range(0, n_points):
                new_Q, l1 = Q_acc[k].double_step()
                Q_acc[k] = new_Q
                l1f = E12_034(
                    xOverY[k] * l1.w1 % p,
                    yInv[k] * l1.w3 % p,
                    xOverY[k] * l1.w7 % p,
                    yInv[k] * l1.w9 % p,
                )
                lines[k] = l1f
            if n_points % 2 != 0:
                res, continuable_hash = mul034_trick(
                    res, lines[n_points - 1], continuable_hash
                )
            for k in range(1, n_points, 2):
                prod_lines, continuable_hash = mul034_034_trick(
                    lines[k], lines[k - 1], continuable_hash
                )
                res, continuable_hash = mul01234_trick(
                    res, prod_lines, continuable_hash
                )
        elif bit == 1:
            for k in range(0, n_points):
                new_Q, l1, l2 = Q_acc[k].double_and_add_step(Q_arr[k])
                Q_acc[k] = new_Q
                l1f = E12_034(
                    xOverY[k] * l1.w1 % p,
                    yInv[k] * l1.w3 % p,
                    xOverY[k] * l1.w7 % p,
                    yInv[k] * l1.w9 % p,
                )
                l2f = E12_034(
                    xOverY[k] * l2.w1 % p,
                    yInv[k] * l2.w3 % p,
                    xOverY[k] * l2.w7 % p,
                    yInv[k] * l2.w9 % p,
                )
                prod_lines, continuable_hash = mul034_034_trick(
                    l1f, l2f, continuable_hash
                )
                res, continuable_hash = mul01234_trick(
                    res, prod_lines, continuable_hash
                )
        elif bit == -1:
            for k in range(0, n_points):
                new_Q, l1, l2 = Q_acc[k].double_and_add_step(Q_neg[k])
                Q_acc[k] = new_Q
                l1f = E12_034(
                    xOverY[k] * l1.w1 % p,
                    yInv[k] * l1.w3 % p,
                    xOverY[k] * l1.w7 % p,
                    yInv[k] * l1.w9 % p,
                )
                l2f = E12_034(
                    xOverY[k] * l2.w1 % p,
                    yInv[k] * l2.w3 % p,
                    xOverY[k] * l2.w7 % p,
                    yInv[k] * l2.w9 % p,
                )
                prod_lines, continuable_hash = mul034_034_trick(
                    l1f, l2f, continuable_hash
                )
                res, continuable_hash = mul01234_trick(
                    res, prod_lines, continuable_hash
                )
    # print("resBefFinalLoop", res.to_gnark())
    for k in range(0, n_points):
        q1x = Q_arr[k].x.conjugate()
        q1y = Q_arr[k].y.conjugate()
        q1x = mul_by_non_residue_k_pow_j(q1x, 1, 2)
        q1y = mul_by_non_residue_k_pow_j(q1y, 1, 3)

        q2x = mul_by_non_residue_k_pow_j(Q_arr[k].x, 2, 2)
        q2y = mul_by_non_residue_k_pow_j(Q_arr[k].y, 2, 3)
        q2y = -q2y

        Q1 = G2Point(q1x, q1y)
        # print("Q1\n", Q1)
        Q2 = G2Point(q2x, q2y)
        # print("Q2\n", Q2)

        Q_acc[k], l1 = Q_acc[k].add_step(Q1)
        l1f = E12_034(
            xOverY[k] * l1.w1 % p,
            yInv[k] * l1.w3 % p,
            xOverY[k] * l1.w7 % p,
            yInv[k] * l1.w9 % p,
        )

        l2 = G2Point.line_compute(Q_acc[k], G2Point(q2x, q2y))
        l2f = E12_034(
            xOverY[k] * l2.w1 % p,
            yInv[k] * l2.w3 % p,
            xOverY[k] * l2.w7 % p,
            yInv[k] * l2.w9 % p,
        )

        prod_lines, continuable_hash = mul034_034_trick(l1f, l2f, continuable_hash)
        res, continuable_hash = mul01234_trick(res, prod_lines, continuable_hash)

    return res, continuable_hash


def mul034_034_trick(x: E12_034, y: E12_034, continuable_hash: int) -> (E12_01234, int):
    z_poly = x.to_poly() * y.to_poly()
    z_polyr = z_poly % IRREDUCIBLE_POLY_12
    z_polyq = z_poly // IRREDUCIBLE_POLY_12
    z_polyr_coeffs = z_polyr.get_coeffs()
    z_polyq_coeffs = z_polyq.get_coeffs()
    assert len(z_polyq_coeffs) <= 7
    z_polyr_coeffs = z_polyr_coeffs + [0] * (12 - len(z_polyr_coeffs))
    r_w5 = z_polyr_coeffs.pop(5)
    assert r_w5 == 0, f"Not a 01234, w5={r_w5}"
    z_polyq_coeffs = z_polyq_coeffs + [0] * (7 - len(z_polyq_coeffs))

    q2 = [split_128(x) for x in z_polyq_coeffs]
    R = E12_01234(*z_polyr_coeffs)
    r3 = R.to_bigint3()

    h = x.hash(continuable_hash=continuable_hash)
    h = y.hash(continuable_hash=h)
    h = poseidon_hash(q2[0][0] * r3[0][0], h)
    h = poseidon_hash(q2[0][1] * r3[0][1], h)
    h = poseidon_hash(q2[1][0] * r3[0][2], h)
    h = poseidon_hash(q2[1][1] * r3[1][0], h)
    h = poseidon_hash(q2[2][0] * r3[1][1], h)
    h = poseidon_hash(q2[2][1] * r3[1][2], h)
    h = poseidon_hash(q2[3][0] * r3[2][0], h)
    h = poseidon_hash(q2[3][1] * r3[2][1], h)
    h = poseidon_hash(q2[4][0] * r3[2][2], h)
    h = poseidon_hash(q2[4][1] * r3[3][0], h)
    h = poseidon_hash(q2[5][0] * r3[3][1], h)
    h = poseidon_hash(q2[5][1] * r3[3][2], h)
    h = poseidon_hash(q2[6][0] * r3[4][0], h)
    h = poseidon_hash(q2[6][1] * r3[4][1], h)
    h = R.hash(continuable_hash=h, cut=True)

    return R, h


def mul034_trick(x: E12, y: E12_034, continuable_hash: int) -> (E12, int):
    z_poly = x.to_poly() * y.to_poly()
    z_polyr = z_poly % IRREDUCIBLE_POLY_12
    z_polyq = z_poly // IRREDUCIBLE_POLY_12
    z_polyr_coeffs = z_polyr.get_coeffs()
    z_polyq_coeffs = z_polyq.get_coeffs()
    assert len(z_polyq_coeffs) <= 9
    z_polyr_coeffs = z_polyr_coeffs + [0] * (12 - len(z_polyr_coeffs))
    z_polyq_coeffs = z_polyq_coeffs + [0] * (9 - len(z_polyq_coeffs))
    q2 = [split_128(x) for x in z_polyq_coeffs]
    R = E12(*z_polyr_coeffs)
    r3 = R.to_bigint3()
    h = x.hash(continuable_hash=continuable_hash)
    h = y.hash(continuable_hash=h)
    h = poseidon_hash(q2[0][0] * r3[0][0], h)
    h = poseidon_hash(q2[0][1] * r3[0][1], h)
    h = poseidon_hash(q2[1][0] * r3[0][2], h)
    h = poseidon_hash(q2[1][1] * r3[1][0], h)
    h = poseidon_hash(q2[2][0] * r3[1][1], h)
    h = poseidon_hash(q2[2][1] * r3[1][2], h)
    h = poseidon_hash(q2[3][0] * r3[2][0], h)
    h = poseidon_hash(q2[3][1] * r3[2][1], h)
    h = poseidon_hash(q2[4][0] * r3[2][2], h)
    h = poseidon_hash(q2[4][1] * r3[3][0], h)
    h = poseidon_hash(q2[5][0] * r3[3][1], h)
    h = poseidon_hash(q2[5][1] * r3[3][2], h)
    h = poseidon_hash(q2[6][0] * r3[4][0], h)
    h = poseidon_hash(q2[6][1] * r3[4][1], h)
    h = poseidon_hash(q2[7][0] * r3[4][2], h)
    h = poseidon_hash(q2[7][1] * r3[5][0], h)
    h = poseidon_hash(q2[8][0] * r3[5][1], h)
    h = poseidon_hash(q2[8][1] * r3[5][2], h)

    h = R.hash(continuable_hash=h, cut="w5_d2")

    return R, h


def square_trick(x: E12, continuable_hash: int) -> (E12, int):
    x_poly = x.to_poly()
    z_poly = x_poly * x_poly
    z_polyr = z_poly % IRREDUCIBLE_POLY_12
    z_polyq = z_poly // IRREDUCIBLE_POLY_12
    z_polyr_coeffs = z_polyr.get_coeffs()
    z_polyq_coeffs = z_polyq.get_coeffs()
    assert len(z_polyq_coeffs) <= 11
    z_polyr_coeffs = z_polyr_coeffs + [0] * (12 - len(z_polyr_coeffs))
    z_polyq_coeffs = z_polyq_coeffs + [0] * (11 - len(z_polyq_coeffs))
    q2 = [split_128(x) for x in z_polyq_coeffs]
    R = E12(*z_polyr_coeffs)
    r3 = R.to_bigint3()
    h = x.hash(continuable_hash=continuable_hash)

    h = poseidon_hash(q2[0][0] * r3[0][0], h)
    h = poseidon_hash(q2[0][1] * r3[0][1], h)
    h = poseidon_hash(q2[1][0] * r3[0][2], h)
    h = poseidon_hash(q2[1][1] * r3[1][0], h)
    h = poseidon_hash(q2[2][0] * r3[1][1], h)
    h = poseidon_hash(q2[2][1] * r3[1][2], h)
    h = poseidon_hash(q2[3][0] * r3[2][0], h)
    h = poseidon_hash(q2[3][1] * r3[2][1], h)
    h = poseidon_hash(q2[4][0] * r3[2][2], h)
    h = poseidon_hash(q2[4][1] * r3[3][0], h)
    h = poseidon_hash(q2[5][0] * r3[3][1], h)
    h = poseidon_hash(q2[5][1] * r3[3][2], h)
    h = poseidon_hash(q2[6][0] * r3[4][0], h)
    h = poseidon_hash(q2[6][1] * r3[4][1], h)
    h = poseidon_hash(q2[7][0] * r3[4][2], h)
    h = poseidon_hash(q2[7][1] * r3[5][0], h)
    h = poseidon_hash(q2[8][0] * r3[5][1], h)
    h = poseidon_hash(q2[8][1] * r3[5][2], h)
    h = poseidon_hash(q2[9][0] * r3[6][0], h)
    h = poseidon_hash(q2[9][1] * r3[6][1], h)
    h = poseidon_hash(q2[10][0] * r3[6][2], h)
    h = poseidon_hash(q2[10][1] * r3[7][0], h)

    h = R.hash(continuable_hash=h, cut="w7_d0")

    return R, h


def mul01234_trick(x: E12, y: E12_01234, continuable_hash: int) -> (E12, int):
    z_poly = x.to_poly() * y.to_poly()
    z_polyr = z_poly % IRREDUCIBLE_POLY_12
    z_polyq = z_poly // IRREDUCIBLE_POLY_12
    z_polyr_coeffs = z_polyr.get_coeffs()
    z_polyq_coeffs = z_polyq.get_coeffs()
    assert len(z_polyq_coeffs) <= 11
    z_polyr_coeffs = z_polyr_coeffs + [0] * (12 - len(z_polyr_coeffs))
    z_polyq_coeffs = z_polyq_coeffs + [0] * (11 - len(z_polyq_coeffs))
    q2 = [split_128(x) for x in z_polyq_coeffs]
    R = E12(*z_polyr_coeffs)
    r3 = R.to_bigint3()
    h = x.hash(continuable_hash=continuable_hash)
    h = y.hash(continuable_hash=h)
    h = poseidon_hash(q2[0][0] * r3[0][0], h)
    h = poseidon_hash(q2[0][1] * r3[0][1], h)
    h = poseidon_hash(q2[1][0] * r3[0][2], h)
    h = poseidon_hash(q2[1][1] * r3[1][0], h)
    h = poseidon_hash(q2[2][0] * r3[1][1], h)
    h = poseidon_hash(q2[2][1] * r3[1][2], h)
    h = poseidon_hash(q2[3][0] * r3[2][0], h)
    h = poseidon_hash(q2[3][1] * r3[2][1], h)
    h = poseidon_hash(q2[4][0] * r3[2][2], h)
    h = poseidon_hash(q2[4][1] * r3[3][0], h)
    h = poseidon_hash(q2[5][0] * r3[3][1], h)
    h = poseidon_hash(q2[5][1] * r3[3][2], h)
    h = poseidon_hash(q2[6][0] * r3[4][0], h)
    h = poseidon_hash(q2[6][1] * r3[4][1], h)
    h = poseidon_hash(q2[7][0] * r3[4][2], h)
    h = poseidon_hash(q2[7][1] * r3[5][0], h)
    h = poseidon_hash(q2[8][0] * r3[5][1], h)
    h = poseidon_hash(q2[8][1] * r3[5][2], h)
    h = poseidon_hash(q2[9][0] * r3[6][0], h)
    h = poseidon_hash(q2[9][1] * r3[6][1], h)
    h = poseidon_hash(q2[10][0] * r3[6][2], h)
    h = poseidon_hash(q2[10][1] * r3[7][0], h)
    h = R.hash(continuable_hash=h, cut="w7_d0")

    return R, h


if __name__ == "__main__":
    G1 = G1Point(1, 2)
    G2 = G2Point(
        E2(
            10857046999023057135944570762232829481370756359578518086990519993285655852781,
            11559732032986387107991004021392285783925812861821192530917403151452391805634,
            p,
        ),
        E2(
            8495653923123431417604973247489272438418190587263600148770280649306958101930,
            4082367875863433681332203403145435568316851327593401208105741076214120093531,
            p,
        ),
    )

    # m, h = multi_miller_loop([G1], [G2], 1)

    # print(m)
    # print(h)

    P = [
        G1Point(
            x=6424909707529041010431833767196069900905951186152453452535233785859310247091,
            y=6731815178901292517144522853524599129026091167900349143473443684504480249601,
        ),
        G1Point(
            x=10154908101955836410822568671359241381386977712614837423695806888806827087120,
            y=6694119430739204200412415739739878806463649419827004538677705571548899835345,
        ),
        G1Point(
            x=11664089827190113040588903049366218671264446383108882453852976389666897952784,
            y=11964654005374721149828827734828350582389212487311147825692987599394401865041,
        ),
    ]
    Q = [
        G2Point(
            x=E2(
                a0=9377668754004040279698406674069547206576290350544684455848413744271894321832,
                a1=11702600617119966915217386854353771222477427862839239072991366294351362953119,
                p=p,
            ),
            y=E2(
                a0=2339250257289832665920974862775225721388286867501651664202401324220401621360,
                a1=3628891305020420995628487021870577687557167953941662416598489001684202886401,
                p=p,
            ),
        ),
        G2Point(
            x=E2(
                a0=10857046999023057135944570762232829481370756359578518086990519993285655852781,
                a1=11559732032986387107991004021392285783925812861821192530917403151452391805634,
                p=p,
            ),
            y=E2(
                a0=8495653923123431417604973247489272438418190587263600148770280649306958101930,
                a1=4082367875863433681332203403145435568316851327593401208105741076214120093531,
                p=p,
            ),
        ),
        G2Point(
            x=E2(
                a0=7912208710313447447762395792098481825752520616755888860068004689933335666613,
                a1=12599857379517512478445603412764121041984228075771497593287716170335433683702,
                p=p,
            ),
            y=E2(
                a0=21679208693936337484429571887537508926366191105267550375038502782696042114705,
                a1=11502426145685875357967720478366491326865907869902181704031346886834786027007,
                p=p,
            ),
        ),
    ]

    m, h = multi_miller_loop(P, Q, 3)
    print(m)
    print(h)
