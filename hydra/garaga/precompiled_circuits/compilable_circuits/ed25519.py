"""Fixed-field circuits for the Ed25519 divide-and-pair subgroup test."""

from garaga import ed25519 as ed
from garaga.modulo_circuit import ModuloCircuit, WriteOps
from garaga.modulo_circuit_structs import u384
from garaga.precompiled_circuits.compilable_circuits.base import BaseModuloCircuit


def pow_252_3(circuit, x):
    """Compute x^(2^252-3) with 251 squarings and 11 other multiplications."""

    def square_n(value, n):
        for _ in range(n):
            value = circuit.mul(value, value)
        return value

    x2 = circuit.mul(x, x)
    x9 = circuit.mul(square_n(x2, 2), x)
    x11 = circuit.mul(x9, x2)
    x31 = circuit.mul(circuit.mul(x11, x11), x9)
    x10 = circuit.mul(square_n(x31, 5), x31)
    x20 = circuit.mul(square_n(x10, 10), x10)
    x40 = circuit.mul(square_n(x20, 20), x20)
    x50 = circuit.mul(square_n(x40, 10), x10)
    x100 = circuit.mul(square_n(x50, 50), x50)
    x200 = circuit.mul(square_n(x100, 100), x100)
    x250 = circuit.mul(square_n(x200, 50), x50)
    return circuit.mul(square_n(x250, 2), x)


class Ed25519Circuit(BaseModuloCircuit):
    INPUTS = {
        "low_order": ["x", "y"],
        "from_weierstrass": ["x", "y"],
        "prepare": ["x", "y"],
        "sqrt": ["value"],
        "sqrt_or_twice": ["value"],
        "halve_up": ["u", "w", "e", "wp"],
        "halve_nqr": ["e", "wp", "root"],
        "finish": ["e", "wp", "w", "sign"],
    }

    def __init__(self, curve_id=4, operation="sqrt", auto_run=True, compilation_mode=1):
        if curve_id != 4:
            raise ValueError("Ed25519 circuits require curve 4")
        self.operation = operation
        super().__init__(
            name=operation,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self):
        values = {
            "x": ed.CURVE.Gx,
            "y": ed.CURVE.Gy,
            "u": 4,
            "w": 2,
            "e": 3,
            "wp": 4,
            "root": 5,
            "sign": 1,
            "value": 4,
        }
        return [self.field(values[name]) for name in self.INPUTS[self.operation]]

    def _run_circuit_inner(self, input):
        c = ModuloCircuit(self.name, 4, compilation_mode=self.compilation_mode)
        args = [
            c.write_struct(u384(name, [value]), WriteOps.INPUT)
            for name, value in zip(self.INPUTS[self.operation], input, strict=True)
        ]
        const = c.set_or_get_constant
        if self.operation == "low_order":
            x, y = args
            outputs = [c.add(c.mul(x, x), c.mul(y, y))]
        elif self.operation == "from_weierstrass":
            x, y = args
            # The order-two point (y=0) is handled before this map.
            twelve_x = c.mul(const(12), x)
            yt = c.div(
                c.sub(const(-5 - ed.D), twelve_x),
                c.sub(const(1 + 5 * ed.D), twelve_x),
            )
            # (a-d)(1+y_t) / (4*y_w*(1-y_t)).
            xt = c.div(
                c.mul(const(-1 - ed.D), c.add(const(1), yt)),
                c.mul(c.mul(const(4), y), c.sub(const(1), yt)),
            )
            outputs = [xt, yt]
        elif self.operation == "prepare":
            x, y = args
            one_minus_y = c.sub(const(1), y)
            e = c.mul(x, one_minus_y)
            u = c.mul(c.mul(c.mul(const(-1 - ed.D), c.add(const(1), y)), x), e)
            outputs = [u, c.mul(const(2), one_minus_y), e]
        elif self.operation in ("sqrt", "sqrt_or_twice"):
            (value,) = args
            root = c.mul(pow_252_3(c, value), value)
            root_sq = c.mul(root, root)
            outputs = [root, c.sub(root_sq, value), c.add(root_sq, value)]
            if self.operation == "sqrt_or_twice":
                imaginary = c.mul(const(ed.I), value)
                outputs.extend([c.sub(root_sq, imaginary), c.add(root_sq, imaginary)])
        elif self.operation == "halve_up":
            u, w, e, wp = args
            up = c.sub(
                c.sub(c.mul(const(4), u), c.mul(const(ed.A_PRIME), c.mul(e, e))),
                c.mul(const(2), c.mul(wp, w)),
            )
            outputs = [c.mul(up, const(pow(2, -1, ed.P)))]
        elif self.operation == "halve_nqr":
            e, wp, root = args
            outputs = [
                c.mul(e, root),
                c.mul(wp, root),
                c.mul(const(ed.SQRT_2_B_PRIME), c.mul(e, e)),
            ]
        elif self.operation == "finish":
            e, wp, w, sign = args
            u = c.mul(
                c.sub(
                    c.sub(c.mul(w, w), c.mul(const(ed.A), c.mul(e, e))), c.mul(w, wp)
                ),
                const(pow(2, -1, ed.P)),
            )
            shift = c.add(c.mul(sign, w), c.mul(const(2 * ed.I), e))
            f = c.mul(u, c.mul(shift, shift))
            t = pow_252_3(c, f)
            outputs = [c.mul(c.mul(t, t), f)]
        else:
            raise ValueError(f"Unknown Ed25519 circuit: {self.operation}")
        for index, value in enumerate(outputs):
            c.extend_struct_output(u384(f"out_{index}", [value]))
        return c
