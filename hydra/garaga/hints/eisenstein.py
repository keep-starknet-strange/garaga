from __future__ import annotations

import math
from typing import Tuple

_NEIGHBOURS = ((1, 0), (0, 1), (-1, 1), (-1, 0), (0, -1), (1, -1))


def _round_nearest(z: int, d: int) -> int:
    """Return ⌊(z+d/2)/d⌋ for *all* signs of z, using ints only."""
    half = d >> 1  # d//2,  d is always >0
    return (z + half) // d if z >= 0 else -((-z + half) // d)


class EisensteinInteger:
    """
    Represents an Eisenstein integer z = a0 + a1*ω, where ω = exp(2πi/3).

    ω satisfies ω^2 + ω + 1 = 0.
    Uses Python's built-in arbitrary-precision integers.

    Attributes:
        a0: The integer coefficient of 1.
        a1: The integer coefficient of ω.
    """

    # Class constants for common values
    ZERO: "EisensteinInteger"
    ONE: "EisensteinInteger"

    def __init__(self, a0: int = 0, a1: int = 0):
        """Initializes an EisensteinInteger."""
        if not isinstance(a0, int) or not isinstance(a1, int):
            raise TypeError("Coefficients a0 and a1 must be integers")
        self.a0: int = a0
        self.a1: int = a1

    def __str__(self) -> str:
        """Returns a user-friendly string representation (e.g., '3 + 2*ω')."""
        if self.a1 == 0:
            return str(self.a0)

        a0_str = str(self.a0) if self.a0 != 0 else ""

        if self.a1 == 1:
            a1_str = "ω"
        elif self.a1 == -1:
            a1_str = "-ω"
        else:
            a1_str = f"{self.a1}*ω"

        if not a0_str:
            return a1_str
        else:
            sign = " + " if self.a1 > 0 else " - "
            if abs(self.a1) == 1:
                a1_abs_str = "ω"
            else:
                a1_abs_str = f"{abs(self.a1)}*ω"
            return f"{a0_str}{sign}{a1_abs_str}"

    def __repr__(self) -> str:
        """Returns an unambiguous string representation 'EisensteinInteger(a0, a1)'."""
        return f"EisensteinInteger({self.a0}, {self.a1})"

    def __eq__(self, other: object) -> bool:
        """Checks equality: self == other."""
        if not isinstance(other, EisensteinInteger):
            return NotImplemented
        return self.a0 == other.a0 and self.a1 == other.a1

    # Note: No __hash__ implemented as instances are mutable via `set` methods.

    def copy(self) -> "EisensteinInteger":
        """Returns a new EisensteinInteger instance with the same value."""
        return EisensteinInteger(self.a0, self.a1)

    def set(self, other: "EisensteinInteger") -> "EisensteinInteger":
        """Sets the value of self to the value of other. Returns self."""
        if not isinstance(other, EisensteinInteger):
            raise TypeError("Argument must be an EisensteinInteger")
        self.a0 = other.a0
        self.a1 = other.a1
        return self

    def set_zero(self) -> "EisensteinInteger":
        """Sets the value of self to zero. Returns self."""
        self.a0 = 0
        self.a1 = 0
        return self

    def set_one(self) -> "EisensteinInteger":
        """Sets the value of self to one. Returns self."""
        self.a0 = 1
        self.a1 = 0
        return self

    def is_zero(self) -> bool:
        """Checks if the value is zero."""
        return self.a0 == 0 and self.a1 == 0

    def __neg__(self) -> "EisensteinInteger":
        """Computes the negation -self."""
        return EisensteinInteger(-self.a0, -self.a1)

    def conjugate(self) -> "EisensteinInteger":
        """
        Computes the complex conjugate.

        conj(a0 + a1*ω) = (a0 - a1) - a1*ω
        """
        return EisensteinInteger(self.a0 - self.a1, -self.a1)

    def __add__(self, other: "EisensteinInteger") -> "EisensteinInteger":
        """Computes the sum self + other."""
        if not isinstance(other, EisensteinInteger):
            return NotImplemented
        return EisensteinInteger(self.a0 + other.a0, self.a1 + other.a1)

    def __sub__(self, other: "EisensteinInteger") -> "EisensteinInteger":
        """Computes the difference self - other."""
        if not isinstance(other, EisensteinInteger):
            return NotImplemented
        return EisensteinInteger(self.a0 - other.a0, self.a1 - other.a1)

    def __mul__(self, other: object) -> "EisensteinInteger":
        """
        Computes the product self * other.

        Supports multiplication by another EisensteinInteger or an int.
        Uses the identity (x0+x1ω)(y0+y1ω) = (x0y0 - x1y1) + (x0y1 + x1y0 - x1y1)ω.
        """
        if isinstance(other, EisensteinInteger):
            x0, x1 = self.a0, self.a1
            y0, y1 = other.a0, other.a1
            res_a0 = x0 * y0 - x1 * y1
            res_a1 = x0 * y1 + x1 * y0 - x1 * y1
            return EisensteinInteger(res_a0, res_a1)
        elif isinstance(other, int):
            # Multiplication by an integer scalar
            return EisensteinInteger(self.a0 * other, self.a1 * other)
        else:
            return NotImplemented

    def __rmul__(self, other: object) -> "EisensteinInteger":
        """Computes the product other * self (e.g., for int * EisensteinInteger)."""
        if isinstance(other, int):
            # Integer multiplication is commutative
            return self.__mul__(other)
        else:
            # Let __mul__ handle EisensteinInteger * EisensteinInteger
            # and raise NotImplemented for other types
            return NotImplemented

    def norm(self) -> int:
        """
        Computes the norm N(self).

        N(a0 + a1*ω) = a0^2 + a1^2 - a0*a1
        The norm is always non-negative.
        """
        return self.a0**2 + self.a1**2 - self.a0 * self.a1

    def quo_rem(
        self, y: "EisensteinInteger"
    ) -> Tuple["EisensteinInteger", "EisensteinInteger"]:

        if y.is_zero():
            raise ZeroDivisionError("division by zero EisensteinInteger")

        nrm = y.norm()  # >0  (int)
        num = self * y.conjugate()  # numerator, still integers

        # first guess: independent symmetric rounding of the two coords
        q0 = _round_nearest(num.a0, nrm)
        q1 = _round_nearest(num.a1, nrm)
        q = EisensteinInteger(q0, q1)
        r = self - q * y

        # If Euclidean property already holds we’re done.
        # Otherwise walk towards the minimum by ≤ 2 unit steps.
        while r.norm() >= nrm:
            best_q, best_r, best_norm = None, None, r.norm()
            for dp, dq in _NEIGHBOURS:
                cand_q = EisensteinInteger(q0 + dp, q1 + dq)
                cand_r = self - cand_q * y
                cand_norm = cand_r.norm()
                if cand_norm < best_norm:
                    best_q, best_r, best_norm = cand_q, cand_r, cand_norm
            # guaranteed to improve because ℤ[ω] is Euclidean
            q, r = best_q, best_r
            q0, q1 = q.a0, q.a1  # update base point in case 2 steps are needed
        return q, r

    def __floordiv__(self, other: "EisensteinInteger") -> "EisensteinInteger":
        """Computes the quotient self // other using Euclidean rounding division."""
        if not isinstance(other, EisensteinInteger):
            return NotImplemented
        q, _ = self.quo_rem(other)
        return q

    def __mod__(self, other: "EisensteinInteger") -> "EisensteinInteger":
        """Computes the remainder self % other using Euclidean rounding division."""
        if not isinstance(other, EisensteinInteger):
            return NotImplemented
        _, r = self.quo_rem(other)
        return r


# Define class constants after the class is fully defined
EisensteinInteger.ZERO = EisensteinInteger(0, 0)
EisensteinInteger.ONE = EisensteinInteger(1, 0)


def half_gcd(
    a: EisensteinInteger, b: EisensteinInteger
) -> Tuple[EisensteinInteger, EisensteinInteger, EisensteinInteger]:
    """
    Computes the partial GCD result using the Half-GCD approach based on norm reduction.

    Args:
        a: The first EisensteinInteger.
        b: The second EisensteinInteger.

    Returns:
        A tuple (w, v, u) such that w = a*u + b*v and norm(w) is approximately
        less than sqrt(norm(a)). The identity w = a*u + b*v always holds.

    Raises:
        TypeError: If inputs are not EisensteinInteger instances.
        ValueError: If the norm of 'a' is unexpectedly negative.
        RuntimeError: If the algorithm takes an excessive number of iterations.
    """
    if not isinstance(a, EisensteinInteger) or not isinstance(b, EisensteinInteger):
        raise TypeError("Inputs must be EisensteinInteger instances")

    # Initialize variables for the Extended Euclidean Algorithm
    a_run = a.copy()
    b_run = b.copy()
    u = EisensteinInteger.ONE.copy()  # Use class constant copies
    v = EisensteinInteger.ZERO.copy()
    u_ = EisensteinInteger.ZERO.copy()
    v_ = EisensteinInteger.ONE.copy()
    # Invariants: a_run = a*u + b*v,  b_run = a*u_ + b*v_

    norm_a = a.norm()
    if norm_a < 0:
        raise ValueError("Norm of input 'a' cannot be negative")
    # Calculate the termination threshold
    limit = math.isqrt(norm_a)

    # Loop while the norm of the 'smaller' value (b_run) is >= the limit
    iteration = 0
    max_iterations = 200000  # Safety limit

    while b_run.norm() >= limit:
        if iteration > max_iterations:
            raise RuntimeError(
                f"HalfGCD exceeded {max_iterations} iterations for a={a}, b={b}"
            )

        if b_run.is_zero():
            break  # GCD is a_run

        try:
            quotient, remainder = a_run.quo_rem(b_run)
        except ZeroDivisionError:
            # Should ideally not happen if b_run.is_zero() check works
            break

        # Update coefficients
        next_u_ = u - quotient * u_
        next_v_ = v - quotient * v_

        # Update state
        a_run, b_run = b_run, remainder
        u, u_ = u_, next_u_
        v, v_ = v_, next_v_

        iteration += 1

    # Return the final state corresponding to the Go implementation's return values
    # (b_run, v_, u_) which satisfy b_run = a*u_ + b*v_
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
