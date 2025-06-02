import random
from dataclasses import dataclass
from functools import lru_cache
from hashlib import sha512

from garaga import garaga_rs
from garaga.definitions import (
    BASE,
    CURVES,
    N_LIMBS,
    CurveID,
    G1Point,
    TwistedEdwardsCurve,
)
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

    def serialize_with_hints(self, use_rust=False, as_str=False) -> list[int] | str:
        """Serialize the signature with hints for verification"""
        if use_rust:
            cd = garaga_rs.schnorr_calldata_builder(
                self.rx, self.s, self.e, self.px, self.py, self.curve_id.value
            )
            if as_str:
                return "[{}]".format(", ".join(map(hex, cd)))
            return cd

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
            False,  # include_points_and_scalars
            True,  # serialize_as_pure_felt252_array
        )
        cd.extend(msm_calldata)
        if as_str:
            return "[{}]".format(", ".join(map(hex, cd)))
        return cd


@dataclass(slots=True)
class ECDSASignature:
    """
    An ECDSA signature with recovery parameter and associated public key and message hash.

    Fields:
      r    : int - r component of the signature (derived from the ephemeral point R.x mod n).
      s    : int - s component of the signature.
      v    : int - Recovery parameter; 0 if R.y is even, otherwise 1.
      px   : int - The x-coordinate of the public key.
      py   : int - The y-coordinate of the public key.
      z    : int - The message hash used in signing (in practice, z = H(message)).
      curve_id : CurveID - The identifier for the curve being used.
    """

    r: int
    s: int
    v: int
    px: int
    py: int
    z: int
    curve_id: CurveID

    def __post_init__(self):
        curve = CURVES[self.curve_id.value]
        n = curve.n
        p = curve.p
        # For ECDSA, r and s must be nonzero and less than n.
        assert 0 < self.r < n, f"r must be in range 1..n-1, got {hex(self.r)}"
        assert 0 < self.s < n, f"s must be in range 1..n-1, got {hex(self.s)}"
        # v should be either 0 or 1.
        assert self.v in (0, 1), f"v must be 0 or 1, got {self.v}"
        # Ensure public key coordinates are in the field.
        assert 0 <= self.px < p, f"px must be in range 0..p-1, got {hex(self.px)}"
        assert 0 <= self.py < p, f"py must be in range 0..p-1, got {hex(self.py)}"

    @classmethod
    def sample(cls, curve_id: CurveID) -> "ECDSASignature":
        """
        Generate a valid ECDSA signature for the given curve.

        The algorithm:
          1. Generate a private key d.
          2. Compute the public key Q = d * G.
          3. Generate a random message hash z (in practice, z = H(message)).
          4. Choose a random nonce k and compute R = k * G.
          5. Let r = R.x mod n (with r != 0).
          6. Compute s = k⁻¹ * (z + r * d) mod n (with s != 0).
          7. Set the recovery parameter v = 0 if R.y is even, else 1.
        """
        curve = CURVES[curve_id.value]
        n = curve.n
        p = curve.p
        G = G1Point.get_nG(curve_id, 1)

        # Generate the private key d and public key Q.
        d = random.randint(1, n - 1)
        Q = G.scalar_mul(d)

        # Generate a random message hash (normally, this is H(message)).
        z = random.randint(1, n - 1)

        # Choose a nonce k until we get valid r and s.
        while True:
            k = random.randint(1, n - 1)
            R = G.scalar_mul(k)
            r = R.x % n  # r is computed from the x-coordinate of R.
            if r == 0:
                continue
            try:
                k_inv = pow(k, -1, n)
            except ValueError:
                continue
            s = (k_inv * (z + r * d)) % n
            if s == 0:
                continue
            v = 0 if R.y % 2 == 0 else 1
            break

        sig = cls(r=r, s=s, v=v, px=Q.x, py=Q.y, z=z, curve_id=curve_id)
        assert (
            sig.is_valid()
        ), f"generated ECDSA signature on curve {curve_id.name} is invalid"
        return sig

    def is_valid(self) -> bool:
        """
        Verify the ECDSA signature using the stored message hash and public key.

        Standard verification:
          1. Compute w = s⁻¹ mod n.
          2. Compute u₁ = z * w mod n and u₂ = r * w mod n.
          3. Compute R' = u₁ * G + u₂ * Q.
          4. The signature is valid if (R'.x mod n) equals r.
        """
        curve = CURVES[self.curve_id.value]
        n = curve.n
        G = G1Point.get_nG(self.curve_id, 1)
        Q = G1Point(self.px, self.py, self.curve_id)

        try:
            s_inv = pow(self.s, -1, n)
        except ValueError:
            return False

        u1 = (self.z * s_inv) % n
        u2 = (self.r * s_inv) % n

        R_prime = G.scalar_mul(u1).add(Q.scalar_mul(u2))
        return (R_prime.x % n) == self.r
        # return (R_prime.x) == self.r

    def serialize(self) -> list[int]:
        cd = []
        cd.extend(bigint_split(self.r, N_LIMBS, BASE))
        cd.extend(split_128(self.s))
        cd.append(self.v)
        cd.extend(bigint_split(self.px, N_LIMBS, BASE))
        cd.extend(bigint_split(self.py, N_LIMBS, BASE))
        cd.extend(split_128(self.z))
        return cd

    def serialize_with_hints(self, use_rust=False, as_str=False) -> list[int] | str:
        """Serialize the signature with hints for verification"""
        if use_rust:
            cd = garaga_rs.ecdsa_calldata_builder(
                self.r, self.s, self.v, self.px, self.py, self.z, self.curve_id.value
            )
            if as_str:
                return "[{}]".format(", ".join(map(hex, cd)))
            return cd

        cd = self.serialize()
        n = CURVES[self.curve_id.value].n
        s_inv = pow(self.s, -1, n)
        u1 = (self.z * s_inv) % n
        u2 = (self.r * s_inv) % n

        msm_calldata = garaga_rs.msm_calldata_builder(
            [
                CURVES[self.curve_id.value].Gx,
                CURVES[self.curve_id.value].Gy,
                self.px,
                self.py,
            ],
            [u1, u2],
            self.curve_id.value,
            False,  # include_points_and_scalars
            True,  # serialize_as_pure_felt252_array
        )
        cd.extend(msm_calldata)
        if as_str:
            return "[{}]".format(", ".join(map(hex, cd)))
        return cd


@dataclass(slots=True)
class EdDSA25519Signature:
    """
    An EdDSA25519 signature with associated public key and message.
    """

    Ry_twisted: int
    s: int
    Py_twisted: int
    msg: bytes

    def __eq__(self, other) -> bool:
        if not isinstance(other, EdDSA25519Signature):
            return NotImplemented
        return (
            self.Ry_twisted == other.Ry_twisted
            and self.s == other.s
            and self.Py_twisted == other.Py_twisted
            and self.msg == other.msg
        )

    def __hash__(self) -> int:
        return hash((self.Ry_twisted, self.s, self.Py_twisted, self.msg))

    def __post_init__(self):
        assert 0 <= self.Ry_twisted < 2**256
        assert 0 <= self.Py_twisted < 2**256
        assert 0 <= self.s < 2**256

    @property
    def curve_id(self) -> CurveID:
        return CurveID.ED25519

    @property
    def curve(self) -> TwistedEdwardsCurve:
        return CURVES[CurveID.ED25519.value]

    @classmethod
    def from_json(cls, json):
        public_key_bytes = bytes.fromhex(json["public_key"])
        message_bytes = bytes.fromhex(json["message"])
        signature_bytes = bytes.fromhex(json["signature"])

        assert len(public_key_bytes) == 32
        assert len(signature_bytes) == 64

        return cls(
            Ry_twisted=int.from_bytes(signature_bytes[:32], "little"),
            s=int.from_bytes(signature_bytes[32:64], "little"),
            Py_twisted=int.from_bytes(public_key_bytes, "little"),
            msg=message_bytes,
        )

    def serialize(self) -> list[int]:
        cd = []
        cd.extend(split_128(self.Ry_twisted))
        cd.extend(split_128(self.s))
        cd.extend(split_128(self.Py_twisted))
        cd.append(len(self.msg))
        cd.extend(list(self.msg))

        return cd

    def xrecover(self, y: int) -> int:
        p = self.curve.p
        D = self.curve.d_twisted
        I = pow(2, (p - 1) // 4, p)
        xx = (y * y - 1) * pow(D * y * y + 1, -1, p)
        x = pow(xx, (p + 3) // 8, p)
        if (x * x - xx) % p != 0:
            x = (x * I) % p
            assert (x * x - xx) % p == 0
        if x % 2 != 0:
            x = p - x
        return x

    def decode_point(self, compressed_point_le: int) -> G1Point:
        sign_bit, y_twisted = divmod(compressed_point_le, 2 ** (255))
        x_twisted = self.xrecover(y_twisted)
        if x_twisted % 2 != sign_bit:
            x_twisted = self.curve.p - x_twisted
        x_weierstrass, y_weierstrass = self.curve.to_weierstrass(x_twisted, y_twisted)
        return G1Point(x_weierstrass, y_weierstrass, self.curve_id)

    @lru_cache(maxsize=None)
    def deserialize_R_A_h(self) -> tuple[G1Point, G1Point, int]:
        R = self.decode_point(self.Ry_twisted)
        A = self.decode_point(self.Py_twisted)

        preimage = (
            self.Ry_twisted.to_bytes(32, "little")
            + self.Py_twisted.to_bytes(32, "little")
            + self.msg
        )
        H_bytes = sha512(preimage).digest()
        H = int.from_bytes(H_bytes, "little")
        h = H % self.curve.n
        return R, A, h

    def is_valid(self) -> bool:
        s = self.s

        R, A, h = self.deserialize_R_A_h()
        G_neg = G1Point.get_nG(self.curve_id, -1)

        msm_result = G1Point.msm(points=[G_neg, A], scalars=[s, h])

        should_be_inf = msm_result.add(R)

        if R.is_infinity() or A.is_infinity():
            return False

        return should_be_inf.is_infinity()

    def serialize_with_hints(self, use_rust=False, as_str=False) -> list[int] | str:
        """Serialize the signature with hints for verification"""
        if use_rust:
            return garaga_rs.eddsa_calldata_builder(
                self.Ry_twisted,
                self.s,
                self.Py_twisted,
                self.msg,
            )

        cd = self.serialize()
        R, A, h = self.deserialize_R_A_h()
        msm_calldata = garaga_rs.msm_calldata_builder(
            [
                CURVES[self.curve_id.value].Gx,
                -CURVES[self.curve_id.value].Gy % self.curve.p,
                A.x,
                A.y,
            ],
            [self.s, h],
            self.curve_id.value,
            False,  # include_points_and_scalars
            True,  # serialize_as_pure_felt252_array
        )

        cd.extend(msm_calldata)
        (Rx_twisted, _) = self.curve.to_twistededwards(R.x, R.y)
        cd.extend(split_128(Rx_twisted))  # sqrt_Rx_hint
        (Px_twisted, _) = self.curve.to_twistededwards(A.x, A.y)
        cd.extend(split_128(Px_twisted))  # sqrt_Px_hint

        if as_str:
            return "[{}]".format(", ".join(map(hex, cd)))
        return cd

    def __eq__(self, other) -> bool:
        if not isinstance(other, EdDSA25519Signature):
            return NotImplemented
        return (
            self.Ry_twisted == other.Ry_twisted
            and self.s == other.s
            and self.Py_twisted == other.Py_twisted
            and self.msg == other.msg
        )

    def __hash__(self) -> int:
        return hash((self.Ry_twisted, self.s, self.Py_twisted, self.msg))


if __name__ == "__main__":
    import json

    with open("tests/ed25519_test_vectors.json", "r") as f:
        test_vectors = json.load(f)

    for i, test_vector in enumerate(test_vectors):
        signature = EdDSA25519Signature.from_json(test_vector)
        assert signature.is_valid(), f"Signature {i} is invalid"
