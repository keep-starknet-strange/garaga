import re
import subprocess
from src.definitions import G1Point, G2Point, CurveID, CURVES


exec_path = {
    CurveID.BN254: "tools/gnark/main",
    CurveID.BLS12_381: "tools/gnark/bls12_381/cairo_test/main",
}


class GnarkCLI:
    def __init__(self, curve_id: CurveID):
        self.curve = CURVES[curve_id.value]
        self.curve_id = curve_id
        self.executable_path = exec_path[curve_id]

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

    def pair(self, P: list[G1Point], Q: list[G2Point]):
        assert len(P) == len(Q)
        args = ["n_pair", "pair", str(len(P))]
        for p, q in zip(P, Q):
            args += [
                str(p.x),
                str(p.y),
                str(q.x[0]),
                str(q.x[1]),
                str(q.y[0]),
                str(q.y[1]),
            ]
        output = self.run_command(args)
        res = self.parse_fp_elements(output)
        assert len(res) == 12, f"Got {output}"
        return res

    def miller(self, P: list[G1Point], Q: list[G2Point]):
        assert len(P) == len(Q)
        args = ["n_pair", "miller_loop", str(len(P))]
        for p, q in zip(P, Q):
            args += [
                str(p.x),
                str(p.y),
                str(q.x[0]),
                str(q.x[1]),
                str(q.y[0]),
                str(q.y[1]),
            ]
        output = self.run_command(args)
        res = self.parse_fp_elements(output)
        assert len(res) == 12
        return res

    def nG1nG2_operation(self, n1: int, n2: int) -> tuple[G1Point, G2Point]:
        args = ["nG1nG2", str(n1), str(n2)]
        output = self.run_command(args)
        fp_elements = self.parse_fp_elements(output)
        assert len(fp_elements) == 6
        # print(fp_elements)
        return G1Point(*fp_elements[:2], self.curve_id), G2Point(
            tuple(fp_elements[2:4]), tuple(fp_elements[4:6]), self.curve_id
        )


if __name__ == "__main__":
    for curve_id in [CurveID.BN254, CurveID.BLS12_381]:
        print("\n\n", curve_id)
        cli = GnarkCLI(curve_id)
        curve = CURVES[curve_id.value]

        a, b = cli.nG1nG2_operation(1, 1)

        e = cli.pair([a], [b])
        m = cli.miller([a], [b])
        print(f"m={m}")
        print(f"e={e}")
