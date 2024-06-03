import re
import subprocess
from src.definitions import G1Point, G2Point, CurveID, CURVES


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

    def pair(self, input: list[int], n_pairs: int):
        assert (
            len(input) == 6 * n_pairs
        ), f"Expected {6 * n_pairs} input points, got {len(input)}"
        args = ["n_pair", "pair", str(n_pairs)]
        for x in input:
            args.append(str(x))
        output = self.run_command(args)
        res = self.parse_fp_elements(output)
        assert len(res) == 12, f"Got {output}"
        return res

    def miller(self, input: list[int], n_pairs: int):
        assert len(input) == 6 * n_pairs
        args = ["n_pair", "miller_loop", str(n_pairs)]
        for x in input:
            args.append(str(x))
        output = self.run_command(args)
        res = self.parse_fp_elements(output)
        assert len(res) == 12, f"Got {output}"
        return res

    def g1_add(self, p1: tuple[int, int], p2: tuple[int, int]):
        args = ["g1", "add", str(p1[0]), str(p1[1]), str(p2[0]), str(p2[1])]
        output = self.run_command(args)
        res = self.parse_fp_elements(output)
        assert len(res) == 2, f"Got {output}"
        return (res[0], res[1])

    def g1_scalarmul(self, p1: tuple[int, int], n: int):
        args = ["ng1", str(p1[0]), str(p1[1]), str(n)]
        output = self.run_command(args)
        res = self.parse_fp_elements(output)
        assert len(res) == 2, f"Got {output}"
        return (res[0], res[1])

    def nG1nG2_operation(
        self, n1: int, n2: int, raw: bool = False
    ) -> tuple[G1Point, G2Point] | list[int]:
        args = ["nG1nG2", str(n1), str(n2)]
        output = self.run_command(args)
        fp_elements = self.parse_fp_elements(output)
        assert len(fp_elements) == 6
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
