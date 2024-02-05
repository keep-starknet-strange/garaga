from dataclasses import dataclass


@dataclass(slots=True)
class BaseField:
    p: int

    def __call__(self, integer):
        return FieldElement(integer % self.p, self.p)

    def zero(self):
        return FieldElement(0, self.p)

    def one(self):
        return FieldElement(1, self.p)


@dataclass(slots=True, frozen=True)
class FieldElement:
    value: int
    p: int

    def __add__(self, right):
        if isinstance(right, FieldElement):
            return FieldElement((self.value + right.value) % self.p, self.p)
        if isinstance(right, int):
            return FieldElement((self.value + right) % self.p, self.p)
        return NotImplemented

    def __neg__(self):
        return FieldElement((-self.value) % self.p, self.p)

    def __sub__(self, right):
        if isinstance(right, FieldElement):
            return FieldElement((self.value - right.value) % self.p, self.p)
        if isinstance(right, int):
            return FieldElement((self.value - right) % self.p, self.p)
        return NotImplemented

    def __mul__(self, right):
        if isinstance(right, FieldElement):
            return FieldElement((self.value * right.value) % self.p, self.p)
        if isinstance(right, int):
            return FieldElement((self.value * right) % self.p, self.p)
        return NotImplemented

    def __inv__(self):
        return FieldElement(pow(self.value, -1, self.p), self.p)

    def __truediv__(self, right):
        return self * right.__inv__()

    def __pow__(self, exponent):
        return FieldElement(pow(self.value, exponent, self.p), self.p)

    def __eq__(self, other):
        if isinstance(other, FieldElement):
            return self.value == other.value and self.p == other.p
        return False

    def __ne__(self, other):
        return not self.__eq__(other)

    def __radd__(self, left):
        return self.__add__(left)

    def __rsub__(self, left):
        return -self.__sub__(left)

    def __rmul__(self, left):
        return self.__mul__(left)

    def __rtruediv__(self, left):
        return self.__inv__().__mul__(left)

    def __rpow__(self, left):
        return FieldElement(pow(left, self.value, self.p), self.p)


@dataclass(slots=True, frozen=True)
class ModuloElement:
    """
    Represents an element within a modulo circuit with its associated offset.

    Attributes:
        elmt (BaseFieldElement): The base field element.
        offset (int): The offset within the modulo circuit where the element is stored.
    """

    elmt: FieldElement
    offset: int

    @property
    def value(self) -> int:
        return self.elmt.value


class Polynomial:
    def __init__(self, coefficients: list):
        if coefficients == []:
            self.coefficients = []
            return
        else:
            first_coeff = coefficients[0]
            if isinstance(first_coeff, FieldElement):
                self.coefficients = coefficients
            elif isinstance(first_coeff, ModuloElement):
                self.coefficients = [c.elmt for c in coefficients]
            else:
                raise ValueError(
                    f"Unsupported coefficient type {type(first_coeff)} for Polynomial initialization."
                )

    def degree(self):
        if self.coefficients == []:
            return -1
        zero = FieldElement(0, self.coefficients[0].p)
        if self.coefficients == [zero] * len(self.coefficients):
            return -1
        maxindex = 0
        for i in range(len(self.coefficients)):
            if self.coefficients[i] != zero:
                maxindex = i
        return maxindex

    def get_coeffs(self):
        coeffs = [x.value % x.p for x in self.coefficients]
        while len(coeffs) > 0 and coeffs[-1] == 0:
            coeffs.pop()
        return coeffs

    def __add__(self, other):
        if self.degree() == -1:
            return other
        elif other.degree() == -1:
            return self
        field = self.coefficients[0].field
        coeffs = [field.zero()] * max(len(self.coefficients), len(other.coefficients))
        for i in range(len(self.coefficients)):
            coeffs[i] = coeffs[i] + self.coefficients[i]
        for i in range(len(other.coefficients)):
            coeffs[i] = coeffs[i] + other.coefficients[i]
        return Polynomial(coeffs)

    def __neg__(self):
        return Polynomial([-c for c in self.coefficients])

    def __sub__(self, other):
        return self.__add__(-other)

    def __mul__(self, other):
        if isinstance(other, (FieldElement)):
            return Polynomial([c * other for c in self.coefficients])
        elif not isinstance(other, Polynomial):
            raise TypeError(
                f"Cannot multiply polynomial by type {type(other)}, must be FieldElement or Polynomial"
            )

        if self.coefficients == [] or other.coefficients == []:
            return Polynomial([])
        zero = self.coefficients[0].field.zero()
        buf = [zero] * (len(self.coefficients) + len(other.coefficients) - 1)
        for i in range(len(self.coefficients)):
            if self.coefficients[i].is_zero():
                continue  # optimization for sparse polynomials
            for j in range(len(other.coefficients)):
                buf[i + j] = buf[i + j] + self.coefficients[i] * other.coefficients[j]
        return Polynomial(buf)

    def __truediv__(self, other):
        quo, rem = Polynomial.divide(self, other)
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

    def __divmod__(numerator, denominator):
        if denominator.degree() == -1:
            return None
        if numerator.degree() < denominator.degree():
            return (Polynomial([]), numerator)
        field = denominator.coefficients[0].field
        remainder = Polynomial([n for n in numerator.coefficients])
        quotient_coefficients = [
            field.zero() for i in range(numerator.degree() - denominator.degree() + 1)
        ]
        for i in range(numerator.degree() - denominator.degree() + 1):
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

    def __str__(self):
        return "[" + ",".join(s.__str__() for s in self.coefficients) + "]"

    def leading_coefficient(self):
        return self.coefficients[self.degree()]

    def is_zero(self):
        if self.coefficients == []:
            return True
        for c in self.coefficients:
            if not c.is_zero():
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
            return Polynomial([self.coefficients[0].field.one()])
        acc = Polynomial([self.coefficients[0].field.one()])
        for i in reversed(range(len(bin(exponent)[2:]))):
            acc = acc * acc
            if (1 << i) & exponent != 0:
                acc = acc * self
        return acc
