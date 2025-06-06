from garaga.definitions import CURVES, CurveID, G1Point
from garaga.poseidon_transcript import hades_permutation

STARKNET_CURVE = CURVES[CurveID.STARKNET.value]


class BPTranscript:
    init_hash: int
    s0: int
    s1: int
    s2: int
    permutations_count: int

    def __init__(self, init_hash: int | str | bytes) -> None:
        self.init_hash = self._process_val(init_hash)
        self.s0, self.s1, self.s2 = hades_permutation(
            self.init_hash,
            0,
            1,
        )
        self.permutations_count = 1

    def _process_val(value: int | str | bytes):
        if isinstance(value, int):
            assert value < STARKNET_CURVE.p, "value must be less than p"
            return value
        elif isinstance(value, str):
            val = int.from_bytes(value.encode(), "big")
            assert val < STARKNET_CURVE.p, "value must be less than p"
            return val
        elif isinstance(value, bytes):
            val = int.from_bytes(value, "big")
            assert val < STARKNET_CURVE.p, "value must be less than p"
            return val
        else:
            raise ValueError(f"Invalid type for value: {type(value)} : {value}")

    def update_pt(self, pt: G1Point):
        assert pt.curve_id == CurveID.STARKNET, "only starknet curve is supported"
        self.s0, self.s1, self.s2 = hades_permutation(
            self.s0 + pt.x,
            self.s1 + pt.y,
            self.s2,
        )

    def digest(self) -> int:
        return self.s0

    def challenge(self) -> int:
        return self.digest()
