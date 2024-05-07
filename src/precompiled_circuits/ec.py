from src.modulo_circuit import WriteOps
from src.extension_field_modulo_circuit import (
    ModuloCircuit,
    ModuloCircuitElement,
    PyFelt,
    Polynomial,
)
from src.definitions import (
    CURVES,
    STARK,
    CurveID,
    BN254_ID,
    BLS12_381_ID,
    Curve,
)

import random
from enum import Enum

from starkware.python.math_utils import is_quad_residue, sqrt as sqrt_mod_p


class IsOnCurveCircuit(ModuloCircuit):
    def __init__(self, name: str, curve_id: int):
        super().__init__(name=name, curve_id=curve_id)
        self.curve = CURVES[curve_id]

    def _is_on_curve_G1(
        self, x: ModuloCircuitElement, y: ModuloCircuitElement
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
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

    def _is_on_curve_G2(
        self,
        x0: ModuloCircuitElement,
        x1: ModuloCircuitElement,
        y0: ModuloCircuitElement,
        y1: ModuloCircuitElement,
    ):
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


class DerivePointFromX(ModuloCircuit):
    def __init__(self, name: str, curve_id: int):
        super().__init__(name=name, curve_id=curve_id, generic_circuit=True)
        self.curve = CURVES[curve_id]

    def _derive_point_from_x(
        self,
        x: ModuloCircuitElement,
        b: ModuloCircuitElement,
        g: ModuloCircuitElement,
    ) -> list[ModuloCircuitElement]:
        # y^2 = x^3 + ax + b
        # Assumes a == 0.
        x3 = self.mul(x, self.mul(x, x))
        rhs = self.add(x3, b)

        grhs = self.mul(g, rhs)

        # WRITE g*rhs and rhs "square roots" to circuit.
        # If rhs is a square, write zero to gx and the square root of rhs to x3_ax_b_sqrt.
        # Otherwise, write the square root of gx to gx_sqrt and zero to x3_ax_b_sqrt.
        ## %{
        if is_quad_residue(rhs.value, self.field.p):
            rhs_sqrt = self.write_element(
                self.field(sqrt_mod_p(rhs.value, self.field.p)),
                WriteOps.WITNESS,
            )
            grhs_sqrt = self.write_element(self.field.zero(), WriteOps.WITNESS)

        else:
            assert is_quad_residue(grhs.value, self.field.p)  # Sanity check.
            rhs_sqrt = self.write_element(self.field.zero(), WriteOps.WITNESS)

            grhs_sqrt = self.write_element(
                self.field(sqrt_mod_p(grhs.value, self.field.p)),
                WriteOps.WITNESS,
            )

        ## %}
        should_be_rhs = self.mul(rhs_sqrt, rhs_sqrt)

        should_be_grhs = self.mul(grhs_sqrt, grhs_sqrt)

        return (rhs, grhs, should_be_rhs, should_be_grhs, rhs_sqrt)
