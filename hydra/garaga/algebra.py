from __future__ import annotations

import random
from dataclasses import dataclass
from typing import Generic, TypeVar

from sympy import legendre_symbol, sqrt_mod

T = TypeVar("T", "PyFelt", "Fp2")


@dataclass(slots=True)
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
        p = self.p
        if isinstance(right, PyFelt):
            return PyFelt((self.value + right.value) % p, p)
        if isinstance(right, int):
            return PyFelt((self.value + right) % p, p)
        raise TypeError(f"Cannot add PyFelt and {type(right)}")

    def __neg__(self) -> PyFelt:
        p = self.p
        return PyFelt((-self.value) % p, p)

    def __sub__(self, right: PyFelt | int) -> PyFelt:
        p = self.p
        if isinstance(right, PyFelt):
            return PyFelt((self.value - right.value) % p, p)
        if isinstance(right, int):
            return PyFelt((self.value - right) % p, p)
        raise TypeError(f"Cannot subtract PyFelt and {type(right)}")

    def __mul__(self, right: PyFelt | int) -> PyFelt:
        p = self.p
        if isinstance(right, PyFelt):
            return PyFelt((self.value * right.value) % p, p)
        if isinstance(right, int):
            return PyFelt((self.value * right) % p, p)
        raise TypeError(f"Cannot multiply PyFelt and {type(right)}")

    def __rmul__(self, left: PyFelt | int) -> PyFelt:
        return self.__mul__(left)

    def __inv__(self) -> PyFelt:
        try:
            inv = pow(self.value, -1, self.p)
        except ValueError:
            raise ValueError(f"Cannot invert {self.value} modulo {self.p}")
        return PyFelt(inv, self.p)

    def __truediv__(self, right: PyFelt) -> PyFelt:
        assert isinstance(self, PyFelt) and isinstance(
            right, PyFelt
        ), f"Cannot divide {type(self)} by {type(right)}"
        return self * right.__inv__()

    def __pow__(self, exponent: int) -> PyFelt:
        return PyFelt(pow(self.value, exponent, self.p), self.p)

    def __eq__(self, other: object) -> bool:
        if isinstance(other, PyFelt):
            return self.value == other.value
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

    def is_quad_residue(self) -> bool:
        if self.value == 0:
            return True
        return legendre_symbol(self.value, self.p) == 1

    def sqrt(self, min_root: bool = True) -> PyFelt:
        if not self.is_quad_residue():
            raise ValueError("Cannot square root a non-quadratic residue")
        roots = sqrt_mod(self.value, self.p, all_roots=True)
        if min_root:
            return PyFelt(min(roots), self.p)
        else:
            return PyFelt(max(roots), self.p)


@dataclass(slots=True)
class Fp2:
    a0: PyFelt
    a1: PyFelt

    def __post_init__(self):
        assert self.a0.p == self.a1.p, "Fields must be the same"

    @property
    def p(self) -> int:
        return self.a0.p

    @property
    def value(self) -> tuple[int, int]:
        return self.a0.value, self.a1.value

    @staticmethod
    def random(p: int, max_value: int = None) -> Fp2:
        if max_value is None:
            max_value = p - 1

        rnd1 = random.randint(0, max_value)
        rnd2 = random.randint(0, max_value)
        return Fp2(
            PyFelt(rnd1, p),
            PyFelt(rnd2, p),
        )

    @staticmethod
    def one(p: int) -> Fp2:
        return Fp2(PyFelt(1, p), PyFelt(0, p))

    @staticmethod
    def zero(p: int) -> Fp2:
        return Fp2(PyFelt(0, p), PyFelt(0, p))

    def __repr__(self) -> str:
        return f"Fp2({self.a0}, {self.a1})"

    def __add__(self, other: Fp2) -> Fp2:
        if isinstance(other, Fp2):
            return Fp2(self.a0 + other.a0, self.a1 + other.a1)
        else:
            raise TypeError(f"Cannot add Fp2 and {type(other)}")

    def __eq__(self, other: object) -> bool:
        if isinstance(other, Fp2):
            return self.a0 == other.a0 and self.a1 == other.a1 and self.p == other.p
        else:
            raise TypeError(f"Cannot compare Fp2 and {type(other)}")

    def __neg__(self) -> Fp2:
        return Fp2(-self.a0, -self.a1)

    def __sub__(self, other: Fp2) -> Fp2:
        return self.__add__(-other)

    def __mul__(self, other: Fp2 | PyFelt | int) -> Fp2:
        if isinstance(other, PyFelt):
            assert other.p == self.a0.p, "Fields must be the same"
            return Fp2(self.a0 * other, self.a1 * other)
        elif isinstance(other, int):
            return Fp2(self.a0 * other, self.a1 * other)
        elif isinstance(other, Fp2):
            # (a0 + a1 * i) * (b0 + b1 * i) = a0 * b0 - a1 * b1 + (a0 * b1 + a1 * b0) * i
            return Fp2(
                self.a0 * other.a0 - self.a1 * other.a1,
                self.a0 * other.a1 + self.a1 * other.a0,
            )
        else:
            raise TypeError(f"Cannot multiply Fp2 and {type(other)}")

    def __rmul__(self, other):
        return self.__mul__(other)

    def __truediv__(self, other):
        if isinstance(other, Fp2):
            return self * other.__inv__()
        elif isinstance(other, int):
            return self * pow(other, -1, self.p)

        return NotImplemented

    def __rtruediv__(self, other) -> Fp2:
        if isinstance(other, Fp2):
            return other * self.__inv__()
        elif isinstance(other, int):
            return other * self.__inv__()

        return NotImplemented

    def __inv__(self) -> Fp2:
        t0, t1 = (self.a0 * self.a0, self.a1 * self.a1)
        t0 = t0 + t1
        t1 = pow(t0.value, -1, self.p)
        return Fp2(self.a0 * t1, -(self.a1 * t1))

    def __pow__(self, p: int) -> Fp2:
        """
        Compute x**p in F_p^2 using square-and-multiply algorithm.
        Args:
        p: The exponent, a non-negative integer.
        Returns:
        x**p in F_p^2, represented similarly as x.
        """
        assert isinstance(p, int) and p >= 0

        # Handle the easy cases.
        if p == 0:
            # x**0 = 1, where 1 is the multiplicative identity in F_p^2.
            return Fp2(PyFelt(1, self.p), PyFelt(0, self.p))
        elif p == 1:
            # x**1 = x.
            return self

        # Start the computation.
        result = self.one(
            self.p
        )  # Initialize result as the multiplicative identity in F_p^2.
        temp = self  # Initialize temp as self.

        # Loop through each bit of the exponent p.
        for bit in reversed(bin(p)[2:]):  # [2:] to strip the "0b" prefix.
            if bit == "1":
                result = result * temp
            temp = temp * temp

        return result

    def norm(self) -> PyFelt:
        return self.a0 * self.a0 + self.a1 * self.a1

    def legendre(self) -> int:
        norm = self.norm()
        return legendre_symbol(norm.value, self.p)

    def is_quad_residue(self) -> bool:
        return self.legendre() == 1

    def sqrt(self) -> Fp2:
        if not self.is_quad_residue():
            raise ValueError("Cannot square root a non-quadratic residue")
        assert self.p % 4 == 3, "p must be 3 mod 4 to use this sqrt"
        min_one = Fp2(PyFelt(-1 % self.p, self.p), PyFelt(0, self.p))

        a = self
        a1 = a ** ((self.p - 3) // 4)
        alpha = a1 * a1 * a
        a0 = alpha**self.p * alpha
        if a0 == min_one:
            return ValueError("Cannot square root a non-quadratic residue")

        x0 = a1 * a
        if alpha == min_one:
            i = Fp2(PyFelt(0, self.p), PyFelt(1, self.p))
            x = i * x0
        else:
            b = (Fp2.one(self.p) + alpha) ** ((self.p - 1) // 2)
            x = b * x0

        # Return the root as is, without forcing a specific sign
        return x

    def lexicographically_largest(self) -> bool:
        """Check if this Fp2 element is lexicographically largest."""
        if self.a1.value > (self.p - 1) // 2:
            return True
        if self.a1.value < (self.p - 1) // 2:
            return False
        return self.a0.value > (self.p - 1) // 2


@dataclass(slots=True)
class BaseField:
    p: int

    def __call__(self, integer: int) -> PyFelt:
        return PyFelt(integer % self.p, self.p)

    def zero(self) -> PyFelt:
        return PyFelt(0, self.p)

    def one(self) -> PyFelt:
        return PyFelt(1, self.p)

    def random(self, max_value: int = None) -> PyFelt:
        if max_value is None:
            max_value = self.p - 1
        return PyFelt(random.randint(0, max_value), self.p)

    @property
    def type(self) -> type[PyFelt]:
        return PyFelt


@dataclass(slots=True)
class BaseFp2Field:
    p: int

    def __call__(self, a: tuple[int, int] | int) -> Fp2:
        if isinstance(a, tuple):
            a0, a1 = a
        else:
            a0, a1 = a, 0
        return Fp2(PyFelt(a0 % self.p, self.p), PyFelt(a1 % self.p, self.p))

    def zero(self) -> Fp2:
        return Fp2(PyFelt(0, self.p), PyFelt(0, self.p))

    def one(self) -> Fp2:
        return Fp2(PyFelt(1, self.p), PyFelt(0, self.p))

    def random(self) -> Fp2:
        return Fp2.random(self.p)

    @property
    def type(self) -> type[Fp2]:
        return Fp2


@dataclass(slots=True)
class ModuloCircuitElement:
    """
    Represents an element within a modulo circuit with its associated offset.

    Attributes:
        emulated_felt (PyFelt): The emulated field element in the modulo circuit
        offset (int): The offset in the values segment within the modulo circuit where the element is stored.
    """

    emulated_felt: PyFelt
    offset: int

    __repr__ = lambda self: f"ModuloCircuitElement({hex(self.value)}, {self.offset})"

    @property
    def value(self) -> int:
        return self.emulated_felt.value

    @property
    def p(self) -> int:
        return self.emulated_felt.p

    @property
    def felt(self) -> PyFelt:
        return self.emulated_felt


class Polynomial(Generic[T]):
    """
    Represents a polynomial with coefficients in a finite field.

    Parameters :
    coefficients (list[PyFelt | ModuloCircuitElement]): A list of coefficients for the polynomial.

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

    __slots__ = [
        "coefficients",
        "coeff_type",
        "p",
        "field",
        "zero_field",
        "zero_field_value",
    ]

    def __init__(self, coefficients: list[T], raw_init: tuple = None):
        if raw_init is not None:
            self._raw_init(coefficients, *raw_init)
        else:
            coeffs_types = {type(c) for c in coefficients}
            if coeffs_types == {PyFelt}:
                self._initialize(coefficients, PyFelt, BaseField)
            elif coeffs_types == {ModuloCircuitElement}:
                self._initialize([c.felt for c in coefficients], PyFelt, BaseField)
            elif coeffs_types == {Fp2}:
                self._initialize(coefficients, Fp2, BaseFp2Field)
            else:
                raise TypeError(
                    f"All elements in the list must be of the same type, either ModuloCircuitElement, PyFelt or Fp2., got {coeffs_types}"
                )

    def _raw_init(
        self,
        coefficients: list[T],
        coeff_type: type[T],
        p: int,
        field,
        zero_field,
        zero_field_value,
    ) -> None:
        self.coefficients = coefficients
        self.coeff_type = coeff_type
        self.p = p
        self.field = field
        self.zero_field = zero_field
        self.zero_field_value = zero_field_value

    def _initialize(
        self, coefficients: list[T], coeff_type: type[T], field_class: type
    ):
        self.coefficients: list[T] = coefficients
        self.coeff_type = coeff_type
        self.p = coefficients[0].p
        self.field = field_class(self.p)
        self.zero_field = self.field.zero()
        self.zero_field_value = self.zero_field.value

    def __repr__(self) -> str:
        if self.coeff_type == PyFelt:
            return f"Polynomial({[x.value for x in self.get_coeffs()]})"
        elif self.coeff_type == Fp2:
            return f"Polynomial({[x for x in self.get_coeffs()]})"

    def print_as_sage_poly(self, var_name: str = "z", as_hex: bool = False) -> str:
        """
        Prints the polynomial ready to be used in SageMath.
        """
        if self.is_zero():
            return ""
        coeffs = self.get_coeffs()
        string = ""
        zero = self.zero_field
        for i, coeff in enumerate(coeffs[::-1]):
            if coeff == zero:
                continue
            else:
                if self.coeff_type == PyFelt:
                    coeff_str = hex(coeff.value) if as_hex else str(coeff.value)
                elif self.coeff_type == Fp2:
                    coeff_str = f"({coeff.a1.value} * i + {coeff.a0.value})"

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
            return self.zero_field

    def __len__(self) -> int:
        return len(self.coefficients)

    def degree(self) -> int:
        for i, coeff in enumerate(self.coefficients[::-1]):
            if coeff.value != self.zero_field_value:
                return len(self.coefficients) - 1 - i
        return -1

    def get_coeffs(self) -> list[T]:
        coeffs = self.coefficients[:]
        while len(coeffs) > 0 and coeffs[-1].value == self.zero_field_value:
            coeffs.pop()
        if coeffs == []:
            return [self.zero_field]
        return coeffs

    def get_value_coeffs(self) -> list[int]:
        if self.coeff_type == PyFelt:
            return [c.value for c in self.get_coeffs()]
        elif self.coeff_type == Fp2:
            raise NotImplementedError("Fp2 not implemented")

    def differentiate(self) -> "Polynomial":
        """
        Differentiates the polynomial with respect to x.

        Returns:
        Polynomial: The derivative of the polynomial.
        """
        if len(self.coefficients) <= 1:
            return Polynomial([self.zero_field])

        derivative_coeffs = [
            self.coefficients[i] * i for i in range(1, len(self.coefficients))
        ]
        return Polynomial(
            derivative_coeffs,
            raw_init=(
                self.coeff_type,
                self.p,
                self.field,
                self.zero_field,
                self.zero_field_value,
            ),
        )

    def __add__(self, other: Polynomial) -> Polynomial:
        if self.coeff_type != other.coeff_type:
            raise TypeError(
                f"Cannot add Polynomial of type {self.coeff_type} and {other.coeff_type} \n self: {self} \n other: {other}"
            )

        ns, no = len(self.coefficients), len(other.coefficients)
        if ns >= no:
            coeffs = self.coefficients[:]
            for i in range(no):
                coeffs[i] += other.coefficients[i]
        else:
            coeffs = other.coefficients[:]
            for i in range(ns):
                coeffs[i] += self.coefficients[i]

        return Polynomial(
            coeffs,
            raw_init=(
                self.coeff_type,
                self.p,
                self.field,
                self.zero_field,
                self.zero_field_value,
            ),
        )

    def __neg__(self) -> "Polynomial":
        return Polynomial(
            [-c for c in self.coefficients],
            raw_init=(
                self.coeff_type,
                self.p,
                self.field,
                self.zero_field,
                self.zero_field_value,
            ),
        )

    def __sub__(self, other: Polynomial) -> Polynomial:
        if self.coeff_type != other.coeff_type:
            raise TypeError(
                f"Cannot add Polynomial of type {self.coeff_type} and {other.coeff_type} \n self: {self} \n other: {other}"
            )

        ns, no = len(self.coefficients), len(other.coefficients)
        coeffs = self.coefficients[:]
        if ns >= no:
            for i in range(no):
                coeffs[i] -= other.coefficients[i]
        else:
            for i in range(ns):
                coeffs[i] -= other.coefficients[i]
            for i in range(ns, no):
                coeffs.append(-other.coefficients[i])

        return Polynomial(
            coeffs,
            raw_init=(
                self.coeff_type,
                self.p,
                self.field,
                self.zero_field,
                self.zero_field_value,
            ),
        )

    def __mul__(
        self, other: "Polynomial" | PyFelt | ModuloCircuitElement
    ) -> "Polynomial":
        if isinstance(other, (PyFelt, ModuloCircuitElement)):
            return Polynomial(
                [c * other.felt for c in self.coefficients],
                raw_init=(
                    self.coeff_type,
                    self.p,
                    self.field,
                    self.zero_field,
                    self.zero_field_value,
                ),
            )
        elif isinstance(other, Fp2):
            return Polynomial(
                [c * other for c in self.coefficients],
                raw_init=(
                    self.coeff_type,
                    self.p,
                    self.field,
                    self.zero_field,
                    self.zero_field_value,
                ),
            )
        if self.coeff_type != other.coeff_type:
            raise TypeError(
                f"Cannot multiply polynomial of type {self.coeff_type} by polynomial of type {other.type}"
            )

        len_self = len(self.coefficients)
        len_other = len(other.coefficients)
        buf = [self.zero_field] * (len_self + len_other - 1)
        for i in range(len_self):
            if self.coefficients[i].value == self.zero_field_value:
                continue  # optimization for sparse polynomials
            for j in range(len_other):
                buf[i + j] += self.coefficients[i] * other.coefficients[j]

        while len(buf) > 0 and buf[-1].value == self.zero_field_value:
            buf.pop()
        if buf == []:
            return Polynomial(
                [self.zero_field],
                raw_init=(
                    self.coeff_type,
                    self.p,
                    self.field,
                    self.zero_field,
                    self.zero_field_value,
                ),
            )

        return Polynomial(
            buf,
            raw_init=(
                self.coeff_type,
                self.p,
                self.field,
                self.zero_field,
                self.zero_field_value,
            ),
        )

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
        den_deg = denominator.degree()
        if den_deg == -1:
            raise ValueError("Cannot divide by zero polynomial")
        num_deg = self.degree()
        if num_deg < den_deg:
            return (Polynomial.zero(self.p, self.coeff_type), self)

        remainder = Polynomial(
            self.coefficients[:],
            raw_init=(
                self.coeff_type,
                self.p,
                self.field,
                self.zero_field,
                self.zero_field_value,
            ),
        )
        quotient_coefficients = [self.zero_field] * (num_deg - den_deg + 1)

        denom_lead_inv = denominator[den_deg].__inv__()

        rem_deg = num_deg
        while rem_deg >= den_deg:
            shift = rem_deg - den_deg
            coefficient = remainder[rem_deg] * denom_lead_inv
            quotient_coefficients[shift] = coefficient

            subtractee = (
                Polynomial(
                    [self.zero_field] * shift + [coefficient],
                    raw_init=(
                        self.coeff_type,
                        self.p,
                        self.field,
                        self.zero_field,
                        self.zero_field_value,
                    ),
                )
                * denominator
            )
            remainder = remainder - subtractee
            rem_deg = remainder.degree()

        quotient = Polynomial(
            quotient_coefficients,
            raw_init=(
                self.coeff_type,
                self.p,
                self.field,
                self.zero_field,
                self.zero_field_value,
            ),
        )
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
            if c != self.zero_field:
                return False
        return True

    @staticmethod
    def zero(p: int, type: type[T] = PyFelt) -> "Polynomial[T]":
        if type == PyFelt:
            return Polynomial([PyFelt(0, p)])
        elif type == Fp2:
            return Polynomial([Fp2.zero(p)])
        else:
            raise ValueError(f"Unknown type {type}")

    @staticmethod
    def one(p: int, type: type[T] = PyFelt) -> "Polynomial[T]":
        if type == PyFelt:
            return Polynomial([PyFelt(1, p)])
        elif type == Fp2:
            return Polynomial([Fp2.one(p)])
        else:
            raise ValueError(f"Unknown type {type}")

    def evaluate(self, point: PyFelt | Fp2) -> PyFelt | Fp2:
        assert isinstance(
            point, self.coeff_type
        ), f"point type must match polynomial type {self.coeff_type}"
        xi = self.field.one()
        value = self.zero_field
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
        if self.coeff_type != modulo_poly.coeff_type:
            raise TypeError(
                f"Cannot pow polynomial of type {self.coeff_type} modulo a polynomial of type {modulo_poly.coeff_type}"
            )
        one = Polynomial.one(self.p, self.coeff_type)
        if exponent == 0:
            return one
        acc = one
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
        one = Polynomial.one(x.p, x.coeff_type)
        zero = Polynomial.zero(x.p, x.coeff_type)
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
        raw_init = (x.coeff_type, x.p, x.field, x.zero_field, x.zero_field_value)
        return (
            Polynomial([c * lcinv for c in old_s.coefficients], raw_init=raw_init),
            Polynomial([c * lcinv for c in old_t.coefficients], raw_init=raw_init),
            Polynomial([c * lcinv for c in old_r.coefficients], raw_init=raw_init),
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
class RationalFunction(Generic[T]):
    numerator: Polynomial[T]
    denominator: Polynomial[T]

    @property
    def field(self) -> BaseField | BaseFp2Field:
        return self.numerator.field

    @classmethod
    def zero(cls, p: int, type: type[T] = PyFelt) -> "RationalFunction[T]":
        return cls(Polynomial.zero(p, type), Polynomial.one(p, type))

    @classmethod
    def one(cls, p: int, type: type[T] = PyFelt) -> "RationalFunction[T]":
        return cls(Polynomial.one(p, type), Polynomial.one(p, type))

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

    def evaluate(self, x: PyFelt | Fp2) -> PyFelt | Fp2:
        return self.numerator.evaluate(x) / self.denominator.evaluate(x)

    def degrees_infos(self) -> dict[str, int]:
        return {
            "numerator": self.numerator.degree(),
            "denominator": self.denominator.degree(),
        }


@dataclass(slots=True)
class FunctionFelt(Generic[T]):
    # f = a(x) + yb(x)
    a: RationalFunction[T]
    b: RationalFunction[T]

    @property
    def field(self) -> BaseField | BaseFp2Field:
        return self.a.numerator.field

    @classmethod
    def zero(cls, p: int, type: type[T] = PyFelt) -> "FunctionFelt[T]":
        return cls(RationalFunction.zero(p, type), RationalFunction.zero(p, type))

    @classmethod
    def one(cls, p: int, type: type[T] = PyFelt) -> "FunctionFelt[T]":
        return cls(RationalFunction.one(p, type), RationalFunction.zero(p, type))

    def simplify(self) -> "FunctionFelt":
        return FunctionFelt(self.a.simplify(), self.b.simplify())

    def __add__(self, other: "FunctionFelt") -> "FunctionFelt":
        return FunctionFelt(self.a + other.a, self.b + other.b)

    def __mul__(self, other: PyFelt | int) -> "FunctionFelt":
        return FunctionFelt(self.a * other, self.b * other)

    def __rmul__(self, other: PyFelt | int) -> "FunctionFelt":
        return self.__mul__(other)

    def evaluate(self, x: PyFelt | Fp2, y: PyFelt | Fp2) -> PyFelt | Fp2:
        assert (
            isinstance(x, self.field.type) and x.p == self.field.p
        ), f"x type must match field {self.field.type}, got {type(x)} over {hex(x.p)}"
        assert (
            isinstance(y, self.field.type) and y.p == self.field.p
        ), f"y type must match field {self.field.type}, got {type(y)} over {hex(y.p)}"

        return self.a.evaluate(x) + y * self.b.evaluate(x)

    def degrees_infos(self) -> dict[str, dict[str, int]]:
        return {
            "a": self.a.degrees_infos(),
            "b": self.b.degrees_infos(),
        }

    def validate_degrees(self, msm_size: int, batched: bool = True) -> bool:
        degrees = self.degrees_infos()
        if batched:
            extra = 2
        else:
            extra = 0
        assert degrees["a"]["numerator"] <= msm_size + 1 + extra
        assert degrees["a"]["denominator"] <= msm_size + 2 + extra
        assert degrees["b"]["numerator"] <= msm_size + 2 + extra
        assert degrees["b"]["denominator"] <= msm_size + 5 + extra
        return True

    def print_as_sage_poly(self, var: str = "x", as_hex: bool = False) -> str:
        return f"(({self.b.numerator.print_as_sage_poly(var, as_hex)}) / ({self.b.denominator.print_as_sage_poly(var, as_hex)}) * y + ({self.a.numerator.print_as_sage_poly(var, as_hex)} / ({self.a.denominator.print_as_sage_poly(var, as_hex)})"
