import pytest
from garaga.algebra import BaseField, BaseFp2Field, Fp2, Polynomial, PyFelt
from garaga.curves import CURVES, CurveID
from hypothesis import given
from hypothesis import strategies as st

P = CURVES[CurveID.BN254.value].p


def field_for(field_type, p=P):
    return BaseField(p) if field_type is PyFelt else BaseFp2Field(p)


@pytest.mark.parametrize("field_type", [PyFelt, Fp2])
@pytest.mark.parametrize("values", [[0], [7], [0, 0, 0], [2, 3, 0, 0], [0, 0, 5]])
@pytest.mark.parametrize("point_value", [0, 1, 2])
def test_evaluate_zero_constant_and_trailing_zero_coefficients(
    field_type, values, point_value
):
    field = field_for(field_type)
    coefficients = [field(value) for value in values]
    polynomial = Polynomial(coefficients)
    point = field(point_value)
    expected = sum(
        (coefficient * point**index for index, coefficient in enumerate(coefficients)),
        field.zero(),
    )
    assert polynomial.evaluate(point) == expected
    assert polynomial.coefficients is coefficients
    assert [coefficient.value for coefficient in coefficients] == [
        field(value).value for value in values
    ]


@pytest.mark.parametrize("field_type", [PyFelt, Fp2])
@given(
    values=st.lists(
        st.tuples(st.integers(0, 2**384), st.integers(0, 2**384)),
        min_size=1,
        max_size=32,
    ),
    point_value=st.tuples(st.integers(0, 2**384), st.integers(0, 2**384)),
)
def test_evaluate_matches_independent_direct_power_sum(field_type, values, point_value):
    field = field_for(field_type)
    coefficients = [
        field(value[0] if field_type is PyFelt else value) for value in values
    ]
    point = field(point_value[0] if field_type is PyFelt else point_value)
    polynomial = Polynomial(coefficients)
    before = [(coefficient.value, coefficient.p) for coefficient in coefficients]
    expected = sum(
        (coefficient * point**index for index, coefficient in enumerate(coefficients)),
        field.zero(),
    )
    result = polynomial.evaluate(point)
    assert result == expected
    assert result.p == field.p
    assert polynomial.coefficients is coefficients
    assert [
        (coefficient.value, coefficient.p) for coefficient in coefficients
    ] == before


@pytest.mark.parametrize("field_type", [PyFelt, Fp2])
@pytest.mark.parametrize("trailing", [[], [1], [1, 0]])
def test_evaluate_preserves_mixed_modulus_reductions(field_type, trailing):
    field13 = field_for(field_type, 13)
    field17 = field_for(field_type, 17)
    polynomial = Polynomial(
        [field13(10), field17(10)] + [field13(value) for value in trailing]
    )
    expected = field13(4 if trailing else 0)
    assert polynomial.evaluate(field13(2)) == expected


@pytest.mark.parametrize("field_type", [PyFelt, Fp2])
def test_evaluate_empty_coefficient_storage_returns_existing_zero(field_type):
    field = field_for(field_type)
    polynomial = Polynomial([field.zero()])
    polynomial.coefficients.clear()
    assert polynomial.evaluate(field(2)) is polynomial.zero_field


@pytest.mark.parametrize("field_type", [PyFelt, Fp2])
def test_evaluate_keeps_point_type_assertion(field_type):
    field = field_for(field_type)
    polynomial = Polynomial([field.one()])
    with pytest.raises(AssertionError, match="point type must match polynomial type"):
        polynomial.evaluate(1)
