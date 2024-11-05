from garaga.definitions import CURVES, CurveID
from garaga.extension_field_modulo_circuit import ModuloCircuit, ModuloCircuitElement
from garaga.modulo_circuit import ModuloCircuit, WriteOps
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

    def run_isogeny_g2(
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


if __name__ == "__main__":
    circuit = IsogenyG2("isogeny", 1)  # BLS12-381
    field_x = circuit.write_elements(
        [
            circuit.field(
                169519152402139697623491793754012113789032894758910773796231348501731795490199910990796174115277871812568749679080
            ),
            circuit.field(
                1728095456082680609005278389175634228411286941580472237217092659287996601824281397719739792814994738024437208024916
            ),
        ],
        WriteOps.INPUT,
    )
    field_y = circuit.write_elements(
        [
            circuit.field(
                921899175962300040840420456901482071750200770271137541308616448315528969776376924836021205171957295791079922974103
            ),
            circuit.field(
                3684633599184560222490700115577520911020962810206788383522966831012065752604210815152740734710545831758791724608234
            ),
        ],
        WriteOps.INPUT,
    )
    x_affine, y_affine = circuit.run_isogeny_g2(field_x, field_y)
    print(x_affine)
    print(y_affine)
