from random import randrange

from garaga.modulo_circuit import ModuloCircuit, WriteOps
from garaga.modulo_circuit_structs import RSA2048Chunks, u384
from garaga.precompiled_circuits.compilable_circuits.base import (
    BaseModuloCircuit,
    PyFelt,
)

RSA2048_N_CHUNKS = 6
RSA2048_TOP_CHUNK_BITS = 128
RSA2048_N_STEPS = 17


class RSAFullVerificationCircuit(BaseModuloCircuit):
    """Mega-circuit: all 17 reduction steps fused into one circuit per channel.

    Inputs (217): mod(6) + sig(6) + 17*(quot(6)+rem(6)) + step(1)
    Outputs (17): 17 diffs
    """

    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ) -> None:
        super().__init__(
            name="rsa_full_verification",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        # mod_chunks (6) + sig_chunks (6) + 17*(quot(6)+rem(6)) + step(1) = 217
        mod_chunks = [self.field.random() for _ in range(RSA2048_N_CHUNKS - 1)]
        mod_chunks.append(self.field(randrange(1 << RSA2048_TOP_CHUNK_BITS)))
        sig_chunks = [self.field.random() for _ in range(RSA2048_N_CHUNKS - 1)]
        sig_chunks.append(self.field(randrange(1 << RSA2048_TOP_CHUNK_BITS)))
        witness_chunks = []
        for _ in range(RSA2048_N_STEPS):
            quot = [self.field.random() for _ in range(RSA2048_N_CHUNKS - 1)]
            quot.append(self.field(randrange(1 << RSA2048_TOP_CHUNK_BITS)))
            rem = [self.field.random() for _ in range(RSA2048_N_CHUNKS - 1)]
            rem.append(self.field(randrange(1 << RSA2048_TOP_CHUNK_BITS)))
            witness_chunks.extend(quot + rem)
        step = [self.field.random()]
        return mod_chunks + sig_chunks + witness_chunks + step

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(
            self.name,
            self.curve_id,
            generic_circuit=True,
            generic_modulus=True,
            compilation_mode=self.compilation_mode,
        )

        mod_chunks = circuit.write_struct(
            RSA2048Chunks(
                "mod_chunks",
                [input.pop(0) for _ in range(RSA2048_N_CHUNKS)],
            ),
            WriteOps.INPUT,
        )
        sig_chunks = circuit.write_struct(
            RSA2048Chunks(
                "sig_chunks",
                [input.pop(0) for _ in range(RSA2048_N_CHUNKS)],
            ),
            WriteOps.INPUT,
        )

        all_quot_chunks = []
        all_rem_chunks = []
        for i in range(RSA2048_N_STEPS):
            quot = circuit.write_struct(
                RSA2048Chunks(
                    f"quot_chunks_{i}",
                    [input.pop(0) for _ in range(RSA2048_N_CHUNKS)],
                ),
                WriteOps.INPUT,
            )
            rem = circuit.write_struct(
                RSA2048Chunks(
                    f"rem_chunks_{i}",
                    [input.pop(0) for _ in range(RSA2048_N_CHUNKS)],
                ),
                WriteOps.INPUT,
            )
            all_quot_chunks.append(quot)
            all_rem_chunks.append(rem)

        step = circuit.write_struct(u384("step", [input.pop(0)]), WriteOps.INPUT)
        assert len(input) == 0, f"Expected empty input, got {len(input)} elements left"

        mod_res = circuit.eval_horner(
            mod_chunks, step, poly_name="mod_chunks", var_name="STEP"
        )
        sig_res = circuit.eval_horner(
            sig_chunks, step, poly_name="sig_chunks", var_name="STEP"
        )

        current = sig_res  # first step squares sig_res
        diffs = []
        for i in range(RSA2048_N_STEPS):
            q_res = circuit.eval_horner(
                all_quot_chunks[i], step, poly_name=f"quot_{i}", var_name="STEP"
            )
            r_res = circuit.eval_horner(
                all_rem_chunks[i], step, poly_name=f"rem_{i}", var_name="STEP"
            )
            if i < RSA2048_N_STEPS - 1:
                ab = circuit.mul(current, current, comment=f"square_{i}")
            else:
                ab = circuit.mul(current, sig_res, comment="final_multiply")
            qn = circuit.mul(q_res, mod_res, comment=f"quot*mod_{i}")
            diff = circuit.sub(ab, qn, comment=f"ab-qn_{i}")
            diff = circuit.sub(diff, r_res, comment=f"ab-qn-rem_{i}")
            diffs.append(diff)
            current = r_res

        for i, diff in enumerate(diffs):
            circuit.extend_struct_output(u384(f"diff_{i}", [diff]))
        return circuit
