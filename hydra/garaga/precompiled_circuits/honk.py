import copy
import math
from dataclasses import dataclass, fields
from enum import Enum, auto

import sha3

import garaga.hints.io as io
import garaga.modulo_circuit_structs as structs
from garaga.definitions import CURVES, CurveID, G1Point, G2Point
from garaga.extension_field_modulo_circuit import ModuloCircuit, ModuloCircuitElement

NUMBER_OF_SUBRELATIONS = 26
NUMBER_OF_ALPHAS = NUMBER_OF_SUBRELATIONS - 1
NUMBER_OF_ENTITIES = 44
BATCHED_RELATION_PARTIAL_LENGTH = 8
CONST_PROOF_SIZE_LOG_N = 28
NUMBER_UNSHIFTED = 35
NUMBER_TO_BE_SHIFTED = 9


MAX_LOG_N = 23  # 2^23 = 8388608


G1_PROOF_POINT_SHIFT = 2**136

G2_POINT_KZG_1 = G2Point.get_nG(CurveID.BN254, 1)
G2_POINT_KZG_2 = G2Point(
    x=(
        0x0118C4D5B837BCC2BC89B5B398B5974E9F5944073B32078B7E231FEC938883B0,
        0x260E01B251F6F1C7E7FF4E580791DEE8EA51D87A358E038B4EFE30FAC09383C1,
    ),
    y=(
        0x22FEBDA3C0C0632A56475B4214E5615E11E6DD3F96E6CEA2854A87D4DACC5E55,
        0x04FC6369F7110FE3D25156C1BB9A72859CF2A04641F99BA4EE413C80DA6A5FE4,
    ),
    curve_id=CurveID.BN254,
)


@dataclass
class HonkProof:
    circuit_size: int
    public_inputs_size: int
    public_inputs_offset: int
    public_inputs: list[int]
    w1: G1Point
    w2: G1Point
    w3: G1Point
    w4: G1Point
    z_perm: G1Point
    lookup_read_counts: G1Point
    lookup_read_tags: G1Point
    lookup_inverses: G1Point
    sumcheck_univariates: list[list[int]]
    sumcheck_evaluations: list[int]
    gemini_fold_comms: list[G1Point]
    gemini_a_evaluations: list[int]
    shplonk_q: G1Point
    kzg_quotient: G1Point

    @property
    def log_circuit_size(self) -> int:
        return int(math.log2(self.circuit_size))

    def __post_init__(self):
        assert len(self.sumcheck_univariates) == CONST_PROOF_SIZE_LOG_N
        assert all(
            len(univariate) == BATCHED_RELATION_PARTIAL_LENGTH
            for univariate in self.sumcheck_univariates
        )
        assert len(self.sumcheck_evaluations) == NUMBER_OF_ENTITIES
        assert len(self.gemini_fold_comms) == CONST_PROOF_SIZE_LOG_N - 1
        assert len(self.gemini_a_evaluations) == CONST_PROOF_SIZE_LOG_N

    @classmethod
    def from_bytes(cls, bytes: bytes) -> "HonkProof":
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

        cursor += 8 * G1_PROOF_POINT_SIZE

        # Parse sumcheck univariates.
        sumcheck_univariates = []
        for i in range(CONST_PROOF_SIZE_LOG_N):
            sumcheck_univariates.append(
                [
                    elements[cursor + i * BATCHED_RELATION_PARTIAL_LENGTH + j]
                    for j in range(BATCHED_RELATION_PARTIAL_LENGTH)
                ]
            )
        cursor += BATCHED_RELATION_PARTIAL_LENGTH * CONST_PROOF_SIZE_LOG_N

        # Parse sumcheck_evaluations
        sumcheck_evaluations = elements[cursor : cursor + NUMBER_OF_ENTITIES]

        cursor += NUMBER_OF_ENTITIES

        # Parse gemini fold comms
        gemini_fold_comms = [
            parse_g1_proof_point(cursor + i * G1_PROOF_POINT_SIZE)
            for i in range(CONST_PROOF_SIZE_LOG_N - 1)
        ]

        cursor += (CONST_PROOF_SIZE_LOG_N - 1) * G1_PROOF_POINT_SIZE

        # Parse gemini a evaluations
        gemini_a_evaluations = elements[cursor : cursor + CONST_PROOF_SIZE_LOG_N]

        cursor += CONST_PROOF_SIZE_LOG_N

        shplonk_q = parse_g1_proof_point(cursor)
        kzg_quotient = parse_g1_proof_point(cursor + G1_PROOF_POINT_SIZE)

        cursor += 2 * G1_PROOF_POINT_SIZE

        assert cursor == len(elements)

        return HonkProof(
            circuit_size=circuit_size,
            public_inputs_size=public_inputs_size,
            public_inputs_offset=public_inputs_offset,
            public_inputs=public_inputs,
            w1=w1,
            w2=w2,
            w3=w3,
            w4=w4,
            z_perm=z_perm,
            lookup_read_counts=lookup_read_counts,
            lookup_read_tags=lookup_read_tags,
            lookup_inverses=lookup_inverses,
            sumcheck_univariates=sumcheck_univariates,
            sumcheck_evaluations=sumcheck_evaluations,
            gemini_fold_comms=gemini_fold_comms,
            gemini_a_evaluations=gemini_a_evaluations,
            shplonk_q=shplonk_q,
            kzg_quotient=kzg_quotient,
        )

    def to_circuit_elements(self, circuit: ModuloCircuit) -> "HonkProof":
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
            z_perm=circuit.write_struct(
                structs.G1PointCircuit.from_G1Point("z_perm", self.z_perm)
            ),
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
            sumcheck_univariates=[
                circuit.write_elements(univariate)
                for univariate in self.sumcheck_univariates
            ],
            sumcheck_evaluations=circuit.write_elements(self.sumcheck_evaluations),
            gemini_fold_comms=[
                circuit.write_struct(
                    structs.G1PointCircuit.from_G1Point(f"gemini_fold_comm_{i}", comm)
                )
                for i, comm in enumerate(self.gemini_fold_comms)
            ],
            gemini_a_evaluations=circuit.write_elements(self.gemini_a_evaluations),
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

        code = f"HonkProof {{\n"
        code += f"circuit_size: {self.circuit_size},\n"
        code += f"public_inputs_size: {self.public_inputs_size},\n"
        code += f"public_inputs_offset: {self.public_inputs_offset},\n"
        code += f"public_inputs: {format_array(self.public_inputs, span=True)},\n"
        code += f"w1: {g1_to_g1point256(self.w1)},\n"
        code += f"w2: {g1_to_g1point256(self.w2)},\n"
        code += f"w3: {g1_to_g1point256(self.w3)},\n"
        code += f"w4: {g1_to_g1point256(self.w4)},\n"
        code += f"z_perm: {g1_to_g1point256(self.z_perm)},\n"
        code += f"lookup_read_counts: {g1_to_g1point256(self.lookup_read_counts)},\n"
        code += f"lookup_read_tags: {g1_to_g1point256(self.lookup_read_tags)},\n"
        code += f"lookup_inverses: {g1_to_g1point256(self.lookup_inverses)},\n"

        # Flatten sumcheck_univariates array
        code += f"sumcheck_univariates: {format_array(io.flatten(self.sumcheck_univariates)[:self.log_circuit_size * BATCHED_RELATION_PARTIAL_LENGTH], span=True)},\n"

        code += f"sumcheck_evaluations: {format_array(self.sumcheck_evaluations, span=True)},\n"
        code += f"gemini_fold_comms: array![{', '.join(g1_to_g1point256(comm) for comm in self.gemini_fold_comms[:self.log_circuit_size - 1])}].span(),\n"
        code += f"gemini_a_evaluations: {format_array(self.gemini_a_evaluations[:self.log_circuit_size], span=True)},\n"
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
        cd.extend(serialize_G1Point256(self.z_perm))
        cd.extend(serialize_G1Point256(self.lookup_read_counts))
        cd.extend(serialize_G1Point256(self.lookup_read_tags))
        cd.extend(serialize_G1Point256(self.lookup_inverses))
        cd.extend(
            io.bigint_split_array(
                x=io.flatten(self.sumcheck_univariates)[
                    : BATCHED_RELATION_PARTIAL_LENGTH * self.log_circuit_size
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
        cd.extend(serialize_G1Point256(self.shplonk_q))
        cd.extend(serialize_G1Point256(self.kzg_quotient))

        return cd


@dataclass
class HonkVk:
    name: str
    circuit_size: int
    log_circuit_size: int
    public_inputs_size: int
    public_inputs_offset: int
    qm: G1Point
    qc: G1Point
    ql: G1Point
    qr: G1Point
    qo: G1Point
    q4: G1Point
    qArith: G1Point
    qDeltaRange: G1Point
    qElliptic: G1Point
    qAux: G1Point
    qLookup: G1Point
    qPoseidon2External: G1Point
    qPoseidon2Internal: G1Point
    s1: G1Point
    s2: G1Point
    s3: G1Point
    s4: G1Point
    id1: G1Point
    id2: G1Point
    id3: G1Point
    id4: G1Point
    t1: G1Point
    t2: G1Point
    t3: G1Point
    t4: G1Point
    lagrange_first: G1Point
    lagrange_last: G1Point

    def __repr__(self) -> str:
        # Print all fields line by line :
        return "\n".join(
            f"{field.name}: {getattr(self, field.name).__repr__()}"
            for field in fields(self)
        )

    # def __str__(self) -> str:
    #     return self.__repr__()

    @classmethod
    def from_bytes(cls, bytes: bytes) -> "HonkVk":
        circuit_size = int.from_bytes(bytes[0:8], "big")
        log_circuit_size = int.from_bytes(bytes[8:16], "big")
        public_inputs_size = int.from_bytes(bytes[16:24], "big")
        public_inputs_offset = int.from_bytes(bytes[24:32], "big")

        cursor = 32

        rest = bytes[cursor:]
        assert len(rest) % 32 == 0

        # print(f"circuit_size: {circuit_size}")
        # print(f"log_circuit_size: {log_circuit_size}")
        # print(f"public_inputs_size: {public_inputs_size}")

        # Get all fields that are G1Points from the dataclass
        g1_fields = [
            field.name
            for field in fields(cls)
            if field.type == G1Point and field.name != "name"
        ]

        # print(f"g1_fields: {g1_fields}")

        # Parse all G1Points into a dictionary
        points = {}
        for field_name in g1_fields:
            x = int.from_bytes(bytes[cursor : cursor + 32], "big")
            y = int.from_bytes(bytes[cursor + 32 : cursor + 64], "big")
            points[field_name] = G1Point(x=x, y=y, curve_id=CurveID.BN254)
            cursor += 64
        # print(f"points: {points}")
        # Create instance with all parsed values
        return cls(
            name="",
            circuit_size=circuit_size,
            log_circuit_size=log_circuit_size,
            public_inputs_size=public_inputs_size,
            public_inputs_offset=public_inputs_offset,
            **points,
        )

    def serialize_to_cairo(self, name: str = "vk") -> str:
        code = f"pub const {name}: HonkVk = HonkVk {{\n"
        code += f"circuit_size: {self.circuit_size},\n"
        code += f"log_circuit_size: {self.log_circuit_size},\n"
        code += f"public_inputs_size: {self.public_inputs_size},\n"
        code += f"public_inputs_offset: {self.public_inputs_offset},\n"

        g1_points = [
            field.name
            for field in fields(self)
            if field.type == G1Point and field.name != "name"
        ]
        for field_name in g1_points:
            code += f"{field_name}: {getattr(self, field_name).serialize_to_cairo(name=field_name, raw=True)},\n"
        code += "};"
        return code

    def to_circuit_elements(self, circuit: ModuloCircuit) -> "HonkVk":
        return HonkVk(
            name=self.name,
            circuit_size=self.circuit_size,
            log_circuit_size=self.log_circuit_size,
            public_inputs_size=self.public_inputs_size,
            public_inputs_offset=circuit.write_element(self.public_inputs_offset),
            **{
                field.name: circuit.write_struct(
                    structs.G1PointCircuit.from_G1Point(
                        field.name, getattr(self, field.name)
                    )
                )
                for field in fields(self)
                if field.type == G1Point and field.name != "name"
            },
        )


class Sha3Transcript:
    def __init__(self):
        self.hasher = sha3.keccak_256()

    def digest_reset(self) -> bytes:
        res = self.hasher.digest()
        res_int = int.from_bytes(res, "big")
        res_mod = res_int % CURVES[CurveID.GRUMPKIN.value].p
        res_bytes = res_mod.to_bytes(32, "big")

        self.hasher = sha3.keccak_256()
        return res_bytes

    def update(self, data: bytes):
        self.hasher.update(data)


@dataclass
class HonkTranscript:
    eta: int | ModuloCircuitElement
    etaTwo: int | ModuloCircuitElement
    etaThree: int | ModuloCircuitElement
    beta: int | ModuloCircuitElement
    gamma: int | ModuloCircuitElement
    alphas: list[int | ModuloCircuitElement]
    gate_challenges: list[int | ModuloCircuitElement]
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
        self.hasher = sha3.keccak_256()

    @classmethod
    def from_proof(cls, proof: HonkProof) -> "HonkTranscript":
        def g1_to_g1_proof_point(g1_proof_point: G1Point) -> tuple[int, int, int, int]:
            x_high, x_low = divmod(g1_proof_point.x, G1_PROOF_POINT_SHIFT)
            y_high, y_low = divmod(g1_proof_point.y, G1_PROOF_POINT_SHIFT)
            return (x_low, x_high, y_low, y_high)

        def split_challenge(ch: bytes) -> tuple[int, int]:
            ch_int = int.from_bytes(ch, "big")
            high_128, low_128 = divmod(ch_int, 2**128)
            return (low_128, high_128)

        # Round 0 : circuit_size, public_inputs_size, public_input_offset, [public_inputs], w1, w2, w3
        FR = CURVES[CurveID.GRUMPKIN.value].p

        hasher = Sha3Transcript()

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
            for j in range(BATCHED_RELATION_PARTIAL_LENGTH):
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
            sum_check_u_challenges=sum_check_u_challenges,
            rho=rho,
            gemini_r=gemini_r,
            shplonk_nu=shplonk_nu,
            shplonk_z=shplonk_z,
            public_inputs_delta=None,
        )

    def to_circuit_elements(self, circuit: ModuloCircuit) -> "HonkTranscript":
        return HonkTranscript(
            eta=circuit.write_element(self.eta),
            etaTwo=circuit.write_element(self.etaTwo),
            etaThree=circuit.write_element(self.etaThree),
            beta=circuit.write_element(self.beta),
            gamma=circuit.write_element(self.gamma),
            alphas=circuit.write_elements(self.alphas),
            gate_challenges=circuit.write_elements(self.gate_challenges),
            sum_check_u_challenges=circuit.write_elements(self.sum_check_u_challenges),
            rho=circuit.write_element(self.rho),
            gemini_r=circuit.write_element(self.gemini_r),
            shplonk_nu=circuit.write_element(self.shplonk_nu),
            shplonk_z=circuit.write_element(self.shplonk_z),
            public_inputs_delta=None,
        )

    def to_cairo(self) -> str:
        code = "HonkTranscript{\n"
        code += f"    eta: {hex(self.eta)},\n"
        code += f"    eta_two: {hex(self.etaTwo)},\n"
        code += f"    eta_three: {hex(self.etaThree)},\n"
        code += f"    beta: {hex(self.beta)},\n"
        code += f"    gamma: {hex(self.gamma)},\n"
        code += (
            f"    alphas:array![{', '.join([hex(alpha) for alpha in self.alphas])}],\n"
        )
        code += f"    gate_challenges:array![{', '.join([hex(gate_challenge) for gate_challenge in self.gate_challenges])}],\n"
        code += f"    sum_check_u_challenges:array![{', '.join([hex(sum_check_u_challenge) for sum_check_u_challenge in self.sum_check_u_challenges])}],\n"
        code += f"    rho: {hex(self.rho)},\n"
        code += f"    gemini_r: {hex(self.gemini_r)},\n"
        code += f"    shplonk_nu: {hex(self.shplonk_nu)},\n"
        code += f"    shplonk_z: {hex(self.shplonk_z)},\n"
        code += "}"
        return code


class HonkVerifierCircuits(ModuloCircuit):
    def __init__(
        self,
        name: str,
        log_n: int,
        curve_id: int = CurveID.GRUMPKIN.value,
        compilation_mode: int = 1,
    ):
        super().__init__(
            name=name,
            curve_id=curve_id,
            compilation_mode=compilation_mode,
        )
        self.log_n = log_n

    def verify_sanity(
        self, proof: HonkProof, transcript: HonkTranscript, vk: HonkVk
    ) -> bool:

        transcript.public_inputs_delta = self.compute_public_input_delta(
            proof.public_inputs,
            transcript.beta,
            transcript.gamma,
            proof.circuit_size,
            transcript.public_inputs_offset,
        )

        rlc, check = self.verify_sum_check(
            proof.sumcheck_univariates, transcript, proof.circuit_size, transcript.beta
        )

        # check_spl = self.verify_shplemini(proof, vk, transcript)

        assert rlc.value == 0
        assert check.value == 0

    def prepare_shplemini_msm(
        self, proof: HonkProof, vk: HonkVk, transcript: HonkTranscript
    ) -> ModuloCircuitElement:
        pass

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
        # Parameters:
        # - public_inputs : x₀, ..., xₘ₋₁ public inputs to the circuit
        # - beta: Random linear-combination term to combine both (wʲ, IDʲ) and (wʲ, σʲ)
        # - gamma: Schwartz-Zippel random evaluation to ensure ∏ᵢ (γ + Sᵢ) = ∏ᵢ (γ + Tᵢ)
        # - domain_size: Total number of rows required for the circuit (power of 2)
        # - offset: Extent to which public inputs are offset from the 0th index in the wire polynomials,
        #           for example, due to inclusion of a leading zero row or Goblin style ECC op gates
        #           at the top of the execution trace.
        # Returns: ModuloCircuitElement representing the public input Δ
        # Note:
        # - domain_size : part of vk.
        # - offset : proof pub input offset
        """
        assert len(public_inputs) > 0
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

        for i, pub_input in enumerate(public_inputs):
            num = self.mul(num, self.add(num_acc, pub_input))
            den = self.mul(den, self.add(den_acc, pub_input))

            # skip last round (unused otherwise)
            if i != len(public_inputs) - 1:
                num_acc = self.add(num_acc, beta)
                den_acc = self.sub(den_acc, beta)

        return self.div(num, den)

    def verify_sum_check(
        self,
        sumcheck_univariates: list[list[ModuloCircuitElement]],
        sumcheck_evaluations: list[ModuloCircuitElement],
        beta: ModuloCircuitElement,
        gamma: ModuloCircuitElement,
        public_inputs_delta: ModuloCircuitElement,
        eta: ModuloCircuitElement,
        eta_two: ModuloCircuitElement,
        eta_three: ModuloCircuitElement,
        sum_check_u_challenges: list[ModuloCircuitElement],
        gate_challenges: list[ModuloCircuitElement],
        alphas: list[ModuloCircuitElement],
        log_n: int,
        base_rlc: ModuloCircuitElement,
    ) -> ModuloCircuitElement:
        """
        We will add an extra challenge base_rlc to do a Sumcheck RLC since
        Cairo1 doesn't support assert_eq inside circuits (unlike Cairo0).
        """

        pow_partial_evaluation = self.set_or_get_constant(1)
        round_target = self.set_or_get_constant(0)
        check_rlc = self.set_or_get_constant(0)

        rlc_coeff = base_rlc
        for i, round in enumerate(range(log_n)):
            round_univariate: list[ModuloCircuitElement] = sumcheck_univariates[round]
            total_sum = self.add(round_univariate[0], round_univariate[1])
            check_rlc = self.add(
                check_rlc, self.mul(self.sub(total_sum, round_target), rlc_coeff)
            )
            # Skip at the last round
            if i != log_n - 1:
                rlc_coeff = self.mul(rlc_coeff, base_rlc)

            round_challenge = sum_check_u_challenges[round]
            round_target = self.compute_next_target_sum(
                round_univariate, round_challenge
            )
            pow_partial_evaluation = self.partially_evaluate_pow(
                gate_challenges,
                pow_partial_evaluation,
                round_challenge,
                round,
            )
        # Last Round
        evaluations = self.accumulate_relation_evaluations(
            sumcheck_evaluations,
            beta,
            gamma,
            public_inputs_delta,
            eta,
            eta_two,
            eta_three,
            pow_partial_evaluation,
        )

        assert (
            len(evaluations) == NUMBER_OF_SUBRELATIONS
        ), f"Expected {NUMBER_OF_SUBRELATIONS}, got {len(evaluations)}"
        assert len(alphas) == NUMBER_OF_ALPHAS

        grand_honk_relation_sum = evaluations[0]
        for i, evaluation in enumerate(evaluations[1:]):
            grand_honk_relation_sum = self.add(
                grand_honk_relation_sum,
                self.mul(evaluation, alphas[i]),
            )

        check = self.sub(grand_honk_relation_sum, round_target)

        return check_rlc, check

    def compute_next_target_sum(
        self,
        round_univariate: list[ModuloCircuitElement],
        challenge: ModuloCircuitElement,
    ) -> ModuloCircuitElement:

        BARYCENTRIC_LAGRANGE_DENOMINATORS = [
            self.set_or_get_constant(
                0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFEC51
            ),
            self.set_or_get_constant(
                0x00000000000000000000000000000000000000000000000000000000000002D0
            ),
            self.set_or_get_constant(
                0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFFF11
            ),
            self.set_or_get_constant(
                0x0000000000000000000000000000000000000000000000000000000000000090
            ),
            self.set_or_get_constant(
                0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFFF71
            ),
            self.set_or_get_constant(
                0x00000000000000000000000000000000000000000000000000000000000000F0
            ),
            self.set_or_get_constant(
                0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFFD31
            ),
            self.set_or_get_constant(
                0x00000000000000000000000000000000000000000000000000000000000013B0
            ),
        ]

        assert len(BARYCENTRIC_LAGRANGE_DENOMINATORS) == BATCHED_RELATION_PARTIAL_LENGTH

        BARYCENTRIC_DOMAIN = [
            self.set_or_get_constant(i) for i in range(BATCHED_RELATION_PARTIAL_LENGTH)
        ]

        numerator = self.set_or_get_constant(1)
        target_sum = self.set_or_get_constant(0)

        for i in range(BATCHED_RELATION_PARTIAL_LENGTH):
            # Update numerator
            numerator = self.mul(
                numerator, self.sub(challenge, self.set_or_get_constant(i))
            )

            # Calculate inverse of the denominator
            inv = self.inv(
                self.mul(
                    BARYCENTRIC_LAGRANGE_DENOMINATORS[i],
                    self.sub(challenge, BARYCENTRIC_DOMAIN[i]),
                )
            )

            # Calculate term and update target_sum
            term = round_univariate[i]
            term = self.mul(term, inv)
            target_sum = self.add(target_sum, term)

        # Scale the sum by the value of B(x)
        target_sum = self.mul(target_sum, numerator)

        return target_sum

    def partially_evaluate_pow(
        self,
        gate_challenges: list[ModuloCircuitElement],
        current_evaluation: ModuloCircuitElement,
        challenge: ModuloCircuitElement,
        round: int,
    ) -> ModuloCircuitElement:
        """
        Univariate evaluation of the monomial ((1-X_l) + X_l.B_l) at the challenge point X_l=u_l
        """
        univariate_eval = self.add(
            self.set_or_get_constant(1),
            self.mul(
                challenge, self.sub(gate_challenges[round], self.set_or_get_constant(1))
            ),
        )
        new_evaluation = self.mul(current_evaluation, univariate_eval)

        return new_evaluation

    def accumulate_relation_evaluations(
        self,
        sumcheck_evaluations: list[list[ModuloCircuitElement]],
        beta: ModuloCircuitElement,
        gamma: ModuloCircuitElement,
        public_inputs_delta: ModuloCircuitElement,
        eta: ModuloCircuitElement,
        eta_two: ModuloCircuitElement,
        eta_three: ModuloCircuitElement,
        pow_partial_evaluation: ModuloCircuitElement,
    ) -> list[ModuloCircuitElement]:

        domain_separator = pow_partial_evaluation

        assert len(sumcheck_evaluations) == len(
            Wire
        ), f"Expected {len(Wire)}, got {len(sumcheck_evaluations)}"

        evaluations = [self.set_or_get_constant(0)] * NUMBER_OF_SUBRELATIONS

        evaluations = self.accumulate_arithmetic_relation(
            sumcheck_evaluations, evaluations, pow_partial_evaluation
        )
        evaluations = self.accumulate_permutation_relation(
            sumcheck_evaluations,
            evaluations,
            beta,
            gamma,
            public_inputs_delta,
            domain_separator,
        )
        evaluations = self.accumulate_log_derivative_lookup_relation(
            sumcheck_evaluations,
            evaluations,
            gamma,
            eta,
            eta_two,
            eta_three,
            domain_separator,
        )
        evaluations = self.accumulate_delta_range_relation(
            sumcheck_evaluations, evaluations, domain_separator
        )
        evaluations = self.accumulate_elliptic_relation(
            sumcheck_evaluations, evaluations, domain_separator
        )

        evaluations = self.accumulate_auxillary_relation(
            sumcheck_evaluations,
            evaluations,
            eta,
            eta_two,
            eta_three,
            domain_separator,
        )

        evaluations = self.accumulate_poseidon_external_relation(
            sumcheck_evaluations, evaluations, domain_separator
        )

        evaluations = self.accumulate_poseidon_internal_relation(
            sumcheck_evaluations, evaluations, domain_separator
        )

        return evaluations

    def accumulate_arithmetic_relation(
        self,
        purported_evaluations: list[ModuloCircuitElement],
        evaluations: list[ModuloCircuitElement],
        domain_separator: ModuloCircuitElement,
    ) -> ModuloCircuitElement:

        p = purported_evaluations
        q_arith = p[Wire.Q_ARITH]
        # Relation 0

        neg_half = self.set_or_get_constant(self.field(-2).__inv__())

        accum = self.product(
            [
                self.sub(q_arith, self.set_or_get_constant(3)),
                p[Wire.Q_M],
                p[Wire.W_R],
                p[Wire.W_L],
                neg_half,
            ]
        )
        accum = self.sum(
            [
                accum,
                self.mul(p[Wire.Q_L], p[Wire.W_L]),
                self.mul(p[Wire.Q_R], p[Wire.W_R]),
                self.mul(p[Wire.Q_O], p[Wire.W_O]),
                self.mul(p[Wire.Q_4], p[Wire.W_4]),
                p[Wire.Q_C],
            ]
        )
        accum = self.add(
            accum,
            self.mul(self.sub(q_arith, self.set_or_get_constant(1)), p[Wire.W_4_SHIFT]),
        )
        accum = self.product([accum, q_arith, domain_separator])

        evaluations[0] = accum

        # Relation 1
        accum = self.sum([p[Wire.W_L], p[Wire.W_4], p[Wire.Q_M]])
        accum = self.sub(accum, p[Wire.W_L_SHIFT])
        accum = self.mul(accum, self.sub(q_arith, self.set_or_get_constant(2)))
        accum = self.mul(accum, self.sub(q_arith, self.set_or_get_constant(1)))
        accum = self.mul(accum, q_arith)
        accum = self.mul(accum, domain_separator)

        evaluations[1] = accum

        return evaluations

    def accumulate_permutation_relation(
        self,
        purported_evaluations: list[ModuloCircuitElement],
        evaluations: list[ModuloCircuitElement],
        beta: ModuloCircuitElement,
        gamma: ModuloCircuitElement,
        public_inputs_delta: ModuloCircuitElement,
        domain_separator: ModuloCircuitElement,
    ) -> list[ModuloCircuitElement]:
        p = purported_evaluations

        # Grand Product Numerator
        n = self.sum([p[Wire.W_L], self.mul(p[Wire.ID_1], beta), gamma])
        n = self.mul(n, self.sum([p[Wire.W_R], self.mul(p[Wire.ID_2], beta), gamma]))
        n = self.mul(n, self.sum([p[Wire.W_O], self.mul(p[Wire.ID_3], beta), gamma]))
        n = self.mul(n, self.sum([p[Wire.W_4], self.mul(p[Wire.ID_4], beta), gamma]))

        # Grand Product Denominator
        d = self.sum([p[Wire.W_L], self.mul(p[Wire.SIGMA_1], beta), gamma])
        d = self.mul(d, self.sum([p[Wire.W_R], self.mul(p[Wire.SIGMA_2], beta), gamma]))
        d = self.mul(d, self.sum([p[Wire.W_O], self.mul(p[Wire.SIGMA_3], beta), gamma]))
        d = self.mul(d, self.sum([p[Wire.W_4], self.mul(p[Wire.SIGMA_4], beta), gamma]))

        acc = self.mul(n, self.add(p[Wire.Z_PERM], p[Wire.LAGRANGE_FIRST]))
        acc = self.sub(
            acc,
            self.mul(
                d,
                self.add(
                    p[Wire.Z_PERM_SHIFT],
                    self.mul(p[Wire.LAGRANGE_LAST], public_inputs_delta),
                ),
            ),
        )
        evaluations[2] = self.mul(acc, domain_separator)

        evaluations[3] = self.product(
            [p[Wire.LAGRANGE_LAST], p[Wire.Z_PERM_SHIFT], domain_separator]
        )

        return evaluations

    def accumulate_log_derivative_lookup_relation(
        self,
        purported_evaluations: list[ModuloCircuitElement],
        evaluations: list[ModuloCircuitElement],
        gamma: ModuloCircuitElement,
        eta: ModuloCircuitElement,
        eta_two: ModuloCircuitElement,
        eta_three: ModuloCircuitElement,
        domain_separator: ModuloCircuitElement,
    ) -> list[ModuloCircuitElement]:
        p = purported_evaluations
        write_term = self.sum(
            [
                p[Wire.TABLE_1],
                gamma,
                self.mul(p[Wire.TABLE_2], eta),
                self.mul(p[Wire.TABLE_3], eta_two),
                self.mul(p[Wire.TABLE_4], eta_three),
            ]
        )

        derived_entry_1 = self.sum(
            [p[Wire.W_L], gamma, self.mul(p[Wire.Q_R], p[Wire.W_L_SHIFT])]
        )
        derived_entry_2 = self.add(
            p[Wire.W_R], self.mul(p[Wire.Q_M], p[Wire.W_R_SHIFT])
        )
        derived_entry_3 = self.add(
            p[Wire.W_O], self.mul(p[Wire.Q_C], p[Wire.W_O_SHIFT])
        )
        read_term = self.sum(
            [
                derived_entry_1,
                self.mul(derived_entry_2, eta),
                self.mul(derived_entry_3, eta_two),
                self.mul(p[Wire.Q_O], eta_three),
            ]
        )

        read_inverse = self.mul(p[Wire.LOOKUP_INVERSES], write_term)
        write_inverse = self.mul(p[Wire.LOOKUP_INVERSES], read_term)

        inverse_exists_xor = self.sub(
            self.add(p[Wire.LOOKUP_READ_TAGS], p[Wire.Q_LOOKUP]),
            self.mul(p[Wire.LOOKUP_READ_TAGS], p[Wire.Q_LOOKUP]),
        )

        accumulator_none = self.product(
            [read_term, write_term, p[Wire.LOOKUP_INVERSES]]
        )
        accumulator_none = self.sub(accumulator_none, inverse_exists_xor)
        accumulator_none = self.mul(accumulator_none, domain_separator)

        accumulator_one = self.mul(p[Wire.Q_LOOKUP], read_inverse)
        accumulator_one = self.sub(
            accumulator_one, self.mul(p[Wire.LOOKUP_READ_COUNTS], write_inverse)
        )

        evaluations[4] = accumulator_none
        evaluations[5] = accumulator_one

        return evaluations

    def accumulate_delta_range_relation(
        self,
        purported_evaluations: list[ModuloCircuitElement],
        evaluations: list[ModuloCircuitElement],
        domain_separator: ModuloCircuitElement,
    ) -> list[ModuloCircuitElement]:

        p = purported_evaluations
        delta_1 = self.sub(p[Wire.W_R], p[Wire.W_L])
        delta_2 = self.sub(p[Wire.W_O], p[Wire.W_R])
        delta_3 = self.sub(p[Wire.W_4], p[Wire.W_O])
        delta_4 = self.sub(p[Wire.W_L_SHIFT], p[Wire.W_4])

        # Contributions 6 - 7 - 8 - 9.
        for i, delta in enumerate([delta_1, delta_2, delta_3, delta_4]):
            evaluations[6 + i] = self.product(
                [
                    delta,
                    self.add(delta, self.set_or_get_constant(-1)),
                    self.add(delta, self.set_or_get_constant(-2)),
                    self.add(delta, self.set_or_get_constant(-3)),
                    p[Wire.Q_RANGE],
                    domain_separator,
                ]
            )
        return evaluations

    def accumulate_elliptic_relation(
        self,
        purported_evaluations: list[ModuloCircuitElement],
        evaluations: list[ModuloCircuitElement],
        domain_separator: ModuloCircuitElement,
    ):
        p = purported_evaluations
        # TODO : Do not use arithmetic circuit
        # Split in two and use Q_is_double as if-else condition in Cairo.

        x1 = p[Wire.W_R]
        y1 = p[Wire.W_O]
        x2 = p[Wire.W_L_SHIFT]
        y2 = p[Wire.W_4_SHIFT]
        y3 = p[Wire.W_O_SHIFT]
        x3 = p[Wire.W_R_SHIFT]
        q_sign = p[Wire.Q_L]
        q_is_double = p[Wire.Q_M]

        x_diff = self.sub(x2, x1)
        y1_sqr = self.mul(y1, y1)

        y2_sqr = self.mul(y2, y2)
        y1y2 = self.product([y1, y2, q_sign])
        x_add_identity = self.sum([x3, x2, x1])
        x_add_identity = self.product([x_add_identity, x_diff, x_diff])
        x_add_identity = self.sub(x_add_identity, y2_sqr)
        x_add_identity = self.sub(x_add_identity, y1_sqr)
        x_add_identity = self.add(x_add_identity, y1y2)
        x_add_identity = self.add(x_add_identity, y1y2)

        q_is_add = self.sub(self.set_or_get_constant(1), q_is_double)

        # Point addition, x-coordinate check
        evaluations[10] = self.product(
            [
                x_add_identity,
                domain_separator,
                p[Wire.Q_ELLIPTIC],
                q_is_add,
            ]
        )

        # Point addition, y-coordinate check
        y1_plus_y3 = self.add(y1, y3)
        y_diff = self.sub(self.mul(y2, q_sign), y1)
        y_add_identity = self.add(
            self.mul(y1_plus_y3, x_diff),
            self.mul(self.sub(x3, x1), y_diff),
        )
        evaluations[11] = self.product(
            [
                y_add_identity,
                domain_separator,
                p[Wire.Q_ELLIPTIC],
                q_is_add,
            ]
        )

        # Point doubling, x-coordinate check

        GRUMPKIN_CURVE_B_PARAMETER_NEGATED = self.set_or_get_constant(17)  # - (- 17)
        x_pow_4 = self.mul(self.add(y1_sqr, GRUMPKIN_CURVE_B_PARAMETER_NEGATED), x1)
        y1_sqr_mul_4 = self.add(y1_sqr, y1_sqr)
        y1_sqr_mul_4 = self.add(y1_sqr_mul_4, y1_sqr_mul_4)

        x1_pow_4_mul_9 = self.mul(x_pow_4, self.set_or_get_constant(9))

        x_double_identity = self.sub(
            self.mul(self.sum([x3, x1, x1]), y1_sqr_mul_4), x1_pow_4_mul_9
        )

        evaluations[10] = self.add(
            evaluations[10],
            self.product(
                [x_double_identity, domain_separator, p[Wire.Q_ELLIPTIC], q_is_double]
            ),
        )

        # Point doubling, y-coordinate check

        x1_sqr_mul_3 = self.mul(self.sum([x1, x1, x1]), x1)
        y_double_identity = self.sub(
            self.mul(x1_sqr_mul_3, self.sub(x1, x3)),
            self.mul(self.add(y1, y1), self.add(y1, y3)),
        )

        evaluations[11] = self.add(
            evaluations[11],
            self.product(
                [y_double_identity, domain_separator, p[Wire.Q_ELLIPTIC], q_is_double]
            ),
        )

        return evaluations

    def accumulate_auxillary_relation(
        self,
        purported_evaluations: list[ModuloCircuitElement],
        evaluations: list[ModuloCircuitElement],
        eta: ModuloCircuitElement,
        eta_two: ModuloCircuitElement,
        eta_three: ModuloCircuitElement,
        domain_separator: ModuloCircuitElement,
    ):
        p = purported_evaluations
        limb_size = self.set_or_get_constant(2**68)
        sub_limb_shift = self.set_or_get_constant(2**14)

        limb_subproduct = self.add(
            self.mul(p[Wire.W_L], p[Wire.W_R_SHIFT]),
            self.mul(p[Wire.W_L_SHIFT], p[Wire.W_R]),
        )

        non_native_field_gate_2 = self.sub(
            self.add(
                self.mul(p[Wire.W_L], p[Wire.W_4]),
                self.mul(p[Wire.W_R], p[Wire.W_O]),
            ),
            p[Wire.W_O_SHIFT],
        )
        non_native_field_gate_2 = self.mul(non_native_field_gate_2, limb_size)
        non_native_field_gate_2 = self.sub(non_native_field_gate_2, p[Wire.W_4_SHIFT])
        non_native_field_gate_2 = self.add(non_native_field_gate_2, limb_subproduct)
        non_native_field_gate_2 = self.mul(non_native_field_gate_2, p[Wire.Q_4])

        limb_subproduct = self.mul(limb_subproduct, limb_size)
        limb_subproduct = self.add(
            limb_subproduct,
            self.mul(p[Wire.W_L_SHIFT], p[Wire.W_R_SHIFT]),
        )

        non_native_field_gate_1 = limb_subproduct
        non_native_field_gate_1 = self.sub(
            non_native_field_gate_1,
            self.add(p[Wire.W_O], p[Wire.W_4]),
        )
        non_native_field_gate_1 = self.mul(non_native_field_gate_1, p[Wire.Q_O])

        non_native_field_gate_3 = limb_subproduct
        non_native_field_gate_3 = self.add(non_native_field_gate_3, p[Wire.W_4])
        non_native_field_gate_3 = self.sub(
            non_native_field_gate_3,
            self.add(p[Wire.W_O_SHIFT], p[Wire.W_4_SHIFT]),
        )
        non_native_field_gate_3 = self.mul(non_native_field_gate_3, p[Wire.Q_M])

        non_native_field_identity = self.sum(
            [non_native_field_gate_1, non_native_field_gate_2, non_native_field_gate_3]
        )
        non_native_field_identity = self.mul(non_native_field_identity, p[Wire.Q_R])

        limb_accumulator_1 = self.mul(p[Wire.W_R_SHIFT], sub_limb_shift)
        limb_accumulator_1 = self.add(limb_accumulator_1, p[Wire.W_L_SHIFT])
        limb_accumulator_1 = self.mul(limb_accumulator_1, sub_limb_shift)
        limb_accumulator_1 = self.add(limb_accumulator_1, p[Wire.W_O])
        limb_accumulator_1 = self.mul(limb_accumulator_1, sub_limb_shift)
        limb_accumulator_1 = self.add(limb_accumulator_1, p[Wire.W_R])
        limb_accumulator_1 = self.mul(limb_accumulator_1, sub_limb_shift)
        limb_accumulator_1 = self.add(limb_accumulator_1, p[Wire.W_L])
        limb_accumulator_1 = self.sub(limb_accumulator_1, p[Wire.W_4])
        limb_accumulator_1 = self.mul(limb_accumulator_1, p[Wire.Q_4])

        limb_accumulator_2 = self.mul(p[Wire.W_O_SHIFT], sub_limb_shift)
        limb_accumulator_2 = self.add(limb_accumulator_2, p[Wire.W_R_SHIFT])
        limb_accumulator_2 = self.mul(limb_accumulator_2, sub_limb_shift)
        limb_accumulator_2 = self.add(limb_accumulator_2, p[Wire.W_L_SHIFT])
        limb_accumulator_2 = self.mul(limb_accumulator_2, sub_limb_shift)
        limb_accumulator_2 = self.add(limb_accumulator_2, p[Wire.W_4])
        limb_accumulator_2 = self.mul(limb_accumulator_2, sub_limb_shift)
        limb_accumulator_2 = self.add(limb_accumulator_2, p[Wire.W_O])
        limb_accumulator_2 = self.sub(limb_accumulator_2, p[Wire.W_4_SHIFT])
        limb_accumulator_2 = self.mul(limb_accumulator_2, p[Wire.Q_M])

        #         Fr limb_accumulator_identity = ap.limb_accumulator_1 + ap.limb_accumulator_2;
        # limb_accumulator_identity = limb_accumulator_identity * wire(p, WIRE.Q_O); //  deg 3

        limb_accumulator_identity = self.add(limb_accumulator_1, limb_accumulator_2)
        limb_accumulator_identity = self.mul(limb_accumulator_identity, p[Wire.Q_O])

        memory_record_check = self.sum(
            [
                self.mul(p[Wire.W_O], eta_three),
                self.mul(p[Wire.W_R], eta_two),
                self.mul(p[Wire.W_L], eta),
            ]
        )
        memory_record_check = self.add(memory_record_check, p[Wire.Q_C])
        partial_record_check = copy.deepcopy(memory_record_check)
        memory_record_check = self.sub(memory_record_check, p[Wire.W_4])

        index_delta = self.sub(p[Wire.W_L_SHIFT], p[Wire.W_L])
        record_delta = self.sub(p[Wire.W_4_SHIFT], p[Wire.W_4])
        index_is_monotonically_increasing = self.sub(
            self.mul(index_delta, index_delta), index_delta
        )

        adjacent_values_match_if_adjacent_indices_match = self.mul(
            self.add(
                self.neg(index_delta),
                self.set_or_get_constant(1),
            ),
            record_delta,
        )

        q_l_qr = self.mul(p[Wire.Q_L], p[Wire.Q_R])
        common_product = self.product([q_l_qr, p[Wire.Q_AUX], domain_separator])

        evaluations[13] = self.mul(
            adjacent_values_match_if_adjacent_indices_match, common_product
        )

        evaluations[14] = self.mul(index_is_monotonically_increasing, common_product)

        ROM_consistency_check_identity = self.mul(memory_record_check, q_l_qr)

        access_type = self.sub(p[Wire.W_4], partial_record_check)
        access_check = self.sub(self.mul(access_type, access_type), access_type)
        next_gate_access_type = self.sum(
            [
                self.mul(p[Wire.W_O_SHIFT], eta_three),
                self.mul(p[Wire.W_R_SHIFT], eta_two),
                self.mul(p[Wire.W_L_SHIFT], eta),
            ]
        )
        next_gate_access_type = self.sub(p[Wire.W_4_SHIFT], next_gate_access_type)

        value_delta = self.sub(p[Wire.W_O_SHIFT], p[Wire.W_O])

        adjacent_values_match_if_adjacent_indices_match_and_next_access_is_a_read_operation = self.mul(
            self.add(self.neg(index_delta), self.set_or_get_constant(1)),
            self.mul(
                value_delta,
                self.add(self.neg(next_gate_access_type), self.set_or_get_constant(1)),
            ),
        )

        next_gate_access_type_is_boolean = self.sub(
            self.mul(next_gate_access_type, next_gate_access_type),
            next_gate_access_type,
        )

        common_product = self.product(
            [p[Wire.Q_ARITH], p[Wire.Q_AUX], domain_separator]
        )

        evaluations[15] = self.mul(
            adjacent_values_match_if_adjacent_indices_match_and_next_access_is_a_read_operation,
            common_product,
        )

        evaluations[16] = self.mul(index_is_monotonically_increasing, common_product)
        evaluations[17] = self.mul(next_gate_access_type_is_boolean, common_product)

        RAM_consistency_check_identity = self.mul(access_check, p[Wire.Q_ARITH])

        timestamp_delta = self.sub(p[Wire.W_R_SHIFT], p[Wire.W_R])
        RAM_timestamp_check_identity = self.sub(
            self.mul(
                self.add(self.neg(index_delta), self.set_or_get_constant(1)),
                timestamp_delta,
            ),
            p[Wire.W_O],
        )

        memory_identity = ROM_consistency_check_identity
        memory_identity = self.add(
            memory_identity,
            self.product([RAM_timestamp_check_identity, p[Wire.Q_4], p[Wire.Q_L]]),
        )
        memory_identity = self.add(
            memory_identity,
            self.product([memory_record_check, p[Wire.Q_M], p[Wire.Q_L]]),
        )
        memory_identity = self.add(memory_identity, RAM_consistency_check_identity)

        auxiliary_identity = self.sum(
            [memory_identity, non_native_field_identity, limb_accumulator_identity]
        )

        auxiliary_identity = self.product(
            [auxiliary_identity, p[Wire.Q_AUX], domain_separator]
        )
        evaluations[12] = auxiliary_identity

        return evaluations

    def accumulate_poseidon_external_relation(
        self,
        purported_evaluations: list[ModuloCircuitElement],
        evaluations: list[ModuloCircuitElement],
        domain_separator: ModuloCircuitElement,
    ) -> list[ModuloCircuitElement]:

        p = purported_evaluations

        s1 = self.add(p[Wire.W_L], p[Wire.Q_L])
        s2 = self.add(p[Wire.W_R], p[Wire.Q_R])
        s3 = self.add(p[Wire.W_O], p[Wire.Q_O])
        s4 = self.add(p[Wire.W_4], p[Wire.Q_4])

        u1 = self.pow5(s1)
        u2 = self.pow5(s2)
        u3 = self.pow5(s3)
        u4 = self.pow5(s4)

        t0 = self.add(u1, u2)
        t1 = self.add(u3, u4)
        t2 = self.add(self.add(u2, u2), t1)
        t3 = self.add(self.add(u4, u4), t0)

        v4 = self.add(t1, t1)
        v4 = self.add(self.add(v4, v4), t3)

        v2 = self.add(t0, t0)
        v2 = self.add(self.add(v2, v2), t2)

        v1 = self.add(t3, v2)
        v3 = self.add(t2, v4)

        q_pos_by_scaling = self.mul(p[Wire.Q_POSEIDON2_EXTERNAL], domain_separator)

        evaluations[18] = self.mul(q_pos_by_scaling, self.sub(v1, p[Wire.W_L_SHIFT]))
        evaluations[19] = self.mul(q_pos_by_scaling, self.sub(v2, p[Wire.W_R_SHIFT]))
        evaluations[20] = self.mul(q_pos_by_scaling, self.sub(v3, p[Wire.W_O_SHIFT]))
        evaluations[21] = self.mul(q_pos_by_scaling, self.sub(v4, p[Wire.W_4_SHIFT]))

        return evaluations

    def pow5(self, x: ModuloCircuitElement) -> ModuloCircuitElement:
        x2 = self.mul(x, x)
        x4 = self.mul(x2, x2)
        return self.mul(x4, x)

    def accumulate_poseidon_internal_relation(
        self,
        purported_evaluations: list[ModuloCircuitElement],
        evaluations: list[ModuloCircuitElement],
        domain_separator: ModuloCircuitElement,
    ) -> list[ModuloCircuitElement]:

        p = purported_evaluations
        INTERNAL_MATRIX_DIAGONAL = [
            self.set_or_get_constant(
                0x10DC6E9C006EA38B04B1E03B4BD9490C0D03F98929CA1D7FB56821FD19D3B6E7
            ),
            self.set_or_get_constant(
                0x0C28145B6A44DF3E0149B3D0A30B3BB599DF9756D4DD9B84A86B38CFB45A740B
            ),
            self.set_or_get_constant(
                0x00544B8338791518B2C7645A50392798B21F75BB60E3596170067D00141CAC15
            ),
            self.set_or_get_constant(
                0x222C01175718386F2E2E82EB122789E352E105A3B8FA852613BC534433EE428B
            ),
        ]

        s1 = self.add(p[Wire.W_L], p[Wire.Q_L])

        u1 = self.pow5(s1)
        u2 = p[Wire.W_R]
        u3 = p[Wire.W_O]
        u4 = p[Wire.W_4]

        u_sum = self.sum([u1, u2, u3, u4])

        q_pos_by_scaling = self.mul(p[Wire.Q_POSEIDON2_INTERNAL], domain_separator)

        v1 = self.add(self.mul(u1, INTERNAL_MATRIX_DIAGONAL[0]), u_sum)
        evaluations[22] = self.mul(q_pos_by_scaling, self.sub(v1, p[Wire.W_L_SHIFT]))

        v2 = self.add(self.mul(u2, INTERNAL_MATRIX_DIAGONAL[1]), u_sum)
        evaluations[23] = self.mul(q_pos_by_scaling, self.sub(v2, p[Wire.W_R_SHIFT]))

        v3 = self.add(self.mul(u3, INTERNAL_MATRIX_DIAGONAL[2]), u_sum)
        evaluations[24] = self.mul(q_pos_by_scaling, self.sub(v3, p[Wire.W_O_SHIFT]))

        v4 = self.add(self.mul(u4, INTERNAL_MATRIX_DIAGONAL[3]), u_sum)
        evaluations[25] = self.mul(q_pos_by_scaling, self.sub(v4, p[Wire.W_4_SHIFT]))

        return evaluations

    def compute_shplemini_msm_scalars(
        self,
        p_sumcheck_evaluations: list[
            ModuloCircuitElement
        ],  # Full evaluations, not replaced.
        p_gemini_a_evaluations: list[ModuloCircuitElement],
        tp_gemini_r: ModuloCircuitElement,
        tp_rho: ModuloCircuitElement,
        tp_shplonk_z: ModuloCircuitElement,
        tp_shplonk_nu: ModuloCircuitElement,
        tp_sumcheck_u_challenges: list[ModuloCircuitElement],
    ) -> list[ModuloCircuitElement]:
        assert all(isinstance(i, ModuloCircuitElement) for i in p_sumcheck_evaluations)
        #         function computeSquares(Fr r) internal pure returns (Fr[CONST_PROOF_SIZE_LOG_N] memory squares) {
        #     squares[0] = r;
        #     for (uint256 i = 1; i < CONST_PROOF_SIZE_LOG_N; ++i) {
        #         squares[i] = squares[i - 1].sqr();
        #     }
        # }
        powers_of_evaluations_challenge = [tp_gemini_r]
        for i in range(1, self.log_n):
            powers_of_evaluations_challenge.append(
                self.mul(
                    powers_of_evaluations_challenge[i - 1],
                    powers_of_evaluations_challenge[i - 1],
                )
            )

        scalars = [self.set_or_get_constant(0)] * (
            NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 2
        )

        # computeInvertedGeminiDenominators

        inverse_vanishing_evals = [None] * (CONST_PROOF_SIZE_LOG_N + 1)
        inverse_vanishing_evals[0] = self.inv(
            self.sub(tp_shplonk_z, powers_of_evaluations_challenge[0])
        )
        for i in range(self.log_n):
            inverse_vanishing_evals[i + 1] = self.inv(
                self.add(tp_shplonk_z, powers_of_evaluations_challenge[i])
            )
        assert len(inverse_vanishing_evals) == CONST_PROOF_SIZE_LOG_N + 1

        # mem.unshiftedScalar = inverse_vanishing_evals[0] + (tp.shplonkNu * inverse_vanishing_evals[1]);
        # mem.shiftedScalar =
        #     tp.geminiR.invert() * (inverse_vanishing_evals[0] - (tp.shplonkNu * inverse_vanishing_evals[1]));

        unshifted_scalar = self.neg(
            self.add(
                inverse_vanishing_evals[0],
                self.mul(tp_shplonk_nu, inverse_vanishing_evals[1]),
            )
        )

        shifted_scalar = self.neg(
            self.mul(
                self.inv(tp_gemini_r),
                self.sub(
                    inverse_vanishing_evals[0],
                    self.mul(tp_shplonk_nu, inverse_vanishing_evals[1]),
                ),
            )
        )

        scalars[0] = self.set_or_get_constant(1)

        batching_challenge = self.set_or_get_constant(1)
        batched_evaluation = self.set_or_get_constant(0)

        for i in range(1, NUMBER_UNSHIFTED + 1):
            scalars[i] = self.mul(unshifted_scalar, batching_challenge)
            batched_evaluation = self.add(
                batched_evaluation,
                self.mul(p_sumcheck_evaluations[i - 1], batching_challenge),
            )
            batching_challenge = self.mul(batching_challenge, tp_rho)

        for i in range(NUMBER_UNSHIFTED + 1, NUMBER_OF_ENTITIES + 1):
            scalars[i] = self.mul(shifted_scalar, batching_challenge)
            batched_evaluation = self.add(
                batched_evaluation,
                self.mul(p_sumcheck_evaluations[i - 1], batching_challenge),
            )
            # skip last round:
            if i < NUMBER_OF_ENTITIES:
                batching_challenge = self.mul(batching_challenge, tp_rho)

        constant_term_accumulator = self.set_or_get_constant(0)
        batching_challenge = self.square(tp_shplonk_nu)

        for i in range(CONST_PROOF_SIZE_LOG_N - 1):
            dummy_round = i >= (self.log_n - 1)

            scaling_factor = self.set_or_get_constant(0)
            if not dummy_round:
                scaling_factor = self.mul(
                    batching_challenge, inverse_vanishing_evals[i + 2]
                )
                scalars[NUMBER_OF_ENTITIES + i + 1] = self.neg(scaling_factor)
                constant_term_accumulator = self.add(
                    constant_term_accumulator,
                    self.mul(scaling_factor, p_gemini_a_evaluations[i + 1]),
                )
            else:
                # print(
                #     f"dummy round {i}, index {NUMBER_OF_ENTITIES + i + 1} is set to 0"
                # )
                pass

            # skip last round:
            if i < self.log_n - 2:
                batching_challenge = self.mul(batching_challenge, tp_shplonk_nu)

        # computeGeminiBatchedUnivariateEvaluation
        def compute_gemini_batched_univariate_evaluation(
            tp_sumcheck_u_challenges,
            batched_eval_accumulator,
            gemini_evaluations,
            gemini_eval_challenge_powers,
        ):
            for i in range(self.log_n, 0, -1):
                challenge_power = gemini_eval_challenge_powers[i - 1]
                u = tp_sumcheck_u_challenges[i - 1]
                eval_neg = gemini_evaluations[i - 1]

                # (challengePower * batchedEvalAccumulator * Fr.wrap(2)) - evalNeg * (challengePower * (Fr.wrap(1) - u) - u))
                # (challengePower * (Fr.wrap(1) - u)
                term = self.mul(
                    challenge_power, self.sub(self.set_or_get_constant(1), u)
                )

                batched_eval_round_acc = self.sub(
                    self.double(self.mul(challenge_power, batched_eval_accumulator)),
                    self.mul(eval_neg, self.sub(term, u)),
                )

                # (challengePower * (Fr.wrap(1) - u) + u).invert()
                den = self.add(term, u)

                batched_eval_round_acc = self.mul(batched_eval_round_acc, self.inv(den))
                batched_eval_accumulator = batched_eval_round_acc

            return batched_eval_accumulator

        a_0_pos = compute_gemini_batched_univariate_evaluation(
            tp_sumcheck_u_challenges,
            batched_evaluation,
            p_gemini_a_evaluations,
            powers_of_evaluations_challenge,
        )

        # mem.constantTermAccumulator = mem.constantTermAccumulator + (a_0_pos * inverse_vanishing_evals[0]);
        # mem.constantTermAccumulator =
        #     mem.constantTermAccumulator + (proof.geminiAEvaluations[0] * tp.shplonkNu * inverse_vanishing_evals[1]);

        constant_term_accumulator = self.add(
            constant_term_accumulator,
            self.mul(a_0_pos, inverse_vanishing_evals[0]),
        )

        constant_term_accumulator = self.add(
            constant_term_accumulator,
            self.product(
                [
                    p_gemini_a_evaluations[0],
                    tp_shplonk_nu,
                    inverse_vanishing_evals[1],
                ]
            ),
        )

        scalars[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N] = constant_term_accumulator
        scalars[NUMBER_OF_ENTITIES + CONST_PROOF_SIZE_LOG_N + 1] = tp_shplonk_z

        # vk.t1 : 22 + 36
        # vk.t2 : 23 + 37
        # vk.t3 : 24 + 38
        # vk.t4 : 25 + 39

        # proof.w1 : 28 + 40
        # proof.w2 : 29 + 41
        # proof.w3 : 30 + 42
        # proof.w4 : 31 + 43

        scalars[22] = self.add(scalars[22], scalars[36])
        scalars[23] = self.add(scalars[23], scalars[37])
        scalars[24] = self.add(scalars[24], scalars[38])
        scalars[25] = self.add(scalars[25], scalars[39])

        scalars[28] = self.add(scalars[28], scalars[40])
        scalars[29] = self.add(scalars[29], scalars[41])
        scalars[30] = self.add(scalars[30], scalars[42])
        scalars[31] = self.add(scalars[31], scalars[43])

        scalars[36] = None
        scalars[37] = None
        scalars[38] = None
        scalars[39] = None
        scalars[40] = None
        scalars[41] = None
        scalars[42] = None
        scalars[43] = None

        return scalars


class AutoValueEnum(Enum):
    def __new__(cls, value):
        obj = object.__new__(cls)
        obj._value_ = value
        return obj

    def __int__(self):
        return self._value_

    def __index__(self):
        return self._value_


class Wire(AutoValueEnum):
    Q_M = 0  # Start at 0 for array indexing
    Q_C = auto()
    Q_L = auto()
    Q_R = auto()
    Q_O = auto()
    Q_4 = auto()
    Q_ARITH = auto()
    Q_RANGE = auto()
    Q_ELLIPTIC = auto()
    Q_AUX = auto()
    Q_LOOKUP = auto()
    Q_POSEIDON2_EXTERNAL = auto()
    Q_POSEIDON2_INTERNAL = auto()
    SIGMA_1 = auto()
    SIGMA_2 = auto()
    SIGMA_3 = auto()
    SIGMA_4 = auto()
    ID_1 = auto()
    ID_2 = auto()
    ID_3 = auto()
    ID_4 = auto()
    TABLE_1 = auto()
    TABLE_2 = auto()
    TABLE_3 = auto()
    TABLE_4 = auto()
    LAGRANGE_FIRST = auto()
    LAGRANGE_LAST = auto()
    W_L = auto()
    W_R = auto()
    W_O = auto()
    W_4 = auto()
    Z_PERM = auto()
    LOOKUP_INVERSES = auto()
    LOOKUP_READ_COUNTS = auto()
    LOOKUP_READ_TAGS = auto()
    TABLE_1_SHIFT = auto()
    TABLE_2_SHIFT = auto()
    TABLE_3_SHIFT = auto()
    TABLE_4_SHIFT = auto()
    W_L_SHIFT = auto()
    W_R_SHIFT = auto()
    W_O_SHIFT = auto()
    W_4_SHIFT = auto()
    Z_PERM_SHIFT = auto()

    @staticmethod
    def unused_indexes():
        return [
            Wire.TABLE_1_SHIFT.value,
            Wire.TABLE_2_SHIFT.value,
            Wire.TABLE_3_SHIFT.value,
            Wire.TABLE_4_SHIFT.value,
        ]

    @staticmethod
    def insert_unused_indexes_with_nones(array: list) -> list:
        assert len(array) == len(Wire) - len(Wire.unused_indexes())
        for i in Wire.unused_indexes():
            array.insert(i, None)
        for i in Wire.unused_indexes():
            assert array[i] is None
        assert len(array) == len(Wire)

        return array

    @staticmethod
    def replace_unused_indexes_with_nones(array: list) -> list:
        for i in Wire.unused_indexes():
            array[i] = None
        return array

    @staticmethod
    def remove_unused_indexes(array: list) -> list:
        for i in Wire.unused_indexes():
            array.pop(i)
        return array


if __name__ == "__main__":
    proof = HonkProof.from_bytes(
        open(
            "hydra/garaga/starknet/honk_contract_generator/examples/proof_ultra_keccak.bin",
            "rb",
        ).read()
    )
    print(proof.to_cairo())
    print(f"\n\n")

    tp = HonkTranscript.from_proof(proof)
    print(f"\n\n")
    print(tp.to_cairo())

    print(f"\n\n")

    print(Wire.unused_indexes())

    print(tp)
