from __future__ import annotations

import math
from typing import Tuple


def quo_rem_truncated(x: int, y: int) -> Tuple[int, int]:
    """
    Computes quotient and remainder using truncated division (towards zero).

    This mimics the behavior of Go's `big.Int.QuoRem` method.
    q = x / y (truncated towards zero)
    r = x - y * q

    Args:
        x: Dividend.
        y: Divisor.

    Returns:
        A tuple (q, r) representing the quotient and remainder.

    Raises:
        ZeroDivisionError: If y is 0.
    """
    if y == 0:
        raise ZeroDivisionError("division by zero")

    # Standard division produces a float. int() truncates floats towards zero.
    q = int(x / y)
    # The remainder is defined as r = x - y*q based on the truncated quotient.
    r = x - y * q

    # --- Verification (optional but useful) ---
    # Check remainder properties for truncated division:
    # 1. abs(r) < abs(y)
    # 2. x = y * q + r
    # 3. sign(r) == sign(x) or r == 0
    assert abs(r) < abs(
        y
    ), f"Truncated: Remainder magnitude |{r}| >= divisor magnitude |{y}|"
    assert (
        x == y * q + r
    ), f"Truncated: Definition x = y*q + r failed: {x} != {y}*{q} + {r}"
    assert r == 0 or math.copysign(1, r) == math.copysign(
        1, x
    ), f"Truncated: Remainder sign mismatch: sign({r}) != sign({x})"
    # --- End Verification ---

    return q, r


def div_euclidean(x: int, y: int) -> int:
    """
    Computes the quotient using Euclidean division (floor division).

    This mimics the behavior of Go's `big.Int.Div` method.
    For Euclidean division:
    q = floor(x / y)
    r = x - y * q, such that 0 <= r < |y|

    Python's // operator directly performs Euclidean (floor) division.

    Args:
        x: Dividend.
        y: Divisor.

    Returns:
        The Euclidean quotient q.

    Raises:
        ZeroDivisionError: If y is 0.
    """
    if y == 0:
        raise ZeroDivisionError("division by zero")

    # Python's // operator performs floor division, which corresponds
    # to the Euclidean division quotient.
    q = x // y

    # --- Verification (optional but useful) ---
    # Calculate the corresponding Euclidean remainder
    r = x % y  # Or r = x - y * q
    # Check remainder properties for Euclidean division:
    # 1. 0 <= r < |y|
    # 2. x = y * q + r
    assert 0 <= r < abs(y), f"Euclidean: Remainder {r} not in [0, |{y}|)"
    assert (
        x == y * q + r
    ), f"Euclidean: Definition x = y*q + r failed: {x} != {y}*{q} + {r}"
    # --- End Verification ---

    return q


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
        """
        Performs Euclidean division self / y using rounding to the NEAREST Eisenstein integer.

        This method guarantees norm(remainder) < norm(divisor).

        Args:
            y: The divisor (must be non-zero).

        Returns:
            A tuple (quotient, remainder).

        Raises:
            ZeroDivisionError: If y is zero.
            TypeError: If y is not an EisensteinInteger.
        """
        if not isinstance(y, EisensteinInteger):
            raise TypeError("Divisor must be an EisensteinInteger")

        norm_y = y.norm()
        if norm_y == 0:
            raise ZeroDivisionError("division by zero EisensteinInteger")

        # Calculate numerator = self * y.conjugate() = num0 + num1*ω
        num = self * y.conjugate()

        # Calculate quotient q by rounding components of num/norm_y to nearest int
        q_a0 = div_euclidean(num.a0, norm_y)
        q_a1 = div_euclidean(num.a1, norm_y)
        q = EisensteinInteger(q_a0, q_a1)

        # Calculate remainder r = self - y * q
        r = self - q * y  # Corrected order from previous edit

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
    max_iterations = 20000  # Safety limit

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
