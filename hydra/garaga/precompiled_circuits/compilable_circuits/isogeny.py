import garaga.modulo_circuit_structs as structs
from garaga.definitions import CurveID
from garaga.precompiled_circuits.compilable_circuits.base import (
    BaseModuloCircuit,
    ModuloCircuit,
    PyFelt,
)
from garaga.signature import get_isogeny_to_g1_map


class ApplyIsogenyCircuit(BaseModuloCircuit):
    def __init__(
        self, curve_id: int, auto_run: bool = True, compilation_mode: int = 1
    ) -> None:
        super().__init__(
            name=f"apply_isogeny_{CurveID(curve_id).name.lower()}",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        return [self.field(44), self.field(4)]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(
            self.name,
            self.curve_id,
            compilation_mode=self.compilation_mode,
        )
        px, py = circuit.write_struct(structs.G1PointCircuit(name="pt", elmts=input))
        x_rational, y_rational = get_isogeny_to_g1_map(CurveID(self.curve_id))
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

        x_affine_num = circuit.eval_horner(x_num, px, "x_num")
        x_affine_den = circuit.eval_horner(x_den, px, "x_den")
        x_affine = circuit.div(x_affine_num, x_affine_den)
        y_affine_num = circuit.eval_horner(y_num, px, "y_num")
        y_affine_den = circuit.eval_horner(y_den, px, "y_den")
        y_affine_eval = circuit.div(y_affine_num, y_affine_den)
        y_affine = circuit.mul(y_affine_eval, py)
        circuit.extend_struct_output(
            structs.G1PointCircuit(name="res", elmts=[x_affine, y_affine])
        )

        return circuit
