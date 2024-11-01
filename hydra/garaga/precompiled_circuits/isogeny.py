from garaga.definitions import CURVES, CurveID
from garaga.extension_field_modulo_circuit import ModuloCircuit, ModuloCircuitElement
from garaga.modulo_circuit import ModuloCircuit
from garaga.signature import get_isogeny_to_g2_map


class IsogenyG2(ModuloCircuit):
    def __init__(self, name: str, curve_id: int, compilation_mode: int = 0):
        super().__init__(
            name=name,
            curve_id=curve_id,
            compilation_mode=compilation_mode,
            generic_circuit=True,
        )
        self.curve = CURVES[curve_id]

    def run_isogeny_g2(
        self, x: list[ModuloCircuitElement], y: list[ModuloCircuitElement]
    ) -> ModuloCircuit:
        circuit = ModuloCircuit(
            self.name,
            self.curve_id,
            generic_circuit=True,
            compilation_mode=self.compilation_mode,
        )

        x_rational, y_rational = get_isogeny_to_g2_map(CurveID(self.curve_id))
        x_num = [
            circuit.set_or_get_constant(c) for c in x_rational.numerator.coefficients
        ]
        x_den = [
            circuit.set_or_get_constant(c) for c in x_rational.denominator.coefficients
        ]

        y_num = [
            circuit.set_or_get_constant(c) for c in y_rational.numerator.coefficients
        ]
        y_den = [
            circuit.set_or_get_constant(c) for c in y_rational.denominator.coefficients
        ]

        x_affine_num = self.fp2_eval_horner(x_num, x, "x_num")
        x_affine_den = self.fp2_eval_horner(x_den, x, "x_den")
        x_affine = self.fp2_div(x_affine_num, x_affine_den)
        y_affine_num = self.fp2_eval_horner(y_num, x, "y_num")
        y_affine_den = self.fp2_eval_horner(y_den, x, "y_den")
        y_affine_eval = self.fp2_div(y_affine_num, y_affine_den)
        y_affine = self.fp2_mul(y_affine_eval, y)

        return x_affine, y_affine
