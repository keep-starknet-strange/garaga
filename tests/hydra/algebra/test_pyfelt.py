import pytest

from garaga.algebra import PyFelt

# Define a prime number for the finite field
p = 101


def test_pyfelt_addition():
    a = PyFelt(10, p)
    b = PyFelt(20, p)
    c = 30
    assert a + b == PyFelt(30, p)
    assert a + c == PyFelt(40, p)
    assert c + a == PyFelt(40, p)


def test_pyfelt_subtraction():
    a = PyFelt(10, p)
    b = PyFelt(20, p)
    c = 5
    assert a - b == PyFelt(-10 % p, p)
    assert a - c == PyFelt(5, p)
    assert c - a == PyFelt(-5 % p, p)


def test_pyfelt_multiplication():
    a = PyFelt(10, p)
    b = PyFelt(20, p)
    c = 2
    assert a * b == PyFelt(200 % p, p)
    assert a * c == PyFelt(20, p)
    assert c * a == PyFelt(20, p)


def test_pyfelt_division():
    a = PyFelt(10, p)
    c = PyFelt(1, p)
    assert a / c == a
    with pytest.raises(ValueError):
        a / PyFelt(0, p)


def test_pyfelt_negation():
    a = PyFelt(10, p)
    assert -a == PyFelt(-10 % p, p)


def test_pyfelt_inversion():
    a = PyFelt(10, p)
    inv_a = a.__inv__()
    assert a * inv_a == PyFelt(1, p)
    with pytest.raises(ValueError):
        PyFelt(0, p).__inv__()


def test_pyfelt_exponentiation():
    a = PyFelt(10, p)
    assert a**3 == PyFelt(1000 % p, p)
    assert a**0 == PyFelt(1, p)


def test_pyfelt_equality():
    a = PyFelt(10, p)
    b = PyFelt(10, p)
    c = PyFelt(20, p)
    assert a == b
    assert a != c
    assert a == 10
    assert a != 20


def test_pyfelt_comparison():
    a = PyFelt(10, p)
    b = PyFelt(20, p)
    c = 15
    assert a < b
    assert a <= b
    assert b > a
    assert b >= a
    assert a < c
    assert a <= c
    assert b > c
    assert b >= c


def test_pyfelt_quadratic_residue():
    a = PyFelt(4, p)
    b = PyFelt(99, p)
    assert a.is_quad_residue()
    assert not b.is_quad_residue()


def test_pyfelt_sqrt():
    a = PyFelt(4, p)
    b = PyFelt(99, p)
    assert a.sqrt() == PyFelt(2, p)
    with pytest.raises(ValueError):
        print(b.sqrt())


def test_pyfelt_repr():
    a = PyFelt(10, p)
    assert repr(a) == "PyFelt(10, 0x65)"


def test_pyfelt_invalid_operations():
    a = PyFelt(10, p)
    with pytest.raises(Exception):
        a + "invalid"
    with pytest.raises(Exception):
        a - "invalid"
    with pytest.raises(Exception):
        a * "invalid"
    with pytest.raises(Exception):
        a / "invalid"
    with pytest.raises(Exception):
        a == "invalid"
    with pytest.raises(Exception):
        a < "invalid"
    with pytest.raises(Exception):
        a <= "invalid"
    with pytest.raises(Exception):
        a > "invalid"
    with pytest.raises(Exception):
        a >= "invalid"


if __name__ == "__main__":
    pytest.main()
