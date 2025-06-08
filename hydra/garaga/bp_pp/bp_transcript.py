from abc import abstractmethod
from typing import Protocol, runtime_checkable

from garaga.definitions import CurveID, G1Point
from garaga.garaga_rs import PyMerlinTranscript
from garaga.poseidon_transcript import hades_permutation


@runtime_checkable
class Transcript(Protocol):
    """Protocol for cryptographic transcript with byte-oriented interface."""

    @abstractmethod
    def append_u64(self, label: bytes, value: int) -> None:
        """Append a labeled u64 to the transcript."""

    @abstractmethod
    def append_point(self, label: bytes, point: G1Point) -> None:
        """Append a labeled point to the transcript."""

    @abstractmethod
    def challenge_scalar(self, label: bytes) -> int:
        """Generate a challenge scalar from the transcript."""


class MerlinTranscript:
    """
    Transcript to match the bp-pp rust crate over secp256k1.
    """

    def __init__(self, label: bytes = b"WLNA") -> None:
        self.transcript = PyMerlinTranscript(label)

    def append_u64(self, label: bytes, value: int) -> None:
        # print(f"[PYTHON] Append u64 {label}: {value}")
        self.transcript.append_u64(label, value)

    def append_point(self, label: bytes, point: G1Point) -> None:
        assert (
            point.curve_id == CurveID.SECP256K1
        ), f"Expected SECP256K1 pt, got {point.curve_id}"
        x_bytes = point.x.to_bytes(32, "big")
        y_bytes = point.y.to_bytes(32, "big")
        # print(f"[PYTHON] Append point {label}: {x_bytes.hex()}, {y_bytes.hex()}")
        self.transcript.append_point(label, x_bytes, y_bytes)

    def challenge_scalar(self, label: bytes) -> int:
        scalar_bytes = self.transcript.challenge_scalar(label)
        assert len(scalar_bytes) == 32
        # print(f"[PYTHON] Challenge {label}: {hex(int.from_bytes(scalar_bytes, 'big'))}")
        return int.from_bytes(scalar_bytes, "big")


class StarknetTranscript:
    """
    Transcript adapted to Cairo and the Starknet curve.
    """

    init_hash: int
    s0: int
    s1: int
    s2: int
    permutations_count: int

    def __init__(self, init_hash: int) -> None:
        self.init_hash = self._create_hash_value(init_hash)
        self.s0, self.s1, self.s2 = hades_permutation(
            self.init_hash,
            0,
            1,
        )
        self.permutations_count = 1

    def append_u64(self, label: bytes, value: int) -> None:
        pass

    def append_point(self, label: bytes, point: G1Point) -> None:
        assert (
            point.curve_id == CurveID.STARKNET
        ), f"Expected Starknet pt, got {point.curve_id}"

    def challenge_scalar(self, label: bytes) -> int:
        pass
