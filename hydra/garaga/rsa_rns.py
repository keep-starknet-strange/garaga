from __future__ import annotations

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
DELTA_ABS_BOUND = (1 << (2 * RSA_BITS + 1)) + (1 << RSA_BITS)

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
class EncodedValue:
    value: int
    limbs: tuple[int, ...]
    residues: tuple[int, ...]

    @staticmethod
    def from_int(x: int, channel_moduli: Sequence[int]) -> "EncodedValue":
        limbs = tuple(split_limbs_2048(x))
        residues = tuple(x % p for p in channel_moduli)
        return EncodedValue(value=x, limbs=limbs, residues=residues)

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
    quotient: EncodedValue
    remainder: EncodedValue

    def serialize_to_calldata(self) -> list[int]:
        return (
            self.quotient.serialize_to_calldata()
            + self.remainder.serialize_to_calldata()
        )


@dataclass(frozen=True, slots=True)
class RSA2048WitnessBundle:
    modulus: EncodedValue
    signature: EncodedValue
    expected_message: EncodedValue
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


class CairoRNSContext:
    def __init__(self, channel_moduli: Sequence[int]) -> None:
        self.ps = list(channel_moduli)

        if not self.ps:
            raise ValueError("at least one channel modulus is required")
        if len(set(self.ps)) != len(self.ps):
            raise ValueError("channel moduli must be distinct")
        if not all(p < BASE**4 for p in self.ps):
            raise ValueError("channel moduli must fit in 4 x 96-bit words")
        if not all(is_probable_prime(p) for p in self.ps):
            raise ValueError("channel moduli must be pairwise coprime")
        if math.prod(self.ps) <= DELTA_ABS_BOUND:
            raise ValueError("combined CRT modulus is too small for exactness")

        self.M = math.prod(self.ps)
        self.M_i = [self.M // p for p in self.ps]
        self.M_i_inv = [pow(Mi, -1, p) for Mi, p in zip(self.M_i, self.ps)]

    def encode(self, x: int) -> EncodedValue:
        return EncodedValue.from_int(x, self.ps)

    def residues_from_limbs(self, limbs: Sequence[int]) -> tuple[int, ...]:
        _ = join_limbs_2048(limbs)
        out = []
        for p in self.ps:
            acc = 0
            for limb in reversed(limbs):
                acc = (acc * BASE + limb) % p
            out.append(acc)
        return tuple(out)

    def crt_reconstruct(self, residues: Sequence[int]) -> int:
        if len(residues) != len(self.ps):
            raise ValueError("wrong number of residues")
        x = 0
        for residue, p, Mi, Mi_inv in zip(residues, self.ps, self.M_i, self.M_i_inv):
            if not (0 <= residue < p):
                raise ValueError("residue out of range")
            x = (x + residue * Mi * Mi_inv) % self.M
        return x

    def check_encoding(self, ev: EncodedValue) -> bool:
        try:
            value_from_limbs = join_limbs_2048(ev.limbs)
        except ValueError:
            return False
        if value_from_limbs != ev.value:
            return False
        return ev.residues == self.residues_from_limbs(ev.limbs)

    def cairo_style_relation_holds(
        self,
        a: EncodedValue,
        b: EncodedValue,
        modulus: EncodedValue,
        quotient: EncodedValue,
        remainder: EncodedValue,
    ) -> bool:
        for ev in (a, b, modulus, quotient, remainder):
            if not self.check_encoding(ev):
                return False

        if not (0 <= remainder.value < modulus.value):
            return False

        for idx, p in enumerate(self.ps):
            lhs = (a.residues[idx] * b.residues[idx]) % p
            rhs = (
                quotient.residues[idx] * modulus.residues[idx] + remainder.residues[idx]
            ) % p
            if lhs != rhs:
                return False
        return True

    def exactness_theorem_applies(
        self,
        a: EncodedValue,
        b: EncodedValue,
        modulus: EncodedValue,
        quotient: EncodedValue,
        remainder: EncodedValue,
    ) -> bool:
        delta = a.value * b.value - quotient.value * modulus.value - remainder.value
        return (delta % self.M == 0) and (abs(delta) < self.M)

    def check_exact_mul_div_mod(
        self,
        a: EncodedValue,
        b: EncodedValue,
        modulus: EncodedValue,
        quotient: EncodedValue,
        remainder: EncodedValue,
    ) -> bool:
        if not self.cairo_style_relation_holds(a, b, modulus, quotient, remainder):
            return False
        if not self.exactness_theorem_applies(a, b, modulus, quotient, remainder):
            return False
        return a.value * b.value == quotient.value * modulus.value + remainder.value


def witness_mul_div_mod(
    ctx: CairoRNSContext, a: int, b: int, modulus: int
) -> tuple[EncodedValue, EncodedValue, EncodedValue, EncodedValue, EncodedValue]:
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
    ctx: CairoRNSContext, a: int, b: int, modulus: int
) -> ReductionWitness:
    a_ev, b_ev, modulus_ev, quotient_ev, remainder_ev = witness_mul_div_mod(
        ctx, a, b, modulus
    )
    if not ctx.check_exact_mul_div_mod(
        a_ev, b_ev, modulus_ev, quotient_ev, remainder_ev
    ):
        raise AssertionError("exact RNS/CRT modular multiplication check failed")
    return ReductionWitness(quotient=quotient_ev, remainder=remainder_ev)


def checked_mul_mod(ctx: CairoRNSContext, x: int, y: int, modulus: int) -> int:
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
    ctx: CairoRNSContext,
    signature: int,
    expected_message: int,
    modulus: int,
    e: int = RSA_PUBLIC_EXPONENT,
) -> tuple[ReductionWitness, ...]:
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
        raise AssertionError("witness path does not match the expected message")
    if len(reductions) != RSA_REDUCTION_COUNT:
        raise AssertionError(
            f"expected {RSA_REDUCTION_COUNT} reductions, got {len(reductions)}"
        )
    return tuple(reductions)


def build_rsa2048_witness_bundle(seed: int = 0) -> RSA2048WitnessBundle:
    ctx = CairoRNSContext(CHANNEL_MODULI)
    modulus, e, private_exponent = generate_demo_rsa_key(seed=20260305 + seed)
    rng = random.Random(0x5253412048 + seed)
    expected_message = rng.randrange(2, modulus - 1)
    signature = pow(expected_message, private_exponent, modulus)
    reductions = build_rsa2048_reductions(
        ctx, signature, expected_message, modulus, e=e
    )
    return RSA2048WitnessBundle(
        modulus=ctx.encode(modulus),
        signature=ctx.encode(signature),
        expected_message=ctx.encode(expected_message),
        reductions=reductions,
    )


def is_valid_rsa2048_witness(
    bundle: RSA2048WitnessBundle,
    ctx: CairoRNSContext | None = None,
) -> bool:
    ctx = ctx or CairoRNSContext(CHANNEL_MODULI)

    if not ctx.check_encoding(bundle.modulus):
        return False
    if not ctx.check_encoding(bundle.signature):
        return False
    if not ctx.check_encoding(bundle.expected_message):
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
        if not ctx.check_exact_mul_div_mod(
            acc, acc, bundle.modulus, witness.quotient, witness.remainder
        ):
            return False
        acc = witness.remainder

    last = bundle.reductions[-1]
    if not ctx.check_exact_mul_div_mod(
        acc, bundle.signature, bundle.modulus, last.quotient, last.remainder
    ):
        return False
    return last.remainder.value == bundle.expected_message.value


def verify_rsa_signature_with_exact_checks(
    ctx: CairoRNSContext, signature: int, e: int, modulus: int
) -> tuple[int, int]:
    bits = bin(e)[2:]
    if bits[0] != "1":
        raise ValueError("public exponent must be positive")

    acc = signature
    checked_steps = 0
    for bit in bits[1:]:
        acc = checked_mul_mod(ctx, acc, acc, modulus)
        checked_steps += 1
        if bit == "1":
            acc = checked_mul_mod(ctx, acc, signature, modulus)
            checked_steps += 1

    return acc, checked_steps


def demo_context_summary(ctx: CairoRNSContext) -> None:
    print("== Cairo-adapted exact RNS/CRT context ==")
    print(f"Base B = 2^{LIMB_BITS}")
    print(
        f"Big-int format = {N_LIMBS} limbs of 96 bits (top limb constrained to {TOP_LIMB_BITS} bits)"
    )
    print(f"Number of CRT channels = {len(ctx.ps)}")
    print(
        f"Each channel modulus fits in 4 x 96-bit words: {all(p < BASE**4 for p in ctx.ps)}"
    )
    print(f"Channel modulus bit lengths = {[p.bit_length() for p in ctx.ps]}")
    print(f"Combined CRT modulus bit length = {ctx.M.bit_length()}")
    print(f"Combined CRT modulus > delta bound: {ctx.M > DELTA_ABS_BOUND}")
    print("First channel modulus split into four 96-bit words:")
    print(f"  {split_words_96(ctx.ps[0], 4)}")
    print()


def demo_crt_roundtrip(ctx: CairoRNSContext, rng: random.Random) -> None:
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
    ctx: CairoRNSContext, modulus: int, rng: random.Random
) -> None:
    print("== One exact mul/div/mod witness check ==")
    a = rng.randrange(0, modulus)
    b = rng.randrange(0, modulus)
    a_ev, b_ev, modulus_ev, quotient_ev, remainder_ev = witness_mul_div_mod(
        ctx, a, b, modulus
    )

    assert ctx.cairo_style_relation_holds(
        a_ev, b_ev, modulus_ev, quotient_ev, remainder_ev
    )
    assert ctx.exactness_theorem_applies(
        a_ev, b_ev, modulus_ev, quotient_ev, remainder_ev
    )
    assert ctx.check_exact_mul_div_mod(
        a_ev, b_ev, modulus_ev, quotient_ev, remainder_ev
    )

    print(f"  modulus bits = {modulus.bit_length()}")
    print(f"  a bits = {a.bit_length()}")
    print(f"  b bits = {b.bit_length()}")
    print(f"  q bits = {quotient_ev.value.bit_length()}")
    print(f"  r bits = {remainder_ev.value.bit_length()}")
    print("  All channel congruences passed, the range check 0 <= r < modulus passed,")
    print("  and the CRT exactness bound implies a*b = q*modulus + r exactly.")
    print()


def demo_negative_tests(ctx: CairoRNSContext, modulus: int, rng: random.Random) -> None:
    print("== Negative tests (tampering is detected) ==")
    a = rng.randrange(0, modulus)
    b = rng.randrange(0, modulus)
    a_ev, b_ev, modulus_ev, quotient_ev, remainder_ev = witness_mul_div_mod(
        ctx, a, b, modulus
    )

    bad_residues = list(remainder_ev.residues)
    bad_residues[0] = (bad_residues[0] + 1) % ctx.ps[0]
    bad_remainder = EncodedValue(
        remainder_ev.value, remainder_ev.limbs, tuple(bad_residues)
    )
    assert not ctx.cairo_style_relation_holds(
        a_ev, b_ev, modulus_ev, quotient_ev, bad_remainder
    )

    bad_limbs = list(quotient_ev.limbs)
    bad_limbs[1] ^= 1
    bad_quotient = EncodedValue(
        quotient_ev.value, tuple(bad_limbs), quotient_ev.residues
    )
    assert not ctx.check_encoding(bad_quotient)

    print("  Tampered residue detected: PASS")
    print("  Tampered limb detected: PASS")
    print()


def demo_full_rsa_verification(ctx: CairoRNSContext) -> None:
    print("== Full RSA-2048 verification path with exact checks ==")
    modulus, e, private_exponent = generate_demo_rsa_key()
    rng = random.Random(999)
    message = rng.randrange(2, modulus - 1)
    signature = pow(message, private_exponent, modulus)

    verified_message, checked_steps = verify_rsa_signature_with_exact_checks(
        ctx, signature, e, modulus
    )

    assert verified_message == message
    assert verified_message == pow(signature, e, modulus)

    print(f"  RSA modulus bits = {modulus.bit_length()}")
    print(f"  public exponent e = {e}")
    print(f"  signature verification succeeded = {verified_message == message}")
    print(f"  exact mul/div/mod checks executed = {checked_steps}")
    print(
        "  For e = 65537 = 2^16 + 1, the canonical path uses 16 squarings + 1 multiply = 17 checked reductions."
    )
    print()


def run_self_tests() -> None:
    ctx = CairoRNSContext(CHANNEL_MODULI)
    rng = random.Random(123456789)

    demo_context_summary(ctx)
    demo_crt_roundtrip(ctx, rng)
    modulus, _, _ = generate_demo_rsa_key()
    demo_single_exact_relation(ctx, modulus, rng)
    demo_negative_tests(ctx, modulus, rng)
    demo_full_rsa_verification(ctx)

    bundle = build_rsa2048_witness_bundle()
    assert is_valid_rsa2048_witness(bundle, ctx)
    print("All demonstrations and assertions passed.")


if __name__ == "__main__":
    run_self_tests()
