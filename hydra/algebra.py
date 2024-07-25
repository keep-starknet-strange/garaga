from __future__ import annotations
from dataclasses import dataclass
import random


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
    def felt(self) -> PyFelt:
        return self

    def __repr__(self) -> str:
        p_str = f"0x{self.p:0x}"
        if len(p_str) > 10:
            p_str = f"{p_str[:6]}...{p_str[-4:]}"
        return f"PyFelt({self.value}, {p_str})"

    def __add__(self, right: PyFelt | int) -> PyFelt:
        if isinstance(right, PyFelt):
            return PyFelt((self.value + right.value) % self.p, self.p)
        if isinstance(right, int):
            return PyFelt((self.value + right) % self.p, self.p)
        raise TypeError(f"Cannot add PyFelt and {type(right)}")

    def __neg__(self) -> PyFelt:
        return PyFelt((-self.value) % self.p, self.p)

    def __sub__(self, right: PyFelt | int) -> PyFelt:
        if isinstance(right, PyFelt):
            return PyFelt((self.value - right.value) % self.p, self.p)
        if isinstance(right, int):
            return PyFelt((self.value - right) % self.p, self.p)
        raise TypeError(f"Cannot subtract PyFelt and {type(right)}")

    def __mul__(self, right: PyFelt | int) -> PyFelt:
        if isinstance(right, PyFelt):
            return PyFelt((self.value * right.value) % self.p, self.p)
        if isinstance(right, int):
            return PyFelt((self.value * right) % self.p, self.p)
        raise TypeError(f"Cannot multiply PyFelt and {type(right)}")

    def __rmul__(self, left: PyFelt | int) -> PyFelt:
        return self.__mul__(left)

    def __inv__(self) -> PyFelt:
        return PyFelt(pow(self.value, -1, self.p), self.p)

    def __truediv__(self, right: PyFelt) -> PyFelt:
        assert type(self) == type(right), f"Cannot divide {type(self)} by {type(right)}"
        return self * right.__inv__()

    def __pow__(self, exponent: int) -> PyFelt:
        return PyFelt(pow(self.value, exponent, self.p), self.p)

    def __eq__(self, other: object) -> bool:
        if isinstance(other, PyFelt):
            return self.value == other.value and self.p == other.p
        if isinstance(other, int):
            return self.value == other
        raise TypeError(f"Cannot compare PyFelt and {type(other)}")

    def __lt__(self, other: PyFelt | int) -> bool:
        if isinstance(other, PyFelt):
            return self.value < other.value
        if isinstance(other, int):
            return self.value < other
        raise TypeError(f"Cannot compare PyFelt and {type(other)}")

    def __le__(self, other: PyFelt | int) -> bool:
        if isinstance(other, PyFelt):
            return self.value <= other.value
        if isinstance(other, int):
            return self.value <= other
        raise TypeError(f"Cannot compare PyFelt and {type(other)}")

    def __gt__(self, other: PyFelt | int) -> bool:
        if isinstance(other, PyFelt):
            return self.value > other.value
        if isinstance(other, int):
            return self.value > other
        raise TypeError(f"Cannot compare PyFelt and {type(other)}")

    def __ge__(self, other: PyFelt | int) -> bool:
        if isinstance(other, PyFelt):
            return self.value >= other.value
        if isinstance(other, int):
            return self.value >= other
        raise TypeError(f"Cannot compare PyFelt and {type(other)}")

    def __rlt__(self, left: int) -> bool:
        return left < self.value

    def __rle__(self, left: int) -> bool:
        return left <= self.value

    def __rgt__(self, left: int) -> bool:
        return left > self.value

    def __rge__(self, left: int) -> bool:
        return left >= self.value

    def __ne__(self, other: object) -> bool:
        return not self.__eq__(other)

    def __radd__(self, left: PyFelt | int) -> PyFelt:
        return self.__add__(left)

    def __rsub__(self, left: PyFelt | int) -> PyFelt:
        return -self.__sub__(left)

    def __rtruediv__(self, left: PyFelt | int) -> PyFelt:
        return self.__inv__().__mul__(left)


@dataclass(slots=True)
class BaseField:
    p: int

    def __call__(self, integer: int) -> PyFelt:
        return PyFelt(integer % self.p, self.p)

    def zero(self) -> PyFelt:
        return PyFelt(0, self.p)

    def one(self) -> PyFelt:
        return PyFelt(1, self.p)

    def random(self) -> PyFelt:
        return PyFelt(random.randint(0, self.p - 1), self.p)


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
    def p(self) -> int:
        return self.emulated_felt.p

    @property
    def felt(self) -> PyFelt:
        return self.emulated_felt


class Polynomial:
    """
    Represents a polynomial with coefficients in a finite field.

    Parameters :
    coefficients (list[PyFelt | ModuloCircuitElement]): A list of coefficients for the polynomial.
    raw_init (bool): A flag indicating whether to initialize the polynomial directly from a list of coefficients of PyFelt type.

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
        coefficients: list[PyFelt | ModuloCircuitElement],
        raw_init: bool = False,
    ):
        self.coefficients: list[PyFelt] = [c.felt for c in coefficients]
        self.p = coefficients[0].p
        self.field = BaseField(self.p)
        return

    def __repr__(self) -> str:
        return f"Polynomial({[x.value for x in self.get_coeffs()]})"

    def print_as_sage_poly(self, var_name: str = "z", as_hex: bool = False) -> str:
        """
        Prints the polynomial ready to be used in SageMath.
        """
        if self.is_zero():
            return ""
        coeffs = self.get_value_coeffs()
        string = ""
        for i, coeff in enumerate(coeffs[::-1]):
            if coeff == 0:
                continue
            else:
                coeff_str = hex(coeff) if as_hex else str(coeff)
                if i == len(coeffs) - 1:

                    string += f"{coeff_str}"
                elif i == len(coeffs) - 2:
                    string += f"{coeff_str}*{var_name} + "
                else:
                    string += f"{coeff_str}*{var_name}^{len(coeffs) - 1 - i} + "
        return string

    def __getitem__(self, i: int) -> PyFelt:
        try:
            return self.coefficients[i]
        except IndexError:
            return self.field.zero()

    def __len__(self) -> int:
        return len(self.coefficients)

    def degree(self) -> int:
        for i in range(len(self.coefficients) - 1, -1, -1):
            if self.coefficients[i].value != 0:
                return i
        return -1

    def get_coeffs(self) -> list[PyFelt]:
        coeffs = self.coefficients.copy()
        while len(coeffs) > 0 and coeffs[-1] == 0:
            coeffs.pop()
        if coeffs == []:
            return [self.field.zero()]
        return coeffs

    def get_value_coeffs(self) -> list[int]:
        return [c.value for c in self.get_coeffs()]

    def differentiate(self) -> "Polynomial":
        """
        Differentiates the polynomial with respect to x.

        Returns:
        Polynomial: The derivative of the polynomial.
        """
        if len(self.coefficients) <= 1:
            return Polynomial([self.field.zero()])

        derivative_coeffs = [
            self.coefficients[i] * PyFelt(i, self.p)
            for i in range(1, len(self.coefficients))
        ]
        return Polynomial(derivative_coeffs)

    def __add__(self, other: Polynomial) -> Polynomial:
        if not isinstance(other, Polynomial):
            raise TypeError(f"Cannot add Polynomial and {type(other)}")

        ns, no = len(self.coefficients), len(other.coefficients)
        if ns >= no:
            coeffs = self.coefficients[:]
            for i in range(no):
                coeffs[i] = coeffs[i] + other.coefficients[i]
        else:
            coeffs = other.coefficients[:]
            for i in range(ns):
                coeffs[i] = coeffs[i] + self.coefficients[i]

        return Polynomial(coeffs)

    def __neg__(self) -> "Polynomial":
        return Polynomial([-c for c in self.coefficients])

    def __sub__(self, other: "Polynomial") -> "Polynomial":
        return self.__add__(-other)

    def __mul__(
        self, other: "Polynomial" | PyFelt | ModuloCircuitElement
    ) -> "Polynomial":
        if isinstance(other, (PyFelt, ModuloCircuitElement)):
            return Polynomial([c * other.felt for c in self.coefficients])
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
        res = Polynomial(Polynomial(buf).get_coeffs())
        return res

    def __rmul__(
        self, other: "Polynomial" | PyFelt | ModuloCircuitElement
    ) -> "Polynomial":
        return self.__mul__(other)

    def __truediv__(self, other):
        quo, rem = Polynomial.__divmod__(self, other)
        assert (
            rem.is_zero()
        ), "cannot perform polynomial division because remainder is not zero"
        return quo

    def __floordiv__(self, other: "Polynomial") -> "Polynomial":
        quo, _ = Polynomial.__divmod__(self, other)
        return quo

    def __mod__(self, other: "Polynomial") -> "Polynomial":
        _, rem = Polynomial.__divmod__(self, other)
        return rem

    def __divmod__(self, denominator: "Polynomial") -> tuple[Polynomial, Polynomial]:
        if denominator.is_zero():
            raise ValueError("Cannot divide by zero polynomial")
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
                Polynomial([field.zero()] * shift + [coefficient]) * denominator
            )
            quotient_coefficients[shift] = coefficient
            remainder = remainder - subtractee
        quotient = Polynomial(quotient_coefficients)
        return quotient, remainder

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, Polynomial):
            raise TypeError(f"Cannot compare Polynomial with {type(other)}")

        if self.degree() != other.degree():
            return False

        if self.degree() == -1:
            return True

        return self.get_coeffs() == other.get_coeffs()

    def __neq__(self, other: object) -> bool:
        return not self.__eq__(other)

    def leading_coefficient(self) -> PyFelt:
        return self.coefficients[self.degree()]

    def is_zero(self) -> bool:
        if not self.coefficients:
            return True
        for c in self.coefficients:
            if c.value != 0:
                return False
        return True

    @staticmethod
    def zero(p: int) -> "Polynomial":
        return Polynomial([PyFelt(0, p)])

    @staticmethod
    def one(p: int) -> "Polynomial":
        return Polynomial([PyFelt(1, p)])

    def evaluate(self, point: PyFelt) -> PyFelt:
        xi = self.field.one()
        value = self.field.zero()
        for c in self.coefficients:
            value = value + c * xi
            xi = xi * point
        return value

    def __pow__(self, exponent: int) -> "Polynomial":
        if exponent == 0:
            return Polynomial([self.field.one()])
        acc = Polynomial([self.field.one()])
        for i in reversed(range(len(bin(exponent)[2:]))):
            acc = acc * acc
            if (1 << i) & exponent != 0:
                acc = acc * self
        return acc

    def pow(self, exponent: int, modulo_poly: "Polynomial") -> "Polynomial":
        if exponent == 0:
            return Polynomial([PyFelt(1, self.coefficients[0].p)])
        acc = Polynomial([PyFelt(1, self.coefficients[0].p)])
        for i in reversed(range(len(bin(exponent)[2:]))):
            acc = acc * acc % modulo_poly
            if (1 << i) & exponent != 0:
                acc = (acc * self) % modulo_poly
        return acc % modulo_poly

    def inv(self, modulo_poly: "Polynomial") -> "Polynomial":
        """
        Inverts a polynomial modulo another polynomial over a finite field.

        Parameters:
        modulo_poly Polynomial: The polynomial to invert modulo.

        Returns:
        Polynomial: The inverted polynomial.
        """
        if self.is_zero():
            raise ValueError("Cannot invert zero polynomial")
        inv, _, gcd = Polynomial.xgcd(self, modulo_poly)
        assert (
            gcd.degree() == 0 and gcd.coefficients[0] == 1
        ), f"Polynomial {self} is not invertible modulo {modulo_poly}"
        return inv

    @staticmethod
    def xgcd(x: Polynomial, y: Polynomial) -> tuple[Polynomial, Polynomial, Polynomial]:
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

        lcinv = old_r.leading_coefficient().__inv__()

        # a, b, g
        return (
            Polynomial([c * lcinv for c in old_s.coefficients]),
            Polynomial([c * lcinv for c in old_t.coefficients]),
            Polynomial([c * lcinv for c in old_r.coefficients]),
        )

    @staticmethod
    def lagrange_interpolation(
        p: int, domain: list[PyFelt], values: list[PyFelt]
    ) -> Polynomial:
        """
        Performs Lagrange interpolation on a set of points.

        Parameters:
        p (int): The prime modulus for the field.
        domain (list[PyFelt]): The domain of the interpolation.
        values (list[PyFelt]): The values corresponding to the domain.

        Returns:
        Polynomial: The interpolated polynomial.
        """
        assert len(domain) == len(
            values
        ), "number of elements in domain does not match number of values -- cannot interpolate"
        assert len(domain) > 0, "cannot interpolate between zero points"
        field = BaseField(p)
        X = Polynomial([field.zero(), field.one()])
        acc = Polynomial([field.zero()])
        for i in range(len(domain)):
            prod = Polynomial([values[i]])
            for j in range(len(domain)):
                if j == i:
                    continue
                prod = (
                    prod
                    * (X - Polynomial([domain[j]]))
                    * Polynomial([(domain[i] - domain[j]).__inv__()])
                )
            acc = acc + prod
        return acc


@dataclass(slots=True)
class RationalFunction:
    numerator: Polynomial
    denominator: Polynomial

    @property
    def field(self) -> BaseField:
        return self.numerator.field

    def simplify(self) -> "RationalFunction":
        _, _, gcd = Polynomial.xgcd(self.numerator, self.denominator)
        num_simplified = self.numerator // gcd
        den_simplified = self.denominator // gcd
        return RationalFunction(
            num_simplified * self.denominator.leading_coefficient().__inv__(),
            den_simplified * den_simplified.leading_coefficient().__inv__(),
        )

    def __add__(self, other: "RationalFunction") -> "RationalFunction":
        return RationalFunction(
            self.numerator * other.denominator + other.numerator * self.denominator,
            self.denominator * other.denominator,
        ).simplify()

    def __mul__(self, other: int | PyFelt) -> "RationalFunction":
        if isinstance(other, int):
            other = self.field(other)
        elif isinstance(other, PyFelt):
            other = self.field(other.value)
        else:
            raise TypeError(f"Cannot multiply RationalFunction with {type(other)}")
        return RationalFunction(self.numerator * other, self.denominator)

    def evaluate(self, x: PyFelt) -> PyFelt:
        return self.numerator.evaluate(x) / self.denominator.evaluate(x)

    def degrees_infos(self) -> dict[str, int]:
        return {
            "numerator": self.numerator.degree(),
            "denominator": self.denominator.degree(),
        }


@dataclass(slots=True)
class FunctionFelt:
    # f = a(x) + yb(x)
    a: RationalFunction
    b: RationalFunction

    @property
    def field(self) -> BaseField:
        return self.a.numerator.field

    def simplify(self) -> "FunctionFelt":
        return FunctionFelt(self.a.simplify(), self.b.simplify())

    def __add__(self, other: "FunctionFelt") -> "FunctionFelt":
        return FunctionFelt(self.a + other.a, self.b + other.b)

    def __mul__(self, other: PyFelt | int) -> "FunctionFelt":
        return FunctionFelt(self.a * other, self.b * other)

    def __rmul__(self, other: PyFelt | int) -> "FunctionFelt":
        return self.__mul__(other)

    def evaluate(self, x: PyFelt, y: PyFelt) -> PyFelt:
        return self.a.evaluate(x) + y * self.b.evaluate(x)

    def degrees_infos(self) -> dict[str, dict[str, int]]:
        return {
            "a": self.a.degrees_infos(),
            "b": self.b.degrees_infos(),
        }

    def print_as_sage_poly(self, var: str = "x") -> str:
        return f"(({self.b.numerator.print_as_sage_poly(var)}) / ({self.b.denominator.print_as_sage_poly(var)}) * y + ({self.a.numerator.print_as_sage_poly(var)} / ({self.a.denominator.print_as_sage_poly(var)})"


if __name__ == "__main__":
    p = 10000000007
    domain = [PyFelt(1, p), PyFelt(2, p)]
    values = [PyFelt(2, p), PyFelt(4, p)]
    print(Polynomial.lagrange_interpolation(p, domain, values))
    print(PyFelt(1, 12345864586489789789))
