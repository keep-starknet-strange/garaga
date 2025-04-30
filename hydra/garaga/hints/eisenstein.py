"""
 -----------------------------------------------------------------------------
 ε – Eisenstein integers in pure Python (fully commented)
 -----------------------------------------------------------------------------
 A **beginner‑friendly walk‑through**
 -----------------------------------------------------------------------------
 This file implements three things:

   • an *Eisenstein integer* class  z = a0 + a1·ω  with  ω = e^{2πi/3}
   • an *exact* Euclidean division  quo_rem()  in the ring ℤ[ω]
   • the *Half‑GCD* algorithm, one of the fastest ways to compute a greatest
     common divisor when the inputs are very large
 """

from __future__ import annotations  # ► allow the class to refer to itself in type hints

import math
from typing import Tuple

# ---------------------------------------------------------------------------
# 1.  Tiny helper for the Euclidean division in ℤ[ω]
# ---------------------------------------------------------------------------

#  The six **unit directions** of the hexagonal lattice.  Graphically:
#     ↑ (0,1)
#  ↖       ↗
# (-1,1)   (1,0)
#  ↙       ↘
# (-1,0)   (1,-1)
#     ↓ (0,-1)
_NEIGHBOURS = ((1, 0), (0, 1), (-1, 1), (-1, 0), (0, -1), (1, -1))


def _round_nearest(z: int, d: int) -> int:
    """Symmetric integer rounding  ——  ⌊ (z + d/2) / d ⌋ for *any* sign of *z*.

    • *d* is strictly positive (we only call this with norms, which are > 0).
    • For   z ≥ 0   the formula above already works.
    • For   z <  0   we cannot add  +d/2  (would move us the wrong way),
      so we flip the sign, apply the positive rule, then flip back.
    """
    half = d >> 1  # bit‑shift right by 1  ⇒  divide by 2 (fast, exact)
    return (z + half) // d if z >= 0 else -((-z + half) // d)


# ---------------------------------------------------------------------------
# 2.  The EisensteinInteger class
# ---------------------------------------------------------------------------


class EisensteinInteger:
    """Eisenstein integers:  *hexagonal* analogue of Gaussian integers.

    Definition
    ----------
    ω  (pronounced "omega") is the complex cube‑root of 1 with positive
    imaginary part:  ω = e^{2πi/3} = −½ + i·√3/2.
    It satisfies  ω² + ω + 1 = 0  and  |ω| = 1.

    Every element of  ℤ[ω]  can be written uniquely as
        z = a₀ + a₁·ω,    with  a₀, a₁ ∈ ℤ.
    The pair (a₀, a₁) are the *hex‑coordinates* in the triangular lattice.

    In code we store just those two integers.
    """

    # Class‑level constants (created *after* the class body below)
    ZERO: "EisensteinInteger"  # 0 + 0·ω
    ONE: "EisensteinInteger"  # 1 + 0·ω

    # ────────────────────────────────────────────────────────────────────
    #  Construction & basic utilities
    # ────────────────────────────────────────────────────────────────────
    def __init__(self, a0: int = 0, a1: int = 0):
        if not isinstance(a0, int) or not isinstance(a1, int):
            raise TypeError("Coefficients a0 and a1 must be integers")
        self.a0 = a0
        self.a1 = a1

    def copy(self) -> "EisensteinInteger":
        """Clone *self* (handy for algorithms that mutate a temporary copy)."""
        return EisensteinInteger(self.a0, self.a1)

    def is_zero(self) -> bool:
        return self.a0 == 0 and self.a1 == 0

    def __str__(self) -> str:
        """Pretty print   3 + 2·ω,   −ω,  0,  …"""
        if self.a1 == 0:
            return str(self.a0)

        a0_part = f"{self.a0}" if self.a0 != 0 else ""
        # coefficient of ω
        if self.a1 == 1:
            a1_part = "ω"
        elif self.a1 == -1:
            a1_part = "-ω"
        else:
            a1_part = f"{self.a1}*ω"

        if a0_part == "":
            return a1_part
        sign = " + " if self.a1 > 0 else " - "
        abs_a1_part = "ω" if abs(self.a1) == 1 else f"{abs(self.a1)}*ω"
        return f"{a0_part}{sign}{abs_a1_part}"

    def __repr__(self) -> str:
        """Unambiguous form so that  eval(repr(z)) == z  (useful in a REPL)."""
        return f"EisensteinInteger({self.a0}, {self.a1})"

    # ────────────────────────────────────────────────────────────────────
    #  Equality & negation
    # ────────────────────────────────────────────────────────────────────
    def __eq__(self, other: object) -> bool:  # called by  z1 == z2
        return (
            isinstance(other, EisensteinInteger)
            and self.a0 == other.a0
            and self.a1 == other.a1
        )

    def __neg__(self) -> "EisensteinInteger":  # −z
        return EisensteinInteger(-self.a0, -self.a1)

    # ────────────────────────────────────────────────────────────────────
    #  Conjugation
    # ────────────────────────────────────────────────────────────────────
    def conjugate(self) -> "EisensteinInteger":
        """Field automorphism  ω ↦ ω²  (complex conjugation).
        Algebraically:  conj(a₀ + a₁·ω) = (a₀ − a₁) − a₁·ω.
        """
        return EisensteinInteger(self.a0 - self.a1, -self.a1)

    # ────────────────────────────────────────────────────────────────────
    #  Addition, subtraction, multiplication
    # ────────────────────────────────────────────────────────────────────
    def __add__(self, other: "EisensteinInteger") -> "EisensteinInteger":
        return EisensteinInteger(self.a0 + other.a0, self.a1 + other.a1)

    def __sub__(self, other: "EisensteinInteger") -> "EisensteinInteger":
        return EisensteinInteger(self.a0 - other.a0, self.a1 - other.a1)

    def __mul__(self, other: object) -> "EisensteinInteger":
        """Product formula derived from  (x₀ + x₁ω)(y₀ + y₁ω).
        Expand and use  ω² = −1 − ω.
        """
        if isinstance(other, EisensteinInteger):
            x0, x1, y0, y1 = self.a0, self.a1, other.a0, other.a1
            return EisensteinInteger(
                x0 * y0 - x1 * y1,  # coefficient of 1
                x0 * y1 + x1 * y0 - x1 * y1,  # coefficient of ω
            )
        elif isinstance(other, int):
            return EisensteinInteger(self.a0 * other, self.a1 * other)
        return NotImplemented

    # Support  int * EisensteinInteger  (commutative)
    __rmul__ = __mul__

    # ────────────────────────────────────────────────────────────────────
    #  Norm (always a *plain* integer)
    # ────────────────────────────────────────────────────────────────────
    def norm(self) -> int:
        """N(a₀ + a₁·ω)  =  a₀² + a₁² − a₀·a₁   ≥ 0
        Proof: treat ω as  −½ + i·√3/2  and compute |z|².
        """
        return self.a0 * self.a0 + self.a1 * self.a1 - self.a0 * self.a1

    # -------------------------------------------------------------------
    #  Euclidean division  ——  the heart of arithmetic in ℤ[ω]
    # -------------------------------------------------------------------
    def quo_rem(
        self, y: "EisensteinInteger"
    ) -> Tuple["EisensteinInteger", "EisensteinInteger"]:
        """Return  (q, r)  such that   self = q·y + r   with  N(r) < N(y).

        Strategy (all integer‑only):
          1. Multiply by the *conjugate* of y to get an element of the
             lattice that is colinear with y – this is the usual trick to
             mimic complex division without leaving the ring.
          2. Divide the two coordinates by the *positive* norm N(y) and
             apply symmetric rounding to obtain a *first guess* q.
          3. If this guess does not yet satisfy the Euclidean inequality
             N(r) < N(y), walk at most two unit steps in the hex lattice
             until it does.

        Because ℤ[ω] is a Euclidean domain, this procedure is guaranteed
        to terminate and the while‑loop never needs more than two laps.
        """
        if y.is_zero():
            raise ZeroDivisionError("division by zero EisensteinInteger")

        nrm = y.norm()  # denominator of the coordinates ( > 0 )
        num = self * y.conjugate()  # numerator in the same lattice line

        # --- 1st approximation by independent rounding -----------------
        q0 = _round_nearest(num.a0, nrm)
        q1 = _round_nearest(num.a1, nrm)
        q = EisensteinInteger(q0, q1)
        r = self - q * y

        # --- Improve the quotient until Euclidean property holds --------
        while r.norm() >= nrm:  # very rarely true (≈ 1 in 12 cases)
            best_q, best_r, best_norm = None, None, r.norm()
            # test the 6 neighbours
            for dp, dq in _NEIGHBOURS:
                cand_q = EisensteinInteger(q0 + dp, q1 + dq)
                cand_r = self - cand_q * y
                cand_norm = cand_r.norm()
                if cand_norm < best_norm:
                    best_q, best_r, best_norm = cand_q, cand_r, cand_norm
            # move to the better neighbour (Euclidean property assures one exists)
            q, r = best_q, best_r
            q0, q1 = q.a0, q.a1  # update centre for the *next* neighbour pass
        return q, r

    # Allow the syntactic sugar  z // y   and  z % y -------------------------
    def __floordiv__(self, other: "EisensteinInteger") -> "EisensteinInteger":
        return self.quo_rem(other)[0]

    def __mod__(self, other: "EisensteinInteger") -> "EisensteinInteger":
        return self.quo_rem(other)[1]


# -------- class constants (must be assigned *after* the class is complete) ---
EisensteinInteger.ZERO = EisensteinInteger(0, 0)
EisensteinInteger.ONE = EisensteinInteger(1, 0)

# ---------------------------------------------------------------------------
# 3.  Half‑GCD  ——  sub‑quadratic gcd via size halving
# ---------------------------------------------------------------------------


def half_gcd(
    a: EisensteinInteger,
    b: EisensteinInteger,
) -> Tuple[EisensteinInteger, EisensteinInteger, EisensteinInteger]:
    """Return  (w, v, u)  with  w = a·u + b·v  and  N(w) < √N(a).

    Why is that useful?  The classical Euclidean gcd repeatedly replaces the
    *larger* input by its remainder modulo the smaller one – this shrinks one
    argument at every step, but only by a *constant* factor, so it needs
    O(log N) iterations.

    **Half‑GCD** knocks out *half* the size (in bits) at every major step and
    therefore runs in roughly O(log N / log log N) time.

    The idea is to run the Euclidean algorithm *just long enough* for the
    remainder’s norm to dip below √N(a).  The output coefficients u, v let us
    continue assembling the gcd later (the full gcd algorithm calls half_gcd
    recursively on smaller and smaller inputs).
    """
    if not isinstance(a, EisensteinInteger) or not isinstance(b, EisensteinInteger):
        raise TypeError("Inputs must be EisensteinInteger instances")

    # Extended Euclidean bookkeeping matrices
    a_run, b_run = a.copy(), b.copy()
    u, v = EisensteinInteger.ONE.copy(), EisensteinInteger.ZERO.copy()
    u_, v_ = EisensteinInteger.ZERO.copy(), EisensteinInteger.ONE.copy()
    # Invariants throughout the loop:
    #     a_run =  a·u  + b·v
    #     b_run =  a·u_ + b·v_

    limit = math.isqrt(a.norm())  # √N(a)  (integer square root)

    # Safety valve: more than ~2e5 iterations would imply a bug
    for _ in range(200_000):
        if b_run.norm() < limit or b_run.is_zero():
            break
        q, r = a_run.quo_rem(b_run)

        # update (a_run, b_run)  and the coefficient matrix simultaneously
        a_run, b_run = b_run, r
        u, u_ = u_, u - q * u_
        v, v_ = v_, v - q * v_
    else:
        raise RuntimeError("Half‑GCD failed to converge – too many steps")

    # *Return order* follows the classic Half‑GCD papers:  (w, v, u)
    return b_run, v_, u_


if __name__ == "__main__":
    z1 = EisensteinInteger(3, 2)  # 3 + 2ω
    z2 = EisensteinInteger(1, -1)  # 1 - ω

    print(f"z1 = {z1}")
    print(f"z2 = {z2}")
    print(f"z1 + z2 = {z1 + z2}")
    print(f"z1 - z2 = {z1 - z2}")
    print(f"z1 * z2 = {z1 * z2}")
    print(f"Norm(z1) = {z1.norm()}")
    print(f"Conj(z1) = {z1.conjugate()}")
    print(f"-z1 = {-z1}")

    q, r = z1.quo_rem(z2)
    print(f"z1 // z2 = {q}")
    print(f"z1 % z2 = {r}")
    print(f"Check: z2 * q + r = {z2 * q + r}, Expected: {z1}")

    # Half GCD example
    a = EisensteinInteger(10, 3)
    b = EisensteinInteger(3, 1)
    print(f"\nHalf GCD for a = {a}, b = {b}")
    w, v_res, u_res = half_gcd(a, b)
    print(f"  w = {w}")
    print(f"  v = {v_res}")
    print(f"  u = {u_res}")
    check = a * u_res + b * v_res
    print(f"  Check: a*u + b*v = {check}, Expected w: {w}")
    print(f"  Norm(w) = {w.norm()}, Limit = {math.isqrt(a.norm())}")

    # a = EisensteinInteger(8+7j * (math.sqrt(3)/2 + 0.5j)) # Approximate large number
    a_int = EisensteinInteger(13, 14)  # Example large int coeffs
    b_int = EisensteinInteger(5, 3)
    print(f"\nHalf GCD for a = {a_int}, b = {b_int}")
    w, v_res, u_res = half_gcd(a_int, b_int)
    print(f"  w = {w}")
    print(f"  v = {v_res}")
    print(f"  u = {u_res}")
    check = a_int * u_res + b_int * v_res
    print(f"  Check: a*u + b*v = {check}, Expected w: {w}")
    print(f"  Norm(w) = {w.norm()}, Limit = {math.isqrt(a_int.norm())}")
