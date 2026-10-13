"""Exact rank-four LLL reconstruction for GLV + fake-GLV hints."""

from fractions import Fraction
from math import isqrt


def _round_nearest(value: Fraction) -> int:
    """Round ties away from zero, identically to the Rust producer."""
    q, r = divmod(abs(value.numerator), value.denominator)
    q += 2 * r >= value.denominator
    return -q if value < 0 else q


def _gram_schmidt(
    basis: list[list[int]],
) -> tuple[list[list[Fraction]], list[Fraction]]:
    mu = [[Fraction(0) for _ in range(4)] for _ in range(4)]
    orthogonal = []
    norms = []
    for i, row in enumerate(basis):
        vector = list(map(Fraction, row))
        for j in range(i):
            mu[i][j] = sum(a * b for a, b in zip(row, orthogonal[j])) / norms[j]
            vector = [a - mu[i][j] * b for a, b in zip(vector, orthogonal[j])]
        orthogonal.append(vector)
        norms.append(sum(a * a for a in vector))
    return mu, norms


def rational_reconstruct_extension(
    modulus: int, scalar: int, eigenvalue: int
) -> tuple[int, int, int, int]:
    """Return short (u1,u2,v1,v2) with u1+λu2+s(v1+λv2)=0 modulo n.

    The full-rank kernel basis has determinant n. Like gnark's reconstruction,
    LLL uses δ=99/100 and stops at a usable vector bounded by floor(n^(1/4)).
    Cached Gram-Schmidt updates avoid repeated rational orthogonalization.
    """
    if modulus <= 1:
        raise ValueError("The lattice modulus must be greater than one")
    scalar %= modulus
    eigenvalue %= modulus
    basis = [
        [modulus, 0, 0, 0],
        [-eigenvalue, 1, 0, 0],
        [-scalar, 0, 1, 0],
        [-(scalar * eigenvalue % modulus), 0, 0, 1],
    ]
    bound = isqrt(isqrt(modulus))

    def usable(row: list[int]) -> bool:
        return (row[2] + eigenvalue * row[3]) % modulus != 0

    def small(row: list[int]) -> bool:
        return usable(row) and all(abs(coordinate) <= bound for coordinate in row)

    for row in basis:
        if small(row):
            return tuple(row)

    mu, norms = _gram_schmidt(basis)
    k = 1
    while k < 4:
        for j in range(k - 1, -1, -1):
            if abs(mu[k][j]) > Fraction(1, 2):
                q = _round_nearest(mu[k][j])
                basis[k] = [a - q * b for a, b in zip(basis[k], basis[j])]
                for i in range(j):
                    mu[k][i] -= q * mu[j][i]
                mu[k][j] -= q
                if small(basis[k]):
                    return tuple(basis[k])

        old_mu = mu[k][k - 1]
        if norms[k] >= (Fraction(99, 100) - old_mu * old_mu) * norms[k - 1]:
            k += 1
            continue

        basis[k], basis[k - 1] = basis[k - 1], basis[k]
        combined_norm = norms[k] + old_mu * old_mu * norms[k - 1]
        new_mu = old_mu * norms[k - 1] / combined_norm
        norms[k] = norms[k] * norms[k - 1] / combined_norm
        norms[k - 1] = combined_norm
        for j in range(k - 1):
            mu[k][j], mu[k - 1][j] = mu[k - 1][j], mu[k][j]
        mu[k][k - 1] = new_mu
        for i in range(k + 1, 4):
            previous = mu[i][k]
            mu[i][k] = mu[i][k - 1] - old_mu * previous
            mu[i][k - 1] = previous + new_mu * mu[i][k]
        for row in basis[k - 1 : k + 1]:
            if small(row):
                return tuple(row)
        k = max(k - 1, 1)

    result = min(
        (row for row in basis if usable(row)), key=lambda row: max(map(abs, row))
    )
    max_bits = (modulus.bit_length() + 3) // 4 + 1
    if any(abs(coordinate).bit_length() > max_bits for coordinate in result):
        raise ValueError("The reconstructed GLV coefficients exceed the circuit bound")
    return tuple(result)
