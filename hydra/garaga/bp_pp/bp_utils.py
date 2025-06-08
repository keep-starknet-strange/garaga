from typing import TypeVar

from garaga.algebra import PyFelt
from garaga.definitions import G1Point

T = TypeVar("T")


def reduce(v: list[T]) -> tuple[list[T], list[T]]:
    """Split a list into two lists based on index parity."""
    res0 = [x for i, x in enumerate(v) if i % 2 == 0]  # Even indices
    res1 = [x for i, x in enumerate(v) if i % 2 == 1]  # Odd indices

    return res0, res1


def scalar_vector_mul(v: list[PyFelt], w: list[PyFelt]) -> PyFelt:
    """
    Compute the dot product of two vectors of scalars.

    Args:
        v: First vector
        w: Second vector

    Returns:
        Dot product of the two vectors, ie sum(v[i] * w[i] for i in range(len(v)))
    """
    max_len = max(len(v), len(w))
    v = v + [0] * (max_len - len(v))
    w = w + [0] * (max_len - len(w))
    res = 0
    for vi, wi in zip(v, w):
        res = res + vi * wi
    return res


def scalar_vector_mul_weighted(v: list[PyFelt], w: list[PyFelt], s: PyFelt) -> PyFelt:
    """
    Compute the dot product of two vectors of scalars, weighted by powers of a scalar.

    Args:
        v: First vector
        w: Second vector
        s: Weight

    Returns:
        Weighted dot product of the two vectors, ie:
          sum(v[i] * w[i] * s^(i+1) for i in range(len(v)))
    """
    max_len = max(len(v), len(w))
    v = v + [0] * (max_len - len(v))
    w = w + [0] * (max_len - len(w))
    res = 0
    weight = s
    for vi, wi in zip(v, w):
        res = res + vi * wi * weight
        weight = weight * s
    return res


def vector_add(a: list[T], b: list[T]) -> list[T]:
    """Element-wise addition of two vectors."""
    # For now, assume both vectors have the same length
    # This is true for WLNA where we split vectors evenly
    max_len = max(len(a), len(b))
    if isinstance(a[0], PyFelt):
        a = a + [0] * (max_len - len(a))
        b = b + [0] * (max_len - len(b))
    elif isinstance(a[0], G1Point):
        a = a + [G1Point.infinity(a[0].curve_id)] * (max_len - len(a))
        b = b + [G1Point.infinity(b[0].curve_id)] * (max_len - len(b))
    return [ai + bi for ai, bi in zip(a, b, strict=True)]


def vector_mul_scalar(v: list[T], s: T) -> list[T]:
    """Multiply each element of a vector by a scalar."""
    # Handle G1Point scalar multiplication specially
    from garaga.definitions import G1Point

    if v and isinstance(v[0], G1Point):
        # G1Point expects an int, not PyFelt
        s_value = s.value if hasattr(s, "value") else s
        return [vi * s_value for vi in v]
    return [vi * s for vi in v]


if __name__ == "__main__":
    pass
