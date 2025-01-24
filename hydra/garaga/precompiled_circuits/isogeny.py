from garaga.definitions import CURVES, CurveID
from garaga.extension_field_modulo_circuit import ModuloCircuitElement
from garaga.modulo_circuit import ModuloCircuit, WriteOps
from garaga.signature import get_isogeny_to_g1_map, get_isogeny_to_g2_map


class IsogenyG2(ModuloCircuit):
    def __init__(self, name: str, curve_id: int, compilation_mode: int = 0):
        super().__init__(
            name=name,
            curve_id=curve_id,
            compilation_mode=compilation_mode,
            generic_circuit=True,
        )
        self.curve = CURVES[curve_id]

    def set_consts(self):
        x_rational, y_rational = get_isogeny_to_g2_map(CurveID(self.curve_id))
        self.x_num = self.write_elements(
            x_rational.numerator.coefficients, WriteOps.CONSTANT
        )
        self.x_den = self.write_elements(
            x_rational.denominator.coefficients, WriteOps.CONSTANT
        )
        self.y_num = self.write_elements(
            y_rational.numerator.coefficients, WriteOps.CONSTANT
        )
        self.y_den = self.write_elements(
            y_rational.denominator.coefficients, WriteOps.CONSTANT
        )

    def run_isogeny(
        self, x: list[ModuloCircuitElement], y: list[ModuloCircuitElement]
    ) -> tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]:
        circuit = ModuloCircuit(
            self.name,
            self.curve_id,
            generic_circuit=False,
            compilation_mode=self.compilation_mode,
        )

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
            generic_circuit=True,
        )
        self.curve = CURVES[curve_id]

    def set_consts(self):
        x_rational, y_rational = get_isogeny_to_g1_map(CurveID(self.curve_id))
        self.x_num = self.write_elements(
            x_rational.numerator.coefficients, WriteOps.CONSTANT
        )
        self.x_den = self.write_elements(
            x_rational.denominator.coefficients, WriteOps.CONSTANT
        )
        self.y_num = self.write_elements(
            y_rational.numerator.coefficients, WriteOps.CONSTANT
        )
        self.y_den = self.write_elements(
            y_rational.denominator.coefficients, WriteOps.CONSTANT
        )

    def run_isogeny(
        self, x: ModuloCircuitElement, y: ModuloCircuitElement
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        circuit = ModuloCircuit(
            self.name,
            self.curve_id,
            generic_circuit=False,
            compilation_mode=self.compilation_mode,
        )

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
