import codecs
import dataclasses
import hashlib
import json
import os
from pathlib import Path
from typing import Any, List

from garaga.definitions import CURVES, CurveID, G1Point, G2Point
from garaga.hints import io
from garaga.hints.io import split_128
from garaga.modulo_circuit_structs import (
    E12D,
    G1PointCircuit,
    G2PointCircuit,
    StructArray,
)
from garaga.precompiled_circuits.multi_miller_loop import MultiMillerLoopCircuit

# Import constants from generated file
from garaga.starknet.constants import (
    RISC0_BN254_CONTROL_ID,
    RISC0_CONTROL_ROOT,
    SP1_VERIFIER_HASH,
    SP1_VERIFIER_VERSION,
)

# https://github.com/risc0/risc0-ethereum/blob/main/contracts/src/groth16/ControlID.sol
# release 2.0
RISC0_CONTROL_ROOT = 0x539032186827B06719244873B17B2D4C122E2D02CFB1994FE958B2523B844576
RISC0_BN254_CONTROL_ID = (
    0x04446E66D300EB7FB45C9726BB53C793DDA407A62E9601618BB43C5C14657AC0
)

# https://github.com/succinctlabs/sp1-contracts/blob/main/contracts/src/v4.0.0-rc.3/SP1VerifierGroth16.sol
SP1_VERIFIER_VERSION: str = "v4.0.0-rc.3"
SP1_VERIFIER_HASH: bytes = bytes.fromhex(
    "11b6a09d63d255ad425ee3a7f6211d5ec63fbde9805b40551c3136275b6f4eb4"
)


class KeyPatternNotFound(Exception):
    def __init__(self, key_patterns):
        super().__init__(f"No key found with patterns {key_patterns}")
        self.key_patterns = key_patterns


def iterate_nested_dict(d):
    for key, value in d.items():
        if isinstance(value, dict):
            yield from iterate_nested_dict(value)
        else:
            yield value


def find_item_from_key_patterns(data: dict, key_patterns: List[str]) -> Any:
    best_match = None
    best_score = -1
    for key, value in data.items():
        for pattern in key_patterns:
            if key.lower() == pattern.lower():
                # Exact match
                return value
            elif pattern.lower() in key.lower():
                # Partial match
                score = key.lower().count(pattern.lower())
                if score > best_score:
                    best_match = value
                    best_score = score

    if best_match is not None:
        return best_match
    else:
        raise KeyPatternNotFound(key_patterns)


def try_parse_g1_point_from_key(
    data: dict, key_patterns: List[str], curve_id: CurveID = None
) -> G1Point:
    point = find_item_from_key_patterns(data, key_patterns)
    return try_parse_g1_point(point, curve_id)


def proj_to_affine(x, y, z, curve_id: CurveID) -> G1Point:
    x, y, z = io.to_int(x), io.to_int(y), io.to_int(z)
    p = curve_id.p
    z = pow(z, -1, p)
    x = x * z % p
    y = y * z % p
    return G1Point(x=x, y=y, curve_id=curve_id)


def try_parse_g1_point(point: Any, curve_id: CurveID = None) -> G1Point:
    if isinstance(point, dict):
        return G1Point(
            x=io.to_int(find_item_from_key_patterns(point, ["x"])),
            y=io.to_int(find_item_from_key_patterns(point, ["y"])),
            curve_id=curve_id,
        )
    elif isinstance(point, (tuple, list)):
        if len(point) == 2:
            return G1Point(
                x=io.to_int(point[0]),
                y=io.to_int(point[1]),
                curve_id=curve_id,
            )
        elif len(point) == 3:
            return proj_to_affine(point[0], point[1], point[2], curve_id)
        else:
            raise ValueError(f"Invalid point: {point}")
    else:
        raise ValueError(f"Invalid point: {point}")


def try_parse_g2_point_from_key(
    data: dict, key_patterns: List[str], curve_id: CurveID = None
) -> G2Point:
    point = find_item_from_key_patterns(data, key_patterns)
    return try_parse_g2_point(point, curve_id)


def try_parse_g2_point(point: Any, curve_id: CurveID = None) -> G2Point:
    if isinstance(point, dict):
        x_g2 = find_item_from_key_patterns(point, ["x"])
        y_g2 = find_item_from_key_patterns(point, ["y"])
        if isinstance(x_g2, dict) and isinstance(y_g2, dict):
            return G2Point(
                x=(
                    io.to_int(find_item_from_key_patterns(x_g2, ["a0"])),
                    io.to_int(find_item_from_key_patterns(x_g2, ["a1"])),
                ),
                y=(
                    io.to_int(find_item_from_key_patterns(y_g2, ["a0"])),
                    io.to_int(find_item_from_key_patterns(y_g2, ["a1"])),
                ),
                curve_id=curve_id,
            )
        elif isinstance(x_g2, (tuple, list)) and isinstance(y_g2, (tuple, list)):
            return G2Point(
                x=(
                    io.to_int(x_g2[0]),
                    io.to_int(x_g2[1]),
                ),
                y=(
                    io.to_int(y_g2[0]),
                    io.to_int(y_g2[1]),
                ),
                curve_id=curve_id,
            )
    elif isinstance(point, (tuple, list)):
        if len(point) == 2:
            supposed_x = point[0]
            supposed_y = point[1]
        elif len(point) == 3:
            assert (io.to_int(point[2][0]), io.to_int(point[2][1])) == (
                1,
                0,
            ), "Non standard projective coordinates"
            supposed_x = point[0]
            supposed_y = point[1]

        if isinstance(supposed_x, (tuple, list)):
            assert len(supposed_x) == 2, f"Invalid fp2 coordinates: {supposed_x}"
            supposed_x = (io.to_int(supposed_x[0]), io.to_int(supposed_x[1]))
        if isinstance(supposed_y, (tuple, list)):
            assert len(supposed_y) == 2, f"Invalid fp2 coordinates: {supposed_y}"
            supposed_y = (io.to_int(supposed_y[0]), io.to_int(supposed_y[1]))
        return G2Point(x=supposed_x, y=supposed_y, curve_id=curve_id)
    else:
        raise ValueError(f"Invalid point: {point}")


def try_guessing_curve_id_from_json(data: dict) -> CurveID:
    try:
        curve_id = CurveID.from_str(find_item_from_key_patterns(data, ["curve"]))
    except (ValueError, KeyError, KeyPatternNotFound):
        # Try guessing the curve id from the bit size of the first found integer in the json.
        x = None
        for value in iterate_nested_dict(data):
            try:
                x = io.to_int(value)
                break
            except TypeError:
                continue
        if x is None:
            raise ValueError("No integer found in the JSON data.")
        if x.bit_length() > 256:
            curve_id = CurveID.BLS12_381
        else:
            curve_id = CurveID.BN254
    return curve_id


@dataclasses.dataclass(slots=True)
class Groth16VerifyingKey:
    alpha: G1Point
    beta: G2Point
    gamma: G2Point
    delta: G2Point
    ic: List[G1Point]

    def __post_init__(self):
        assert (
            len(self.ic) > 1
        ), "The verifying key must have at least two points in the ic array (one public input and one private input)"
        assert len(self.ic) == len(
            set(self.ic)
        ), "The ic array must not contain duplicate points."
        assert (
            self.alpha.curve_id
            == self.beta.curve_id
            == self.gamma.curve_id
            == self.delta.curve_id
        ), "All points must be on the same curve."
        assert all(point.curve_id == self.alpha.curve_id for point in self.ic)

    @property
    def curve_id(self) -> CurveID:
        return self.alpha.curve_id

    def from_dict(data: dict) -> "Groth16VerifyingKey":
        try:
            curve_id = try_guessing_curve_id_from_json(data)
            try:
                verifying_key = find_item_from_key_patterns(data, ["verifying_key"])
            except KeyPatternNotFound:
                verifying_key = data
            try:
                return Groth16VerifyingKey(
                    alpha=try_parse_g1_point_from_key(
                        verifying_key, ["alpha"], curve_id
                    ),
                    beta=try_parse_g2_point_from_key(verifying_key, ["beta"], curve_id),
                    gamma=try_parse_g2_point_from_key(
                        verifying_key, ["gamma"], curve_id
                    ),
                    delta=try_parse_g2_point_from_key(
                        verifying_key, ["delta"], curve_id
                    ),
                    ic=[
                        try_parse_g1_point(point, curve_id)
                        for point in find_item_from_key_patterns(verifying_key, ["ic"])
                    ],
                )
            except (ValueError, KeyPatternNotFound):
                # Gnark case.
                g1_points = find_item_from_key_patterns(verifying_key, ["g1"])
                g2_points = find_item_from_key_patterns(verifying_key, ["g2"])
                return Groth16VerifyingKey(
                    alpha=try_parse_g1_point_from_key(g1_points, ["alpha"], curve_id),
                    beta=try_parse_g2_point_from_key(g2_points, ["beta"], curve_id),
                    gamma=try_parse_g2_point_from_key(g2_points, ["gamma"], curve_id),
                    delta=try_parse_g2_point_from_key(g2_points, ["delta"], curve_id),
                    ic=[
                        try_parse_g1_point(point, curve_id)
                        for point in find_item_from_key_patterns(g1_points, ["K"])
                    ],
                )
        except KeyError as e:
            raise KeyError(f"The key {e} is missing from the JSON data.")

    def from_json(file_path: str | Path) -> "Groth16VerifyingKey":
        path = Path(file_path)
        try:
            with path.open("r") as f:
                data = json.load(f)
        except FileNotFoundError:
            cwd = os.getcwd()
            print(f"Current working directory: {cwd}")
            print(f"Attempted to access file: {os.path.abspath(file_path)}")
            raise FileNotFoundError(f"The file {file_path} was not found.")
        except json.JSONDecodeError:
            raise ValueError(f"The file {file_path} does not contain valid JSON.")
        return Groth16VerifyingKey.from_dict(data)

    def serialize_to_cairo(self) -> str:
        # Precompute M = miller_loop(public_pair)
        circuit = MultiMillerLoopCircuit(
            name="precompute M", curve_id=self.curve_id.value, n_pairs=1
        )
        circuit.write_p_and_q(P=[self.alpha], Q=[self.beta])

        M = E12D("alpha_beta_miller_loop_result", circuit.miller_loop(n_pairs=1))
        gamma_g2 = G2PointCircuit.from_G2Point("gamma_g2", self.gamma)
        delta_g2 = G2PointCircuit.from_G2Point("delta_g2", self.delta)
        ic = StructArray(
            name="ic",
            elmts=[
                G1PointCircuit.from_G1Point(f"ic_{i}", point)
                for i, point in enumerate(self.ic)
            ],
        )
        code = f"""
        pub const vk:Groth16VerifyingKey = Groth16VerifyingKey{{
            alpha_beta_miller_loop_result: {M.serialize(raw=True)},
            gamma_g2: {gamma_g2.serialize(raw=True)},
            delta_g2: {delta_g2.serialize(raw=True)}
        }};

        pub const ic: [G1Point; {len(self.ic)}] = {ic.serialize(raw=True, const=True)};

        """
        return code

    def flatten(self) -> list[int]:
        lst = []
        lst.extend([self.alpha.x, self.alpha.y])
        lst.extend([self.beta.x[0], self.beta.x[1], self.beta.y[0], self.beta.y[1]])
        lst.extend([self.gamma.x[0], self.gamma.x[1], self.gamma.y[0], self.gamma.y[1]])
        lst.extend([self.delta.x[0], self.delta.x[1], self.delta.y[0], self.delta.y[1]])
        for point in self.ic:
            lst.extend([point.x, point.y])
        return lst


def reverse_byte_order_uint256(value: int | bytes) -> int:
    if isinstance(value, int):
        value_bytes = value.to_bytes(32, byteorder="big")
    else:
        value_bytes = value.ljust(
            32, b"\x00"
        )  # Ensure 32 bytes, pad with zeros if needed
    return int.from_bytes(value_bytes[::-1], byteorder="big")


def split_digest(digest: int | bytes):
    reversed_digest = reverse_byte_order_uint256(digest)
    return split_128(reversed_digest)


@dataclasses.dataclass(slots=True)
class Groth16Proof:
    a: G1Point
    b: G2Point
    c: G1Point
    public_inputs: List[int] = dataclasses.field(default_factory=list)
    curve_id: CurveID = None
    image_id: bytes = None  # Only used for risc0 proofs
    journal: bytes = None  # Only used for risc0 proofs
    public_inputs_sp1: bytes = None  # Only used for sp1 proofs

    def __post_init__(self):
        assert (
            self.a.curve_id == self.b.curve_id == self.c.curve_id
        ), f"All points must be on the same curve, got {self.a.curve_id}, {self.b.curve_id}, {self.c.curve_id}"
        self.curve_id = self.a.curve_id
        for pub in self.public_inputs:
            assert (
                0 <= pub < CURVES[self.curve_id.value].n
            ), f"Public input {pub} is out of bounds for curve {self.curve_id}"
        if self.public_inputs_sp1 is not None:
            assert isinstance(
                self.public_inputs_sp1, bytes
            ), "SP1 public inputs must be a bytes object"
            assert (
                len(self.public_inputs_sp1) % 32 == 0
            ), "SP1 public inputs must be a multiple of 32 bytes"

    def from_dict(
        data: dict, public_inputs: None | list | dict = None
    ) -> "Groth16Proof":
        curve_id = try_guessing_curve_id_from_json(data)
        try:
            proof = find_item_from_key_patterns(data, ["proof"])
        except KeyPatternNotFound:
            proof = data

        try:
            seal = find_item_from_key_patterns(data, ["seal"])
            image_id = find_item_from_key_patterns(data, ["image_id"])
            journal = find_item_from_key_patterns(data, ["journal"])

            print("Seal: {}\nImage_id: {}\nJournal: {}".format(seal, image_id, journal))
            return Groth16Proof._from_risc0(
                seal=codecs.decode(seal[2:].replace("\\x", ""), "hex"),
                image_id=codecs.decode(image_id[2:].replace("\\x", ""), "hex"),
                journal=codecs.decode(journal[2:].replace("\\x", ""), "hex"),
            )
        except (ValueError, KeyError, KeyPatternNotFound):
            pass
        except Exception as e:
            print(f"Error when attempmting to parse as Risc0 proof: {e}")
            raise e

        try:
            sp1_vkey = find_item_from_key_patterns(data, ["vkey"])
            public_inputs = find_item_from_key_patterns(data, ["publicValues"])
            sp1_proof = find_item_from_key_patterns(data, ["proof"])
            return Groth16Proof._from_sp1(
                vkey=codecs.decode(sp1_vkey[2:].replace("\\x", ""), "hex"),
                proof=codecs.decode(sp1_proof[2:].replace("\\x", ""), "hex"),
                public_inputs=codecs.decode(
                    public_inputs[2:].replace("\\x", ""), "hex"
                ),
            )
        except KeyPatternNotFound:
            pass
        except Exception as e:
            print(f"Error when attempmting to parse as SP1 proof: {e}")
            raise e

        if public_inputs is not None:
            if isinstance(public_inputs, dict):
                public_inputs = list(public_inputs.values())
            elif isinstance(public_inputs, list):
                pass
            else:
                raise ValueError(f"Invalid public inputs format: {public_inputs}")
        else:
            try:
                public_inputs = find_item_from_key_patterns(data, ["public"])
            except KeyPatternNotFound as e:
                print(f"Error: {e}")
                raise e
        return Groth16Proof(
            a=try_parse_g1_point_from_key(proof, ["a"], curve_id),
            b=try_parse_g2_point_from_key(proof, ["b"], curve_id),
            c=try_parse_g1_point_from_key(proof, ["c", "Krs"], curve_id),
            public_inputs=[io.to_int(pub) for pub in public_inputs],
        )

    def from_json(
        proof_path: str | Path, public_inputs_path: str | Path = None
    ) -> "Groth16Proof":
        path = Path(proof_path)
        try:
            with path.open("r") as f:
                data = json.load(f)
        except FileNotFoundError:
            raise FileNotFoundError(f"The file {proof_path} was not found.")
        except json.JSONDecodeError:
            raise ValueError(f"The file {proof_path} does not contain valid JSON.")
        try:
            if public_inputs_path is not None:
                with Path(public_inputs_path).open("r") as f:
                    public_inputs = json.load(f)
            else:
                public_inputs = None
        except FileNotFoundError:
            raise FileNotFoundError(f"The file {public_inputs_path} was not found.")
        except json.JSONDecodeError:
            raise ValueError(
                f"The file {public_inputs_path} does not contain valid JSON."
            )
        return Groth16Proof.from_dict(data, public_inputs)

    def _from_risc0(
        seal: bytes,
        image_id: bytes,
        journal: bytes,
        CONTROL_ROOT: int = RISC0_CONTROL_ROOT,
        BN254_CONTROL_ID: int = RISC0_BN254_CONTROL_ID,
    ) -> "Groth16Proof":
        assert len(image_id) <= 32, "image_id must be 32 bytes"
        CONTROL_ROOT_0, CONTROL_ROOT_1 = split_digest(CONTROL_ROOT)
        proof = seal[4:]
        journal_digest = hashlib.sha256(journal).digest()
        claim_digest = ok(image_id, journal_digest).digest()
        claim0, claim1 = split_digest(claim_digest)
        return Groth16Proof(
            a=G1Point(
                x=int.from_bytes(proof[0:32], "big"),
                y=int.from_bytes(proof[32:64], "big"),
                curve_id=CurveID.BN254,
            ),
            b=G2Point(
                x=(
                    int.from_bytes(proof[96:128], "big"),
                    int.from_bytes(proof[64:96], "big"),
                ),
                y=(
                    int.from_bytes(proof[160:192], "big"),
                    int.from_bytes(proof[128:160], "big"),
                ),
                curve_id=CurveID.BN254,
            ),
            c=G1Point(
                x=int.from_bytes(proof[192:224], "big"),
                y=int.from_bytes(proof[224:256], "big"),
                curve_id=CurveID.BN254,
            ),
            public_inputs=[
                CONTROL_ROOT_0,
                CONTROL_ROOT_1,
                claim0,
                claim1,
                BN254_CONTROL_ID,
            ],
            image_id=image_id,
            journal=journal,
        )

    def _from_sp1(
        vkey: bytes,
        public_inputs: bytes,
        proof: bytes,
    ) -> "Groth16Proof":
        _selector, proof = proof[:4], proof[4:]
        assert (
            _selector == SP1_VERIFIER_HASH[:4]
        ), f"Invalid SP1 proof version. Expected {SP1_VERIFIER_HASH[:4]} for version {SP1_VERIFIER_VERSION}, got {_selector}\n Please use SP1 verifier version {SP1_VERIFIER_VERSION} or contact garaga developers to update the SP1 verifier version."
        pub_input_hash: bytes = hashlib.sha256(public_inputs).digest()
        pub_input_hash: int = int.from_bytes(pub_input_hash, "big") % (
            2**253
        )  # <=> & ((1 << 253) - 1)
        # print(f"pub_input_hash: {hex(pub_input_hash)}")
        return Groth16Proof(
            a=G1Point(
                x=int.from_bytes(proof[0:32], "big"),
                y=int.from_bytes(proof[32:64], "big"),
                curve_id=CurveID.BN254,
            ),
            b=G2Point(
                x=(
                    int.from_bytes(proof[96:128], "big"),
                    int.from_bytes(proof[64:96], "big"),
                ),
                y=(
                    int.from_bytes(proof[160:192], "big"),
                    int.from_bytes(proof[128:160], "big"),
                ),
                curve_id=CurveID.BN254,
            ),
            c=G1Point(
                x=int.from_bytes(proof[192:224], "big"),
                y=int.from_bytes(proof[224:256], "big"),
                curve_id=CurveID.BN254,
            ),
            public_inputs=[int.from_bytes(vkey, "big"), pub_input_hash],
            public_inputs_sp1=public_inputs,
        )

    def serialize_to_calldata(self) -> list[int]:
        cd = []
        cd.extend(io.bigint_split(self.a.x))
        cd.extend(io.bigint_split(self.a.y))
        cd.extend(io.bigint_split(self.b.x[0]))
        cd.extend(io.bigint_split(self.b.x[1]))
        cd.extend(io.bigint_split(self.b.y[0]))
        cd.extend(io.bigint_split(self.b.y[1]))
        cd.extend(io.bigint_split(self.c.x))
        cd.extend(io.bigint_split(self.c.y))
        if self.image_id and self.journal and self.public_inputs_sp1 is None:
            # Risc0 mode.
            # Public inputs will be reconstructed from image id and journal.
            image_id_u256 = io.bigint_split(
                int.from_bytes(self.image_id, "big"), 8, 2**32
            )[::-1]
            journal = list(self.journal)
            # Span of u32, length 8.
            cd.append(8)
            cd.extend(image_id_u256)
            # Span of u8, length depends on input
            cd.append(len(self.journal))
            cd.extend(journal)
        elif self.public_inputs_sp1 is not None:
            # SP1 mode.
            # Public inputs 0 is vkey
            cd.extend(io.bigint_split(self.public_inputs[0], 2, 2**128))
            # Public inputs 1 is sha256(public_inputs_sp1) % 2**253
            # We serialize pub_inputs_sp1 as u32 array for Cairo sha256.
            n_bytes = len(self.public_inputs_sp1)
            assert n_bytes % 32 == 0, "SP1 public inputs must be a multiple of 32 bytes"
            n_words = n_bytes // 32
            cd.append(n_words)  # Deserialization 8 by 8
            for i in range(0, n_bytes, 4):
                cd.append(int.from_bytes(self.public_inputs_sp1[i : i + 4], "big"))
        else:
            # Normal mode.
            cd.append(len(self.public_inputs))
            for pub in self.public_inputs:
                cd.extend(io.bigint_split(pub, 2, 2**128))
        return cd

    def flatten(self, include_public_inputs: bool = True) -> list[int]:
        lst = []
        lst.extend([self.a.x, self.a.y])
        lst.extend([self.b.x[0], self.b.x[1]])
        lst.extend([self.b.y[0], self.b.y[1]])
        lst.extend([self.c.x, self.c.y])
        if include_public_inputs:
            lst.extend(self.public_inputs)
        return lst


class ExitCode:
    def __init__(self, system, user):
        self.system = system
        self.user = user


class Output:
    def __init__(self, journal_digest, assumptions_digest):
        self.journal_digest = journal_digest
        self.assumptions_digest = assumptions_digest

    def digest(self):
        return hashlib.sha256(
            hashlib.sha256(b"risc0.Output").digest()
            + self.journal_digest
            + self.assumptions_digest
            + (2 << 8).to_bytes(2, byteorder="big")
        ).digest()


class ReceiptClaim:
    def __init__(
        self,
        pre_state_digest,
        post_state_digest,
        exit_code,
        input,
        output,
        tag_digest: bytes = hashlib.sha256(b"risc0.ReceiptClaim").digest(),
    ):
        self.pre_state_digest = pre_state_digest
        self.post_state_digest = post_state_digest
        self.exit_code = exit_code
        self.input = input
        self.output = output.digest()
        self.TAG_DIGEST = tag_digest

    def digest(self):
        # print(f"TAG_DIGEST: {self.TAG_DIGEST.hex()}")
        # print(f"self.input: {self.input.hex()}")
        # print(f"self.pre_state_digest: {self.pre_state_digest.hex()}")
        # print(f"self.post_state_digest: {self.post_state_digest.hex()}")
        # print(f"self.output: {self.output.hex()}")
        # print(f"self.exit_code.system: {self.exit_code.system}")
        # print(f"self.exit_code.user: {self.exit_code.user}")
        return hashlib.sha256(
            self.TAG_DIGEST
            + self.input
            + self.pre_state_digest
            + self.post_state_digest
            + self.output
            + (self.exit_code.system << 24).to_bytes(4, byteorder="big")
            + (self.exit_code.user << 24).to_bytes(4, byteorder="big")
            + (4 << 8).to_bytes(2, byteorder="big")
        ).digest()


def ok(image_id, journal_digest):
    SYSTEM_STATE_ZERO_DIGEST = bytes.fromhex(
        "A3ACC27117418996340B84E5A90F3EF4C49D22C79E44AAD822EC9C313E1EB8E2"
    )  # https://github.com/risc0/risc0-ethereum/blob/34d2fee4ca6b5fb354a8a1a00c43f8945097bfe5/contracts/src/IRiscZeroVerifier.sol#L60
    return ReceiptClaim(
        pre_state_digest=image_id,
        post_state_digest=SYSTEM_STATE_ZERO_DIGEST,
        exit_code=ExitCode(0, 0),  # (Halted, 0)
        input=bytes(32),  # bytes32(0)
        output=Output(journal_digest, bytes(32)),  # Output(journalDigest, bytes32(0))
    )


if __name__ == "__main__":
    # PATH = Path(__file__).parent
    # print(f"PATH: {PATH}")
    # proof = Groth16Proof.from_json(
    #     f"{PATH}/examples/gnark_proof_bn254.json",
    #     f"{PATH}/examples/gnark_public_bn254.json",
    # )
    # # print(proof)
    # vk = Groth16VerifyingKey.from_json(f"{PATH}/examples/gnark_vk_bn254.json")
    # print(vk)

    # vk_risc0 = Groth16VerifyingKey.from_json(f"{PATH}/examples/vk_risc0.json")
    # # print(vk_risc0)

    # Risc0 proof extracted from https://sepolia.etherscan.io/tx/0x2308aeefef309097aeaf0e3660915d5b80813e693ac72147b651e0196155235d
    bproof = bytes.fromhex(
        "310fe5982466f8f1bab4d00a829cafcda46036fb9c5108df341746ab5f7532aa71aee03b0947eaf1af095584de8d5bd0a91a811f071a555c21a113476aa167108dfeb73913c3a1ef6a5baac68cddd25fafdbf660c4e479f7a836cc1b98904610ead5c9ab2c62f6fdf8ca099964080c95beebf5728b41728128ec0c7823f8adf22e5bfeed1110de7c21ed2dc1e2fd8f2c52d68a15129cf68f18a3087131920e8dcb40a81b003f524b6dcbabdc1e270494bc39b190bddfdb13106409350f80b6204d89da4c16842b4139dd02a39829cf1403657ad00080300a32148c31093cb752809cae2e075db0a79893a6d71a4a7d61111fdff741aeb198dd7fb00b4fa23714ddfd8093"
    )

    def parse_proof_and_signals(proof: bytes) -> Groth16Proof:
        proof = proof[4:]

        def bytes_32_iterator(data: bytes):
            for i in range(0, len(data), 32):
                yield io.to_int(data[i : i + 32])

        it = bytes_32_iterator(proof)
        print(len(proof) / 32)
        _a = G1Point(x=next(it), y=next(it), curve_id=CurveID.BN254)
        _b = G2Point(
            x=[next(it), next(it)][::-1],
            y=[next(it), next(it)][::-1],
            curve_id=CurveID.BN254,
        )
        _c = G1Point(x=next(it), y=next(it), curve_id=CurveID.BN254)

        public_inputs = list(it)
        print(len(public_inputs))
        return Groth16Proof(
            a=_a,
            b=_b,
            c=_c,
            public_inputs=list(it),
        )

    proof = parse_proof_and_signals(bproof)
    print(proof)
