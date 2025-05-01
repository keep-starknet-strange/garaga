#!/usr/bin/env python3

import math
from dataclasses import dataclass
from typing import List, Tuple

import garaga.hints.eisenstein as eisenstein
from garaga.definitions import CURVES, CurveID, G1Point


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


def split_scalar(s: int, l: Lattice) -> Tuple[int, int]:
    """Splits a scalar s into components (u, v) using a precomputed GLV lattice.

    Based on the approach described in https://www.iacr.org/archive/crypto2001/21390189.pdf,
    this function finds a vector (u, v) such that s = u + v*lambda (mod r),
    where lambda and r are the parameters used to generate the lattice l.
    The vector (u, v) is typically chosen such that u and v have smaller magnitudes than s.

    Args:
        s: The scalar to split.
        l: The precomputed Lattice object containing basis V1, V2, determinant Det,
           and rounding coefficients b1, b2.

    Returns:
        A tuple (u, v) representing the scalar decomposition.
    """
    # Calculate intermediate values k1, k2 using the scalar and rounding coefficients
    k1 = s * l.b1
    k2 = -(s * l.b2)

    # Determine the shift amount 'n' used during lattice precomputation
    # This should match the logic in precompute_lattice
    n_bit_length = max(1, l.Det).bit_length()
    n = 2 * (((n_bit_length + 32) >> 6) << 6)

    # Right-shift k1 and k2 to effectively divide by 2^n,
    # approximating division by the determinant Det.
    # This gives the integer coefficients for the closest lattice vector approximation.
    k1 >>= n
    k2 >>= n

    # Calculate the lattice vector w = k1*V1 + k2*V2
    w_vec0 = k1 * l.V1[0] + k2 * l.V2[0]
    w_vec1 = k1 * l.V1[1] + k2 * l.V2[1]

    # Calculate the final decomposition (u, v)
    # u = s - w[0]
    # v = -w[1]
    u = s - w_vec0
    v = -w_vec1

    return u, v


def half_gcd_eisenstein_hint(
    modulus: int, scalar: int, eigen_value: int
) -> Tuple[int, int, int, int]:
    glv_basis = precompute_lattice(modulus, eigen_value)
    r = eisenstein.EisensteinInteger(glv_basis.V1[0], glv_basis.V1[1])
    if scalar % modulus == modulus - 1:
        scalar = 1
    # print(f"SPLIT SCALAR INPUT: {scalar}")
    sp = split_scalar(scalar, glv_basis)
    s = eisenstein.EisensteinInteger(sp[0], sp[1])
    # in-circuit we check that Q - [s]P = 0 or equivalently Q + [-s]P = 0
    # so here we return -s instead of s.
    s = -s
    # print(f"r: {r}, \ns: {s}")
    w, v_res, _ = eisenstein.half_gcd(r, s)

    # Note : outputs can be negative.
    return w.a0, w.a1, v_res.a0, v_res.a1


from garaga.hints.io import bigint_split


def split(x):
    return bigint_split(x, 4, 2**64)


def get_glv_fake_glv_hint(
    point: G1Point, scalar: int
) -> tuple[G1Point, int, int, int, int]:
    curve = CURVES[point.curve_id.value]
    assert (
        curve.is_endomorphism_available()
    ), f"Curve {point.curve_id} does not have an endomorphism, use get_fake_glv_hint instead"
    eigen_value = curve.eigen_value
    u1, u2, v1, v2 = encode_glv_fake_glv_hint(
        *half_gcd_eisenstein_hint(curve.n, scalar, eigen_value)
    )
    Q = point.scalar_mul(scalar)
    return Q, u1, u2, v1, v2


def encode(value: int) -> int:
    return abs(value) + 2**128 if value < 0 else value


def encode_glv_fake_glv_hint(
    u1: int, u2: int, v1: int, v2: int
) -> tuple[int, int, int, int]:

    return encode(u1), encode(u2), encode(v1), encode(v2)


def get_fake_glv_hint(point: G1Point, scalar: int) -> tuple[G1Point, int, int]:
    curve = CURVES[point.curve_id.value]
    if scalar == 0:
        scalar = 1
    assert (
        not curve.is_endomorphism_available()
    ), f"Curve {point.curve_id} has an endomorphism, use get_glv_fake_glv_hint instead"
    glv_basis = precompute_lattice(curve.n, scalar)
    s1, s2 = glv_basis.V1[0], glv_basis.V1[1]
    assert (s1 + scalar * s2) % curve.n == 0
    assert 0 < s1 and s2 != 0
    Q = point.scalar_mul(scalar)
    return Q, s1, encode(s2)


def scalar_mul_glv_and_fake_glv(point: G1Point, scalar: int) -> G1Point:
    curve = CURVES[point.curve_id.value]
    assert scalar % curve.n != 0, f"Scalar is 0 for point {point}"
    assert point.is_infinity() == False, f"Point is infinity for scalar {scalar}"

    curve_id = point.curve_id
    if not curve.is_endomorphism_available():
        raise ValueError(
            "Endomorphism not available for this curve. Use fake GLV instead."
        )

    eigen_value = curve.eigen_value
    third_root_of_unity = curve.third_root_of_unity

    # %{ Hint :
    u1, u2, v1, v2 = half_gcd_eisenstein_hint(curve.n, scalar, eigen_value)
    Q = point.scalar_mul(scalar)
    print(f"Q: {Q}")
    # %} #
    if scalar % curve.n == curve.n - 1:
        _scalar = 1
        Q = G1Point.get_nG(curve_id, 2)
    else:
        _scalar = scalar

    print(f"Q: {split(Q.x)}, {split(Q.y)}")
    print(f"u1: {u1}, u2: {u2}, v1: {v1}, v2: {v2}")

    print(f"encoded hint: {encode_glv_fake_glv_hint(u1, u2, v1, v2)}")
    # Verifier :
    # We need to check that:
    # 		s*(v1 + λ*v2) + u1 + λ*u2 = 0
    assert (
        _scalar * (v1 + eigen_value * v2) + u1 + eigen_value * u2
    ) % curve.n == 0, f"Wrong decomposition for scalar {scalar}"

    # Precompute -P, -Φ(P), Φ(P):
    table_P = [None, None]
    if u1 < 0:
        table_P[1] = -point
        table_P[0] = point
    else:
        table_P[1] = point
        table_P[0] = -point

    table_Phi_P = [None, None]
    if u2 < 0:
        table_Phi_P[1] = G1Point(point.x * third_root_of_unity, -point.y, curve_id)
        table_Phi_P[0] = G1Point(point.x * third_root_of_unity, point.y, curve_id)
    else:
        table_Phi_P[1] = G1Point(point.x * third_root_of_unity, point.y, curve_id)
        table_Phi_P[0] = G1Point(point.x * third_root_of_unity, -point.y, curve_id)

    # precompute -Q, -Φ(Q), Φ(Q)
    table_Q = [None, None]
    if v1 < 0:
        table_Q[1] = -Q
        table_Q[0] = Q
    else:
        table_Q[1] = Q
        table_Q[0] = -Q

    table_Phi_Q = [None, None]
    if v2 < 0:
        table_Phi_Q[1] = G1Point(Q.x * third_root_of_unity, -Q.y, curve_id)
        table_Phi_Q[0] = G1Point(Q.x * third_root_of_unity, Q.y, curve_id)
    else:
        table_Phi_Q[1] = G1Point(Q.x * third_root_of_unity, Q.y, curve_id)
        table_Phi_Q[0] = G1Point(Q.x * third_root_of_unity, -Q.y, curve_id)

    # precompute -P-Q, P+Q, P-Q, -P+Q, -Φ(P)-Φ(Q), Φ(P)+Φ(Q), Φ(P)-Φ(Q), -Φ(P)+Φ(Q)

    table_S = [None, None, None, None]
    table_Phi_S = [None, None, None, None]

    table_S[0] = table_P[0].add(table_Q[0])  # -P-Q
    table_S[1] = -table_S[0]  # P+Q
    table_S[2] = table_P[1].add(table_Q[0])  # P-Q
    table_S[3] = -table_S[2]  # -P+Q

    for i in range(4):
        print(f"\nS{i}: {table_S[i].to_cairo_1(as_hex=False)}\n")

    print(f"table_Phi_P[0]: {split(table_Phi_P[0].x)}, {split(table_Phi_P[0].y)}")
    print(f"table_Phi_Q[0]: {split(table_Phi_Q[0].x)}, {split(table_Phi_Q[0].y)}")
    table_Phi_S[0] = table_Phi_P[0].add(table_Phi_Q[0])  # -Φ(P)-Φ(Q)
    table_Phi_S[1] = -table_Phi_S[0]  # Φ(P)+Φ(Q)
    table_Phi_S[2] = table_Phi_P[1].add(table_Phi_Q[0])  # Φ(P)-Φ(Q)
    table_Phi_S[3] = -table_Phi_S[2]  # -Φ(P)+Φ(Q)

    # we suppose that the first bits of the sub-scalars are 1 and set:
    # 		Acc = P + Q + Φ(P) + Φ(Q)
    Acc = table_S[1].add(table_Phi_S[1])
    B1 = Acc
    print(f"B1: {B1.to_cairo_1(as_hex=False)}")
    # print(f"B1: {split(B1.x)}, {split(B1.y)}")

    # then we add G (the base point) to Acc to avoid incomplete additions in
    # the loop, because when doing doubleAndAdd(Acc, Bi) as (Acc+Bi)+Acc it
    # might happen that Acc==Bi or Acc==-Bi. But now we force Acc to be
    # different than the stored Bi. However, at the end, Acc will not be the
    # point at infinity but [2^nbits]G.
    #
    # N.B.: Acc cannot be equal to G, otherwise this means G = -Φ²([s+1]P)
    Acc = Acc.add(G1Point.get_nG(point.curve_id, 1))

    # 	// u1, u2, v1, v2 < r^{1/4} (up to a constant factor).
    # // We prove that the factor is log_(3/sqrt(3)))(r).
    # // so we need to add 9 bits to r^{1/4}.nbits().
    # nbits := st.Modulus().BitLen()>>2 + 9

    n_bits = curve.n.bit_length() // 4 + 9
    # n_bits = 73

    def to_bits_le(x: int) -> List[int]:
        """
        ToBits returns the bit representation of the Element in little-endian (LSB
        first) order.
        """
        # Convert to binary string, remove '0b' prefix, pad with zeros, and reverse
        bits_be = bin(x)[2:].zfill(n_bits)
        # print(bits_be)
        return [int(b) for b in bits_be[::-1]]

    u1_bits = to_bits_le(abs(u1))
    u2_bits = to_bits_le(abs(u2))
    v1_bits = to_bits_le(abs(v1))
    v2_bits = to_bits_le(abs(v2))

    # print(f"length of u1_bits: {len(u1_bits)}")

    # // At each iteration we look up the point Bi from:
    # // 		B1  = +P + Q + Φ(P) + Φ(Q)
    # // 		B2  = +P + Q + Φ(P) - Φ(Q)

    # At each iteration we look up the point Bi from:
    # 		B1  = +P + Q + Φ(P) + Φ(Q)
    # 		B2  = +P + Q + Φ(P) - Φ(Q)

    B2 = table_S[1].add(table_Phi_S[2])
    # 		B3  = +P + Q - Φ(P) + Φ(Q)
    B3 = table_S[1].add(table_Phi_S[3])
    # 		B4  = +P + Q - Φ(P) - Φ(Q)
    B4 = table_S[1].add(table_Phi_S[0])
    # 		B5  = +P - Q + Φ(P) + Φ(Q)
    B5 = table_S[2].add(table_Phi_S[1])
    # 		B6  = +P - Q + Φ(P) - Φ(Q)
    B6 = table_S[2].add(table_Phi_S[2])
    # 		B7  = +P - Q - Φ(P) + Φ(Q)
    B7 = table_S[2].add(table_Phi_S[3])
    # 		B8  = +P - Q - Φ(P) - Φ(Q)
    B8 = table_S[2].add(table_Phi_S[0])
    # 		B9  = -P + Q + Φ(P) + Φ(Q)
    B9 = -B8
    # 		B10 = -P + Q + Φ(P) - Φ(Q)
    B10 = -B7
    # 		B11 = -P + Q - Φ(P) + Φ(Q)
    B11 = -B6
    # 		B12 = -P + Q - Φ(P) - Φ(Q)
    B12 = -B5
    # 		B13 = -P - Q + Φ(P) + Φ(Q)
    B13 = -B4
    # 		B14 = -P - Q + Φ(P) - Φ(Q)
    B14 = -B3
    # 		B15 = -P - Q - Φ(P) + Φ(Q)
    B15 = -B2
    # 		B16 = -P - Q - Φ(P) - Φ(Q)
    B16 = -B1

    # print(f"B1: {split(B1.x)}, {split(B1.y)}")
    # print(f"B2: {split(B2.x)}, {split(B2.y)}")
    # print(f"B3: {split(B3.x)}, {split(B3.y)}")
    # print(f"B4: {split(B4.x)}, {split(B4.y)}")
    # print(f"B5: {split(B5.x)}, {split(B5.y)}")
    # print(f"B6: {split(B6.x)}, {split(B6.y)}")
    # print(f"B7: {split(B7.x)}, {split(B7.y)}")
    # print(f"B8: {split(B8.x)}, {split(B8.y)}")
    # print(f"B9: {split(B9.x)}, {split(B9.y)}")
    # print(f"B10: {split(B10.x)}, {split(B10.y)}")
    # print(f"B11: {split(B11.x)}, {split(B11.y)}")
    # print(f"B12: {split(B12.x)}, {split(B12.y)}")
    # print(f"B13: {split(B13.x)}, {split(B13.y)}")
    # print(f"B14: {split(B14.x)}, {split(B14.y)}")
    # print(f"B15: {split(B15.x)}, {split(B15.y)}")
    # print(f"B16: {split(B16.x)}, {split(B16.y)}")

    # note that half the points are negatives of the other half,
    # hence have the same X coordinates.

    Bs = [B16, B8, B14, B6, B12, B4, B10, B2, B15, B7, B13, B5, B11, B3, B9, B1]
    # for i := nbits - 1; i > 0; i-- {
    print(f"Acc; {Acc.to_cairo_1(as_hex=False)}")
    for i in range(n_bits - 1, 0, -1):
        # // selectorY takes values in [0,15]

        selector_y = u1_bits[i] + 2 * u2_bits[i] + 4 * v1_bits[i] + 8 * v2_bits[i]
        # print(f"selector_y_{i}: {selector_y}")
        # // selectorX takes values in [0,7] s.t.:
        # 		- when selectorY < 8: selectorX = selectorY
        # 		- when selectorY >= 8: selectorX = 15 - selectorY

        if selector_y < 8:
            selector_x = selector_y
        else:
            selector_x = 15 - selector_y
        # print(f"selector_x_{i}: {selector_x}")
        Bi = G1Point(Bs[selector_x].x, Bs[selector_y].y, curve_id)

        # // Acc = [2]Acc + Bi

        Acc = Acc.add(Acc).add(Bi)

    print("Acc final: ", Acc.to_cairo_1(as_hex=False))
    # i = 0
    #
    # // i = 0
    # // subtract the P, Q, Φ(P), Φ(Q) if the first bits are 0
    # tableP[0] = c.Add(tableP[0], Acc)
    # Acc = c.Select(u1bits[0], Acc, tableP[0])
    # tablePhiP[0] = c.Add(tablePhiP[0], Acc)
    # Acc = c.Select(u2bits[0], Acc, tablePhiP[0])
    # tableQ[0] = c.Add(tableQ[0], Acc)
    # Acc = c.Select(v1bits[0], Acc, tableQ[0])
    # tablePhiQ[0] = c.Add(tablePhiQ[0], Acc)
    # Acc = c.Select(v2bits[0], Acc, tablePhiQ[0])

    if u1_bits[0] == 0:
        Acc = Acc.add(table_P[0])
    if u2_bits[0] == 0:
        Acc = Acc.add(table_Phi_P[0])
    if v1_bits[0] == 0:
        Acc = Acc.add(table_Q[0])
    if v2_bits[0] == 0:
        Acc = Acc.add(table_Phi_Q[0])

    # Acc should be now equal to [2^nbits]G

    gm = G1Point.get_nG(point.curve_id, 2 ** (n_bits - 1))
    # print(f"gm: {split(gm.x)}, {split(gm.y)}")
    if scalar % curve.n == curve.n - 1:
        gm = Acc
    assert Acc == gm, f"Acc is not equal to [2^nbits]G, {Acc} != {gm}"

    return Q


if __name__ == "__main__":
    import random

    random.seed(0)
    s = 111793196543967404139194827996419963236210979610743141064269745943111491389390
    print(f"scalar: {s}")

    g = G1Point.get_nG(CurveID.SECP256K1, 1)
    res = scalar_mul_glv_and_fake_glv(g, s)

    # print(g.to_cairo_1())
    # print(res.to_cairo_1())

    from garaga.definitions import *

    for curve_id in CURVES:
        curve: WeierstrassCurve = CURVES[curve_id]
        if curve.is_endomorphism_available():
            nbits = curve.n.bit_length() // 4 + 9
            used_nbits = 73
            assert (
                used_nbits >= nbits
            ), f"Curve {curve_id} has {nbits} bits, but used {used_nbits} bits"
            print(
                f"Curve {curve_id}: {nbits}, {G1Point.get_nG(CurveID(curve_id), 2 ** (used_nbits -1)).to_cairo_1()}"
            )
