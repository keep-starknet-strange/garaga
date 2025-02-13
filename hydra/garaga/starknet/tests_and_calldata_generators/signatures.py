import random
from dataclasses import dataclass

from garaga import garaga_rs
from garaga.definitions import BASE, CURVES, N_LIMBS, CurveID, G1Point
from garaga.hints.io import bigint_split, split_128


@dataclass(slots=True)
class SchnorrSignature:
    """
    A Schnorr signature with associated public key and challenge.
    Fields :
    rx : int - The x-coordinate of the R point from the signature.
    s : int - The s-coordinate of the signature.
    e : int - The challenge hash.
    px : int - The x-coordinate of the public key.
    py : int - The y-coordinate of the public key.
    curve_id : CurveID - The curve id.
    """

    rx: int
    s: int
    e: int
    px: int
    py: int
    curve_id: CurveID

    def __post_init__(self):
        assert self.py % 2 == 0, "y-coordinate of public key must be even"
        n = CURVES[self.curve_id.value].n
        p = CURVES[self.curve_id.value].p
        assert (
            0 <= self.rx < p
        ), f"rx must be in range 0 < rx < {hex(p)}, got {hex(self.rx)}"
        assert 0 < self.s < n, f"s must be in range 0 < s < {hex(n)}, got {hex(self.s)}"
        assert 0 < self.e < n, f"e must be in range 0 < e < {hex(n)}, got {hex(self.e)}"

    @classmethod
    def sample(cls, curve_id: CurveID) -> "SchnorrSignature":
        """
        Generate a valid Schnorr signature for the given curve.
        The algorithm:
        1. Generate private key x
        2. Compute public key P = xG
        3. Generate random k (nonce)
        4. Compute R = kG
        5. Compute e (challenge)
        6. Compute s = k + ex (mod n)
        """
        curve = CURVES[curve_id.value]
        n = curve.n
        G = G1Point.get_nG(curve_id, 1)

        # Generate private key and compute public key
        x = random.randint(1, n - 1)
        Pk = G.scalar_mul(x)

        # Ensure public key has even y (BIP340 requirement)
        if Pk.y % 2 == 1:
            x = (-x) % n  # Update the private key accordingly
            Pk = -Pk

        # Generate nonce and compute R point
        k = random.randint(1, n - 1)
        R = G.scalar_mul(k)

        # Ensure R has even y (BIP340 requirement)
        if R.y % 2 == 1:
            k = (-k) % n  # Update the nonce accordingly
            R = -R

        # Generate challenge (in real usage this would be H(R.x || P.x || message))
        e = random.randint(1, n - 1)

        # Compute s = k + ex mod n
        s = (k + e * x) % n

        res = SchnorrSignature(rx=R.x, s=s, e=e, px=Pk.x, py=Pk.y, curve_id=curve_id)
        assert res.is_valid(), "generated signature is invalid"
        return res

    def is_valid(self) -> bool:
        Pk = G1Point(self.px, self.py, self.curve_id)
        n = CURVES[self.curve_id.value].n
        G = G1Point.get_nG(self.curve_id, 1)
        res = G.scalar_mul(self.s).add(Pk.scalar_mul(-self.e % n))
        return res.x == self.rx

    def serialize(self) -> list[int]:
        cd = []
        cd.extend(bigint_split(self.rx, N_LIMBS, BASE))
        cd.extend(split_128(self.s))
        cd.extend(split_128(self.e))
        cd.extend(bigint_split(self.px, N_LIMBS, BASE))
        cd.extend(bigint_split(self.py, N_LIMBS, BASE))
        return cd

    def serialize_with_hints(self) -> list[int]:
        cd = self.serialize()
        e_neg = -self.e % CURVES[self.curve_id.value].n
        msm_calldata = garaga_rs.msm_calldata_builder(
            [
                CURVES[self.curve_id.value].Gx,
                CURVES[self.curve_id.value].Gy,
                self.px,
                self.py,
            ],
            [self.s, e_neg],
            self.curve_id.value,
            False,  # include_digits_decomposition
            False,  # include_points_and_scalars
            False,  # serialize_as_pure_felt252_array
            False,  # risc0_mode
        )[1:]
        cd.extend(msm_calldata)
        return cd
