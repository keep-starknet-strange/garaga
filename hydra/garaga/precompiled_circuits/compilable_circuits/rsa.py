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


class RSAFirstStepCircuit(BaseModuloCircuit):
    """Mega-fused first step: evaluate mod, sig, quot, rem via Horner + relation check."""

    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ) -> None:
        super().__init__(
            name="rsa_first_step",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        # mod_chunks (6) + sig_chunks (6) + quot_chunks (6) + rem_chunks (6) + step (1) = 25
        mod_chunks = [self.field.random() for _ in range(RSA2048_N_CHUNKS - 1)]
        mod_chunks.append(self.field(randrange(1 << RSA2048_TOP_CHUNK_BITS)))
        sig_chunks = [self.field.random() for _ in range(RSA2048_N_CHUNKS - 1)]
        sig_chunks.append(self.field(randrange(1 << RSA2048_TOP_CHUNK_BITS)))
        quot_chunks = [self.field.random() for _ in range(RSA2048_N_CHUNKS - 1)]
        quot_chunks.append(self.field(randrange(1 << RSA2048_TOP_CHUNK_BITS)))
        rem_chunks = [self.field.random() for _ in range(RSA2048_N_CHUNKS - 1)]
        rem_chunks.append(self.field(randrange(1 << RSA2048_TOP_CHUNK_BITS)))
        step = [self.field.random()]
        return mod_chunks + sig_chunks + quot_chunks + rem_chunks + step

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(
            self.name,
            self.curve_id,
            generic_circuit=True,
            generic_modulus=True,
            compilation_mode=self.compilation_mode,
        )
        circuit.do_not_inline = True

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
        quot_chunks = circuit.write_struct(
            RSA2048Chunks(
                "quot_chunks",
                [input.pop(0) for _ in range(RSA2048_N_CHUNKS)],
            ),
            WriteOps.INPUT,
        )
        rem_chunks = circuit.write_struct(
            RSA2048Chunks(
                "rem_chunks",
                [input.pop(0) for _ in range(RSA2048_N_CHUNKS)],
            ),
            WriteOps.INPUT,
        )
        step = circuit.write_struct(u384("step", [input.pop(0)]), WriteOps.INPUT)
        assert len(input) == 0, f"Expected empty input, got {len(input)} elements left"

        mod_res = circuit.eval_horner(
            mod_chunks, step, poly_name="mod_chunks", var_name="STEP"
        )
        sig_res = circuit.eval_horner(
            sig_chunks, step, poly_name="sig_chunks", var_name="STEP"
        )
        quot_res = circuit.eval_horner(
            quot_chunks, step, poly_name="quot_chunks", var_name="STEP"
        )
        rem_res = circuit.eval_horner(
            rem_chunks, step, poly_name="rem_chunks", var_name="STEP"
        )

        ab = circuit.mul(sig_res, sig_res, comment="sig * sig")
        qn = circuit.mul(quot_res, mod_res, comment="quot * mod")
        diff = circuit.sub(ab, qn, comment="ab - qn")
        diff = circuit.sub(diff, rem_res, comment="ab - qn - rem")

        circuit.extend_struct_output(u384("mod_res", [mod_res]))
        circuit.extend_struct_output(u384("sig_res", [sig_res]))
        circuit.extend_struct_output(u384("rem_res", [rem_res]))
        circuit.extend_struct_output(u384("diff", [diff]))
        return circuit


class RSABatchedSquaringCircuit(BaseModuloCircuit):
    """Batched: chain 5 squarings in one circuit (eval Horner + relation check × 5)."""

    BATCH_SIZE = 5

    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ) -> None:
        super().__init__(
            name="rsa_batched_squaring",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        # 3 × (quot_chunks(6) + rem_chunks(6)) + step(1) + prev_res(1) + mod_res(1) = 39
        inputs = []
        for _ in range(self.BATCH_SIZE):
            quot_chunks = [self.field.random() for _ in range(RSA2048_N_CHUNKS - 1)]
            quot_chunks.append(self.field(randrange(1 << RSA2048_TOP_CHUNK_BITS)))
            rem_chunks = [self.field.random() for _ in range(RSA2048_N_CHUNKS - 1)]
            rem_chunks.append(self.field(randrange(1 << RSA2048_TOP_CHUNK_BITS)))
            inputs.extend(quot_chunks + rem_chunks)
        inputs.append(self.field.random())  # step
        inputs.append(self.field.random())  # prev_res
        inputs.append(self.field.random())  # mod_res
        return inputs

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(
            self.name,
            self.curve_id,
            generic_circuit=True,
            generic_modulus=True,
            compilation_mode=self.compilation_mode,
        )
        circuit.do_not_inline = True

        all_quot_chunks = []
        all_rem_chunks = []
        for i in range(self.BATCH_SIZE):
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
        prev_res = circuit.write_struct(
            u384("prev_res", [input.pop(0)]), WriteOps.INPUT
        )
        mod_res = circuit.write_struct(u384("mod_res", [input.pop(0)]), WriteOps.INPUT)
        assert len(input) == 0, f"Expected empty input, got {len(input)} elements left"

        current_res = prev_res
        diffs = []
        for i in range(self.BATCH_SIZE):
            quot_res = circuit.eval_horner(
                all_quot_chunks[i], step, poly_name=f"quot_{i}", var_name="STEP"
            )
            rem_res = circuit.eval_horner(
                all_rem_chunks[i], step, poly_name=f"rem_{i}", var_name="STEP"
            )
            ab = circuit.mul(current_res, current_res, comment=f"square_{i}")
            qn = circuit.mul(quot_res, mod_res, comment=f"quot*mod_{i}")
            diff = circuit.sub(ab, qn, comment=f"ab-qn_{i}")
            diff = circuit.sub(diff, rem_res, comment=f"ab-qn-rem_{i}")
            diffs.append(diff)
            current_res = rem_res

        circuit.extend_struct_output(u384("rem_res", [current_res]))
        for i, diff in enumerate(diffs):
            circuit.extend_struct_output(u384(f"diff_{i}", [diff]))
        return circuit


class RSAFusedEvalRelationCircuit(BaseModuloCircuit):
    """Fused: evaluate quotient & remainder via Horner, then check a*b - q*n - r."""

    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 0,
    ) -> None:
        super().__init__(
            name="rsa_fused_eval_relation",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        # quot_chunks (6) + rem_chunks (6) + step (1) + lhs_res (1) + rhs_res (1) + mod_res (1) = 16
        quot_chunks = [self.field.random() for _ in range(RSA2048_N_CHUNKS - 1)]
        quot_chunks.append(self.field(randrange(1 << RSA2048_TOP_CHUNK_BITS)))
        rem_chunks = [self.field.random() for _ in range(RSA2048_N_CHUNKS - 1)]
        rem_chunks.append(self.field(randrange(1 << RSA2048_TOP_CHUNK_BITS)))
        step = [self.field.random()]
        lhs_res = [self.field.random()]
        rhs_res = [self.field.random()]
        mod_res = [self.field.random()]
        return quot_chunks + rem_chunks + step + lhs_res + rhs_res + mod_res

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(
            self.name,
            self.curve_id,
            generic_circuit=True,
            generic_modulus=True,
            compilation_mode=self.compilation_mode,
        )
        circuit.do_not_inline = True

        quot_chunks = circuit.write_struct(
            RSA2048Chunks(
                "quot_chunks",
                [input.pop(0) for _ in range(RSA2048_N_CHUNKS)],
            ),
            WriteOps.INPUT,
        )
        rem_chunks = circuit.write_struct(
            RSA2048Chunks(
                "rem_chunks",
                [input.pop(0) for _ in range(RSA2048_N_CHUNKS)],
            ),
            WriteOps.INPUT,
        )
        step = circuit.write_struct(u384("step", [input.pop(0)]), WriteOps.INPUT)
        lhs_res = circuit.write_struct(u384("lhs_res", [input.pop(0)]), WriteOps.INPUT)
        rhs_res = circuit.write_struct(u384("rhs_res", [input.pop(0)]), WriteOps.INPUT)
        mod_res = circuit.write_struct(u384("mod_res", [input.pop(0)]), WriteOps.INPUT)
        assert len(input) == 0, f"Expected empty input, got {len(input)} elements left"

        quot_res = circuit.eval_horner(
            quot_chunks, step, poly_name="quot_chunks", var_name="STEP"
        )
        rem_res = circuit.eval_horner(
            rem_chunks, step, poly_name="rem_chunks", var_name="STEP"
        )

        ab = circuit.mul(lhs_res, rhs_res, comment="lhs * rhs")
        qn = circuit.mul(quot_res, mod_res, comment="quot * mod")
        diff = circuit.sub(ab, qn, comment="ab - qn")
        diff = circuit.sub(diff, rem_res, comment="ab - qn - rem")

        circuit.extend_struct_output(u384("rem_res", [rem_res]))
        circuit.extend_struct_output(u384("diff", [diff]))
        return circuit
