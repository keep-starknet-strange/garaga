import re
import subprocess
from fastecdsa import curvemath
from hydra.definitions import G1Point, G2Point, CurveID, CURVES
from hydra.hints.tower_backup import E12
import garaga_rs

class GnarkCLI:
    def __init__(self, curve_id: CurveID):
        exec_path = {
            CurveID.BN254: "tools/gnark/main",
            CurveID.BLS12_381: "tools/gnark/bls12_381/cairo_test/main",
        }
        self.curve = CURVES[curve_id.value]
        self.curve_id = CurveID(curve_id.value)
        self.executable_path = exec_path[self.curve_id]

    def run_command(self, args):
        process = subprocess.Popen(
            [self.executable_path] + args,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
        stdout, stderr = process.communicate()
        if process.returncode != 0:
            raise Exception(f"Error executing gnark-cli: {stderr.decode('utf-8')}")
        return stdout.decode("utf-8")

    def parse_fp_elements(self, input_string: str):
        pattern = re.compile(r"\[([^\[\]]+)\]")
        substrings = pattern.findall(input_string)
        sublists = [substring.split(" ") for substring in substrings]
        sublists = [[int(x) for x in sublist] for sublist in sublists]
        fp_elements = []
        for sublist in sublists:
            element_value = sum(x * (2 ** (64 * i)) for i, x in enumerate(sublist))
            fp_elements.append(element_value)
        return fp_elements

    def pair(self, input: list[int], n_pairs: int, raw: bool = True):
        assert (
            len(input) == 6 * n_pairs
        ), f"Expected {6 * n_pairs} input points, got {len(input)}"
        args = ["n_pair", "pair", str(n_pairs)]
        for x in input:
            args.append(str(x))
        output = self.run_command(args)
        res = self.parse_fp_elements(output)
        assert len(res) == 12, f"Got {output}"
        if raw:
            return res
        return E12(res, self.curve_id.value)

    def miller(
        self, input: list[int], n_pairs: int, raw: bool = False
    ) -> list[int] | E12:
        assert len(input) == 6 * n_pairs
        args = ["n_pair", "miller_loop", str(n_pairs)]
        for x in input:
            args.append(str(x))
        output = self.run_command(args)
        res = self.parse_fp_elements(output)
        assert len(res) == 12, f"Got {output}"
        if raw:
            return res
        return E12(res, self.curve_id.value)

    def g1_add(self, p1: tuple[int, int], p2: tuple[int, int]):
        x, y = curvemath.add(
            str(p1[0]),
            str(p1[1]),
            str(p2[0]),
            str(p2[1]),
            str(CURVES[self.curve.id].p),
            str(CURVES[self.curve.id].a),
            str(CURVES[self.curve.id].b),
            str(CURVES[self.curve.id].n),
            str(CURVES[self.curve.id].Gx),
            str(CURVES[self.curve.id].Gy),
        )
        return (int(x), int(y))

    def g1_scalarmul(self, p1: tuple[int, int], n: int):
        x, y = curvemath.mul(
            str(p1[0]),
            str(p1[1]),
            str(n),
            str(CURVES[self.curve.id].p),
            str(CURVES[self.curve.id].a),
            str(CURVES[self.curve.id].b),
            str(CURVES[self.curve.id].n),
            str(CURVES[self.curve.id].Gx),
            str(CURVES[self.curve.id].Gy),
        )
        return (int(x), int(y))

    def g2_add(
        self,
        p1: tuple[tuple[int, int], tuple[int, int]],
        p2: tuple[tuple[int, int], tuple[int, int]],
    ):
        arg1 = (p1[0][0], p1[0][1], p1[1][0], p1[1][1])
        arg2 = (p2[0][0], p2[0][1], p2[1][0], p2[1][1])
        return garaga_rs.g2_add(self.curve.id, arg1, arg2)

    def g2_scalarmul(self, p1: tuple[tuple[int, int], tuple[int, int]], n: int):
        arg1 = (p1[0][0], p1[0][1], p1[1][0], p1[1][1])
        return garaga_rs.g2_scalar_mul(self.curve.id, arg1, n)

    def nG1nG2_operation(
        self, n1: int, n2: int, raw: bool = False
    ) -> tuple[G1Point, G2Point] | list[int]:
        g1 = (self.curve.Gx, self.curve.Gy)
        p1 = g1 if n1 == 1 else self.g1_scalarmul(g1, n1)
        g2 = (self.curve.G2x, self.curve.G2y)
        p2 = (g2[0][0], g2[0][1], g2[1][0], g2[1][1]) if n2 == 1 else self.g2_scalarmul(g2, n2)
        fp_elements = [p1[0], p1[1], p2[0], p2[1], p2[2], p2[3]]
        if raw:
            return fp_elements
        return G1Point(*fp_elements[:2], self.curve_id), G2Point(
            tuple(fp_elements[2:4]), tuple(fp_elements[4:6]), self.curve_id
        )


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
