from abc import abstractmethod
from typing import Dict, Tuple, Type, Union

import garaga.modulo_circuit_structs as structs
import garaga.precompiled_circuits.honk_new as hk
from garaga.definitions import CurveID
from garaga.modulo_circuit import ModuloCircuitElement
from garaga.modulo_circuit_structs import u384
from garaga.precompiled_circuits.compilable_circuits.base import (
    BaseModuloCircuit,
    ModuloCircuit,
    PyFelt,
)
from garaga.precompiled_circuits.honk_new import HonkVerifierCircuits, HonkVk


class BaseUltraHonkCircuit(BaseModuloCircuit):
    def __init__(
        self,
        name: str,
        curve_id: CurveID.GRUMPKIN.value,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ) -> None:
        super().__init__(
            name=name,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def _initialize_circuit(self) -> HonkVerifierCircuits:
        return HonkVerifierCircuits(
            name=self.name,
            curve_id=self.curve_id,
        )

    def _process_input(
        self, circuit: HonkVerifierCircuits, input: list[PyFelt]
    ) -> dict:
        """
        Method responsible for deserializing the input list of elements into the variables in the input map,
        and writing them to the circuit.
        The input list is expected to be in the same order as the input map.
        Since we use Python 3.10, the input map dict is ordered.
        Returns a vars dict with the same keys as the input map, but with the values being the instances of the structs,
        each struct holding ModuloCircuitElement(s).
        """
        vars = {}
        for name, struct_info in self.input_map.items():
            if isinstance(struct_info, tuple) and struct_info[0] == structs.u384Array:
                # Handle u384Array with specified size
                struct_type, size = struct_info
                vars[name] = circuit.write_struct(
                    struct_type(name, elmts=[input.pop(0) for _ in range(size)])
                )
            else:
                struct_type = struct_info
                # For other types, create a temporary instance to get its length
                temp_instance = struct_type(
                    name, None
                )  # Temporary instance with a dummy element
                size = len(temp_instance)
                if size == 1:
                    vars[name] = circuit.write_struct(
                        struct_type(name, elmts=[input.pop(0)])
                    )
                else:
                    # Convert to tuple so that it is Hashable
                    vars[name] = tuple(
                        circuit.write_struct(
                            struct_type(name, elmts=[input.pop(0) for _ in range(size)])
                        )
                    )
        assert len(input) == 0, f"Expected input of length 0, got {len(input)}"

        return vars

    @property
    @abstractmethod
    def input_map(
        self,
    ) -> Dict[
        str,
        Union[
            Type[structs.Cairo1SerializableStruct],
            Tuple[Type[structs.Cairo1SerializableStruct], int],
        ],
    ]:
        """
        Define the input map for the circuit in a dict.
        The key will be the name of the input variable, also used in the signature of the compiled Cairo code.
        The value will be either a Cairo1SerializableStruct type (which defines the struct in the Cairo code),
            or a tuple of the type and its size (for Array-like types).
        The reason behind this is that each Cairo1SerializableStruct defines the __len__ method, but for the
        array-like structs we need to specify the size in advance.
        """

    def build_input(self) -> list[PyFelt]:
        """
        Extends the base method of BaseModuloCircuit, by reading the input map and returning a list of random elements of the total expected size.
        """
        total_elements = 0
        for name, struct_info in self.input_map.items():
            if isinstance(struct_info, tuple):
                # Array-like case
                _, size = struct_info
                total_elements += size
            else:
                # For other structs, create a temporary instance to get its length
                temp_instance = struct_info(name, None)
                total_elements += len(temp_instance)

        return [self.field.random() for _ in range(total_elements)]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = self._initialize_circuit()

        vars = self._process_input(circuit, input)
        return self._execute_circuit_logic(circuit, vars)

    @abstractmethod
    def _execute_circuit_logic(self, circuit, vars) -> ModuloCircuit:
        """
        Implement the circuit logic using the processed input variables.
        """


class SumCheckCircuit(BaseUltraHonkCircuit):
    def __init__(
        self,
        vk: HonkVk,
        curve_id: int = CurveID.GRUMPKIN.value,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ) -> None:
        name = f"honk_sumcheck_size_{vk.log_circuit_size}_pub_{vk.public_inputs_size}"
        self.vk = vk

        super().__init__(name, curve_id, auto_run, compilation_mode)

    @property
    def input_map(self) -> dict:
        imap = {}

        imap["p_public_inputs"] = (structs.u384Array, self.vk.public_inputs_size)
        imap["p_public_inputs_offset"] = structs.u384

        for i in range(hk.BATCHED_RELATION_PARTIAL_LENGTH):
            imap[f"sumcheck_univariate_{i}"] = (
                structs.u384Array,
                hk.CONST_PROOF_SIZE_LOG_N,
            )

        imap["sumcheck_evaluations"] = (
            structs.u384Array,
            hk.NUMBER_OF_ENTITIES,
        )

        imap["tp_sum_check_u_challenges"] = (
            structs.u384Array,
            hk.CONST_PROOF_SIZE_LOG_N,
        )
        imap["tp_gate_challenges"] = (
            structs.u384Array,
            hk.CONST_PROOF_SIZE_LOG_N,
        )
        imap["tp_eta_1"] = structs.u384
        imap["tp_eta_2"] = structs.u384
        imap["tp_eta_3"] = structs.u384
        imap["tp_beta"] = structs.u384
        imap["tp_gamma"] = structs.u384
        imap["tp_base_rlc"] = structs.u384
        imap["tp_alphas"] = (structs.u384Array, hk.NUMBER_OF_ALPHAS)
        return imap

    def _execute_circuit_logic(
        self, circuit: HonkVerifierCircuits, vars: dict
    ) -> ModuloCircuit:
        tp_delta = circuit.compute_public_input_delta(
            vars["p_public_inputs"],
            vars["tp_beta"],
            vars["tp_gamma"],
            self.vk.circuit_size,
            vars["p_public_inputs_offset"],
        )

        sumcheck_univariates = []
        for i in range(hk.BATCHED_RELATION_PARTIAL_LENGTH):
            sumcheck_univariates.append(vars[f"sumcheck_univariate_{i}"])

        # Transpose the sumcheck_univariates matrix :
        # sumcheck_univariates is a list of lists, where each inner list has length hk.CONST_PROOF_SIZE_LOG_N
        # We want to transform it into a list of lists, where each inner list has length hk.BATCHED_RELATION_PARTIAL_LENGTH
        sumcheck_univariates = list(zip(*sumcheck_univariates))

        check_rlc, check = circuit.verify_sum_check(
            sumcheck_univariates,
            vars["sumcheck_evaluations"],
            vars["tp_beta"],
            vars["tp_gamma"],
            tp_delta,
            vars["tp_eta_1"],
            vars["tp_eta_2"],
            vars["tp_eta_3"],
            vars["tp_sum_check_u_challenges"],
            vars["tp_gate_challenges"],
            vars["tp_alphas"],
            self.vk.log_circuit_size,
            vars["tp_base_rlc"],
        )

        assert type(check_rlc) == ModuloCircuitElement
        assert type(check) == ModuloCircuitElement

        circuit.extend_struct_output(u384("check_rlc", elmts=[check_rlc]))
        circuit.extend_struct_output(u384("check", elmts=[check]))
        return circuit
