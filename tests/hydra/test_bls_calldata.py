"""
Rust ↔ Python parity test for `garaga_rs.bls_calldata_builder`.

Mirrors the convention used by every other calldata builder in
Garaga (`use_rust=True/False` round-trip): the new Rust builder must
emit the same `Vec<BigUint>` byte-for-byte as a Python reconstruction
that wires together the existing primitives
(`build_hash_to_curve_hint` + `precompute_lines` + `MPCheckCalldataBuilder`).

Pinned vector matches `tools/garaga_rs/src/calldata/bls_calldata.rs`'s
`test_bls_calldata_builder_known_fixture` so the Rust unit test, the
Python parity test, and the downstream Shhh V8 fixture all agree.
"""

import pytest

from garaga import garaga_rs
import garaga.hints.io as io
from garaga.curves import CurveID
from garaga.points import G1G2Pair, G2Point
from garaga.signature import hash_to_curve
from garaga.starknet.tests_and_calldata_generators.map_to_curve import (
    build_hash_to_curve_hint,
)
from garaga.starknet.tests_and_calldata_generators.mpcheck import (
    MPCheckCalldataBuilder,
)
from garaga.precompiled_circuits.multi_miller_loop import precompute_lines


# Deterministic vector pinned across Rust + Python + Shhh V8 fixture.
SK = 0x12345678
MESSAGE_HASH = 0x05BCD634CE46C7234BD7A4B0959C3C5EDEED7F569DCFB7B33E23D7E2197A2A2F


def _build_python_calldata() -> list[int]:
    """Reconstruct the calldata in pure Python so we can compare to the
    Rust output element-wise."""
    g2_gen = G2Point.get_nG(CurveID.BLS12_381, 1)
    pubkey = g2_gen.scalar_mul(SK)
    msg_bytes = MESSAGE_HASH.to_bytes(32, "big")
    msg_pt = hash_to_curve(msg_bytes, CurveID.BLS12_381, "sha256")
    sig = msg_pt.scalar_mul(SK)
    neg_pubkey = -pubkey

    h2c_hint = build_hash_to_curve_hint(msg_bytes).to_calldata()
    lines = precompute_lines([g2_gen, neg_pubkey])

    pairs = [
        G1G2Pair(p=sig, q=g2_gen, curve_id=CurveID.BLS12_381),
        G1G2Pair(p=msg_pt, q=neg_pubkey, curve_id=CurveID.BLS12_381),
    ]
    mpc_data = MPCheckCalldataBuilder(
        curve_id=CurveID.BLS12_381,
        pairs=pairs,
        n_fixed_g2=2,
        public_pair=None,
    ).serialize_to_calldata(use_rust=True)

    body: list[int] = []
    body.extend(io.bigint_split(sig.x))
    body.extend(io.bigint_split(sig.y))
    body.extend(h2c_hint)
    body.append(len(lines) // 4)
    for pyfelt in lines:
        body.extend(io.bigint_split(pyfelt.value))
    body.extend(mpc_data)

    return [len(body)] + body


def _compress_g1(p) -> bytes:
    """BLS12-381 compressed G1 (48 bytes BE, sign bit on the top byte)."""
    p_mod = 0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAB
    bx = bytearray(p.x.to_bytes(48, "big"))
    flag = 0x80
    if 2 * p.y > p_mod:
        flag |= 0x20
    bx[0] |= flag
    return bytes(bx)


def _uncompressed_g2(p) -> bytes:
    """BLS12-381 uncompressed G2 (192 bytes BE: x0 || x1 || y0 || y1)."""
    return (
        p.x[0].to_bytes(48, "big")
        + p.x[1].to_bytes(48, "big")
        + p.y[0].to_bytes(48, "big")
        + p.y[1].to_bytes(48, "big")
    )


def test_bls_calldata_builder_rust_python_parity():
    """End-to-end: Rust output ≡ Python output, byte-for-byte."""
    g2_gen = G2Point.get_nG(CurveID.BLS12_381, 1)
    pubkey = g2_gen.scalar_mul(SK)
    msg_bytes = MESSAGE_HASH.to_bytes(32, "big")
    msg_pt = hash_to_curve(msg_bytes, CurveID.BLS12_381, "sha256")
    sig = msg_pt.scalar_mul(SK)

    rust_input = [
        MESSAGE_HASH,
        int.from_bytes(_compress_g1(sig), "big"),
        int.from_bytes(_uncompressed_g2(pubkey), "big"),
    ]
    cd_rust = garaga_rs.bls_calldata_builder(rust_input)
    cd_python = _build_python_calldata()

    assert len(cd_rust) == len(cd_python), (
        f"length mismatch: rust={len(cd_rust)} python={len(cd_python)}"
    )
    assert cd_rust == cd_python, "Rust ↔ Python calldata mismatch"


def test_bls_calldata_builder_length_matches_fixture():
    """Match the Shhh V8 fixture's expected envelope length."""
    g2_gen = G2Point.get_nG(CurveID.BLS12_381, 1)
    pubkey = g2_gen.scalar_mul(SK)
    msg_bytes = MESSAGE_HASH.to_bytes(32, "big")
    msg_pt = hash_to_curve(msg_bytes, CurveID.BLS12_381, "sha256")
    sig = msg_pt.scalar_mul(SK)

    cd = garaga_rs.bls_calldata_builder(
        [
            MESSAGE_HASH,
            int.from_bytes(_compress_g1(sig), "big"),
            int.from_bytes(_uncompressed_g2(pubkey), "big"),
        ]
    )
    # 1 (size) + 8 (sig_g1) + 12 (h2c_hint) + 1 (lines_len)
    # + 2176 (lines) + 2079 (mpcheck_hint) = 4277.
    assert len(cd) == 4277


def test_bls_calldata_builder_rejects_wrong_arity():
    with pytest.raises(ValueError):
        garaga_rs.bls_calldata_builder([0])
