from dataclasses import dataclass


@dataclass(slots=True, frozen=True)
class PyFelt:
    """
    Represents an element of a finite field. The dataclass decorator automatically provides implementations for __init__, __repr__, __eq__, and __hash__ methods.
    Supports the following operations through magic methods:
    - Addition ((PyFelt | int) + (PyFelt | int))
    - Subtraction ((PyFelt | int) - (PyFelt | int))
    - Multiplication ((PyFelt | int) * (PyFelt | int))
    - Division (PyFelt / PyFelt)
    - Negation (-PyFelt)
    - Inversion (inv(PyFelt))
    - Exponentiation (PyFelt ** int)
    - Equality (PyFelt == PyFelt)
    - Inequality (PyFelt != PyFelt)
    """

    value: int
    p: int

    @property
    def felt(self):
        return self

    def __add__(self, right):
        if isinstance(right, PyFelt):
            return PyFelt((self.value + right.value) % self.p, self.p)
        if isinstance(right, int):
            return PyFelt((self.value + right) % self.p, self.p)
        return NotImplemented

    def __neg__(self):
        return PyFelt((-self.value) % self.p, self.p)

    def __sub__(self, right):
        if isinstance(right, PyFelt):
            return PyFelt((self.value - right.value) % self.p, self.p)
        if isinstance(right, int):
            return PyFelt((self.value - right) % self.p, self.p)
        return NotImplemented

    def __mul__(self, right):
        if isinstance(right, PyFelt):
            return PyFelt((self.value * right.value) % self.p, self.p)
        if isinstance(right, int):
            return PyFelt((self.value * right) % self.p, self.p)
        return NotImplemented

    def __rmul__(self, left):
        return self.__mul__(left)

    def __inv__(self):
        return PyFelt(pow(self.value, -1, self.p), self.p)

    def __truediv__(self, right):
        assert type(self) == type(right), f"Cannot divide {type(self)} by {type(right)}"
        return self * right.__inv__()

    def __pow__(self, exponent):
        return PyFelt(pow(self.value, exponent, self.p), self.p)

    def __eq__(self, other):
        if isinstance(other, PyFelt):
            return self.value == other.value and self.p == other.p
        if isinstance(other, int):
            return self.value == other
        return False

    def __ne__(self, other):
        return not self.__eq__(other)

    def __radd__(self, left):
        return self.__add__(left)

    def __rsub__(self, left):
        return -self.__sub__(left)

    def __rtruediv__(self, left):
        return self.__inv__().__mul__(left)

    def __rpow__(self, left):
        return PyFelt(pow(left, self.value, self.p), self.p)


@dataclass(slots=True)
class BaseField:
    p: int

    def __call__(self, integer):
        return PyFelt(integer % self.p, self.p)

    def zero(self):
        return PyFelt(0, self.p)

    def one(self):
        return PyFelt(1, self.p)


@dataclass(slots=True, frozen=True)
class ModuloCircuitElement:
    """
    Represents an element within a modulo circuit with its associated offset.

    Attributes:
        emulated_felt (PyFelt): The emulated field element in the modulo circuit
        offset (int): The offset in the values segment within the modulo circuit where the element is stored.
    """

    emulated_felt: PyFelt
    offset: int

    @property
    def value(self) -> int:
        return self.emulated_felt.value

    @property
    def p(self):
        return self.emulated_felt.p

    @property
    def felt(self):
        return self.emulated_felt


class Polynomial:
    """
    Represents a polynomial with coefficients in a finite field.

    Magic Methods Summary:
    - __init__: Initializes a polynomial with a list of coefficients.
    - __add__: (Polynomial + Polynomial) Adds two polynomials.
    - __neg__: (-Polynomial) Negates the polynomial.
    - __sub__: (Polynomial - Polynomial) Subtracts one polynomial from another.
    - __mul__: (Polynomial * PyFelt|Polynomial) Multiplies the polynomial by either a field element or another polynomial.
    - __truediv__: (Polynomial / Polynomial) Divides one polynomial by another, asserting no remainder.
    - __floordiv__: (Polynomial // Polynomial) Performs floor division on two polynomials.
    - __mod__: (Polynomial % Polynomial) Finds the remainder of polynomial division.
    - __divmod__: Divides one polynomial by another, returning both quotient and remainder.
    - __eq__: (Polynomial == Polynomial) Checks if two polynomials are equal.
    - __neq__: (Polynomial != Polynomial) Checks if two polynomials are not equal.
    - __str__: Returns a string representation of the polynomial.
    - __pow__: (Polynomial ** int) Raises the polynomial to a power.
    """

    def __init__(
        self,
        coefficients: list[int | PyFelt | ModuloCircuitElement],
        raw_init: bool = False,
    ):
        if raw_init:
            # List of PyFelt
            self.coefficients = coefficients
            self.p = coefficients[0].p
            self.field = BaseField(self.p)
            return
        assert (
            type(coefficients) == list
        ), f"coefficients must be a list, not {type(coefficients)}"

        first_coeff = coefficients[0]
        arg_type = type(first_coeff)
        assert all(type(c) == arg_type for c in coefficients)
        if arg_type == PyFelt:
            self.coefficients = coefficients
            self.p = first_coeff.p
        elif arg_type == ModuloCircuitElement:
            self.coefficients = [c.emulated_felt for c in coefficients]
            self.p = first_coeff.emulated_felt.p
        else:
            raise ValueError(
                f"Unsupported coefficient type {type(first_coeff)} for Polynomial initialization."
            )
        self.field = BaseField(self.p)

    def __repr__(self):
        return f"Polynomial({[x.value for x in self.get_coeffs()]})"

    def __getitem__(self, i):
        try:
            return self.coefficients[i].value
        except IndexError:
            return 0

    def degree(self):
        if self.coefficients == []:
            return -1
        zero = PyFelt(0, self.coefficients[0].p)
        if self.coefficients == [zero] * len(self.coefficients):
            return -1
        maxindex = 0
        for i in range(len(self.coefficients)):
            if self.coefficients[i] != zero:
                maxindex = i
        return maxindex

    def get_coeffs(self) -> list[PyFelt]:
        coeffs = self.coefficients.copy()
        while len(coeffs) > 0 and coeffs[-1] == 0:
            coeffs.pop()
        if coeffs == []:
            return [self.field.zero()]
        return coeffs

    def get_value_coeffs(self) -> list[int]:
        return [c.value for c in self.get_coeffs()]

    def __add__(self, other):
        if self.degree() == -1:
            return other
        elif other.degree() == -1:
            return self
        field = self.field
        coeffs = [field.zero()] * max(len(self.coefficients), len(other.coefficients))
        for i in range(len(self.coefficients)):
            coeffs[i] = coeffs[i] + self.coefficients[i]
        for i in range(len(other.coefficients)):
            coeffs[i] = coeffs[i] + other.coefficients[i]
        return Polynomial(coeffs, raw_init=True)

    def __neg__(self):
        return Polynomial([-c for c in self.coefficients], raw_init=True)

    def __sub__(self, other):
        return self.__add__(-other)

    def __mul__(self, other):
        if isinstance(other, (PyFelt, ModuloCircuitElement)):
            return Polynomial(
                [c * other.felt for c in self.coefficients], raw_init=True
            )
        elif not isinstance(other, Polynomial):
            raise TypeError(
                f"Cannot multiply polynomial by type {type(other)}, must be PyFelt or Polynomial"
            )

        if self.coefficients == [] or other.coefficients == []:
            return Polynomial([self.field.zero()])
        zero = self.field.zero()
        buf = [zero] * (len(self.coefficients) + len(other.coefficients) - 1)
        for i in range(len(self.coefficients)):
            if self.coefficients[i] == 0:
                continue  # optimization for sparse polynomials
            for j in range(len(other.coefficients)):
                buf[i + j] = buf[i + j] + self.coefficients[i] * other.coefficients[j]
        res = Polynomial(Polynomial(buf).get_coeffs(), raw_init=True)
        return res

    def __rmul__(self, other):
        return self.__mul__(other)

    def __truediv__(self, other):
        quo, rem = Polynomial.__divmod__(self, other)
        print(quo, rem)
        assert (
            rem.is_zero()
        ), "cannot perform polynomial division because remainder is not zero"
        return quo

    def __floordiv__(self, other):
        quo, rem = Polynomial.__divmod__(self, other)
        return quo

    def __mod__(self, other):
        quo, rem = Polynomial.__divmod__(self, other)
        return rem

    def __divmod__(self, denominator: "Polynomial"):
        if denominator.degree() == -1:
            return None
        if self.degree() < denominator.degree():
            return (Polynomial([PyFelt(0, self.p)]), self)
        field = self.field
        remainder = Polynomial([n for n in self.coefficients])
        quotient_coefficients = [
            field.zero() for i in range(self.degree() - denominator.degree() + 1)
        ]
        for i in range(self.degree() - denominator.degree() + 1):
            if remainder.degree() < denominator.degree():
                break
            coefficient = (
                remainder.leading_coefficient() / denominator.leading_coefficient()
            )
            shift = remainder.degree() - denominator.degree()
            subtractee = (
                Polynomial([field.zero()] * shift + [coefficient], raw_init=True)
                * denominator
            )
            quotient_coefficients[shift] = coefficient
            remainder = remainder - subtractee
        quotient = Polynomial(quotient_coefficients, raw_init=True)
        return quotient, remainder

    def __eq__(self, other):
        assert type(self) == type(
            other
        ), f"type of self {type(self)} must be equal to type of other which is {type(other)}"
        if self.degree() != other.degree():
            return False
        if self.degree() == -1:
            return True
        return all(
            self.coefficients[i] == other.coefficients[i]
            for i in range(min(len(self.coefficients), len(other.coefficients)))
        )

    def __neq__(self, other):
        return not self.__eq__(other)

    def is_zero(self):
        if self.degree() == -1:
            return True
        return False

    def leading_coefficient(self):
        return self.coefficients[self.degree()]

    def is_zero(self):
        if self.coefficients == []:
            return True
        for c in self.coefficients:
            if c != 0:
                return False
        return True

    def evaluate(self, point):
        xi = point.field.one()
        value = point.field.zero()
        for c in self.coefficients:
            value = value + c * xi
            xi = xi * point
        return value

    def __pow__(self, exponent):
        if exponent == 0:
            return Polynomial([self.field.one()])
        acc = Polynomial([self.field.one()])
        for i in reversed(range(len(bin(exponent)[2:]))):
            acc = acc * acc
            if (1 << i) & exponent != 0:
                acc = acc * self
        return acc

    def pow(self, exponent: int, modulo_poly: "Polynomial"):
        if exponent == 0:
            return Polynomial([PyFelt(1, self.coefficients[0].p)])
        acc = Polynomial([PyFelt(1, self.coefficients[0].p)])
        for i in reversed(range(len(bin(exponent)[2:]))):
            acc = acc * acc % modulo_poly
            if (1 << i) & exponent != 0:
                acc = (acc * self) % modulo_poly
        return acc % modulo_poly

    @staticmethod
    def xgcd(x, y):
        """
        Extended Euclidean Algorithm for polynomials.

        This method computes the extended greatest common divisor (GCD) of two polynomials x and y.
        It returns a tuple of three elements: (a, b, g) such that a * x + b * y = g, where g is the
        greatest common divisor of x and y. This is particularly useful in contexts like
        computational algebra or number theory where the coefficients of the polynomials are in a field.

        Parameters:
        x (Polynomial): The first polynomial.
        y (Polynomial): The second polynomial.

        Returns:
        tuple: A tuple (a, b, g) where:
            a (Polynomial): A polynomial such that a * x + b * y = g.
            b (Polynomial): A polynomial such that a * x + b * y = g.
            g (Polynomial): The greatest common divisor of x and y.
        """
        one = Polynomial([x.field.one()])
        zero = Polynomial([x.field.zero()])
        old_r, r = (x, y)
        old_s, s = (one, zero)
        old_t, t = (zero, one)

        while not r.is_zero():
            quotient = old_r // r
            old_r, r = (r, old_r - quotient * r)
            old_s, s = (s, old_s - quotient * s)
            old_t, t = (t, old_t - quotient * t)

        lcinv = old_r.coefficients[old_r.degree()].__inv__()

        # a, b, g
        return (
            Polynomial([c * lcinv for c in old_s.coefficients]),
            Polynomial([c * lcinv for c in old_t.coefficients]),
            Polynomial([c * lcinv for c in old_r.coefficients]),
        )
