from abc import ABC, abstractmethod
from dataclasses import dataclass, fields
from enum import Enum, auto

import garaga.hints.io as io
import garaga.modulo_circuit_structs as structs
from garaga.algebra import ModuloCircuitElement
from garaga.curves import CURVES, CurveID, ProofSystem
from garaga.hints.keccak256 import keccak_256
from garaga.modulo_circuit import ModuloCircuit
from garaga.points import G1Point, G2Point
from garaga.poseidon_transcript import hades_permutation

NUMBER_OF_SUBRELATIONS = 28
NUMBER_OF_ALPHAS = NUMBER_OF_SUBRELATIONS - 1
NUMBER_OF_ENTITIES = 41
BATCHED_RELATION_PARTIAL_LENGTH = 8
CONST_PROOF_SIZE_LOG_N = 28
NUMBER_UNSHIFTED = 36
NUMBER_TO_BE_SHIFTED = 5
SHIFTED_COMMITMENTS_START = 30
PAIRING_POINT_OBJECT_LENGTH = 16


MAX_LOG_N = 23  # 2^23 = 8388608
MAX_CIRCUIT_SIZE = 1 << MAX_LOG_N


G1_PROOF_POINT_SHIFT = 2**136
G1_PROOF_POINT_SIZE = NUM_ELEMENTS_COMM = 2
NUM_ELEMENTS_FR = 1


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

NUM_WITNESS_ENTITIES = 8
NUM_LIBRA_EVALUATIONS = 4
ZK_BATCHED_RELATION_PARTIAL_LENGTH = 9
SUBGROUP_SIZE = 256
SUBGROUP_GENERATOR = 0x07B0C561A6148404F086204A9F36FFB0617942546750F230C893619174A57A76
SUBGROUP_GENERATOR_INVERSE = (
    0x204BD3277422FAD364751AD938E2B5E6A54CF8C68712848A692C553D0329F5D6
)

LIBRA_COMMITMENTS = 3
LIBRA_EVALUATIONS = 4
LIBRA_UNIVARIATES_LENGTH = 9


@dataclass
class HonkVk:
    name: str
    log_circuit_size: int
    public_inputs_size: int
    qm: G1Point
    qc: G1Point
    ql: G1Point
    qr: G1Point
    qo: G1Point
    q4: G1Point
    qLookup: G1Point
    qArith: G1Point
    qDeltaRange: G1Point
    qElliptic: G1Point
    qMemory: G1Point
    qNnf: G1Point
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
    vk_hash: int
    vk_bytes: bytes

    def __repr__(self) -> str:
        # Print all fields line by line :
        return "\n".join(
            f"{field.name}: {getattr(self, field.name).__repr__()}"
            for field in fields(self)
        )

    @classmethod
    def from_bytes(cls, vk_bytes: bytes) -> "HonkVk":
        vk_hash = (
            int.from_bytes(keccak_256(vk_bytes).digest(), "big")
            % CURVES[CurveID.BN254.value].n
        )
        log_circuit_size = int.from_bytes(vk_bytes[0:32], "big")
        public_inputs_size = int.from_bytes(vk_bytes[32:64], "big")
        public_inputs_offset = int.from_bytes(vk_bytes[64:96], "big")

        assert (
            public_inputs_offset == 1
        ), f"invalid public inputs offset: {public_inputs_offset}"

        cursor = 96

        rest = vk_bytes[cursor:]
        assert (
            len(rest) % 32 == 0
        ), f"invalid vk_bytes length: {len(vk_bytes)}. Make sure you are using the correct version of bb or that the vk is not corrupted."

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
            x = int.from_bytes(vk_bytes[cursor : cursor + 32], "big")
            y = int.from_bytes(vk_bytes[cursor + 32 : cursor + 64], "big")
            points[field_name] = G1Point(x=x, y=y, curve_id=CurveID.BN254)
            cursor += 64
        # print(f"points: {points}")
        # Create instance with all parsed values
        return cls(
            name="",
            log_circuit_size=log_circuit_size,
            public_inputs_size=public_inputs_size,
            **points,
            vk_hash=vk_hash,
            vk_bytes=vk_bytes,
        )

    def to_cairo(self, name: str = "vk") -> str:
        code = f"pub const {name}: HonkVk = HonkVk {{\n"
        code += f"vk_hash: {self.vk_hash},\n"
        code += f"log_circuit_size: {self.log_circuit_size},\n"
        code += f"public_inputs_size: {self.public_inputs_size},\n"

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
            log_circuit_size=self.log_circuit_size,
            public_inputs_size=self.public_inputs_size,
            **{
                field.name: circuit.write_struct(
                    structs.G1PointCircuit.from_G1Point(
                        field.name, getattr(self, field.name)
                    )
                )
                for field in fields(self)
                if field.type == G1Point and field.name != "name"
            },
            vk_hash=self.vk_hash,
            vk_bytes=self.vk_bytes,
        )

    def flatten(self) -> list[int]:
        lst = []
        lst.append(self.circuit_size)
        lst.append(self.log_circuit_size)
        lst.append(self.public_inputs_size)
        lst.append(self.public_inputs_offset)
        for field in fields(self):
            if field.type == G1Point and field.name != "name":
                point = getattr(self, field.name)
                lst.extend([point.x, point.y])
        return lst


class Transcript(ABC):
    def __init__(self):
        self.reset()

    @abstractmethod
    def reset(self):
        pass

    @abstractmethod
    def update(self, data: bytes):
        pass

    @abstractmethod
    def digest(self) -> bytes:
        pass

    def digest_reset(self) -> bytes:
        res_bytes = self.digest()
        self.reset()
        return res_bytes


class Sha3Transcript(Transcript):
    def reset(self):
        self.hasher = keccak_256()

    def digest(self) -> bytes:
        res = self.hasher.digest()
        res_int = int.from_bytes(res, "big")
        res_mod = res_int % CURVES[CurveID.GRUMPKIN.value].p
        res_bytes = res_mod.to_bytes(32, "big")
        return res_bytes

    def update(self, data: bytes):
        self.hasher.update(data)


class StarknetPoseidonTranscript(Transcript):
    def reset(self):
        self.s0, self.s1, self.s2 = hades_permutation(
            int.from_bytes(b"StarknetHonk", "big"), 0, 1
        )

    def digest(self) -> bytes:
        res_bytes = self.s0.to_bytes(32, "big")
        return res_bytes

    def update(self, data: bytes):
        val = int.from_bytes(data, "big")
        assert val < 2**256
        high, low = divmod(val, 2**128)
        self.s0, self.s1, self.s2 = hades_permutation(
            self.s0 + low, self.s1 + high, self.s2
        )


@dataclass
class ZKHonkProof:
    log_circuit_size: int  # from vk
    public_inputs: list[int]
    pairing_point_object: list[int]
    w1: G1Point
    w2: G1Point
    w3: G1Point
    w4: G1Point
    z_perm: G1Point
    lookup_read_counts: G1Point
    lookup_read_tags: G1Point
    lookup_inverses: G1Point
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
    proof_bytes: bytes
    public_inputs_bytes: bytes

    def __post_init__(self):
        assert len(self.pairing_point_object) == PAIRING_POINT_OBJECT_LENGTH
        assert len(self.libra_commitments) == 3
        assert all(
            len(univariate) == ZK_BATCHED_RELATION_PARTIAL_LENGTH
            for univariate in self.sumcheck_univariates
        )
        assert len(self.sumcheck_evaluations) == NUMBER_OF_ENTITIES
        assert len(self.libra_poly_evals) == 4
        assert len(self.gemini_fold_comms) == self.log_circuit_size - 1
        assert len(self.gemini_a_evaluations) == self.log_circuit_size
        assert len(self.libra_poly_evals) == 4

    @classmethod
    def from_bytes(
        cls, proof_bytes: bytes, public_inputs_bytes: bytes, vk: HonkVk
    ) -> "ZKHonkProof":
        FIELD_ELEMENT_SIZE = 32
        n_elements = len(proof_bytes) // FIELD_ELEMENT_SIZE
        assert len(proof_bytes) % FIELD_ELEMENT_SIZE == 0
        elements = [
            int.from_bytes(proof_bytes[i : i + FIELD_ELEMENT_SIZE], "big")
            for i in range(0, len(proof_bytes), FIELD_ELEMENT_SIZE)
        ]
        assert (
            len(elements)
            == n_elements
            == ZKHonkProof.calculate_proof_size(vk.log_circuit_size)
        ), f"{len(elements)} == {n_elements} == {ZKHonkProof.calculate_proof_size(vk.log_circuit_size)}"

        n_public_inputs = len(public_inputs_bytes) // FIELD_ELEMENT_SIZE
        assert len(public_inputs_bytes) % FIELD_ELEMENT_SIZE == 0
        public_inputs = [
            int.from_bytes(public_inputs_bytes[i : i + FIELD_ELEMENT_SIZE], "big")
            for i in range(0, len(public_inputs_bytes), FIELD_ELEMENT_SIZE)
        ]
        assert (
            len(public_inputs)
            == n_public_inputs
            == vk.public_inputs_size - PAIRING_POINT_OBJECT_LENGTH
        )

        pairing_point_object = []
        cursor = 0
        for i in range(PAIRING_POINT_OBJECT_LENGTH):
            pairing_point_object.append(elements[cursor + i])

        cursor += PAIRING_POINT_OBJECT_LENGTH

        def parse_g1_proof_point(i: int) -> G1Point:
            p = CURVES[CurveID.BN254.value].p
            return G1Point(
                x=elements[i] % p,
                y=elements[i + 1] % p,
                curve_id=CurveID.BN254,
            )

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
        for i in range(vk.log_circuit_size):
            sumcheck_univariates.append(
                [
                    elements[cursor + i * ZK_BATCHED_RELATION_PARTIAL_LENGTH + j]
                    for j in range(ZK_BATCHED_RELATION_PARTIAL_LENGTH)
                ]
            )
        cursor += ZK_BATCHED_RELATION_PARTIAL_LENGTH * vk.log_circuit_size

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
            for i in range(vk.log_circuit_size - 1)
        ]

        cursor += (vk.log_circuit_size - 1) * G1_PROOF_POINT_SIZE

        # Parse gemini a evaluations
        gemini_a_evaluations = elements[cursor : cursor + vk.log_circuit_size]

        cursor += vk.log_circuit_size

        libra_poly_evals = elements[cursor : cursor + 4]

        cursor += 4

        shplonk_q = parse_g1_proof_point(cursor)
        kzg_quotient = parse_g1_proof_point(cursor + G1_PROOF_POINT_SIZE)

        cursor += 2 * G1_PROOF_POINT_SIZE

        assert cursor == len(elements)

        return ZKHonkProof(
            log_circuit_size=vk.log_circuit_size,
            public_inputs=public_inputs,
            pairing_point_object=pairing_point_object,
            w1=w1,
            w2=w2,
            w3=w3,
            w4=w4,
            z_perm=z_perm,
            lookup_read_counts=lookup_read_counts,
            lookup_read_tags=lookup_read_tags,
            lookup_inverses=lookup_inverses,
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
            proof_bytes=proof_bytes,
            public_inputs_bytes=public_inputs_bytes,
        )

    def to_circuit_elements(self, circuit: ModuloCircuit) -> "ZKHonkProof":
        """Convert everything to ModuloCircuitElements given a circuit."""
        return ZKHonkProof(
            log_circuit_size=self.log_circuit_size,
            public_inputs=circuit.write_elements(self.public_inputs),
            pairing_point_object=circuit.write_elements(self.pairing_point_object),
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
            proof_bytes=self.proof_bytes,
            public_inputs_bytes=self.public_inputs_bytes,
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
        code += f"public_inputs: {format_array(self.public_inputs, span=True)},\n"
        code += f"pairing_point_object: {format_array(self.pairing_point_object, span=True)},\n"
        code += f"w1: {g1_to_g1point256(self.w1)},\n"
        code += f"w2: {g1_to_g1point256(self.w2)},\n"
        code += f"w3: {g1_to_g1point256(self.w3)},\n"
        code += f"w4: {g1_to_g1point256(self.w4)},\n"
        code += f"z_perm: {g1_to_g1point256(self.z_perm)},\n"
        code += f"lookup_read_counts: {g1_to_g1point256(self.lookup_read_counts)},\n"
        code += f"lookup_read_tags: {g1_to_g1point256(self.lookup_read_tags)},\n"
        code += f"lookup_inverses: {g1_to_g1point256(self.lookup_inverses)},\n"
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
        cd.extend(
            io.bigint_split_array(
                x=self.public_inputs, n_limbs=2, base=2**128, prepend_length=True
            )
        )
        cd.extend(
            io.bigint_split_array(
                x=self.pairing_point_object,
                n_limbs=2,
                base=2**128,
                prepend_length=True,
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

        cd.append(len(self.libra_commitments))
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
                prepend_length=True,
            )
        )

        cd.extend(serialize_G1Point256(self.shplonk_q))
        cd.extend(serialize_G1Point256(self.kzg_quotient))

        return cd

    def flatten(self) -> list[int]:
        """Used to pass data to Rust"""

        lst = []
        lst.extend(self.public_inputs)
        lst.extend(self.pairing_point_object)
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

    @staticmethod
    def calculate_proof_size(log_circuit_size: int):
        # Witness and Libra commitments

        proof_size = NUM_WITNESS_ENTITIES * NUM_ELEMENTS_COMM
        proof_size += (
            NUM_ELEMENTS_COMM * 4
        )  # Libra concat, grand sum, quotient comms + Gemini masking
        # Sumcheck
        proof_size += (
            log_circuit_size * ZK_BATCHED_RELATION_PARTIAL_LENGTH * NUM_ELEMENTS_FR
        )
        # sumcheck univariates
        proof_size += NUMBER_OF_ENTITIES * NUM_ELEMENTS_FR
        # sumcheck evaluations

        # Libra and Gemini
        proof_size += NUM_ELEMENTS_FR * 3
        # Libra sum, claimed eval, Gemini masking eval
        proof_size += log_circuit_size * NUM_ELEMENTS_FR
        # Gemini a evaluations
        proof_size += NUM_LIBRA_EVALUATIONS * NUM_ELEMENTS_FR
        # libra evaluations

        # PCS commitments
        proof_size += (log_circuit_size - 1) * NUM_ELEMENTS_COMM
        # Gemini Fold commitments
        proof_size += NUM_ELEMENTS_COMM * 2
        # Shplonk Q and KZG W commitments

        # Pairing points
        proof_size += PAIRING_POINT_OBJECT_LENGTH
        # pairing inputs carried on public inputs
        return proof_size


@dataclass
class ZKHonkTranscript:
    eta: int | ModuloCircuitElement
    etaTwo: int | ModuloCircuitElement
    etaThree: int | ModuloCircuitElement
    beta: int | ModuloCircuitElement
    gamma: int | ModuloCircuitElement
    alpha: int | ModuloCircuitElement
    gate_challenge: int | ModuloCircuitElement
    libra_challenge: int | ModuloCircuitElement
    sum_check_u_challenges: list[ModuloCircuitElement]
    rho: int | ModuloCircuitElement
    gemini_r: int | ModuloCircuitElement
    shplonk_nu: int | ModuloCircuitElement
    shplonk_z: int | ModuloCircuitElement
    last_state: tuple[int, int, int]
    public_inputs_delta: int | None = None  # Derived.

    @classmethod
    def from_proof(
        cls,
        vk: HonkVk,
        proof: ZKHonkProof,
        system: ProofSystem = ProofSystem.UltraKeccakZKHonk,
    ) -> "ZKHonkTranscript":
        assert (
            len(proof.public_inputs)
            == vk.public_inputs_size - PAIRING_POINT_OBJECT_LENGTH
        )

        def split_challenge(ch: bytes) -> tuple[int, int]:
            ch_int = int.from_bytes(ch, "big")
            high_128, low_128 = divmod(ch_int, 2**128)
            return (low_128, high_128)

        FR = CURVES[CurveID.GRUMPKIN.value].p

        match system:
            case ProofSystem.UltraKeccakZKHonk:
                hasher = Sha3Transcript()
            case ProofSystem.UltraStarknetZKHonk:
                hasher = StarknetPoseidonTranscript()
            case _:
                raise ValueError(f"Proof system {system} not compatible")

        ## 1. Relation Parameters Challenges
        ##    1.1 eta_challenges
        ##    1.2 beta_and_gamma_challenges
        ##
        ## struct RelationParameters {
        #     // challenges
        #     Fr eta;
        #     Fr etaTwo;
        #     Fr etaThree;
        #     Fr beta;
        #     Fr gamma;
        #     // derived
        #     Fr publicInputsDelta;
        # }

        # Round 0 : circuit_size, public_inputs_size, public_input_offset, [public_inputs], w1, w2, w3

        hasher.update(int.to_bytes(vk.vk_hash, 32, "big"))

        for pub_input in proof.public_inputs:
            hasher.update(int.to_bytes(pub_input, 32, "big"))
        for pub_input in proof.pairing_point_object:
            hasher.update(int.to_bytes(pub_input, 32, "big"))

        for g1_proof_point in [proof.w1, proof.w2, proof.w3]:
            # print(f"g1_proof_point: {g1_proof_point.__repr__()}")
            hasher.update(int.to_bytes(g1_proof_point.x, 32, "big"))
            hasher.update(int.to_bytes(g1_proof_point.y, 32, "big"))

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
            hasher.update(int.to_bytes(g1_proof_point.x, 32, "big"))
            hasher.update(int.to_bytes(g1_proof_point.y, 32, "big"))

        ch1 = hasher.digest_reset()
        beta, gamma = split_challenge(ch1)

        ## 2. Alpha Challenges

        # Round 2: ch1, lookup_inverses, z_perm

        hasher.update(ch1)

        for g1_proof_point in [proof.lookup_inverses, proof.z_perm]:
            hasher.update(int.to_bytes(g1_proof_point.x, 32, "big"))
            hasher.update(int.to_bytes(g1_proof_point.y, 32, "big"))

        ch2 = hasher.digest_reset()

        alpha, _ = split_challenge(ch2)

        ## 3. Gate Challenges
        hasher.update(ch2)
        ch3 = hasher.digest_reset()
        gate_challenge, _ = split_challenge(ch3)

        ## 4. Libra Challenge

        # print(f"gate_challenges: {[hex(x) for x in gate_challenges]}")
        # print(f"len(gate_challenges): {len(gate_challenges)}")

        # Round 3 and 1/2: Libra challenge
        hasher.update(ch3)

        hasher.update(int.to_bytes(proof.libra_commitments[0].x, 32, "big"))
        hasher.update(int.to_bytes(proof.libra_commitments[0].y, 32, "big"))

        hasher.update(int.to_bytes(proof.libra_sum, 32, "big"))

        ch3 = hasher.digest_reset()
        libra_challenge, _ = split_challenge(ch3)

        ## 5. Sumcheck U Challenges
        # Round 4: Sumcheck u challenges
        ch4 = ch3
        sum_check_u_challenges = [None] * vk.log_circuit_size

        # print(f"len(sumcheck_univariates): {len(proof.sumcheck_univariates)}")
        # print(
        #     f"len(proof.sumcheck_univariates[0]): {len(proof.sumcheck_univariates[0])}"
        # )

        for i in range(vk.log_circuit_size):
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

        ## 6. Rho Challenge
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
            hasher.update(int.to_bytes(g1_proof_point.x, 32, "big"))
            hasher.update(int.to_bytes(g1_proof_point.y, 32, "big"))

        hasher.update(int.to_bytes(proof.gemini_masking_eval, 32, "big"))

        c5 = hasher.digest_reset()
        rho, _ = split_challenge(c5)

        # print(f"rho: {hex(rho)}")

        ## 7. Gemini R Challenge
        # Gemini R :
        hasher.update(c5)
        for i in range(vk.log_circuit_size - 1):
            hasher.update(int.to_bytes(proof.gemini_fold_comms[i].x, 32, "big"))
            hasher.update(int.to_bytes(proof.gemini_fold_comms[i].y, 32, "big"))

        c6 = hasher.digest_reset()
        gemini_r, _ = split_challenge(c6)

        # print(f"gemini_r: {hex(gemini_r)}")

        ## 8. Shplonk Nu Challenge
        # Shplonk Nu :
        hasher.update(c6)
        for i in range(vk.log_circuit_size):
            hasher.update(int.to_bytes(proof.gemini_a_evaluations[i], 32, "big"))

        for i in range(4):
            hasher.update(int.to_bytes(proof.libra_poly_evals[i], 32, "big"))

        c7 = hasher.digest_reset()
        shplonk_nu, _ = split_challenge(c7)

        # print(f"shplonk_nu: {hex(shplonk_nu)}")
        ## 9. Shplonk Z Challenge
        # Shplonk Z :
        hasher.update(c7)
        hasher.update(int.to_bytes(proof.shplonk_q.x, 32, "big"))
        hasher.update(int.to_bytes(proof.shplonk_q.y, 32, "big"))

        c8 = hasher.digest_reset()
        shplonk_z_low, shplonk_z_high = split_challenge(c8)

        # print(f"shplonk_z: {hex(shplonk_z)}")

        s0, s1, s2 = hades_permutation(shplonk_z_low, shplonk_z_high, 2)

        return cls(
            eta=eta,
            etaTwo=eta_two,
            etaThree=eta_three,
            beta=beta,
            gamma=gamma,
            alpha=alpha,
            gate_challenge=gate_challenge,
            libra_challenge=libra_challenge,
            sum_check_u_challenges=sum_check_u_challenges,
            rho=rho,
            gemini_r=gemini_r,
            shplonk_nu=shplonk_nu,
            shplonk_z=shplonk_z_low,
            last_state=(s0, s1, s2),
            public_inputs_delta=None,
        )

    def to_circuit_elements(self, circuit: ModuloCircuit) -> "ZKHonkTranscript":
        return ZKHonkTranscript(
            eta=circuit.write_element(self.eta),
            etaTwo=circuit.write_element(self.etaTwo),
            etaThree=circuit.write_element(self.etaThree),
            beta=circuit.write_element(self.beta),
            gamma=circuit.write_element(self.gamma),
            alpha=circuit.write_element(self.alpha),
            gate_challenge=circuit.write_element(self.gate_challenge),
            libra_challenge=circuit.write_element(self.libra_challenge),
            sum_check_u_challenges=circuit.write_elements(self.sum_check_u_challenges),
            rho=circuit.write_element(self.rho),
            gemini_r=circuit.write_element(self.gemini_r),
            shplonk_nu=circuit.write_element(self.shplonk_nu),
            shplonk_z=circuit.write_element(self.shplonk_z),
            last_state=self.last_state,
            public_inputs_delta=None,
        )

    def to_cairo(self) -> str:
        code = "ZKHonkTranscript{\n"
        code += f"    eta: {hex(self.eta)},\n"
        code += f"    eta_two: {hex(self.etaTwo)},\n"
        code += f"    eta_three: {hex(self.etaThree)},\n"
        code += f"    beta: {hex(self.beta)},\n"
        code += f"    gamma: {hex(self.gamma)},\n"
        code += f"    alpha: {hex(self.alpha)},\n"
        code += f"    gate_challenge: {hex(self.gate_challenge)},\n"
        code += f"    libra_challenge: {hex(self.libra_challenge)},\n"
        code += f"    sum_check_u_challenges:array![{', '.join([hex(sum_check_u_challenge) for sum_check_u_challenge in self.sum_check_u_challenges])}],\n"
        code += f"    rho: {hex(self.rho)},\n"
        code += f"    gemini_r: {hex(self.gemini_r)},\n"
        code += f"    shplonk_nu: {hex(self.shplonk_nu)},\n"
        code += f"    shplonk_z: {hex(self.shplonk_z)},\n"
        code += "}"
        return code


class ZKHonkVerifierCircuits(ModuloCircuit):
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

    def compute_public_input_delta(
        self,
        public_inputs: list[ModuloCircuitElement],
        pairing_point_object: list[ModuloCircuitElement],
        beta: ModuloCircuitElement,
        gamma: ModuloCircuitElement,
    ) -> ModuloCircuitElement:
        assert len(public_inputs) > 0
        assert len(pairing_point_object) == PAIRING_POINT_OBJECT_LENGTH
        offset: ModuloCircuitElement = self.set_or_get_constant(1)

        num = self.set_or_get_constant(1)
        den = self.set_or_get_constant(1)
        PERMUTATION_ARGUMENT_VALUE_SEPARATOR = 1 << 28
        num_acc = self.add(
            gamma,
            self.mul(
                beta,
                self.add(
                    self.set_or_get_constant(PERMUTATION_ARGUMENT_VALUE_SEPARATOR),
                    offset,
                ),
            ),
        )
        den_acc = self.sub(
            gamma,
            self.mul(beta, self.add(offset, self.set_or_get_constant(1))),
        )

        for i, pub_input in enumerate(public_inputs):
            num = self.mul(num, self.add(num_acc, pub_input))
            den = self.mul(den, self.add(den_acc, pub_input))

            num_acc = self.add(num_acc, beta)
            den_acc = self.sub(den_acc, beta)

        for i, pub_input in enumerate(pairing_point_object):
            num = self.mul(num, self.add(num_acc, pub_input))
            den = self.mul(den, self.add(den_acc, pub_input))

            # skip last round (unused otherwise)
            if i != len(pairing_point_object) - 1:
                num_acc = self.add(num_acc, beta)
                den_acc = self.sub(den_acc, beta)

        return self.div(num, den)

    def verify_sum_check(
        self,
        libra_sum: ModuloCircuitElement,
        sumcheck_univariates: list[list[ModuloCircuitElement]],
        sumcheck_evaluations: list[ModuloCircuitElement],
        libra_evaluation: ModuloCircuitElement,
        beta: ModuloCircuitElement,
        gamma: ModuloCircuitElement,
        public_inputs_delta: ModuloCircuitElement,
        eta: ModuloCircuitElement,
        eta_two: ModuloCircuitElement,
        eta_three: ModuloCircuitElement,
        libra_challenge: ModuloCircuitElement,
        sum_check_u_challenges: list[ModuloCircuitElement],
        gate_challenge: ModuloCircuitElement,
        alpha: ModuloCircuitElement,
        log_n: int,
        base_rlc: ModuloCircuitElement,
    ) -> ModuloCircuitElement:
        """
        We will add an extra challenge base_rlc to do a Sumcheck RLC since
        Cairo1 doesn't support assert_eq inside circuits (unlike Cairo0).
        """

        pow_partial_evaluation = self.set_or_get_constant(1)
        round_target = self.mul(libra_challenge, libra_sum)
        check_rlc = None

        rlc_coeff = base_rlc
        current_gate_challenge = gate_challenge
        for i, round in enumerate(range(log_n)):
            round_univariate: list[ModuloCircuitElement] = sumcheck_univariates[round]
            total_sum = self.add(round_univariate[0], round_univariate[1])
            check_rlc = self.add(
                check_rlc, self.mul(self.sub(total_sum, round_target), rlc_coeff)
            )

            round_challenge = sum_check_u_challenges[round]
            round_target = self.compute_next_target_sum(
                round_univariate, round_challenge
            )
            pow_partial_evaluation = self.partially_evaluate_pow(
                current_gate_challenge,
                pow_partial_evaluation,
                round_challenge,
                round,
            )
            # Skip at the last round
            if i != log_n - 1:
                rlc_coeff = self.mul(rlc_coeff, base_rlc)
                current_gate_challenge = self.square(current_gate_challenge)

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

        grand_honk_relation_sum = evaluations[0]
        alpha_i = alpha
        len_evaluations = len(evaluations) - 1
        for i, evaluation in enumerate(evaluations[1:]):
            grand_honk_relation_sum = self.add(
                grand_honk_relation_sum,
                self.mul(evaluation, alpha_i),
            )
            # Skip last update of alpha_i
            if i != len_evaluations - 1:
                alpha_i = self.mul(alpha_i, alpha)

        evaluation = sum_check_u_challenges[2]
        for i in range(3, log_n):
            evaluation = self.mul(evaluation, sum_check_u_challenges[i])

        grand_honk_relation_sum = self.add(
            self.mul(
                grand_honk_relation_sum,
                self.sub(self.set_or_get_constant(1), evaluation),
            ),
            self.mul(libra_evaluation, libra_challenge),
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
                0x0000000000000000000000000000000000000000000000000000000000009D80
            ),
            self.set_or_get_constant(
                0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFEC51
            ),
            self.set_or_get_constant(
                0x00000000000000000000000000000000000000000000000000000000000005A0
            ),
            self.set_or_get_constant(
                0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFFD31
            ),
            self.set_or_get_constant(
                0x0000000000000000000000000000000000000000000000000000000000000240
            ),
            self.set_or_get_constant(
                0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFFD31
            ),
            self.set_or_get_constant(
                0x00000000000000000000000000000000000000000000000000000000000005A0
            ),
            self.set_or_get_constant(
                0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFEC51
            ),
            self.set_or_get_constant(
                0x0000000000000000000000000000000000000000000000000000000000009D80
            ),
        ]

        assert (
            len(BARYCENTRIC_LAGRANGE_DENOMINATORS) == ZK_BATCHED_RELATION_PARTIAL_LENGTH
        )

        BARYCENTRIC_DOMAIN = [
            self.set_or_get_constant(i)
            for i in range(ZK_BATCHED_RELATION_PARTIAL_LENGTH)
        ]

        numerator = self.set_or_get_constant(1)
        target_sum = self.set_or_get_constant(0)

        for i in range(ZK_BATCHED_RELATION_PARTIAL_LENGTH):
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
        gate_challenge: ModuloCircuitElement,
        current_evaluation: ModuloCircuitElement,
        challenge: ModuloCircuitElement,
        round: int,
    ) -> ModuloCircuitElement:
        """
        Univariate evaluation of the monomial ((1-X_l) + X_l.B_l) at the challenge point X_l=u_l
        """
        univariate_eval = self.add(
            self.set_or_get_constant(1),
            self.mul(challenge, self.sub(gate_challenge, self.set_or_get_constant(1))),
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

        evaluations = self.accumulate_memory_relation(
            sumcheck_evaluations,
            eta,
            eta_two,
            eta_three,
            evaluations,
            domain_separator,
        )

        evaluations = self.accumulate_nnf_relation(
            sumcheck_evaluations, evaluations, domain_separator
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
        read_tag = p[Wire.LOOKUP_READ_TAGS]

        read_tag_boolean_relation = self.sub(self.square(read_tag), read_tag)

        evaluations[4] = accumulator_none
        evaluations[5] = accumulator_one
        evaluations[6] = self.mul(read_tag_boolean_relation, domain_separator)

        return evaluations

    def accumulate_delta_range_relation(
        self,
        purported_evaluations: list[ModuloCircuitElement],
        evaluations: list[ModuloCircuitElement],
        domain_separator: ModuloCircuitElement,
    ) -> list[ModuloCircuitElement]:

        p = purported_evaluations
        # Precompute constants
        minus_one = self.set_or_get_constant(-1)

        # Precompute common terms
        q_range = p[Wire.Q_RANGE]
        q_range_times_domain = self.mul(q_range, domain_separator)

        # Compute deltas
        delta_1 = self.sub(p[Wire.W_R], p[Wire.W_L])
        delta_2 = self.sub(p[Wire.W_O], p[Wire.W_R])
        delta_3 = self.sub(p[Wire.W_4], p[Wire.W_O])
        delta_4 = self.sub(p[Wire.W_L_SHIFT], p[Wire.W_4])

        # Process each delta
        for i, delta in enumerate([delta_1, delta_2, delta_3, delta_4]):
            # Compute delta + (-1), delta + (-2), delta + (-3) efficiently
            delta_minus_1 = self.add(delta, minus_one)
            delta_minus_2 = self.add(delta_minus_1, minus_one)  # Reuse delta_minus_1
            delta_minus_3 = self.add(delta_minus_2, minus_one)  # Reuse delta_minus_2

            # Compute product efficiently
            temp = self.mul(delta, delta_minus_1)
            temp = self.mul(temp, delta_minus_2)
            temp = self.mul(temp, delta_minus_3)
            evaluations[7 + i] = self.mul(temp, q_range_times_domain)

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
        evaluations[11] = self.product(
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
        evaluations[12] = self.product(
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

        evaluations[11] = self.add(
            evaluations[11],
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

        evaluations[12] = self.add(
            evaluations[12],
            self.product(
                [y_double_identity, domain_separator, p[Wire.Q_ELLIPTIC], q_is_double]
            ),
        )

        return evaluations

    def accumulate_memory_relation(
        self,
        purported_evaluations: list[ModuloCircuitElement],
        eta: ModuloCircuitElement,
        eta_two: ModuloCircuitElement,
        eta_three: ModuloCircuitElement,
        evaluations: list[ModuloCircuitElement],
        domain_separator: ModuloCircuitElement,
    ) -> list[ModuloCircuitElement]:
        p = purported_evaluations

        memory_record_check = self.mul(p[Wire.W_O], eta_three)
        memory_record_check = self.add(
            memory_record_check, self.mul(p[Wire.W_R], eta_two)
        )
        memory_record_check = self.add(memory_record_check, self.mul(p[Wire.W_L], eta))
        memory_record_check = self.add(memory_record_check, p[Wire.Q_C])
        partial_record_check = memory_record_check
        memory_record_check = self.sub(memory_record_check, p[Wire.W_4])

        index_delta = self.sub(p[Wire.W_L_SHIFT], p[Wire.W_L])
        record_delta = self.sub(p[Wire.W_4_SHIFT], p[Wire.W_4])

        index_is_monotonically_increasing = self.mul(
            index_delta, self.sub(index_delta, self.set_or_get_constant(1))
        )
        adjacent_values_match_if_adjacent_indices_match = self.mul(
            self.add(
                self.mul(index_delta, self.set_or_get_constant(-1)),
                self.set_or_get_constant(1),
            ),
            record_delta,
        )

        wire_ql_times_qr = self.mul(p[Wire.Q_L], p[Wire.Q_R])

        q_memory_times_domain = self.mul(p[Wire.Q_MEMORY], domain_separator)

        wire_ql_times_qr_times_qmemory_times_domain = self.product(
            [wire_ql_times_qr, q_memory_times_domain]
        )
        evaluations[14] = self.mul(
            adjacent_values_match_if_adjacent_indices_match,
            wire_ql_times_qr_times_qmemory_times_domain,
        )
        evaluations[15] = self.mul(
            index_is_monotonically_increasing,
            wire_ql_times_qr_times_qmemory_times_domain,
        )

        ROM_consistency_check_identity = self.mul(memory_record_check, wire_ql_times_qr)

        access_type = self.sub(p[Wire.W_4], partial_record_check)
        access_check = self.mul(
            access_type, self.sub(access_type, self.set_or_get_constant(1))
        )

        next_gate_access_type = self.sum(
            [
                self.mul(p[Wire.W_O_SHIFT], eta_three),
                self.mul(p[Wire.W_R_SHIFT], eta_two),
                self.mul(p[Wire.W_L_SHIFT], eta),
            ]
        )
        next_gate_access_type = self.sub(p[Wire.W_4_SHIFT], next_gate_access_type)

        value_delta = self.sub(p[Wire.W_O_SHIFT], p[Wire.W_O])
        adjacent_values_match_if_adjacent_indices_match_and_next_access_is_a_read_operation = self.product(
            [
                self.add(
                    self.mul(index_delta, self.set_or_get_constant(-1)),
                    self.set_or_get_constant(1),
                ),
                value_delta,
                self.add(
                    self.mul(next_gate_access_type, self.set_or_get_constant(-1)),
                    self.set_or_get_constant(1),
                ),
            ]
        )

        next_gate_access_type_is_boolean = self.sub(
            self.mul(next_gate_access_type, next_gate_access_type),
            next_gate_access_type,
        )

        q_o_times_q_memory_times_domain = self.mul(p[Wire.Q_O], q_memory_times_domain)
        evaluations[16] = self.product(
            [
                adjacent_values_match_if_adjacent_indices_match_and_next_access_is_a_read_operation,
                q_o_times_q_memory_times_domain,
            ]
        )
        evaluations[17] = self.product(
            [
                index_is_monotonically_increasing,
                q_o_times_q_memory_times_domain,
            ]
        )
        evaluations[18] = self.product(
            [
                next_gate_access_type_is_boolean,
                q_o_times_q_memory_times_domain,
            ]
        )

        RAM_consistency_check_identity = self.mul(access_check, p[Wire.Q_O])

        timestamp_delta = self.sub(p[Wire.W_R_SHIFT], p[Wire.W_R])

        RAM_timestamp_check_identity = self.mul(
            self.add(
                self.mul(index_delta, self.set_or_get_constant(-1)),
                self.set_or_get_constant(1),
            ),
            timestamp_delta,
        )
        RAM_timestamp_check_identity = self.sub(
            RAM_timestamp_check_identity, p[Wire.W_O]  # Fixed: was p[Wire.Q_O]
        )

        memory_identity = self.sum(
            [
                ROM_consistency_check_identity,
                self.product(
                    [RAM_timestamp_check_identity, self.mul(p[Wire.Q_4], p[Wire.Q_L])]
                ),
                self.product([memory_record_check, self.mul(p[Wire.Q_M], p[Wire.Q_L])]),
                RAM_consistency_check_identity,
            ]
        )
        memory_identity = self.mul(memory_identity, q_memory_times_domain)

        evaluations[13] = memory_identity

        return evaluations

    def accumulate_nnf_relation(
        self,
        purported_evaluations: list[ModuloCircuitElement],
        evaluations: list[ModuloCircuitElement],
        domain_separator: ModuloCircuitElement,
    ) -> list[ModuloCircuitElement]:

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

        nnf_identiy = self.add(non_native_field_identity, limb_accumulator_identity)
        nnf_identiy = self.product([nnf_identiy, p[Wire.Q_NNF], domain_separator])
        evaluations[19] = nnf_identiy

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

        evaluations[20] = self.mul(q_pos_by_scaling, self.sub(v1, p[Wire.W_L_SHIFT]))
        evaluations[21] = self.mul(q_pos_by_scaling, self.sub(v2, p[Wire.W_R_SHIFT]))
        evaluations[22] = self.mul(q_pos_by_scaling, self.sub(v3, p[Wire.W_O_SHIFT]))
        evaluations[23] = self.mul(q_pos_by_scaling, self.sub(v4, p[Wire.W_4_SHIFT]))

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
        evaluations[24] = self.mul(q_pos_by_scaling, self.sub(v1, p[Wire.W_L_SHIFT]))

        v2 = self.add(self.mul(u2, INTERNAL_MATRIX_DIAGONAL[1]), u_sum)
        evaluations[25] = self.mul(q_pos_by_scaling, self.sub(v2, p[Wire.W_R_SHIFT]))

        v3 = self.add(self.mul(u3, INTERNAL_MATRIX_DIAGONAL[2]), u_sum)
        evaluations[26] = self.mul(q_pos_by_scaling, self.sub(v3, p[Wire.W_O_SHIFT]))

        v4 = self.add(self.mul(u4, INTERNAL_MATRIX_DIAGONAL[3]), u_sum)
        evaluations[27] = self.mul(q_pos_by_scaling, self.sub(v4, p[Wire.W_4_SHIFT]))

        return evaluations

    def compute_shplemini_msm_scalars(
        self,
        p_sumcheck_evaluations: list[
            ModuloCircuitElement
        ],  # Full evaluations, not replaced.
        p_gemini_masking_eval: ModuloCircuitElement,
        p_gemini_a_evaluations: list[ModuloCircuitElement],
        p_libra_poly_evals: list[ModuloCircuitElement],
        tp_gemini_r: ModuloCircuitElement,
        tp_rho: ModuloCircuitElement,
        tp_shplonk_z: ModuloCircuitElement,
        tp_shplonk_nu: ModuloCircuitElement,
        tp_sumcheck_u_challenges: list[ModuloCircuitElement],
    ) -> list[ModuloCircuitElement]:
        assert all(isinstance(i, ModuloCircuitElement) for i in p_sumcheck_evaluations)

        powers_of_evaluations_challenge = [tp_gemini_r]
        for i in range(1, self.log_n):
            powers_of_evaluations_challenge.append(
                self.square(
                    powers_of_evaluations_challenge[i - 1],
                )
            )

        scalars = [self.set_or_get_constant(0)] * (
            NUMBER_UNSHIFTED + self.log_n + LIBRA_COMMITMENTS + 3
        )

        pos_inverted_denominator = self.inv(
            self.sub(tp_shplonk_z, powers_of_evaluations_challenge[0])
        )
        neg_inverted_denominator = self.inv(
            self.add(tp_shplonk_z, powers_of_evaluations_challenge[0])
        )

        unshifted_scalar = self.add(
            pos_inverted_denominator,
            self.mul(tp_shplonk_nu, neg_inverted_denominator),
        )

        shifted_scalar_neg = self.neg(
            self.mul(
                self.inv(tp_gemini_r),
                self.sub(
                    pos_inverted_denominator,
                    self.mul(tp_shplonk_nu, neg_inverted_denominator),
                ),
            )
        )

        scalars[0] = self.set_or_get_constant(1)

        batching_challenge = tp_rho
        batched_evaluation = p_gemini_masking_eval
        unshifted_scalar_neg = self.neg(unshifted_scalar)
        scalars[1] = unshifted_scalar_neg
        for i in range(0, NUMBER_UNSHIFTED):
            scalars[i + 2] = self.mul(unshifted_scalar_neg, batching_challenge)
            batched_evaluation = self.add(
                batched_evaluation,
                self.mul(p_sumcheck_evaluations[i], batching_challenge),
            )
            batching_challenge = self.mul(batching_challenge, tp_rho)

        for i in range(0, NUMBER_TO_BE_SHIFTED):
            scalar_offset = i + SHIFTED_COMMITMENTS_START
            evaluation_offset = i + NUMBER_UNSHIFTED
            scalars[scalar_offset] = self.add(
                scalars[scalar_offset], self.mul(shifted_scalar_neg, batching_challenge)
            )
            batched_evaluation = self.add(
                batched_evaluation,
                self.mul(p_sumcheck_evaluations[evaluation_offset], batching_challenge),
            )
            # skip last round:
            if i < NUMBER_TO_BE_SHIFTED - 1:
                batching_challenge = self.mul(batching_challenge, tp_rho)

        # computeFoldPosEvaluations
        def compute_fold_pos_evaluations(
            tp_sumcheck_u_challenges,
            batched_eval_accumulator,
            gemini_evaluations,
            gemini_eval_challenge_powers,
        ):
            fold_pos_evaluations = [self.set_or_get_constant(0)] * self.log_n
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
                fold_pos_evaluations[i - 1] = batched_eval_accumulator

            return fold_pos_evaluations

        fold_pos_evaluations = compute_fold_pos_evaluations(
            tp_sumcheck_u_challenges,
            batched_evaluation,
            p_gemini_a_evaluations,
            powers_of_evaluations_challenge,
        )

        constant_term_accumulator = self.mul(
            fold_pos_evaluations[0], pos_inverted_denominator
        )

        constant_term_accumulator = self.add(
            constant_term_accumulator,
            self.product(
                [
                    p_gemini_a_evaluations[0],
                    tp_shplonk_nu,
                    neg_inverted_denominator,
                ]
            ),
        )

        batching_challenge = self.square(tp_shplonk_nu)

        boundary = NUMBER_UNSHIFTED + 2

        for i in range(self.log_n - 1):
            dummy_round = i >= (self.log_n - 1)

            scaling_factor = self.set_or_get_constant(0)
            if not dummy_round:
                pos_inverted_denominator = self.inv(
                    self.sub(tp_shplonk_z, powers_of_evaluations_challenge[i + 1])
                )
                neg_inverted_denominator = self.inv(
                    self.add(tp_shplonk_z, powers_of_evaluations_challenge[i + 1])
                )

                scaling_factor_pos = self.mul(
                    batching_challenge, pos_inverted_denominator
                )
                scaling_factor_neg = self.mul(
                    batching_challenge,
                    self.mul(tp_shplonk_nu, neg_inverted_denominator),
                )
                scalars[boundary + i] = self.neg(
                    self.add(scaling_factor_neg, scaling_factor_pos)
                )

                accum_contribution = self.mul(
                    scaling_factor_neg, p_gemini_a_evaluations[i + 1]
                )
                accum_contribution = self.add(
                    accum_contribution,
                    self.mul(scaling_factor_pos, fold_pos_evaluations[i + 1]),
                )
                constant_term_accumulator = self.add(
                    constant_term_accumulator, accum_contribution
                )
            else:
                # print(
                #     f"dummy round {i}, index {NUMBER_OF_ENTITIES + i + 1} is set to 0"
                # )
                pass

            batching_challenge = self.mul(
                batching_challenge, self.square(tp_shplonk_nu)
            )

        boundary += self.log_n - 1

        denominators = [self.set_or_get_constant(0)] * 4
        denominators[0] = self.inv(self.sub(tp_shplonk_z, tp_gemini_r))
        denominators[1] = self.inv(
            self.sub(
                tp_shplonk_z,
                self.mul(self.set_or_get_constant(SUBGROUP_GENERATOR), tp_gemini_r),
            ),
        )
        denominators[2] = denominators[0]
        denominators[3] = denominators[0]

        batching_scalars = [self.set_or_get_constant(0)] * 4
        batching_challenge = self.mul(batching_challenge, self.square(tp_shplonk_nu))

        for i in range(LIBRA_EVALUATIONS):
            scaling_factor = self.mul(denominators[i], batching_challenge)
            batching_scalars[i] = self.neg(scaling_factor)

            # skip last step:
            if i < LIBRA_EVALUATIONS - 1:
                batching_challenge = self.mul(batching_challenge, tp_shplonk_nu)
            constant_term_accumulator = self.add(
                constant_term_accumulator,
                self.mul(scaling_factor, p_libra_poly_evals[i]),
            )

        scalars[boundary] = batching_scalars[0]
        scalars[boundary + 1] = self.add(batching_scalars[1], batching_scalars[2])
        scalars[boundary + 2] = batching_scalars[3]

        scalars[boundary + 3] = constant_term_accumulator
        scalars[boundary + 4] = tp_shplonk_z

        return scalars

    def check_evals_consistency(
        self,
        p_libra_evaluation: ModuloCircuitElement,
        p_libra_poly_evals: list[ModuloCircuitElement],
        tp_gemini_r: ModuloCircuitElement,
        tp_sumcheck_u_challenges: list[ModuloCircuitElement],
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        vanishing_poly_eval = self.sub(
            self.pow(tp_gemini_r, SUBGROUP_SIZE), self.set_or_get_constant(1)
        )

        challenge_poly_lagrange = [self.set_or_get_constant(0)] * SUBGROUP_SIZE
        challenge_poly_lagrange[0] = self.set_or_get_constant(1)
        for r in range(self.log_n):
            curr_idx = 1 + LIBRA_UNIVARIATES_LENGTH * r
            challenge_poly_lagrange[curr_idx] = self.set_or_get_constant(1)
            for idx in range(curr_idx + 1, curr_idx + LIBRA_UNIVARIATES_LENGTH):
                challenge_poly_lagrange[idx] = self.mul(
                    challenge_poly_lagrange[idx - 1], tp_sumcheck_u_challenges[r]
                )

        root_power = self.set_or_get_constant(1)
        challenge_poly_eval = self.set_or_get_constant(0)
        denominators = [self.set_or_get_constant(0)] * SUBGROUP_SIZE
        for idx in range(SUBGROUP_SIZE):
            denominators[idx] = self.sub(
                self.mul(root_power, tp_gemini_r), self.set_or_get_constant(1)
            )
            denominators[idx] = self.inv(denominators[idx])
            challenge_poly_eval = self.add(
                challenge_poly_eval,
                self.mul(challenge_poly_lagrange[idx], denominators[idx]),
            )
            # skip last step:
            if idx < SUBGROUP_SIZE - 1:
                root_power = self.mul(
                    root_power, self.set_or_get_constant(SUBGROUP_GENERATOR_INVERSE)
                )

        numerator = self.mul(
            vanishing_poly_eval,
            self.set_or_get_constant(pow(SUBGROUP_SIZE, -1, self.field.p)),
        )
        challenge_poly_eval = self.mul(challenge_poly_eval, numerator)
        lagrange_first = self.mul(denominators[0], numerator)
        lagrange_last = self.mul(denominators[SUBGROUP_SIZE - 1], numerator)

        diff = self.mul(lagrange_first, p_libra_poly_evals[2])
        diff = self.add(
            diff,
            self.mul(
                self.sub(
                    tp_gemini_r, self.set_or_get_constant(SUBGROUP_GENERATOR_INVERSE)
                ),
                self.sub(
                    self.sub(p_libra_poly_evals[1], p_libra_poly_evals[2]),
                    self.mul(p_libra_poly_evals[0], challenge_poly_eval),
                ),
            ),
        )
        diff = self.sub(
            self.add(
                diff,
                self.mul(
                    lagrange_last, self.sub(p_libra_poly_evals[2], p_libra_evaluation)
                ),
            ),
            self.mul(vanishing_poly_eval, p_libra_poly_evals[3]),
        )

        return vanishing_poly_eval, diff

    def check_evals_consistency_split(
        self,
        p_libra_evaluation: ModuloCircuitElement,
        p_libra_poly_evals: list[ModuloCircuitElement],
        tp_gemini_r: ModuloCircuitElement,
        tp_sumcheck_u_challenges: list[ModuloCircuitElement],
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        challenge_poly_eval, root_power_times_tp_gemini_r = (
            self._check_evals_consistency_init(tp_gemini_r)
        )
        for r in range(self.log_n):
            challenge_poly_eval, root_power_times_tp_gemini_r = (
                self._check_evals_consistency_loop(
                    challenge_poly_eval,
                    root_power_times_tp_gemini_r,
                    tp_sumcheck_u_challenges[r],
                )
            )
        vanishing_poly_eval, diff = self._check_evals_consistency_done(
            p_libra_evaluation,
            p_libra_poly_evals,
            tp_gemini_r,
            challenge_poly_eval,
            root_power_times_tp_gemini_r,
        )
        return vanishing_poly_eval, diff

    def _check_evals_consistency_init(
        self,
        tp_gemini_r: ModuloCircuitElement,
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        challenge_poly_eval = self.inv(
            self.sub(tp_gemini_r, self.set_or_get_constant(1))
        )
        root_power_times_tp_gemini_r = self.mul(
            self.set_or_get_constant(SUBGROUP_GENERATOR_INVERSE), tp_gemini_r
        )
        return challenge_poly_eval, root_power_times_tp_gemini_r

    def _check_evals_consistency_loop(
        self,
        challenge_poly_eval: ModuloCircuitElement,
        root_power_times_tp_gemini_r: ModuloCircuitElement,
        tp_sumcheck_u_challenge: ModuloCircuitElement,
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        challenge_poly_lagrange = self.set_or_get_constant(1)
        for i in range(LIBRA_UNIVARIATES_LENGTH):
            denominator = self.inv(
                self.sub(root_power_times_tp_gemini_r, self.set_or_get_constant(1))
            )
            challenge_poly_eval = self.add(
                challenge_poly_eval, self.mul(challenge_poly_lagrange, denominator)
            )
            root_power_times_tp_gemini_r = self.mul(
                root_power_times_tp_gemini_r,
                self.set_or_get_constant(SUBGROUP_GENERATOR_INVERSE),
            )
            # skip last step:
            if i < LIBRA_UNIVARIATES_LENGTH - 1:
                challenge_poly_lagrange = self.mul(
                    challenge_poly_lagrange, tp_sumcheck_u_challenge
                )
        return challenge_poly_eval, root_power_times_tp_gemini_r

    def _check_evals_consistency_done(
        self,
        p_libra_evaluation: ModuloCircuitElement,
        p_libra_poly_evals: list[ModuloCircuitElement],
        tp_gemini_r: ModuloCircuitElement,
        challenge_poly_eval: ModuloCircuitElement,
        root_power_times_tp_gemini_r: ModuloCircuitElement,
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        # We've processed indices 0 to (1 + log_n * 9 - 1) = log_n * 9
        # Need to advance root_power for remaining indices up to SUBGROUP_SIZE - 2
        # (SUBGROUP_SIZE - 1 is the last index, handled separately for lagrange_last)
        for _ in range(1 + self.log_n * LIBRA_UNIVARIATES_LENGTH, SUBGROUP_SIZE - 1):
            root_power_times_tp_gemini_r = self.mul(
                root_power_times_tp_gemini_r,
                self.set_or_get_constant(SUBGROUP_GENERATOR_INVERSE),
            )
        denominator_first = self.inv(self.sub(tp_gemini_r, self.set_or_get_constant(1)))
        denominator_last = self.inv(
            self.sub(root_power_times_tp_gemini_r, self.set_or_get_constant(1))
        )

        vanishing_poly_eval = self.sub(
            self.pow(tp_gemini_r, SUBGROUP_SIZE), self.set_or_get_constant(1)
        )
        numerator = self.mul(
            vanishing_poly_eval,
            self.set_or_get_constant(pow(SUBGROUP_SIZE, -1, self.field.p)),
        )
        challenge_poly_eval = self.mul(challenge_poly_eval, numerator)
        lagrange_first = self.mul(denominator_first, numerator)
        lagrange_last = self.mul(denominator_last, numerator)

        diff = self.mul(lagrange_first, p_libra_poly_evals[2])
        diff = self.add(
            diff,
            self.mul(
                self.sub(
                    tp_gemini_r, self.set_or_get_constant(SUBGROUP_GENERATOR_INVERSE)
                ),
                self.sub(
                    self.sub(p_libra_poly_evals[1], p_libra_poly_evals[2]),
                    self.mul(p_libra_poly_evals[0], challenge_poly_eval),
                ),
            ),
        )
        diff = self.sub(
            self.add(
                diff,
                self.mul(
                    lagrange_last, self.sub(p_libra_poly_evals[2], p_libra_evaluation)
                ),
            ),
            self.mul(vanishing_poly_eval, p_libra_poly_evals[3]),
        )

        return vanishing_poly_eval, diff

    def pow(self, x: ModuloCircuitElement, e: int) -> ModuloCircuitElement:
        assert e > 0 and ((e - 1) & e) == 0  # supports only powers of 2
        shift = e.bit_length() - 1
        y = x
        for i in range(shift):
            y = self.mul(y, y)
        return y


def get_msm_points_from_vk_and_proof(
    vk: HonkVk,
    proof: ZKHonkProof,
) -> list[G1Point]:
    points = [
        proof.shplonk_q,  # 0
        proof.gemini_masking_poly,  # 1
        vk.qm,  # 2
        vk.qc,  # 3
        vk.ql,  # 4
        vk.qr,  # 5
        vk.qo,  # 6
        vk.q4,  # 7
        vk.qLookup,  # 8
        vk.qArith,  # 9
        vk.qDeltaRange,  # 10
        vk.qElliptic,  # 11
        vk.qMemory,  # 12
        vk.qNnf,  # 13
        vk.qPoseidon2External,  # 14
        vk.qPoseidon2Internal,  # 15
        vk.s1,  # 16
        vk.s2,  # 17
        vk.s3,  # 18
        vk.s4,  # 19
        vk.id1,  # 20
        vk.id2,  # 21
        vk.id3,  # 22
        vk.id4,  # 23
        vk.t1,  # 24
        vk.t2,  # 25
        vk.t3,  # 26
        vk.t4,  # 27
        vk.lagrange_first,  # 28
        vk.lagrange_last,  # 29
        proof.w1,  # 30
        proof.w2,  # 31
        proof.w3,  # 32
        proof.w4,  # 33
        proof.z_perm,  # 34
        proof.lookup_inverses,  # 35
        proof.lookup_read_counts,  # 36
        proof.lookup_read_tags,  # 37
    ]

    points.extend(proof.gemini_fold_comms)
    points.extend(proof.libra_commitments)
    points.append(G1Point.get_nG(CurveID.BN254, 1))
    points.append(proof.kzg_quotient)

    assert len(points) == NUMBER_UNSHIFTED + vk.log_circuit_size + LIBRA_COMMITMENTS + 3

    return points


def honk_proof_from_bytes(
    proof_bytes: bytes,
    public_inputs_bytes: bytes,
    vk: HonkVk,
    system: ProofSystem,
) -> ZKHonkProof:
    if system == ProofSystem.UltraKeccakZKHonk:
        return ZKHonkProof.from_bytes(proof_bytes, public_inputs_bytes, vk)
    else:
        raise ValueError(f"Invalid system: {system}")


def honk_transcript_from_proof(
    vk: HonkVk,
    proof: ZKHonkProof,
) -> ZKHonkTranscript:
    return ZKHonkTranscript.from_proof(vk, proof)


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
    Q_LOOKUP = auto()
    Q_ARITH = auto()
    Q_RANGE = auto()
    Q_ELLIPTIC = auto()
    Q_MEMORY = auto()
    Q_NNF = auto()
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
    W_L_SHIFT = auto()
    W_R_SHIFT = auto()
    W_O_SHIFT = auto()
    W_4_SHIFT = auto()
    Z_PERM_SHIFT = auto()

    @staticmethod
    def unused_indexes():
        return []

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
    vk = HonkVk.from_bytes(
        open(
            "hydra/garaga/starknet/honk_contract_generator/examples/vk_ultra_keccak.bin",
            "rb",
        ).read(),
    )
    proof = honk_proof_from_bytes(
        open(
            "hydra/garaga/starknet/honk_contract_generator/examples/proof_ultra_keccak_zk.bin",
            "rb",
        ).read(),
        open(
            "hydra/garaga/starknet/honk_contract_generator/examples/public_inputs_ultra_keccak.bin",
            "rb",
        ).read(),
        vk,
        ProofSystem.UltraKeccakZKHonk,
    )

    print(vk.to_cairo())

    print(proof.to_cairo())
    print(f"\n\n")

    tp = honk_transcript_from_proof(vk, proof)
    print(f"\n\n")
    print(tp.to_cairo())

    print(f"\n\n")

    print(Wire.unused_indexes())

    print(tp)
