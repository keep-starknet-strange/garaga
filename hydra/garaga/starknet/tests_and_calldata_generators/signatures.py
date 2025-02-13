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

    def serialize_with_hints(self, use_rust=False) -> list[int]:
        """Serialize the signature with hints for verification"""
        if use_rust:
            return garaga_rs.schnorr_calldata_builder(
                self.rx, self.s, self.e, self.px, self.py, self.curve_id.value
            )

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

    def serialize_with_hints(self, use_rust=False) -> list[int]:
        """Serialize the signature with hints for verification"""
        if use_rust:
            return garaga_rs.ecdsa_calldata_builder(
                self.r, self.s, self.v, self.px, self.py, self.z, self.curve_id.value
            )

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
            False,  # include_digits_decomposition
            False,  # include_points_and_scalars
            False,  # serialize_as_pure_felt252_array
            False,  # risc0_mode
        )[1:]
        cd.extend(msm_calldata)
        return cd
