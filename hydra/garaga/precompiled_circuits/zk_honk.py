import math
from dataclasses import dataclass

import garaga.hints.io as io
from garaga.algebra import ModuloCircuitElement
from garaga.definitions import CURVES, CurveID, G1Point, ProofSystem
from garaga.modulo_circuit import ModuloCircuit
from garaga.precompiled_circuits.honk import (
    CONST_PROOF_SIZE_LOG_N,
    G1_PROOF_POINT_SHIFT,
    MAX_LOG_N,
    NUMBER_OF_ALPHAS,
    NUMBER_OF_ENTITIES,
    Sha3Transcript,
    StarknetPoseidonTranscript,
    Wire,
    g1_to_g1_proof_point,
)

ZK_BATCHED_RELATION_PARTIAL_LENGTH = 9


@dataclass
class ZKHonkProof:
    circuit_size: int
    public_inputs_size: int
    public_inputs_offset: int
    public_inputs: list[int]
    w1: G1Point
    w2: G1Point
    w3: G1Point
    w4: G1Point
    lookup_read_counts: G1Point
    lookup_read_tags: G1Point
    lookup_inverses: G1Point
    z_perm: G1Point
    libra_commitments: list[G1Point]
    libra_sum: int
    sumcheck_univariates: list[list[int]]
    sumcheck_evaluations: list[int]
    libra_evaluation: int
    gemini_masking_poly: G1Point
    gemini_masking_eval: int
    gemini_fold_comms: list[G1Point]
    gemini_a_evaluations: list[int]
    libra_poly_evals: list[int]
    shplonk_q: G1Point
    kzg_quotient: G1Point

    @property
    def log_circuit_size(self) -> int:
        return int(math.log2(self.circuit_size))

    def __post_init__(self):
        assert len(self.libra_commitments) == 3
        assert len(self.sumcheck_univariates) == CONST_PROOF_SIZE_LOG_N
        assert all(
            len(univariate) == ZK_BATCHED_RELATION_PARTIAL_LENGTH
            for univariate in self.sumcheck_univariates
        )
        assert len(self.sumcheck_evaluations) == NUMBER_OF_ENTITIES
        assert len(self.gemini_fold_comms) == CONST_PROOF_SIZE_LOG_N - 1
        assert len(self.gemini_a_evaluations) == CONST_PROOF_SIZE_LOG_N
        assert len(self.libra_poly_evals) == 4

    @classmethod
    def from_bytes(cls, bytes: bytes) -> "ZKHonkProof":
        n_elements = int.from_bytes(bytes[:4], "big")
        assert len(bytes[4:]) % 32 == 0
        elements = [
            int.from_bytes(bytes[i : i + 32], "big") for i in range(4, len(bytes), 32)
        ]
        assert len(elements) == n_elements

        circuit_size = elements[0]
        public_inputs_size = elements[1]
        public_inputs_offset = elements[2]

        assert circuit_size <= 2**MAX_LOG_N

        public_inputs = []
        cursor = 3
        for i in range(public_inputs_size):
            public_inputs.append(elements[cursor + i])

        cursor += public_inputs_size

        def parse_g1_proof_point(i: int) -> G1Point:
            return G1Point(
                x=elements[i] + G1_PROOF_POINT_SHIFT * elements[i + 1],
                y=elements[i + 2] + G1_PROOF_POINT_SHIFT * elements[i + 3],
                curve_id=CurveID.BN254,
            )

        G1_PROOF_POINT_SIZE = 4

        w1 = parse_g1_proof_point(cursor)
        w2 = parse_g1_proof_point(cursor + G1_PROOF_POINT_SIZE)
        w3 = parse_g1_proof_point(cursor + 2 * G1_PROOF_POINT_SIZE)

        lookup_read_counts = parse_g1_proof_point(cursor + 3 * G1_PROOF_POINT_SIZE)
        lookup_read_tags = parse_g1_proof_point(cursor + 4 * G1_PROOF_POINT_SIZE)
        w4 = parse_g1_proof_point(cursor + 5 * G1_PROOF_POINT_SIZE)
        lookup_inverses = parse_g1_proof_point(cursor + 6 * G1_PROOF_POINT_SIZE)
        z_perm = parse_g1_proof_point(cursor + 7 * G1_PROOF_POINT_SIZE)

        libra_commitments = [None] * 3
        libra_commitments[0] = parse_g1_proof_point(cursor + 8 * G1_PROOF_POINT_SIZE)

        cursor += 9 * G1_PROOF_POINT_SIZE

        libra_sum = elements[cursor]

        cursor += 1

        # Parse sumcheck univariates.
        sumcheck_univariates = []
        for i in range(CONST_PROOF_SIZE_LOG_N):
            sumcheck_univariates.append(
                [
                    elements[cursor + i * ZK_BATCHED_RELATION_PARTIAL_LENGTH + j]
                    for j in range(ZK_BATCHED_RELATION_PARTIAL_LENGTH)
                ]
            )
        cursor += ZK_BATCHED_RELATION_PARTIAL_LENGTH * CONST_PROOF_SIZE_LOG_N

        # Parse sumcheck_evaluations
        sumcheck_evaluations = elements[cursor : cursor + NUMBER_OF_ENTITIES]

        cursor += NUMBER_OF_ENTITIES

        libra_evaluation = elements[cursor]

        cursor += 1

        libra_commitments[1] = parse_g1_proof_point(cursor)
        libra_commitments[2] = parse_g1_proof_point(cursor + G1_PROOF_POINT_SIZE)
        gemini_masking_poly = parse_g1_proof_point(cursor + 2 * G1_PROOF_POINT_SIZE)

        cursor += 3 * G1_PROOF_POINT_SIZE

        gemini_masking_eval = elements[cursor]

        cursor += 1

        # Parse gemini fold comms
        gemini_fold_comms = [
            parse_g1_proof_point(cursor + i * G1_PROOF_POINT_SIZE)
            for i in range(CONST_PROOF_SIZE_LOG_N - 1)
        ]

        cursor += (CONST_PROOF_SIZE_LOG_N - 1) * G1_PROOF_POINT_SIZE

        # Parse gemini a evaluations
        gemini_a_evaluations = elements[cursor : cursor + CONST_PROOF_SIZE_LOG_N]

        cursor += CONST_PROOF_SIZE_LOG_N

        libra_poly_evals = elements[cursor : cursor + 4]

        cursor += 4

        shplonk_q = parse_g1_proof_point(cursor)
        kzg_quotient = parse_g1_proof_point(cursor + G1_PROOF_POINT_SIZE)

        cursor += 2 * G1_PROOF_POINT_SIZE

        assert cursor == len(elements)

        return ZKHonkProof(
            circuit_size=circuit_size,
            public_inputs_size=public_inputs_size,
            public_inputs_offset=public_inputs_offset,
            public_inputs=public_inputs,
            w1=w1,
            w2=w2,
            w3=w3,
            w4=w4,
            lookup_read_counts=lookup_read_counts,
            lookup_read_tags=lookup_read_tags,
            lookup_inverses=lookup_inverses,
            z_perm=z_perm,
            libra_commitments=libra_commitments,
            libra_sum=libra_sum,
            sumcheck_univariates=sumcheck_univariates,
            sumcheck_evaluations=sumcheck_evaluations,
            libra_evaluation=libra_evaluation,
            gemini_masking_poly=gemini_masking_poly,
            gemini_masking_eval=gemini_masking_eval,
            gemini_fold_comms=gemini_fold_comms,
            gemini_a_evaluations=gemini_a_evaluations,
            libra_poly_evals=libra_poly_evals,
            shplonk_q=shplonk_q,
            kzg_quotient=kzg_quotient,
        )

    def to_circuit_elements(self, circuit: ModuloCircuit) -> "ZKHonkProof":
        """Convert everything to ModuloCircuitElements given a circuit."""
        return HonkProof(
            circuit_size=self.circuit_size,
            public_inputs_size=self.public_inputs_size,
            public_inputs_offset=circuit.write_element(self.public_inputs_offset),
            public_inputs=circuit.write_elements(self.public_inputs),
            w1=circuit.write_struct(structs.G1PointCircuit.from_G1Point("w1", self.w1)),
            w2=circuit.write_struct(structs.G1PointCircuit.from_G1Point("w2", self.w2)),
            w3=circuit.write_struct(structs.G1PointCircuit.from_G1Point("w3", self.w3)),
            w4=circuit.write_struct(structs.G1PointCircuit.from_G1Point("w4", self.w4)),
            lookup_read_counts=circuit.write_struct(
                structs.G1PointCircuit.from_G1Point(
                    "lookup_read_counts", self.lookup_read_counts
                )
            ),
            lookup_read_tags=circuit.write_struct(
                structs.G1PointCircuit.from_G1Point(
                    "lookup_read_tags", self.lookup_read_tags
                )
            ),
            lookup_inverses=circuit.write_struct(
                structs.G1PointCircuit.from_G1Point(
                    "lookup_inverses", self.lookup_inverses
                )
            ),
            z_perm=circuit.write_struct(
                structs.G1PointCircuit.from_G1Point("z_perm", self.z_perm)
            ),
            libra_commitments=[
                circuit.write_struct(
                    structs.G1PointCircuit.from_G1Point(f"libra_commitments_{i}", comm)
                )
                for i, comm in enumerate(self.libra_commitments)
            ],
            libra_sum=circuit.write_element(self.libra_sum),
            sumcheck_univariates=[
                circuit.write_elements(univariate)
                for univariate in self.sumcheck_univariates
            ],
            sumcheck_evaluations=circuit.write_elements(self.sumcheck_evaluations),
            libra_evaluation=circuit.write_element(self.libra_evaluation),
            gemini_masking_poly=circuit.write_struct(
                structs.G1PointCircuit.from_G1Point(
                    "gemini_masking_poly", self.gemini_masking_poly
                )
            ),
            gemini_masking_eval=circuit.write_element(self.gemini_masking_eval),
            gemini_fold_comms=[
                circuit.write_struct(
                    structs.G1PointCircuit.from_G1Point(f"gemini_fold_comm_{i}", comm)
                )
                for i, comm in enumerate(self.gemini_fold_comms)
            ],
            gemini_a_evaluations=circuit.write_elements(self.gemini_a_evaluations),
            libra_poly_evals=circuit.write_elements(self.libra_poly_evals),
            shplonk_q=circuit.write_struct(
                structs.G1PointCircuit.from_G1Point("shplonk_q", self.shplonk_q)
            ),
            kzg_quotient=circuit.write_struct(
                structs.G1PointCircuit.from_G1Point("kzg_quotient", self.kzg_quotient)
            ),
        )

    def to_cairo(self) -> str:
        def g1_to_g1point256(g1_point: G1Point) -> str:
            return f"G1Point256{{x: {hex(g1_point.x)}, y: {hex(g1_point.y)}}}"

        def format_array(elements: list, span: bool = False) -> str:
            """Helper function to format arrays with custom element formatting"""
            formatted_elements = [hex(el) for el in elements]
            arr = f"array![{', '.join(formatted_elements)}]"
            if span:
                return f"{arr}.span()"
            return arr

        code = f"ZKHonkProof {{\n"
        code += f"circuit_size: {self.circuit_size},\n"
        code += f"public_inputs_size: {self.public_inputs_size},\n"
        code += f"public_inputs_offset: {self.public_inputs_offset},\n"
        code += f"public_inputs: {format_array(self.public_inputs, span=True)},\n"
        code += f"w1: {g1_to_g1point256(self.w1)},\n"
        code += f"w2: {g1_to_g1point256(self.w2)},\n"
        code += f"w3: {g1_to_g1point256(self.w3)},\n"
        code += f"w4: {g1_to_g1point256(self.w4)},\n"
        code += f"lookup_read_counts: {g1_to_g1point256(self.lookup_read_counts)},\n"
        code += f"lookup_read_tags: {g1_to_g1point256(self.lookup_read_tags)},\n"
        code += f"lookup_inverses: {g1_to_g1point256(self.lookup_inverses)},\n"
        code += f"z_perm: {g1_to_g1point256(self.z_perm)},\n"
        code += f"libra_commitments: array![{', '.join(g1_to_g1point256(comm) for comm in self.libra_commitments)}].span(),\n"
        code += f"libra_sum: {hex(self.libra_sum)},\n"

        # Flatten sumcheck_univariates array
        code += f"sumcheck_univariates: {format_array(io.flatten(self.sumcheck_univariates)[:self.log_circuit_size * ZK_BATCHED_RELATION_PARTIAL_LENGTH], span=True)},\n"

        code += f"sumcheck_evaluations: {format_array(self.sumcheck_evaluations, span=True)},\n"
        code += f"libra_evaluation: {hex(self.libra_evaluation)},\n"
        code += f"gemini_masking_poly: {g1_to_g1point256(self.gemini_masking_poly)},\n"
        code += f"gemini_masking_eval: {hex(self.gemini_masking_eval)},\n"
        code += f"gemini_fold_comms: array![{', '.join(g1_to_g1point256(comm) for comm in self.gemini_fold_comms[:self.log_circuit_size - 1])}].span(),\n"
        code += f"gemini_a_evaluations: {format_array(self.gemini_a_evaluations[:self.log_circuit_size], span=True)},\n"
        code += f"libra_poly_evals: {format_array(self.libra_poly_evals, span=True)},\n"
        code += f"shplonk_q: {g1_to_g1point256(self.shplonk_q)},\n"
        code += f"kzg_quotient: {g1_to_g1point256(self.kzg_quotient)},\n"
        code += "};"
        return code

    def serialize_to_calldata(self) -> list[int]:
        def serialize_G1Point256(g1_point: G1Point) -> list[int]:
            xl, xh = io.split_128(g1_point.x)
            yl, yh = io.split_128(g1_point.y)
            return [xl, xh, yl, yh]

        cd = []
        cd.append(self.circuit_size)
        cd.append(self.public_inputs_size)
        cd.append(self.public_inputs_offset)
        cd.extend(
            io.bigint_split_array(
                x=self.public_inputs, n_limbs=2, base=2**128, prepend_length=True
            )
        )
        cd.extend(serialize_G1Point256(self.w1))
        cd.extend(serialize_G1Point256(self.w2))
        cd.extend(serialize_G1Point256(self.w3))
        cd.extend(serialize_G1Point256(self.w4))
        cd.extend(serialize_G1Point256(self.lookup_read_counts))
        cd.extend(serialize_G1Point256(self.lookup_read_tags))
        cd.extend(serialize_G1Point256(self.lookup_inverses))
        cd.extend(serialize_G1Point256(self.z_perm))

        for pt in self.libra_commitments:
            cd.extend(serialize_G1Point256(pt))

        cd.extend(io.bigint_split(self.libra_sum, n_limbs=2, base=2**128))

        cd.extend(
            io.bigint_split_array(
                x=io.flatten(self.sumcheck_univariates)[
                    : ZK_BATCHED_RELATION_PARTIAL_LENGTH * self.log_circuit_size
                ],  # The rest is 0.
                n_limbs=2,
                base=2**128,
                prepend_length=True,
            )
        )

        cd.extend(
            io.bigint_split_array(
                x=self.sumcheck_evaluations, n_limbs=2, base=2**128, prepend_length=True
            )
        )

        cd.extend(io.bigint_split(self.libra_evaluation, n_limbs=2, base=2**128))

        cd.extend(serialize_G1Point256(self.gemini_masking_poly))

        cd.extend(io.bigint_split(self.gemini_masking_eval, n_limbs=2, base=2**128))

        cd.append(self.log_circuit_size - 1)
        for pt in self.gemini_fold_comms[
            : self.log_circuit_size - 1
        ]:  # The rest is G(1, 2)
            cd.extend(serialize_G1Point256(pt))

        cd.extend(
            io.bigint_split_array(
                x=self.gemini_a_evaluations[: self.log_circuit_size],
                n_limbs=2,
                base=2**128,
                prepend_length=True,
            )
        )

        cd.extend(
            io.bigint_split_array(
                x=self.libra_poly_evals,
                n_limbs=2,
                base=2**128,
                prepend_length=False,
            )
        )

        cd.extend(serialize_G1Point256(self.shplonk_q))
        cd.extend(serialize_G1Point256(self.kzg_quotient))

        return cd

    def flatten(self) -> list[int]:
        """Used to pass data to Rust"""

        lst = []
        lst.append(self.circuit_size)
        lst.append(self.public_inputs_size)
        lst.append(self.public_inputs_offset)
        lst.extend(self.public_inputs)
        lst.extend(g1_to_g1_proof_point(self.w1))
        lst.extend(g1_to_g1_proof_point(self.w2))
        lst.extend(g1_to_g1_proof_point(self.w3))
        lst.extend(g1_to_g1_proof_point(self.lookup_read_counts))
        lst.extend(g1_to_g1_proof_point(self.lookup_read_tags))
        lst.extend(g1_to_g1_proof_point(self.w4))
        lst.extend(g1_to_g1_proof_point(self.lookup_inverses))
        lst.extend(g1_to_g1_proof_point(self.z_perm))
        lst.extend(g1_to_g1_proof_point(self.libra_commitments[0]))
        lst.append(self.libra_sum)
        for line in self.sumcheck_univariates:
            lst.extend(line)
        lst.extend(self.sumcheck_evaluations)
        lst.append(self.libra_evaluation)
        lst.extend(g1_to_g1_proof_point(self.libra_commitments[1]))
        lst.extend(g1_to_g1_proof_point(self.libra_commitments[2]))
        lst.extend(g1_to_g1_proof_point(self.gemini_masking_poly))
        lst.append(self.gemini_masking_eval)
        for point in self.gemini_fold_comms:
            lst.extend(g1_to_g1_proof_point(point))
        lst.extend(self.gemini_a_evaluations)
        lst.extend(self.libra_poly_evals)
        lst.extend(g1_to_g1_proof_point(self.shplonk_q))
        lst.extend(g1_to_g1_proof_point(self.kzg_quotient))
        return lst


@dataclass
class ZKHonkTranscript:
    eta: int | ModuloCircuitElement
    etaTwo: int | ModuloCircuitElement
    etaThree: int | ModuloCircuitElement
    beta: int | ModuloCircuitElement
    gamma: int | ModuloCircuitElement
    alphas: list[int | ModuloCircuitElement]
    gate_challenges: list[int | ModuloCircuitElement]
    libra_challenge: int | ModuloCircuitElement
    sum_check_u_challenges: list[ModuloCircuitElement]
    rho: int | ModuloCircuitElement
    gemini_r: int | ModuloCircuitElement
    shplonk_nu: int | ModuloCircuitElement
    shplonk_z: int | ModuloCircuitElement
    public_inputs_delta: int | None = None  # Derived.

    def __post_init__(self):
        assert len(self.alphas) == NUMBER_OF_ALPHAS
        assert len(self.gate_challenges) == CONST_PROOF_SIZE_LOG_N
        assert len(self.sum_check_u_challenges) == CONST_PROOF_SIZE_LOG_N

    @classmethod
    def from_proof(
        cls, proof: ZKHonkProof, system: ProofSystem = ProofSystem.UltraKeccakZKHonk
    ) -> "ZKHonkTranscript":

        def split_challenge(ch: bytes) -> tuple[int, int]:
            ch_int = int.from_bytes(ch, "big")
            high_128, low_128 = divmod(ch_int, 2**128)
            return (low_128, high_128)

        # Round 0 : circuit_size, public_inputs_size, public_input_offset, [public_inputs], w1, w2, w3
        FR = CURVES[CurveID.GRUMPKIN.value].p

        match system:
            case ProofSystem.UltraKeccakZKHonk:
                hasher = Sha3Transcript()
            case ProofSystem.UltraStarknetZKHonk:
                hasher = StarknetPoseidonTranscript()
            case _:
                raise ValueError(f"Proof system {system} not compatible")

        hasher.update(int.to_bytes(proof.circuit_size, 32, "big"))
        hasher.update(int.to_bytes(proof.public_inputs_size, 32, "big"))
        hasher.update(int.to_bytes(proof.public_inputs_offset, 32, "big"))

        for pub_input in proof.public_inputs:
            hasher.update(int.to_bytes(pub_input, 32, "big"))

        for g1_proof_point in [proof.w1, proof.w2, proof.w3]:
            # print(f"g1_proof_point: {g1_proof_point.__repr__()}")
            x0, x1, y0, y1 = g1_to_g1_proof_point(g1_proof_point)
            hasher.update(int.to_bytes(x0, 32, "big"))
            hasher.update(int.to_bytes(x1, 32, "big"))
            hasher.update(int.to_bytes(y0, 32, "big"))
            hasher.update(int.to_bytes(y1, 32, "big"))

        ch0 = hasher.digest_reset()

        eta, eta_two = split_challenge(ch0)

        hasher.update(ch0)
        ch0 = hasher.digest_reset()
        eta_three, _ = split_challenge(ch0)

        # print(f"eta: {hex(eta)}")
        # print(f"eta_two: {hex(eta_two)}")
        # print(f"eta_three: {hex(eta_three)}")
        # Round 1 : ch0, lookup_read_counts, lookup_read_tags, w4

        hasher.update(ch0)

        for g1_proof_point in [
            proof.lookup_read_counts,
            proof.lookup_read_tags,
            proof.w4,
        ]:
            x0, x1, y0, y1 = g1_to_g1_proof_point(g1_proof_point)
            hasher.update(int.to_bytes(x0, 32, "big"))
            hasher.update(int.to_bytes(x1, 32, "big"))
            hasher.update(int.to_bytes(y0, 32, "big"))
            hasher.update(int.to_bytes(y1, 32, "big"))

        ch1 = hasher.digest_reset()
        beta, gamma = split_challenge(ch1)

        # Round 2: ch1, lookup_inverses, z_perm

        hasher.update(ch1)

        for g1_proof_point in [proof.lookup_inverses, proof.z_perm]:
            x0, x1, y0, y1 = g1_to_g1_proof_point(g1_proof_point)
            hasher.update(int.to_bytes(x0, 32, "big"))
            hasher.update(int.to_bytes(x1, 32, "big"))
            hasher.update(int.to_bytes(y0, 32, "big"))
            hasher.update(int.to_bytes(y1, 32, "big"))

        ch2 = hasher.digest_reset()

        alphas = [None] * NUMBER_OF_ALPHAS
        alphas[0], alphas[1] = split_challenge(ch2)

        for i in range(1, NUMBER_OF_ALPHAS // 2):
            hasher.update(ch2)
            ch2 = hasher.digest_reset()
            alphas[i * 2], alphas[i * 2 + 1] = split_challenge(ch2)

        if NUMBER_OF_ALPHAS % 2 == 1:
            hasher.update(ch2)
            ch2 = hasher.digest_reset()
            alphas[-1], _ = split_challenge(ch2)

        # Round 3: Gate Challenges :
        ch3 = ch2
        gate_challenges = [None] * CONST_PROOF_SIZE_LOG_N
        for i in range(CONST_PROOF_SIZE_LOG_N):
            hasher.update(ch3)
            ch3 = hasher.digest_reset()
            gate_challenges[i], _ = split_challenge(ch3)

        # print(f"gate_challenges: {[hex(x) for x in gate_challenges]}")
        # print(f"len(gate_challenges): {len(gate_challenges)}")

        # Round 3 and 1/2: Libra challenge
        hasher.update(ch3)

        x0, x1, y0, y1 = g1_to_g1_proof_point(proof.libra_commitments[0])
        hasher.update(int.to_bytes(x0, 32, "big"))
        hasher.update(int.to_bytes(x1, 32, "big"))
        hasher.update(int.to_bytes(y0, 32, "big"))
        hasher.update(int.to_bytes(y1, 32, "big"))

        hasher.update(int.to_bytes(proof.libra_sum, 32, "big"))

        ch3 = hasher.digest_reset()
        libra_challenge, _ = split_challenge(ch3)

        # Round 4: Sumcheck u challenges
        ch4 = ch3
        sum_check_u_challenges = [None] * CONST_PROOF_SIZE_LOG_N

        # print(f"len(sumcheck_univariates): {len(proof.sumcheck_univariates)}")
        # print(
        #     f"len(proof.sumcheck_univariates[0]): {len(proof.sumcheck_univariates[0])}"
        # )

        for i in range(CONST_PROOF_SIZE_LOG_N):
            # Create array of univariate challenges starting with previous challenge
            univariate_chal = [ch4]

            # Add the sumcheck univariates for this round
            for j in range(ZK_BATCHED_RELATION_PARTIAL_LENGTH):
                univariate_chal.append(
                    int.to_bytes(proof.sumcheck_univariates[i][j], 32, "big")
                )

            # Update hasher with all univariate challenges
            for chal in univariate_chal:
                hasher.update(chal)

            # Get next challenge
            ch4 = hasher.digest_reset()

            # Split challenge to get sumcheck challenge
            sum_check_u_challenges[i], _ = split_challenge(ch4)

        # print(f"sum_check_u_challenges: {[hex(x) for x in sum_check_u_challenges]}")
        # print(f"len(sum_check_u_challenges): {len(sum_check_u_challenges)}")

        # Rho challenge :
        hasher.update(ch4)
        for i in range(NUMBER_OF_ENTITIES):
            hasher.update(int.to_bytes(proof.sumcheck_evaluations[i], 32, "big"))

        hasher.update(int.to_bytes(proof.libra_evaluation, 32, "big"))

        for g1_proof_point in [
            proof.libra_commitments[1],
            proof.libra_commitments[2],
            proof.gemini_masking_poly,
        ]:
            x0, x1, y0, y1 = g1_to_g1_proof_point(g1_proof_point)
            hasher.update(int.to_bytes(x0, 32, "big"))
            hasher.update(int.to_bytes(x1, 32, "big"))
            hasher.update(int.to_bytes(y0, 32, "big"))
            hasher.update(int.to_bytes(y1, 32, "big"))

        hasher.update(int.to_bytes(proof.gemini_masking_eval, 32, "big"))

        c5 = hasher.digest_reset()
        rho, _ = split_challenge(c5)

        # print(f"rho: {hex(rho)}")

        # Gemini R :
        hasher.update(c5)
        for i in range(CONST_PROOF_SIZE_LOG_N - 1):
            x0, x1, y0, y1 = g1_to_g1_proof_point(proof.gemini_fold_comms[i])
            hasher.update(int.to_bytes(x0, 32, "big"))
            hasher.update(int.to_bytes(x1, 32, "big"))
            hasher.update(int.to_bytes(y0, 32, "big"))
            hasher.update(int.to_bytes(y1, 32, "big"))

        c6 = hasher.digest_reset()
        gemini_r, _ = split_challenge(c6)

        # print(f"gemini_r: {hex(gemini_r)}")

        # Shplonk Nu :
        hasher.update(c6)
        for i in range(CONST_PROOF_SIZE_LOG_N):
            hasher.update(int.to_bytes(proof.gemini_a_evaluations[i], 32, "big"))

        for i in range(4):
            hasher.update(int.to_bytes(proof.libra_poly_evals[i], 32, "big"))

        c7 = hasher.digest_reset()
        shplonk_nu, _ = split_challenge(c7)

        # print(f"shplonk_nu: {hex(shplonk_nu)}")

        # Shplonk Z :
        hasher.update(c7)
        x0, x1, y0, y1 = g1_to_g1_proof_point(proof.shplonk_q)
        hasher.update(int.to_bytes(x0, 32, "big"))
        hasher.update(int.to_bytes(x1, 32, "big"))
        hasher.update(int.to_bytes(y0, 32, "big"))
        hasher.update(int.to_bytes(y1, 32, "big"))

        c8 = hasher.digest_reset()
        shplonk_z, _ = split_challenge(c8)

        # print(f"shplonk_z: {hex(shplonk_z)}")

        return cls(
            eta=eta,
            etaTwo=eta_two,
            etaThree=eta_three,
            beta=beta,
            gamma=gamma,
            alphas=alphas,
            gate_challenges=gate_challenges,
            libra_challenge=libra_challenge,
            sum_check_u_challenges=sum_check_u_challenges,
            rho=rho,
            gemini_r=gemini_r,
            shplonk_nu=shplonk_nu,
            shplonk_z=shplonk_z,
            public_inputs_delta=None,
        )

    def to_circuit_elements(self, circuit: ModuloCircuit) -> "ZKHonkTranscript":
        return ZKHonkTranscript(
            eta=circuit.write_element(self.eta),
            etaTwo=circuit.write_element(self.etaTwo),
            etaThree=circuit.write_element(self.etaThree),
            beta=circuit.write_element(self.beta),
            gamma=circuit.write_element(self.gamma),
            alphas=circuit.write_elements(self.alphas),
            gate_challenges=circuit.write_elements(self.gate_challenges),
            libra_challenge=circuit.write_element(self.libra_challenge),
            sum_check_u_challenges=circuit.write_elements(self.sum_check_u_challenges),
            rho=circuit.write_element(self.rho),
            gemini_r=circuit.write_element(self.gemini_r),
            shplonk_nu=circuit.write_element(self.shplonk_nu),
            shplonk_z=circuit.write_element(self.shplonk_z),
            public_inputs_delta=None,
        )

    def to_cairo(self) -> str:
        code = "ZKHonkTranscript{\n"
        code += f"    eta: {hex(self.eta)},\n"
        code += f"    eta_two: {hex(self.etaTwo)},\n"
        code += f"    eta_three: {hex(self.etaThree)},\n"
        code += f"    beta: {hex(self.beta)},\n"
        code += f"    gamma: {hex(self.gamma)},\n"
        code += (
            f"    alphas:array![{', '.join([hex(alpha) for alpha in self.alphas])}],\n"
        )
        code += f"    gate_challenges:array![{', '.join([hex(gate_challenge) for gate_challenge in self.gate_challenges])}],\n"
        code += f"    libra_challenge: {hex(self.libra_challenge)},\n"
        code += f"    sum_check_u_challenges:array![{', '.join([hex(sum_check_u_challenge) for sum_check_u_challenge in self.sum_check_u_challenges])}],\n"
        code += f"    rho: {hex(self.rho)},\n"
        code += f"    gemini_r: {hex(self.gemini_r)},\n"
        code += f"    shplonk_nu: {hex(self.shplonk_nu)},\n"
        code += f"    shplonk_z: {hex(self.shplonk_z)},\n"
        code += "}"
        return code


if __name__ == "__main__":
    proof = ZKHonkProof.from_bytes(
        open(
            "hydra/garaga/starknet/honk_contract_generator/examples/proof_ultra_keccak_zk.bin",
            "rb",
        ).read()
    )
    print(proof.to_cairo())
    print(f"\n\n")

    tp = ZKHonkTranscript.from_proof(proof, ProofSystem.UltraKeccakZKHonk)
    print(f"\n\n")
    print(tp.to_cairo())

    print(f"\n\n")

    print(Wire.unused_indexes())

    print(tp)
