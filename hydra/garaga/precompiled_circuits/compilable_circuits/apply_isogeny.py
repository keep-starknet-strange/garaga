import garaga.modulo_circuit_structs as structs
from garaga.definitions import CurveID
from garaga.precompiled_circuits.compilable_circuits.base import (
    BaseModuloCircuit,
    ModuloCircuit,
    PyFelt,
)
from garaga.precompiled_circuits.isogeny import IsogenyG1


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

        circuit = IsogenyG1(self.name, self.curve_id, self.compilation_mode)

        px, py = circuit.write_struct(structs.G1PointCircuit(name="pt", elmts=input))

        x_affine, y_affine = circuit.run_isogeny(px, py)

        circuit.extend_struct_output(
            structs.G1PointCircuit(name="res", elmts=[x_affine, y_affine])
        )

        return circuit
