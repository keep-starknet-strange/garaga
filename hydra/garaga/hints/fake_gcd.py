#!/usr/bin/env python3

import math
from dataclasses import dataclass
from typing import List, Tuple


@dataclass
class Lattice:
    """Represents a 2D lattice basis (V1, V2) derived from GLV decomposition.

    Attributes:
        V1: First basis vector [v11, v12].
        V2: Second basis vector [v21, v22], chosen to be short.
        Det: Determinant of the lattice basis (v11*v22 - v12*v21).
        b1: Rounding coefficient derived from V2, used in scalar decomposition.
        b2: Rounding coefficient derived from V1, used in scalar decomposition.
    """

    V1: Tuple[int, int]
    V2: Tuple[int, int]
    Det: int
    b1: int
    b2: int


@dataclass
class ComplexNumber:
    """Represents a number in a complex field, e.g., Gaussian or Eisenstein integers."""

    A0: int  # Real part or equivalent
    A1: int  # Imaginary part or equivalent

    def __neg__(self):
        return ComplexNumber(-self.A0, -self.A1)


def half_gcd(mod: int, input_val: int) -> Tuple[int, int]:
    """
    Computes the first vector of a GLV lattice basis for a given modulus and input.

    This is a Python adaptation of a Go function likely used for cryptographic
    scalar multiplication optimizations (GLV method).

    Args:
        mod (int): The modulus (often the group order `r`).
        input_val (int): The input value (often the eigenvalue `lambda`).

    Returns:
        Tuple[int, int]: The components (v11, |v12|) of the first basis vector V1.
    """
    lattice = precompute_lattice(mod, input_val)
    output0 = lattice.V1[0]
    output1 = lattice.V1[1]

    # The GLV decomposition often requires the absolute value of the second component.
    return output0, abs(output1)


# --- MOCK FUNCTIONS (Replace with actual implementations) ---


def mock_split_scalar(scalar: int, lattice: Lattice) -> Tuple[int, int]:
    """Mock implementation of ecc.SplitScalar.

    Decomposes a scalar based on the provided lattice basis.
    The actual algorithm depends on the GLV method details.
    Using lattice.b1, lattice.b2, lattice.Det for decomposition:
    s1 = round(scalar * b1 / 2^n)
    s2 = round(scalar * b2 / 2^n)
    k1 = s1*V1[0] + s2*V2[0]
    k2 = s1*V1[1] + s2*V2[1]
    This is a common approach, but the exact Go implementation might differ.
    For simplicity, we use a placeholder.
    """
    # Placeholder logic: Replace with actual scalar decomposition
    # This simple split is unlikely to be correct for crypto purposes.
    print(f"Warning: Using mock scalar split for scalar {scalar}")
    s0 = scalar // (lattice.V1[0] + 1)  # Arbitrary split
    s1 = scalar // (lattice.V1[1] - 1) if lattice.V1[1] != 1 else scalar // 2
    return int(s0), int(s1)


def mock_eisenstein_half_gcd(
    r: ComplexNumber, s: ComplexNumber
) -> Tuple[ComplexNumber, ComplexNumber]:
    """Mock implementation of eisenstein.HalfGCD.

    Performs a Half-GCD operation on two Eisenstein integers.
    Requires a specific algorithm for Eisenstein integers.
    """
    # Placeholder logic: Replace with actual Eisenstein Half-GCD
    print(f"Warning: Using mock Eisenstein HalfGCD for r={r}, s={s}")
    # Return some deterministic combination for predictability
    res0 = ComplexNumber(r.A0 - s.A0, r.A1 - s.A1)
    res1 = ComplexNumber(r.A0 + s.A0, r.A1 + s.A1)
    return res0, res1


# --- END MOCK FUNCTIONS ---


def half_gcd_eisenstein_signs(
    mod: int, inputs: Tuple[int, int]
) -> Tuple[int, int, int, int]:
    """
    Computes signs resulting from an Eisenstein Half-GCD operation on GLV components.

    Adapts the Go halfGCDEisensteinSigns function.

    Args:
        mod (int): The modulus (group order `r`).
        inputs (Tuple[int, int]): A tuple containing two integers:
                                  - inputs[0]: The scalar `k` to decompose.
                                  - inputs[1]: The eigenvalue `lambda`.

    Returns:
        Tuple[int, int, int, int]: A tuple of four integers (0 or 1) representing
                                   the signs of the two components (A0, A1) of the
                                   two Eisenstein numbers resulting from HalfGCD(r, -s).
                                   Output is 1 if negative, 0 otherwise.
                                   Order: [sign(res[0].A0), sign(res[0].A1), sign(res[1].A0), sign(res[1].A1)]

    Raises:
        ValueError: If the number of inputs is not 2.
    """
    if len(inputs) != 2:
        raise ValueError(f"Expected 2 inputs, got {len(inputs)}")

    scalar_k, lambda_val = inputs

    # 1. Precompute the lattice basis using lambda
    lattice = precompute_lattice(mod, lambda_val)

    # 2. Define the 'r' Eisenstein number from the first lattice vector
    r = ComplexNumber(A0=lattice.V1[0], A1=lattice.V1[1])

    # 3. Split the scalar k using the lattice basis (using mock implementation)
    sp0, sp1 = mock_split_scalar(scalar_k, lattice)

    # 4. Define the 's' Eisenstein number from the split result and negate it
    s_original = ComplexNumber(A0=sp0, A1=sp1)
    s_negated = -s_original  # Use the __neg__ method

    # 5. Perform Eisenstein Half-GCD on r and -s (using mock implementation)
    res = mock_eisenstein_half_gcd(r, s_negated)
    res0, res1 = res

    # 6. Determine the signs of the components
    sign00 = 1 if res0.A0 < 0 else 0
    sign01 = 1 if res0.A1 < 0 else 0
    sign10 = 1 if res1.A0 < 0 else 0
    sign11 = 1 if res1.A1 < 0 else 0

    return sign00, sign01, sign10, sign11


def precompute_lattice(r: int, lam: int) -> Lattice:
    """
    Computes a short 2D lattice basis related to parameters (r, lambda).

    Uses a variant of the Extended Euclidean Algorithm to find short vectors
    (v1, v2) such that v1 = [a, b] and v2 = [c, d] satisfy
    a + b*lambda = 0 (mod r) and c + d*lambda = 0 (mod r).
    See https://www.iacr.org/archive/crypto2001/21390189.pdf (Algorithm 3.7)

    Args:
        r (int): The modulus.
        lam (int): The lambda value (e.g., eigenvalue in GLV).

    Returns:
        Lattice: An object containing the lattice basis vectors (V1, V2),
                 determinant (Det), and rounding coefficients (b1, b2).

    Raises:
        ValueError: If intermediate steps lead to division by zero (e.g., lam=0 mod r)
                    or if the final determinant is zero.
    """
    # Extended Euclidean Algorithm State: [[value, s_coeff, t_coeff], ...]
    # We maintain two states [ri, si, ti] such that ri = si*r + ti*lambda
    euclidean_state: List[List[int]] = [
        [r, 1, 0],  # Corresponds to r = 1*r + 0*lambda
        [lam, 0, 1],  # Corresponds to lam = 0*r + 1*lambda
    ]

    # Compute the integer square root of r as the termination threshold
    sqrt_r: int = int(math.isqrt(r))

    # Run Euclidean algorithm until the remainder (state[1][0]) is smaller than sqrt(r)
    while abs(euclidean_state[1][0]) >= sqrt_r:
        current_rem, s_curr, t_curr = euclidean_state[1]
        prev_rem, s_prev, t_prev = euclidean_state[0]

        if current_rem == 0:
            # This occurs if lambda is a multiple of r or lambda is 0.
            raise ValueError(
                "Division by zero in Euclidean algorithm. Check inputs r and lam."
            )

        quotient: int = prev_rem // current_rem
        next_rem: int = prev_rem % current_rem

        # Update coefficients using the identity: R_next = R_prev - q * R_curr
        # where R represents [rem, s, t]
        s_next = s_prev - s_curr * quotient
        t_next = t_prev - t_curr * quotient

        # Shift states: current becomes previous, new becomes current
        euclidean_state[0] = [current_rem, s_curr, t_curr]
        euclidean_state[1] = [next_rem, s_next, t_next]

    # One final step to potentially find a shorter vector combination
    current_rem, s_curr, t_curr = euclidean_state[1]
    prev_rem, s_prev, t_prev = euclidean_state[0]

    if current_rem == 0:
        raise ValueError(
            "Division by zero in Euclidean algorithm final step. Check inputs r and lam."
        )

    quotient = prev_rem // current_rem
    # Calculate the next potential remainder and t-coefficient
    final_rem = prev_rem % current_rem
    final_t = t_prev - t_curr * quotient

    # First basis vector: V1 = [current_rem, -t_curr]
    # Satisfies current_rem + (-t_curr)*lambda = 0 mod r (since current_rem = s_curr*r + t_curr*lambda)
    V1_list: List[int] = [current_rem, -t_curr]

    # Candidate vectors for the second basis vector V2
    # Candidate 1: [prev_rem, -t_prev]
    cand1 = (prev_rem, -t_prev)
    # Candidate 2: [final_rem, -final_t]
    cand2 = (final_rem, -final_t)

    # Choose the shorter candidate vector based on squared Euclidean norm (||v||^2 = x^2 + y^2)
    norm1_sq: int = cand1[0] ** 2 + cand1[1] ** 2
    norm2_sq: int = cand2[0] ** 2 + cand2[1] ** 2

    if norm1_sq > norm2_sq:
        V2_list: List[int] = list(cand2)
    else:
        V2_list = list(cand1)

    # Calculate the determinant of the chosen basis {V1, V2}
    det: int = V1_list[0] * V2_list[1] - V1_list[1] * V2_list[0]

    if det == 0:
        # Basis vectors are linearly dependent, which shouldn't happen for typical inputs.
        raise ValueError(
            "Lattice determinant is zero. Input parameters might be unsuitable."
        )

    def round_half_away_from_zero(a: int, b: int) -> int:
        """Computes round(a / b), rounding ties away from zero.

        Equivalent to standard mathematical rounding, differs from Python's
        default round() which rounds ties to the nearest even number.
        Needed to potentially match specific Go implementation behavior.
        """
        if b == 0:
            raise ValueError("Division by zero in rounding.")
        # Perform division using absolute values
        quotient, remainder = divmod(abs(a), abs(b))
        # Check if the remainder is large enough to round up (away from zero)
        if remainder * 2 >= abs(b):
            quotient += 1
        # Restore the sign based on the original signs of a and b
        if (a < 0) != (b < 0):
            return -quotient  # Result is negative
        else:
            return quotient  # Result is positive

    # Compute rounding coefficients b1, b2 used in scalar decomposition
    # n is calculated to ensure 2^n is sufficiently larger than |det|,
    # potentially matching Go's fixed-size integer/word alignment logic.
    # The `+ 32 >> 6 << 6` part aligns the bit length to a multiple of 64.
    n_bit_length = max(
        1, det
    ).bit_length()  # Use max(1,...) for robustness if det=0 (though checked above)
    n: int = 2 * (((n_bit_length + 32) >> 6) << 6)

    # Calculate b1 = round(2^n * V2[1] / det)
    b1: int = round_half_away_from_zero(V2_list[1] << n, det)
    # Calculate b2 = round(2^n * V1[1] / det)
    b2: int = round_half_away_from_zero(V1_list[1] << n, det)

    # Return the results structured in the Lattice dataclass
    return Lattice(V1=tuple(V1_list), V2=tuple(V2_list), Det=det, b1=b1, b2=b2)
