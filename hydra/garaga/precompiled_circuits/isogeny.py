from garaga.definitions import CURVES, CurveID
from garaga.extension_field_modulo_circuit import ModuloCircuitElement
from garaga.modulo_circuit import ModuloCircuit
from garaga.precompiled_circuits.fp2 import Fp2Circuits
from garaga.signature import get_isogeny_to_g1_map, get_isogeny_to_g2_map


class IsogenyG2(Fp2Circuits):
    def __init__(self, name: str, curve_id: int, compilation_mode: int = 0):
        super().__init__(
            name=name,
            curve_id=curve_id,
            compilation_mode=compilation_mode,
            generic_circuit=False,
        )
        self.curve = CURVES[curve_id]

    def set_consts(self):
        x_rational, y_rational = get_isogeny_to_g2_map(CurveID(self.curve_id))
        self.x_num = [
            self.set_or_get_constant(c) for c in x_rational.numerator.coefficients
        ]
        self.x_den = [
            self.set_or_get_constant(c) for c in x_rational.denominator.coefficients
        ]
        self.y_num = [
            self.set_or_get_constant(c) for c in y_rational.numerator.coefficients
        ]
        self.y_den = [
            self.set_or_get_constant(c) for c in y_rational.denominator.coefficients
        ]

    def run_isogeny(
        self, x: list[ModuloCircuitElement], y: list[ModuloCircuitElement]
    ) -> tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]:
        """
        Runs the isogeny to G2 map.
        """
        self.set_consts()

        x_affine_num = self.fp2_eval_horner(self.x_num, x, "x_num")
        x_affine_den = self.fp2_eval_horner(self.x_den, x, "x_den")
        x_affine = self.fp2_div(x_affine_num, x_affine_den)
        y_affine_num = self.fp2_eval_horner(self.y_num, x, "y_num")
        y_affine_den = self.fp2_eval_horner(self.y_den, x, "y_den")
        y_affine_eval = self.fp2_div(y_affine_num, y_affine_den)
        y_affine = self.fp2_mul(y_affine_eval, y)

        return x_affine, y_affine


class IsogenyG1(ModuloCircuit):
    def __init__(self, name: str, curve_id: int, compilation_mode: int = 0):
        super().__init__(
            name=name,
            curve_id=curve_id,
            compilation_mode=compilation_mode,
            generic_circuit=False,
        )
        self.curve = CURVES[curve_id]

    def set_consts(self):
        """
        Sets the constants for the isogeny to G1 map.
        """
        x_rational, y_rational = get_isogeny_to_g1_map(CurveID(self.curve_id))
        self.x_num = [
            self.set_or_get_constant(c) for c in x_rational.numerator.coefficients
        ]
        self.x_den = [
            self.set_or_get_constant(c) for c in x_rational.denominator.coefficients
        ]

        self.y_num = [
            self.set_or_get_constant(c) for c in y_rational.numerator.coefficients
        ]
        self.y_den = [
            self.set_or_get_constant(c) for c in y_rational.denominator.coefficients
        ]

    def run_isogeny(
        self, x: ModuloCircuitElement, y: ModuloCircuitElement
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        """
        Runs the isogeny to G1 map.
        """
        self.set_consts()

        x_affine_num = self.eval_horner(self.x_num, x, "x_num")
        x_affine_den = self.eval_horner(self.x_den, x, "x_den")
        x_affine = self.div(x_affine_num, x_affine_den)
        y_affine_num = self.eval_horner(self.y_num, x, "y_num")
        y_affine_den = self.eval_horner(self.y_den, x, "y_den")
        y_affine_eval = self.div(y_affine_num, y_affine_den)
        y_affine = self.mul(y_affine_eval, y)

        return x_affine, y_affine


if __name__ == "__main__":
    circuit = IsogenyG1("isogeny", 1)  # BLS12-381

    field_x = circuit.write_element(
        circuit.field(
            1412853964218444964438936699552956047210482383152224645596624291427056376487356261681298103080878386132407858666637
        )
    )
    field_y = circuit.write_element(
        circuit.field(
            752734926215712395741522221355891264404138695398702662135908094550118515106801651502315795564392519475687558113863
        )
    )

    x_affine, y_affine = circuit.run_isogeny(field_x, field_y)
