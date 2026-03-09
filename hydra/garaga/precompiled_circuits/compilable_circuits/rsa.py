from random import randrange

from garaga.modulo_circuit import ModuloCircuit, WriteOps
from garaga.modulo_circuit_structs import RSA2048Chunks, u384
from garaga.precompiled_circuits.compilable_circuits.base import (
    BaseModuloCircuit,
    PyFelt,
)

RSA2048_N_CHUNKS = 6
RSA2048_TOP_CHUNK_BITS = 128


class RSAEval6ChunksCircuit(BaseModuloCircuit):
    """Evaluate a 6-chunk little-endian radix-2^384 polynomial under a runtime modulus."""

    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ) -> None:
        super().__init__(
            name="rsa_eval_6_chunks",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        chunks = [self.field.random() for _ in range(RSA2048_N_CHUNKS - 1)]
        chunks.append(self.field(randrange(1 << RSA2048_TOP_CHUNK_BITS)))
        # Runtime step is 2^384 mod p_i for the selected RSA channel modulus.
        chunks.append(self.field.random())
        return chunks

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(
            self.name,
            self.curve_id,
            generic_circuit=True,
            generic_modulus=True,
            compilation_mode=self.compilation_mode,
        )
        circuit.do_not_inline = True
        chunks = circuit.write_struct(
            RSA2048Chunks(
                "chunks",
                [input.pop(0) for _ in range(RSA2048_N_CHUNKS)],
            ),
            WriteOps.INPUT,
        )
        step = circuit.write_struct(u384("step", [input.pop(0)]), WriteOps.INPUT)
        assert len(input) == 0, f"Expected empty input, got {len(input)} elements left"

        value = circuit.eval_horner(chunks, step, poly_name="chunks", var_name="STEP")
        circuit.extend_struct_output(u384("value", [value]))
        return circuit


class RSARelationCheckCircuit(BaseModuloCircuit):
    """Evaluate a * b - q * n - r under a runtime modulus."""

    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ) -> None:
        super().__init__(
            name="rsa_relation_check",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        return [self.field.random() for _ in range(5)]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(
            self.name,
            self.curve_id,
            generic_circuit=True,
            generic_modulus=True,
            compilation_mode=self.compilation_mode,
        )
        circuit.do_not_inline = True
        a = circuit.write_struct(u384("a", [input.pop(0)]), WriteOps.INPUT)
        b = circuit.write_struct(u384("b", [input.pop(0)]), WriteOps.INPUT)
        q = circuit.write_struct(u384("q", [input.pop(0)]), WriteOps.INPUT)
        n = circuit.write_struct(u384("n", [input.pop(0)]), WriteOps.INPUT)
        r = circuit.write_struct(u384("r", [input.pop(0)]), WriteOps.INPUT)
        assert len(input) == 0, f"Expected empty input, got {len(input)} elements left"

        ab = circuit.mul(a, b, comment="Evaluate a * b")
        qn = circuit.mul(q, n, comment="Evaluate q * n")
        diff = circuit.sub(ab, qn, comment="Subtract q * n")
        diff = circuit.sub(diff, r, comment="Subtract r")
        circuit.extend_struct_output(u384("diff", [diff]))
        return circuit
