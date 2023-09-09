from tools.py.field import *


class Polynomial:
    def __init__(self, coefficients):
        self.coefficients = [c for c in coefficients]

    def degree(self):
        if self.coefficients == []:
            return -1
        zero = self.coefficients[0].field.zero()
        if self.coefficients == [zero] * len(self.coefficients):
            return -1
        maxindex = 0
        for i in range(len(self.coefficients)):
            if self.coefficients[i] != zero:
                maxindex = i
        return maxindex

    def get_coeffs(self):
        return [x.value % x.field.p for x in self.coefficients]

    def __neg__(self):
        return Polynomial([-c for c in self.coefficients])

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

    def __sub__(self, other):
        return self.__add__(-other)

    def __mul__(self, other):
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
        quo, rem = Polynomial.divide(self, other)
        return quo

    def __mod__(self, other):
        quo, rem = Polynomial.divide(self, other)
        return rem

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

    def divide(numerator, denominator):
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

    def is_zero(self):
        if self.coefficients == []:
            return True
        for c in self.coefficients:
            if not c.is_zero():
                return False
        return True

    def interpolate_domain(domain, values):
        assert len(domain) == len(
            values
        ), "number of elements in domain does not match number of values -- cannot interpolate"
        assert len(domain) > 0, "cannot interpolate between zero points"
        field = domain[0].field
        x = Polynomial([field.zero(), field.one()])
        acc = Polynomial([])
        for i in range(len(domain)):
            prod = Polynomial([values[i]])
            for j in range(len(domain)):
                if j == i:
                    continue
                prod = (
                    prod
                    * (x - Polynomial([domain[j]]))
                    * Polynomial([(domain[i] - domain[j]).inverse()])
                )
            acc = acc + prod
        return acc

    def zerofier_domain(domain):
        field = domain[0].field
        x = Polynomial([field.zero(), field.one()])
        acc = Polynomial([field.one()])
        for d in domain:
            acc = acc * (x - Polynomial([d]))
        return acc

    def evaluate(self, point):
        xi = point.field.one()
        value = point.field.zero()
        for c in self.coefficients:
            value = value + c * xi
            xi = xi * point
        return value

    def evaluate_domain(self, domain):
        return [self.evaluate(d) for d in domain]

    def __xor__(self, exponent):
        if self.is_zero():
            return Polynomial([])
        if exponent == 0:
            return Polynomial([self.coefficients[0].field.one()])
        acc = Polynomial([self.coefficients[0].field.one()])
        for i in reversed(range(len(bin(exponent)[2:]))):
            acc = acc * acc
            if (1 << i) & exponent != 0:
                acc = acc * self
        return acc

    def scale(self, factor):
        return Polynomial(
            [(factor ^ i) * self.coefficients[i] for i in range(len(self.coefficients))]
        )

    def xgcd(x, y):
        one = Polynomial([x.coefficients[0].field.one()])
        zero = Polynomial([x.coefficients[0].field.zero()])
        old_r, r = (x, y)
        old_s, s = (one, zero)
        old_t, t = (zero, one)

        while not r.is_zero():
            quotient = old_r // r
            old_r, r = (r, old_r - quotient * r)
            old_s, s = (s, old_s - quotient * s)
            old_t, t = (t, old_t - quotient * t)

        lcinv = old_r.coefficients[old_r.degree()].inverse()

        # a, b, g
        return (
            Polynomial([c * lcinv for c in old_s.coefficients]),
            Polynomial([c * lcinv for c in old_t.coefficients]),
            Polynomial([c * lcinv for c in old_r.coefficients]),
        )


def test_colinearity(points):
    domain = [p[0] for p in points]
    values = [p[1] for p in points]
    polynomial = Polynomial.interpolate_domain(domain, values)
    return polynomial.degree() == 1
