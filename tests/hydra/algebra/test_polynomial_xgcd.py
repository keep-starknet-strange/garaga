import pytest
from garaga.algebra import BaseField, BaseFp2Field, Fp2, Polynomial, PyFelt
from hypothesis import given
from hypothesis import strategies as st


def field_for(field_type, p=31):
    return BaseField(p) if field_type is PyFelt else BaseFp2Field(p)


@pytest.mark.parametrize("field_type", [PyFelt, Fp2])
@pytest.mark.parametrize("padding", [0, 2, 5])
def test_xgcd_preserves_bezout_coefficients_and_padded_gcd_storage(field_type, padding):
    field = field_for(field_type)
    x = Polynomial([field(value) for value in [1, 2, 3] + [0] * padding])
    y = Polynomial([field(value) for value in [2, 3] + [0] * padding])
    a, b, g = Polynomial.xgcd(x, y)
    # (1 + 2x + 3x²) - x(2 + 3x) = 1, including the original remainder padding.
    assert a.coefficients == [field.one()]
    assert b.coefficients == [field.zero(), field(-1)]
    assert g.coefficients == [field.one()] + [field.zero()] * (2 + padding)
    assert a * x + b * y == g


@pytest.mark.parametrize("field_type", [PyFelt, Fp2])
@given(
    x_values=st.lists(
        st.tuples(st.integers(0, 30), st.integers(0, 30)), min_size=1, max_size=5
    ),
    y_values=st.lists(
        st.tuples(st.integers(0, 30), st.integers(0, 30)), min_size=1, max_size=5
    ),
)
def test_xgcd_preserves_bezout_divisibility_and_inputs(field_type, x_values, y_values):
    field = field_for(field_type)
    x = Polynomial(
        [field(value[0] if field_type is PyFelt else value) for value in x_values]
    )
    y = Polynomial(
        [field(value[0] if field_type is PyFelt else value) for value in y_values]
    )
    before = [[(c.value, c.p) for c in poly.coefficients] for poly in (x, y)]
    if x.is_zero() and y.is_zero():
        with pytest.raises(ValueError):
            Polynomial.xgcd(x, y)
    else:
        a, b, g = Polynomial.xgcd(x, y)
        assert a * x + b * y == g
        assert (x % g).is_zero()
        assert (y % g).is_zero()
        assert g.leading_coefficient() == field.one()
    assert [[(c.value, c.p) for c in poly.coefficients] for poly in (x, y)] == before


@pytest.mark.parametrize("field_type", [PyFelt, Fp2])
@pytest.mark.parametrize("value", [31, 62, -31])
def test_xgcd_keeps_legacy_normalization_of_noncanonical_zero(field_type, value):
    field = field_for(field_type)
    coefficient = PyFelt(value, field.p)
    if field_type is Fp2:
        coefficient = Fp2(coefficient, PyFelt(0, field.p))
    x = Polynomial([coefficient])
    y = Polynomial([field.one(), field.one()])
    a, b, g = Polynomial.xgcd(x, y)
    assert a.coefficients == [field.zero()]
    assert b.coefficients == [field.one()]
    assert g.coefficients == y.coefficients
    assert x.coefficients[0].value == coefficient.value


@pytest.mark.parametrize("field_type", [PyFelt, Fp2])
def test_xgcd_keeps_mixed_modulus_legacy_behavior(field_type):
    field13 = field_for(field_type, 13)
    field17 = field_for(field_type, 17)
    x = Polynomial(
        [field13(10), field17(10) if field_type is PyFelt else field17.zero()]
    )
    y = Polynomial([field13.one()])
    if field_type is Fp2:
        with pytest.raises(ValueError, match="Cannot divide by zero polynomial"):
            Polynomial.xgcd(x, y)
        return
    a, b, g = Polynomial.xgcd(x, y)
    assert a.coefficients == [field13.zero()]
    assert b.coefficients == [field13.one()]
    assert g.coefficients == [field13.one()]


@pytest.mark.parametrize("field_type", [PyFelt, Fp2])
def test_xgcd_two_zero_polynomials_keep_inversion_error(field_type):
    field = field_for(field_type)
    message = "Cannot invert" if field_type is PyFelt else "base is not invertible"
    with pytest.raises(ValueError, match=message):
        Polynomial.xgcd(Polynomial([field.zero()]), Polynomial([field.zero()]))


def test_xgcd_constant_type_mismatch_keeps_multiplication_error():
    with pytest.raises(TypeError, match="Cannot multiply PyFelt"):
        Polynomial.xgcd(Polynomial([PyFelt(1, 31)]), Polynomial([Fp2.one(31)]))


def test_xgcd_lower_degree_type_mismatch_keeps_legacy_attribute_error():
    with pytest.raises(AttributeError, match="type"):
        Polynomial.xgcd(
            Polynomial([PyFelt(1, 31)]), Polynomial([Fp2.one(31), Fp2.one(31)])
        )
