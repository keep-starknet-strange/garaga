"""RSA-2048 signature verification via RNS arithmetic and CRT exactness.

Implements RSA-2048 modular exponentiation verification suitable for
provable computation (Cairo/STARK). Integers in [0, 2^2048) are
represented in a Residue Number System (RNS) defined by 11 pairwise
coprime ~384-bit primes.

A modular product a·b ≡ r (mod n) is witnessed by the Euclidean
quotient q satisfying a·b = q·n + r. Correctness is verified through:

  1. Channel congruences: for each prime p_i,
     a·b ≡ q·n + r (mod p_i).
  2. CRT exactness: since |a·b - q·n - r| < M = ∏ p_i and the
     congruences force a·b - q·n - r ≡ 0 (mod M), the relation
     holds exactly over ℤ.

RSA-2048 verification computes s^{65537} mod n via square-and-multiply,
yielding 16 squarings + 1 final multiplication = 17 certified reductions.
"""

from __future__ import annotations

import hashlib
import math
import random
from dataclasses import dataclass
from typing import Sequence

LIMB_BITS = 96
BASE = 1 << LIMB_BITS
N_LIMBS = 22
RSA_BITS = 2048
TOP_LIMB_BITS = RSA_BITS - LIMB_BITS * (N_LIMBS - 1)
TOP_LIMB_MAX = 1 << TOP_LIMB_BITS
MAX_2048 = 1 << RSA_BITS
N_CHUNKS = 6
CHUNK_LIMBS = 4
TOP_CHUNK_BITS = 128
RSA_REDUCTION_COUNT = 17
RSA_PUBLIC_EXPONENT = 65537

# Upper bound on |a·b - q·n - r| for a, b, q, n, r < 2^2048.
# The CRT modulus M = ∏ p_i must exceed this to guarantee exactness.
CRT_EXACTNESS_BOUND = (1 << (2 * RSA_BITS + 1)) + (1 << RSA_BITS)

CHANNEL_MODULI = [
    4925250774549309901534880012517951725634967408808180833493536675530715221437151326426783281860614455100828498787617,
    4925250774549309901534880012517951725634967408808180833493536675530715221437151326426783281860614455100828498787149,
    4925250774549309901534880012517951725634967408808180833493536675530715221437151326426783281860614455100828498785261,
    4925250774549309901534880012517951725634967408808180833493536675530715221437151326426783281860614455100828498784349,
    4925250774549309901534880012517951725634967408808180833493536675530715221437151326426783281860614455100828498783539,
    4925250774549309901534880012517951725634967408808180833493536675530715221437151326426783281860614455100828498782649,
    4925250774549309901534880012517951725634967408808180833493536675530715221437151326426783281860614455100828498782327,
    4925250774549309901534880012517951725634967408808180833493536675530715221437151326426783281860614455100828498781403,
    4925250774549309901534880012517951725634967408808180833493536675530715221437151326426783281860614455100828498781199,
    4925250774549309901534880012517951725634967408808180833493536675530715221437151326426783281860614455100828498780291,
    4925250774549309901534880012517951725634967408808180833493536675530715221437151326426783281860614455100828498779421,
]


def modinv(a: int, m: int) -> int:
    return pow(a, -1, m)


def split_words_96(x: int, n_words: int) -> list[int]:
    return [(x >> (LIMB_BITS * i)) & (BASE - 1) for i in range(n_words)]


def join_words_96(words: Sequence[int]) -> int:
    out = 0
    for i, word in enumerate(words):
        if not (0 <= word < BASE):
            raise ValueError(f"96-bit word {i} out of range")
        out |= word << (LIMB_BITS * i)
    return out


def split_limbs_2048(x: int) -> list[int]:
    if not (0 <= x < MAX_2048):
        raise ValueError("value is not a non-negative 2048-bit integer")
    limbs = split_words_96(x, N_LIMBS)
    if limbs[-1] >= TOP_LIMB_MAX:
        raise ValueError("top limb exceeds the 32-bit RSA-2048 bound")
    return limbs


def join_limbs_2048(limbs: Sequence[int]) -> int:
    if len(limbs) != N_LIMBS:
        raise ValueError(f"expected {N_LIMBS} limbs, got {len(limbs)}")
    x = join_words_96(limbs)
    if x >= MAX_2048:
        raise ValueError("reconstructed integer exceeds 2048 bits")
    if limbs[-1] >= TOP_LIMB_MAX:
        raise ValueError("top limb exceeds the 32-bit RSA-2048 bound")
    return x


def limbs_to_chunks(limbs: Sequence[int]) -> tuple[int, ...]:
    """Group 22 limbs of 96 bits into 6 chunks of 384 bits (top chunk: 128 bits)."""
    if len(limbs) != N_LIMBS:
        raise ValueError(f"expected {N_LIMBS} limbs, got {len(limbs)}")
    padded_limbs = list(limbs) + [0, 0]
    chunks = []
    for chunk_index in range(N_CHUNKS):
        start = chunk_index * CHUNK_LIMBS
        end = start + CHUNK_LIMBS
        chunks.append(join_words_96(padded_limbs[start:end]))
    if chunks[-1] >= (1 << TOP_CHUNK_BITS):
        raise ValueError("top chunk exceeds the 128-bit RSA-2048 bound")
    return tuple(chunks)


def is_probable_prime(n: int, rounds: int = 24) -> bool:
    if n < 2:
        return False

    small_primes = (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37)
    for p in small_primes:
        if n % p == 0:
            return n == p

    d = n - 1
    s = 0
    while d % 2 == 0:
        s += 1
        d //= 2

    rng = random.Random((n ^ 0x9E3779B97F4A7C15) & ((1 << 64) - 1))
    for _ in range(rounds):
        a = rng.randrange(2, n - 1)
        x = pow(a, d, n)
        if x in (1, n - 1):
            continue
        for __ in range(s - 1):
            x = pow(x, 2, n)
            if x == n - 1:
                break
        else:
            return False
    return True


def random_probable_prime(bits: int, rng: random.Random) -> int:
    while True:
        candidate = rng.getrandbits(bits) | (1 << (bits - 1)) | 1
        while candidate.bit_length() == bits:
            if is_probable_prime(candidate):
                return candidate
            candidate += 2


@dataclass(frozen=True, slots=True)
class RNSInteger:
    """An integer x in [0, 2^2048) together with its RNS representation.

    Attributes:
        value: The integer x.
        limbs: 96-bit limb decomposition, x = sum(limbs[i] * 2^{96i}).
        residues: Channel residues, residues[i] = x mod p_i.
    """

    value: int
    limbs: tuple[int, ...]
    residues: tuple[int, ...]

    @staticmethod
    def from_int(x: int, channel_moduli: Sequence[int]) -> "RNSInteger":
        limbs = tuple(split_limbs_2048(x))
        residues = tuple(x % p for p in channel_moduli)
        return RNSInteger(value=x, limbs=limbs, residues=residues)

    @property
    def chunks(self) -> tuple[int, ...]:
        return limbs_to_chunks(self.limbs)

    def serialize_to_calldata(self) -> list[int]:
        calldata = []
        for chunk in self.chunks:
            calldata.extend(split_words_96(chunk, CHUNK_LIMBS))
        return calldata


@dataclass(frozen=True, slots=True)
class ReductionWitness:
    """Witness for a modular reduction a * b = q * n + r over Z.

    Attributes:
        quotient: q = floor(a*b / n) as an RNS integer.
        remainder: r = (a*b) mod n as an RNS integer.
    """

    quotient: RNSInteger
    remainder: RNSInteger

    def serialize_to_calldata(self) -> list[int]:
        return (
            self.quotient.serialize_to_calldata()
            + self.remainder.serialize_to_calldata()
        )


@dataclass(frozen=True, slots=True)
class RSA2048ExponentiationWitness:
    """Complete witness for RSA-2048 verification: s^e = m (mod n).

    Contains the modulus n, signature s, expected message m, and 17
    reduction witnesses certifying the square-and-multiply chain
    for s^{65537} mod n.
    """

    modulus: RNSInteger
    signature: RNSInteger
    expected_message: RNSInteger
    reductions: tuple[ReductionWitness, ...]

    def __post_init__(self) -> None:
        if len(self.reductions) != RSA_REDUCTION_COUNT:
            raise ValueError(
                f"expected {RSA_REDUCTION_COUNT} reductions, got {len(self.reductions)}"
            )

    def serialize_public_key(self) -> list[int]:
        return self.modulus.serialize_to_calldata()

    def serialize_signature_with_hint(self) -> list[int]:
        calldata = (
            self.signature.serialize_to_calldata()
            + self.expected_message.serialize_to_calldata()
        )
        for witness in self.reductions:
            calldata.extend(witness.serialize_to_calldata())
        return calldata

    def serialize(self, prepend_public_key: bool = True) -> list[int]:
        calldata = []
        if prepend_public_key:
            calldata.extend(self.serialize_public_key())
        calldata.extend(self.serialize_signature_with_hint())
        return calldata


class RNSContext:
    """RNS arithmetic context for CRT-based exact modular verification.

    Defines the RNS basis {p_1, ..., p_k} and precomputes CRT
    reconstruction coefficients. The product M = prod(p_i) must exceed
    CRT_EXACTNESS_BOUND to guarantee that channel congruences imply
    integer equality.

    Attributes:
        primes: Channel primes p_1, ..., p_k.
        M: CRT modulus, M = prod(p_i).
        cofactors: CRT cofactors, M_i = M / p_i.
        cofactor_inverses: CRT lifting coefficients, M_i^{-1} mod p_i.
    """

    def __init__(self, channel_moduli: Sequence[int]) -> None:
        self.primes = list(channel_moduli)

        if not self.primes:
            raise ValueError("at least one channel modulus is required")
        if len(set(self.primes)) != len(self.primes):
            raise ValueError("channel moduli must be distinct")
        if not all(p < BASE**4 for p in self.primes):
            raise ValueError("channel moduli must fit in 4 x 96-bit words")
        if not all(is_probable_prime(p) for p in self.primes):
            raise ValueError("channel moduli must be prime")
        if math.prod(self.primes) <= CRT_EXACTNESS_BOUND:
            raise ValueError("CRT modulus is too small for exactness")

        self.M = math.prod(self.primes)
        self.cofactors = [self.M // p for p in self.primes]
        self.cofactor_inverses = [
            pow(M_i, -1, p) for M_i, p in zip(self.cofactors, self.primes)
        ]

    def encode(self, x: int) -> RNSInteger:
        return RNSInteger.from_int(x, self.primes)

    def residues_from_limbs(self, limbs: Sequence[int]) -> tuple[int, ...]:
        """Compute channel residues directly from the limb decomposition."""
        _ = join_limbs_2048(limbs)
        out = []
        for p in self.primes:
            acc = 0
            for limb in reversed(limbs):
                acc = (acc * BASE + limb) % p
            out.append(acc)
        return tuple(out)

    def crt_reconstruct(self, residues: Sequence[int]) -> int:
        """Reconstruct x in [0, M) from its channel residues via the CRT."""
        if len(residues) != len(self.primes):
            raise ValueError("wrong number of residues")
        x = 0
        for r_i, p_i, M_i, M_i_inv in zip(
            residues, self.primes, self.cofactors, self.cofactor_inverses
        ):
            if not (0 <= r_i < p_i):
                raise ValueError("residue out of range")
            x = (x + r_i * M_i * M_i_inv) % self.M
        return x

    def is_consistent_encoding(self, ev: RNSInteger) -> bool:
        """Check that limbs and residues are consistent with the integer value."""
        try:
            value_from_limbs = join_limbs_2048(ev.limbs)
        except ValueError:
            return False
        if value_from_limbs != ev.value:
            return False
        return ev.residues == self.residues_from_limbs(ev.limbs)

    def rns_congruences_hold(
        self,
        a: RNSInteger,
        b: RNSInteger,
        modulus: RNSInteger,
        quotient: RNSInteger,
        remainder: RNSInteger,
    ) -> bool:
        """Check a*b = q*n + r (mod p_i) in every RNS channel."""
        for ev in (a, b, modulus, quotient, remainder):
            if not self.is_consistent_encoding(ev):
                return False

        if not (0 <= remainder.value < modulus.value):
            return False

        for idx, p in enumerate(self.primes):
            lhs = (a.residues[idx] * b.residues[idx]) % p
            rhs = (
                quotient.residues[idx] * modulus.residues[idx] + remainder.residues[idx]
            ) % p
            if lhs != rhs:
                return False
        return True

    def crt_exactness_holds(
        self,
        a: RNSInteger,
        b: RNSInteger,
        modulus: RNSInteger,
        quotient: RNSInteger,
        remainder: RNSInteger,
    ) -> bool:
        """Check |delta| < M and delta = 0 (mod M) where delta = a*b - q*n - r."""
        delta = a.value * b.value - quotient.value * modulus.value - remainder.value
        return (delta % self.M == 0) and (abs(delta) < self.M)

    def verify_exact_modular_product(
        self,
        a: RNSInteger,
        b: RNSInteger,
        modulus: RNSInteger,
        quotient: RNSInteger,
        remainder: RNSInteger,
    ) -> bool:
        """Verify a*b = q*n + r exactly via RNS congruences and CRT exactness."""
        if not self.rns_congruences_hold(a, b, modulus, quotient, remainder):
            return False
        if not self.crt_exactness_holds(a, b, modulus, quotient, remainder):
            return False
        return a.value * b.value == quotient.value * modulus.value + remainder.value


def witness_modular_product(
    ctx: RNSContext, a: int, b: int, modulus: int
) -> tuple[RNSInteger, RNSInteger, RNSInteger, RNSInteger, RNSInteger]:
    """Compute the RNS encoding of (a, b, n, q, r) where a*b = q*n + r."""
    if not (0 <= a < modulus and 0 <= b < modulus and 1 < modulus < MAX_2048):
        raise ValueError("require 0 <= a,b < modulus < 2^2048 and modulus > 1")
    quotient, remainder = divmod(a * b, modulus)
    return (
        ctx.encode(a),
        ctx.encode(b),
        ctx.encode(modulus),
        ctx.encode(quotient),
        ctx.encode(remainder),
    )


def build_reduction_witness(
    ctx: RNSContext, a: int, b: int, modulus: int
) -> ReductionWitness:
    """Build and verify a reduction witness for a*b mod n."""
    a_ev, b_ev, modulus_ev, quotient_ev, remainder_ev = witness_modular_product(
        ctx, a, b, modulus
    )
    if not ctx.verify_exact_modular_product(
        a_ev, b_ev, modulus_ev, quotient_ev, remainder_ev
    ):
        raise AssertionError("exact RNS/CRT modular multiplication check failed")
    return ReductionWitness(quotient=quotient_ev, remainder=remainder_ev)


def verified_mul_mod(ctx: RNSContext, x: int, y: int, modulus: int) -> int:
    """Compute x*y mod n with a verified RNS reduction."""
    return build_reduction_witness(ctx, x, y, modulus).remainder.value


def generate_demo_rsa_key(
    bits: int = RSA_BITS,
    e: int = RSA_PUBLIC_EXPONENT,
    seed: int = 20260305,
) -> tuple[int, int, int]:
    if bits != RSA_BITS:
        raise ValueError("this helper is written around RSA-2048")

    rng = random.Random(seed)
    half = bits // 2

    while True:
        p = random_probable_prime(half, rng)
        if math.gcd(p - 1, e) == 1:
            break

    while True:
        q = random_probable_prime(half, rng)
        if q != p and math.gcd(q - 1, e) == 1:
            break

    modulus = p * q
    if modulus.bit_length() != bits:
        return generate_demo_rsa_key(bits=bits, e=e, seed=seed + 1)

    phi = (p - 1) * (q - 1)
    private_exponent = modinv(e, phi)
    return modulus, e, private_exponent


def build_rsa2048_reductions(
    ctx: RNSContext,
    signature: int,
    expected_message: int,
    modulus: int,
    e: int = RSA_PUBLIC_EXPONENT,
) -> tuple[ReductionWitness, ...]:
    """Compute all reduction witnesses for the square-and-multiply chain s^e mod n.

    For e = 65537 = 2^16 + 1, the binary representation has 17 bits,
    yielding 16 squarings and 1 final multiplication = 17 reductions.
    """
    bits = bin(e)[2:]
    if bits[0] != "1":
        raise ValueError("public exponent must be positive")

    acc = signature
    reductions = []
    for bit in bits[1:]:
        squaring = build_reduction_witness(ctx, acc, acc, modulus)
        reductions.append(squaring)
        acc = squaring.remainder.value
        if bit == "1":
            multiply = build_reduction_witness(ctx, acc, signature, modulus)
            reductions.append(multiply)
            acc = multiply.remainder.value

    if acc != expected_message:
        raise AssertionError("witness path does not yield the expected message")
    if len(reductions) != RSA_REDUCTION_COUNT:
        raise AssertionError(
            f"expected {RSA_REDUCTION_COUNT} reductions, got {len(reductions)}"
        )
    return tuple(reductions)


def generate_rsa2048_witness(seed: int = 0) -> RSA2048ExponentiationWitness:
    """Generate a complete RSA-2048 verification witness from a deterministic seed."""
    ctx = RNSContext(CHANNEL_MODULI)
    modulus, e, private_exponent = generate_demo_rsa_key(seed=20260305 + seed)
    rng = random.Random(0x5253412048 + seed)
    expected_message = rng.randrange(2, modulus - 1)
    signature = pow(expected_message, private_exponent, modulus)
    reductions = build_rsa2048_reductions(
        ctx, signature, expected_message, modulus, e=e
    )
    return RSA2048ExponentiationWitness(
        modulus=ctx.encode(modulus),
        signature=ctx.encode(signature),
        expected_message=ctx.encode(expected_message),
        reductions=reductions,
    )


# PKCS#1 v1.5 SHA-256 DigestInfo prefix (DER-encoded AlgorithmIdentifier + NULL param).
# RFC 8017, Section 9.2, Note 1.
PKCS1_SHA256_DIGEST_INFO_PREFIX = bytes.fromhex(
    "3031300d060960864801650304020105000420"
)


def pkcs1_v1_5_encode_sha256(
    message_hash: bytes, modulus_byte_length: int = 256
) -> int:
    """Encode a SHA-256 hash as a PKCS#1 v1.5 padded integer.

    Constructs: 0x00 || 0x01 || PS || 0x00 || DigestInfo || H
    where PS is (modulus_byte_length - 3 - len(DigestInfo) - 32) bytes of 0xFF.

    For RSA-2048 (modulus_byte_length=256), PS is 202 bytes of 0xFF.
    """
    if len(message_hash) != 32:
        raise ValueError("message_hash must be exactly 32 bytes (SHA-256)")
    digest_info = PKCS1_SHA256_DIGEST_INFO_PREFIX + message_hash
    ps_len = modulus_byte_length - 3 - len(digest_info)
    if ps_len < 8:
        raise ValueError("modulus too short for PKCS#1 v1.5 SHA-256 encoding")
    encoded = b"\x00\x01" + b"\xff" * ps_len + b"\x00" + digest_info
    return int.from_bytes(encoded, byteorder="big")


def generate_rsa2048_sha256_witness(
    message: bytes, seed: int = 0
) -> RSA2048ExponentiationWitness:
    """Generate an RSA-2048 verification witness for a SHA-256 message digest.

    Signs the PKCS#1 v1.5 encoding of SHA-256(message) under a deterministic
    demo key, then builds the full exponentiation witness.
    """
    ctx = RNSContext(CHANNEL_MODULI)
    modulus, e, private_exponent = generate_demo_rsa_key(seed=20260305 + seed)

    message_hash = hashlib.sha256(message).digest()
    expected_message = pkcs1_v1_5_encode_sha256(message_hash)
    signature = pow(expected_message, private_exponent, modulus)

    reductions = build_rsa2048_reductions(
        ctx, signature, expected_message, modulus, e=e
    )
    return RSA2048ExponentiationWitness(
        modulus=ctx.encode(modulus),
        signature=ctx.encode(signature),
        expected_message=ctx.encode(expected_message),
        reductions=reductions,
    )


def is_valid_rsa2048_witness(
    bundle: RSA2048ExponentiationWitness,
    ctx: RNSContext | None = None,
) -> bool:
    """Validate an RSA-2048 exponentiation witness.

    Checks encoding consistency, range constraints, and all 17 modular
    reduction steps of the square-and-multiply chain.
    """
    ctx = ctx or RNSContext(CHANNEL_MODULI)

    if not ctx.is_consistent_encoding(bundle.modulus):
        return False
    if not ctx.is_consistent_encoding(bundle.signature):
        return False
    if not ctx.is_consistent_encoding(bundle.expected_message):
        return False
    if bundle.modulus.value <= 1 or bundle.modulus.value % 2 == 0:
        return False
    if bundle.signature.value >= bundle.modulus.value:
        return False
    if bundle.expected_message.value >= bundle.modulus.value:
        return False
    if len(bundle.reductions) != RSA_REDUCTION_COUNT:
        return False

    acc = bundle.signature
    for witness in bundle.reductions[:-1]:
        if not ctx.verify_exact_modular_product(
            acc, acc, bundle.modulus, witness.quotient, witness.remainder
        ):
            return False
        acc = witness.remainder

    last = bundle.reductions[-1]
    if not ctx.verify_exact_modular_product(
        acc, bundle.signature, bundle.modulus, last.quotient, last.remainder
    ):
        return False
    return last.remainder.value == bundle.expected_message.value


def modular_exponentiation_with_proof(
    ctx: RNSContext, signature: int, e: int, modulus: int
) -> tuple[int, int]:
    """Compute s^e mod n via square-and-multiply with verified reductions.

    Returns (result, reduction_count).
    """
    bits = bin(e)[2:]
    if bits[0] != "1":
        raise ValueError("public exponent must be positive")

    acc = signature
    reduction_count = 0
    for bit in bits[1:]:
        acc = verified_mul_mod(ctx, acc, acc, modulus)
        reduction_count += 1
        if bit == "1":
            acc = verified_mul_mod(ctx, acc, signature, modulus)
            reduction_count += 1

    return acc, reduction_count


def demo_context_summary(ctx: RNSContext) -> None:
    print("== RNS context for exact modular arithmetic ==")
    print(f"Base B = 2^{LIMB_BITS}")
    print(
        f"Big-int format = {N_LIMBS} limbs of 96 bits (top limb constrained to {TOP_LIMB_BITS} bits)"
    )
    print(f"Number of CRT channels = {len(ctx.primes)}")
    print(
        f"Each channel prime fits in 4 x 96-bit words: {all(p < BASE**4 for p in ctx.primes)}"
    )
    print(f"Channel prime bit lengths = {[p.bit_length() for p in ctx.primes]}")
    print(f"CRT modulus M bit length = {ctx.M.bit_length()}")
    print(f"CRT modulus M > exactness bound: {ctx.M > CRT_EXACTNESS_BOUND}")
    print("First channel prime split into four 96-bit words:")
    print(f"  {split_words_96(ctx.primes[0], 4)}")
    print()


def demo_crt_roundtrip(ctx: RNSContext, rng: random.Random) -> None:
    print("== CRT roundtrip from limb-consistent residues ==")
    for idx in range(1, 4):
        x = rng.getrandbits(RSA_BITS - 1)
        ev = ctx.encode(x)
        x_recovered = ctx.crt_reconstruct(ev.residues)
        assert x_recovered == x
        print(
            f"  sample {idx}: recovered exact {x.bit_length()}-bit value from residues"
        )
    print()


def demo_single_exact_relation(
    ctx: RNSContext, modulus: int, rng: random.Random
) -> None:
    print("== One exact modular product witness check ==")
    a = rng.randrange(0, modulus)
    b = rng.randrange(0, modulus)
    a_ev, b_ev, modulus_ev, quotient_ev, remainder_ev = witness_modular_product(
        ctx, a, b, modulus
    )

    assert ctx.rns_congruences_hold(a_ev, b_ev, modulus_ev, quotient_ev, remainder_ev)
    assert ctx.crt_exactness_holds(a_ev, b_ev, modulus_ev, quotient_ev, remainder_ev)
    assert ctx.verify_exact_modular_product(
        a_ev, b_ev, modulus_ev, quotient_ev, remainder_ev
    )

    print(f"  modulus bits = {modulus.bit_length()}")
    print(f"  a bits = {a.bit_length()}")
    print(f"  b bits = {b.bit_length()}")
    print(f"  q bits = {quotient_ev.value.bit_length()}")
    print(f"  r bits = {remainder_ev.value.bit_length()}")
    print("  All channel congruences passed, 0 <= r < n verified,")
    print("  and CRT exactness implies a*b = q*n + r over Z.")
    print()


def demo_negative_tests(ctx: RNSContext, modulus: int, rng: random.Random) -> None:
    print("== Negative tests (tampering is detected) ==")
    a = rng.randrange(0, modulus)
    b = rng.randrange(0, modulus)
    a_ev, b_ev, modulus_ev, quotient_ev, remainder_ev = witness_modular_product(
        ctx, a, b, modulus
    )

    bad_residues = list(remainder_ev.residues)
    bad_residues[0] = (bad_residues[0] + 1) % ctx.primes[0]
    bad_remainder = RNSInteger(
        remainder_ev.value, remainder_ev.limbs, tuple(bad_residues)
    )
    assert not ctx.rns_congruences_hold(
        a_ev, b_ev, modulus_ev, quotient_ev, bad_remainder
    )

    bad_limbs = list(quotient_ev.limbs)
    bad_limbs[1] ^= 1
    bad_quotient = RNSInteger(quotient_ev.value, tuple(bad_limbs), quotient_ev.residues)
    assert not ctx.is_consistent_encoding(bad_quotient)

    print("  Tampered residue detected: PASS")
    print("  Tampered limb detected: PASS")
    print()


def demo_full_rsa_verification(ctx: RNSContext) -> None:
    print("== Full RSA-2048 verification via square-and-multiply ==")
    modulus, e, private_exponent = generate_demo_rsa_key()
    rng = random.Random(999)
    message = rng.randrange(2, modulus - 1)
    signature = pow(message, private_exponent, modulus)

    verified_message, reduction_count = modular_exponentiation_with_proof(
        ctx, signature, e, modulus
    )

    assert verified_message == message
    assert verified_message == pow(signature, e, modulus)

    print(f"  RSA modulus bits = {modulus.bit_length()}")
    print(f"  public exponent e = {e}")
    print(f"  signature verification succeeded = {verified_message == message}")
    print(f"  verified modular reductions = {reduction_count}")
    print(
        "  For e = 65537 = 2^16 + 1, the chain uses 16 squarings + 1 multiply = 17 reductions."
    )
    print()


def run_self_tests() -> None:
    ctx = RNSContext(CHANNEL_MODULI)
    rng = random.Random(123456789)

    demo_context_summary(ctx)
    demo_crt_roundtrip(ctx, rng)
    modulus, _, _ = generate_demo_rsa_key()
    demo_single_exact_relation(ctx, modulus, rng)
    demo_negative_tests(ctx, modulus, rng)
    demo_full_rsa_verification(ctx)

    bundle = generate_rsa2048_witness()
    assert is_valid_rsa2048_witness(bundle, ctx)
    print("All demonstrations and assertions passed.")


if __name__ == "__main__":
    run_self_tests()
