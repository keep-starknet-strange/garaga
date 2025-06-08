import time

import pytest

from garaga import garaga_rs
from garaga.bp_pp.bp_transcript import MerlinTranscript
from garaga.bp_pp.wlna import WLNAPublicSetup, prove_wlna
from garaga.definitions import CurveID, G1Point, get_scalar_field


@pytest.mark.parametrize("n", [512])
def test_wlna_parity(n):
    curve_id = CurveID.SECP256K1

    # Use deterministic setup for reproducible results
    # secp256k1 generator
    g = G1Point.get_nG(curve_id, 1)

    # Generate points deterministically by scalar multiplication
    g_vec = []
    h_vec = []
    for i in range(n):
        # Use small scalars for deterministic generation
        g_point = g.gen_random_point(curve_id)
        h_point = g.gen_random_point(curve_id)
        g_vec.append(g_point)
        h_vec.append(h_point)

    # Get the field for this curve
    field = get_scalar_field(curve_id)

    # Use deterministic scalar values
    c_vec = [field.random() for _ in range(n)]
    rho = field.random()
    mu = field.random()

    # Private inputs
    l_vec = [field.random() for _ in range(n)]
    n_vec = [field.random() for _ in range(n)]

    # Convert to hex strings for Rust binding
    g_x_hex = format(g.x, "064x")
    g_y_hex = format(g.y, "064x")
    g_vec_hex = [(format(p.x, "064x"), format(p.y, "064x")) for p in g_vec]
    h_vec_hex = [(format(p.x, "064x"), format(p.y, "064x")) for p in h_vec]
    c_vec_hex = [format(f.value, "064x") for f in c_vec]
    rho_hex = format(rho.value, "064x")
    mu_hex = format(mu.value, "064x")
    l_vec_hex = [format(f.value, "064x") for f in l_vec]
    n_vec_hex = [format(f.value, "064x") for f in n_vec]

    # Get ground truth from Rust
    t0 = time.time()
    rust_proof = garaga_rs.prove_wlna_with_challenges(
        g_x_hex,
        g_y_hex,
        g_vec_hex,
        h_vec_hex,
        c_vec_hex,
        rho_hex,
        mu_hex,
        l_vec_hex,
        n_vec_hex,
    )
    t1 = time.time()
    print(f"n: {n} Rust time: {t1-t0}")

    # Create Python setup
    setup = WLNAPublicSetup(G=g, G_vec=g_vec, H_vec=h_vec, c=c_vec, rho=rho, mu=mu)

    # print(f"\n\n\n Python")
    # Create Merlin transcript
    transcript = MerlinTranscript(label=b"WLNA")

    # Call Python implementation
    t0 = time.time()
    python_proof = prove_wlna(setup, transcript, l_vec, n_vec)

    t1 = time.time()

    print(f"n: {n} Python time: {t1-t0}")

    # print(python_proof)

    # print(rust_proof.__repr__())

    for i, (py_r, rust_r) in enumerate(zip(python_proof.r, rust_proof.r)):
        assert py_r.x == int(rust_r[0], 16), f"r[{i}].x mismatch"
        assert py_r.y == int(rust_r[1], 16), f"r[{i}].y mismatch"

    for i, (py_x, rust_x) in enumerate(zip(python_proof.x, rust_proof.x)):
        assert py_x.x == int(rust_x[0], 16), f"x[{i}].x mismatch"
        assert py_x.y == int(rust_x[1], 16), f"x[{i}].y mismatch"

    for i, (py_l, rust_l) in enumerate(zip(python_proof.l, rust_proof.l)):
        assert py_l == int(rust_l, 16), f"l[{i}] mismatch"

    for i, (py_n, rust_n) in enumerate(zip(python_proof.n, rust_proof.n)):
        assert py_n == int(rust_n, 16), f"n[{i}] mismatch"

    print(f"n: {n} size: {python_proof.size()}")
