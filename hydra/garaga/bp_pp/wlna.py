from __future__ import annotations

from dataclasses import dataclass

from garaga.algebra import PyFelt
from garaga.bp_pp.bp_transcript import Transcript
from garaga.bp_pp.bp_utils import (
    reduce,
    scalar_vector_mul,
    scalar_vector_mul_weighted,
    vector_add,
    vector_mul_scalar,
)
from garaga.definitions import CurveID, G1Point, get_base_field


@dataclass(slots=True)
class WLNAPublicSetup:
    G: G1Point
    G_vec: list[G1Point]
    H_vec: list[G1Point]
    c: list[PyFelt]
    rho: PyFelt
    mu: PyFelt

    @staticmethod
    def init(n: int, curve: CurveID) -> "WLNAPublicSetup":
        g = G1Point.gen_random_point(curve)
        g_vec = [G1Point.gen_random_point(curve) for _ in range(n)]
        h_vec = [G1Point.gen_random_point(curve) for _ in range(n)]
        c = [PyFelt.gen_random_felt(curve) for _ in range(n)]
        rho = PyFelt.random()
        mu = PyFelt.random()


@dataclass(slots=True)
class WLNAProof:
    r: list[G1Point]
    x: list[G1Point]
    l: list[PyFelt]
    n: list[PyFelt]

    def is_well_formed(self) -> bool:
        if len(self.x) != len(self.r):
            return False
        return True

    def size(self) -> str:
        return f"{len(self.r)+len(self.x)}Pts + {len(self.l)+len(self.n)} scalars"


def commit_wlna(setup: WLNAPublicSetup, l: list[PyFelt], n: list[PyFelt]) -> G1Point:
    # v = <c, l> + |n|_{mu}^2
    # C = vG + ⟨l, H⟩ + ⟨n, G⟩
    G1_INFINITY = G1Point.infinity(setup.G.curve_id)
    v = sum(ci * li for ci, li in zip(setup.c, l)) + sum(
        n[i] ** 2 * setup.mu ** (i + 1) for i in range(len(n))
    )
    C = (
        setup.G * v
        + sum((li * Hi for li, Hi in zip(l, setup.H_vec)), start=G1_INFINITY)
        + sum((ni * Gi for ni, Gi in zip(n, setup.G_vec)), start=G1_INFINITY)
    )
    return C


def prove_wlna(
    setup: WLNAPublicSetup, t: Transcript, l: list[PyFelt], n: list[PyFelt]
) -> WLNAProof:
    """
    Create a weight norm linear argument proof.

    This proves knowledge of vectors `l`, `n` that satisfy:
    C = v·g + ⟨l, h_vec⟩ + ⟨n, g_vec⟩
    where v = |n|²_μ + ⟨c, l⟩
    """
    curve_id = setup.G.curve_id
    # Base case: if vectors are small enough, return them directly
    if len(l) + len(n) < 6:
        return WLNAProof(r=[], x=[], l=l, n=n)

    # Compute ρ⁻¹ for later use
    rho_inv = setup.rho.inverse()

    # print(f"rho: {hex(setup.rho.value)}")
    # print(f"rho_inv: {hex(rho_inv.value)}")

    # Split vectors into even and odd indices
    c0, c1 = reduce(setup.c)
    l0, l1 = reduce(l)
    n0, n1 = reduce(n)
    G0, G1 = reduce(setup.G_vec)
    H0, H1 = reduce(setup.H_vec)

    # μ² for weighted norm computation
    mu2 = setup.mu * setup.mu

    # Compute the x-coordinate value
    # vx = ⟨n0, n1⟩_μ² · ρ⁻¹ · 2 + ⟨c0, l1⟩ + ⟨c1, l0⟩
    vx = (
        scalar_vector_mul_weighted(n0, n1, mu2) * rho_inv * 2
        + scalar_vector_mul(c0, l1)
        + scalar_vector_mul(c1, l0)
    )

    # print(f"vx: {hex(vx.value)}")

    # Compute the r-coordinate value
    # vr = |n1|²_μ² + ⟨c1, l1⟩
    vr = scalar_vector_mul_weighted(n1, n1, mu2) + scalar_vector_mul(c1, l1)

    G1_INFINITY = G1Point.infinity(curve_id)
    # Compute x and r points
    x = (
        setup.G * vx
        + sum((H * s for H, s in zip(H0, l1, strict=False)), start=G1_INFINITY)
        + sum((H * s for H, s in zip(H1, l0, strict=False)), start=G1_INFINITY)
        + sum(
            (
                G0i * s
                for G0i, s in zip(G0, map(lambda s: s * setup.rho, n1), strict=False)
            ),
            start=G1_INFINITY,
        )
        + sum(
            (
                G1i * s
                for G1i, s in zip(G1, map(lambda s: s * rho_inv, n0), strict=False)
            ),
            start=G1_INFINITY,
        )
    )

    r = (
        setup.G * vr
        + sum((H * s for H, s in zip(H1, l1, strict=False)), start=G1_INFINITY)
        + sum((G * s for G, s in zip(G1, n1, strict=False)), start=G1_INFINITY)
    )

    # Update transcript with commitment, x, and r
    commitment = commit_wlna(setup, l, n)

    t.append_point(b"wnla_com", commitment)
    t.append_point(b"wnla_x", x)
    t.append_point(b"wnla_r", r)
    t.append_u64(b"l.sz", len(l))
    t.append_u64(b"n.sz", len(n))

    # Get challenge
    field = get_base_field(setup.G.curve_id)
    y_int = t.challenge_scalar(b"wnla_challenge")
    y = field(y_int)

    # Compute reduced generators
    h_prime = vector_add(H0, vector_mul_scalar(H1, y))
    g_prime = vector_add(vector_mul_scalar(G0, setup.rho), vector_mul_scalar(G1, y))
    c_prime = vector_add(c0, vector_mul_scalar(c1, y))

    # Compute reduced witness vectors
    l_prime = vector_add(l0, vector_mul_scalar(l1, y))
    n_prime = vector_add(vector_mul_scalar(n0, rho_inv), vector_mul_scalar(n1, y))

    # Create reduced WLNA instance
    setup_prime = WLNAPublicSetup(
        G=setup.G,
        G_vec=g_prime,
        H_vec=h_prime,
        c=c_prime,
        rho=setup.mu,  # ρ′ = μ
        mu=mu2,  # μ′ = μ²
    )

    # Recursive call
    proof = prove_wlna(setup_prime, t, l_prime, n_prime)

    # Append x and r to the proof
    proof.r.append(r)
    proof.x.append(x)

    return proof


def verify_wlna(
    setup: WLNAPublicSetup, t: Transcript, proof: WLNAProof, commitment: G1Point
) -> bool:
    """
    Verify a weight norm linear argument proof.

    Returns True if the proof is valid, False otherwise.
    """
    if not proof.is_well_formed():
        return False

    # Base case: if proof has no recursion, verify directly
    if len(proof.x) == 0:
        return commitment == commit_wlna(setup, proof.l, proof.n)

    # Split generators into even and odd indices
    c0, c1 = reduce(setup.c)
    g0, g1 = reduce(setup.G_vec)
    h0, h1 = reduce(setup.H_vec)

    # Update transcript with commitment and last proof elements
    # Use Merlin protocol
    t.append_point(b"wnla_com", commitment)
    t.append_point(b"wnla_x", proof.x[-1])
    t.append_point(b"wnla_r", proof.r[-1])
    t.append_u64(b"l.sz", len(setup.H_vec))
    t.append_u64(b"n.sz", len(setup.G_vec))

    # Get challenge
    field = get_base_field(setup.G.curve_id)
    y_int = t.get_scalar_challenge(b"wnla_challenge", setup.G.curve_id)
    y = field(y_int)

    # Compute reduced generators
    h_prime = vector_add(h0, vector_mul_scalar(h1, y))
    g_prime = vector_add(vector_mul_scalar(g0, setup.rho), vector_mul_scalar(g1, y))
    c_prime = vector_add(c0, vector_mul_scalar(c1, y))

    # Compute the reduced commitment
    # C′ = C + y·X + (y² - 1)·R
    y2 = y * y
    C_prime = commitment + y * proof.x[-1] + (y2 - 1) * proof.r[-1]

    # Create reduced WLNA instance
    setup_prime = WLNAPublicSetup(
        G=setup.G,
        G_vec=g_prime,
        H_vec=h_prime,
        c=c_prime,
        rho=setup.mu,  # ρ′ = μ
        mu=setup.mu * setup.mu,  # μ′ = μ²
    )

    # Create reduced proof (without the last elements)
    proof_prime = WLNAProof(r=proof.r[:-1], x=proof.x[:-1], l=proof.l, n=proof.n)

    # Recursive verification
    return verify_wlna(setup_prime, t, proof_prime, C_prime)
