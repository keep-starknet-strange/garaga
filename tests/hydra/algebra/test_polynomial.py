import pytest

from garaga.algebra import BaseField, Polynomial
from garaga.curves import CURVES, CurveID

# List of curve IDs to test
p = CURVES[CurveID.SECP256K1.value].p
zero = Polynomial.zero(p)


@pytest.mark.parametrize("degree_x", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
@pytest.mark.parametrize("degree_y", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
def test_xgcd(degree_x: int, degree_y: int):
    field = BaseField(p)
    x_coeffs = [field.random() for _ in range(degree_x + 1)]
    y_coeffs = [field.random() for _ in range(degree_y + 1)]

    x = Polynomial(x_coeffs)
    y = Polynomial(y_coeffs)

    a, b, g = Polynomial.xgcd(x, y)

    assert a * x + b * y == g
    assert x % g == zero
    assert y % g == zero


@pytest.mark.parametrize("degree", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
def test_lagrange_interpolation(degree: int):
    field = BaseField(p)

    # Define domain and values for interpolation
    domain = [field(i) for i in range(1, degree + 2)]
    values = [field(i * i) for i in range(1, degree + 2)]

    # Perform Lagrange interpolation
    interpolated_poly = Polynomial.lagrange_interpolation(p, domain, values)

    # Check that the polynomial evaluates correctly at the domain points
    for x, y in zip(domain, values):
        assert interpolated_poly.evaluate(x) == y

    # Additional checks for edge cases
    domain_edge = [field(0)]
    values_edge = [field(7)]
    interpolated_poly_edge = Polynomial.lagrange_interpolation(
        p, domain_edge, values_edge
    )
    assert interpolated_poly_edge.evaluate(domain_edge[0]) == values_edge[0]

    # Check for larger set of points
    domain_large = [field(i) for i in range(1, 11)]
    values_large = [field(i * i) for i in range(1, 11)]
    interpolated_poly_large = Polynomial.lagrange_interpolation(
        p, domain_large, values_large
    )
    for x, y in zip(domain_large, values_large):
        assert interpolated_poly_large.evaluate(x) == y
