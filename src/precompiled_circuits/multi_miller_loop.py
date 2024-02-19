from src.modulo_circuit import WriteOps
from src.extension_field_modulo_circuit import (
    ExtensionFieldModuloCircuit,
    EuclideanPolyAccumulator,
    ModuloCircuitElement,
    PyFelt,
    Polynomial,
)
from src.poseidon_transcript import CairoPoseidonTranscript
from src.definitions import CURVES, STARK, CurveID, BN254_ID, BLS12_381_ID, Curve
from src.hints.extf_mul import nondeterministic_extension_field_div


class MultiMillerLoopCircuit(ExtensionFieldModuloCircuit):
    def __init__(self, name: str, curve_id: CurveID):
        super().__init__(name, curve_id, 12)
        self.curve = CURVES[curve_id]

    def compute_slope(
        self,
        P: tuple[
            list[ModuloCircuitElement],
            list[ModuloCircuitElement],
        ],
        Q: tuple[
            list[ModuloCircuitElement],
            list[ModuloCircuitElement],
        ],
    ) -> list[ModuloCircuitElement, ModuloCircuitElement]:

        if P == Q:
            # Double
            # num = 3 * x^2
            # den = 2 * y
            num = self.extf_scalar_mul(P[0], self.get_constant(3))
            den = self.extf_add(P[1], P[1])
        else:
            # Add
            # num = y0 -y1
            # den x0 - x1
            num = self.extf_sub(P[1], Q[1])
            den = self.extf_sub(P[0], Q[0])

        # slope = num / den <=> num = slope * den

        slope = nondeterministic_extension_field_div(num, den, self.curve_id, 2)
        slope = self.write_elements(slope, WriteOps.WITNESS)
        # slope = s0 + i * s1
        # den = d0 + i * d1
        # slope*den = s0*d0 - s1*d1 + i * (s0*d1 + s1*d0)
        should_be_num = [
            self.sub(self.mul(slope[0], den[0]), self.mul(slope[1], den[1])),
            self.add(self.mul(slope[0], den[1]), self.mul(slope[1], den[0])),
        ]
        self.assert_eq(should_be_num[0], num[0])
        self.assert_eq(should_be_num[1], num[1])

        return slope

    # Todo : compute line
    def compute_line(
        self,
        P: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
        Q: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]],
    ) -> list[ModuloCircuitElement]:
        
        

    def compute_line_functions(
        self,
        P: tuple[ModuloCircuitElement, ModuloCircuitElement],
        Q: tuple[
            list[ModuloCircuitElement, ModuloCircuitElement],
            list[ModuloCircuitElement, ModuloCircuitElement],
        ],
    ):
        """
        Algorithm 2 from https://eprint.iacr.org/2019/077.pdf
        """
        T = Q

        line_functions = [None] * self.log2u
        for i in range(self.log2u, -1, -1):
            print(i)
            line_functions[i] = self.compute_line(T, T)
