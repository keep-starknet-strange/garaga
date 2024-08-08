import re
import subprocess
from fastecdsa import curvemath
from hydra.definitions import G1Point, G2Point, CurveID, CURVES
from hydra.hints.tower_backup import E12
import garaga_rs

class GnarkCLI:
    def __init__(self, curve_id: CurveID):
        self.curve = CURVES[curve_id.value]

    def pair(self, input: list[int], n_pairs: int, raw: bool = True) -> list[int] | E12:
        res = garaga_rs.multi_pairing(self.curve.id, input)
        if raw: return res
        return E12(res, self.curve.id)

    def miller(self, input: list[int], n_pairs: int, raw: bool = False) -> list[int] | E12:
        res = garaga_rs.multi_miller_loop(self.curve.id, input)
        if raw: return res
        return E12(res, self.curve.id)

    def g1_add(self, p1: tuple[int, int], p2: tuple[int, int]) -> tuple[int, int]:
        x, y = curvemath.add(
            str(p1[0]),
            str(p1[1]),
            str(p2[0]),
            str(p2[1]),
            str(self.curve.p),
            str(self.curve.a),
            str(self.curve.b),
            str(self.curve.n),
            str(self.curve.Gx),
            str(self.curve.Gy),
        )
        return (int(x), int(y))

    def g1_scalarmul(self, p1: tuple[int, int], n: int) -> tuple[int, int]:
        x, y = curvemath.mul(
            str(p1[0]),
            str(p1[1]),
            str(n),
            str(self.curve.p),
            str(self.curve.a),
            str(self.curve.b),
            str(self.curve.n),
            str(self.curve.Gx),
            str(self.curve.Gy),
        )
        return (int(x), int(y))

    def g2_add(self, p1: tuple[tuple[int, int], tuple[int, int]], p2: tuple[tuple[int, int], tuple[int, int]]) -> tuple[int, int, int, int]:
        arg1 = (p1[0][0], p1[0][1], p1[1][0], p1[1][1])
        arg2 = (p2[0][0], p2[0][1], p2[1][0], p2[1][1])
        return garaga_rs.g2_add(self.curve.id, arg1, arg2)

    def g2_scalarmul(self, p1: tuple[tuple[int, int], tuple[int, int]], n: int) -> tuple[int, int, int, int]:
        arg1 = (p1[0][0], p1[0][1], p1[1][0], p1[1][1])
        return garaga_rs.g2_scalar_mul(self.curve.id, arg1, n)

    def nG1nG2_operation(self, n1: int, n2: int, raw: bool = False) -> tuple[G1Point, G2Point] | list[int]:
        g1 = (self.curve.Gx, self.curve.Gy)
        g2 = (self.curve.G2x, self.curve.G2y)
        p1 = g1 if n1 == 1 else self.g1_scalarmul(g1, n1)
        p2 = (g2[0][0], g2[0][1], g2[1][0], g2[1][1]) if n2 == 1 else self.g2_scalarmul(g2, n2)
        res = [p1[0], p1[1], p2[0], p2[1], p2[2], p2[3]]
        if raw: return res
        return G1Point(*res[:2], self.curve.id), G2Point(tuple(res[2:4]), tuple(res[4:6]), self.curve.id)

if __name__ == "__main__":
    for curve_id in [CurveID.BN254, CurveID.BLS12_381]:
        print("\n\n", curve_id)
        cli = GnarkCLI(curve_id)
        curve = CURVES[curve_id.value]

        points = cli.nG1nG2_operation(1, 1, raw=True)
        print(points)
        e = cli.pair(points, 1)
        m = cli.miller(points, 1)
        print(f"m={m}")
        print(f"e={e}")
