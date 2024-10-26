from garaga.definitions import CurveID
from garaga.extension_field_modulo_circuit import ModuloCircuit, ModuloCircuitElement

NUMBER_OF_SUBRELATIONS = 26
NUMBER_OF_ALPHAS = NUMBER_OF_SUBRELATIONS - 1
NUMBER_OF_ENTITIES = 44


class HonkVerifierCircuits(ModuloCircuit):
    def __init__(
        self,
        name: str,
        curve_id: int = CurveID.GRUMPKIN.value,
    ):
        super().__init__(
            name=name,
            curve_id=curve_id,
        )

    def compute_public_input_delta(
        self,
        public_inputs: list[ModuloCircuitElement],
        beta: ModuloCircuitElement,
        gamma: ModuloCircuitElement,
        domain_size: int,
        offset: ModuloCircuitElement,
    ) -> ModuloCircuitElement:
        """
        # cpp/src/barretenberg/plonk_honk_shared/library/grand_product_delta.hpp
        # Specific for the # of public inputs.
        # domain_size : part of vk.
        # offset : proof pub input offset
        """
        num = self.set_or_get_constant(1)
        den = self.set_or_get_constant(1)

        num_acc = self.add(
            gamma,
            self.mul(beta, self.add(self.set_or_get_constant(domain_size), offset)),
        )
        den_acc = self.sub(
            gamma,
            self.mul(beta, self.add(offset, self.set_or_get_constant(1))),
        )

        for pub_input in public_inputs:
            num = self.mul(num, self.add(num_acc, pub_input))
            den = self.mul(den, self.add(den_acc, pub_input))

            num_acc = self.add(num_acc, beta)
            den_acc = self.sub(den_acc, beta)

        return self.div(num, den)
