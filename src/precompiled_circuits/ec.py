from src.modulo_circuit import WriteOps
from src.extension_field_modulo_circuit import (
    ModuloCircuit,
    ModuloCircuitElement,
    PyFelt,
    Polynomial,
    AccPolyInstructionType,
)
from src.poseidon_transcript import CairoPoseidonTranscript
from src.definitions import (
    CURVES,
    STARK,
    CurveID,
    BN254_ID,
    BLS12_381_ID,
    Curve,
    generate_frobenius_maps,
    get_V_torus_powers,
    get_sparsity,
)
from src.hints.extf_mul import (
    nondeterministic_square_torus,
    nondeterministic_extension_field_mul_divmod,
)
import random
from enum import Enum


class IsOnCurveCircuit(ModuloCircuit):
    def __init__(self, name: str, curve_id: int):
        super().__init__(name=name, curve_id=curve_id)
        self.curve = CURVES[curve_id]

    def _is_on_curve_G1(
        self, x: ModuloCircuitElement, y: ModuloCircuitElement
    ) -> ModuloCircuitElement:
        # y^2 = x^3 + ax + b
        a = self.set_or_get_constant(self.field(self.curve.a))
        b = self.set_or_get_constant(self.field(self.curve.b))

        y2 = self.mul(y, y)
        x3 = self.mul(x, self.mul(x, x))

        if a.value != 0:
            ax = self.mul(a, x)
            x3_ax_b = self.add(x3, self.add(ax, b))
        else:
            x3_ax_b = self.add(x3, b)

        return y2, x3_ax_b

    def _is_on_curve_G2(self, x0, x1, y0, y1):
        # y^2 = x^3 + ax + b [Fp2]
        a = self.set_or_get_constant(self.field(self.curve.a))
        b0 = self.set_or_get_constant(self.field(self.curve.b20))
        b1 = self.set_or_get_constant(self.field(self.curve.b21))

        y2 = self.fp2_square([y0, y1])
        x2 = self.fp2_square([x0, x1])
        x3 = self.fp2_mul([x0, x1], x2)

        if a.value != 0:
            ax = [self.mul(a, x0), self.mul(a, x1)]
            ax_b = [self.add(ax[0], b0), self.add(ax[1], b1)]
        else:
            ax_b = [b0, b1]

        x3_ax_b = [self.add(x3[0], ax_b[0]), self.add(x3[1], ax_b[1])]

        return y2, x3_ax_b
